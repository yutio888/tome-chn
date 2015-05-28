local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ARCANE_SUPREMACY",
	name = "奥术至尊",
	info = function(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[移 除 %d 个 负 面 魔 法 效 果， 并 且 使 你 进 入 奥 术 强 化 状 态 10 回 合， 增 加 5 点 法 术 强 度 和 法 术 豁 免， 每 移 除 一 个 DEBUFF， 额 外 增 加 5 点 法 术 强 度 和 法 术 豁 免。]]):
		format(count)
	end,
}

registerTalentTranslation{
	id = "T_COMMAND_STAFF",
	name = "法杖掌控",
	info = function(self, t)
		return ([[改 变 法 杖 中 流 动 的 能 量 性 质。]])
	end,
}

registerTalentTranslation{
	id = "T_WARD",
	name = "守护",
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
		你 能 激 活 的 伤 害 类 型 有 ： %s]]):format(xs)
	end,
}

registerTalentTranslation{
	id = "T_YIILKGUR_BEAM_DOWN",
	name = "回到地面",
	info = function(self, t)
		return ([[使 用 伊 克 格 的 传 送 阵 传 送 回 地 面。]])
	end,
}

registerTalentTranslation{
	id = "T_BLOCK",
	name = "格挡",
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

registerTalentTranslation{
	id = "T_BLOOM_HEAL",
	name = "夏花之愈",
	info = function(self, t)
		return ([[呼 唤 自 然 的 力 量 每 回 合 恢 复 你 %d 生 命 值 持 续 6 回 合。 
		 受 意 志 影 响， 恢 复 量 有 额 外 加 成。]]):format(7 + self:getWil() * 0.5)
	end,
}

registerTalentTranslation{
	id = "T_DESTROY_MAGIC",
	name = "禁魔",
	info = function(self, t)
		return ([[ 目 标 有 %d%% 概 率（ 最 大 叠 加 至 %d%% ） 施 法 失 败 率。 等 级 2 时 魔 法 效 果 可 能 会 被 打 断 。 等 级 3 时 持 续 性 法 术 可 能 会 被 打 断 。 等 级 5 时 魔 法 生 物 和 不 死 族 可 能 会 被 震 慑。 ]]):format(t.getpower(self, t),t.maxpower(self,t))
	end,
}

registerTalentTranslation{
	id = "T_BATTLE_TRANCE",
	name = "战意勃发",
	info = function(self, t)
		return ([[ 你 进 入 了 战 斗 狂 热 状 态， 获 得 15 ％ 全 体 伤 害 抗 性， 减 少 15 点 精 神 强 度 并 获 得 20 点 精 神 豁 免。 技 能 激 活 5 回 合 后 ， 每 回 合 你 都 有 一 定 几 率 疲 劳 ， 终 止 技 能 并 进 入 混 乱 状 态。 ]])
	end,
}

registerTalentTranslation{
	id = "T_SOUL_PURGE",
	name = "解放灵魂",
	info = function(self, t)
		return ([[除 去 Morrigor 吸 收 的 所 有 技 能。 ]])
	end,
}

registerTalentTranslation{
	id = "T_DIG_OBJECT",
	name = "挖掘",
	info = function(self, t)
		local best = t.findBest(self, t) or {digspeed=100}
		return ([[ 挖 掘 消 耗 %d 回 合 ( 基 于 你 携 带 的 最 好 锄 头 )。 ]])
		:format(best.digspeed)
	end,
}

registerTalentTranslation{
	id = "T_SHIV_LORD",
	name = "寒冰元素",
	info = function(self, t)
		local power = t.getPower(self, t)
		local dur = t.getDuration(self, t)
		return ([[你 吸 收 周 围 的 寒 冰 围 绕 你， 将 自 己 转 变 为 纯 粹 的 冰 元 素 — — 西 弗 格 罗 斯， 持 续 %d 回 合。 
		 转 化 成 元 素 后， 你 不 需 要 呼 吸 并 获 得 等 级 %d 的 冰 雪 风 暴， 获 得 %d%% 切 割 和 震 慑 抵 抗 ， %d%% 寒 冰 抗 性 ,所 有 冰 冷 伤 害 可 对 你 产 生 治 疗， 治 疗 量 基 于 伤 害 值 的 %d%% 。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(dur, self:getTalentLevelRaw(t), power * 100, power * 100 / 2, 50 + power * 100)
	end,
}

registerTalentTranslation{
	id = "T_MENTAL_REFRESH",
	name = "振作精神",
	info = function(self, t)
		return ([[ 刷 新 至 多 3 个 自 然 ， 超 能 或 诅 咒 系 技 能 。 ]])
	end,
}

registerTalentTranslation{
	id = "T_DAGGER_BLOCK",
	name = "匕首格挡",
	info = function(self, t)
		return ([[ 举 起 你 的 匕 首 来 格 挡 攻 击 一 回 合 ， 减 少 所 有 物 理 伤 害 %d 点 。 如 果 你 完 全 格 挡 了 一 次 攻 击 的 伤 害 ， 攻 击 者 将 进 入 致 命 的 被 反 击 状 态 （ 对 其 攻 击 伤 害 加 倍 ） 一 回 合 并 被 缴 械 三 回 合。
		格 挡 值 随 敏 捷 和 灵 巧 增 加 。]]):format(t.getPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHIELDSMAIDEN_AURA",
	name = "女武神之守护",
	info = function(self, t)
		return ([[每 10 回 合 能 自 动 抵 抗 一 次 攻 击 .]])
	end,
}

registerTalentTranslation{
	id = "T_PSIONIC_MAELSTROM",
	name = "灵能风暴",
	info = function(self, t)
		return ([[接 下 来 8 回 合 内 ， 强 大 的 灵 能 能 量 在 你 身 边 爆 发 ， 造 成 %d 伤 害 。]]):format(t.getDamage(self, t))
	end,
}


return _M
