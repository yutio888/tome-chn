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
local alchemist_num = 1
local other_alchemist_nums = {2, 3, 4}
local q = game.player:hasQuest("brotherhood-of-alchemists")
local final_reward = "LIFEBINDING_EMERALD"
local e = {
	{
	short_name = "fox",
	name = "狡诈药剂",
	id = "ELIXIR_FOX",
	start = "fox_start",
	almost = "fox_almost_done",
	full = "elixir_of_the_fox",
	full_2 = "elixir_of_avoidance",
	full_3 = "elixir_of_precision",
	poached = "fox_poached",
	},
	{
	short_name = "avoidance",
	name = "闪避药剂",
	id = "ELIXIR_AVOIDANCE",
	start = "avoidance_start",
	almost = "avoidance_almost_done",
	full = "elixir_of_avoidance",
	full_2 = "elixir_of_the_fox",
	full_3 = "elixir_of_precision",
	poached = "avoidance_poached",
	},
	{
	short_name = "precision",
	name = "精准药剂",
	id = "ELIXIR_PRECISION",
	start = "precision_start",
	almost = "precision_almost_done",
	full = "elixir_of_precision",
	full_2 = "elixir_of_the_fox",
	full_3 = "elixir_of_avoidance",
	poached = "precision_poached",
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
		return ([[额哦……你来的太晚了， %s 已经完成了。不过这些东西给你也没什么坏处， 虽然……你本不应该得到这些奖励。]]):format(other_alch)
	else
		return ([[啊，好极了，如果你愿意，请交给我吧，要知道你离开的那么长时间里，%s 已经制造了 %s。如果他抢了我的位置，我估计我就要被解雇了。]]):format(other_alch, other_elixir)
	end
end

if not q or (q and not q:isCompleted(e[1].start) and not q:isCompleted(e[2].start) and not q:isCompleted(e[3].start)) then

-- Here's the dialog that pops up if the player has never worked for this alchemist before:
newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*一个穿着一尘不染白缎面长袍的人打开了门，他上下打量着你。*#WHITE#
啊，一个冒险者，我正好在考虑是不是要重新找个人帮忙。]],
	answers = {
		{"听上去不错，但总有种不祥的预感……", jump="ominous"},
		{"[离开]"},
	}
}

newChat{ id="ominous",
	text = [[的确，你帮我完成这件事的话我会好好报答你，不过这个任务很危险。事实上，前面三个接受任务的人到目前为止还没有一个活着回来。]],
	answers = {
		{"那……你的建议呢？", jump="proposal"},
	}
}

newChat{ id="proposal",
	text = [[非常好，我是一个炼金术师，水平很高超的那种O(∩_∩)O~。今年，炼金术士兄弟会第一次邀请我成为他们的会员。加入的条件……我就不多啰嗦了，估计你也不想听，反正复杂的很，我都快累死了。幸好，我现在就剩下三件事没办了。]],
	answers = {
		{"我怎么帮你？", jump="help"},
	}
}

newChat{ id="help",
	text = [[我需要一些材料来制作三瓶药剂。很显然，既然我找你帮忙，那么，想简单从那些草药师那里搞到这些材料是几乎不可能的。没错，你得从这些材料的拥有者那里强行搞来，当然你免不了一场大战。我曾经试图说服一位娜迦把它的舌头给我……哈！我偶尔会开开玩笑。]],
	answers = {
		{"对于从怪物身上把你要的东西给活剥下来，我可是个行家，但是我能得到什么好处？", jump="competition"},
	}
}

newChat{ id="competition",
	text = [[什么？我会和你分享我的劳动成果！三瓶药剂每个我都会制造三份：一份给自己，一份给炼金术士兄弟会交差，而另外一份给你。必须告诉你的是，时间非常紧迫，我不是今年炼金术士兄弟会邀请的唯一一个，只有第一个完成他们要求的人才会被接受。据我所知，至少还有三个人在抢我这个位置。如果你帮我成功入会的话，除了药剂之外，我还有更好的东西回报你。我有一块古老的生命宝石，合理使用可以大大增强你的治疗能力。怎么样，有兴趣么？]],
	answers = {
		{"我接受了。", jump="choice", action = function(npc, player) player:grantQuest("brotherhood-of-alchemists") end,},
		{"我现在没空帮你。"},
	}
}

