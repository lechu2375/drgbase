hook.Add("DrG/LoadLanguages", "DrG/FrenchLanguage", function()
  local lang = DrGBase.GetOrCreateLanguage("fr")
  lang.Flag = "flags16/fr.png"
  lang.Name = "Français"

  -- Misc --

  lang:Set("drgbase.hello", "Salut !")

  -- Possession --

  lang:Set("drgbase.possession.possess", "Posséder")
  lang:Set("drgbase.possession.allowed", function(name) return "Tu possèdes désormais "..name end)
  lang:Set("drgbase.possession.denied.notplayer", "Tu n'es pas un joueur ?")
  lang:Set("drgbase.possession.denied.dead", "Tu peux ne pas posséder de nextbot en étant mort")
  lang:Set("drgbase.possession.denied.invehicle", "Tu ne peux pas posséder de nextbot depuis un véhicule")

  -- Spawnmenu --

  lang:Set("drgbase.menu.main", "Menu principal")

  lang:Set("drgbase.menu.main.info", "Informations")

  lang:Set("drgbase.menu.main.server", "Paramètres serveur")

  lang:Set("drgbase.menu.main.client", "Paramètres client")
  lang:Set("drgbase.menu.main.client.language", "Langue")
  lang:Set("drgbase.menu.main.client.language.text", "Définir la langue utilisée, cela recharge automatiquement le spawnmenu.")
  lang:Set("drgbase.menu.main.client.language.missing_translations", function(nb) return "(traductions manquantes: "..nb..")" end)

  lang:Set("drgbase.menu.nextbots", "Nextbots")

  lang:Set("drgbase.menu.nextbots.ai", "Paramètres IA")
  lang:Set("drgbase.menu.nextbots.ai.behaviour", "Comportement")
  lang:Set("drgbase.menu.nextbots.ai.behaviour.ai_disabled", "Désactiver l'IA")
  lang:Set("drgbase.menu.nextbots.ai.behaviour.ignore_players", "Ignorer les joueurs")
  lang:Set("drgbase.menu.nextbots.ai.behaviour.ignore_npcs", "Ignorer les PNJs")
  lang:Set("drgbase.menu.nextbots.ai.behaviour.ignore_others", "Ignorer les autres entités")
  lang:Set("drgbase.menu.nextbots.ai.behaviour.roam", "Activer l'errance")
  lang:Set("drgbase.menu.nextbots.ai.detection", "Détection")
  lang:Set("drgbase.menu.nextbots.ai.detection.omniscience", "Omniscience")
  lang:Set("drgbase.menu.nextbots.ai.detection.blind", "Désactiver la vision")
  lang:Set("drgbase.menu.nextbots.ai.detection.deaf", "Désactiver l'écoute")

  lang:Set("drgbase.menu.nextbots.possession", "Possession")
  lang:Set("drgbase.menu.nextbots.possession.server", "Paramètres serveur")
  lang:Set("drgbase.menu.nextbots.possession.server.enabled", "Activer la possession")
  lang:Set("drgbase.menu.nextbots.possession.server.spawn_with_possessor", "Spawn avec le possesseur")
  lang:Set("drgbase.menu.nextbots.possession.client", "Paramètres client")
  lang:Set("drgbase.menu.nextbots.possession.client.binds.stop", "Arrêter la possession")
  lang:Set("drgbase.menu.nextbots.possession.client.binds.views", "Caméra suivante")

  lang:Set("drgbase.menu.nextbots.misc", "Divers")
  lang:Set("drgbase.menu.nextbots.misc.stats", "Stats")
  lang:Set("drgbase.menu.nextbots.misc.stats.health", "Multiplicateur de santé")
  lang:Set("drgbase.menu.nextbots.misc.stats.player_damage", "Multiplicateur de dégâts aux joueurs")
  lang:Set("drgbase.menu.nextbots.misc.stats.npc_damage", "Multiplicateur de dégâts aux PNJs")
  lang:Set("drgbase.menu.nextbots.misc.stats.other_damage", "Multiplicateur de dégâts aux autres entités")
  lang:Set("drgbase.menu.nextbots.misc.stats.speed", "Multiplicateur de vitesse")
  lang:Set("drgbase.menu.nextbots.misc.ragdolls", "Corps")
  lang:Set("drgbase.menu.nextbots.misc.ragdolls.remove", "Retirer les corps")
  lang:Set("drgbase.menu.nextbots.misc.ragdolls.fadeout", "Durée de la disparition")
  lang:Set("drgbase.menu.nextbots.misc.ragdolls.disable_collisions", "Désactiver les collisions")

  -- Tools --

  lang:Set("tool.drgbase_tool_damage.name", "Infliger des dégâts")
  lang:Set("tool.drgbase_tool_damage.desc", "Infliger des dégâts à une entité.")
	lang:Set("tool.drgbase_tool_damage.0", "Clic gauche pour infliger des dégâts.")
  lang:Set("tool.drgbase_tool_damage.damage", "Dégâts")
  lang:Set("tool.drgbase_tool_damage.type", "Type")
  lang:Set("tool.drgbase_tool_damage.enabled", "Activé")
  lang:Set("tool.drgbase_tool_damage.yes", "Oui")
  lang:Set("tool.drgbase_tool_damage.no", "Non")
  lang:Set("tool.drgbase_tool_damage.dmg_crush", "Écraser")
  lang:Set("tool.drgbase_tool_damage.dmg_slash", "Tranchant")
  lang:Set("tool.drgbase_tool_damage.dmg_blast", "Explosion")
  lang:Set("tool.drgbase_tool_damage.dmg_burn", "Brûlure")
  lang:Set("tool.drgbase_tool_damage.dmg_slowburn", "Brûlure lente")
  lang:Set("tool.drgbase_tool_damage.dmg_shock", "Électricité")
  lang:Set("tool.drgbase_tool_damage.dmg_plasma", "Plasma")
  lang:Set("tool.drgbase_tool_damage.dmg_dissolve", "Dissoudre")
  lang:Set("tool.drgbase_tool_damage.dmg_sonic", "Sonique")
  lang:Set("tool.drgbase_tool_damage.dmg_poison", "Poison")
  lang:Set("tool.drgbase_tool_damage.dmg_acid", "Acide")
  lang:Set("tool.drgbase_tool_damage.dmg_radiation", "Radiation")
  lang:Set("tool.drgbase_tool_damage.dmg_neurotoxin", "Neurotoxine")

  lang:Set("tool.drgbase_tool_disable_ai.name", "Désativer l'IA")
	lang:Set("tool.drgbase_tool_disable_ai.desc", "Activer/désactiver l'IA d'un nextbot.")
	lang:Set("tool.drgbase_tool_disable_ai.0", "Clic gauche pour activer/désactiver. (Vert => Activée / Rouge => Désactivée)")

  lang:Set("tool.drgbase_tool_factions.name", "Factions")
  lang:Set("tool.drgbase_tool_factions.desc", "Modifier les factions d'une entité.")
  lang:Set("tool.drgbase_tool_factions.0", "Clic gauche pour modifier les factions d'une entité, recharger pour les applique à soi-même. Clic droit pour copier les factions d'une entité.")
  lang:Set("tool.drgbase_tool_factions.selected_factions", "Factions sélectionnées")

  lang:Set("tool.drgbase_tool_mover.name", "Déplacer un nextbot")
  lang:Set("tool.drgbase_tool_mover.desc", "Forcer un nextbot à se déplacer.")
  lang:Set("tool.drgbase_tool_mover.0", "Clic gauche pour sélectionner un nextbot, clic droit pour le(s) faire se déplacer, recharger pour effacer la sélection.")

end)