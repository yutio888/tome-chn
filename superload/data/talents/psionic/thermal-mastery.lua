local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TRANSCENDENT_PYROKINESIS",
	name = "卓越热能",
	info = function(self, t)
		return ([[在 %d 回 合 中 你 的 热 能 突 破 极 限， 增 加 你 的 火 焰 和 寒 冷 伤 害 %d%% ， 火 焰 和 寒 冷 抗 性 穿 透 %d%% 。
		额 外 效 果：
		重 置 热 能 护 盾， 热 能 吸 取， 热 能 光 环 和 意 念 风 暴 的 冷 却 时 间。
		根 据 情 况， 热 能 光 环 获 得 其 中 一 种 强 化： 热 能 光 环 的 半 径 增 加 为 2 格。 你 的 所 有 武 器 获 得 热 能 光 环 的 伤 害 加 成。
		你 的 热 能 护 盾 获 得 100%% 的 吸 收 效 率， 并 可 以 吸 收 两 倍 伤 害。
		意 念 风 暴 附 带 火 焰 冲 击 效 果。
		热 能 吸 取 将 会 降 低 敌 人 的 伤 害 %d%% 。
		热 能 打 击 的 第 二 次 寒 冷 / 冻 结 攻 击 将 会 产 生 半 径 为 1 的 爆 炸。
		受 精 神 强 度 影 响， 伤 害 和 抗 性 穿 透 有 额 外 加 成。
		同 一 时 间 只 有 一 个 超 能 系 技 能 产 生 效 果。]]):format(t.getDuration(self, t), t.getPower(self, t), t.getPenetration(self, t), t.getDamagePenalty(self, t))
	end,
}

registerTalentTranslation{
	id = "T_BRAINFREEZE",
	name = "锁脑极寒",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[迅 速 的 抽 取 敌 人 大 脑 的 热 量， 造 成 %0.1f 寒 冷 伤 害。
		受 到 技 能 影 响 的 生 物 将 被 锁 脑 四 回 合， 随 机 技 能 进 入 冷 却， 并 冻 结 冷 却 时 间。
		受 精 神 强 度 影 响， 伤 害 和 锁 脑 几 率 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.COLD, dam))
	end,
}

registerTalentTranslation{
	id = "T_HEAT_SHIFT",
	name = "热能转移",
	info = function(self, t)
		local dur = t.getDuration(self, t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		return ([[在 半 径 %d 范 围 内， 将 所 有 敌 人 身 上 的 热 量 转 移 到 武 器 上， 把 敌 人 冻 僵 在 地 面， 多 余 的 热 量 则 令 他 们 无 法 使 用 武 器 和 盔 甲。 
		造 成 %0.1f 寒 冷 伤 害 和 %0.1f 火 焰 伤 害， 并 对 敌 人 施 加 定 身 （ 冻 足） 和 缴 械 状 态， 持 续 %d 回 合。
		受 到 两 种 伤 害 影 响 的 单 位 也 会 降 低 %d 护 甲 和 豁 免。
		受 精 神 强 度 影 响，施 加 状 态 的 几 率 和 持 续 时 间 有 额 外 加 成。]]):
		format(rad, damDesc(self, DamageType.COLD, dam), damDesc(self, DamageType.FIRE, dam), dur, t.getArmor(self, t))
	end,
}

registerTalentTranslation{
	id = "T_THERMAL_BALANCE",
	name = "热能平衡",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local dam1 = dam * (self:getMaxPsi() - self:getPsi()) / self:getMaxPsi()
		local dam2 = dam * self:getPsi() / self:getMaxPsi()
		return ([[根 据 当 前 的 意 念 力 水 平， 你 在 火 焰 和 寒 冷 中 寻 求 平 衡。
		你 对 敌 人 施 放 一 次 爆 炸， 根 据 当 前 的 意 念 力 造 成 %0.1f 火 焰 伤 害， 根 据 意 念 力 最 大 值 与 当 前 值 的 差 值 造 成 %0.1f 寒 冷 伤 害， 爆 炸 半 径 为 %d 。
		这 个 技 能 会 使 你 当 前 的 意 念 力 变 为 最 大 值 的 一 半。
		受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, dam2), damDesc(self, DamageType.COLD, dam1), self:getTalentRadius(t))
	end,
}


return _M
