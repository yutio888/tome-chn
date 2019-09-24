local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STEALTH",
	name = "潜行",
	info = function(self, t)
		local stealthpower = t.getStealthPower(self, t) + (self:attr("inc_stealth") or 0)
		local radius, rad_dark = t.getRadius(self, t, true)
		xs = rad_dark ~= radius and (" (在黑暗地格范围为 %d )"):format(rad_dark) or ""
		return ([[进 入 潜 行 模 式 （潜 行 点 数 %d ，基 于 灵 巧 ），让 你 更 难 被 侦 测 到 。
		如 果 成 功 （每 回 合 都 重 新 检 查 ），敌 人 将 不 会 知 道 你 在 哪 里 ，或 者 根 本 不 会 注 意 到 你 。
		潜 行 将 光 照 半 径 减 小 至 0，增加3点夜视能力 ，并 且 不 能 在 装 备 重 甲 或 板 甲 时 使 用 。
		如 果 敌 人 在 半 径 %d %s 内 ，你 不 能 进 入 潜 行 。
		除非特别说明，任何非顺发的非移动能力都会打破潜行。

		即使不知道你位置的敌人，仍然会猜测你可能在的位置。
		在潜行时，敌人无法分享有关你位置的信息，并且会一直相信你还在那里。]]):
		format(stealthpower, radius, xs)
	end,
}

registerTalentTranslation{
	id = "T_SHADOWSTRIKE",
	name = "影袭",
	info = function(self, t)
		local multiplier = t.getMultiplier(self, t)*100
		local dur = t.getDuration(self, t)
		return ([[你 充 分 发 挥 潜 行 优 势。
		潜 行 状 态 下 攻 击 时，如 果 直 到 命 中 前 你 的 目 标 都 没 有 发 现 你 ，你 的 攻 击 将 自 动 暴 击 。（即 使 目 标 注 意 到 你 ，你 的 法 术 和 精 神 攻 击 也 会 暴 击 。）
		对 于 看 不 见 你 的 目 标 ，暴 击 伤 害 增 加 %d%% 。（你 必 须 能 够 看 到 你 的 目 标 ，并 且 伤 害 奖 励 随 距 离 降 低 ：3 格 内 保 持 满 额 ，到 10 格 时 降 低 为 0 ）、
		此 外 ，由 于 任 何 原 因 脱 离 潜 行 后 ，暴 击 伤 害 奖 励 会 持 续 存 在 %d 回 合 （不 受 范 围 限 制 ）。]]):format(multiplier, dur)
	end,
}

registerTalentTranslation{
	id = "T_SOOTHING_DARKNESS",
	name = "黑暗亲和",
	info = function(self, t)
		return ([[你 对 黑 暗 和 阴 影 有 特 殊 的 亲 和 力 。
		 站 在 黑 暗 地 格 中 ，激 活 潜 行 的 最 小 范 围 限 制 降 低 %d 。
		 当 潜 行 时 ，你 增 加 %0.1f 的 生 命 回 复 速 度 （基 于 灵 巧 ），同 时 你 也 增 加 %0.1f 的 体 力 回 复 速 度 。该 回 复 效 果 在 退 出 潜 行 后 仍 能 保 持 %d 回 合 ，并 且 生 命 回 复 速 度 是 正 常 的 五 倍 。]]):
		format(t.getRadius(self, t, true), t.getLife(self,t), t.getStamina(self,t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_DANCE",
	name = "暗影之舞",
	info = function (self,t)
		return ([[你 对 潜 行 的 精 通 让 你 能 够 随 时 从 视 野 中 消 失 。
		你自动进入潜行模式。在%d回合内，你非潜行的行动不会使你主动显形。]]):
		format(t.getDuration(self, t))
	end,
}




return _M
