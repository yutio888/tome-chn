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
	name = "Willful Tormenter",
	type = {"corruption/torment", 1},
	require = corrs_req1,
	mode = "sustained",
	points = 5,
	cooldown = 20,
	tactical = { BUFF = 2 },
	VimBonus = function(self, t) return self:combatTalentScale(t, 20, 75, 0.75) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/flame")
		return {
			vim = self:addTemporaryValue("max_vim", t.VimBonus(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("max_vim", p.vim)

		while self:getMaxVim() < 0 do
			local l = {}
			for tid, _ in pairs(self.sustain_talents) do
				local t = self:getTalentFromId(tid)
				if t.sustain_vim then l[#l+1] = tid end
			end
			if #l == 0 then break end
			self:forceUseTalent(rng.table(l), {ignore_energy=true, no_equilibrium_fail=true, no_paradox_fail=true})
		end

		return true
	end,
	info = function(self, t)
		return ([[你 将 精 神 集 中 于 一 个 目 标： 摧 毁 所 有 敌 人。 
		 增 加 你 %d 点 活 力 上 限。]]):
		format(t.VimBonus(self, t))
	end,
}

newTalent{
	name = "Blood Lock",
	type = {"corruption/torment", 2},
	require = corrs_req2,
	points = 5,
	cooldown = 16,
	vim = 12,
	range = 10,
	radius = 2,
	tactical = { DISABLE = 1 },
	direct_hit = true,
	no_energy = true,
	requires_target = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), talent=t}
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 12)) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end
			target:setEffect(target.EFF_BLOOD_LOCK, t.getDuration(self, t), {src=self, dam=self:combatTalentSpellDamage(t, 4, 90), apply_power=self:combatSpellpower()})
		end)
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[掌 控 敌 人 的 血 液 和 肉 体。 在 2 码 范 围 内， 任 何 被 鲜 血 禁 锢 攻 击 到 的 敌 人 的 治 疗 或 回 复 将 不 能 超 过 当 前 生 命 值， 持 续 %d 回 合。]]):
		format(t.getDuration(self, t))
	end,
}

newTalent{
	name = "Overkill",
	type = {"corruption/torment", 3},
	require = corrs_req3,
	points = 5,
	mode = "sustained",
	cooldown = 20,
	sustain_vim = 18,
	tactical = { BUFF = 2 },
	oversplash = function(self,t) return self:combatLimit(self:combatTalentSpellDamage(t, 10, 70), 100, 20, 0, 66.7, 46.7) end, -- Limit to <100%
	activate = function(self, t)
		game:playSoundNear(self, "talents/flame")
		return {ov = self:addTemporaryValue("overkill", t.oversplash(self,t)),}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("overkill", p.ov)
		return true
	end,
	info = function(self, t)
		return ([[当 你 杀 死 一 个 敌 人 后， 多 余 的 伤 害 不 会 消 失。 
		 反 之 %d%% 的 伤 害 会 溅 落 在 2 码 范 围 内， 造 成 枯 萎 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(t.oversplash(self,t))
	end,
}

newTalent{
	name = "Blood Vengeance",
	type = {"corruption/torment", 4},
	require = corrs_req4,
	points = 5,
	mode = "sustained",
	cooldown = 20,
	getPower = function(self, t) return self:combatTalentLimit(t, 5, 15, 10), self:combatLimit(self:combatTalentSpellDamage(t, 10, 90), 100, 20, 0, 50, 61.3) end, -- Limit threshold > 5%, chance < 100%
	sustain_vim = 22,
	tactical = { BUFF = 2 },
	activate = function(self, t)
		local l, c = t.getPower(self, t)
		game:playSoundNear(self, "talents/flame")
		return {
			l = self:addTemporaryValue("reduce_spell_cooldown_on_hit", l),
			c = self:addTemporaryValue("reduce_spell_cooldown_on_hit_chance", c),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("reduce_spell_cooldown_on_hit", p.l)
		self:removeTemporaryValue("reduce_spell_cooldown_on_hit_chance", p.c)
		return true
	end,
	info = function(self, t)
		local l, c = t.getPower(self, t)
		return ([[当 你 遭 受 到 超 过 至 少 %d%% 总 生 命 值 的 伤 害 时， 你 有 %d%% 概 率 降 低 所 有 技 能 1 回 合 冷 却 时 间。 
		 受 法 术 强 度 影 响， 概 率 有 额 外 加 成。]]):
		format(l, c)
	end,
}