newChat{ id="choice",
	text = [[好极了，那么，我有三瓶药剂要制造，不过每次我只给你一项任务，一次给你超负荷的任务对你可没有任何好处。你自己选一个吧：狡诈药剂，能让你像一只狐狸一般灵活；闪避药剂，能提高你躲避伤害的能力；精准药剂，能让你对敌人的弱点了如指掌。你选择哪一个？]],
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

newChat{ id="list",
	text = [[这里有一张配方，上面写着我目前缺少的材料。当心别丢了你的小命，要是我错过这次机会就得等明年了。哦，我记得好像提醒过你，已经有几个冒险者出发去帮我弄这些材料了，一会你出去之后达利或者他们之中的一个估计要来领取奖励了。]],
	answers = {
		{"我马上出发。"},
	}
}

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
	text = [[#LIGHT_GREEN#*炼金师打开了门。*#WHITE#
啊，你回来了。]],
	answers = {
		-- If not the final elixir:
		{"我回来了，我找到了"..e[1].name.."的材料。", jump="complete",
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
--		{"抱歉，我好想还没找全，我马上回来。"},
	}
}

--Final elixir:
newChat{ id="totally-complete",
	text = [[#LIGHT_GREEN#*炼金师看到材料有点急不可耐，他咧着嘴开心的笑了起来。*#WHITE#
好极了！简直棒极了！这可是最后一步！来来来，把它们给我吧。]],
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
	text = [[在这儿等着，我去制作药剂，一小时内我会把东西弄好，当然还有你的奖励。]],
	answers = {
		{"[等待]", jump="complete3"},

	}
}

--Final Elixir:
newChat{ id="totally-complete2",
	text = [[最后稍等一下，我的冒险家朋友，马上我会带着你的两份奖励回来，哈哈终于大功告成啦！]],
	answers = {
		{"[等待]", jump="totally-complete3"},

	}
}

--Not final elixir:
newChat{ id="complete3",
	text = [[#LIGHT_GREEN#*炼金师终于回来了，他递给你一个精致的小玻璃瓶。*#WHITE#
享用你的奖励吧。]],
	answers = {
		{"谢谢，我走了。",
			cond = function(npc, player) return q and q:isCompleted(e[1].almost) and not q:isCompleted(e[1].full) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[1].full)
				q:reward(player, e[1].id)
				q:update_needed_ingredients(player)
			end
		},
		{"谢谢，我走了。",
			cond = function(npc, player) return q and q:isCompleted(e[2].almost) and not q:isCompleted(e[2].full) end,
			action = function(npc, player)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[2].full)
				q:reward(player, e[2].id)
				q:update_needed_ingredients(player)
			end
		},
		{"谢谢，我走了。",
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
	text = [[#LIGHT_GREEN#*炼金师终于回来了，手里拿着一颗翡翠宝石和一个药水瓶。*#WHITE#
尽情享用你的劳动成果吧，我的冒险家。为了表示我的敬意，我准备给我的新作品取名为……呃……你叫什么名字？哈哈，开个玩笑，啊～在我被喜悦冲昏头脑之前，我必须得继续我的工作，那么，再见了我的朋友。]],
	answers = {
		{"谢谢，我走了。",
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
		{"谢谢，我走了。",
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
		{"谢谢，我走了。",
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
	text = [[好极了，你准备帮我做哪一个？]],
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

newChat{ id="list",
	text = [[这里有一张配方，上面写着我目前缺少的材料。当心别丢了你的小命，要是我错过这次机会就得等明年了。]],
	answers = {
		{"我走了。"},
	}
}

-- If the elixir got made while you were out:
newChat{ id="poached",
	text = [[非常抱歉，我已经自己把那些药剂都做好了，我可没理由再给你任何奖励。]],
	answers = {
		{"哼……",
			cond = function(npc, player) return empty_handed(npc, player, 1) end,
			action = function(npc, player)
				q:remove_ingredients(player, e[1].short_name, 1)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[1].almost)
				q:update_needed_ingredients(player)
			end,
		},
		{"哼……",
			cond = function(npc, player) return empty_handed(npc, player, 2) end,
			action = function(npc, player)
				q:remove_ingredients(player, e[2].short_name, 2)
				player:setQuestStatus("brotherhood-of-alchemists", engine.Quest.COMPLETED, e[2].almost)
				q:update_needed_ingredients(player)
			end,
		},
		{"哼……",
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

return "welcome"
