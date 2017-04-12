--------------------------------------------------
--装备类型与副类型列表：
--------------------------------------------------
objectMType = {}
objectMType["weapon"] = "武器"
objectMType["jewelry"] = "首饰"
objectMType["lite"] = "照明"
objectMType["armor"] = "护甲"
objectMType["mount"] = "基座"
objectMType["gem"] = "珠宝"
objectMType["potion"] = "药水"
objectMType["orb"] = "水晶球"
objectMType["scroll"] = "卷轴"
objectMType["tool"] = "工具"
objectMType["alchemist-gem"] = "炼金宝石"
objectMType["unknown"] = "未知"
objectMType["misc"] = "杂项"
objectMType["ammo"] = "弹药"
objectMType["chest"] = "盒子"
objectMType["charm"] = "护符"
objectMType["organic"] = "器官"
objectMType["lore"] = "文献"
objectMType["corpse"] = "尸体"
objectMType["seed"] = "种子"
objectMType["tinker"] = "配件"
objectSType = {}
objectSType["battleaxe"] = "战斧"
objectSType["greatmaul"] = "巨槌"
objectSType["greatsword"] = "大剑"
objectSType["trident"] = "三叉戟"
objectSType["waraxe"] = "巨斧"
objectSType["longbow"] = "长弓"
objectSType["cloak"] = "斗蓬"
objectSType["cloth"] = "长袍"
objectSType["digger"] = "鹤嘴锄"
objectSType["whip"] = "鞭子"
objectSType["hands"] = "手部"
objectSType["white"] = "白宝石"
objectSType["blue"] = "蓝宝石"
objectSType["green"] = "绿宝石"
objectSType["red"] = "红宝石"
objectSType["violet"] = "紫宝石"
objectSType["yellow"] = "黄宝石"
objectSType["multi-hued"] = "混晶石"
objectSType["black"] = "黑曜石"
objectSType["white"] = "白宝石"
objectSType["color"] = "多彩"
objectSType["heavy"] = "重甲"
objectSType["feet"] = "脚部"
objectSType["head"] = "头部"
objectSType["staff"] = "法杖"
objectSType["scroll"] = "卷轴"
objectSType["infusion"] = "纹身"
objectSType["potion"] = "药水"
objectSType["rune"] = "符文"
objectSType["taint"] = "堕落印记"
objectSType["lore"] = "传说"
objectSType["mummy"] = "木乃伊裹尸布"
objectSType["golem"] = "傀儡"
objectSType["money"] = "金币"
objectSType["massive"] = "板甲"
objectSType["mace"] = "锤子"
objectSType["sling"] = "投石索"
objectSType["lite"] = "灯具"
objectSType["shield"] = "盾牌"
objectSType["light"] = "轻甲"
objectSType["wand"] = "魔杖"
objectSType["belt"] = "腰带"
objectSType["dagger"] = "匕首"
objectSType["longsword"] = "长剑"
objectSType["amulet"] = "项链"
objectSType["ring"] = "戒指"
objectSType["orb"] = "水晶球"
objectSType["shot"] = "子弹"
objectSType["arrow"] = "箭矢"
objectSType["ingredient"] = "配料"
objectSType["unknown"] = "未知"
objectSType["sher'tul"] = "夏·图尔"
objectSType["mindstar"] = "灵晶"
objectSType["rod"] = "魔杖"
objectSType["torque"] = "项圈"
objectSType["totem"] = "图腾"
objectSType["tome"] = "书册"
objectSType["misc"] = "杂项"
objectSType["egg"] = "蛋"
objectSType["trinket"] = "饰品"
objectSType["lecture on humility"] = "有关人性的手记"
objectSType["magic teaching"] = "魔法教学"
objectSType["heart"] = "心脏"
objectSType["animal"] = "动物"
objectSType["blood"] = "血液"
objectSType["demon"] = "恶魔"
objectSType["steamsaw"] = "蒸汽链锯"
objectSType["implant"] = "植入物"
objectSType["schematic"] = "设计图"
objectSType["steamgun"] = "蒸汽枪"
objectSType["steamtech"] = "蒸汽科技"
objectSType["salve"] = "药剂"
objectSType["fang"] = "牙齿"
objectSType["demonic"] = "恶魔道具"
objectSType["injector"] = "注射器"
objectSType["bomb"] = "炸弹"
objectSType["power"] = "强力道具"
--------------------------------------------------------
--鼠标信息
--------------------------------------------------------
objDesc = {}

