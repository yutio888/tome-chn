local Talents = require "engine.interface.ActorTalents"
local damDesc = Talents.main_env.damDesc
local DamageType = require "engine.DamageType"

Talents.talents_def.T_LACERATING_STRIKES.name= "撕裂挥击"
Talents.talents_def.T_LACERATING_STRIKES.info= function(self, t)
		return ([[你 的 每 次 攻 击 都 会 撕 裂 敌 人。 
		 所 有 的 攻 击 现 在 都 有 %d%% 的 概 率 撕 裂 目 标， 使 目 标 进 入 持 续 10 回 合 的 流 血 状 态， 总 计 造 成 %d%% 你 的 攻 击 伤 害 值。]]):
		format(t.cutChance(self, t), 100 * self:combatTalentWeaponDamage(t, 0.15, 0.35))
	end
Talents.talents_def.T_SCOUNDREL.name= "街霸战术"
Talents.talents_def.T_SCOUNDREL.info= function(self, t)
		local duration = t.getDuration(self, t)
		local move = t.getMovePenalty(self, t)
		local attack = t.getAttackPenalty(self, t)
		local will = t.getWillPenalty(self, t)
		local cun = t.getCunPenalty(self, t)
		return ([[你 学 会 利 用 敌 人 的 痛 苦。 
		 如 果 一 个 正 在 流 血 的 敌 人 试 图 攻 击 你， 则 它 的 暴 击 率 会 降 低 %d%% ， 因 为 它 的 伤 口 使 其 行 动 更 容 易 被 预 判。 
		 如 果 你 攻 击 一 个 正 在 流 血 的 敌 人， 那 么 你 有 %d%% 几 率 在 %d 回 合 内 致 残 目 标， 通 过 利 用 目 标 的 创 口 减 少 其 %d%% 移 动 速 度 和 %d 命 中； 或 者 对 目 标 的 创 口 进 行 再 次 打 击 加 深 其 痛 苦， 减 少 目 标 %d 的 意 志 和 %d 的 灵 巧。 
		 受 灵 巧 影 响， 减 值 有 额 外 加 成。
		]]):format(t.getCritPenalty(self,t), t.disableChance(self, t), duration, move * 100, attack, will, cun)
	end
Talents.talents_def.T_NIMBLE_MOVEMENTS.name= "隐匿冲锋"
Talents.talents_def.T_NIMBLE_MOVEMENTS.info= function(self, t)
		return ([[你 快 速 且 隐 蔽 的 冲 向 目 标 区 域， 中 途 可 以 被 敌 人 或 障 碍 物 打 断。 此 技 能 不 会 中 断 潜 行。]])
	end
Talents.talents_def.T_MISDIRECTION.name= "误导"
Talents.talents_def.T_MISDIRECTION.info= function(self, t)
		return ([[你 制 造 混 乱 的 技 巧 已 趋 于 巅 峰。 现 在， 即 便 是 你 最 简 单 的 动 作 也 会 迷 惑 敌 人， 使 他 们 看 不 透 你 的 行 踪。 
		 你 增 加 %d%% 闪 避， 并 且 敌 人 有 %d%% 几 率 会 被 误 导， 从 而 攻 击 你 旁 边 %d 码 范 围 的 随 机 地 区。 
		 受 灵 巧 影 响， 闪 避 的 增 加 比 率 有 额 外 加 成。]]):
		format(t.getDefense(self, t) ,t.getDeflect(self, t) ,t.getDeflectRange(self,t))
	end

