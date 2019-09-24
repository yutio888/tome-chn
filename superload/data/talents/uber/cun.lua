local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FAST_AS_LIGHTNING",
	name = "疾如闪电",
	info = function(self, t)
		return ([[向 同 一 方 向 连 续 以 超 过 800％ 速 度 至 少 移 动 3 回 合 后， 你 可 以 无 视 障 碍 物 移 动。 
		 移 动 过 程 中  ，你 有 50%% 几 率 通 过 换 位 无 视 攻 击，每 回 合 最 多 触 发 一 次。
		 变 换 方 向 会 打 断 此 效 果。  ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_TRICKY_DEFENSES",
	name = "欺诈护盾",
	["require.special.desc"] = "加入反魔神教",
	info = function(self, t)
		return ([[由 于 你 精 通 欺 诈 和 伪 装， 你 的 反 魔 护 盾 可 以 多 吸 收 %d 伤 害。 
		 受 灵 巧 影 响， 效 果 按 比 例 加 成。  ]])
		:format(t.shieldmult(self)*100)
	end,
}

registerTalentTranslation{
	id = "T_ENDLESS_WOES",
	name = "无尽灾厄",
	["require.special.desc"] = "曾 造 成 超 过 50000 点 酸 性、 枯 萎、 暗 影、 精 神 或 时 空 伤 害",
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
		return ([[你 被 灾 厄 光 环 笼 罩，存储你造成的元素伤害。
		当你积累的元素伤害达到%d时，你会向一个随机的敌人发射一次强力的爆炸，在半径%d范围内造成%d的该类型伤害，并对敌人附加以下的附加效果：

		#GREEN#酸性:#LAST#  每回合受到 %d 酸性伤害，持续5回合。
		#DARK_GREEN#枯萎:#LAST#  每回合受到 %d 枯萎伤害， 力量、体质和敏捷减少 %d，持续5回合
		#GREY#黑暗:#LAST#  造成的所有伤害减少 %d%% ，持续5回合。
		#LIGHT_STEEL_BLUE#时空:#LAST#  整体速度降低 %d%%，持续5回合。
		#YELLOW#精神:#LAST#  混乱 (强度 %d%%) ，持续5回合。

		同种效果最多每12回合触发一次。这不是普通的技能冷却。
		伤害和效果强度随你的灵巧值增加，伤害阈值随你的等级增加，施加附加效果的强度由你的精神强度和法术强度的最高值决定。
		%s]])
		:format(t.getThreshold(self, t), t.getDamage(self, t), self:getTalentRadius(t), t.getAcid(self, t), blight_dam, blight_disease, t.getDarkness(self, t), t.getTemporal(self, t), t.getMind(self, t), str)
	end,
}

registerTalentTranslation{
	id = "T_SECRETS_OF_TELOS",
	name = "泰勒斯之秘",
	["require.special.desc"] = "找到泰勒斯法杖的上半部，下半部和宝石。",
	info = function(self, t)
		return ([[泰 勒 斯 有 三 宝： 又 长、 又 粗、 打 怪 好。 
		 通 过 对 泰 勒 斯 三 宝 的 长 期 研 究， 你 相 信 你 可 以 使 它 们 合 为 一 体。  ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_ELEMENTAL_SURGE",
	name = "元素狂潮",
	["require.special.desc"] = "曾 造 成 50000 点 奥 术、 火 焰、 冰 冷、 闪 电、 光 系 或 自 然 伤 害",
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
		当你积累的元素伤害达到%d时，你会向一个随机的敌人发射一次强力的爆炸，在半径%d范围内造成%d的该类型伤害，并对你自己附加以下的附加效果：

		物理:		清除1个物理负面特效并给予2回合物理负面特效豁免。
		#PURPLE#奥术:#LAST#		增加你的精神和施法速度30%%，持续3回合。
		#LIGHT_RED#火焰:#LAST#		增加你所造成的所有伤害%d%%，持续3回合。
		#1133F3#寒冷:#LAST#		将你的皮肤变成冰，增加护甲%d，对攻击者造成%d冰冻伤害，持续3回合
		#ROYAL_BLUE#闪电:#LAST#	你的移动速度提升%d%%，持续2回合。
		#YELLOW#光系:#LAST#		技能冷却时间减少20%%，持续3回合。
		#LIGHT_GREEN#自然:#LAST#		清除1个魔法负面特效并给予2回合魔法负面特效豁免。

		同种效果最多每10回合触发一次。这不是普通的技能冷却。
		伤害和效果强度随你的灵巧值增加，伤害阈值随你的等级增加。
		%s]])
		:format(t.getThreshold(self, t), t.getDamage(self, t), self:getTalentRadius(t), t.getFire(self, t), cold.armor, cold.dam, t.getLightning(self, t), str)
	end,
}

eye_of_the_tiger_data = {
	physical = {
		desc = "所 有 的 物 理 暴 击 减 少 随 机 的 1 个 冷 却 中 的 格 斗 或 灵 巧 系 技 能 2 回 合 冷 却 时 间。 ",
		types = { "^technique/", "^cunning/" },
		reduce = 2,
	},
	spell = {
		desc = "所 有 的 法 术 暴 击 减 少 随 机 的 1 个 冷 却 中 的 法 术  技 能 2 回 合 冷 却 时 间。 ",
		types = { "^spell/", "^corruption/", "^celestial/", "^chronomancy/" },
		reduce = 2,
	},
	mind = {
		desc = "所 有 的 精 神 暴 击 减 少 随 机 的 1 个 冷 却 中 的 自 然 / 心 灵 / 痛 苦 系 技 能 2 回 合 冷 却 时 间。 ",
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
		每种类型 每 回 合 最 多 触 发 一 次 ， 不 能 影 响 触 发 该 效 果 的 技 能。]])
		:format(table.concat(list, "\n"))
	end,

}

