local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FIRE_INFUSION",
	name = "火焰充能",
	info = function(self, t)
		local daminc = t.getIncrease(self, t)
		return ([[给 炼 金 炸 弹 附 加 火 焰 能 量, 使 敌 人 进 入 灼 烧 状 态
		此 外， 你 造 成 的 所 有 火 焰 伤 害 增 加 %d%% 。]]):
		format(daminc)
	end,
}

registerTalentTranslation{
	id = "T_SMOKE_BOMB",
	name = "烟雾弹",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[投 掷 一 枚 烟 雾 弹， 遮 住 一 条 直 线 的 视 野。 %d 回 合 后 烟 雾 会 消 失。 
		 若 烟 雾 中 存 在 处 于 引 燃 状 态 的 生 物， 则 会 将 烟 雾 消 耗 一 空 并 在 所 有 目 标 身 上 附 加 引 燃 效 果， 持 续 时 间 增 加 %d 回 合。 
		 受 法 术 强 度 影 响， 持 续 时 间 有 额 外 加 成。]]):
		format(duration, math.ceil(duration / 3))
	end,
}

registerTalentTranslation{
	id = "T_FIRE_STORM",
	name = "火焰风暴",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[制 造 一 片 激 烈 的 火 焰 风 暴， 每 回 合 对 施 法 者 周 围 3 码 范 围 内 的 目 标 造 成 %0.2f 火 焰 伤 害， 持 续 %d 回 合。 
		 你 精 确 的 操 控 火 焰 风 暴， 阻 止 它 伤 害 你 的 队 友。 
		 受 法 术 强 度 影 响， 伤 害 和 持 续 时 间 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.FIRE, damage), duration)
	end,
}

registerTalentTranslation{
	id = "T_BODY_OF_FIRE",
	name = "火焰之躯",
	info = function(self, t)
		local onhitdam = t.getFireDamageOnHit(self, t)
		local insightdam = t.getFireDamageInSight(self, t)
		local res = t.getResistance(self, t)
		local manadrain = t.getManaDrain(self, t)
		return ([[将 你 的 身 体 转 化 为 纯 净 的 火 焰， 增 加 你 %d%% 火 焰 抵 抗。 对 任 何 攻 击 你 的 怪 物 造 成 %0.2f 火 焰 伤 害 并 向 附 近 目 标 每 回 合 随 机 射 出 %d 个 缓 慢 移 动 的 火 焰 球， 每 个 火 球 造 成 %0.2f 火 焰 伤 害。 
		 当 此 技 能 激 活 时， 每 回 合 消 耗 %0.2f 法 力 值。 
		 受 法 术 强 度 影 响， 伤 害 和 火 焰 抵 抗 有 额 外 加 成。]]):
		format(res,onhitdam, math.floor(self:getTalentLevel(t)), insightdam,-manadrain)
	end,
}


return _M
