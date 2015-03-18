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

uberTalent{
	name = "Fast As Lightning",
	mode = "passive",
	trigger = function(self, t, ox, oy)
		local dx, dy = (self.x - ox), (self.y - oy)
		if dx ~= 0 then dx = dx / math.abs(dx) end
		if dy ~= 0 then dy = dy / math.abs(dy) end
		local dir = util.coordToDir(dx, dy, 0)

		local eff = self:hasEffect(self.EFF_FAST_AS_LIGHTNING)
		if eff and eff.blink then
			if eff.dir ~= dir then
				self:removeEffect(self.EFF_FAST_AS_LIGHTNING)
			else
				return
			end
		end

		self:setEffect(self.EFF_FAST_AS_LIGHTNING, 1, {})
		eff = self:hasEffect(self.EFF_FAST_AS_LIGHTNING)

		if not eff.dir then eff.dir = dir eff.nb = 0 end

		if eff.dir ~= dir then
			self:removeEffect(self.EFF_FAST_AS_LIGHTNING)
			self:setEffect(self.EFF_FAST_AS_LIGHTNING, 1, {})
			eff = self:hasEffect(self.EFF_FAST_AS_LIGHTNING)
			eff.dir = dir eff.nb = 0
			game.logSeen(self, "#LIGHT_BLUE#%s slows from critical velocity!", self.name:capitalize())
		end

		eff.nb = eff.nb + 1

		if eff.nb >= 3 and not eff.blink then
			self:effectTemporaryValue(eff, "prob_travel", 5)
			game.logSeen(self, "#LIGHT_BLUE#%s reaches critical velocity!", self.name:capitalize())
			local sx, sy = game.level.map:getTileToScreen(self.x, self.y)
			game.flyers:add(sx, sy, 30, rng.float(-3, -2), (rng.range(0,2)-1) * 0.5, "CRITICAL VELOCITY!", {0,128,255})
			eff.particle = self:addParticles(Particles.new("megaspeed", 1, {angle=util.dirToAngle((dir == 4 and 6) or (dir == 6 and 4 or dir))}))
			eff.blink = true
			game:playSoundNear(self, "talents/thunderstorm")
		end
	end,
	info = function(self, t)
		return ([[向 同 一 方 向 连 续 以 超 过 800％ 速 度 至 少 移 动 3 回 合 后， 你 可 以 无 视 障 碍 物 移 动。 
		 变 换 方 向 会 打 断 此 效 果。  ]])
		:format()
	end,
}

uberTalent{
	name = "Tricky Defenses",
	mode = "passive",
	require = { special={desc="加入反魔神教", fct=function(self) return self:knowTalentType("wild-gift/antimagic") end} },
	-- called by getMax function in Antimagic shield talent definition mod.data.talents.gifts.antimagic.lua
	shieldmult = function(self) return self:combatStatScale("cun", 0.1, 0.5) end,
	info = function(self, t)
		return ([[由 于 你 精 通 欺 诈 和 伪 装， 你 的 反 魔 护 盾 可 以 多 吸 收 %d%% 伤 害。 
		 受 灵 巧 影 响， 效 果 按 比 例 加 成。  ]])
		:format(t.shieldmult(self)*100)
	end,
}

