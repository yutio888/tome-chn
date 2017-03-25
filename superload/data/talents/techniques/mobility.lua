local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DISENGAGE",
	name = "后跳",
	info = function (self,t)
		return ([[指 定 目 标 ， 向 后 跳 跃 %d 格 ， 可 以 跃 过 途 中 所 有 生 物 。
		你 必 须 选 择 可 见 目 标 ， 必 须 以 近 乎 直 线 的 轨 迹 后 跳 。
		落 地 后 ， 你 获 得 3 回 合 %d%% 移 动 速 度 加 成 ， 采 取 除 移 动 外 的 行 动 会 提 前 终 止。
		移 动 速 度 和 跳 跃 距 离 会 受 疲 劳 值 影 响 。]]):
		format(t.getDist(self, t), t.getSpeed(self,t), t.getNb(self,t))
	end,
}

registerTalentTranslation{
	id = "T_EVASION",
	name = "闪避",
	info = function (self,t)
		local chance, def = t.getChanceDef(self,t)
		return ([[你 的 战斗 技巧和反射神经让你能 迅速 躲闪 攻击 ，获得 %d%% 几率 躲闪 近战与 远程 攻击，闪避增加 %d ，持续 %d 回合。
		躲闪几率 和 闪避加成 受 敏捷加成。]]):
		format(chance, def,t.getDur(self,t))
	end,
}

registerTalentTranslation{
	id = "T_TUMBLE",
	name = "翻筋斗",
	info = function (self,t)
		return ([[你 迅速地移动至 范围内 可见的 位置，跃过 路径上 所有敌人。
		该技能 在 身着 重甲时不能使用 ， 使用后 你会进入 疲劳状态， 增加移动系 技能 消耗 %d%% （可以叠加）， %d 回合后 解除。]]):format(t.getExhaustion(self, t), t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TRAINED_REACTIONS",
	name = "特种训练",
	info = function (self,t)
		local stam = t.getStamina(self, t)
		local trigger = t.getLifeTrigger(self, t)
		local reduce = t.getReduction(self, t, true)*100
		return ([[经过 训练后， 你 脚步轻快，神经敏锐。
		技能开启时 ，你会 对 任何 将超过你 %d%% 最大生命值 的  伤害做出 反应。
		消耗 %0.1f 体力， 你将减少 %d%% 伤害。
		身着重甲 时无法使用。
		伤害减免受 闪避 加成。]])
		:format(trigger, stam, reduce)
	end,
}


return _M
