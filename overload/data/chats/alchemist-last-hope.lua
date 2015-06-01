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

local art_list = mod.class.Object:loadList("/data/general/objects/brotherhood-artifacts.lua")
local alchemist_num = 4
local other_alchemist_nums = {1, 2, 3}
local q = game.player:hasQuest("brotherhood-of-alchemists")
local final_reward = "TAINT_TELEPATHY"
local e = {
	{
	short_name = "brawn",
	name = "蛮牛药剂",
	id = "ELIXIR_BRAWN",
	start = "brawn_start",
	almost = "brawn_almost_done",
	full = "elixir_of_brawn",
	full_2 = "elixir_of_stoneskin",
	full_3 = "elixir_of_foundations",
	poached = "brawn_poached",
	},
	{
	short_name = "stoneskin",
	name = "石肤药剂",
	id = "ELIXIR_STONESKIN",
	start = "stoneskin_start",
	almost = "stoneskin_almost_done",
	full = "elixir_of_stoneskin",
	full_2 = "elixir_of_brawn",
	full_3 = "elixir_of_foundations",
	poached = "stoneskin_poached",
	},
	{
	short_name = "foundations",
	name = "领悟药剂",
	id = "ELIXIR_FOUNDATIONS",
	start = "foundations_start",
	almost = "foundations_almost_done",
	full = "elixir_of_foundations",
	full_2 = "elixir_of_brawn",
	full_3 = "elixir_of_stoneskin",
	poached = "foundations_poached",
	},
}

--cond function for turning in non-final elixirs
--checks that player has quest and elixir ingredients, hasn't completed it yet, has started that elixir, and hasn't completed both other elixirs since that would make this the last one:
local function turn_in(npc, player, n) -- n is the index of the elixir we're checking on
	return q and q:check_ingredients(player, e[n].short_name, n) -- make sure we have the quest and the elixir's ingredients
	and not q:isCompleted(e[n].almost) and not q:isCompleted(e[n].full) --make sure we haven't finished the quest already
	and q:isCompleted(e[n].start) --make sure we've been given the task to make this elixir
	and not (q:isCompleted(e[n].full_2) and q:isCompleted(e[n].full_3)) --make sure we haven't already finished both the other elixirs, since that would make this the final one which requires a special dialog.
end

--cond function for turning in final elixir with index n
--checks that player has quest and elixir ingredients, hasn't completed it yet, has started that elixir, and both the other elixirs are done
local function turn_in_final(npc, player, n) -- n is the index of the elixir we're checking on
	return q and q:check_ingredients(player, e[n].short_name, n) -- make sure we have the quest and the elixir's ingredients
	and not q:isCompleted(e[n].almost) and not q:isCompleted(e[n].full) --make sure we haven't finished the quest already
	and q:isCompleted(e[n].start) --make sure we've been given the task to make this elixir
	and (q:isCompleted(e[n].full_2) and q:isCompleted(e[n].full_3)) --make sure the other two elixirs are made, thus making this the final turn-in
end

--cond function for turning in poached (completed by somebody besides you) elixirs
--checks that the player has the quest and elixir ingredients, hasn't turned it in, the task is complete anyway, the task has actually been started, and that it's been poached
local function turn_in_poached(npc, player, n) -- n is the index of the elixir we're checking on
	return q and q:check_ingredients(player, e[n].short_name, n) -- make sure we have the quest and the elixir's ingredients
	and not q:isCompleted(e[n].almost) --make sure we haven't turned it in already
	and q:isCompleted(e[n].full) --make sure that, even though we haven't turned it in, the elixir has been made for this alchemist
	and q:isCompleted(e[n].start) --make sure we've been given the task to make this elixir
	and q:isCompleted(e[n].poached)  --make sure this task has been poached
end

