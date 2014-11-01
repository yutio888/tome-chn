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

-- Baseline blind because the class has a lot of trouble with CC early game and rushing TL4 isn't reasonable
newTalent{
	name = "Sun Ray", short_name = "SUN_BEAM",
	type = {"celestial/sun", 1},
	require = divi_req1,
	random_ego = "attack",
	points = 5,
	cooldown = 9,
	positive = -16,
	range = 7,
	tactical = { ATTACK = {LIGHT = 2} },
	no_energy = function(self, t) return self:attr("amplify_sun_beam") and true or false end,
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	getDamage = function(self, t)
		local mult = 1
		if self:attr("amplify_sun_beam") then mult = 1 + self:attr("amplify_sun_beam") / 100 end
		return self:combatTalentSpellDamage(t, 20, 220) * mult
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 4)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.LIGHT, self:spellCrit(t.getDamage(self, t)), {type="light"})

		if self:getTalentLevel(t) >= 3 then
			local _ _, x, y = self:canProject(tg, x, y)
			self:project({type="ball", x=x, y=y, radius=2, selffire=false}, x, y, DamageType.BLIND, t.getDuration(self, t), {type="light"})
		end

		-- Delay removal of the effect so its still there when no_energy checks
		game:onTickEnd(function()
			self:removeEffect(self.EFF_SUN_VENGEANCE)
		end)

		game:playSoundNear(self, "talents/flame")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 召 唤 太 阳 之 力 ， 形 成 一 道 射 线 ， 造 成 %0.1f 点  光 系 伤 害。
		等 级 3 时 射 线 变 得 如 此 强 烈 ， 半 径 2 以 内 的 敌 人 将 被 致 盲 %d 回 合 。
		伤 害 受 法 强 加 成 。]]):
		format(damDesc(self, DamageType.LIGHT, damage), t.getDuration(self, t))
	end,
}

newTalent{
	name = "Path of the Sun",
	type = {"celestial/sun", 2},
	require = divi_req2,
	points = 5,
	cooldown = 15,
	positive = -20,
	tactical = { ATTACKAREA = {LIGHT = 2}, CLOSEIN = 2 },
	range = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 4, 9)) end,
	direct_hit = true,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 10, 310) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local dam = self:spellCrit(t.getDamage(self, t))
		local grids = self:project(tg, x, y, function() end)
		grids[self.x] = grids[self.x] or {}
		grids[self.x][self.y] = true
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:addEffect(self, self.x, self.y, 5, DamageType.SUN_PATH, dam / 5, 0, 5, grids, MapEffect.new{color_br=255, color_bg=249, color_bb=60, alpha=100, effect_shader="shader_images/sun_effect.png"}, nil, true)
		game.level.map:addEffect(self, self.x, self.y, 5, DamageType.COSMETIC, 0      , 0, 5, grids, {type="sun_path", args={tx=x-self.x, ty=y-self.y}, only_one=true}, nil, true)

		self:setEffect(self.EFF_PATH_OF_THE_SUN, 5, {})

		game:playSoundNear(self, "talents/fireflash")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[ 在 你 面 前 出 现 一 条 阳 光 大 道 ， 持 续 5 回 合 。 任 何 站 在 上 面 的 敌 人 每 回 合 受 到 %0.2f 点 光 系 伤 害 。
		 你 站 在 上 面 行 走 不 消 耗 时 间, 也 不 会 触 发 陷 阱。
		 伤 害 受 法 强 加 成 。]]):format(damDesc(self, DamageType.LIGHT, damage / 5), radius)
	end,
}

-- Can someone put a really obvious visual on this?
newTalent{
	name = "Sun's Vengeance", short_name = "SUN_VENGEANCE",
	type = {"celestial/sun",3},
	require = divi_req3,
	mode = "passive",
	points = 5,
	getCrit = function(self, t) return self:combatTalentScale(t, 2, 10, 0.75) end,
	getProcChance = function(self, t) return self:combatTalentLimit(t, 100, 30, 75) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "combat_spellcrit", t.getCrit(self, t))
		self:talentTemporaryValue(p, "combat_physcrit", t.getCrit(self, t))
	end,
	callbackOnCrit = function(self, t, kind, dam, chance)
		if kind ~= "spell" and kind ~= "physical" then return end
		if not rng.percent(t.getProcChance(self, t)) then return end
		if self.turn_procs.sun_vengeance then return end --Note: this will trigger a lot since it get's multiple chances a turn
		self.turn_procs.sun_vengeance = true

		if self:isTalentCoolingDown(self.T_SUN_BEAM) then
			self.talents_cd[self.T_SUN_BEAM] = self.talents_cd[self.T_SUN_BEAM] - 1
			if self.talents_cd[self.T_SUN_BEAM] <= 0 then self.talents_cd[self.T_SUN_BEAM] = nil end
		else
			self:setEffect(self.EFF_SUN_VENGEANCE, 2, {})
		end
	end,
	info = function(self, t)
		local crit = t.getCrit(self, t)
		local chance = t.getProcChance(self, t)
		return ([[让 阳 光 的 怒 火 充 满 自 身 ， 增 加 %d%% 物 理 和 法 术暴 击 率。
		 每 次 物 理 或 法 术 暴 击  时 ，有 %d%% 几 率 获 得 阳 光 之 怒 效 果 ， 持 续 两 回 合 。
		 当 效 果 激 活 时 ， 你 的 阳 光 烈 焰 变 为 瞬 发 ， 同 时 伤 害 增 加25%%。 
		 如 果 阳 光 烈 焰 处 于 冷 却 中， 则 减 少 1 回 合 冷 却 时间 。 
		 该 效 果 一 回 合 至 多 触 发一 次 。 ]]):
		format(crit, chance)
	end,
}

-- Core class defense to be compared with Bone Shield, Aegis, Indiscernable Anatomy, etc
-- Moderate offensive scaler
-- The CD reduction effects more abilities on the class than it doesn't
-- Banned from NPCs due to sheer scaling insanity
newTalent{
	name = "Suncloak",
	type = {"celestial/sun", 4},
	require = divi_req4,
	points = 5,
	cooldown = 15, -- 20 was accounting for it buffing itself
	fixed_cooldown = true,
	positive = -15,
	tactical = { BUFF = 2 },
	direct_hit = true,
	no_npc_use = true,
	requires_target = true,
	range = 10,
	getCap = function(self, t) return self:combatTalentLimit(t, 30, 90, 70) end,
	getHaste = function(self, t) return math.min(0.5, self:combatTalentSpellDamage(t, 0.1, 0.4)) end,
	getCD = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 5, 450), 0.5, .03, 32, .35, 350) end, -- Limit < 50% cooldown reduction
	action = function(self, t)
		self:setEffect(self.EFF_SUNCLOAK, 6, {cap=t.getCap(self, t), haste=t.getHaste(self, t), cd=t.getCD(self, t)})
		game:playSoundNear(self, "talents/flame")
		return true
	end,
	info = function(self, t)
		return ([[ 你 将 自 己 包 裹 在 阳 光 中 ， 保 护 你 6 回 合 。
		 你 的 施 法 速 度 增 加 %d%% ， 法 术 冷 却 减 少 %d%% ， 同 时 一 次 攻 击 不 能 对  你 造 成 超 过 %d%% 最 大 生 命的 伤 害。
		 效 果 受 法 强 加 成 。]]):
		format(t.getHaste(self, t)*100, t.getCD(self, t)*100, t.getCap(self, t))
   end,
}

