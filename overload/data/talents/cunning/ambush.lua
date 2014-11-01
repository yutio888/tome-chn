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

local Map = require "engine.Map"

newTalent{
	name = "Shadow Leash",
	type = {"cunning/ambush", 1},
	require = cuns_req_high1,
	points = 5,
	cooldown = 20,
	stamina = 15,
	mana = 15,
	range = 1,
	tactical = { DISABLE = {disarm = 2} },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		if core.fov.distance(self.x, self.y, x, y) > 1 then return nil end

		if target:canBe("disarm") then
			target:setEffect(target.EFF_DISARMED, t.getDuration(self, t), {apply_power=self:combatAttack()})
		else
			game.logSeen(target, "%s resists the shadow!", target.name:capitalize())
		end

		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[使 你 的 武 器 立 刻 转 化 为 暗 影 之 缚 形 态， 夺 取 目 标 武 器， 缴 械 目 标 %d 回 合。 
		 受 命 中 影 响， 技 能 命 中 率 有 额 外 加 成。]]):
		format(duration)
	end,
}

newTalent{
	name = "Shadow Ambush",
	type = {"cunning/ambush", 2},
	require = cuns_req_high2,
	points = 5,
	cooldown = 20,
	stamina = 15,
	mana = 15,
	range = 7,
	tactical = { DISABLE = {silence = 2}, CLOSEIN = 2 },
	requires_target = true,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 2, 6)) end,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t)}
		local x, y, target = self:getTarget(tg)
		if not x or not y or not target then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		target = game.level.map(x, y, Map.ACTOR)
		if not target then return nil end

		local sx, sy = util.findFreeGrid(self.x, self.y, 5, true, {[engine.Map.ACTOR]=true})
		if not sx then return end

		target:move(sx, sy, true)

		if core.fov.distance(self.x, self.y, sx, sy) <= 1 then
			if target:canBe("stun") then
				target:setEffect(target.EFF_DAZED, 2, {apply_power=self:combatAttack()})
			end
			if target:canBe("silence") then
				target:setEffect(target.EFF_SILENCED, t.getDuration(self, t), {apply_power=self:combatAttack()})
			else
				game.logSeen(target, "%s resists the shadow!", target.name:capitalize())
			end
		end

		return true
	end,
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 向 目 标 甩 出 1 道 影 之 绳 索， 将 目 标 拉 向 你 并 沉 默 它 %d 回 合， 同 时 眩 晕 目 标 2 回 合。 
		 受 命 中 影 响， 技 能 命 中 率 有 额 外 加 成。]]):
		format(duration)
	end,
}

