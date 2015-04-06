local Talents = require "engine.interface.ActorTalents"

dofile("/data-chn123/talents/celestial/chants.lua")
dofile("/data-chn123/talents/celestial/circles.lua")
dofile("/data-chn123/talents/celestial/sunlight.lua")
dofile("/data-chn123/talents/celestial/sun.lua")
dofile("/data-chn123/talents/celestial/combat.lua")
dofile("/data-chn123/talents/celestial/light.lua")
dofile("/data-chn123/talents/celestial/glyphs.lua")
dofile("/data-chn123/talents/celestial/guardian.lua")
dofile("/data-chn123/talents/celestial/radiance.lua")
dofile("/data-chn123/talents/celestial/crusader.lua")
dofile("/data-chn123/talents/celestial/twilight.lua")
dofile("/data-chn123/talents/celestial/hymns.lua")
dofile("/data-chn123/talents/celestial/star-fury.lua")
dofile("/data-chn123/talents/celestial/eclipse.lua")

dofile("/data-chn123/talents/corruptions/sanguisuge.lua")
dofile("/data-chn123/talents/corruptions/scourge.lua")
dofile("/data-chn123/talents/corruptions/plague.lua")
dofile("/data-chn123/talents/corruptions/reaving-combat.lua")
dofile("/data-chn123/talents/corruptions/bone.lua")
dofile("/data-chn123/talents/corruptions/curses.lua")
dofile("/data-chn123/talents/corruptions/hexes.lua")
dofile("/data-chn123/talents/corruptions/blood.lua")
dofile("/data-chn123/talents/corruptions/blight.lua")
dofile("/data-chn123/talents/corruptions/shadowflame.lua")
dofile("/data-chn123/talents/corruptions/vim.lua")
dofile("/data-chn123/talents/corruptions/torment.lua")
dofile("/data-chn123/talents/corruptions/vile-life.lua")

dofile("/data-chn123/talents/cunning/stealth.lua")
dofile("/data-chn123/talents/cunning/traps.lua")
dofile("/data-chn123/talents/cunning/poisons.lua")
dofile("/data-chn123/talents/cunning/dirty.lua")
dofile("/data-chn123/talents/cunning/lethality.lua")
dofile("/data-chn123/talents/cunning/tactical.lua")
dofile("/data-chn123/talents/cunning/survival.lua")
dofile("/data-chn123/talents/cunning/shadow-magic.lua")
dofile("/data-chn123/talents/cunning/ambush.lua")
dofile("/data-chn123/talents/cunning/scoundrel.lua")
dofile("/data-chn123/talents/cunning/called-shots.lua")

dofile("/data-chn123/talents/cursed/slaughter.lua")
dofile("/data-chn123/talents/cursed/endless-hunt.lua")
dofile("/data-chn123/talents/cursed/strife.lua")
dofile("/data-chn123/talents/cursed/gloom.lua")
dofile("/data-chn123/talents/cursed/rampage.lua")
dofile("/data-chn123/talents/cursed/predator.lua")

dofile("/data-chn123/talents/cursed/force-of-will.lua")
dofile("/data-chn123/talents/cursed/dark-sustenance.lua")
dofile("/data-chn123/talents/cursed/shadows.lua")
dofile("/data-chn123/talents/cursed/darkness.lua")
dofile("/data-chn123/talents/cursed/punishments.lua")
dofile("/data-chn123/talents/cursed/gestures.lua")
dofile("/data-chn123/talents/cursed/one-with-shadows.lua")

dofile("/data-chn123/talents/cursed/cursed-form.lua")
dofile("/data-chn123/talents/cursed/cursed-aura.lua")
dofile("/data-chn123/talents/cursed/fears.lua")

dofile("/data-chn123/talents/gifts/call.lua")
dofile("/data-chn123/talents/gifts/harmony.lua")

dofile("/data-chn123/talents/gifts/antimagic.lua")

dofile("/data-chn123/talents/gifts/slime.lua")
dofile("/data-chn123/talents/gifts/fungus.lua")
dofile("/data-chn123/talents/gifts/mucus.lua")
dofile("/data-chn123/talents/gifts/ooze.lua")
dofile("/data-chn123/talents/gifts/moss.lua")
dofile("/data-chn123/talents/gifts/oozing-blades.lua")
dofile("/data-chn123/talents/gifts/corrosive-blades.lua")

