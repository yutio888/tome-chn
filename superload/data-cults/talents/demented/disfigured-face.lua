local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_DISEASED_TONGUE",
	name = "疫病之舌",
	info = function(self, t)
		return ([[ 你 的 舌 头 化 作 疫 病 触 手 ， 让 你 能 #{italic}#舔 舐#{normal}# 锥 形 范 围 内 的 敌 人。
		被 舔 舐 的 敌 人 受 到 无 视 护 甲 的 %d%% 触 手 伤 害 并 获 得 一 种 持 续 %d 回 合 的 随 机 疾 病，每 回 合 造 成 %0.2f 枯 萎 伤 害 并 减 少 力 量 、敏 捷 或 体 质 %d 点。
		如 果 你 至 少 命 中 了 一 名 敌 人， 你 获 得 %d 疯 狂 值。
		疾 病 伤 害 随 法 术 强 度 而 增 加 。]]):
		format(
			t.getDamageTentacle(self, t) * 100,
			t.getDuration(self, t), damDesc(self, DamageType.BLIGHT, t.getDamageDisease(self, t)), t.getDiseasePower(self, t),
			t.getInsanity(self, t)
		)
	end,
}

registerTalentTranslation{
	id = "T_DISSOLVED_FACE",
	name = "溶解之脸",
	info = function(self, t)
		return ([[你 用 脸 贴 近 敌 人 ， 让 其 部 分 融 化 为 血 肉， 对 锥 形 范 围 内 敌 人 造 成 %0.2f 暗 影 伤 害， 持 续 5 回 合 （ 总 伤 害 %0.2f ）。
		每 回 合 目 标 身 上 的 每 种 疾 病 将 使 其 受 到 额 外 %0.2f 枯 萎 伤 害。]])
		:format(damDesc(self, DamageType.DARKNESS, t.getDamage(self, t) / 5), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), damDesc(self, DamageType.BLIGHT, 0.7 * t.getDamage(self, t) / 5))
	end,
}

registerTalentTranslation{
	id = "T_WRITHING_HAIRS",
	name = "苦痛之发",
	info = function(self, t)
		return ([[短 时 间 内 你 的 头 上 生 长 出 恐 怖 的 头 发， 每 根 头 发 的 末 梢 长 着 一 只 令 人 毛 骨 悚 然 的 眼 睛。
		你 用 这 些 眼 睛 凝 视 目 标 区 域， 部 分 石 化 范 围 内 目 标， 降 低 其 %d%% 移 速 并 使 其 处 于 7 回 合 的 脆 弱 状 态。
		脆 弱 状 态 的 目 标 每 次 受 到 伤 害 时 有 35%% 几 率 增 加 %d%% 伤 害。
		该 效 果 不 能 被 豁 免。
		]]):
		format(t.getSpeed(self, t) * 100, t.getBrittle(self, t))
	end,
}

registerTalentTranslation{
	id = "T_GLIMPSE_OF_TRUE_HORROR",
	name = "恐怖无边",
	info = function(self, t)
		return ([[ 每 次 你 使 用 该 系 技 能 时 ， 你 就 能 展 现 何 为 真 正 的 恐 怖。
		如 果 目 标 未 能 通 过 法 术 豁 免， 将 处 于 2 回 合 恐 惧 状 态 ， 使 用 技 能 有 %d%% 几 率 失 败 。
		同 时 ，敌 人 的 恐 惧 和 痛 苦 能 激 励 你 的 意 志， 在 2 回 合 内 增 加 你 %d%% 暗 影 和 枯 萎 伤 害 抗 性 穿 透。
		技 能 效 果 受 法 术 强 度 加 成 。]]):
		format(t.getFail(self, t), t.getPen(self, t))
	end,
}
return _M
