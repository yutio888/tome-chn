local Talents = require "engine.interface.ActorTalents"
local damDesc = Talents.main_env.damDesc
local DamageType = require "engine.DamageType"

Talents.talents_def.T_PUSH_KICK.name= "强力踢"
Talents.talents_def.T_PUSH_KICK.info= function(self, t)
		local damage = t.getDamage(self, t) *100
		return ([[每 有 一 个  连 击 点，  对 目 标 造 成 %d%% 武 器 伤 害，并 解 除 目 标 一 项 物 理 持 续 技 能。 
		等 级 3 时，魔 法 持 续 技 能 也 会 受 影 响。
		等 级 5 时，精 神 持 续 技 能 也 会 受 影 响。 
		使 用 该 技 能 将 除 去 全 部 连 击 点。]])
		:format(damage)
	end
Talents.talents_def.T_DEFENSIVE_THROW.name= "闪身投掷"
Talents.talents_def.T_DEFENSIVE_THROW.info= function(self, t)
		local damage = t.getDamage(self, t)
		local damagetwo = t.getDamageTwo(self, t)
		return ([[当 你 闪 避 一 次 近 战 攻 击 时 ，如 果 你 没 有 装 备 武 器 你 有 %d%% 概 率 将 目 标 摔 到 地 上。 
		如 果 目 标 被 成 功 摔 倒， 则 会 造 成 %0.2f 伤 害 且 目 标 被 眩 晕 2 回 合 或 承 受 %0.2f 伤 害。 同 时 目 标 若 被 抓 取， 则 会 被 震 慑 2 回 合。
		每 回 合 至 多 触 发 %0.1f 次。
		受 命 中 和 物 理 强 度 影 响， 摔 投 概 率 和 伤 害 按 比 例 加 成。
		触 发 次 数 受 力 量 和 敏 捷 影 响。]]):
		format(t.getchance(self,t), damDesc(self, DamageType.PHYSICAL, (damage)), damDesc(self, DamageType.PHYSICAL, (damagetwo)), t.getThrows(self, t))
	end
Talents.talents_def.T_BREATH_CONTROL.name= "空手格挡"
Talents.talents_def.T_BREATH_CONTROL.info= function(self, t)
		local block = t.getBlock(self, t)
		local maxblock = block*5
		return ([[硬 化 身 体 ，每 有 一 点 连 击 点 就 能 格 挡 %d 点 伤 害（至 多 %d ）,持 续 2 回 合。
			当 前 格 挡 值:  %d
			使 用 该 技 能 会 除 去 所 有 连 击 点。]])
		:format(block, maxblock, block * self:getCombo())
	end
Talents.talents_def.T_ROUNDHOUSE_KICK.name= "回旋踢"
Talents.talents_def.T_ROUNDHOUSE_KICK.info= function(self, t)
		local damage = t.getDamage(self, t)
		return ([[施 展 回 旋 踢 攻 击 前 方 敌 人， 造 成 %0.2f 物 理 伤 害 并 击 退 之。
		这 项 攻 击 会 取 消 你 的 抓 取 效 果。
		受 物 理 强 度 影 响 ， 伤 害 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.PHYSICAL, (damage)))
	end
		
	