objDesc["Steampower: "] = "蒸汽强度"
objDesc["Steam crit. chance: "] = "蒸汽暴击几率："
objDesc["Steamtech Speed: "] = "蒸汽速度："
objDesc["Steam each turn: "] = "每回合蒸汽回复："
objDesc["Maximum steam: "] = "蒸汽容量："
--
objDesc["[Plot Item]"] = "[剧情物品]"
objDesc["It must be held with both hands."] = "你必须使用双手装备。"
objDesc["It can be used as a weapon and offhand."] = "能当作单手武器+副手使用"
objDesc["It is part of a set of items."] = "它是某个套装中的一件。"
objDesc["The set is complete."] = "套装已完成。"
objDesc["Mastery: "] = "武器精通类型:"
objDesc["Accuracy bonus: "] = "命中加成："
objDesc["Talent mastery: "] = "技能掌握："
objDesc["Talent masteries: "] = "技能掌握："
objDesc["Dam. multiplier: "] = "伤害倍率："
objDesc["Requires:"] = "装备需求："
objDesc["Damage type: "] = "伤害类型："
objDesc["Accuracy: "] = "命中："
objDesc["Physical crit. chance: "] = "物理暴击率："
objDesc["Crit. chance: "] = "暴击率："
objDesc["Attack speed: "] = "攻击速度："
objDesc["Block value: "] = "格挡强度："
objDesc["Firing range: "] = "攻击距离："
objDesc["Reload speed: "] = "装填速度："
objDesc["Shadow Power: "] = "阴影强度："
objDesc["Turns elapse between self-loadings: "] = "自动填弹间隔："
objDesc["When used from stealth a simple attack with it will not break stealth."] = "潜行中使用，单纯攻击不会取消潜行。"
objDesc["Travel speed: "] = "飞行速度："
objDesc["Effects on melee hit: "] = "近战附加特效："
objDesc["Effects on ranged hit: "] = "远程附加特效："
objDesc["Effects when hit in melee: "] = "近战反击特效："
objDesc["Damage when hit (Melee): "] = "近战反击伤害："
objDesc["Damage (Melee): "] = "近战附加伤害："
objDesc["Damage (ranged): "] = "远程附加伤害："
objDesc["Damage against: "] = "伤害增幅："
objDesc["#ORANGE#Attacks use: #LAST#"] ="#ORANGE#攻击消耗：#LAST#"
objDesc["Reduced damage from: "] = "降低特定来源伤害："
objDesc["Armour Penetration: "] = "护甲穿透："
objDesc["Armour penetration: "] = "护甲穿透："
objDesc["Physical crit. chance: "] = "物理暴击率："
objDesc["Physical power: "] = "物理强度："
objDesc["Armour: "] = "护甲值："
objDesc["Armour Hardiness: "] = "护甲强度："
objDesc["Defense: "] = "近身闪避："
objDesc["Ranged Defense: "] = "远程闪避："
objDesc["Fatigue: "] = "疲劳值："
objDesc["Changes stats: "] = "属性变化："
objDesc["Damage (Melee): "] = "近战附加伤害："
objDesc["Damage (Ranged): "] = "远程附加伤害："
objDesc["Damage when the wearer is hit: "] = "装备者被击中时伤害反射："
objDesc["Reduce damage by fixed amount: "] = "按固定数值减少全部伤害："
objDesc["Changes resistances: "] = "抗性改变："
objDesc["Maximum wards: "] = "最大抵挡值："
objDesc["Changes resistances cap: "] = "抗性上限改变："
objDesc["Changes resistances penetration: "] = "抗性穿透改变："
objDesc["Changes damage: "] = "伤害加成："
objDesc["Damage affinity(heal): "] = "伤害吸收（治疗）："
objDesc["Change telepathy range by : "] = "心灵感应范围改变："
objDesc["Grants telepathy: "] = "能够感知："
objDesc["Talent master: "] = "技能加成"
objDesc["Talent masters: "] = "技能加成"
objDesc["Talent cooldown:"] = "技能冷却："
objDesc["Talents cooldown:"] = "技能冷却："
objDesc["Talent granted: "] = "技能加成："
objDesc["Talents granted: "] = "技能加成："
objDesc["Damage conversion: "] = "伤害转换："
objDesc["Allows you to breathe in: "] = "可以在以下环境呼吸："
objDesc["Critical mult.: "] = "暴击伤害加成："
objDesc["Reduces opponents crit chance: "] = "减少对方暴击率："
objDesc["Trap disarming bonus: "] = "拆除陷阱加成："
objDesc["Stealth bonus: "] = "潜行加成："
objDesc["Maximum encumbrance: "] = "负重上限加成："
objDesc["Physical save: "] = "物理豁免加成："
objDesc["Spell save: "] = "法术豁免加成："
objDesc["Mental save: "] = "精神豁免加成："
objDesc["Blindness immunity: "] = "致盲免疫："
objDesc["Poison immunity: "] = "毒素免疫："
objDesc["Disease immunity: "] = "疾病免疫："
objDesc["Cut immunity: "] = "流血免疫："
objDesc["Silence immunity: "] = "沉默免疫："
objDesc["Disarm immunity: "] = "缴械免疫："
objDesc["Confusion immunity: "] = "混乱免疫："
objDesc["Sleep immunity: "] = "睡眠免疫： "
objDesc["Pinning immunity: "] = "定身免疫："
objDesc["Stun/Freeze immunity: "] = "震慑/冰冻免疫："
objDesc["Fear immunity: "] = "恐惧免疫："
objDesc["Knockback immunity: "] = "击退免疫："
objDesc["Instant-death immunity: "] = "即死免疫："
objDesc["Teleport immunity: "] = "传送免疫："
objDesc["Life regen: "] = "生命回复："
objDesc["Stamina each turn: "] = "每回合体力回复："
objDesc["Mana each turn: "] = "每回合法力回复："
objDesc["Hate each turn: "] = "每回合仇恨值回复："
objDesc["Psi each turn: "] = "每回合超能力值回复："
objDesc["Equilibrium each turn: "] = "每回合失衡值回复："
objDesc["Vim each turn: "] = "每回合活力值回复："
objDesc["P.Energy each turn: "] = "每回合正能量值回复："
objDesc["N.Energy each turn: "] = "每回合负能量值回复："
objDesc["Stamina when hit: "] = "被击中回复体力："
objDesc["Mana when hit: "] = "被击中回复法力："
objDesc["Equilibrium when hit: "] = "被击中回复失衡值："
objDesc["Psi when hit: "] = "被击中回复超能力值："
objDesc["Hate when hit: "] = "被击中回复仇恨值："
objDesc["Vim when hit: "] = "被击中回复活力值："
objDesc["Vim when hitting in melee: "] = "近战命中时回复活力："
objDesc["Mana when firing critical spell: "] = "法术暴击时回复法力："
objDesc["Vim when firing critical spell: "] = "法术暴击时回复活力："
objDesc["Spellpower on spell critical (stacks up to 3 times): "] = "法术暴击时增加法术强度（最大叠加3次）："
objDesc["Hate when firing a critical mind attack: "] = "精神暴击时回复仇恨值："
objDesc["Psi when firing a critical mind attack: "] = "精神暴击时回复超能力值："
objDesc["Equilibrium when firing a critical mind attack: "] = "精神暴击时回复失衡值："
objDesc["Hate per kill: "] = "每次击杀获得仇恨值："
objDesc["Psi per kill: "] = "每次击杀获得超能力值："
objDesc["Vim per kill: "] = "每次击杀获得活力值："
objDesc["Only die when reaching: "] = "生命底限："
objDesc["Maximum life: "] = "生命上限："
objDesc["Maximum mana: "] = "法力上限："
objDesc["Maximum stamina: "] = "体力上限："
objDesc["Maximum souls: "] = "灵魂上限： "
objDesc["Maximum hate: "] = "仇恨上限："
objDesc["Maximum vim: "] = "活力上限："
objDesc["Maximum psi: "] = "超能力值上限："
objDesc["Maximum pos.energy: "] = "正能量上限："
objDesc["Maximum neg.energy: "] = "负能量上限："
objDesc["Damage type: "] = "伤害类型："
objDesc["Maximum air capacity: "] = "空气容量上限："
objDesc["Spellpower: "] = "法术强度："
objDesc["Spell crit. chance: "] = "法术暴击率："
objDesc["Lowers spell cool-downs by: "] = "减少法术冷却时间："
objDesc["Mindpower: "] = "精神强度："
objDesc["Mental crit. chance: "] = "精神暴击率："
objDesc["Light radius: "] = "光照范围："
objDesc["Infravision radius: "] = "夜视范围："
objDesc["Sight radius: "] = "视觉范围："
objDesc["Heightened senses radius: "] = "强化感知范围："
objDesc["See invisible: "] = "侦测隐形："
objDesc["See stealth: "] = "侦测潜行："
objDesc["Invisibility: "] = "隐形等级："
objDesc["Global speed: "] = "整体速度："
objDesc["Movement speed: "] = "移动速度："
objDesc["Combat speed: "] = "战斗速度："
objDesc["Casting speed: "] = "施法速度："
objDesc["Mental speed: "] = "精神速度："
objDesc["Healing mod.: "] = "治疗加成："
objDesc["Heals friendly targets nearby when you use a nature summon: "] = "当你使用自然召唤时治疗附近友方单位："
objDesc["Life leech chance: "] = "吸血几率："
objDesc["Life leech: "] = "吸血："
objDesc["Resource leech chance: "] = "能量吸收几率："
objDesc["Resource leech: "] = "能量吸收："
objDesc["Damage Shield penetration: "] = "护盾穿透："
objDesc["Chance to avoid attacks: "] = "闪避攻击几率： "
objDesc["Defense after a teleport: "] = "传送后增加闪避："
objDesc["Resist all after a teleport: "] = "传送后增加所有抵抗："
objDesc["New effects duration reduction after a teleport: "] = "传送后减少效果持续时间："
objDesc["Damage Resonance (when hit): "] = "伤害共振（当击中时）："
objDesc["Size category: "] = "体积等级："
objDesc["Max wilder summons: "] = "最大自然召唤数："
objDesc["Life regen bonus (wilder-summons): "] = "生命回复加成（自然召唤）："
objDesc["Slows Projectiles: "] = "减缓抛射物速度："
objDesc["Damage Shield Duration: "]= "护盾持续时间增加： " 
objDesc["Damage Shield Power: "]= "护盾强度增加： "
objDesc["The wearer is treated as an undead."] = "装备者看作为亡灵。"
objDesc["The wearer is treated as a demon."] = "装备者看作为恶魔。"
objDesc["The wearer is blinded."] = "装备者处于失明状态。"
objDesc["Allows you to speak and read the old Sher'Tul language."] = "让你学会古老的夏·图尔语言。"
objDesc["When used to modify unarmed attacks:"] = "徒手伤害加成："
objDesc["When used to attack (with talents):"] = "使用技能攻击时："
objDesc["It is immune to teleportation, if you teleport it will fall on the ground."] = "此物品无法传送，传送时会自动掉落。"
objDesc["Default ammo(infinite):"] = "默认弹药伤害："
objDesc["When wielded/worn:"] = "当使用或装备时："
objDesc["When carried:"] = "当携带时："
objDesc["Special effect on block:"] = "格挡时触发特效："
objDesc["When used to imbue an object:"] = "当被用来强化装备时："
objDesc["When used as an alchemist bomb:"] = "当用作炼金炸弹时："
objDesc["Capacity: "] = "弹仓容量："
objDesc["Turns elapse between self-loadings: "] = "自动装填的间隔时间："
objDesc["Ammo reloads per turn: "] = "弹药每回合装填："
objDesc["Damage Shield penetration (this weapon only): "] = "护盾穿透（仅限此武器）："
objDesc["Lifesteal (this weapon only): "] = "生命偷取（仅限此武器）: " 
objDesc["Multiple attacks: "] = "多次攻击："
objDesc["Multiple attacks procs power reduction: "] = "多次攻击强度衰减："
objDesc["Burst (radius 1) on hit: "] = "击中时溅射伤害（1格半径）："
objDesc["Burst (radius 2) on hit: "] = "击中时溅射伤害（2格半径）："
objDesc["Burst (radius 2) on crit: "] = "暴击时溅射伤害（2格半径）："
objDesc[" all"] = "全体"
objDesc[" Str"] = "力量"
objDesc[" Mag"] = "魔法"
objDesc[" Dex"] = "敏捷"
objDesc[" Cun"] = "灵巧"
objDesc[" Con"] = "体质"
objDesc[" Wil"] = "意志"
objDesc["turn)"] = "回合)"
objDesc["turns)"] = "回合)"
objDesc[" turn)"] = " 回合)"
objDesc[" turns)"] = " 回合)"
objDesc["Activating this item is instant."] = "使用该物品不需要时间。"
objDesc["Accuracy is based on willpower for this weapon."] = "该武器的命中率受意志加成。"
objDesc["The wearer is treated as an undead."] = "装备者将被视为不死族。"
objDesc["The wearer no longer has to breathe."] = "装备者不需要呼吸。"
objDesc["The wearer is treated as a demon."] = "装备者将被视为恶魔。"
objDesc["Quick Weapon Swap:"] = "无影手："
objDesc["This item allows the wearer to swap to their secondary weapon without spending a turn."] = "该武器允许装备者在切换至副武器时无需消耗一回合。"
objDesc["Blind-Fight: "] = "心眼："
objDesc["This item allows the wearer to attack unseen targets without any penalties."] = "该物品允许你在攻击不可见单位时不受任何惩罚。"
objDesc["Avoid Pressure Traps: "] = "轻盈："
objDesc["The wearer never triggers traps that require pressure."] = "该物品可防止装备者触发压力式陷阱。"
objDesc["Shots beam through all targets."] = "光束穿透所有目标。"
objDesc["This weapon will act as a psionic focus."] = "这把武器可以作为灵能聚焦使用。"
objDesc["The wearer is asleep."] = "穿戴者陷入沉睡。"
objDesc["Lucid Dreamer: "] = "清晰梦境："
objDesc["This item allows the wearer to act while sleeping."] = "此装备允许装备者边睡觉边行动。"
objDesc["Deflect projectiles away: "] = "抛射物偏斜："
objDesc["Reduces paradox anomalies(equivalent to willpower): "] = "时空技能异常阀值（基于意志）："
objDesc["Skullcracker multiplicator: "] = "铁头功加成："
objDesc["All your damage is converted and split into arcane, fire, cold and lightning."] = "你造成的所有伤害被转化均分为奥术、火焰、冰冻和闪电伤害。"
objDesc["Attack speed improves with your strength and size category."] = "攻击速度随力量和体型变化。"
objDesc["Absorbs all darkness in its light radius."] = "吸收范围内一切黑暗"

