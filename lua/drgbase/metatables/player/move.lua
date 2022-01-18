local plyMETA = FindMetaTable("Player")

local PlayerMove = DrGBase.CreateClass()
function PlayerMove:new(ply)
  self.Player = ply
end

function PlayerMove.prototype:IsMoving()
  return self:IsMovingForward() or
    self:IsMovingBackward() or
    self:IsMovingLeft() or
    self:IsMovingRight()
end
function PlayerMove.prototype:IsMovingForward()
  return self.Player:KeyDown(IN_FORWARD) and
    not self.Player:KeyDown(IN_BACK)
end
function PlayerMove.prototype:IsMovingBackward()
  return self.Player:KeyDown(IN_BACK) and
    not self.Player:KeyDown(IN_FORWARD)
end
function PlayerMove.prototype:IsMovingLeft()
  return self.Player:KeyDown(IN_MOVELEFT) and
    not self.Player:KeyDown(IN_MOVERIGHT)
end
function PlayerMove.prototype:IsMovingRight()
  return self.Player:KeyDown(IN_MOVERIGHT) and
    not self.Player:KeyDown(IN_MOVELEFT)
end

function PlayerMove.prototype:tostring()
  return "IsMoving = " .. tostring(self:IsMoving()) .. "\n" ..
    "| Forward = " .. tostring(self:IsMovingForward()) .. "\n" ..
    "| Backward = " .. tostring(self:IsMovingBackward()) .. "\n" ..
    "| Left = " .. tostring(self:IsMovingLeft()) .. "\n" ..
    "| Right = " .. tostring(self:IsMovingRight())
end

function plyMETA:DrG_Move()
  if not self.DrG_MoveObj then self.DrG_MoveObj = PlayerMove(self) end
  return self.DrG_MoveObj
end