local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ILLUMINATE",
	name = "照明术",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local turn = t.getBlindPower(self, t)
		local dam = t.getDamage(self, t)
		return ([[制 造 一 个 发 光 的 球 体， 照 亮 %d 码 半 径 范 围 区 域。 
		 在 等 级 3 时， 它 同 时 可 以 致 盲 看 到 它 的 人（ 施 法 者 除 外） %d 回 合。 
		 在 等 级 4 时， 它 会 造 成 %0.2f 点 光 系 伤 害。]]):
		format(radius, turn, damDesc(self, DamageType.LIGHT, dam))
	end,
}

registerTalentTranslation{
	id = "T_BLUR_SIGHT",
	name = "模糊视觉",
	info = function(self, t)
		local defence = t.getDefense(self, t)
		return ([[施 法 者 的 形 象 变 的 模 糊 不 清， 增 加 %d 点 闪 避。 
		 受 法 术 强 度 影 响， 闪 避 有 额 外 加 成。]]):
		format(defence)
	end,
}

registerTalentTranslation{
	id = "T_PHANTASMAL_SHIELD",
	name = "幻象护盾",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[施 法 者 被 幻 象 护 盾 所 包 围。 若 你 受 到 近 战 打 击， 此 护 盾 会 对 攻 击 者 造 成 %d 点 光 系 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.LIGHT, damage))
	end,
}

registerTalentTranslation{
	id = "T_INVISIBILITY",
	name = "隐形",
	info = function(self, t)
		local invisi = t.getInvisibilityPower(self, t)
		return ([[施 法 者 从 视 线 中 淡 出， 额 外 增 加 %d 点 隐 形 强 度。 
		 注 意： 你 必 须 取 下 装 备 中 的 灯 具， 否 则 你 仍 然 会 被 轻 易 发 现。 
		 由 于 你 变 的 不 可 见， 你 脱 离 了 相 位 现 实。 你 的 所 有 攻 击 降 低 70%% 伤 害。 
		 当 此 技 能 激 活 时， 它 会 持 续 消 耗 你 的 法 力（ 2 法 力 / 回 合）。 
		 受 法 术 强 度 影 响， 隐 形 强 度 有 额 外 加 成。]]):
		format(invisi)
	end,
}


return _M
