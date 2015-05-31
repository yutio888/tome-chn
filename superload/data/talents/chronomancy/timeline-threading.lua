local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RETHREAD",
	name = "重组",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local targets = t.getTargetCount(self, t)
		return ([[重 组 时 间 线 ， 对 一 个 目 标 造 成  %0.2f 时 空 伤 害 。 然 后 再 对 半 径 10 内 的 另 一 个 目 标 造 成 等 量 伤 害 。
		重 组  能 击 中 至 多 %d 个 目 标 ， 不 会 重 复 击 中 同 一 个 目 标 ， 也 不 会 击 中 施 法 者 。
		伤 害 受 法 术 强 度 加 成 。]]):
		format(damDesc(self, DamageType.TEMPORAL, damage), targets)
	end,
}

registerTalentTranslation{
	id = "T_TEMPORAL_FUGUE",
	name = "时间复制",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[接 下 来 %d 回 合， 2 个 你 的 镜 像 进 入 你 的 时 间 线 。
		当 技 能 生 效 时 ， 所 有 你 或 者 你 的 镜 像 造 成 的 伤 害 会 减 少 2/3 ， 所 有 你 或 者 镜 像 受 到 的 伤 害 会 由 你 们 三 者 均 分。
		开 启 时 该 技 能 不 会 正 常 冷 却。你 能 直 接 控 制 你 的 镜 像 ， 给 他 们 指 令 ， 或 者 调 整 技 能 使 用 策 略。
		你 和 镜 像 不 会 互 相 伤 害。 ]]):
		format(duration)
	end,
}

registerTalentTranslation{
	id = "T_BRAID_LIFELINES",
	name = "生命线编织",
	info = function(self, t)
		local braid = t.getBraid(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 的 重 组 技 能 将 目 标 的 生 命 线 编 织 在 一 起 %d 回 合。
		受 影 响 的 生 物 将 受 到 其 他 受 影 响 生 物 受 到 的 %d%% 伤 害.
		伤 害 受 法 术 强 度 加 成 。]])
		:format(duration, braid)
	end,
}

registerTalentTranslation{
	id = "T_CEASE_TO_EXIST",
	name = "存在抹杀",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getPower(self, t)
		return ([[接 下 来 %d 回 合，你 尝 试 抹 杀 目 标 在 当 前 时 间 线 的 存 在， 降 低 目 标 物 理 和 时 空 抗性 %d%% 。
		如 果 你 在 法 术 生 效 期 间 击 杀 了 目 标 ， 你 将 会 返 回 到 你 释 放 该 法 术 的 时 间 点 ， 而 目 标 将 被 杀 死。
		这 个 法 术 分 离 的 时 间 线 。 法 术 生 效 期 间 ， 其 余 分 离 时 间 线 的 法 术 将 无 法 成 功 试 用。
		抗 性 减 少 程 度 受 法 术 强 度 加 成。]])
		:format(duration, power)
	end,
}


return _M
