-- Skirmisher, a class for Tales of Maj'Eyal 1.1.5
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

local sling_equipped = function(self, silent)
	if not self:hasArcheryWeapon("sling") then
		if not silent then
			game.logPlayer(self, "You must wield a sling!")
		end
		return false
	end
	return true
end

-- calc_all is so the info can show all the effects.
local sniper_bonuses = function(self, calc_all)
	local bonuses = {}
	local t = self:getTalentFromId("T_SKIRMISHER_SLING_SNIPER")
	local level = self:getTalentLevel(t)

	if level > 0 or calc_all then
		bonuses.crit_chance = self:combatTalentScale(t, 3, 10)
		bonuses.crit_power = self:combatTalentScale(t, 0.1, 0.2, 0.75)
	end
	if level >= 5 or calc_all then
		bonuses.resists_pen = {[DamageType.PHYSICAL] = self:combatStatLimit("cun", 100, 15, 50)} -- Limit < 100%
	end
	return bonuses
end

-- Add the phys pen to self right before the shot hits.
local pen_on = function(self, talent, tx, ty, tg, target)
	if target and tg and tg.archery and tg.archery.resists_pen then
		self.temp_skirmisher_sling_sniper = self:addTemporaryValue("resists_pen", tg.archery.resists_pen)
	end
end

-- The action for each of the shots.
local fire_shot = function(self, t)
	local tg = {type = "hit"}

	local targets = self:archeryAcquireTargets(tg, table.clone(t.archery_target_parameters))
	if not targets then return end
	local bonuses = sniper_bonuses(self)
	local params = {mult = t.damage_multiplier(self, t)}
	if bonuses.crit_chance then params.crit_chance = bonuses.crit_chance end
	if bonuses.crit_power then params.crit_power = bonuses.crit_power end
	if bonuses.resists_pen then params.resists_pen = bonuses.resists_pen end
	self:archeryShoot(targets, t, {type = "hit", speed = 200}, params) -- Projectile speed because using "hit" with slow projectiles is infuriating
	return true
end

-- Remove the phys pen from self right after the shot is finished.
local pen_off = function(self, talent, target, x, y)
	if self.temp_skirmisher_sling_sniper then
		self:removeTemporaryValue("resists_pen", self.temp_skirmisher_sling_sniper)
	end
end

local shot_cooldown = function(self, t)
	if self:getTalentLevel(self.T_SKIRMISHER_SLING_SNIPER) >= 3 then
		return 6
	else
		return 8
	end
end

newTalent {
	short_name = "SKIRMISHER_KNEECAPPER",
	name = "Kneecapper",
	type = {"cunning/called-shots", 1},
	require = techs_cun_req1,
	points = 5,
	no_energy = "fake",
	random_ego = "attack",
	tactical = {ATTACK = {weapon = 1}, DISABLE = 1},
	stamina = 10,
	cooldown = shot_cooldown,
	requires_target = true,
	range = archery_range,
	on_pre_use = function(self, t, silent) return sling_equipped(self, silent) end,
	pin_duration = function(self, t)
		return math.floor(self:combatTalentScale(t, 1, 2))
	end,
	slow_duration = function(self, t)
		return math.floor(self:combatTalentScale(t, 3, 4.7))
	end,
	slow_power = function(self, t)
		return self:combatLimit(self:getCun()*.5 + self:getTalentLevel(t)*10, 0.6, 0.2, 15, 0.5, 100) --Limit < 60%, 20% at TL 1 for 10 Cun, 50% at TL5, Cun 100
	end,
	archery_onreach = pen_on,
	archery_onmiss = pen_off,
	archery_onhit = function(self, t, target, x, y)
		target:setEffect(target.EFF_SLOW_MOVE, t.slow_duration(self, t), {power = t.slow_power(self, t), apply_power = self:combatAttack()})
		if target:canBe("pin") then
			target:setEffect(target.EFF_PINNED, t.pin_duration(self, t), {apply_power = self:combatAttack()})
		else
			game.logSeen(target, "%s resists being knocked down.", target.name:capitalize())
		end
		pen_off(self, t, target, x, y)
	end,
	archery_target_parameters = {one_shot = true},
	damage_multiplier = function(self, t)
		return self:combatTalentWeaponDamage(t, 1.5, 1.9)
	end,
	action = fire_shot,
	info = function(self, t)
		return ([[射 击 敌 人 的 膝 盖 （ 或 者 任 何 活 动 肢 体 上 的 重 要 部 位）， 造 成 %d%% 武 器 伤 害， 并 将 敌 人 击 倒 （ 定 身 %d 回 合） 并 在 之 后 降 低 其 移 动 速 度 %d%% %d 回合 。
		这 个 射 击 将 会 穿 过 你 和 目 标 间 的 其 他 敌 人。
		受 灵 巧 影 响， 减 速 效 果 有 额 外 加 成。]])
		:format(t.damage_multiplier(self, t) * 100,
				t.pin_duration(self, t),
				t.slow_power(self, t) * 100,
				t.slow_duration(self, t))
	end,
}

