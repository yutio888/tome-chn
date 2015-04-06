local Talents = require "engine.interface.ActorTalents"
local damDesc = Talents.main_env.damDesc
local DamageType = require "engine.DamageType"

Talents.talents_def.T_STEALTH.name= "潜行"
Talents.talents_def.T_STEALTH.info= function(self, t)
		local stealthpower = t.getStealthPower(self, t) + (self:attr("inc_stealth") or 0)
		local radius = t.getRadius(self, t)
		return ([[进 入 潜 行 模 式（ %d 点 潜 行 等 级， 基 于 灵 巧）， 使 你 更 难 被 察 觉。 如 果 潜 行 成 功 ( 每 回 合 都 会 进 行 鉴 定 )， 则 敌 人 无 法 看 到 你 也 不 会 注 意 到 你 的 行 动。 
		 当 你 在 潜 行 状 态 时， 光 照 范 围 减 少 至 0 。 并 且， 当 你 穿 重 甲 或 板 甲 时 将 无 法 潜 行。 
		 当 周 围 %d 码 范 围 内 有 可 见 敌 人 时， 你 将 无 法 潜 行。]]):
		format(stealthpower, radius)
	end
Talents.talents_def.T_SHADOWSTRIKE.name= "影袭"
Talents.talents_def.T_SHADOWSTRIKE.info= function(self, t)
		local multiplier = t.getMultiplier(self, t)
		return ([[当 你 在 隐 身 状 态 下 发 动 攻 击 时， 如 果 在 你 攻 击 前 目 标 没 发 现 你， 你 的 攻 击 会 自 动 变 成 暴 击。 
		 影 袭 的 暴 击 伤 害 比 普 通 暴 击 伤 害 多 +%.02f%% 。]]):
		format(multiplier * 100)
	end
Talents.talents_def.T_HIDE_IN_PLAIN_SIGHT.name= "强制隐身"
Talents.talents_def.T_HIDE_IN_PLAIN_SIGHT.info= function(self, t)
		return ([[你 学 会 如 何 在 敌 人 的 视 线 内 进 入 潜 行 状 态。
		 成 功 率 取 决 于 %0.2f 倍 潜 行 强 度（ 现 有 %d 点 ）、 所 有 敌 人 的 侦 测 潜 行 强 度、敌 人 数 目 以 及 敌 人 和 你 的 距 离（ 每 有 1 码 距 离 ， 对 方 侦 测 潜 行 强 度 减 少 10 ％ ） ， 同 时 此 技 能 会 刷 新 潜 行 的 冷 却 时 间。 
		 所 有 正 在 追 赶 你 的 生 物 都 会 丢 失 你 的 踪 迹。
		 当 你 不 在 敌 人 的 视 野 内 时， 成 功 率 为 100 ％。]]):
		format(t.stealthMult(self, t), t.getChance(self, t, true))
	end
Talents.talents_def.T_UNSEEN_ACTIONS.name= "行动如风"
Talents.talents_def.T_UNSEEN_ACTIONS.info= function(self, t)
		return ([[当 你 在 隐 身 状 态 下 行 动 时（ 如 攻 击， 使 用 物 品 … …），你 有 一 定 概 率 不 会 打 破 潜 行 状 态 。
		成 功 率 取 决 于 %0.2f 倍 潜 行 强 度（ 现 有  %d 点 ）、 所 有 敌 人 的 侦 测 潜 行 强 度、敌 人 数 目 以 及 敌 人 和 你 的 距 离（ 每 有 1 码 距 离 ， 对 方 侦 测 潜 行 强 度 减 少 10%% ）。
		当 你 不 在 敌 人 的 视 野 内 时， 基 础 成 功 率 为 100%% 。
		受 幸 运 值， 成 功 率 有 额 外 加 成 。]]):
		format(t.stealthMult(self, t), t.getChance(self, t, true))
	end