local function more_aid(npc, player)
	return not (q:isCompleted(e[1].full) and q:isCompleted(e[2].full) and q:isCompleted(e[3].full)) --make sure all the elixirs aren't already made
	--Next, for each of the three elixirs, make sure it's not the case that we're still working on it
	and not (q:isCompleted(e[1].start) and not q:isCompleted(e[1].full))
	and not (q:isCompleted(e[2].start) and not q:isCompleted(e[2].full))
	and not (q:isCompleted(e[3].start) and not q:isCompleted(e[3].full))
end

local function give_bits(npc, player, n) -- n is the index of the elixir we're checking on
	return q and q:check_ingredients(player, e[n].short_name) -- make sure we have the quest and the elixir's ingredients
	and q:isCompleted(e[n].start) --make sure we've started the task
	and not q:isCompleted(e[n].full) --... but not finished
end

local function empty_handed(npc, player, n) -- n is the index of the elixir we're checking on
	return q and q:check_ingredients(player, e[n].short_name, n) -- make sure we have the quest and the elixir's ingredients
	and q:isCompleted(e[n].start) --make sure we've started the task
	and not q:isCompleted(e[n].almost) --make sure we've not turned the stuff in before...
	and q:isCompleted(e[n].full)  --... and yet the elixir is already made (poached!)
end

--Make the alchemist's reaction to your turn-in vary depending on whether he lost.
local function alchemist_reaction_complete(npc, player, lose, other_alch, other_elixir)
	if lose == true then
		return ([[见鬼，你来的太晚了，%s 已经完成了，不过我想你已经尽力了，所以我还是会完成这桩交易，把材料给我吧。]]):format(other_alch)
	else
		return ([[干的好！而且你完好无损地回来了。很好，这和我费尽心思做好一瓶特效药剂的感觉一样好。我已经激动的不能自已了！哦对了，你不在的时候有一只小鸟告诉我说 %s 已经制造了 %s 。别让他超过我！]]):format(other_alch, other_elixir)
	end
end

if not q or (q and not q:isCompleted(e[1].start) and not q:isCompleted(e[2].start) and not q:isCompleted(e[3].start)) then

-- Here's the dialog that pops up if the player has never worked for this alchemist before:
newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*一位穿着肮脏破旧锁甲的矮人开了门。*#WHITE#
说！你是不是对收钱帮人搜集材料感兴趣？]],
	answers = {
		{"对！", jump="ominous"},
		{"[离开]"},
	}
}

newChat{ id="ominous",
	text = [[感谢上帝，我喜欢冒险者，我正准备自己也去当个冒险者时被它打了一下，呃……我说的“它”其实是指我老婆，哈！]],
	answers = {
		{"你打算怎么做？", jump="proposal"},
	}
}

newChat{ id="proposal",
	text = [[我的想法就是，我给你怪物物品清单，然后你给我把它们都找回来。然后我用这些材料做一些很炫的药剂，之后我就可以加入炼金术士兄弟会了。]],
	answers = {
		{"听上去是一个不错的计划。", jump="help"},
	}
}

newChat{ id="help",
	text = [[这可是一个极好的计划，而这些药剂，好吧，显然如果我加入炼金术士兄弟会的话，他们一定会称我的这些为“万能药”，我会照他们说的话去做的，因为他们自有他们的一套办法让我不得不服从他们的命令……那……我们刚说到哪儿了？]],
	answers = {
		{"帮你加入那个什么什么兄弟会……我能得到什么回报？", jump="competition"},
	}
}

newChat{ id="competition",
	text = [[很简单，每份药剂我都会让你先喝个痛快的。喝下这些药剂会让你更有男子汉气概，而且，要是你的帮助能起决定性作用的话，我还会额外给你一件真正的宝物：传说中马基埃亚尔唯一的堕落印记——感应印记哦！]],
	answers = {
		{"我接受了。", jump="choice", action = function(npc, player) player:grantQuest("brotherhood-of-alchemists") end,},
		{"我现在没空帮你。"},
	}
}

