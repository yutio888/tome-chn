local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CHANT_OF_FORTITUDE",
	name = "坚韧赞歌",
	info = function(self, t)
		local saves = t.getResists(self, t)
		local life = t.getLifePct(self, t)
		return ([[颂 赞 日 之 荣 耀 ，使 你 获 得 %d 精 神 豁 免 ，并 增 加 %0.1f%% 最 大 生 命 值 （当 前 加 成 ：%d ）。
		 同 时 只 能 激 活 一 种 赞 歌 。
		 效 果 受 法 术 强 度 加 成。
		 ]]):
		format(saves, life*100, life*self.max_life)
	end,
}

registerTalentTranslation{
	id = "T_CHANT_OF_FORTRESS",
	name = "防御赞歌",
	info = function (self,t)
		local physicalresistance = t.getPhysicalResistance(self, t)
		local saves = t.getResists(self, t)
		return ([[颂 赞 日 之 荣 耀 ，使 你 获 得 %d 物 理 抗 性 ，%d 物 理 豁 免 ，%d 护 甲 与 15%% 护 甲 硬 度 。
		 同 时 只 能 激 活 一 种 赞 歌 。
		 效 果 受 法 术 强 度 加 成。]]):
		format(physicalresistance, saves, physicalresistance)
	end,
}

registerTalentTranslation{
	id = "T_CHANT_OF_RESISTANCE",
	name = "元素赞歌",
	info = function(self, t)
		local resists = t.getResists(self, t)
		local saves = t.getSpellResists(self, t)
		local range = -t.getDamageChange(self, t)
		return ([[颂 赞 日 之 荣 耀 ，使 你 获 得 %d 火 焰、闪 电、酸 性 和 寒 冷 抗 性 ，%d 法 术 豁 免 ，并 减 少 三 格 外 敌 人 对 你 造 成 的 伤 害 %d%% 。
		 同 时 只 能 激 活 一 种 赞 歌 。
		 效 果 受 法 术 强 度 加 成。]]):
		format(resists, saves, range)
	end,
}

registerTalentTranslation{
	id = "T_CHANT_OF_LIGHT",
	name = "光明赞歌",
	info = function(self, t)
		local damageinc = t.getLightDamageIncrease(self, t)
		local damage = t.getDamageOnMeleeHit(self, t)
		local lite = t.getLite(self, t)
		return ([[颂 赞 日 之 荣 耀 ，使 你 获 得 光 系 与 火 系 充 能， 造 成 %d%% 点 额 外 伤 害。 
		 此 外 它 提 供 你 光 之 护 盾， 对 任 何 攻 击 你 的 目 标 造 成 %0.1f 光 系 伤 害。 
		 你 的 光 照 范 围 同 时 增 加 %d 码。 
		 同 时 只 能 激 活 1 个 圣 歌 ，另 外 此 赞 歌 消 耗 能 量 较 少。 
		 效 果 受 法 术 强 度 加 成。]]):
		format(damageinc, damDesc(self, DamageType.LIGHT, damage), lite)
	end,
}
registerTalentTranslation{
	id = "T_CHANT_ACOLYTE",
	name = "赞歌入门",
	info = function (self,t)
		local ret = ""
		local old1 = self.talents[self.T_CHANT_OF_FORTITUDE]
		local old2 = self.talents[self.T_CHANT_OF_FORTRESS]
		local old3 = self.talents[self.T_CHANT_OF_RESISTANCE]
		self.talents[self.T_CHANT_OF_FORTITUDE] = (self.talents[t.id] or 0)
		self.talents[self.T_CHANT_OF_FORTRESS] = (self.talents[t.id] or 0)
		self.talents[self.T_CHANT_OF_RESISTANCE] = (self.talents[t.id] or 0)
		pcall(function() -- Be very paranoid, even if some addon or whatever manage to make that crash, we still restore values
			local t1 = self:getTalentFromId(self.T_CHANT_OF_FORTITUDE)
			local t2 = self:getTalentFromId(self.T_CHANT_OF_FORTRESS)
			local t3 = self:getTalentFromId(self.T_CHANT_OF_RESISTANCE)
			ret = ([[你 学 会 了 三 种 防 御 赞 歌 ，以 此 咏 唱 对 太 阳 的 赞 颂 ：
		 坚 韧 赞 歌 ：增 加 %d 精 神 豁 免 ， %d%%  最 大 生 命 值 
		 堡 垒 赞 歌 ：增 加 %d 物 理 豁 免 ， %d 物 理 抗 性 ， %d 护 甲 ， 15%%  护 甲 硬 度 
		 元 素 赞 歌 ：增 加 %d 法 术 豁 免 ， %d%%  火 焰 /寒 冷 /闪 电 /酸 性 抗 性 ，减 少 三 格 外 敌 人 对 你 造 成 的 伤 害 %d%%  。
		 你 同 时 只 能 激 活 一 种 赞 歌 。]]):
			format(t1.getResists(self, t1), t1.getLifePct(self, t1)*100, t2.getResists(self, t2), t2.getPhysicalResistance(self, t2), t2.getPhysicalResistance(self, t2), t3.getSpellResists(self, t3), t3.getResists(self, t3), t3.getDamageChange(self, t3))
		end)
		self.talents[self.T_CHANT_OF_FORTITUDE] = old1
		self.talents[self.T_CHANT_OF_FORTRESS] = old2
		self.talents[self.T_CHANT_OF_RESISTANCE] = old3
		return ret
	end,
}
registerTalentTranslation{
	id = "T_CHANT_ILLUMINATE",
	name = "初现光芒",
	info = function (self,t)
		return ([[咏 唱 赞 歌 让 你 沐 浴 在 光 明 中，你 的 体 力 与 法 力 每 回 合 回 复 %0.2f , 并 对 所 有 近 战 攻 击 你 的 敌 人 造 成 %0.2f 光 属 性 伤 害 。
		 效 果 受 法 术 强 度 加 成。]]):format(t.getBonusRegen(self, t), damDesc(self, DamageType.LIGHT, t.getDamageOnMeleeHit(self, t)))
	end,
}
registerTalentTranslation{
	id = "T_CHANT_ADEPT",
	name = "赞歌专家",
	info = function (self,t)
		return ([[咏 唱 赞 歌 的 娴 熟 技 艺 让 光 明 得 以 扩 散， 增 加 %d 光 照 半 径。
		 每 次 你 咏 唱 新 的 赞 歌 时 ，你 将 解 除 自 身 所 有 CT 效 果 ，并 解 除 %d 项 相 应 类 型 的 负 面 状 态 。
		 坚 韧 赞 歌 ：解 除 精 神 负 面 状 态 
		 堡 垒 赞 歌 ：解 除 物 理 负 面 状 态 
		 元 素 赞 歌 ：解 除 魔 法 负 面 状 态 ]]):format(t.getBonusLight(self, t), t.getDebuffCures(self, t))
	end,
}
registerTalentTranslation{
	id = "T_CHANT_RADIANT",
	name = "辉耀绽放",
	info = function (self,t)
		return ([[咏 唱 赞 歌 歌 颂 太 阳 的 热 情 达 到 了 顶 峰 。
		  你 的 赞 歌 现 在 让 你 的 火 焰 与 光 明 伤 害 增 加 %d%% ,同 时 令 你 每 回 合 回 复 %0.2f 正 能 量 。
		  效 果 受 法 术 强 度 加 成 。]]):format(t.getLightDamageIncrease(self, t), t.getBonusRegen(self, t))
	end,
}
return _M