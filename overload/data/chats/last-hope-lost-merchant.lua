-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
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
local q = game.player:hasQuest("lost-merchant")
if q and q:isStatus(q.COMPLETED, "saved") then

local p = game:getPlayer(true)

local trap = p:knowTalentType("cunning/trapping") and not game.state:unlockTalentCheck(player.T_AMBUSH_TRAP, player)
local poison = p:getTalentFromId(p.T_STONING_POISON)
local poison = poison and p:knowTalentType("cunning/poisons") and not p:knowTalent(poison) and p:canLearnTalent(poison)
newChat{ id="welcome",
	text = [[啊, 我 #{italic}#亲爱的#{normal}# 朋友 @playername@!
多亏了你我安全回到了这个伟大的城市！ 我的精品商店过些日子正打算开张营业。不过既然我欠你个人情，要是你需要一些稀有物品的话也许我可以为你提前开张。]]
..((trap or poison) and ("\n顺便一提, "..((trap and "在逃亡过程中我找到了个好点子—— #YELLOW#伏击陷阱#LAST#" or "")
..(poison and (trap and " ，同时在" or "在").. " 我整理货物时, 我发现了一些 #YELLOW#石化毒剂#LAST# ，据说能把生物变成石头。  真正的剧毒!" or ".")).."\nY你应该会对它感兴趣吧?") or "")
..((game.state:isAdvanced() and "\n噢我的好朋友，我告诉过你我可以为你打造一件真正的 #{italic}#史诗#{normal}# 物品，专门为你量身定做哦，而且价格非常公道..." or "\n我准备为最有眼光的那位顾客提供一件真正独特的服务。如果你过会儿回来，我将做好充分准备后给你一个大大的惊喜。而且价格绝对#{italic}#公道#{normal}#哦！当然！")),
	answers = {
		{"好吧，让我看看你的货物。", action=function(npc, player)
			npc.store:loadup(game.level, game.zone)
			npc.store:interact(player)
		end},
		{"不如说说那个特殊物品？", cond=function(npc, player) return game.state:isAdvanced() end, jump="unique1"},
		{"闪光陷阱？听上去很不错.", cond=function(npc, player) return trap end, jump="trap"},
		{"石化毒素?", cond=function(npc, player) return poison end, jump="poison"},
		{"抱歉，我得走了！"},
	}
}

newChat{ id="trap",
	text = [[你要知道，我问遍了每个地方都没发现有相同的东西。
	不过，既然你救了我的命，给我3000金币我就把它转让给你。这可是很划算的！]],
	answers = {
		{"虽然很贵，不过我要了.", cond=function(npc, player) return player.money >= 3000 end, jump="traplearn"},
		{"..."},
	}
}

newChat{ id="traplearn",
	text = [[和你做生意真愉快!]],
	answers = {
		{"谢了.", action=function(npc, player)
			game.state:unlockTalent(player.T_AMBUSH_TRAP, player)
			player:incMoney(-3000)
		end},
	}
}

