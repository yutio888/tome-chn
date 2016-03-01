

local Talents = require("engine.interface.ActorTalents")
local Stats = require("engine.interface.ActorStats")

local set = function(what) return function(npc, player) npc["chat-progress-"..what] = true end end
local isNotSet = function(what) return function(npc, player) return not npc["chat-progress-"..what] end end

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*在你面前的是一台非常古老的机器。它似乎充满了某种超能力，听上去不可思议。
现在，它朝你 #{bold}#说话#{normal}#了！*#WHITE#
你好啊冒险者，我们等你很久了。]],
	answers = {
		{"你是?", jump="what", cond=isNotSet"what", action=function(npc, plauer) set("what")(npc, player) game.party:learnLore("weissi-1") end},
		{"等我?", jump="waiting", cond=isNotSet"waiting", action=set"waiting"},
		{"你要我干啥?", jump="for", cond=isNotSet"for", action=set"for"},
		{"我有一些肌肉组织要给你.", jump="give", cond=function(npc, player)
			if not npc["chat-progress-what"] then return false end
			if not npc["chat-progress-for"] then return false end
			if not player:hasQuest("orcs+weissi") then return false end
			local o = player:findInInventoryBy(player:getInven("INVEN"), "yeti_muscle_tissue", true)
			return o and true or false
		end},
		{"[leave]"},
	}
}

