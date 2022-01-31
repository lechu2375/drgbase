DrGBase.CreateTool(function()

  function TOOL:LeftClick(tr)
    local ent = tr.Entity
    if not IsValid(ent) then return false end
    if not ent.IsDrGNextbot then return false end
    if SERVER then ent:SetAIDisabled(not ent:IsAIDisabled()) end
    return true
  end

  function TOOL:DrawHalos()
    local enabled = {}
    local disabled = {}
    for nb in DrGBase.NextbotIterator() do
      table.insert(nextbot:IsAIDisabled() and disabled or enabled, nb)
    end
    halo.Add(enabled, DrGBase.CLR_GREEN)
    halo.Add(disabled, DrGBase.CLR_RED)
  end

end)