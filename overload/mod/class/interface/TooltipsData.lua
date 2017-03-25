-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2017 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

require "engine.class"

module(..., package.seeall, class.make)


-------------------------------------------------------------
-- Resources
-------------------------------------------------------------
TOOLTIP_GOLD = [[#GOLD#金币#LAST#
钱！
你可以用金币在城镇的商店里购买道具。
你可以通过杀死敌人、卖掉不需要的装备
或者完成任务获得金币。
]]

TOOLTIP_LIVES = [[#GOLD#生命数#LAST#
你的生命数以及你的死亡次数。
你的总生命数取决于你的死亡模式设定。
你可以获得其他的复活机会，但这不视为
额外的生命数。]]
TOOLTIP_BLOOD_LIFE = [[#GOLD#生命之血#LAST#
生命之血在你体内流淌。
能将你从死亡边缘挽救一次。]]

TOOLTIP_LIFE = [[#GOLD#生命值#LAST#
这是你的生命力量，你收到伤害时会不断
减少。
当生命值低于0时角色死亡。
注意死亡通常是永久的！
提升体质属性可以增加你的生命值。]]

TOOLTIP_DAMAGE_SHIELD = [[#GOLD#护盾#LAST#
不同的技能、物品和力量可以在有限时间
内提供一个护盾。
为你吸收部分伤害。
]]

TOOLTIP_UNNATURAL_BODY = [[#GOLD#诅咒回复#LAST#
你的诅咒之体技能可以使你从倒下的敌人
身上吸取生命。
每次你杀死一个生物，你会累计回复值，
每回合再部分转化为你的生命值。]]

TOOLTIP_LIFE_REGEN = [[#GOLD#生命回复#LAST#
每个回合你的生命回复量。
这个值可以通过施法、技能、注入和装备
来提高。]]

TOOLTIP_HEALING_MOD = [[#GOLD#治疗加值#LAST#
代表你回血技能的效果。
该系数表明治疗对你的生效程度。所有治
疗的基础值需要乘上这个系数（包括生命
自然恢复）。
体质会增加该项属性。]]

TOOLTIP_AIR = [[#GOLD#空气#LAST#
当你受到窒息效果时空气量才会显示。
这个值下降至0角色死亡。当被困在墙内、
深入水下等等情况下空气值会不断下降。
当你返回可以呼吸的区域，空气值会缓慢
恢复。
]]

TOOLTIP_STAMINA = [[#GOLD#体力#LAST#
体力反映你的身体素质。用于使用物理技能。
休息可以恢复体力值，在游戏进行中也会缓
慢恢复。
提升意志属性可以增加体力值。]]

TOOLTIP_MANA = [[#GOLD#法力#LAST#
法力值是你的剩余法术能量。施放法术将
会消耗法力值，使用持续性法术会减少你
的法力最大值。
提升意志属性可以增加法力值。]]

TOOLTIP_POSITIVE = [[#GOLD#正能量#LAST#
正能量是你的剩余神圣能量。
施放某些技能时可以产生正能量，储备的
正能量会随着游戏进行缓慢减少。
]]

TOOLTIP_NEGATIVE = [[#GOLD#负能量#LAST#
负能量是你的剩余神圣能量。
施放某些技能时可以产生负能量，储备的
负能量会随着游戏进行缓慢减少。
]]

TOOLTIP_VIM = [[#GOLD#活力#LAST#
活力是你控制的生命能量。施放堕落系法
术需要消耗活力值。
活力值不会自动回复，你需要从你自身和
你的目标身上吸取。
每杀死一个生物可以吸收意志属性10%的
活力值。
当你用堕落技能杀死一个生物时你可以吸
收回你消耗的活力值。
]]

TOOLTIP_EQUILIBRIUM = [[#GOLD#失衡值#LAST#
失衡值是你保持自然平衡的能力。
失衡值越接近于0你破坏自然平衡的量越少，
当你的失衡值过高时会影响你使用野性系
技能。
]]

