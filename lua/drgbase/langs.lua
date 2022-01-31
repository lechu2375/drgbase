if CLIENT then

  local GmodLanguage = GetConVar("gmod_language")

  -- Language class --

  local Language = DrGBase.CreateClass()

  function Language:new(id, parent)
    self.Id = id
    self.Parent = parent
    self.Name = id
    self.Data = {}
  end

  function Language.prototype:IsCurrent()
    return self.Id == GmodLanguage:GetString()
  end

  function Language.prototype:Set(placeholder, translation)
    self.Data[placeholder:TrimLeft("#")] = translation
    return self
  end
  function Language.prototype:Get(placeholder, ...)
    local translation = self.Data[placeholder:TrimLeft("#")]
    if translation then
      if isfunction(translation) then translation = translation(...) end
      return tostring(translation)
    elseif self.Parent then
      return self.Parent:Get(placeholder, ...)
    end
  end

  function Language.prototype:MissingTranslations()
    if not self.Parent then return {} end
    local missing = self.Parent:MissingTranslations()
    for key in pairs(self.Parent.Data) do
      if self.Data[key] then missing[key] = nil
      else missing[key] = self.Parent end
    end
    return missing
  end

  function Language.prototype:tostring()
    return "Language("..self.Name..")"
  end

  if not list.HasEntry("DrG/Languages", "en") then
    local lang = Language("en", nil)
    list.Set("DrG/Languages", "en", lang)
  end

  -- API --

  function DrGBase.GetLanguage(id)
    if not isstring(id) then return end
    return list.GetForEdit("DrG/Languages")[id]
  end

  function DrGBase.GetOrCreateLanguage(id)
    if not isstring(id) then return end
    local lang = DrGBase.GetLanguage(id)
    if lang then return lang end
    lang = Language(id, DrGBase.GetLanguage("en"))
    list.Set("DrG/Languages", id, lang)
    return lang
  end

  function DrGBase.GetCurrentLanguage()
    local id = GmodLanguage:GetString()
    return DrGBase.GetLanguage(id) or DrGBase.GetLanguage("en")
  end

  function DrGBase.GetText(placeholder, ...)
    return DrGBase.GetCurrentLanguage():Get(placeholder, ...) or placeholder
  end

  function DrGBase.LanguageIterator()
    return pairs(list.GetForEdit("DrG/Languages"))
  end

  function DrGBase.GetLanguages()
    local langs = {}
    for _, lang in DrGBase.LanguageIterator() do
      table.insert(langs, lang)
    end
    return langs
  end

  local function AddTranslation(lang)
    if lang.Parent then AddTranslation(lang.Parent) end
    for placeholder, translation in pairs(lang.Data) do
      if not isstring(translation) then continue end
      language.Add(placeholder, translation)
    end
  end

  local function AddCurrentTranslation()
    AddTranslation(DrGBase.GetCurrentLanguage())
  end

  function DrGBase.ReloadLanguages()
    hook.Run("DrG/LoadLanguages")
    AddCurrentTranslation()
  end

  hook.Add("PreGamemodeLoaded", "DrG/LoadLanguages", function()
    DrGBase.ReloadLanguages()
  end)
  concommand.Add("drgbase_cmd_reload_languages", function()
    DrGBase.ReloadLanguages()
  end)
  cvars.AddChangeCallback("gmod_language", function()
    AddCurrentTranslation()
  end, "DrG/LanguageChange")

end

-- Import languages --

DrGBase.IncludeFolder("drgbase/cl_langs")