-- Getters --

function ENT:Team()
  return self:GetNW2Int("DrG/Team", 0)
end

if SERVER then
  util.AddNetworkString("DrG/RelationshipChange")

  local D_HS = 5

  local REL_METATABLE = {
    __index = function()
      return { disp = D_NU, prio = 1 }
    end
  }

  local TARGET_EXCEPTIONS = {
    ["npc_bullseye"] = false,
    ["npc_grenade_frag"] = false,
    ["npc_tripmine"] = false,
    ["npc_satchel"] = false,

    ["replicator_melon"] = DrGBase.TargetRepMelons,
    ["neo_replicator_melon"] = DrGBase.TargetRepMelons,
    ["npc_antlion_grub"] = DrGBase.TargetInsects,
    ["monster_cockroach"] = DrGBase.TargetInsects,
    ["replicator_worker"] = true,
    ["replicator_queen"] = true,
    ["replicator_queen_hive"] = true
  }
  function DrGBase.IsTarget(ent)
    if not IsValid(ent) then return false end
    local class = ent:GetClass()
    if TARGET_EXCEPTIONS[class] ~= nil then
      local exception = TARGET_EXCEPTIONS[class]
      if isbool(exception) then return expection
      else return exception:GetBool() end
    else
      if ent.DrG_Target then return true end
      if ent:IsNextBot() then return true end
      if ent:IsPlayer() then return true end
      if ent:IsNPC() then return true end
      return false
    end
  end

  local function IsCachedDisp(disp)
    return disp == D_LI or disp == D_HT or disp == D_FR
  end

  local function IsValidDisp(disp)
    return IsCachedDisp(disp) or disp == D_NU
  end

  local function ToDisp(disp)
    if IsValidDisp(disp) then return disp
    else return D_ER end
  end

  -- Getters/setters --

  function ENT:SetTeam(team)
    self:SetNW2Int("DrG/Team", team)
  end

  function ENT:GetNoTarget()
    return self:IsFlagSet(FL_NOTARGET)
  end
  function ENT:SetNoTarget(noTarget)
    if noTarget then self:AddFlags(FL_NOTARGET)
    else self:RemoveFlags(FL_NOTARGET) end
  end

  function ENT:GetDefaultRelationship()
    return ToDisp(self.DefaultRelationship), 1
  end
  function ENT:SetDefaultRelationship(disp)
    self.DefaultRelationship = ToDisp(disp)
    self:UpdateRelationships()
  end

  function ENT:IsFrightening()
    return tobool(self.Frightening)
  end
  function ENT:SetFrightening(frightening)
    local old = self:IsFrightening()
    self.Frightening = tobool(frightening)
    if old == self.Frightening then return end
    for _, ent in ipairs(ents.GetAll()) do
      if not ent:IsNPC() then continue end
      self:UpdateRelationshipWith(ent)
    end
  end

  -- Entities --

  ENT.DrG_EntityRelationships = setmetatable({}, REL_METATABLE)

  function ENT:GetEntityRelationship(ent)
    local rel = self.DrG_EntityRelationships[ent]
    return rel.disp, rel.prio
  end
  function ENT:SetEntityRelationship(ent, disp, prio)
    self.DrG_EntityRelationships[ent] = { disp = ToDisp(disp), prio = prio or 1 }
    self:UpdateRelationships()
  end
  function ENT:AddEntityRelationship(ent, disp, prio)
    local _, oldPrio = self:GetEntityRelationship(ent)
    if prio >= oldPrio then
      self:SetEntityRelationship(ent, disp, prio)
    end
  end
  function ENT:ResetEntityRelationship(ent)
    self.DrG_EntityRelationships[ent] = nil
    self:UpdateRelationships()
  end

  -- Models --

  ENT.DrG_ModelRelationships = setmetatable({}, REL_METATABLE)

  function ENT:GetModelRelationship(model)
    local rel = self.DrG_ModelRelationships[model]
    return rel.disp, rel.prio
  end
  function ENT:SetModelRelationship(model, disp, prio)
    self.DrG_ModelRelationships[model] = { disp = ToDisp(disp), prio = prio or 1 }
    self:UpdateRelationships()
  end
  function ENT:AddModelRelationship(model, disp, prio)
    local _, oldPrio = self:GetModelRelationship(model)
    if prio >= oldPrio then
      self:SetModelRelationship(model, disp, prio)
    end
  end
  function ENT:ResetModelRelationship(model)
    self.DrG_ModelRelationships[model] = nil
    self:UpdateRelationships()
  end

  function ENT:GetSelfModelRelationship()
    return self:GetModelRelationship(self:GetModel())
  end
  function ENT:SetSelfModelRelationship(disp, prio)
    return self:SetModelRelationship(self:GetModel(), disp, prio)
  end
  function ENT:AddSelfModelRelationship(disp, prio)
    return self:AddModelRelationship(self:GetModel(), disp, prio)
  end
  function ENT:ResetSelfModelRelationship()
    return self:ResetModelRelationship(self:GetModel())
  end

  -- Classes --

  ENT.DrG_ClassRelationships = setmetatable({}, REL_METATABLE)

  function ENT:GetClassRelationship(class)
    local rel = self.DrG_ClassRelationships[class]
    return rel.disp, rel.prio
  end
  function ENT:SetClassRelationship(class, disp, prio)
    self.DrG_ClassRelationships[class] = { disp = ToDisp(disp), prio = prio or 1 }
    self:UpdateRelationships()
  end
  function ENT:AddClassRelationship(class, disp, prio)
    local _, oldPrio = self:GetClassRelationship(class)
    if prio >= oldPrio then
      self:SetClassRelationship(class, disp, prio)
    end
  end
  function ENT:ResetClassRelationship(class)
    self.DrG_ClassRelationships[class] = nil
    self:UpdateRelationships()
  end

  function ENT:GetSelfClassRelationship()
    return self:GetClassRelationship(self:GetClass())
  end
  function ENT:SetSelfClassRelationship(disp, prio)
    return self:SetClassRelationship(self:GetClass(), disp, prio)
  end
  function ENT:AddSelfClassRelationship(disp, prio)
    return self:AddClassRelationship(self:GetClass(), disp, prio)
  end
  function ENT:ResetSelfClassRelationship()
    return self:ResetClassRelationship(self:GetClass())
  end

  -- Factions --

  ENT.DrG_FactionRelationships = {}

  function ENT:GetFactionRelationship(faction)
    local rel = self.DrG_FactionRelationships[faction]
    if rel then return rel.disp, rel.prio
    elseif self:IsInFaction(faction) then return D_LI, 1
    else return D_NU, 1 end
  end
  function ENT:SetFactionRelationship(faction, disp, prio)
    self.DrG_FactionRelationships[faction] = { disp = ToDisp(disp), prio = prio or 1 }
    self:UpdateRelationships()
  end
  function ENT:AddFactionRelationship(faction, disp, prio)
    local _, oldPrio = self:GetFactionRelationship(faction)
    if prio >= oldPrio then
      self:SetFactionRelationship(faction, disp, prio)
    end
  end
  function ENT:ResetFactionRelationship(faction)
    self.DrG_FactionRelationships[faction] = nil
    self:UpdateRelationships()
  end

  function ENT:GetPlayersRelationship()
    return self:GetFactionRelationship("FACTION_PLAYERS")
  end
  function ENT:SetPlayersRelationship(disp, prio)
    return self:SetFactionRelationship("FACTION_PLAYERS", disp, prio)
  end
  function ENT:AddPlayersRelationship(disp, prio)
    return self:AddFactionRelationship("FACTION_PLAYERS", disp, prio)
  end
  function ENT:ResetPlayersRelationship()
    return self:ResetFactionRelationship("FACTION_PLAYERS")
  end

  function ENT:FactionIterator()
    return self:DrG_FactionIterator()
  end
  function ENT:GetFactions()
    return self:DrG_GetFactions()
  end
  function ENT:IsInFaction(faction)
    return self:DrG_IsInFaction(faction)
  end
  function ENT:JoinFaction(faction)
    return self:DrG_JoinFaction(faction)
  end
  function ENT:JoinFactions(faction)
    return self:DrG_JoinFactions(faction)
  end
  function ENT:LeaveFaction(faction)
    return self:DrG_LeaveFaction(faction)
  end
  function ENT:LeaveFactions(faction)
    return self:DrG_LeaveFactions(faction)
  end

  function ENT:OnJoinFaction(_faction) end
  function ENT:OnLeaveFaction(_faction) end

  -- Ignore --

  ENT.DrG_IgnoredEntities = {}

  local NPC_STATES_IGNORED = {
    [NPC_STATE_PLAYDEAD] = true,
    [NPC_STATE_DEAD] = true
  }
  function ENT:IsIgnored(ent)
    if ent:IsPlayer() and not ent:Alive() then return true end
    if ent:IsPlayer() and ent:DrG_IsPossessing() then return true end
    if ent:IsPlayer() and GetConVar("ai_ignoreplayers"):GetBool() then return true end
    if ent:IsPlayer() then
      if DrGBase.IgnorePlayers:GetBool() then return true end
    elseif DrGBase.IsTarget(ent) then
      if DrGBase.IgnoreNPCs:GetBool() then return true end
    elseif DrGBase.IgnoreOthers:GetBool() then return true end
    if ent:IsFlagSet(FL_NOTARGET) then return true end
    if ent.IsVJBaseSNPC and ent.VJ_NoTarget then return true end -- why the f❤ck
    if ent.CPTBase_NPC and ent.UseNotarget then return true end -- are you not using
    if ent.IV04NextBot and ent.IsNTarget then return true end -- the built-in no target
    if ent:IsNPC() and NPC_STATES_IGNORED[ent:GetNPCState()] then return true end
    if (ent:IsPlayer() or ent:IsNPC() or ent:IsNextBot()) and ent:Health() <= 0 then return true end
    if ent.IsDrGNextbot and (ent:IsDown() or ent:IsDead()) then return true end
    if self:ShouldIgnore(ent) then return true end
    return self.DrG_IgnoredEntities[ent] or false
  end
  function ENT:SetIgnored(ent, ignored)
    self.DrG_IgnoredEntities[ent] = tobool(ignored)
  end

  function ENT:ShouldIgnore(_ent) end

  -- Cache --

  ENT.DrG_Relationships = setmetatable({}, REL_METATABLE)
  ENT.DrG_RelationshipCache = { [D_LI] = {}, [D_HT] = {}, [D_FR] = {} }
  ENT.DrG_RelationshipCacheDetected = { [D_LI] = {}, [D_HT] = {}, [D_FR] = {} }

  function ENT:OnRelationshipChange(_ent, _old, _new) end

  local function SetRelationship(self, ent, disp, prio)
    if not IsValid(ent) then return end
    if not IsValidDisp(disp) then return end
    local old = self:GetRelationship(ent)
    if old ~= disp then
      self.DrG_RelationshipCache[D_LI][ent] = nil
      self.DrG_RelationshipCache[D_HT][ent] = nil
      self.DrG_RelationshipCache[D_FR][ent] = nil
      self.DrG_RelationshipCacheDetected[D_LI][ent] = nil
      self.DrG_RelationshipCacheDetected[D_HT][ent] = nil
      self.DrG_RelationshipCacheDetected[D_FR][ent] = nil
      if IsCachedDisp(disp) then
        self:ListenTo(ent, disp ~= D_LI)
        self.DrG_RelationshipCache[disp][ent] = true
      else self:ListenTo(ent, false) end
    end
    self.DrG_Relationships[ent] = {disp = disp, prio = prio}
    if old ~= disp then
      self:OnRelationshipChange(ent, old, disp)
      if ent:IsPlayer() then ent:DrG_Send("DrG/RelationshipChange", self, old, disp)
      elseif ent:IsNPC() then
        if self:IsAlly(ent) then ent:DrG_SetRelationship(self, D_LI)
        elseif self:IsAfraidOf(ent) then ent:DrG_SetRelationship(self, D_HT)
        elseif self:IsHostile(ent) then
          if self:IsFrightening() then ent:DrG_SetRelationship(self, D_FR)
          else ent:DrG_SetRelationship(self, D_HT) end
        end
      end
    end
  end

  function ENT:GetRelationship(ent, absolute)
    if not IsValid(ent) or ent == self then return D_ER, -1 end
    if not absolute and self:IsIgnored(ent) then return D_NU, 1 end
    local rel = self.DrG_Relationships[ent]
    return rel.disp, rel.prio
  end
  function ENT:IsAlly(ent, absolute)
    return self:GetRelationship(ent, absolute) == D_LI
  end
  function ENT:IsEnemy(ent, absolute)
    return self:GetRelationship(ent, absolute) == D_HT
  end
  function ENT:IsAfraidOf(ent, absolute)
    return self:GetRelationship(ent, absolute) == D_FR
  end
  function ENT:IsHostile(ent, absolute)
    local disp = self:GetRelationship(ent, absolute)
    return disp == D_HT or disp == D_FR
  end
  function ENT:IsNeutral(ent, absolute)
    return self:GetRelationship(ent, absolute) == D_NU
  end

  -- Update --

  function ENT:InitRelationships()
    if self.DrG_RelationshipsReady then return end
    self.DrG_RelationshipsReady = true
    self:UpdateRelationships()
  end

  function ENT:UpdateRelationships()
    if not self.DrG_RelationshipsReady then return end
    for _, ent in ipairs(ents.GetAll()) do
      self:UpdateRelationshipWith(ent)
    end
  end

  local DISP_PRIORITY = {
    [D_LI] = 4,
    [D_FR] = 3,
    [D_HT] = 2,
    [D_NU] = 1,
    [D_ER] = 0
  }

  function ENT:UpdateRelationshipWith(ent)
    if not self.DrG_RelationshipsReady then return D_ER, -1 end
    if not IsValid(ent) or ent == self then return D_ER, -1 end
    local rel = { disp = DrGBase.IsTarget(ent) and self:GetDefaultRelationship(ent) or D_NU, prio = 1 }
    local function CompareRelations(disp, prio)
      if prio > rel.prio or (prio == rel.prio and DISP_PRIORITY[disp] > DISP_PRIORITY[rel.disp]) then
        rel.disp = disp
        rel.prio = prio
      end
    end
    CompareRelations(self:GetEntityRelationship(ent))
    CompareRelations(self:GetModelRelationship(ent:GetModel()))
    CompareRelations(self:GetClassRelationship(ent:GetClass()))
    local disp, prio = self:OnUpdateRelationship(ent)
    if IsValidDisp(disp) then CompareRelations(disp, prio or 1) end
    for faction in ent:DrG_FactionIterator() do
      CompareRelations(self:GetFactionRelationship(faction))
    end
    SetRelationship(self, ent, rel.disp, rel.prio)
    return rel.disp, rel.prio
  end

  local CustomRelationshipDeprecation = DrGBase.Deprecation("ENT:CustomRelationship(ent)", "ENT:OnUpdateRelationship(ent)")
  function ENT:OnUpdateRelationship(ent)
    if isfunction(self.CustomRelationship) then
      CustomRelationshipDeprecation()
      return self:CustomRelationship(ent)
    end
  end

  hook.Add("OnEntityCreated", "DrG/UpdateRelationshipWithNew", function(ent)
    timer.Simple(0, function()
      if not IsValid(ent) then return end
      for nb in DrGBase.NextbotIterator() do
        nb:UpdateRelationshipWith(ent)
      end
    end)
  end)

  -- Entity iterator --

  local function EntityIterator(self, disp, detected)
    if disp == D_HS then
      return util.DrG_MergeIterators({
        self:EnemyIterator(detected),
        self:AfraidOfIterator(detected)
      })
    elseif IsCachedDisp(disp) then
      if detected then
        local cache = self:IsOmniscient() and
          self.DrG_RelationshipCache[disp] or
          self.DrG_RelationshipCacheDetected[disp]
        local entities = pairs(cache)
        local ent = nil
        return function()
          while true do
            ent = next(cache, ent)
            if not ent then return end
            if not IsValid(ent) then continue end
            if self:GetRelationship(ent) ~= disp then continue end
            return ent
          end
        end
      else
        return function(_, ent)
          while true do
            ent = next(self.DrG_RelationshipCache[disp], ent)
            if not ent then return end
            if not IsValid(ent) then continue end
            if isbool(detected) and self:HasDetected(ent) ~= detected then continue end
            if self:GetRelationship(ent) ~= disp then continue end
            return ent
          end
        end
      end
    else
      local i = 1
      local entities = ents.GetAll()
      return function()
        for j = i, #entities do
          local ent = entities[j]
          if not IsValid(ent) then continue end
          if isbool(detected) and self:HasDetected(ent) ~= detected then continue end
          if self:GetRelationship(ent) ~= disp then continue end
          i = j+1
          return ent
        end
      end
    end
  end
  function ENT:AllyIterator(detected)
    return EntityIterator(self, D_LI, detected)
  end
  function ENT:EnemyIterator(detected)
    return EntityIterator(self, D_HT, detected)
  end
  function ENT:AfraidOfIterator(detected)
    return EntityIterator(self, D_FR, detected)
  end
  function ENT:HostileIterator(detected)
    return EntityIterator(self, D_HS, detected)
  end
  function ENT:NeutralIterator(detected)
    return EntityIterator(self, D_NU, detected)
  end

  -- Get entities --

  local function GetEntities(self, disp, detected)
    local entities = {}
    for ent in EntityIterator(self, disp, detected) do
      table.insert(entities, ent)
    end
    return entities
  end
  function ENT:GetAllies(detected)
    return GetEntities(self, D_LI, detected)
  end
  function ENT:GetEnemies(detected)
    return GetEntities(self, D_HT, detected)
  end
  function ENT:GetAfraidOf(detected)
    return GetEntities(self, D_FR, detected)
  end
  function ENT:GetHostiles(detected)
    return GetEntities(self, D_HS, detected)
  end
  function ENT:GetNeutrals(detected)
    return GetEntities(self, D_NU, detected)
  end

  -- Get closest entity --

  local function GetClosestEntity(self, disp, detected)
    local closest = NULL
    for ent in EntityIterator(self, disp, detected) do
      if not IsValid(closest) or
      self:GetRangeSquaredTo(ent) < self:GetRangeSquaredTo(closest) then
        closest = ent
      end
    end
    return closest
  end
  function ENT:GetClosestAlly(detected)
    return GetClosestEntity(self, D_LI, detected)
  end
  function ENT:GetClosestEnemy(detected)
    return GetClosestEntity(self, D_HT, detected)
  end
  function ENT:GetClosestAfraidOf(detected)
    return GetClosestEntity(self, D_FR, detected)
  end
  function ENT:GetClosestHostile(detected)
    return GetClosestEntity(self, D_HS, detected)
  end
  function ENT:GetClosestNeutral(detected)
    return GetClosestEntity(self, D_NU, detected)
  end

  -- Support for NPC functions --

  function ENT:Disposition(ent)
    local disp = self:GetRelationship(ent)
    return disp
  end

  function ENT:AddRelationship(str)
    local split = string.Explode("[%s]+", str, true)
    if #split ~= 3 then return end
    local class = split[1]
    local relationship = split[2]
    if relationship == "D_ER" then relationship = D_ER
    elseif relationship == "D_HT" then relationship = D_HT
    elseif relationship == "D_FR" then relationship = D_FR
    elseif relationship == "D_LI" then relationship = D_LI
    elseif relationship == "D_NU" then relationship = D_NU
    else return end
    local val = tonumber(split[3])
    if val ~= val then return end
    self:AddClassRelationship(class, relationship, val)
  end

