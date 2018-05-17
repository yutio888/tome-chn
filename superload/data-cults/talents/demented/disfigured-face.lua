
-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2018 Nicolas Casalini
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

-- Low impact but can be spammed pretty often to build Insanity
newTalent{
	name = "Diseased Tongue",
	type = {"demented/disfigured-face", 1},
	require = dementedreq1,
	points = 5,
	cooldown = 5,
	range = function(self, t) return math.floor(self:combatTalentLimit(t, 6, 1, 4)) end,
	tactical = { ATTACK = {blight=2}, DISABLE = 0.5 },
	direct_hit = true,
	requires_target = true,
	getDiseasePower = function(self, t) return self:combatTalentSpellDamage(t, 5, 28) end,
	getDamageDisease = function(self, t) return 5 + self:combatTalentSpellDamage(t, 5, 30) end,
	getDamageTentacle = function(self, t) return 1 end,
	getDuration = function(self, t) return 6 end,
	getInsanity = function(self, t) return 10 end,
	target = function(self, t) return {type="cone", range=0, radius=self:getTalentRange(t), selffire=false, friendlyfire=false, talent=t} end,
	action = function(self, t)
		local tentacle = self:callTalent(self.T_MUTATED_HAND, "getTentacleCombat", true)
		if not tentacle then return end
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		self:attr("tentacle_hand_prevent", 1)

		local diseases = {{self.EFF_WEAKNESS_DISEASE, "str"}, {self.EFF_ROTTING_DISEASE, "con"}, {self.EFF_DECREPITUDE_DISEASE, "dex"}}
		local damage = self:spellCrit(t.getDamageDisease(self, t))
		local did_hit = false
		self:attr("combat_apr", 10000)
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, engine.Map.ACTOR)
			if not target then return end
			local disease = rng.table(diseases)
			local speed, hit = self:attackTargetWith(target, tentacle, nil, t.getDamageTentacle(self, t))
			if hit and target:canBe("disease") then
				did_hit = true
				target:setEffect(disease[1], 6, {src=self, dam=damage, [disease[2]]=t.getDiseasePower(self, t), apply_power=self:combatSpellpower()})
			end
			if hit and self:knowTalent(self.T_GLIMPSE_OF_TRUE_HORROR) then
				self:callTalent(self.T_GLIMPSE_OF_TRUE_HORROR, "affectTarget", target)
			end
		end)
		self:attr("combat_apr", -10000)

		local hx, hy = self:attachementSpot("back", true)
		local ps = Particles.new("tentacle_lash", 1, {dir=math.deg(math.atan2(y-self.y, x-self.x)+math.pi/2), dist=tg.radius})
		ps.dx = hx ps.dy = hy self:addParticles(ps)

		self:attr("tentacle_hand_prevent", -1)

		game:playSoundNear(self, "talents/slime")

		if did_hit then self:incInsanity(t.getInsanity(self, t)) end

		return true
	end,
	info = function(self, t)
		return ([[Your tongue turns into a diseased tentacle that you use to #{italic}#lick#{normal}# enemies in a cone.
		Licked creatures take %d%% tentacle damage that ignores armor and get sick, gaining a random disease for %d turns that deals %0.2f blight damage per turn and reduces strength, dexterity or constitution by %d.
		
		If at least one enemy is hit you gain %d insanity.
		
		Disease damage will increase with your Spellpower.]]):
		format(
			t.getDamageTentacle(self, t) * 100,
			t.getDuration(self, t), damDesc(self, DamageType.BLIGHT, t.getDamageDisease(self, t)), t.getDiseasePower(self, t),
			t.getInsanity(self, t)
		)
	end,
}