newChat{ id="choice",
	text = [[最后一件事，除我之外还有几个家伙对炼金术士兄弟会的这个会员资格虎视眈眈，他们肯定不希望我来坐这个位置的，因此你越快动身越好。现在，你选择帮我完成哪个药剂吧：蛮牛药剂？石肤药剂？还是领悟药剂？最好马上行动，我建议。]],
	answers = {
		{e[1].name..".", jump="list",
			cond = function(npc, player) return not game.player:hasQuest("brotherhood-of-alchemists"):isCompleted(e[1].full) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[1].start)
				game.player:hasQuest("brotherhood-of-alchemists"):update_needed_ingredients(player)
			end,
			on_select=function(npc, player)
				local o = art_list[e[1].id]
				o:identify(true)
				game.tooltip_x, game.tooltip_y = 1, 1
				game:tooltipDisplayAtMap(game.w, game.h, tostring(o:getDesc()))
			end,
		},
		{e[2].name..".", jump="list",
			cond = function(npc, player) return not game.player:hasQuest("brotherhood-of-alchemists"):isCompleted(e[2].full) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[2].start)
				game.player:hasQuest("brotherhood-of-alchemists"):update_needed_ingredients(player)
			end,
			on_select=function(npc, player)
				local o = art_list[e[2].id]
				o:identify(true)
				game.tooltip_x, game.tooltip_y = 1, 1
				game:tooltipDisplayAtMap(game.w, game.h, tostring(o:getDesc()))
			end,
		},
		{e[3].name..".", jump="list",
			cond = function(npc, player) return not game.player:hasQuest("brotherhood-of-alchemists"):isCompleted(e[3].full) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[3].start)
				game.player:hasQuest("brotherhood-of-alchemists"):update_needed_ingredients(player)
			end,
			on_select=function(npc, player)
				local o = art_list[e[3].id]
				o:identify(true)
				game.tooltip_x, game.tooltip_y = 1, 1
				game:tooltipDisplayAtMap(game.w, game.h, tostring(o:getDesc()))
			end,
		},
		{"[离开]"},
	}
}

if npc.errand_given then
newChat{ id="list",
	text = [[OK，这里是材料的清单。哦对了，另外还有一件事，有几个家伙已经出发帮我找这些材料了，我一视同仁，要是其中有人先把材料找到给我带来的话，那你就只能自认倒霉了，动作快点吧。]],
	answers = {
		{"那我走了。"},
	}
}
else
newChat{ id="list",
	text = [[OK，这里是材料的清单。哦对了，另外还有一件事，有几个家伙已经出发帮我找这些材料了，我一视同仁，要是其中有人先把材料找到给我带来的话，那你就只能自认倒霉了，动作快点吧。

哦，对了，最后还有另外一件事……不知道你感不感兴趣，不过这件事可没有报酬的。]],
	answers = {
		{"好吧，我看看我能不能帮上忙。", jump="errand", action=function(npc, player) npc.errand_given = true end},
		{"我可不白干，不是给你做跑腿的，现在拿到材料清单了我会去搞定，别的事情就算了。", action=function(npc, player) npc.errand_given = true end},
	}
}
end

-- Quest is complete; nobody answers the door
elseif q and q:isStatus(q.DONE) then
newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*门锁住了，没人注意到你的敲门声。*#WHITE#]],
	answers = {
		{"[离开]"},
	}
}


else -- Here's the dialog that pops up if the player *has* worked with this alchemist before (either done quests or is in the middle of one):

