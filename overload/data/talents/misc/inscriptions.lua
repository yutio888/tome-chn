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

newInscription = function(t)
	-- Warning, up that if more than 5 inscriptions are ever allowed
	for i = 1, 6 do
		local tt = table.clone(t)
		tt.short_name = tt.name:upper():gsub("[ ]", "_").."_"..i
		tt.display_name = function(self, t)
			local data = self:getInscriptionData(t.short_name)
			if data.item_name then
				local n = tstring{t.name, " ["}
				n:merge(data.item_name)
				n:add("]")
				return n
			else
				return t.name
			end
		end
		if tt.type[1] == "inscriptions/infusions" then tt.auto_use_check = function(self, t) return not self:hasEffect(self.EFF_INFUSION_COOLDOWN) end
		elseif tt.type[1] == "inscriptions/runes" then tt.auto_use_check = function(self, t) return not self:hasEffect(self.EFF_RUNE_COOLDOWN) end
		elseif tt.type[1] == "inscriptions/taints" then tt.auto_use_check = function(self, t) return not self:hasEffect(self.EFF_TAINT_COOLDOWN) end
		end
		tt.auto_use_warning = "- will only auto use when no saturation effect exists"
		tt.cooldown = function(self, t)
			local data = self:getInscriptionData(t.short_name)
			return data.cooldown
		end
		tt.old_info = tt.info
		tt.info = function(self, t)
			local ret = t.old_info(self, t)
			local data = self:getInscriptionData(t.short_name)
			if data.use_stat and data.use_stat_mod then
				ret = ret..("\n受 你 的 %s 影 响， 此 效 果 按 比 例 加 成。 "):format(s_stat_name[self.stats_def[data.use_stat].name] or self.stats_def[data.use_stat].name)
			end
			return ret
		end
		if not tt.image then
			tt.image = "talents/"..(t.short_name or t.name):lower():gsub("[^a-z0-9_]", "_")..".png"
		end
		tt.no_unlearn_last = true
		tt.is_inscription = true
		newTalent(tt)
	end
end

function change_infusion_eff(str)
	str = str:gsub("mental"," 精 神 "):gsub("magical"," 魔 法 "):gsub("physical"," 物 理 ")
	return str
end

-----------------------------------------------------------------------
-- Infusions
-----------------------------------------------------------------------
newInscription{
	name = "Infusion: Regeneration",
	type = {"inscriptions/infusions", 1},
	points = 1,
	tactical = { HEAL = 2 },
	on_pre_use = function(self, t) return not self:hasEffect(self.EFF_REGENERATION) end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:setEffect(self.EFF_REGENERATION, data.dur, {power=(data.heal + data.inc_stat) / data.dur})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 纹 身 治 疗 你 自 己 %d 生 命 值， 持 续 %d 回 合。 ]]):format(data.heal + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[治 疗 %d 持 续 %d 回 合  ]]):format(data.heal + data.inc_stat, data.dur)
	end,
}

newInscription{
	name = "Infusion: Healing",
	type = {"inscriptions/infusions", 1},
	points = 1,
	tactical = { HEAL = 2 },
	is_heal = true,
	no_energy = true,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:attr("allow_on_heal", 1)
		self:attr("disable_ancestral_life", 1)
		self:heal(data.heal + data.inc_stat, t)
		self:attr("disable_ancestral_life", -1)
		self:attr("allow_on_heal", -1)

		self:removeEffectsFilter(function(e) return e.subtype.wound end, 1)
		self:removeEffectsFilter(function(e) return e.subtype.poison end, 1)
		
		if core.shader.active(4) then
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=true , size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=2.0}))
			self:addParticles(Particles.new("shader_shield_temp", 1, {toback=false, size_factor=1.5, y=-0.3, img="healgreen", life=25}, {type="healing", time_factor=2000, beamsCount=20, noup=1.0}))
		end
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 纹 身 立 即 治 疗 你 %d 生 命 值, 同 时 去 除 一 个 流 血 或 毒 素 效 果 。]]):format(data.heal + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[治 疗 %d]]):format(data.heal + data.inc_stat)
	end,
}

