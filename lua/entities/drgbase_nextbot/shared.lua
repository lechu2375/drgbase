ENT.Type = "nextbot"
ENT.Base = "base_nextbot"
ENT.IsDrGNextbot = true

-- Misc --
ENT.Models = {"models/player/kleiner.mdl"}
ENT.ModelScale = 1
ENT.Skins = {0}
ENT.CollisionBounds = Vector(10, 10, 72)
ENT.BloodColor = BLOOD_COLOR_RED
ENT.RagdollOnDeath = true
ENT.VPhysics = false

-- Sounds --
DrGBase.IncludeFile("sounds.lua")
ENT.OnSpawnSounds = {}
ENT.OnIdleSounds = {}
ENT.IdleSoundDelay = 2
ENT.ClientIdleSounds = false
ENT.OnDamageSounds = {}
ENT.DamageSoundDelay = 0.25
ENT.OnDeathSounds = {}
ENT.DefaultFootsteps = {
  [MAT_ANTLION] = {
    "physics/flesh/flesh_impact_hard1.wav",
    "physics/flesh/flesh_impact_hard2.wav",
    "physics/flesh/flesh_impact_hard3.wav",
    "physics/flesh/flesh_impact_hard4.wav",
    "physics/flesh/flesh_impact_hard5.wav",
    "physics/flesh/flesh_impact_hard6.wav"
  },
  [MAT_BLOODYFLESH] = {
    "physics/flesh/flesh_squishy_impact_hard1.wav",
    "physics/flesh/flesh_squishy_impact_hard2.wav",
    "physics/flesh/flesh_squishy_impact_hard3.wav",
    "physics/flesh/flesh_squishy_impact_hard4.wav"
  },
  [MAT_CONCRETE] = {
    "player/footsteps/concrete1.wav",
    "player/footsteps/concrete2.wav",
    "player/footsteps/concrete3.wav",
    "player/footsteps/concrete4.wav"
  },
  [MAT_DIRT] = {
    "player/footsteps/dirt1.wav",
    "player/footsteps/dirt2.wav",
    "player/footsteps/dirt3.wav",
    "player/footsteps/dirt4.wav"
  },
  [MAT_EGGSHELL] = {
    "physics/flesh/flesh_impact_hard1.wav",
    "physics/flesh/flesh_impact_hard2.wav",
    "physics/flesh/flesh_impact_hard3.wav",
    "physics/flesh/flesh_impact_hard4.wav",
    "physics/flesh/flesh_impact_hard5.wav",
    "physics/flesh/flesh_impact_hard6.wav"
  },
  [MAT_FLESH] = {
    "physics/flesh/flesh_impact_hard1.wav",
    "physics/flesh/flesh_impact_hard2.wav",
    "physics/flesh/flesh_impact_hard3.wav",
    "physics/flesh/flesh_impact_hard4.wav",
    "physics/flesh/flesh_impact_hard5.wav",
    "physics/flesh/flesh_impact_hard6.wav"
  },
  [MAT_GRATE] = {
    "player/footsteps/chainlink1.wav",
    "player/footsteps/chainlink2.wav",
    "player/footsteps/chainlink3.wav",
    "player/footsteps/chainlink4.wav"
  },
  [MAT_ALIENFLESH] = {
    "physics/flesh/flesh_impact_hard1.wav",
    "physics/flesh/flesh_impact_hard2.wav",
    "physics/flesh/flesh_impact_hard3.wav",
    "physics/flesh/flesh_impact_hard4.wav",
    "physics/flesh/flesh_impact_hard5.wav",
    "physics/flesh/flesh_impact_hard6.wav"
  },
  [MAT_SNOW] = {
    "player/footsteps/grass1.wav",
    "player/footsteps/grass2.wav",
    "player/footsteps/grass3.wav",
    "player/footsteps/grass4.wav"
  },
  [MAT_PLASTIC] = {
    "physics/plastic/plastic_box_impact_soft1.wav",
    "physics/plastic/plastic_box_impact_soft2.wav",
    "physics/plastic/plastic_box_impact_soft3.wav",
    "physics/plastic/plastic_box_impact_soft4.wav"
  },
  [MAT_METAL] = {
    "player/footsteps/metal1.wav",
    "player/footsteps/metal2.wav",
    "player/footsteps/metal3.wav",
    "player/footsteps/metal4.wav"
  },
  [MAT_SAND] = {
    "player/footsteps/sand1.wav",
    "player/footsteps/sand2.wav",
    "player/footsteps/sand3.wav",
    "player/footsteps/sand4.wav"
  },
  [MAT_FOLIAGE] = {
    "player/footsteps/grass1.wav",
    "player/footsteps/grass2.wav",
    "player/footsteps/grass3.wav",
    "player/footsteps/grass4.wav"
  },
  [MAT_COMPUTER] = {
    "player/footsteps/metal1.wav",
    "player/footsteps/metal2.wav",
    "player/footsteps/metal3.wav",
    "player/footsteps/metal4.wav"
  },
  [MAT_SLOSH] = {
    "player/footsteps/slosh1.wav",
    "player/footsteps/slosh2.wav",
    "player/footsteps/slosh3.wav",
    "player/footsteps/slosh4.wav"
  },
  [MAT_TILE] = {
    "player/footsteps/tile1.wav",
    "player/footsteps/tile2.wav",
    "player/footsteps/tile3.wav",
    "player/footsteps/tile4.wav"
  },
  [MAT_GRASS] = {
    "player/footsteps/grass1.wav",
    "player/footsteps/grass2.wav",
    "player/footsteps/grass3.wav",
    "player/footsteps/grass4.wav"
  },
  [MAT_VENT] = {
    "player/footsteps/duct1.wav",
    "player/footsteps/duct2.wav",
    "player/footsteps/duct3.wav",
    "player/footsteps/duct4.wav"
  },
  [MAT_WOOD] = {
    "player/footsteps/wood1.wav",
    "player/footsteps/wood2.wav",
    "player/footsteps/wood3.wav",
    "player/footsteps/wood4.wav"
  },
  [MAT_DEFAULT] = {
    "player/footsteps/concrete1.wav",
    "player/footsteps/concrete2.wav",
    "player/footsteps/concrete3.wav",
    "player/footsteps/concrete4.wav"
  },
  [MAT_GLASS] = {
    "physics/glass/glass_sheet_step1.wav",
    "physics/glass/glass_sheet_step2.wav",
    "physics/glass/glass_sheet_step3.wav",
    "physics/glass/glass_sheet_step4.wav"
  },
  [MAT_WARPSHIELD] = {
    "physics/glass/glass_sheet_step1.wav",
    "physics/glass/glass_sheet_step2.wav",
    "physics/glass/glass_sheet_step3.wav",
    "physics/glass/glass_sheet_step4.wav"
  }
}
ENT.Footsteps = {}

