-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
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

local imbueEgo = function(gem, ring)
	if not gem then return end
	if not ring then return end
	local Entity = require("engine.Entity")
	local ego = Entity.new{
		fake_ego = true,
		name = "imbued_"..gem.name,
		keywords = {[gem.name] = true},
		wielder = table.clone(gem.imbue_powers, true),
		been_imbued = true,
		egoed = true,
	}
	if gem.talent_on_spell then ego.talent_on_spell = table.clone(gem.talent_on_spell, true) end  -- Its really weird that this table structure is different for one property
	game.zone:applyEgo(ring, ego, "object", true)
end

local imbue_ring = function(npc, player)
	player:showInventory("镶嵌哪个戒指？", player:getInven("INVEN"), function(o) return o.type == "jewelry" and o.subtype == "ring" and o.material_level end, function(ring, ring_item)
		player:showInventory("使用哪颗宝石？", player:getInven("INVEN"), function(gem) return gem.type == "gem" and gem.imbue_powers and gem.material_level end, function(gem, gem_item)
			local lev = (ring.material_level + gem.material_level) / 2 * 10 + 10  -- Average the material level then add a bonus so we guarantee greater ego level range
			local new_ring
			local r = rng.range(0, 99)
			if r < 20 then
				local ring = game.zone:makeEntity(game.level, "object", 
					{base_list="mod.class.Object:/data/general/objects/jewelry.lua", type="jewelry", subtype="ring",
					ignore_material_restriction=true, ego_filter={keep_egos=true, ego_chance=-1000},
					special=function(e) return e.material_level == ring.material_level end}
					, lev, true)
				new_ring = game.state:generateRandart{base=ring, lev=lev}
			else
				new_ring = game.zone:makeEntity(game.level, "object",
					{base_list="mod.class.Object:/data/general/objects/jewelry.lua", type="jewelry", subtype="ring",
					ignore_material_restriction=true, tome = {greater=9, double_greater=1}, egos = 2,
					special=function(e) return e.material_level == ring.material_level end}
					, lev, true)
			end
			if not new_ring then
				game.logPlayer(player, "%s failed to craft with %s and %s!", npc.name:capitalize(), ring:getName{do_colour=true, no_count=true}, gem:getName{do_colour=true, no_count=true})
				return false
			end
			
			local price = 300 * (ring.material_level + gem.material_level) / 2
			if price > player.money then require("engine.ui.Dialog"):simplePopup("Not enough money", "This costs "..price.." gold, you need more gold.") return end

			require("engine.ui.Dialog"):yesnoPopup("Imbue cost", "This will cost you "..price.." gold, do you accept?", function(ret) if ret then
				imbueEgo(gem, new_ring)
				player:incMoney(-price)
				player:removeObject(player:getInven("INVEN"), gem_item)

				new_ring.name = (ring.short_name or ring.name or "weird").." "..gem.name .. " ring"
				new_ring:identify(true)
				game.zone:addEntity(game.level, new_ring, "object")
				player:addObject(player:getInven("INVEN"), new_ring)

				game.logPlayer(player, "%s creates: %s", npc.name:capitalize(), new_ring:getName{do_colour=true, no_count=true})
			end end)
		end)
	end)
end