newInscription{
	name = "Infusion: Wild",
	type = {"inscriptions/infusions", 1},
	points = 1,
	no_energy = true,
	tactical = {
		DEFEND = 3,
		CURE = function(self, t, target)
			local nb = 0
			local data = self:getInscriptionData(t.short_name)
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if data.what[e.type] and e.status == "detrimental" then
					nb = nb + 1
				end
			end
			return nb
		end
	},
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)

		local target = self
		local effs = {}
		local force = {}
		local known = false

		-- Go through all temporary effects
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if data.what[e.type] and e.status == "detrimental" and e.subtype["cross tier"] then
				force[#force+1] = {"effect", eff_id}
			elseif data.what[e.type] and e.status == "detrimental" then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		-- Cross tier effects are always removed and not part of the random game, otherwise it is a huge nerf to wild infusion
		for i = 1, #force do
			local eff = force[i]
			if eff[1] == "effect" then
				target:removeEffect(eff[2])
				known = true
			end
		end

		for i = 1, 1 do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				target:removeEffect(eff[2])
				known = true
			end
		end
		if known then
			game.logSeen(self, "%s is cured!", self.name:capitalize())
		end
		self:setEffect(self.EFF_PAIN_SUPPRESSION, data.dur, {power=data.power + data.inc_stat})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local what = table.concat(table.keys(data.what), ", ")
		return ([[激 活 纹 身 解 除 你 %s 效 果 并 减 少 所 有 伤 害 %d%% 持 续 %d 回 合。 ]]):format(change_infusion_eff(what), data.power+data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local what = table.concat(table.keys(data.what), ", ")
		return ([[减 伤 %d%%; 解 除 %s]]):format(data.power + data.inc_stat, what:gsub("physical"," 物 理 "):gsub("magical"," 魔 法 "):gsub("mental"," 精 神 ").." 效 果 ")
	end,
}

-- fixedart wild variant
newInscription{
	name = "Infusion: Primal", image = "talents/infusion__wild.png",
	type = {"inscriptions/infusions", 1},
	points = 1,
	no_energy = true,
	tactical = {
		DEFEND = 3,
		CURE = function(self, t, target)
			local nb = 0
			local data = self:getInscriptionData(t.short_name)
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if data.what[e.type] and e.status == "detrimental" then
					nb = nb + 1
				end
			end
			return nb
		end
	},
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)

		local target = self
		local effs = {}
		local force = {}
		local known = false

		-- Go through all temporary effects
		for eff_id, p in pairs(target.tmp) do
			local e = target.tempeffect_def[eff_id]
			if data.what[e.type] and e.status == "detrimental" and e.subtype["cross tier"] then
				force[#force+1] = {"effect", eff_id}
			elseif data.what[e.type] and e.status == "detrimental" then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		-- Cross tier effects are always removed and not part of the random game, otherwise it is a huge nerf to wild infusion
		for i = 1, #force do
			local eff = force[i]
			if eff[1] == "effect" then
				target:removeEffect(eff[2])
				known = true
			end
		end

		for i = 1, 1 do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				target:removeEffect(eff[2])
				known = true
			end
		end
		if known then
			game.logSeen(self, "%s is cured!", self.name:capitalize())
		end
		self:setEffect(self.EFF_PRIMAL_ATTUNEMENT, data.dur, {power=data.power + data.inc_stat})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local what = table.concat(table.keys(data.what), ", ")
		return ([[ 激 活 这 个 纹 身 ， 解 除 %s 效 果 并 将 你 受 到 的 %d%% 全 体 伤 害 转 化 为 治 疗 ， 持 续 %d 回 合 。]]):format(change_infusion_eff(what), data.power+data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local what = table.concat(table.keys(data.what), ", ")
		return ([[伤 害 治 疗 %d%%; 解 除 %s]]):format(data.power + data.inc_stat,change_infusion_eff(what))
	end,
}


newInscription{
	name = "Infusion: Movement",
	type = {"inscriptions/infusions", 1},
	points = 1,
	no_energy = true,
	tactical = { DEFEND = 1 },
	on_pre_use = function(self, t) return not self:attr("never_move") end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:setEffect(self.EFF_FREE_ACTION, data.dur, {power=1})
		game:onTickEnd(function() self:setEffect(self.EFF_WILD_SPEED, 1, {power=data.speed + data.inc_stat}) end)
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 纹 身 可 以 在 1 个 游 戏 回 合 内 提 升 移 动 速 度 %d%% 。 除 移 动 以 外 其 他 动 作 会 取 消 这 个 效 果。 
		 同 时 免 疫 眩 晕、 震 慑 和 定 身 效 果 %d 回 合。 
		 注 意： 由 于 你 的 速 度 非 常 快， 游 戏 回 合 会 相 对 很 慢。 ]]):format(data.speed + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d%% 加 速 ; %d 回 合 ]]):format(data.speed + data.inc_stat, data.dur)
	end,
}



newInscription{
	name = "Infusion: Sun",
	type = {"inscriptions/infusions", 1},
	points = 1,
	tactical = { ATTACKAREA = 1, DISABLE = { blind = 2 } },
	range = 0,
	radius = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.range
	end,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), selffire=false, radius=self:getTalentRadius(t), talent=t}
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, engine.DamageType.BLINDCUSTOMMIND, {power=data.power + data.inc_stat, turns=data.turns})
		self:project(tg, self.x, self.y, engine.DamageType.BREAK_STEALTH, {power=(data.power + data.inc_stat)/2, turns=data.turns})
		tg.selffire = true
		self:project(tg, self.x, self.y, engine.DamageType.LITE, data.power >= 19 and 100 or 1)
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 纹 身 照 亮 %d 区 域 和 潜 行 单 位， 可 能 使 潜 行 目 标 显 形（ 降 低 %d 潜 行 强 度）。 %s
		 同 时 区 域 内 目 标 也 有 几 率 被 致 盲（ %d 等 级）， 持 续 %d 回 合。 ]]):
		format(data.range, (data.power + data.inc_stat)/2, data.power >= 19 and "\n 这 光 线 是 如 此 强 烈， 以 至 于 能 驱 散 魔 法 造 成 的 黑 暗 " or "", data.power + data.inc_stat, data.turns)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[范 围 %d; 强 度 %d; 持 续 %d%s]]):format(data.range, data.power + data.inc_stat, data.turns, data.power >= 19 and "; 驱 散 黑 暗 " or "")
	end,
}

