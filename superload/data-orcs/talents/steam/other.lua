local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_GLOBAL_MEDICAL_CD",
	name = "药物注射器",
	info = function(self, t)
		return ""
	end,}

registerTalentTranslation{
	id = "T_MEDICAL_URGENCY_VEST",
	name = "紧急药物处理",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[该药物注射器注射药物效率为 %d%% ，冷却时间修正为 %d%% 。]])
		:format(data.power + data.inc_stat, data.cooldown_mod)
	end,}

registerTalentTranslation{
	id = "T_LIFE_SUPPORT",
	name = "生命支持系统",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[生命支持系统允许使用药物效率为 %d%% ，冷却时间修正为 %d%% 。]])
		:format(data.power + data.inc_stat, data.cooldown_mod)
	end,}

registerTalentTranslation{
	id = "T_CREATE_TINKER",
	name = "制造附着物",
	info = function(self, t)
		return ([[允许你制造附着物。]])
	end,}

registerTalentTranslation{
	id = "T_TINKER_WEAPON_AUTOMATON_1H",
	name = "武装机器人：单手模式",
	info = function(self, t)
		return ([[部署一个装备单手武器的武装机器人。武装机器人将自动选择武器 ,武器不会掉落。选中时 ,武装机器人将自动匹配技能等级 ,你的状态和其他数据都会被描述。	  
		]]):format()
	end,}

registerTalentTranslation{
	id = "T_TINKER_HAND_CANNON",
	name = "手炮",
	info = function(self, t)
		return ([[向在 %d  码范围内的一个敌人开火造成 %d%% 的武器伤害。如果手炮是由沃瑞坦钢制作的，你能多一次额外的射击。射击是远程攻击将会触发弹药特效。
]]):
		format(self:getTalentRange(t), t.getDamage(self, t)*100)
	end,}