TOOLTIP_HATE = [[#GOLD#仇恨值#LAST#
仇恨值是你对目标生物的愤怒程度。
杀死生物和使用某些技能都可以积累仇恨。
所有的痛苦系技能都依靠仇恨来发挥力量，
仇恨值越高你的技能越有效。
]]

TOOLTIP_PARADOX = [[#GOLD#紊乱值#LAST#
紊乱值是你对时空连续性的破坏度。
当紊乱值增加时你的技能消耗和技能效果
会相应提升，但同时你的法术会变得更
难控制。
提升意志属性可以提高你控制时光魔法的
能力。
]]

TOOLTIP_PSI = [[#GOLD#意念力#LAST#
意念力值反映你的意志力能够控制能量的
大小。与物质一样，不能产生或者消灭。
通常会随着你从周围自发吸收到的少量的
热能和动能而缓慢恢复。
如果需要在战斗时迅速大量恢复，需要通
过护盾或者其他技能进行能量的大量吸
收来达到。
能量储存的上限由意志决定。
]]

TOOLTIP_FEEDBACK = [[#GOLD#反馈值#LAST#
反馈值反映你能利用周围环境对你造成的
伤害，会以每回合至少10%的速率下降，且
每回合至少下降1点。你从外界受到的所有
伤害都会增加你的反馈值，增加的数值取
决于你损失生命值的百分比和你的等级。
1级人物在损失50%生命后获得100反馈值，
而50级人物损失20%生命后获得同样多的反
馈值。
]]

TOOLTIP_NECROTIC_AURA = [[#GOLD#死灵光环#LAST#
是维持召唤的死灵随从的主要媒介。
光环内的死灵随从每次杀死生物时会增加
灵魂值。
]]

TOOLTIP_FORTRESS_ENERGY = [[#GOLD#Fortress Energy#LAST#
The energy of the Sher'Tul Fortress. It is replenished by transmogrifying items and used to power all the Fortress systems.
]]

TOOLTIP_LEVEL = [[#GOLD#等级和经验值#LAST#
每次击杀一个不低于你5级的生物你可以
获得经验值。
当你的经验值提升至100%你可以提升一个
的等级。你最多可以提升至50级。
每提升一个等级你将获得属性和技能点数
奖励，利用这些点数可以提升你的角色。
]]

TOOLTIP_ENCUMBERED = [[#GOLD#负重#LAST#
你携带的每种道具都有负重值，你的最大
负重量取决你的力量属性。
当当前负重值超过你的负重量时你就不能
移动了，尝试丢弃一些道具减少负重。
]]

-------------------------------------------------------------
-- Talents
-------------------------------------------------------------
TOOLTIP_INSCRIPTIONS = [[#GOLD#纹身#LAST#
埃亚尔的人们发明了一种利用提取的植物精
华将一些符咒纹刻到皮肤上的技术。
那些纹身可以产生一些特殊的能力，通常
人们会纹刻一种回复纹身，当然还有一些
其他种类的纹身。
]]

TOOLTIP_PRODIGIES = [[#GOLD#Prodigies#LAST#
Prodigies are special talents that only the most powerful of characters can acquire.
All of them require at least 50 in a core stat and many also have other, very specific and/or demanding requirements to learn.
Players can learn new prodigies at levels 30 and 42.]]

TOOLTIP_ITEM_TALENTS = [[#GOLD#Item Talents#LAST#
Some objects bestow additional talents on the wearer or holder.
These talents work like normal, learned talents, but are lost if the object granting them is taken off or dropped, even for a moment.]]

TOOLTIP_ACTIVATED = [[#GOLD#Activated Talents#LAST#
Most talents require activation (i.e. time) to use, and create a specific effect when called upon.
Specific information on each talent appears its tooltip.]]