newInscription{
	name = "Infusion: Heroism",
	type = {"inscriptions/infusions", 1},
	points = 1,
	no_energy = true,
	tactical = { BUFF = 2 },
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:setEffect(self.EFF_HEROISM, data.dur, {power=data.power + data.inc_stat, die_at=data.die_at + data.inc_stat * 30})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 纹 身 可 以 增 加 你 3 项 基 础 属 性 %d ， 持 续 %d 回 合。
		同 时， 当 英 雄 纹 身 激 活 时， 你 的 生 命 值 只 有 在 降 低 到 -%d 生 命 时 才 会 死 亡。 然 而， 当 生 命 值 低 于 0 时， 你 无 法 看 到 你 还 剩 下 多 少 生 命。
		属 性 提 高 以 你 最 高 的 三 个 属 性 为 准。
		效 果 结 束 时， 如 果 你 的 生 命 值 在 0 以 下 ， 会 变 为 1 点。 ]]):format(data.power + data.inc_stat, data.dur, data.die_at + data.inc_stat * 30)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[+%d 持 续 %d 回 合， 死 亡 限 值 -%d]]):format(data.power + data.inc_stat, data.dur, data.die_at + data.inc_stat * 30)
	end,
}

newInscription{
	name = "Infusion: Insidious Poison",
	type = {"inscriptions/infusions", 1},
	points = 1,
	tactical = { ATTACK = { NATURE = 1 }, DISABLE=1, CURE = function(self, t, target)
			local nb = 0
			local data = self:getInscriptionData(t.short_name)
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type == "magical" and e.status == "detrimental" then nb = nb + 1 end
			end
			return nb
		end },
	requires_target = true,
	range = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.range
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_slime", trail="slimetrail"}}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.INSIDIOUS_POISON, {dam=data.power + data.inc_stat, dur=7, heal_factor=data.heal_factor}, {type="slime"})
		self:removeEffectsFilter({status="detrimental", type="magical", ignore_crosstier=true}, 1)
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 纹 身 会 发 射 一 个 毒 气 弹 造 成 每 回 合 %0.2f 自 然 伤 害 持 续 7 回 合， 并 降 低 目 标 治 疗 效 果 %d%% 。
		 突 然 涌 动 的 自 然 力 量 会 除 去 你 受 到 的 一 个 负 面 魔 法 效 果 。 ]]):format(damDesc(self, DamageType.NATURE, data.power + data.inc_stat) / 7, data.heal_factor)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d 自 然 伤 害， %d%% 治 疗 下 降 ]]):format(damDesc(self, DamageType.NATURE, data.power + data.inc_stat) / 7, data.heal_factor)
	end,
}

-- Opportunity cost for this is HUGE, it should not hit friendly, also buffed duration
newInscription{
	name = "Infusion: Wild Growth",
	type = {"inscriptions/infusions", 1},
	points = 1,
	tactical = { ATTACKAREA = { PHYSICAL = 1, NATURE = 1 }, DISABLE = 3 },
	range = 0,
	radius = 5,
	direct_hit = true,
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t), selffire=false, friendlyfire = false, talent=t}
	end,
	getDamage = function(self, t) return 10 + self:combatMindpower() * 3.6 end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local dam = t.getDamage(self, t)
		local tg = self:getTalentTarget(t)
		self:project(tg, self.x, self.y, function(tx, ty)
			DamageType:get(DamageType.ENTANGLE).projector(self, tx, ty, DamageType.ENTANGLE, dam)
		end)
		self:setEffect(self.EFF_THORNY_SKIN, data.dur, {hard=data.hard or 30, ac=data.armor or 50})
		game:playSoundNear(self, "talents/earth")
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local damage = t.getDamage(self, t)
		return ([[从 土 地 中 召 唤 坚 硬 的 藤 蔓， 缠 绕 %d 码 范 围 内 所 有 生 物， 持 续 %d 回 合。 将 其 定 身 并 造 成 每 回 合 %0.2f 物 理 和 %0.2f 自 然 伤 害。 
		 藤 蔓 也 会 生 长 在 你 的 身 边 ， 增 加 %d 护 甲 和 %d%% 护 甲 硬 度 。]]):
		format(self:getTalentRadius(t), data.dur, damDesc(self, DamageType.PHYSICAL, damage)/3, damDesc(self, DamageType.NATURE, 2*damage)/3, data.armor or 50, data.hard or 30)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[范 围 %d 持 续 %d 回 合 ]]):format(self:getTalentRadius(t), data.dur)
	end,
}

