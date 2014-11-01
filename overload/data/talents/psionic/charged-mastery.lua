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
	name = "Transcendent Electrokinesis",
	type = {"psionic/charged-mastery", 1},
	require = psi_cun_high1,
	points = 5,
	psi = 20,
	cooldown = 30,
	tactical = { BUFF = 3 },
	getPower = function(self, t) return self:combatTalentMindDamage(t, 10, 30) end,
	getPenetration = function(self, t) return self:combatLimit(self:combatTalentMindDamage(t, 10, 20), 100, 4.2, 4.2, 13.4, 13.4) end, -- Limit < 100%
	getConfuse = function(self, t) return self:combatTalentLimit(t, 50, 15, 35) end, --Limit < 50%
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 30, 5, 10)) end, --Limit < 30
	action = function(self, t)
		self:setEffect(self.EFF_TRANSCENDENT_ELECTROKINESIS, t.getDuration(self, t), {power=t.getPower(self, t), penetration = t.getPenetration(self, t), confuse=t.getConfuse(self, t)})
		self:removeEffect(self.EFF_TRANSCENDENT_PYROKINESIS)
		self:removeEffect(self.EFF_TRANSCENDENT_TELEKINESIS)
		self:alterTalentCoolingdown(self.T_CHARGED_SHIELD, -1000)
		self:alterTalentCoolingdown(self.T_CHARGED_STRIKE, -1000)
		self:alterTalentCoolingdown(self.T_CHARGED_AURA, -1000)
		self:alterTalentCoolingdown(self.T_CHARGE_LEECH, -1000)
		self:alterTalentCoolingdown(self.T_BRAIN_STORM, -1000)
		return true
	end,
	info = function(self, t)
		return ([[在 %d 回 合 中 你 的 电 能 突 破 极 限， 增 加 你 的 闪 电 伤 害 %d%% ， 闪 电 抗 性 穿 透 %d%% 。
		额 外 效 果：
		重 置 电 能 护 盾， 电 能 吸 取， 充 能 光 环 和 头 脑 风 暴 的 冷 却 时 间。
		根 据 情 况， 充 能 光 环 获 得 其 中 一 种 强 化： 充 能 光 环 的 半 径 增 加 为 2 格。 你 的 所 有 武 器 获 得 充 能 光 环 的 伤 害 加 成。
		你 的 电 能 护 盾 获 得 100%% 的 吸 收 效 率， 并 可 以 吸 收 两 倍 伤 害。
		头 脑 风 暴 附 带 致 盲 效 果。
		电 能 吸 取 附 带 混 乱 效 果 （ %d%% 概 率）。
		电 能 打 击 的 第 二 次 闪 电 / 致 盲 攻 击 将 会 对 半 径 3 格 之 内 的 最 多 3 名 敌 人 产 生 连 锁 反 应。
		受 精 神 强 度 影 响， 伤 害 和 抗 性 穿 透 有 额 外 加 成。
		同 一 时 间 只 有 一 个 卓 越 技 能 产 生 效 果。]]):format(t.getDuration(self, t), t.getPower(self, t), t.getPenetration(self, t), t.getConfuse(self, t))
	end,
}

newTalent{
	name = "Thought Sense",
	type = {"psionic/charged-mastery", 2},
	require = psi_cun_high2, 
	points = 5,
	psi = 20,
	cooldown = 30,
	tactical = { BUFF = 3 },
	getDefense = function(self, t) return self:combatTalentMindDamage(t, 20, 40) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 12)) end,
	radius = function(self, t) return math.floor(self:combatScale(self:getWil(10, true) * self:getTalentLevel(t), 10, 0, 15, 50)) end,
	action = function(self, t)
		self:setEffect(self.EFF_THOUGHTSENSE, t.getDuration(self, t), {range=t.radius(self, t), def=t.getDefense(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[感 知 半 径 %d 范 围 内 生 物 的 精 神 活 动 ， 效 果 持 续 %d 回 合。
		这 个 技 能 暴 露 他 们 的 位 置， 并 增 加 你 的 防 御 %d。
		受 精 神 强 度 影 响， 持 续 时 间、 闪 避、 和 半 径 有 额 外 加 成。]]):format(t.radius(self, t), t.getDuration(self, t), t.getDefense(self, t))
	end,
}

