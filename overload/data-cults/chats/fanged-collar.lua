-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2018 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

local DeathDialog = require("mod.dialogs.DeathDialog")

newChat{ id="welcome",
	text = [[#{italic}##GREY#你感受到湮灭的黑暗淹没了你。不知为何，黑暗并没有完全包围你。有什么东西似乎正在陪伴着你，你觉得它似乎想要帮助你。它无言地的向你承诺，一切都会好起来的，他可以帮你脱离死亡的命运。你只要说“是”就行了。#{normal}#]],
	answers = {
		{"你默默的同意了，你想活下去！", jump="accept"},
		{"你默默地拒绝了，这个存在太可怕了。", jump="die"},
	}
}

newChat{ id="die",
	text = [[#{italic}##GREY#那个存在伤心地离开了，但是你觉得它尊重了你的选择。它让你寻找到了只有死亡才能给你的平和安宁。#{normal}#]],
	answers = {
		{"[你死了]", action=function(o, player)
			local d = DeathDialog.new(player)
			if not d.dont_show then game:registerDialog(d) end
		end},
	}
}

newChat{ id="accept",
	text = [[#{italic}##GREY#你可不想死。不需要多少思考，你同意了这个请求。那个东西高兴地开始做了…某件事。你醒了过来，感受到生命重新充满了你的四肢。然而，你仍然感觉头痛欲裂，你的脖子也很痛。到底是什么把你从死亡的边缘带了回来？#{normal}#]],
	answers = {
		{"...", action=function(o, player)
			DeathDialog:cleanActor(player)
			DeathDialog:resurrectBasic(player)
			DeathDialog:restoreResources(player)

			player.equipdoll = "cults_beheaded"

			local _, item, inven_id = player:findInAllWornInventoriesByObject(true, o)
			if inven_id then player:onTakeoff(o, inven_id, true, true) end
			o.wielder.death_dialog = nil
			o.on_cantakeoff = function(self, who) return true end
			if inven_id then player:onWear(o, inven_id, true, true) end

			local base_list = require("mod.class.Object"):loadList("/data-cults/general/objects/special-misc.lua")
			base_list.__real_type = "object"
			local fakehead = game.zone:makeEntityByName(game.level, base_list, "FANGED_COLLAR_HEAD")
			if not fakehead then return end
			fakehead:identify(true)
			player:wearObject(fakehead, true, true)

			for tt, v in pairs(player.talents_types) do
				if tt:find("^race/") then
					player.talents_types[tt] = nil
					break
				end
			end

			player:learnTalentType("race/parasite", true)
			player:learnTalent(player.T_TAKE_A_BITE, true)
			player.cults_fanged_parasite = true

			game.log("#CRIMSON#好奇怪…你很确定你已经死了，但你还活着。然而，你还是觉得你少了什么重要的东西。你的脖子很痛，你还是觉得很头疼。不知为何，你隐约感觉你不应该照镜子。")
		end},
	}
}

return "welcome"
