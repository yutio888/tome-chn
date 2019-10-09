local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DARK_REIGN",
	name = "黑暗支配",
	info = function(self, t)
		return ([[你与阴影的联系更加紧密了。
		 每次你用暗影伤害杀死生物或造成超过 %d%% 最大生命的伤害时，你获得 8%% 全体伤害吸收，持续 10 回合。
		 这个效果能叠加至最多 %d 层，每回合至多叠加 1 层。]]):
		format(t.getThreshold(self, t)*100,t.getStack(self, t))
	end,
}


registerTalentTranslation{
	id = "T_DREAD_END",
	name = "黑暗终结",
	info = function(self, t)
		return ([[你学会利用死亡来获取力量。
		 当黑暗支配开启，每次你使用非暗影伤害杀死生物或造成超过 %d%% 最大生命的伤害时，产生半径 1 的黑暗能量池，持续 5 回合。
		 能量池将在半径 %d 范围内的随机敌人处生成。
		 任何站在里面的敌人每回合将受到 %0.2f 点暗影伤害。
		 这个效果每回合最多触发一次。
		 伤害受法术强度加成。
		 技能等级 3 或以上时，当你处于黑暗支配状态下，每一层状态使你获得 -%d 生命底限。]])
		:format(t.getThreshold(self, t)*100, t.getTargetRadius(self, t), t.getDamage(self, t), t.getDieAt(self, t) )
	end,
}

registerTalentTranslation{
	id = "T_BLOOD_PACT",
	name = "鲜血契约",
	info = function(self, t)
		return ([[支付 %d%% 当前生命值， 1 回合内你造成的所有伤害转化为黑暗伤害。
		 如果黑暗支配开启，每有一层，你获得 %d 体力与 %d 活力。]]):
		format(t.getLifeCost(self, t)*100, t.getStamina(self, t),t.getVim(self, t))		
	end,
}


registerTalentTranslation{
	id = "T_ERUPTING_DARKNESS",
	name = "黑暗爆发",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[当黑暗终结制造出黑暗能量池时，你能将愤怒集中在内，将其转变为火山。
		 半径 %d 内至多 %d 个能量池将会喷发，转化为火山，持续 %d 回合。
		 每回合火山将喷射火焰巨石，造成 %0.2f 火焰与 %0.2f 物理伤害。
		 效果受法术强度加成。]]):
		format(self:getTalentRadius(t), t.getNb(self, t), t.getDuration(self, t), dam/2,dam/2)
	end,
}


return _M
