-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2017 Nicolas Casalini
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

require "engine.class"
local Dialog = require "engine.ui.Dialog"
local DamageType = require "engine.DamageType"

module(..., package.seeall, class.make)

function _M:onPartyDeath(src, death_note)
	if self.dead then if game.level:hasEntity(self) then game.level:removeEntity(self, true) end return true end

	-- Remove from the party if needed
	if self.remove_from_party_on_death then
		game.party:removeMember(self, true)
	-- Overwise note the death turn
	else
		game.party:setDeathTurn(self, game.turn)
	end

	-- Die
	death_note = death_note or {}
	mod.class.Actor.die(self, src, death_note)

	-- Was not the current player, just die
	if game.player ~= self then return end

	-- Check for any survivor that can be controlled
	local game_ender = not game.party:findSuitablePlayer()

	-- No more player found! Switch back to main and die
	if game_ender then
		if self == src then world:gainAchievement("HALFLING_SUICIDE", self) end
		game.party:setPlayer(game.party:findMember{main=true}, true)
		game.paused = true
		game.player.energy.value = game.energy_to_act
		src = src or {name="unknown"}
		game.player.killedBy = src
		game.player.died_times[#game.player.died_times+1] = {name=src.name, level=game.player.level, turn=game.turn}
		game.player:registerDeath(game.player.killedBy)
		local dialog = require("mod.dialogs."..(game.player.death_dialog or "DeathDialog")).new(game.player)
		if not dialog.dont_show then
			game:registerDialog(dialog)
		end
		game.player:saveUUID()

		local death_mean = nil
		if death_note and death_note.damtype then
			local dt = DamageType:get(death_note.damtype)
			if dt and dt.death_message then death_mean = rng.table(dt.death_message) end
		end

		local top_killer = nil
		if profile.mod.deaths then
			local l = {}
			for _, names in pairs(profile.mod.deaths.sources or {}) do
				for name, nb in pairs(names) do l[name] = (l[name] or 0) + nb end
			end
			l = table.listify(l)
			if #l > 0 then
				table.sort(l, function(a,b) return a[2] > b[2] end)
				top_killer = l[1][1]
			end
		end

		local msg, short_msg
		if not death_note.special_death_msg then
			msg = "玩家%s 等级 %d %s %s %s 而死，杀死他（她）的是 %s%s%s ，死在第 %s 层， %s。"
			short_msg = "%s(%d %s %s)  %s 而死，被 %s%s 杀死于 %s %s."
			local srcname = src.name
			local killermsg = (src.killer_message and " "..("，" .. killer_msg_chn[src.killer_message] or src.killer_message) or ""):gsub("#sex#", game.player.female and "她" or "他")
			if src.name == game.player.name then
				srcname = game.player.female and "她自己" or "他自己"
				killermsg = rng.table{
					" (笨蛋)",
					" 操作太不给力了",
					" 显然玩家太谦虚了",
					"，肯定是发生了什么意外",
					"，似乎是实验失败了",
					"，成为了野生动物的午餐",
					" (真令人尴尬)",
				}
			end
			msg = msg:format(
				game.player.name, game.player.level, s_stat_name[game.player.descriptor.subrace] or game.player.descriptor.subrace, s_stat_name[game.player.descriptor.subclass] or game.player.descriptor.subclass,
				death_note_chn[death_mean] or "猛击",
				npcCHN:getName(srcname),
				src.name == top_killer and " (不止一次)" or "",
				killermsg,
				game.level.level, zoneName[game.zone.name] or game.zone.name
			)
			short_msg = short_msg:format(
				game.player.name, game.player.level, s_stat_name[game.player.descriptor.subrace] or game.player.descriptor.subrace, s_stat_name[game.player.descriptor.subclass] or game.player.descriptor.subclass,
				death_note_chn[death_mean] or "猛击",
				npcCHN:getName(srcname),
				killermsg,
				game.level.level, zoneName[game.zone.name] or game.zone.name
			)
		else
			msg = "玩家%s 等级 %d %s %s %s ，死在第 %s 层， %s。"
			short_msg = "%s(%d %s %s) %s 死于 %s %s."
			msg = msg:format(
				game.player.name, game.player.level, s_stat_name[game.player.descriptor.subrace] or game.player.descriptor.subrace, s_stat_name[game.player.descriptor.subclass] or game.player.descriptor.subclass,
				death_note.special_death_msg,
				game.level.level, zoneName[game.zone.name] or game.zone.name
			)
			short_msg = short_msg:format(
				game.player.name, game.player.level, s_stat_name[game.player.descriptor.subrace] or game.player.descriptor.subrace, s_stat_name[game.player.descriptor.subclass] or game.player.descriptor.subclass,
				death_note.special_death_msg,
				game.level.level, zoneName[game.zone.name] or game.zone.name

			)
		end

		game:playSound("actions/death")
		game.delayed_death_message = "#{bold}#"..msg.."#{normal}#"
		if (not game.player.easy_mode_lifes or game.player.easy_mode_lifes <= 0) and not game.player.infinite_lifes then
			profile.chat.uc_ext:sendKillerLink(msg, short_msg, src)
		end
	end
end
