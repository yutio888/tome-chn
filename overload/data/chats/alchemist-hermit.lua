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
local alchemist_num = 3
local other_alchemist_nums = {1, 2, 4}
local q = game.player:hasQuest("brotherhood-of-alchemists")
local final_reward = "INFUSION_WILD_GROWTH"
local e = {
	{
	short_name = "force",
	name = "爆炸药剂",
	cap_name = "ELIXIR OF EXPLOSIVE FORCE",
	id = "ELIXIR_FORCE",
	start = "force_start",
	almost = "force_almost_done",
	full = "elixir_of_explosive_force",
	full_2 = "elixir_of_serendipity",
	full_3 = "elixir_of_focus",
	poached = "force_poached",
	},
	{
	short_name = "serendipity",
	name = "幸运药剂",
	cap_name = "ELIXIR OF SERENDIPITY",
	id = "ELIXIR_SERENDIPITY",
	start = "serendipity_start",
	almost = "serendipity_almost_done",
	full = "elixir_of_serendipity",
	full_2 = "elixir_of_explosive_force",
	full_3 = "elixir_of_focus",
	poached = "serendipity_poached",
	},
	{
	short_name = "focus",
	name = "专注药剂",
	cap_name = "ELIXIR OF FOCUS",
	id = "ELIXIR_FOCUS",
	start = "focus_start",
	almost = "focus_almost_done",
	full = "elixir_of_focus",
	full_2 = "elixir_of_explosive_force",
	full_3 = "elixir_of_serendipity",
	poached = "focus_poached",
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
		return ([[见鬼！在我收到消息说某个蠢货已经制成了药剂并且加入了兄弟会之后10分钟你居然出现了，到底什么该死的事情花了你那么长时间？！把你那些该死的材料给我，要不是有个诅咒说，如果我不这么做的话我会被杀，我才不会帮你做这该死的奖品。要是药水味道尝上去像马尿一样的话那肯定是你这混蛋造成的。]])
	else
		return ([[#LIGHT_GREEN#*那个半身人递给你一张纸条，上面写着：听说 %s 在你离开的时候制造了 %s 。下次动作快点。*#WHITE#
		我还是什么都听不见，幸运的是，看上去似乎和你聊天也没什么意思。]]):format(other_alch, other_elixir)
	end
end

if not q or (q and not q:isCompleted(e[1].start) and not q:isCompleted(e[2].start) and not q:isCompleted(e[3].start)) then

-- Here's the dialog that pops up if the player has never worked for this alchemist before:
newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*你敲了半天的门，终于有个穿着烧焦且冒着烟的长袍半身人开了门，他看上去很不高兴。*#WHITE#
这一上午搞这天杀的药剂差点搞的我屁股开花，我听到有个白痴敲我家的门敲的跟攻城槌一样，行了！我听见了！虽然我的耳朵已经差不多快聋掉了！找我有什么事么？]],
	answers = {
		{"也许我能帮上什么忙。", jump="ominous"},
		{"[离开]"},
	}
}

newChat{ id="ominous",
	text = [[说大声点，笨蛋！我的耳膜最近在调制药剂的时候被炸破了，谢天谢地，你最好将你的嗓门提高三倍！]],
	answers = {
		{"我说，也许我能帮上什么忙！！", jump="proposal"},
	}
}

newChat{ id="proposal",
	text = [[还是听不见，不过听着，炼金术士兄弟会最近会吸收最先做好三瓶指定药剂的炼金师作为会员。我本来对那些呆瓜组成的团体没什么兴趣，不过碰巧兄弟会有一种治疗烂屁股的秘方，我对这个很感兴趣。]],
	answers = {
		{"我怎么帮你？", jump="help"},
	}
}

newChat{ id="help",
	text = [[兄弟会精通该死的炼金领域，而他们却像一头大棕龙坐在它的粪堆上一样保守着他们的秘密！要知道，其实我才不想要那什么蛋疼的秘方，我准备把他们的秘密都偷出来，写在纸上，抄上一百份，然后贴到马基埃亚尔所有村庄的树上去！]],
	answers = {
		{"这可不像一个隐士的态度！", jump="competition"},
	}
}