-----------------------------------------------------------------------
-- Runes
-----------------------------------------------------------------------
newInscription{
	name = "Rune: Phase Door",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	is_teleport = true,
	tactical = { ESCAPE = 2 },
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		self:teleportRandom(self.x, self.y, data.range + data.inc_stat)
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		self:setEffect(self.EFF_OUT_OF_PHASE, data.dur or 3, {
			defense=(data.power or data.range) + data.inc_stat * 3,
			resists=(data.power or data.range) + data.inc_stat * 3,
			effect_reduction=(data.power or data.range) + data.inc_stat * 3,
		})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = (data.power or data.range) + data.inc_stat * 3
		return ([[激 活 这 个 符 文 会 使 你 在 %d 码 范 围 内 随 机 传 送。 
		 之 后 ， 你 会 出 入 现 实 空 间 % d 回 合 ， 所 有 新 的 负 面 状 态 持 续 时 间 减 少 %d%% ， 闪 避 增 加 %d ， 全 体 伤 害 抗 性 增 加 %d%%。 ]]):
		format(data.range + data.inc_stat, data.dur or 3, power, power, power)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = (data.power or data.range) + data.inc_stat * 3
		return ([[范 围 %d; 强 度 %d; 持 续 %d]]):format(data.range + data.inc_stat, power, data.dur or 3)
	end,
}

newInscription{
	name = "Rune: Controlled Phase Door",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	is_teleport = true,
	tactical = { CLOSEIN = 2 },
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = {type="ball", nolock=true, pass_terrain=true, nowarning=true, range=data.range + data.inc_stat, radius=3, requires_knowledge=false}
		local x, y = self:getTarget(tg)
		if not x then return nil end
		-- Target code does not restrict the target coordinates to the range, it lets the project function do it
		-- but we cant ...
		local _ _, x, y = self:canProject(tg, x, y)

		-- Check LOS
		local rad = 3
		if not self:hasLOS(x, y) and rng.percent(35 + (game.level.map.attrs(self.x, self.y, "control_teleport_fizzle") or 0)) then
			game.logPlayer(self, "The targetted phase door fizzles and works randomly!")
			x, y = self.x, self.y
			rad = tg.range
		end

		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		self:teleportRandom(x, y, rad)
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文， 传 送 至 %d 码 内 的 指 定 位 置。 ]]):format(data.range + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[范 围 %d]]):format(data.range + data.inc_stat)
	end,
}

newInscription{
	name = "Rune: Teleportation",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	is_teleport = true,
	tactical = { ESCAPE = 3 },
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		self:teleportRandom(self.x, self.y, data.range + data.inc_stat, 15)
		game.level.map:particleEmitter(self.x, self.y, 1, "teleport")
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 随 机 传 送 %d 码 范 围 内 位 置， 至 少 传 送 15 码 以 外。 ]]):format(data.range + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[范 围 %d]]):format(data.range + data.inc_stat)
	end,
}

newInscription{
	name = "Rune: Shielding",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	allow_autocast = true,
	no_energy = true,
	tactical = { DEFEND = 2 },
	on_pre_use = function(self, t)
		return not self:hasEffect(self.EFF_DAMAGE_SHIELD)
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:setEffect(self.EFF_DAMAGE_SHIELD, data.dur, {power=data.power + data.inc_stat})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 产 生 一 个 防 护 护 盾， 吸 收 最 多 %d 伤 害 持 续 %d 回 合。 ]]):format(data.power + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[吸 收 %d 持 续 %d 回 合 ]]):format(data.power + data.inc_stat, data.dur)
	end,
}

newInscription{
	name = "Rune: Reflection Shield",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	allow_autocast = true,
	no_energy = true,
	tactical = { DEFEND = 2 },
	on_pre_use = function(self, t)
		return not self:hasEffect(self.EFF_DAMAGE_SHIELD)
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:setEffect(self.EFF_DAMAGE_SHIELD, 5, {power=100+5*self:getMag(), reflect=100})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 产 生 一 个 防 御 护 盾， 吸 收 并 反 弹 最 多 %d 伤 害 值， 持 续 %d 回 合。 效 果 与 魔 法 成 比 例 增 长。 ]])
		:format(100+5*self:getMag(), 5)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[吸 收 并 反 弹 %d 持 续 %d 回 合 ]]):format(100+5*self:getMag(), 5)
	end,
}

newInscription{
	name = "Rune: Invisibility",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	tactical = { DEFEND = 3, ESCAPE = 2 },
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:setEffect(self.EFF_INVISIBILITY, data.dur, {power=data.power + data.inc_stat, penalty=0.4})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 使 你 变 得 隐 形（ %d 隐 形 等 级） 持 续 %d 回 合。 
		 由 于 你 的 隐 形 使 你 从 现 实 相 位 中 脱 离， 你 的 所 有 伤 害 降 低 40%%。 
		]]):format(data.power + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[强 度 %d 持 续 %d 回 合 ]]):format(data.power + data.inc_stat, data.dur)
	end,
}

newInscription{
	name = "Rune: Speed",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	no_energy = true,
	tactical = { BUFF = 4 },
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:setEffect(self.EFF_SPEED, data.dur, {power=(data.power + data.inc_stat) / 100})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 提 高 整 体 速 度 %d%% 持 续 %d 回 合。 ]]):format(data.power + data.inc_stat, data.dur)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[ 提 速 %d%% 持 续 %d 回 合 ]]):format(data.power + data.inc_stat, data.dur)
	end,
}


