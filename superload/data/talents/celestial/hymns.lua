local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HYMN_OF_SHADOWS",
	name = "暗影圣诗",
	info = function (self,t)
		return ([[赞 颂 月 之 荣 耀 ，使 你 获 得 暗 影 之 灵 敏 。
		 移 动 速 度 增 加 %d%% ,施 法 速 度 增 加 %d%% ,闪 避 增 加 %d 。
		 同 时 只 能 激 活 一 种 圣 诗 。
		 效 果 受 法 术 强 度 加 成 。]]):
		format(t.moveSpeed(self, t), t.castSpeed(self, t), t.evade(self, t))
	end,
}

registerTalentTranslation{
	id = "T_HYMN_OF_DETECTION",
	name = "侦查圣诗",
	info = function(self, t)
		local invis = t.getSeeInvisible(self, t)
		local stealth = t.getSeeStealth(self, t)
		return ([[赞 美 月 之 荣 耀， 使 你 能 察 觉 潜 行 单 位（ +%d 侦 测 等 级） 和 隐 形 单 位（ +%d 侦 测 等 级）。 
		 你 攻 击 不 可 见 目 标 时 无 惩  罚 ，同 时 暴 击 造 成 %d%% 额 外 伤 害 。 
		 同 时 只 能 激 活 1 个 圣 诗。 
		 受 法 术 强 度 影 响， 侦 测 等 级 和 伤 害 有 额 外 加 成。]]):
		format(stealth, invis, t.critPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_HYMN_OF_PERSEVERANCE",
	name = "坚毅圣诗",
	info = function(self, t)
		local immunities = t.getImmunities(self, t)
		return ([[赞 美 月 之 荣 耀， 增 加 你 %d%% 震 慑、 致 盲 和 混 乱 抵 抗。 
		 同 时 只 能 激 活 1 个 圣 诗。 ]]):
		format(100 * (immunities))
	end,
}

registerTalentTranslation{
	id = "T_HYMN_OF_MOONLIGHT",
	name = "月光圣诗",
	info = function(self, t)
		local targetcount = t.getTargetCount(self, t)
		local damage = t.getDamage(self, t)
		local drain = t.getNegativeDrain(self, t)
		return ([[当 此 技 能 激 活 时， 会 在 你 身 边 产 生 1 片 影 之 舞 跟 随 你。 
		 每 回 合 随 机 向 附 近 5 码 半 径 范 围 内 的 %d 个 敌 人 发 射 暗 影 射 线， 造 成 1 到 %0.2f 伤 害。 
		 这 个 强 大 法 术 的 每 道 射 线 会 消 耗 %0.1f 负 能 量， 如 果 能 量 值 过 低 则 不 会 发 射 射 线。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(targetcount, damDesc(self, DamageType.DARKNESS, damage), drain)
	end,
}
registerTalentTranslation{
	id = "T_HYMN_ACOLYTE",
	name = "圣诗入门",
	info = function (self,t)
		local ret = ""
		local old1 = self.talents[self.T_HYMN_OF_SHADOWS]
		local old2 = self.talents[self.T_HYMN_OF_DETECTION]
		local old3 = self.talents[self.T_HYMN_OF_PERSEVERANCE]
		self.talents[self.T_HYMN_OF_SHADOWS] = (self.talents[t.id] or 0)
		self.talents[self.T_HYMN_OF_DETECTION] = (self.talents[t.id] or 0)
		self.talents[self.T_HYMN_OF_PERSEVERANCE] = (self.talents[t.id] or 0)
		pcall(function() -- Be very paranoid, even if some addon or whatever manage to make that crash, we still restore values
			local t1 = self:getTalentFromId(self.T_HYMN_OF_SHADOWS)
			local t2 = self:getTalentFromId(self.T_HYMN_OF_DETECTION)
			local t3 = self:getTalentFromId(self.T_HYMN_OF_PERSEVERANCE)
			ret = ([[你 学 会 了 三 种 防 御 圣 诗 ，以 此 咏 唱 对 月 亮 的 赞 颂 ：
		 暗 影 圣 诗 ：增 加 %d%% 移 动 速 度 ， %d%%  施 法 速 度， %d 闪避 。 
		 侦 察 圣 诗 ：增 加 %d 潜 行 侦 察 ， %d 隐 身 侦 察 ， %d%% 暴 击 伤 害 
		 坚 毅 圣 诗 ：增 加 %d%% 震 慑 、混 乱、 致 盲 抗 性。
		 你 同 时 只 能 激 活 一 种 赞 歌 。]]):
			format(t1.moveSpeed(self, t1), t1.castSpeed(self, t1), t1.evade(self, t1), t2.getSeeStealth(self, t2), t2.getSeeInvisible(self, t2), t2.critPower(self, t2), t3.getImmunities(self, t3)*100)
		end)
		self.talents[self.T_HYMN_OF_SHADOWS] = old1
		self.talents[self.T_HYMN_OF_DETECTION] = old2
		self.talents[self.T_HYMN_OF_PERSEVERANCE] = old3
		return ret
	end,
}
registerTalentTranslation{
	id = "T_HYMN_INCANTOR",
	name = "暗影临近",
	info = function (self,t)
		return ([[圣 诗 让 暗 影 集 中 在 你 身 边 ， 你 的 黑 暗 伤 害 增 加  %d%% ，并 对 所 有 近 战 攻 击 你 的 敌 人 造 成 %0.2f 暗 属 性 伤 害 。
		效 果 受 法 术 强 度 加 成 。]]):format(t.getDarkDamageIncrease(self, t), damDesc(self, DamageType.DARKNESS, t.getDamageOnMeleeHit(self, t)))
	end,
}
registerTalentTranslation{
	id = "T_HYMN_ADEPT",
	name = "圣诗专家",
	info = function (self,t)
		return ([[咏 唱 圣 诗 的 娴 熟 技 艺 让 黑 暗 不 再 阻 碍 你 的 视 线， 增 加 %d 暗 视 半 径。
		 每 次 你 结 束 旧 的 圣 诗 时 ，你 将 获 得 圣 诗 提 供 的 增 益 效 果 。
		 暗 影 圣 诗 ：增 加 %d%% 移 动 速 度 ，持 续 1 回 合。 
		 侦 察 圣 诗 ：隐 身 ( %d 强 度) 持 续 %d 回 合。 
		 坚 毅 圣 诗 ：护 盾 ( %d 强 度) 持 续 %d 回 合。]]):format(t.getBonusInfravision(self, t), t.getSpeed(self, t), 
			t.invisPower(self, t), t.invisDur(self, t), t.shieldPower(self, t), t.shieldDur(self, t))
	end,
}
registerTalentTranslation{
	id = "T_HYMN_NOCTURNALIST",
	name = "暗夜流光",
	info = function (self,t)
		return ([[咏 唱 圣 诗 歌 颂 月 亮 的 热 情 达 到 了 顶 峰 。每 回 合 回 复 %0.2f 负 能 量。
		你 的 圣 诗 自 动 产 生 阴 影 射 线 攻 击 周 围 5 格 内 至 多 %d 个 敌 人 ， 造 成 1 到  %0.2f 伤 害， 同 时 有 20%% 几 率 触 发  致 盲 效 果 。
		这 项 效 果 每 产 生 一 发 射 线 将 抽 取 %0.1f 负 能 量 ， 能 量 过 低 时 无 法 产 生 射 线 。
		效 果 受 法 术 强 度 加 成 。]]):format(t.getBonusRegen(self, t), t.getTargetCount(self, t), damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), t.getNegativeDrain(self, t))
	end,
}