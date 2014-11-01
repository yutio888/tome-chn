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
	name = "azdadazdazdazd",
	type = {"wild-gift/malleable-body", 1},
	require = gifts_req1,
	points = 5,
	equilibrium = 10,
	cooldown = 30,
	no_energy = true,
	tactical = { BUFF = 2 },
	getDur = function(self, t) return math.max(5, math.floor(self:getTalentLevel(t) * 2)) end,
	action = function(self, t)

		return true
	end,
	info = function(self, t)
		local dur = t.getDur(self, t)
		return ([[你 的 身 体 变 的 像 软 泥 怪 一 样， 你 可 以 分 裂 成 2 个， 持 续 %d 回 合。 
		 你 的 本 体 获 得 原 始 的 软 泥 特 性， 而 分 裂 体 则 获 得 酸 性 特 性。
		 如 果 你 习 得 软 泥 之 刃 系 技 能 树， 则 该 技 能 树 会 变 为 腐 蚀 之 刃 技 能 树。 
		 你 和 分 裂 体 共 享 生 命。 
		 当 你 分 裂 时， 你 增 加 %d%% 所 有 抵 抗。 
		 受 精 神 强 度 影 响， 抵 抗 有 额 外 加 成。]]):
		format(dur, 10 + self:combatTalentMindDamage(t, 5, 200) / 10)
	end,
}

newTalent{
	name = "ervevev",
	type = {"wild-gift/malleable-body", 2},
	require = gifts_req2,
	points = 5,
	mode = "passive",
	getPower = function(self, t) return 20 + self:combatTalentMindDamage(t, 5, 500) / 10 end,

	info = function(self, t)
		local p = t.getPower(self, t)
		return ([[强 化 你 的 孢 子 使 其 能 够 参 与 到 你 的 治 疗 作 用 中。 
		 每 当 你 受 到 治 疗 时， 你 会 得 到 一 个 持 续 6 回 合 的 回 复 效 果， 回 复 值 为 你 所 受 治 疗 值 的 %d%% 。 
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(p)
	end,
}

newTalent{
	name = "zeczczeczec", 
	type = {"wild-gift/malleable-body", 3},
	require = gifts_req3,
	points = 5,
	equilibrium = 5,
	cooldown = 8,

	action = function(self, t)

		return true
	end,
	info = function(self, t)
		return ([[你 和 分 裂 体 相 互 交 换 位 置， 误 导 敌 人， 使 敌 人 的 目 标 锁 定 为 另 一 个 分 身。 
		 当 你 和 分 裂 体 交 换 位 置 时， 双 方 进 行 了 短 暂 的 融 合。 增 加 %d%% 自 然 和 酸 性 伤 害， 持 续 6 回 合， 同 时 治 疗 你 %d 点 生 命 值。
		 受 精 神 强 度 影 响， 伤 害 和 治 疗 量 有 额 外 加 成。]]):
		format(15 + self:combatTalentMindDamage(t, 5, 300) / 10, 40 + self:combatTalentMindDamage(t, 5, 300))
	end,
}

newTalent{
	name = "Indiscernible Anatomyblabla",
	type = {"wild-gift/malleable-body", 4},
	require = gifts_req4,
	points = 5,
	mode = "passive",
	on_learn = function(self, t)
		self:attr("ignore_direct_crits", 15)
	end,
	on_unlearn = function(self, t)
		self:attr("ignore_direct_crits", -15)
	end,
	info = function(self, t)
		return ([[你 身 体 的 内 部 器 官 融 化 在 一 起， 使 你 更 难 遭 受 致 命 打 击。 
		 所 有 对 你 产 生 的 直 接 暴 击（ 物 理、 精 神、 法 术） 都 会 有 %d%% 几 率 变 成 普 通 攻 击。]]):
		format(self:getTalentLevelRaw(t) * 15)
	end,
}