newInscription{
	name = "Rune: Vision",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	no_npc_use = true,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:magicMap(data.range, self.x, self.y, function(x, y)
			local g = game.level.map(x, y, Map.TERRAIN)
			if g and (g.always_remember or g:check("block_move")) then
				for _, coord in pairs(util.adjacentCoords(x, y)) do
					local g2 = game.level.map(coord[1], coord[2], Map.TERRAIN)
					if g2 and not g2:check("block_move") then return true end
				end
			end
		end)
		self:setEffect(self.EFF_SENSE_HIDDEN, data.dur, {power=data.power + data.inc_stat})
		self:setEffect(self.EFF_RECEPTIVE_MIND, data.dur, {what=data.esp or "humanoid"})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local kind=data.esp or " 人 形 怪 "
                kind=kind:gsub("demon"," 恶 魔 "):gsub("animal"," 动 物 "):gsub("undead"," 不 死 族 "):gsub("dragon"," 龙 "):gsub("horror"," 恐 魔 "):gsub("humanoid","人 形 怪")
		return ([[激 活 这 个 符 文 可 以 使 你 查 看 周 围 环 境（ %d 有 效 范 围） 使 你 你 查 看 隐 形 生 物（ %d 侦 测 隐 形 等 级） 持 续 %d 回 合。 
		 你 的 精 神 更 加 敏 锐 ， 能 感 知 到 周 围 的 %s  ， 持 续 %d 回 合。 ]]):
		format(data.range, data.power + data.inc_stat, data.dur, kind, data.dur)

	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local kind=data.esp or " 人 形 "
                kind=kind:gsub("demon"," 恶 魔 "):gsub("animal"," 动 物 "):gsub("undead"," 不 死 "):gsub("dragon"," 龙 "):gsub("horror"," 恐 魔 "):gsub("humanoid","人 形 怪")
		return ([[范 围 %d; 持 续 %d; 感知 %s]]):format(data.range, data.dur, kind)
	end,
}

local function attack_rune(self, btid)
	for tid, lev in pairs(self.talents) do
		if tid ~= btid and self.talents_def[tid].is_attack_rune and not self.talents_cd[tid] then
			self.talents_cd[tid] = 1
		end
	end
end

newInscription{
	name = "Rune: Heat Beam",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_attack_rune = true,
	no_energy = true,
	is_spell = true,
	tactical = { ATTACK = { FIRE = 1 }, CURE = function(self, t, target)
			local nb = 0
			local data = self:getInscriptionData(t.short_name)
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type == "physical" and e.status == "detrimental" then nb = nb + 1 end
			end
			return nb
		end },
	requires_target = true,
	direct_hit = true,
	range = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.range
	end,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.FIREBURN, {dur=5, initial=0, dam=data.power + data.inc_stat})
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, tg.radius, "flamebeam", {tx=x-self.x, ty=y-self.y})
		self:removeEffectsFilter({status="detrimental", type="physical", ignore_crosstier=true}, 1)
		game:playSoundNear(self, "talents/fire")
		attack_rune(self, t.id)
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 发 射 一 束 射 线， 造 成 %0.2f 火 焰 伤 害 持 续 5 回 合。 
		 高 温 同 时 会 解 除 你 受 到 的 一 个 负 面 物 理 状 态。 ]]):format(damDesc(self, DamageType.FIRE, data.power + data.inc_stat))
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d 火 焰 伤 害 ]]):format(damDesc(self, DamageType.FIRE, data.power + data.inc_stat))
	end,
}

newInscription{
	name = "Rune: Biting Gale",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_attack_rune = true,
	no_energy = true,
	is_spell = true,
	tactical = { ATTACK = { COLD = 1 }, DISABLE = { stun = 1 }, CURE = function(self, t, target)
			local nb = 0
			local data = self:getInscriptionData(t.short_name)
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type == "mental" and e.status == "detrimental" then nb = nb + 1 end
			end
			return nb
		end },
	requires_target = true,
	range = 0,
	target = function(self, t)
		return {type="cone", cone_angle=25, radius = 6, range=self:getTalentRange(t), talent=t, display={particle="bolt_ice", trail="icetrail"}}
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local damage = data.power + data.inc_stat -- Cut by ~2/3rds or so
		local apply = self:rescaleCombatStats((data.apply + data.inc_stat))

	--	local apply = data.apply + data.inc_stat -- Same calculation as Sun Infusion, goes above what PCs can get on power stats pretty easily
		self:project(tg, x, y, function(tx, ty)
			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end
			
			-- Minor damage, apply stun resist reduction, freeze
			DamageType:get(DamageType.COLD).projector(target, tx, ty, DamageType.COLD, damage)
			target:setEffect(target.EFF_WET, 5, {apply_power=data.inc_stat})

			if target:canBe("stun") then
				target:setEffect(target.EFF_FROZEN, 2, {hp=damage*1.5, apply_power=apply})
			end

		end, data.power + data.inc_stat, {type="freeze"})
		self:removeEffectsFilter({status="detrimental", type="mental", ignore_crosstier=true}, 1)
		game:playSoundNear(self, "talents/ice")
		attack_rune(self, t.id)
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local apply = self:rescaleCombatStats((data.apply + data.inc_stat))
		return ([[激 活 这 个 符 文 ， 形 成 一 股 锥 形 寒 风 ， 造 成 %0.2f 寒 冷 伤 害。
			寒 风 会 减 半 敌 人 的  震 慑 抗 性  ， 并 试 图 冻 结 他 们 3 回合 ，强 度 %d。
			寒 冷 同 时 净 化 了 你 的 精 神， 解 除 一  项 随 机 负 面 精 神 效 果。 ]]):
			format(damDesc(self, DamageType.COLD, data.power + data.inc_stat), apply)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local apply = self:rescaleCombatStats((data.apply + data.inc_stat))
		return ([[%d 寒冷伤害; %d 强度]]):format(damDesc(self, DamageType.COLD, data.power + data.inc_stat), apply)
	end,
}

