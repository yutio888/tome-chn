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
	name = "Arcane Eye",
	type = {"spell/divination", 1},
	require = spells_req1,
	points = 5,
	mana = 15,
	cooldown = 10,
	no_energy = true,
	no_npc_use = true,
	requires_target = true,
	getDuration = function(self, t) return math.floor(10 + self:getTalentLevel(t) * 3) end,
	getRadius = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	action = function(self, t)
		local tg = {type="hit", nolock=true, pass_terrain=true, nowarning=true, range=100, requires_knowledge=false}
		local x, y = self:getTarget(tg)
		if not x then return nil end
		-- Target code does not restrict the target coordinates to the range, it lets the project function do it
		-- but we cant ...
		local _ _, x, y = self:canProject(tg, x, y)

		self:setEffect(self.EFF_ARCANE_EYE, t.getDuration(self, t), {x=x, y=y, track=(self:getTalentLevel(t) >= 4) and game.level.map(x, y, Map.ACTOR) or nil, radius=t.getRadius(self, t), true_seeing=self:getTalentLevel(t) >= 5})
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local duration = t.getDuration(self, t)
		return ([[召 唤 1 个 奥 术 之 眼 放 置 于 指 定 地 点， 持 续 %d 回 合。 
		 此 眼 睛 不 会 被 其 他 生 物 看 见 或 攻 击， 它 提 供 魔 法 视 觉， 可 看 到 它 周 围 %d 码 范 围 的 怪 物。 
		 它 不 需 要 灯 光 去 提 供 能 量， 且 它 的 视 线 无 法 穿 墙。 
		 召 唤 奥 术 之 眼 不 消 耗 回 合。 
		 同 时 只 能 存 在 1 个 奥 术 之 眼。 
		 在 等 级 4 时， 可 以 在 怪 物 身 上 放 置 奥 术 之 眼， 持 续 时 间 直 到 技 能 结 束 或 怪 物 死 亡。 
		 在 等 级 5 时， 它 可 以 在 怪 物 身 上 放 置 一 个 魔 法 标 记 并 无 视 隐 形 和 潜 行 效 果。]]):
		format(duration, radius)
	end,
}

newTalent{
	name = "Keen Senses",
	type = {"spell/divination", 2},
	require = spells_req2,
	mode = "sustained",
	points = 5,
	sustain_mana = 40,
	tactical = { BUFF = 2 },
	cooldown = 30,
	getSeeInvisible = function(self, t) return self:combatTalentSpellDamage(t, 2, 45) end,
	getSeeStealth = function(self, t) return self:combatTalentSpellDamage(t, 2, 20) end,
	getCriticalChance = function(self, t) return self:combatTalentSpellDamage(t, 2, 12) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
		return {
			invis = self:addTemporaryValue("see_invisible", t.getSeeInvisible(self, t)),
			stealth = self:addTemporaryValue("see_stealth", t.getSeeStealth(self, t)),
			crit = self:addTemporaryValue("combat_spellcrit", t.getCriticalChance(self, t)),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("see_invisible", p.invis)
		self:removeTemporaryValue("see_stealth", p.stealth)
		self:removeTemporaryValue("combat_spellcrit", p.crit)
		return true
	end,
	info = function(self, t)
		local seeinvisible = t.getSeeInvisible(self, t)
		local seestealth = t.getSeeStealth(self, t)
		local criticalchance = t.getCriticalChance(self, t)
		return ([[你 集 中 精 神， 通 过 直 觉 获 取 未 来 的 信 息。 
		 增 加 侦 测 隐 形 等 级 +%d
		 增 加 侦 测 潜 行 等 级 +%d
		 增 加 法 术 暴 击 几 率 +%d%%
		 受 法 术 强 度 影 响， 此 效 果 有 额 外 加 成。]]):
		format(seeinvisible, seestealth, criticalchance)
	end,
}

newTalent{
	name = "Vision",
	type = {"spell/divination", 3},
	require = spells_req3,
	points = 5,
	random_ego = "utility",
	mana = 20,
	cooldown = 20,
	no_npc_use = true,
	getRadius = function(self, t) return 5 + self:combatTalentSpellDamage(t, 2, 12) end,
	action = function(self, t)
		self:magicMap(t.getRadius(self, t))
		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local radius = t.getRadius(self, t)
		return ([[通 过 意 念 探 测 周 围 地 形， 有 效 范 围： %d  码。]]):
		format(radius)
	end,
}

newTalent{
	name = "Premonition",
	type = {"spell/divination", 4},
	mode = "sustained",
	require = spells_req4,
	points = 5,
	sustain_mana = 120,
	cooldown = 30,
	tactical = { BUFF = 2 },
	getResist = function(self, t) return 10 + self:combatTalentSpellDamage(t, 2, 25) end,
	on_damage = function(self, t, damtype)
		if damtype == DamageType.PHYSICAL then return end

		if not self:hasEffect(self.EFF_PREMONITION_SHIELD) then
			self:setEffect(self.EFF_PREMONITION_SHIELD, 5, {damtype=damtype, resist=t.getResist(self, t)})
			game.logPlayer(self, "#OLIVE_DRAB#Your premonition allows you to raise a shield just in time!")
		end
	end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic")
		return {
		}
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		local resist = t.getResist(self, t)
		return ([[你 的 眼 前 会 闪 烁 未 来 的 景 象， 让 你 能 够 预 知 对 你 的 攻 击。 
		 如 果 攻 击 是 元 素 类 或 魔 法 类 的， 那 么 你 会 创 造 一 个 临 时 性 的 护 盾 来 减 少 %d%% 所 有 此 类 攻 击 伤 害， 持 续 5 回 合。 
		 此 效 果 每 隔 5 回 合 只 能 触 发 一 次， 且 在 承 受 伤 害 前 被 激 活。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):format(resist)
	end,
}
