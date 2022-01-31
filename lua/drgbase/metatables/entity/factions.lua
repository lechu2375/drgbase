local entMETA = FindMetaTable("Entity")

local DEFAULT_FACTIONS = {
  ["player"] = "FACTION_PLAYERS",
  ["npc_crow"] = "FACTION_ANIMALS",
  ["npc_monk"] = "FACTION_REBELS",
  ["npc_pigeon"] = "FACTION_ANIMALS",
  ["npc_seagull"] = "FACTION_ANIMALS",
  ["npc_combine_camera"] = "FACTION_COMBINE",
  ["npc_turret_ceiling"] = "FACTION_COMBINE",
  ["npc_cscanner"] = "FACTION_COMBINE",
  ["npc_combinedropship"] = "FACTION_COMBINE",
  ["npc_combinegunship"] = "FACTION_COMBINE",
  ["npc_combine_s"] = "FACTION_COMBINE",
  ["npc_hunter"] = "FACTION_COMBINE",
  ["npc_helicopter"] = "FACTION_COMBINE",
  ["npc_manhack"] = "FACTION_COMBINE",
  ["npc_metropolice"] = "FACTION_COMBINE",
  ["npc_rollermine"] = "FACTION_COMBINE",
  ["npc_clawscanner"] = "FACTION_COMBINE",
  ["npc_stalker"] = "FACTION_COMBINE",
  ["npc_strider"] = "FACTION_COMBINE",
  ["npc_turret_floor"] = "FACTION_COMBINE",
  ["npc_alyx"] = "FACTION_REBELS",
  ["npc_barney"] = "FACTION_REBELS",
  ["npc_citizen"] = "FACTION_REBELS",
  ["npc_dog"] = "FACTION_REBELS",
  ["npc_magnusson"] = "FACTION_REBELS",
  ["npc_kleiner"] = "FACTION_REBELS",
  ["npc_mossman"] = "FACTION_REBELS",
  ["npc_eli"] = "FACTION_REBELS",
  ["npc_fisherman"] = "FACTION_REBELS",
  ["npc_gman"] = "FACTION_GMAN",
  ["npc_odessa"] = "FACTION_REBELS",
  ["npc_vortigaunt"] = "FACTION_REBELS",
  ["npc_breen"] = "FACTION_COMBINE",
  ["npc_antlion"] = "FACTION_ANTLIONS",
  ["npc_antlion_grub"] = "FACTION_ANTLIONS",
  ["npc_antlionguard"] = "FACTION_ANTLIONS",
  ["npc_antlionguardian"] = "FACTION_ANTLIONS",
  ["npc_antlion_worker"] = "FACTION_ANTLIONS",
  ["npc_barnacle"] = "FACTION_BARNACLES",
  ["npc_headcrab_fast"] = "FACTION_ZOMBIES",
  ["npc_fastzombie"] = "FACTION_ZOMBIES",
  ["npc_fastzombie_torso"] = "FACTION_ZOMBIES",
  ["npc_headcrab"] = "FACTION_ZOMBIES",
  ["npc_headcrab_black"] = "FACTION_ZOMBIES",
  ["npc_poisonzombie"] = "FACTION_ZOMBIES",
  ["npc_zombie"] = "FACTION_ZOMBIES",
  ["npc_zombie_torso"] = "FACTION_ZOMBIES",
  ["npc_zombine"] = "FACTION_ZOMBIES",
  ["monster_alien_grunt"] = "FACTION_XEN_ARMY",
  ["monster_alien_slave"] = "FACTION_XEN_ARMY",
  ["monster_human_assassin"] = "FACTION_HECU",
  ["monster_babycrab"] = "FACTION_ZOMBIES",
  ["monster_bullchicken"] = "FACTION_XEN_WILDLIFE",
  ["monster_cockroach"] = "FACTION_ANIMALS",
  ["monster_alien_controller"] = "FACTION_XEN_ARMY",
  ["monster_gargantua"] = "FACTION_XEN_ARMY",
  ["monster_bigmomma"] = "FACTION_ZOMBIES",
  ["monster_human_grunt"] = "FACTION_HECU",
  ["monster_headcrab"] = "FACTION_ZOMBIES",
  ["monster_houndeye"] = "FACTION_XEN_WILDLIFE",
  ["monster_nihilanth"] = "FACTION_XEN_ARMY",
  ["monster_scientist"] = "FACTION_REBELS",
  ["monster_barney"] = "FACTION_REBELS",
  ["monster_snark"] = "FACTION_XEN_WILDLIFE",
  ["monster_tentacle"] = "FACTION_XEN_WILDLIFE",
  ["monster_zombie"] = "FACTION_ZOMBIES",
  ["npc_apc_dropship"] = "FACTION_COMBINE",
  ["npc_elite_overwatch_dropship"] = "FACTION_COMBINE",
  ["npc_civil_protection_tier1_dropship"] = "FACTION_COMBINE",
  ["npc_civil_protection_tier2_dropship"] = "FACTION_COMBINE",
  ["npc_shotgunner_dropship"] = "FACTION_COMBINE",
  ["npc_overwatch_squad_tier1_dropship"] = "FACTION_COMBINE",
  ["npc_overwatch_squad_tier2_dropship"] = "FACTION_COMBINE",
  ["npc_overwatch_squad_tier3_dropship"] = "FACTION_COMBINE",
  ["npc_random_combine_dropship"] = "FACTION_COMBINE",
  ["npc_strider_dropship"] = "FACTION_COMBINE"
}