newTalent{
	name = "Static Net",
	type = {"psionic/charged-mastery", 3},
	require = psi_cun_high3,
	points = 5,
	random_ego = "attack",
	psi = 32,
	cooldown = 13,
	tactical = { ATTACKAREA = { LIGHTNING = 2 } },
	range = 8,
	radius = function(self,t) return self:combatTalentScale(t, 2, 5) end,
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getSlow = function(self, t) return self:combatLimit(self:combatTalentMindDamage(t, 5, 50), 50, 4, 4, 34, 34) end, -- Limit < 50%
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 20, 130) end,
	getWeaponDamage = function(self, t) return self:combatTalentMindDamage(t, 10, 50) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 3, 9)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, _, _, x, y = self:canProject(tg, x, y)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			x, y, t.getDuration(self, t),
			DamageType.STATIC_NET, {dam=t.getDamage(self, t), slow=t.getSlow(self, t), weapon=t.getWeaponDamage(self, t)},
			self:getTalentRadius(t),
			5, nil,
			MapEffect.new{color_br=30, color_bg=100, color_bb=160, effect_shader="shader_images/retch_effect.png"},
			nil, true
		)
		game:playSoundNear(self, "talents/lightning")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[在 半 径 %d 范 围 中 散 布 一 个 持 续 %d 回 合 的 静 电 捕 网。
		站 在 网 中 的 敌 人 受 到 %0.1f 的 闪 电 伤 害 并 被 减 速 %d%%。
		当 你 在 网 中 穿 梭， 你 的 武 器 上 会 逐 渐 累 加 静 电 充 能， 让 你 的 下 一 次 攻 击 造 成 额 外 %0.1f 的 闪 电 伤 害。
		受 精 神 强 度 影 响， 技 能 效 果 有 额 外 加 成。]]):
		format(self:getTalentRadius(t), duration, damDesc(self, DamageType.LIGHTNING, damage), t.getSlow(self, t), damDesc(self, DamageType.LIGHTNING, t.getWeaponDamage(self, t)))
	end,
}

newTalent{
	name = "Heartstart",
	type = {"psionic/charged-mastery", 4},
	require = psi_cun_high4,
	points = 5,
	mode = "sustained",
	sustain_psi = 30,
	cooldown = 60,
	tactical = { BUFF = 10},
	getPower = function(self, t) -- Similar to blurred mortality
		return self:combatTalentMindDamage(t, 0, 300) + self.max_life * self:combatTalentLimit(t, 1, .01, .05)
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		local effs = {}
		-- Go through all spell effects
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.status == "detrimental" and e.subtype.stun then
				self:removeEffect(eff_id)
			end
		end
		self:setEffect(self.EFF_HEART_STARTED, t.getDuration(self, t), {power=t.getPower(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[储 存 一 次 电 力 充 能 用 来 在 之 后 挽 救 你 的 生 命。
		当 这 个 技 能 激 活 时， 如 果 你 的 生 命 值 被 减 低 到 0 以 下， 这 个 技 能 将 会 进 入 冷 却， 解 除 你 的 震 慑 / 晕 眩 / 冰 冻 状 态， 使 你 的 生 命 值 最 多 为 - %d 时 不 会 死 亡， 效 果 持 续 %d 回 合。
		受 精 神 强 度 和 最 大 生 命 值 影 响， 承 受 的 致 命 伤 害 有 额 外 加 成。.]]):
		format(t.getPower(self, t), t.getDuration(self, t))
	end,
}

