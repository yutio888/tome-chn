local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHADOWGUARD",
	name = "暗 影 守 护 ",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local duration2 = t.getImmuneDuration(self, t)
		local spellpower = t.getSpellpower(self, t)
		local defence = t.getDefense(self, t)
		return ([[你 的 黑 暗 亲 和 技 能，让 你 在 离 开 潜 行 时 获 得 25%% 所 有 伤 害 抗 性。
		此 外 ， 当 你 的 生 命 值 降 低 到 50%% 以 下 时 ，你 在 %d 回 合 内 免 疫 负 面 状 态 ， 并 获 得 %d 闪 避 和 %d 法 术 强 度 ， 持 续 %d 回 合 。]]):
		format(duration2, defence, spellpower, duration)
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_GRASP",
	name = "影之抓握",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 向 目 标 伸 出 影 之 抓 握 ， 将 其 缴 械 并 沉 默 %d 回 合 。
		影 子 会 对 目 标 造 成 %d 点 暗 影 伤 害 ， 将 它 拉 到 你 的 身 边 。
		技 能 伤 害 受 法 术 强 度 加 成。
		异 常 状 态 命 中 率 受 命 中 影 响。]]):
		format(duration, damDesc(self, DamageType.DARKNESS, damage))
	end,
}

registerTalentTranslation{
	id = "T_UMBRAL_AGILITY",
	name = "影之灵巧",
	info = function(self, t)
		return ([[你 对 暗 影 魔 法 的 掌 握 使 你 更 加 强 大。
		获 得 %d 命 中， %d 闪 避 ， %d%% 暗 影 伤 害 抗 性 穿 透。
		加 成 效 果 受 法 术 强 度 影 响 。]])
		:format(t.getAccuracy(self, t), t.getDefense(self, t), t.getPenetration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHADOW_VEIL",
	name = "暗影面纱",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local res = t.getDamageRes(self, t)
		return ([[你 融 入 阴 影 ， 并 被 其 支 配 。
		使 用 该 技 能 时 以 及 接 下 来 的 %d 个 回 合 内 ，你 将 会 自 动 闪 烁 到 一 个 附 近 的 敌 人 身 边（ 离 第 一 个 击 中 的 目 标 的 位 置 在 %d 码 之 内）， 攻 击 并 造 成 %d%% 暗 影 武 器 伤 害。
		融 入 阴 影 时 ， 你 免 疫 所 有 异 常 状 态 ， 并 获 得 %d%% 全 体 伤 害 抗 性。
		在 此 技 能 激 活 时 ， 你 无 法 控 制 你 的 角 色 ， 并 且 无 法 主 动 中 断 技 能， 直 到 死 亡 、 持 续 时 间 结 束 、 或 者 找 不 到 攻 击 的 目 标 。
		这 个 技 能 不 视 为 传 送 。
		抗 性 提 升 效 果 受 法 术 强 度 加 成 。]]):
		format(duration, t.getBlinkRange(self, t) ,100 * damage, res)
	end,
}




return _M
