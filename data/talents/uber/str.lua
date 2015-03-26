


















uberTalent{
	name = "Flexible Combat"
	info= function(self, t)
		return ([[每 当 你 进 行 近 战 攻 击 时， 有 60 ％ 几 率 追 加 一 次 额 外 的 徒 手 攻 击。  ]])
		:format()
	end
name = "You Shall Be My Weapon!", short_name="TITAN_S_SMASH", image = "talents/titan_s_smash.png"
	info= function(self, t)
		return ([[对 敌 人 进 行 一 次 猛 击， 造 成 350 ％ 的 武 器 伤 害 并 击 退 目 标 6 码。 
		所 有 击 退 路 径 上 的 敌 人 会 被 撞 至 一 旁 并 被 震 慑 3 回 合。
		体 型 超 过  “Big” 时， 每 增 加 一 级 ， 额 外 增 加 80%% 武 器 伤 害。 ]])
		:format()
	end
name = "Massive Blow"
	info= function(self, t)
		return ([[对 敌 人 进 行 一 次 猛 击， 造 成 150 ％ 的 武 器 伤 害 并 击 退 目 标 4 码。 
		如 果 敌 人 在 击 退 时 撞 上 墙 壁， 墙 壁 会 被 撞 毁 且 对 敌 人 造 成 额 外 的 350 ％ 武 器 伤 害。  ]])
		:format()
	end
name = "Steamroller"
	info= function(self, t)
		return ([[当 你 使 用 冲 锋 时， 冲 锋 目 标 会 被 标 记。 在 接 下 来 两 轮 之 内 杀 掉 冲 锋 对 象， 则 冲 锋 技 能 会 冷 却 完 毕。 
		每 当 此 技 能 触 发 时， 你 获 得 1 个 增 加 20 ％ 伤 害 的 增 益 效 果， 最 大 叠 加 至 100 ％。
		冲 锋 现 在 只 消 耗 2 点 体 力 。]])
		:format()
	end
name = "Irresistible Sun"
	info= function(self, t)
		local dam = (50 + self:getStr() * 1.7) / 3
		return ([[你 获 得 6 回 合 的 星 之 引 力， 将 周 围 5 码 范 围 内 的 所 有 生 物 向 你 拉 扯， 并 对 所 有 敌 人 造 成 %0.2f 火 焰、 %0.2f 光 系 和 %0.2f 物 理 伤 害。 
		最 靠 近 你 的 敌 人 受 到 额 外 的 200 ％ 伤 害。 
		受 力 量 影 响， 伤 害 值 有 额 外 加 成。  ]])
		:format(damDesc(self, DamageType.FIRE, dam), damDesc(self, DamageType.LIGHT, dam), damDesc(self, DamageType.PHYSICAL, dam))
	end
name = "I Can Carry The World!", short_name = "NO_FATIGUE"
	info= function(self, t)
		return ([[你 是 如 此 强 壮， 永 不 疲 倦。 疲 劳 值 永 久 为 0 且 负 重 上 限 增 加 500 点 并 且 增 加 40 点 力 量 。 ]])
		:format()
	end
name = "Legacy of the Naloren"
	info= function(self, t)
		local level = t.bonusLevel(self,t)
		return ([[你 站 在 萨 拉 苏 尔 一 方 并 帮 助 他 解 决 了 厄 库 尔 维 斯 克。 你 现 在 可 以 轻 松 的 在 水 下 呼 吸。 
	         同 时， 你 能 轻 易 学 会 如 何 使 用 三 叉 戟 和 其 他 异 形 武 器（ 获 得 %d 级 异 形 武 器 掌 握）， 并 且 可 以 像 娜 迦 一 样 喷 吐 毒 素（ 等 级 %d） 。 技 能 等 级 随 人 物 等 级 增 长。   
		 此 外， 若 萨 拉 苏 尔 仍 然 存 活， 他 还 会 送 你 一 份 大 礼 …]])
		:format(level, level)
	end
name = "Superpower"
	info= function(self, t)
		return ([[强 壮 的 身 体 才 能 承 载 强 大 的 灵 魂。 而 强 大 的 灵 魂 却 可 以 创 造 一 个 强 壮 的 身 体。 
		获 得 相 当 于 你 50 ％ 力 量 值 的 精 神 强 度 增 益。 
		此 外， 你 的 所 有 武 器 都 会 有 额 外 的 30 ％ 意 志 修 正 加 成。  ]])
		:format()
	end

