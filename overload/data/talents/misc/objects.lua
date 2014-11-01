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

newTalentType{ no_silence=true, is_spell=true, type="sher'tul/fortress", name = "fortress", description = "Yiilkgur abilities." }
newTalentType{ no_silence=true, is_spell=true, type="spell/objects", name = "object spells", description = "Spell abilities of the various objects of the world." }
newTalentType{ type="technique/objects", name = "object techniques", description = "Techniques of the various objects of the world." }
newTalentType{ type="wild-gift/objects", name = "object techniques", description = "Wild gifts of the various objects of the world." }
newTalentType{ type="misc/objects", name = "object techniques", description = "Powers of the various objects of the world." }

--local oldTalent = newTalent
--local newTalent = function(t) if type(t.hide) == "nil" then t.hide = true end return oldTalent(t) end

newTalent{
	name = "charms", short_name = "GLOBAL_CD",
	type = {"spell/objects",1},
	points = 1,
	cooldown = 1,
	no_npc_use = true,
	hide = true,
	action = function(self, t)
		return true
	end,
	info = function(self, t)
		return ""
	end,
}


newTalent{
	name = "Arcane Supremacy",
	type = {"spell/objects",1},
	points = 1,
	mana = 40,
	cooldown = 12,
	tactical = {
		BUFF = function(self, t, target)
			local nb = 0
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type == "magical" and e.status == "detrimental" then
					nb = nb + 1
				end
			end
			return nb
		end,
		CURE = function(self, t, target)
			local nb = 0
			for eff_id, p in pairs(self.tmp) do
				local e = self.tempeffect_def[eff_id]
				if e.type == "magical" and e.status == "detrimental" then
					nb = nb + 1
				end
			end
			return nb
		end
	},
	getRemoveCount = function(self, t) return math.floor(self:getTalentLevel(t)) end,
	action = function(self, t)
		local effs = {}
		local power = 5

		-- Go through all spell effects
		for eff_id, p in pairs(self.tmp) do
			local e = self.tempeffect_def[eff_id]
			if e.type == "magical" and e.status == "detrimental" then
				effs[#effs+1] = {"effect", eff_id}
			end
		end

		for i = 1, t.getRemoveCount(self, t) do
			if #effs == 0 then break end
			local eff = rng.tableRemove(effs)

			if eff[1] == "effect" then
				self:removeEffect(eff[2])
				power = power + 5
			end
		end

		self:setEffect(self.EFF_ARCANE_SUPREMACY, 10, {power=power})

		game:playSoundNear(self, "talents/spell_generic")
		return true
	end,
	info = function(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[移 除 %d 个 负 面 魔 法 效 果， 并 且 使 你 进 入 奥 术 强 化 状 态 10 回 合， 增 加 5 点 法 术 强 度 和 法 术 豁 免， 每 移 除 一 个 DEBUFF， 额 外 增 加 5 点 法 术 强 度 和 法 术 豁 免。]]):
		format(count)
	end,
}

newTalent{
	name = "Command Staff",
	type = {"spell/objects", 1},
	cooldown = 5,
	points = 5,
	no_npc_use = true,
	no_unlearn_last = true,
	action = function(self, t)
		local staff = self:hasStaffWeapon()
		if not staff or not staff.wielder or not staff.wielder.learn_talent or not staff.wielder.learn_talent[self.T_COMMAND_STAFF] then
			game.logPlayer(self, "You must be holding a staff.")
			return
		end
		-- Terrible sanity check to make sure staff.element is defined
		if not staff.combat.element then
			staff.combat.element = staff.combat.damtype or engine.DamageType.PHYSICAL
		end

		local state = {}
		local Chat = require("engine.Chat")
		local chat = Chat.new("command-staff", {name="Command Staff"}, self, {version=staff, state=state, co=coroutine.running()})
		local d = chat:invoke()
		if not coroutine.yield() then return nil end
		return true
	end,
	info = function(self, t)
		return ([[改 变 法 杖 中 流 动 的 能 量 性 质。]])
	end,
}

