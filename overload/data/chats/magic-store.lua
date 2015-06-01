-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2015 Nicolas Casalini
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

local function recharge(npc, player)
	player:showEquipInven("选择充能的物品", function(o) return o.recharge_cost and o.power and o.max_power and o.power < o.max_power end, function(o, inven, item)
		local cost = math.ceil(o.recharge_cost * (o.max_power / (o.use_talent and o.use_talent.power or o.use_power.power)))
		if cost > player.money then require("engine.ui.Dialog"):simplePopup("金币不足", "这将花费 "..cost.." 金币。") return true end
		require("engine.ui.Dialog"):yesnoPopup("充能？", "这将花费你 "..cost.." 金币。", function(ok) if ok then
			o.power = o.max_power
			player:incMoney(-cost)
			player.changed = true
		end end)
		return true
	end)

end

newChat{ id="welcome",
	text = [[欢迎你 @playername@,光临我的商店。]],
	answers = {
		{"让我看看你的货物。", action=function(npc, player)
			npc.store:loadup(game.level, game.zone)
			npc.store:interact(player)
		end},
		{"我想为我的装备充能。", action=recharge},
		{"抱歉，我得走了！"},
	}
}

return "welcome"
