local _M = loadPrevious(...)

registerTalentTranslation{
    id = "T_REND",
    name = "撕裂",
	info = function(self, t)
		return ([[向目标挥舞两把武器，每次攻击造成 %d%% 伤害，每次攻击将会使目标身上持续时间最短的疾病效果的持续时间延长 %d 回合。]]):
		format(100 * t.getDamage(self, t), t.getIncrease(self, t))
	end,
}

registerTalentTranslation{
    id = "T_RUIN",
    name = "毁伤",
	info = function(self, t)
		local dam = damDesc(self, DamageType.BLIGHT, t.getDamage(self, t))
		return ([[专 注 于 你 带 来 的 瘟 疫， 每 次 近 战 攻 击 会 造 成 %0.2f 枯 萎 伤 害（ 同 时 每 击 恢 复 你 %0.2f 生 命 值）。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(dam, dam * 0.4)
	end,
}

registerTalentTranslation{
    id = "T_ACID_STRIKE",
    name = "酸性打击",
	info = function(self, t)
		return ([[用 每 把 武 器 打 击 目 标， 每 次 攻 击 造 成 %d%% 酸 性 武 器 伤 害。 
		 如 果 有 至 少 一 次 攻 击 命 中 目 标， 则 会 产 生 酸 系 溅 射， 对 %d 范围内的所有敌 人 造 成 %0.2f 酸 性 伤 害。 
		 受 法 术 强 度 影 响， 溅 射 伤 害 有 额 外 加 成。]]):
		 format(100 * t.getDamage(self, t), self:getTalentRadius(t), damDesc(self, DamageType.ACID, t.getSplash(self, t)))
		end,
}

registerTalentTranslation{
    id = "T_DARK_SURPRISE",
    name = "黑暗连击",
	info = function(self, t)
		return ([[腐 化 目 标 ， 2  回 合 内 降 低 其  100%%  的 疾 病 免 疫 ，并 去 除 其  2  个 自 然 持 续 效 果 。然 后 用 你 的 两 把 武 器 打 击 敌 人 ，造 成  %d%%  伤 害 。]]):
			format(100 * t.getDamage(self, t))
	end,
}


return _M
