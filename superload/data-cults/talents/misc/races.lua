local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DREM_FRENZY",
	name = "狂热",
	info = function(self, t)
		return ([[进入杀戮狂热状态 3 回合。
		狂热状态下，  你使用的第一个职业技能不进入冷却（再次使用将进入冷却。）
		该效果对纹身、符文、瞬间技能以及固定冷却时间技能无效。
		]]):
		format()
	end,
}

registerTalentTranslation{
	id = "T_SPIKESKIN",
	name = "尖刺皮肤",
	info = function(self, t)
		return ([[ 你的皮肤生长出被黑暗和枯萎力量覆盖的尖刺。
		每回合你第一次被近战攻击命中时，尖刺对攻击者造成伤害，对方将在 5 回合内每回合受到 %0.2f 黑暗流血伤害。
		同时，你将被敌人的鲜血鼓舞， 2 格范围内每个流血生物（上限 %d ）为你提供 5%% 全体伤害抗性。
		伤害随魔法属性提升。]]):
		format(damDesc(self, DamageType.DARKNESS, t.getDamage(self, t)), t.getNb(self, t))
	end,
}

registerTalentTranslation{
	id = "T_FACELESS",
	name = "无面",
	info = function(self, t)
		return ([[你无面孔的脸没有情感，令人困惑。这让你更容易抵抗精神冲击。
		你获得 %d 精神豁免， %d%% 混乱免疫。]]):
		format(t.getSave(self, t), t.getImmune(self, t)*100)
	end,
}

registerTalentTranslation{
	id = "T_FROM_BELOW_IT_DEVOURS",
	name = "自深渊吞噬万物",
	info = function(self, t)
		return ([[ 你同地下深处某物的联系让你能召唤一只饥饿大嘴。
		每回合它将周围 10 格内生物朝自身拉近 2 格。
		它有 %d 额外生命，存在 %d 回合，不造成伤害。 
		它的额外生命取决于你的体质和技能等级。许多其他属性受等级影响。]]):
		format(t.getLife(self, t), t.getTime(self, t))
	end,
}

local oldinfo_stone_fortress = Talents.talents_def.T_STONE_FORTRESS.info
Talents.talents_def.T_STONE_FORTRESS.info = function(self, t)
	local desc = oldinfo_stone_fortress(self, t)
	return desc:gsub("\nFor Drems this effect activates as long as the hungering mouth summoned by From Below It Devours is alive.", "\n对于德瑞姆，这一技能效果将会在“自深渊吞噬万物”技能召唤的饥饿大嘴仍然存活时持续有效。")
end

registerTalentTranslation{
	id = "T_KROG_WRATH",
	name = "自然之怒",
	info = function(self, t)
		return ([[你释放持续 5 回合的自然的愤怒。
		愤怒状态下，每当你造成伤害时有 %d%% （每回合攻击的第一个生物 100%% ）几率震慑 3 回合。
		该效果每回合只能震慑一个敌人。
		震慑几率受体质影响，强度由物理或精神强度中较高一项决定。]]):
		format(t.getChance(self, t))
	end,
}
local Dialog = require "engine.ui.Dialog"
registerTalentTranslation{
	id = "T_DRAKE-INFUSED_BLOOD",
	name = "灌输龙血",
	action = function(self, t)
		local possibles = {
			{name=DamageType:get(DamageType.FIRE).text_color.."火龙 / 火焰抗性", damtype=DamageType.FIRE},
			{name=DamageType:get(DamageType.COLD).text_color.."冰龙 / 寒冷抗性", damtype=DamageType.COLD},
			{name=DamageType:get(DamageType.LIGHTNING).text_color.."风暴龙 / 闪电抗性", damtype=DamageType.LIGHTNING},
			{name=DamageType:get(DamageType.PHYSICAL).text_color.."沙龙 / 物理抗性 (数值减半)", damtype=DamageType.PHYSICAL},
			{name=DamageType:get(DamageType.NATURE).text_color.."野性龙 / 自然抗性", damtype=DamageType.NATURE},
		}
		local damtype = self:talentDialog(Dialog:listPopup("选择龙种", "选择你希望灌输的龙血种类:", possibles, 400, 400, function(item) self:talentDialogReturn(item) end))
		if damtype then
			self.drake_infused_blood_type = damtype.damtype
			self:updateTalentPassives(t.id)
		end
		self.krog_kills = 0
		return true
	end,
	info = function(self, t)
		local damtype = self.drake_infused_blood_type or DamageType.FIRE
		local resist = t.getResist(self, t)
		local damage = t.getRetaliation(self, t)
		if damtype == DamageType.PHYSICAL then 
			resist = resist / 2
			damage = damage / 2
		end
		local damname = DamageType:get(damtype).text_color..DamageType:get(damtype).name.."#LAST#"
		return ([[ 伊格除去了你身体内部肮脏的魔法符文，并改用龙血提供能量维持你的身体。
		龙血强化了你，使你获得 %d%% 震慑抗性， %d%% %s 伤害抗性， %d %s 近战附加伤害。
		你可以主动开启该技能来改变龙力类型，进而改变相应元素。
		抗性和附加伤害受意志值加成。
		改变类型需要战斗经验，你必须杀死 100 生物后才能使用（当前 %d）。
		
		当你学会该技能时，你变得如此强大，以至于能双持任何单手武器。]]):
		format(t.getImmune(self, t), resist,damname, damDesc(self, damtype, damage), damname, self.krog_kills or 0)
	end,
}

