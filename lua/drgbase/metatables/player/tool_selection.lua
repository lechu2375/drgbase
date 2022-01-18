local plyMETA = FindMetaTable("Player")

local PlayerSelection = DrGBase.CreateClass()
function PlayerSelection:new(ply, tool)
  self.Entities = {}
  self.Player = ply
  self.Tool = tool
end

function PlayerSelection.prototype:SelectedIterator()
  return function(_, ent)
    while true do
      ent = next(self.Entities, ent)
      if not ent then return end
      if not IsValid(ent) then continue end
      return ent
    end
  end
end

function PlayerSelection.prototype:GetSelected()
  local selected = {}
  for ent in self:SelectedIterator() do
    table.insert(selected, ent)
  end
  return selected
end

function PlayerSelection.prototype:IsSelected(ent)
  return self.Entities[ent] or false
end

function PlayerSelection.prototype:tostring()
  return "PlayerSelection ["..table.Count(self.Entities).."]"
end

function plyMETA:DrG_ToolSelection(mode)
  local tool = self:GetTool(mode)
  if not tool then return end
  self.DrG_Selection = self.DrG_Selection or {}
  self.DrG_Selection[mode] = self.DrG_Selection[mode] or PlayerSelection(self, tool)
  return self.DrG_Selection[mode]
end

if SERVER then
  util.AddNetworkString("DrG/SelectEntity")
  util.AddNetworkString("DrG/DeselectEntity")
  util.AddNetworkString("DrG/ClearSelection")
  util.AddNetworkString("DrG/ClearAndSelectEntity")

  function PlayerSelection.prototype:SelectEntity(ent)
    self.Entities[ent] = true
    net.Start("DrG/SelectEntity")
    net.WriteString(self.Tool.Mode)
    net.WriteEntity(ent)
    net.Send(self.Player)
  end

  function PlayerSelection.prototype:DeselectEntity(ent)
    self.Entities[ent] = nil
    net.Start("DrG/DeselectEntity")
    net.WriteString(self.Tool.Mode)
    net.WriteEntity(ent)
    net.Send(self.Player)
  end

  function PlayerSelection.prototype:ClearSelection()
    self.Entities = {}
    net.Start("DrG/ClearSelection")
    net.WriteString(self.Tool.Mode)
    net.Send(self.Player)
  end

  function PlayerSelection.prototype:ClearAndSelectEntity(ent)
    self.Entities = {[ent] = true}
    net.Start("DrG/ClearAndSelectEntity")
    net.WriteString(self.Tool.Mode)
    net.WriteEntity(ent)
    net.Send(self.Player)
  end

else

  net.Receive("DrG/SelectEntity", function()
    local ply = LocalPlayer()
    local mode = net.ReadString()
    local ent = net.ReadEntity()
    if IsValid(ent) then
      ply:DrG_Selection(mode).Entities[ent] = true
    end
  end)

  net.Receive("DrG/DeselectEntity", function()
    local ply = LocalPlayer()
    local mode = net.ReadString()
    local ent = net.ReadEntity()
    if IsValid(ent) then
      ply:DrG_Selection(mode).Entities[ent] = nil
    end
  end)

  net.Receive("DrG/ClearSelection", function()
    local ply = LocalPlayer()
    local mode = net.ReadString()
    if IsValid(ent) then
      ply:DrG_Selection(mode).Entities = {}
    end
  end)

  net.Receive("DrG/ClearAndSelectEntity", function()
    local ply = LocalPlayer()
    local mode = net.ReadString()
    local ent = net.ReadEntity()
    if IsValid(ent) then
      ply:DrG_Selection(mode).Entities = {[ent] = true}
    end
  end)

end