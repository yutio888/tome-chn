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
	name = "Heightened Senses",
	type = {"cunning/survival", 1},
	require = cuns_req1,
	mode = "passive",
	points = 5,
	sense = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	trapPower = function(self, t) return self:combatScale(self:getTalentLevel(t) * self:getCun(25, true), 0, 0, 125, 125) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "heightened_senses", t.sense(self, t))
	end,
	info = function(self, t)
		return ([[你 注 意 到 他 人 注 意 不 到 的 细 节， 甚 至 能 在 阴 影 区 域 “ 看 到 ” 怪 物， %d 码 半 径 范 围。 
		 注 意 此 能 力 不 属 于 心 灵 感 应， 仍 然 受 到 视 野 的 限 制。 
		 同 时 你 的 细 致 观 察 也 能 使 你 发 现 周 围 的 陷 阱 (%d 侦 查 强 度 )。 
		 在 等 级 3 时， 你 学 会 拆 除 已 发 现 的 陷 阱 (%d 拆 除 强 度 )。 
		 受 灵 巧 影 响， 陷 阱 侦 查 强 度 和 拆 除 强 度 有 额 外 加 成。]]):
		format(t.sense(self,t),t.trapPower(self,t),t.trapPower(self,t))
	end,
}

newTalent{
	name = "Charm Mastery",
	type = {"cunning/survival", 2},
	require = cuns_req2,
	mode = "passive",
	points = 5,
	cdReduc = function(tl) 
		if tl <=0 then return 0 end
		return math.floor(100*tl/(tl+7.5)) --I5 Limit < 100%
	end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "use_object_cooldown_reduce", t.cdReduc(self:getTalentLevel(t))) --I5
	end,
--	on_unlearn = function(self, t)
--	end,
	info = function(self, t)
		return ([[你 灵 活 的 头 脑， 使 你 可 以 更 加 有 效 的 使 用 饰 品（ 魔 杖、 图 腾 和 项 圈）， 减 少 %d%% 饰 品 的 冷 却 时 间。]]):
		format(t.cdReduc(self:getTalentLevel(t))) --I5
	end,
}

newTalent{
	name = "Piercing Sight",
	type = {"cunning/survival", 3},
	require = cuns_req3,
	mode = "passive",
	points = 5,
	--  called by functions _M:combatSeeStealth and _M:combatSeeInvisible functions mod\class\interface\Combat.lua	
	seePower = function(self, t) return self:combatScale(self:getCun(15, true)*self:getTalentLevel(t), 5, 0, 80, 75) end, --I5 
	info = function(self, t)
		return ([[你 比 大 多 数 人 都 更 加 注 意 仔 细 观 察 周 围 的 动 静， 使 你 能 发 觉 隐 形 和 潜 行 的 生 物。 
		 提 升 侦 测 潜 行 等 级 %d 并 提 升 侦 测 隐 形 等 级 %d 。 
		 受 灵 巧 影 响， 你 的 侦 查 强 度 有 额 外 加 成。]]):
		format(t.seePower(self,t), t.seePower(self,t))
	end,
}

newTalent{
	name = "Evasion",
	type = {"cunning/survival", 4},
	points = 5,
	require = cuns_req4,
	random_ego = "defensive",
	tactical = { ESCAPE = 2, DEFEND = 2 },
	cooldown = 30,
	getDur = function(self) return math.floor(self:combatStatLimit("wil", 30, 6, 15)) end, -- Limit < 30
	getChanceDef = function(self, t)
		if self.perfect_evasion then return 100, 0 end
		return self:combatLimit(5*self:getTalentLevel(t) + self:getCun(25,true) + self:getDex(25,true), 50, 10, 10, 37.5, 75),
		self:combatScale(self:getTalentLevel(t) * (self:getCun(25, true) + self:getDex(25, true)), 0, 0, 55, 250, 0.75)
		-- Limit evasion chance < 50%, defense bonus ~= 55 at level 50
	end,
	action = function(self, t)
		local dur = t.getDur(self)
		local chance, def = t.getChanceDef(self,t)
		self:setEffect(self.EFF_EVASION, dur, {chance=chance, defense = def})
		return true
	end,
	info = function(self, t)
		local chance, def = t.getChanceDef(self,t)
		return ([[你 敏 捷 的 身 手 允 许 你 预 判 即 将 到 来 的 攻 击， 允 许 你 有 %d%% 的 概 率 完 全 躲 避 它 们 并 提 供 %d 点 闪 避 ， 持 续 %d 回 合。 
		 受 意 志 影 响， 持 续 时 间 有 额 外 加 成； 
		 受 灵 巧 和 敏 捷 影 响， 闪 避 率 和 闪 避 有 额 外 加 成。]]):
		format(chance, def,t.getDur(self))
	end,
}
