local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DEMON_SEED_FIRE_BOLTS",
	name = "近战火球",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[当 你 近 战 攻 击 命 中 时 ， 有 %d%% 几 率 释 放 至 多 %d 个 火 球 ， 造 成 %0.2f 点 火 焰 伤 害。
		伤 害 受 法 术 强 度 加 成]]):
		format(self:getTalentLevel(t) * 5 + 20, 1+math.ceil(self:getTalentLevel(t) / 2), damage)
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_FIERY_CLEANSING",
	name = "火焰净化",
	info = function(self, t)
		return ([[消 耗 10%% 最 大 生 命 值，解 除 至 多 %d 个 负 面 状 态。]]):
		format(t.getNb(self, t))
	end,
}



registerTalentTranslation{
	id = "T_DEMON_SEED_FARSTRIKE",
	name = "远程打击",
	info = function(self, t)
		local range = self:getTalentRange(t)
		return ([[扔 出 武 器 攻 击 远 处 敌 人，造 成 %d%% 武 器 伤 害 。]]):
		format(t.getDamage(self, t)*100)
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_CORROSIVE_SLASHES",
	name = "腐蚀鞭笞",
	info = function(self, t)
		return ([[用 酸 液 覆 盖 武 器，近 战 伤 害 转 变 为 酸 性。
		近 战 攻 击 获 得 %d 护 甲 穿 透。]]):
		format(t.getArmorPen(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_ACIDIC_BATH",
	name = "酸浴",
	info = function(self, t)
		return ([[在 半 径 4 的 范 围 内 制 造 持 续 %d 回 合 的 酸 池 ， 造 成 %0.2f 酸 性 伤 害 （ 包 括 自 己）。
		你 获 得 40%% 酸 性 抗 性 与 %d%% 酸 性 伤 害 吸 收 。
		伤 害 受 法 术 强 度 加 成。
		The damage scales with your Spellpower.]]):
		format(t.getDuration(self, t),t.getDamage(self, t), t.getAffinity(self, t))
	end,
}



registerTalentTranslation{
	id = "T_DEMON_SEED_BLIGHTED_PATH",
	name = "枯萎之路",
	info = function(self, t)
		return ([[每 次 你 行 走 、 移 动 时 ， 你 获 得 一 次 枯 萎 充 能 。 你 最 多 能 积 累 %d 次 充 能。
		当 你 取 消 该 技 能 时 ， 你 能 选 择 回 复 自 己 或 攻 击 近 身目 标 。 每 次 充 能 可 以 回 复 %0.2f 点 活 力 或 造 成 %0.2f 枯 萎 伤 害。
		伤 害 受 法 术 强 度 加 成。]]):
		format(t.getMaxCharges(self, t), t.getVim(self, t),t.getDamage(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_CORRUPT_LIGHT",
	name = "腐化之光",
	info = function(self, t)
		return ([[在 半 径 %d 范 围 内 扩 散 黑 暗 。 每 一 块 原 本 被 照 亮 的 地 形 ，都 在 接 下 来 的 %d 回 合 里 增 加 你 的 伤 害。]]):
		format(self:getTalentRadius(t), t.getDuration(self, t))
	end,
}



registerTalentTranslation{
	id = "T_DEMON_SEED_SHADOWMELD",
	name = "暗影融合",
	info = function(self, t)
		return ([[每 当 你 站 在 黑 暗 地 形 时 ，你 能 与 黑 暗 融 合 ，获 得 %d 潜 行 强 度 。
		 你 的 灯 具 不 会 计 算 在 内 ，同 时 效 果 激 活 时 灯 具 将 自 动 关 闭 。
		 移 动 会 取 消 该 效 果 。
		 潜 行 强 度 受 法 术 强 度 加 成 。]]):
		format(t.getStealth(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_BLOOD_SHIELD",
	name = "鲜血护盾",
	info = function(self, t)
		return ([[在 盾 牌 中 引 导 毁 灭 之 力 ，使 你 受 到 的 全 体 伤 害 减 少 15%% 格 挡 值 。
		 每 次 你 被 近 战 攻 击 命 中 时 ，你 的 盾 牌 会 自 动 反 击 ，造 成 %d%% 格 挡 值 的 火 焰 暗 影 混 合 伤 害 。]]):
		format(0.35 * t.getPercent(self, t))
	end,
}



registerTalentTranslation{
	id = "T_DEMON_SEED_SILENCE",
	name = "沉默",
	info = function(self, t)
		return ([[腐 化 目 标 ， 使 之 沉 默 %d 回 合。]]):
		format(t.getDuration(self, t))
	end,
}



registerTalentTranslation{
	id = "T_DEMON_SEED_FIERY_PORTAL",
	name = "火焰传送门",
	info = function(self, t)
		return ([[制 造 两 个 连 接 在 一 起 的 传 送 门 ， 持 续 %d 回 合。]]):
		format(t.getDuration(self, t))
	end,
}



registerTalentTranslation{
	id = "T_DEMON_SEED_DOOM_TENDRILS",
	name = "末日触须",
	info = function(self, t)
		return ([[你 化 身 为 末 日 之 柱 ，在 周 围 2 码 的 范 围 内 产 生 火 焰 触 须 。
		 被 火 焰 触 须 击 中 的 敌 人 每 回 合 受 到 %0.2f 火 焰 伤 害 。
		 受 到 伤 害 的 生 物 同 时 会 被 定 身 。]]):
		format(t.getDamage(self, t))
	end,
}



registerTalentTranslation{
	id = "T_DEMON_SEED_DOOMED_NATURE",
	name = "自然末日",
	info = function(self, t)
		return ([[你 诅 咒 目 标 5 回 合 ，割 裂 其 与 自 然 的 联 系 。
		 每 次 被 诅 咒 的 目 标 试 图 使 用 自 然 力 量 时 ，有 %d%% 几 率 失 败 并 制 造 一 个 火 球 ，对 半 径 1 内 的 生 物 造 成 %0.2f 火 焰 伤 害 。
		 伤 害 受 你 的 意 志 加 成 。]]):
		format(t.getChance(self, t),  t.getDamage(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_ACID_BURST",
	name = "酸性爆发",
	info = function(self, t)
		return ([[每 次 你 格 挡 攻 击 时 ，将 释 放 少 量 酸 性 气 体 ，在 半 径 3 的 范 围 内 造 成 持 续 %d 回 合 的 %d 伤 害 。
		 伤 害 受 法 术 强 度 加 成 。]]):
		format( t.getDuration(self,t), t.getDamage(self,t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_ACID_CONE",
	name = "锥形酸液",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[每 次 近 战 暴 击 时 ， 将 释 放 一 股 锥 形 酸 液 ，造 成 %d 伤 害 并 融 化 墙 壁。
		伤 害 受 法 术 强 度 加 成。]]):
		format(damage)
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_ARMOURED_LEVIATHAN",
	name = "重装上阵",
	info = function(self, t)
		return ([[你 利 用 盾 牌 来 强 化 自 身 ，力 量 和 魔 法 增 加 10%% 格 挡 值 ,持 续 %d 回 合 。]]):
		format(t.getDuration(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_FLASH_BLOCK",
	name = "瞬间格挡",
	info = function(self, t)
		return ([[在 闪 电 般 的 速 度 中 ，你 瞬 间 举 起 盾 牌 格 挡 。]]):
		format()
	end,
}


registerTalentTranslation{
	id = "T_DEMON_SEED_BLACKICE",
	name = "黑冰",
	info = function(self, t)
		return ([[每 次 你 用 非 火 焰 伤 害 杀 死 生 物 时 ， 你 获 得 一 次 黑 冰 充 能 ， 持 续 20 回 合 ， 最 多 累 计 %d 次。
		任 何 时 候 ， 你 能 消 耗 一 次 充 能 ， 降 低 一 个 生 物 %d%% 火 焰 抗 性 7 回 合。]]):
		format(t.getStack(self, t), t.getRes(self, t))
	end,
}


return _M
