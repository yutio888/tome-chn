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

function get_mindstar_power_mult(self, div)
	local main, off = self:hasPsiblades(true, true)
	if not main or not off then return 1 end

	local mult = 1 + (main.combat.dam + off.combat.dam) * 0.8 / (div or 40)
	return mult
end

newTalent{
	name = "Psiblades",
	type = {"wild-gift/mindstar-mastery", 1},
	require = gifts_req1,
	points = 5,
	mode = "sustained",
	sustain_equilibrium = 18,
	cooldown = 6,
	tactical = { BUFF = 4 },
	getPowermult = function(self,t,level) return 1.076 + 0.324*(level or self:getTalentLevel(t))^.5 end, --I5
	getStatmult = function(self,t,level) return 1.076 + 0.324*(level or self:getTalentLevel(t))^.5 end, --I5
	getAPRmult = function(self,t,level) return 0.65 + 0.51*(level or self:getTalentLevel(t))^.5 end, -- I5
	getDamage = function(self, t) return self:getTalentLevel(t) * 10 end,
	getPercentInc = function(self, t) return math.sqrt(self:getTalentLevel(t) / 5) / 2 end,
	activate = function(self, t)
		local r = {
			tmpid = self:addTemporaryValue("psiblades_active", self:getTalentLevel(t)),
		}

		for i, o in ipairs(self:getInven("MAINHAND") or {}) do self:onTakeoff(o, self.INVEN_MAINHAND, true) self:onWear(o, self.INVEN_MAINHAND, true) end
		for i, o in ipairs(self:getInven("OFFHAND") or {}) do self:onTakeoff(o, self.INVEN_OFFHAND, true) self:onWear(o, self.INVEN_OFFHAND, true) end
		self:updateModdableTile()

		return r
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("psiblades_active", p.tmpid)

		for i, o in ipairs(self:getInven("MAINHAND") or {}) do self:onTakeoff(o, self.INVEN_MAINHAND, true) self:checkMindstar(o) self:onWear(o, self.INVEN_MAINHAND, true) end
		for i, o in ipairs(self:getInven("OFFHAND") or {}) do self:onTakeoff(o, self.INVEN_OFFHAND, true) self:checkMindstar(o) self:onWear(o, self.INVEN_OFFHAND, true) end
		self:updateModdableTile()

		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[将 你 的 精 神 能 量 灌 入 你 所 装 备 的 灵 晶 中， 使 其 生 成 心 灵 利 刃。 
		 灵 晶 所 产 生 的 心 灵 利 刃 会 进 行 %0.2f 伤 害 修 正 加 成（ 从 属 性 中 获 得 的 伤 害 值）， 增 加 %0.2f 护 甲 穿 透。
		 心 灵 利 刃 将 使 灵 晶 附 加 的 精 神 强 度、 意 志 和 灵 巧 变 为 %0.2f 倍。  
		 同 时 增 加 %d 点 物 理 强 度， 当 你 使 用 灵 晶 时， 增 加 %d%% 武 器 伤 害。]]):
		format(t.getStatmult(self, t), t.getAPRmult(self, t), t.getPowermult(self, t), damage, 100 * inc) --I5
	end,
}

newTalent{
	name = "Thorn Grab",
	type = {"wild-gift/mindstar-mastery", 2},
	require = gifts_req2,
	points = 5,
	equilibrium = 7,
	cooldown = 15,
	no_energy = true,
	range = 1,
	tactical = { ATTACK = 2, DISABLE = 2 },
	on_pre_use = function(self, t, silent) if not self:hasPsiblades(true, false) then if not silent then game.logPlayer(self, "You require a psiblade in your mainhand to use this talent.") end return false end return true end,
	speedPenalty = function(self, t) return self:combatTalentLimit(t, 1, 0.18, 0.23) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end
		target:setEffect(target.EFF_THORN_GRAB, 10, {src=self, speed = t.speedPenalty(self, t), dam=self:mindCrit(self:combatTalentMindDamage(t, 15, 250) / 10 * get_mindstar_power_mult(self))})
		return true
	end,		
	info = function(self, t)
		return ([[你 通 过 心 灵 利 刃 接 触 你 的 目 标， 将 自 然 的 怒 火 带 给 你 的 敌 人。 
		 荆 棘 藤 蔓 会 抓 取 目 标， 使 其 减 速 %d%% ， 并 且 每 回 合 造 成 %0.2f 自 然 伤 害， 持 续 10 回 合。 
		 受 精 神 强 度 和 灵 晶 强 度 影 响， 伤 害 有 额 外 加 成（ 需 要 2 只 灵 晶， 加 成 比 例 %2.f ）。]]):
		format(100*t.speedPenalty(self,t), damDesc(self, DamageType.NATURE, self:combatTalentMindDamage(t, 15, 250) / 10 * get_mindstar_power_mult(self)), get_mindstar_power_mult(self))
	end,
}

