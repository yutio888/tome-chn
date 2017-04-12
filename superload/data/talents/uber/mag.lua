local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SPECTRAL_SHIELD",
	name = "无光之盾",
	["require.special.desc"] = "掌 握 格 挡 技 能， 曾 释 放 过 100 个 法 术， 且 格 挡 强 度 超 过 200",
	info = function(self, t)
		return ([[向 护 盾 中 灌 注 魔 法 序 列， 使 格 挡 技 能 能 够 格 挡 任 何 类 型 的 伤 害。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_AETHER_PERMEATION",
	name = "以太渗透",
	["require.special.desc"] = "拥 有 至 少 25% 以 上 的 奥 术 抗 性， 并 且 曾 去 过 无 尽 虚 空",
	info = function(self, t)
		return ([[在 你 的 周 围 创 造 一 层 厚 实 的 以 太 层， 任 何 伤 害 均 会 使 用 奥 术 抵 抗 代 替 原 本 攻 击 类 型 抵 抗 进 行 抵 抗 计 算。 
		实 际 上， 你 的 所 有 抵 抗 约 等 于 你 66%% 的 奥 术 抗 性。
		你 的 奥 术 抗 性 增 加 20%%， 抗 性 上 限 增 加 10%% 。]])
		:format()
	end,
}


registerTalentTranslation{
	id = "T_ARCANE_MIGHT",
	name = "奥术之握",
	info = function(self, t)
		return ([[你 学 会 如 何 利 用 自 己 潜 在 的 奥 术 力 量， 将 它 们 注 入 你 的 武 器。 
		所 有 武 器 均 有 额 外 的 50％ 魔 法 加 成。
		你 的 基 础 物 理 强 度 增 加 等 同 于 100%% 基 础 法 强 的 数 值。
		你 的 物 理 暴 击 率 增 加 等 同 于 25%% 法 术 暴 击 率 的 数 值。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_TEMPORAL_FORM",
	name = "时空形态",
	["require.special.desc"] = "曾 释 放 过 1000 个 以 上 的 技 能 并 且 成 功 进 入 过 相 位 现 实。",
	info = function(self, t)
		return ([[你 可 以 扭 曲 周 围 的 时 间 线， 转 换 成 时 空 元 素 “ 泰 鲁 戈 洛 斯 ” 形 态， 持 续 10 回 合。 
		在 这 种 形 态 中， 你 对 定 身、 流 血、 致 盲、 震 慑 免 疫， 获 得 30％ 时 空 抵 抗 和 20％ 的 时 空 抵 抗 穿 透。 
		你 造 成 的 伤 害 的 50%% 转 化 为 时 空 伤 害。 
		同 时， 你 的 时 空 伤 害 增 益 等 于 你 所 有 类 型 的 伤 害 增 益 中 的 最 大 值， 此 外， 还 增 加 30％ 额 外 时 空 伤 害 增 益。
		你 在 时 空 形 态 下 能 释 放 以 下 异 常：异常：重排, 异常：时空风暴 , 异常：不完美设计 ,  异常：重力井 和 异常：虫洞.
		]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_BLIGHTED_SUMMONING",
	name = "枯萎召唤",
	["require.special.desc"] = "曾 召 唤 了 100 个 以 上 此 技 能 相 关 的 召 唤 生 物（ 炼 金 傀 儡 视 作 100 单 位）",
	info = function(self, t)
		local tl = t.bonusTalentLevel(self, t)
		return ([[ 你 将 枯 萎 元 素 注 入 你 的 召 唤 兽 体 内， 给 予 它 们 新 的 技 能( 等 级 %d )： 
		- 战 争 猎 犬 : 衰 竭 诅 咒  - 黑 果 冻 怪 : 活 力 感 知 
		- 米 诺 陶 : 生 命 源 泉 - 岩 石 傀 儡 : 白 骨 之 矛 
		- 火 焰 里 奇 : 枯 萎 吸 收 - 三 头 蛇 : 鲜 血 喷 射 
		- 雾 凇 : 剧 毒 风 暴 - 火 龙 : 黑 暗 之 炎 
		- 乌 龟 : 虚 弱 诅 咒 - 蜘 蛛 : 腐 蚀 蠕 虫 
		- 骷 髅 : 白 骨 之 握 或 白 骨 之 矛 - 骨 巨 人 : 骨 盾 
		- 食 尸 鬼 : 鲜 血 禁 锢 - 吸 血 鬼 / 巫 妖 : 黑 暗 之 炎 
		- 梦 靥 / 尸 妖 : 鲜 血 沸 腾 
		- 炼 金 傀 儡 : 堕 落 力 量 和 掠 夺 格 斗 系 技 能 树 
		- 阴 影 : 转 移 邪 术 - 精 神 体 战 士 : 乌 鲁 洛 克 之 焰 
		- 树 人 : 腐 蚀 蠕 虫 - 夺 心 魔 精 英 : 黑 暗 之 门 
		- 食 尸 鬼 傀 儡 : 撕 裂 
		- 浮 肿 软 泥 怪 : 白 骨 护 盾 ( 等 级 %d )
		- 粘 液 软 泥 怪 : 剧 毒 瘟 疫 
		 你 的 死 灵 召 唤 和 自 然 召 唤 会 得 到 魔 法 加 成。
		 技 能 等 级 随 人 物 等 级 增 加。 
		 其 他 种 族 和 物 品 召 唤 物 也 有 可 能 被 影 响。]])
		 :format(tl,math.ceil(tl*2/3))
	end,
}

registerTalentTranslation{
	id = "T_REVISIONIST_HISTORY",
	name = "修正历史",
	["require.special.desc"] = "曾经至少进行过一次时空穿越",
	info = function(self, t)
		return ([[你 现 在 可 以 控 制 不 远 的 过 去。 使 用 技 能 后 获 得 一 个 持 续 20 轮 的 时 空 效 果。 
		 在 效 果 持 续 时 间 内， 再 次 使 用 技 能 即 可 回 到 第 
		 一 次 使 用 的 时 间 点 重 新 来 过。 
 		 这 个 法 术 会 使 时 间 线 分 裂， 所 以 其 他 同 样 能 使 
		 时 间 线 分 裂 的 技 能 在 此 期 间 不 能 成 功 释 放。  ]])
		:format()
	end,
}
registerTalentTranslation{
	id = "T_REVISIONIST_HISTORY_BACK",
    name = "改写历史",
	info = function(self, t)
		return ([[改 写 历 史 ， 返 回 到 修 正 历 史 施 法 点 。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_CAUTERIZE",
	name = "浴火重生",
	["require.special.desc"] = "曾 承 受 过 至 少 7500 点 火 焰 伤 害， 并 且 至 少 曾 释 放 过 1000 次 法 术。",
	info = function(self, t)
		return ([[你 的 心 炎 是 如 此 强 大。 每 当 你 受 到 必 死 的 攻 击 时， 你 的 身 体 会 被 圣 焰 所 环 绕。 
		 圣 焰 会 修 复 伤 口， 完 全 吸 收 此 次 攻 击 伤 害， 但 是 它 们 将 会 继 续 燃 烧， 持 续 8 回 合。 
		 每 回 合 圣 焰 会 对 你 造 成 10％ 刚 才 吸 收 的 伤 害（ 此 伤 害 会 自 动 忽 略 护 甲 和 抵 抗）。 
		 警 告： 此 技 能 有 冷 却 时 间， 慎 用。  ]])
	end,
}

registerTalentTranslation{
	id = "T_MYSTICAL_CUNNING",
	name = "魔之秘术",
	["require.special.desc"] = "掌握陷阱或者毒药技能",
	info = function(self, t)
		local descs = ""
		for i, tid in pairs(t.autolearn_talent) do
			local bonus_t = self:getTalentFromId(tid)
			if bonus_t then
				descs = ("%s\n#YELLOW#%s#LAST#\n%s\n"):format(descs,bonus_t.name,self:callTalent(bonus_t.id,"info"))
			end
		end
		return ([[通 过 对 奥 术 之 力 的 研 究， 你 开 发 出 了 新 的 陷 阱 和 毒 药（ 由 学 习 此 进 阶 时 掌 握 的 技 能 决 定） 
		你 可 以 学 会： 
%s
		同 时， 你 的 魔 法 豁 免 永 久 提 高 20 点。]])
		:format(descs)
	end,

}

return _M
