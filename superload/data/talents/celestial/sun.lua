local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SUN_BEAM",
	name = "阳光烈焰",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 召 唤 太 阳 之 力 ， 形 成 一 道 射 线 ， 造 成 %0.1f 点 光 系 伤 害。
		等 级 3 时 射 线 变 得 如 此 强 烈 ， 半 径 2 以 内 的 敌 人 将 被 致 盲 %d 回 合 。
		伤 害 受 法 强 加 成 。]]):
		format(damDesc(self, DamageType.LIGHT, damage), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_PATH_OF_THE_SUN",
	name = "阳光大道",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local damage = t.getDamage(self, t)
		return ([[ 在 你 面 前 出 现 一 条 阳 光 大 道 ， 持 续 5 回 合 。 任 何 站 在 上 面 的 敌 人 每 回 合 受 到 %0.2f 点 光 系 伤 害 。
		 你 站 在 上 面 行 走 不 消 耗 时 间, 也 不 会 触 发 陷 阱。
		 伤 害 受 法 强 加 成 。]]):format(damDesc(self, DamageType.LIGHT, damage / 5), radius)
	end,
}

registerTalentTranslation{
	id = "T_SUN_VENGEANCE",
	name = "阳光之怒",
	info = function(self, t)
		local crit = t.getCrit(self, t)
		local chance = t.getProcChance(self, t)
		return ([[让 阳 光 的 怒 火 充 满 自 身 ， 增 加 %d%% 物 理 和 法 术暴 击 率。
		 每 次 物 理 或 法 术 暴 击 时 ，有 %d%% 几 率 获 得 阳 光 之 怒 效 果 ， 持 续 两 回 合 。
		 当 效 果 激 活 时 ， 你 的 阳 光 烈 焰 变 为 瞬 发 ， 同 时 伤 害 增 加 25%% 。 
		 如 果 阳 光 烈 焰 处 于 冷 却 中， 则 减 少 1 回 合 冷 却 时间 。 
		 该 效 果 一 回 合 至 多 触 发一 次 。 ]]):
		format(crit, chance)
	end,
}

registerTalentTranslation{
	id = "T_SUNCLOAK",
	name = "阳光护体",
	info = function(self, t)
		return ([[ 你 将 自 己 包 裹 在 阳 光 中 ， 保 护 你 6 回 合 。
		 你 的 施 法 速 度 增 加 %d%% ， 法 术 冷 却 减 少 %d%% ， 同 时 一 次 攻 击 不 能 对 你 造 成 超 过 %d%% 最 大 生 命的 伤 害。
		 效 果 受 法 强 加 成 。]]):
		format(t.getHaste(self, t)*100, t.getCD(self, t)*100, t.getCap(self, t))
   end,
}

return _M
