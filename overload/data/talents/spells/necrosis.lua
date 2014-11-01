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
	name = "Blurred Mortality",
	type = {"spell/necrosis",1},
	require = spells_req1,
	mode = "sustained",
	points = 5,
	sustain_mana = 30,
	cooldown = 30,
	tactical = { BUFF = 2 },
	lifeBonus = function(self, t) -- Add fraction of max life
		return 50 * self:getTalentLevelRaw(t) + self.max_life * self:combatTalentLimit(t, 1, .01, .05)
	end,
	activate = function(self, t)
		if self.player and not self:hasQuest("lichform") and not self:attr("undead") then
			self:grantQuest("lichform")
			if game.state.birth.campaign_name ~= "maj-eyal" then self:setQuestStatus("lichform", engine.Quest.DONE) end
			require("engine.ui.Dialog"):simplePopup("Lichform", "You have mastered the lesser arts of overcoming death, but your true goal is before you: the true immortality of Lichform!")
		end

		local ret = {
			die_at = self:addTemporaryValue("die_at", -t.lifeBonus(self, t)),
		} -- Add up to 100% max life
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("die_at", p.die_at)
		return true
	end,
	info = function(self, t)
		return ([[对 你 而 言， 生 死 之 别 变 的 模 糊， 你 只 有 在 生 命 值 下 降 到 -%d 时 才 会 死 亡。 
		 但 是 当 你 生 命 值 降 到 0 时， 你 无 法 看 到 你 还 剩 多 少 生 命 值。]]):
		format(t.lifeBonus(self, t))
	end,
}

