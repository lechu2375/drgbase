function DrGBase.Deprecation(old, new)
  local printed = false
  return function()
    if not printed and GetConVar("developer"):GetBool() then
      ErrorNoHalt("[DrGBase] Deprecation warning: '"..old.."' is deprecated, you should use '"..new.."' instead".."\n")
      printed = true
    end
  end
end

function DrGBase.Deprecated(old, new, fn)
  local deprecation = DrGBase.Deprecation(old, new)
  return function(...)
    deprecation()
    return fn(...)
  end
end