objDesc["Offers either offensive or defensive benefits, depending on the position of the sands.  Switching the direction of flow takes no time."] = "根据沙的位置在进攻增益和防守增益间切换。切换沙的流向不消耗时间。"
objDesc["When you take a hit of more than 20% of your max life a shield is created equal to 130% the damage taken."] = "当你受到一次攻击损失超过20％最大生命值时，你获得一个护盾，可吸收那个数值130％的伤害。"
objDesc["Detects traps.Gives a 25% to shrug off up to three stuns, pins, and dazes each turn, with a 10 turn cooldown."] = "探测陷阱。每回合有25％几率从至多3个震慑、定身、眩晕状态中解除，该效果冷却时间为10个回合。"
objDesc["Automatically fires lightning bolts at nearby enemies, with a chance to inflict Daze."] = "自动向周围的敌人发射闪电，有一定几率使之眩晕。"
objDesc["All your damage is converted and split into light and darkness."] = "你造成的所有伤害被转化均分为光系和暗影伤害。"
objDesc["Gives all your cold damage a 20% chance to freeze the target."] = "你造成寒冷伤害有20%几率冰冻目标。"
objDesc["When using a mental talent, gives a 10% chance to lower the current cooldowns of up to three of your wild gift, psionic, or cursed talents by three turns."] = "每次使用精神技能时，有10%几率减少至多3个自然、超能、诅咒系的技能冷却时间3回合。"
objDesc["25% of all damage splashes in a radius of 1 around the target."] = "你造成的伤害的25%溅射在目标周围1格"
objDesc["Increases your solipsism threshold by 20% (if you have one). If you do, also grants 15% global speed when worn."] = "增加唯我临界点20%，之后增加15%整体速度"
objDesc["This item does not take a turn to use."] = "使用该物品不需花费时间"
objDesc["Your Lightning and Chain Lightning spells gain a 24% chance to daze, and your Thunderstorm spell gains a 12% chance to daze."] = "你的闪电术和连锁闪电有24%几率闪电风暴有12%几率令对方眩晕"
objDesc["Will bring you back from death, but only once!"] = "能将你从死亡边缘拯救1次"
objDesc["Enhances the effectiveness of Meditation by 20%"] = "强化冥想效果20%"
objDesc["Heals all nearby living creatures by 5 points each turn."]= "每回合治疗周围所有生物5点生命值" 
objDesc["Damage dealt by this weapon is increased by half your critical multiplier, if doing so would kill the target."] = "这把武器造成的伤害将增加一半的暴击加成，如果这样能秒杀目标。"
objDesc["Reduces incoming crit damage: "] = "减少直接暴击伤害： "
objDesc["Chance to avoid any damage: "] = "无视伤害几率： "
objDesc["Ice block penetration: "] = "冰块穿透： "
objDesc["Damage Backlash: "] = "伤害回火： "
objDesc["Reduce all damage from unseen attackers: "] = "降低不可见目标伤害： "
objDesc["Granted talent can block up to 1 instance of damage each 10 turns."] = "提供技能:每十回合能抵挡一次攻击。"
objDesc["No gem"] ="没有宝石"
objDesc["Transfers a bleed, poison, or wound to its source or a nearby enemy every 4 turns."] = "每4回合将一项流血、毒素或伤口效果转移给效果来源或者附近的敌人"
objDesc["Can block like a shield, potentially disarming the enemy."]="能像盾牌一样格挡，可能缴械对方"
objDesc["Increases the damage of Sun Beam by 15%."] = "增加15%阳光烈焰伤害"
objDesc["Trails fire behind you, dealing damage based on spellpower."]="在你身后留下火焰，伤害与法术强度相关"
objDesc["Damage shields have +1 duration and +15% power"] = "伤害护盾增加一回合持续时间和15%强度"
objDesc["% chance to summon an orc spirit"] = "% 几率召唤一个兽人灵魂"
objDesc["Storm Duration: "] = "风暴持续时间："
objDesc["Your Obliterating Smash can destroy walls."] = "你的歼灭挥斩能摧毁墙壁"
objDesc["All nearby enemies take 20 fire damage each turn and healing you for 10% of the damage dealt."] = "附近的敌人每回合受到20火焰伤害。你受到10%伤害值的治疗"
objDesc["Plaguefire detonates when its victim dies, spreading to other enemies up to two times."] = "疫火感染的生物死亡时，疫火将传播到附近的敌人。至多传播2次。"
objDesc["Status resistances shift over time to match the statuses you are being hit by."] = "依据你中的负面状态改变你的状态免疫"
objDesc["Can be unequipped, can't be rerolled."] = "能解除装备，不能重置"
objDesc["Can be unequipped or rerolled."] = "能解除装备或重置"
objDesc["Increases the range of Haste of the Doomed by 1."] = "增加种族技能“加速”的范围1码"
objDesc["Increases all saves by your Shadow Power."] = "每点“阴影强度”增加1点全豁免"
objDesc["Grants spellpower equal to your Shadow Power."] = "每点“阴影强度”增加1点法术强度"
objDesc["Increases all damage penetration by 1% for each point of your Shadow Power."] = "每点“阴影强度”增加1%抗性穿透"
objDesc["Grants 2.5% movement speed for each point of Shadow Power."] = "每点“阴影强度”增加2.5%移动速度"
objDesc["Grants spell-crit equal to half of your Shadow Power."] = "每点“阴影强度”增加0.5%法术暴击率"
objDesc["Grants physical power equal to your Shadow Power."] = "每点“阴影强度”增加1%点物理强度"

