local Talents = require "engine.interface.ActorTalents"
local damDesc = Talents.main_env.damDesc
local DamageType = require "engine.DamageType"

Talents.talents_def.T_DUAL_WEAPON_TRAINING.name= "双持专精"
Talents.talents_def.T_DUAL_WEAPON_TRAINING.info= function(self, t)
		return ([[副 手 武 器 伤 害 增 加 至 %d%% 。]]):format(100 * t.getoffmult(self,t))
	end
Talents.talents_def.T_DUAL_WEAPON_DEFENSE.name= "格挡训练"
Talents.talents_def.T_DUAL_WEAPON_DEFENSE.info= function(self, t)
		local xs = ([[  当 技 能 等 级 超 过 5 时 ， 你 能 用 副 手 武 器 挡 住 近 战 攻 击（ 灵 晶 除 外） 。 
		 你 现 在 有 %d%% 的 概 率 偏 移 至 多 %d 点 伤 害 （ 你 副 手 伤 害 的 %d%% ） ， 每 回 合 至 多 触 发 %0.1f 次 （ 基 于 你 的 灵 巧）。 ]]):
		format(t.getDeflectChance(self,t),t.getDamageChange(self, t, true), t.getDeflectPercent(self,t), t.getDeflects(self, t, true))
		return ([[你 已 经 学 会 用 你 的 武 器 招 架 攻 击。 当 你 双 持 时， 增 加 %d 点 近 身 闪 避。 
		受 敏 捷 影 响， 闪 避 增 益 按 比 例 加 成。%s]]):format(t.getDefense(self, t),xs)
	end
Talents.talents_def.T_PRECISION.name= "弱点打击"
Talents.talents_def.T_PRECISION.info= function(self, t)
		return ([[你 已 经 学 会 打 击 弱 点 位 置， 双 持 时 增 加 你 %d 点 护 甲 穿 透。 
		受 敏 捷 影 响， 护 甲 穿 透 有 额 外 加 成。 ]]):format(t.getApr(self, t))
	end
Talents.talents_def.T_MOMENTUM.name= "急速切割"
Talents.talents_def.T_MOMENTUM.info= function(self, t)
		return ([[当 你 双 持 武 器 时， 增 加 %d%% 攻 击 速 度， 快 速 消 耗 体 力 （ -6 体 力 / 回 合）。  ]]):format(t.getSpeed(self, t)*100)
	end
Talents.talents_def.T_DUAL_STRIKE.name= "双持打击"
Talents.talents_def.T_DUAL_STRIKE.info= function(self, t)
		return ([[用 副 手 武 器 造 成 %d%% 伤 害。 
		如 果 攻 击 命 中， 目 标 将 会 被 震 慑 %d 回 合 并 且 你 会 使 用 主 武 器 对 目 标 造 成 %d%% 伤 害。 
		受 命 中 影 响， 震 慑 概 率 有 额 外 加 成。 ]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.7, 1.5), t.getStunDuration(self, t), 100 * self:combatTalentWeaponDamage(t, 0.7, 1.5))
	end
Talents.talents_def.T_FLURRY.name= "疾风连刺"
Talents.talents_def.T_FLURRY.info= function(self, t)
		return ([[对 目 标 进 行 快 速 的 连 刺， 每 把 武 器 进 行 3 次 打 击， 每 次 打 击 造 成 %d%% 的 伤 害。]]):format(100 * self:combatTalentWeaponDamage(t, 0.4, 1.0))
	end
Talents.talents_def.T_SWEEP.name= "拔刀斩"
Talents.talents_def.T_SWEEP.info= function(self, t)
		return ([[对 你 正 前 方 锥 形 范 围 的 敌 人 造 成 %d%% 武 器 伤 害 并 使 目 标 进 入 流 血 状 态， 每 回 合 造 成 %d 点 伤 害， 持 续 %d 回 合。
		 受 主 手 武 器 伤 害 和 敏 捷 影 响， 流 血 伤 害 有 额 外 加 成。 ]]):
		format(100 * self:combatTalentWeaponDamage(t, 1, 1.7), damDesc(self, DamageType.PHYSICAL, t.cutPower(self, t)), t.cutdur(self, t))
	end
Talents.talents_def.T_WHIRLWIND.name= "旋风斩"
Talents.talents_def.T_WHIRLWIND.info= function(self, t)
		return ([[挥 砍 一 周， 用 2 把 武 器 对 你 周 围 的 所 有 敌 人 造 成 %d%% 伤 害。]]):format(100 * self:combatTalentWeaponDamage(t, 1.2, 1.9))
	end