newChat{ id="competition",
	text = [[然后他们会怎么样？当他们的宝贝秘密，或许根本就不存在，或者就是些操蛋秘方公之于众之后，除了用他们的泪水做药剂和被大家鄙视之外，“基佬兄弟会”就没什么秘密可藏了。现在，说大声点！你是接受任务还是拒绝？]],
	answers = {
		{"我接受！", jump="choice", action = function(npc, player) player:grantQuest("brotherhood-of-alchemists") end,},
		{"我没空帮你！"},
	}
}

newChat{ id="choice",
	text = [[#LIGHT_GREEN#*他递给你一张写着药剂材料的纸片。*#WHITE#
药剂配方是一个商业机密，所以一次我只给你一个，然后我会告诉你怎么做。呃……等我做好以后一定会让你喝个够，这会令你大受裨益。好了，你现在选哪一个？你只要用手点一下这该死的列表就可以了，你说的话我一个字都没听见。但愿你别再在这里跟我说什么了！]],
	answers = {
		{"[指向"..e[1].name..".]", jump="list",
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
		{"[指向"..e[2].name..".]", jump="list",
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
		{"[指向"..e[3].name..".]", jump="list",
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
	text = [[这里有一张我需要的材料清单，大多数材料拥有者可能会要了你的小命，但愿你没那么挫，我已经有一票挫子帮手了。希望你比他们要聪明，动作麻利点！]],
	answers = {
		{"那我走了！"},
	}
}

-- Quest is complete; nobody answers the door
elseif q and q:isStatus(q.DONE) then
newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*门锁着，没人注意到你的敲门声。*#WHITE#]],
	answers = {
		{"[离开]"},
	}
}


else -- Here's the dialog that pops up if the player *has* worked with this alchemist before (either done quests or is in the middle of one):

local other_alch, other_elixir, player_loses, alch_picked, e_picked = require "data-chn123.quests.brotherhood-of-alchemists".competition(q, player, other_alchemist_nums)

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*那个半身人，身上还冒着烟，开了门。*#WHITE#
我呆在这坑爹的地方是有原因的，你TM…………哦，是你啊。]],
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
		{"我来接下一步的任务！", jump="choice",
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
	text = [[#LIGHT_GREEN#*你第一次看到，半身人满是煤灰的脸上绽放出了诚恳的笑容。*#WHITE#
干的好！不管你是谁！整个马基埃亚尔都应该感谢你，除了那些炼金术士兄弟会成员，他们想加害于你。不过幸运的是，那些货通常来说根本伤不到你。]],
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
	text = [[在这儿等着，这是一个不错的机会，如果你进入这栋建筑，你会有幸成为冒险家牌肉松。由于我有这件强大的炼金长袍保护，我才没变成粉蒸肉。]],
	answers = {
		{"[等待]", jump="complete3"},

	}
}

--Final Elixir:
newChat{ id="totally-complete2",
	text = [[给我一小时时间，你在这等着，想想那可恶的兄弟会。要是听到爆炸声，你得来救我，不管什么情况哪怕房子烧成窟窿，变成冒着毒烟的地狱你也得进来。]],
	answers = {
		{"[等待]", jump="totally-complete3"},

	}
}

--Not final elixir:
newChat{ id="complete3",
	text = [[#LIGHT_GREEN#*还好，没发生任何不幸的事，那个半身人终于回来了，递给你一个黑乎乎的玻璃瓶。*#WHITE#
喝吧！你要是喜欢这份工作的话随时可以回来找我。我还没赢呢！最好快点，你在这儿待的时间太长，下次迎接你的可就是一个冒着黑烟怒不可遏的半身人了！]],
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
	text = [[#LIGHT_GREEN#*那个半身人终于拿着一个瓶子和一个袋子回来了。*#WHITE#
这是你那份药剂，另外还有个东西给你。这个纹身可稀有了，千万别浪费了！]],
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
	text = [[你选择哪一个任务？你是来做任务的吧？我想你该不是那些来找春药的蠢货吧？]],
	answers = {
		{"[指向"..e[1].name..".]", jump="list",
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
		{"[指向"..e[2].name..".]", jump="list",
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
		{"[指向"..e[3].name..".]", jump="list",
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
	text = [[拿好配料清单，动作快点。]],
	answers = {
		{"那我走了。"},
	}
}

-- If the elixir got made while you were out:
newChat{ id="poached",
	text = [[太慢了，蠢蛋，药剂我已经做好了。已经有人来拿走了奖励。如果你觉得失望，告诉自己这是否比被剁成几大块然后第二天早上被卖给生物学家要好。就是这样，再见！]],
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
