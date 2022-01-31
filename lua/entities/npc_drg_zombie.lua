if not DrGBase then return end -- return if DrGBase isn't installed
ENT.Base = "drgbase_nextbot" -- DO NOT TOUCH (obviously)

-- Misc --
ENT.PrintName = "Zombie"
ENT.Category = "DrGBase"
ENT.Models = {"models/Zombie/Classic.mdl"}
ENT.BloodColor = BLOOD_COLOR_GREEN

-- Sounds --
ENT.OnDamageSounds = {"Zombie.Pain"}
ENT.OnDeathSounds = {"Zombie.Die"}

-- Stats --
ENT.SpawnHealth = 50

-- AI --
ENT.RangeAttackRange = 0
ENT.MeleeAttackRange = 50
ENT.ReachEnemyRange = 50
ENT.AvoidEnemyRange = 0

-- Relationships --
ENT.Factions = {"FACTION_ZOMBIES"}

-- Movements/animations --
ENT.UseWalkframes = true
ENT.RunAnimation = ACT_WALK

-- Detection --
ENT.EyeBone = "ValveBiped.Bip01_Spine4"
ENT.EyeOffset = Vector(7.5, 0, 5)

-- Possession --
ENT.PossessionEnabled = true
ENT.PossessionMove = POSSESSION_MOVE_8DIR
ENT.PossessionViews = {
  {auto = true},
  {
    offset = Vector(7.5, 0, 0),
    distance = 0,
    eyepos = true
  }
}
if SERVER then

  -- Init/Think --

  function ENT:Initialize()
    self:SetDefaultRelationship(D_HT)
    self:SetBodygroup(1, 1)
  end

  -- AI --

  function ENT:DoMeleeAttack(enemy)
    self:EmitSound("Zombie.Attack")
    self:PlayActivityAndMove(ACT_MELEE_ATTACK1, self.FaceTowardsEnemy)
  end

  -- Possession --

  function ENT:DoPossessionBinds(binds)
    if binds:KeyDown(IN_ATTACK) then
      self:EmitSound("Zombie.Attack")
      self:PlayActivityAndMove(ACT_MELEE_ATTACK1, 1, self.PossessionFaceForward)
    end
  end

  -- Damage --

  function ENT:DoDeath(_, hitgroup)
    if hitgroup ~= HITGROUP_HEAD then
      self:SetBodygroup(1, 0)
      local headcrab = ents.Create("npc_drg_headcrab")
      if not IsValid(headcrab) then return end
      headcrab:SetPos(self:EyePos())
      headcrab:SetAngles(self:GetAngles())
      headcrab:Spawn()
      if IsValid(self:GetCreator()) then
        self:GetCreator():DrG_AddUndo(headcrab, "NPC", "Undone Headcrab")
      end
    end
  end

  -- Animations/Sounds --

  function ENT:OnNewEnemy()
    self:EmitSound("Zombie.Alert")
  end

  function ENT:OnAnimEvent()
    if self:IsAttacking() and self:GetCycle() > 0.3 then
      local hit = self:MeleeAttack({
        damage = 10, type = DMG_SLASH,
        force = Vector(100, 0, 0),
        viewpunch = Angle(10, 0, 0),
      })
      if #hit > 0 then
        self:EmitSound("Zombie.AttackHit")
      else self:EmitSound("Zombie.AttackMiss") end
    elseif math.random(2) == 1 then
      self:EmitSound("Zombie.FootstepLeft")
    else self:EmitSound("Zombie.FootstepRight") end
  end

end

-- DO NOT TOUCH --
AddCSLuaFile()
DrGBase.AddNextbot(ENT)
