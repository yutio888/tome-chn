actorCHN = {}


actorCHN["male"] = "男性"
actorCHN["female"] = "女性"

--角色类别
actorCHN["Unknown"] = "未知生物"
actorCHN["Humanoid"] = "人形生物"
actorCHN["Insect"] = "昆虫"
actorCHN["Aquatic"] = "水栖生物"
actorCHN["Animal"] = "动物"
actorCHN["Undead"] = "亡灵"
actorCHN["Dragon"] = "龙"
actorCHN["Construct"] = "机关"
actorCHN["Immovable"] = "静态类"
actorCHN["Elemental"] = "元素生物"
actorCHN["Horror"] = "恐魔"
actorCHN["Vermin"] = "害虫"
actorCHN["Spiderkin"] = "蜘蛛"
actorCHN["Thought-form"] = "精神体"
actorCHN["Hostile"] = "敌对"
--角色亚类别
actorCHN["Human"] = "人类"
actorCHN["Ant"] = "蚂蚁"
actorCHN["Critter"] = "牲畜"
actorCHN["Demon"] = "恶魔"
actorCHN["Bear"] = "熊"
actorCHN["Bird"] = "飞禽"
actorCHN["Giant"] = "巨人"
actorCHN["Canine"] = "犬类"
actorCHN["Cold"] = "冰龙"
actorCHN["Golem"] = "傀儡"
actorCHN["Shalore"] = "永恒精灵"
actorCHN["Fire"] = "火焰"
actorCHN["Feline"] = "猫科动物"
actorCHN["Ghost"] = "幽灵"
actorCHN["Ghoul"] = "食尸鬼"
actorCHN["Air"] = "大气"
actorCHN["Corrupted"] = "堕落者"
actorCHN["Eldritch"] = "艾尔德里奇"
actorCHN["Jelly"] = "果冻怪"
actorCHN["Lich"] = "巫妖"
actorCHN["Void"] = "虚空行者"
actorCHN["Major"] = "大恶魔"
actorCHN["Minor"] = "小恶魔"
actorCHN["Minotaur"] = "米诺陶"
actorCHN["Molds"] = "霉菌怪"
actorCHN["Multihued"] = "七彩龙"
actorCHN["Mummy"] = "木乃伊"
actorCHN["Naga"] = "纳迦"
actorCHN["Oozes"] = "软泥怪"
actorCHN["Plants"] = "植物"
actorCHN["Ritch"] = "里奇"
actorCHN["Rodent"] = "啮齿动物"
actorCHN["Sandworm"] = "沙虫"
actorCHN["Shade"] = "阴魂"
actorCHN["Sher'Tul"] = "夏·图尔"
actorCHN["Skeleton"] = "骷髅人"
actorCHN["Snake"] = "蛇"
actorCHN["Ice"] = "寒冰"
actorCHN["Spider"] = "蜘蛛"
actorCHN["Storm"] = "风暴"
actorCHN["Temporal"] = "时空怪"
actorCHN["Swarms"] = "虫群"
actorCHN["Troll"] = "巨魔"
actorCHN["Vampire"] = "吸血鬼"
actorCHN["Worms"] = "蠕虫"
actorCHN["Wight"] = "尸妖"
actorCHN["Wild"] = "自然"
actorCHN["Xorn"] = "索尔石怪"
actorCHN["Yaech"] = "夺魂魔"
actorCHN["Dwarf"] = "矮人"
actorCHN["Elf"] = "精灵"
actorCHN["Halfling"] = "半身人"
actorCHN["Yeek"] = "夺心魔"
actorCHN["Thought-form"] = "精神体"
actorCHN["shade"] = "影子"
actorCHN["ogre"] = "食人魔"
			
--角色分级
actorCHN["Rank: "] = "分级："
actorCHN["elite"] = "精英"
actorCHN["critter"] = "小怪"
actorCHN["normal"] = "普通"
actorCHN["rare"] = "稀有"
actorCHN["unique"] = "史诗"
actorCHN["elite boss"] = "稀有boss"

--角色体型
actorCHN["Size: "] = "体型："
actorCHN["tiny"] = "微小"
actorCHN["small"] = "矮小"
actorCHN["medium"] = "中等"
actorCHN["big"] = "高大"
actorCHN["huge"] = "庞大"
actorCHN["gargantuan"] = "巨型"