-- Minor insanity dump AoE
newTalent{
	name = "Dissolved Face",
	type = {"demented/disfigured-face", 2},
	image = "talents/disolved_face.png",
	require = dementedreq2,
	points = 5,
	insanity = -10,
	cooldown = 12,
	tactical = { ATTACKAREA = { DARKNESS = 1.5, BLIGHT = 1.5} },
	requires_target = true,
	direct_hit = true,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 1, 400) end,
	target = function(self, t) return {type="cone", talent=t, cone_angle = 45, range=0, radius=8, selffire=false, friendlyfire=false} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x then return nil end

		local dam = self:spellCrit(t.getDamage(self, t))
		self:project(tg, x, y, function(px, py)
			local a = game.level.map(px, py, Map.ACTOR)
			if not a then return end
			
			a:setEffect(a.EFF_DISOLVED_FACE, 5, {src=self, dam=dam / 5})
			if self:knowTalent(self.T_GLIMPSE_OF_TRUE_HORROR) then
				self:callTalent(self.T_GLIMPSE_OF_TRUE_HORROR, "affectTarget", a)
			end
		end)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "decaying_guts", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/vile_breath")
		return true
	end,
	info = function(self, t)
		return ([[You approach your face to your target and let some of it melt in a gush of blood and gore, dealing %0.2f darkness damage (%0.2f total) in a cone over 5 turns.
		Each turn the target will be dealt an additional %0.2f blight damage per disease.
		Damage will increase with your Spellpower.]])
		:format(damDesc(self, DamageType.DARKNESS, t.getDamage(self, t) / 5), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), damDesc(self, DamageType.BLIGHT, 0.7 * t.getDamage(self, t) / 5))
	end,
}

newTalent{
	name = "Writhing Hairs",
	type = {"demented/disfigured-face", 3},
	require = dementedreq3,
	points = 5,
	insanity = -10,
	cooldown = 15,
	tactical = { DISABLE = 2 },
	requires_target = true,
	range = 7,
	radius = 2,
	direct_hit = true,
	getSpeed = function(self, t) return self:combatTalentLimit(t, 0.8, 0.1, 0.7) end,
	getBrittle = function(self, t) return self:combatTalentScale(t, 30, 60) end,
	target = function(self, t) return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), selffire=false, friendlyfire=false, nolock=true} end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTargetLimited(tg)
		if not x or not y then return nil end

		self:project(tg, x, y, function(px, py)
			local a = game.level.map(px, py, Map.ACTOR)
			if not a then return end
			a:setEffect(a.EFF_WRITHING_HAIRS, 7, {speed=t.getSpeed(self, t), brittle=t.getBrittle(self, t)})
			if self:knowTalent(self.T_GLIMPSE_OF_TRUE_HORROR) then
				self:callTalent(self.T_GLIMPSE_OF_TRUE_HORROR, "affectTarget", a)
			end	
		end)

		local hx, hy = self:attachementSpot("head", true)
		if not hx then hx, hy = 0, 0 end
		hx, hy = hx + 0.25, hy + 0.25
		self:addParticles(Particles.new("image", 1, {life=12, size=64, once=true, image="particles_images/writhing_hairs", x=hx*64, y=hy*64}))

		game:playSoundNear(self, "talents/writhing_hairs")
		return true
	end,
	info = function(self, t)
		return ([[For a brief moment horrific hairs grow on your head, each of them ending with a creepy eye.
		You use those eyes to gaze upon a target area, and creatures caught inside partially turn to stone, reducing their movement speed by %d%% and making them brittle for 7 turns.
		Brittle targets have a 35%% chance for any damage they take to be increased by %d%%.
		This cannot be saved against.
		]]):
		format(t.getSpeed(self, t) * 100, t.getBrittle(self, t))
	end,
}

newTalent{
	name = "Glimpse of True Horror",
	type = {"demented/disfigured-face", 4},
	require = dementedreq4,
	points = 5,
	mode = "passive",
	getFail = function(self, t) return self:combatTalentSpellDamage(t, 15, 300) / 10 end,
	getPen = function(self, t) return self:combatTalentSpellDamage(t, 30, 400) / 10 end,
	affectTarget = function(self, t, target)
		if self:reactionToward(target) <= 0 then
			target:setEffect(target.EFF_GLIMPSE_OF_TRUE_HORROR, 2, {apply_power=self:combatSpellpower(), fail=t.getFail(self, t)})
			self:setEffect(self.EFF_GLIMPSE_OF_TRUE_HORROR_SELF, 2, {pen=t.getPen(self, t)})
		end
	end,
	info = function(self, t)
		return ([[Whenever you use a disfigured face power you show a glimpse of what True Horror is.
		If the affected targets fail a spell save they become frightened for 2 turns, giving them %d%% chances to fail using talents.
		When a target becomes afraid it bolsters you to see their anguish, increasing your darkness and blight damage penetration by %d%% for 2 turns.
		The values will increase with your Spellpower.]]):
		format(t.getFail(self, t), t.getPen(self, t))
	end,
}
