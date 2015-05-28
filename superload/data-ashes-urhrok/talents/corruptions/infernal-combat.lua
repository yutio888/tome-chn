local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FLAME_LEASH",
	name = "火焰束缚",
	info = function(self, t)
		return ([[火 焰 触 须 从 你 的 手 中 伸 出 ，在 锥 形 范 围 内 伸 展 。
		 被 火 焰 触 须 抓 住 的 生 物 将 被 拉 过 来 ，同 时 移 动 速 度 减 少 %d%% ，持 续 4 回 合 。
		 每 个 触 须 会 留 下 火 焰 痕 迹 ，每 回 合 造 成 %0.2f 火 焰 伤 害 ，持 续 4 回 合 。
		 伤 害 受 法 术 强 度 加 成 。]])
		:format(t.getSlow(self, t) * 100, t.getDam(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_BLADE",
	name = "恶魔之刃",
	info = function(self, t)
		return ([[向 你 的 武 器 灌 输 火 焰 之 力 ，持 续 5 回 合 。
		 每 次 近 战 攻 击 时 会 释 放 一 个 火 球 ，在 半 径 1 的 范 围 内 造 成 %0.2f 火 焰 伤 害 。
		 这 个 效 果 每 回 合 只 能 触 发 一 次 。
		 伤 害 受 法 术 强 度 加 成 。]]):
		format(t.getDam(self, t))
	end,
}


registerTalentTranslation{
	id = "T_LINK_OF_PAIN",
	name = "苦痛链接",
	info = function(self, t)
		return ([[使 用 恶 魔 之 力 ，你 在 源 生 物 与 牺 牲 生 物 间 构 造 痛 苦 链 接 ，持 续 %d 回 合 。
		 每 次 源 生 物 受 到 伤 害 时 ， %d%% 伤 害 由 牺 牲 生 物 承 受 。
		 当 牺 牲 生 物 因 此 效 果 死 亡 时 ，你 将 获 得 能 量 ，减 少 所 有 技 能 冷 却 时 间 1 回 合 。]]):
		format(t.getDur(self, t), t.getPower(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_HORNS",
	name = "恶魔之角",
	info = function(self, t)
		return ([[你 的 盾 牌 上 长 出 临 时 的 恶 魔 之 角 。
		 你 盾 击 敌 人 造 成 %d%% 伤 害 。
		 如 果 攻 击 命 中 ，目 标 将 被 恶 魔 角 刺 穿 ，流 血 5 回 合 ，合 计 受 到 额 外 50%% 黑 暗 伤 害 。
		 每 次 你 攻 击 被 恶 魔 角 刺 穿 的 目 标 时 ，你 回 复 %d 生 命 (每 回 合 至 多 1 次 )。
		 治 疗 效 果 受 法 术 强 度 加 成 。]])
		:format(100 * self:combatTalentWeaponDamage(t, 1, 2, self:getTalentLevel(self.T_SHIELD_EXPERTISE)), t.getHeal(self, t))
	end,
}


return _M
