DrGBase.CreateTool(function()

  function TOOL:LeftClick(tr)
    local ent = tr.Entity
    if IsValid(ent) and ent.IsDrGNextbot then
      self:Selection():ToggleSelected(ent)
      return true
    else return false end
  end

  function TOOL:RightClick(tr)
    for nb in self:Selection():Iterator() do
      nb:CallInCoroutine(nb.GoTo, tr.HitPos)
    end
    return true
  end

  function TOOL:Reload()
    self:Selection():Clear()
    return true
  end

  function TOOL:DrawHalos()
    halo.Add(self:Selection():GetSelected(), DrGBase.CLR_CYAN)
  end

end)