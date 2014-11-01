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

local Object = require "mod.class.Object"

newTalent{
	name = "Consume Soul",
	type = {"spell/animus",1},
	require = spells_req1,
	points = 5,
	soul = 1,
	cooldown = 10,
	tactical = { HEAL = 1, MANA = 1 },
	getHeal = function(self, t) return (40 + self:combatTalentSpellDamage(t, 10, 520)) * (necroEssenceDead(self, true) and 1.5 or 1) end,
	is_heal = true,
	action = function(self, t)
		self:attr("allow_on_heal", 1)
		self:heal(self:spellCrit(t.getHeal(self, t)), self)
		self:attr("allow_on_heal", -1)
		self:incMana(self:spellCrit(t.getHeal(self, t)) / 3, self)
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healdark", life=25}, {type="healing", time_factor=6000, beamsCount=15, noup=2.0, beamColor1={0xcb/255, 0xcb/255, 0xcb/255, 1}, beamColor2={0x35/255, 0x35/255, 0x35/255, 1}}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healdark", life=25}, {type="healing", time_factor=6000, beamsCount=15, noup=1.0, beamColor1={0xcb/255, 0xcb/255, 0xcb/255, 1}, beamColor2={0x35/255, 0x35/255, 0x35/255, 1}}))
		end
		game:playSoundNear(self, "talents/heal")
		if necroEssenceDead(self, true) then necroEssenceDead(self)() end
		return true
	end,
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[ 粉 碎 你 捕 获 的 一 个 灵 魂 ， 利 用 其 能 量 回 复 自 己 %d 点 生 命 ， %d 点 法 力 。
		 受 法 术 强 度 影 响 ，治 疗 量 有 额 外 加 成。 ]]):
		format(heal, heal / 3)
	end,
}

newTalent{
	name = "Animus Hoarder",
	type = {"spell/animus",2},
	require = spells_req2,
	mode = "sustained",
	points = 5,
	sustain_mana = 50,
	cooldown = 30,
	tactical = { BUFF = 3 },
	getMax = function(self, t) return math.floor(self:combatTalentScale(t, 2, 8)) end,
	getChance = function(self, t) return math.floor(self:combatTalentScale(t, 10, 80)) end,
	activate = function(self, t)
		local ret = {}
		self:talentTemporaryValue(ret, "max_soul", t.getMax(self, t))
		self:talentTemporaryValue(ret, "extra_soul_chance", t.getChance(self, t))
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local max, chance = t.getMax(self, t), t.getChance(self, t)
		return ([[ 你 对 灵 魂 的 渴 望 与 日 俱 增 。 当 你 杀 死 一 个 生 物 时 ， 你 利 用 强 大 的 力 量 抹 去 它 的 仇 恨， 有 %d%% 概 率 获 得 额 外 一 个 灵 魂 ， 同 时 你 能 获 得  的 最 大 灵 魂 数 增 加  %d。]]):
		format(chance, max)
	end,
}

