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
	name = "Slumber",
	type = {"psionic/slumber", 1},
	points = 5,
	require = psi_wil_req1,
	cooldown = 8,
	psi = 10,
	tactical = { DISABLE = {sleep = 2} },
	direct_hit = true,
	requires_target = true,
	range = 7,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getDuration = function(self, t) return math.ceil(self:combatTalentScale(t, 2.3, 4.3)) end,
	getInsomniaPower = function(self, t)
		local t = self:getTalentFromId(self.T_SANDMAN)
		local reduction = t.getInsomniaPower(self, t)
		return 20 - reduction
	end,
	getSleepPower = function(self, t)
		local power = self:combatTalentMindDamage(t, 10, 100)
		if self:knowTalent(self.T_SANDMAN) then
			local t = self:getTalentFromId(self.T_SANDMAN)
			power = power * t.getSleepPowerBonus(self, t)
		end
		return math.ceil(power)
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		target = game.level.map(x, y, Map.ACTOR)
		if not target then return nil end

		--Restless?
		local is_waking =0
		if self:knowTalent(self.T_RESTLESS_NIGHT) then
			local t = self:getTalentFromId(self.T_RESTLESS_NIGHT)
			is_waking = t.getDamage(self, t)
		end

		local power = self:mindCrit(t.getSleepPower(self, t))
		if target:canBe("sleep") then
			target:setEffect(target.EFF_SLUMBER, t.getDuration(self, t), {src=self, power=power, waking=is_waking, insomnia=t.getInsomniaPower(self, t), no_ct_effect=true, apply_power=self:combatMindpower()})
			game.level.map:particleEmitter(target.x, target.y, 1, "generic_charge", {rm=180, rM=200, gm=100, gM=120, bm=30, bM=50, am=70, aM=180})
		else
			game.logSeen(self, "%s resists the sleep!", target.name:capitalize())
		end
		game:playSoundNear(self, "talents/dispel")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getSleepPower(self, t)
		local insomnia = t.getInsomniaPower(self, t)
		return([[目 标 进 入 持 续 %d 回 合 的 深 睡 眠， 使 其 无 法 进 行 任 何 动 作。 目 标 每 承 受 %d 伤 害， 睡 眠 的 持 续 时 间 减 少 一 回 合。 
		 当 催 眠 结 束 时， 目 标 会 饱 受 失 眠 的 痛 苦， 持 续 回 合 等 于 已 睡 眠 的 回 合 数（ 但 最 多 5 回 合）， 失 眠 状 态 的 每 一 个 剩 余 回 合 数 会 让 目 标 获 得 %d%% 睡 眠 免 疫。 
		 受 精 神 强 度 影 响， 伤 害 临 界 点 有 额 外 加 成。]]):format(duration, power, insomnia)
	end,
}

newTalent{
	name = "Restless Night",
	type = {"psionic/slumber", 2},
	points = 5,
	require = psi_wil_req2,
	mode = "passive",
	getDamage = function(self, t) return self:combatTalentMindDamage(t, 5, 40) end,
	doRestlessNight = function (self, target, damage)
		local dam = self:mindCrit(damage)
		target:setEffect(target.EFF_RESTLESS_NIGHT, 5, {power=dam, src=self, no_ct_effect=true})
		game.level.map:particleEmitter(target.x, target.y, 1, "generic_discharge", {rm=180, rM=200, gm=100, gM=120, bm=30, bM=50, am=70, aM=180})
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return([[被 你 沉 睡 的 目 标 在 醒 来 时 每 行 走 一 回 合 将 承 受 %0.2f 精 神 伤 害， 持 续 5 回 合。 
		 受 精 神 强 度 影 响， 伤 害 按 比 例 加 成。]]):format(damDesc(self, DamageType.MIND, (damage)))
	end,
}

newTalent{
	name = "Sandman",
	type = {"psionic/slumber", 3},
	points = 5,
	require = psi_wil_req3,
	mode = "passive",
	getSleepPowerBonus = function(self, t) return self:combatTalentLimit(t, 2, 1.1, 1.5) end, -- Limit < 2
	getInsomniaPower = function(self, t) return self:combatTalentLimit(t, 20, 3, 10) end, -- Limit to <20%
	info = function(self, t)
		local power_bonus = t.getSleepPowerBonus(self, t) - 1
		local insomnia = t.getInsomniaPower(self, t)
		return([[增 加 %d%% 你 对 被 睡 眠 目 标 在 睡 眠 回 合 减 少 前 所 能 造 成 的 伤 害， 并 且 减 少 %d%% 你 造 成 的 失 眠 效 果 所 增 加 的 睡 眠 免 疫。 
		 这 些 效 果 将 即 时 反 映 在 技 能 描 述 中。 
		 受 精 神 强 度 影 响， 伤 害 临 界 点 的 增 益 效 果 按 比 例 加 成。]]):format(power_bonus * 100, insomnia)
	end,
}

