local Talents = require "engine.interface.ActorTalents"
local damDesc = Talents.main_env.damDesc
local DamageType = require "engine.DamageType"

Talents.talents_def.T_CHANT_OF_FORTITUDE.name = "坚韧赞歌"
Talents.talents_def.T_CHANT_OF_FORTITUDE.info = function(self, t)
		local saves = t.getResists(self, t)
		local life = t.getLifePct(self, t)
		local damageonmeleehit = t.getDamageOnMeleeHit(self, t)
		return ([[赞 美 太 阳 之 荣 耀 使 你 获 得 %d 点 物 理 及 法 术 豁 免 并 增 加 %0.1f%% 最 大 生 命 值。(当 前 增 加:  %d).
		 此 外 它 提 供 你 光 之 护 盾， 对 任 何 攻 击 你 的 目 标 造 成 %0.1f 光 系 伤 害。 
		 同 时 只 能 激 活 1 个 圣 歌。 
		 豁 免 和 伤 害 受 法 术 强 度 加 成 ， 生 命 值 受 技 能 等 级 影 响 。]]):
		format(saves, life*100, life*self.max_life, damDesc(self, DamageType.LIGHT, damageonmeleehit))
	end
Talents.talents_def.T_CHANT_OF_FORTRESS.name = "防御赞歌"
Talents.talents_def.T_CHANT_OF_FORTRESS.info = function(self, t)
		local range = -t.getDamageChange(self, t)
		local damageonmeleehit = t.getDamageOnMeleeHit(self, t)
		return ([[赞 美 太 阳 之 荣 耀, 距 离 3 及 以 上 的 敌 人 对 你 的 伤 害 减 少 %d%% 。
		 此 外 它 提 供 你 光 之 护 盾， 对 任 何 攻 击 你 的 目 标 造 成 %0.1f 光 系 伤 害。 
		 同 时 只 能 激 活 1 个 圣 歌。 
		 伤 害 减 少 量 受 技 能 等 级 加 成 ， 光 系 伤 害 受 法 强 加 成。]]):
		format(range, damDesc(self, DamageType.LIGHT, damageonmeleehit))
	end
Talents.talents_def.T_CHANT_OF_RESISTANCE.name = "元素赞歌"
Talents.talents_def.T_CHANT_OF_RESISTANCE.info = function(self, t)
		local resists = t.getResists(self, t)
		local damage = t.getDamageOnMeleeHit(self, t)
		return ([[赞 美 太 阳 之 荣 耀 使 你 获 得 %d%% 全 体 抵 抗。 
		 此 外 它 提 供 你 光 之 护 盾， 对 任 何 攻 击 你 的 目 标 造 成 %0.1f 光 系 伤 害。 
		 同 时 只 能 激 活 1 个 圣 歌。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(resists, damDesc(self, DamageType.LIGHT, damage))
	end
Talents.talents_def.T_CHANT_OF_LIGHT.name = "光明赞歌"
Talents.talents_def.T_CHANT_OF_LIGHT.info = function(self, t)
		local damageinc = t.getLightDamageIncrease(self, t)
		local damage = t.getDamageOnMeleeHit(self, t)
		local lite = t.getLite(self, t)
		return ([[赞 美 太 阳 之 荣 耀 使 你 获 得 光 系 与 火 系 充 能， 造 成 %d%% 点 额 外 伤 害。 
		 此 外 它 提 供 你 光 之 护 盾， 对 任 何 攻 击 你 的 目 标 造 成 %0.1f 光 系 伤 害。 
		 你 的 光 照 范 围 同 时 增 加 %d 码。 
		 同 时 只 能 激 活 1 个 圣 歌 ，另 外 此 赞 歌 消 耗 能 量 较 少。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(damageinc, damDesc(self, DamageType.LIGHT, damage), lite)
	end

