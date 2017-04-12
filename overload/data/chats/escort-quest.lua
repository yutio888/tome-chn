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

local Talents = require("engine.interface.ActorTalents")
local Stats = require("engine.interface.ActorStats")

local reward_types = {
	warrior = {
		types = {
			["technique/conditioning"] = 0.8,
		},
		talents = {
			[Talents.T_VITALITY] = 1,
			[Talents.T_UNFLINCHING_RESOLVE] = 1,
			[Talents.T_EXOTIC_WEAPONS_MASTERY] = 1,
		},
		stats = {
			[Stats.STAT_STR] = 2,
			[Stats.STAT_CON] = 1,
		},
	},
	divination = {
		types = {
			["spell/divination"] = 0.8,
		},
		talents = {
			[Talents.T_ARCANE_EYE] = 1,
			[Talents.T_PREMONITION] = 1,
			[Talents.T_VISION] = 1,
		},
		stats = {
			[Stats.STAT_MAG] = 2,
			[Stats.STAT_WIL] = 1,
		},
		antimagic = {
			types = {
				["wild-gift/call"] = 0.8,
			},
			saves = { mental = 4 },
			talents = {
				[Talents.T_NATURE_TOUCH] = 1,
				[Talents.T_EARTH_S_EYES] = 1,
			},
			stats = {
				[Stats.STAT_CUN] = 1,
				[Stats.STAT_WIL] = 2,
			},
		},
	},
	alchemy = {
		types = {
			["spell/staff-combat"] = 0.8,
			["spell/stone-alchemy"] = 0.8,
		},
		talents = {
			[Talents.T_CHANNEL_STAFF] = 1,
			[Talents.T_STAFF_MASTERY] = 1,
			[Talents.T_STONE_TOUCH] = 1,
		},
		stats = {
			[Stats.STAT_MAG] = 2,
			[Stats.STAT_DEX] = 1,
		},
		antimagic = {
			types = {
				["wild-gift/mindstar-mastery"] = 0.8,
			},
			talents = {
				[Talents.T_PSIBLADES] = 1,
				[Talents.T_THORN_GRAB] = 1,
			},
			saves = { spell = 4 },
			stats = {
				[Stats.STAT_WIL] = 1,
				[Stats.STAT_DEX] = 2,
			},
		},
	},
	survival = {
		types = {
			["cunning/survival"] = 0.8,
		},
		talents = {
			[Talents.T_HEIGHTENED_SENSES] = 1,
			[Talents.T_DEVICE_MASTERY] = 1,
			[Talents.T_TRACK] = 1,
		},
		stats = {
			[Stats.STAT_DEX] = 2,
			[Stats.STAT_CUN] = 1,
		},
	},
	sun_paladin = {
		types = {
			["celestial/chants"] = 0.8,
		},
		talents = {
			[Talents.T_CHANT_OF_FORTITUDE] = 1,
			[Talents.T_CHANT_OF_FORTRESS] = 1,
		},
		stats = {
			[Stats.STAT_STR] = 2,
			[Stats.STAT_MAG] = 1,
		},
		antimagic = {
--			types = {
--				["technique/mobility"] = 0.8, --imagine a world where paradox mage/archmage etc could access trained reactions
--			},
			talents = {
				[Talents.T_DISENGAGE] = 1,
				[Talents.T_EVASION] = 1,
			},
			saves = { spell = 4, phys = 4 },
			stats = {
				[Stats.STAT_CUN] = 1,
				[Stats.STAT_WIL] = 2,
			},
		},
	},
	anorithil = {
		types = {
			["celestial/light"] = 0.8,
		},
		talents = {
			[Talents.T_BATHE_IN_LIGHT] = 1,
			[Talents.T_HEALING_LIGHT] = 1,
		},
		stats = {
			[Stats.STAT_CUN] = 2,
			[Stats.STAT_MAG] = 1,
		},
		antimagic = {
			types = {
				["psionic/feedback"] = 0.8,
			},
			talents = {
				[Talents.T_BIOFEEDBACK] = 1,
				[Talents.T_CONVERSION] = 1,
			},
			saves = { spell = 4, mental = 4 },
			stats = {
				[Stats.STAT_CUN] = 1,
				[Stats.STAT_WIL] = 2,
			},
		},
	},
	temporal = {
		types = {
			["chronomancy/chronomancy"] = 0.8,
		},
		talents = {
			[Talents.T_PRECOGNITION] = 1,
			[Talents.T_FORESIGHT] = 1,
		},										
		stats = {
			[Stats.STAT_MAG] = 2,
			[Stats.STAT_WIL] = 1,
		},
		antimagic = {
			types = {
				["psionic/dreaming"] = 0.8,
			},
			talents = {
				[Talents.T_SLEEP] = 1,
				[Talents.T_DREAM_WALK] = 1,
			},
			saves = { spell = 4 },
			stats = {
				[Stats.STAT_WIL] = 1,
				[Stats.STAT_CUN] = 2,
			},
		},
	},
	exotic = {
		talents = {
			[Talents.T_DISARM] = 1,
--			[Talents.T_WATER_JET] = 1,
			[Talents.T_SPIT_POISON] = 1,
			[Talents.T_MIND_SEAR] = 1,
		},
		stats = {
			[Stats.STAT_STR] = 2,
			[Stats.STAT_DEX] = 2,
			[Stats.STAT_MAG] = 2,
			[Stats.STAT_WIL] = 2,
			[Stats.STAT_CUN] = 2,
			[Stats.STAT_CON] = 2,
		},
	},
}

