local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STRENGTH_OF_PURPOSE",
	name = "意志之力",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[增 加 物 理 强 度  %d ，增 加 剑 、斧 、权 杖 、匕 首 或 者 弓 箭 的 武 器 伤 害  %d%% 。
		 当 装 备 武 器 、弹 药 或 者 计 算 武 器 伤 害 时 ，你 使 用 魔 法 取 代 你 的 力 量 属 性 进 行 计 算 。
		 这 个 技 能 的 奖 励 伤 害 取 代 武 器 掌 握 、匕 首 掌 握 和 弓 箭 掌 握 的 加 成 。]]):
		format(damage, 100*inc)
	end,
}

registerTalentTranslation{
	id = "T_GUARDIAN_UNITY",
	name = "守卫融合",
	info = function(self, t)
		local trigger = t.getLifeTrigger(self, t)
		local split = t.getDamageSplit(self, t) * 100
		local duration = t.getDuration(self, t)
		local cooldown = self:getTalentCooldown(t)
		return ([[当 单 次 攻 击 对 你 造 成 了 最 大 生 命 值  %d%%  以 上 的 伤 害 时 ，另 一 个 你 出 现 ，吸 收 这 次 伤 害 的  %d%% ，并 吸 收  %d%%  你 在 接 下 来  %d  回 合 中 的 所 有 伤 害 。
		 这 个 克 隆 体 处 于 现 实 位 面 之 外 ，因 此 只 能 造 成  50%%  伤 害 ，并 且 射 出 的 箭 矢 可 以 穿 过 友 军 。		 这 个 技 能 有 冷 却 时 间 。]]):format(trigger, split * 2, split, duration)
	end,
}

registerTalentTranslation{
	id = "T_VIGILANCE",
	name = "严阵以待",
	info = function(self, t)
		local sense = t.getSense(self, t)
		local power = t.getPower(self, t)
		return ([[增 强 你 的 隐 形 侦 测 能 力  +%d  以 及 潜 行 侦 测 能 力  +%d  。   此 外 ，每 回 合 你 有  %d%%  的 几 率 从 一 个 负 面 状 态 中 回 复 。
		 受 魔 法 属 性 影 响 ，侦 测 能 力 按 比 例 增 加 。]]):
		format(sense, sense, power)
	end,
}

registerTalentTranslation{
	id = "T_WARDEN_S_FOCUS",
	name = "专注守卫",
	info = function(self, t)
		local damage = t.getDamage(self, t) * 100
		local power = t.getPower(self, t)
		local duration = t.getDuration(self, t)
		return ([[使 用 你 的 远 程 或 者 近 战 武 器 对 目 标 造 成  %d%%  武 器 伤 害 。   在 接 下 来 的 %d 回 合 中 ，你 的 随 机 目 标 技 能 ，比 如 闪 烁 灵 刃 和 守 卫 召 唤 将 会 集 中 命 中 目 标 。
		 对 这 个 目 标 的 攻 击 获 得  %d%%  额 外 的 暴 击 几 率 和 暴 击 加 成 ，同 时 其 他 分 级 低 于 目 标 的 单 位 对 你 造 成 的 伤 害 减 少  %d%% ]])
		:format(damage, duration, power, power, power)
	end,
}

return _M
