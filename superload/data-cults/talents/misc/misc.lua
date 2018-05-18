local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_TELEPORT_KROSHKKUR",
	name = "传送: 克诺什库尔",
	info = function(self, t) return ([[允 许 传 送 至 克 诺 什 库 尔。
	你 学 习 了 那 里 的 禁 忌 秘 密， 因 此 获 得 了 传 送 至 克 诺 什 库 尔 的 法 术。
	该 法 术 必 须 保 持 机 密； 它 在 有 其 他 人 在 场 时 不 能 使 用 。
	该 法 术 需 要 40 回 合 生 效 ，在 此 期 间 你 需 要 处 于 任 何 生 物 视 线 外 。]]) end,
}

registerTalentTranslation{
	id = "T_DREM_CALL_OF_AMAKTHEL",
	name = "阿玛克塞尔的呼唤",
	info = function(self, t)
		return ([[将 10 格 内 的 敌 人 朝 你 拉 近 3 格 。 该 法 术 会 令 他 们 选 择 你 作 为  目 标。]])
	end,
}

registerTalentTranslation{
	id = "T_CRUMBLE",
	name = "瓦解",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[发 射 黑 暗 能 量 ，对 目 标 造 成 %0.2f 伤 害 并 破 坏 3 格 范 围 内 的 墙 壁。伤 害 受 法 术 强 度 加 成 。]]):
		format(damDesc(self, DamageType.DARKNESS, damage))
	end,
}

registerTalentTranslation{
	id = "T_TWISTED_EVOLUTION",
	name = "扭曲进化",
	info = function(self, t)
		return ([[进 化 10 格 范 围 内 至 多 %d 名 友 方 单 位 5 回 合 。
		#ORCHID#速 度:#LAST# 增 加 %d%% 整 体 速 度。
		#ORCHID#形 态:#LAST# 增 加 %d 全 属 性 。
		#ORCHID#力 量:#LAST# 增 加 %d%% 伤 害 。]]):format(t.getAmount(self, t), t.getEvolveSpeed(self, t) * 100, t.getEvolveStat(self, t), t.getEvolveDamage(self, t))
	end,
}

registerTalentTranslation{
	id = "T_GLASS_SPLINTERS",
	name = "玻璃碎片",
	info = function(self, t)
		return ([[ 使 用 玻 璃 碎 片 攻 击 敌 人 ，造 成 %d%% 奥 术 武 器 伤 害 。
		如 果 攻 击 命 中 ，目 标 将 被 玻 璃 碎 片 扎 6 回 合 。
		每 回 合 目 标 将 受 到 8%% 攻 击 伤 害 的 流 血 伤 害 。
		同 时 每 当 目 标 移 动 时 ， 受 到 %d%% 攻 击 伤 害。 
		技 能 等 级 5 后 ， 目 标 有 15%% 几 率 使 用 技 能 失 败 。]])
		:format(t.getDam(self, t) * 100, t.getMovePenalty(self, t))
	end,
}

registerTalentTranslation{
	id = "T_THROW_PEEBLE",
	name = "投掷鹅卵石",
	info = function(self, t)
		return ([[朝 目 标 扔 石 头， 造 成 %0.2f 物 理 伤 害。
		伤 害 受 力 量 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, t.getDam(self, t)))
	end,
}

registerTalentTranslation{
	id = "T_NETHERFORCE",
	name = "虚空之力",
	info = function(self, t)
		local dam = t.getDamage(self,t)/2
		local backlash = t.getBacklash(self,t)
		return ([[用 虚 空 之 力 攻 击 目 标 ，造 成 %0.2f 暗 影 %0.2f 时 空 伤 害 并 击 退 8 格。 
		该 法 术 会 产 生 熵 能 反 冲， 让 你 在 8 回 合 内 受  到 %d 伤 害。
		伤 害 受 法 术 强 度 加 成 。]]):
		format(damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.TEMPORAL, dam), backlash)
	end,
}
return _M
