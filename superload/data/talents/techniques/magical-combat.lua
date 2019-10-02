local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ARCANE_COMBAT",
	name = "奥术武器",
	info = function(self, t)
		local talent_list = ""
		local build_string = {}
		for _, talent in pairs(self.talents_def) do
			if talent.allow_for_arcane_combat and talent.name then
				if #build_string > 0 then build_string[#build_string+1] = ", " end
				build_string[#build_string+1] = talent.name
			end
		end
		if #build_string > 0 then talent_list = table.concat(build_string) end
		
		local talent_selected = ""
		if self:isTalentActive(t.id) then
			local talent = self:getTalentFromId(self:isTalentActive(t.id).talent)
			if talent and talent.name then
				talent_selected = [[
				
				当前选择法术: ]] .. talent.name
			else
				talent_selected = [[
				
				当前选择法术: 随机]]
			end
		end
		return ([[允 许 你 使 用 近 战 武 器 附 魔 法 术。 在 你 每 次 的 近 战 攻 击 中 都 有 %d%% 概 率 附 加 一 次 火 球 术、 闪 电 术 或 岩 石 飞 弹 。 
		你 可 以 选 择 触 发 某 一 种 法 术 ， 或 者 选 择 随 机 触 发 任 意 一 种 法 术。
		当 双 持 或 持 有 盾 牌 时，  每 把 武 器 触 发 概 率 减 半。
		通 过 这 种 方 式 触 发 的 法 术 不 会 造 成 对 应 技 能 进 入 CD 状 态。
		受 灵 巧 影 响， 触 发 概 率 有 额 外 加 成。
		允 许 法 术 ： %s %s]]):
		format(t.getChance(self, t), talent_list, talent_selected)
	end,
}


registerTalentTranslation{
	id = "T_ARCANE_CUNNING",
	name = "奥术灵巧",
	info = function(self, t)
		local spellpower = t.getSpellpower(self, t)
		local bonus = self:getCun()*spellpower/100
		return ([[你 额 外 增 加 相 当 于 你 %d%% 灵 巧 值 的 法 术 强 度。（当前加成：%d）]]):
		format(spellpower, bonus)
	end,
}

registerTalentTranslation{
	id = "T_ARCANE_FEED",
	name = "奥术充能",
	info = function(self, t)
		return ([[当 技 能 激 活 时， 每 回 合 恢 复 %0.2f 法 力 值 并 提 高 %d%% 物 理 及 法 术 爆 击 几 率。]]):format(t.getManaRegen(self, t), t.getCritChance(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ARCANE_DESTRUCTION",
	name = "奥术毁灭",
	info = function(self, t)
		return ([[通 过 你 的 武 器 来 传 送 原 始 的 魔 法 伤 害。 增 加 相 当 于 你 %d%% 魔 法 属 性 值 的 物 理 强 度 （ 当 前 值 ： %d ） 。
		每 当 你 近 战 攻 击 暴 击 时， 你 会 释 放 一 个 半 径 为 %d 码 的 奥 术 属 性 的 魔 法 球， 造 成 %0.2f 的 伤 害。 
		受 法 术 强 度 影 响， 增 益 按 比 例 加 成。
		当 双 持 或 持 有 盾 牌 时，只有50%%的几率触发。
		技 能 等 级 5 时 ， 魔 法 球 的 半 径 变 成 2。]]):
		format(t.getSPMult(self, t)*100, self:getMag() * t.getSPMult(self, t), self:getTalentRadius(t), damDesc(self, DamageType.ARCANE, t.getDamage(self, t)) )
	end,
}


return _M
