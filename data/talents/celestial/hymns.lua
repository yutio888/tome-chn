local Talents = require "engine.interface.ActorTalents"
local damDesc = Talents.main_env.damDesc
local DamageType = require "engine.DamageType"

Talents.talents_def.T_HYMN_OF_SHADOWS.name= "暗影圣诗"
Talents.talents_def.T_HYMN_OF_SHADOWS.info= function(self, t)
		local darknessinc = t.getDarknessDamageIncrease(self, t)
		local darknessdamage = t.getDamageOnMeleeHit(self, t)
		return ([[赞 美 月 之 荣 耀， 使 你 获 得 暗 影 充 能， 你 的 攻 击 额 外 增 加 %d%% 点 暗 影 伤 害。 
		 此 外 它 提 供 你 暗 影 护 盾， 对 任 何 攻 击 你 的 目 标 造 成 %0.2f 暗 影 伤 害。 
		 同 时 只 能 激 活 1 个 圣 诗。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(darknessinc, damDesc(self, DamageType.DARKNESS, darknessdamage))
	end
Talents.talents_def.T_HYMN_OF_DETECTION.name= "侦查圣诗"
Talents.talents_def.T_HYMN_OF_DETECTION.info= function(self, t)
		local infra = t.getInfraVisionPower(self, t)
		local invis = t.getSeeInvisible(self, t)
		local stealth = t.getSeeStealth(self, t)
		local darknessdamage = t.getDamageOnMeleeHit(self, t)
		return ([[赞 美 月 之 荣 耀， 使 你 的 夜 视 范 围 增 加 到 %d 码， 能 察 觉 潜 行 单 位（ +%d 侦 测 等 级） 和 隐 形 单 位（ +%d 侦 测 等 级）。 
		 此 外 它 提 供 你 暗 影 护 盾， 对 任 何 攻 击 你 的 目 标 造 成 %0.2f 暗 影 伤 害。 
		 同 时 只 能 激 活 1 个 圣 诗。 
		 受 法 术 强 度 影 响， 侦 测 等 级 和 伤 害 有 额 外 加 成。]]):
		format(infra, stealth, invis, damDesc(self, DamageType.DARKNESS, darknessdamage))
	end
Talents.talents_def.T_HYMN_OF_PERSEVERANCE.name= "坚韧圣诗"
Talents.talents_def.T_HYMN_OF_PERSEVERANCE.info= function(self, t)
		local immunities = t.getImmunities(self, t)
		local darknessdamage = t.getDamageOnMeleeHit(self, t)
		return ([[赞 美 月 之 荣 耀， 增 加 你 %d%% 震 慑、 致 盲 和 混 乱 抵 抗。 
		 此 外 它 提 供 你 暗 影 护 盾， 对 任 何 攻 击 你 的 目 标 造 成 %0.2f 暗 影 伤 害。 
		 同 时 只 能 激 活 1 个 圣 诗。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(100 * (immunities), damDesc(self, DamageType.DARKNESS, darknessdamage))
	end
Talents.talents_def.T_HYMN_OF_MOONLIGHT.name= "月光圣诗"
Talents.talents_def.T_HYMN_OF_MOONLIGHT.info= function(self, t)
		local targetcount = t.getTargetCount(self, t)
		local damage = t.getDamage(self, t)
		local drain = t.getNegativeDrain(self, t)
		return ([[当 此 技 能 激 活 时， 会 在 你 身 边 产 生 1 片 影 之 舞 跟 随 你。 
		 每 回 合 随 机 向 附 近 5 码 半 径 范 围 内 的 %d 个 敌 人 发 射 暗 影 射 线， 造 成 1 到 %0.2f 伤 害。 
		 这 个 强 大 法 术 的 每 道 射 线 会 消 耗 %0.1f 负 能 量， 如 果 能 量 值 过 低 则 不 会 发 射 射 线。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(targetcount, damDesc(self, DamageType.DARKNESS, damage), drain)
	end