newTalent{
	name = "Ward",
	type = {"misc/objects", 1},
	cooldown = function(self, t)
		return math.max(10, 28 - 3 * self:getTalentLevel(t))
	end,
	points = 5,
	hard_cap = 5,
	no_npc_use = true,
	action = function(self, t)
		local state = {}
		local Chat = require("engine.Chat")
		local chat = Chat.new("ward", {name="Ward"}, self, {version=self, state=state})
		local d = chat:invoke()
		local co = coroutine.running()
		--print("before d.unload, state.set_ward is ", state.set_ward)
		d.unload = function() coroutine.resume(co, state.set_ward) end
		--print("state.set_ward is ", state.set_ward)
		if not coroutine.yield() then return nil end
		return true
	end,
	info = function(self, t)
		local xs = ""
		for w, nb in pairs(self.wards) do
			local kind=engine.DamageType.dam_def[w].name:capitalize();
			kind=kind:gsub("fire"," 火 焰 "):gsub("lightning"," 闪 电 "):gsub("arcane"," 奥 术 "):gsub("cold"," 寒 冷 ")
			         :gsub("blight"," 枯 萎 "):gsub("darkness"," 暗 影 "):gsub("physical"," 物 理 "):gsub("temporal"," 时 空 ")
				 :gsub("light"," 光 系 "):gsub("acid"," 酸 性 "):gsub("mental"," 精 神 "):gsub("nature"," 自 然 ")
			xs = xs .. (xs ~= "" and ", " or "") .. engine.DamageType.dam_def[w].name:capitalize() .. "(" .. tostring(nb) .. ")"
		end
		return ([[激 活 指 定 伤 害 类 型 的 抵 抗 状 态， 能 够 完 全 抵 抗 对 应 属 性 的 伤 害。 抵 抗 次 数 由 魔 杖 决 定。
		你 能 激 活 的 伤 害 类 型 有 ：%s]]):format(xs)
	end,
}

newTalent{
	name = "Teleport to the ground", short_name = "YIILKGUR_BEAM_DOWN",
	type = {"sher'tul/fortress", 1},
	points = 1,
	no_npc_use = true,
	action = function(self, t)
		return true
	end,
	info = function(self, t)
		return ([[使 用 伊 克 格 的 传 送 阵 传 送 回 地 面。]])
	end,
}