local artifact_imbue_amulet = function(npc, player)
	player:showInventory("镶嵌哪个项链？", player:getInven("INVEN"), function(o) return o.type == "jewelry" and o.subtype == "amulet" and o.material_level end, function(amulet, amulet_item)
		player:showInventory("使用哪颗做第一个宝石？", player:getInven("INVEN"), function(gem1) return gem1.type == "gem" and (gem1.material_level or 99) <= amulet.material_level and gem1.imbue_powers end, function(gem1, gem1_item)
			player:showInventory("使用哪颗做第二个宝石？", player:getInven("INVEN"), function(gem2) return gem2.type == "gem" and (gem2.material_level or 99) <= amulet.material_level and gem1.name ~= gem2.name and gem2.imbue_powers end, function(gem2, gem2_item)
				local price = 1000
				if price > player.money then require("engine.ui.Dialog"):simplePopup("Not enough money", "Limmir needs more gold for the magical plating.") return end

				require("engine.ui.Dialog"):yesnoPopup("Imbue cost", "You need to use "..price.." gold for the plating, do you accept?", function(ret) if ret then
					player:incMoney(-price)
					local gem3, tries = nil, 10
					while gem3 == nil and tries > 0 do gem3 = game.zone:makeEntity(game.level, "object", {type="gem"}, nil, true) tries = tries - 1 end
					if not gem3 then gem3 = rng.percent(50) and gem1 or gem2 end
					print("镶嵌第三颗宝石", gem3.name)
				
				local new_amulet = game.zone:makeEntity(game.level, "object",
					{base_list="mod.class.Object:/data/general/objects/jewelry.lua", type="jewelry", subtype="amulet",
					ignore_material_restriction=true, ego_filter={keep_egos=true, ego_chance=-1000},
					special=function(e) return e.material_level == amulet.material_level end}
					, player.level, true)

					if gem1_item > gem2_item then
						player:removeObject(player:getInven("INVEN"), gem1_item)
						player:removeObject(player:getInven("INVEN"), gem2_item)
					else
						player:removeObject(player:getInven("INVEN"), gem2_item)
						player:removeObject(player:getInven("INVEN"), gem1_item)
					end

					imbueEgo(gem1, new_amulet)  -- Should keywords not be applied here since the item is unique?
					imbueEgo(gem2, new_amulet)
					imbueEgo(gem3, new_amulet)

					new_amulet.name = "Limmir's Amulet of the Moon"
					new_amulet.unique = util.uuid()
					new_amulet:identify(true)
					game.zone:addEntity(game.level, new_amulet, "object")
					player:addObject(player:getInven("INVEN"), new_amulet)
					game.logPlayer(player, "%s creates: %s", npc.name:capitalize(), new_amulet:getName{do_colour=true, no_count=true})
				end end)
			end)
		end)
	end)
end

newChat{ id="welcome",
	text = [[欢迎来我的商店，@playername@。]],
	answers = {
		{"让我看看你卖的东西。", action=function(npc, player)
			npc.store:loadup(game.level, game.zone)
			npc.store:interact(player)
		end, cond=function(npc, player) return npc.store and true or false end},
		{"我在找一些特殊的珠宝。", jump="jewelry"},
		{"据说你可以给项链附魔？", jump="artifact_jewelry", cond=function(npc, player) return npc.can_craft and player:hasQuest("master-jeweler") and player:isQuestStatus("master-jeweler", engine.Quest.COMPLETED, "limmir-survived") end},
		{"我找到了这本手册，看上去好像很重要。", jump="quest", cond=function(npc, player) return npc.can_quest and player:hasQuest("master-jeweler") and player:hasQuest("master-jeweler"):has_tome(player) end},
		{"抱歉，我必须得走了。"},
	}
}

newChat{ id="jewelry",
	text = [[你算找对地方了，我可是一个珠宝专家。
如果你给我找来一颗宝石和一枚没有魔法属性的戒指，我可以帮你把宝石镶嵌到戒指里去。
不过根据不同戒指品质我要收取一小笔费用。你得寻找高品质的戒指和宝石。]],
	answers = {
		{"我需要你的服务。", action=imbue_ring},
		{"暂时不用，谢了。"},
	}
}

newChat{ id="artifact_jewelry",
	text = [[对！感谢你让这个地方从腐化中脱离了出来。我会留在这个岛上学习魔法光环，我会遵守我的诺言帮你制作一枚强力的项链。
给我带来一枚没有魔法属性的项链还有两颗不同属性的宝石，我会利用它们给制作一枚强力的项链。
你帮了我那么多，这次我不收任何费用。不过制作过程中需要镀金工艺，这大约得花费390金币。]],
	answers = {
		{"我需要你的服务。", action=artifact_imbue_amulet},
		{"暂时不用，谢了。"},
	}
}

newChat{ id="quest",
	text = [[#LIGHT_GREEN#*他快速浏览了那本手册，露出了惊讶的表情。*#WHITE# 这真是神奇的发现！太神奇了！
有了这些知识我就能制造更强大的项链了。不过这需要一个特殊的地方来完成制作过程。
传言在南部山脉之中有个地方充满能量。有个古老的传说，当冬月与太阳距离太接近的时候它的一部分从空中掉落了下来并融入了大地，使那个地方充满能量。
在坠落的地方形成了一个湖泊，湖水吸收了万年月光的力量，应该有足够的神力来制作这件艺术品。
去找到那个湖泊，然后使用这个卷轴将我召唤过去，从现在开始我要潜心研修你的这本手册，等待你召唤我的那一刻。]],
	answers = {
		{"我看看能不能找到那个地方。", action=function(npc, player)
			game.level:removeEntity(npc)
			player:hasQuest("master-jeweler"):remove_tome(player)
			player:hasQuest("master-jeweler"):start_search(player)
		end},
	}
}

return "welcome"
