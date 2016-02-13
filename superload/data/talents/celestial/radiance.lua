local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RADIANCE",
	name = "光辉",
	info = function(self, t)
		return ([[你 的 体 内 充 满 了 阳 光 ， 你 的 身 体 会 发 光 ，半 径 %d 。
		 你 的 眼 睛 适 应 了 光 明 ， 获 得 %d%% 目 盲 免 疫 。
		 光 照 超 过 你 的 灯 具 时 取 代 之 ， 不 与 灯 具 叠 加 光 照 。
		]]):
		format(radianceRadius(self), t.getResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ILLUMINATION",
	name = "照明",
	info = function(self, t)
		return ([[你 的 光 辉 让 你 能 看 见 平 时 看 不 见 的 东 西 。
		 所 有 在 你 光 辉 范 围 内 的 敌 人 减 少 %d 点 潜 行 和 隐 身 强 度 ， 减 少 %d 闪 避 ， 同 时 不 可 见 带 来 的 闪 避 加 成 无 效 。 
		 效 果 受 法 强 加 成。]]):
		format(t.getPower(self, t), t.getDef(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SEARING_SIGHT",
	name = "灼烧",
	info = function(self, t)
		return ([[ 你 的 光 辉 变 得 如 此 强 烈 ， 所 有 受 到 照 射 的 敌 人 都 会 被 灼 伤 ， 受 到 %0.1f 点 光 系 伤 害 ( 随 距 离 减 少)。
		 等 级 4 时， 有 %d%% 几 率 眩 晕 目 标 3 回 合。
		 伤 害 受 法 强 加 成 。]]):
		format(damDesc(self, DamageType.LIGHT, t.getDamage(self, t)), t.getDaze(self, t))
	end,
}

registerTalentTranslation{
	id = "T_JUDGEMENT",
	name = "裁决",
	info = function(self, t)
		return ([[向 光 辉 覆 盖 的 敌 人 发 射 光 明 球 ， 每 个 球 会 缓 慢 移 动 ， 直 到 命 中 ， 同 时 对 路 径 上 的 障 碍 物 造 成 %d 点 光 系 伤 害。
		 当 击 中 目 标 时 ， 球 体 会 爆 炸 ， 造 成 %d 点 光 系 伤 害 ， 同 时 50%% 的 伤 害 会 治 疗 你 。
		 使 用 这 项 技 能 会 让 光 辉 照 明 范 围 减 少 至 1 ， 持 续 5 回 合 。]]):
		format(t.getMoveDamage(self, t), t.getExplosionDamage(self, t))
	end,
}

return _M
