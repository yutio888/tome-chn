local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HEALING_LIGHT",
	name = "治愈之光",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[一 束 充 满 活 力 的 阳 光 照 耀 着 你， 治 疗 你 %d 点 生 命 值。 
		 受 法 术 强 度 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(heal)
	end,
}

registerTalentTranslation{
	id = "T_BATHE_IN_LIGHT",
	name = "光之洗礼",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local heal = t.getHeal(self, t)
		local heal_fact = heal/(heal+50)
		local duration = t.getDuration(self, t)
		return ([[圣 光 倾 泻 在 你 周 围 %d 码 范 围 内， 每 回 合 治 疗 所 有 单 位 %0.2f 生 命 值, 给 予 其 等 量 的 护 盾 , 并 增 加 此 范 围 内 所 有 人 %d%% 治 疗 效 果。 此 效 果 持 续 %d 回 合。 
		 如 果 已 经 存 在 护 盾， 则 护 盾 将 会 增 加 等 量 数 值 ，如 果 护 盾 持 续 时 间 不 足 2 回 合，会 延 长 至 2 回 合。
		 当 同 一 个 护 盾 被 刷 新 20 次 后 ， 将 会 因 为 不 稳 定 而 破 碎 。
		 它 同 时 会 照 亮 此 区 域。 
		 受 魔 法 影 响， 治 疗 量 有 额 外 加 成。]]):
		format(radius, heal, heal_fact*100, duration)
	end,
}

registerTalentTranslation{
	id = "T_BARRIER",
	name = "护盾术",
	info = function(self, t)
		local absorb = t.getAbsorb(self, t)
		return ([[一 个 持 续 10 回 合 的 保 护 性 圣 盾 围 绕 着 你， 可 吸 收 %d 点 伤 害。 
		 受 法 术 强 度 影 响， 圣 盾 的 最 大 吸 收 量 有 额 外 加 成。]]):
		format(absorb)
	end,
}

registerTalentTranslation{
	id = "T_PROVIDENCE",
	name = "光之守护",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 位 于 圣 光 的 保 护 下， 每 回 合 移 除 1 种 负 面 状 态， 持 续 %d 回 合。 。]]):
		format( duration)
	end,
}

return _M