uberTalent{
	name = "Endless Woes",
	mode = "passive",
	require = { special={desc="曾 造 成 超 过 50000 点 酸 性、 枯 萎、 暗 影、 精 神 或 时 空 伤 害", fct=function(self) return 
		self.damage_log and (
			(self.damage_log[DamageType.ACID] and self.damage_log[DamageType.ACID] >= 50000) or
			(self.damage_log[DamageType.BLIGHT] and self.damage_log[DamageType.BLIGHT] >= 50000) or
			(self.damage_log[DamageType.DARKNESS] and self.damage_log[DamageType.DARKNESS] >= 50000) or
			(self.damage_log[DamageType.MIND] and self.damage_log[DamageType.MIND] >= 50000) or
			(self.damage_log[DamageType.TEMPORAL] and self.damage_log[DamageType.TEMPORAL] >= 50000)
		)
	end} },
	cunmult = function(self) return self:combatStatScale("cun", 0.15, 1) end,
	trigger = function(self, t, target, damtype, dam)
		if dam < 150 then return end
		if damtype == DamageType.ACID and rng.percent(20) then
			target:setEffect(target.EFF_ACID_SPLASH, 5, {src=self, dam=(dam * t.cunmult(self) / 2.5) / 5, atk=self:getCun() / 2, apply_power=math.max(self:combatSpellpower(), self:combatMindpower())})
		elseif damtype == DamageType.BLIGHT and target:canBe("disease") and rng.percent(20) then
			local diseases = {{self.EFF_WEAKNESS_DISEASE, "str"}, {self.EFF_ROTTING_DISEASE, "con"}, {self.EFF_DECREPITUDE_DISEASE, "dex"}}
			local disease = rng.table(diseases)
			target:setEffect(disease[1], 5, {src=self, dam=(dam * t.cunmult(self)/ 2.5) / 5, [disease[2]]=self:getCun() / 3, apply_power=math.max(self:combatSpellpower(), self:combatMindpower())})
		elseif damtype == DamageType.DARKNESS and target:canBe("blind") and rng.percent(20) then
			target:setEffect(target.EFF_BLINDED, 5, {apply_power=math.max(self:combatSpellpower(), self:combatMindpower())})
		elseif damtype == DamageType.TEMPORAL and target:canBe("slow") and rng.percent(20) then
			target:setEffect(target.EFF_SLOW, 5, {apply_power=math.max(self:combatSpellpower(), self:combatMindpower()), power=0.3})
		elseif damtype == DamageType.MIND and target:canBe("confusion") and rng.percent(20) then
			target:setEffect(target.EFF_CONFUSED, 5, {apply_power=math.max(self:combatSpellpower(), self:combatMindpower()), power=20})
		end
	end,
	info = function(self, t)
		return ([[你 被 灾 厄 光 环 笼 罩。 
		 你 造 成 的 酸 液 伤 害， 有 20％ 几 率 对 敌 人 造 成 原 伤 害 值 %d%% 的 伤 害， 持 续 5 回 合， 同 时 降 低 %d 点 命 中； 
		 你 造 成 的 枯 萎 伤 害， 有 20％ 几 率 导 致 敌 人 染 上 随 机 疾 病， 造 成 持 续 5 回 合 的 %d%% 原 始 伤 害， 降 低 随 机 某 项 属 性 %d 点； 
		 你 造 成 的 暗 影 伤 害， 有 20％ 几 率 使 敌 人 失 明， 持 续 5 回 合。 
		 你 造 成 的 时 空 伤 害， 有 20％ 几 率 使 敌 人 减 速 30％， 持 续 5 回 合。 
		 你 造 成 的 精 神 伤 害， 有 20％ 几 率 使 敌 人 混 乱， 持 续 5 回 合。 
		 以 上 效 果 只 有 在 伤 害 超 过 150 点 才 会 触 发。 
		 受 灵 巧 影 响， 伤 害 有 额 外 加 成 。 ]])
		:format(100*t.cunmult(self) / 2.5, self:getCun() / 2, 100*t.cunmult(self) / 2.5, self:getCun() / 3)
	end,
}

