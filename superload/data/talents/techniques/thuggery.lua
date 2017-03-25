local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SKULLCRACKER",
	name = "铁头功",
	info = function(self, t)
		local dam = damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t))
		local duration = t.getDuration(self, t)
		return ([[你 用 前 额 猛 击 敌 人 头 部（ 或 者 任 意 你 能 找 到 的 有 效 位 置）， 造 成 %0.2f 物 理 伤 害。 如 果 
		此 次 攻 击 命 中， 则 目 标 会 混 乱( %d%% 强 度) %d 回 合。 
		受 头 盔 品 质、 力 量 和 物 理 伤 害 影 响， 伤 害 有 额 外 加 成。 
		受 敏 捷 和 命 中 影 响， 混 乱 强 度 和 概 率 有 额 外 加 成。 ]]):
		format(dam, t.getConfusion(self, t), duration)
	end,
}

registerTalentTranslation{
	id = "T_VICIOUS_STRIKES",
	name = "恶毒打击",
	info = function(self, t)
		return ([[你 知 道 如 何 击 中 目 标 弱 点， 使 你 获 得 +%d%% 暴 击 伤 害 加 成 和 %d 护 甲 穿 透。]]):
		format(t.critpower(self, t), t.getAPR(self, t))
	end,
}
registerTalentTranslation{
	id = "T_RIOT-BORN",
	name = "黑暗出生",
	info = function(self, t)
		return ([[你 与 生 俱 来 的 暴 力 意 识 令 你 在 战 斗 中 获 得 %d%% 震 慑 和 混 乱 免 疫 。]]):
		format(t.getImmune(self, t)*100)
	end,
}
registerTalentTranslation{
	id = "T_TOTAL_THUGGERY",
	name = "不择手段",
	info = function(self, t)
		return ([[你 疯 狂 地 杀 戮， 试 图 尽 快 击 倒 你 的 敌 人。 
		增 加 %d%% 攻 击 速 度， %d%% 暴 击 率 和 %d%% 物 理 抵 抗 穿 透， 但 是 每 次 攻 击 消 耗 6 点 体 力。
		该 效 果 在 休 息 或 者 奔 跑 时 自 动 解 除。
		]]):
		format(t.getSpeed(self,t)*100, t.getCrit(self, t), t.getPen(self, t))
	end,
}


return _M
