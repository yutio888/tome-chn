local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_WORM_THAT_WALKS_LINK",
	name = "蠕虫合体链接",
	info = function(self, t) return ([[链接至召唤者]]) end,
}

registerTalentTranslation{
	id = "T_WORM_THAT_WALKS",
	name = "蠕虫合体",
	info = function(self, t)
		return ([[你激活同蠕虫合体的契约，令其帮助你。
		你可以完全控制它，装备它。
		使用该法术将复活已死亡的单位，使其获得 %d%% 生命。
		原始技能等级提升将带来更多装备格：
		等级 1 ：主手 /副手武器
		等级 2 ：躯体
		等级 3 ：腰带
		等级 4 ：戒指 /戒指
		等级 5 ：戒指 /戒指/ 饰品
		
		试图改变其装备时，先将装备交给它，再切换控制。]]):
		format(t.getPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_WORM_THAT_STABS",
	name = "夹击", 
	info = function(self, t)
		return ([[你和蠕虫合体同时传送至 %d 内的目标处，造成 %d%% 近战伤害。
		你的蠕虫合体的闪电突袭技能冷却时间减少 %d 。]])
		:format(10, t.getDamage(self, t) * 100, t.getBlindside(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHARED_INSANITY",
	name = "共享疯狂",
	info = function(self, t)
		return ([[ 你和蠕虫合体建立强大的精神链接。
		只要你和它的距离不超过 3 格，你们均获得持续 5 回合的 %d%% 全体抗性。
		该技能每增加两级原始等级，你的蠕虫合体获得一个纹身位（当前： %d ）。]])
		:format(t.getResist(self, t), t.getInscriptions(self, t))
	end,
}
	
registerTalentTranslation{
	id = "T_TERRIBLE_SIGHT",
	name = "恐怖景象",
	info = function(self, t)
		return ([[ 当你处于蠕虫合体 3 格范围内时，你可以制造恐怖光环。
		看到两个疯狂恐魔并肩作战将令周围 %d 格的敌人震慑 %d 回合，除非它们的物理豁免成功对抗了你的法术强度。
		此外，你的共享疯狂效果将令 3 格内的敌人在 3 回合里失去 %d 法术豁免和 %d 闪避。]]):
		format(self:getTalentRange(t), t.getDur(self, t), t.getSave(self, t), t.getSave(self, t))
	end,
}

return _M
