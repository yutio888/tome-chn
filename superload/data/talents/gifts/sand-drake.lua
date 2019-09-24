local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SWALLOW",
	name = "吞噬",
	info = function(self, t)
		return ([[对 目 标 造 成 %d%% 自 然 武 器 伤 害。 
		如果这个攻击将目标的生命值降低到其最大生命值的一定比例以下（基于技能等级和两者体型大小）或杀死了它，你会吞噬它，立刻将其杀死，并根据其等级恢复生命值和失衡值。
		对方会与你的物理强度进行豁免对抗，以防被吞噬。
		同 时 ， 这 个 技 能 还 能 被 动 提 升 你 的 物 理 和 精 神 暴 击 率 %d%% 。
		每 点 土 龙 系 的 天 赋 可 以 使 你 增 加 物 理 抵 抗 0.5%% 。
		如果你装备了盾牌，这一技能也会用你的盾牌攻击。

		基于你目前的体型，吞噬的生命值上限如下所示：
		微小:  %d%%
		矮小:  %d%%
		中等:  %d%%
		高大:  %d%%
		庞大:  %d%%
		巨型:  %d%%]]):
		format(100 * t.getDamage(self, t), t.getPassiveCrit(self, t),
			t.maxSwallow(self, t, 1),
			t.maxSwallow(self, t, 2),
			t.maxSwallow(self, t, 3),
			t.maxSwallow(self, t, 4),
			t.maxSwallow(self, t, 5),
			t.maxSwallow(self, t, 6))
	end,
}

registerTalentTranslation{
	id = "T_QUAKE",
	name = "地震",
	info = function(self, t)
		local radius = self:getTalentRadius(t)
		local dam = t.getDamage(self, t)
		return ([[你 猛 踩 大 地， 在 %d 码 范 围 内 造 成 地 震。 
		 在 地 震 范 围 内 的 怪 物 会 受 到 %d%% 武 器 伤 害 并 被 击 退 3 码。 
		 在 地 震 范 围 内 的 地 形 也 会 受 到 影 响。 
		 每 点 土 龙 系 的 天 赋 可 以 使 你 增 加 物 理 抵 抗 0.5%% 。]]):format(radius, dam*100)
	end,
}

registerTalentTranslation{
	id = "T_BURROW",
	name = "土遁",
	info = function(self, t)
		return ([[允 许 你 钻 进 墙 里， 持 续 %d 回 合。
		 你 强 大 的 挖 掘 能 力 让 你 能 挖 掘 敌 人 的 防 御 弱 点； 处 于 该 状 态 下 时 你 获 得 %d 护 甲 穿 透 和 %d%% 物 理 抗 性 穿 透 。
         在 技 能 等 级 5 时 ， 这 个 技 能 变 成 瞬 发 。 冷 却 时 间 随 技 能 等 级 升 高 而 降 低 。
		 每 点 土 龙 系 的 天 赋 可 以 使 你 增 加 物 理 抵 抗 0.5%% 。]]):format(t.getDuration(self, t), t.getPenetration(self, t), t.getPenetration(self, t) / 2)
	end,
}

registerTalentTranslation{
	id = "T_SAND_BREATH",
	name = "沙瀑吐息",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 在 前 方 %d 码 锥 形 范 围 内 喷 出 流 沙。 此 范 围 内 的 目 标 会 受 到 %0.2f 物 理 伤 害 并 被 致 盲 %d 回 合。 
		 受 力 量 影 响， 伤 害 有 额 外 加 成。 技 能 暴 击 率 基 于 精 神 暴 击 值 计 算，致盲几率基于你的精神强度。
		 每 点 土 龙 系 的 天 赋 可 以 使 你 增 加 物 理 抵 抗 0.5%% 。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, damage), duration)
	end,
}


return _M