TOOLTIP_INSTANT = [[#GOLD#Instant Talents#LAST#
Some activated talents take no time to use, being activated with but a thought.
Unlike most talents, instant talents are never put on cooldown from being stunned, and may be usable when most other talents are not.
Specific information on each talent appears its tooltip.]]

TOOLTIP_PASSIVE = [[#GOLD#Passive Talents#LAST#
When learned, passive talents permanently alter the user in some way.
The effects are always present and are usually not dispellable or removable, though other effects may counteract or negate them.
Specific information on each talent appears its tooltip.]]

TOOLTIP_SUSTAINED = [[#GOLD#Sustained Talents#LAST#
Sustained talents are turned on and left on.
While active, a sustained talent produces some effects on the user that stay in effect until the talent is deactivated. Activating most sustained talents require the user to put aside some resources, which become unavailable until the talent is turned off.
Deactivating a sustained talent causes it to go on cooldown.
Specific information on each talent appears its tooltip.]]

-------------------------------------------------------------
-- Speeds
-------------------------------------------------------------
TOOLTIP_SPEED_GLOBAL = [[#GOLD#整体速度#LAST#
你所有的活动都受到整体速度的影响。
当你达到一个特定的数量时，它可以影响
你每回合所能做的事。
例如：在200%整体速度情况下，你的行动
速度可以提升一倍，一个回合别的生物只
能完成一个动作而你可以完成两个。
]]
TOOLTIP_SPEED_MOVEMENT = [[#GOLD#移动速度#LAST#
你移动时消耗的时间。
它表示同一时间内你能移动的数量。
例如：当你有200%移动速度时，你比
在0%时移动速度提升一倍。
]]
TOOLTIP_SPEED_SPELL = [[#GOLD#施法速度#LAST#
你施放法术需要消耗的时间。
它表示你在同一时间内能够施放的法术数
量。
例如：当你有200%施法速度时，你比
0%时同样回合内多施放一次法术。
]]
TOOLTIP_SPEED_ATTACK = [[#GOLD#战斗速度#LAST#
你近战或远程攻击时需要消耗的时间。
它表示你在同一时间内的攻击频率。
例如：当你有200%攻击速度时，你比
0%时同样回合内多攻击一次。
]]
TOOLTIP_SPEED_MENTAL = [[#GOLD#精神速度#LAST#
使用精神能力需要消耗的时间。
它表示你在同一时间内的可使用的精神技
能频率。
例如：当你有200%攻击速度时，你比
0%时同样回合内多施放一次。
]]
-------------------------------------------------------------
-- Stats
-------------------------------------------------------------
TOOLTIP_STATS = [[#GOLD#属性#LAST#
你的角色的主要属性。基础值：你的角色
的基础属性，能通过升级加点增加，被等
级制约。当前值：基础值加上来自装备、
技能等效果后的实际值。
]]
TOOLTIP_STR = [[#GOLD#力量#LAST#
力量属性影响你的角色的物理能力，提升
力量可以提高物理强度，提高使用重型武
器造成的伤害，提高物理豁免，同时提高
你的负重量。
]]
TOOLTIP_DEX = [[#GOLD#敏捷#LAST#
敏捷属性影响你的灵巧和警觉能力，提升
敏捷可以提升精准，提升闪避，
提升摆脱暴击伤害的几率，
提升使用轻武器造成的伤害。
]]
TOOLTIP_CON = [[#GOLD#体质#LAST#
体质属性影响你抵抗和承受伤害的能力，
提升体质可以提高你的最大生命值、物理
豁免和治疗系数。
]]
TOOLTIP_MAG = [[#GOLD#魔法#LAST#
魔法属性影响你驾驭魔法能量的能力，提
升魔法可以提高你的法术强度，提升法术
豁免和提高其他魔法物品的使用效果。
]]
TOOLTIP_WIL = [[#GOLD#意志#LAST#
意志属性是你的专注能力，提升意志可以
提升你的法力值、体力值、超能力量、精
神力、法术豁免和精神豁免。
]]
TOOLTIP_CUN = [[#GOLD#灵巧#LAST#
灵巧属性提升你学习、思考和反应能力。
提升灵巧可以让你学习更多的技能，提升
意志力，提升意志豁免和暴击几率。
]]
TOOLTIP_STRDEXCON = "#AQUAMARINE#物理属性#LAST#\n---\n"..TOOLTIP_STR.."\n---\n"..TOOLTIP_DEX.."\n---\n"..TOOLTIP_CON
TOOLTIP_MAGWILCUN = "#AQUAMARINE#精神属性#LAST#\n---\n"..TOOLTIP_MAG.."\n---\n"..TOOLTIP_WIL.."\n---\n"..TOOLTIP_CUN

