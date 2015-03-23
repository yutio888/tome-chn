-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2015 Nicolas Casalini
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

uberTalent{
	name = "Draconic Will",
	cooldown = 15,
	no_energy = true,
	requires_target = true,
	range = 10,
	fixed_cooldown = true,
	tactical = { BUFF = 2 },
	action = function(self, t)
		self:setEffect(self.EFF_DRACONIC_WILL, 5, {})
		return true
	end,
	require = { special={desc="熟悉龙之世界", fct=function(self) return game.state.birth.ignore_prodigies_special_reqs or (self:attr("drake_touched") and self:attr("drake_touched") >= 2) end} },
	info = function(self, t)
		return ([[你 的 身 体 如 巨 龙 般 强 韧， 可 以 轻 易 抵 抗 负 面 效 果。 
		在 5 回 合 内 对 负 面 效 果 免 疫。]])
		:format()
	end,
}

uberTalent{
	name = "Meteoric Crash",
	mode = "passive",
	cooldown = 15,
	getDamage = function(self, t) return math.max(100 + self:combatSpellpower() * 5, 100 + self:combatMindpower() * 5) end,
	require = { special={desc="曾亲眼目睹过陨石坠落", fct=function(self) return game.state.birth.ignore_prodigies_special_reqs or self:attr("meteoric_crash") end} },
	trigger = function(self, t, target)
		self:startTalentCooldown(t)
		local terrains = t.terrains or mod.class.Grid:loadList("/data/general/grids/lava.lua")
		t.terrains = terrains -- cache

		local meteor = function(src, x, y, dam)
			game.level.map:particleEmitter(x, y, 10, "meteor", {x=x, y=y}).on_remove = function(self)
				local x, y = self.args.x, self.args.y
				game.level.map:particleEmitter(x, y, 10, "fireflash", {radius=2})
				game:playSoundNear(game.player, "talents/fireflash")

				local grids = {}
				for i = x-1, x+1 do for j = y-1, y+1 do
					local oe = game.level.map(i, j, engine.Map.TERRAIN)
					if oe and not oe:attr("temporary") and
					(core.fov.distance(x, y, i, j) < 1 or rng.percent(40)) and (game.level.map:checkEntity(i, j, engine.Map.TERRAIN, "dig") or game.level.map:checkEntity(i, j, engine.Map.TERRAIN, "grow")) then
						local g = terrains.LAVA_FLOOR:clone()
						g:resolve() g:resolve(nil, true)
						game.zone:addEntity(game.level, g, "terrain", i, j)
						grids[#grids+1] = {x=i,y=j,oe=oe}
					end
				end end
				for i = x-1, x+1 do for j = y-1, y+1 do
					game.nicer_tiles:updateAround(game.level, i, j)
				end end
				for _, spot in ipairs(grids) do
					local i, j = spot.x, spot.y
					local g = game.level.map(i, j, engine.Map.TERRAIN)
					g.temporary = 8
					g.x = i g.y = j
					g.canAct = false
					g.energy = { value = 0, mod = 1 }
					g.old_feat = spot.oe
					g.useEnergy = mod.class.Trap.useEnergy
					g.act = function(self)
						self:useEnergy()
						self.temporary = self.temporary - 1
						if self.temporary <= 0 then
							game.level.map(self.x, self.y, engine.Map.TERRAIN, self.old_feat)
							game.level:removeEntity(self)
							game.nicer_tiles:updateAround(game.level, self.x, self.y)
						end
					end
					game.level:addEntity(g)
				end

				src:project({type="ball", radius=2, selffire=false}, x, y, engine.DamageType.FIRE, dam/2)
				src:project({type="ball", radius=2, selffire=false}, x, y, engine.DamageType.PHYSICAL, dam/2)
				src:project({type="ball", radius=2, selffire=false}, x, y, function(px, py)
					local target = game.level.map(px, py, engine.Map.ACTOR)
					if target then
						if target:canBe("stun") then
							target:setEffect(target.EFF_STUNNED, 3, {apply_power=math.max(src:combatSpellpower(), src:combatMindpower())})
						else
							game.logSeen(target, "%s resists the stun!", target.name:capitalize())
						end
					end
				end)
				if core.shader.allow("distort") then game.level.map:particleEmitter(x, y, 2, "shockwave", {radius=2}) end
				game:getPlayer(true):attr("meteoric_crash", 1)
			end
		end

		local dam = t.getDamage(self, t)
		if self:combatMindCrit() > self:combatSpellCrit() then dam = self:mindCrit(dam)
		else dam = self:spellCrit(dam)
		end
		meteor(self, target.x, target.y, dam)

		return true
	end,
	info = function(self, t)
		local dam = t.getDamage(self, t)/2
		return ([[在 施 展 伤 害 类 魔 法 或 精 神 攻 击 时， 你 会 释 放 意 念， 召 唤 一 颗 陨 石 砸 向 附 近 敌 人。 
		被 影 响 的 地 区 会 转 化 为 岩 浆 地 形， 持 续 8 回 合， 陨 石 冲 击 会 造 成 %0.2f 火 焰 和 %0.2f 物 理 伤 害。 
		陨 石 也 会 震 慑 区 域 内 敌 人 3 回 合。 
		受 精 神 强 度 或 法 术 强 度 影 响， 伤 害 按 比 例 加 成。  ]])
		:format(damDesc(self, DamageType.FIRE, dam), damDesc(self, DamageType.PHYSICAL, dam))
	end,
}

uberTalent{
	name = "Garkul's Revenge",
	mode = "passive",
	on_learn = function(self, t)
		self.inc_damage_actor_type = self.inc_damage_actor_type or {}
		self.inc_damage_actor_type.construct = (self.inc_damage_actor_type.construct or 0) + 1000
		self.inc_damage_actor_type.humanoid = (self.inc_damage_actor_type.humanoid or 0) + 20
	end,
	on_unlearn = function(self, t)
		self.inc_damage_actor_type.construct = (self.inc_damage_actor_type.construct or 0) - 1000
		self.inc_damage_actor_type.humanoid = (self.inc_damage_actor_type.humanoid or 0) - 20
	end,
	require = { special={desc="装备加库尔的两件宝物并且了解加库尔的一生", fct=function(self)
		local o1 = self:findInAllInventoriesBy("define_as", "SET_GARKUL_TEETH")
		local o2 = self:findInAllInventoriesBy("define_as", "HELM_OF_GARKUL")
		return o1 and o2 and o1.wielded and o2.wielded and (game.state.birth.ignore_prodigies_special_reqs or (
			game.party:knownLore("garkul-history-1") and
			game.party:knownLore("garkul-history-2") and
			game.party:knownLore("garkul-history-3") and
			game.party:knownLore("garkul-history-4") and
			game.party:knownLore("garkul-history-5")
			))
	end} },
	info = function(self, t)
		return ([[加 库 尔 之 魂 与 你 同 在， 你 现 在 能 对 建 筑 类 造 成 1000％ 额 外 伤 害， 对 人 形 生 物 造 成 20％ 额 外 伤 害。  ]])
		:format()
	end,
}

uberTalent{
	name = "Hidden Resources",
	cooldown = 15,
	no_energy = true,
	tactical = { BUFF = 2 },
	action = function(self, t)
		self:setEffect(self.EFF_HIDDEN_RESOURCES, 5, {})
		return true
	end,
	require = { special={desc="曾 获 得 千 钧 一 发 成 就（ 在 低 于 1HP 情 况 下 杀 死 1 个 敌 人）", fct=function(self) return self:attr("barely_survived") end} },
	info = function(self, t)
		return ([[在 严 峻 的 形 势 面 前， 你 集 中 意 念 进 入 心 如 止 水 的 状 态。 
		在 5 回 合 内， 所 有 技 能 不 消 耗 任 何 能 量。  ]])
		:format()
	end,
}


uberTalent{
	name = "Lucky Day",
	mode = "passive",
	require = { special={desc="拥有大运气。（至少有+5luck属性）", fct=function(self) return self:getLck() >= 55 end} },
	on_learn = function(self, t)
		self.inc_stats[self.STAT_LCK] = (self.inc_stats[self.STAT_LCK] or 0) + 40
		self:onStatChange(self.STAT_LCK, 40)
	end,
	on_unlearn = function(self, t)
		self.inc_stats[self.STAT_LCK] = (self.inc_stats[self.STAT_LCK] or 0) - 40
		self:onStatChange(self.STAT_LCK, -40)
	end,
	info = function(self, t)
		return ([[每 天 都 是 幸 运 日。 幸 运 永 久 +40。  ]])
		:format()
	end,
}

uberTalent{
	name = "Unbreakable Will",
	mode = "passive",
	cooldown = 7,
	trigger = function(self, t)
		self:startTalentCooldown(t)
		game.logSeen(self, "#LIGHT_BLUE#%s's unbreakable will shrugs off the effect!", self.name:capitalize())
		return true
	end,
	info = function(self, t)
		return ([[你 的 意 志 如 此 坚 定， 可 以 忽 视 对 你 造 成 的 精 神 效 果。 
		警 告： 此 技 能 有 冷 却 时 间。  ]])
		:format()
	end,
}

uberTalent{
	name = "Spell Feedback",
	mode = "passive",
	cooldown = 9,
	require = { special={desc="习得反魔技能", fct=function(self) return self:knowTalentType("wild-gift/antimagic") end} },
	trigger = function(self, t, target, source_t)
		self:startTalentCooldown(t)
		self:logCombat(target, "#LIGHT_BLUE##Source# punishes #Target# for casting a spell!", self.name:capitalize(), target.name)
		DamageType:get(DamageType.MIND).projector(self, target.x, target.y, DamageType.MIND, 20 + self:getWil() * 2)

		local dur = target:getTalentCooldown(source_t)
		if dur and dur > 0 then
			target:setEffect(target.EFF_SPELL_FEEDBACK, dur, {power=35})
		end
		return true
	end,
	info = function(self, t)
		return ([[你 的 意 志 是 对 抗 邪 恶 魔 法 师 的 盾 牌。 
		每 当 你 受 到 魔 法 伤 害， 你 会 惩 罚 施 法 者， 使 其 受 到 %0.2f 的 精 神 伤 害。 
		同 时， 它 们 在 对 你 使 用 的 技 能 进 入 冷 却 的 回 合 中， 会 受 到 35％ 法 术 失 败 率 惩 罚。
		注 意 ： 该 技 能 有 冷 却 时 间。 ]])
		:format(damDesc(self, DamageType.MIND, 20 + self:getWil() * 2))
	end,
}

uberTalent{
	name = "Mental Tyranny",
	mode = "sustained",
	require = { },
	cooldown = 20,
	tactical = { BUFF = 2 },
	require = { special={desc="曾造成50000点精神伤害", fct=function(self) return 
		self.damage_log and (
			(self.damage_log[DamageType.MIND] and self.damage_log[DamageType.MIND] >= 50000)
		)
	end} },
	activate = function(self, t)
		game:playSoundNear(self, "talents/distortion")
		return {
			converttype = self:addTemporaryValue("all_damage_convert", DamageType.MIND),
			convertamount = self:addTemporaryValue("all_damage_convert_percent", 33),
			dam = self:addTemporaryValue("inc_damage", {[DamageType.MIND] = 10}),
			resist = self:addTemporaryValue("resists_pen", {[DamageType.MIND] = 30}),
		}
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("all_damage_convert", p.converttype)
		self:removeTemporaryValue("all_damage_convert_percent", p.convertamount)
		self:removeTemporaryValue("inc_damage", p.dam)
		self:removeTemporaryValue("resists_pen", p.resist)
		return true
	end,
	info = function(self, t)
		return ([[用 钢 铁 般 的 意 志 驱 使 整 个 身 体。 
		当 此 技 能 激 活 时， 你 33%% 的 伤 害 会 转 化 为 精 神 伤 害。 
		此 外， 你 获 得 30％ 精 神 抵 抗 穿 透 并 增 加 10％ 精 神 伤 害。 ]]):
		format()
	end,
}