newTalent{
	name = "Block",
	type = {"technique/objects", 1},
	cooldown = function(self, t)
		return 8 - util.bound(self:getTalentLevelRaw(t), 1, 5)
	end,
	points = 5,
	hard_cap = 5,
	range = 1,
	requires_target = true,
	tactical = { ATTACK = 3, DEFEND = 3 },
	on_pre_use = function(self, t, silent) if not self:hasShield() then if not silent then game.logPlayer(self, "You require a shield to use this talent.") end return false end return true end,
	getProperties = function(self, t)
		local shield = self:hasShield()
		--if not shield then return nil end
		local p = {
			sp = (shield and shield.special_combat and shield.special_combat.spellplated or false),
			ref = (shield and shield.special_combat and shield.special_combat.reflective or false),
			br = (shield and shield.special_combat and shield.special_combat.bloodruned or false),
		}
		return p
	end,
	getBlockValue = function(self, t)
		local val = 0
		local shield1 = self:hasShield()
		if shield1 then val = val + (shield1.special_combat and shield1.special_combat.block or 0) end

		if not self:getInven("MAINHAND") then return val end
		local shield2 = self:getInven("MAINHAND")[1]
		if shield2 then val = val + (shield2.special_combat and shield2.special_combat.block or 0) end
		return val
	end,
	getBlockedTypes = function(self, t)
		local shield = self:hasShield()
		local bt = {[DamageType.PHYSICAL]=true}
		if not shield then return bt, "error!" end
		local shield2 = self:getInven("MAINHAND") and self:getInven("MAINHAND")[1]
		shield2 = shield2 and shield2.special_combat and shield2 or nil

		if not self:attr("spectral_shield") then
			if shield.wielder.resists then for res, v in pairs(shield.wielder.resists) do if v > 0 then bt[res] = true end end end
			if shield.wielder.on_melee_hit then for res, v in pairs(shield.wielder.on_melee_hit) do if v > 0 then bt[res] = true end end end
			if shield2 and shield2.wielder.resists then for res, v in pairs(shield2.wielder.resists) do if v > 0 then bt[res] = true end end end
			if shield2 and shield2.wielder.on_melee_hit then for res, v in pairs(shield2.wielder.on_melee_hit) do if v > 0 then bt[res] = true end end end
		else
			bt[DamageType.FIRE] = true
			bt[DamageType.LIGHTNING] = true
			bt[DamageType.COLD] = true
			bt[DamageType.ACID] = true
			bt[DamageType.NATURE] = true
			bt[DamageType.BLIGHT] = true
			bt[DamageType.LIGHT] = true
			bt[DamageType.DARKNESS] = true
			bt[DamageType.ARCANE] = true
			bt[DamageType.MIND] = true
			bt[DamageType.TEMPORAL] = true
		end

		local n = 0
		for t, _ in pairs(bt) do n = n + 1 end

		if n < 1 then return "(error 2)" end
		local e_string = ""
		if n == 1 then
			e_string = DamageType.dam_def[next(bt)].name
		else
			local list = table.keys(bt)
			for i = 1, #list do
				list[i] = DamageType.dam_def[list[i]].name
			end
			e_string = table.concat(list, ", ")
		end
		return bt, e_string
	end,
	action = function(self, t)
		local properties = t.getProperties(self, t)
		local bt, bt_string = t.getBlockedTypes(self, t)
		self:setEffect(self.EFF_BLOCKING, 1 + (self:knowTalent(self.T_ETERNAL_GUARD) and 1 or 0), {power = t.getBlockValue(self, t), d_types=bt, properties=properties})
		return true
	end,
	info = function(self, t)
		local properties = t.getProperties(self, t)
		local sp_text = ""
		local ref_text = ""
		local br_text = ""
		if properties.sp then
			sp_text = (" 那 回 合 增 加 %d 点 法 术 豁 免."):format(t.getBlockValue(self, t))
		end
		if properties.ref then
			ref_text = " 反 弹 所 有 格 挡 的 伤 害 ."
		end
		if properties.br then
			br_text = " 所 有 格 挡 的 伤 害 值 会 治 疗 玩 家 ."
		end
		local bt, bt_string = t.getBlockedTypes(self, t)
		return ([[举 起 你 的 盾 牌 进 入 防 御 姿 态 一 回 合， 减 少 所 有 	%s 类 攻 击 伤 害 %d 。 如 果 你 完 全 格 挡 了 一 次 攻 击， 攻 击 者 将 遭 到 一 次 致 命 的 反 击（ 一 次 普 通 攻 击 将 造 成 200%% 伤 害）， 持 续 1 回 合。 
	    %s%s%s]]):format(bt_string, t.getBlockValue(self, t), sp_text, ref_text, br_text)
	end,
}

newTalent{
	short_name = "BLOOM_HEAL", image = "talents/regeneration.png",
	name = "Bloom Heal",
	type = {"wild-gift/objects", 1},
	points = 1,
	no_energy = true,
	cooldown = function(self, t) return 50 end,
	tactical = { HEAL = 2 },
	on_pre_use = function(self, t) return not self:hasEffect(self.EFF_REGENERATION) end,
	action = function(self, t)
		self:setEffect(self.EFF_REGENERATION, 6, {power=7 + self:getWil() * 0.5})
		return true
	end,
	info = function(self, t)
		return ([[呼 唤 自 然 的 力 量 每 回 合 恢 复 你 %d 生 命 值 持 续 6 回 合。 
		 受 意 志 影 响， 恢 复 量 有 额 外 加 成。]]):format(7 + self:getWil() * 0.5)
	end,
}

