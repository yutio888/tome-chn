local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_NETHERBLAST",
	name = "虚空爆炸",
	info = function(self, t)
		local dam = t.getDamage(self,t)/2
		local backlash = t.getBacklash(self,t)
		return ([[发 射 一 束 不 稳 定 的 虚 空 能 量，造 成 %0.2f 暗 影 %0.2f 时 空 伤 害 。
		该 法 术 会 对 你 产 生 熵 能 反 冲， 在 8 回 合 内 造 成 %d 伤 害 。
		伤 害 受 法 术 强 度 加 成 。]]):
		format(damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.TEMPORAL, dam), backlash)
	end,
}

registerTalentTranslation{
	id = "T_RIFT_CUTTER",
	name = "裂缝切割",
	info = function(self, t)
		return ([[发 射 一 束 扫 射 大 地 的 能 量， 造 成 %0.2f 暗 影 伤 害， 并 产 生 不 稳 定 的 裂 缝。 3 回 合 后 裂 缝 湮 灭 并 对 周 围 敌 人 造 成 %0.2f 时 空 伤 害。
		一 次 湮 灭 不 能 多 次 伤 害 同 一 目 标。
		该 法 术 会 对 你 产 生 熵 能 反 冲， 在 8 回 合 内 造 成 %d 伤 害 。
		伤 害 受 法 术 强 度 加 成 。]]):
		format(damDesc(self, DamageType.DARKNESS, t.getDamage(self,t)), damDesc(self, DamageType.TEMPORAL, t.getDamage(self,t)), t.getBacklash(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SPATIAL_DISTORTION",
	name = "空间扭曲",
	info = function(self, t)
		local dam = t.getDamage(self,t)/2
		local backlash = t.getBacklash(self,t)
		local dur = t.getDuration(self,t)
		local rad = self:getTalentRadius(t)
		return ([[ 在 时 空 中 临 时 打 开 半 径 %d 的 裂 缝 ， 将 范 围 内 目 标 传 送 至 指 定 位 置 。
		敌 人 将 受 到 %0.2f 暗 影 %0.2f 时 空 伤 害。
		该 法 术 会 对 你 产 生 熵 能 反 冲， 在 8 回 合 内 造 成 %d 伤 害 。
		伤 害 受 法 术 强 度 加 成 。]]):format(rad, damDesc(self, DamageType.DARKNESS, dam), damDesc(self, DamageType.TEMPORAL, dam), backlash)
	end,
}

registerTalentTranslation{
	id = "T_HALO_OF_RUIN",
	name = "毁灭光环",
	info = function(self, t)
		return ([[ 每 次 你 释 放 疯 狂 法 术 时， 一 次 虚 空 火 花 将 环 绕 在 你 周 围 10 回 合， 上 限 为 5 个。
		每 个 火 花 增 加 你 %d%% 暴 击 率。 当 你 拥 有 5 个 火 花 时， 你 的 下 一 次 虚 空 法 术 将 消 耗 所 有 火 花 来 获 得 强 化 效 果 。
#PURPLE#虚 空 爆 炸：#LAST# 成 为 穿 透 性 虚 空 能 量  ， 并 在 5 回 合 内 造 成 额 外 %d%% 伤 害 。
#PURPLE#裂 缝 切 割:#LAST# 裂 缝 内 的 敌 人 将 定 身 %d 回合，每 回 合 受 到 %0.2f 时 空 伤 害 。 裂 缝 湮 灭 时 爆 炸 半 径 增 加 %d 。
#PURPLE#空 间 扭 曲:#LAST# 裂 缝 出 口 处 产 生 一 个 持 续 %d 回 合 的 熵 之 胃， 能 用 触 须 拉 近 敌 人。
伤 害 受 法 术 强 度 加 成 。
熵 之 胃 的 属 性 受 等 级 和 魔 法 属 性 加 成 。]]):
		format(t.getCrit(self,t), t.getSpikeDamage(self,t)*100, t.getPin(self, t), damDesc(self, DamageType.TEMPORAL, t.getRiftDamage(self,t)), t.getRiftRadius(self,t), t.getSpatialDuration(self,t))
	end,
}

registerTalentTranslation{
	id = "T_GRASPING_TENDRILS",
	name = "触须抓取",
	info = function(self, t)
		return ([[抓 住 目 标 ，将 其 拉 到 身 边 ，造 成 %d%% 武 器 伤 害 并 嘲 讽 之。]]):
		format(t.getDamage(self,t)*100)
	end,
}
return _M