newTalent{
	name = "Animus Purge",
	type = {"spell/animus",3},
	require = spells_req3,
	points = 5,
	mana = 50,
	soul = 4,
	cooldown = 15,
	range = 6,
	proj_speed = 20,
	requires_target = true,
	no_npc_use = true,
	direct_hit = function(self, t) if self:getTalentLevel(t) >= 3 then return true else return false end end,
	target = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		return tg
	end,
	getMaxLife = function(self, t) return self:combatTalentLimit(t, 50, 10, 25) end,
	getDamage = function(self, t) return self:combatTalentSpellDamage(t, 35, 330) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(px, py)
			local m = game.level.map(px, py, Map.ACTOR)
			if not m or not m.max_life or not m.life or m.on_die then return end

			if game.party and game.party:hasMember(self) then
				for act, def in pairs(game.party.members) do
					if act.summoner and act.summoner == self then
						if act.type == "undead" and act.subtype == "husk" then
							game.party:removeMember(act)
							act:disappear(act)							
						end
					end
				end
			end

			local dam = self:spellCrit(t.getDamage(self, t))
			local olddie = rawget(m, "die")
			m.die = function() end
			DamageType:get(DamageType.DARKNESS).projector(self, px, py, DamageType.DARKNESS, dam)
			m.die = olddie
			game.level.map:particleEmitter(px, py, 1, "dark")
			if 100 * m.life / m.max_life <= t.getMaxLife(self, t) and self:checkHit(self:combatSpellpower(), m:combatSpellResist()) and m:canBe("instakill") and m.rank <= 3.2 and not m:attr("undead") and not m.summoner and not m.summon_time then
				m.type = "undead"
				m.subtype = "husk"
				m:attr("no_life_regen", 1)
				m:attr("no_healing", 1)
				m.ai_state.tactic_leash = 100
				m.remove_from_party_on_death = true
				m.no_inventory_access = true
				m.no_party_reward = true
				m.life = m.max_life
				m.move_others = true
				m.summoner = self
				m.summoner_gain_exp = true
				m.unused_stats = 0
				m.dead = nil
				m.undead = 1
				m.no_breath = 1
				m.unused_talents = 0
				m.unused_generics = 0
				m.unused_talents_types = 0
				m.silent_levelup = true
				m.clone_on_hit = nil
				if m:knowTalent(m.T_BONE_SHIELD) then m:unlearnTalent(m.T_BONE_SHIELD, m:getTalentLevelRaw(m.T_BONE_SHIELD)) end
				if m:knowTalent(m.T_MULTIPLY) then m:unlearnTalent(m.T_MULTIPLY, m:getTalentLevelRaw(m.T_MULTIPLY)) end
				if m:knowTalent(m.T_SUMMON) then m:unlearnTalent(m.T_SUMMON, m:getTalentLevelRaw(m.T_SUMMON)) end
				m:learnTalent(m.T_HUSK_DESTRUCT, 1)
				m.no_points_on_levelup = true
				m.faction = self.faction

				m.on_act = function(self)
					if game.player ~= self then return end
					if not self.summoner.dead and not self:hasLOS(self.summoner.x, self.summoner.y) then
						if not self:hasEffect(self.EFF_HUSK_OFS) then
							self:setEffect(self.EFF_HUSK_OFS, 3, {})
						end
					else
						if self:hasEffect(self.EFF_HUSK_OFS) then
							self:removeEffect(self.EFF_HUSK_OFS)
						end
					end
				end

				m.on_can_control = function(self, vocal)
					if not self:hasLOS(self.summoner.x, self.summoner.y) then
						if vocal then game.logPlayer(game.player, "Your husk is out of sight; you cannot establish direct control.") end
						return false
					end
					return true
				end

				m:removeEffectsFilter({status="detrimental"}, nil, true)
				game.level.map:particleEmitter(px, py, 1, "demon_teleport")

				applyDarkEmpathy(self, m)

				game.party:addMember(m, {
					control="full",
					type="husk",
					title="Lifeless Husk",
					orders = {leash=true, follow=true},
					on_control = function(self)
						self:hotkeyAutoTalents()
					end,
				})
				game:onTickEnd(function() self:incSoul(2) end)

				self:logCombat(m, "#GREY##Source# rips apart the animus of #target# and creates an undead husk.")
			end
		end)

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 试 图 粉 碎 你 敌 人 的 灵 魂， 造 成 %0.2f 点 暗 影 伤 害 （ 但 不 会 杀 死 它 ） 。 
		 如 果 剩 余 生 命 少 于 %d%% , 你 将 试 图 控 制 其 身 体 。
		 如 果 成 功 ， 对 方 将 成 为 你 永 久 的 傀 儡， 不 受 你 的 死 灵 光 环 影 响 ， 并 得 到 两 个 灵 魂 。 
		 傀 儡 能 力 与 生 前 相 同 , 受 黑 暗 共 享 的 影 响， 在 制 造 时 生 命 恢 复 满 值 ， 之 后 不 能 以 任 何 方 式 被 治 疗 。
		 任 何 时 候， 这 种 方 式 只 能 控 制 一 个 生 物 ， 在 已 经 存 在 傀 儡 时 使 用 该 技 能 会 让 原 来 的 傀 儡 消 失。
		 boss、 不 死 族 和 召 唤 物 不 会 变 成 傀 儡 。 
		 受 法 术 强 度 影 响， 伤 害 和 概 率 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage), t.getMaxLife(self, t))
	end,
}

newTalent{
	name = "Essence of the Dead",
	type = {"spell/animus",4},
	require = spells_req4,
	points = 5,
	mana = 20,
	soul = 2,
	cooldown = 20,
	tactical = { BUFF = 3 },
	getnb = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5)) end,
	action = function(self, t)
		self:setEffect(self.EFF_ESSENCE_OF_THE_DEAD, 1, {nb=t.getnb(self, t)})
		return true
	end,
	info = function(self, t)
		local nb = t.getnb(self, t)
		return ([[  粉 碎 两 个 灵 魂， 接 下 来  的 %d 个 法 术 获  得 额 外 效 果 ： 
                  受 影 响 的 法 术 有：
		  亡 灵 分 流： 获 得 治 疗 量 一 半 的 护 盾 
                  亡 灵 召 唤： 额 外 召 唤 两 个 不 死 族
                  亡 灵 组 合： 额 外 召 唤 一 个 骨 巨 人
                  黑 夜 降 临： 攻 击 变 成 锥 形
                  暗 影 通 道： 被 传 送 的 不 死 族 同 时 受 到 相 当 于 30%% 最 大 生 命 值 的 治 疗
                  骨 灵 冷 火： 冰 冻 概 率 增 加 至 100%%
                  寒 冰 箭： 每 个 寒 冰 箭 都 变 成 射 线
                  消 耗 灵 魂： 效 果 增 加 50%%]]):
		format(nb)
	end,
}


newTalent{
	name = "Self-destruction", short_name = "HUSK_DESTRUCT", image = "talents/golem_destruct.png",
	type = {"spell/other", 1},
	points = 1,
	range = 0,
	radius = 4,
	no_unlearn_last = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t)}
	end,
	tactical = { ATTACKAREA = { DARKNESS = 3 } },
	no_npc_use = true,
	on_pre_use = function(self, t)
		return self.summoner and self.summoner.dead
	end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, DamageType.DARKNESS, 50 + 10 * self.level)
		if core.shader.active() then
			game.level.map:particleEmitter(self.x, self.y, tg.radius, "starfall", {radius=tg.radius})
		else
			game.level.map:particleEmitter(self.x, self.y, tg.radius, "shadow_flash", {radius=tg.radius})
		end
		game:playSoundNear(self, "talents/fireflash")
		self:die(self)
		return true
	end,
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[毁 灭 自 己 ， 在 半 径 %d 的 范 围 造 成 %0.2f 点 暗 影 伤 害。
		只 有 当 主 人 死 去 时 才 能 使 用。]]):format(rad, damDesc(self, DamageType.DARKNESS, 50 + 10 * self.level))
	end,
}
