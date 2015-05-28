local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_FEARSCAPE_SHIFT",
	name = "炼狱之门",
	info = function(self, t)
	local damage = t.getDamage(self, t)
	return ([[开 启 通 往 恶 魔 空 间 的 炼 狱 之 门 ， 踏 入 并 传 送 到 附 近 位 置 。 
	当 你 踏 出 炼 狱 之 门 时 ， 炼 狱 之 火 随 之 喷 发 ，造 成 %0.2f 恶 魔 之 火 伤 害 ，伤 害 %d 码 内 所 有 生 物。地 上 的 余 烬 会 造 成 持 续 4 回 合 的 额 外 %0.2f 恶 魔 之 火 伤 害。

	穿 越 空 间 增 强 了 你 的 直 觉 ， 让 你 能 够 在 3 回 合 内 觉 察 到 %d 码 内 的 所 有 敌 对 生 物 。 
 
	伤 害 受 法 术 强 度 加 成 ， 范 围 随 技 能 等 级 增 大。]]):
	format(damage, self:getTalentRadius(t),damage, t.getVision(self, t))
	end,
}


registerTalentTranslation{
	id = "T_CAUTERIZE_SPIRIT",
	name = "灵魂焚净",
	info = function(self, t)
	return ([[移 除 所 有 负 面 状 态 ， 但 每 移 除 一 个 状 态 ， 会 在 7 回 合 内 灼 烧 自 身 ，受 到 合 计 %d%% 最 大 生 命 值 的 伤 害。
	伤 害 无 视 一 切 抗 性 、防 御 效 果 和 伤 害 吸 收。
	
此 技 能 瞬 发 。]]):format(t.getBurnDamage(self, t)*100)
	end,
}


registerTalentTranslation{
	id = "T_INFERNAL_BREATH_DOOM",
	name = "地狱吐息",
	info = function(self, t)
	local radius = self:getTalentRadius(t)
	return ([[在 %d 码 的 锥 形 范 围 内 ，喷 出 持 续 4 回 合 的 暗 黑 火 焰。
	范 围 内 所 有 的 非 恶 魔 生 物 受 到 %0.2f 火 焰 伤 害 ， 同 时 火 焰 会 造 成 每 回 合 %0.2f 的 灼 烧 伤 害。
	恶 魔 受 到 等 量 的 治 疗 。
 
	伤 害 受 力 量 加 成 ， 该 技 能 使 用 魔 法 暴 击 率。]]):
	format(radius, self:combatTalentStatDamage(t, "str", 30, 350), self:combatTalentStatDamage(t, "str", 30, 70))
	end,
}


registerTalentTranslation{
	id = "T_FEARSCAPE_AURA",
	name = "乌鲁克之胃",
	info = function(self, t)
	local damage = t.getDamage(self, t)
	local radius = self:getTalentRadius(t)
	return ([[你 的 身 体 成 为 恶 魔 空 间 与 现 实 的 纽 带 ，将 %d 码 的 锥 形 范 围 内 的 敌 人 抓 过 来 ，同 时 每 回 合 造 成 %0.2f 点 火 焰 伤 害。
伤 害 受 法 术 强 度 加 成。]]):format(radius, damage)
	end,
}




return _M