newTalent{
	image = "talents/mana_clash.png",
	name = "Destroy Magic",
	type = {"wild-gift/objects", 1},
	points = 5,
	no_energy = true,
	tactical = { ATTACK = { ARCANE = 3 } },
	cooldown = function(self, t) return 50 end,
	tactical = { HEAL = 2 },
	target = function(self, t)
		return {type="hit", range=1, talent=t}
	end,
	getpower = function(self, t) return 8 end,
	maxpower = function(self, t) return self:combatTalentLimit(t, 100, 45, 70) end, -- Limit spell failure < 100%
	action = function(self, t)
	self:getTalentLevel(t)
		local tg = self:getTalentTarget(t)
		local x, y, target = self:getTarget(tg)
		if not x or not y then return nil end
		local dispower = t.getpower(self,t)
		local dismax = t.maxpower(self, t)
		self:project(tg, x, y, function(px, py)
			target:setEffect(target.EFF_SPELL_DISRUPTION, 8, {src=self, power = dispower, max = dismax, apply_power=self:combatMindpower()})
			if rng.percent(30) and self:getTalentLevel(t)>2 then

			local effs = {}

			-- Go through all spell effects
				for eff_id, p in pairs(target.tmp) do
					local e = target.tempeffect_def[eff_id]
					if e.type == "magical" then
						effs[#effs+1] = {"effect", eff_id}
					end
				end
			if self:getTalentLevel(t) > 3 then --only do sustains at level 3+
				-- Go through all sustained spells
				for tid, act in pairs(target.sustain_talents) do
					if act then
						local talent = target:getTalentFromId(tid)
						if talent.is_spell then effs[#effs+1] = {"talent", tid} end
					end
				end
			end
				local eff = rng.tableRemove(effs)
				if eff then
					if eff[1] == "effect" then
						target:removeEffect(eff[2])
					else
						target:forceUseTalent(eff[2], {ignore_energy=true})
					end
				end
			end
			if self:getTalentLevel(t)>=5 then
				if target.undead or target.construct then
					self:project({type="hit"}, target.x, target.y, engine.DamageType.ARCANE, 40+self:combatMindpower())
					if target:canBe("stun") then target:setEffect(target.EFF_STUNNED, 5, {apply_power=self:combatMindpower()}) end
					game.logSeen(self, "%s's animating magic is disrupted!", target.name:capitalize())
				end
			end
		end, nil, {type="slime"})
		return true
	end,
	info = function(self, t)
		return ([[ 目 标 有 %d%% 概 率（ 最 大 叠 加 至 %d%%） 施 法 失 败 率。 等 级 2 时 魔 法 效 果 可 能 会 被 打 断 。 等 级 3 时 持 续 性 法 术 可 能 会 被 打 断 。 等 级 5 时 魔 法 生 物 和 不 死 族 可 能 会 被 震 慑。 ]]):format(t.getpower(self, t),t.maxpower(self,t))
	end,
}

newTalent{
	name = "Battle Trance", image = "talents/clarity.png",
	type = {"wild-gift/objects",1},
	points = 1,
	mode = "sustained",
	cooldown = 15,
	no_energy = true,
	activate = function(self, t)
		local ret = {}
		self:talentTemporaryValue(ret, "resists", {all=15})
		self:talentTemporaryValue(ret, "combat_mindpower", -15)
		self:talentTemporaryValue(ret, "combat_mentalresist", 20)
		ret.trance_counter = 0
		return ret
	end,
	deactivate = function(self, t, p)
		return true
	end,
	callbackOnAct = function(self, t)
		local tt = self:isTalentActive(t.id)
		if not tt then return end
		tt.trance_counter = tt.trance_counter + 1
		if tt.trance_counter <= 5 then return end
		if rng.percent((tt.trance_counter - 5) * 2) then
			self:forceUseTalent(self.T_BATTLE_TRANCE, {ignore_energy=true})
			self:setEffect(self.EFF_CONFUSED, 4, {power=40})
			game.logPlayer(self, "You overdose on the honeyroot sap!")
		end
		
		return
	end,
	info = function(self, t)
		return ([[ 你 进 入 了 战 斗 狂 热 状 态， 获 得 15％ 全 体 伤 害 抗 性， 减 少 15 点 精 神 强 度 并 获 得 20 点 精 神 豁 免。 技 能 激 活 5 回 合 后 ， 每 回 合 你 都 有 一 定 几 率 疲 劳 ， 终 止 技 能 并 进 入 混 乱 状 态。 ]])
	end,
}

newTalent{
	name = "Soul Purge", image = "talents/stoic.png",
	type = {"misc/objects", 1},
	cooldown = 3,
	points = 1,
	hard_cap = 1,
	no_npc_use = true,
	action = function(self, t)
		local o = self:findInAllInventoriesBy("define_as", "MORRIGOR")
		o.use_talent=nil
        o.power_regen=nil
        o.max_power=nil
		return true
	end,
	info = function(self, t)
		return ([[除 去 Morrigor 吸 收 的 所 有 技 能。 ]])
	end,
}

newTalent{
	name = "Dig", short_name = "DIG_OBJECT",
	type = {"misc/objects", 1},
	findBest = function(self, t)
		local best = nil
		local find = function(inven)
			for item, o in ipairs(inven) do
				if o.digspeed and (not best or o.digspeed < best.digspeed) then best = o end
			end
		end
		for inven_id, inven in pairs(self.inven) do find(inven) end
		return best
	end,
	points = 1,
	hard_cap = 1,
	no_npc_use = true,
	action = function(self, t)
		local best = t.findBest(self, t)
		if not best then game.logPlayer(self, "You require a digger to dig.") return end

		local tg = {type="bolt", range=1, nolock=true}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end

		local wait = function()
			local co = coroutine.running()
			local ok = false
			self:restInit(best.digspeed, "digging", "dug", function(cnt, max)
				if cnt > max then ok = true end
				coroutine.resume(co)
			end)
			coroutine.yield()
			if not ok then
				game.logPlayer(self, "You have been interrupted!")
				return false
			end
			return true
		end
		if wait() then
			self:project(tg, x, y, engine.DamageType.DIG, 1)
		end

		return true
	end,
	info = function(self, t)
		local best = t.findBest(self, t) or {digspeed=100}
		return ([[ 挖 掘 消 耗 %d 回 合 ( 基 于 你 携 带 的 最 好 锄 头 )。 ]])
		:format(best.digspeed)
	end,
}

newTalent{
	name = "Shivgoroth Form", short_name = "SHIV_LORD", image = "talents/shivgoroth_form.png",
	type = {"spell/objects",1},
	points = 5,
	random_ego = "attack",
	cooldown = 20,
	tactical = { BUFF = 3, ATTACKAREA = { COLD = 0.5, PHYSICAL = 0.5 }, DISABLE = { knockback = 1 } },
	direct_hit = true,
	range = 10,
	no_energy = true,
	is_spell=true,
	requires_target = true,
	getDuration = function(self, t) return 4 + math.ceil(self:getTalentLevel(t)) end,
	getPower = function(self, t) return util.bound(50 + self:combatTalentSpellDamage(t, 50, 450), 0, 500) / 500 end,
	on_pre_use = function(self, t, silent) if self:attr("is_shivgoroth") then if not silent then game.logPlayer(self, "You are already a Shivgoroth!") end return false end return true end,
	action = function(self, t)
		self:setEffect(self.EFF_SHIVGOROTH_FORM_LORD, t.getDuration(self, t), {power=t.getPower(self, t), lvl=self:getTalentLevelRaw(t)})
		game:playSoundNear(self, "talents/tidalwave")
		return true
	end,
	info = function(self, t)
		local power = t.getPower(self, t)
		local dur = t.getDuration(self, t)
		return ([[你 吸 收 周 围 的 寒 冰 围 绕 你， 将 自 己 转 变 为 纯 粹 的 冰 元 素 — — 西 弗 格 罗 斯， 持 续 %d 回 合。 
		 转 化 成 元 素 后， 你 不 需 要 呼 吸 并 获 得 等 级 %d 的 冰 雪 风 暴， 获 得 %d%% 切 割 和 震 慑 抵 抗 ，%d%% 寒 冰 抗 性 ,所 有 冰 冷 伤 害 可 对 你 产 生 治 疗， 治 疗 量 基 于 伤 害 值 的 %d%% 。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(dur, self:getTalentLevelRaw(t), power * 100, power * 100 / 2, 50 + power * 100)
	end,
}

newTalent{
	name = "Mental Refresh",
	type = {"misc/objects", 1},
	points = 5,
	equilibrium = 20,
	cooldown = 50,
	range = 10,
	tactical = { BUFF = 2 },
	action = function(self, t)
		local nb = 3
		local tids = {}
		for tid, _ in pairs(self.talents_cd) do
			local tt = self:getTalentFromId(tid)
			if tt.type[1]:find("^wild%-gift/") or tt.type[1]:find("psionic/") or tt.type[1]:find("cursed/") then
				tids[#tids+1] = tid
			end
		end
		for i = 1, nb do
			if #tids == 0 then break end
			local tid = rng.tableRemove(tids)
			self.talents_cd[tid] = self.talents_cd[tid] - 3
		end
		self.changed = true
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[ 刷 新 至 多 3 个 自 然 ， 超 能 或 诅 咒 系 技 能 。 ]])
	end,
}

newTalent{
	name = "Dagger Block",
	image = "talents/block.png",
	type = {"technique/objects", 1},
	cooldown = function(self, t)
		return 8 - util.bound(self:getTalentLevelRaw(t), 1, 5)
	end,
	points = 5,
	hard_cap = 5,
	range = 1,
	requires_target = true,
	tactical = { ATTACK = 3, DEFEND = 3 },
	
	getProperties = function(self, t)
		local p = {
			sp = false,
			ref = false,
			br = false,
			sb = true
		}
		return p
	end,
	getBlockedTypes = function(self, t)
	
		local bt = {[DamageType.PHYSICAL]=true}
			bt[DamageType.FIRE] = false
			bt[DamageType.LIGHTNING] = false
			bt[DamageType.COLD] = false
			bt[DamageType.ACID] = false
			bt[DamageType.NATURE] = false
			bt[DamageType.BLIGHT] = false
			bt[DamageType.LIGHT] = false
			bt[DamageType.DARKNESS] = false
			bt[DamageType.ARCANE] = false
			bt[DamageType.MIND] = false
			bt[DamageType.TEMPORAL] = false
			
		local n = 0
		for t, _ in pairs(bt) do n = n + 1 end

		if n < 1 then return "(error 2)" end
		local e_string = ""
		if n == 1 then
			e_string = DamageType.dam_def[next(bt)].name
		else
			local list = table.keys(bt)
			for i = 1, #list do
				list[i] = DamageType.dam_def[list[i]].name
			end
			e_string = table.concat(list, ", ")
		end
		return bt, e_string
	end,
	getPower = function(self, t) return 120+self:getCun()+self:getDex() end,
	action = function(self, t)
		local properties = t.getProperties(self, t)
		local bt, bt_string = t.getBlockedTypes(self, t)
		self:setEffect(self.EFF_BLOCKING, 1 + (self:knowTalent(self.T_ETERNAL_GUARD) and 1 or 0), {power = t.getPower(self, t), d_types=bt, properties=properties})
		return true
	end,
	info = function(self, t)
		return ([[ 举 起 你 的 匕 首 来 格 挡 攻 击 一 回 合 ， 减 少 所 有 物 理 伤 害 %d 点 。 如 果 你 完 全 格 挡 了 一 次 攻 击 的 伤 害 ， 攻 击 者 将 进 入 致 命 的 被 反 击 状 态 （ 对 其 攻 击 伤 害 加 倍 ） 一 回 合 并 被 缴 械 三 回 合。
		格 挡 值 随 敏 捷 和 灵 巧 增 加 。]]):format(t.getPower(self, t))
	end,
}

newTalent{
	name = "Shieldsmaiden Aura",
	type = {"misc/objects", 1},
	points = 1,
	mode = "passive",
	cooldown = 10,
	callbackOnHit = function(self, t, cb)
		if not self:isTalentCoolingDown(t) then
			self:startTalentCooldown(t)
			cb.value=0
			game.logPlayer(self, "你的盾牌保护了你！")
			return true
		else
		return false
		end
	end,
	info = function(self, t)
		return ([[每 10 回 合 自 动 抵 挡 一 次 攻 击。]])
	end,
}
