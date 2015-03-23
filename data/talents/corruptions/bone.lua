local Talents = require "engine.interface.ActorTalents"
local damDesc = Talents.main_env.damDesc
local DamageType = require "engine.DamageType"

Talents.talents_def.T_BONE_SPEAR.name= "白骨之矛"
Talents.talents_def.T_BONE_SPEAR.info= function(self, t)
		return ([[对 一 条 线 上 的 目 标 释 放 1 根 骨 矛， 造 成 %0.2f 物 理 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.PHYSICAL, self:combatTalentSpellDamage(t, 20, 200)))
	end
Talents.talents_def.T_BONE_GRAB.name= "白骨之握"
Talents.talents_def.T_BONE_GRAB.info= function(self, t)
		return ([[抓 住 目 标 并 传 送 到 你 的 身 边， 从 地 上 冒 出 一 根 骨 刺 将 其 定 在 那， 持 续 %d 回 合。 
		 骨 刺 同 时 也 会 造 成 %0.2f 物 理 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):
		format(t.getDuration(self, t), damDesc(self, DamageType.PHYSICAL, self:combatTalentSpellDamage(t, 5, 140)))
	end
Talents.talents_def.T_BONE_NOVA.name= "白骨新星"
Talents.talents_def.T_BONE_NOVA.info= function(self, t)
		return ([[向 所 有 方 向 射 出 骨 矛， 对 %d 码 范 围 内 所 有 敌 人 造 成 %0.2f 物 理 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(self:getTalentRadius(t), damDesc(self, DamageType.PHYSICAL, self:combatTalentSpellDamage(t, 8, 180)))
	end
Talents.talents_def.T_BONE_SHIELD.name= "白骨护盾"
Talents.talents_def.T_BONE_SHIELD.info= function(self, t)
		return ([[制 造 1 圈 白 骨 护 盾 围 绕 你。 每 个 护 盾 能 完 全 吸 收 1 次 攻 击。 
		 当 前 最 多 可 制 造 %d 个 护 盾。
		 每 %d 个 回 合 会 自 动 补 充 一 个 骨 盾。 ]]):
		format(t.getNb(self, t), t.getRegen(self, t))
	end

