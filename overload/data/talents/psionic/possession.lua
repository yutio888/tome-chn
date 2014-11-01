-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
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

newTalent{
	name = "Possess",
	type = {"psionic/possession", 1},
	require = psi_wil_req1,
	points = 5,
	cooldown = 30,
	psi = 30,
	no_npc_use = true,
	range = 3,
	requires_target = true,
	allowedTypes = function(self, t, type)
		if type == "animal" then return true end
		if type == "humanoid" then return true end
		if type == "giant" then return true end
		return false
	end,
	getMaxTalents = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), selffire=false, talent=t} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local tx, ty = self:getTarget(tg)
		if not tx or not ty then return nil end
		local _ _, tx, ty = self:canProject(tg, tx, ty)
		local target = game.level.map(tx, ty, Map.ACTOR)
		if not target or target == self then return nil end

		if target == self.summoner then
			game.party:setPlayer(self.summoner, true)
			return true
		end

		if not t.allowedTypes(self, t, target.type) then game.logPlayer(self, "You may not possess this kind of creature.") return nil end
--		if target.life > target.max_life * 0.25 then game.logPlayer(self, "You may not possess this creature yet its life is too high.") return nil end
		if target.dead then game.logPlayer(self, "Your target is dead!") return nil end
		if not self:checkHit(self:combatMindpower(), target:combatMentalResist(), 0, 95, 5) then -- or not target:canBe("instakill") then
			self:logCombat(target, "#Source# fails to shatter #Target#'s mind, preventing its possession.")
			return true
		end

		self.ai = "none"

		target.faction = self.faction
		target.ai = "none"
		target.ai_state = target.ai_state or {}
		target.ai_state.tactic_leash = 100
		target.remove_from_party_on_death = true
		target.no_inventory_access = true
		target.move_others = true
		target.summoner = self
		target.summoner_gain_exp = true
		target.on_die = function(self, src) if self.summoner then self.summoner:die(src) end end
		target.no_leave_control = true

		-- Remove & adjust talents
		local nb = t.getMaxTalents(self, t)
		local remove = {}
		for tid, lev in pairs(target.talents) do
			local t = self:getTalentFromId(tid)
			if t.mode ~= "passive" then
				table.insert(remove, tid)
			end
		end
		local keep = {}
		for i = 1, nb do
			if #remove == 0 then break end
			table.insert(keep, rng.tableRemove(remove))
		end
		for _, tid in ipairs(remove) do target:unlearnTalent(tid, target:getTalentLevelRaw(tid)) end

		-- Give a way to go back
		target:learnTalent(target.T_POSSESS, true)

		-- Adjust mental stats
		target.stats[target.STAT_MAG] = self.stats[self.STAT_MAG]
		target.inc_stats[target.STAT_MAG] = self.inc_stats[self.STAT_MAG]
		target.stats[target.STAT_WIL] = self.stats[self.STAT_WIL]
		target.inc_stats[target.STAT_WIL] = self.inc_stats[self.STAT_WIL]
		target.stats[target.STAT_CUN] = self.stats[self.STAT_CUN]
		target.inc_stats[target.STAT_CUN] = self.inc_stats[self.STAT_CUN]

		-- Countdown to death
		target:setEffect(target.EFF_POSSESSION, 100, {})

		game.party:addMember(target, {
			control="full",
			type="possesed",
			title="Possessed Husk",
			orders = {leash=true, follow=true},
			on_control = function(self)
				self:hotkeyAutoTalents()
			end,
		})
		game.party:setPlayer(target, true)

		return true
	end,
	info = function(self, t)
		return ([[]]):
		format()
	end,
}

newTalent{
	name = "Physical Possession",
	type = {"psionic/possession", 2},
	require = psi_wil_req2,
	points = 5,
	mode = "passive",
	no_npc_use = true,
	info = function(self, t)
		return ([[]]):
		format()
	end,
}

newTalent{
	name = "Wild Possession",
	type = {"psionic/possession", 3},
	require = psi_wil_req3,
	mode = "passive",
	points = 5,
	no_npc_use = true,
	info = function(self, t)
		return ([[]]):
		format()
	end,
}

newTalent{
	name = "Arcane Possession",
	type = {"psionic/possession", 4},
	require = psi_wil_req4,
	mode = "passive",
	points = 5,
	no_npc_use = true,
	info = function(self, t)
		return ([[]]):
		format()
	end,
}
