local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_EXPLOSIVE_STEAM_ENGINE",
	name = "引擎轰炸",
	info = function(self, t)
		return ([[在 战 场 上 投 掷 一 枚 两 回 合 后 爆 炸 的 微 型 不  稳 定 蒸 汽 引 擎。
		爆 炸 后 在 %d 码 范 围 内 产 生 灼 热 的 蒸 汽 云 雾 ， 对 范 围 内 敌 人 造 成 %0.2f 的 火 焰 伤 害。
		流 血 状 态 的 敌 人 会 受 到 40%% 的 额 外 火 焰 伤 害。
		伤 害 随 蒸 汽 强 度 增 加 。
		#{italic}#嘀嗒 嘀嗒 嘀嗒 轰 ！！#{normal}#]])
		:format(self:getTalentRadius(t), damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_LINGERING_CLOUD",
	name = "厚重云雾",
	info = function(self, t)
		return ([[引 擎 轰 炸 产 生 的 蒸 汽 云 雾 现 在 会 持 续 5 回 合 。
		每 回 合 云 雾 范 围 内 的 流 血 敌 人 会 受 到 %0.2f 火 焰 伤 害 。
		任 何 使 用 蒸 汽 科 技 的 生 物 在 云 雾 中 每 回 合 额 外 回 复 %d 蒸 汽 值 。
		伤 害 随 蒸 汽 强 度 增 加 。 
		#{italic}#尝尝最新科技带来的燃烧服务吧 ！#{normal}#]])
		:format(damDesc(self, DamageType.FIRE, t.getDamage(self, t)), t.getRegen(self, t))
	end,}

registerTalentTranslation{
	id = "T_TREMOR_ENGINE",
	name = "巨震引擎",
	info = function(self, t)
		return ([[在 战 场 上 投 掷 一 枚 两 回 合 后 触 发 的 巨 震 引 擎 。
		触 发 后 5 回 合 内 ，他  会 持 续 的 造 成 地 面 的 小 范 围 震 动 ， 震 慑 、 定 身 或 者 缴 械 范 围 %d 内 任 何 生 物 %d 回 合。
		#{italic}#你脚下是纸, 不是大地。 颤抖吧 ！#{normal}#]])
		:format(self:getTalentRadius(t), t.getDur(self, t))
	end,}


registerTalentTranslation{
	id = "T_SEISMIC_ACTIVITY",
	name = "地震爆发",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[巨 震 引 擎 的 最 后 一 次 爆 发 输 出 撕 裂 地 面 ， 引 出 岩 浆 ， 形 成 一 座 火 山 ， 持 续 %d 回 合。
		每 回 合 ， 火 山 会 喷 出 熔 岩 球 ， 造 成 %0.2f 火 焰 伤害 %0.2f 物 理 伤 害。
		伤 害 随 蒸 汽 强 度 增 加 。
		#{italic}#品尝火焰之怒吧 ！#{normal}#]])
		:format(t.getDur(self, t), damDesc(self, DamageType.FIRE, dam/2), damDesc(self, DamageType.PHYSICAL, dam/2))
	end,}

return _M