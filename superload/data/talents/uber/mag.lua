local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SPECTRAL_SHIELD",
	name = "无光之盾",
	["require.special.desc"] = "掌握格挡技能，曾释放过 100 个法术，且格挡强度超过 200",
	info = function(self, t)
		return ([[向护盾中灌注魔法序列，使格挡技能能够格挡任何类型的伤害。]])
		:format()
	end,
}
registerTalentTranslation{
	id = "T_ETHEREAL_FORM",
	name = "虚幻形态",
	["require.special.desc"]  = "闪避有效值超过40。",
	info = function(self, t)
		return ([[你获得 25%% 绝对伤害抗性， 25%% 全体伤害抗性穿透。
		每当你被武器攻击的时候，这项增益会减少 5%% ，8 回合后完全恢复。
		此外，你将获得相当于你魔法值和敏捷值中最高的一项   70%% 的闪避值 (%d) ]])
		:format(math.max(self:getMag(), self:getDex()) * 0.7)
	end,

}
registerTalentTranslation{
	id = "T_AETHER_PERMEATION",
	name = "以太渗透",
	["require.special.desc"] = "拥有至少 25% 以上的奥术抗性，并且曾去过无尽虚空",
	info = function(self, t)
		return ([[在你的周围创造一层厚实的以太层，任何伤害均会使用奥术抵抗代替原本攻击类型抵抗进行抵抗计算。 
		实际上，你的所有抵抗约等于你 66%% 的奥术抗性。
		你的奥术抗性增加 20%%，抗性上限增加 10%% 。]])
		:format()
	end,
}


registerTalentTranslation{
	id = "T_ARCANE_MIGHT",
	name = "奥术之握",
	info = function(self, t)
		return ([[你学会如何利用自己潜在的奥术力量，将它们注入你的武器。 
		所有武器均有额外的 50％魔法加成。
		你的基础物理强度增加等同于 100%% 基础法强的数值。
		你的物理暴击率增加等同于 25%% 法术暴击率的数值。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_TEMPORAL_FORM",
	name = "时空形态",
	["require.special.desc"] = "曾释放过 1000 个以上的技能并且成功进入过相位现实。",
	info = function(self, t)
		return ([[你可以扭曲周围的时间线，转换成时空元素“泰鲁戈洛斯”形态，持续 10 回合。 
		在这种形态中，你对定身、流血、致盲、震慑免疫，获得 30％时空抵抗和 20％的时空抵抗穿透。 
		你造成的伤害的 50%% 转化为时空伤害。 
		同时，你的时空伤害增益等于你所有类型的伤害增益中的最大值，此外，还增加 30％额外时空伤害增益。
		你在时空形态下能释放以下异常：异常：重排, 异常：时空风暴 , 异常：不完美设计 ,  异常：重力井和异常：虫洞.
		]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_BLIGHTED_SUMMONING",
	name = "枯萎召唤",
	["require.special.desc"] = "曾召唤了 100 个以上此技能相关的召唤生物（炼金傀儡视作 100 单位）",
	info = function(self, t)
		local tl = t.bonusTalentLevel(self, t)
		return ([[ 你将枯萎元素注入你的召唤兽体内，给予它们新的技能( 等级 %d )： 
		- 战争猎犬 : 衰竭诅咒  - 黑果冻怪 : 活力感知 
		- 米诺陶 : 生命源泉 - 岩石傀儡 : 白骨之矛 
		- 火焰里奇 : 枯萎吸收 - 三头蛇 : 鲜血喷射 
		- 雾凇 : 剧毒风暴 - 火龙 : 黑暗之炎 
		- 乌龟 : 虚弱诅咒 - 蜘蛛 : 腐蚀蠕虫 
		- 骷髅 : 白骨之握或白骨之矛 - 骨巨人 : 骨盾 
		- 食尸鬼 : 鲜血禁锢 - 吸血鬼 / 巫妖 : 黑暗之炎 
		- 梦靥 / 尸妖 : 鲜血沸腾 
		- 炼金傀儡 : 堕落力量和掠夺格斗系技能树 
		- 阴影 : 转移邪术 - 精神体战士 : 乌鲁洛克之焰 
		- 树人 : 腐蚀蠕虫 - 夺心魔精英 : 黑暗之门 
		- 食尸鬼傀儡 : 撕裂 
		- 浮肿软泥怪 : 白骨护盾 ( 等级 %d )
		- 粘液软泥怪 : 剧毒瘟疫 
		 你的死灵召唤和自然召唤会得到魔法加成。
		 技能等级随人物等级增加。 
		 其他种族和物品召唤物也有可能被影响。]])
		 :format(tl,math.ceil(tl*2/3))
	end,
}

registerTalentTranslation{
	id = "T_REVISIONIST_HISTORY",
	name = "修正历史",
	["require.special.desc"] = "曾经至少进行过一次时空穿越",
	info = function(self, t)
		return ([[你现在可以控制不远的过去。使用技能后获得一个持续 20 轮的时空效果。 
		 在效果持续时间内，再次使用技能即可回到第 
		 一次使用的时间点重新来过。 
 		 这个法术会使时间线分裂，所以其他同样能使 
		 时间线分裂的技能在此期间不能成功释放。  ]])
		:format()
	end,
}
registerTalentTranslation{
	id = "T_REVISIONIST_HISTORY_BACK",
    name = "改写历史",
	info = function(self, t)
		return ([[改写历史，返回到修正历史施法点。]])
		:format()
	end,
}

registerTalentTranslation{
	id = "T_CAUTERIZE",
	name = "浴火重生",
	["require.special.desc"] = "曾承受过至少 7500 点火焰伤害，并且至少曾释放过 1000 次法术。",
	info = function(self, t)
		return ([[你的心炎是如此强大。每当你受到必死的攻击时，你的身体会被圣焰所环绕。 
		 圣焰会修复伤口，完全吸收此次攻击伤害，但是它们将会继续燃烧，持续 8 回合。 
		 每回合圣焰会对你造成 10％刚才吸收的伤害（此伤害会自动忽略护甲和抵抗）。 
		 警告：此技能有冷却时间，慎用。  ]])
	end,
}

registerTalentTranslation{
	id = "T_MYSTICAL_CUNNING",
	name = "魔之秘术",
	["require.special.desc"] = "掌握陷阱或者毒药技能",
	info = function(self, t)
		local descs = ""
		for i, tid in pairs(t.autolearn_talent) do
			local bonus_t = self:getTalentFromId(tid)
			if bonus_t then
				descs = ("%s\n#YELLOW#%s#LAST#\n%s\n"):format(descs,bonus_t.name,self:callTalent(bonus_t.id,"info"))
			end
		end
		return ([[通过对奥术之力的研究，你开发出了新的陷阱和毒药（由学习此进阶时掌握的技能决定） 
		你在灵巧 / 毒药系和灵巧 / 陷阱系技能树上获得 1 . 0 系数。
		你的毒素爆发技能冷却时间减少 3。
		你的诱饵技能冷却时间减少 5。

		你可以学会： 
%s]])
		:format(descs)
	end,

}

return _M
