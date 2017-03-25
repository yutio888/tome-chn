local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_EARTHEN_MISSILES",
	name = "岩石飞弹",
	info = function(self, t)
		local count = 2
		if self:getTalentLevel(t) >= 5 then
			count = count + 1
		end
		local damage = t.getDamage(self, t)
		return ([[释 放 出 %d 个 岩 石 飞 弹 射 向 任 意 射 程 内 的 目 标。 每 个 飞 弹 造 成 %0.2f 物 理 伤 害 和 每 回 合 %0.2f 流 血 伤 害， 持 续 5 回 合。 
		 在 等 级 5 时， 你 可 以 额 外 释 放 一 个 飞 弹。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(count,damDesc(self, DamageType.PHYSICAL, damage/2), damDesc(self, DamageType.PHYSICAL, damage/12))
	end,
}

registerTalentTranslation{
	id = "T_BODY_OF_STONE",
	name = "岩石身躯",
	info = function(self, t)
		local fireres = t.getFireRes(self, t)
		local lightningres = t.getLightningRes(self, t)
		local acidres = t.getAcidRes(self, t)
		local cooldownred = t.getCooldownReduction(self, t)
		local stunres = t.getStunRes(self, t)
		return ([[你 将 自 己 扎 根 于 土 壤 并 使 你 的 肉 体 融 入 石 头。 
		 当 此 技 能 被 激 活 时 你 不 能 移 动 并 且 任 何 移 动 会 打 断 此 技 能 效 果。 
		 当 此 技 能 激 活 时， 受 你 的 石 化 形 态 和 土 壤 相 关 影 响， 会 产 生 以 下 效 果： 
		* 减 少 岩 石 飞 弹、 粉 碎 钻 击、 地 震 和 山 崩 地 裂 冷 却 时 间 回 合 数： %d%%
		* 获 得 %d%% 火 焰 抵 抗， %d%% 闪 电 抵 抗， %d%% 酸 性 抵 抗 和 %d%% 震 慑 抵 抗。 
		 受 法 术 强 度 影 响， 抵 抗 按 比 例 加 成。]])
		:format(cooldownred, fireres, lightningres, acidres, stunres*100)
	end,
}

registerTalentTranslation{
	id = "T_EARTHQUAKE",
	name = "地震",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		local duration = t.getDuration(self, t)
		return ([[引 起 一 波 强 烈 的 地 震， 每 回 合 造 成 %0.2f 物 理 伤 害（ %d 码 半 径 范 围）， 持 续 %d 回 合。 有 概 率 震 慑 此 技 能 所 影 响 到 的 怪 物。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.PHYSICAL, damage), radius, duration)
	end,
}

registerTalentTranslation{
	id = "T_CRYSTALLINE_FOCUS",
	name = "水晶力场",
	info = function(self, t)
		local damageinc = t.getPhysicalDamageIncrease(self, t)
		local ressistpen = t.getResistPenalty(self, t)
		local saves = t.getSaves(self, t)
		return ([[你 专 注 于 维 持 水 晶 力 场， 增 加 你 %0.1f%% 所 有 物 理 伤 害 并 忽 略 目 标 %d%% 的 物 理 伤 害 抵 抗。 
		 同 时 增 加 你 %d 点 物 理 和 魔 法 豁 免。]])
		:format(damageinc, ressistpen, saves)
	end,
}


return _M
