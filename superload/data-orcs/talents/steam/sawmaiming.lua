local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TO_THE_ARMS",
	name = "切臂",
	info = function(self, t)
		return ([[用 链 锯 攻 击 目 标 手 臂 ， 造 成 %d%% 武 器 伤 害 并 尝 试 致 残 目 标 %d 回 合。
		致 残 状 态 的 敌 人 造 成 的 伤 害 减 少 %d%% 。
		致 残 几 率 受 物 理 强 度 影 响 。
		#{italic}#杀人如砍瓜切菜 !#{normal}#]]):
		format(100 * self:combatTalentWeaponDamage(t, 1, 1.6), t.getDuration(self, t), t.getMaim(self, t))
	end,}

registerTalentTranslation{
	id = "T_BLOODSTREAM",
	name = "涌血",
	info = function(self, t)
		return ([[你 " 轻 柔 " 地 将 链 锯 放 在 目 标 的 伤 口 上 ， 造 成 %d%% 武 器 伤 害 并 加 深 伤  口。
		所 有 流 血 伤 口 持 续 时 间 增 加 %d 回 合 ， 伤 害 增 加 %d%% （ 每 项 流 血 最 多 触 发 一 次 ） 。
		效 果 触 发 时 ， 血 流 将 喷 射 而 出 ， 对 4 码 锥 形 范 围 内 所 有 生 物 造 成 %0.2f 物 理 伤 害 。
		伤 害 受 蒸 汽 强 度 加 成 。 
		#{italic}#一切技术，皆为屠杀 !#{normal}#]]):
		format(self:combatTalentWeaponDamage(t, 0.3, 1.1) * 100, t.getDuration(self, t), t.getDamageInc(self, t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_SPINAL_BREAK",
	name = "断脊",
	info = function(self, t)
		return ([[你尝 试 撕 裂 敌 人 的 脊 柱 ， 减 少 其 %d%% 整 体 速 度 4 回 合 ， 并 造 成 %d%% 武 器 伤 害 。
		同 时 敌 人 将 失 去 %d 项 物 理 效 果。
		技 能 等 级 3 时 ， 同 时 除 去 %d 项 物 理 或 魔 法 维 持 技 能 。
		#{italic}#切碎他们，折磨他们，收割他们！#{normal}#]]):
		format(t.getSlow(self, t) * 100, self:combatTalentWeaponDamage(t, 0.6, 1.5) * 100, t.getRemoveCount(self, t), t.getRemoveCount(self, t))
	end,}


registerTalentTranslation{
	id = "T_GORESPLOSION",
	name = "爆尸",
	info = function(self, t)
		return ([[每 次 击 杀 敌 人 时， 将 爆 炸 物 和 榴 弹 封 入 尸 体 ，引 发 一 场 半 径 %d 的 大 爆 炸 。
		 任 何 被 击 中 的 敌 人 将 在 6  回 合 内 受 到 %0.2f 流 血 伤 害 。
		 同 时 榴 弹 将 损 伤 他 们 的 发 声 器 官 ， 沉 默 %d 回 合。
		#{italic}#使用战争技术的精华——榴弹。为了制造血和骚乱 ！#{normal}#]]):
		format(self:getTalentRange(t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t) / 6), t.getDuration(self, t))
	end,}

return _M