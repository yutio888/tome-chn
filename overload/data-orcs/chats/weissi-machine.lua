

local Talents = require("engine.interface.ActorTalents")
local Stats = require("engine.interface.ActorStats")

local set = function(what) return function(npc, player) npc["chat-progress-"..what] = true end end
local isNotSet = function(what) return function(npc, player) return not npc["chat-progress-"..what] end end

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*Before your is an extremely old looking machine. It seems to be infused with some sort of psionic forces; impossible as this sounds.
And it #{bold}#speaks#{normal}# to you!*#WHITE#
Welcome @playername@. We have been waiting for you.]],
	answers = {
		{"What are you?", jump="what", cond=isNotSet"what", action=function(npc, plauer) set("what")(npc, player) game.party:learnLore("weissi-1") end},
		{"Waiting for me?", jump="waiting", cond=isNotSet"waiting", action=set"waiting"},
		{"What do you need me for?", jump="for", cond=isNotSet"for", action=set"for"},
		{"I have muscle tissue for you.", jump="give", cond=function(npc, player)
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
	text = [[#LIGHT_GREEN#*You feel a powerful projection in your head.*#WHITE#]],
	answers = {
		{"I see...", jump="welcome"},
	}
}

newChat{ id="waiting",
	text = [[Yes. We predict you will be useful to us. If you are not, an other will be.]],
	answers = {
		{"I see...", jump="welcome"},
	}
}

newChat{ id="for",
	text = [[We require recent yeti tissue muscle from powerful specimens. You will help us, or you will not. Either way they will come to us.
If you do so we shall reward your with petty knowledge so that you may postpone your death.]],
	answers = {
		{"That is... generous of you.", jump="welcome", action=function(npc, player)
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
	{"Talent categories", jump="learn_types"},
	{"Talents", jump="learn_talents"},
	{"Improved core stats", jump="learn_stats"},
}

newChat{ id="give",
	text = [[#LIGHT_GREEN#*The muscle tissue suddenly vanishes from your inventory.*#WHITE#
Thank you @playername@. We shall honor our bargain with you. What do you wish to learn?]],
	answers = give_anwsers,
}
newChat{ id="give_re",
	text = [[What do you wish to learn?]],
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
	text = [[Antimagic is a very special category. If you learn it you will never be able to use arcane powered items or talents anymore.
Do you want to learn it?]],
	answers = {
		{"No.", jump="learn_types"},
		{"Yes!", action=function(npc, player)
			local tt = "wild-gift/antimagic"
			game.party:reward("Select the party member to receive the reward:", function(player)
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
	text = [[Very well. We can teach you a talent category; which do you want?]],
	answers = {
		{"Physical techniques", jump="learn_types_physical"},
		{"Arcane spells", jump="learn_types_arcane"},
		{"Nature/Psionic talents", jump="learn_types_nature"},
		{"Hum no let me change my mind.", jump="give_re"},
	}
}
for kind, types in pairs(talent_types) do
	local answers = {}
	for _, tt in ipairs(types) do if game.player:knowTalentType(tt) == nil then
		local tt_def = player:getTalentTypeFrom(tt)
		local cat = tt_def.type:gsub("/.*", "")
		if tt == "wild-gift/antimagic" then
			table.insert(answers, {("[Allow training of talent category %s (at mastery %0.2f)]"):format(cat:capitalize().." / "..tt_def.name:capitalize(), 0.8), jump="learn_types_antimagic", on_select=function(npc, player)
					game.tooltip_x, game.tooltip_y = 1, 1
					game:tooltipDisplayAtMap(game.w, game.h, "#GOLD#"..(cat:capitalize().." / "..tt_def.name:capitalize()).."#LAST#\n"..tt_def.description)
			end})
		else
			table.insert(answers, {("[Allow training of talent category %s (at mastery %0.2f)]"):format(cat:capitalize().." / "..tt_def.name:capitalize(), 0.8), action=function(npc, player)
					game.party:reward("Select the party member to receive the reward:", function(player)
						if player:knowTalentType(tt) == nil then player:setTalentTypeMastery(tt, 0.8) end
						player:learnTalentType(tt, true)
						-- player:hasQuest(npc.quest_id).reward_message = ("gained talent category %s (at mastery %0.2f)"):format(cat:capitalize().." / "..tt_def.name:capitalize(), mastery)
					end)
					on_learn(npc, player)
				end, on_select=function(npc, player)
					game.tooltip_x, game.tooltip_y = 1, 1
					game:tooltipDisplayAtMap(game.w, game.h, "#GOLD#"..(cat:capitalize().." / "..tt_def.name:capitalize()).."#LAST#\n"..tt_def.description)
				end,
			})
		end
	end end
	table.insert(answers, {"Hum no let me change my mind.", jump="give_re"})
	newChat{ id="learn_types_"..kind,
		text = [[Very well. We can teach you a talent which do you want?]],
		answers = answers
	}
end

newChat{ id="learn_talents",
	text = [[Very well. We can teach you a talent which do you want?]],
	answers = {
		{"Physical techniques", jump="learn_talents_physical"},
		{"Arcane spells", jump="learn_talents_arcane"},
		{"Nature/Psionic talents", jump="learn_talents_nature"},
		{"Hum no let me change my mind.", jump="give_re"},
	}
}
for kind, tids in pairs(talents) do
	local answers = {}
	for _, tid in ipairs(tids) do local t = player:getTalentFromId(tid) local level = math.min(t.points - player:getTalentLevelRaw(tid), 1) if level > 0 then
		table.insert(answers, {("[%s talent %s (+%d level(s))]"):format(game.player:knowTalent(tid) and "Improve" or "Learn", t.name, level), action=function(npc, player)
				game.party:reward("Select the party member to receive the reward:", function(player)
					if player:knowTalentType(t.type[1]) == nil then player:setTalentTypeMastery(t.type[1], 0.8) end
					player:learnTalent(tid, true, level, {no_unlearn=true})
					if t.hide then player.__show_special_talents = player.__show_special_talents or {} player.__show_special_talents[tid] = true end
					-- player:hasQuest(npc.quest_id).reward_message = ("%s talent %s (+%d level(s))"):format(game.player:knowTalent(tid) and "improved" or "learnt", t.name, level)
				end)
				on_learn(npc, player)
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
		text = [[Very well. We can teach you a talent category (that you will need to unlock later); which do you want?]],
		answers = answers
	}
end

do
	local answers = {}
	for _, i in ipairs(stats) do
		table.insert(answers, {("[Improve %s by +%d]"):format(player.stats_def[i].name, 4), action=function(npc, player)
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
	table.insert(answers, {"Hum no let me change my mind.", jump="give_re"})
	newChat{ id="learn_stats",
		text = [[Very well. We can increase one of your core stats by 4, which one?]],
		answers = answers
	}
end

return "welcome"