newInscription{
	name = "Rune: Acid Wave",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_attack_rune = true,
	no_energy = true,
	is_spell = true,
	tactical = {
		ATTACKAREA = { ACID = 1 },
		CURE = function(self, t, target)
			local nb = 0
			local data = self:getInscriptionData(t.short_name)
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type == "magical" and e.status == "detrimental" then nb = nb + 1 end
			end
			return nb
		end
	},
	requires_target = true,
	direct_hit = true,
	range = 0,
	radius = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.radius
	end,
	target = function(self, t)
		return {type="cone", radius=self:getTalentRadius(t), range = 0, selffire=false, cone_angle=5, talent=t}
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local apply = self:rescaleCombatStats((data.apply + data.inc_stat))

		self:removeEffectsFilter({status="detrimental", type="magical", ignore_crosstier=true}, 1)
		self:project(tg, x, y, function(tx, ty)

			local target = game.level.map(tx, ty, Map.ACTOR)
			if not target or target == self then return end

			if target:canBe("disarm") then
				target:setEffect(target.EFF_DISARMED, data.dur, {apply_power=apply})
			end

			DamageType:get(DamageType.ACID).projector(self, tx, ty, DamageType.ACID, data.power + data.inc_stat)

		end)

		game.level.map:particleEmitter(self.x, self.y, tg.radius, "breath_acid", {radius=tg.radius, tx=x-self.x, ty=y-self.y})
		game:playSoundNear(self, "talents/slime")
		attack_rune(self, t.id)
		return true
	end,
	info = function(self, t)
		  local data = self:getInscriptionData(t.short_name)
		  local pow = data.apply + data.inc_stat
		  local apply = self:rescaleCombatStats((data.apply + data.inc_stat))
		  
		  return ([[发 射 锥 形 酸 性 冲 击 波 造 成 %d 码 %0.2f 酸 性 伤 害。
		 酸 性 冲 击 波 会 腐 蚀 目 标， 缴 械 %d 回 合 ，强 度 %d。
		 酸 性 能 量 同 时 会 除 去 你 的 一 项 负 面 魔 法 效 果。]]):
			 format(self:getTalentRadius(t), damDesc(self, DamageType.ACID, data.power + data.inc_stat), data.dur or 3, apply)
	   end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local pow = data.power
		local apply = self:rescaleCombatStats((data.apply + data.inc_stat))

		return ([[%d 酸 性 伤 害; 持 续 %d; 强 度 %d]]):format(damDesc(self, DamageType.ACID, data.power + data.inc_stat), data.dur or 3, apply)
	end,
}

newInscription{
	name = "Rune: Lightning",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_attack_rune = true,
	no_energy = true,
	is_spell = true,
	tactical = { ATTACK = { LIGHTNING = 1 } },
	requires_target = true,
	direct_hit = true,
	range = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.range
	end,
	target = function(self, t)
		return {type="beam", range=self:getTalentRange(t), talent=t}
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = data.power + data.inc_stat
		self:project(tg, x, y, DamageType.LIGHTNING, rng.avg(dam / 3, dam, 3))
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(self.x, self.y, math.max(math.abs(x-self.x), math.abs(y-self.y)), "lightning", {tx=x-self.x, ty=y-self.y})
		self:setEffect(self.EFF_ELEMENTAL_SURGE_LIGHTNING, 2, {})
		game:playSoundNear(self, "talents/lightning")
		attack_rune(self, t.id)
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local dam = damDesc(self, DamageType.LIGHTNING, data.power + data.inc_stat)
		return ([[激 活 这 个 符 文 发 射 一 束 闪 电 打 击 目 标， 造 成 %0.2f 至 %0.2f 闪 电 伤 害。 
		 同 时 会 让 你 进 入 闪 电 形 态 %d 回 合： 受 到 伤 害 时 你 会 瞬 移 到 附 近 的 一  格 并 防 止 此 伤 害 ， 一 回 合 只 能 触 发 一 次。 ]]):
		format(dam / 3, dam, 2)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d 闪 电 伤 害 ]]):format(damDesc(self, DamageType.LIGHTNING, data.power + data.inc_stat))
	end,
}