newTalent{
	name = "Dreamscape",
	type = {"psionic/slumber", 4},
	points = 5,
	require = psi_wil_req4,
	cooldown = 24,
	psi = 40,
	not_on_random_boss = true,
	tactical = { DISABLE = function(self, t, target) if target and target.game_ender and target:attr("sleep") then return 4 else return 0 end end},
	direct_hit = true,
	requires_target = true,
	range = 7,
	target = function(self, t) return {type="hit", range=self:getTalentRange(t), talent=t} end,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 24, 6, 14)) end, -- Limit < 24
	getPower = function(self, t) return self:combatTalentMindDamage(t, 10, 100) end,
	on_pre_use = function(self, t, silent) if self:attr("is_psychic_projection") then if not silent then game.logPlayer(self, "You feel it unwise to travel to the dreamscape in such a fragile form.") end return false end return true end,
	action = function(self, t)
		if game.zone.is_dream_scape then
			game.logPlayer(self, "This talent cannot be used from within the Dreamscape.")
			return
		end
		if game.zone.no_planechange then
			game.logPlayer(self, "This talent cannot be used here.")
			return
		end

		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local tx, ty, target = self:getTarget(tg)
		if not tx or not ty or not target then return nil end
		local _ _, tx, ty = self:canProject(tg, tx, ty)
		if not tx or not ty or not target then return nil end
		target = game.level.map(tx, ty, Map.ACTOR)
		if not tx or not ty or not target then return nil end
		if not (target.player and target.game_ender) and not (self.player and self.game_ender) then return nil end
		if target == self then return end
		if target:attr("negative_status_effect_immune") or target:attr("status_effect_immune") then return nil end

		if not self:canBe("planechange") or target.summon_time or target.summon then
			game.logPlayer(self, "The spell fizzles...")
			return
		end

		if not (target and target:attr("sleep")) then
			game.logPlayer(self, "Your target must be sleeping in order to enter its dreamscape.")
			return nil
		end
		if self:reactionToward(target) >= 0 then
			game.logPlayer(self, "You can't cast this on friendly targets.")
			return nil
		end

		game:onTickEnd(function()
			if self:attr("dead") then return end
			local oldzone = game.zone
			local oldlevel = game.level

			-- Clean up thought-forms
			cancelThoughtForms(self)

			-- Remove them before making the new elvel, this way party memebrs are not removed from the old
			if oldlevel:hasEntity(self) then oldlevel:removeEntity(self) end
			if oldlevel:hasEntity(target) then oldlevel:removeEntity(target) end

			oldlevel.no_remove_entities = true
			local zone = mod.class.Zone.new("dreamscape-talent")
			local level = zone:getLevel(game, 1, 0)
			oldlevel.no_remove_entities = nil

			level:addEntity(self)
			level:addEntity(target)

			level.source_zone = oldzone
			level.source_level = oldlevel
			game.zone = zone
			game.level = level
			game.zone_name_s = nil

			local x1, y1 = util.findFreeGrid(4, 6, 20, true, {[Map.ACTOR]=true})
			if x1 then
				self:move(x1, y1, true)
				game.level.map:particleEmitter(x1, y1, 1, "generic_teleport", {rm=0, rM=0, gm=180, gM=255, bm=180, bM=255, am=35, aM=90})
			end
			local x2, y2 = util.findFreeGrid(8, 6, 20, true, {[Map.ACTOR]=true})
			if x2 then
				target:move(x2, y2, true)
			end

			target:setTarget(self)
			target.dream_plane_trapper = self
			target.dream_plane_on_die = target.on_die
			target.on_die = function(self, ...)
				self.dream_plane_trapper:removeEffect(self.EFF_DREAMSCAPE)
				local args = {...}
				game:onTickEnd(function()
					if self.dream_plane_on_die then self:dream_plane_on_die(unpack(args)) end
					self.on_die, self.dream_plane_on_die = self.dream_plane_on_die, nil
				end)
			end

			self.dream_plane_on_die = self.on_die
			self.on_die = function(self, ...)
				self:removeEffect(self.EFF_DREAMSCAPE)
				local args = {...}
				game:onTickEnd(function()
					if self.dream_plane_on_die then self:dream_plane_on_die(unpack(args)) end
					self.on_die, self.dream_plane_on_die = self.dream_plane_on_die, nil
				--	if not game.party:hasMember(self) then world:gainAchievement("FEARSCAPE", game:getPlayer(true)) end
				end)
			end

			game.logPlayer(game.player, "#LIGHT_BLUE#You are taken to the Dreamscape!")

			if game.party:hasMember(target) then game.party:learnLore("dreamscape-entry") end
		end)

		local power = self:mindCrit(t.getPower(self, t))
		self:setEffect(self.EFF_DREAMSCAPE, t.getDuration(self, t), {target=target, power=power, projections_killed=0, x=self.x, y=self.y, tx=target.x, ty=target.y})
		game:playSoundNear(self, "talents/teleport")
		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getPower(self, t)
		return([[进 入 某 个 睡 眠 状 态 目 标 的 梦 境 中， 持 续 %d 回 合。 
		 当 你 位 于 梦 境 空 间 中 时， 你 将 会 遇 到 目 标 无 敌 的 睡 眠 形 态， 每 4 回 合 它 会 制 造 出 1 个 梦 境 守 卫 来 保 护 它 的 心 灵。 
		 除 非 目 标 激 活 了 清 晰 梦 境， 否 则 梦 境 守 卫 造 成 的 普 通 伤 害 只 有 50％。 
		 当 梦 境 空 间 的 效 果 结 束 时， 你 每 摧 毁 一 个 梦 境 守 卫， 目 标 生 命 值 会 减 少 10％， 并 且 受 到 持 续 1 回 合 的 锁 脑 效 果（ 可 叠 加）。 
		 在 梦 境 空 间 中 时， 你 的 伤 害 会 提 高 %d%% 。 
		 受 精 神 强 度 影 响， 伤 害 增 益 有 额 外 加 成。]]):format(duration, power)
	end,
}
