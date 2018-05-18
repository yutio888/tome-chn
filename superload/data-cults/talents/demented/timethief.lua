local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ACCELERATE",
	name = "窃速神偷",
	info = function(self, t)
		local dur = t.getDuration(self, t)
		local speed = t.getSpeed(self, t)
		return ([[扭 曲 周 围 时 空 ， 周 围 7 码 内 敌 人 移 动 速 度 降 低 50%% ， 持 续 %d 回 合 。
		你 使 用 偷 取 的 速 度 强 化 自 身 ， 使 自 己 获 得 一 回 合 神 速 状 态 ， 移 动 速 度 提 高 %d%%， 每 减 速 一 个 敌 人 ， 额 外 提 高 %d%%， 最 大 个 数 4 个 。
		移 动 外 的 任 何 行 动 将 终 止 加 速 效 果。]]):
		format(dur, speed, speed/8)
	end,
}

registerTalentTranslation{
	id = "T_SWITCH",
	name = "偷天换日",
	info = function(self, t)
		local nb = t.getNb(self,t)
		local dur = t.getDuration(self,t)
		return ([[释 放 熵 浪 潮 ，清 除 自 己 的 灾 祸 ， 同 时 吸 取 他 人 的 能 量 。 10 码 内 所 有 敌 人 的 %d 项 有 益 效 果 持 续 时 间 缩 短 %d 回 合 。 自 身 同 等 数 量 的 有 害 效 果 持 续 时 间 缩 短 同 等 回 合 。]]):
		format(nb, dur)
	end,
}

registerTalentTranslation{
	id = "T_SUSPEND",
	name = "窃命凝固",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		local dur = t.getDuration(self,t)
		return ([[你 和 %d 码 内 所 有 敌 人 在 时 间 中 凝 固 %d 回 合 ， 无 法 行 动 但 也 无 法 被 伤 害。
		自 身 的 有 害 效 果 持 续 时 间 和 技 能 CD 会 正 常 扣 减 ， 有 益 效 果 持 续 时 间 不 变。
		敌 人 的 有 害 效 果 持 续 时 间 和 技 能 CD 不 会 扣 减 ， 有 益 效 果 持 续 时 间 正 常 扣 减。]]):format(rad, dur)
	end,
}

registerTalentTranslation{
	id = "T_SPLIT",
	name = "命运裂解",
	info = function(self, t)
		local dur = t.getDuration(self, t)
		local power = t.getPower(self,t)
		local res = 80 - power
		local dam = 40 + power
		local life = 20 + power
		return ([[将 目 标 敌 人 从 正 常 时 间 流 部 分 移 除 ， 持 续 %d 回 合 ， 隔 绝 他 们 与 现 实 世 界 交 互 的 能 力 。 移 除 期 间 敌 人 受 到 的 伤 害 降 低 %d%% ， 造 成 的 伤 害 也 降 低 %d%% 。
		技 能 启 动 时 ， 你 从 受 损 的 时 间 线 中 召 唤 敌 人 的 时 空 克 隆 体 协 助 你 战 斗 ， 持 续 时 间 与 敌 人 移 除 时 间 相 同 ， 克 隆 体 生 命 值 降 低 %d%% ， 造 成 伤 害 降 低 %d%% ， 其 他 能 力 与 本 体 相 同。]]):
		format(dur, res, dam, life, dam)
	end,
}
return _M