-- Stats --
ENT.SpawnHealth = 100
ENT.HealthRegen = 0
ENT.FallDamage = false
ENT.ShoveResistance = false
ENT.DamageMultipliers = {}

-- AI --
DrGBase.IncludeFile("ai.lua")
ENT.BehaviourTree = "BaseAI"
ENT.Omniscient = false
ENT.SpotDuration = 30
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 0
ENT.ReachEnemyRange = 150
ENT.AvoidEnemyRange = 75
ENT.FollowPlayers = false

-- Relationships --
DrGBase.IncludeFile("relationships.lua")
ENT.Factions = {}
ENT.Frightening = false
ENT.AllyDamageTolerance = 0.33
ENT.AfraidDamageTolerance = 0.33
ENT.NeutralDamageTolerance = 0.33

-- Locomotion --
DrGBase.IncludeFile("locomotion.lua")
DrGBase.IncludeFile("path.lua")
ENT.Acceleration = 400
ENT.Deceleration = 400
ENT.JumpHeight = 58
ENT.StepHeight = 20
ENT.MaxYawRate = 250
ENT.DeathDropHeight = 200
ENT.AvoidObstacles = true

-- Movements/animations --
DrGBase.IncludeFile("movements.lua")
DrGBase.IncludeFile("animations.lua")
ENT.WalkSpeed = 100
ENT.WalkAnimation = ACT_WALK
ENT.WalkAnimRate = 1
ENT.RunSpeed = 200
ENT.RunAnimation = ACT_RUN
ENT.RunAnimRate = 1
ENT.IdleAnimation = ACT_IDLE
ENT.IdleAnimRate = 1
ENT.JumpAnimation = ACT_JUMP
ENT.JumpAnimRate = 1
ENT.AnimMatchSpeed = true
ENT.AnimMatchDirection = true

