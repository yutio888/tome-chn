local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SKIRMISHER_SLING_SUPREMACY",
	name = "投石索精通",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local reloads = t.ammo_mastery_reload(self, t)
		return ([[增 加 物 理 强 度 %d 并 增 加 使 用 投 石 索 的 武 器 伤 害 %d%% 。
		同 时 增 加 每 回 合 的 装 填 量 %d 。]]):format(damage, inc * 100, reloads)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_SWIFT_SHOT",
	name = "快速投射",
	info = function(self, t)
		return ([[发 射 一 枚 快 速 的 石 弹， 造 成 %d%% 伤 害， 攻 击 速 度 是 你 普 通 攻 击 的 两 倍。 移 动 将 会 降 低 技 能 冷 却 1 回 合。]])
			:format(t.getDamage(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_HURRICANE_SHOT",
	name = "飓风连射",
	info = function(self, t)
		return ([[最 多 发 射 %d 颗 弹 矢， 每 颗 对 锥 形 范 围 内 的 敌 人 造 成 %d%% 武 器 伤 害。 每 个 敌 人 只 能 被 攻 击 1 次 （ 当 技 能 等 级 在 3 级 或 更 高 时 为 2 次）。 使 用 快 速 投 射 技 能 会 降 低 冷 却 时 间 1 回 合。]])
			:format(t.limit_shots(self, t),
							t.damage_multiplier(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_SKIRMISHER_BOMBARDMENT",
	name = "连环炮击",
	info = function(self, t)
		return ([[当 技 能 激 活 时， 你 的 基 础 射 击 技 能 将 发 射 %d 石 弹， 每 颗 造 成 %d%% 远 程 伤 害， 每 次 攻 击 消 耗 %d 体 力。]])
		:format(t.bullet_count(self, t), t.damage_multiplier(self, t) * 100, t.shot_stamina(self, t))
	end,
}


return _M
