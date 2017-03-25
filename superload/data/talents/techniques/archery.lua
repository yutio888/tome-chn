local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SHOOT",
	name = "射击",
	info = function(self, t)
		return ([[使 用 弓 箭 、 投 石 索 或 者 其 他 什 么 东 西 发 射 ！]])
	end,
}

registerTalentTranslation{
	id = "T_STEADY_SHOT",
	name = "稳固射击",
	info = function (self,t)
		local dam = t.getDamage(self,t)*100
		local chance = t.getChance(self,t)
		return ([[稳 固 地 射 击， 造 成 %d%% 伤 害，同 时 有 %d%% 几 率 标 记 目 标。
如 果 稳 固 射 击 没 有 进 入 冷 却 状 态 ， 将 自 动 代 替 普 通 攻 击 ， 并 进 入 冷 却。]]):
		format(dam, chance)
	end,
}
registerTalentTranslation{
	id = "T_PIN_DOWN",
	name = "强力定身",
	info = function (self,t)
		local dam = t.getDamage(self,t)*100
		local dur = t.getDuration(self,t)
		local mark = t.getMarkChance(self,t)
		local chance = t.getChance(self,t)
		return ([[你 朝 目 标 发 射 定 身 攻 击，造 成 %d%% 伤 害，并 尝 试 将 目 标 定 身 %d 回 合。
		你 对 目 标 的 下 一 发 射 击 或 者 稳 固 射 击 将 增 加 100%% 暴 击 率 与 标 记 几 率 。
		此 次 攻 击 有 20%% 几 率 标 记 目 标。
		定 身 几 率 受 命 中 加 成。]]):
		format(dam, dur, mark, chance)
	end,
}
registerTalentTranslation{
	id = "T_FRAGMENTATION_SHOT",
	name = "爆裂射击",
	info = function (self,t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self,t)*100
		local dur = t.getDuration(self,t)
		local speed = t.getSpeedPenalty(self,t)*100
		local chance = t.getChance(self,t)
		return ([[发 射 命 中 后 爆 裂 成 %d 格 半 径 球 型 范 围 碎 片 的弹 药, 造 成 %d%% 武 器 伤 害 并 致 残 目 标 %d 回 合， 降 低  %d%% 攻 击、施 法 和 精 神 速 度。
		每 个 被 击 中 的 目 标 有 %d%% 几 率 被 标 记。
		致 残 几 率 受 命 中 加 成。]])
		:format(rad, dam, dur, speed, chance)
	end,
}
registerTalentTranslation{
	id = "T_SCATTER_SHOT",
	name = "分散射击",
	info = function (self,t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self,t)*100
		local dur = t.getDuration(self,t)
		local chance = t.getChance(self,t)
		return ([[射 出 弹 药 化 为 %d 格 锥 形 冲 击 波，造 成 %d%% 伤 害 ，被 击 中 的 单 位 将 被 击 退 至 范 围 外 ， 并 被 震 慑 %d 回 合 。
		每 个 被 击 中 的 目 标 有 %d%% 几 率 被 标 记。
		击 退 与 震 慑 几 率 受 命 中 加 成。]])
		:format(rad, dam, dur, chance)
	end,
}
registerTalentTranslation{
	id = "T_HEADSHOT",
	name = "爆头",
	info = function (self,t)
		local dam = t.getDamage(self,t)*100
		local apr = t.getApr(self,t)
		return ([[瞄 准 目 标 头 部 发 射 穿 透 性 弹 药，造 成 %d%% 武 器 伤 害。
此 次 攻 击 额 外 获 得 %d 护 甲 穿 透 和 100 命 中，且 能 穿 透 目 标 以 外 单 位。
只 能 对 被 标 记 的 单 位 使 用，使 用 将 消 耗 掉 标 记。 
护 甲 穿 透 受 敏 捷 加 成 。]]):
		format(dam, apr)
	end,
}
registerTalentTranslation{
	id = "T_VOLLEY",
	name = "齐射",
	info = function (self,t)
		local rad = self:getTalentRadius(t)
		local dam = t.getDamage(self,t)*100
		return ([[你 向 天 空 发 射 无 数 弹 药 ， 如 箭 雨 般 落 向 目 标 ， 造 成 %d%% 伤 害 ， 杀 伤  半 径 %d 格 。
如 果 中 心 目 标 被 标 记 ， 你 将 消 耗 其 标 记 ， 不 消 耗 弹 药 发 射 额 外 齐 射 一 轮 ， 造 成 %d%% 伤 害 。]])
		:format(dam, rad, dam*0.75)
	end,
}
registerTalentTranslation{
	id = "T_CALLED_SHOTS",
	name = "精巧射击",
	info = function (self,t)
		local dam = t.getDamage(self,t)*100
		local dur = t.getDuration(self,t)
		return ([[你 朝 目 标 的 喉 咙 （ 或 者 类 似 部 位 ）射 击，造 成 %d%% 武 器 伤 害 并 沉 默 %d 回 合。
如 果 目 标 被 标 记 ， 则 消 耗 标 记 并 额 外 向 目 标 的 手 臂 与 大 腿 （ 或 者 类 似 部 位 ） 射 击 两 次 ， 造 成 %d%% 伤 害 , 降 低 其 50 %% 移 动 速 度 ，同 时 使 其 不 能 使 用 武 器 。
状 态 效 果 几 率 受 命 中 加 成 。]]):
		format(dam, dur, dam*0.25)
	end,
}
registerTalentTranslation{
	id = "T_BULLSEYE",
	name = "靶心",
	info = function (self,t)
		local speed = t.getSpeed(self,t)*100
		local nb = t.getTalentCount(self,t)
		local cd = t.getCooldown(self,t)
		return ([[每 次 消 耗 标 记 时 ，获 得 %d%% 攻 击 速 度 2 回 合，并 减 少 %d 个 战 斗 技 巧 系 技 能 冷 却 时 间 %d 回 合。]]):
		format(speed, nb, cd)
	end,
}
registerTalentTranslation{
	id = "T_RELAXED_SHOT",
	name = "宁神射击",
	info = function (self,t)
		return ([[你 射 出 放 松 的 一 箭, 造 成 %d%% 伤 害，同 时 回 复 %d 体 力。
		]]):format(self:combatTalentWeaponDamage(t, 0.5, 1.1) * 100, 12 + self:getTalentLevel(t) * 8)
	end,
}
registerTalentTranslation{
	id = "T_CRIPPLING_SHOT",
	name = "致残射击",
	info = function (self,t)
		return ([[你 射 出 致 残 一 箭 ,造 成 %d%% 伤 害，并 降 低 目 标 %d%% 速 度 7 回 合 。
		状 态 效 果 受 命 中 加 成。]]):format(self:combatTalentWeaponDamage(t, 1, 1.5) * 100, util.bound((self:combatAttack() * 0.15 * self:getTalentLevel(t)) / 100, 0.1, 0.4) * 100)
	end,
}
registerTalentTranslation{
	id = "T_PINNING_SHOT",
	name = "定身射击",
	info = function (self,t)
		return ([[你 射 出 定 身 一 箭 , 造 成 %d%% 伤 害，并 定 身 目 标 %d 回 合。
		定 身 几 率 受 敏 捷 加 成 。]])
		:format(self:combatTalentWeaponDamage(t, 1, 1.4) * 100,
		t.getDur(self, t))
	end,
}