local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DREM_FRENZY",
	name = "狂热",
	info = function(self, t)
		return ([[进 入 杀 戮 狂 热 状 态 3 回 合 。
		狂 热 状 态 下 ，   你 使 用 的 第 一 个 职 业 技 能 不 进 入 冷 却 （ 再 次 使 用 将 进 入 冷 却 。）
		该 效 果 对 纹 身、 符 文、 瞬 间 技 能 以 及 固 定 冷 却 时 间 技 能 无 效 。
		]]):
		format()
	end,
}

registerTalentTranslation{
	id = "T_SPIKESKIN",
	name = "尖刺皮肤",
	info = function(self, t)
		return ([[ 你 的 皮 肤 生 长 出 被 黑 暗 和 枯 萎 力 量 覆 盖 的 尖 刺 。
		每 回 合 你 第 一 次 被 近 战 攻 击 命 中 时 ， 尖 刺 对 攻 击 者 造 成 伤 害， 对 方 将 在 5 回 合 内 每 回 合 受 到 %0.2f 黑 暗 流 血 伤 害。
		同 时， 你 将 被 敌 人 的 鲜 血 鼓 舞， 2 格 范 围 内 每 个 流 血 生 物（ 上 限 %d ） 为 你 提 供 5%% 全 体 伤 害 抗 性 。
		伤 害 随 魔 法 属 性 提 升 。]]):
		format(damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), t.getNb(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FACELESS",
	name = "无面",
	info = function(self, t)
		return ([[你 无 面 孔 的 脸 没 有 情 感 ，令 人 困 惑。 这 让 你 更 容 易 抵 抗 精 神 冲 击。
		你 获 得 %d 精 神 豁 免， %d%% 混 乱 免 疫 。]]):
		format(t.getSave(self, t), t.getImmune(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_FROM_BELOW_IT_DEVOURS",
	name = "自深渊吞噬万物",
	info = function(self, t)
		return ([[ 你 同 地 下 深 处 某 物 的 联 系 让 你 能 召 唤 一 只 饥 饿 大 嘴。
		每 回 合 它 将 周 围 10 格 内 生 物 朝 自 身 拉 近 3 格， 并 强 制 其 攻 击 它。
		它 有 %d 额 外 生 命， 存 在 %d 回 合， 不 造 成 伤 害。 
		它 的 额 外生 命 取 决 于 你 的 体 质 和 技 能 等 级。 许 多 其 他 属 性 受 等 级 影 响。]]):
		format(t.getLife(self, t), t.getTime(self, t))
	end,
}

registerTalentTranslation{
	id = "T_KROG_WRATH",
	name = "自然之怒",
	info = function(self, t)
		return ([[你 释 放 持 续 5 回  合 的 自 然 的 愤 怒。
		愤 怒 状 态 下 ， 每 当 你 造 成 伤 害 时 有 %d%%（ 第 一 次 攻 击 100%% ） 几 率 震 慑 3 回 合。
		每 个 生 物 每 轮 只 能 被 该 效 果 影 响 一 次 。
		震 慑 几 率 受 体 质 影 响， 强 度 由 物 理 或 精 神 强 度 中 较 高 一 项 决 定。]]):
		format(t.getChance(self, t))
	end,
}
local Dialog = require "engine.ui.Dialog"
registerTalentTranslation{
	id = "T_DRAKE-INFUSED_BLOOD",
	name = "灌输龙血",
	action = function(self, t)
		local possibles = {
			{name=DamageType:get(DamageType.FIRE).text_color.."火龙 / 火焰抗性", damtype=DamageType.FIRE},
			{name=DamageType:get(DamageType.COLD).text_color.."冰龙 / 寒冷抗性", damtype=DamageType.COLD},
			{name=DamageType:get(DamageType.LIGHTNING).text_color.."风暴龙 / 闪电抗性", damtype=DamageType.LIGHTNING},
			{name=DamageType:get(DamageType.PHYSICAL).text_color.."沙龙 / 物理抗性 (数值减半)", damtype=DamageType.PHYSICAL},
			{name=DamageType:get(DamageType.NATURE).text_color.."野性龙 / 自然抗性", damtype=DamageType.NATURE},
		}
		local damtype = self:talentDialog(Dialog:listPopup("选择龙种", "选择你希望灌输的龙血种类:", possibles, 400, 400, function(item) self:talentDialogReturn(item) end))
		if damtype then
			self.drake_infused_blood_type = damtype.damtype
			self:updateTalentPassives(t.id)
		end
		self.krog_kills = 0
		return true
	end,
	info = function(self, t)
		local damtype = self.drake_infused_blood_type or DamageType.FIRE
		local resist = t.getResist(self, t)
		local damage = t.getRetaliation(self, t)
		if damtype == DamageType.PHYSICAL then 
			resist = resist / 2
			damage = damage / 2
		end
		local damname = DamageType:get(damtype).text_color..DamageType:get(damtype).name.."#LAST#"
		return ([[ 伊 格 除 去 了 你 身 体 内 部 肮 脏 的 魔 法 符 文， 并 改 用 龙 血 提 供 能 量 维 持 你 的 身 体。
		龙 血 强 化 了 你， 使 你 获 得 %d%% 震 慑 抗 性 ， %d%% %s 伤 害 抗 性， %d %s 近 战 附 加 伤 害。
		你 可 以 主 动 开 启 该 技 能 来 改 变 龙 力 类 型， 进 而 改 变 相 应 元 素。
		改 变 类 型 需 要 战 斗 经 验， 你 必 须 杀 死 100 生 物 后 才 能 使 用（当 前 %d）。]]):
		format(t.getImmune(self, t),  resist,damname, damDesc(self, damtype, damage), damname, self.krog_kills or 0)
	end,
}

registerTalentTranslation{
	id = "T_FUEL_PAIN",
	name = "燃烧痛苦",
	info = function(self, t)
		return ([[你 的 身 体 习 惯 于 痛 苦。 每 次 你 受 到 超 过 20%% 最 大 生 命 的 伤 害 时， 你 的 一 个 纹 身 将 立 刻 冷 却 完 毕。
		该 效 果 冷 却 时 间 为 %d 回 合。 ]]):
		format(self:getTalentCooldown(t))
	end,
}

registerTalentTranslation{
	id = "T_WARBORN",
	name = "为战争而生",
	info = function(self, t)
		return ([[ 你 被 伊 格 制 造 的 唯 一 理 由： 对 魔 法 作 战！
		5 回 合 内 你 受 到 的 所 有 伤 害 降 低 %d%%， 同 时 你 开 启 该 技 能 时， 自 然 之 怒 自 动 冷 却 完 毕。
		当 你 学 会 该 技 能 时 ， 你 变 得 如 此 强 大 ， 以 至 于 能 双 持 任 何 单 手 武 器 。]]):
		format(t.getResist(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TAKE_A_BITE",
	name = "咬一口",
	info = function(self, t)
		return ([[ 你 尝 试 用 #{italic}#头#{normal}# 咬 你 的 敌 人 造 成 %d%% 枯 萎 武 器 伤 害。
		如 果 目 标 被 咬 后 生 命 不 足 20%%， 你 有 %d%% 几 率 直 接 杀 死 它（对 boss 无效）。
		你 咬 中 以 后 5 回 合 内 每 回 合 回 复 %0.1f 生 命。
		秒 杀 几 率 和 生 命 回 复 受 体 质 加 成， 武 器 伤 害 受 力 量 敏 捷 魔 法 中 最 高 值 影 响。]]):
		format(t.getDam(self, t) * 100, t.getChance(self, t), t.getRegen(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ULTRA_INSTINCT",
	name = "终极本能",
	info = function(self, t)
		return ([[ 没 有 #{bold}#思 维#{normal}# 和 #{bold}#自 我#{normal}# 的 干 扰， 你 的 身 体 全 凭 本 能 行 动，  反 应 速 度 更 快 。
		整 体 速 度 增 加 %d%% 。]]):
		format(t.getSpeed(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_CORRUPTING_INFLUENCE",
	name = "堕落影响",
	info = function(self, t)
		return ([[ 寄 生 在 你 身 体 里 的 堕 落 力 量 渗 出 了 你 的 身 体， 给 予 你 强 化。
		增 加 %d%% 枯 萎 、 黑 暗 、 时 空 和  酸 性 伤 害 抗 性， 同 时 减 少 %d%% 自 然 和 光 系 伤 害 抗 性。 ]]):format(t.getResist(self, t), t.getResist(self, t) / 3)
	end,
}

registerTalentTranslation{
	id = "T_HORROR_SHELL",
	name = "恐惧外壳",
	info = function(self, t)
		return ([[在 你 身 边 制 造 一 层 持 续 10 回 合 吸 收 %d 伤 害 的 外 壳。
		吸 收 量 受 体 质 加 成。]]):
		format(t.getShield(self, t))
	end,
}
return _M