newInscription{
	name = "Rune: Manasurge",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	tactical = { MANA = 1 },
	on_pre_use = function(self, t)
		return self:knowTalent(self.T_MANA_POOL) and not self:hasEffect(self.EFF_MANASURGE)
	end,
	on_learn = function(self, t)
		self.mana_regen_on_rest = (self.mana_regen_on_rest or 0) + 0.5
	end,
	on_unlearn = function(self, t)
		self.mana_regen_on_rest = (self.mana_regen_on_rest or 0) - 0.5
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		self:incMana((data.mana + data.inc_stat) / 20)
		if self.mana_regen > 0 then
			self:setEffect(self.EFF_MANASURGE, data.dur, {power=self.mana_regen * (data.mana + data.inc_stat) / 100})
		else
			if self.mana_regen < 0 then
				game.logPlayer(self, "Your negative mana regeneration rate is unaffected by the rune.")
			else
				game.logPlayer(self, "Your nonexistant mana regeneration rate is unaffected by the rune.")
			end
		end
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 对 你 自 己 释 放 法 力 回 复， 增 加 %d%% 回 复 量 持 续 %d 回 合， 并 立 即 回 复 %d 法 力 值。 
			同 时 ， 在 你 休 息 时 增 加 每 回 合 0.5 的 魔 力 回 复。 ]]):format(data.mana + data.inc_stat, data.dur, (data.mana + data.inc_stat) / 20)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d%% 回 复 持 续 %d 回 合 ; %d 法 力 瞬 回 ]]):format(data.mana + data.inc_stat, data.dur, (data.mana + data.inc_stat) / 20)
	end,
}

newInscription{
	name = "Rune: Frozen Spear",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_attack_rune = true,
	no_energy = true,
	is_spell = true,
	tactical = { ATTACK = { COLD = 1 }, DISABLE = { stun = 1 }, CURE = function(self, t, target)
			local nb = 0
			local data = self:getInscriptionData(t.short_name)
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type == "mental" and e.status == "detrimental" then nb = nb + 1 end
			end
			return nb
		end },
	requires_target = true,
	range = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return data.range
	end,
	target = function(self, t)
		return {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_ice", trail="icetrail"}}
	end,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, DamageType.ICE, data.power + data.inc_stat, {type="freeze"})
		self:removeEffectsFilter({status="detrimental", type="mental", ignore_crosstier=true}, 1)
		game:playSoundNear(self, "talents/ice")
		attack_rune(self, t.id)
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 发 射 一 束 冰 枪， 造 成 %0.2f 冰 冻 伤 害 并 有 一 定 几 率 冻 结 你 的 目 标。 
               	 寒 冰 同 时 会 解 除 你 受 到 的 一 个 负 面 精 神 状 态。 ]]):format(damDesc(self, DamageType.COLD, data.power + data.inc_stat))
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d 寒 冰 伤 害 ]]):format(damDesc(self, DamageType.COLD, data.power + data.inc_stat))
	end,
}


-- This is mostly a copy of Time Skip :P
newInscription{
	name = "Rune of the Rift",
	type = {"inscriptions/runes", 1},
	points = 1,
	is_spell = true,
	tactical = { DISABLE = 2, ATTACK = { TEMPORAL = 1 } },
	direct_hit = true,
	reflectable = true,
	requires_target = true,
	range = 4,
	target = function(self, t)
		return {type="hit", range=self:getTalentRange(t), talent=t}
	end,
	getDamage = function(self, t) return 150 + self:getWil() * 4 end,
	getDuration = function(self, t) return 4 end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local _ _, x, y = self:canProject(tg, x, y)
		local target = game.level.map(x, y, Map.ACTOR)
		if not target then return end

		if target:attr("timetravel_immune") then
			game.logSeen(target, "%s is immune!", target.name:capitalize())
			return
		end

		local hit = self:checkHit(self:combatSpellpower(), target:combatSpellResist() + (target:attr("continuum_destabilization") or 0))
		if not hit then game.logSeen(target, "%s resists!", target.name:capitalize()) return true end

		self:project(tg, x, y, DamageType.TEMPORAL, self:spellCrit(t.getDamage(self, t)))
		game.level.map:particleEmitter(x, y, 1, "temporal_thrust")
		game:playSoundNear(self, "talents/arcane")
		self:incParadox(-60)
		if target.dead or target.player then return true end
		target:setEffect(target.EFF_CONTINUUM_DESTABILIZATION, 100, {power=self:combatSpellpower(0.3)})
		
		-- Replace the target with a temporal instability for a few turns
		local oe = game.level.map(target.x, target.y, engine.Map.TERRAIN)
		if not oe or oe:attr("temporary") then return true end
		local e = mod.class.Object.new{
			old_feat = oe, type = oe.type, subtype = oe.subtype,
			name = "temporal instability", image = oe.image, add_mos = {{image="object/temporal_instability.png"}},
			display = '&', color=colors.LIGHT_BLUE,
			temporary = t.getDuration(self, t),
			canAct = false,
			target = target,
			act = function(self)
				self:useEnergy()
				self.temporary = self.temporary - 1
				-- return the rifted actor
				if self.temporary <= 0 then
					game.level.map(self.target.x, self.target.y, engine.Map.TERRAIN, self.old_feat)
					game.level:removeEntity(self, true)
					game.nicer_tiles:updateAround(game.level, self.target.x, self.target.y)
					local mx, my = util.findFreeGrid(self.target.x, self.target.y, 20, true, {[engine.Map.ACTOR]=true})
					local old_levelup = self.target.forceLevelup
					self.target.forceLevelup = function() end
					game.zone:addEntity(game.level, self.target, "actor", mx, my)
					self.target.forceLevelup = old_levelup
				end
			end,
			summoner_gain_exp = true, summoner = self,
		}
		
		game.logSeen(target, "%s has moved forward in time!", target.name:capitalize())
		game.level:removeEntity(target, true)
		game.level:addEntity(e)
		game.level.map(x, y, Map.TERRAIN, e)
		game.nicer_tiles:updateAround(game.level, x, y)
		game.level.map:updateMap(x, y)
		return true
	end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[造 成 %0.2f 时 空 伤 害。 如 果 你 的 目 标 存 活， 则 它 会 被 传 送 %d 回 合 至 未 来。 
		 它 也 能 降 低 你 60 紊 乱 值 ( 如 果 你 拥 有 该 能 量 )。 
		 注 意， 若 与 其 他 时 空 效 果 相 混 合 则 可 能 产 生 无 法 预 料 的 后 果。 ]]):format(damDesc(self, DamageType.TEMPORAL, damage), duration)
	end,
	short_info = function(self, t)
		return ("%0.2f 时 空 伤 害， 从 时 间 中 移 除 %d 回 合 "):format(t.getDamage(self, t), t.getDuration(self, t))
	end,
}