-------------------------------------------------------------
-- Melee
-------------------------------------------------------------
TOOLTIP_COMBAT_ATTACK = [[#GOLD#命中#LAST#
命中值表示经目标防御值校正后你击中目
标和使目标失去平衡的几率。
当造成基于命中的持续性物理效果的时候，
敌人的相关豁免每超过命中一点减少5％持
续时间。
]]
TOOLTIP_COMBAT_PHYSICAL_POWER = [[#GOLD#物理强度#LAST#
物理强度表示你在战斗中造成物理伤害的
能力。
当造成基于物理强度的持续性物理效果的
时候，敌人的相关豁免每超过物理强度一
点减少5％持续时间。
]]
TOOLTIP_COMBAT_DAMAGE = [[#GOLD#伤害#LAST#
你攻击目标时产生的伤害量。
目标受到的伤害可以被其护甲值或百分比
免伤属性所减免。
提升力量和敏捷属性可以提升伤害，一些
技能也可以改变影响伤害值的属性。
]]
TOOLTIP_COMBAT_APR = [[#GOLD#护甲穿透#LAST#
护甲穿透可以让你忽视部分目标护甲值（
只对护甲值有效，对百分比免伤无效）。
它不能提高造成的伤害，所以只对有装甲
属性的目标有效。
]]
TOOLTIP_COMBAT_CRIT = [[#GOLD#物理暴击#LAST#
每次造成物理伤害时你都有一定几率造成
一次150%普通伤害量的致命攻击。
一些技能可以提高这个几率。
提升灵巧属性值可以提高物理暴击率。
]]
TOOLTIP_COMBAT_SPEED = [[#GOLD#攻击速度#LAST#
攻击速度表示你在每个回合内攻击速度。
值越高你的攻击速度越快。
]]
TOOLTIP_COMBAT_RANGE = [[#GOLD#攻击范围#LAST#
你武器能攻击的最远距离。
]]
TOOLTIP_ARCHERY_RANGE_SPEED = [[#GOLD#弓箭范围和速度Archery range and speed#LAST#
弓箭能射出的最大范围，超过范围攻击会消失。
所有抛射物有独立的飞行速度，以百分比形式和移动速度比较。
]]
TOOLTIP_COMBAT_AMMO = [[#GOLD#弹药剩余#LAST#
表示你剩余的弹药数量。
弓和投石索有一个无限量的基础弹药，当
你装备的弹药为0时你依然可以射击。
炼金术士必须装备炼金宝石来作为弹药使
用。
]]