newChat{ id="poison",
	text = [[Ungrol发现这种物质含有某些稀有成分，.
“比毒药还要毒” ，但他没钱买下来。 基于我们的良好关系，我很愿意卖给你，#{italic}#只需要#{normal}# -- 1500 金币!]],
	answers = {
		{"有点贵，不过应该能派上用场。我要了!", cond=function(npc, player) return player.money >= 1500 end, jump="poisonlearn"},
		{"这个价格 ... 还是算了吧..."},
	}
}

newChat{ id="poisonlearn",
	text = [[给你了。别洒在自己身上了!]],
	answers = {
		{"谢了.", action=function(npc, player)
			player:incMoney(-1500)
			player:learnTalent(player.T_STONING_POISON, true, 1)
		end},
	}
}

newChat{ id="unique1",
	text = [[对于这项服务，只有到了合理的价位我才会愿意提供给别人，不过对你，我的朋友，我准备给你打个20%的折扣—— #{italic}#只要#{normal}# 4000 金币就可以打造一个真真正正你特有的装备哦，怎么样？]],
	answers = {
		{"什么？这点小钱无所谓，赶紧给我弄出来吧！", cond=function(npc, player) return player.money >= 10000 end, jump="make"},
		{"好的，请吧。", cond=function(npc, player) return player.money >= 4000 end, jump="make"},
		{"多少钱？！呃……抱歉，我……我得出去呼吸一下新鲜空气……", cond=function(npc, player) return player.money < 500 end},
		{"现在不用，再见。"},
	}
}

local maker_list = function()
	local mainbases = {
		防具 = {
			"elven-silk robe",
			"drakeskin leather armour",
			"voratun mail armour",
			"voratun plate armour",
			"elven-silk cloak",
			"drakeskin leather gloves",
			"voratun gauntlets",
			"elven-silk wizard hat",
			"drakeskin leather cap",
			"voratun helm",
			"pair of drakeskin leather boots",
			"pair of voratun boots",
			"drakeskin leather belt",
			"voratun shield",
		},
		武器 = {
			"voratun battleaxe",
			"voratun greatmaul",
			"voratun greatsword",
			"voratun waraxe",
			"voratun mace",
			"voratun longsword",
			"voratun dagger",
			"living mindstar",
			"quiver of dragonbone arrows",
			"dragonbone longbow",
			"drakeskin leather sling",
			"dragonbone staff",
			"pouch of voratun shots",
		},
		杂项 = {
			"voratun ring",
			"voratun amulet",
			"dwarven lantern",
			"voratun pickaxe",
			{ "dragonbone wand","龙骨魔杖"},
			{"dragonbone totem","龙骨图腾"},
			{ "voratun torque","沃瑞坦项圈" },
		},
	}
	local l = {{"我决定不买了。", jump = "welcome"}}
	for kind, bases in pairs(mainbases) do
		l[#l+1] = {kind:capitalize(), action=function(npc, player)
			local l = {{"算了，我不买了。", jump = "welcome"}}
			newChat{ id="makereal",
				text = [[你想要哪一种物品？]],
				answers = l,
			}

			for i, name in ipairs(bases) do
				local dname = nil
				if type(name) == "table" then name, dname = name[1], name[2] end
				local not_ps, force_themes
				not_ps = game.state:attrPowers(player) -- make sure randart is compatible with player
				if not_ps.arcane then force_themes = {'antimagic'} end
				
				local o, ok
				local tries = 100
				repeat
					o = game.zone:makeEntity(game.level, "object", {name=name, ignore_material_restriction=true, no_tome_drops=true, ego_filter={keep_egos=true, ego_chance=-1000}}, nil, true)
					if o then ok = true end
					if o and not game.state:checkPowers(player, o, nil, "antimagic_only") then
						ok = false o = nil 
					end
					tries = tries - 1
				until ok or tries < 0
				if o then
					if not dname then dname = o:getName{force_id=true, do_color=true, no_count=true}
					else dname = "#B4B4B4#"..o:getDisplayString()..dname.."#LAST#" end
					l[#l+1] = {dname, action=function(npc, player)
						local art, ok
						local nb = 0
						repeat
							art = game.state:generateRandart{base=o, lev=70, egos=4, force_themes=force_themes, forbid_power_source=not_ps}
							if art then ok = true end
							if art and not game.state:checkPowers(player, art, nil, "antimagic_only") then
								ok = false
							end
							nb = nb + 1
							if nb == 40 then break end
						until ok
						if art and nb < 40 then
							art:identify(true)
							player:addObject(player.INVEN_INVEN, art)
							player:incMoney(-4000)
							-- clear chrono worlds and their various effects
							if game._chronoworlds then
								game.log("#CRIMSON#Your timetravel has no effect on pre-determined outcomes such as this.")
								game._chronoworlds = nil
							end
							if not config.settings.cheat then game:saveGame() end

							newChat{ id="naming",
								text = "你想给你的装备取名吗？\n"..tostring(art:getTextualDesc()),
								answers = {
									{"是的。", action=function(npc, player)
										local d = require("engine.dialogs.GetText").new("给你的装备起名", "名字", 2, 40, function(txt)
											art.name = txt:removeColorCodes():gsub("#", " ")
											game.log("#LIGHT_BLUE#The merchant carefully hands you: %s", art:getName{do_color=true})
										end, function() game.log("#LIGHT_BLUE#The merchant carefully hands you: %s", art:getName{do_color=true}) end)
										game:registerDialog(d)
									end},
									{"不，谢谢。", action=function() game.log("#LIGHT_BLUE#The merchant carefully hands you: %s", art:getName{do_color=true}) end},
								},
							}
							return "naming"
						else
							newChat{ id="oups",
								text = "啊真抱歉，这东西我们可做不了。",
								answers = {
									{"好吧，我们试试别的东西。", jump="make"},
									{"好吧，以后再说。"},
								},
							}
							return "oups"
						end
					end}
				end
			end

			return "makereal"
		end}
	end
	return l
end

newChat{ id="make",
	text = [[你喜欢什么类型的装备？]],
	answers = maker_list(),
}

else

newChat{ id="welcome",
	text = [[*这个商店好像还没开张。*]],
	answers = {
		{"[离开]"},
	}
}

end

return "welcome"
