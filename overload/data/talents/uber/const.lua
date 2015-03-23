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
	name = "Draconic Body",
	mode = "passive",
	cooldown = 20,
	require = { special={desc="熟悉龙之世界", fct=function(self) return game.state.birth.ignore_prodigies_special_reqs or (self:attr("drake_touched") and self:attr("drake_touched") >= 2) end} },
	trigger = function(self, t, value)
		if self.life - value < self.max_life * 0.3 and not self:isTalentCoolingDown(t) then
			self:heal(self.max_life * 0.4, t)
			self:startTalentCooldown(t)
			game.logSeen(self,"%s's draconic body hardens and heals!",self.name)
		end
	end,
	info = function(self, t)
		return ([[你 的 身 体 如 龙 般 坚 固， 当 生 命 值 下 降 到 30％ 以 下 时， 恢 复 40％ 的 最 大 生 命 值。  ]])
		:format()
	end,
}

uberTalent{
	name = "Bloodspring",
	mode = "passive",
	cooldown = 12,
	require = { special={desc="梅琳达被献祭", fct=function(self) return game.state.birth.ignore_prodigies_special_reqs or (self:hasQuest("kryl-feijan-escape") and self:hasQuest("kryl-feijan-escape"):isStatus(engine.Quest.FAILED)) end} },
	trigger = function(self, t)
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, 4,
			DamageType.BLOODSPRING, {dam={dam=100 + self:getCon() * 3, healfactor=0.5}, x=self.x, y=self.y, st=DamageType.DRAINLIFE, power=50 + self:getCon() * 2},
			1,
			5, nil,
			MapEffect.new{color_br=255, color_bg=20, color_bb=20, effect_shader="shader_images/darkness_effect.png"},
			function(e, update_shape_only)
				if not update_shape_only then e.radius = e.radius + 0.5 end
				return true
			end,
			false
		)
		game:playSoundNear(self, "talents/tidalwave")
		self:startTalentCooldown(t)
	end,
	info = function(self, t)
		return ([[当 敌 人 的 单 次 攻 击 造 成 超 过 你 15%% 总 生 命 值 伤 害 时， 产 生 持 续 4 回 合 的 血 之 狂 潮， 造 成 %0.2f 枯 萎 伤 害 并 治 疗 你 相 当 于 50％ 伤 害 值 的 生 命， 同 时 击 退 敌 人。 
		 受 体 质 影 响， 伤 害 有 额 外 加 成。  ]])
		:format(100 + self:getCon() * 3)
	end,
}

uberTalent{
	name = "Eternal Guard",
	mode = "passive",
	require = { special={desc="掌握格挡技能", fct=function(self) return self:knowTalent(self.T_BLOCK) end} },
	info = function(self, t)
		return ([[你 的 格 挡 技 能 持 续 时 间 增 加 1 回 合， 并 且 被 击 中 后 不 会 结 束。  ]])
		:format()
	end,
}

uberTalent{
	name = "Never Stop Running",
	mode = "sustained",
	cooldown = 20,
	sustain_stamina = 10,
	tactical = { CLOSEIN = 2, ESCAPE = 2 },
	no_energy = true,
	require = { special={desc="掌握至少20级使用体力的技能", fct=function(self) return knowRessource(self, "stamina", 20) end} },
	activate = function(self, t)
		local ret = {}
		self:talentTemporaryValue(ret, "move_stamina_instead_of_energy", 12)
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	info = function(self, t)
		return ([[当 技 能 激 活 时， 你 可 以 挖 掘 出 体 能 的 极 限， 移 动 不 会 耗 费 回 合， 但 是 每 移 动 一 码 需 消 耗 12 点 体 力。  ]])
		:format()
	end,
}

uberTalent{
	name = "Armour of Shadows",
	mode = "passive",
	require = { special={desc="曾造成超过50000点暗影伤害", fct=function(self) return
		self.damage_log and (
			(self.damage_log[DamageType.DARKNESS] and self.damage_log[DamageType.DARKNESS] >= 50000)
		)
	end} },
	-- called by _M:combatArmor in mod\class\interface\Combat.lua
	ArmourBonus = function(self, t) return math.max(30, 0.5*self:getCon()) end,
	on_learn = function(self, t)
		self:attr("darkness_darkens", 1)
	end,
	on_unlearn = function(self, t)
		self:attr("darkness_darkens", -1)
	end,
	info = function(self, t)
		return ([[你 懂 得 如 何 融 入 阴 影， 当 你 站 在 黑 暗 地 形 上 时 将 增 加 %d 点 护 甲 和 50％ 护 甲 韧 性。 同 时， 你 造 成 的 暗 影 伤 害 会 使 你 当 前 所 在 区 域 和 目 标 区 域 陷 入 黑 暗。  
		 受 体 质 影 响, 护 甲 加 值 有 额 外 加 成。]])
		:format(t.ArmourBonus(self,t))
	end,
}

