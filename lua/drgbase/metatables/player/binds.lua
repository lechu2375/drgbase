local plyMETA = FindMetaTable("Player")

local PlayerBinds = DrGBase.CreateClass()
function PlayerBinds:new(ply)
  self.Player = ply
end

-- Keys --

function PlayerBinds.prototype:KeyUp(key)
  return not self.Player:KeyDown(key)
end
function PlayerBinds.prototype:KeyDown(key)
  return self.Player:KeyDown(key)
end
function PlayerBinds.prototype:KeyDownLast(key)
  return self.Player:KeyDownLast(key)
end
function PlayerBinds.prototype:KeyPressed(key)
  return self.Player:KeyPressed(key)
end
function PlayerBinds.prototype:KeyReleased(key)
  return self.Player:KeyReleased(key)
end

-- Buttons --

function PlayerBinds.prototype:ButtonUp(button)
  return self.Player:DrG_ButtonUp(button)
end
function PlayerBinds.prototype:ButtonDown(button)
  return self.Player:DrG_ButtonDown(button)
end
function PlayerBinds.prototype:ButtonPressed(button)
  return self.Player:DrG_ButtonPressed(button)
end
function PlayerBinds.prototype:ButtonReleased(button)
  return self.Player:DrG_ButtonReleased(button)
end

-- ConVars --

function PlayerBinds.prototype:GetButtonFromConVar(convar)
  if SERVER then return self.Player:GetInfoNum(convar, BUTTON_CODE_INVALID)
  else
    local convar = GetConVar(convar)
    if convar then return convar:GetInt()
    else return BUTTON_CODE_INVALID end
  end
end

function PlayerBinds.prototype:ConVarUp(convar)
  return self:ButtonUp(self:GetButtonFromConVar(convar))
end
function PlayerBinds.prototype:ConVarDown(convar)
  return self:ButtonDown(self:GetButtonFromConVar(convar))
end
function PlayerBinds.prototype:ConVarPressed(convar)
  return self:ButtonPressed(self:GetButtonFromConVar(convar))
end
function PlayerBinds.prototype:ConVarReleased(convar)
  return self:ButtonReleased(self:GetButtonFromConVar(convar))
end

-- Misc --

function PlayerBinds.prototype:tostring()
  return "PlayerBinds"
end

function plyMETA:DrG_Binds()
  if not self.DrG_BindsObj then self.DrG_BindsObj = PlayerBinds(self) end
  return self.DrG_BindsObj
end