-- Climbing --
ENT.ClimbLedges = false
ENT.ClimbLedgesMaxHeight = math.huge
ENT.ClimbLedgesMinHeight = 0
ENT.ClimbLadders = false
ENT.ClimbLaddersUp = true
ENT.LaddersUpDistance = 20
ENT.ClimbLaddersUpMaxHeight = math.huge
ENT.ClimbLaddersUpMinHeight = 0
ENT.ClimbLaddersDown = false
ENT.LaddersDownDistance = 20
ENT.ClimbLaddersDownMaxHeight = math.huge
ENT.ClimbLaddersDownMinHeight = 0
ENT.ClimbSpeed = 60
ENT.ClimbUpAnimation = ACT_CLIMB_UP
ENT.ClimbDownAnimation = ACT_CLIMB_DOWN
ENT.ClimbAnimRate = 1
ENT.ClimbOffset = Vector(0, 0, 0)

-- Detection --
DrGBase.IncludeFile("awareness.lua")
DrGBase.IncludeFile("detection.lua")
ENT.SightFOV = 150
ENT.SightRange = math.huge
ENT.MinLuminosity = 0
ENT.MaxLuminosity = 1
ENT.EyeBone = ""
ENT.EyeOffset = Vector(0, 0, 0)
ENT.EyeAngle = Angle(0, 0, 0)
ENT.HearingCoefficient = 1

-- Weapons --
DrGBase.IncludeFile("weapons.lua")
ENT.UseWeapons = false
ENT.Weapons = {}
ENT.WeaponAccuracy = 1
ENT.WeaponAttachment = "Anim_Attachment_RH"
ENT.DropWeaponOnDeath = false
ENT.AcceptPlayerWeapons = false

-- Possession --
DrGBase.IncludeFile("possession.lua")
ENT.PossessionEnabled = false
ENT.PossessionPrompt = true
ENT.PossessionMovement = POSSESSION_MOVE_NSEW
ENT.PossessionViews = {}
ENT.PossessionBinds = {}

-- Other modules --
DrGBase.IncludeFile("behaviours.lua")
DrGBase.IncludeFile("hooks.lua")
DrGBase.IncludeFile("meta.lua")
DrGBase.IncludeFile("misc.lua")
DrGBase.IncludeFile("projectiles.lua")

-- Init --

