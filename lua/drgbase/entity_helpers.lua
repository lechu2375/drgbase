if not istable(ENT) then return end

-- Timers --

function ENT:Timer(...)
  return self:DrG_Timer(...)
end
function ENT:LoopTimer(...)
  return self:DrG_LoopTimer(...)
end

-- Traces --

function ENT:TraceLine(...)
  return self:DrG_TraceLine(...)
end
function ENT:TraceHull(...)
  return self:DrG_TraceHull(...)
end
function ENT:TraceLineRadial(...)
  return self:DrG_TraceLineRadial(...)
end
function ENT:TraceHullRadial(...)
  return self:DrG_TraceHullRadial(...)
end

-- Misc --

function ENT:ScreenShake(...)
  return util.ScreenShake(self:GetPos(), ...)
end

function ENT:GetCooldown(name)
  local delay = self:GetNW2Float("DrG/Cooldowns/"..name, false)
  if delay ~= false then return math.max(0, delay - CurTime())
  else return 0 end
end

if SERVER then

  -- Misc --

  function ENT:RandomPos(min, max)
    return self:DrG_RandomPos(min, max)
  end

  function ENT:SetCooldown(name, delay)
    self:SetNW2Float("DrG/Cooldowns/"..name, CurTime() + delay)
  end

  function ENT:Cooldown(name, delay)
    if self:GetCooldown(name) == 0 then
      self:SetCooldown(name, delay)
      return true
    else return false end
  end

  function ENT:PushEntity(ent, force)
    if istable(ent) then
      local vecs = {}
      for _, en in ipairs(ent) do
        if IsValid(en) then
          vecs[en:EntIndex()] = self:PushEntity(en, force)
        end
      end
      return vecs
    elseif isentity(ent) and IsValid(ent) then
      local direction = self:GetPos():DrG_Direction(ent:GetPos())
      local forward = direction
      forward.z = 0
      forward:Normalize()
      local right = Vector()
      right:Set(forward)
      right:Rotate(Angle(0, -90, 0))
      local up = Vector(0, 0, 1)
      local vec = forward*force.x + right*force.y + up*force.z
      local phys = ent:GetPhysicsObject()
      if ent.IsDrGNextbot then
        ent:LeaveGround()
        ent:SetVelocity(ent:GetVelocity()+vec)
      elseif ent.Type == "nextbot" then
        local jumpHeight = ent.loco:GetJumpHeight()
        ent.loco:SetJumpHeight(1)
        ent.loco:Jump()
        ent.loco:SetJumpHeight(jumpHeight)
        ent.loco:SetVelocity(ent.loco:GetVelocity()+vec)
      elseif IsValid(phys) and not ent:IsPlayer() then
        phys:AddVelocity(vec)
      else ent:SetVelocity(ent:GetVelocity()+vec) end
      return vec
    end
  end

  function ENT:SafeSetPos(pos)
    return self:DrG_SafeSetPos(pos)
  end

  -- Effects --

  function ENT:ParticleEffect(effect, ...)
    return self:DrG_ParticleEffect(effect, ...)
  end
  function ENT:DynamicLight(color, radius, brightness, style, attachment)
    return self:DrG_DynamicLight(color, radius, brightness, style, attachment)
  end

else

  -- Effects --

  function ENT:DynamicLight(color, radius, brightness, style, attachment)
    return self:DrG_DynamicLight(color, radius, brightness, style, attachment)
  end

end