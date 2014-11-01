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

uberTalent{
	name = "Through The Crowd",
	require = { special={desc="同时拥有至少6名同伴", fct=function(self)
		return self:attr("huge_party")
	end} },
	mode = "sustained",
	on_learn = function(self, t)
		self:attr("bump_swap_speed_divide", 10)
	end,
	on_unlearn = function(self, t)
		self:attr("bump_swap_speed_divide", -10)
	end,
	callbackOnAct = function(self, t)
		local nb_friends = 0
		local act
		for i = 1, #self.fov.actors_dist do
			act = self.fov.actors_dist[i]
			if act and self:reactionToward(act) > 0 and self:canSee(act) then nb_friends = nb_friends + 1 end
		end
		if nb_friends > 1 then
			nb_friends = math.min(nb_friends, 5)
			self:setEffect(self.EFF_THROUGH_THE_CROWD, 4, {power=nb_friends * 10})
		end
	end,
	activate = function(self, t)
		local ret = {}
		self:talentTemporaryValue(ret, "nullify_all_friendlyfire", 1)
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[你 习 惯 与 大 部 队 一 起:
		 --你 可 以 与 友 好 生 物 进 行 一 次 换 位， 消 耗 1/10 回 合。
		 --激 活 该 技 能 时 你 不 会 伤 害 友 方 生 物。 
		 --视 野 内 每 有 一 名 友 好 生 物， 你 获 得 10 点 全 体 豁 免 。 ]])
		:format()
	end,
}

uberTalent{
	name = "Swift Hands",
	mode = "passive",
	on_learn = function(self, t)
		self:attr("quick_weapon_swap", 1)
		self:attr("quick_equip_cooldown", 1)
		self:attr("quick_wear_takeoff", 1)
	end,
	on_unlearn = function(self, t)
		self:attr("quick_weapon_swap", -1)
		self:attr("quick_equip_cooldown", -1)
		self:attr("quick_wear_takeoff", -1)
	end,
	info = function(self, t)
		return ([[你 的 手 指 灵 巧 的 超 乎 想 象， 切 换 主/ 副 武 器  ( 默 认 Q 键 )、装 备/ 卸 下 装 备 不 再 消 耗 回 合。 
		 该 效 果 一 回 合 只 能 触 发 一 次 。
		 同 时， 当 装 备 有 附 加 技 能 的 物 品 时， 其 附 加 技 能 也 会 冷 却 完 毕。 ]])
		:format()
	end,
}

uberTalent{
	name = "Windblade",
	mode = "activated",
	require = { special={desc="曾使用双持武器造成超过50000点伤害", fct=function(self) return self.damage_log and self.damage_log.weapon.dualwield and self.damage_log.weapon.dualwield >= 50000 end} },
	cooldown = 12,
	radius = 4,
	range = 1,
	tactical = { ATTACK = { PHYSICAL=2 }, DISABLE = { disarm = 2 } },
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t)}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and target ~= self then
				local hit = self:attackTarget(target, nil, 3.2, true)
				if hit and target:canBe("disarm") then
					target:setEffect(target.EFF_DISARMED, 4, {})
				end
			end
		end)
		self:addParticles(Particles.new("meleestorm", 1, {radius=4, img="spinningwinds_blue"}))

		return true
	end,
	info = function(self, t)
		return ([[你 挥 动 武 器 疯 狂 旋 转， 产 生 剑 刃 风 暴， 对 4 码 范 围 内 所 有 敌 人 造 成 320％ 的 武 器 伤 害， 并 缴 械 它 们 4 回 合。  ]])
		:format()
	end,
}

uberTalent{
	name = "Windtouched Speed",
	mode = "passive",
	require = { special={desc="掌握至少20级使用失衡值的技能", fct=function(self) return knowRessource(self, "equilibrium", 20) end} },
	on_learn = function(self, t)
		self:attr("global_speed_add", 0.2)
		self:attr("avoid_pressure_traps", 1)
		self:recomputeGlobalSpeed()
	end,
	on_unlearn = function(self, t)
		self:attr("global_speed_add", -0.2)
		self:attr("avoid_pressure_traps", -1)
		self:recomputeGlobalSpeed()
	end,
	info = function(self, t)
		return ([[你 和 大 自 然 产 生 共 鸣， 在 与 奥 术 势 力 的 战 斗 中 受 到 她 的 赐 福。 
		 你 的 整 体 速 度 永 久 提 高 20％， 且 不 会 触 发 压 力 式 陷 阱。 ]])
		:format()
	end,
}