actorCHN["Hardiness/Armour: "] = "护甲强度/护甲值："

actorCHN["HP: unknown"] = "生命值：未知"
			
-- 8项战斗属性
actorCHN["#FFD700#Accuracy#FFFFFF#: "] = "#FFD700#命中值　#FFFFFF#："
actorCHN["#0080FF#Defense#FFFFFF#:  "] = "#0080FF#近身闪避#FFFFFF#："
actorCHN["#FFD700#P. power#FFFFFF#: "] = "#FFD700#物理强度#FFFFFF#："
actorCHN["#0080FF#P. save#FFFFFF#:  "] = "#0080FF#物理豁免#FFFFFF#："
actorCHN["#FFD700#S. power#FFFFFF#: "] = "#FFD700#法术强度#FFFFFF#："
actorCHN["#0080FF#S. save#FFFFFF#:  "] = "#0080FF#法术豁免#FFFFFF#："
actorCHN["#FFD700#M. power#FFFFFF#: "] = "#FFD700#精神强度#FFFFFF#："
actorCHN["#0080FF#M. save#FFFFFF#:  "] = "#0080FF#精神豁免#FFFFFF#："

actorCHN["Time left: "] = "时间剩余："
			
--阵营
actorCHN["Faction: "] = "阵营："
actorCHN["Personal reaction: "] = "关系："

actorCHN["Target: "] = "目标："