uberTalent{
	name = "Secrets of Telos",
	mode = "passive",
	require = { special={desc="找到泰勒斯法杖的上半部，下半部和宝石。", fct=function(self)
		local o1 = self:findInAllInventoriesBy("define_as", "GEM_TELOS")
		local o2 = self:findInAllInventoriesBy("define_as", "TELOS_TOP_HALF")
		local o3 = self:findInAllInventoriesBy("define_as", "TELOS_BOTTOM_HALF")
		return o1 and o2 and o3
	end} },
	on_learn = function(self, t)
		local list = mod.class.Object:loadList("/data/general/objects/special-artifacts.lua")
		local o = game.zone:makeEntityByName(game.level, list, "TELOS_SPIRE", true)
		if o then
			o:identify(true)
			self:addObject(self.INVEN_INVEN, o)

			local o1, item1, inven1 = self:findInAllInventoriesBy("define_as", "GEM_TELOS")
			self:removeObject(inven1, item1, true)
			local o2, item2, inven2 = self:findInAllInventoriesBy("define_as", "TELOS_TOP_HALF")
			self:removeObject(inven2, item2, true)
			local o3, item3, inven3 = self:findInAllInventoriesBy("define_as", "TELOS_BOTTOM_HALF")
			self:removeObject(inven3, item3, true)

			self:sortInven()

			game.logSeen(self, "#VIOLET#%s 收集了 %s!", self.name:capitalize(), o:getName{do_colour=true, no_count=true})
		end
	end,
	info = function(self, t)
		return ([[泰 勒 斯 有 三 宝： 又 长、 又 粗、 打 怪 好。 
		 通 过 对 泰 勒 斯 三 宝 的 长 期 研 究， 你 相 信 你 可 以 使 它 们 合 为 一 体。  ]])
		:format()
	end,
}