-------------------------------------------------------------
-- Defense
-------------------------------------------------------------
TOOLTIP_FATIGUE = [[#GOLD#疲劳值#LAST#
疲劳值是你施放法术和技能时增加消耗的
一个百分比。
当你装备重型装备时会增加疲劳值。
并不是所有技能都受疲劳值影响，特别是
野性系。
]]
TOOLTIP_ARMOR = [[#GOLD#护甲值#LAST#
护甲值是受到近身或者远程物理伤害时伤
害的减免量。
吸收(护甲强度)%武器伤害，直至护甲最
大伤害吸收值。
此数值会因护甲穿透减少，并且这一判定
作用发生在所有
暴击伤害加成、技能加成和伤害加成之前，
也就是说即使
是很小的数值也会有更大的作用。
]]
TOOLTIP_ARMOR_HARDINESS = [[#GOLD#护甲强度#LAST#
护甲强度表示护甲可以减免的伤害百分比。
吸收(护甲强度)%武器伤害，直至护甲最
大伤害吸收值。
]]
TOOLTIP_CRIT_REDUCTION = [[#GOLD#暴击抵抗#LAST#
暴击抵抗使你减少受近身或远程暴击的概率。
]]
TOOLTIP_CRIT_SHRUG = [[#GOLD#暴击摆脱#LAST#
让你在受到暴击时，有一定概率避免暴击的
额外伤害。
]]
TOOLTIP_DEFENSE = [[#GOLD#近身闪避#LAST#
近身闪避表示你免受近战物理攻击的几率，
并减少被攻击失去平衡的几率，受攻击者命
中值影响。
]]
TOOLTIP_RDEFENSE = [[#GOLD#远程防御#LAST#
远程防御表示你免收远程物理攻击的几率，
并减少被攻击失去平衡的几率受攻击者命中
值影响。
]]
TOOLTIP_PHYS_SAVE = [[#GOLD#物理豁免#LAST#
增加你摆脱物理效果的几率，基于目标物
理强度判定后，每超过1点减少5％不良物
理状态持续时间。
]]
TOOLTIP_SPELL_SAVE = [[#GOLD#法术豁免#LAST#
增加你摆脱法术效果的几率，基于目标法
术强度判定后，每超过1点减少5％不良法
术状态持续时间。
]]
TOOLTIP_MENTAL_SAVE = [[#GOLD#精神豁免#LAST#
增加你摆脱精神效果的几率，基于目标精
神强度判定后，每超过1点减少5％不良精
神状态持续时间。
]]
-------------------------------------------------------------
-- Physical
-------------------------------------------------------------
TOOLTIP_PHYSICAL_POWER = [[#GOLD#物理强度#LAST#
你的物理强度代表了你的物理能力，该
属性受武器、力量等因素影响。
另外当造成基于物理强度的负面效果时，
敌人的相应豁免每超过物理强度一点将
减少5％持续时间。
]]
TOOLTIP_PHYSICAL_CRIT = [[#GOLD#物理暴击#LAST#
每次造成物理伤害时你都有一定几率
暴击造成额外伤害。
一些技能可以提高这个几率。
提升灵巧属性值可以提高法术暴击率。

]]
-------------------------------------------------------------
-- Spells
-------------------------------------------------------------
TOOLTIP_SPELL_POWER = [[#GOLD#法术强度#LAST#
你的法术强度决定了你施放法术技能的威
力。
另外当造成基于法术强度的负面效果时，
敌人的相应豁免每超过法术强度一点将
减少5％持续时间。
]]
TOOLTIP_SPELL_CRIT = [[#GOLD#法术暴击#LAST#
每次造成法术伤害时你都有一定几率
暴击造成额外伤害。
一些技能可以提高这个几率。
提升灵巧属性值可以提高法术暴击率。
]]
TOOLTIP_SPELL_SPEED = [[#GOLD#施放速度#LAST#
施放速度表示你在每个回合内施法的速度。
值越高你的施法速度越快。
]]
TOOLTIP_SPELL_COOLDOWN = [[#GOLD#冷却速度#LAST#
法术冷却速度反映了你的法术冷却时间有
多快。
它的数值越低，你越可以频繁的使用法术
和符文技能。
]]
-------------------------------------------------------------
-- Mental
-------------------------------------------------------------
TOOLTIP_MINDPOWER = [[#GOLD#精神强度#LAST#
你的精神强度决定了你施放精神法术的威
力。
另外当造成基于精神强度的负面效果时，
敌人的相应豁免每超过精神强度一点将
减少5％持续时间。
]]
TOOLTIP_MIND_CRIT = [[#GOLD#精神暴击#LAST#
每次造成精神伤害时你都有一定几率
暴击造成额外伤害。
一些技能可以提高这个几率。
提升灵巧属性值可以提高精神暴击。
]]
TOOLTIP_MIND_SPEED = [[#GOLD#精神速度#LAST#
精神速度是你使用超能力技能的速度。
值越高速度越快。
]]
-------------------------------------------------------------
-- Damage and resists
-------------------------------------------------------------
TOOLTIP_INC_DAMAGE_ALL = [[#GOLD#伤害加成：全体#LAST#
所有类型任何方式造成的伤害都受此值加
成。
可以与独立类型的伤害增加效果叠加。
]]
TOOLTIP_INC_DAMAGE = [[#GOLD#伤害加成：
指定#LAST#
任何方式造成指定类型的伤害受此值加成。
]]
TOOLTIP_INC_CRIT_POWER = [[#GOLD#暴击
加成#LAST#
所有暴击伤害（近战、魔法等等）受此值
加成以造成更大的暴击伤害。
]]
TOOLTIP_RESIST_ALL = [[#GOLD#伤害抵抗：全体#LAST#
所有类型任何方式对你造成的伤害按此值
减免。
可以与独立类型的伤害减免效果叠加。
]]
TOOLTIP_RESIST_ABSOLUTE = [[#GOLD#伤害抵抗: 绝对#LAST#
所有类型任何方式对你造成的伤害按此值
减免。
该效果在常规伤害抵抗后生效，不受抗性
穿透影响。
]]
TOOLTIP_RESIST = [[#GOLD#伤害抵抗：指定#LAST#
任何方式受到指定类型的伤害按此值减免。
]]

