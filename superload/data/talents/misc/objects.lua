local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ARCANE_SUPREMACY",
	name = "奥术至尊",
	info = function(self, t)
		local count = t.getRemoveCount(self, t)
		return ([[移除 %d 个负面魔法效果，并且使你进入奥术强化状态 10 回合，增加 5 点法术强度和法术豁免，每移除一个 DEBUFF，额外增加 5 点法术强度和法术豁免。]]):
		format(count)
	end,
}

registerTalentTranslation{
	id = "T_COMMAND_STAFF",
	name = "法杖掌控",
	message = function(self, t)
		return ("@Source@ 重新汇集 %s 法杖中的能量。"):format(self:his_her())
	end,
	info = function(self, t)
		return ([[改变法杖中流动的能量性质。]])
	end,
}

registerTalentTranslation{
	id = "T_WARD",
	name = "守护",
	info = function(self, t)
		local xs = ""
		for w, nb in pairs(self.wards) do
			local kind=engine.DamageType.dam_def[w].name:capitalize();
			kind=kind:gsub("fire"," 火焰 "):gsub("lightning"," 闪电 "):gsub("arcane"," 奥术 "):gsub("cold"," 寒冷 ")
				:gsub("blight"," 枯萎 "):gsub("darkness"," 暗影 "):gsub("physical"," 物理 "):gsub("temporal"," 时空 ")
				:gsub("light"," 光系 "):gsub("acid"," 酸性 "):gsub("mental"," 精神 "):gsub("nature"," 自然 ")
			xs = xs .. (xs ~= "" and ", " or "") .. engine.DamageType.dam_def[w].name:capitalize() .. "(" .. tostring(nb) .. ")"
		end
		return ([[激活指定伤害类型的抵抗状态，能够完全抵抗对应属性的伤害。抵抗次数由魔杖决定。
		你能激活的伤害类型有： %s]]):format(xs)
	end,
}

registerTalentTranslation{
	id = "T_YIILKGUR_BEAM_DOWN",
	name = "回到地面",
	info = function(self, t)
		return ([[使用伊克格的传送阵传送回地面。]])
	end,
}

registerTalentTranslation{
	id = "T_BLOCK",
	name = "格挡",
	info = function(self, t)
		local properties = t.getProperties(self, t)
		local sp_text = ""
		local ref_text = ""
		local br_text = ""
		if properties.sp then
			sp_text = (" 那回合增加 %d 点法术豁免."):format(t.getBlockValue(self, t))
		end
		if properties.ref then
			ref_text = " 反弹所有格挡的伤害 ."
		end
		if properties.br then
			br_text = " 所有格挡的伤害值会治疗玩家 ."
		end
		local bt, bt_string = t.getBlockedTypes(self, t)
		return ([[举起你的盾牌进入防御姿态 2 回合，减少所有非精神攻击伤害 %d 。如果你完全格挡了一次攻击，攻击者将遭到一次致命的反击（一次普通攻击将造成 200%% 伤害），持续 1 回合。 
		每次格挡通常只能反击一个敌人。
		如果有任何伤害被成功格挡，此效果将在回合开始时移除。
		如果盾牌对格挡伤害类型有伤害抗性，则格挡值增加50%% 。
		
		当前加成: %s%s%s%s]]):
		format(t.getBlockValue(self, t), bt_string, sp_text, ref_text, br_text)
end,
}

registerTalentTranslation{
	id = "T_BLOOM_HEAL",
	name = "夏花之愈",
	info = function(self, t)
		return ([[呼唤自然的力量每回合恢复你 %d 生命值持续 6 回合。 
		受意志影响，恢复量有额外加成。]]):format(7 + self:getWil() * 0.5)
	end,
}

registerTalentTranslation{
	id = "T_DESTROY_MAGIC",
	name = "禁魔",
	info = function(self, t)
		return ([[ 目标有 %d%% 概率（最大叠加至 %d%% ）施法失败率。等级 2 时魔法效果可能会被打断。等级 3 时持续性法术可能会被打断。等级 5 时魔法生物和不死族可能会被震慑。]]):format(t.getpower(self, t),t.maxpower(self,t))
	end,
}

registerTalentTranslation{
	id = "T_BATTLE_TRANCE",
	name = "战意勃发",
	info = function(self, t)
		return ([[ 你进入了战斗狂热状态，获得 15 ％全体伤害抗性，减少 15 点精神强度并获得 20 点精神豁免。技能激活 5 回合后，每回合你都有一定几率疲劳，终止技能并进入混乱状态。]])
	end,
}

registerTalentTranslation{
	id = "T_SOUL_PURGE",
	name = "解放灵魂",
	info = function(self, t)
		return ([[除去 Morrigor 吸收的所有技能。]])
	end,
}

registerTalentTranslation{
	id = "T_DIG_OBJECT",
	name = "挖掘",
	info = function(self, t)
		local best = t.findBest(self, t) or {digspeed=100}
		return ([[ 挖掘消耗 %d 回合 ( 基于你携带的最好锄头 )。]])
		:format(best.digspeed)
	end,
}

registerTalentTranslation{
	id = "T_SHIV_LORD",
	name = "寒冰元素",
	info = function(self, t)
		local power = t.getPower(self, t)
		local dur = t.getDuration(self, t)
		return ([[你吸收周围的寒冰围绕你，将自己转变为纯粹的冰元素——西弗格罗斯，持续 %d 回合。 
		转化成元素后，你不需要呼吸并获得等级 %d 的冰雪风暴，获得 %d%% 切割和震慑抵抗， %d%% 寒冰抗性 ,所有冰冷伤害可对你产生治疗，治疗量基于伤害值的 %d%% 。 
		受法术强度影响，效果有额外加成。]]):
		format(dur, self:getTalentLevelRaw(t), power * 100, power * 100 / 2, 50 + power * 100)
	end,
}

registerTalentTranslation{
	id = "T_MENTAL_REFRESH",
	name = "振作精神",
	info = function(self, t)
		return ([[ 刷新至多 3 个自然，超能或诅咒系技能。]])
	end,
}

registerTalentTranslation{
	id = "T_DAGGER_BLOCK",
	name = "匕首格挡",
	info = function(self, t)
		return ([[ 举起你的匕首来格挡攻击一回合，减少所有物理伤害 %d 点。如果你完全格挡了一次攻击的伤害，攻击者将进入致命的被反击状态（对其攻击伤害加倍）一回合并被缴械三回合。
		格挡值随敏捷和灵巧增加。]]):format(t.getPower(self, t))
	end,
}

registerTalentTranslation{
	id = "T_SHIELDSMAIDEN_AURA",
	name = "女武神之守护",
	info = function(self, t)
		return ([[每 10 回合能自动抵抗一次攻击 .]])
	end,
}

registerTalentTranslation{
	id = "T_PSIONIC_MAELSTROM",
	name = "灵能风暴",
	info = function(self, t)
		return ([[接下来 8 回合内，强大的灵能能量在你身边爆发，造成 %d 伤害。]]):format(t.getDamage(self, t))
	end,
}

registerTalentTranslation{
	id = "T_MELEE_RETALIATION",
	name = "近战报复",
	info = function(self, t)
		return ([[近战报复。]])
	end,
}

return _M