function getTooltipActorCHN(desc)
	if not desc then return end

	for i = 8,#desc do
		if type(desc[i]) == "string" then
			if actorCHN[desc[i]] then
				desc[i] = actorCHN[desc[i]]
			else
				desc[i]=npcCHN:getName(desc[i])
				if string.find(desc[i],"Level: %d") then desc[i] = string.gsub(desc[i],"Level: ","等级：")
				elseif string.find(desc[i],"HP: %d") then desc[i] = string.gsub(desc[i],"HP:","生命值：")
				elseif string.find(desc[i],"Iceblock: %d") then desc[i]  = string.gsub(desc[i],"Iceblock: ","冰块HP：")
				elseif string.find(desc[i],"Killed by you:") then desc[i]  = string.gsub(desc[i],"Killed by you:","击杀数：")
				elseif desc[i]:find("Melee Retaliation:") then desc[i] = desc[i]:gsub("Melee Retaliation:","近战反击伤害：")
				elseif desc[i]:find("Weapon Keywords:") then
					desc[i] = desc[i]:gsub("Weapon Keywords: ","武器词缀： ")
				elseif desc[i] == "Sustained Talents: " then desc[i] = "持续技能："
				elseif desc[i] == "Temporary Status Effects: " then desc[i]="临时状态效果："
				elseif desc[i] == "Resists: " then
					desc[i] = "抗性："
					--desc[i+1] = desc[i+1]:gsub("all","全体")
					--		:gsub("fire","火焰"):gsub("lightning","闪电"):gsub("arcane","奥术"):gsub("cold","寒冷")
			         	--		:gsub("blight","枯萎"):gsub("darkness","暗影"):gsub("physical","物理"):gsub("temporal","时空")
				 	--		:gsub("light","光系"):gsub("acid","酸性"):gsub("mind","精神"):gsub("nature","自然")
				elseif string.find(desc[i],"Enemies %(.+%)") then
					desc[i] = string.gsub(desc[i],"Enemies","敌人")
				elseif string.find(desc[i],"Undead %(.+%)") then
					desc[i] = string.gsub(desc[i],"Undead","亡灵")
				elseif string.find(desc[i],"Allied Kingdoms %(.+%)") then
					desc[i] = string.gsub(desc[i],"Allied Kingdoms","联合王国")
				elseif string.find(desc[i],"Shalore %(.+%)") then
					desc[i] = string.gsub(desc[i],"Shalore","永恒精灵")
				elseif string.find(desc[i],"Thalore %(.+%)") then
					desc[i] = string.gsub(desc[i],"Thalore","自然精灵")
				elseif string.find(desc[i],"Iron Throne %(.+%)") then
					desc[i] = string.gsub(desc[i],"Iron Throne","钢铁王座")
				elseif string.find(desc[i],"The Way %(.+%)") then
					desc[i] = string.gsub(desc[i],"The Way","维网")
				elseif string.find(desc[i],"Angolwen %(.+%)") then
					desc[i] = string.gsub(desc[i],"Angolwen","安格利文")
				elseif string.find(desc[i],"Keepers of Reality %(.+%)") then
					desc[i] = string.gsub(desc[i],"Keepers of Reality","现实守卫")
				elseif string.find(desc[i],"Dreadfell %(.+%)") then
					desc[i] = string.gsub(desc[i],"Dreadfell","恐惧王座")
				elseif string.find(desc[i],"Temple of Creation %(.+%)") then
					desc[i] = string.gsub(desc[i],"Temple of Creation","造物者神庙")
				elseif string.find(desc[i],"Vargh Republic %(.+%)") then
					desc[i] = string.gsub(desc[i],"Vargh Republic","瓦尔弗娜迦共和国")
				elseif string.find(desc[i],"Water lair %(.+%)") then
					desc[i] = string.gsub(desc[i],"Water lair","水下墓穴")
				elseif string.find(desc[i],"Assassin lair %(.+%)") then
					desc[i] = string.gsub(desc[i],"Assassin lair","盗贼巢穴")
				elseif string.find(desc[i],"Rhalore %(.+%)") then
					desc[i] = string.gsub(desc[i],"Rhalore","罗兰精灵")
				elseif string.find(desc[i],"Zigur %(.+%)") then
					desc[i] = string.gsub(desc[i],"Zigur","伊格")
				elseif string.find(desc[i],"Sunwall %(.+%)") then
					desc[i] = string.gsub(desc[i],"Sunwall","太阳堡垒")
				elseif string.find(desc[i],"Orc Pride %(.+%)") then
					desc[i] = string.gsub(desc[i],"Orc Pride","兽人部落")
				elseif string.find(desc[i],"Sandworm Burrowers %(.+%)") then
					desc[i] = string.gsub(desc[i],"Sandworm Burrowers","钻地沙虫")
				elseif string.find(desc[i],"Victim %(.+%)") then
					desc[i] = string.gsub(desc[i],"Victim","罹难者")
				elseif string.find(desc[i],"Slavers %(.+%)") then
					desc[i] = string.gsub(desc[i],"Slavers","奴隶贩子")
				elseif string.find(desc[i],"Sorcerers %(.+%)") then
					desc[i] = string.gsub(desc[i],"Sorcerers","恶魔法师")
				elseif string.find(desc[i],"Fearscape %(.+%)") then
					desc[i] = string.gsub(desc[i],"Fearscape","恶魔空间")
				elseif string.find(desc[i],"Sher'Tul %(.+%)") then
					desc[i] = string.gsub(desc[i],"Sher'Tul","夏·图尔")
				elseif string.find(desc[i],"Cosmic Fauna %(.+%)") then
					desc[i] = string.gsub(desc[i],"Cosmic Fauna","太空生物")
				elseif string.find(desc[i],"Horrors %(.+%)") then
					desc[i] = string.gsub(desc[i],"Horrors","恐魔")
				elseif string.find(desc[i],"Neutral %(.+%)") then
					desc[i] = string.gsub(desc[i],"Neutral","中立")
				elseif string.find(desc[i],"Unaligned %(.+%)") then
					desc[i] = string.gsub(desc[i],"Unaligned","无阵营")
				elseif string.find(desc[i],"Merchant Caravan %(.+%)") then
					desc[i] = string.gsub(desc[i],"Merchant Caravan","商队")
				elseif string.find(desc[i],"Point Zero Onslaught %(.+%)") then
					desc[i] = string.gsub(desc[i],"Point Zero Onslaught","零点圣域猛攻")
				elseif string.find(desc[i],"Point Zero Guardians %(.+%)") then
					desc[i] = string.gsub(desc[i],"Point Zero Guardians","零点圣域守护者")
				elseif string.find(desc[i],"Behavior:") then desc[i] = string.gsub(desc[i],"Behavior:","行为：　")
				elseif string.find(desc[i],"Action radius:") then desc[i] = string.gsub(desc[i],"Action radius:","活动范围：　")
				end

				if string.find(desc[i],"hostile, .?%d") then desc[i] = string.gsub(desc[i],"hostile, ","敌对，")
				elseif string.find(desc[i],"friendly, .?%d") then desc[i] = string.gsub(desc[i],"friendly, ","友善，")
				elseif string.find(desc[i],"neutral, .?%d") then desc[i] = string.gsub(desc[i],"neutral, ","中立，")
				end
			end
		end
	end

	return desc
end