local hd = {"Quest:escort:reward", reward_types=reward_types}
if require("engine.class"):triggerHook(hd) then reward_types = hd.reward_types end

local reward = reward_types[npc.reward_type]
local quest = game.player:hasQuest(npc.quest_id)
if quest.to_zigur and reward.antimagic then reward = reward.antimagic reward.is_antimagic = true end

game.player:registerEscorts(quest.to_zigur and "zigur" or "saved")

local saves_name = { mental="mental", spell="spell", phys="physical"}
local saves_tooltips = { mental="MENTAL", spell="SPELL", phys="PHYS"}

local function chn_stat(stat_name)
	return stat_name:gsub("Strength","力量"):gsub("Constitution","体质"):gsub("Magic","魔法"):gsub("Willpower","意志"):gsub("Cunning","灵巧"):gsub("Dexterity","敏捷")
end

local function generate_rewards()
	local answers = {}
	if reward.stats then
		for i = 1, #npc.stats_def do if reward.stats[i] then
			local doit = function(npc, player) game.party:reward("选择队伍中获得奖励的成员：", function(player)
				player.inc_stats[i] = (player.inc_stats[i] or 0) + reward.stats[i]
				player:onStatChange(i, reward.stats[i])
				player.changed = true
				player:hasQuest(npc.quest_id).reward_message = ("improved %s by +%d"):format(npc.stats_def[i].name, reward.stats[i])
			end) end
			answers[#answers+1] = {("[提升 %s +%d]"):format(chn_stat(npc.stats_def[i].name), reward.stats[i]),
				jump="done",
				action=doit,
				on_select=function(npc, player)
					game.tooltip_x, game.tooltip_y = 1, 1
					local TooltipsData = require("mod.class.interface.TooltipsData")
					game:tooltipDisplayAtMap(game.w, game.h, TooltipsData["TOOLTIP_"..npc.stats_def[i].short_name:upper()])
				end,
			}
		end end
	end
	if reward.saves then
		for save, v in pairs(reward.saves) do
			local doit = function(npc, player) game.party:reward("Select the party member to receive the reward:", function(player)
				player:attr("combat_"..save.."resist", v)
				player.changed = true
				player:hasQuest(npc.quest_id).reward_message = ("improved %s save by +%d"):format(saves_name[save], v)
			end) end
			answers[#answers+1] = {("[提升 %s 豁免 +%d]"):format(saves_name[save], v),
				jump="done",
				action=doit,
				on_select=function(npc, player)
					game.tooltip_x, game.tooltip_y = 1, 1
					local TooltipsData = require("mod.class.interface.TooltipsData")
					game:tooltipDisplayAtMap(game.w, game.h, TooltipsData["TOOLTIP_"..saves_tooltips[save]:upper().."_SAVE"])
				end,
			}
		end
	end
	if reward.talents then
		for tid, level in pairs(reward.talents) do
			local t = npc:getTalentFromId(tid)
			level = math.min(t.points - game.player:getTalentLevelRaw(tid), level)
			if level > 0 then
				local doit = function(npc, player) game.party:reward("选择队伍中获得奖励的成员：", function(player)
					if game.player:knowTalentType(t.type[1]) == nil then player:setTalentTypeMastery(t.type[1], 0.8) end
					player:learnTalent(tid, true, level, {no_unlearn=true})
					if t.hide then player.__show_special_talents = player.__show_special_talents or {} player.__show_special_talents[tid] = true end
					player:hasQuest(npc.quest_id).reward_message = ("%s talent %s (+%d level(s))"):format(game.player:knowTalent(tid) and "improved" or "learnt", t.name, level)
				end) end
				answers[#answers+1] = {
					("[%s 技能 %s (+%d 等级)]"):format(game.player:knowTalent(tid) and "提升" or "学习", t.name, level),
						jump="done",
						action=doit,
						on_select=function(npc, player)
							game.tooltip_x, game.tooltip_y = 1, 1
							local mastery = nil
							if player:knowTalentType(t.type[1]) == nil then mastery = 0.8 end
							game:tooltipDisplayAtMap(game.w, game.h, "#GOLD#"..t.name.."#LAST#\n"..tostring(player:getTalentFullDescription(t, 1, nil, mastery)))
						end,
					}
			end
		end
	end
	if reward.types then
		for tt, mastery in pairs(reward.types) do if game.player:knowTalentType(tt) == nil then
			local tt_def = npc:getTalentTypeFrom(tt)
			local cat = tt_def.type:gsub("/.*", "")
			local doit = function(npc, player) game.party:reward("Select the party member to receive the reward:", function(player)
				if player:knowTalentType(tt) == nil then player:setTalentTypeMastery(tt, mastery - 1 + player:getTalentTypeMastery(tt)) end
				player:learnTalentType(tt, false)
				player:hasQuest(npc.quest_id).reward_message = ("gained talent category %s (at mastery %0.2f)"):format(cat:capitalize().." / "..tt_def.name:capitalize(), mastery)
			end) end
			answers[#answers+1] = {("[解锁技能树 %s (技能等级 %0.2f)]"):format((t_talent_cat[cat] or cat:capitalize()).." / "..tt_def.name:capitalize(), mastery),
				jump="done",
				action=doit,
				on_select=function(npc, player)
					game.tooltip_x, game.tooltip_y = 1, 1
					game:tooltipDisplayAtMap(game.w, game.h, "#GOLD#"..((t_talent_cat[cat] or cat:capitalize()).." / "..tt_def.name:capitalize()).."#LAST#\n"..tt_def.description)
				end,
			}
		end end
	end
	if reward.special then
		for _, data in ipairs(reward.special) do
			answers[#answers+1] = {data.desc,
				jump="done",
				action=data.action,
				on_select=function(npc, player)
					game.tooltip_x, game.tooltip_y = 1, 1
					game:tooltipDisplayAtMap(game.w, game.h, data.tooltip)
				end,
			}
		end
	end
	return answers
end

newChat{ id="welcome",
	text = reward.is_antimagic and [[最后你召唤了自然之力，传送门发出嘶嘶的响声，将 @npcname@ 传送到了伊格。
你可以感觉到自然对你的感激。]] or
	[[谢谢你我的朋友，要是没有你我就死定了。
请让我报答你吧：]],
	answers = generate_rewards(),
}

newChat{ id="done",
	text = [[那就这样吧，再见！]],
	answers = {
		{"谢谢。"},
	},
}

return "welcome"