uberTalent{
	name = "Elemental Surge",
	mode = "passive",
	cooldown = 12,
	require = { special={desc="曾 造 成 50000 点 奥 术、 火 焰、 冰 冷、 闪 电、 光 系 或 自 然 伤 害", fct=function(self) return 
		self.damage_log and (
			(self.damage_log[DamageType.ARCANE] and self.damage_log[DamageType.ARCANE] >= 50000) or
			(self.damage_log[DamageType.FIRE] and self.damage_log[DamageType.FIRE] >= 50000) or
			(self.damage_log[DamageType.COLD] and self.damage_log[DamageType.COLD] >= 50000) or
			(self.damage_log[DamageType.LIGHTNING] and self.damage_log[DamageType.LIGHTNING] >= 50000) or
			(self.damage_log[DamageType.LIGHT] and self.damage_log[DamageType.LIGHT] >= 50000) or
			(self.damage_log[DamageType.NATURE] and self.damage_log[DamageType.NATURE] >= 50000)
		)
	end} },
	getThreshold = function(self, t) return 4*self.level end,
	getColdEffects = function(self, t)
		return {physresist = 30,
		armor = self:combatStatScale("cun", 20, 50, 0.75),
		dam = math.max(100, self:getCun()),
		}
	end,
	getShield = function(self, t) return 100 + 2*self:getCun() end,
	-- triggered in default projector in mod.data.damage_types.lua
	trigger = function(self, t, target, damtype, dam)
		if dam < t.getThreshold(self, t) then return end
		
		local ok = false
		if damtype == DamageType.ARCANE and rng.percent(30) then ok=true self:setEffect(self.EFF_ELEMENTAL_SURGE_ARCANE, 5, {})
		elseif damtype == DamageType.FIRE and rng.percent(30) then ok=true self:removeEffectsFilter{type="magical", status="detrimental"} self:removeEffectsFilter{type="physical", status="detrimental"} game.logSeen(self, "#CRIMSON#%s fiery attack invokes a cleansing flame!", self.name:capitalize())
		elseif damtype == DamageType.COLD and rng.percent(30) then
			-- EFF_ELEMENTAL_SURGE_COLD in mod.data.timed_effect.magical.lua holds the parameters
			ok=true self:setEffect(self.EFF_ELEMENTAL_SURGE_COLD, 5, t.getColdEffects(self, t))
		elseif damtype == DamageType.LIGHTNING and rng.percent(30) then ok=true self:setEffect(self.EFF_ELEMENTAL_SURGE_LIGHTNING, 5, {})
		elseif damtype == DamageType.LIGHT and rng.percent(30) and not self:hasEffect(self.EFF_DAMAGE_SHIELD) then
			ok=true
			self:setEffect(self.EFF_DAMAGE_SHIELD, 5, {power=t.getShield(self, t)})
		elseif damtype == DamageType.NATURE and rng.percent(30) then ok=true self:setEffect(self.EFF_ELEMENTAL_SURGE_NATURE, 5, {})
		end

		if ok then self:startTalentCooldown(t) end
	end,
	info = function(self, t)
		local cold = t.getColdEffects(self, t)
		return ([[你 被 元 素 光 环 笼 罩， 当 使 用 某 种 元 素 造 成 暴 击 时， 有 一 定 几 率 触 发 以 下 特 效： 
		 奥 术 伤 害 有 30％ 几 率 使 自 身 增 加 20％ 施 法 速 度， 持 续 5 回 合。 
		 火 焰 伤 害 有 30％ 几 率 移 除 自 身 所 有 物 理 和 魔 法 的 负 面 效 果。
		 寒 冷 伤 害 有 30％ 几 率 获 得 持 续 5 回 合 的 冰 晶 皮 肤， 受 到 的 物 理 伤 害 减 少 %d%%， 提 升 %d 护 甲，并 且 攻 击 者 会 受 到 %d 点 冰 冷 反 弹 伤 害。 
		 闪 电 伤 害 有 30％ 几 率 化 为 闪 电 之 体 5 回 合， 受 到 的 任 何 攻 击 会 让 你 向 相 邻 位 置 传 送 一 码， 从 而 使 伤 害 无 效（ 此 效 果 每 回 合 只 能 生 效 一 次）。 
		 光 系 伤 害 有 30％ 几 率 形 成 一 个 吸 收 %d 伤 害 的 护 盾， 持 续 5 回 合。 
		 自 然 伤 害 有 30％ 几 率 强 化 你 的 皮 肤， 对 任 何 魔 法 负 面 效 果 免 疫， 持 续 5 回 合。 
		 寒 冷 和 光 系 效 果 随 灵 巧 增 长 。 
		 以 上 效 果 只 有 在 伤 害 超 过 %d 点 的 情 况 下 才 会 触 发（ 由 你 的 等 级 决 定）。 ]])
		:format(cold.physresist, cold.armor, cold.dam, t.getShield(self, t), t.getThreshold(self, t))
	end,
}