function DrGBase.GetDefaultFaction(class)
  return DEFAULT_FACTIONS[class]
end

function entMETA:DrG_GetFactions()
  local factions = {}
  for faction in self:DrG_FactionIterator() do
    table.insert(factions, faction)
  end
  return factions
end

if SERVER then
  util.AddNetworkString("DrG/JoinFaction")
  util.AddNetworkString("DrG/LeaveFaction")

  function entMETA:DrG_InitFactions()
    if not self.DrG_Factions then
      self.DrG_Factions = {}
      local factions
      if self.IsDrGNextbot then factions = self.Factions
      elseif self.IsVJBaseSNPC then factions = self.VJ_NPC_Class
      elseif self.CPTBase_NPC or self.IV04NextBot then factions = { self.Faction }
      else factions = { DEFAULT_FACTIONS[self:GetClass()] } end
      for _, faction in ipairs(factions) do
        self:DrG_JoinFaction(faction)
      end
    end
  end

  function entMETA:DrG_FactionIterator()
    self:DrG_InitFactions()
    return pairs(self.DrG_Factions)
  end

  function entMETA:DrG_IsInFaction(faction)
    if not isstring(faction) then return false end
    self:DrG_InitFactions()
    return self.DrG_Factions[faction] or false
  end

  function entMETA:DrG_JoinFaction(faction)
    if not isstring(faction) then return end
    self:DrG_InitFactions()
    if not self:DrG_IsInFaction(faction) then
      self.DrG_Factions[faction] = true
      for _, nb in DrGBase.NextbotIterator() do
        nb:UpdateRelationshipWith(self)
      end
      if self.IsDrGNextbot then
        self:UpdateRelationships()
        self:OnJoinFaction(faction)
      end
      hook.Run("DrG/JoinFaction", self, faction)
      net.DrG_Broadcast("DrG/JoinFaction", self, faction)
    end
  end

  function entMETA:DrG_JoinFactions(factions)
    for _, faction in ipairs(factions) do
      self:DrG_JoinFaction(faction)
    end
  end

  function entMETA:DrG_LeaveFaction(faction)
    if not isstring(faction) then return end
    self:DrG_InitFactions()
    if self:DrG_IsInFaction(faction) then
      self.DrG_Factions[faction] = nil
      for nb in DrGBase.NextbotIterator() do
        nb:UpdateRelationshipWith(self)
      end
      if self.IsDrGNextbot then
        self:UpdateRelationships()
        self:OnLeaveFaction(faction)
      end
      hook.Run("DrG/LeaveFaction", self, faction)
      net.DrG_Broadcast("DrG/LeaveFaction", self, faction)
    end
  end

  function entMETA:DrG_LeaveFactions(factions)
    for _, faction in ipairs(factions) do
      self:DrG_LeaveFaction(faction)
    end
  end

else

  function entMETA:DrG_FactionIterator()
    self.DrG_Factions = self.DrG_Factions or {}
    return pairs(self.DrG_Factions)
  end

  function entMETA:DrG_IsInFaction(faction)
    self.DrG_Factions = self.DrG_Factions or {}
    return self.DrG_Factions[faction] or false
  end

  net.DrG_DelayedReceive("DrG/JoinFaction", function(ent, faction)
    if not IsValid(ent) then return end
    ent.DrG_Factions = ent.DrG_Factions or {}
    ent.DrG_Factions[faction] = true
    hook.Run("DrG/JoinFaction", ent, faction)
    if ent.IsDrGNextbot then
      ent:OnJoinFaction(faction)
    end
  end)

  net.DrG_DelayedReceive("DrG/LeaveFaction", function(ent, faction)
    if not IsValid(ent) then return end
    ent.DrG_Factions = ent.DrG_Factions or {}
    ent.DrG_Factions[faction] = nil
    hook.Run("DrG/LeaveFaction", ent, faction)
    if ent.IsDrGNextbot then
      ent:OnLeaveFaction(faction)
    end
  end)

end