newTalent{
	name = "Ambuscade",
	type = {"cunning/ambush", 3},
	points = 5,
	cooldown = 20,
	stamina = 35,
	mana = 35,
	require = cuns_req_high3,
	requires_target = true,
	tactical = { ATTACK = {DARKNESS = 3} },
	getStealthPower = function(self, t) return self:combatScale(self:getCun(15, true) * self:getTalentLevel(t), 25, 0, 100, 75) end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 4, 8)) end,
	getHealth = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 20, 500), 1, 0.2, 0, 0.584, 384) end, -- Limit to < 100% health of summoner
	getDam = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 10, 500), 1.6, 0.4, 0, 0.761 , 361) end, -- Limit to <160% Nerf?
	action = function(self, t)
		-- Find space
		local x, y = util.findFreeGrid(self.x, self.y, 1, true, {[Map.ACTOR]=true})
		if not x then
			game.logPlayer(self, "Not enough space to invoke your shadow!")
			return
		end

		local m = self:cloneFull{
			shader = "shadow_simulacrum",
			no_drops = true,
			faction = self.faction,
			summoner = self, summoner_gain_exp=true,
			summon_time = t.getDuration(self, t),
			ai_target = {actor=nil},
			ai = "summoned", ai_real = "tactical",
			name = "Shadow of "..self.name,
			desc = [[A dark shadowy shape whose form resembles your own.]],
		}
		m:removeAllMOs()
		m.make_escort = nil
		m.on_added_to_level = nil

		m.energy.value = 0
		m.player = nil
		m.max_life = m.max_life * t.getHealth(self, t)
		m.life = util.bound(m.life, 0, m.max_life)
		m.forceLevelup = function() end
		m.die = nil
		m.on_die = function(self) self:removeEffect(self.EFF_ARCANE_EYE,true) end
		m.on_acquire_target = nil
		m.seen_by = nil
		m.puuid = nil
		m.on_takehit = nil
		m.can_talk = nil
		m.clone_on_hit = nil
		m.exp_worth = 0
		m.no_inventory_access = true
		m.no_levelup_access = true
		m.cant_teleport = true
		m:unlearnTalent(m.T_AMBUSCADE,m:getTalentLevelRaw(m.T_AMBUSCADE))
		m:unlearnTalent(m.T_PROJECTION,m:getTalentLevelRaw(m.T_PROJECTION)) -- no recurssive projections
		m:unlearnTalent(m.T_STEALTH,m:getTalentLevelRaw(m.T_STEALTH))
		m:unlearnTalent(m.T_HIDE_IN_PLAIN_SIGHT,m:getTalentLevelRaw(m.T_HIDE_IN_PLAIN_SIGHT))
		m.stealth = t.getStealthPower(self, t)

		self:removeEffect(self.EFF_SHADOW_VEIL) -- Remove shadow veil from creator
		m.remove_from_party_on_death = true
		m.resists[DamageType.LIGHT] = -100
		m.resists[DamageType.DARKNESS] = 130
		m.resists.all = -30
		m.inc_damage.all = ((100 + (m.inc_damage.all or 0)) * t.getDam(self, t)) - 100
		m.force_melee_damage_type = DamageType.DARKNESS

		m.on_act = function(self)
			if self.summoner.dead or not self:hasLOS(self.summoner.x, self.summoner.y) then
				if not self:hasEffect(self.EFF_AMBUSCADE_OFS) then
					self:setEffect(self.EFF_AMBUSCADE_OFS, 2, {})
				end
			else
				if self:hasEffect(self.EFF_AMBUSCADE_OFS) then
					self:removeEffect(self.EFF_AMBUSCADE_OFS)
				end
			end
		end,

		game.zone:addEntity(game.level, m, "actor", x, y)
		game.level.map:particleEmitter(x, y, 1, "shadow")

		if game.party:hasMember(self) then
			game.party:addMember(m, {
				control="full",
				type="shadow",
				title="Shadow of "..self.name,
				temporary_level=1,
				orders = {target=true},
				on_control = function(self)
					self.summoner.ambuscade_ai = self.summoner.ai
					self.summoner.ai = "none"
				end,
				on_uncontrol = function(self)
					self.summoner.ai = self.summoner.ambuscade_ai
					game:onTickEnd(function() game.party:removeMember(self) self:removeEffect(self.EFF_ARCANE_EYE, true) self:disappear() end)
				end,
			})
		end
		game:onTickEnd(function() game.party:setPlayer(m) end)

		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[你 在 %d 回 合 内 完 全 控 制 你 的 影 子。 
		 你 的 影 子 继 承 了 你 的 天 赋 和 属 性， 拥 有 你 %d%% 的 生 命 值 并 造 成 等 同 于 你 %d%% 的 伤 害， -30%% 所 有 抵 抗， -100%% 光 属 性 抵 抗 并 增 加 100%% 暗 影 抵 抗。 
		 你 的 影 子 处 于 永 久 潜 行 状 态（ %d 潜 行 强 度） 并 且 它 所 造 成 的 所 有 近 战 伤 害 均 会 转 化 为 暗 影 伤 害。 
		 如 果 你 提 前 解 除 控 制 或 者 它 离 开 你 的 视 野 时 间 过 长， 你 的 影 分 身 会 自 动 消 失。]]):
		format(t.getDuration(self, t), t.getHealth(self, t) * 100, t.getDam(self, t) * 100, t.getStealthPower(self, t))
	end,
}

newTalent{
	name = "Shadow Veil",
	type = {"cunning/ambush", 4},
	points = 5,
	cooldown = 18,
	stamina = 30,
	mana = 60,
	require = cuns_req_high4,
	requires_target = true,
	range = 5,
	tactical = { ATTACK = {DARKNESS = 2}, DEFEND = 1 },
	getDamage = function(self, t) return self:combatTalentWeaponDamage(t, 0.9, 2.0) end, -- Nerf?
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 18, 4, 8)) end, -- Limit to <18
	getDamageRes = function(self, t) return self:combatTalentScale(t, 15, 35) end,
	getBlinkRange = function(self, t) return math.floor(self:combatTalentScale(t, 5, 7)) end,
	action = function(self, t)
		self:setEffect(self.EFF_SHADOW_VEIL, t.getDuration(self, t), {res=t.getDamageRes(self, t), dam=t.getDamage(self, t), range=t.getBlinkRange(self, t)})
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local res = t.getDamageRes(self, t)
		return ([[你 融 入 阴 影 并 被 其 支 配， 持 续 %d 回 合。 
		 当 你 笼 罩 在 阴 影 里 时， 你 对 所 有 状 态 免 疫 并 减 少 %d%% 所 有 伤 害。 每 回 合 你 可 以 闪 烁 到 附 近 的 1 个 敌 人 面 前( 半 径 %d 以 内 )， 对 其 造 成 %d%% 暗 影 武 器 伤 害。 
		 阴 影 不 能 被 传 送。 
		 当 此 技 能 激 活 时， 除 非 你 死 亡 否 则 无 法 被 打 断， 并 且 你 也 无 法 控 制 你 的 角 色。]]):
		format(duration, res, t.getBlinkRange(self, t) ,100 * damage)
	end,
}

