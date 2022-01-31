DrGBase.CreateTool(function(GetText, GetConVar)
  TOOL.ClientConVar = { selected = "[[\"FACTION_PLAYERS\"]]" }

  if SERVER then
    util.AddNetworkString("DrG/FactionsToolCopy")
  end

  function TOOL.BuildCPanel(panel)
    panel:Help(GetText("desc"))
    panel:Help(GetText("0"))
    local dlist = DrGBase.DListView({ GetText("selected_factions") })
    function dlist:OnRowSelected(line) self:RemoveLine(line) end
    dlist:LinkConVar(GetConVar("selected"))
    dlist:SetSize(10, 400)
    panel:AddItem(dlist)
    net.DrG_Receive("DrG/FactionsToolCopy", function(ent)
      dlist:Clear()
      for faction in ent:DrG_FactionIterator() do
        dlist:AddLine(faction)
      end
    end)
    local textEntry = DrGBase.TextEntry()
    function textEntry:OnEnter(value)
      dlist:AddLine(value)
      self:SetText("")
    end
    function textEntry:GetAutoComplete(input)
      local autocomplete = {}
      if string.StartWith("FACTION_PLAYERS", string.upper(input)) then
        table.insert(autocomplete, "FACTION_PLAYERS")
      end
      for nb in DrGBase.NextbotIterator() do
        for faction in nb:FactionIterator() do
          if string.StartWith(string.upper(faction), string.upper(input)) and
          not table.HasValue(autocomplete, faction) then
            table.insert(autocomplete, faction)
          end
        end
      end
      table.sort(autocomplete)
      return autocomplete
    end
    panel:AddItem(textEntry)
    local clear = DrGBase.Button(GetText("clear"))
    function clear:DoClick()
      dlist:Clear()
    end
    panel:AddItem(clear)
    local reset = DrGBase.Button(GetText("reset"))
    function reset:DoClick()
      dlist:Reset()
    end
    panel:AddItem(reset)
  end

  function TOOL:RightClick(tr)
    if not IsValid(tr.Entity) then return false end
    if SERVER then
      self:GetOwner():DrG_Send("DrG/FactionsToolCopy", tr.Entity)
    end
    return true
  end

  -- Apply factions --

  function TOOL:ApplyFactions(ent)
    local lines = util.JSONToTable(self:GetClientInfo("selected"))
    local factions = {}
    for _, line in ipairs(lines) do
      table.insert(factions, line[1])
    end
    for faction in ent:DrG_FactionIterator() do
      if not table.HasValue(factions, faction) then ent:DrG_LeaveFaction(faction) end
    end
    for _, faction in ipairs(factions) do
      ent:DrG_JoinFaction(faction)
    end
  end

  function TOOL:LeftClick(tr)
    if not IsValid(tr.Entity) then return false end
    if SERVER then self:ApplyFactions(tr.Entity) end
    return true
  end

  function TOOL:Reload()
    if SERVER then self:ApplyFactions(self:GetOwner()) end
    return true
  end

end)