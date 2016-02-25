local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_AUTOMATED_CLOAK_TESSELLATION",
	name = "披风护甲",
	info = function(self, t)
		return ([[在 披 风 上 布 满 小 块 金 属 ， 对 所 有 攻 击 提 供 %d 的 伤 害 减 免。
	大 量 的 金 属 碎 片 同 时 对 远 程 打 击 提 供 偏 移 抵 抗 ，有 %d%% 的 概 率 将 投 射 物 反 射 至 附 近 的 其 他 位 置 。]])
		:format(t.getArmor(self, t), t.getEvasion(self, t))
	end,}

registerTalentTranslation{
	id = "T_CLOAK_GESTURE",
	name = "披风花招",
	info = function(self, t)
		return ([[在 抖 动 披 风 的 同 时 ， 在 面 前 扔 下 一 个 小 型 的 爆 燃 设 备 ， 产 生 一 堵 长 度 为 %d 的 浓 密 蒸 汽 墙。 对 穿 越 的 生 物 造 成 %0.2f 的 火 焰 伤 害 ， 并 且 阻 挡 生 物 视 线 。 效 果 持 续 5 回 合 。
	技 能 等 级 5 时，敌 人 会 完 全 丧 失 你 的 行 踪 ，仇 恨 丢 失。
	伤 害 随 蒸 汽 强 度 提 高 增 加 。]])
		:format(t.getLength(self, t), damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_EMBEDDED_RESTORATION_SYSTEMS",
	name = "嵌入式回复系统",
	info = function(self, t)
		return ([[为 披 风 加 装 嵌 入 式 回 复 系 统 ， 周 围 没 有 可 见 敌 人 时 自 动 触 发 ， 回 复 %d 生 命 值 。
	技 能 等 级 3 时 ， 同 时 会 消 除 一 个 物 理 负 面 效 果 。
	该 系 统 每 %d 回 合 自 动 触 发 一 次 。]])
		:format(t.getHeal(self, t), t.getCD(self, t))
	end,}

registerTalentTranslation{
	id = "T_CLOAK",
	name = "屏蔽设备",
	info = function(self, t)
		return ([[在 披 风 上 布 满 细 小 的 反 射 镜 阵 列 ， 反 射 照 射 到 你 身 上 的 所 有 光 线 ， 让 你 直 接 潜 形。
		 获 得 %d 潜 行 强 度 ， 持 续 10 回 合。
		 潜 行 强 度 随 蒸 汽 强 度 提 高 增 加。]]):
		format(t.getStealth(self, t))
	end,}
return _M