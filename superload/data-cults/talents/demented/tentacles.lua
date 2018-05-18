local _M = loadPrevious(...)
local Object = require "mod.class.Object"

registerTalentTranslation{
	id = "T_MUTATED_HAND",
	name = "异变之手",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local allow_tcombat = t.canTentacleCombat(self, t)
		local tcombat = {combat=t.getTentacleCombat(self, t, true)}
		local tcombatdesc = Object:descCombat(self, tcombat, {}, "combat")
		return ([[你 的 左 手 异 变 成 为 大 量 的 恶 心 触 手 。
		副 手 空 闲 时 ， 当 使 用 普 通 攻 击 ， 触 手 会 自 动 攻 击 目 标 以 及 目 标 同 侧 的 其 他 单 位 。
		物 理 强 度 提 高 %d ， 触 手 伤 害 提 高 %d 。
		每 次 触 手 攻 击 时 ， 获 得 %d 疯 狂 值 。
		附 近 有 #{italic}# 普通人 #{normal}# 时 会 自 动 生 成 微 弱 的 心 灵 护 盾  ， 避 免 被 他 们 发 现 你 的 恐 魔 形 态。
		你 的 触 手 当 前 属 性 为 %s :
		%s]]):
		format(damage, 100*inc, t.getInsanityBonus(self, t), allow_tcombat and "" or ", #CRIMSON# 由 于 副 手 非 空 闲 当 前 无 法 使 用。d#WHITE#", tostring(tcombatdesc))
	end,
}

registerTalentTranslation{
	id = "T_LASH_OUT",
	name = "旋风鞭挞",
	info = function(self, t)
		return ([[飞 速 旋 转 ， 伸 展 武 器 对 周 围 单 位 造 成 %d%% 武 器 伤 害 ， 并 且 伸 展 触 手 对 3 码 内 单 位 造 成 %d%% 触 手 伤 害 。
		如 果 武 器 击 中 敌 人 ， 你 获 得 %d 疯 狂 值 。
		如 果 触 手 击 中 敌 人 ， 你 获 得 %d 疯 狂 值。
		#YELLOW_GREEN# 当 触 手 处 于 缠 绕 状 态 : #WHITE# 你 的 触 手 攻 击 以 被 缠 绕 目 标 为 中 心 展 开 ， 攻 击 范 围 只 有 1 码 ， 但 是 会 使 被 击 中 单 位 眩 晕 5 回 合。]]):
		format(100 * t.getDamage(self, t), 100 * t.getDamageTentacle(self, t), t.getMHInsanity(self, t), t.getTentacleInsanity(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TENDRILS_ERUPTION",
	name = "触手地狱",
	info = function(self, t)
		return ([[你 的 触 手 钻 入 地 下 ， 分 布 到 %d 码 范 围 的 目 标 区 域。
		该 区 域 喷 发 出 大 量 黑 色 触 手， 对 区 域 内 所 有 敌 人 造 成 %d%% 触 手 伤 害。
		被 触 手 击 中 的 生 物 需 要 进 行 法 术 检 定 ， 检 定 失 败 将 被 麻 痹 ，5 回 合 内 伤 害 降 低 %d%% 。
		如 果 有 敌 人 被 触 手 击 中 ， 你 获 得 %d 疯 狂 值 。
		#YELLOW_GREEN# 当 触 手 处 于 缠 绕 状 态 : #WHITE# 触 手 对 缠 绕 对 象 连 续 突 击 ， 造 成 %d%% 触 手 伤 害 。 如 果 你 与 被 缠 绕 对 象 相 邻 ， 则 进 行 一 次 额 外 的 主 手 打 击 。 技 能 C D 缩 短 为 1 0 回 合 。]]):
		format(self:getTalentRadius(t), t.getDamageTentacle(self, t) * 100, t.getNumb(self, t), t.getInsanity(self, t), t.getDamageTentacle(self, t) * 1.5 * 100)
	end,
}

registerTalentTranslation{
	name = "触手缠绕", 
	id = "T_TENTACLE_CONSTRICT",
	info = function(self, t)
		return ([[伸 展 触 手 缠 绕 一 个 远 处 的 目 标 ， 并 向 你 拖 拽。
		目 标 被 触 手 缠 绕 后 ，可 以 尝 试 向 远 处 移 动 ， 但 是 每 回 合 会 被 拖 回 一 码。
		当 缠 绕 了 敌 人 ， 普 通 攻 击 不 会 额 外 附 加 触 手 攻 击， 但 每 回 合 对 缠 绕 敌 人 造 成 %d%% 触 手 伤 害。
		敌 人 可 以 抵 抗 触 手 拖 拽 ， 但 是 缠 绕 状 态 会 持 续 生 效。
		其 他 触 手 技 能 在 缠 绕 状 态 下 会 发 生 变 化 ， 具 体 请 查 看 相 应 技 能 描 述。]]):
		format(t.getDamageTentacle(self, t) * 100)
	end,
}

return _M
