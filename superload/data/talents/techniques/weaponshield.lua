local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHIELD_PUMMEL",
	name = "盾牌连击",
	info = function(self, t)
		return ([[连 续 使 用 2 次 盾 牌 攻 击 敌 人 并 分 别 造 成 %d%% 和 %d%% 盾 牌 伤 害。
		如 果 此 技 能 连 续 命 中 目 标 2 次 则 目 标 会 被 震 慑 %d 回 合。
		受 命 中 和 力 量 影 响， 震 慑 几 率 有 额 外 加 成。]])
		:format(100 * self:combatTalentWeaponDamage(t, 1, 1.7, self:getTalentLevel(self.T_SHIELD_EXPERTISE)),
		100 * self:combatTalentWeaponDamage(t, 1.2, 2.1, self:getTalentLevel(self.T_SHIELD_EXPERTISE)),
		t.getStunDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_RIPOSTE",
	name = "还击",
	info = function(self, t)
		local inc = t.getDurInc(self, t)
		return ([[通 过 以 下 方 法 提 高 你 的 反 击 能 力：
		当 出 现 不 完 全 格 挡 时 也 可 以 进 行 反 击。
		增 加 攻 击 者 反 击DEBUFF的 持 续 时 间 %d 。
		你 对 可 反 击 目 标 的 反 击 次 数 增 加 %d 次。
		增 加 %d%% 反 击 暴 击 率。
		受 敏 捷 影 响， 此 暴 击 率 按 比 例 加 成。]]):format(inc, inc, t.getCritInc(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHIELD_SLAM",
	name = "拍击",
	info = function(self, t)
		local damage = t.getShieldDamage(self, t)*100
		return ([[用 盾 牌 拍 击 目 标 3 次， 造 成 %d%% 武 器 伤 害 ， 然 后 迅 速 进 入 格 挡 状 态。
		该 格 挡 不 占 用 盾 牌 的 格 挡 技 能 CD。]])
		:format(damage)
	end,
}

registerTalentTranslation{
	id = "T_ASSAULT",
	name = "强袭",
	info = function(self, t)
		return ([[用 你 的 盾 牌 攻 击 目 标 并 造 成 %d%% 伤 害， 如 果 此 次 攻 击 命 中， 那 么 你 将 会 发 动 2 次 武 器 暴 击， 每 击 分 别 造 成 %d%% 基 础 伤 害。]]):
		format(100 * self:combatTalentWeaponDamage(t, 0.8, 1.3, self:getTalentLevel(self.T_SHIELD_EXPERTISE)), 100 * self:combatTalentWeaponDamage(t, 0.8, 1.3))
	end,
}

registerTalentTranslation{
	id = "T_SHIELD_WALL",
	name = "盾墙",
	info = function (self,t)
		return ([[进 入 防 御 姿 态， 提 高 %d 闪 避 、 %d 护 甲 值 和 %d 格挡值。
		 受 敏 捷 影 响， 闪 避 和 护 甲 值 增 益 有 额 外 加 成。
		 受 力 量 影 响 格 挡 值 有 额 外 加 成。
		另 外 它 同 时 也 会 提 供 %d%% 震 慑 和 击 退 免 疫。]]):
		format(t.getDefense(self, t), t.getArmor(self, t), t.getBlock(self, t), 100*t.stunKBresist(self, t))
	end,

}

registerTalentTranslation{
	id = "T_REPULSION",
	name = "盾牌猛击",
	info = function(self, t)
		return ([[用 盾 牌 猛 击 周 围  所 有 敌 人，造 成 %d%% 盾 牌 伤 害 并 击 退 %d 格。
		此 外 所 有 怪 物 被 击 退 时 也 会 被 眩 晕 %d 回 合。 
		该 技 能 命 中 时 将 刷 新 冲 锋 的 冷 却。
		击 退 距 离 受 技 能 等 级 加 成。
		眩 晕 时 间 受 力 量 加 成。]]):format(t.getShieldDamage(self, t)*100, t.getDist(self, t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHIELD_EXPERTISE",
	name = "盾牌专精",
	info = function(self, t)
		return ([[当 你 用 盾 牌 攻 击 时 提 高 你 的 伤 害 和 闪 避， 并 提 高 法 术 豁 免（ +%d ） 和 物 理 豁 免（ +%d ）。]]):format(t.getSpell(self, t), t.getPhysical(self, t))
	end,
}

registerTalentTranslation{
	id = "T_LAST_STAND",
	name = "破釜沉舟",
	info = function(self, t)
		local hp = self:isTalentActive(self.T_LAST_STAND)
		if hp then
			hp = t.lifebonus(self, t, hp.base_life)
		else
			hp = t.lifebonus(self,t)
		end
		return ([[在 走 投 无 路 的 局 面 下， 你 鼓 舞 自 己， 提 高 %d 点 闪 避 与 护 甲 ，提 高 %d 点 当 前 及 最 大 生 命 值 ， 但 是 这 会 使 你 无 法 移 动。 
		你 的 坚 守 让 你 集 中 精 力 于 对 手 的 每 一 次 进 攻， 让 你 能 承 受 原 本 致 命 的 伤 害。 你 只 有 在 生 命 值 下 降 到 -%d 时 才 会 死 亡。
		受 敏 捷 影 响 ， 闪 避 和 护 甲 有 额 外 加 成 。
		受 体 质 和 最 大 生 命 值 影 响， 生 命 值 增 益 有 额 外 加 成。]]):
		format(t.getDefense(self, t), hp, hp)
	end,
}


return _M
