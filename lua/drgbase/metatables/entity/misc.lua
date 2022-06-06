local entMETA = FindMetaTable("Entity")

-- Misc --

function entMETA:DrG_SearchBone(searchBone)
  local lookup = self:LookupBone(searchBone)
  if lookup then return lookup end
  for boneId = 0, (self:GetBoneCount()-1) do
    local boneName = self:GetBoneName(boneId)
    if not boneName then return end
    if boneName == "__INVALIDBONE__" then continue end
    if string.find(string.lower(boneName), string.lower(searchBone)) then
      return boneId
    end
  end
  return -1
end

function entMETA:DrG_GetPlayerColor()
  return isfunction(self.GetPlayerColor)
    and self:GetPlayerColor():ToColor()
    or nil
end

function entMETA:DrG_SetPlayerColor(color)
  local vec = color:ToVector()
  if self:IsPlayer() then return self:SetPlayerColor(vec) end
  function self.GetPlayerColor() return vec end
  if SERVER then
    net.Start("DrG/SetPlayerColor")
    net.WriteEntity(self)
    net.WriteColor(color)
    net.Broadcast()
  end
end

-- Traces --

function entMETA:DrG_TraceLine(data, arg2)
  if isvector(data) then
    if not istable(arg2) then arg = {} end
    arg2.direction = data
    return self:DrG_TraceLine(arg2)
  else
    if not istable(data) then data = {} end
    if not isvector(data.start) then data.start = self:GetPos() end
    data.collisiongroup = data.collisiongroup or self:GetCollisionGroup()
    if not data.mask and SERVER and self:IsNextBot() then data.mask = self:GetSolidMask() end
    if not data.filter then
      if self.IsDrGNextbot then
        data.filter = {self, self:GetWeapon(), self:GetPossessor()}
      else data.filter = self end
    end
    return util.DrG_TraceLine(data)
  end
end
function entMETA:DrG_TraceHull(data, arg2)
  if isvector(data) then
    if not istable(arg2) then arg = {} end
    arg2.direction = data
    return self:DrG_TraceHull(arg2)
  else
    if not istable(data) then data = {} end
    if not isvector(data.start) then data.start = self:GetPos() end
    data.collisiongroup = data.collisiongroup or self:GetCollisionGroup()
    if not data.mask and SERVER and self:IsNextBot() then data.mask = self:GetSolidMask() end
    if not data.filter then
      if self.IsDrGNextbot then
        data.filter = {self, self:GetWeapon(), self:GetPossessor()}
      else data.filter = self end
    end
    local mins, maxs = self:GetCollisionBounds()
    data.maxs = data.maxs or maxs
    data.mins = data.mins or mins
    if self:IsNextBot() and data.step then
      data.mins.z = self.loco:GetStepHeight()
    end
    return util.DrG_TraceHull(data)
  end
end
function entMETA:DrG_TraceLineRadial(distance, precision, data)
  local traces = {}
  --[[for i = 1, precision do
    local normal = self:GetForward()*distance
    normal:Rotate(Angle(0, i*(360/precision), 0))
    table.insert(traces, self:DrG_TraceLine(normal, data))
  end
  table.sort(traces, function(tr1, tr2)
    return self:GetRangeSquaredTo(tr1.HitPos) < self:GetRangeSquaredTo(tr2.HitPos)
  end)]]
  return traces
end
function entMETA:DrG_TraceHullRadial(distance, precision, data)
  local traces = {}
  --[[for i = 1, precision do
    local normal = self:GetForward()*distance
    normal:Rotate(Angle(0, i*(360/precision), 0))
    table.insert(traces, self:DrG_TraceHull(normal, data))
  end
  table.sort(traces, function(tr1, tr2)
    return self:GetRangeSquaredTo(tr1.HitPos) < self:GetRangeSquaredTo(tr2.HitPos)
  end)]]
  return traces
end

-- Timers --

function entMETA:DrG_Timer(duration, callback, ...)
  timer.DrG_Simple(duration, function(...)
    if IsValid(self) then callback(self, ...) end
  end, ...)
end
function entMETA:DrG_LoopTimer(delay, callback, ...)
  timer.DrG_Loop(delay, function(...)
    if not IsValid(self) then return false end
    return callback(self, ...)
  end, ...)
end

