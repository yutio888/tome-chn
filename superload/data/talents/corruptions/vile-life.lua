local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_BLOOD_SPLASH",
	name = "鲜血飞溅",
	info = function(self, t)
		return ([[制 造 痛 苦 和 死 亡 让 你 充 满 活 力。
		每 次 暴 击 时 回 复 %d 生 命。
		每 次 杀 死 生 物 时 回 复 %d 生 命。
		每 个 效 果 每 回 合 只 能 触 发 一 次。]]):
		format(t.heal(self, t), t.heal(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ELEMENTAL_DISCORD",
	name = "元素狂乱",
	info = function(self, t)
		return ([[ 每 次 受 到 元 素 伤 害 时 对 造 成 伤 害 的 生 物 触 发 以 下 效 果：
		- 火 焰：灼 烧 目 标 5 回 合 ，造 成 %0.2f 火 焰 伤 害 。
		- 寒 冷：冻 结 目 标 3 回 合 ，冰 块 强 度 %d 。
		- 酸 性：致 盲 %d 回 合 。
		- 闪 电：眩 晕 %d 回 合 。
		- 自 然：减 速 %d%% 四 回 合。
		每 种 伤 害 类 型 的 效 果 每 10 回 合 只 能 触 发 一 次。]]):
		format(
			damDesc(self, DamageType.FIRE, t.getFire(self, t)),
			t.getCold(self, t),
			t.getAcid(self, t),
			t.getLightning(self, t),
			t.getNature(self, t)
		)
	end,
}

registerTalentTranslation{
	id = "T_HEALING_INVERSION",
	name = "治疗逆转",
	info = function(self, t)
		return ([[你 操 控 目 标 的 活 力 ， 临 时 将 所 有 治 疗 转 化 为 伤 害 。 
		5 回 合 内 目 标 受 到 的 所 有 治 疗 将 变 成 %d%% 治 疗 量 的 枯 萎 伤 害 。
		效 果 受 法 术 强 度 加 成 。]]):format(t.getPower(self,t))
	end,
}

registerTalentTranslation{
	id = "T_VILE_TRANSPLANT",
	name = "邪恶移植",
	info = function(self, t)
		return ([[你 将 至 多 %d 个 物 理 与 魔 法 负 面 状 态 转 移 给 附 近 的 一 个 生 物 。
		每 转 移 一 个 负 面 状 态 ， 你 将 失 去 %0.1f%% 剩 余 生 命 值 ， 该 生 物 将 受 到 等 量 治 疗。
		转 移 成 功 率 受 法 术 强 度 影 响 。]]):
		format(t.getNb(self, t), t.getDam(self, t))
	end,
}



return _M
