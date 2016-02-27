

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*你面前有一个奇怪的三角形设备，似乎是某种自动设施。*#WHITE#
似乎它能教授你制造配件的技巧，但需要你一些投入（500g+一点大系点）。]],
	answers = {
		{"[支付500金币和一点大系点]", jump="APE", action=function(npc, player)
			player:learnTalentType("steamtech/physics", true)
			player:learnTalentType("steamtech/chemistry", true)
			player:learnTalent(player.T_SMITH, true)
			player:learnTalent(player.T_THERAPEUTICS, true)
			player:incMoney(-500)
			player.unused_talents_types = player.unused_talents_types - 1

			-- From now on, drop tinker stuff
			game.state.birth.merge_tinkers_data = true

			game.log("#PURPLE# %s 教会你: #GOLD#蒸汽/机械#LAST#, #GOLD#蒸汽/药剂#LAST#和两项基础技能。", npcCHN:getName(npc.name))
		end, cond=function(npc, player) return player.money >= 500 and player.unused_talents_types >= 1 and not player:knowTalent(player.T_CREATE_TINKER) end},
		{"[接近商店]", action=function(npc, player)
			npc.store:loadup(game.level, game.zone)
			npc.store:interact(player, npc.name)
		end, cond=function(npc, player) return player:knowTalent(player.T_CREATE_TINKER) end},
		{"[离开]"},
	}
}

newChat{ id="APE",
	text = [[机械交给你一个小金属盒，上面写着 #{italic}#"便携式自动提取仪"#{normal}#.
它似乎能将金属物品转化为铁块，将纹身转化为植物。

#{bold}#你可以选择使用它或者转化之盒。在里面没有物品时使用它则设置为默认使用。#{normal}#
]],
	answers = {
		{"[拿走]", jump="welcome", action=function(npc, player)
			local ape = player:findInAllInventoriesBy("define_as", "APE")
			if not ape then
				local base_list = require("mod.class.Object"):loadList("/data-orcs/general/objects/quest-artifacts.lua")
				base_list.__real_type = "object"
				local o = game.zone:makeEntityByName(game.level, base_list, "APE")
				if o then
					o.auto_hotkey = 1
					player:addObject(player.INVEN_INVEN, o)
					player:sortInven()
				end
			end
		end},
	}
}

return "welcome"
