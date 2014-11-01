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
	name = "Wild Growth",
	type = {"wild-gift/fungus", 1},
	require = gifts_req1,
	points = 5,
	mode = "sustained",
	sustain_equilibrium = 15,
	cooldown = 20,
	tactical = { BUFF = 2 },
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	activate = function(self, t)
		local dur = t.getDur(self, t)
		game:playSoundNear(self, "talents/heal")
		local ret = {
			dur = self:addTemporaryValue("liferegen_dur", dur),
		}
		if self:knowTalent(self.T_FUNGAL_GROWTH) then
			local t= self:getTalentFromId(self.T_FUNGAL_GROWTH)
			ret.fg = self:addTemporaryValue("fungal_growth", t.getPower(self, t))
		end
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("liferegen_dur", p.dur)
		if p.fg then self:removeTemporaryValue("fungal_growth", p.fg) end
		return true
	end,
	info = function(self, t)
		local dur = t.getDur(self, t)
		return ([[使 你 自 身 周 围 环 绕 无 数 微 不 可 见、 有 治 疗 作 用 的 孢 子。 
		 作 用 于 你 身 上 的 任 何 回 复 效 果， 会 增 加 +%d 回 合 持 续 时 间。]]):
		format(dur)
	end,
}

newTalent{
	name = "Fungal Growth",
	type = {"wild-gift/fungus", 2},
	require = gifts_req2,
	points = 5,
	mode = "passive",
	getPower = function(self, t) return self:combatLimit(self:combatTalentMindDamage(t, 5, 500), 100, 20, 0, 56.8, 368.5) end, --limit <100%
	info = function(self, t)
		local p = t.getPower(self, t)
		return ([[强 化 你 的 孢 子 使 其 能 够 参 与 到 你 的 治 疗 作 用 中。 
		 每 当 你 受 到 治 疗 时， 你 会 得 到 一 个 持 续 6 回 合 的 回 复 效 果， 回 复 值 为 你 所 受 治 疗 值 的 %d%% 。 
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(p)
	end,
}

newTalent{
	name = "Ancestral Life",
	type = {"wild-gift/fungus", 3},
	require = gifts_req3,
	points = 5,
	mode = "passive",
	getEq = function(self, t) return self:combatTalentScale(t, 0.5, 2.5, 0.5, 0.5) end,
	getTurn = function(self, t) return util.bound(50 + self:combatTalentMindDamage(t, 5, 500) / 10, 50, 160) end,
	info = function(self, t)
		local eq = t.getEq(self, t)
		local turn = t.getTurn(self, t)
		return ([[你 的 孢 子 可 以 追 溯 到 创 世 纪 元， 你 可 以 传 承 来 自 远 古 的 天 赋。  
		 每 当 一 个 新 的 回 复 效 果 作 用 到 你 身 上 时， 你 增 加 %d%% 的 增 益 回 合。  
		 同 时， 每 当 你 受 到 回 复 作 用 时， 每 回 合 你 的 失 衡 值 将 会 减 少 %0.1f 。 
		 受 精 神 强 度 影 响， 增 益 回 合 有 额 外 加 成。]]):
		format(turn, eq)
	end,
}

newTalent{
	name = "Sudden Growth",
	type = {"wild-gift/fungus", 4},
	require = gifts_req4,
	points = 5,
	equilibrium = 22,
	cooldown = 25,
	tactical = { HEAL = function(self, t, target) return self.life_regen * 10 end },
	getMult = function(self, t) return util.bound(5 + self:getTalentLevel(t), 3, 12) end,
	action = function(self, t)
		local amt = self.life_regen * t.getMult(self, t)

		self:heal(amt, t)

		game:playSoundNear(self, "talents/heal")
		return true
	end,
	info = function(self, t)
		local mult = t.getMult(self, t)
		return ([[一 股 强 大 的 能 量 穿 过 你 的 孢 子， 使 其 立 刻 对 你 释 放 治 愈 性 能 量， 治 疗 你 %d%% 当 前 生 命 回 复 值。]]):
		format(mult * 100)
	end,
}