uberTalent{
	name = "Spine of the World",
	mode = "passive",
	trigger = function(self, t)
		if self:hasEffect(self.EFF_SPINE_OF_THE_WORLD) then return end
		self:setEffect(self.EFF_SPINE_OF_THE_WORLD, 5, {})
	end,
	info = function(self, t)
		return ([[你 的 后 背 坚 若 磐 石。 当 你 受 到 物 理 效 果 影 响 时， 你 的 身 体 会 硬 化， 在 5 回 合 内 对 所 有 其 他 物 理 效 果 免 疫。 ]])
		:format()
	end,
}

uberTalent{
	name = "Fungal Blood",
	require = { special={desc="能使用纹身", fct=function(self) return not self.inscription_restrictions or self.inscription_restrictions['inscriptions/infusions'] end} },
	tactical = { HEAL = function(self) return not self:hasEffect(self.EFF_FUNGAL_BLOOD) and 0 or math.ceil(self:hasEffect(self.EFF_FUNGAL_BLOOD).power / 150) end },
	healmax = function(self, t) return self.max_life * self:combatStatLimit("con", 0.5, 0.1, 0.25) end, -- Limit < 50% max life
	fungalPower = function(self, t) return self:getCon()*2 + self.max_life * self:combatStatLimit("con", 0.05, 0.005, 0.01) end,
	on_pre_use = function(self, t) return self:hasEffect(self.EFF_FUNGAL_BLOOD) and self:hasEffect(self.EFF_FUNGAL_BLOOD).power > 0 and not self:attr("undead") end,
	trigger = function(self, t)
		if self.inscription_restrictions and not self.inscription_restrictions['inscriptions/infusions'] then return end
		self:setEffect(self.EFF_FUNGAL_BLOOD, 6, {power=t.fungalPower(self, t)})
	end,
	no_energy = true,
	-- decay handed by "FUNGAL_BLOOD" effect in mod.data.timed_effects.physical.lua
	action = function(self, t)
		local eff = self:hasEffect(self.EFF_FUNGAL_BLOOD)
		self:attr("allow_on_heal", 1)
		self:heal(math.min(eff.power, t.healmax(self,t)), eff)
		self:attr("allow_on_heal", -1)
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0, circleDescendSpeed=3.5}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0, circleDescendSpeed=3.5}))
		end
		self:removeEffectsFilter({status="detrimental", type="magical"}, 10)
		self:removeEffect(self.EFF_FUNGAL_BLOOD)
		return true
	end,
	info = function(self, t)
		return ([[真 菌 充 斥 在 你 的 血 液 中， 每 当 使 用 纹 身 时 你 都 会 储 存 %d 的 真 菌 能 量。 
		 当 使 用 此 技 能 时， 可 释 放 能 量 治 愈 伤 口 ( 恢 复 值 不 超 过 %d ),  并 解 除 至 多 10 个 负 面 魔 法 效 果。 
		 真 菌 之 力 保 存 6 回 合， 每 回 合 减 少 10 点或 10%% 。  
		 受 体 质 影 响， 真 菌 能 量 的 保 存 数 量 和 治 疗 上 限 有 额 外 加 成。]])
		:format(t.fungalPower(self, t), t.healmax(self,t))
	end,
}

uberTalent{
	name = "Corrupted Shell",
	mode = "passive",
	require = { special={desc="承 受 过 至 少 7500 点 枯 萎 伤 害 并 和 堕 落 领 主 一 起 摧 毁 伊 码。", fct=function(self) return
		(self.damage_intake_log and self.damage_intake_log[DamageType.BLIGHT] and self.damage_intake_log[DamageType.BLIGHT] >= 7500) and
		(game.state.birth.ignore_prodigies_special_reqs or (
			self:hasQuest("anti-antimagic") and 
			self:hasQuest("anti-antimagic"):isStatus(engine.Quest.DONE) and
			not self:hasQuest("anti-antimagic"):isStatus(engine.Quest.COMPLETED, "grand-corruptor-treason")
		))
	end} },
	on_learn = function(self, t)
		self.max_life = self.max_life + 250
		self.combat_armor_hardiness = self.combat_armor_hardiness + 20
	end,
	info = function(self, t)
		return ([[多 亏 了 你 在 堕 落 能 量 上 的 新 发 现， 你 学 到 一 些 方 法 来 增 强 你 的 体 质。 但 是 只 有 当 你 有 一 副 强 壮 的 体 魄 时 方 能 承 受 这 剧 烈 的 变 化。 
		 增 加 你 250 点 生 命 上 限， %d 点 闪 避，20%% 护 甲 硬 度 , %d 所 有 豁 免， 你 的 身 体 已 经 突 破 了 自 然 界 的 范 畴 和 大 自 然 的 限 制。 
		 受 体 质 影 响， 豁 免 和 闪 避 有 额 外 加 成。]])
		:format(self:getCon() / 3, self:getCon() / 3)
	end,
}