local other_alch, other_elixir, player_loses, alch_picked, e_picked = require "data-chn123.quests.brotherhood-of-alchemists".competition(q, player, other_alchemist_nums)

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*那个穿锁甲的矮人打开了门。*#WHITE#
啊～我亲爱的冒险家。]],
	answers = {
		-- If not the final elixir:
		{"我回来了，我找到了"..e[1].name..".", jump="complete",
			cond = function(npc, player) return turn_in(npc, player, 1) end,
			action = function(npc, player)
				q:on_turnin(player, alch_picked, e_picked, false)
			end,
		},
		{"我回来了，我找到了"..e[2].name.."的材料。", jump="complete",
			cond = function(npc, player) return turn_in(npc, player, 2) end,
			action = function(npc, player)
				q:on_turnin(player, alch_picked, e_picked, false)
			end,
		},
		{"我回来了，我找到了"..e[3].name.."的材料。", jump="complete",
			cond = function(npc, player) return turn_in(npc, player, 3) end,
			action = function(npc, player)
				q:on_turnin(player, alch_picked, e_picked, false)
			end,
		},

		-- If the final elixir:
		{"我回来了，我找到了"..e[1].name.."的材料。", jump="totally-complete",
			cond = function(npc, player) return turn_in_final(npc, player, 1) end,
		},
		{"我回来了，我找到了"..e[2].name.."的材料。", jump="totally-complete",
			cond = function(npc, player) return turn_in_final(npc, player, 2) end,
		},
		{"我回来了，我找到了"..e[3].name.."的材料。", jump="totally-complete",
			cond = function(npc, player) return turn_in_final(npc, player, 3) end,
		},

		-- If the elixir got made while you were out:
		{"我回来了，我找到了"..e[1].name.."的材料。", jump="poached",
			cond = function(npc, player) return turn_in_poached(npc, player, 1) end,
		},
		{"我回来了，我找到了"..e[2].name.."的材料。", jump="poached",
			cond = function(npc, player) return turn_in_poached(npc, player, 2) end,
		},
		{"我回来了，我找到了"..e[3].name.."的材料。", jump="poached",
			cond = function(npc, player) return turn_in_poached(npc, player, 3) end,
		},

		--Don't let player work on multiple elixirs for the same alchemist.
		--See comments in more_aid function above for all the gory detail
		{"我来接下一步任务。", jump="choice",
			cond = function(npc, player) return more_aid(npc, player) end,
		},
		{"[离开]"},
	}
}

--Not final elixir:
newChat{ id="complete",
	text = alchemist_reaction_complete(npc, player, player_loses, other_alch, other_elixir),
	answers = {
		{"[给他材料。]", jump="complete2",
			cond = function(npc, player) return give_bits(npc, player, 1) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[1].almost)
				q:remove_ingredients(player, e[1].short_name, 1)
			end
		},
		{"[给他材料。]", jump="complete2",
			cond = function(npc, player) return give_bits(npc, player, 2) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[2].almost)
				q:remove_ingredients(player, e[2].short_name, 2)
			end
		},
		{"[给他材料。]", jump="complete2",
			cond = function(npc, player) return give_bits(npc, player, 3) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[3].almost)
				q:remove_ingredients(player, e[3].short_name, 3)
			end
		},
--		{"Sorry, it seems I lack some stuff. I will be back."},
	}
}

--Final elixir:
newChat{ id="totally-complete",
	text = [[#LIGHT_GREEN#*他欢快地拍着你的肩膀。*#WHITE#
哈哈！这可是最后一件！斯泰尔和马鲁斯还有那个该死的隐士只能舔我的胡子了，还有我老婆也是！对没错，我知道你能听见！干得好伙计，我们开始完成它吧。]],
	answers = {
		{"[给他材料。]", jump="totally-complete2",
			cond = function(npc, player) return give_bits(npc, player, 1) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[1].almost)
				q:remove_ingredients(player, e[1].short_name, 1)
			end
		},
		{"[给他材料。]", jump="totally-complete2",
			cond = function(npc, player) return give_bits(npc, player, 2) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[2].almost)
				q:remove_ingredients(player, e[2].short_name, 2)
			end
		},
		{"[给他材料。]", jump="totally-complete2",
			cond = function(npc, player) return give_bits(npc, player, 3) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[3].almost)
				q:remove_ingredients(player, e[3].short_name, 3)
			end
		},
		--{"Sorry, it seems I lack some stuff. I will be back."},
	}
}

