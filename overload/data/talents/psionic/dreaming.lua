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
	name = "Sleep",
	type = {"psionic/dreaming", 1},
	points = 5, 
	require = psi_wil_req1,
	cooldown = function(self, t) return math.max(4, 9 - self:getTalentLevelRaw(t)) end,
	psi = 5,
	tactical = { DISABLE = {sleep = 1} },
	direct_hit = true,
	requires_target = true,
	range = 7,
	radius = function(self, t) return math.floor(self:combatTalentScale(t, 1.25, 2.25)) end,
	target = function(self, t) return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), talent=t} end,
	getDuration = function(self, t) return math.ceil(self:combatTalentScale(t, 2.1, 3.5)) end,
	getInsomniaPower= function(self, t)
		local t = self:getTalentFromId(self.T_SANDMAN)
		local reduction = t.getInsomniaPower(self, t)
		return 20 - reduction
	end,
	getSleepPower = function(self, t) 
		local power = self:combatTalentMindDamage(t, 5, 25) -- This probably needs a buff
		if self:knowTalent(self.T_SANDMAN) then
			local t = self:getTalentFromId(self.T_SANDMAN)
			power = power * t.getSleepPowerBonus(self, t)
		end
		return math.ceil(power)
	end,
	doContagiousSleep = function(self, target, p, t)
		local tg = {type="ball", radius=1, talent=t}
		self:project(tg, target.x, target.y, function(tx, ty)
			local t2 = game.level.map(tx, ty, Map.ACTOR)
			if t2 and t2 ~= target and rng.percent(p.contagious) and t2:canBe("sleep") and not t2:hasEffect(t2.EFF_SLEEP) then
				t2:setEffect(t2.EFF_SLEEP, p.dur, {src=self, power=p.power, waking=p.waking, insomnia=p.insomnia, no_ct_effect=true, apply_power=self:combatMindpower()})
				game.level.map:particleEmitter(target.x, target.y, 1, "generic_charge", {rm=0, rM=0, gm=100, gM=200, bm=200, bM=255, am=35, aM=90})
			end
		end)
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		--Contagious?
		local is_contagious = 0
		if self:getTalentLevel(t) >= 5 then
			is_contagious = 25
		end
		--Restless?
		local is_waking =0
		if self:knowTalent(self.T_RESTLESS_NIGHT) then
			local t = self:getTalentFromId(self.T_RESTLESS_NIGHT)
			is_waking = t.getDamage(self, t)
		end

		local power = self:mindCrit(t.getSleepPower(self, t))
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if target then
				if target:canBe("sleep") then
					target:setEffect(target.EFF_SLEEP, t.getDuration(self, t), {src=self, power=power,  contagious=is_contagious, waking=is_waking, insomnia=t.getInsomniaPower(self, t), no_ct_effect=true, apply_power=self:combatMindpower()})
					game.level.map:particleEmitter(target.x, target.y, 1, "generic_charge", {rm=0, rM=0, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})
				else
					game.logSeen(self, "%s resists the sleep!", target.name:capitalize())
				end
			end
		end)
		game:playSoundNear(self, "talents/dispel")
		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		local power = t.getSleepPower(self, t)
		local insomnia = t.getInsomniaPower(self, t)
		return([[使 %d 码 半 径 范 围 内 的 目 标 陷 入 %d 回 合 的 睡 眠 状 态 中， 使 它 们 无 法 行 动。 它 们 每 承 受 %d 点 伤 害， 睡 眠 的 持 续 时 间 减 少 一 回 合。 
		 当 睡 眠 结 束 时， 目 标 会 饱 受 失 眠 的 痛 苦， 持 续 回 合 等 于 已 睡 眠 的 回 合 数（ 但 最 多 10 回 合）， 失 眠 状 态 的 每 一 个 剩 余 回 合 数 会 让 目 标 获 得 %d%% 睡 眠 免 疫。 
		 在 等 级 5 时， 睡 眠 会 具 有 传 染 性， 每 回 合 有 25％ 几 率 传 播 向 附 近 的 目 标。 
		 受 精 神 强 度 影 响， 伤 害 临 界 点 按 比 例 加 成。]]):format(radius, duration, power, insomnia)
	end,
}

