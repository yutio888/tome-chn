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
	name = "Radiant Fear",
	type = {"cursed/dark-figure", 1},
	require = cursed_wil_req1,
	points = 5,
	cooldown = 50,
	hate = 1,
	getRadius = function(self, t) return 3 + math.floor((self:getTalentLevelRaw(t) - 1) / 2) end,
	getDuration = function(self, t) return 5 + math.floor(self:getTalentLevel(t) * 2) end,
	tactical = { DISABLE = 2 },
	requires_target = true,
	range = 6,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end

		if core.fov.distance(self.x, self.y, x, y) > self:getTalentRange(t) then
			game.logPlayer(self, "You are too far to from the target!")
			return nil
		end

		local radius = t.getRadius(self, t)
		local duration = t.getDuration(self, t)

		target:setEffect(target.EFF_RADIANT_FEAR, duration, { radius = radius, knockback = 1, source = self })

		return true
	end,
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local duration = t.getDuration(self, t)
		return ([[恐 惧 %d 码 半 径 内 的 目 标 以 驱 逐 他 们， 持 续 %d 回 合。]]):format(radius, duration)
	end,
}

newTalent{
	name = "Suppression",
	type = {"cursed/dark-figure", 2},
	mode = "passive",
	require = cursed_wil_req2,
	points = 5,
	on_learn = function(self, t)
	end,
	on_unlearn = function(self, t)
	end,
	getPercent = function(self, t) return 15 + math.floor(self:getTalentLevel(t) * 10) end,
	info = function(self, t)
		local percent = t.getPercent(self, t)
		return ([[长 年 对 抗 诅 咒 的 经 历 使 你 能 够 自 我 控 制。 大 部 分 非 魔 法 效 果 的 持 续 时 间 减 少 %d%% 。]]):format(percent)
	end,
}

newTalent{
	name = "Cruel Vigor",
	type = {"cursed/dark-figure", 3},
	mode = "passive",
	require = cursed_wil_req3,
	points = 5,
	on_learn = function(self, t)
	end,
	on_unlearn = function(self, t)
	end,
	on_kill = function(self, t)
		local speed = t.getSpeed(self, t)
		local duration = t.getDuration(self, t)
		self:setEffect(self.EFF_INVIGORATED, duration, { speed = speed })
	end,
	getSpeed = function(self, t) return 20 + math.floor(self:getTalentLevel(t) * 5) end,
	getDuration = function(self, t) return 3 end,
	info = function(self, t)
		local speed = t.getSpeed(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 被 周 围 的 死 亡 所 鼓 舞。 你 每 杀 死 一 个 单 位 提 供 你 %d%% 的 速 度， 持 续 %d 更 多 回 合。]]):format(100 + speed, duration)
	end,
}

--newTalent{
--	name = "Tools of the Trade",
--	type = {"cursed/dark-figure", 3},
--	mode = "passive",
--	require = cursed_wil_req3,
--	points = 5,
--	on_learn = function(self, t)
--	end,
--	on_unlearn = function(self, t)
--	end,
--	identify = function(self, t, object)
--		if object.level_range and object.level_range[1] <= self:getTalentLevel(t) * 10 then
--			object:identify(true)
--			game.logPlayer(self, "You have identified the %s.", object:getName{no_count=true})
--		end
--	end,
--	info = function(self, t)
--		return ([[Your obsessions have lead you to a greater knowledge of the tools of death, allowing you to identify weapons and armor that you pick up. You can identify more powerful items as you increase your skill.]])
--	end,
--}

newTalent{
	name = "Pity",
	type = {"cursed/dark-figure", 4},
	mode = "sustained", no_sustain_autoreset = true,
	require = cursed_wil_req4,
	points = 5,
	cooldown = 10,
	allow_autocast = true,
	no_energy = true,
	tactical = { BUFF = 3 },
	range = function(self, t) return 9 - math.floor(self:getTalentLevel(t) * 0.7) end,
	activate = function(self, t)
		local res = {
			pityId = self:addTemporaryValue("pity", self:getTalentRange(t))
		}
		self:resetCanSeeCacheOf()
		return res
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("pity", p.pityId)
		self:resetCanSeeCacheOf()
		return true
	end,
	info = function(self, t)
		local range = t.range(self, t)
		return ([[你 收 起 可 怕 的 本 质 伪 装 成 可 怜 虫。 那 些 在 %d 码 外 看 到 你 的 敌 人 将 忽 略 你。 
		 当 你 攻 击 或 使 用 技 能 时， 它 们 会 看 穿 你 的 本 质， 怜 悯 技 能 将 失 效。]]):format(range)
	end,
}