TOOLTIP_RESIST_SPEED = [[#GOLD#伤害抵抗: 速度#LAST#
所有类型任何方式对你造成的伤害按此值
减免，随着你的总体移动速度减少而增加。
该效果在常规伤害抵抗后生效，不受抗性
穿透影响。
]]
TOOLTIP_RESIST_DAMAGE_ACTOR = [[#GOLD#伤害抵抗: 生物类型#LAST#
任何方式受到指定生物类型的伤害按此值减免。
]]
TOOLTIP_AFFINITY_ALL = [[#GOLD#伤害吸收: 全体#LAST#
任何方式受到的伤害均按此值治疗你。
可以与独立类型的伤害吸收效果叠加。
注意：伤害吸收的治疗效果在伤害产生
后处理，不能防止秒杀。
]]
TOOLTIP_AFFINITY = [[#GOLD#伤害吸收: 指定#LAST#
任何方式受到指定类型的伤害按此值治疗你。
注意：伤害吸收的治疗效果在伤害产生
后处理，不能防止秒杀。
TOOLTIP_STATUS_IMMUNE = [[#GOLD#状态免疫#LAST#
大部分状态效果可以被特定的免疫来抵消。
百分比表示你完全免疫特效的几率。]]
TOOLTIP_SPECIFIC_IMMUNE = [[#GOLD#特
效免疫几率#LAST#
表示你完全免疫特效的几率。]]
TOOLTIP_STUN_IMMUNE = [[#GOLD#震慑免疫#LAST#
表示你完全免疫震慑、眩晕或者冰冻的几率。
]]
TOOLTIP_INSTAKILL_IMMUNE = [[#GOLD#即死免疫#LAST#
表示你对立即死亡类效果的抵抗几率。
]]
TOOLTIP_NEGATIVE_STATUS_IMMUNE = [[#GOLD#负面状态效果免疫#LAST#
表示你完全免疫负面特效的几率。
]]
TOOLTIP_ON_HIT_DAMAGE = [[#GOLD#伤害反弹#LAST#
生物每次近战攻击你时所受到的反弹伤害。
]]
TOOLTIP_MELEE_PROJECT = [[#GOLD#近战附加伤害#LAST#
每次近战攻击都会额外造成的伤害。
]]
TOOLTIP_MELEE_PROJECT_INNATE = TOOLTIP_MELEE_PROJECT..[[
这和你的武器伤害相互独立。
]]
TOOLTIP_RANGED_PROJECT = [[#GOLD#远程附加伤害#LAST#
每次远程攻击都会额外造成的伤害。
]]
TOOLTIP_RANGED_PROJECT_INNATE = TOOLTIP_RANGED_PROJECT..[[
这和你的武器伤害相互独立。
]]
TOOLTIP_RESISTS_PEN_ALL = [[#GOLD#伤害穿透：全体#LAST#
减少你造成伤害时目标的所有有效伤害抗
性。
如果你对某种生物有50%全体伤害穿透那
最终这个生物的所有伤害抗性均为原抗性
值的50%。
可以与独立类型的伤害穿透效果叠加。
]]
TOOLTIP_RESISTS_PEN = [[#GOLD#伤害穿透：指定#LAST#
减少你造成指定类型伤害时目标对该类型
伤害的抗性。
如果你对某种生物有50%指定类型伤害穿
透并且这个生物对该伤害类型有50%的伤
害抗性，那最终这个生物对该伤害抗性
为25%。
]]
TOOLTIP_FLAT_RESIST = [[#GOLD#伤害减免#LAST#
按固定数值减免某种类型（或所有类型）
伤害。
该效果会递减，每40点为一等级；每增加
一等级，一点有效值需要的原始值加一。
显示在面板上的为有效值。
]]


-------------------------------------------------------------
-- Misc
-------------------------------------------------------------
TOOLTIP_ESP = [[#GOLD#感知#LAST#
能让你感知到指定类型的生物，哪怕它不
在你的视线范围内。
]]
TOOLTIP_ESP_RANGE = [[#GOLD#感知范围#LAST#
决定了你能够感知到生物的范围。
]]
TOOLTIP_ESP_ALL = [[#GOLD#感知#LAST#
能让你感知到指定类型的生物，哪怕它不
在你的视线范围内。
]]
TOOLTIP_VISION_LITE = [[#GOLD#光照范围#LAST#
你可照亮的最大距离，除非已设有照明否
则超出这个范围的地方是不可见的。
]]
TOOLTIP_VISION_SIGHT = [[#GOLD#视线范围#LAST#
你视线所及的范围，只有在有光照的地方
有效。
]]
TOOLTIP_VISION_INFRA = [[#GOLD#强化感知#LAST#
特殊的视觉范围（包括暗视），即使黑
暗处也有效，只能发现生物。不同类型
视觉取最大值。
]]
TOOLTIP_VISION_STEALTH = [[#GOLD#潜行#LAST#
要使用潜行角色必须具有潜行技能。
潜行可以让你在不被敌人发现的情况下接
近敌人。
就算他们发现了你也需要花费更多时间集
中你。
所有生物都会从潜行中试图发现你。
]]
TOOLTIP_VISION_SEE_STEALTH = [[#GOLD#侦测潜行#LAST#
你发现潜行生物的能力，该值越高你发现
的几率也越高（受目标自身的潜行等级影
响）。
]]
TOOLTIP_VISION_INVISIBLE = [[#GOLD#隐形#LAST#
隐形生物可以从敌人的视线中消失，他们
只能被有侦测隐形的生物发现。
]]
TOOLTIP_VISION_SEE_INVISIBLE = [[#GOLD#侦测隐形#LAST#
你发现隐形生物的能力，该值越高你发现
的几率也越高（受目标自身隐形等级的影
响）。
TOOLTIP_SEE_TRAPS = [[#GOLD#侦察陷阱#LAST#
你侦察陷阱的能力，该属性越高，你就越
容易发现陷阱。
]]
TOOLTIP_ANTIMAGIC_USER = [[#GOLD#反魔法#LAST#
你决心反对并摧毁世界上的魔法与奥术
力量。
拒绝使用法术，不能装备力量来源为奥术
的装备。
]]
