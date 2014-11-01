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
	name = "Telekinetic Smash",
	type = {"psionic/psi-fighting", 1},
	require = psi_cun_req1,
	points = 5,
	random_ego = "attack",
	cooldown = 8,
	psi = 10,
	range = 1,
	requires_target = true,
	tactical = { ATTACK = { PHYSICAL = 2 } },
	duration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
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
		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 0.9, 1.5), true)
		if self:getInven(self.INVEN_PSIONIC_FOCUS) then
			for i, o in ipairs(self:getInven(self.INVEN_PSIONIC_FOCUS)) do
				if o.combat and not o.archery then
					self:attackTargetWith(target, o.combat, nil, self:combatTalentWeaponDamage(t, 0.9, 1.5))
				end
			end
		end
		if hit and target:canBe("stun") then
			target:setEffect(target.EFF_STUNNED, t.duration(self,t), {apply_power=self:combatMindpower()})
		end
		self:attr("use_psi_combat", -1)
		return true
	end,
	info = function(self, t)
		return ([[凝 集 你 的 意 念 ，用 主 手 武 器 和 念 动 武 器 狂 莽 地 砸 击 你 的 目 标 ，造 成 %d%% 武 器 伤 害 。
		 如 果 你 的 主 手 武 器 命 中 ，将 震 慑 目 标 %d 回 合 。
		 此 次 攻 击 根 据 意 志 和 灵 巧 来 判 定 伤 害 和 命 中 ，取 代 力 量 和 敏 捷 。
		 此 次 攻 击 中 任 何 激 活 光 环 的 伤 害 附 加 将 会 沿 用 到 武 器 上 。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.9, 1.5), t.duration(self,t))
	end,
}

newTalent{
	name = "Augmentation",
	type = {"psionic/psi-fighting", 2},
	require = psi_cun_req2,
	points = 5,
	mode = "sustained",
	cooldown = 0,
	sustain_psi = 10,
	no_energy = true,
	tactical = { BUFF = 2 },
	getMult = function(self, t) return self:combatTalentScale(t, 0.07, 0.25) end,
	activate = function(self, t)
		local str_power = t.getMult(self, t)*self:getWil()
		local dex_power = t.getMult(self, t)*self:getCun()
		return {
			stats = self:addTemporaryValue("inc_stats", {
				[self.STAT_STR] = str_power,
				[self.STAT_DEX] = dex_power,
			}),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("inc_stats", p.stats)
		return true
	end,
	info = function(self, t)
		local inc = t.getMult(self, t)
		local str_power = inc*self:getWil()
		local dex_power = inc*self:getCun()
		return ([[当 开 启 时 ， 你  为 了 你 的 血 肉 之 躯 精 准 地 灌 布 精 神 之 力 。 分 别 增 加 意 志 和 灵 巧 的 %d%% 至 力 量 和 敏 捷。
		力 量 增 加 %d 点
		敏 捷 增 加 %d 点]]):
		format(inc*100, str_power, dex_power)
	end,
}

newTalent{
	name = "Warding Weapon",
	type = {"psionic/psi-fighting", 3},
	require = psi_cun_req3,
	points = 5,
	cooldown = 10,
	psi = 15,
	no_energy = true,
	tactical = { BUFF = 2 },
	getWeaponDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.75, 1.1) end,
	getChance = function(self, t) return math.floor(self:combatStatLimit("cun", 100, 5, 30)) end,
	action = function(self, t)
		self:setEffect(self.EFF_WEAPON_WARDING, 1, {})
		return true
	end,
	info = function(self, t)
		return ([[用 意 念 进 行 防 御 。
		 下 一 个 回 合 ，你 的 念 动 武 器 会 完 全 格 挡 对 你 的 第 一 次 近 战 攻 击 ，并 反 击 攻 击 者 造 成 %d%% 武 器 伤 害 。
		 技 能 等 级 3 时 你 还 能 缴 械 攻 击 者 3 回 合 。
		 技 能 等 级 5 时 每 回 合 你 有 %d%% 几 率 被 动 格 挡 一 次 近 战 攻 击 ，并 消 耗 1 5 点 超 能 力 值 。 几 率 受 灵 巧 加 成 。 
		 这 个 技 能 需 要 一 把 主 手 武 器 和 一 把 念 动 武 器 。]]):
		format(100 * t.getWeaponDamage(self, t), t.getChance(self, t))
	end,
}

newTalent{
	name = "Impale",
	type = {"psionic/psi-fighting", 4},
	require = psi_cun_req4,
	points = 5,
	random_ego = "attack",
	cooldown = 10,
	psi = 20,
	range = 3,
	requires_target = true,
	tactical = { ATTACK = { PHYSICAL = 2 } },
	getDamage = function (self, t) return math.floor(self:combatTalentMindDamage(t, 12, 340)) end,
	getWeaponDamage = function(self, t) return self:combatTalentWeaponDamage(t, 1.5, 2.6) end,
	getShatter = function(self, t) return self:combatTalentLimit(t, 100, 10, 85) end,
	action = function(self, t)
		local weapon = self:getInven(self.INVEN_PSIONIC_FOCUS) and self:getInven(self.INVEN_PSIONIC_FOCUS)[1]
		if type(weapon) == "boolean" then weapon = nil end
		if not weapon or self:attr("disarmed")then
			game.logPlayer(self, "You cannot do that without a weapon in your telekinetic slot.")
			return nil
		end
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 3 then return nil end
		local speed, hit = self:attackTargetWith(target, weapon.combat, nil, t.getWeaponDamage(self, t))
		if hit and target:canBe("cut") then
			target:setEffect(target.EFF_CUT, 4, {power=t.getDamage(self,t)/4, apply_power=self:combatMindpower()})
		end

		if hit and rng.percent(t.getShatter(self, t)) and self:getTalentLevel(t) >= 3 then
			local effs = {}

			-- Go through all shield effects
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.status == "beneficial" and e.subtype and e.subtype.shield then
					effs[#effs+1] = {"effect", eff_id}
				end
			end

			for i = 1, 1 do
				if #effs == 0 then break end
				local eff = rng.tableRemove(effs)

				if eff[1] == "effect" then
					game.logSeen(self, "#CRIMSON#%s shatters %s shield!", self.name:capitalize(), target.name)
					target:removeEffect(eff[2])
				end
			end
		end
		return true
	end,
	info = function(self, t)
		return ([[将 你 的 意 志 灌 入 你 的 念 动 武 器 ，使 它 猛 力 推 进 并 刺 穿 你 的 目 标 并 恶 毒 的 绞 开 它 的 身 体 。
		 这 次 攻 击 将 造 成 %d%% 武 器 伤 害 ，并 使 目 标 流 血 4 回 合 ，累 计 造 成 %0.1f 物 理 伤 害 。
		 在 3 级 时 ，武 器 将 势 不 可 挡 地 突 进 ，有 %d%% 几 率 击 碎 目 标 身 上 一 个 临 时 性 的 伤 害 护 盾 （如 果 存 在 ）。
		 判 定 此 次 攻 击 的 伤 害 和 命 中 时 ，意 志 和 灵 巧 讲 替 代 力 量 和 敏 捷 。
		 流 血 伤 害 随 精 神 强 度 增 加 。]]):
		format(100 * t.getWeaponDamage(self, t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self,t)), t.getShatter(self, t))
	end,
}