newTalent{
	name = "Lucid Dreamer",
	type = {"psionic/dreaming", 2},
	points = 5,
	require = psi_wil_req2,
	mode = "sustained",
	sustain_psi = 20,
	cooldown = 12,
	tactical = { BUFF=2 },
	getPower = function(self, t) return self:combatTalentMindDamage(t, 5, 25) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/heal")
		local power = t.getPower(self, t)
		local ret = {
			phys = self:addTemporaryValue("combat_physresist", power),
			mental = self:addTemporaryValue("combat_mentalresist", power),
			spell = self:addTemporaryValue("combat_spellresist", power),
			dreamer = self:addTemporaryValue("lucid_dreamer", power),
			sleep = self:addTemporaryValue("sleep", 1),
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_physresist", p.phys)
		self:removeTemporaryValue("combat_mentalresist", p.mental)
		self:removeTemporaryValue("combat_spellresist", p.spell)
		self:removeTemporaryValue("lucid_dreamer", p.dreamer)
		self:removeTemporaryValue("sleep", p.sleep)
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		return ([[你 进 入 清 晰 梦 境。 在 此 状 态 下， 你 虽 然 处 于 睡 眠 状 态 但 仍 可 以 行 动， 并 且 对 失 眠 免 疫， 对 失 眠 状 态 下 的 目 标 附 加 %d%% 伤 害， 同 时， 你 的 物 理、 法 术 和 精 神 豁 免 增 加 %d 点。 
		 注 意 在 睡 眠 状 态 下 会 使 你 降 低 对 特 定 负 面 状 态 的 抵 抗（ 例 如 心 魔， 暗 夜 恐 惧 和 梦 靥 行 者）。 
		 受 精 神 强 度 影 响， 豁 免 增 益 效 果 按 比 例 加 成。]]):format(power, power)
	end,
}

newTalent{
	name = "Dream Walk",
	type = {"psionic/dreaming", 3},
	points = 5, 
	require = psi_wil_req3,
	psi= 10,
	cooldown = 10,
	tactical = { ESCAPE = 1, CLOSEIN = 1 },
	range = 7,
	radius = function(self, t) return math.max(0, 7 - math.floor(self:getTalentLevel(t))) end,
	requires_target = true,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t)}
	end,
	direct_hit = true,
	is_teleport = true,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		if not self:hasLOS(x, y) or game.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") then
			game.logPlayer(self, "You do not have line of sight to this location.")
			return nil
		end
		local __, x, y = self:canProject(tg, x, y)
		local teleport = self:getTalentRadius(t)
		target = game.level.map(x, y, Map.ACTOR)
		if (target and target:attr("sleep")) or game.zone.is_dream_scape then
			teleport = 0
		end
		
		game.level.map:particleEmitter(x, y, 1, "generic_teleport", {rm=0, rM=0, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})

		-- since we're using a precise teleport we'll look for a free grid first
		local tx, ty = util.findFreeGrid(x, y, 5, true, {[Map.ACTOR]=true})
		if tx and ty then
			if not self:teleportRandom(tx, ty, teleport) then
				game.logSeen(self, "The dream walk fizzles!")
			end
		end

		game.level.map:particleEmitter(self.x, self.y, 1, "generic_teleport", {rm=0, rM=0, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})
		game:playSoundNear(self, "talents/teleport")

		return true
	end,
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[你 穿 越 梦 境， 出 现 在 某 个 目 标 地 点 附 近 （%d 码 传 送 误 差）。
		 如 果 目 标 为 处 于 睡 眠 状 态 的 生 物， 你 将 会 出 现 在 离 目 标 最 近 的 地 方。]]):format(radius)
	end,
}

newTalent{
	name = "Dream Prison",
	type = {"psionic/dreaming", 4},
	points = 5,
	require = psi_wil_req4,
	mode = "sustained",
	sustain_psi = 40,
	cooldown = function(self, t) return math.floor(self:combatTalentLimit(t, 0, 45, 25)) end, -- Limit > 0
	tactical = { DISABLE = function(self, t, target) if target and target:attr("sleep") then return 4 else return 0 end end},
	range = 7,
	requires_target = true,
	target = function(self, t)
		return {type="ball", radius=self:getTalentRange(t), range=0}
	end,
	direct_hit = true,
	getDrain = function(self, t) return 5 - math.min(4, self:getTalentLevel(t)/2) end,
	remove_on_zero = true,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
		local drain = self:getMaxPsi() * t.getDrain(self, t) / 100
		local ret = {
			drain = self:addTemporaryValue("psi_regen", -drain),
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("psi_regen", p.drain)
		return true
	end,
	info = function(self, t)
		local drain = t.getDrain(self, t)
		return ([[将 范 围 内 所 有 睡 眠 状 态 的 目 标 囚 禁 在 梦 境 牢 笼 里， 有 效 地 延 长 他 们 的 睡 眠 效 果， 这 个 强 大 的 技 能 每 回 合 会 持 续 消 耗 %d 点 超 能 力 值， 并 且 运 用 了 灵 能 通 道， 所 以 当 你 移 动 时 会 中 断 此 技 能。 
		 注 意： 每 回 合 可 产 生 的 睡 眠 附 加 状 态， 如 梦 靥 的 伤 害 和 入 梦 的 传 染 效 果， 将 在 此 效 果 持 续 过 程 中 失 效。]]):format(drain)
	end,
}