objDesc["Increases all damage by 1% for each point of your Shadow Power."] = "每点“阴影强度”增加1%全体伤害加成"
objDesc["Increases all resists by 0.4% for each point of your Shadow Power."] = "每点“阴影强度”增加0.4%全体抗性"
objDesc["Latent Damage Type: "] = "潜在伤害类型："
objDesc["Lights terrain (power 100)"] = "照亮地形（强度100）"
objDesc["Lights terrain (power 10)"] = "照亮地形（强度10）"
objDesc["Slows by 17%"] = "减速17%"

objDesc["This harmonious mindstar will complement other natural mindstars."] = "这个和谐的灵晶能与其他自然灵晶组合成套装。"
objDesc["This purifying mindstar will cleanse other mindstars."] = "这个灵晶能净化其他灵晶"
objDesc["This mindstar will resonate with other psionic mindstars."] = "这个灵晶能和其他超能力灵晶共鸣"
objDesc["This honing mindstar will focus other psionic mindstars."] = "这个灵晶能和其他超能力灵晶共鸣"
objDesc["This parasitic mindstar will draw strength from other psionic mindstars"] = "这个灵晶能从其他超能力灵晶吸取力量"
objDesc["This natural mindstar calls for a summoner."] = "这个自然灵晶需要一个召唤者"
objDesc["The natural wyrm seeks an element."] = "龙战士寻求一种元素"
objDesc["This natural fire should be returned to the wyrm."] = "自然之火应该回归龙战士"
objDesc["This natural frost should be returned to the wyrm."] = "自然之冰应该回归龙战士"
objDesc["This natural sand should be returned to the wyrm."] = "自然之沙应该回归龙战士"
objDesc["This natural lightning should be returned to the wyrm."] = "自然之雷应该回归龙战士"
objDesc["This natural venom should be returned to the wyrm."] = "自然之毒素应该回归龙战士"
objDesc["This psionic mindstar dreams of an epiphany."] = "这个超能灵晶有一个光辉的梦想"
objDesc["This psionic mindstar has an epiphany about dreams."] = "这个超能灵晶有一个光辉的梦想"
objDesc["This mindstar absorbs psionic energy that needs to be projected."] = "这个灵晶吸收被放射出的超能力"
objDesc["This mindstar projects psionic energy if enough is absorbed."] = "这个灵晶能放射出超能力"
objDesc["This psionic mindstar hates not to be wrathful."] = "这个灵晶需要足够的愤怒"
objDesc["This psionic mindstar is wrathful to the hated."] = "这个灵晶需要足够的仇恨"
objDesc["No medical injector available, values are indicative only."] = "没有可用的药物注射器，数值仅供参考。"
objDesc["Deals high light damage and increases critical multiplier."] = "造成大量光明伤害，增加暴击系数。"
objDesc["On landing any melee attack, release a fiery shockwave, dealing fire and physical damage each equal to your steampower in a cone from the target of radius 3."] = "近战攻击将释放冲击波， 半径3的锥形范围内目标受到 等于蒸汽强度的物理火焰伤害。"
objDesc["Strikes can trigger a thunderclap that damages and repel foes."] = "攻击能触发雷电，伤害并击退敌人。"
objDesc["Deals fire damage and ignites the ground."] = "造成火焰伤害，点燃大地。"
objDesc["On critical strikes generates a 3 tiles lightning beam."] = "暴击制造范围3的闪电射线。"
objDesc["Deals lightning damage and drains resources."] = "造成闪电伤害,吸取资源。"
objDesc["Deals stacking poison damage."] = "造成可叠加的毒素伤害。"
objDesc["Infects targets with a stat reducing disease."] = "传染属性削减疾病"
objDesc["Deals cold damage and slows."] = "造成寒冷伤害并减速"
objDesc["Deals acid damage that also reduces armour."] = "造成酸性伤害并降低护甲"
objDesc["Knocks you back when fired."] = "开火时击退自己。"
objDesc["On falling below 20% of your max life, releases a cloud of smoke, confusing nearby enemies and giving you stealth and a chance to avoid incoming damage for 5 turns."]="当生命值少于20%时， 释放烟雾潜行， 混乱周围生物， 并有一定几率免疫伤害，持续5回合。"
objDesc["The more steam the better!"] = "蒸汽越多越好！"
special_t = {}
	special_t["deal cold damage equal to 100 + the higher of your steam or spellpower, and attempt to freeze the target (20% chance)."] = "造成100+蒸汽强度或法术强度较高项的寒冷伤害，并有20%几率冻结目标"
	special_t["10% chance to stun, blind, pin, or confuse the target"] = "10% 几率震慑、致盲、定身或混乱目标"
	special_t["cripple the target"] = "致残目标"
	special_t["wounds the target reducing their healing"] = "重创目标并降低治疗效果"
		special_t["wounds the target"] = "重创目标"
	special_t["splashes the target with acid"] = "用硫酸溅目标一脸"
	special_t["25% chance for lightning to arc to a second target"] = "25% 几率闪电连锁至下一个目标"
	special_t["35% chance for lightning to arc to a second target"] = "35% 几率闪电连锁至下一个目标"
	special_t["random elemental effect"] = "随机元素效果"
	special_t["20% chance to curse the target"] = "20% 几率诅咒目标"
	special_t["25% chance to crush the target"] = "25% 几率碾碎目标"
	special_t["25% chance to remove a magical effect"] = "25% 几率移除魔法效果"
	special_t["burns latent spell energy"] = "燃烧潜在的法术能量"
	special_t["disrupts spell-casting"] = "打断施法"
	special_t["leeches stamina from the target"] = "从目标身上吸收耐力"
	special_t["25% chance to put talents on cooldown"] = "25% 几率使技能进入冷却"
	special_t["20% chance to torment the target"] = "20% 几率折磨目标"
	special_t["10% chance to create an air burst"] = "10% 几率制造一次音爆"
	special_t["10% chance to knock the target back"] = "10% 几率击退目标"
	special_t["10% chance to crush the target"] = "10% 几率碾碎目标"
	special_t["Damage nearby creatures"] = "伤害附近敌人"
	special_t["9% chance to stun or confuse the target"] = "9% 几率震慑或混乱目标"
	special_t["10% chance to send the wielder into a killing frenzy"] = "10% 几率使持有者进入疯狂杀戮状态"
	special_t["10% chance to shimmer to a different hue and gain powers"] = "10% 几率变换不同颜色并且增加强度"
	special_t["40% chance to dominate the target"] = "40% 几率支配目标"
	special_t["dominate the target"] = "支配目标"
	special_t["sets off a powerful explosion"] = "产生一次猛烈的爆炸"
	special_t["grows in power"] = "增加强度"
	special_t["grows dramatically in power"] = "大幅增加强度"
	special_t["torments the target with many mental effects"] = "对目标附加多种精神状态"
	special_t["hit up to two adjacent enemies"] = "攻击目标相邻的2个单位"
	special_t["20% to slow target"] = "20％几率减速目标"
	special_t["bursts into an icy cloud"] = "爆炸成一片冰雾"
	special_t["20% chance to shatter magical shields"] = "20％几率打破魔法护盾"
	special_t["50% chance to shatter magical shields"] = "50％几率打破魔法护盾"
	special_t["silences the target"] = "沉默目标"
	special_t["inflicts pinning spydric poison upon the target"] = "释放出定身目标的毒液"
	special_t["15% chance to animate a bleeding foe's blood"] = "15％几率使处于流血状态的敌人大出血"
	special_t["deal magical damage"] = "造成魔法伤害"
        special_t["decapitate a weakened target"] = "将虚弱的敌人斩首"
        special_t["pin the target to the nearest wall"] ="将目标钉在最近的墙上"
	special_t["deals physical damage equal to 3% of the target's missing health"] = "造成等于目标已损失生命值3%的物理伤害"
	special_t["steals up to 50 mana from the target"] = "从目标处吸取至多50点法力"
	special_t["release a burst of light and dark damage (scales with Magic)"] = "爆发光明和黑暗伤害（随魔法增加）"
	special_t["25% chance to strike the target again."] = "25%几率再次攻击"
	special_t["Attempt to devour a low HP enemy, striking again and possibly killing instantly."] = "试图吞噬低生命的敌人，再次攻击，可能秒杀目标。"
	special_t["inflicts bonus temporal damage and slows target"] = "造成额外时空伤害并让目标减速"
	special_t["25% chance to damage nearby creatures"] = "25%几率伤害附近生物"
	special_t["deal bonus arcane and darkness damage"] = "造成额外奥术和暗影伤害"
	special_t["Causes lightning to strike and destroy any projectiles in a radius of 10, dealing damage and dazing enemies in a radius of 5 around them."] =
	"触发闪电,击落半径10内所有抛射物抛射物半径5以内的敌人受到伤害并被眩晕。"
	special_t["Breaks enemy weapon."] = "破坏对方武器"
	special_t["releases a burst of light, dealing damage equal to your spellpower in a 3 radius cone."]="释放光明，在半径3的锥形范围内造成等于法术强度的伤害"
	special_t["deal manaburn damage equal to your mindpower in a radius 3 cone"] = "在半径3的锥形范围内造成相当于精神强度的法力燃烧伤害"
	special_t["Create a Winter Storm that gradually expands, dealing cold damage to your enemies each turn and reducing their turn energy by 20%.  Melee attacks will relocate the storm on top of your target and increase its duration."]="制造不断扩张的冰风暴，每回合对敌人造成寒冷伤害同时减少对方20%回合能量。近战攻击将强化风暴并延长时间。"
	special_t["reduces mental save penalty"]="减少精神豁免的减益效果"
	special_t["grows dramatically in power"]="显著增加强度"
	special_t["swallows the victim's soul, gaining a new power"]="吞噬受害者的灵魂，得到新的能力"                
	special_t["Enter a Rampage (Shared 30 turn cooldown)."]= "进入暴走状态（共享30回合冷却）" 
	special_t["Random elemental explosion"] = "随机元素爆炸"
	special_t["releases a burst of dark fire, dealing damage equal to your magic stat"] = "释放黑暗之火造成等于魔法属性的伤害"
	special_t["Increases all damage dealt, and reduces all damage taken, by 1%, stacking up to 10 times. Resets after 10 turns without attacking."] = "增加全体伤害并减少受到的伤害各1%%效果持续10回合，最多叠加至10层"
  special_t["The breath attack has a chance to shift randomly between Fire, Ice, Lightning, Acid, and Sand each turn."] = "喷吐攻击的属性每回合有几率在火、冰、闪电、酸和沙之间随机切换。"
  special_t["You have never taken it off."] = "你还没有把它脱下过。"
  special_t["Curse of Madness"] = "疯狂诅咒"
  special_t["Curse of Misfortune"] = "不幸诅咒"
  special_t["Curse of Shrouds"] = "屏障诅咒"
  special_t["Curse of Corpses"] = "尸体诅咒"
  special_t["Curse of Nightmares"] = "噩梦诅咒"
  special_t["Boom."] = "爆炸"
  special_t["project a beam of lightning"] = "制造闪电射线"
  special_t["Mana regeneration, on spell hit 25%% chances to cast lightning."] = "魔力回复，法术命中有25%%几率触发闪电术。"
	special_t["Fully heal yourself. (15 turn cooldown)"] = "完全治疗(15回合冷却)"
	special_t["reduces mental save"] = "减少精神豁免"
	special_t["On hitting with a mindstar, deal physical damage equal to your steampower in radius 1 around the target."] = "用灵晶命中时，在半径1范围内造成等于蒸汽强度的物理伤害"
	special_t["bursts into an cloud of spydric poison, pinning those inside (with a 10 turn cooldown)"] = "爆发一阵具有定身效果的毒云，10回合冷却"
	special_t["strike the target with one of Mind Sear, Psychic Lobotomy, or Sunder Mind, at random."] = "随机触发以下技能之一：心灵光束、精神切断或碾碎心灵"
	special_t["a bolt of lightning strikes your target, dealing lightning damage to them and fire damage to those around them."] = "一道闪电击中目标，造成闪电伤害，并对周围生物造成火焰伤害。"
	special_t["release a burst of light dealing damage equal to your cunning plus your magic in a ball of radius 2. If the target is undead, the damage and radius are doubled."] = "在半径2范围内造成等于灵巧加魔法的光明伤害。若目标为不死族，伤害和半径加倍"
	special_t["Release a burst of shrapnel, dealing physical damage equal to your steampower in a cone from the target of radius 4."] = [[释放榴弹，在半径4锥形范围内造成等于蒸汽强度的物理伤害]]
	special_t["You feel something is #{bold}#very wrong#{normal}# with this ring."] = "你感觉这个戒指#{bold}#非常不对劲#{normal}#."
