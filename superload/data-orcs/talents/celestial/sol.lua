local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_SOLAR_ORB",
	name = "日光球",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local cooldownred = t.getCooldownReduction(self, t)
		return ([[发 射 一 个 光 球 造 成 %0.2f 的 光 伤 害 然 后 折 返, 再 次 造 成 相 同 的 伤 害 并 且 当 回 到 你 身 上 的 时 候 减 少 一 半 (%d) 的 冷 却 时 间. 伤 害 随 着 你 的 法 术 强 度 增 加. 球 体 最 多 飞 行 %d 然 后 折 回 你.]]):
		format(damDesc(self, DamageType.LIGHT, damage), cooldownred, self:getTalentRange(t) * 4)
	end,}

registerTalentTranslation{
	id = "T_SOLAR_WIND",
	name = "太阳风",
	info = function(self, t)
		local speed = t.getSpeed(self, t)
		local slow = t.getSlowFromSpeed(speed)
		return ([[开 启 时, 增 加 发 射 出 去 的 抛 射 物 %d%% 速 度, 减 少 射 向 你 的 抛 射 物 %d%% 速 度. 增 加 和 减 少 随 着 你 的 法 术 强 度 提 高.]]):
		format(speed, slow)
	end,}

registerTalentTranslation{
	id = "T_LUCENT_WRATH",
	name = "光 之 愤 怒",
	info = function(self, t)
		local delay = t.getDelay(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[%d 回 合 后, 在 (范 围 %d) 的 目 标 区 域 发 出 一 束 激 光, 造 成  %0.2f 伤 害 并 照 明 区 域.]]):
		format(delay, radius, damDesc(self, DamageType.LIGHT, damage))
		
	end,}

registerTalentTranslation{
	id = "T_LIGHTSPEED",
	name = "光速",
	info = function(self, t)
		local turn = t.getTurn(self, t)
		return ([[立 刻 获 得 %d%% 额 外 回 合.]]):
		format(turn * 100)
	end,}

return _M
