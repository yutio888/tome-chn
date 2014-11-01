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
	name = "Resolve",
	type = {"wild-gift/antimagic", 1},
	require = gifts_req1,
	mode = "passive",
	points = 5,
	getRegen = function(self, t) return 1 + (self:combatTalentMindDamage(t, 1, 10) /10) end,
	getResist = function(self, t) return self:combatTalentMindDamage(t, 10, 40) end,
	on_absorb = function(self, t, damtype)
		if not DamageType:get(damtype).antimagic_resolve then return end

		if not self:isTalentActive(self.T_ANTIMAGIC_SHIELD) then
			self:incEquilibrium(-t.getRegen(self, t))
			self:incStamina(t.getRegen(self, t))
		end
		self:setEffect(self.EFF_RESOLVE, 7, {damtype=damtype, res=self:mindCrit(t.getResist(self, t))})
		game.logSeen(self, "%s is invigorated by the attack!", self.name:capitalize())
	end,
	info = function(self, t)
		local resist = t.getResist(self, t)
		local regen = t.getRegen(self, t)
		return ([[你 选 择 了 站 在 魔 法 的 对 立 面。 那 些 未 能 杀 死 你 的 磨 难 将 使 你 更 加 强 大。 
		 每 次 你 受 到 一 种 非 物 理、 非 精 神 攻 击 时， 你 能 增 加 %d%% 对 该 类 型 伤 害 的 抵 抗， 持 续 7 回 合。 
		 如 果 没 有 激 活 反 魔 法 护 盾， 你 同 时 还 可 以 吸 收 部 分 能 量， 每 次 吸 收 的 能 量 会 降 低 失 衡 值 并 增 加 %0.2f 体 力 值。  
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(	resist, regen )
	end,
}

newTalent{
	name = "Aura of Silence",
	type = {"wild-gift/antimagic", 2},
	require = gifts_req2,
	points = 5,
	equilibrium = 20,
	cooldown = 10,
	tactical = { DISABLE = { silence = 4 } },
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 5, 11.5)) end,
	getduration = function(self, t) return math.floor(self:combatTalentLimit(t, 10, 3.5, 5.6)) end, -- Limit <10
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.SILENCE, {dur=t.getduration(self,t), power_check=self:combatMindpower()})
		game.level.map:particleEmitter(self.x, self.y, 1, "shout", {size=4, distorion_factor=0.3, radius=self:getTalentRadius(t), life=30, nb_circles=8, rm=0.8, rM=1, gm=0, gM=0, bm=0.5, bM=0.8, am=0.6, aM=0.8})
		return true
	end,
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[发 出 一 次 音 波 冲 击， 沉 默 你 自 己 和 周 围 目 标 %d 回 合， 有 效 范 围 %d 码。 
		 受 精 神 强 度 影 响， 沉 默 几 率 有 额 外 加 成。]]):
		format(t.getduration(self,t), rad)
	end,
}

newTalent{
	name = "Antimagic Shield",
	type = {"wild-gift/antimagic", 3},
	require = gifts_req3,
	mode = "sustained",
	points = 5,
	sustain_equilibrium = 30,
	cooldown = 20,
	range = 10,
	tactical = { DEFEND = 2 },
	getMax = function(self, t)
		local v = self:combatTalentMindDamage(t, 20, 80)
		if self:knowTalent(self.T_TRICKY_DEFENSES) then
			v = v * (1 + self:callTalent(self.T_TRICKY_DEFENSES,"shieldmult"))
		end
		return v
	end,
	on_damage = function(self, t, damtype, dam)
		if not DamageType:get(damtype).antimagic_resolve then return dam end

		if dam <= self.antimagic_shield then
			self:incEquilibrium(dam / 30)
			dam = 0
		else
			self:incEquilibrium(self.antimagic_shield / 30)
			dam = dam - self.antimagic_shield
		end

		if not self:equilibriumChance() then
			self:forceUseTalent(self.T_ANTIMAGIC_SHIELD, {ignore_energy=true})
			game.logSeen(self, "#GREEN#The antimagic shield of %s crumbles.", self.name)
		end
		return dam
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		return {
			am = self:addTemporaryValue("antimagic_shield", t.getMax(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("antimagic_shield", p.am)
		return true
	end,
	info = function(self, t)
		return ([[给 你 增 加 一 个 护 盾， 每 次 被 攻 击 吸 收 最 多 %d 点 非 物 理、 非 精 神 元 素 伤 害。  
		 每 吸 收 30 点 伤 害 都 会 增 加 1 点 失 衡 值， 并 进 行 一 次 鉴 定， 若 鉴 定 失 败， 则 护 盾 会 破 碎 且 技 能 会 进 入 冷 却 状 态。 
		 受 精 神 强 度 影 响， 护 盾 的 最 大 伤 害 吸 收 值 有 额 外 加 成。]]):
		format(t.getMax(self, t))
	end,
}

newTalent{
	name = "Mana Clash",
	type = {"wild-gift/antimagic", 4},
	require = gifts_req4,
	points = 5,
	equilibrium = 10,
	cooldown = 8,
	range = 10,
	tactical = { ATTACK = { ARCANE = 3 } },
	direct_hit = true,
	requires_target = true,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end

			local base = self:mindCrit(self:combatTalentMindDamage(t, 20, 460))
			DamageType:get(DamageType.MANABURN).projector(self, px, py, DamageType.MANABURN, base)
		end, nil, {type="slime"})
		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local base = self:combatTalentMindDamage(t, 20, 460)
		local mana = base
		local vim = base / 2
		local positive = base / 4
		local negative = base / 4

		return ([[从 目 标 身 上 吸 收 %d 点 法 力， %d 点 活 力， %d 点 正 负 能 量， 并 触 发 一 次 链 式 反 应， 引 发 一 次 奥 术 对 撞。 
		 奥 术 对 撞 造 成 相 当 于 100%% 吸 收 的 法 力 值 或 200%% 吸 收 的 活 力 值 或 400%% 吸 收 的 正 负 能 量 的 伤 害， 按 最 高 值 计 算。 
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(mana, vim, positive, negative)
	end,
}
