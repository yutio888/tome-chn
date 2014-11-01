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
	name = "Disperse Magic",
	type = {"spell/meta",1},
	require = spells_req1,
	points = 5,
	random_ego = "utility",
	mana = 40,
	cooldown = 7,
	tactical = { DISABLE = 2 },
	direct_hit = true,
	requires_target = function(self, t) return self:getTalentLevel(t) >= 3 end,
	range = 10,
	getRemoveCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	action = function(self, t)
		local target = self

		if self:getTalentLevel(t) >= 3 then
			local tg = {type="hit", range=self:getTalentRange(t)}
			local tx, ty = self:getTarget(tg)
			if tx and ty and game.level.map(tx, ty, Map.ACTOR) then
				local _ _, tx, ty = self:canProject(tg, tx, ty)
				if not tx then return nil end
				target = game.level.map(tx, ty, Map.ACTOR)
				if not target then return nil end

				target = game.level.map(tx, ty, Map.ACTOR)
			else return nil
			end
		end

		local effs = {}

		-- Go through all spell effects
		if self:reactionToward(target) < 0 then
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.type == "magical" and e.status == "beneficial" then
					effs[#effs+1] = {"effect", eff_id}
				end
			end

			-- Go through all sustained spells
			for tid, act in pairs(target.sustain_talents) do
				if act then
					local talent = target:getTalentFromId(tid)
					if talent.is_spell then effs[#effs+1] = {"talent", tid} end
				end
			end
		else
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.type == "magical" and e.status == "detrimental" then
					effs[#effs+1] = {"effect", eff_id}
				end
			end
		end

		for i = 1, t.getRemoveCount(self, t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				target:removeEffect(eff[2])
			else
				target:forceUseTalent(eff[2], {ignore_energy=true})
			end
		end
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[驱 散 目 标 身 上 的 %d 种 魔 法 效 果（ 敌 方 单 位 的 增 益 状 态 和 友 方 单 位 的 负 面 状 态）。 
		 在 等 级 3 时 可 以 选 择 目 标。]]):
		format(count)
	end,
}

newTalent{
	name = "Spellcraft",
	type = {"spell/meta",2},
	require = spells_req2,
	points = 5,
	sustain_mana = 70,
	cooldown = 30,
	mode = "sustained",
	tactical = { BUFF = 2 },
	getChance = function(self, t) return self:getTalentLevelRaw(t) * 20 end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
		return {
			cd = self:addTemporaryValue("spellshock_on_damage", self:combatTalentSpellDamage(t, 10, 320) / 4),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("spellshock_on_damage", p.cd)
		return true
	end,
	info = function(self, t)
		local chance = t.getChance(self, t)
		return ([[你 学 会 精 确 调 节 你 的 攻 击 技 能。 
		 你 试 图 控 制 自 己 的 攻 击 性 魔 法， 尝 试 在 攻 击 范 围 中 留 出 空 隙， 避 免 伤 及 自 身， %d%% 成 功 概 率。 
		 如 果 你 的 法 术 强 度 等 级 超 过 目 标 法 术 豁 免 等 级， 你 的 攻 击 法 术 将 会 对 目 标 产 生 法 术 冲 击。 此 技 能 将 赋 予 你 提 高 %d 法 术 强 度 的 加 成 用 于 判 定 目 标 的 法 术 豁 免。 被 法 术 冲 击 目 标 暂 时 减 少 20%% 伤 害 抵 抗。]]):
		format(chance, self:combatTalentSpellDamage(t, 10, 320) / 4)
	end,
}

newTalent{
	name = "Quicken Spells",
	type = {"spell/meta",3},
	require = spells_req3,
	points = 5,
	mode = "sustained",
	sustain_mana = 80,
	cooldown = 30,
	tactical = { BUFF = 2 },
	getCooldownReduction = function(self, t) return util.bound(self:getTalentLevelRaw(t) / 15, 0.05, 0.3) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
		return {
			cd = self:addTemporaryValue("spell_cooldown_reduction", t.getCooldownReduction(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("spell_cooldown_reduction", p.cd)
		return true
	end,
	info = function(self, t)
		local cooldownred = t.getCooldownReduction(self, t)
		return ([[减 少 %d%% 所 有 法 术 冷 却 时 间。]]):
		format(cooldownred * 100)
	end,
}

newTalent{
	name = "Metaflow",
	type = {"spell/meta",4},
	require = spells_req4,
	points = 5,
	mana = 70,
	cooldown = 50,
	tactical = { BUFF = 2 },
	getTalentCount = function(self, t) return math.floor(self:combatTalentScale(t, 2, 7, "log")) end,
	getMaxLevel = function(self, t) return self:getTalentLevel(t) end,
	action = function(self, t)
		local tids = {}
		for tid, _ in pairs(self.talents_cd) do
			local tt = self:getTalentFromId(tid)
			if tt.type[2] <= t.getMaxLevel(self, t) and tt.is_spell then
				tids[#tids+1] = tid
			end
		end
		for i = 1, t.getTalentCount(self, t) do
			if #tids == 0 then break end
			local tid = rng.tableRemove(tids)
			self.talents_cd[tid] = nil
		end
		self.changed = true
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local talentcount = t.getTalentCount(self, t)
		local maxlevel = t.getMaxLevel(self, t)
		return ([[ 你 对 奥 术 的 精 通 使 你 能 重 置 法 术 的 冷 却 时 间。 
		 重 置 至 多 %d 个法 术 的 冷 却 ， 对 技 能 层 次 %d 或 更 低 的 技 能 有 效。]]):
		format(talentcount, maxlevel)
	end,
}
