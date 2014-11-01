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
	name = "Rage",
	type = {"wild-gift/summon-augmentation", 1},
	require = gifts_req1,
	points = 5,
	equilibrium = 5,
	cooldown = 15,
	range = 10,
	np_npc_use = true,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t, first_target="friend"}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty or not target or not target.summoner or not target.summoner == self or not target.wild_gift_summon then return nil end
		target:setEffect(target.EFF_ALL_STAT, 10, {power=self:mindCrit(self:combatTalentMindDamage(t, 10, 100))/4})
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		return ([[提 升 1 只 召 唤 兽 的 杀 戮 速 度， 增 加 它 %d 点 所 有 属 性， 持 续 10 回 合。]]):format(self:combatTalentMindDamage(t, 10, 100)/4)
	end,
}

newTalent{
	name = "Detonate",
	type = {"wild-gift/summon-augmentation", 2},
	require = gifts_req2,
	points = 5,
	equilibrium = 5,
	cooldown = 25,
	range = 10,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8, 0.5, 0, 0, true)) end,
	requires_target = true,
	no_npc_use = true,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t, first_target="friend"}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty or not target or not target.summoner or not target.summoner == self or not target.wild_gift_summon or not target.wild_gift_detonate then return nil end

		local dt = self:getTalentFromId(target.wild_gift_detonate)

		if not dt.on_detonate then
			game.logPlayer("You may not detonate this summon.")
			return nil
		end

		dt.on_detonate(self, t, target)
		target:die(self)

		local l = {}
		for tid, cd in pairs(self.talents_cd) do
			local t = self:getTalentFromId(tid)
			if t.is_summon then l[#l+1] = tid end
		end
		if #l > 0 then 
			self.talents_cd[rng.table(l)] = nil
		end

		game:playSoundNear(self, "talents/fireflash")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[献 祭 1 只 召 唤 兽， 使 它 在 %d 码 范 围 内 爆 炸。 
		- 里 奇 之 焰： 形 成 1 个 火 球。 
		- 三 头 蛇： 形 成 1 个 电 球、 酸 液 球 或 毒 球。 
		- 雾 凇： 形 成 1 个 冰 球。 
		- 火 龙： 形 成 一 片 火 焰。 
		- 战 争 猎 犬： 形 成 1 个 能 造 成 物 理 伤 害 的 球。 
		- 史 莱 姆： 形 成 一 片 能 减 速 的 淤 泥。 
		- 米 诺 陶 斯： 形 成 1 团 锋 利 的 刺 球， 切 割 所 有 敌 人。 
		- 岩 石 傀 儡： 击 退 所 有 敌 人。 
		- 乌 龟： 给 所 有 友 方 单 位 提 供 1 个 小 护 盾。 
		- 蜘 蛛： 定 住 周 围 所 有 的 敌 人。 
		 此 外， 随 机 的 某 个 召 唤 技 能 会 冷 却 完 毕。 
		 献 祭 产 生 的 负 面 效 果 不 会 影 响 到 你 或 你 的 召 唤 兽。
		 受 意 志 影 响， 效 果 有 额 外 加 成。]]):format(radius)
	end,
}

newTalent{
	name = "Resilience",
	type = {"wild-gift/summon-augmentation", 3},
	require = gifts_req3,
	mode = "passive",
	points = 5,
	incCon = function(self, t) return math.floor(self:combatTalentScale(t, 2, 10, 0.75)) end,
	info = function(self, t)
		return ([[提 升 你 所 有 召 唤 物 %d点体质，并 在 计 算 召 唤 物 剩 余 时 间 时 增 加 %0.1f 点 技 能 等 级。]]):format(t.incCon(self, t), self:getTalentLevel(t))
	end,
}

newTalent{
	name = "Phase Summon",
	type = {"wild-gift/summon-augmentation", 4},
	require = gifts_req4,
	points = 5,
	equilibrium = 5,
	cooldown = 25,
	range = 10,
	requires_target = true,
	np_npc_use = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty or not target or not target.summoner or not target.summoner == self or not target.wild_gift_summon then return nil end

		local dur = t.getDuration(self, t)
		self:setEffect(self.EFF_EVASION, dur, {chance=50})
		target:setEffect(target.EFF_EVASION, dur, {chance=50})

		-- Displace
		game.level.map:remove(self.x, self.y, Map.ACTOR)
		game.level.map:remove(target.x, target.y, Map.ACTOR)
		game.level.map(self.x, self.y, Map.ACTOR, target)
		game.level.map(target.x, target.y, Map.ACTOR, self)
		self.x, self.y, target.x, target.y = target.x, target.y, self.x, self.y

		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		return ([[与 1 只 召 唤 兽 调 换 位 置。 这 会 干 扰 你 的 敌 人， 使 你 和 该 召 唤 兽 获 得 50%% 闪 避 状 态， 持 续 %d 回 合。]]):format(t.getDuration(self, t))
	end,
}