newTalent{
	name = "Impending Doom",
	type = {"spell/necrosis",2},
	require = spells_req2,
	points = 5,
	mana = 70,
	cooldown = 30,
	tactical = { ATTACK = { ARCANE = 3 }, DISABLE = 2 },
	range = 7,
	requires_target = true,
	getMax = function(self, t) return 200 + self:combatTalentSpellDamage(t, 28, 850) end,
	getDamage = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 10, 100), 150, 50, 0, 117, 67) end, -- Limit damage factor to < 150%
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			local dam = target.life * t.getDamage(self, t) / 100
			dam = math.min(dam, t.getMax(self, t))
			target:setEffect(target.EFF_IMPENDING_DOOM, 10, {apply_power=self:combatSpellpower(), dam=dam/10, src=self})
		end, 1, {type="freeze"})
		return true
	end,
	info = function(self, t)
		return ([[你 使 目 标 厄 运 临 头。 目 标 的 治 疗 加 成 减 少 100%% 且 会 对 目 标 造 成 它 %d%% 剩 余 生 命 值 的 奥 术 伤 害（ 或 %0.2f ， 取 最 小 伤 害 值）， 持 续 10 回 合。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(t.getDamage(self, t), t.getMax(self, t))
	end,
}

newTalent{
	name = "Undeath Link",
	type = {"spell/necrosis",3},
	require = spells_req3,
	points = 5,
	random_ego = "attack",
	mana = 35,
	cooldown = 20,
	tactical = { HEAL = 2 },
	is_heal = true,
	getHeal = function(self, t) return self:combatLimit(self:combatTalentSpellDamage(t, 10, 70), 100, 20, 0,  66.7, 46.7) end, --Limit to <100%
	on_pre_use = function(self, t)
		if game.party and game.party:hasMember(self) then
			for act, def in pairs(game.party.members) do
				if act.summoner and act.summoner == self and act.necrotic_minion then
					return true
				end
			end
		else
			for uid, act in pairs(game.level.entities) do
				if act.summoner and act.summoner == self and act.necrotic_minion then
					return true
				end
			end
		end
		return false
	end,
	action = function(self, t)
		local heal = t.getHeal(self, t)
		local maxdrain = 0 --Use biggest drain for healing purposes
		local drain = 0
		if game.party and game.party:hasMember(self) then
			for act, def in pairs(game.party.members) do
				if act.summoner and act.summoner == self and act.necrotic_minion then
					drain = math.min(act.max_life * heal / 100, act.life-act.die_at)
					act:takeHit(drain, self)
					maxdrain = math.max(maxdrain, drain)
				end
			end
		else
			for uid, act in pairs(game.level.entities) do
				if act.summoner and act.summoner == self and act.necrotic_minion then
					drain = math.min(act.max_life * heal / 100, act.life-act.die_at)
					act:takeHit(drain, self)
					maxdrain = math.max(maxdrain, drain)
				end
			end
		end
		self:attr("allow_on_heal", 1)
		self:heal(maxdrain)
		local empower = necroEssenceDead(self)
		if empower then
			self:setEffect(self.EFF_DAMAGE_SHIELD, 4, {color={0xcb/255, 0xcb/255, 0xcb/255}, power=maxdrain * 0.3})
			empower()
		end
		self:attr("allow_on_heal", -1)
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {size_factor=1.5, y=-0.3, img="healdark", life=25}, {type="healing", time_factor=6000, beamsCount=15, noup=2.0, beamColor1={0xcb/255, 0xcb/255, 0xcb/255, 1}, beamColor2={0x35/255, 0x35/255, 0x35/255, 1}}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {size_factor=1.5, y=-0.3, img="healdark", life=25}, {type="healing", time_factor=6000, beamsCount=15, noup=1.0, beamColor1={0xcb/255, 0xcb/255, 0xcb/255, 1}, beamColor2={0x35/255, 0x35/255, 0x35/255, 1}}))
		end
		game:playSoundNear(self, "talents/ice")
		return true
	end,
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[[吸 收 你 所 有 亡 灵 随 从 %d%% 的 最 大 生 命 值（ 可 能 会 杀 死 它 们） 并 使 用 这 股 能 量 治 愈 你。
		 受 法 术 强 度 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(heal)
	end,
}

newTalent{
	name = "Lichform",
	type = {"spell/necrosis",4},
	require = {
		stat = { mag=function(level) return 40 + (level-1) * 2 end },
		level = function(level) return 20 + (level-1)  end,
		special = { desc="完成'起死回生'任务并且不是不死族", fct=function(self, t) return not self:attr("undead") and (self:isQuestStatus("lichform", engine.Quest.DONE) or game.state.birth.ignore_prodigies_special_reqs) end},
	},
	mode = "sustained",
	points = 5,
	sustain_mana = 150,
	cooldown = 30,
	no_unlearn_last = true,
	no_npc_use = true,
	becomeLich = function(self, t)
		self.has_used_lichform = true
		self.descriptor.race = "Undead"
		self.descriptor.subrace = "Lich"
		if not self.has_custom_tile then
			self.moddable_tile = "skeleton"
			self.moddable_tile_nude = 1
			self.moddable_tile_base = "base_lich_01.png"
			self.moddable_tile_ornament = nil
			self.attachement_spots = "race_skeleton"
		end
		self.blood_color = colors.GREY
		self:attr("poison_immune", 1)
		self:attr("disease_immune", 0.5)
		self:attr("stun_immune", 0.5)
		self:attr("cut_immune", 1)
		self:attr("fear_immune", 1)
		self:attr("no_breath", 1)
		self:attr("undead", 1)
		self.resists[DamageType.COLD] = (self.resists[DamageType.COLD] or 0) + 20
		self.resists[DamageType.DARKNESS] = (self.resists[DamageType.DARKNESS] or 0) + 20
		self.inscription_restrictions = self.inscription_restrictions or {}
		self.inscription_restrictions["inscriptions/runes"] = true
		self.inscription_restrictions["inscriptions/taints"] = true

		local level = self:getTalentLevel(t)
		if level < 2 then
			self:incIncStat("mag", -3) self:incIncStat("wil", -3)
			self.resists.all = (self.resists.all or 0) - 10
		elseif level < 3 then
			-- nothing
		elseif level < 4 then
			self:incIncStat("mag", 3) self:incIncStat("wil", 3)
			self.life_rating = self.life_rating + 1
		elseif level < 5 then
			self:incIncStat("mag", 3) self:incIncStat("wil", 3)
			self:attr("combat_spellresist", 10) self:attr("combat_mentalresist", 10)
			self.life_rating = self.life_rating + 2
			self:learnTalentType("celestial/star-fury", true)
			self:setTalentTypeMastery("celestial/star-fury", self:getTalentTypeMastery("celestial/star-fury") - 0.3)
			self.negative_regen = self.negative_regen + 0.2 + 0.1
		elseif level < 6 then
			self:incIncStat("mag", 5) self:incIncStat("wil", 5)
			self:attr("combat_spellresist", 10) self:attr("combat_mentalresist", 10)
			self.resists_cap.all = (self.resists_cap.all or 0) + 10
			self.life_rating = self.life_rating + 2
			self:learnTalentType("celestial/star-fury", true)
			self:setTalentTypeMastery("celestial/star-fury", self:getTalentTypeMastery("celestial/star-fury") - 0.1)
			self.negative_regen = self.negative_regen + 0.2 + 0.5
		else
			self:incIncStat("mag", 6) self:incIncStat("wil", 6) self:incIncStat("cun", 6)
			self:attr("combat_spellresist", 15) self:attr("combat_mentalresist", 15)
			self.resists_cap.all = (self.resists_cap.all or 0) + 15
			self.life_rating = self.life_rating + 3
			self:learnTalentType("celestial/star-fury", true)
			self:setTalentTypeMastery("celestial/star-fury", self:getTalentTypeMastery("celestial/star-fury") + 0.1)
			self.negative_regen = self.negative_regen + 0.2 + 1
		end

		if self:attr("blood_life") then
			self.blood_life = nil
			game.log("#GREY#As you turn into a powerful undead you feel your body violently rejecting the Blood of Life.")
		end

		require("engine.ui.Dialog"):simplePopup("Lichform", "#GREY#You feel your life slip away, only to be replaced by pure arcane forces! Your flesh starts to rot on your bones, and your eyes fall apart as you are reborn into a Lich!")

		game.level.map:particleEmitter(self.x, self.y, 1, "demon_teleport")
	end,
	on_pre_use = function(self, t)
		if self:attr("undead") then return false else return true end
	end,
	activate = function(self, t)
		local ret = {
			mana = self:addTemporaryValue("mana_regen", -4),
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("mana_regen", p.mana)
		return true
	end,
	info = function(self, t)
		return ([[你 的 终 极 目 标。 所 有 亡 灵 法 师 的 目 标， 就 是 变 成 一 个 强 大 且 永 生 的 巫 妖！ 
		 当 此 技 能 激 活 时， 如 果 你 被 杀 死， 你 的 身 体 会 被 转 化 为 巫 妖。 
		 所 有 的 巫 妖 会 增 加 以 下 天 赋： 
		* 中 毒、 流 血、 恐 惧 免 疫 
		*50%% 疾 病 和 震 慑 抵 抗 
		*20%% 冰 冷 和 暗 影 抵 抗 
		* 不 需 要 呼 吸 
		* 纹 身 不 起 作 用 
		 同 时： 
		* 等 级 1： -3 所 有 属 性， -10%% 所 有 抵 抗。 
		 如 此 微 小 的 代 价！ 
		* 等 级 2： 无 
		* 等 级 3： +3 魔 法 和 意 志， +1 每 等 级 增 加 生 命 值（ 不 追 加 前 面 等 级 的 生 命 值）。 
		* 等 级 4： +3 魔 法 和 意 志， +2 每 等 级 增 加 生 命 值（ 不 追 加 前 面 等 级 的 生 命 值）， +10 法 术 和 精 神 豁 免， 天 空 / 星 怒 系 技 能 树（ 0.7） 和 每 回 合 0.1 负 能 量 回 复。 
		* 等 级 5： +5 魔 法 和 意 志， +2 每 等 级 增 加 生 命 值（ 不 追 加 前 面 等 级 的 生 命 值）， +10 法 术 和 精 神 豁 免， 所 有 抵 抗 上 限 增 加 10%%， 天 空 / 星 怒 系 技 能 树（ 0.9） 和 每 回 合 0.5 负 能 量 回 复。 
		* 等 级 6： +6 魔 法、 意 志 和 灵 巧， +3 每 等 级 增 加 生 命 值（ 不 追 加 前 面 等 级 的 生 命 值）， +15 法 术 和 精 神 豁 免， 所 有 抵 抗 上 限 增 加 15%%， 天 空 / 星 怒 系 技 能 树（ 1.1） 和 每 回 合 1.0 负 能 量 回 复。 恐 惧 我 的 力 量 吧！ 
		 不 死 族 无 法 使 用 此 天 赋。 
		 当 此 技 能 激 活 时， 每 回 合 消 耗 4 法 力 值。]]):
		format()
	end,
}
