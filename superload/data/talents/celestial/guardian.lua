local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHIELD_OF_LIGHT",
	name = "圣光沁盾",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[使 你 的 盾 牌 充 满 光 系 能 量， 每 次 受 到 攻 击 会 消 耗 2 点 正 能 量 并 恢 复 %0.2f 生 命 值。 
		 如 果 你 没 有 足 够 的 正 能 量， 此 效 果 无 法 触 发。 
		 同 时 ，每 回 合 一 次 ，近 战 攻 击 命 中 时 会 附 加 一 次 盾 击 ， 造 成 %d%% 光 系 伤 害。
		 受 法 术 强 度 影 响， 恢 复 量 有 额 外 加 成。]]):
		format(heal, t.getShieldDamage(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_BRANDISH",
	name = "剑盾之怒",
	info = function(self, t)
		local weapondamage = t.getWeaponDamage(self, t)
		local shielddamage = t.getShieldDamage(self, t)
		local lightdamage = t.getLightDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[用 你 的 武 器 对 目 标 造 成 %d%% 伤 害， 同 时 盾 击 目 标 造 成 %d%% 伤 害。 如 果 盾 牌 击 中 目 标， 则 会 产 生 光 系 爆 炸， 对 范 围 内 除 你 以 外 的 所 有 目 标 造 成 %0.2f 光 系 范 围 伤 害（ 半 径 %d 码） 并 照 亮 受 影 响 区 域。 
		 受 法 术 强 度 影 响， 光 系 伤 害 有 额 外 加 成。]]):
		format(100 * weapondamage, 100 * shielddamage, damDesc(self, DamageType.LIGHT, lightdamage), radius)
	end,
}

registerTalentTranslation{
	id = "T_RETRIBUTION",
	name = "惩戒之盾",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local absorb_string = ""
		if self.retribution_absorb and self.retribution_strike then
			absorb_string = ([[#RED#Absorb Remaining: %d]]):format(self.retribution_absorb)
		end
		return ([[吸 收 你 收 到 的 一 半 伤 害。 一 旦 惩 戒 之 盾 吸 收 %0.2f 伤 害 值， 它 会 产 生 光 系 爆 炸， 在 %d 码 半 径 范 围 内 造 成 等 同 吸 收 值 的 伤 害 并 中 断 技 能 效 果。 
		 受 法 术 强 度 影 响， 伤 害 吸 收 值 有 额 外 加 成。
		%s]]):
		format(damage, self:getTalentRange(t), absorb_string)
	end,
}
registerTalentTranslation{
	id = "T_CRUSADE",
	name = "十字军打击",
	info = function(self, t)
		local weapon = t.getWeaponDamage(self, t)*100
		local shield = t.getShieldDamage(self, t)*100
		local cooldown = t.getCooldownReduction(self, t)
		local cleanse = t.getDebuff(self, t)
		return ([[你 用 武 器 攻 击 造 成 %d%% 光 系 伤 害 ， 再 用 盾 牌 攻 击 造 成 %d%% 光 系 伤 害。
			如 果 第 一 次 攻 击 命 中 ， 随 机 %d 个 技 能 cd 时 间 减 1 。
			如 果 第 二 次 攻 击 命 中， 除 去 你 身 上 至 多 %d 个 debuff。]]):
		format(weapon, shield, cooldown, cleanse)
	end,
}

return _M