special_t["When you take a hit of more than 10% of your total life the suit's motors activate for the next turn, displacing you before any blow could hit you."] = "当你受到超过10%总生命值的伤害后，引擎启动，下回合内，每次受到攻击时，将自动移位来避免伤害。"
special_t["Increases your maximum stacks of Death Momentum by 1."] = "增加死亡波纹的上限1。"
special_t["You are immune to mental status effects."] = "你免疫精神状态效果。"
special_t["When worn, gives you an additional prodigy point."] = "装备时，获得一点觉醒技能点。"
special_t["Allows you to resist the most terrible assaults on your mind."] = "让你抵抗最可怕的精神攻击。"
special_t["Burst apart, dealing physical damage equal to 25% of the original damage in a ball of radius 1."] = "产生爆炸，在半径1范围内造成25%原伤害值的伤害。"
special_t["Fire rate increases while firing, up to 5 shots per turn. Resets after 5 turns without firing."] = "攻击频率随着射击而增加，一回合最多射5次。5回合未射击则效果消失。"
special_t["50% chance to reload 1 ammo"] = "50% 几率装填1发弹药"
special_t["When fired, shoots up to 4 extra shots at random foes with a radius 4 cone centered on the target."] = "发射时，在半径4的锥形范围内随机射出至多额外4发子弹。"
special_t["every third hit always crits."] = "第三下攻击必定暴击."
special_t["inflict fire damage based on steampower"] = "造成基于蒸汽强度的火焰伤害"
special_t["Knocks melee attackers away. Distance scales with damage incoming."] = "击退近战攻击者。距离和其造成的伤害有关。"
special_t["They are out to get you.\nThis is not real this is not real this is not real."] = "他们来了。\n这不是真的不是真的不是真"
special_t["On taking fire damage: Gain 5% of the damage as steam."] = "受到的火焰伤害5%转化为蒸汽。"
special_t["You move 3 spaces at once."] = "一次走3格"
special_t["may infect the target with a random disease"] = "可能触发随机疾病"
special_t["Moving builds up a stacking movement speed (caps at 25%) and damage bonus (caps at double). Hitting removes the bonus."] = "移动会带来移动速度加成（最高25%）和伤害加成（最高50%）。攻击后加成消失。"
special_t["Increases the speed bonus from Saw Wheels by 25%."] = "链锯轮滑速度增加25%"
special_t["15% chance to pin the target"] = "15% 几率定身"
special_t["summon a treant (5 turn cooldown)"] = "召唤一个树人(5回合冷却)"
special_t["On Taking Damage: Blindside the attacker (range 6)."] = "受伤触发: 闪电突袭 (范围 6)."
special_t["Attack speed increases with paradox, up to 250% at 1000 paradox."] = "攻击速度随紊乱值增加，1000紊乱时为250%."
special_t["increase paradox by a random amount"] = "随机增加紊乱值"
special_t["All damage dealt by or to you (that is over 1% of max life) bleeds for an additional 20% of the damage as physical damage (ignores most status resistances).\nWhile you are bleeding, Heartrend's damage increases and it gains lifesteal."] = "你受到与造成的所有超过1%总生命的伤害将触发流血效果，无视大部分状态免疫，造成额外20%物理伤害。\n当你处于流血状态时，心脏切割伤害增加并具有吸血效果。"
special_t["If bleed damage per turn is greater than 5% of max life, attacks cleave."] = "若每回合流血伤害伤害超过5%最大生命，攻击变为劈击。"
special_t["deal a melee attack against all other enemies in a circle around you"] = "对周围一圈敌人进行近战攻击。"

