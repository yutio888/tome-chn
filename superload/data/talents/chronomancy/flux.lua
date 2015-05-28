local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_INDUCE_ANOMALY",
	name = "引导异常",
	info = function(self, t)
		local reduction = t.getReduction(self, t)
		return ([[引 发 一 次 异 常 ， 减 少 你 的 紊 乱 值 %d 。 这 个 技 能 不 会 引 发 重 大 异 常。
		引 导 异 常 不 会 被 扭 曲 命 运 延 后 ， 也 不 会 触 发 被 延 后 的 异 变 。 
		然 而 ， 当 学 会 扭 曲 命 运 后 ， 你 可 以 选 中 引 导 异 变 作 为 目 标。
		受 法 术 强 度 影 响 ， 紊 乱 值 减 少 效 果 有 额 外 加 成。]]):format(reduction)
	end,
}

registerTalentTranslation{
	id = "T_REALITY_SMEARING",
	name = "弥散现实",
	info = function(self, t)
		local ratio = t.getPercent(self, t)
		local duration = t.getDuration(self, t)
		return ([[当 激 活 这 个 技 能 时 ， 你 受 到 伤 害 的 30%% 被 转 化 为 %0.2f 的 紊 乱 值。
		这 些 紊 乱 伤 害 会 被 分 散 到 三 个 回 合 中。]]):
		format(ratio, duration)
	end,
}

registerTalentTranslation{
	id = "T_ATTENUATE",
	name = "湮灭洪流",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[对 范 围 内 所 有 单 位 造 成 %0.2f 时 空 伤 害 ， 这 些 伤 害 会 被 分 散 到  %d 回 合 中 。 技 能 半 径 为 %d 格。
		 带 有 弥 散 现 实 效 果 的 单 位 不 会 受 到 伤 害 ， 并 在 四 回 合 中 回 复 %d 生 命 值。
		 如 果 目 标 的 生 命 值 被 减 低 到  20%% 以下，湮 灭 洪 流 将 会 立 刻 杀 死 目 标。
		 受 到 法 术 强 度 影 响 ， 伤 害 有 额 外 加 成。]]):format(damage, duration, radius, damage *0.4)
	end,
}

registerTalentTranslation{
	id = "T_TWIST_FATE",
	name = "扭曲命运",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local talent
		local t_name = "None"
		local t_info = ""
		local eff = self:hasEffect(self.EFF_TWIST_FATE)
		if eff then
			talent = self:getTalentFromId(eff.talent)
			t_name = talent.name
			t_info = talent.info(self, talent)
		end
		return ([[当 扭 曲 命 运 没 有 进 入 冷 却 时 ，微 小 异 变 将 会 被 延 后  %d  回 合 ，允 许 你 正 常 地 使 用 法 术 。   你 可 以 使 用 扭 曲 命 运 技 能 来 选 择 指 定 的 区 域 来 触 发 被 延 后 的 异 变 。		 如 果 在 第 一 个 异 变 被 延 后 的 回 合 中 引 发 了 第 二 个 异 变 ，那 么 第 一 个 异 变 将 会 立 刻 触 发 ，并 且 打 断 你 当 前 的 回 合 或 行 动 。
		 当 触 发 被 延 后 的 异 变 时 ，可 以 立 即 减 少 紊 乱 值 。
				 
		 当 前 异 变 ： %s 
		 
		%s ]]):
		format(duration, t_name, t_info)
	end,
}

return _M
