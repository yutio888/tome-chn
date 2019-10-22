local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ATTACK",
	name = "攻击",
	info = function(self, t)
		return ([[尽情砍杀吧宝贝！]])
	end,
}

registerTalentTranslation{
	id = "T_HUNTED_PLAYER",
	name = "被捕猎",
	info = function(self, t) return ([[你被捕猎了！
		每回合有 %d%% 几率半径 %d 的怪能在 30 回合内察觉你的位置。]]):
		format(math.min(100, 1 + self.level / 7), 10 + self.level / 5)
	end,
}

registerTalentTranslation{
	id = "T_TELEPORT_ANGOLWEN",
	name = "传送：安格利文",
	info = function(self, t)
return [[允许你传送至秘密的小镇：安格利文。 
		你已经在那里学习了很多魔法知识并且学会传送至这个小镇。 
		其他人是不允许学习这种法术的所以你施法时不能被任何生物看到。 
		法术将消耗一段时间生效，你施放法术及法术生效以前你必须保持在其他生物视线以外。]]
	end,
}

registerTalentTranslation{
	id = "T_TELEPORT_POINT_ZERO",
	name = "传送：零点圣域",
	info = function(self, t)
return[[允许你传送至时空守卫的大本营：零点圣域。 
		你已经在那里学习了很多时空魔法并且学会传送至此地。 
		其他人是不允许学习这种法术的所以你施法时不能被任何生物看到。 
		法术将消耗一段时间生效，在你施放法术及法术生效前你必须保持在其他生物视线以外。]]
	end,
}

registerTalentTranslation{
	id = "T_RELENTLESS_PURSUIT",
	name = "无尽追踪",
	info = function (self,t)
		local eff_desc = ""
		for e_type, fn in pairs(self.save_for_effects) do
			eff_desc = eff_desc .. ("\n%s 效果 -%d 回合"):format(e_type:gsub("physical","物理"):gsub("magical","魔法"):gsub("mental","精神"), t.getReduction(self, t, e_type))
		end
		return ([[无论是领主大人、失落之地的瑞库纳兽人还是瑞库纳传送门外那些令人恐怖的未知生物都无法阻止你寻找虹吸法杖的魔力。 
		孩子们会在将来用童谣来传唱你的无情。 
		当激活时，可以缩短所有不利效果的有效时间 ,20%% 相应豁免的回合或者 2 回合 , 取较低项。
		%s]]):
		format(eff_desc)
	end,
}

registerTalentTranslation{
	id = "T_SHERTUL_FORTRESS_GETOUT",
	name = "返回地面",
	info = function(self, t)
		return ([[使用堡垒自带的传送系统“哔”的一下回到地面。
		Requires being in flight above the ground of a planet.]])
	end,
}

registerTalentTranslation{
	id = "T_SHERTUL_FORTRESS_BEAM",
	name = "火力支援",
	info = function(self, t)
		return ([[消耗 10 点堡垒能量，将一股强大的爆炸能量送到地面，重创任何区域内的敌人。
		Requires being in flight above the ground of a planet.]])
	end,
}


return _M