if SERVER then
  util.AddNetworkString("DrG/SetPlayerColor")

  -- Misc --

  function entMETA:DrG_RandomPos(min, max)
    if not isnumber(min) then min = 1500 end
    if isnumber(max) then
      local dir = Vector(math.random(min, max), 0, 0)
      dir:Rotate(Angle(0, math.random(0, 359), 0))
      local pos = self:GetPos()+dir
      if navmesh.IsLoaded() then
        local area = navmesh.GetNearestNavArea(pos)
        if IsValid(area) then
          return self:DrG_TraceHull({
            start = area:GetCenter(),
            endpos = area:GetClosestPointOnArea(pos),
            collisiongroup = COLLISION_GROUP_WORLD,
            step = true
          }).HitPos
        end
      end
      if util.IsInWorld(pos) then
        return self:DrG_TraceHull({
          start = pos, direction = Vector(0, 0, -10000),
          collisiongroup = COLLISION_GROUP_WORLD
        }).HitPos
      else return self:DrG_RandomPos(min, max) end
    else return self:DrG_RandomPos(min, min) end
  end

  function entMETA:DrG_Dissolve(type)
    if self:IsFlagSet(FL_DISSOLVING) then return true end
    local dissolver = ents.Create("env_entity_dissolver")
    if not IsValid(dissolver) then return false end
    if self:GetName() == "" then
      self:SetName("ent_"..self:GetClass().."_"..self:GetCreationID().."_dissolved")
    end
    dissolver:SetKeyValue("dissolvetype", tostring(type or 0))
    dissolver:Fire("dissolve", self:GetName())
    dissolver:Remove()
    return true
  end

  function entMETA:DrG_DeathNotice(attacker, inflictor)
    if self:IsPlayer() then
      hook.Run("PlayerDeath", self, inflictor, attacker)
    else hook.Run("OnNPCKilled", self, attacker, inflictor) end
  end

  function entMETA:DrG_CreateRagdoll(dmg)
    if not util.IsValidRagdoll(self:GetModel()) then return NULL end
    local ragdoll = ents.Create("prop_ragdoll")
    if IsValid(ragdoll) then
      ragdoll:SetPos(self:GetPos())
      ragdoll:SetAngles(self:GetAngles())
      ragdoll:SetModel(self:GetModel())
      ragdoll:SetSkin(self:GetSkin())
      ragdoll:SetColor(self:GetColor())
      local playerColor = self:DrG_GetPlayerColor()
      if playerColor then
        ragdoll:DrG_SetPlayerColor(playerColor)
      end
      ragdoll:SetModelScale(self:GetModelScale())
      ragdoll:SetBloodColor(self:GetBloodColor())
      for i = 1, #self:GetBodyGroups() do
        ragdoll:SetBodygroup(i-1, self:GetBodygroup(i-1))
      end
      ragdoll:Spawn()
      for i = 0, (ragdoll:GetPhysicsObjectCount()-1) do
        local bone = ragdoll:GetPhysicsObjectNum(i)
        if not IsValid(bone) then continue end
        local pos, angles = self:GetBonePosition(ragdoll:TranslatePhysBoneToBone(i))
        bone:SetPos(pos)
        bone:SetAngles(angles)
      end
      if dmg then
        local phys = ragdoll:GetPhysicsObject()
        phys:SetVelocity(self:GetVelocity())
        local force = dmg:GetDamageForce()
        local position = dmg:GetDamagePosition()
        if IsValid(phys) and isvector(force) and isvector(position) then
          phys:ApplyForceOffset(force, position)
        end
        if dmg:IsDamageType(DMG_DISSOLVE) then ragdoll:DrG_Dissolve()
        elseif dmg:IsDamageType(DMG_BURN) then ragdoll:Ignite(10) end
        local attacker = dmg:GetAttacker()
        if IsValid(attacker) and attacker.IsDrGNextbot then
          attacker:DetectEntity(ragdoll)
        end
      end
      ragdoll.EntityClass = self:GetClass()
      ragdoll:SetOwner(self)
      return ragdoll
    else return NULL end
  end

  function entMETA:DrG_BecomeRagdoll(dmg)
    if self:IsPlayer() then
      if not self:Alive() then return NULL
      else self:KillSilent() end
    else self:Remove() end
    if not self:IsFlagSet(FL_TRANSRAGDOLL) and
    not (dmg and dmg:IsDamageType(DMG_REMOVENORAGDOLL)) then
      self:AddFlags(FL_TRANSRAGDOLL)
      local ragdoll = self:DrG_CreateRagdoll(dmg)
      if IsValid(ragdoll) and not self:IsPlayer() then
        undo.ReplaceEntity(self, ragdoll)
        cleanup.ReplaceEntity(self, ragdoll)
      end
      if self.IsDrGNextbot then
        if not dmg then dmg = DamageInfo() end
        self.DrG_OnRagdollRes = self:OnRagdoll(ragdoll, dmg)
      end
      return ragdoll
    else return NULL end
  end

  function entMETA:DrG_RagdollDeath(dmg)
    if dmg then self:DrG_DeathNotice(dmg:GetAttacker(), dmg:GetInflictor()) end
    return self:DrG_BecomeRagdoll(dmg)
  end

  function entMETA:DrG_AimAt(target, speed, feet)
    local phys = self:GetPhysicsObject()
    if not IsValid(phys) then return end
    local dir, info = phys:DrG_AimAt(target, speed, feet)
    if dir:IsZero() then
      local owner = self:GetOwner()
      if IsValid(owner) then
        return self:DrG_AimAt(self:GetPos()+owner:GetForward()*speed, speed)
      else return self:DrG_AimAt(self:GetPos()+self:GetForward()*speed, speed) end
    else return dir, info end
  end

  function entMETA:DrG_ThrowAt(target, options)
    local phys = self:GetPhysicsObject()
    if not IsValid(phys) then return end
    local dir, info = phys:DrG_ThrowAt(target, options)
    if dir:IsZero() then
      local speed = options.magnitude or 1000
      local owner = self:GetOwner()
      if IsValid(owner) then
        return self:DrG_ThrowAt(self:GetPos()+owner:GetForward()*speed, options)
      else return self:DrG_ThrowAt(self:GetPos()+self:GetForward()*speed, options) end
    else return dir, info end
  end

  function entMETA:DrG_SafeSetPos(pos)
    if self:DrG_TraceHull({
      start = pos, endpos = pos
    }).Hit then return false end
    self:SetPos(pos)
    return true
  end

  function entMETA:DrG_GetDisposition(ent)
    if not IsValid(ent) then return D_ER
    elseif self == ent then return D_NU
    elseif self:IsNPC() or self.IsDrGNextbot then
      return self:Disposition(ent)
    elseif self.IV04NextBot then
      local disp = self:CheckRelationships(ent)
      if disp == "friend" then return D_LI
      elseif disp == "foe" then return D_HT
      else return D_NU end
    elseif self:IsPlayer() then
      if not ent:IsPlayer() then
        return ent:Disposition(self)
      else
        local myTeam = self:Team()
        local entTeam = ent:Team()
        if myTeam == TEAM_CONNECTING or entTeam == TEAM_CONNECTING
        or myTeam == TEAM_UNASSIGNED or entTeam == TEAM_UNASSIGNED
        or myTeam == TEAM_SPECTATOR or entTeam == TEAM_SPECTATOR then return D_NU
        elseif myTeam == entTeam then return D_LI
        else return D_HT end
      end
    end
    return D_NU
  end

  -- Effects --

  function entMETA:DrG_ParticleEffect(effect, ...)
    local root = {parent = self}
    local args, n = table.DrG_Pack(...)
    if n > 0 then
      local data = root
      for i = 1, n do
        local arg = args[i]
        if i == 1 and isstring(arg) then
          root.attachment = arg
        elseif isentity(arg) and IsValid(arg) then
          data.cpoints = {{parent = arg}}
          if isstring(args[i+1]) then
            data.cpoints[1].attachment = args[i+1]
          end
          data = data.cpoints[1]
        elseif isvector(arg) then
          data.cpoints = {{pos = arg}}
          data = data.cpoints[1]
        else continue end
      end
      if data ~= root then
        data.active = false
      end
    end
    return DrGBase.ParticleEffect(effect, root)
  end

  function entMETA:DrG_DynamicLight(color, radius, brightness, style, attachment)
    if color == nil then color = Color(255, 255, 255) end
    if not isnumber(radius) then radius = 1000 end
    radius = math.Clamp(radius, 0, math.huge)
    if not isnumber(brightness) then brightness = 1 end
    brightness = math.Clamp(brightness, 0, math.huge)
    local light = ents.Create("light_dynamic")
  	light:SetKeyValue("brightness", tostring(brightness))
  	light:SetKeyValue("distance", tostring(radius))
    if isstring(style) then
      light:SetKeyValue("style", tostring(style))
    end
    light:Fire("Color", tostring(color.r).." "..tostring(color.g).." "..tostring(color.b))
  	light:SetLocalPos(self:GetPos())
  	light:SetParent(self)
    if isstring(attachment) then
      light:Fire("setparentattachment", attachment)
    end
  	light:Spawn()
  	light:Activate()
  	light:Fire("TurnOn", "", 0)
  	self:DeleteOnRemove(light)
    return light
  end

else

  -- Misc --

  net.Receive("DrG/SetPlayerColor", function(ent, color)
    local ent = net.ReadEntity()
    local color = net.ReadColor()
    if IsValid(ent) then
      ent:DrG_SetPlayerColor(color)
    end
  end)

  -- Effects --

  function entMETA:DrG_DynamicLight(color, radius, brightness, style, attachment)
    if color == nil then color = Color(255, 255, 255) end
    if not isnumber(radius) then radius = 1000 end
    radius = math.Clamp(radius, 0, math.huge)
    if not isnumber(brightness) then brightness = 1 end
    brightness = math.Clamp(brightness, 0, math.huge)
    local light = DynamicLight(self:EntIndex())
    light.r = color.r
    light.g = color.g
    light.b = color.b
    light.size = radius
    light.brightness = brightness
    light.style = style
    light.dieTime = CurTime() + 1
    light.decay = 100000
    if attachment then
      if isstring(attachment) then
        attachment = self:LookupAttachment(attachment)
      end
      if isnumber(attachment) and attachment > 0 then
        light.pos = self:GetAttachment(attachment).Pos
      else light.pos = self:GetPos() end
    else light.pos = self:GetPos() end
    return light
  end

end