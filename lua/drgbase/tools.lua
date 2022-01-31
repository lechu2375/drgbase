-- Selection --

local ToolSelection = DrGBase.CreateClass()
function ToolSelection:new(tool)
  self.Entities = {}
  self.Tool = tool
end

function ToolSelection.prototype:Iterator()
  return function(_, ent)
    while true do
      ent = next(self.Entities, ent)
      if not ent then return end
      if not IsValid(ent) then continue end
      return ent
    end
  end
end

function ToolSelection.prototype:GetSelected()
  local selected = {}
  for ent in self:Iterator() do
    table.insert(selected, ent)
  end
  return selected
end

function ToolSelection.prototype:IsSelected(ent)
  return self.Entities[ent] or false
end

function ToolSelection.prototype:tostring()
  return "ToolSelection ["..self.Tool:GetMode().."]"
end

-- Create --

function DrGBase.CreateTool(fn)
  local TOOL = TOOL
  TOOL.Name = "#tool."..TOOL.Mode..".name"
  TOOL.Tab = "drgbase"
  TOOL.Category = "tools"
  TOOL.IsDrGTool = true

  local function GetText(placeholder, ...)
    return DrGBase.GetText("tool."..TOOL.Mode.."."..placeholder, ...)
  end

  function TOOL.BuildCPanel(panel)
    panel:Help(GetText("desc"))
    panel:Help(GetText("0"))
  end

  function TOOL:Selection()
    self.DrG_Selection = self.DrG_Selection or ToolSelection(self)
    return self.DrG_Selection
  end

  if CLIENT then
    fn(GetText, function(name)
      return GetConVar(TOOL.Mode.."_"..name)
    end)
  else fn() end
end

if SERVER then
  util.AddNetworkString("DrG/ToolSelectEntity")
  util.AddNetworkString("DrG/ToolDeselectEntity")
  util.AddNetworkString("DrG/ToolClearSelection")
  util.AddNetworkString("DrG/ToolClearAndSelectEntity")

  -- Selection --

  function ToolSelection.prototype:Select(ent)
    self.Entities[ent] = true
    net.Start("DrG/ToolSelectEntity")
    net.WriteString(self.Tool:GetMode())
    net.WriteEntity(ent)
    net.Send(self.Tool:GetOwner())
  end

  function ToolSelection.prototype:Deselect(ent)
    self.Entities[ent] = nil
    net.Start("DrG/ToolDeselectEntity")
    net.WriteString(self.Tool:GetMode())
    net.WriteEntity(ent)
    net.Send(self.Tool:GetOwner())
  end

  function ToolSelection.prototype:ToggleSelected(ent)
    if self:IsSelected(ent) then self:Deselect(ent)
    else self:Select(ent) end
  end

  function ToolSelection.prototype:Clear()
    self.Entities = {}
    net.Start("DrG/ToolClearSelection")
    net.WriteString(self.Tool:GetMode())
    net.Send(self.Tool:GetOwner())
  end

  function ToolSelection.prototype:ClearAndSelect(ent)
    self.Entities = {[ent] = true}
    net.Start("DrG/ToolClearAndSelectEntity")
    net.WriteString(self.Tool:GetMode())
    net.WriteEntity(ent)
    net.Send(self.Tool:GetOwner())
  end

else

  -- Halos --

  hook.Add("PreDrawHalos", "DrG/ToolDrawHalos", function()
    local ply = LocalPlayer()
    local weap = ply:GetActiveWeapon()
    if not IsValid(weap) or weap:GetClass() ~= "gmod_tool" then return end
    local tool = ply:GetTool()
    if tool ~= nil and tool.IsDrGTool and isfunction(tool.DrawHalos) then
      tool:DrawHalos()
    end
  end)

  -- Selection --

  net.Receive("DrG/ToolSelectEntity", function()
    local ply = LocalPlayer()
    local mode = net.ReadString()
    local ent = net.ReadEntity()
    if IsValid(ent) then
      ply:GetTool(mode):Selection().Entities[ent] = true
    end
  end)

  net.Receive("DrG/ToolDeselectEntity", function()
    local ply = LocalPlayer()
    local mode = net.ReadString()
    local ent = net.ReadEntity()
    if IsValid(ent) then
      ply:GetTool(mode):Selection().Entities[ent] = nil
    end
  end)

  net.Receive("DrG/ToolClearSelection", function()
    local ply = LocalPlayer()
    local mode = net.ReadString()
    ply:GetTool(mode):Selection().Entities = {}
  end)

  net.Receive("DrG/ToolClearAndSelectEntity", function()
    local ply = LocalPlayer()
    local mode = net.ReadString()
    local ent = net.ReadEntity()
    if IsValid(ent) then
      ply:GetTool(mode):Selection().Entities = {[ent] = true}
    end
  end)

end