registerTalentTranslation{
	id = "T_FUEL_PAIN",
	name = "燃烧痛苦",
	info = function(self, t)
		return ([[你的身体习惯于痛苦。每次你受到超过 20%% 最大生命的伤害时，你的一个纹身将立刻冷却完毕，并移除符文饱和效果。
		该效果冷却时间为 %d 回合。]]):
		format(self:getTalentCooldown(t))
	end,
}

registerTalentTranslation{
	id = "T_WARBORN",
	name = "龙血打击",
	info = function(self, t)
		local damtype = self.drake_infused_blood_type or DamageType.FIRE
		local damname = DamageType:get(damtype).text_color..DamageType:get(damtype).name.."#LAST#"
		return ([[ 你被伊格制造的唯一理由：对魔法作战！
		打击你的敌人，造成 %d%% %s 武器伤害，并沉默它们 %d 回合。
		伤害类型根据龙血的类型而决定。
		沉默的几率受物理强度或精神强度的最高值加成。]]):format(100 * t.getDamage(self, t), damname, t.getDuration(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TAKE_A_BITE",
	name = "咬一口",
	info = function(self, t)
		return ([[ 你尝试用 #{italic}#头#{normal}# 咬你的敌人造成 %d%% 枯萎武器伤害。
		如果目标被咬后生命不足 20%% ，你有 %d%% 几率直接杀死它（对 boss 无效）。
		你咬中以后 5 回合内每回合回复 %0.1f 生命。
		秒杀几率和生命回复受体质加成，武器伤害受力量敏捷魔法中最高值影响。]]):
		format(t.getDam(self, t) * 100, t.getChance(self, t), t.getRegen(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ULTRA_INSTINCT",
	name = "终极本能",
	info = function(self, t)
		return ([[ 没有 #{bold}#思维#{normal}# 和 #{bold}#自我#{normal}# 的干扰，你的身体全凭本能行动，反应速度更快。
		整体速度增加 %d%% 。]]):
		format(t.getSpeed(self, t) * 100)
	end,
}

registerTalentTranslation{
	id = "T_CORRUPTING_INFLUENCE",
	name = "堕落影响",
	info = function(self, t)
		return ([[ 寄生在你身体里的堕落力量渗出了你的身体，给予你强化。
		增加 %d%% 枯萎、黑暗、时空和酸性伤害抗性，同时减少 %d%% 自然和光系伤害抗性。]]):format(t.getResist(self, t), t.getResist(self, t) / 3)
	end,
}

registerTalentTranslation{
	id = "T_HORROR_SHELL",
	name = "恐惧外壳",
	info = function(self, t)
		return ([[在你身边制造一层持续 10 回合吸收 %d 伤害的外壳。
		吸收量受体质加成。]]):
		format(t.getShield(self, t))
	end,
}
return _M
