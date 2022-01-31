function DrGBase.DListView(columns)
  local dlist = vgui.Create("DListView")
  for _, column in ipairs(columns) do dlist:AddColumn(column) end
  local linked = false
  function dlist:LinkConVar(convar)
    if linked then return end
    linked = true
    local function UpdateConVar()
      local values = {}
      for _, line in ipairs(self:GetLines()) do
        local value = {}
        for i = 1, #columns do
          table.insert(value, line:GetValue(i))
        end
        table.insert(values, value)
      end
      convar:SetString(util.TableToJSON(values))
    end
    local AddLine = self.AddLine
    function self:AddLine(...)
      AddLine(self, ...)
      UpdateConVar()
    end
    local RemoveLine = self.RemoveLine
    function self:RemoveLine(...)
      RemoveLine(self, ...)
      UpdateConVar()
    end
    local ClearSelection = self.ClearSelection
    function self:ClearSelection(...)
      ClearSelection(self, ...)
      UpdateConVar()
    end
    local Clear = self.Clear
    function self:Clear(...)
      Clear(self, ...)
      UpdateConVar()
    end
    function self:MatchConVar()
      local lines = util.JSONToTable(convar:GetString())
      if lines then
        Clear(self)
        for _, line in ipairs(lines) do
          AddLine(self, unpack(line))
        end
      else self:Reset() end
    end
    function self:Reset()
      convar:Revert()
      self:MatchConVar()
    end
    self:MatchConVar()
  end
  return dlist
end

function DrGBase.Button(text)
  local button = vgui.Create("DButton")
  button:SetText(text or "")
  return button
end

function DrGBase.TextEntry(placeholder)
  local textEntry = vgui.Create("DTextEntry")
  textEntry:SetPlaceholderText(placeholder or "")
  return textEntry
end