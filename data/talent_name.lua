t_talent_name = {}
--[[
已作废，仅供参考
local Talents = require "engine.interface.ActorTalents"
local damDesc = Talents.main_env.damDesc


--uber/const

Talents.talents_def.T_BLOODSPRING.name= "血如泉涌"
Talents.talents_def.T_BLOODSPRING.info
Talents.talents_def.T_ETERNAL_GUARD.name= "永恒防御"
Talents.talents_def.T_ETERNAL_GUARD.info
Talents.talents_def.T_NEVER_STOP_RUNNING.name= "永不止步"
Talents.talents_def.T_NEVER_STOP_RUNNING.info
Talents.talents_def.T_ARMOUR_OF_SHADOWS.name= "影之护甲"
Talents.talents_def.T_ARMOUR_OF_SHADOWS.info
Talents.talents_def.T_SPINE_OF_THE_WORLD.name= "世界之脊"
Talents.talents_def.T_SPINE_OF_THE_WORLD.info
Talents.talents_def.T_FUNGAL_BLOOD.name= "真菌之血"
Talents.talents_def.T_FUNGAL_BLOOD.info
Talents.talents_def.T_CORRUPTED_SHELL.name= "堕落之壳"
Talents.talents_def.T_CORRUPTED_SHELL.info

--uber/cun
Talents.talents_def.T_FAST_AS_LIGHTNING.name= "疾如闪电"
Talents.talents_def.T_FAST_AS_LIGHTNING.info
Talents.talents_def.T_TRICKY_DEFENSES.name= "欺诈护盾"
Talents.talents_def.T_TRICKY_DEFENSES.info
Talents.talents_def.T_ENDLESS_WOES.name= "无尽灾厄"
Talents.talents_def.T_ENDLESS_WOES.info
Talents.talents_def.T_SECRETS_OF_TELOS.name= "泰勒斯之秘"
Talents.talents_def.T_SECRETS_OF_TELOS.info
Talents.talents_def.T_ELEMENTAL_SURGE.name= "元素狂潮"
Talents.talents_def.T_ELEMENTAL_SURGE.info
Talents.talents_def.T_EYE_OF_THE_TIGER.name= "猛虎之眼"
Talents.talents_def.T_EYE_OF_THE_TIGER.info
Talents.talents_def.T_WORLDLY_KNOWLEDGE.name= "渊博学识"
Talents.talents_def.T_WORLDLY_KNOWLEDGE.info
Talents.talents_def.T_TRICKS_OF_THE_TRADE.name= "欺诈圣手"
Talents.talents_def.T_TRICKS_OF_THE_TRADE.info

--uber/dex
Talents.talents_def.T_THROUGH_THE_CROWD.name= "穿梭人群"
Talents.talents_def.T_THROUGH_THE_CROWD.info
Talents.talents_def.T_SWIFT_HANDS.name= "疾影手"
Talents.talents_def.T_SWIFT_HANDS.info
Talents.talents_def.T_WINDBLADE.name= "剑刃风暴"
Talents.talents_def.T_WINDBLADE.info
Talents.talents_def.T_WINDTOUCHED_SPEED.name= "和风守护"
Talents.talents_def.T_WINDTOUCHED_SPEED.info
Talents.talents_def.T_GIANT_LEAP.name= "战争践踏"
Talents.talents_def.T_GIANT_LEAP.info
Talents.talents_def.T_CRAFTY_HANDS.name= "心灵手巧"
Talents.talents_def.T_CRAFTY_HANDS.info
Talents.talents_def.T_ROLL_WITH_IT.name= "随波逐流"
Talents.talents_def.T_ROLL_WITH_IT.info
Talents.talents_def.T_VITAL_SHOT.name= "要害射击"
Talents.talents_def.T_VITAL_SHOT.info

--uber/mag
Talents.talents_def.T_SPECTRAL_SHIELD.name= "无光之盾"
Talents.talents_def.T_SPECTRAL_SHIELD.info
Talents.talents_def.T_AETHER_PERMEATION.name= "以太渗透"
Talents.talents_def.T_AETHER_PERMEATION.info
Talents.talents_def.T_MYSTICAL_CUNNING.name= "魔之秘术"
Talents.talents_def.T_MYSTICAL_CUNNING.info
Talents.talents_def.T_ARCANE_MIGHT.name= "奥术之握"
Talents.talents_def.T_ARCANE_MIGHT.info
Talents.talents_def.T_TEMPORAL_FORM.name= "时空形态"
Talents.talents_def.T_TEMPORAL_FORM.info
Talents.talents_def.T_BLIGHTED_SUMMONING.name= "枯萎召唤"
Talents.talents_def.T_BLIGHTED_SUMMONING.info
Talents.talents_def.T_REVISIONIST_HISTORY.name= "修正历史"
Talents.talents_def.T_REVISIONIST_HISTORY.info
Talents.talents_def.T_CAUTERIZE.name= "浴火重生"
Talents.talents_def.T_CAUTERIZE.info

--uber/str
Talents.talents_def.T_FLEXIBLE_COMBAT.name= "自由格斗"
Talents.talents_def.T_FLEXIBLE_COMBAT.info
Talents.talents_def.T_TITAN_S_SMASH.name= "化作星星吧！！"
Talents.talents_def.T_TITAN_S_SMASH.info
Talents.talents_def.T_MASSIVE_BLOW.name= "巨人之锤"
Talents.talents_def.T_MASSIVE_BLOW.info
Talents.talents_def.T_STEAMROLLER.name= "无尽冲锋"
Talents.talents_def.T_STEAMROLLER.info
Talents.talents_def.T_IRRESISTIBLE_SUN.name= "无御之日"
Talents.talents_def.T_IRRESISTIBLE_SUN.info
Talents.talents_def.T_NO_FATIGUE.name= "我能举起世界！"
Talents.talents_def.T_NO_FATIGUE.info
Talents.talents_def.T_LEGACY_OF_THE_NALOREN.name= "纳鲁之传承"
Talents.talents_def.T_LEGACY_OF_THE_NALOREN.info
Talents.talents_def.T_SUPERPOWER.name= "超级力量"
Talents.talents_def.T_SUPERPOWER.info

--uber/wil
Talents.talents_def.T_DRACONIC_WILL.name= "龙族意志"
Talents.talents_def.T_DRACONIC_WILL.info
Talents.talents_def.T_METEORIC_CRASH.name= "落星"
Talents.talents_def.T_METEORIC_CRASH.info
Talents.talents_def.T_GARKUL_S_REVENGE.name= "加库尔的复仇"
Talents.talents_def.T_GARKUL_S_REVENGE.info
Talents.talents_def.T_HIDDEN_RESOURCES.name= "潜能爆发"
Talents.talents_def.T_HIDDEN_RESOURCES.info
Talents.talents_def.T_LUCKY_DAY.name= "幸运日"
Talents.talents_def.T_LUCKY_DAY.info
Talents.talents_def.T_UNBREAKABLE_WILL.name= "坚定意志"
Talents.talents_def.T_UNBREAKABLE_WILL.info
Talents.talents_def.T_SPELL_FEEDBACK.name= "法术反馈"
Talents.talents_def.T_SPELL_FEEDBACK.info
Talents.talents_def.T_MENTAL_TYRANNY.name= "灵魂之怒"
Talents.talents_def.T_MENTAL_TYRANNY.info




--misc/inscriptions

Talents.talents_def.T_INFUSION:_HEALING.name= "纹身：治疗"
Talents.talents_def.T_INFUSION:_HEALING.info
Talents.talents_def.T_INFUSION:_WILD.name= "纹身：狂暴"
Talents.talents_def.T_INFUSION:_WILD.info
Talents.talents_def.T_INFUSION:_MOVEMENT.name= "纹身：移动加速"
Talents.talents_def.T_INFUSION:_MOVEMENT.info
Talents.talents_def.T_INFUSION:_SUN.name= "纹身：阳光"
Talents.talents_def.T_INFUSION:_SUN.info
Talents.talents_def.T_INFUSION:_HEROISM.name= "纹身：英勇"
Talents.talents_def.T_INFUSION:_HEROISM.info
Talents.talents_def.T_INFUSION:_INSIDIOUS_POISON.name= "纹身：下毒"
Talents.talents_def.T_INFUSION:_INSIDIOUS_POISON.info
Talents.talents_def.T_INFUSION:_WILD_GROWTH.name= "纹身：野性生长"
Talents.talents_def.T_INFUSION:_WILD_GROWTH.info
Talents.talents_def.T_INFUSION:_PRIMAL.name= "纹身：原初之力"
Talents.talents_def.T_INFUSION:_PRIMAL.info
Talents.talents_def.T_RUNE:_PHASE_DOOR.name= "符文：相位之门"
Talents.talents_def.T_RUNE:_PHASE_DOOR.info
Talents.talents_def.T_RUNE:_CONTROLLED_PHASE_DOOR.name= "符文：可控性相位门"
Talents.talents_def.T_RUNE:_CONTROLLED_PHASE_DOOR.info
Talents.talents_def.T_RUNE:_TELEPORTATION.name= "符文：传送"
Talents.talents_def.T_RUNE:_TELEPORTATION.info
Talents.talents_def.T_RUNE:_SHIELDING.name= "符文：护盾"
Talents.talents_def.T_RUNE:_SHIELDING.info
Talents.talents_def.T_RUNE:_REFLECTION_SHIELD.name= "符文：反射护盾"
Talents.talents_def.T_RUNE:_REFLECTION_SHIELD.info
Talents.talents_def.T_RUNE:_INVISIBILITY.name= "符文：隐形"
Talents.talents_def.T_RUNE:_INVISIBILITY.info
Talents.talents_def.T_RUNE:_SPEED.name= "符文：加速"
Talents.talents_def.T_RUNE:_SPEED.info
Talents.talents_def.T_RUNE:_VISION.name= "符文：视界"
Talents.talents_def.T_RUNE:_VISION.info
Talents.talents_def.T_RUNE:_HEAT_BEAM.name= "符文：热能射线"
Talents.talents_def.T_RUNE:_HEAT_BEAM.info
Talents.talents_def.T_RUNE:_BITING_GALE.name= "符文：冰风吞噬"
Talents.talents_def.T_RUNE:_BITING_GALE.info
Talents.talents_def.T_RUNE:_ACID_WAVE.name= "符文：酸性冲击波"
Talents.talents_def.T_RUNE:_ACID_WAVE.info
Talents.talents_def.T_RUNE:_LIGHTNING.name= "符文：闪电冲击"
Talents.talents_def.T_RUNE:_LIGHTNING.info
Talents.talents_def.T_RUNE:_MANASURGE.name= "符文：法力回复"
Talents.talents_def.T_RUNE:_MANASURGE.info
Talents.talents_def.T_RUNE_OF_THE_RIFT.name= "符文：时空裂隙"
Talents.talents_def.T_RUNE_OF_THE_RIFT.info
Talents.talents_def.T_TAINT:_DEVOURER.name= "堕落印记：吞噬"
Talents.talents_def.T_TAINT:_DEVOURER.info
Talents.talents_def.T_TAINT:_TELEPATHY.name= "堕落印记：感应"
Talents.talents_def.T_TAINT:_TELEPATHY.info]]