registerTalentTranslation{
	id = "T_TINKER_FATAL_ATTRACTOR",
	name = "致命诱饵",
	info = function(self, t)
		return ([[快速创建一个灵能增强金属诱饵，引诱敌人反弹 %d%%  攻击者的伤害。
诱饵有 %d 生命值，持续 5 回合。
伤害、生命值、抗性和护甲值取决于你的蒸汽强度。
]]):
		format(t.getReflection(self, t), t.getHP(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_ROCKET_BOOTS",
	name = "火箭靴", 
	info = function(self, t)
		return ([[激活火箭靴，从你的靴子上发射巨大的火焰，增加你的移动速度 %d%% 。
每次移动都会留下一道火焰持续 4 回合的伤害为  %0.2f  的火焰。
做任何其他行动都会打断效果。
#{italic}#烧毁他们 !#{normal}#]]):
		format(100 * (0.5 + self:getTalentLevel(t) / 2), damDesc(self, DamageType.FIRE, t.getDam(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_IRON_GRIP",
	name = "铁腕", 
	info = function(self, t)
		return ([[激活活塞碾压你的目标在 %d  回合内造成  %d%%  的徒手伤害 .
同时目标被定身而且他的护甲和闪避减少  %d  。
#{italic}#压碎他们的骨头 !#{normal}#]]):
		format(t.getDur(self, t), self:combatTalentWeaponDamage(t, 1.2, 2.1) * 100, t.getReduc(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_SPRING_GRAPPLE",
	name = "弹簧飞爪",
	info = function(self, t)
		return ([[抓住目标把目标向你拉拢，造成 %d%%  的徒手伤害，如果命中，目标定身  %d  回合。
]]):
		format(self:combatTalentWeaponDamage(t, 0.8, 1.8) * 100, t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_TOXIC_CANNISTER_LAUNCHER",
	name = "毒罐发射装置", 
	info = function(self, t)
		return ([[发射一个充满有毒气体的罐子。
每 2 回合在此周围发出一个半径为 3 码的毒雾。
毒雾在 5 回合内造成 %0.2f 的自然伤害。
发生器有 %d  点生命值持续 8 回合。当它被摧毁或持续时间结束会发出最后一片毒雾。
伤害，生命值，抗性和护甲值取决于你的蒸汽强度。
从创造者处继承伤害和穿透。]]):
		format(damDesc(self, DamageType.NATURE, t.getDam(self, t)), t.getHP(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_POWERED_ARMOUR",
	name = "蒸汽动力装甲",
	info = function(self, t)
		return ([[激活盔甲的主动防御系统。
　　你的盔甲被电流的覆盖。他会减弱的对你的物理攻击。
     除了精神伤害所有伤害直接减少  %d  点。
     盔甲有时会漏电，每回合有  50%%  的几率电击周围 1 码范围内的目标，造成  %0.2f  到  %0.2f  点闪电伤害。
    效果随蒸汽强度增加。]]):
		format(t.getRes(self, t), t.getDam(self, t) / 3, t.getDam(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_VIRAL_NEEDLEGUN",
	name = "病毒针枪",
	info = function(self, t)
		return ([[你射出一片枯萎的针，打击  %d  码锥形范围内的目标，造成 %0.2f  的物理伤害。
每个命中目标都有 %d%%  几率感染一种随机疾病，造成 %0.2f  枯萎伤害同时降低体质，力量或敏捷 %d 点持续 20 回合。
		伤害和疾病效果随蒸汽强度增加 ]]):format(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, t.damage(self, t)), t.diseaseChance(self, t), damDesc(self, DamageType.BLIGHT, t.diseaseDamage(self, t)), t.diseaseStat(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_SAND_SHREDDER",
	name = "砂土粉碎",
	info = function(self, t)
		return ([[你分解砂土墙。嘣 ~~~]])
	end,}

registerTalentTranslation{
	id = "T_FLAMETHROWER",
	name = "火焰喷射器",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local radius = self:getTalentRadius(t)
		return ([[喷出一片锥形半径为  %d  的火焰 
　　伤害随蒸汽强度增加。]]):
		format(radius, damDesc(self, DamageType.FIRE, damage))
	end,}

registerTalentTranslation{
	id = "T_MASS_REPAIR",
	name = "大规模修复",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		local radius = self:getTalentRadius(t)
		return ([[释放一片锥形半径  %d  码的修理器 ,修复机械生物 (蒸汽蜘蛛 ) %d  生命值。
　　治疗量随蒸汽强度增加。]]):
		format(radius, heal)
--		format(radius, damDesc(self, DamageType.FIRE, damage))
	end,}

registerTalentTranslation{
	id = "T_TINKER_ARCANE_DISRUPTION_WAVE",
	name = "奥术干扰波 ",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[制造一场奥术干扰波，沉默  %d  码范围内受影响的目标 %d 回合，包括使用者。
沉默几率随蒸汽强度增加。]]):
		format(rad,t.getduration(self,t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_YEEK_WILL",
	name = "精神碾压",
	info = function(self, t)
		return ([[粉碎你的受害者的内心 ,给你完全控制其行为 6 回合。
　　当效果结束时 ,你抽出了自己的思维，受害者的身体会崩溃 , 死亡。
　　稀有怪、boss 、亡灵不受控制。
		]]):format()
	end,}

registerTalentTranslation{
	id = "T_TINKER_SHOCKING_TOUCH",
	name = "电击之触",
	info = function(self, t)
		return ([[接触生物释放电流 ,造成 %0.2f 闪电伤害。
如果这个插件材质大于 1 级 ,电弧可以传递到 2 码范围内的另一个目标。
触电的敌人数目不会大于插件材质等级。
伤害随蒸汽强度增加。]]):format(damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_FLASH_POWDER",
	name = "闪光粉",
	info = function(self, t)
		return ([[扔一把尘土 ,迅速氧化 ,释放出眩目的光芒。
　　致盲锥形半径 %d 码内的生物 %d  回合。
     致盲强度随蒸汽强度增加。]]):format(self:getTalentRadius(t), t.duration(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_ITCHING_POWDER",
	name = "痒痒粉",
	info = function(self, t)
		return ([[释放一把痒痒粉。
　　锥形半径 %d 码内的生物 %d 回合内很痒 ,导致它们释放技能 %d%% 几率失败。
     致痒强度随蒸汽强度增加。]]):format(self:getTalentRadius(t), t.duration(self, t), t.failChance(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_THUNDER_GRENADE",
	name = "闪电榴弹",
	info = function(self, t)
		return ([[向你的敌人投掷手榴弹 ,造成  %0.2f  物理伤害，半径 %d  码。
　　目标也会震慑  %d  回合。
　　震慑强度随蒸汽强度增加。]]):format(t.getDamage(self, t), self:getTalentRadius(t), t.duration(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_PROJECT_SAW",
	name = "发射链锯",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你激活隐藏的弹簧来弹射一个你的敌人。任何生物被抓后造成  %0.2f  物理伤害和 5 回合内一半的流血伤害。
伤害随蒸汽强度增加。]]):format(damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_VOLTAIC_BOLT",
	name = "闪电球",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[释放一个闪电球，造成  %0.2f  闪电伤害。
伤害随蒸汽强度增加。]]):
		format(damDesc(self, DamageType.LIGHTNING, damage))
	end,}

registerTalentTranslation{
	id = "T_TINKER_VOLTAIC_SENTRY",
	name = "伏特守卫",
	info = function(self, t)
		return ([[在某个位置处放置一个带电的哨兵装置。
每一个回合，它会向附近的敌人发射一个闪电球。
闪电球造成  %0.2f  闪电伤害。
哨兵有 %d  的生命，持续 10 回合。]]):
		format(damDesc(self, DamageType.LIGHTNING, t.getDam(self, t)), t.getHP(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_EXPLOSIVE_SHELL",
	name = "爆炸弹",
	info = function(self, t)
		return ([[你使用蒸汽枪在射程内制造一场特殊的爆炸。
　　当每一个弹片击中它的目标 ,造成正常蒸汽枪伤害和半径 %d 码内的爆炸，造成 %0.2f 的物理伤害 ,
　　这个技能不使用弹药。]])
		:format(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_FLARE_SHELL",
	name = "闪光弹",
	info = function(self, t)
		return ([[你使用蒸汽枪在射程内制造一场特殊的爆炸。
　　当每一个弹片击中它的目标 ,造成正常蒸汽枪伤害和半径 %d 码内的爆炸，致盲 %d  回合。
　　这个技能不使用弹药。]])
		:format(self:getTalentRadius(t), t.duration(self, t))
	end,
	}

registerTalentTranslation{
	id = "T_TINKER_INCENDIARY_SHELL",
	name = "燃烧弹",
	info = function(self, t)
		return ([[你使用蒸汽枪在射程内制造一场特殊的爆炸。
　　当每一个弹片击中它的目标 ,造成正常蒸汽枪伤害和半径 2 码内的燃烧，伤害 %d 。
     这燃烧不持久 ,马上燃烧半径为 1 码，造成  %0.2f 火焰伤害。
　　这个技能不使用弹药。]])
		:format(math.floor(self:getTalentLevel(t)), damDesc(self, DamageType.FIRE, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_SOLID_SHELL",
	name = "固实弹",
	info = function(self, t)
		return ([[你使用蒸汽枪发射特殊固体打击目标造成 %d%%  武器伤害。
　　击退目标 %d 码。
     这个技能不使用弹药 ]])
		:format(100*t.getMultiple(self, t), t.knockback(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_IMPALER_SHELL",
	name = "穿刺弹", 
	info = function(self, t)
		return ([[你使用蒸汽枪发射特殊弹药打击目标造成 %d%%  武器伤害。
击退目标 2 码并定身  %d  回合。
     这个技能不使用弹药 ]])
		:format(100*t.getMultiple(self, t), t.duration(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_SAW_SHELL",
	name = "链锯弹",
	info = function(self, t)
		return ([[你使用蒸汽枪发射特殊弹药打击目标造成 %d%%  武器伤害。
链锯会切割目标，在 5 回合内造成 %d%%  武器伤害 
这个技能不使用弹药 ]])
		:format(100*t.getMultiple(self, t), 50*t.getMultiple(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_HOOK_SHELL",
	name = "钩链弹",
	info = function(self, t)
		return ([[你使用蒸汽枪发射特殊弹药打击目标或某处 
如果你的目标是一个生物，他们被拉向你 %d 码 
如果你的目标是一个空地，你会被拉向空地 %d 码 
这个技能不使用弹药 ]])
		:format(t.distance(self, t), t.distance(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_MAGNETIC_SHELL",
	name = "磁性弹",
	info = function(self, t)
		return ([[你使用蒸汽枪发射特殊弹药打击目标造成正常武器伤害。
目标将磁化  %d  回合。这降低了他们的闪避和疲劳 %d  。
这个技能不使用弹药 
技能效果随蒸汽强度增加。]])
		:format(t.duration(self, t), t.getPower(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_VOLTAIC_SHELL",
	name = "伏特弹",
	info = function(self, t)
		return ([[你使用蒸汽枪发射特殊弹药打击目标造成 100%% 闪电武器伤害。
这将释放强大的电流，打击周围 %d 的敌人。
每个闪电球造成 %0.2f 的闪电伤害 
这个技能不使用弹药 
闪电球伤害随蒸汽强度增加。]])
		:format(math.floor(self:getTalentLevel(t)), damDesc(self, DamageType.LIGHTNING, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_ANTIMAGIC_SHELL",
	name = "反魔弹",
	info = function(self, t)
		return ([[你使用蒸汽枪发射特殊弹药打击目标造成 100%% 武器伤害。
造成 %0.2f 奥术燃烧。
这个技能不使用弹药。
奥术燃烧伤害取决于蒸汽强度。]])
		:format(damDesc(self, DamageType.ARCANE, t.getDamage(self, t)))
	end,}

registerTalentTranslation{
	id = "T_TINKER_BOTANICAL_SHELL",
	name = "植物弹",
	info = function(self, t)
		return ([[你使用蒸汽枪发射特殊弹药打击目标造成 100%% 自然武器伤害。
将释放孢子生长成半径 %d 的苔藓 %d 回合。
每回合苔藓造成  %0.2f  自然伤害对半径内的每一个敌人。
这种苔藓有吸血特性，  伤害的 %d%%  治愈使用者。  
这个技能不使用弹药 
苔藓伤害随蒸汽强度增加。]])
		:format(self:getTalentRadius(t), t.getDuration(self, t), damDesc(self, DamageType.NATURE, t.getDamage(self, t)), t.getHeal(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_CORROSIVE_SHELL",
	name = "腐蚀弹",
	info = function(self, t)
		return ([[你使用蒸汽枪发射特殊弹药打击目标造成 %d%% 酸性武器伤害。
释放的酸也会腐蚀的目标，降低其命中，闪避和护甲 %d  。
这个技能不使用弹药。
腐蚀强度随蒸汽强度增加。]])
		:format(100*t.getMultiple(self, t), t.getPower(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_TOXIC_SHELL",
	name = "毒气弹",
	info = function(self, t)
		return ([[你使用蒸汽枪发射特殊弹药打击目标造成 100%% 枯萎武器伤害。
向目标释放重金属，造成每回合  %0.2f  枯萎伤害，并且降低整体速度 %d%%  %d  回合 .
这个技能不使用弹药。
枯萎伤害随蒸汽强度增加。]])
		:format(damDesc(self, DamageType.BLIGHT, t.getPower(self, t)), t.getPower(self, t)-10, t.duration(self, t))
	end,}

registerTalentTranslation{
	id = "T_TINKER_MOSS_TREAD",
	name = "苔藓之踏",
	info = function(self, t)
		local dur = t.getDuration(self, t)
		local dam = t.getDamage(self, t)
		return ([[在 %d 回合内，你在行走或站立时放置苔藓 
     每回合自动放置苔藓，持续 %d 回合。
　　每个苔藓对站在它上面的每一个敌人造成 %0.2f 自然伤害。
　　这个苔藓很厚 ,导致粘住所有踩过它的敌人。
　　降低移动速度 %d%%  并且有 %d%% 机会被定身 4 回合。
     伤害随蒸汽强度增加。]]):
		format(dur*2, dur, damDesc(self, DamageType.NATURE, dam), t.getSlow(self, t), t.getPin(self, t))
	end,}

return _M