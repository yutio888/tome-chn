local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ATTACK",
	name = "攻击",
	info = function(self, t)
		return ([[尽 情 砍 杀 吧 宝 贝！]])
	end,
}

registerTalentTranslation{
	id = "T_HUNTED_PLAYER",
	name = "被捕猎",
	info = function(self, t) return ([[你 被 捕 猎 了 ！
		每 回 合 有 %d%% 几 率 半 径 %d 的 怪 能 在 30 回 合 内 察 觉 你 的 位 置。]]):
		format(math.min(100, 1 + self.level / 7), 10 + self.level / 5)
	end,
}

registerTalentTranslation{
	id = "T_TELEPORT_ANGOLWEN",
	name = "传送：安格利文",
	info = function(self, t)
return [[允 许 你 传 送 至 秘 密 的 小 镇： 安 格 利 文。 
		 你 已 经 在 那 里 学 习 了 很 多 魔 法 知 识 并 且 学 会 传 送 至 这 个 小 镇。 
		 其 他 人 是 不 允 许 学 习 这 种 法 术 的 所 以 你 施 法 时 不 能 被 任 何 生 物 看 到。 
		 法 术 将 消 耗 一 段 时 间 生 效， 你 施 放 法 术 及 法 术 生 效 以 前 你 必 须 保 持 在 其 他 生 物 视 线 以 外。]]
	end,
}

registerTalentTranslation{
	id = "T_TELEPORT_POINT_ZERO",
	name = "传送：零点圣域",
	info = function(self, t)
return[[允 许 你 传 送 至 时 空 守 卫 的 大 本 营： 零 点 圣 域。 
		 你 已 经 在 那 里 学 习 了 很 多 时 空 魔 法 并 且 学 会 传 送 至 此 地。 
		 其 他 人 是 不 允 许 学 习 这 种 法 术 的 所 以 你 施 法 时 不 能 被 任 何 生 物 看 到。 
		 法 术 将 消 耗 一 段 时 间 生 效， 在 你 施 放 法 术 及 法 术 生 效 前 你 必 须 保 持 在 其 他 生 物 视 线 以 外。]]
	end,
}

registerTalentTranslation{
	id = "T_RELENTLESS_PURSUIT",
	name = "无尽追踪",
	info = function (self,t)
		local eff_desc = ""
		for e_type, fn in pairs(self.save_for_effects) do
			eff_desc = eff_desc .. ("\n%s 效 果 -%d 回 合"):format(e_type:gsub("physical","物理"):gsub("magical","魔法"):gsub("mental","精神"), t.getReduction(self, t, e_type))
		end
		return ([[无 论 是 领 主 大 人、 失 落 之 地 的 瑞 库 纳 兽 人 还 是 瑞 库 纳 传 送 门 外 那 些 令 人 恐 怖 的 未 知 生 物 都 无 法 阻 止 你 寻 找 虹 吸 法 杖 的 魔 力。 
		 孩 子 们 会 在 将 来 用 童 谣 来 传 唱 你 的 无 情。 
		 当 激 活 时， 可 以 缩 短 所 有 不 利 效 果 的 有 效 时 间 ,20%% 相 应 豁 免 的 回 合 或 者 2 回 合 , 取 较 低 项。
		%s]]):
		format(eff_desc)
	end,
}

registerTalentTranslation{
	id = "T_SHERTUL_FORTRESS_GETOUT",
	name = "返回地面",
	info = function(self, t)
		return ([[使 用 堡 垒 自 带 的 传 送 系 统 “ 哔 ” 的 一 下 回 到 地 面。
		Requires being in flight above the ground of a planet.]])
	end,
}

registerTalentTranslation{
	id = "T_SHERTUL_FORTRESS_BEAM",
	name = "火力支援",
	info = function(self, t)
		return ([[消 耗 10 点 堡 垒 能 量， 将 一 股 强 大 的 爆 炸 能 量 送 到 地 面， 重 创 任 何 区 域 内 的 敌 人。
		Requires being in flight above the ground of a planet.]])
	end,
}


return _M