--Not final elixir:
newChat{ id="complete2",
	text = [[别走开，给我一个小时的时间去做药剂。]],
	answers = {
		{"[等待]", jump="complete3"},

	}
}

--Final Elixir:
newChat{ id="totally-complete2",
	text = [[我本来想请你进来等的，不过我老婆在这里所以……我发觉我有点喜欢你了。]],
	answers = {
		{"[等待]", jump="totally-complete3"},

	}
}

--Not final elixir:
newChat{ id="complete3",
	text = [[#LIGHT_GREEN#*那个矮人回来了，手里拿着个药瓶。*#WHITE#
尝上去像厄洛克的小便……不过总算完成了。]],
	answers = {
		{"谢了，我走了。",
			cond = function(npc, player) return q and q:isCompleted(e[1].almost) and not q:isCompleted(e[1].full) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[1].full)
				q:reward(player, e[1].id)
				q:update_needed_ingredients(player)
			end
		},
		{"谢了，我走了。",
			cond = function(npc, player) return q and q:isCompleted(e[2].almost) and not q:isCompleted(e[2].full) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[2].full)
				q:reward(player, e[2].id)
				q:update_needed_ingredients(player)
			end
		},
		{"谢了，我走了。",
			cond = function(npc, player) return q and q:isCompleted(e[3].almost) and not q:isCompleted(e[3].full) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[3].full)
				q:reward(player, e[3].id)
				q:update_needed_ingredients(player)
			end
		},
	}
}

--Final elixir:
newChat{ id="totally-complete3",
	text = [[#LIGHT_GREEN#*那个矮人终于回来了，手里拿着一个药瓶和一个小袋子。*#WHITE#
这里面我给你带来个好东西，尽管也许明天早上对你没什么用。小心使用这个“感应印记”,如果下次你敲门的时候，是我老婆开门的话，你可要小心点，哈！]],
	answers = {
		{"多谢，我走了。",
			cond = function(npc, player) return q and q:isCompleted(e[1].almost) and not q:isCompleted(e[1].full) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[1].full)
				q:reward(player, e[1].id)
				q:reward(player, final_reward)
				q:update_needed_ingredients(player)
				q:winner_is(player, alchemist_num)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.DONE)

			end
		},
		{"多谢，我走了。",
			cond = function(npc, player) return q and q:isCompleted(e[2].almost) and not q:isCompleted(e[2].full) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[2].full)
				q:reward(player, e[2].id)
				q:reward(player, final_reward)
				q:update_needed_ingredients(player)
				q:winner_is(player, alchemist_num)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.DONE)
			end
		},
		{"多谢，我走了。",
			cond = function(npc, player) return q and q:isCompleted(e[3].almost) and not q:isCompleted(e[3].full) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[3].full)
				q:reward(player, e[3].id)
				q:reward(player, final_reward)
				q:update_needed_ingredients(player)
				q:winner_is(player, alchemist_num)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.DONE)
			end
		},
	}
}

newChat{ id="choice",
	text = [[祝福你我的冒险家，你选择哪一个？]],
	answers = {
		{e[1].name..".", jump="list",
			cond = function(npc, player) return not q:isCompleted(e[1].full) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[1].start)
				q:update_needed_ingredients(player)
			end,
			on_select=function(npc, player)
				local o = art_list[e[1].id]
				o:identify(true)
				game.tooltip_x, game.tooltip_y = 1, 1
				game:tooltipDisplayAtMap(game.w, game.h, tostring(o:getDesc()))
			end,
		},
		{e[2].name..".", jump="list",
			cond = function(npc, player) return not q:isCompleted(e[2].full) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[2].start)
				q:update_needed_ingredients(player)
			end,
			on_select=function(npc, player)
				local o = art_list[e[2].id]
				o:identify(true)
				game.tooltip_x, game.tooltip_y = 1, 1
				game:tooltipDisplayAtMap(game.w, game.h, tostring(o:getDesc()))
			end,
		},
		{e[3].name..".", jump="list",
			cond = function(npc, player) return not q:isCompleted(e[3].full) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[3].start)
				q:update_needed_ingredients(player)
			end,
			on_select=function(npc, player)
				local o = art_list[e[3].id]
				o:identify(true)
				game.tooltip_x, game.tooltip_y = 1, 1
				game:tooltipDisplayAtMap(game.w, game.h, tostring(o:getDesc()))
			end,
		},
		{"[离开]"},
	}
}

