t_talent_name["T_ELDRITCH_BLOW"] = "奥术盾击"
t_talent_name["T_ELDRITCH_INFUSION"] = "奥术充能"
t_talent_name["T_ELDRITCH_FURY"] = "奥术连击"
t_talent_name["T_ELDRITCH_SLAM"] = "奥术猛击"

talentInfoCHN["T_ELDRITCH_BLOW"] = function(self, t)
		return ([[调 用 奥 术 能 量 ， 激 发 近 战 攻 击 ， 使 用 武 器 和 盾 牌 攻 击 目 标 造 成 %d%% 奥 术 武 器 伤 害。
		只 要 有 一 次 命 中 ， 将 震 慑 目 标 %d 回 合 。
		由 于 这 次 攻 击 视 为 魔 法 攻 击 ， 震 慑 成 功 率 由 己 方 物 理 强 度 和 目 标 法 术 豁 免 （ 非 物 理 豁 免 ） 决 定。
		伤 害 受 法 术 强 度 加 成。]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.6, (100 + self:combatTalentSpellDamage(t, 50, 300)) / 100), t.getDuration(self, t))
	end
talentInfoCHN["T_ELDRITCH_INFUSION"] = function(self, t)
		local dam = t.getDamage(self, t)
		return ([[用 奥 术 能 量 给 盾 牌 冲 能，每 次 近 战 攻 击 附 加 %0.1f 奥 术 伤 害， 同 时 每 次 受 到 近 战 攻 击 时 反 击%0.1f 点 奥 术 伤 害。
		伤 害 受 法 术 强 度 加  成。]]):
		format(dam, dam * 0.7)
	end
talentInfoCHN["T_ELDRITCH_FURY"] = function(self, t)
		return ([[调 用 奥 术 能 量，激 发 近 战 攻 击，用 盾 牌 攻 击 目 标 三 次 ， 造 成 %d%% 自 然 武 器 伤 害 。
		只 要 有 一 次 命 中 ， 将 眩 晕 目 标 %d 回 合 。
		由 于 这 次 攻 击 视 为 魔 法 攻 击 ， 震 慑 成 功 率 由 己 方 物 理 强 度 和 目 标 法 术 豁 免 （ 非 物 理 豁 免 ） 决 定。	]])
		:format(100 * self:combatTalentWeaponDamage(t, 0.6, 1.6), t.getDuration(self, t))
	end
talentInfoCHN["T_ELDRITCH_SLAM"] = function(self, t)
		return ([[用 盾 牌 猛 击 地 面 ， 制 造 冲 击 波 。
		对 半 径 %d 内 的 生 物 造 成 %d%% 奥 术 武 器 伤 害 。]])
		:format(self:getTalentRadius(t),100 * self:combatTalentWeaponDamage(t, 1.3, 2.6))
	end
