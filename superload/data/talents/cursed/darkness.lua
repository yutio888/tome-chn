local _M = loadPrevious(...)

local function getDamageIncrease(self)
	local total = 0
		
	local t = self:getTalentFromId(self.T_CREEPING_DARKNESS)
	if t then total = total + self:getTalentLevelRaw(t) end
	t = self:getTalentFromId(self.T_DARK_VISION)
	if t then total = total + self:getTalentLevelRaw(t) end
	t = self:getTalentFromId(self.T_DARK_TORRENT)
	if t then total = total + self:getTalentLevelRaw(t) end
	t = self:getTalentFromId(self.T_DARK_TENDRILS)
	if t then total = total + self:getTalentLevelRaw(t) end
	
	return self:combatScale(total, 5, 1, 40, 20) --I5
--I5	return total * 2
end

registerTalentTranslation{
	id = "T_CREEPING_DARKNESS",
	name = "黑暗之雾",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		local darkCount = t.getDarkCount(self, t)
		local damageIncrease = getDamageIncrease(self)
		return ([[一 股 黑 暗 之 雾 在 目 标 点 范 围 内 %d 个 方 向 蔓 延 半 径 %d 码。 黑 暗 之 雾 造 成 %d 点 伤 害， 阻 挡 未 掌 握 黑 暗 视 觉 或 其 他 魔 法 视 觉 能 力 目 标 的 视 线。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。 你 对 任 何 进 入 黑 暗 之 雾 的 人 造 成 +%d%% 点 伤 害。]]):format(darkCount, radius, damage, damageIncrease)
	end,
}

registerTalentTranslation{
	id = "T_DARK_VISION",
	name = "黑暗视觉",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local movementSpeedChange = t.getMovementSpeedChange(self, t)
		local damageIncrease = getDamageIncrease(self)
		return ([[你 的 眼 睛 穿 过 黑 暗 并 发 现 隐 藏 在 黑 暗 里 的 敌 人。 
		 你 的 视 线 同 样 可 以 穿 过 黑 暗 之 雾 看 到 %d 的 半 径 范 围。 同 时 黑 暗 之 雾 极 大 的 提 高 你 的 步 伐。 
		（ 在 黑 暗 之 雾 中 增 加 你 +%d%% 移 动 速 度） 
		 你 对 任 何 进 入 黑 暗 之 雾 的 人 造 成 +%d%% 点 伤 害。]]):format(range, movementSpeedChange * 100, damageIncrease)
	end,
}

registerTalentTranslation{
	id = "T_DARK_TORRENT",
	name = "黑暗迸发",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local damageIncrease = getDamageIncrease(self)
		return ([[向 敌 人 发 射 一 股 灼 热 的 黑 暗 能 量， 造 成 %d 点 伤 害。 黑 暗 能 量 有 25%% 概 率 致 盲 目 标 3 回 合 并 使 它 们 丢 失 当 前 目 标。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。 
		 你 对 任 何 进 入 黑 暗 之 雾 的 人 造 成 +%d%% 点 伤 害。]]):format(damDesc(self, DamageType.DARKNESS, damage), damageIncrease)
	end,
}

registerTalentTranslation{
	id = "T_DARK_TENDRILS",
	name = "黑暗触手",
	info = function(self, t)
		local pinDuration = t.getPinDuration(self, t)
		local damage = t.getDamage(self, t)
		local damageIncrease = getDamageIncrease(self)
		return ([[伸 出 黑 暗 触 手 攻 击 你 的 敌 人 并 使 它 们 在 黑 暗 里 定 身 %d 回 合。 当 黑 暗 触 手 移 动 时， 黑 暗 之 雾 会 跟 随 蔓 延。 
		 每 回 合 黑 暗 会 造 成 %d 点 伤 害。 
		 受 精 神 强 度 影 响， 伤 害 有 额 外 加 成。 你 对 任 何 进 入 黑 暗 之 雾 的 人 造 成 +%d%% 点 伤 害。]]):format(pinDuration, damage, damageIncrease)
	end,
}




return _M