registerTalentTranslation{
	id = "T_WORLDLY_KNOWLEDGE",
	name = "渊博学识",
	info = function(self, t)
		return ([[以 0.9 的 技 能 系 数 学 会 以 下 技 能 树 中 的 一 个。
		 分 组 1 中 的 技 能， 所 有 职 业 都 可 学。
		 分 组 2 中 的 技 能， 只 适 用 于 不 学 法 术 和 符 文 的 职 业。
		 分 组 3 中 的 技 能， 不 适 用 于 反 魔 神 教 的 信 徒。
		 分 组 1：
		- 格 斗 / 体 质 强 化 系
		- 灵 巧 / 生 存 系
		- 自 然 / 自 然 协 调 系
		 分 组 2：
		- 自 然 / 自 然 召 唤 系
		- 自 然 / 灵 晶 掌 握 系
		- 超 能 / 梦 境 系
		- 超 能 / 强 化 移 动 系
		- 超 能 / 反 馈 系
		 分 组 3：
		- 法 术 / 侦 查 系 
		- 法 术 / 法 杖 格 斗 系
		- 法 术 / 岩 石 炼 金 系
		- 堕 落 / 邪 恶 生 命 系
		- 堕 落 / 邪 术 系
		- 堕 落 / 诅 咒 系
		- 天 空 / 赞 歌 系
		- 时 空 / 时 空 系]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_ADEPT",
	name = "熟能生巧",
	info = function(self, t)
		return ([[你的技能树系数增加0.3。请注意，许多技能不会从这一增长中受益。]])
		:format()
	end,
}


registerTalentTranslation{
	id = "T_TRICKS_OF_THE_TRADE",
	name = "欺诈圣手",
	["require.special.desc"] = "与盗贼领主同流合污",
	info = function(self, t)
		return ([[你 结 交 了 狐 朋 狗 友， 学 到 了 一 些 下 三 滥 的 技 巧。 
		 增 加 灵 巧 / 潜 行 系 0.2 系 数 值（ 需 习 得 该 技 能 树， 未 解 锁 则 会 解 锁 此 技 能）， 同 时 增 加 灵 巧 / 街 头 格 斗 系 0.1 系 数 值（ 未 习 得 则 以 0.9 的 技 能 系 数 解 锁 此 技 能 树）。
		 此 外， 你 攻 击 隐 形 单 位 时 的 伤 害 惩 罚 永 久 减 半。  ]]):
		format()
	end,
}

return _M
