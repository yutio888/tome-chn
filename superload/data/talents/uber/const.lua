local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DRACONIC_BODY",
	name = "龙族之躯",
	["require.special.desc"] = "熟悉龙之世界",
	info = function(self, t)
		return ([[你 的 身 体 如 龙 般 坚 固， 当 生 命 值 下 降 到 30％ 以 下 时， 恢 复 40％ 的 最 大 生 命 值。  ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_BLOODSPRING",
	name = "血如泉涌",
	["require.special.desc"] = "梅琳达被献祭",
	info = function(self, t)
		return ([[当 敌 人 的 单 次 攻 击 造 成 超 过 你 15%% 总 生 命 值 伤 害 时， 产 生 持 续 4 回 合 的 血 之 狂 潮， 造 成 %0.2f 枯 萎 伤 害 并 治 疗 你 相 当 于 50％ 伤 害 值 的 生 命， 同 时 击 退 敌 人。 
		 受 体 质 影 响， 伤 害 有 额 外 加 成。  ]])
		:format(100 + self:getCon() * 3)
	end,
}

registerTalentTranslation{
	id = "T_ETERNAL_GUARD",
	name = "永恒防御",
	["require.special.desc"] = "掌握格挡技能",
	info = function(self, t)
		return ([[你 的 格 挡 技 能 持 续 时 间 增 加 1 回 合， 并 且 被 击 中 后 不 会 结 束。  ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_NEVER_STOP_RUNNING",
	name = "永不止步",
	["require.special.desc"] = "掌握至少20级使用体力的技能",
	info = function(self, t)
		return ([[当 技 能 激 活 时， 你 可 以 挖 掘 出 体 能 的 极 限， 移 动 不 会 耗 费 回 合， 但 是 每 移 动 一 码 需 消 耗 12 点 体 力。  ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_ARMOUR_OF_SHADOWS",
	name = "影之护甲",
	["require.special.desc"] = "曾造成超过50000点暗影伤害",
	info = function(self, t)
		return ([[你 懂 得 如 何 融 入 阴 影， 当 你 站 在 黑 暗 地 形 上 时 将 增 加 %d 点 护 甲、 50％ 护 甲 韧 性 和 20%% 闪 避。 同 时， 你 造 成 的 暗 影 伤 害 会 使 你 当 前 所 在 区 域 和 目 标 区 域 陷 入 黑 暗。  
		 受 体 质 影 响, 护 甲 加 值 有 额 外 加 成。]])
		:format(t.ArmourBonus(self,t))
	end,
}

registerTalentTranslation{
	id = "T_SPINE_OF_THE_WORLD",
	name = "世界之脊",
	info = function(self, t)
		return ([[你 的 后 背 坚 若 磐 石。 当 你 受 到 物 理 效 果 影 响 时， 你 的 身 体 会 硬 化， 在 5 回 合 内 对 所 有 其 他 物 理 效 果 免 疫。 ]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_FUNGAL_BLOOD",
	name = "真菌之血",
	["require.special.desc"] = "能使用纹身",
	info = function(self, t)
		return ([[真 菌 充 斥 在 你 的 血 液 中， 每 当 使 用 纹 身 时 你 都 会 储 存 %d 的 真 菌 能 量。 
		 当 使 用 此 技 能 时， 可 释 放 能 量 治 愈 伤 口 ( 恢 复 值 不 超 过 %d ),  并 解 除 至 多 10 个 负 面 魔 法 效 果。 
		 真 菌 之 力 保 存 6 回 合， 每 回 合 减 少 10 点或 10%% 。  
		 受 体 质 影 响， 真 菌 能 量 的 保 存 数 量 和 治 疗 上 限 有 额 外 加 成。]])
		:format(t.fungalPower(self, t), t.healmax(self,t))
	end,
}

registerTalentTranslation{
	id = "T_CORRUPTED_SHELL",
	name = "堕落之壳",
	["require.special.desc"] = "承 受 过 至 少 7500 点 枯 萎 伤 害 并 和 大 堕 落 者 一 起 摧 毁 伊 格。",
	info = function(self, t)
		return ([[多 亏 了 你 在 堕 落 能 量 上 的 新 发 现， 你 学 到 一 些 方 法 来 增 强 你 的 体 质。 但 是 只 有 当 你 有 一 副 强 壮 的 体 魄 时 方 能 承 受 这 剧 烈 的 变 化。 
		 增 加 你 250 点 生 命 上 限， %d 点 闪 避，%d 护 甲 值，20%% 护 甲 硬 度 , %d 所 有 豁 免， 你 的 身 体 已 经 突 破 了 自 然 界 的 范 畴 和 大 自 然 的 限 制。 
		 受 体 质 影 响， 豁 免 、护 甲 和 闪 避 有 额 外 加 成。]])
		:format(self:getCon() / 3, self:getCon() / 3.5, self:getCon() / 3)
	end,
}

return _M
