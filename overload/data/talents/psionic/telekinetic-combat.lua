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


newTalent{
	name = "Telekinetic Assault",
	type = {"psionic/telekinetic-combat", 4},
	require = psi_cun_high4, 
	points = 5,
	random_ego = "attack",
	cooldown = 12,
	psi = 25,
	range = 1,
	requires_target = true,
	tactical = { ATTACK = { PHYSICAL = 3 } },
	action = function(self, t)
		local weapon = self:getInven("MAINHAND") and self:getInven("MAINHAND")[1]
		if type(weapon) == "boolean" then weapon = nil end
		if not weapon or self:attr("disarmed")then
			game.logPlayer(self, "You cannot do that without a weapon in your hands.")
			return nil
		end
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		self:attr("use_psi_combat", 1)
		if self:getInven(self.INVEN_PSIONIC_FOCUS) then
			for i, o in ipairs(self:getInven(self.INVEN_PSIONIC_FOCUS)) do
				if o.combat and not o.archery then
					self:attackTargetWith(target, o.combat, nil, self:combatTalentWeaponDamage(t, 1.2, 1.9))
					self:attackTargetWith(target, o.combat, nil, self:combatTalentWeaponDamage(t, 1.2, 1.9))
				end
			end
		end
		self:attackTargetWith(target, weapon.combat, nil, self:combatTalentWeaponDamage(t, 1.5, 2.5))
		self:attr("use_psi_combat", -1)
		return true
	end,
	info = function(self, t)
		return ([[Assault your target with all weapons, dealing two strikes with your telekinetically-wielded weapon for %d%% damage followed by an attack with your physical weapon for %d%% damage. 
		This physical weapon attack uses your Willpower and Cunning instead of Strength and Dexterity to determine Accuracy and damage.
		Any active Aura damage bonusses will extend to your main weapons for this attack.]]):
		format(100 * self:combatTalentWeaponDamage(t, 1.2, 1.9), 100 * self:combatTalentWeaponDamage(t, 1.5, 2.5))
	end,
}