-----------------------------------------------------------------------
-- Taints
-----------------------------------------------------------------------
newInscription{
	name = "Taint: Devourer",
	type = {"inscriptions/taints", 1},
	points = 1,
	is_spell = true,
	tactical = { ATTACK = 1, HEAL=1 },
	requires_target = true,
	direct_hit = true,
	no_energy = true,
	range = 5,
	action = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end

			local effs = {}

			-- Go through all spell effects
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.type == "magical" or e.type == "physical" then
					effs[#effs+1] = {"effect", eff_id}
				end
			end

			-- Go through all sustained spells
			for tid, act in pairs(target.sustain_talents) do
				if act then
					effs[#effs+1] = {"talent", tid}
				end
			end

			local nb = data.effects
			for i = 1, nb do
				if #effs == 0 then break end
				local eff = rng.tableRemove(effs)

				if eff[1] == "effect" then
					target:removeEffect(eff[2])
				else
					target:forceUseTalent(eff[2], {ignore_energy=true})
				end
				self:attr("allow_on_heal", 1)
				self:heal(data.heal + data.inc_stat, t)
				self:attr("allow_on_heal", -1)
				if core.shader.active(4) then
					self:addParticles(Particles.new("shader_shield_temp", 1, {size_factor=1.5, y=-0.3, img="healdark", life=25}, {type="healing", time_factor=6000, beamsCount=15, noup=2.0, beamColor1={0xcb/255, 0xcb/255, 0xcb/255, 1}, beamColor2={0x35/255, 0x35/255, 0x35/255, 1}}))
					self:addParticles(Particles.new("shader_shield_temp", 1, {size_factor=1.5, y=-0.3, img="healdark", life=25}, {type="healing", time_factor=6000, beamsCount=15, noup=1.0, beamColor1={0xcb/255, 0xcb/255, 0xcb/255, 1}, beamColor2={0x35/255, 0x35/255, 0x35/255, 1}}))
				end
			end

			game.level.map:particleEmitter(px, py, 1, "shadow_zone")
		end)
		game:playSoundNear(self, "talents/fire")
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[对 目 标 激 活 此 印 记， 移 除 其 %d 个 效 果 并 将 其 转 化 为 治 疗 你 每 个 效 果 %d 生 命 值。 ]]):format(data.effects, data.heal + data.inc_stat)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[%d 效 果 / %d 治 疗 ]]):format(data.effects, data.heal + data.inc_stat)
	end,
}


newInscription{
	name = "Taint: Telepathy",
	type = {"inscriptions/taints", 1},
	points = 1,
	is_spell = true,
	range = 10,
	action = function(self, t)
		local rad = self:getTalentRange(t)
		self:setEffect(self.EFF_SENSE, 5, {
			range = rad,
			actor = 1,
		})
		self:setEffect(self.EFF_WEAKENED_MIND, 10, {save=10, power=35})
		return true
	end,
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[解 除 你 的 精 神 束 缚 %d 回 合， 感 应 %d 码 范 围 内 的 所 有 生 物 ， 减 少 %d 精 神 豁 免 持 续 10 回 合 并 增 加 %d 点 精 神 强 度。 ]]):format(data.dur, self:getTalentRange(t), 10, 35)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[范 围 %d 码 心 灵 感 应 持 续 %d 回 合 ]]):format(self:getTalentRange(t), data.dur)
	end,
}