newChat{ id="what",
	text = [[#LIGHT_GREEN#*你感觉到大脑里浮现出强大的预言。*#WHITE#]],
	answers = {
		{"我明白了...", jump="welcome"},
	}
}

newChat{ id="waiting",
	text = [[是的。我们预测你将对我们有所助益。当然，如果你不是，也会有其他人。]],
	answers = {
		{"我明白了...", jump="welcome"},
	}
}

newChat{ id="for",
	text = [[我们需要强大雪人种族的肌肉组织。你可以帮我们，也可以选择不帮。这取决于你。
如果你帮了我们，我们将传授你知识。]],
	answers = {
		{"这真是... 慷慨.", jump="welcome", action=function(npc, player)
			player:grantQuest("orcs+weissi")
			player:setQuestStatus("orcs+weissi", engine.Quest.COMPLETED, "for")
		end},
	}
}

local talent_types = {
	physical = {
		"technique/conditioning",
		"technique/field-control",
		"technique/mobility",
		"cunning/survival",
	},

	arcane = {
		"spell/divination",
		"spell/staff-combat",
		"celestial/chants",
		-- "celestial/light", -- shibari told me to remove it for mex ! ;)
		"chronomancy/chronomancy",
	},

	nature = {
		"psionic/dreaming",
		"wild-gift/antimagic",
		"wild-gift/call",
		"wild-gift/mindstar-mastery",
	},
}

local talents = {
	physical = {
		Talents.T_VITALITY,
		Talents.T_UNFLINCHING_RESOLVE,
		Talents.T_EXOTIC_WEAPONS_MASTERY,
		Talents.T_HEIGHTENED_SENSES,
		Talents.T_CHARM_MASTERY,
		Talents.T_PIERCING_SIGHT,
		Talents.T_HACK_N_BACK,
		Talents.T_LIGHT_OF_FOOT,
		Talents.T_TRACK,
		Talents.T_HEAVE,
	},

	arcane = {
		Talents.T_ARCANE_EYE,
		Talents.T_PREMONITION,
		Talents.T_VISION,
		Talents.T_CHANNEL_STAFF,
		Talents.T_STAFF_MASTERY,
		Talents.T_STONE_TOUCH,
		Talents.T_CHANT_OF_FORTITUDE,
		Talents.T_CHANT_OF_FORTRESS,
		Talents.T_BATHE_IN_LIGHT,
		Talents.T_HEALING_LIGHT,
		Talents.T_PRECOGNITION,
		Talents.T_FORESIGHT,
	},

	nature = {
		Talents.T_NATURE_TOUCH,
		Talents.T_EARTH_S_EYES,
		Talents.T_PSIBLADES,
		Talents.T_THORN_GRAB,
		Talents.T_SLEEP,
		Talents.T_DREAM_WALK,
		Talents.T_RESOLVE,
		Talents.T_MANA_CLASH,
	},
}

local stats = {
	Stats.STAT_STR,
	Stats.STAT_DEX,
	Stats.STAT_CON,
	Stats.STAT_MAG,
	Stats.STAT_WIL,
	Stats.STAT_CUN,
}

local give_anwsers = {
	{"技能树", jump="learn_types"},
	{"技能", jump="learn_talents"},
	{"强化核心属性", jump="learn_stats"},
}

newChat{ id="give",
	text = [[#LIGHT_GREEN#*肌肉组织突然消失了。*#WHITE#
感谢你冒险家，你的帮助我们将铭记于心。你想学什么？]],
	answers = give_anwsers,
}
newChat{ id="give_re",
	text = [[你想学什么?]],
	answers = give_anwsers,
}

on_learn = function(npc, player)
	local o, item = player:findInInventoryBy(player:getInven("INVEN"), "yeti_muscle_tissue", true)
	player:removeObject(player:getInven("INVEN"), item, true)
	player:sortInven()

	game:setAllowedBuild("tinker_psyshot", true)

	if not npc.next_lore_id then npc.next_lore_id = 2 end
	if npc.next_lore_id <= 5 then
		game.party:learnLore("weissi-"..npc.next_lore_id)
		if npc.next_lore_id == 5 then
			player:setQuestStatus("orcs+weissi", engine.Quest.COMPLETED)
		end
		npc.next_lore_id = npc.next_lore_id + 1
	end
end

------------------------------------------------------------
-- Hack for antimagic
------------------------------------------------------------
newChat{ id="learn_types_antimagic",
	text = [[反魔法是一系非常特殊的技能。你学习后将不能使用奥术装备和法术技能。
	确定要学习么?]],
	answers = {
		{"我再想想.", jump="learn_types"},
		{"决定了!", action=function(npc, player)
			local tt = "wild-gift/antimagic"
			game.party:reward("选择接受奖励的成员：", function(player)
				if player:knowTalentType(tt) == nil then player:setTalentTypeMastery(tt, 0.8) end
				player:learnTalentType(tt, true)
				player:attr("forbid_arcane", 1)

				for tid, _ in pairs(player.sustain_talents) do
					local t = player:getTalentFromId(tid)
					if t.is_spell then player:forceUseTalent(tid, {ignore_energy=true}) end
				end

				-- Remove equipment
				for inven_id, inven in pairs(player.inven) do
					for i = #inven, 1, -1 do
						local o = inven[i]
						if o.power_source and o.power_source.arcane then
							game.logPlayer(player, "You cannot use your %s anymore; it is tainted by magic.", o:getName{do_color=true})
							local o = player:removeObject(inven, i, true)
							player:addObject(player.INVEN_INVEN, o)
							player:sortInven()
						end
					end
				end

				-- player:hasQuest(npc.quest_id).reward_message = ("gained talent category %s (at mastery %0.2f)"):format(cat:capitalize().." / "..tt_def.name:capitalize(), mastery)
			end)
			on_learn(npc, player)
		end, on_select=function(npc, player)
			local tt = "wild-gift/antimagic"
			local tt_def = player:getTalentTypeFrom(tt)
			local cat = tt_def.type:gsub("/.*", "")
			game.tooltip_x, game.tooltip_y = 1, 1
			game:tooltipDisplayAtMap(game.w, game.h, "#GOLD#"..(cat:capitalize().." / "..tt_def.name:capitalize()).."#LAST#\n"..tt_def.description)
		end,
		},
	}
}
------------------------------------------------------------
------------------------------------------------------------

newChat{ id="learn_types",
	text = [[很好，我们能教你一个技能树，你想要哪种？]],
	answers = {
		{"战斗策略", jump="learn_types_physical"},
		{"法术", jump="learn_types_arcane"},
		{"自然/超能力", jump="learn_types_nature"},
		{"让我再想想", jump="give_re"},
	}
}
for kind, types in pairs(talent_types) do
	local answers = {}
	for _, tt in ipairs(types) do if game.player:knowTalentType(tt) == nil then
		local tt_def = player:getTalentTypeFrom(tt)
		local cat = tt_def.type:gsub("/.*", "")
		if tt == "wild-gift/antimagic" then
			table.insert(answers, {("[允许技能树 %s (系数 %0.2f)]"):format(t_talent_cat[cat] or cat:capitalize() .." / "..t_talent_type_name[tt_def.name] or tt_def.name:capitalize(), 0.8), jump="learn_types_antimagic", on_select=function(npc, player)
					game.tooltip_x, game.tooltip_y = 1, 1
					game:tooltipDisplayAtMap(game.w, game.h, "#GOLD#"..(t_talent_cat[cat] or cat:capitalize() .." / "..t_talent_type_name[tt_def.name] or tt_def.name:capitalize()).."#LAST#\n"..tt_def.description)
			end})
		else
			table.insert(answers, {("[允许技能树 %s (系数 %0.2f)]"):format(t_talent_cat[cat] or cat:capitalize() .." / "..t_talent_type_name[tt_def.name] or tt_def.name:capitalize(), 0.8), action=function(npc, player)
					game.party:reward("Select the party member to receive the reward:", function(player)
						if player:knowTalentType(tt) == nil then player:setTalentTypeMastery(tt, 0.8) end
						player:learnTalentType(tt, true)
						-- player:hasQuest(npc.quest_id).reward_message = ("gained talent category %s (at mastery %0.2f)"):format(t_talent_cat[cat] or cat:capitalize() .." / "..t_talent_type_name[tt_def.name] or tt_def.name:capitalize(), mastery)
					end)
					on_learn(npc, player)
				end, on_select=function(npc, player)
					game.tooltip_x, game.tooltip_y = 1, 1
					game:tooltipDisplayAtMap(game.w, game.h, "#GOLD#"..(t_talent_cat[cat] or cat:capitalize() .." / "..t_talent_type_name[tt_def.name] or tt_def.name:capitalize()).."#LAST#\n"..tt_def.description)
				end,
			})
		end
	end end
	table.insert(answers, {"让我再想想。", jump="give_re"})
	newChat{ id="learn_types_"..kind,
		text = [[很好。我们能教授你技能，你想学哪个？]],
		answers = answers
	}
end

newChat{ id="learn_talents",
	text = [[很好。我们能教授你技能，你想学哪个？]],
	answers = {
		{"战斗策略", jump="learn_talents_physical"},
		{"法术", jump="learn_talents_arcane"},
		{"自然/超能力", jump="learn_talents_nature"},
		{"让我再想想", jump="give_re"},
	}
}
for kind, tids in pairs(talents) do
	local answers = {}
	for _, tid in ipairs(tids) do local t = player:getTalentFromId(tid) local level = math.min(t.points - player:getTalentLevelRaw(tid), 1) if level > 0 then
		table.insert(answers, {("[%s 技能 %s (+%d 等级)]"):format(game.player:knowTalent(tid) and "增强" or "学会", t.name, level), action=function(npc, player)
				local function learn()
					game.party:reward("Select the party member to receive the reward:", function(player)
						if player:knowTalentType(t.type[1]) == nil then player:setTalentTypeMastery(t.type[1], 0.8) end
						player:learnTalent(tid, true, level, {no_unlearn=true})
						if t.hide then player.__show_special_talents = player.__show_special_talents or {} player.__show_special_talents[tid] = true end
						-- player:hasQuest(npc.quest_id).reward_message = ("%s talent %s (+%d level(s))"):format(game.player:knowTalent(tid) and "improved" or "learnt", t.name, level)
					end)
					on_learn(npc, player)
				end

				if t.is_antimagic then
					newChat{ id="learn_talent_"..t.id,
						text = [[反魔法是一系非常特殊的技能。你学习后将不能使用奥术装备和法术技能。
	确定要学习么?]],
						answers = {
							{"我再想想.", jump="learn_talents"},
							{"好的!", action=function(npc, player)
								learn()
							end}					
						}
					}
					return "learn_talent_"..t.id
				else
					learn()
				end
			end, on_select=function(npc, player)
				game.tooltip_x, game.tooltip_y = 1, 1
				local mastery = nil
				if player:knowTalentType(t.type[1]) == nil then mastery = 0.8 end
				game:tooltipDisplayAtMap(game.w, game.h, "#GOLD#"..t.name.."#LAST#\n"..tostring(player:getTalentFullDescription(t, 1, nil, mastery)))
			end,
		})
	end end
	table.insert(answers, {"Hum no let me change my mind.", jump="give_re"})
	newChat{ id="learn_talents_"..kind,
		text = [[很好，我们能教你一个技能树(需解锁)，你想要哪种？]],
		answers = answers
	}
end

do
	local answers = {}
	for _, i in ipairs(stats) do
		table.insert(answers, {("[增加 %s %d点]"):format(player.stats_def[i].name, 4), action=function(npc, player)
				game.party:reward("Select the party member to receive the reward:", function(player)
					player:incIncStat(i, 4)
					-- player:hasQuest(npc.quest_id).reward_message = ("improved %s by +%d"):format(npc.stats_def[i].name, reward.stats[i])
				end)
				on_learn(npc, player)
			end, on_select=function(npc, player)
				game.tooltip_x, game.tooltip_y = 1, 1
				local TooltipsData = require("mod.class.interface.TooltipsData")
				game:tooltipDisplayAtMap(game.w, game.h, TooltipsData["TOOLTIP_"..player.stats_def[i].short_name:upper()])
			end,
		})
	end
	table.insert(answers, {"我再想想.", jump="give_re"})
	newChat{ id="learn_stats",
		text = [[很好，我们能强化你一项属性4点。选择哪个?]],
		answers = answers
	}
end

return "welcome"