dofile("/data-chn123/talents/gifts/sand-drake.lua")
dofile("/data-chn123/talents/gifts/fire-drake.lua")
dofile("/data-chn123/talents/gifts/cold-drake.lua")
dofile("/data-chn123/talents/gifts/storm-drake.lua")
dofile("/data-chn123/talents/gifts/venom-drake.lua")
dofile("/data-chn123/talents/gifts/higher-draconic.lua")

dofile("/data-chn123/talents/gifts/summon-melee.lua")
dofile("/data-chn123/talents/gifts/summon-distance.lua")
dofile("/data-chn123/talents/gifts/summon-utility.lua")
dofile("/data-chn123/talents/gifts/summon-augmentation.lua")
dofile("/data-chn123/talents/gifts/summon-advanced.lua")

dofile("/data-chn123/talents/gifts/mindstar-mastery.lua")
dofile("/data-chn123/talents/gifts/eyals-fury.lua")

dofile("/data-chn123/talents/misc/objects.lua")
dofile("/data-chn123/talents/misc/misc2.lua")
dofile("/data-chn123/talents/misc/npcs.lua")
dofile("/data-chn123/talents/misc/horrors.lua")
dofile("/data-chn123/talents/misc/races.lua")

dofile("/data-chn123/talents/psionic/absorption.lua")
dofile("/data-chn123/talents/psionic/finer-energy-manipulations.lua")
dofile("/data-chn123/talents/psionic/projection.lua")
dofile("/data-chn123/talents/psionic/psi-fighting.lua")
dofile("/data-chn123/talents/psionic/voracity.lua")
dofile("/data-chn123/talents/psionic/augmented-mobility.lua")
dofile("/data-chn123/talents/psionic/augmented-striking.lua")
dofile("/data-chn123/talents/psionic/focus.lua")
dofile("/data-chn123/talents/psionic/other.lua")

dofile("/data-chn123/talents/psionic/kinetic-mastery.lua")
dofile("/data-chn123/talents/psionic/thermal-mastery.lua")
dofile("/data-chn123/talents/psionic/charged-mastery.lua")

dofile("/data-chn123/talents/psionic/discharge.lua")
dofile("/data-chn123/talents/psionic/distortion.lua")
dofile("/data-chn123/talents/psionic/dream-forge.lua")
dofile("/data-chn123/talents/psionic/dream-smith.lua")
dofile("/data-chn123/talents/psionic/dreaming.lua")
dofile("/data-chn123/talents/psionic/mentalism.lua")
dofile("/data-chn123/talents/psionic/feedback.lua")
dofile("/data-chn123/talents/psionic/nightmare.lua")
dofile("/data-chn123/talents/psionic/psychic-assault.lua")
dofile("/data-chn123/talents/psionic/slumber.lua")
dofile("/data-chn123/talents/psionic/solipsism.lua")
dofile("/data-chn123/talents/psionic/thought-forms.lua")

dofile("/data-chn123/talents/spells/arcane.lua")
dofile("/data-chn123/talents/spells/aether.lua")
dofile("/data-chn123/talents/spells/fire.lua")
dofile("/data-chn123/talents/spells/wildfire.lua")
dofile("/data-chn123/talents/spells/earth.lua")
dofile("/data-chn123/talents/spells/stone.lua")
dofile("/data-chn123/talents/spells/water.lua")
dofile("/data-chn123/talents/spells/ice.lua")
dofile("/data-chn123/talents/spells/air.lua")
dofile("/data-chn123/talents/spells/storm.lua")
dofile("/data-chn123/talents/spells/conveyance.lua")
dofile("/data-chn123/talents/spells/aegis.lua")
dofile("/data-chn123/talents/spells/meta.lua")
dofile("/data-chn123/talents/spells/divination.lua")
dofile("/data-chn123/talents/spells/temporal.lua")
dofile("/data-chn123/talents/spells/phantasm.lua")
dofile("/data-chn123/talents/spells/enhancement.lua")

