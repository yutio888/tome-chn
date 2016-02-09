local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STONE_SKIN",
	name = "石化皮肤",
	info = function(self, t)
		local armor = t.getArmor(self, t)
		return ([[施 法 者 的 皮 肤 变 的 和 岩 石 一 样 坚 硬， 提 高 %d 点 护 甲。 
		 受 法 术 强 度 影 响， 护 甲 有 额 外 加 成。]]):
		format(armor)
	end,
}

registerTalentTranslation{
	id = "T_DIG",
	name = "粉碎钻击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local nb = t.getDigs(self, t)
		return ([[ 射 出 一 道 能 击 碎 岩 石 的 强 有 力 的 射 线， 挖 掘 路 径 上 至 多 %d 块 墙 壁。 
	 	 射 线 同 时 对 路 径 上 的 所 有 生 物 造 成 %0.2f 点 物 理 伤 害。 
		 受 法 术 强 度 影 响，伤 害 有 额 外 加 成。 ]]):
		format(nb, damDesc(self, DamageType.PHYSICAL, damage))
	end,
}

registerTalentTranslation{
	id = "T_MUDSLIDE",
	name = "山崩地裂",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[召 唤 一 次 山 崩 对 敌 人 造 成 %0.2f 点 物 理 伤 害（ %d 码 锥 形 范 围）。 
		 范 围 内 的 任 何 敌 人 都 将 被 击 退。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.PHYSICAL, damage), self:getTalentRadius(t))
	end,
}

registerTalentTranslation{
	id = "T_STONE_WALL",
	name = "岩石堡垒",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local damage = t.getDamage(self, t)
		return ([[召 唤 岩 石 堡 垒 环 绕 着 你， 持 续 %d 回 合。 
		 在 等 级 4 时， 它 可 以 环 绕 其 他 目 标。
		 范 围 内 的 任 何 敌 对 生 物 将 受 到 %0.2f 点 物 理 伤 害。 
		 受 法 术 强 度 影 响， 持 续 时 间 和 伤 害 有 额 外 加 成。]]):
		format(duration, damDesc(self, DamageType.PHYSICAL, damage))
	end,
}


return _M
