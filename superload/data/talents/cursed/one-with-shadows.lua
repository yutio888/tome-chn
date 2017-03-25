local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHADOW_SENSES",
	name = "阴影感知",
	info = function(self, t)
		return ([[ 你 的 意 识 延 伸 到 阴 影 上 。
		 你 能 清 晰 的 感 知 到 阴 影 的 位 置 ， 同 时 还 能 感 知 到 阴 影 视 野 %d 码 范 围 内 的 敌 人 。]])
		:format(self:getTalentRange(t))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_EMPATHY",
	name = "阴影链接",
	info = function(self, t)
		local power = t.getPower(self, t)
		local duration = t.getDur(self, t)
		return ([[ 你 连 接 到 你 的 阴 影 ， 持 续 %d 回 合 ，将 你 受 到 的 伤 害 的 %d%% 转 移 至 随 机 某 个 阴 影 上。
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成。 ]]):
		format(duration, power)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_TRANSPOSITION",
	name = "阴影换位",
	info = function(self, t)
		return ([[ 现 在 ， 其 他 人 很 难 分 清 你 和 阴 影 。 
 	 	 你 能 选 择 半 径 %d 范 围 内 的 一 个 阴 影 并 和 它 交 换 位 置 。
		 同 时 至 多 %d 个 随 机 负 面 物 理 或 魔 法 效 果 会 被 转 移 至 选 择 的 阴 影 身 上 。]])
		:format(self:getTalentRadius(t), t.getNb(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_DECOY",
	name = "阴影诱饵",
	info = function(self, t)
		return ([[ 你 的 阴 影 用 生 命 来 守 护 你 。
		 当 你 受 到 致 命 攻 击 时 ，你 将 立 刻 和 随 机 一个 阴 影 换 位 ， 让 它 代 替 承 受 攻 击， 并 将此 技 能 打 入 冷 却 。
		 在 接 下 来 的 4 个 回 合 ， 除 非 你 的 生 命 降 至 - %d 下 ， 否 则 你 不 会 死 去 。
		 受 精 神 强 度 影 响， 效 果 有 额 外 加 成 。 ]]):
		format(t.getPower(self, t))
	end,
}



return _M
