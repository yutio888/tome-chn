local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DRAINING_ASSAULT",
	name = "汲魂痛击",
	info = function(self, t)
	return ([[对 目 标 攻 击 两 次 ， 每 次 造 成 %d%% 武 器 伤 害 , 吸 取 %d%% 的 伤 害 回 复 生 命 ， 同 时 每 次 击 中 均 回 复 %d 活 力 。]]):format(100 * t.getHit(self, t), t.lifeSteal(self, t), t.vimSteal(self, t))
	end,
}


registerTalentTranslation{
	id = "T_FIERY_GRASP",
	name = "炙炎之牢",
	info = function(self, t)
	local damage = t.getDamage(self, t)
	return ([[对 目 标 伸 出 一 只 火 炎 之 爪 ， 对 直 线 上 的 生 物 造 成 %0.2f 点 火 焰 伤 害 。 目 标 被 火 炎 之 爪 抓 住 后， 受 到 %d%% 火 焰 武 器 伤 害，并在 %d 回 合 不 能 移 动 ， 同 时 每 回 合 受 到 %0.2f 点 火 焰 伤 害。
	技 能 等 级 4 级 以 后，目 标 同 时 会 被 沉 默。
	射 线 伤 害 和 持 续 伤 害 受 法 术 强 度 加 成。]]):
	format(damage, 100 * t.getHit(self, t),t.getDur(self,t), damage)
	end,
}


registerTalentTranslation{
	id = "T_RECKLESS_STRIKE",
	name = "舍身一击",
	info = function(self, t)
	return ([[攻 击 目 标 ，造 成 %d%% 武 器 伤 害。本 次 攻 击 必 中，且 无 视 目 标 护 甲 和 抗 性 。
	但 是，你 自 己 会 受 到 输 出 伤 害 的 %d%% 或 者 当 前 生 命 值 30%% 的 伤 害 ， 取 数 值 较 低 者。]]):format(100 * t.getMainhit(self, t), t.getBacklash(self,t))
	end,
}


registerTalentTranslation{
	id = "T_SHARE_THE_PAIN",
	name = "以眼还眼",
	info = function(self, t)
	return ([[你 沉 迷 于 战 争 的 狂 热 。 当 一 个 近 身 的 敌 对 生 物 伤 害 你 时，有 %d%% 几 率 自 动 反 击，造 成 %d%% 武 器 伤 害。
	此 效 果 每 回 合 对 同 一 目 标 触 发 一 次。]]):format(math.min(100, t.getChance(self,t)), t.getHit(self,t)*100)
	end,
}



return _M