dofile("/data-chn123/talents/spells/explosives.lua")
dofile("/data-chn123/talents/spells/golemancy.lua")
dofile("/data-chn123/talents/spells/advanced-golemancy.lua")
dofile("/data-chn123/talents/spells/staff-combat.lua")
dofile("/data-chn123/talents/spells/fire-alchemy.lua")
dofile("/data-chn123/talents/spells/frost-alchemy.lua")
dofile("/data-chn123/talents/spells/acid-alchemy.lua")
dofile("/data-chn123/talents/spells/energy-alchemy.lua")
dofile("/data-chn123/talents/spells/stone-alchemy.lua")
dofile("/data-chn123/talents/spells/golem.lua")

dofile("/data-chn123/talents/spells/necrotic-minions.lua")
dofile("/data-chn123/talents/spells/advanced-necrotic-minions.lua")
dofile("/data-chn123/talents/spells/nightfall.lua")
dofile("/data-chn123/talents/spells/shades.lua")
dofile("/data-chn123/talents/spells/necrosis.lua")
dofile("/data-chn123/talents/spells/grave.lua")
dofile("/data-chn123/talents/spells/animus.lua")

dofile("/data-chn123/talents/techniques/2hweapon.lua")
dofile("/data-chn123/talents/techniques/2h-assault.lua")
dofile("/data-chn123/talents/techniques/strength-of-the-berserker.lua")
dofile("/data-chn123/talents/techniques/dualweapon.lua")
dofile("/data-chn123/talents/techniques/weaponshield.lua")
dofile("/data-chn123/talents/techniques/superiority.lua")
dofile("/data-chn123/talents/techniques/warcries.lua")
dofile("/data-chn123/talents/techniques/bloodthirst.lua")
dofile("/data-chn123/talents/techniques/battle-tactics.lua")
dofile("/data-chn123/talents/techniques/field-control.lua")
dofile("/data-chn123/talents/techniques/combat-techniques.lua")
dofile("/data-chn123/talents/techniques/combat-training.lua")
dofile("/data-chn123/talents/techniques/bow.lua")
dofile("/data-chn123/talents/techniques/sling.lua")
dofile("/data-chn123/talents/techniques/archery.lua")
dofile("/data-chn123/talents/techniques/excellence.lua")
dofile("/data-chn123/talents/techniques/magical-combat.lua")
dofile("/data-chn123/talents/techniques/mobility.lua")
dofile("/data-chn123/talents/techniques/pugilism.lua")
dofile("/data-chn123/talents/techniques/thuggery.lua")

dofile("/data-chn123/talents/techniques/skirmisher-slings.lua")
dofile("/data-chn123/talents/techniques/buckler-training.lua")
dofile("/data-chn123/talents/techniques/acrobatics.lua")
dofile("/data-chn123/talents/techniques/tireless-combatant.lua")

dofile("/data-chn123/talents/techniques/pugilism.lua")
dofile("/data-chn123/talents/techniques/unarmed-discipline.lua")
dofile("/data-chn123/talents/techniques/finishing-moves.lua")
dofile("/data-chn123/talents/techniques/grappling.lua")
dofile("/data-chn123/talents/techniques/unarmed-training.lua")
dofile("/data-chn123/talents/techniques/conditioning.lua")

dofile("/data-chn123/talents/undeads/ghoul.lua")
dofile("/data-chn123/talents/undeads/skeleton.lua")
	dofile("data-chn123/talents/chronomancy/chronomancer.lua")
	if(Talents.talents_def.T_INCINERATING_BLOWS) then 
		dofile("data-chn123/talents/corruptions/corruptions.lua")
		dofile("data-chn123/talents/misc/misc.lua")
	end
	if(Talents.talents_def.T_DWARVEN_HALF_EARTHEN_MISSILES) then
		dofile("data-chn123/talents/gifts/gifts.lua")
		dofile("data-chn123/talents/spells/spells.lua")
	end
	
	

