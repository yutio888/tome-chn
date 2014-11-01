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
local Chat = require "engine.Chat"

newTalent{
	name = "Life Tap", short_name = "GOLEMANCY_LIFE_TAP",
	type = {"spell/advanced-golemancy", 1},
	require = {
		special = { desc="Having an Alchemist Golem", fct=function(self, t) return self.alchemy_golem end},
		stat = { mag=function(level) return 22 + (level-1) * 2 end },
		level = function(level) return 10 + (level-1)  end,
	},
	points = 5,
	mana = 25,
	cooldown = 12,
	tactical = { HEAL = 2 },
	is_heal = true,
	getPower = function(self, t) return 70 + self:combatTalentSpellDamage(t, 15, 450) end,
	action = function(self, t)
		local mover, golem = getGolem(self)
		if not golem then
			game.logPlayer(self, "Your golem is currently inactive.")
			return
		end

		local power = math.min(t.getPower(self, t), golem.life)
		golem.life = golem.life - power -- Direct hit, bypass all checks
		golem.changed = true
		self:attr("allow_on_heal", 1)
		self:heal(power, golem)
		self:attr("allow_on_heal", -1)
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healarcane", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleDescendSpeed=4}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healarcane", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, beamColor1={0x8e/255, 0x2f/255, 0xbb/255, 1}, beamColor2={0xe7/255, 0x39/255, 0xde/255, 1}, circleDescendSpeed=4}))
		end
		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local power=t.getPower(self, t)
		return ([[你 汲 取 傀 儡 的 生 命 能 量 来 恢 复 自 己。 恢 复 %d 点 生 命。]]):
		format(power)
	end,
}

newTalent{
	name = "Gem Golem",
	type = {"spell/advanced-golemancy",2},
	require = spells_req_high2,
	mode = "passive",
	points = 5,
	no_unlearn_last = true,
	info = function(self, t)
		return ([[在 傀 儡 身 上 镶 嵌 2 颗 宝 石， 它 可 以 得 到 宝 石 加 成 并 改 变 近 战 攻 击 类 型。 你 可 以 移 除 并 镶 嵌 不 同 种 类 的 宝 石， 移 除 行 为 不 会 破 坏 宝 石。 
		 可 用 宝 石 等 级： %d
		 宝 石 会 在 傀 儡 的 物 品 栏 中 改 变 成 功 。 ]]):format(self:getTalentLevelRaw(t))
	end,
}

newTalent{
	name = "Supercharge Golem",
	type = {"spell/advanced-golemancy", 3},
	require = spells_req_high3,
	points = 5,
	mana = 20,
	cooldown = function(self, t) return math.ceil(self:combatTalentLimit(t, 0, 24, 20)) end, -- Limit to > 0
	tactical = { DEFEND = 1, ATTACK=1 },
	getPower = function(self, t) return (60 + self:combatTalentSpellDamage(t, 15, 450)) / 7, 7, self:combatTalentLimit(t, 100, 27, 55) end, --Limit life gain < 100%
	action = function(self, t)
		local regen, dur, hp = t.getPower(self, t)

		-- ressurect the golem
		if not game.level:hasEntity(self.alchemy_golem) or self.alchemy_golem.dead then
			self.alchemy_golem.dead = nil
			self.alchemy_golem.life = self.alchemy_golem.max_life / 100 * hp

			-- Find space
			local x, y = util.findFreeGrid(self.x, self.y, 5, true, {[Map.ACTOR]=true})
			if not x then
				game.logPlayer(self, "Not enough space to supercharge!")
				return
			end
			game.zone:addEntity(game.level, self.alchemy_golem, "actor", x, y)
			self.alchemy_golem:setTarget(nil)
			self.alchemy_golem.ai_state.tactic_leash_anchor = self
			self.alchemy_golem:removeAllEffects()
		end

		local mover, golem = getGolem(self)
		if not golem then
			game.logPlayer(self, "Your golem is currently inactive.")
			return
		end

		golem:setEffect(golem.EFF_SUPERCHARGE_GOLEM, dur, {regen=regen})

		game:playSoundNear(self, "talents/arcane")
		return true
	end,
	info = function(self, t)
		local regen, turns, life = t.getPower(self, t)
		return ([[你 激 活 傀 儡 的 特 殊 模 式， 提 高 它 每 回 合 %0.2f 生 命 回 复 速 度， 持 续 %d 回 合。 
		 如 果 你 的 傀 儡 死 亡， 它 会 立 刻 复 活， 复 活 时 保 留 %d%% 生 命 值。 
		 此 技 能 激 活 时 你 的 傀 儡 处 于 激 怒 状 态， 可 增 加 25%% 伤 害。]]):
		format(regen, turns, life)
	end,
}



newTalent{
	name = "Runic Golem",
	type = {"spell/advanced-golemancy",4},
	require = spells_req_high4,
	mode = "passive",
	points = 5,
	no_unlearn_last = true,
	on_learn = function(self, t)
		self.alchemy_golem.life_regen = self.alchemy_golem.life_regen + 1
		self.alchemy_golem.mana_regen = self.alchemy_golem.mana_regen + 1
		self.alchemy_golem.stamina_regen = self.alchemy_golem.stamina_regen + 1
		local lev = self:getTalentLevelRaw(t)
		if lev == 1 or lev == 3 or lev == 5 then
			self.alchemy_golem.max_inscriptions = self.alchemy_golem.max_inscriptions + 1
			self.alchemy_golem.inscriptions_slots_added = self.alchemy_golem.inscriptions_slots_added + 1
		end
	end,
	on_unlearn = function(self, t)
		self.alchemy_golem.life_regen = self.alchemy_golem.life_regen - 1
		self.alchemy_golem.mana_regen = self.alchemy_golem.mana_regen - 1
		self.alchemy_golem.stamina_regen = self.alchemy_golem.stamina_regen - 1
		local lev = self:getTalentLevelRaw(t)
		if lev == 0 or lev == 2 or lev == 4 then
			self.alchemy_golem.max_inscriptions = self.alchemy_golem.max_inscriptions - 1
			self.alchemy_golem.inscriptions_slots_added = self.alchemy_golem.inscriptions_slots_added - 1
		end
	end,
	info = function(self, t)
		return ([[增 加 傀 儡 %0.2f 生 命、 法 力 和 耐 力 回 复。 
		 在 等 级 1、 3、 5 时， 傀 儡 会 增 加 1 个 新 的 符 文 孔。 
		 即 使 没 有 此 天 赋， 傀 儡 默 认 也 有 3 个 符 文 孔。]]):
		format(self:getTalentLevelRaw(t))
	end,
}