uberTalent{
	name = "Eye of the Tiger",
	mode = "passive",
	trigger = function(self, t, kind)
		if self.turn_procs.eye_tiger then return end

		local tids = {}

		for tid, _ in pairs(self.talents_cd) do
			local t = self:getTalentFromId(tid)
			if 
				(kind == "physical" and
					(
						t.type[1]:find("^technique/") or
						t.type[1]:find("^cunning/")
					)
				) or
				(kind == "spell" and
					(
						t.type[1]:find("^spell/") or
						t.type[1]:find("^corruption/") or
						t.type[1]:find("^celestial/") or
						t.type[1]:find("^chronomancy/")
					)
				) or
				(kind == "mind" and
					(
						t.type[1]:find("^wild%-gift/") or
						t.type[1]:find("^cursed/") or
						t.type[1]:find("^psionic/")
					)
				)
				then
				tids[#tids+1] = tid
			end
		end
		if #tids == 0 then return end
		local tid = rng.table(tids)
		self.talents_cd[tid] = self.talents_cd[tid] - (kind == "spell" and 1 or 2)
		if self.talents_cd[tid] <= 0 then self.talents_cd[tid] = nil end
		self.changed = true
		self.turn_procs.eye_tiger = true
	end,
	info = function(self, t)
		return ([[所 有 的 物 理 暴 击 减 少 随 机 的 1 个 冷 却 中 的 格 斗 或 灵 巧 系 技 能 2 回 合 冷 却 时 间。 
		 所 有 的 法 术 暴 击 减 少 随 机 的 1 个 冷 却 中 的 魔 法 系 技 能 1 回 合 冷 却 时 间。 
		 所 有 的 精 神 暴 击 减 少 随 机 的 1 个 冷 却 中 的 自 然 / 心 灵 / 痛 苦 系 技 能 2 回 合 冷 却 时 间。 
		 每 回 合 只 能 触 发 一 次， 并 且 无 法 影 响 当 前 触 发 该 效 果 的 技 能。  ]])
		:format()
	end,
}

uberTalent{
	name = "Worldly Knowledge",
	mode = "passive",
	on_learn = function(self, t, kind)
		local Chat = require "engine.Chat"
		local chat = Chat.new("worldly-knowledge", {name="Worldly Knowledge"}, self)
		chat:invoke()
	end,
	info = function(self, t)
		return ([[以 0.9 的 技 能 系 数 学 会 以 下 技 能 树 中 的 一 个。
		 分 组 1 中 的 技 能， 所 有 职 业 都 可 学。
		 分 组 2 中 的 技 能， 只 适 用 于 不 学 法 术 和 符 文 的 职 业。
		 分 组 3 中 的 技 能， 不 适 用 于 反 魔 神 教 的 信 徒。
		 分 组 1：
		- 格 斗 / 体 质 强 化 系
		- 灵 巧 / 生 存 系
		 分 组 2：
		- 格 斗 / 移 动 系
		- 格 斗 / 阵 地 控 制 系
		- 自 然 / 自 然 召 唤 系
		- 自 然 / 灵 晶 掌 握 系
		- 超 能 / 梦 境 系
		 分 组 3：
		- 法 术 / 侦 查 系 
		- 法 术 / 法 杖 格 斗 系
		- 法 术 / 岩 石 炼 金 系
		- 天 空 / 赞 歌 系
		- 天 空 / 圣 光 系
		- 时 空 / 时 空 系]])
		:format()
	end,
}

uberTalent{
	name = "Tricks of the Trade",
	mode = "passive",
	require = { special={desc="与盗贼领主同流合污", fct=function(self) return game.state.birth.ignore_prodigies_special_reqs or (self:isQuestStatus("lost-merchant", engine.Quest.COMPLETED, "evil")) end} },
	on_learn = function(self, t) 
		if self:knowTalentType("cunning/stealth") then
			self:setTalentTypeMastery("cunning/stealth", self:getTalentTypeMastery("cunning/stealth") + 0.2)
		elseif self:knowTalentType("cunning/stealth") == false then
			self:learnTalentType("cunning/stealth", true)
		end
		if self:knowTalentType("cunning/scoundrel") then
			self:setTalentTypeMastery("cunning/scoundrel", self:getTalentTypeMastery("cunning/scoundrel") + 0.1)
		else
			self:learnTalentType("cunning/scoundrel", true)
			self:setTalentTypeMastery("cunning/scoundrel", 0.9)
		end
		self.invisible_damage_penalty_divisor = (self.invisible_damage_penalty_divisor or 0) + 2
	end,
	info = function(self, t)
		return ([[你 结 交 了 狐 朋 狗 友， 学 到 了 一 些 下 三 滥 的 技 巧。 
		 增 加 灵 巧 / 潜 行 系 0.2 系 数 值（ 需 习 得 该 技 能 树， 未 解 锁 则 会 解 锁 此 技 能）， 同 时 增 加 灵 巧 / 街 头 格 斗 系 0.1 系 数 值（ 未 习 得 则 以 0.9 的 技 能 系 数 解 锁 此 技 能 树）。
		 此 外， 你 处 于 隐 形 时 的 伤 害 惩 罚 永 久 减 半。  ]]):
		format()
	end,
}