-- This serves two primary roles
-- 1.  Core high damage shot
-- 2.  Sniping off-targets like casters in any situation in potentially one shot
newTalent {
	short_name = "SKIRMISHER_THROAT_SMASHER",
	name = "Kill Shot",
	type = {"cunning/called-shots", 2},
	require = techs_cun_req2,
	points = 5,
	no_energy = "fake",
	random_ego = "attack",
	tactical = {ATTACK = {weapon = 2}},
	stamina = 35,
	cooldown = shot_cooldown,
	no_npc_use = true, -- Numbers overtuned to make sure the class has a satisfying high damage shot
	requires_target = true,
	range = archery_range,
	on_pre_use = function(self, t, silent) return sling_equipped(self, silent) end,
	getDistanceBonus = function(self, t, range)
		return self:combatScale(range, -.5, 1, 2.5, 10, 0.25) --Slow scaling to allow for greater range variability
	end,
	getDamage = function(self, t)
		return 1
	end,
	damage_multiplier = function(self, t)
		return self:combatTalentWeaponDamage(t, 0.3, 1.5)
	end,
	archery_onreach = pen_on,
	archery_onmiss = pen_off,
	archery_onhit = function(self, t, target, x, y)
		pen_off(self, t, target, x, y)
	end,
	archery_target_parameters = {one_shot = true},
	action = function(self, t)
		local tg = {type = "hit"}

		local targets = self:archeryAcquireTargets(tg, table.clone(t.archery_target_parameters))
		if not targets then return end

		-- THIS IS WHY I HATE YOUR CODE STRUCTURE GRAYSWANDIR
		local bonuses = sniper_bonuses(self)
		local dist = core.fov.distance(self.x, self.y, targets[1].x, targets[1].y)
		local damage, distbonus = t.damage_multiplier(self, t), t.getDistanceBonus(self, t, dist)

		local target = game.level.map(targets[1].x, targets[1].y, engine.Map.ACTOR)
		if not target then return end
		game:delayedLogMessage(self, target, "kill_shot", "#DARK_ORCHID##Source# 狙击了 #Target# (%+d%%%%%%%% 武器伤害加成)!#LAST#", distbonus*100)
		
		local params = {mult = damage + distbonus}
		if bonuses.crit_chance then params.crit_chance = bonuses.crit_chance end
		if bonuses.crit_power then params.crit_power = bonuses.crit_power end
		if bonuses.resists_pen then params.resists_pen = bonuses.resists_pen end
		self:archeryShoot(targets, t, {type = "hit", speed = 200}, params)

		return true
	end, 
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[对 敌 人 进 行 一 次 特 殊 的 射 击。
		这 个 技 能 专 注 于 精 准 的 远 程 狙 击， 造 成 %d%% 的 基 础 远 程 伤 害 以 及 受 距 离 加 成 的 额 外 伤 害。
		在 零 距 离， 伤 害 加 成 （ 惩 罚） 为 %d%% ， 在 最 大 射 程 （ %d 格）， 伤 害 加 成 为 %d%% 。
		这 个 射 击 将 会 穿 过 你 和 目 标 间 的 其 他 敌 人。]])
		:format(t.damage_multiplier(self, t) * 100, t.getDistanceBonus(self, t, 1)*100, range, t.getDistanceBonus(self, t, range)*100)

		end,
}

newTalent {
	short_name = "SKIRMISHER_NOGGIN_KNOCKER",
	name = "Noggin Knocker",
	type = {"cunning/called-shots", 3},
	require = techs_cun_req3,
	points = 5,
	no_energy = "fake",
	tactical = {ATTACK = {weapon = 2}, DISABLE = {stun = 2}},
	stamina = 15,
	cooldown = shot_cooldown,
	requires_target = true,
	range = archery_range,
	on_pre_use = function(self, t, silent) return sling_equipped(self, silent) end,
	damage_multiplier = function(self, t)
		return self:combatTalentWeaponDamage(t, 0.3, 0.75)
	end,
	archery_onreach = pen_on,
	archery_onmiss = pen_off,
	archery_onhit = function(self, t, target, x, y)
		if target:canBe("stun") then
			target:setEffect(target.EFF_SKIRMISHER_STUN_INCREASE, 1, {apply_power = self:combatAttack()})
		else
			game.logSeen(target, "%s resists the stunning shot!", target.name:capitalize())
		end
		pen_off(self, t, target, x, y)
	end,
	archery_target_parameters = {limit_shots = 1, multishots = 3},
	action = fire_shot,
	info = function(self, t)
		return ([[对 敌 人 的 脆 弱 部 位 （ 通 常 是 头 部） 迅 速 地 连 射 三 次。
		每 次 射 击 造 成 %d%% 远 程 伤 害 并 试 图 震 慑 目 标 或 增 加 震 慑 的 持 续 时 间 1 回 合。
		这 些 射 击 将 会 穿 过 你 和 目 标 间 的 其 他 敌 人。
		受 命 中 影 响， 晕 眩 几 率 增 加。]])
		:format(t.damage_multiplier(self, t) * 100)
	end,
}

newTalent {
	short_name = "SKIRMISHER_SLING_SNIPER",
	name = "Sling Sniper",
	type = {"cunning/called-shots", 4},
	require = techs_cun_req4,
	points = 5,
	no_energy = "fake",
	mode = "passive",
	info = function(self, t)
		local bonuses = sniper_bonuses(self, true)
		return ([[你 对 射 击 的 掌 握 程 度 无 与 伦 比。 你 的 精 准 射 击 系 技 能 获 得 %d%% 额 外 暴 击 几 率 和 %d%% 额 外 暴 击 伤 害。 
		在 第 3 级 时， 所 有 精 准 射 击 系 技 能 冷 却 时 间 降 低 两 回 合。
		在 第 5 级 时， 你 的 精 准 射 击 技 能 获 得 %d%% 物 理 抗 性 穿 透]])
		:format(bonuses.crit_chance,
			bonuses.crit_power * 100,
			bonuses.resists_pen[DamageType.PHYSICAL])
	end
}