newTalent{
	name = "Leaves Tide",
	type = {"wild-gift/mindstar-mastery", 3},
	require = gifts_req3,
	points = 5,
	equilibrium = 20,
	cooldown = 25,
	tactical = { ATTACK = 2, DEFEND=3 },
	getDamage = function(self, t) return 5 + self:combatTalentMindDamage(t, 5, 35) * get_mindstar_power_mult(self) end,
	getChance = function(self, t) return util.bound(10 + self:combatTalentMindDamage(t, 3, 25), 10, 40) * get_mindstar_power_mult(self, 90) end,
	on_pre_use = function(self, t, silent) if not self:hasPsiblades(true, true) then if not silent then game.logPlayer(self, "You require two psiblades in your hands to use this talent.") end return false end return true end,
	action = function(self, t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, 7,
			DamageType.LEAVES, {dam=self:mindCrit(t.getDamage(self, t)), chance=t.getChance(self, t)},
			3,
			5, nil,
			{type="leavestide", only_one=true},
			function(e)
				e.x = e.src.x
				e.y = e.src.y
				return true
			end,
			true
		)
		game:playSoundNear(self, "talents/icestorm")
		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local c = t.getChance(self, t)
		return ([[向 四 周 粉 碎 利 刃， 在 你 周 围 的 3 码 半 径 范 围 内 形 成 一 股 叶 刃 风 暴， 持 续 7 回 合。 
		 被 叶 刃 击 中 的 目 标 会 开 始 流 血， 每 回 合 受 到 %0.2f 点 伤 害（ 可 叠 加）。 
		 所 有 被 叶 刃 覆 盖 的 同 伴， 获 得 %d%% 概 率 完 全 免 疫 任 何 伤 害。 
		 受 精 神 强 度 和 灵 晶 强 度 影 响， 伤 害 和 免 疫 几 率 有 额 外 加 成（ 需 要 2 只 灵 晶， 加 成 比 例 %2.f ）。]]):
		format(dam, c, get_mindstar_power_mult(self))
	end,
}

newTalent{
	name = "Nature's Equilibrium",
	type = {"wild-gift/mindstar-mastery", 4},
	require = gifts_req4,
	points = 5,
	equilibrium = 5,
	cooldown = 15,
	range = 1,
	tactical = { ATTACK = 1, HEAL = 1, EQUILIBRIUM = 1 },
	direct_hit = true,
	requires_target = true,
	on_pre_use = function(self, t, silent) if not self:hasPsiblades(true, true) then if not silent then game.logPlayer(self, "You require two psiblades in your hands to use this talent.") end return false end return true end,
	getMaxDamage = function(self, t) return 50 + self:combatTalentMindDamage(t, 5, 250) * get_mindstar_power_mult(self) end,
	action = function(self, t)
		local main, off = self:hasPsiblades(true, true)

		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		local ol = target.life
		local speed, hit = self:attackTargetWith(target, main.combat, nil, self:combatTalentWeaponDamage(t, 2.5, 4))
		local dam = util.bound(ol - target.life, 0, t.getMaxDamage(self, t))

		while hit do -- breakable if
			local tg = {default_target=self, type="hit", nowarning=true, range=1, first_target="friend"}
			local x, y, target = self:getTarget(tg)
			if not x or not y or not target then break end
			if core.fov.distance(self.x, self.y, x, y) > 1 then break end

			target:attr("allow_on_heal", 1)
			target:heal(dam, t)
			target:attr("allow_on_heal", -1)
			target:incEquilibrium(-dam / 10)
			if core.shader.active(4) then
				self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true ,size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0}))
				self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false,size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0}))
			end
			break
		end

		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[你 用 主 手 心 灵 利 刃 攻 击 敌 人 造 成 %d%% 武 器 伤 害， 用 副 手 心 灵 利 刃 传 导 敌 人 所 受 的 伤 害 能 量 来 治 疗 友 方 单 位。 
		 治 疗 最 大 值 为 %d 。 受 到 治 疗 效 果 的 目 标 失 衡 值 会 降 低 治 疗 量 的 10%% 。 
		 受 精 神 强 度 和 灵 晶 强 度 影 响， 最 大 治 疗 值 有 额 外 加 成（ 需 要 2 只 灵 晶， 加 成 比 例 %2.f ）。]]):
		format(self:combatTalentWeaponDamage(t, 2.5, 4) * 100, t.getMaxDamage(self, t), get_mindstar_power_mult(self))
	end,
}
