


















uberTalent{
	name = "Fast As Lightning"
	info= function(self, t)
		return ([[向 同 一 方 向 连 续 以 超 过 800％ 速 度 至 少 移 动 3 回 合 后， 你 可 以 无 视 障 碍 物 移 动。 
		 变 换 方 向 会 打 断 此 效 果。  ]])
		:format()
	end
name = "Tricky Defenses"
	info= function(self, t)
		return ([[由 于 你 精 通 欺 诈 和 伪 装， 你 的 反 魔 护 盾 可 以 多 吸 收 %d%% 伤 害。 
		 受 灵 巧 影 响， 效 果 按 比 例 加 成。  ]])
		:format(t.shieldmult(self)*100)
	end
name = "end
name = "Secrets of Telos"
	info= function(self, t)
		return ([[泰 勒 斯 有 三 宝： 又 长、 又 粗、 打 怪 好。 
		 通 过 对 泰 勒 斯 三 宝 的 长 期 研 究， 你 相 信 你 可 以 使 它 们 合 为 一 体。  ]])
		:format()
	end
name = "Elemental Surge"
	info= function(self, t)
		local cold = t.getColdEffects(self, t)
		return ([[你 被 元 素 光 环 笼 罩， 当 使 用 某 种 元 素 造 成 暴 击 时， 有 一 定 几 率 触 发 以 下 特 效： 
		 奥 术 伤 害 有 30％ 几 率 使 自 身 增 加 20％ 施 法 速 度， 持 续 5 回 合。 
		 火 焰 伤 害 有 30％ 几 率 移 除 自 身 所 有 物 理 和 魔 法 的 负 面 效 果。
		 寒 冷 伤 害 有 30％ 几 率 获 得 持 续 5 回 合 的 冰 晶 皮 肤， 受 到 的 物 理 伤 害 减 少 %d%%， 提 升 %d 护 甲，并 且 攻 击 者 会 受 到 %d 点 冰 冷 反 弹 伤 害。 
		 闪 电 伤 害 有 30％ 几 率 化 为 闪 电 之 体 5 回 合， 受 到 的 任 何 攻 击 会 让 你 向 相 邻 位 置 传 送 一 码， 从 而 使 伤 害 无 效（ 此 效 果 每 回 合 只 能 生 效 一 次）。 
		 光 系 伤 害 有 30％ 几 率 形 成 一 个 吸 收 %d 伤 害 的 护 盾， 持 续 5 回 合。 
		 自 然 伤 害 有 30％ 几 率 强 化 你 的 皮 肤， 对 任 何 魔 法 负 面 效 果 免 疫， 持 续 5 回 合。 
		 寒 冷 和 光 系 效 果 随 灵 巧 增 长 。 
		 以 上 效 果 只 有 在 伤 害 超 过 %d 点 的 情 况 下 才 会 触 发（ 由 你 的 等 级 决 定）。 ]])
		:format(cold.physresist, cold.armor, cold.dam, t.getShield(self, t), t.getThreshold(self, t))
	end
name = "Eye of the Tiger"
	info= function(self, t)
		return ([[所 有 的 物 理 暴 击 减 少 随 机 的 1 个 冷 却 中 的 格 斗 或 灵 巧 系 技 能 2 回 合 冷 却 时 间。 
		 所 有 的 法 术 暴 击 减 少 随 机 的 1 个 冷 却 中 的 魔 法 系 技 能 1 回 合 冷 却 时 间。 
		 所 有 的 精 神 暴 击 减 少 随 机 的 1 个 冷 却 中 的 自 然 / 心 灵 / 痛 苦 系 技 能 2 回 合 冷 却 时 间。 
		 每 回 合 只 能 触 发 一 次， 并 且 无 法 影 响 当 前 触 发 该 效 果 的 技 能。  ]])
		:format()
	end
name = "Worldly Knowledge"
	info= function(self, t)
		return ([[以 0.9 的 技 能 系 数 学 会 以 下 技 能 树 中 的 一 个。
		 分 组 1 中 的 技 能， 所 有 职 业 都 可 学。
		 分 组 2 中 的 技 能， 只 适 用 于 不 学 法 术 和 符 文 的 职 业。
		 分 组 3 中 的 技 能， 不 适 用 于 反 魔 神 教 的 信 徒。
		 分 组 1：
		- 格 斗 / 体 质 强 化 系
		- 灵 巧 / 生 存 系
		 分 组 2：
		- 格 斗 / 移 动 系
		- 格 斗 / 阵 地 控 制 系
		- 自 然 / 自 然 召 唤 系
		- 自 然 / 灵 晶 掌 握 系
		- 超 能 / 梦 境 系
		 分 组 3：
		- 法 术 / 侦 查 系 
		- 法 术 / 法 杖 格 斗 系
		- 法 术 / 岩 石 炼 金 系
		- 天 空 / 赞 歌 系
		- 天 空 / 圣 光 系
		- 时 空 / 时 空 系]])
		:format()
	end
name = "Tricks of the Trade"
	info= function(self, t)
		return ([[你 结 交 了 狐 朋 狗 友， 学 到 了 一 些 下 三 滥 的 技 巧。 
		 增 加 灵 巧 / 潜 行 系 0.2 系 数 值（ 需 习 得 该 技 能 树， 未 解 锁 则 会 解 锁 此 技 能）， 同 时 增 加 灵 巧 / 街 头 格 斗 系 0.1 系 数 值（ 未 习 得 则 以 0.9 的 技 能 系 数 解 锁 此 技 能 树）。
		 此 外， 你 处 于 隐 形 时 的 伤 害 惩 罚 永 久 减 半。  ]]):
		format()
	end

