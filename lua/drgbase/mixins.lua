-- Functions --

local MIXINS = {}
function DrGBase.ApplyMixin(class, mixin)
  MIXINS[class] = MIXINS[class] or {}
  table.insert(MIXINS[class], mixin)
end

hook.Add("PreRegisterSENT", "DrG/ApplySENTMixins", function(ENT, class)
  for mixinClass, mixins in pairs(MIXINS) do
    if class ~= mixinClass and ENT.Base ~= mixinClass then continue end
    ENT.DrG_Mixin = ENT.DrG_Mixin or {}
    for _, mixin in ipairs(mixins) do
      for key, value in pairs(mixin) do
        if ENT[key] == nil then continue end
        ENT.DrG_Mixin[key] = ENT[key]
        ENT[key] = value
      end
    end
  end
end)

-- Built-in --

local GenericMixin = DrGBase.IncludeFile("mixins/generic.lua")
local NextbotMixin = DrGBase.IncludeFile("mixins/nextbot.lua")
local ProjectileMixin = DrGBase.IncludeFile("mixins/projectile.lua")
local SpawnerMixin = DrGBase.IncludeFile("mixins/spawner.lua")
local WeaponMixin = DrGBase.IncludeFile("mixins/weapon.lua")

DrGBase.ApplyMixin("drgbase_nextbot", GenericMixin)
DrGBase.ApplyMixin("drgbase_nextbot", NextbotMixin)

DrGBase.ApplyMixin("drgbase_projectile", GenericMixin)
DrGBase.ApplyMixin("drgbase_projectile", ProjectileMixin)

DrGBase.ApplyMixin("drgbase_spawner", GenericMixin)
DrGBase.ApplyMixin("drgbase_spawner", SpawnerMixin)