-- ToME - Tales of Middle-Earth
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

local Emote = require "engine.Emote"

newTalent{
	name = "Shadow Senses",
	type = {"cursed/one-with-shadows", 1},
	require = cursed_cun_req_high1,
	mode = "passive",
	points = 5,
	no_npc_use = true,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, 1)) end,
	info = function(self, t)
		return ([[ 你 的 意 识 延 伸 到 阴  影 上 。
		 你 能 清 晰 的 感 知 到 阴 影 的 位 置 ， 同 时 还 能 感 知 到 阴 影 视 野 %d 码 范 围 内 的 敌 人 。]])
		:format(self:getTalentRange(t))
	end,
}

newTalent{
	name = "Shadow Empathy",
	type = {"cursed/one-with-shadows", 2},
	require = cursed_cun_req_high2,
	points = 5,
	hate = 10,
	cooldown = 25,
	getRandomShadow = function(self, t)
		local shadows = {}
		if game.party and game.party:hasMember(self) then
			for act, def in pairs(game.party.members) do
				if act.summoner and act.summoner == self and act.is_doomed_shadow and not act.dead then
					shadows[#shadows+1] = act
				end
			end
		else
			for uid, act in pairs(game.level.entities) do
				if act.summoner and act.summoner == self and act.is_doomed_shadow and not act.dead then
					shadows[#shadows+1] = act
				end
			end
		end
		return #shadows > 0 and rng.table(shadows)
	end,
	getDur = function(self, t) return math.floor(self:combatTalentScale(t, 3, 10)) end,
	getPower = function(self, t) return 5 + self:combatTalentMindDamage(t, 0, 300) / 8 end,
	action = function(self, t)
		self:setEffect(self.EFF_SHADOW_EMPATHY, t.getDur(self, t), {power=t.getPower(self, t)})
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		local duration = t.getDur(self, t)
		return ([[ 你 连 接 到 你 的 阴 影  ， 持 续 %d 回 合 ，将 你 受 到 的 伤 害 的 %d%% 转 移 至 随 机 某 个 阴 影 上。
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。 ]]):
		format(duration, power)
	end,
}

newTalent{
	name = "Shadow Transposition",
	type = {"cursed/one-with-shadows", 3},
	require = cursed_cun_req_high3,
	points = 5,
	hate = 6,
	cooldown = 10,
	no_npc_use = true,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1, 15, 1)) end,
	getNb = function(self, t) return math.floor(self:combatTalentScale(t, 1, 3, 1)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRadius(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, target.x, target.y) > self:getTalentRadius(t) then return nil end
		if target.summoner ~= self or not target.is_doomed_shadow then return end

		-- Displace
		local tx, ty, sx, sy = target.x, target.y, self.x, self.y
		target.x = nil target.y = nil
		self.x = nil self.y = nil
		target:move(sx, sy, true)
		self:move(tx, ty, true)

		self:removeEffectsFilter(function(t) return (t.type == "physical" or t.type == "magical") and t.status == "detrimental" end, t.getNb(self, t))

		return true
	end,
	info = function(self, t)
		return ([[ 现 在 ， 其 他 人 很 难 分 清 你 和 阴 影 。 
 	 	 你 能 选 择 半 径 %d 范 围 内 的 一 个 阴 影 并 和 它 交 换 位 置 。
		 同 时 至 多 %d 个 随 机 负 面 物 理 或 魔 法 效 果 会 被 转 移 至 选 择 的 阴 影 身 上 。]])
		:format(self:getTalentRadius(t), t.getNb(self, t))
	end,
}

newTalent{
	name = "Shadow Decoy",
	type = {"cursed/one-with-shadows", 4},
	require = cursed_cun_req_high4,
	mode = "sustained",
	cooldown = 10,
	points = 5,
	cooldown = 50,
	sustain_hate = 40,
	getPower = function(self, t) return 10 + self:combatTalentMindDamage(t, 0, 300) end,
	onDie = function(self, t, value, src)
		local shadow = self:callTalent(self.T_SHADOW_EMPATHY, "getRandomShadow")
		if not shadow then return false end

		game:delayedLogDamage(src, self, 0, ("#GOLD#(%d 诱饵)#LAST#"):format(value), false)
		game:delayedLogDamage(src, shadow, value, ("#GOLD#%d 诱饵#LAST#"):format(value), false)
		shadow:takeHit(value, src)
		self:setEffect(self.EFF_SHADOW_DECOY, 4, {power=t.getPower(self, t)})
		self:forceUseTalent(t.id, {ignore_energy=true})

		if self.player then
			self:setEmote(Emote.new("Fools, you never killed me; that was only my shadow!", 45))
			world:gainAchievement("AVOID_DEATH", self)
		end
		return true
	end,
	activate = function(self, t)
		return {}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[ 你 的 阴 影 用 生 命 来 守 护 你 。
		 当 你 受 到 致 命 攻 击 时 ，你 将 立 刻 和 随 机 一个 阴 影 换 位 ， 让 它 代 替 承 受 攻 击，  并 将此 技 能 打 入 冷 却 。
		 在 接 下 来 的 4 个 回 合 ， 除 非 你 的 生 命 降 至 - %d 下 ， 否 则 你不 会 死 去 。 但 当 生 命 值 在 0 以 下 时，  你 不 能 看 到 确 切 值 。
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成 。 ]]):
		format(t.getPower(self, t))
	end,
}
