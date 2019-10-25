local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FAST_AS_LIGHTNING",
	name = "疾如闪电",
	info = function(self, t)
		return ([[向同一方向连续以超过 800％速度至少移动 3 回合后，你可以无视障碍物移动。 
		移动过程中，你有 50%% 几率通过换位无视攻击，每回合最多触发一次。
		变换方向会打断此效果。 ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_TRICKY_DEFENSES",
	name = "欺诈护盾",
	["require.special.desc"] = "加入反魔神教",
	info = function(self, t)
		return ([[由于你精通欺诈和伪装，你的反魔护盾可以多吸收 %d 伤害。 
		受灵巧影响，效果按比例加成。 ]])
		:format(t.shieldmult(self)*100)
	end,
}

registerTalentTranslation{
	id = "T_ENDLESS_WOES",
	name = "无尽灾厄",
	["require.special.desc"] = "曾造成超过 50000 点酸性、枯萎、暗影、精神或时空伤害",
	info = function(self, t)
		local blight_dam, blight_disease = t.getBlight(self, t)
		local cooldowns = {}
		local str = ""
		-- Display the remaining cooldowns in the talent tooltip only if its learned
		if self:knowTalent(self.T_ENDLESS_WOES) then
			for dt, _ in pairs(t.dts) do
				local proc = self:hasProc("endless_woes_"..dt:lower())
				if proc then cooldowns[#cooldowns+1] = (dt:lower()):capitalize()..": "..proc.turns end
			end
			str = "(冷却)".."\n"..table.concat(cooldowns, "\n")
		end
		return ([[你被灾厄光环笼罩，存储你造成的元素伤害。
		当你积累的元素伤害达到 %d 时，你会向一个随机的敌人发射一次强力的爆炸，在半径 %d 范围内造成 %d 的该类型伤害，并对敌人附加以下的附加效果：
		#GREEN#酸性 :#LAST#  每回合受到 %d 酸性伤害，持续 5 回合。
		#DARK_GREEN#枯萎 :#LAST#  每回合受到 %d 枯萎伤害，力量、体质和敏捷减少 %d ，持续 5 回合	
		#GREY#黑暗 :#LAST#  造成的所有伤害减少 %d%% ，持续 5 回合。
		#LIGHT_STEEL_BLUE#时空 :#LAST#  整体速度降低 %d%% ，持续 5 回合。	
		#YELLOW#精神 :#LAST#  混乱 (强度 %d%% ) ，持续 5 回合。
		同种效果最多每 12 回合触发一次。这不是普通的技能冷却。 
		伤害和效果强度随你的灵巧值增加，伤害阈值随你的等级增加，施加附加效果的强度由你的精神强度和法术强度的最高值决定。
		%s]])
		:format(t.getThreshold(self, t), self:getTalentRadius(t), t.getDamage(self, t), t.getAcid(self, t), blight_dam, blight_disease, t.getDarkness(self, t), t.getTemporal(self, t), t.getMind(self, t), str)
	end,
}

registerTalentTranslation{
	id = "T_SECRETS_OF_TELOS",
	name = "泰勒斯之秘",
	["require.special.desc"] = "找到泰勒斯法杖的上半部，下半部和宝石。",
	info = function(self, t)
		return ([[泰勒斯有三宝：又长、又粗、打怪好。 
		通过对泰勒斯三宝的长期研究，你相信你可以使它们合为一体。 ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_ELEMENTAL_SURGE",
	name = "元素狂潮",
	["require.special.desc"] = "曾造成 50000 点奥术、火焰、冰冷、闪电、光系或自然伤害",
	info = function(self, t)
		local cooldowns = {}
		local str = ""
		local cold = t.getCold(self, t)
		-- Display the remaining cooldowns in the talent tooltip only if its learned
		if self:knowTalent(self.T_ELEMENTAL_SURGE) then
			for dt, _ in pairs(t.dts) do
				local proc = self:hasProc("elemental_surge_"..dt:lower())
				if proc then cooldowns[#cooldowns+1] = (dt:lower()):capitalize()..": "..proc.turns end
			end
		str = "(冷却)".."\n"..table.concat(cooldowns, "\n")
		end
		return ([[你被元素光环笼罩，存储你造成的元素伤害。
		当你积累的元素伤害达到 %d 时，你会向一个随机的敌人发射一次强力的爆炸，在半径 %d 范围内造成 %d 的该类型伤害，并对你自己附加以下的附加效果：

		物理 :		清除 1 个物理负面特效并给予 2 回合物理负面特效豁免。
		#PURPLE#奥术 :#LAST#		增加你的精神和施法速度 30%% ，持续 3 回合。
		#LIGHT_RED#火焰 :#LAST#		增加你所造成的所有伤害 %d%% ，持续 3 回合。
		#1133F3#寒冷 :#LAST#		将你的皮肤变成冰，增加护甲 %d ，对攻击者造成 %d 冰冻伤害，持续 3 回合 
		#ROYAL_BLUE#闪电 :#LAST#	 你的移动速度提升 %d%% ，持续 2 回合。
		#YELLOW#光系 :#LAST#		技能冷却时间减少 20%% ，持续 3 回合。
		#LIGHT_GREEN#自然 :#LAST#		清除 1 个魔法负面特效并给予 2 回合魔法负面特效豁免。

		同种效果最多每 10 回合触发一次。这不是普通的技能冷却。
		伤害和效果强度随你的灵巧值增加，伤害阈值随你的等级增加。
		%s]])
		:format(t.getThreshold(self, t), self:getTalentRadius(t),t.getDamage(self, t), t.getFire(self, t), cold.armor, cold.dam, t.getLightning(self, t), str)
	end,
}

eye_of_the_tiger_data = {
	physical = {
		desc = "所有的物理暴击减少随机的 1 个冷却中的格斗或灵巧系技能 2 回合冷却时间。",
		types = { "^technique/", "^cunning/" },
		reduce = 2,
	},
	spell = {
		desc = "所有的法术暴击减少随机的 1 个冷却中的法术技能 2 回合冷却时间。",
		types = { "^spell/", "^corruption/", "^celestial/", "^chronomancy/" },
		reduce = 2,
	},
	mind = {
		desc = "所有的精神暴击减少随机的 1 个冷却中的自然 / 心灵 / 痛苦系技能 2 回合冷却时间。",
		types = { "^wild%-gift/", "^cursed/", "^psionic/" },
		reduce = 2,
	},
}
registerTalentTranslation{
	id = "T_EYE_OF_THE_TIGER",
	name = "猛虎之眼",
	trigger = function(self, t, kind)
		local kind_str = "eye_tiger_"..kind
		if self:hasProc(kind_str) then return end

		local tids = {}

		for tid, _ in pairs(self.talents_cd) do
			local t = self:getTalentFromId(tid)
			if not t.fixed_cooldown then
				local ok = false
				local d = eye_of_the_tiger_data[kind]
				if d then for _, check in ipairs(d.types) do
						if t.type[1]:find(check) then ok = true break end
				end end
				if ok then
					tids[#tids+1] = tid
				end
			end
		end
		if #tids == 0 then return end
		local tid = rng.table(tids)
		local d = eye_of_the_tiger_data[kind]
		self.talents_cd[tid] = self.talents_cd[tid] - (d and d.reduce or 1)
		if self.talents_cd[tid] <= 0 then self.talents_cd[tid] = nil end
		self.changed = true
		self:setProc(kind_str)
	end,
	info = function(self, t)
		local list = {}
		for _, d in pairs(eye_of_the_tiger_data) do list[#list+1] = d.desc end
		return ([[%s		
		每种类型每回合最多触发一次，不能影响触发该效果的技能。]])
		:format(table.concat(list, "\n"))
	end,

}

registerTalentTranslation{
	id = "T_WORLDLY_KNOWLEDGE",
	name = "渊博学识",
	info = function(self, t)
		return ([[获得 5 点通用技能点，以 1.0 的技能系数学会以下技能树中的一个。
		分组 1 中的技能，所有职业都可学。
		分组 2 中的技能，只适用于不学法术和符文的职业。
		分组 3 中的技能，不适用于反魔神教的信徒。
		分组 1：
		- 格斗 / 体质强化系
		- 灵巧 / 生存系
		- 自然 / 自然协调系
		分组 2：
		- 自然 / 自然召唤系
		- 自然 / 灵晶掌握系
		- 超能 / 梦境系
		- 超能 / 强化移动系
		- 超能 / 反馈系
		分组 3：
		- 法术 / 侦查系 
		- 法术 / 法杖格斗系
		- 法术 / 岩石炼金系
		- 堕落 / 邪恶生命系
		- 堕落 / 邪术系
		- 堕落 / 诅咒系
		- 天空 / 赞歌系
		- 时空 / 时空系]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_ADEPT",
	name = "熟能生巧",
	info = function(self, t)
		return ([[你的技能树系数增加 0.3 。请注意，许多技能不会从这一增长中受益。]])
		:format()
	end,
}


registerTalentTranslation{
	id = "T_TRICKS_OF_THE_TRADE",
	name = "欺诈圣手",
	["require.special.desc"] = "与盗贼领主同流合污",
	info = function(self, t)
		return ([[你结交了狐朋狗友，学到了一些下三滥的技巧。 
		增加灵巧 / 潜行系 0.2 系数值（需习得该技能树，未解锁则会解锁此技能），同时增加灵巧 / 街头格斗系 0.1 系数值（未习得则以 0.9 的技能系数解锁此技能树）。
		此外，你隐形时的伤害惩罚永久减半。 ]]):
		format()
	end,
}

return _M
