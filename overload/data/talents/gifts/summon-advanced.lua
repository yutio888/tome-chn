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
	name = "Master Summoner",
	type = {"wild-gift/summon-advanced", 1},
	require = gifts_req_high1,
	mode = "sustained",
	points = 5,
	sustain_equilibrium = 20,
	cooldown = 10,
	range = 10,
	tactical = { BUFF = 2 },
	getCooldownReduction = function(self, t) return util.bound(self:getTalentLevelRaw(t) / 15, 0.05, 0.3) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		local particle
		if self:addShaderAura("master_summoner", "awesomeaura", {time_factor=6200, alpha=0.7, flame_scale=0.8}, "particles_images/naturewings.png") then
			--
		elseif core.shader.active(4) then
			particle = self:addParticles(Particles.new("shader_ring_rotating", 1, {radius=1.1}, {type="flames", zoom=2, npow=4, time_factor=4000, color1={0.2,0.7,0,1}, color2={0,1,0.3,1}, hide_center=0, xy={self.x, self.y}}))
		else
			particle = self:addParticles(Particles.new("master_summoner", 1))
		end
		return {
			cd = self:addTemporaryValue("summon_cooldown_reduction", t.getCooldownReduction(self, t)),
			particle = particle,
		}
	end,
	deactivate = function(self, t, p)
		self:removeShaderAura("master_summoner")
		self:removeParticles(p.particle)
		self:removeTemporaryValue("summon_cooldown_reduction", p.cd)
		return true
	end,
	info = function(self, t)
		local cooldownred = t.getCooldownReduction(self, t)
		return ([[降 低 所 有 召 唤 系 技 能 %d%% 冷 却 时 间。]]):
		format(cooldownred * 100)
	end,
}

newTalent{
	name = "Grand Arrival",
	type = {"wild-gift/summon-advanced", 2},
	require = gifts_req_high2,
	points = 5,
	mode = "passive",
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.3, 3.7, "log")) end,
	effectDuration = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	nbEscorts = function(self, t) return math.max(1,math.floor(self:combatTalentScale(t, 0.3, 2.7, "log"))) end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[当 召 唤 精 通 激 活 时， 每 个 召 唤 兽 出 现 在 世 界 上 时， 它 会 触 发 1 个 野 性 效 果： 
		 - 里 奇 之 焰： 减 少 范 围 内 所 有 敌 人 的 火 焰 抵 抗 
		 - 三 头 蛇： 生 成 一 片 持 续 的 毒 雾 
		 - 雾 凇： 减 少 范 围 内 所 有 敌 人 的 寒 冷 抵 抗 
		 - 火 龙： 出 现 %d 只 小 火 龙 
		 - 战 争 猎 犬： 减 少 范 围 内 所 有 敌 人 的 物 理 抵 抗 
		 - 史 莱 姆： 减 少 范 围 内 所 有 敌 人 的 自 然 抵 抗 
		 - 米 诺 陶 斯： 减 少 范 围 内 所 有 敌 人 的 移 动 速 度 
		 - 岩 石 傀 儡： 眩 晕 范 围 内 所 有 敌 人 
		 - 乌 龟： 治 疗 范 围 内 所 有 友 军 单 位 
		 - 蜘 蛛： 蜘 蛛 如 此 的 丑 陋， 以 至 于 附 近 所 有 敌 人 都 会 被 吓 退。
		 效 果 范 围 %d ， 每 个 持 续 效 果 维 持 %d 回 合 。 
		 受 意 志 影 响， 效 果 有 额 外 加 成。]]):format(t.nbEscorts(self, t), radius, t.effectDuration(self, t))
	end,
}

newTalent{
	name = "Nature's Cycle", short_name = "NATURE_CYCLE",
	type = {"wild-gift/summon-advanced", 3},
	require = gifts_req_high3,
	mode = "passive",
	points = 5,
	getChance = function(self, t) return math.min(100, 30 + self:getTalentLevel(t) * 15) end,
	getReduction = function(self, t) return math.floor(self:combatTalentLimit(t, 5, 1, 3.1)) end, -- Limit < 5
	info = function(self, t)
		return ([[当 召 唤 精 通 激 活 时， 每 出 现 新 的 召 唤 兽 会 减 少 狂 怒、 引 爆 和 野 性 召 唤 的 冷 却 时 间。 
		%d%% 概 率 减 少 它 们 %d 回 合 冷 却 时 间。]]):format(t.getChance(self, t), t.getReduction(self, t))
	end,
}

newTalent{
	name = "Wild Summon",
	type = {"wild-gift/summon-advanced", 4},
	require = gifts_req_high4,
	points = 5,
	equilibrium = 9,
	cooldown = 25,
	range = 10,
	tactical = { BUFF = 5 },
	no_energy = true,
	on_pre_use = function(self, t, silent)
		return self:isTalentActive(self.T_MASTER_SUMMONER)
	end,
	duration = function(self, t) return  math.floor(self:combatTalentLimit(t, 25, 1, 5)) end, -- Limit <25
	action = function(self, t)
		self:setEffect(self.EFF_WILD_SUMMON, t.duration(self,t), {chance=100})
		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		return ([[你 在 %d 回 合 内 100%% 召 唤 出 一 只 野 性 模 式 的 召 唤 兽。 
		 此 概 率 每 回 合 递 减。
		 野 性 召 唤 兽 增 加 1 个 新 的 天 赋： 
		- 里 奇 之 焰： 使 身 上 围 绕 一 团 火 焰 并 击 退 敌 人 
		- 三 头 蛇： 可 以 从 近 战 中 脱 离 
		- 雾 凇： 提 高 魔 法 抵 抗 
		- 火 龙： 可 以 用 怒 吼 来 沉 默 敌 人 
		- 战 争 猎 犬： 可 以 狂 暴， 增 加 它 的 暴 击 率 和 护 甲 穿 透 值 
		- 史 莱 姆： 可 以 吞 掉 生 命 值 较 低 的 敌 人， 回 复 你 的 自 然 失 衡 值 
		- 米 诺 陶 斯： 可 以 向 目 标 冲 锋 
		- 岩 石 傀 儡： 近 战 攻 击 有 溅 射 效 果 
		- 乌 龟： 可 以 嘲 讽 范 围 内 敌 人 进 入 近 战 状 态 
		- 蜘 蛛： 可 以 向 目 标 吐 出 剧 毒， 减 少 它 们 的 治 疗 效 果 
		 此 技 能 只 有 在 召 唤 精 通 激 活 时 才 能 使 用。]]):format(t.duration(self,t))
	end,
}