--装备鼠标提示汉化替换
function getObjectDescCHN(desc)
	if not desc then return end

	for i = 1,#desc do
		if type(desc[i]) == "string" then
			if objDesc[desc[i]] then
				desc[i] = objDesc[desc[i]]
			else
				--装备要求
				if string.find(desc[i],"Strength %d+") then desc[i] = string.gsub(desc[i],"Strength","力量")
				elseif string.find(desc[i],"Dexterity %d+") then desc[i] = string.gsub(desc[i],"Dexterity","敏捷")
				elseif string.find(desc[i],"Magic %d+") then desc[i] = string.gsub(desc[i],"Magic","魔法")
				elseif string.find(desc[i],"Willpower %d+") then desc[i] = string.gsub(desc[i],"Willpower","意志")
				elseif string.find(desc[i],"Cunning %d+") then desc[i] = string.gsub(desc[i],"Cunning","灵巧")
				elseif string.find(desc[i],"Constitution %d+") then desc[i] = string.gsub(desc[i],"Constitution","体质")
				elseif string.find(desc[i],"Level %d+") then desc[i] = string.gsub(desc[i],"Level","等级")
				elseif string.find(desc[i],"Talent ") then 
					if string.find(desc[i],"Talent .+ %(level %d+%)") then
						desc[i] = string.gsub(desc[i],"Talent","技能")
						desc[i] = string.gsub(desc[i],"level","等级")
					else
						desc[i] = string.gsub(desc[i],"Talent","技能")
					end
				elseif desc[i]:find("Crushing Blows:") then desc[i] = desc[i]:gsub("Crushing Blows:","毁灭之击")
				--装备详细描述
				elseif string.find(desc[i],"Type: .+ / .+") then
					local stype = string.gsub(desc[i],"Type: .+ / ","")
					local type = string.gsub(string.gsub(desc[i],"Type: ","")," /+.+","")
					desc[i] = string.gsub(desc[i],"Type:","装备类型：")
					desc[i] = string.gsub(desc[i],stype:gsub("%-","%%-"),checkObjSubType(stype))
					desc[i] = string.gsub(desc[i],type:gsub("%-","%%-"),checkObjMainType(type))
				elseif string.find(desc[i],"Base power: ") then
					desc[i] = string.gsub(desc[i],"Base power: ","基础伤害：")
				elseif string.find(desc[i],"Uses stat") then
					desc[i] = string.gsub(desc[i],"Uses stats","伤害受属性加成")
					desc[i] = string.gsub(desc[i],"Uses stat","伤害受属性加成")
					desc[i] = string.gsub(desc[i],"Str","力量")
					desc[i] = string.gsub(desc[i],"Mag","魔法")
					desc[i] = string.gsub(desc[i],"Wil","意志")
					desc[i] = string.gsub(desc[i],"Dex","敏捷")
					desc[i] = string.gsub(desc[i],"Cun","灵巧")
					desc[i] = string.gsub(desc[i],"Con","体质")
					desc[i] = string.gsub(desc[i],"Lck","幸运")
				elseif string.find(desc[i],"On weapon hit:") then
					desc[i] = string.gsub(desc[i],"On weapon hit:","武器命中特效：")
				elseif string.find(desc[i],"On weapon crit:") then
					desc[i] = string.gsub(desc[i],"On weapon crit:","武器暴击特效：")
				elseif string.find(desc[i],"On weapon kill:") then 
					desc[i] = string.gsub(desc[i],"On weapon kill:","武器击杀特效：")
				elseif string.find(desc[i],"When this weapon hits") then
					desc[i] = string.gsub(desc[i],"When this weapon hits:","武器命中特效：")
					desc[i] = string.gsub(desc[i],"chance level","几率，等级")
				elseif string.find(desc[i],"When this weapon crits") then
					desc[i] = string.gsub(desc[i],"When this weapon crits:","武器命中特效：")
					desc[i] = string.gsub(desc[i],"chance level","几率，等级")
				elseif string.find(desc[i],"Bomb damage ") then
					desc[i] = string.gsub(desc[i],"Bomb damage ","炸弹伤害")
				elseif string.find(desc[i],"Bomb thrown range ") then
					desc[i] = string.gsub(desc[i],"Bomb thrown range ","炸弹射程")
				elseif string.find(desc[i],"Mana regain %d+") then
					desc[i] = string.gsub(desc[i],"Mana regain","回复法力值")
				elseif string.find(desc[i],"chance to daze for %d+ turns") then
					desc[i] = string.gsub(desc[i],"chance to daze for","几率眩晕目标")
					desc[i] = string.gsub(desc[i],"turns","回合")
				elseif string.find(desc[i],"chance to stun for %d+ turns") then
					desc[i] = string.gsub(desc[i],"chance to stun for","几率震慑目标")
					desc[i] = string.gsub(desc[i],"turns","回合")
				elseif string.find(desc[i],"Additional .+ damage") then
					desc[i] = string.gsub(desc[i],"Additional","额外")
					desc[i] = string.gsub(desc[i],"damage","伤害")
				elseif string.find(desc[i],"Life regen .+ of max life") then
					desc[i] = string.gsub(desc[i],"Life regen ","回复")
					desc[i] = string.gsub(desc[i]," of max life","总生命值")
				elseif desc[i]:find(" .+ %(%d+%(%-%) turn.+%)") then
					desc[i] = desc[i]:gsub("turn","回合")
					desc[i] = desc[i]:gsub("turns","回合")
				elseif desc[i]:find("Detects traps.") then 
					desc[i] = "探测陷阱。"
				elseif desc[i]:find("with a 10 turn cooldown") then
					desc[i]= "每回合有25％几率从至多3个震慑、定身、眩晕状态中解除,冷却时间10个回合。"
				elseif desc[i]:find("Enter Rampage") then
					desc[i] = "生命值滑落至20%下时，进入暴走状态（30回合冷却）"
				elseif desc[i]:find("Increases all damage by") then
					desc[i]= desc[i]:gsub("Increases all damage by","增加"):gsub("of current vim","当前活力值的全体伤害")
				elseif desc[i]:find("Current Bonus: ") then
					desc[i]= "当前加成："
				elseif desc[i]:find("Reduces all damage by") then
					desc[i]= desc[i]:gsub("Reduces all damage by ","减少"):gsub(" of current vim or 50%% of the damage, whichever is lower; but at the cost of vim equal to 5%% of the damage blocked.","当前活力值的伤害，但最多减少50%%。同时消耗5%%格挡值的活力值。")

				elseif desc[i]:find("When your effective movement speed")  then
					desc[i] = "当你的有效移动速度小于100%%时，获得等于差值的百分比减伤，但最多减少70%"
				elseif desc[i]:find("Current reduction bonus")  then
					desc[i] = desc[i]:gsub("Current reduction bonus", "目前减伤加成")
				elseif desc[i]:find("Cannot be unequipped or rerolled until level") then 
					desc[i] = desc[i]:gsub("Cannot be unequipped or rerolled until level","不能解除装备也不能重置，直到等级")
				elseif desc[i]:find("Storm Duration") then 
					desc[i] = desc[i]:gsub("Storm Duration","冰风暴持续时间")
					desc[i] = desc[i]:gsub("None","无")            
				elseif desc[i]:find("darkness damage %(based on Magic%) in a radius 1 around the target") then
            		desc[i] = desc[i]:gsub("deal", "在目标周围1码范围内造成")
            		:gsub("arcane and", "点奥术和")
            		:gsub("darkness damage %(based on Magic%) in a radius 1 around the target", "点暗影伤害。（基于魔法）")
				elseif desc[i]:find("releases a burst of light, dealing") then
					desc[i] = desc[i]:gsub("releases a burst of light, dealing ", "施放一束光线，在3码半径的锥形内造成")
					:gsub("light damage %(based on Spellpower%) in a radius 3 cone.", "点光系伤害。（基于法术强度）")

				elseif desc[i]:find("release a will o' the wisp that will explode against your foes for") then
					desc[i] = desc[i]:gsub("release a will o' the wisp that will explode against your foes for","释放一只鬼火，鬼火将会爆炸并对你的敌人造成")
					:gsub("cold damage %(based on your Magic%)", "点寒冷伤害（基于魔法）")
				elseif desc[i]:find("summon a stationary shining orb within range") then
					desc[i] = desc[i]:gsub("summon a stationary shining orb within range", "在")
					:gsub("for 15 turns that will illuminate its area and deal", "码范围内召唤一个固定的闪光球体十五回合。球体会照亮这个区域，每回合对范围内的敌人造成")
					:gsub("light damage %(based on your Magic and Strength%) to your foes within radius", "点光系伤害（基于你的魔法和力量），半径")
					:gsub("each turn", "码范围。")
				elseif desc[i]:find("Using medical injector") then
					desc[i] = desc[i]:gsub("Using medical injector with","使用药物注射器，注射"):gsub("efficiency and","效率和"):gsub("cooldown modifier.","冷却时间修正的药剂。")
				elseif desc[i]:find("You cannot bleed.") then
					desc[i] = desc[i]:gsub("You cannot bleed.\nWhen you take damage, if your life is under 20%%, heal for 30%% of your max life.","你不会流血。\n每次受伤害时，若生命值少于20%%，治疗30%%最大生命值。"):gsub("turns until ready","回合冷却剩余"):gsub("15 turn cooldown","15回合冷却时间")
				elseif desc[i]:find("air each turn") then
					desc[i]=desc[i]:gsub("Returns","每回合回复"):gsub("air each turn","空气")
				elseif desc[i]:find("life when you use a salve") then
					desc[i]=desc[i]:gsub("Heals you for","每次使用药膏时恢复"):gsub("life when you use a salve.","生命")
				elseif desc[i]:find("flashes light on your target dealing") then
					desc[i]=desc[i]:gsub("flashes light on your target dealing","对目标造成"):gsub(" damage","伤害")
				elseif desc[i]:find("burn your foe dealing ") then
					desc[i]=desc[i]:gsub("burn your foe dealing ","燃烧敌人，造成"):gsub(" damage and igniting the ground for 4 turns","火焰伤害并点燃大地4回合。")
				elseif desc[i]:find("shock your foe dealing ") then
					desc[i]=desc[i]:gsub("shock your foe dealing ","电击敌人，造成"):gsub(" damage and draining some of their resources","伤害并吸取部分能量。")
				elseif desc[i]:find("applies a stacking poison dealing ") then
					desc[i]=desc[i]:gsub("applies a stacking poison dealing ","造成可累计的毒素伤害，每回合"):gsub(" damage per turn","点")
				elseif desc[i]:find("injects a simple virus dealing ") then
					desc[i]=desc[i]:gsub("injects a simple virus dealing ","注射一种简单的病毒，造成"):gsub(" blight damage on hit and lowering the victims highest stat","枯萎伤害并减少其最高一项基础属性。")
				elseif desc[i]:find("chills your foe dealing ") then
					desc[i]=desc[i]:gsub("chills your foe dealing ","使目标寒冷，造成"):gsub(" damage and slowing them by one tenth of a turn","伤害并减速一回合")
				elseif desc[i]:find("splashes acid on your target dealing ") then
					desc[i]=desc[i]:gsub("splashes acid on your target dealing ","释放酸液，造成"):gsub(" damage and reducing their armor","伤害并降低护甲")
				elseif desc[i]:find("chance to avoid a detrimental acid subtype effect") then
					desc[i]=desc[i]:gsub(" chance to avoid a detrimental acid subtype effect","几率免疫酸性负面效果")
				elseif desc[i]:find("steam each time you walk.") then
					desc[i]=desc[i]:gsub("Generate","每次行走生成"):gsub("steam each time you walk","点蒸汽")
				elseif desc[i]:find("chance to fail to operate properly (reduced by Cunning).") then
					desc[i]=desc[i]:gsub("These boots have a","火箭靴有"):gsub("chance to fail to operate properly","几率被不正确地使用"):gsub("reduced by Cunning","随灵巧降低")
				elseif desc[i]:find("mind damage (based on Mindpower) in a radius 1 around the target") then
					desc[i]=desc[i]:gsub("deal","在半径1范围内造成"):gsub("mind damage","精神伤害")
												 :gsub("based on Mindpower","基于精神强度"):gsub("in a radius 1 around the target","")
				elseif desc[i]:find("cooling down: ") then 
					desc[i]=desc[i]:gsub("cooling down: ","冷却时间剩余："):gsub("turns","回合")
				elseif desc[i]:find("physical damage (based on Cunning), making them bleed.") then
					desc[i]=desc[i]:gsub("Has a","每回合有"):gsub("chance each turn to slash an adjacent enemy for","几率攻击一个相邻敌人，造成"):gsub("physical damage (based on Cunning), making them bleed.","物理伤害（基于灵巧），并使之流血。")
				elseif desc[i]:find("If anomaly triggers, halve paradox.") then
					desc[i]=desc[i]:gsub("increase paradox by a drastic amount with a chance to do an anomaly","大幅增加紊乱，有机率触发异常。"):gsub("chance","几率"):gsub("If anomaly triggers, halve paradox.","若触发异常，紊乱减半。")
				elseif desc[i]:find("wounds the target for 7 turns: ") then
					desc[i]=desc[i]:gsub("wounds the target for 7 turns:","对目标造成持续7回合的 伤口:"):gsub("bleeding,","流血伤害"):gsub(" reduced healing","治疗系数下降")
				elseif desc[i]:find("Projects up to") then
					desc[i]=desc[i]:gsub("Projects up to","投射最多"):gsub("attacks dealing","次攻击，造成"):gsub("weapon damage to random targets in range 7","武器伤害，随机攻击7格内敌人"):gsub("cannot hit the initial target"," 不会再击中初始目标")
				else--if desc[i]:find("Special effect on block:") then
					desc[i] = desc[i]:gsub("Special effect on block:","格挡特效：")
							:gsub("Unleash a lightning nova of radius equal to the tinker tier.","释放半径等于材质等级的闪电新星")
							:gsub("Unleash the fury of the cosmos, dealing light and darkness damage to your attackers","释放宇宙的愤怒造成光系与暗影伤害")
				end

			end
			desc[i] = desc[i]:gsub("already known tinker","已学会")
			desc[i] = desc[i]:gsub("Powered by ","装备灌输力量："):gsub("steamtech","蒸汽科技"):gsub("Steamsaw Mastery","蒸汽链锯掌握"):gsub("Steamgun Mastery","蒸汽枪掌握"):gsub("Psyshot","灵能射击")
			desc[i] = desc[i]:gsub("chance to trigger a Blood Grasp cast of level","几率触发鲜血支配，等级"):gsub("chance to trigger a Silence cast of level ","几率触发沉默，等级"):gsub("Reduces duration of detrimental effects by 40%%","减少40%%负面状态持续时间")
			desc[i] = special_t[desc[i]] or desc[i]
			desc[i] = itemDamagedesc(desc[i])
			desc[i] = desc[i]:gsub("chance of physical repulsion","几率物理击退")
			desc[i] =desc[i]:gsub("fire","火焰"):gsub("lightning","闪电"):gsub("arcane","奥术"):gsub("cold","寒冷")
					:gsub("blight","枯萎"):gsub("darkness","暗影"):gsub("physical","物理"):gsub("temporal","时空")
					:gsub("chance of gloom effects","黑暗光环")
				   	:gsub("light","光系"):gsub("acid","酸性"):gsub("mental","精神"):gsub("nature","自然"):gsub("dazing","眩晕")
					:gsub("Unnatural","非自然生物"):gsub("Undead","不死族"):gsub("Demon","恶魔"):gsub("Major","大型"):gsub("Minor","小型")
					:gsub("Summoned","召唤物"):gsub("Animal","动物"):gsub("Humanoid","人形生物"):gsub("Orc","兽人")
					:gsub("Horror","恐魔"):gsub("Dragon","龙"):gsub("Canine","犬类"):gsub("Living","活物"):gsub("Giant","巨人")
					:gsub("Celestial","天空"):gsub("Chronomancy","时空"):gsub("Corruption","堕落"):gsub("Cursed","诅咒")
					:gsub("Technique","格斗"):gsub("Cunning","灵巧"):gsub("Wild","自然"):gsub("-gift",""):gsub("Psionic","超能"):gsub("Spell","法术")
					:gsub("Undead","亡灵"):gsub("Golem","傀儡"):gsub("Race","种族技能")
					:gsub("water","水"):gsub("Steamtech","蒸汽"):gsub("Steam","蒸汽")
					:gsub("Current Resistance:","当前抗性："):gsub("Blood Charges:","鲜血吸收:")
					:gsub("item",""):gsub("life","生命"):gsub("silence","沉默")
			desc[i]=desc[i]:gsub("status","状态"):gsub("alive","存活"):gsub("dead(does not provide benefits)","死亡（不提供属性）")
			desc[i] = desc[i]:gsub("Attach on","附着于"):gsub("worn on",""):gsub("slot",""):gsub("of type","")
					:gsub("mainhand","主手"):gsub("offhand","副手"):gsub("finger","手指"):gsub("body","躯干")
					:gsub("hands","手套"):gsub("feet","脚部"):gsub("head","头部"):gsub("cloak","披风"):gsub("belt","腰带")
					:gsub("lite","灯具"):gsub("neck","项链"):gsub("tool","工具"):gsub("quiver","弹药")
					:gsub("armor","护甲"):gsub("weapon","武器"):gsub("shield","盾牌"):gsub("staff","法杖")
			if desc[i]:find("When attach to") then desc[i] = "当附着时：" end
			desc[i] = cutChrCHN(desc[i], 20)
		end
        end
	return desc
end


--装备类型替换函数
function checkObjMainType(mtype)
	return objectMType[mtype] or mtype
end

--替换装备副类型
function checkObjSubType(stype)
	return objectSType[stype] or stype
end
