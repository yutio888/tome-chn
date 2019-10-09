local _M = loadPrevious(...)

local trap_range = function(self, t)
	if not self:knowTalent(self.T_TRAP_LAUNCHER) then return 1 end
	return math.floor(self:combatTalentScale(self:getTalentLevel(self.T_TRAP_LAUNCHER), 2, 7, "log")) -- 2@1, 7@5
end

registerTalentTranslation{
	id = "T_TRAP_MASTERY",
	name = "陷阱专精",
	action = function(self, t)
		local nb = t.getNbTraps(self,t)
		local txt = ("准备哪个陷阱? (最多: %d , 最大材质等级 %d )%s"):format(nb, math.min(5, self:getTalentLevelRaw(t)), self.turn_procs.free_trap_mastery and "\n游戏开始: 新准备的陷阱不会进入冷却。" or "\n#YELLOW#新准备的陷阱会进入冷却。#LAST#")
		local traps_dialog = require("mod.dialogs.TrapsSelect").new("选择准备陷阱", self,
		txt, t, nb, trap_mastery_tids)
		local traps_sel, traps_prev = self:talentDialog(traps_dialog)

		local changed = false
		if traps_sel and traps_prev then
			for tid, _ in pairs(traps_prev) do
				if not traps_sel[tid] then
					game.log("#YELLOW_GREEN#分解 %s", self:getTalentFromId(tid).name)
					self:unlearnTalentFull(tid)
					changed = true
				end
			end
			for tid, sel in pairs(traps_sel) do
				if sel and not traps_prev[tid] then
					game.log("#LIGHT_GREEN#准备 %s%s", self:getTalentFromId(tid).name, self.trap_primed == tid and " (normal trigger)" or "")
					self:learnTalent(tid, true, 1, {no_unlearn=true})
					if self.trap_primed == tid then 
						self.trap_primed = nil
					end
					if not self.turn_procs.free_trap_mastery then self:startTalentCooldown(tid) end -- don't cooldown on birth
					changed = true
				end
			end
		end
		if not changed then game.logPlayer(self, "#LIGHT_BLUE#陷阱准备无变化") end
		
		self.turn_procs.free_trap_mastery = false
		self.trap_mastery_ai = {trap_level=math.min(5, self:getTalentLevelRaw(t)), selected=traps_sel or {}} -- for possible AI control later
		return changed
	end,
	info = function(self, t)
		self.turn_procs.trap_mastery_tid = t.id
		local _, stealth_chance = trap_stealth(self, t)
		local detect_power = t.getPower(self, t)
		local disarm_power = t.getPower(self, t)*1.25

		local trap_list = traps_getunlocked(self, t)
		local player = game:getPlayer(true)
		local show_traps = {}
		for i, tid in ipairs(trap_list) do
			local known = self:knowTalent(tid)
			-- display info only for traps prepared or known to the player
			if known or game.state:unlockTalentCheck(tid, player) then
				local tr = self:getTalentFromId(tid)
				show_traps[#show_traps+1] = {tier=tr.trap_mastery_level, name=tr.name,
				known = self.trap_primed ~= tid and known, 
				info = tr.short_info and tr.short_info(self, tr) or "#GREY#(见技能描述)#LAST#"}
			end
		end
		table.sort(show_traps, function(a, b) return a.tier < b.tier end)
		local trap_descs = ""
		for i, trap in ipairs(show_traps) do
			trap_descs = trap_descs.."\n\t"..("%s材质等级 %d : %s#LAST#\n%s"):format(trap.known and "#YELLOW#" or "#YELLOW_GREEN#", trap.tier, trap.name, trap.info)
		end
		self.turn_procs.trap_mastery_tid = nil
		return ([[该技能允许你准备 %d 个不同的陷阱，最高材质等  级为 %d 。（使用该技能选择需要准备  的陷阱。） 
		 已知陷阱：
%s

		 准备好的陷阱更难被发现、被解除（ %d 点侦测强度， %d 点解除强度，基于灵巧）。
		 你免疫自己的陷阱，陷阱可以暴击（使用物理暴击率）。
		 当陷阱消失时，如果效果未触发，回复 80%% 体力消耗。
		 你能在世界上学到许多其他陷阱。]]):
		format(t.getNbTraps(self, t), math.min(5, self:getTalentLevelRaw(t)), trap_descs, detect_power, disarm_power, t.getTrapMastery(self, t), stealth_chance, t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_LURE",
	name = "诱饵",
	info = function(self, t)
		local t2 = self:getTalentFromId(self.T_TAUNT)
		local rad = t2.radius(self, t)	
		return ([[抛出一个诱饵来吸引 %d 码半径内的敌人，持续 %d 回合  。
		 诱饵有 %d 生命 ( 基于灵巧)， %d 护甲和 %d%% 非物理伤害抗性。 
		 在等级 5 时，当诱饵被摧毁时，它会自动触发在它周围 2 码范围内的陷阱（可鉴定某些陷阱是否能被触发 )。 
		 此技能不会打断潜行状态。]]):format(rad, t.getDuration(self,t), t.getLife(self, t), t.getArmor(self, t), t.getResist(self, t))
	end,
}
registerTalentTranslation{
	id = "T_TRAP_LAUNCHER",
	name = "高级陷阱放置",
	short_name = "TRAP_LAUNCHER",
	info = function (self,t)
		return ([[你学会放置陷阱的新技巧。
		 选择一个陷阱，你能在 %d 格外放置，减少 %d%% 消耗时间，有 %d%% 几率不打破潜行。 ]]):format(trap_range(self, t), (1 - t.trapSpeed(self, t))*100, t.trapStealth(self, t))
	end,
}
registerTalentTranslation{
	id = "T_TRAP_PRIMING",
	name = "即爆陷阱",
	info = function (self,t)
		local m_level, trap_list = self:getTalentLevelRaw(t), traps_getunlocked(self, t)
		local mastery = t.getTrapMastery(self, t)
		local instant = "none"
		local show_traps = {}
		self.turn_procs.trap_mastery_tid = t.id
		local _, stealth_chance = trap_stealth(self, t)
		local player = game:getPlayer(true)
		for i, tid in pairs(trap_list) do
			local tr = self:getTalentFromId(tid)
			-- show only primable traps that are primed or that the player knows about
			if tr and tr.allow_primed_trigger and tr.trap_mastery_level and (self:knowTalent(tid) or game.state:unlockTalentCheck(tid, player)) then
				show_traps[#show_traps+1] = {tier=tr.trap_mastery_level, name=tr.name,
				info = tr.short_info and tr.short_info(self, tr) or "#GREY#(see trap description)#LAST#"}
				if tid == self.trap_primed then
					show_traps[#show_traps].instant = true
					instant = tr.name
				end
			end
		end
		self.turn_procs.trap_mastery_tid = nil
		table.sort(show_traps, function(a, b) return a.tier < b.tier end)
		local trap_descs = ""
		for i, trap in ipairs(show_traps) do
			trap_descs = trap_descs.."\n\t"..("%s材质等级 %d : %s#LAST#\n%s"):format(trap.instant and "#YELLOW#" or "#YELLOW_GREEN#", trap.tier, trap.name, trap.info)
		end
		return ([[你额外准备一个陷阱（最高材质等级 %d ），带有特殊的控制机关，能在设置后立刻生效。 (使用该技能来选择需要准备的陷阱。)
		 并非所有陷阱都能这样准备，每种陷阱只有一种改进方式。
		 已学会的引爆方式 :
%s 

带有特殊启动机关的陷阱强度增加  %+d%% (取代陷阱专精的加成 )  ，有 %d%% 几率不破坏潜行。
#YELLOW#当前选择的陷阱 : %s#LAST#]]):
		format(self:getTalentLevelRaw(t), trap_descs, mastery, stealth_chance, instant)
	end,
}
registerTalentTranslation{
	id = "T_SPRINGRAZOR_TRAP",
	name = "刀锋陷阱",
	info = function (self,t)
		local dam = t.getDamage(self, t)
		local power = t.getPower(self,t)
		local instant = self.trap_primed == t.id and "\n#YELLOW#设置完毕后立刻激活。#LAST#" or ""
		return ([[放置压力感应陷阱，触发后爆炸形成半径 2 格的刀片风暴 ,造成 %0.2f 物理伤害。被击中的目标的命中、护甲和闪避下降 %d 。
		该陷阱可以被设置为直接激活，也可以被诱饵激活。%s]]):
		format(damDesc(self, DamageType.PHYSICAL, dam), power, instant)
	end,
	short_info = function(self, t)
		return ([[刀片（范围2）  %d 物理伤害, 减少命中、护甲和闪避  %d 。]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), t.getPower(self,t))
	end,
}
registerTalentTranslation{
	id = "T_BEAR_TRAP",
	name = "捕熊陷阱",
	info = function (self,t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		local instant = self.trap_primed == t.id and "\n#YELLOW#设置完毕后立刻激活。#LAST#" or ""
		return ([[放置一个压力感应的捕熊陷阱，会捕获第一个经过的生物，造成 %0.2f 物理伤害，定身并减速 30%% ，持续 5 回合，并在期间受到 %0.2f 流血伤害。 %s]]):format(dam, dam, instant)
	end,
	short_info = function(self, t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		return ([[%d 物理伤害，定身、30%%减速, 5回合额外 %d 流血伤害。]]):format(dam, dam)
	end,
}
registerTalentTranslation{
	id = "T_DISARMING_TRAP",
	name = "缴械陷阱",
	info = function(self, t)
		return ([[放置一个缴械陷阱。经过的目标受到 %0.2f 点酸性伤害，并被缴械 %d 回合。 ]]):
		format(damDesc(self, DamageType.ACID, t.getDamage(self, t)), t.getDuration(self, t))
	end,
	short_info = function(self, t)
		return ([[%d 酸性伤害, 缴械 %d 回合.]]):
		format(damDesc(self, DamageType.ACID, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}
registerTalentTranslation{
	id = "T_PITFALL_TRAP",
	name = "落穴陷阱",
	info = function (self,t)
		return ([[放置一个压力感应陷阱，目标经过时地面将坍塌，造成  %0.2f  物理伤害并将其埋在地下（暂时移出游戏） 5  回合。
如果目标抵抗被埋，那么他将被定身（无视 50%%定身免疫）。]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
	short_info = function(self, t)
		return ([[%d 物理伤害。目标被移除游戏或者定身 5回合。]]):format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,
}
registerTalentTranslation{
	id = "T_FLASH_BANG_TRAP",
	name = "闪光陷阱",
	info = function(self, t)
		local instant = self.trap_primed == t.id and "\n#YELLOW#设置完毕后立刻激活。#LAST#" or ""
		return ([[放置一个闪光陷阱。产生一个 2 码范围的爆炸，造成 %0.2f 物理伤害，致盲或眩晕目标 %d 回合（各 50%% 几率）。
		 该陷阱可以被设置为直接激活，也可以被诱饵激活。%s]]):
		format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), t.getDuration(self, t), instant)
	end,
	short_info = function(self, t)
		return ([[ 爆炸(半径2) 造成 %d 物理伤害, 50%% 致盲/眩晕 %d 回合。]]):format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}
registerTalentTranslation{
	id = "T_BLADESTORM_TRAP",
	name = "剑刃风暴陷阱",
	info = function (self,t)
		return ([[放置一个陷阱，激活后产生致命的剑刃风暴，持续  %d 回合。这个临时的结构体非常坚韧，获得你的伤害加成，每回合自动攻击相邻敌人。]]):format(t.getDuration(self,t))
	end,
		short_info = function(self, t)
		return ([[每回合攻击周围生物，持续 %d 回合。]]):format(t.getDuration(self, t))
	end,
}
registerTalentTranslation{
	id = "T_BEAM_TRAP",
	name = "射线陷阱",
	info = function (self,t)
		local dam = t.getDamage(self, t)
		local dur = t.getDuration(self,t)
		return ([[放置魔法陷阱，每回合朝 5 格内的随机敌人射出奥术射线，持续  %d  回合 ,  造成  %0.2f  奥术伤害。
该陷阱需要 20 魔法才能准备，消失时不返还体力。
#YELLOW#放置后立刻激活。#LAST#]]):format(dur, damDesc(self, DamageType.ARCANE, dam))
	end,
	short_info = function(self, t)
		return ([[每回合发射 (射程5 )的射线，造成 %d 奥术伤害. 持续 %d 回合。]]):
		format(damDesc(self, DamageType.ARCANE, t.getDamage(self, t)), t.getDuration(self, t))
	end,
}
registerTalentTranslation{
	id = "T_POISON_GAS_TRAP",
	name = "毒气陷阱",
	info = function(self, t)
		local instant = self.trap_primed == t.id and "\n#YELLOW#设置完毕后立刻激活。#LAST#" or ""
		return ([[ 放置一个毒气陷阱，在 3 码范围内产生毒云爆炸，持续 4 回合。 
		 每回合毒云对目标造成 %0.2f 自然伤害，持续 5 回合。有 25%% 几率毒素会被强化为致残、麻木或者阴险毒素。 
		 该陷阱可以被设置为直接激活，也可以被诱饵激活。%s]]):
		format(damDesc(self, DamageType.POISON, t.getDamage(self, t)), instant)
	end,
	short_info = function(self, t)
		return ([[释放范围 3的毒气,5回合内 %d 自然伤害， 25%% 几率强化毒素效果。]]):format(damDesc(self, DamageType.POISON, t.getDamage(self, t)))
	end,
}
registerTalentTranslation{
	id = "T_FREEZING_TRAP",
	name = "冰冻陷阱",
	info = function (self,t)
		local dam = damDesc(self, DamageType.COLD, t.getDamage(self, t))
		local instant = self.trap_primed == t.id and "\n#YELLOW#设置完毕后立刻激活。#LAST#" or ""
		return ([[放置一个陷阱，激活后产生半径 2 的冰冻气体，造成 %0.2f  寒冷伤害并定身  3  回合。
		 冰冻气体持续 5 回合，每回合造成  %0.2f  伤害，有 25%% 几率冻结。
		 该陷阱可以被设置为直接激活，也可以被诱饵激活。%s]]):
		format(dam, dam/3, instant)
	end,
	short_info = function(self, t)
		local dam = damDesc(self, DamageType.COLD, t.getDamage(self, t))
		return ([[爆炸 (范围 2):  %d 寒冷伤害并定身 3 回合。范围冻结 ( %d 寒冷伤害， 25%% 冻结几率) 5回合。]]):format(dam, dam/3)
	end,
}
registerTalentTranslation{
	id = "T_DRAGONSFIRE_TRAP",
	name = "龙火陷阱",
	info = function (self,t)
		local instant = self.trap_primed == t.id and "\n#YELLOW#设置完毕后立刻激活。#LAST#" or ""
		dam = damDesc(self, DamageType.FIRE, t.getDamage(self, t))
		return ([[放置一个压力感应陷阱，激活后产生半径 2 的火云 ,震慑敌人  (每回合 %0.2f 火焰伤害  ) 3 回合。
		 火焰持续 5 回合，每回合燃烧造成  %0.2f  火焰伤害。
	 	 该陷阱可以被设置为直接激活，也可以被诱饵激活。%s]]):
		format(dam/3, dam/2, instant)
	end,
	short_info = function(self, t)
		dam = damDesc(self, DamageType.FIRE, t.getDamage(self, t))
		return ([[爆炸 (范围 2): 震慑并在3回合内每回合造成 %d 火焰伤害。范围火焰 ( %d 火焰伤害) 持续5 回合。]]):format(dam/3, dam/2)
	end,
}

registerTalentTranslation{
	id = "T_GRAVITIC_TRAP",
	name = "引力陷阱",
	message = "@Source@ 放置了一个扭曲的设施。",
	info = function(self, t)
		return ([[ 放置一个引力陷阱，周围一格有敌人经过时触发，将附近 5 码范围内的敌人拉向它（成功率受命中或法强影响）。
		 每回合陷阱对所有目标造成 %0.2f 时空伤害（基于魔法）。
		 陷阱持续 %d 回合。
		 陷阱可以多次触发，需要两回合冷却。
		 该技能不需要高级技能来准备。
		 ]]):
		format(damDesc(self, engine.DamageType.TEMPORAL, t.getDamage(self, t)), t.getDuration(self,t))
	end,
	short_info = function(self, t)
		return ([[制造范围5 的黑洞，持续 %d 回合。敌对生物受到 %d 时空伤害并被拉过去。触发范围+1。]]):
		format(t.getDuration(self,t), damDesc(self, engine.DamageType.TEMPORAL, t.getDamage(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_AMBUSH_TRAP",
	name = "伏击陷阱",
	info = function (self,t)
		return ([[放置一个魔法陷阱，能召唤阴影盗贼攻击目标。
召唤出的盗贼永久潜行，继承你的伤害加成。
杀死目标或者存在 %d 回合后，盗贼消失。]]):
		format(t.getDuration(self,t))
	end,
	short_info = function(self, t)
		return ([[召唤三名潜行盗贼，持续 %d 回合。]]):format(t.getDuration(self,t))
	end,
}
registerTalentTranslation{
	id = "T_PURGING_TRAP",
	name = "净化陷阱",
	info = function (self,t)
		local base = t.getDamage(self,t)
		local mana = base
		local vim = base / 2
		local positive = base / 4
		local negative = base / 4
		local dur = t.getDuration(self,t)
		local nb = t.getNb(self,t)
		local instant = self.trap_primed == t.id and "\n#YELLOW#设置完毕后立刻激活。#LAST#" or ""
		return ([[放置一个陷阱，触发后释放半径 2 的反魔能量波，吸取至多  %d  法力 , %d  活力 , %d  正能量和 %d  负能量 ,  并造成至多  %0.2f  奥术伤害（基于吸取能量），  沉默  %d  回合，并解除至多 %d 项正面魔法状态或者维持技能。
		  吸取效果受意志加成，你需要 25 点意志来使用该技能。
		  该陷阱可以被设置为直接激活，也可以被诱饵激活。 %s ]]):
		format(mana, vim, positive, negative, damDesc(self, DamageType.ARCANE, base), dur, nb, instant)
	end,
	short_info = function(self, t)
		local base = t.getDamage(self,t)
		local mana = base
		local dur = t.getDuration(self,t)
		local nb = t.getNb(self,t)
		return ([[半径2 反魔: 吸收至多 %d 法力, %d 活力, %d 正负能量, 造成至多 %d 奥术伤害。解除 %d 项魔法效果，沉默 %d 回合。]]):
		format(base, base/2, base/4, damDesc(self, DamageType.ARCANE, base), nb, dur)
	end,
}
registerTalentTranslation{
	id = "T_EXPLOSION_TRAP",
	name = "爆炸陷阱",
	info = function (self,t)
		local instant = self.trap_primed == t.id and "\n#YELLOW#设置完毕后立刻激活。#LAST#" or ""
		return ([[放置一个简单而有效的陷阱，激活后触发半径  2 的爆炸, 3 回合内造成 %0.2f 火焰伤害。
		该陷阱可以被设置为直接激活，也可以被诱饵激活。 %s]]):
		format(damDesc(self, DamageType.FIRE, t.getDamage(self, t)), instant)
	end,
	short_info = function(self, t)
		return ([[爆炸(范围 2) ：3回合内 %d 火焰伤害。]]):
		format(damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,
}
registerTalentTranslation{
	id = "T_CATAPULT_TRAP",
	name = "弹射陷阱",
	info = function(self, t)
		return ([[放置一个弹射陷阱。击退经过的敌人 %d 码，并眩晕 5 回合。
		陷阱触发后有 %d%% 几率自己重置，但每回合只能重置一次。
		]]):
		format(t.getDistance(self, t), t.resetChance(self, t))
	end,
	short_info = function(self, t)
		return ([[击退 %d 格，并眩晕。]]):
		format(t.getDistance(self, t))
	end,
}



registerTalentTranslation{
	id = "T_NIGHTSHADE_TRAP",
	name = "颠茄陷阱",
	info = function(self, t)
		local dam = damDesc(self, DamageType.NATURE, t.getDamage(self, t))
		return ([[放置一个涂了颠茄毒素的陷阱，造成 %0.2f 自然伤害并震慑目标 4 回合，并在四回合内受到额外 %0.2f 自然伤害。]]):
		format(dam, dam/10)
	end,
	short_info = function(self, t)
		local dam = damDesc(self, DamageType.NATURE, t.getDamage(self, t))
		return ([[造成 %d 自然伤害，震慑且每回合造成 %d 自然伤害，持续4 回合。]]):
		format(dam, dam/10)
	end,
}









return _M
