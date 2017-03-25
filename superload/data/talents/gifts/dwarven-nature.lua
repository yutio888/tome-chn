local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DWARVEN_HALF_EARTHEN_MISSILES",
	name = "岩石飞弹",
	info = function(self, t)
		local count = 2
		if self:getTalentLevel(t) >= 5 then
			count = count + 1
		end
		local damage = t.getDamage(self, t)
		return ([[释 放 出 %d 个 岩 石 飞 弹 射 向 任 意 射 程 内 的 目 标。 每 个 飞 弹 造 成 %0.2f 物 理 伤 害 和 每 回 合 %0.2f 流 血 伤 害， 持 续 5 回 合。 
		 在 等 级 5 时， 你 可 以 额 外 释 放 一 个 飞 弹。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成]]):format(count,damage/2, damage/12)
	end,
}

registerTalentTranslation{
	id = "T_ELEMENTAL_SPLIT",
	name = "元素分裂",
	info = function(self, t)
		return ([[深 入 你 的 矮 人 血 统 ， 召 唤 岩 石 和 水 晶 分 身 为 你 作 战 ， 持 续 %d 回 合 。
		水 晶 分 身 会 使 用 飞 弹 攻 击 敌 人。
		岩 石 分 身 会 嘲 讽 敌 人 来 保 护 你。
		处 于 深 岩 形 态 时 ， 该 技 能 不 能 使 用。
		]]):format(t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_POWER_CORE",
	name = "能量核心",
	info = function(self, t)
		return ([[你 的 分 身 学 会 新 的 技 能。
		水 晶 分 身 : 尖 刺 之 雨 —— 被 动 技 能 ， 令 周 围 敌 人 流 血 。
		岩 石 分 身 : 岩 石 链 接 —— 一 层 保 护 护 盾 ， 将 周 围 友 方 受 到 的 所 有 伤 害 转 移 至 岩 石 分 身。
		技 能 等 级 为 %d.]]):
		format(math.floor(self:getTalentLevel(t)))
	end,
}

registerTalentTranslation{
	id = "T_DWARVEN_UNITY",
	name = "矮人的团结",
	info = function(self, t)
		return ([[你 呼 唤 你 的 分 身 的 帮 助。
		岩 石 分 身 将 和 你 交 换 位 置， 同 时 原 位 置 半 径 %d 内 的 敌 人 将 会 转 为 以 岩 石 分 身 为 目 标。
		水 晶 分 身 将 立 即 发 射 等 级 %d 的 岩 石 飞 弹 ， 目 标 是 岩 石 分 身（ 如 死 亡 ， 则 改 为 你 自 己 ） 半 径 %d 周 围 的 敌 人。]]):
		format(self:getTalentRadius(t), self:getTalentLevelRaw(t), self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_MERGEBACK",
	name = "重吸收",
	info = function(self, t)
		local nb = t.getRemoveCount(self, t)
		local dam = t.getDamage(self, t)
		local heal = t.getHeal(self, t)
		return ([[重 吸 收 你 的 分 身 ， 清 除 合 计 至 多 %d 个 负 面 状 态。
		每 个 分 身 将 治 疗 你 %d 生 命 值 ， 并 在 半 径 3 的 范 围 内 造 成 %0.2f 点 自 然 伤 害。]]):
		format(nb, heal,dam)
	end,
}

registerTalentTranslation{
	id = "T_STONE_LINK",
	name = "岩石链接",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		return ([[制 造 一 层 半 径 %d 的 护 盾 ， 将 友 方 受 到 的 伤 害 转 移 过 来 ， 持 续 5 回 合。]]):format(radius)
	end,
}

registerTalentTranslation{
	id = "T_RAIN_OF_SPIKES",
	name = "岩刺之雨",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		return ([[ 在 身 边 发 射 尖 刺 ， 半 径 %d 内 的 敌 人 在 6 回 合 内 流 血 %0.2f 点。
		伤 害 受 法 术 强 度 加 成。]]):format(radius, dam)
	end,
}


return _M