uberTalent{
	name = "Giant Leap",
	mode = "activated",
	require = { special={desc="曾使用武器或徒手造成超过50000点伤害", fct=function(self) return 
		self.damage_log and (
			(self.damage_log.weapon.twohanded and self.damage_log.weapon.twohanded >= 50000) or
			(self.damage_log.weapon.shield and self.damage_log.weapon.shield >= 50000) or
			(self.damage_log.weapon.dualwield and self.damage_log.weapon.dualwield >= 50000) or
			(self.damage_log.weapon.other and self.damage_log.weapon.other >= 50000)
		)
	end} },
	cooldown = 20,
	radius = 1,
	range = 10,
	tactical = { CLOSEIN = 2, ATTACK = { PHYSICAL = 2 }, DISABLE = { daze = 1 } },
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t)}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)

		if game.level.map(x, y, Map.ACTOR) then
			x, y = util.findFreeGrid(x, y, 1, true, {[Map.ACTOR]=true})
			if not x then return end
		end

		if game.level.map:checkAllEntities(x, y, "block_move") then return end

		local ox, oy = self.x, self.y
		self:move(x, y, true)
		if config.settings.tome.smooth_move > 0 then
			self:resetMoveAnim()
			self:setMoveAnim(ox, oy, 8, 5)
		end

		self:project(tg, self.x, self.y, function(px, py, tg, self)
			local target = game.level.map(px, py, Map.ACTOR)
			if target and target ~= self then
				local hit = self:attackTarget(target, nil, 2, true)
				if hit and target:canBe("stun") then
					target:setEffect(target.EFF_DAZED, 3, {})
				end
			end
		end)

		return true
	end,
	info = function(self, t)
		return ([[你 跃 向 目 标 地 点， 对 1 码 半 径 范 围 内 的 所 有 敌 人 造 成 200％ 的 武 器 伤 害， 并 眩 晕 目 标 3 回 合。  ]])
		:format()
	end,
}

uberTalent{
	name = "Crafty Hands",
	mode = "passive",
	require = { special={desc="学会5级的附魔技能", fct=function(self)
		return self:getTalentLevelRaw(self.T_IMBUE_ITEM) >= 5
	end} },
	info = function(self, t)
		return ([[你 心 灵 手 巧， 打 造 技 艺 已 趋 于 炉 火 纯 青， 可 以 给 头 盔 和 腰 带 镶 嵌 宝 石。 ]])
		:format()
	end,
}

uberTalent{
	name = "Roll With It",
	mode = "sustained",
	cooldown = 10,
	tactical = { ESCAPE = 1 },
	require = { special={desc="曾被击退50次以上", fct=function(self) return self:attr("knockback_times") and self:attr("knockback_times") >= 50 end} },
	-- Called by default projector in mod.data.damage_types.lua
	getMult = function(self, t) return self:combatLimit(self:getDex(), 0.7, 0.9, 50, 0.85, 100) end, -- Limit > 70% damage taken
	activate = function(self, t)
		local ret = {}
		self:talentTemporaryValue(ret, "knockback_on_hit", 1)
		self:talentTemporaryValue(ret, "movespeed_on_hit", {speed=3, dur=1})
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[ 你 学 会 选 择 在 需 要 的 时 候 借 力 抽 身， 受 到 的 所 有 物 理 伤 害 降 低 %d%%。 
		 当 被 近 战 或 者 远 程 攻 击 命 中 时， 你 会 借 势 后 退 一 码 ( 这 个 效 果 每 轮 只 能 触 发 一 次 )， 并 获 得 1 回 合 的 200％ 移 动 加 速。
		 受 敏 捷 影 响， 伤 害 降 低 幅 度 增 加， 且 作 用 于 物 理 抗 性 后。 ]])
		:format(100*(1-t.getMult(self, t)))
	end,
}

uberTalent{
	name = "Vital Shot",
	no_energy = "fake",
	cooldown = 10,
	range = archery_range,
	require = { special={desc="曾使用远程武器造成50000点伤害", fct=function(self) return self.damage_log and self.damage_log.weapon.archery and self.damage_log.weapon.archery >= 50000 end} },
	tactical = { ATTACK = { weapon = 3 }, DISABLE = 3 },
	requires_target = true,
	on_pre_use = function(self, t, silent) if not self:hasArcheryWeapon() then if not silent then game.logPlayer(self, "You require a bow or sling for this talent.") end return false end return true end,
	archery_onhit = function(self, t, target, x, y)
		if target:canBe("stun") then
			target:setEffect(target.EFF_STUNNED, 5, {apply_power=self:combatAttack()})
		end
		target:setEffect(target.EFF_CRIPPLE, 5, {speed=0.50, apply_power=self:combatAttack()})
	end,
	action = function(self, t)
		local targets = self:archeryAcquireTargets(nil, {one_shot=true})
		if not targets then return end
		self:archeryShoot(targets, t, nil, {mult=4.5})
		return true
	end,
	info = function(self, t)
		return ([[你 对 着 目 标 要 害 射 出 一 发， 使 目 标 受 到 重 创。 
		 受 到 攻 击 的 敌 人 将 会 承 受 450％ 武 器 伤 害， 并 且 由 于 受 到 重 创， 还 会 被 震 慑 和 残 废 ( 减 少 50％ 攻 击、 施 法 和 精 神 速 度 )5 回 合。 
		 受 命 中 影 响， 震 慑 和 残 废 几 率 有 额 外 加 成。 ]]):format()
	end,
}
