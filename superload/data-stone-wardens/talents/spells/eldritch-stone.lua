local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STONE_SPIKES",
	name = "岩石尖刺",
	info = function(self, t)
		local xs = ""
		if self:knowTalent(self.T_POISONED_SPIKES) then
			xs = ("中 毒 6 回 合 受 到 合 计 %0.1f 点 自 然 伤 害 （同 时 减 少 %d%% 治 疗 效 果） "):format(self:callTalent(self.T_POISONED_SPIKES, "getDamage"), self:callTalent(self.T_POISONED_SPIKES, "getHeal"))
		end
		if self:knowTalent(self.T_ELDRITCH_SPIKES) then
			xs = xs..(", 受 到 %0.1f点 奥 术 伤 害（ 同 时 沉 默 %d 回 合 ）,"):format(self:callTalent(self.T_ELDRITCH_SPIKES, "getDamage"), self:callTalent(self.T_ELDRITCH_SPIKES, "getSilence"))
		end
		if self:knowTalent(self.T_IMPALING_SPIKES) then
			xs = xs..(" 受 到 %0.1f 点 物 理 伤 害（同 时 缴 械 %d 回 合）,"):format( self:callTalent(self.T_IMPALING_SPIKES, "getDamage"), self:callTalent(self.T_IMPALING_SPIKES, "getDisarm"))
		end
		return ([[在 半 径 %d 的 锥 形 范 围 内 ， 从 地 下 爆 发 岩 石 尖 刺 。
		范 围 内 的 生 物 将 %s 在 6 回 合 内 受 到 %0.1f 物 理 伤 害。
		伤 害 受 法 术 强 度 加 成 ， 负 面 状 态 附 加 几 率 受 法 术 强 度 和 物 理 强 度 较 高 一 项 影 响 。]])
		:format(self:getTalentRadius(t), xs ~="" and xs.." 并 " or "",  t.getDamage(self, t))
	end,
}

registerTalentTranslation{
	id = "T_POISONED_SPIKES",
	name = "剧毒尖刺",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[用 毒 素 覆 盖 岩 石 尖 刺 ， 使 生 物 中 毒 6 回 合， 造 成 合 计 %0.1f 自 然 伤 害 ， 并 减 少 %d%% 治 疗 效 果 。]]):
		format( t.getDamage(self, t), t.getHeal(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ELDRITCH_SPIKES",
	name = "奥术尖刺",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[用 奥 术 能 量 填 充 岩 石 尖 刺 ， 造 成  %0.1f 奥 术 伤 害 ，并 沉 默 %d 回 合 。]]):
		format( t.getDamage(self, t), t.getSilence(self, t))
	end,
}

registerTalentTranslation{
	id = "T_IMPALING_SPIKES",
	name = "穿透尖刺",
	info = function(self, t)
		return ([[强 化 你 的 岩 石 尖 刺 ， 造 成  %0.1f 物 理 伤 害 ，并 缴 械 %d 回 合 。]]):
		format( t.getDamage(self, t), t.getDisarm(self, t))
	end,
}


return _M
