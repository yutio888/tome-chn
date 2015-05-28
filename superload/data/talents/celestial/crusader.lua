local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ABSORPTION_STRIKE",
	name = "吸能一击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 你 用 双 手 武 器 攻 击 敌 人 ， 造 成 %d%% 武 器 伤 害。
		 如 果 攻 击 命 中 ， 半 径 2 以 内 的 敌 人 光 系 抗 性 下 降 %d%% ，伤 害 下 降 %d%%, 持 续 5 回 合 。]]):
		format(100 * damage, t.getWeakness(self, t), t.getNumb(self, t))
	end,
}

registerTalentTranslation{
	id = "T_MARK_OF_LIGHT",
	name = "光之印记",
	info = function(self, t)
		return ([[你 用 光 标 记 目 标 5 回 合，你 对 它 近 战 攻 击 时 ， 将 受 到 相 当 于 %d%% 伤 害 的 治 疗 。]]):
		format(t.getPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_RIGHTEOUS_STRENGTH",
	name = "光明之力",
	info = function(self, t)
		return ([[ 当 装 备 双 手 武 器 时 ， 你 的 暴 击 率 增 加 %d%%, 同 时 你 的 近 战 暴 击 会 引 发 光 明 之 力 ， 增 加 %d%% 物 理 和 光 系 伤 害 加 成 ， 最 多 叠 加 3 倍 。
		同 时 ， 你 的 近 战 暴 击 会 在 目 标 身 上 留 下 灼 烧 痕 迹 ， 5 回 合 内 造 成 %0.2f 光 系 伤 害， 同 时 减 少 %d 护 甲 。
		伤 害 受 法 强 加 成 。]]):
		format(t.getCrit(self, t), t.getPower(self, t), damDesc(self, DamageType.LIGHT, t.getDamage(self, t)), t.getArmor(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FLASH_OF_THE_BLADE",
	name = "闪光之刃",
	info = function(self, t)
		return ([[ 旋 转 一 周 ， 同 时 将 光 明 之 力 充 满 武 器 。
		 半 径 1 以 内 的 敌 人 将 受 到 %d%% 武 器 伤 害 ， 同 时 半 径 2 以内 的 敌 人将 受 到 %d%% 光 系 武 器 伤害 。
		 技 能 等 级 4 或 以 上 时 ， 在 旋 转 时 你 会 制 造 一层 护盾 ， 吸 收 1 回 合 内 的 所 有 攻 击 。]]):
		format(t.get1Damage(self, t) * 100, t.get2Damage(self, t) * 100)
	end,
}

return _M
