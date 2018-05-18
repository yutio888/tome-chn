local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_REALITY_FRACTURE",
	name = "实境撕裂",
	info = function(self, t)
		local dur = t.getDuration(self,t)
		local damage = t.getDamage(self,t)/2
		local nb = t.getNb(self,t)
		return ([[你 强 大 的 熵 之 力 撕 裂 了 时 空 ，将 这 个 世 界 与 虚 空 相 连 。
当 施 放 疯 狂 系 法 术 时 ，你 有 30%%几 率 在 相 邻 的 空 地 里 打 开 一 个 虚 空 裂 口 ，持 续 %d 回 合 。  它 每 回 合 将 会 对 范 围 7 内 的 一 个 随 机 敌 人 释 放 虚 空 轰 击 ，造 成 %0.2f 点 暗 影 伤 害 和 %0.2f 点 时 空 伤 害 。

你 可 以 主 动 激 活 这 个 天 赋 来 强 制 使 得 时 空 不 稳 定 ，在 你 周 围 创 造 %d 个 虚 空 裂 口 。]]):
		format(dur, damDesc(self, DamageType.DARKNESS, damage), damDesc(self, DamageType.TEMPORAL, damage), nb)
	end,
}

registerTalentTranslation{
	id = "T_QUANTUM_TUNNELLING",
	name = "量子隧道",
	info = function(self, t)
		local range = self:getTalentRange(t)
		local power = t.getPower(self,t)
		return ([[你 短 暂 地 在 时 空 中 打 开 一 个 通 道 ,  传 送 到 范 围 %d 内 的 一 个 虚 空 裂 口 。这 将 摧 毁 那 个 虚 空 裂 口 ，使 你 获 得 一 个 护 盾 ，吸 收 %d 点 伤 害 ，持 续 4 回 合 。
		 护 盾 吸 收 的 伤 害 随 法 术 强 度 提 高 而 提 高 。]]):
		format(range, power)
	end
}

registerTalentTranslation{
	id = "T_PIERCE_THE_VEIL",
	name = "刺破境界线",
	info = function(self, t)
		local chance = t.getChance(self,t)
		local ndam = t.getNetherDamage(self,t)
		local tdam = t.getTemporalDamage(self,t)
		local dur = t.getDimensionalDuration(self,t)
		return ([[向 你 的 裂 口 注 入 能 量 ，你 将 有 %d%%概 率 为 让 每 一 个 裂 口 进 化 成 为 更 强 大 的 形 态 。
#PURPLE#深 渊 裂 隙 :#LAST#  向 半 径 10 内 随 机 敌 人 发 射 光 束 ，造 成  %0.2f  点 暗 影 伤 害 。
#PURPLE#时 空 漩 涡 :#LAST#  每 回 合 对 半 径 4 内 的 敌 人 造 成 %0.2f 点 时 空 伤 害 ，并 且 减 少 他 们 30%%的 全 局 速 度 .
#PURPLE#维 度 之 门 :#LAST#  每 回 合 有 50%%概 率 召 唤 一 个 虚 空 造 物 ，持 续 %d 回 合 ,  是 一 个 能 传 送 的 高 速 物 理 伤 害 
你 的 虚 空 造 物 属 性 随 你 的 等 级 和 魔 法 属 性 提 高 而 提 高 。]])
		:format(chance, damDesc(self, DamageType.DARKNESS, ndam), damDesc(self, DamageType.TEMPORAL, tdam), dur)
	end
}

registerTalentTranslation{
	id = "T_DIMENSIONAL_SKITTER",
	name = "维度迅击",
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[传 送 到 范 围 10 内 的 一 个 敌 人 处 ，并 用 你 的 尖 牙 攻 击 它 ，造 成 %d%%武 器 伤 害 。]]):format(t.getDamage(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_ZERO_POINT_ENERGY",
	name = "零点能量",	
	info = function(self, t)
		local power = t.getPower(self,t)
		return ([[你 从 虚 空 深 处 汲 取 能 量 ，让 你 的 实 境 撕 裂 技 能 强 化 任 何 已 存 在 的 虚 空 裂 口 。
#GREY#虚 空 裂 口 :#LAST#  造 成  %d%%  点 额 外 伤 害 ，  并 且 投 射 物 在 半 径 1 范 围 内 爆 炸 。
#PURPLE#深 渊 裂 隙 :#LAST#  造 成  %d%%  点 额 外 伤 害 ，并 且 连 锁 至 3 个 额 外 目 标 。
#PURPLE#时 空 漩 涡 :#LAST#  造 成  %d%%  点 额 外 伤 害 ，  增 加 1 效 果 半 径 ,  并 且 减 速 效 果 提 高 至  50%%.
#PURPLE#维 度 之 门 :#LAST#  虚 空 造 物 将 会 变 得 狂 暴 ,  增 加 他 们  %d%%的 全 局 速 度 。]])
		:format(power, power, power, power)
	end,
}
return _M

