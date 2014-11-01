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
	name = "Greater Weapon Focus",
	type = {"technique/battle-tactics", 1},
	require = techs_req_high1,
	points = 5,
	cooldown = 20,
	stamina = 25,
	tactical = { ATTACK = 3 },
	getdur = function(self,t) return math.floor(self:combatTalentLimit(t, 20, 5.3, 10.5)) end, -- Limit to <20
	getchance = function(self,t) return self:combatLimit(self:combatTalentStatDamage(t, "dex", 10, 90),100, 6.8, 6.8, 61, 61) end, -- Limit < 100%
	action = function(self, t)
		self:setEffect(self.EFF_GREATER_WEAPON_FOCUS, t.getdur(self,t), {chance=t.getchance(self, t)})
		return true
	end,
	info = function(self, t)
		return ([[专 注 于 你 的 攻 击， 每 次 攻 击 有 %d%% 概 率 对 目 标 造 成 一 次 类 似 的 附 加 伤 害， 持 续 %d 回 合。 
		此 效 果 对 所 有 攻 击， 甚 至 是 技 能 攻 击 或 盾 击 都 有 效 果。 
		受 敏 捷 影 响， 概 率 有 额 外 加 成。]]):format(t.getchance(self, t), t.getdur(self, t))
	end,
}

newTalent{ -- Doesn't scale past level 5, could use some bonus for higher talent levels
	name = "Step Up",
	type = {"technique/battle-tactics", 2},
	require = techs_req_high2,
	mode = "passive",
	points = 5,
	info = function(self, t)
		return ([[每 杀 死 1 个 敌 人 你 有 %d%% 概 率 增 加 1000%% 移 动 速 度， 持 续 一 个 标 准 游 戏 回 合。 
		此 效 果 在 你 执 行 除 移 动 外 其 他 动 作 后 立 刻 结 束。 
		注 意： 由 于 你 的 移 动 非 常 迅 速， 游 戏 回 合 会 过 的 很 慢。]]):format(math.min(100, self:getTalentLevelRaw(t) * 20))
	end,
}

newTalent{
	name = "Bleeding Edge",
	type = {"technique/battle-tactics", 3},
	require = techs_req_high3,
	points = 5,
	cooldown = 12,
	stamina = 24,
	requires_target = true,
	tactical = { ATTACK = { weapon = 1, cut = 1 }, DISABLE = 2 },
	healloss = function(self,t) return self:combatTalentLimit(t, 100, 17, 50) end, -- Limit to < 100%
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		local hit = self:attackTarget(target, nil, self:combatTalentWeaponDamage(t, 1, 1.7), true)
		if hit then
			if target:canBe("cut") then
				local sw = self:getInven("MAINHAND")
				if sw then
					sw = sw[1] and sw[1].combat
				end
				sw = sw or self.combat
				local dam = self:combatDamage(sw)
				local damrange = self:combatDamageRange(sw)
				dam = rng.range(dam, dam * damrange)
				dam = dam * self:combatTalentWeaponDamage(t, 2, 3.2)

				target:setEffect(target.EFF_DEEP_WOUND, 7, {src=self, heal_factor=t.healloss(self, t), power=dam / 7, apply_power=self:combatAttack()})
			end
		end
		return true
	end,
	info = function(self, t)
		local heal = t.healloss(self,t)
		return ([[割 裂 目 标 并 造 成 %d%% 武 器 伤 害。 
		如 果 攻 击 命 中 目 标， 则 目 标 会 持 续 流 血 7 回 合， 
		造 成 总 计 %d%% 武 器 伤 害。 在 此 过 程 中， 任 何 对 目 标 的 治 疗 效 果 减 少 %d%% 。]]):
		format(100 * self:combatTalentWeaponDamage(t, 1, 1.7), 100 * self:combatTalentWeaponDamage(t, 2, 3.2), heal)
	end,
}

-- Banned from NPCs because they tend to ignore stamina costs and in general uncapped scaling resistance is dangerous at high talent levels
-- More ideally numbers could be tweaked to make it sane on NPCs, but it would actually be pretty complicated to do
newTalent{
	name = "True Grit",
	type = {"technique/battle-tactics", 4},
	require = techs_req_high4,
	points = 5,
	mode = "sustained",
	cooldown = 30,
	sustain_stamina = 70,
	tactical = { BUFF = 2 },
--	no_npc_use = true,
	--Note: this can result in > 100% resistancs (before cap) at high talent levels to keep up with opposing resistance lowering talents
	resistCoeff = function(self, t) return self:combatTalentScale(t, 25, 45) end,
	getCapApproach = function(self, t) return self:combatTalentLimit(t, 1, 0.15, 0.5) end,
	do_turn = function(self, t) --called by mod.class.Actor:actBase
		local p = self:isTalentActive(t.id)
		if p.resid then self:removeTemporaryValue("resists", p.resid) end
		if p.cresid then self:removeTemporaryValue("resists_cap", p.cresid) end
		--This makes it impossible to get 100% resist all cap from this talent, and most npc's will get no cap increase
		local resistbonus = (1 - self.life / self.max_life)*t.resistCoeff(self, t)
		p.resid = self:addTemporaryValue("resists", {all=resistbonus})
		local capbonus = util.bound((100-(self.resists_cap.all or 100))*t.getCapApproach(self, t), 0, 100)
		p.cresid = self:addTemporaryValue("resists_cap", {all=capbonus})
	end,
	getStaminaDrain = function(self, t)
		return self:combatTalentLimit(t, 0, -14, -6 ) -- Limit <0 (no stamina regen)
	end,
	activate = function(self, t)
		return {
			stamina = self:addTemporaryValue("stamina_regen", t.getStaminaDrain(self, t))
		}
	end,
	deactivate = function(self, t, p)
		if p.resid then self:removeTemporaryValue("resists", p.resid) end
		if p.cresid then self:removeTemporaryValue("resists_cap", p.cresid) end
		self:removeTemporaryValue("stamina_regen", p.stamina)
		return true
	end,
	info = function(self, t)
		local drain = t.getStaminaDrain(self, t)
		local resistC = t.resistCoeff(self, t)
		return ([[采 取 一 个 防 守 姿 态 并 抵 抗 敌 人 的 猛 攻.
		当 你 受 伤 后 ， 你 获 得 相 当 于 %d%% 损 失 生 命 值 百 分 比 的 全 体 伤 害 抗 性。
		例 如：当你 损 失 70%% 生 命 时 获 得 %d%% 抗 性。
		同 时，你 的 全 体 伤 害 抗 性 上 限 相 比 于 100%% 差 距 将 减 少 %0.1f%%。
		每 回 合 体 力 值 %d 。
		效 果 在 每 回 合 开 始 时 刷 新。]]):
		format(resistC, resistC*0.7, t.getCapApproach(self, t)*100, drain)
	end,
}

