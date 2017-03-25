local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DIRTY_FIGHTING",
	name = "卑劣攻击",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		local power = t.getPower(self,t)
		return ([[你 攻 击 目 标 的 敏 感 部 位，造 成 %d%% 徒 手 伤 害。如 果 攻 击 命 中， 目 标 身 受 重 创，物 理 豁 免 减 少 %d ，震 慑 、 致 盲 、 混 乱 、 定 身 免 疫 降 低 为 原 来 的 50%% ，持 续 %d 回合。
该 效 果 无 视 豁 免。]]):
		format(100 * damage, power, duration)
	end,
}

registerTalentTranslation{
	id = "T_BACKSTAB",
	name = "背刺",
	info = function(self, t)
		local dam = t.getDamageBoost(self, t)
		local chance = t.getDisableChance(self,t)
		return ([[你 机 智 地 利 用 敌 人 的 伤 残，每 项 伤 残 效 果 增 加 %d%%伤 害 ，最 多 %d%%。
伤 残 效 果 包 括 ：震 慑 、致 盲 、眩 晕 、定 身 、缴 械 、致 残 和 沉 默 。
此 外 ，每 项 伤 残 效 果 使 你 的 近 战 攻 击 有 %d%%几 率 （最 多 叠 加 至 %d%%）附 加 额 外 效 果 （不 会 重 复 ）：缴 械 、致 残 （25%%强 度 ）或 者 定 身 2 回 合 。
附 加 效 果 成 功 率 受 命 中 加 成 。 ]]):
		format(dam, dam*3, chance, chance*3)
	end,
}

registerTalentTranslation{
	id = "T_BLINDING_POWDER",
	name = "致盲粉",
	info = function (self,t)
		local accuracy = t.getAcc(self,t)
		local speed = t.getSlow(self,t)
		local duration = t.getDuration(self, t)
		return ([[撒 出 致 盲 粉 ，致 盲 前 方 %d 格 锥 形 范 围 内 的 敌 人 。受 影 响 的 敌 人 命 中 减 少  %d  ，移 动 速 度 减 少  %d%%  ，持 续  %d  回 合 。
		 效 果 成 功 率 受 命 中 加 成 。]]):format(self:getTalentRadius(t), accuracy, speed, duration)
	end,
}

registerTalentTranslation{
	id = "T_TWIST_THE_KNIFE",
	name = "扭曲刀刃",
	info = function (self,t)
		local damage = t.getDamage(self, t)
		local dur = t.getDuration(self, t)
		local nb = t.getDebuffs(self, t)
		return ([[攻 击 敌 人 造 成  %d%%  武 器 伤 害 ，并 延 长 对 方 身 上 至 多  %d  项 负 面 效 果 持 续 时 间  %d  回 合 。每 延 长 一 项 负 面 效 果 ，相 应 减 少 一 项 正 面 效 果 持 续 时 间 。]]):
		format(100 * damage, nb, dur)
	end,
}



return _M
