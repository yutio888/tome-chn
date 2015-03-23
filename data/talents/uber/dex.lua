


















uberTalent{
	name = "Through The Crowd"
	info= function(self, t)
		return ([[你 习 惯 与 大 部 队 一 起:
		 
		 
		 
		:format()
	end
name = "Swift Hands"
	info= function(self, t)
		return ([[你 的 手 指 灵 巧 的 超 乎 想 象， 切 换 主/ 副 武 器  ( 默 认 Q 键 )、装 备/ 卸 下 装 备 不 再 消 耗 回 合。 
		 该 效 果 一 回 合 只 能 触 发 一 次 。
		 同 时， 当 装 备 有 附 加 技 能 的 物 品 时， 其 附 加 技 能 也 会 冷 却 完 毕。 ]])
		:format()
	end
name = "Windblade"
	info= function(self, t)
		return ([[你 挥 动 武 器 疯 狂 旋 转， 产 生 剑 刃 风 暴， 对 4 码 范 围 内 所 有 敌 人 造 成 320％ 的 武 器 伤 害， 并 缴 械 它 们 4 回 合。  ]])
		:format()
	end
name = "Windtouched Speed"
	info= function(self, t)
		return ([[你 和 大 自 然 产 生 共 鸣， 在 与 奥 术 势 力 的 战 斗 中 受 到 她 的 赐 福。 
		 你 的 整 体 速 度 永 久 提 高 20％， 且 不 会 触 发 压 力 式 陷 阱。 ]])
		:format()
	end
name = "Giant Leap"
	info= function(self, t)
		return ([[你 跃 向 目 标 地 点， 对 1 码 半 径 范 围 内 的 所 有 敌 人 造 成 200％ 的 武 器 伤 害， 并 眩 晕 目 标 3 回 合。  ]])
		:format()
	end
name = "Crafty Hands"
	info= function(self, t)
		return ([[你 心 灵 手 巧， 打 造 技 艺 已 趋 于 炉 火 纯 青， 可 以 给 头 盔 和 腰 带 镶 嵌 宝 石。 ]])
		:format()
	end
name = "Roll With It"
	info= function(self, t)
		return ([[ 你 学 会 选 择 在 需 要 的 时 候 借 力 抽 身， 受 到 的 所 有 物 理 伤 害 降 低 %d%%。 
		 当 被 近 战 或 者 远 程 攻 击 命 中 时， 你 会 借 势 后 退 一 码 ( 这 个 效 果 每 轮 只 能 触 发 一 次 )， 并 获 得 1 回 合 的 200％ 移 动 加 速。
		 受 敏 捷 影 响， 伤 害 降 低 幅 度 增 加， 且 作 用 于 物 理 抗 性 后。 ]])
		:format(100*(1-t.getMult(self, t)))
	end
name = "Vital Shot"
	info= function(self, t)
		return ([[你 对 着 目 标 要 害 射 出 一 发， 使 目 标 受 到 重 创。 
		 受 到 攻 击 的 敌 人 将 会 承 受 450％ 武 器 伤 害， 并 且 由 于 受 到 重 创， 还 会 被 震 慑 和 残 废 ( 减 少 50％ 攻 击、 施 法 和 精 神 速 度 )5 回 合。 
		 受 命 中 影 响， 震 慑 和 残 废 几 率 有 额 外 加 成。 ]]):format()
	end

