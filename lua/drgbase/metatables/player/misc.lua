local plyMETA = FindMetaTable("Player")

-- Possession --

function plyMETA:DrG_GetPossessing()
  return self:GetNW2Entity("DrG/Possessing")
end
function plyMETA:DrG_IsPossessing()
  return IsValid(self:DrG_GetPossessing())
end
function plyMETA:DrG_GetPossessingOrSelf()
  return self:DrG_IsPossessing() and self:DrG_GetPossessing() or self
end

local PossessingDeprecation = DrGBase.Deprecation("ply:DrG_Possessing()", "ply:DrG_GetPossessing()")
function plyMETA:DrG_Possessing()
  PossessingDeprecation()
  return self:DrG_GetPossessing()
end

-- Buttons --

hook.Add("PlayerButtonDown", "DrGBasePlayerButtonDown", function(ply, button)
  ply.DrG_ButtonsDown = ply.DrG_ButtonsDown or {}
  ply.DrG_ButtonsDown[button] = {
    down = true, recent = true
  }
  timer.Simple(0, function()
    if not IsValid(ply) then return end
    ply.DrG_ButtonsDown[button].recent = false
  end)
end)

hook.Add("PlayerButtonUp", "DrGBasePlayerButtonUp", function(ply, button)
  ply.DrG_ButtonsDown = ply.DrG_ButtonsDown or {}
  ply.DrG_ButtonsDown[button] = {
    down = false, recent = true
  }
  timer.Simple(0, function()
    if not IsValid(ply) then return end
    ply.DrG_ButtonsDown[button].recent = false
  end)
end)

function plyMETA:DrG_ButtonUp(button)
  self.DrG_ButtonsDown = self.DrG_ButtonsDown or {}
  local data = self.DrG_ButtonsDown[button]
  if data == nil then return true end
  return not data.down
end
function plyMETA:DrG_ButtonPressed(button)
  self.DrG_ButtonsDown = self.DrG_ButtonsDown or {}
  local data = self.DrG_ButtonsDown[button]
  if data == nil then return false end
  return tobool(data.down and data.recent)
end
function plyMETA:DrG_ButtonDown(button)
  self.DrG_ButtonsDown = self.DrG_ButtonsDown or {}
  local data = self.DrG_ButtonsDown[button]
  if data == nil then return false end
  return data.down or false
end
function plyMETA:DrG_ButtonReleased(button)
  self.DrG_ButtonsDown = self.DrG_ButtonsDown or {}
  local data = self.DrG_ButtonsDown[button]
  if data == nil then return false end
  return tobool(not data.down and data.recent)
end

-- Misc --

function plyMETA:DrG_GetVehicle()
  local veh = self:GetVehicle()
  if not IsValid(veh) then return NULL end
  while IsValid(veh:GetParent()) do
    veh = veh:GetParent()
  end
  return veh
end

if SERVER then

  -- Possession --

  function plyMETA:DrG_StopPossession()
    if not self:DrG_IsPossessing() then return end
    self:DrG_GetPossessing():StopPossession()
  end

  -- Luminosity --

  coroutine.DrG_RunThread("DrG/PlayerLuminosity", function()
    while true do
      local players = player.GetHumans()
      for i = 1, #players do
        local ply = players[i]
        ply:DrG_RunCallback("DrG/PlayerLuminosity", function(luminosity)
          if IsValid(ply) then ply.DrG_LuminosityValue = luminosity end
        end)
      end
      coroutine.wait(0.5)
    end
  end)

  function plyMETA:DrG_Luminosity()
    return self.DrG_LuminosityValue or 1
  end

  -- Misc --

  function plyMETA:DrG_Immobilize()
    local chair = ents.Create("prop_vehicle_prisoner_pod")
    if not chair then return end
    chair:SetModel("models/nova/airboat_seat.mdl")
    chair:SetKeyValue("vehiclescript", "scripts/vehicles/prisoner_pod.txt")
    chair:SetPos(self:GetPos())
    chair:SetAngles(self:GetAngles())
    chair:SetNoDraw(true)
    chair:Spawn()
    self:EnterVehicle(chair)
  end

  function plyMETA:DrG_AddUndo(ent, type, text)
    undo.Create(type)
    undo.SetPlayer(self)
    undo.AddEntity(ent)
    if not isstring(text) then
      undo.SetCustomUndoText("Undone #"..ent:GetClass())
    else undo.SetCustomUndoText(text) end
    undo.Finish()
  end

else

  -- Luminosity --

  function plyMETA:DrG_Luminosity()
    if self ~= LocalPlayer() then return -1 end
    local light = render.GetLightColor(self:EyePos())
    local length = math.Round(light:Length(), 2)
    return math.Clamp(math.sqrt(math.log(length)+5)/2, 0, 1)
  end

  net.DrG_DefineCallback("DrG/PlayerLuminosity", function()
    local ply = LocalPlayer()
    if not isfunction(ply.DrG_Luminosity) then return 1
    else return ply:DrG_Luminosity() end
  end)

end