else

  function ENT:OnRelationshipChange(_ent, _old, _new) end
  function ENT:OnJoinFaction(_faction) end
  function ENT:OnLeaveFaction(_faction) end

  net.DrG_DelayedReceive("DrG/RelationshipChange", function(nb, old, new)
    if not IsValid(nb) then return end
    nb.DrG_LocalPlayerDisp = new
    nb:OnRelationshipChange(LocalPlayer(), old, new)
  end)
  function ENT:GetRelationship(ent)
    if ent ~= LocalPlayer() then return D_ER, 1 end
    return self.DrG_LocalPlayerDisp or D_NU, 1
  end
  function ENT:IsAlly(ent)
    return self:GetRelationship(ent) == D_LI
  end
  function ENT:IsEnemy(ent)
    return self:GetRelationship(ent) == D_HT
  end
  function ENT:IsAfraidOf(ent)
    return self:GetRelationship(ent) == D_FR
  end
  function ENT:IsNeutral(ent)
    return self:GetRelationship(ent) == D_NU
  end
  function ENT:IsHostile(ent)
    return self:IsEnemy(ent) or self:IsAfraidOf(ent)
  end

  function ENT:FactionIterator()
    return self:DrG_FactionIterator()
  end
  function ENT:GetFactions()
    return self:DrG_GetFactions()
  end
  function ENT:IsInFaction(faction)
    return self:DrG_IsInFaction(faction)
  end

end