--uber/const
Talents.talents_def.T_DRACONIC_BODY.name = "龙族之躯"
Talents.talents_def.T_BLOODSPRING.name = "血如泉涌"
Talents.talents_def.T_ETERNAL_GUARD.name = "永恒防御"
Talents.talents_def.T_NEVER_STOP_RUNNING.name = "永不止步"
Talents.talents_def.T_ARMOUR_OF_SHADOWS.name = "影之护甲"
Talents.talents_def.T_SPINE_OF_THE_WORLD.name = "世界之脊"
Talents.talents_def.T_FUNGAL_BLOOD.name = "真菌之血"
Talents.talents_def.T_CORRUPTED_SHELL.name = "堕落之壳"

--uber/cun
Talents.talents_def.T_FAST_AS_LIGHTNING.name = "疾如闪电"
Talents.talents_def.T_TRICKY_DEFENSES.name = "欺诈护盾"
Talents.talents_def.T_ENDLESS_WOES.name = "无尽灾厄"
Talents.talents_def.T_SECRETS_OF_TELOS.name = "泰勒斯之秘"
Talents.talents_def.T_ELEMENTAL_SURGE.name = "元素狂潮"
Talents.talents_def.T_EYE_OF_THE_TIGER.name = "猛虎之眼"
Talents.talents_def.T_WORLDLY_KNOWLEDGE.name = "渊博学识"
Talents.talents_def.T_TRICKS_OF_THE_TRADE.name = "欺诈圣手"

--uber/dex
Talents.talents_def.T_THROUGH_THE_CROWD.name = "穿梭人群"
Talents.talents_def.T_SWIFT_HANDS.name = "疾影手"
Talents.talents_def.T_WINDBLADE.name = "剑刃风暴"
Talents.talents_def.T_WINDTOUCHED_SPEED.name = "和风守护"
Talents.talents_def.T_GIANT_LEAP.name = "战争践踏"
Talents.talents_def.T_CRAFTY_HANDS.name = "心灵手巧"
Talents.talents_def.T_ROLL_WITH_IT.name = "随波逐流"
Talents.talents_def.T_VITAL_SHOT.name = "要害射击"

--uber/mag
Talents.talents_def.T_SPECTRAL_SHIELD.name = "无光之盾"
Talents.talents_def.T_AETHER_PERMEATION.name = "以太渗透"
Talents.talents_def.T_MYSTICAL_CUNNING.name = "魔之秘术"
Talents.talents_def.T_ARCANE_MIGHT.name = "奥术之握"
Talents.talents_def.T_TEMPORAL_FORM.name = "时空形态"
Talents.talents_def.T_BLIGHTED_SUMMONING.name = "枯萎召唤"
Talents.talents_def.T_REVISIONIST_HISTORY.name = "修正历史"
Talents.talents_def.T_CAUTERIZE.name = "浴火重生"

--uber/str
Talents.talents_def.T_FLEXIBLE_COMBAT.name = "自由格斗"
Talents.talents_def.T_TITAN_S_SMASH.name = "化作星星吧！！"
Talents.talents_def.T_MASSIVE_BLOW.name = "巨人之锤"
Talents.talents_def.T_STEAMROLLER.name = "无尽冲锋"
Talents.talents_def.T_IRRESISTIBLE_SUN.name = "无御之日"
Talents.talents_def.T_NO_FATIGUE.name = "我能举起世界！"
Talents.talents_def.T_LEGACY_OF_THE_NALOREN.name = "纳鲁之传承"
Talents.talents_def.T_SUPERPOWER.name = "超级力量"

--uber/wil
Talents.talents_def.T_DRACONIC_WILL.name = "龙族意志"
Talents.talents_def.T_METEORIC_CRASH.name = "落星"
Talents.talents_def.T_GARKUL_S_REVENGE.name = "加库尔的复仇"
Talents.talents_def.T_HIDDEN_RESOURCES.name = "潜能爆发"
Talents.talents_def.T_LUCKY_DAY.name = "幸运日"
Talents.talents_def.T_UNBREAKABLE_WILL.name = "坚定意志"
Talents.talents_def.T_SPELL_FEEDBACK.name = "法术反馈"
Talents.talents_def.T_MENTAL_TYRANNY.name = "灵魂之怒"