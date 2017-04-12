local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_EXOTIC_MUNITIONS",
	name = "异种弹药",
	info = function (self,t)
		return ([[你 学 会 了 制 造 和 装 备 专 门 的 弹 药:
燃 烧 弹- 命 中 后 ，对 目 标 附 近 的 敌 人 造 成 %d%% 火 焰 武 器 伤 害 ，范 围 最 大 为 %d， 每 回 合 最 多 一 次。
剧 毒 弹- 命 中 后 ，对 目 标 造 成 %0.2f 自 然 伤 害 并 感 染 麻 木 毒 素 , 在 5 回 合 内 造 成 %0.2f 自 然 伤 害 并 削 弱 其 %d%% 的 伤 害。
穿 甲 弹- 命 中 后 ， 使 目 标 的 护 甲 和 豁 免 减 少 %d ，持 续 3 回合, 你 的 物 理 穿 透 增 加 %d%%。
同 时 只 能 装 备 一 种 弹 药。
毒 素 伤 害 、 护 甲 和 豁 免 削 减 受 物 理 强 度 加 成。]]):
		format(t.getIncendiaryDamage(self, t)*100, t.getIncendiaryRadius(self,t), damDesc(self, DamageType.NATURE, t.getPoisonDamage(self, t)/5), damDesc(self, DamageType.NATURE, t.getPoisonDamage(self, t)), t.getNumb(self, t), t.getArmorSaveReduction(self, t), t.getResistPenalty(self,t))
	end,
}
registerTalentTranslation{
	id = "T_INCENDIARY_AMMUNITION",
	name = "燃烧弹",
	info = function (self,t)
		local damage = t.getIncendiaryDamage(self, t)*100
		local radius = self:getTalentRadius(t)
		return ([[装 填 燃 烧 弹, 对 目 标 附 近 的 敌 人 造 成 %d%% 火 焰 武 器 伤 害 ，范 围 最 大 为 %d。
		该 技 能 每 回 合 最 多 触 发 一 次.
		伤 害 受 物 理 强 度 加 成。]]):format(damage, radius)
	end,
}
registerTalentTranslation{
	id = "T_VENOMOUS_AMMUNITION",
	name = "剧毒弹",
	info = function (self,t)
		local damage = t.getPoisonDamage(self, t)
		local numb = t.getNumb(self,t)
		return ([[装 填 毒 弹, 对 目 标 造 成 %0.2f 自 然 伤 害 并 感 染 麻 木 毒 素 , 在 5 回 合 内 造 成 %0.2f 自 然 伤 害 并 削 弱 其 %d%% 的 伤 害。
		伤 害 随 物 理 强 度 增 加.]]):format(damDesc(self, DamageType.NATURE, damage/5), damDesc(self, DamageType.NATURE, damage), numb)
	end,
}
registerTalentTranslation{
	id = "T_PIERCING_AMMUNITION",
	name = "穿甲弹",
	info = function (self,t)
		local reduce = t.getArmorSaveReduction(self, t)
		local resist = t.getResistPenalty(self,t)
		return ([[装 填 穿 甲 弹, 使 目 标 的 护 甲 和 豁 免 减 少 %d 持 续 3 回合, 你 的 物 理 穿 透 增 加 %d%%。
		护 甲 和 豁 免 削 减 随 物 理 强 度 增 加.]]):format(reduce, resist)
	end,
}
registerTalentTranslation{
	id = "T_EXPLOSIVE_SHOT",
	name = "爆炸射击",
	info = function (self,t)
		local dam = t.getDamage(self,t)*100
		local radius = self:getTalentRadius(t)
		local dur = t.getDuration(self,t)
		local slow = t.getSlow(self,t)
		local fire = t.getFireResist(self,t)
		local poison = t.getPoisonDamage(self,t)
		local fail = t.getPoisonFailure(self,t)
		local nb = t.getRemoveCount(self,t)
		return ([[根 据 当 前 装 填 的 弹 药 进 行 一 次 特 殊 的 射 击
燃 烧 弹- %d%% 火 焰 武 器 伤 害，伤 害 半 径 %d 。 用 粘 稠 的 沥 青 包 裹 敌 人 %d 回合, 减 少 %d%% 整 体 速 度 并 增 加 其 受 到 的 火 焰 伤 害 %d%% 。
剧 毒 弹- %d%% 自 然 武 器 伤 害。爆 炸 会 形 成 半 径 %d 的 致 残 毒 气 云 ，持 续 %d 回 合, 每 回 合 造 成 %0.2f 自 然 伤 害 并 使 目 标 使 用 技 能 有 %d%% 几 率 失 败。
穿 甲 弹- %d%% 物 理 武 器 伤 害，伤 害 半 径 %d ，并 移 除 有 益 的 物 理 效 果 或 持 续 技 能。
毒 素 伤 害 受 物 理 强 度 加 成, 状 态 触 发 几 率 受 命 中 加 成。]]):
		format(dam, radius, dur, slow, fire, dam, radius, dur, damDesc(self, DamageType.NATURE, poison), fail,  dam,radius, nb)
	end,
}
registerTalentTranslation{
	id = "T_ENHANCED_MUNITIONS",
	name = "强化弹药",
	info = function (self,t)
		local fire = t.getFireDamage(self,t)
		local poison = t.getPoisonDamage(self,t)
		local resist = t.getResistPenalty(self,t)
		return ([[你 制 造 出 强 化 版 弹 药, 获 得 额 外 效 果：
燃 烧 弹- 爆 炸 范 围 增 加 1, 点 燃 地 面 每 回 合 额 外 造 成 %0.2f 火 焰 伤 害 持 续 3 回 合.
剧 毒 弹- 感 染 水 蛭 毒 素, 3 回 合 内 造 成 %0.2f 毒 素 伤 害 , 毒 素 造 成 的 100%% 伤 害 会 治 疗 你.
穿 甲 弹- 击 穿 目 标 护 甲, 目 标 受 到 的 所 有 伤 害 增 加 %d%% 持 续 3 回 合.
你 的 强 化 版 弹 药 有 限, 所 以 技 能 有 冷 却 时 间.
伤 害 受 物 理 强 度 加 成, 状 态 触 发 几 率 受 命 中 加 成。]]):
		format(damDesc(self, DamageType.FIRE, fire), damDesc(self, DamageType.NATURE, poison), resist)
	end,
}
registerTalentTranslation{
	id = "T_ALLOYED_MUNITIONS",
	name = "合金弹头",
	info = function (self,t)
		local poison = t.getPoisonDamage(self,t)*100
		local radius = t.getPoisonRadius(self,t)
		local bleed = t.getPhysicalDamage(self,t)
		local numb = t.getNumb(self,t)
		local armor = t.getArmorSaveReduction(self,t)
		local resist = t.getResistPenalty(self,t)
		return ([[混 合 你 的 弹 药, 造 成 更 强 力 的 效 果:
燃 烧 弹- 受 到 爆 炸 袭 击 的 目 标 护 甲 和 豁 免 减 少 %d 持 续 3 回 合, 你 的 物 理 和 火 焰 穿 透 增 加 %d%%.
剧 毒 弹- 造 成 %d%% 自 然 武 器 伤 害，伤 害 半 径 %d , 并 施 加 麻 木 毒 素 效 果. 每 回 合 最 多 生 效 一 次.
穿 甲 弹- 造 成 %0.2f 物 理 伤 害 并 使 目 标 流 血, 5 回 合 内 造 成 %0.2f 物 理 伤 害 并 减 少 他 们 造 成 的 伤 害 %d%%.
物 理 伤 害 、 护 甲 和 豁 免 削 减 受 物 理 强 度 加 成。]]):
		format(armor, resist, poison, radius, bleed/5, bleed, numb)
	end,
}
return _M