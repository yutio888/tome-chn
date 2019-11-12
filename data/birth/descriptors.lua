registerBirthDescriptorTranslation{
    type = "difficulty",
    name = "Tutorial",
    display_name = "教程模式",
	desc =
	{
        "#GOLD##{bold}# 教程模式 ",
		"#WHITE# 以一个简化的人物开始游戏并通过一个简单的任务来探索这个游戏。 #{normal}#",
		" 角色所受伤害减少 20%。",
		" 角色治疗效果增加 10%。",
		"无法获得主游戏的成就。",
	},
}

registerBirthDescriptorTranslation{
    type = "difficulty",
    name = "Easy",
    display_name = "简单",
	desc =
	{
		"#GOLD##{bold}#简单难度#WHITE##{normal}#",
		" 提供一个较简单的游戏体验。",
		" 其他难度游戏困难时请选择此模式。",
		" 角色所受所有伤害减少 30%。",
		" 角色所受所有治疗增加 30%。",
		" 所有负面状态持续时间减少 50%。",
		" 不能完成游戏成就。",
	},
}

registerBirthDescriptorTranslation{
    type = "difficulty",
    name = "Normal",
    display_name = "普通",
	desc =
	{
		"#GOLD##{bold}#普通难度#WHITE##{normal}#",
		" 普通难度的挑战。",
		" 你杀死生物 2  回合内不能使用楼梯",
	},
}

registerBirthDescriptorTranslation{
    type = "difficulty",
    name = "Nightmare",
    display_name = "噩梦",
	desc =
	{
		"#GOLD##{bold}#噩梦难度#WHITE##{normal}#",
		" 高难度游戏设定 ",
		" 所有地区等级提高 50% ",
		" 所有生物技能等级提高 30%",
		" 所有敌人血量增加 10%",
		" 稀有生物出现率略微增加",
		" 你杀死生物 3  回合内不能使用楼梯",
        " 玩家如果同时选择永久死亡模式或冒险模式可以达成噩梦难度成就。",
	},
}

registerBirthDescriptorTranslation{
    type = "difficulty",
    name = "Insane",
    display_name = "疯狂",
    locked_desc = " 简单难度，弱鸡！ \n 普通难度，菜鸟！ \n 噩梦难度，弱爆了！ \n 想成为王者领略最强的挑战吗？ \n 解锁疯狂模式！ ",
	desc =
	{
		"#GOLD##{bold}#疯狂难度#WHITE##{normal}#",
		" 和噩梦难度相似，但随机 boss 出现更加频繁！",
		" 在10级后，所有区域难度增加相当于人物等级的 50% + 1级。",
        " 所有生物技能等级增加 80%。",
		" 固定 boss 的职业技能等级上升速度增加80%。",
		" 所有敌人血量增加 20%",
		" 稀有怪出现频率大幅增加，同时出现随机 Boss。",
		" 你杀死生物 5 回合内不能使用楼梯",
		" 玩家如果同时选择永久死亡或冒险模式可以达成疯狂难度成就。",
	},
}


registerBirthDescriptorTranslation{
    type = "difficulty",
    name = "Madness",
    display_name = "绝望",
	locked_desc = " 疯狂难度也弱爆了！来体验真正让大脑崩溃的感觉吧！",
	desc =
	{
		"#GOLD##{bold}# 绝望难度#WHITE##{normal}#",
		" 绝对不公平的游戏设定。选这个模式的都是疯子！ ",
		" 在10级后，所有区域难度增加相当于人物等级的 150% + 1 级。",
		" 所有生物技能等级增加 170%。",
		" 固定 boss 的职业技能等级上升速度增加170%。",
		" 所有敌人血量增加 200%",
		" 稀有怪出现频率大幅增加，同时出现随机 Boss。",
		" 你杀死生物 9  回合内不能使用楼梯",
		" 玩家处于被捕猎的状态，一定半径内所有生物都能感知到你的位置。",
		" 玩家如果同时选择永久死亡模式或冒险模式可以达成绝望难度成就。",
	},
}

registerBirthDescriptorTranslation{
    type = "permadeath",
    name = "Exploration",
    display_name = "探索模式",
    locked_desc = "探索模式：无限生命（捐赠者特权）",
	desc =
	{
		"#GOLD##{bold}#探索模式#WHITE#",
		" 拥有无限次生命。 #{normal}#",
		" 这不是本游戏推荐的游戏方式，不过也能让你有一个更难忘的经历。",
		" 请记住死亡也是游戏不可或缺的一部分，可以帮助你成为一个更好的玩家。",
		" 此模式你可以完成探索模式成就。",
		" 此模式下你可以无限洗点。",
	},
}

registerBirthDescriptorTranslation{
    type = "permadeath",
    name = "Adventure",
    display_name = "冒险模式",
	desc =
	{
		"#GOLD##{bold}#冒险模式#WHITE#",
		" 你拥有有限的额外生命。",
		" 如果还没有准备好一条命通关就用这个模式进行。 #{normal}#",
		" 在达到 1,2,5,7,14,24,35 级时你分别可以得到额外一次额外生命的奖励。",
	},
}

registerBirthDescriptorTranslation{
    type = "permadeath",
    name = "Roguelike",
    display_name = "永久死亡模式",
	desc =
	{
		"#GOLD##{bold}#永久死亡模式#WHITE#",
		" 经典的 Roguelike 模式。",
		" 你只有一次生命机会。 #{normal}#",
		" 除非你在游戏内找到某些原地复活的能力。",
	},
}