if npc.errand_given then
newChat{ id="list",
	text = [[这里有材料清单，祝你好运！]],
	answers = {
		{"我走了。"},
	}
}
else
newChat{ id="list",
	text = [[这里有材料清单，祝你好运！

哦，对了，最后还有另外一件事。。。。 另外还有一件差事不知道你感不感兴趣，不过这件事可没有报酬的。]],
	answers = {
		{"好吧，我看看我能不能帮上什么忙。", jump="errand", action=function(npc, player) npc.errand_given = true end},
		{"我可不白干，不是给你做跑腿的，现在拿到材料清单了我会去搞定，别的事情就算了。", action=function(npc, player) npc.errand_given = true end},
	}
}
end

-- If the elixir got made while you were out:
newChat{ id="poached",
	text = [[呃。。好像你不在的时候，已经有人把材料给我弄来了，我不会再给你奖励了。很抱歉，不过时间才是最重要的，“先来者先得”，你得记住这句话。]],
	answers = {
		{"哼。。。",
			cond = function(npc, player) return empty_handed(npc, player, 1) end,
			action = function(npc, player)
				q:remove_ingredients(player, e[1].short_name, 1)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[1].almost)
				q:update_needed_ingredients(player)
			end,
		},
		{"哼。。。",
			cond = function(npc, player) return empty_handed(npc, player, 2) end,
			action = function(npc, player)
				q:remove_ingredients(player, e[2].short_name, 2)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[2].almost)
				q:update_needed_ingredients(player)
			end,
		},
		{"哼。。。",
			cond = function(npc, player) return empty_handed(npc, player, 3) end,
			action = function(npc, player)
				q:remove_ingredients(player, e[3].short_name, 3)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[3].almost)
				q:update_needed_ingredients(player)
			end,
		},
	}
}

end

newChat{ id="errand",
	text = [[好吧，事情是这样的，我老婆的一个朋友最近失踪了。她是一个实习炼金术士，叫做塞莉娅。最近他丈夫去世了，这件事让她悲痛欲绝。她每天会到她丈夫的坟墓那里去，直到有一天她一去不回。我个人认为她没了她丈夫活不下去。她们两人形影不离。要是你途经东边的墓园的话你能不能去查看一下。。。你懂的。

我很奇怪死亡到底会对别人产生什么影响，它又是怎样占据人的内心世界的。有时候他们甚至忘了活着才是最重要的。。。她丈夫的葬礼举行的很庄重。]],
	answers = {
		{"我会去尽力的。", action=function(npc, player)
			game:onLevelLoad("wilderness-1", function(zone, level)
				local g = game.zone:makeEntityByName(level, "terrain", "LAST_HOPE_GRAVEYARD")
				local spot = level:pickSpot{type="zone-pop", subtype="last-hope-graveyard"}
				game.zone:addEntity(level, g, "terrain", spot.x, spot.y)
				game.nicer_tiles:updateAround(game.level, spot.x, spot.y)
				game.state:locationRevealAround(spot.x, spot.y)
			end)
			game.log("He points out the location of the graveyard on your map.")
			player:grantQuest("grave-necromancer")
		end},
	}
}

return "welcome"