function ENT:Initialize()
  if SERVER then
    self:SetModel(self.Models[math.random(#self.Models)])
    self:SetModelScale(self.ModelScale)
    self:SetSkin(self.Skins[math.random(#self.Skins)])
    self:SetMaxHealth(self.SpawnHealth)
    self:SetHealth(self.SpawnHealth)
    self:SetBloodColor(self.BloodColor)
    self:SetCollisionGroup(COLLISION_GROUP_NPC)
    if self.VPhysics then
      local min, max = self:GetModelBounds()
      self:SetCollisionBounds(min, max)
      self:PhysicsInit(SOLID_VPHYSICS)
      self:SetMoveType(MOVETYPE_VPHYSICS)
      self:SetSolid(SOLID_VPHYSICS)
      local phys = self:GetPhysicsObject()
      if (phys:IsValid()) then
          phys:Wake()
      end
    else
      self:SetCollisionBounds(
        Vector(self.CollisionBounds.x, self.CollisionBounds.y, self.CollisionBounds.z),
        Vector(-self.CollisionBounds.x, -self.CollisionBounds.y, 0)
      )
    end
    self:SetUseType(SIMPLE_USE)
    self:AddFlags(FL_OBJECT + FL_CLIENT)
    self.VJ_AddEntityToSNPCAttackList = true
    self.vFireIsCharacter = true
    self._DrGBaseCorCalls = {}
  else
    self:SetIK(true)
  end
  self._DrGBaseBaseThinkDelay = 0
  self._DrGBaseCustomThinkDelay = 0
  self._DrGBasePossessionThinkDelay = 0
  self:_InitModules()
  table.insert(DrGBase._SpawnedNextbots, self)
  self:CallOnRemove("DrGBaseCallOnRemove", function(self)
    table.RemoveByValue(DrGBase._SpawnedNextbots, self)
    if SERVER then
      if self:IsPossessed() then self:Dispossess() end
    end
    for i, sound in ipairs(self._DrGBaseEmitSounds) do
      self:StopSound(sound)
    end
    for i, sound in ipairs(self._DrGBaseLoopingSounds) do
      self:StopLoopingSound(sound)
    end
  end)
  self:_BaseInitialize()
  self:CustomInitialize()
end
function ENT:_InitModules()
  if SERVER then
    self:_InitLocomotion()
  end
  self:_InitAwareness()
  self:_InitDetection()
  self:_InitAnimations()
  self:_InitMovements()
  self:_InitRelationships()
  self:_InitPossession()
  self:_InitWeapons()
  self:_InitAI()
  self:_InitMisc()
end
function ENT:_BaseInitialize() end
function ENT:CustomInitialize() end

hook.Add("Think", "velocitytest", function()
  --[[for i, npc in ipairs(ents.FindByClass("npc_*")) do
    print("===============")
    print(npc:GetVelocity())
    print(npc:GetVelocity():Length())
  end]]
end)

-- Think --

function ENT:Think()
  --if SERVER then print(#DrGBase.GetNextbots()) end
  self:_HandleAnimations()
  self:_HandleMisc()
  if SERVER then self:_HandleAI() end
  if CurTime() > self._DrGBaseBaseThinkDelay then
    local delay = self:_BaseThink() or 0
    self._DrGBaseBaseThinkDelay = CurTime() + delay
  end
  if CurTime() > self._DrGBaseCustomThinkDelay then
    local delay = self:CustomThink() or 0
    self._DrGBaseCustomThinkDelay = CurTime() + delay
  end
  if self:IsPossessed() then
    self:_HandlePossession(false)
    if CLIENT and not self:IsPossessedByLocalPlayer() then return end
    if CurTime() > self._DrGBasePossessionThinkDelay then
      local delay = self:PossessionThink() or 0
      self._DrGBasePossessionThinkDelay = CurTime() + delay
    end
  end
end
function ENT:_BaseThink() end
function ENT:CustomThink() end
function ENT:PossessionThink() end

-- Use --

function ENT:Use(activator, caller, useType, value)
  local user = IsValid(caller) and caller or activator
  if SERVER and self.FollowPlayers and user:IsPlayer() and self:IsAlly(user) then
    local ent, dist = self:GetFollowing()
    if IsValid(ent) then
      if user ~= ent then
        net.Start("DrGBaseAlreadyFollowing")
        net.WriteEntity(self)
        net.Send(user)
      else self:FollowEntity(nil, 0, true) end
    else self:FollowEntity(user, 150, true) end
  end
  self:_BaseUse(activator, caller, useType, value)
  self:CustomUse(activator, caller, useType, value)
end
function ENT:_BaseUse() end
function ENT:CustomUse() end

if SERVER then
  AddCSLuaFile()
  util.AddNetworkString("DrGBaseAlreadyFollowing")

  -- Getters/setters --

  -- Functions --

  function ENT:CallInCoroutine(callback, exec)
    table.insert(self._DrGBaseCorCalls, {
      callback = callback,
      now = CurTime(),
      nested = nested or false
    })
  end
  function ENT:YieldCoroutine(caninterrupt)
    local didStuff = false
    if self:IsDying() then
      self._DrGBaseOnDeath()
    end
    while caninterrupt and not self._DrGBaseExecCorCalls and #self._DrGBaseCorCalls > 0 do
      didStuff = true
      local cor = table.remove(self._DrGBaseCorCalls, 1)
      local oldexec = self._DrGBaseExecCorCalls
      self._DrGBaseExecCorCalls = not cor.nested
      cor.callback(self, CurTime() - cor.now)
      self._DrGBaseExecCorCalls = oldexec
    end
    coroutine.yield()
    return didStuff
  end
  function ENT:WaitCoroutine(duration, caninterrupt)
    local delay = CurTime() + duration
    local didStuff = false
    while CurTime() < delay do
      if self:YieldCoroutine(caninterrupt) then didStuff = true end
    end
    return didStuff
  end

  function ENT:GetBehaviourTree()
    return DrGBase.GetBehaviourTree(self.BehaviourTree)
  end
  function ENT:GetBT()
    return self:GetBehaviourTree()
  end

  function ENT:BehaviourTreeEvent(event, ...)
    local tree = self:GetBehaviourTree()
    if not tree then return end
    tree:Event(self, event, ...)
  end
  function ENT:BTEvent(event, ...)
    return self:BehaviourTreeEvent(event, ...)
  end

  -- Hooks --

  function ENT:NoNavmesh() end
  function ENT:OnSpawn() end
  function ENT:OnError() end
  function ENT:CustomBehaviour() end

  -- Handlers --

  function ENT:BehaveStart()
    self.BehaveThread = coroutine.create(function()
      self:RunBehaviour()
    end)
  end

  function ENT:BehaveUpdate(interval)
  	if not self.BehaveThread then return end
  	if coroutine.status(self.BehaveThread) == "dead" then
  		self.BehaveThread = nil
  		Msg(self, " Warning: ENT:RunBehaviour() has finished executing\n")
  	else
      local ok, args = coroutine.resume(self.BehaveThread)
    	if not ok then
    		self.BehaveThread = nil
        if not self:OnError(args) then
          ErrorNoHalt(self, " Error: ", args, "\n")
        end
    	end
  	end
  end

  function ENT:RunBehaviour()
    if not self._DrGBaseSpawned then
      self._DrGBaseSpawned = true
      if #self.OnSpawnSounds > 0 then
        self:EmitSound(self.OnSpawnSounds[math.random(#self.OnSpawnSounds)])
      end
      self:OnSpawn()
    end
    while true do
      if self:IsPossessed() then
        self:_HandlePossession(true)
      elseif not self:IsAIDisabled() then
        local tree = self:GetBT()
        if tree then tree:Run(self)
        else self:CustomBehaviour() end
      end
      self:YieldCoroutine(true)
    end
  end

  -- SLVBase --

  if file.Exists("autorun/slvbase", "LUA") then
    function ENT:PercentageFrozen() return 0 end
  end

else

  -- Follow --

  net.Receive("DrGBaseAlreadyFollowing", function()
    local ent = net.ReadEntity()
    if not IsValid(ent) then return end
    notification.AddLegacy(ent.PrintName.." is already following someone.", NOTIFY_ERROR, 4)
    surface.PlaySound("buttons/button10.wav")
  end)

  local DisplayCollisions = CreateClientConVar("drgbase_display_collisions", "0")
  local DisplaySight = CreateClientConVar("drgbase_display_sight", "0")

  function ENT:Draw()
    self:DrawModel()
    if GetConVar("developer"):GetBool() then
      if DisplayCollisions:GetBool() then
        local bound1, bound2 = self:GetCollisionBounds()
        local center = self:GetPos() + self:OBBCenter()
        render.DrawWireframeBox(self:GetPos(), Angle(0, 0, 0), bound1, bound2, DrGBase.CLR_WHITE, false)
        render.DrawLine(center, center + self:GetVelocity(), DrGBase.CLR_ORANGE, false)
        render.DrawWireframeSphere(center, 2*self:GetScale(), 4, 4, DrGBase.CLR_ORANGE, false)
      end
      if DisplaySight:GetBool() then
         local eyepos = self:EyePos()
         render.DrawWireframeSphere(eyepos, 2*self:GetScale(), 4, 4, DrGBase.CLR_GREEN, false)
         render.DrawLine(eyepos, eyepos + self:EyeAngles():Forward()*15, DrGBase.CLR_GREEN, false)
      end
    end
    self:_BaseDraw()
    self:CustomDraw()
    if self:IsPossessedByLocalPlayer() then
      self:PossessionDraw()
    end
  end
  function ENT:_BaseDraw() end
  function ENT:CustomDraw() end
  function ENT:PossessionDraw() end

end
