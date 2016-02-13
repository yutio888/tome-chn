local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_THROW_BOMB",
	name = "炸弹投掷",
	info = function(self, t)
		local ammo = self:hasAlchemistWeapon()
		local dam, damtype = 1, DamageType.FIRE
		if ammo then dam, damtype = t.computeDamage(self, t, ammo) end
		dam = damDesc(self, damtype, dam)
		return ([[向 一 块 炼 金 宝 石 内 灌 输 爆 炸 能 量 并 扔 出 它。 
		 宝 石 将 会 爆 炸 并 造 成 %0.1f 的 %s 伤 害。 
		 每 个 种 类 的 宝 石 都 会 提 供 一 个 特 殊 的 效 果。 
		 受 宝 石 品 质 和 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(dam, DamageType:get(damtype).name)
	end,
}

registerTalentTranslation{
	id = "T_ALCHEMIST_PROTECTION",
	name = "炼金保护",
	info = function(self, t)
		return ([[提 高 你 和 其 他 友 好 生 物 对 自 己 炸 弹 %d%% 的 元 素 伤 害 抵 抗， 并 增 加 %d%% 对 外 界 的 元 素 伤 害 抵 抗。 
		 在 等 级 5 时 它 同 时 会 保 护 你 免 疫 你 的 炸 弹 所 带 来 的 特 殊 效 果。]]):
		format(math.min(100, self:getTalentLevelRaw(t) * 20), self:getTalentLevelRaw(t) * 3)
	end,
}

registerTalentTranslation{
	id = "T_EXPLOSION_EXPERT",
	name = "爆破专家",
	info = function(self, t)
		local min, max = t.minmax(self, t)
		return ([[炼 金 炸 弹 的 爆 炸 半 径 现 在 增 加 %d 码。
		 增 加 %d%% （ 地 形 开 阔 ） ～ %d%% （ 地 形 狭 窄 ） 爆 炸 伤 害。 ]]):
		format(t.getRadius(self, t), min*100, max*100) 
	end,
}

registerTalentTranslation{
	id = "T_SHOCKWAVE_BOMB",
	name = "烈性炸弹",
	info = function(self, t)
		local ammo = self:hasAlchemistWeapon()
		local dam, damtype = 1
		if ammo then dam = t.computeDamage(self, t, ammo) end
		dam = damDesc(self, DamageType.PHYSICAL, dam)
		return ([[将 2 颗 炼 金 宝 石 压 缩 在 一 起， 使 它 们 变 的 极 度 不 稳 定。 
		 然 后， 你 将 它 们 扔 到 指 定 地 点， 爆 炸 会 产 生 %0.2f 物 理 伤 害 并 击 退 爆 炸 范 围 内 的 任 何 怪 物。 
		 每 个 种 类 的 宝 石 都 会 提 供 一 个 特 殊 的 效 果。 
		 受 宝 石 品 质 和 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(dam)
	end,
}


return _M
