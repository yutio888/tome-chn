local _M = loadPrevious(...)
local function combatTalentPhysicalMindDamage(self, t, b, s)
	return math.max(self:combatTalentMindDamage(t, b, s), self:combatTalentPhysicalDamage(t, b, s))
end
registerTalentTranslation{
	id = "T_RESOLVE",
	name = "分解",
	info = function(self, t)
		local resist = t.getResist(self, t)
		local regen = t.getRegen(self, t)
		return ([[你 选 择 了 站 在 魔 法 的 对 立 面。 那 些 未 能 杀 死 你 的 磨 难 将 使 你 更 加 强 大。 
		 每 次 你 受 到 一 种 非 物 理、 非 精 神 攻 击 时， 你 能 增 加 %d%% 对 该 类 型 伤 害 的 抵 抗， 持 续 7 回 合。 
		 如 果 没 有 激 活 反 魔 法 护 盾， 你 同 时 还 可 以 吸 收 部 分 能 量， 每 次 吸 收 的 能 量 会 降 低 失 衡 值 并 增 加 %0.2f 体 力 值。  
		 技 能 等 级 五 以 后 ，即 使 反 魔 法 护 盾 开 启 ， 也 能 生 效。
		 受 精 神 或 物 理 强 度 较 高 者 影 响， 效 果 有 额 外 加 成。]]):
		format(	resist, regen )
	end,
}

registerTalentTranslation{
	id = "T_AURA_OF_SILENCE",
	name = "沉默光环",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[发 出 一 次 音 波 冲 击， 沉 默 你 自 己 和 周 围 目 标 %d 回 合， 有 效 范 围 %d 码。 
		 每 沉 默 一 个 目 标 ， 你 回 复 %d 失 衡 值 ， 至 多 5 倍。
		 受 精 神 或 物 理 强 度 较 高 者 影 响， 沉 默 几 率 有 额 外 加 成。]]):
		format(t.getduration(self,t), rad, t.getEquiRegen(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ANTIMAGIC_SHIELD",
	name = "反魔法护盾",
	info = function(self, t)
		return ([[给 你 增 加 一 个 护 盾， 每 次 被 攻 击 吸 收 最 多 %d 点 非 物 理、 非 精 神 元 素 伤 害。  
		 每 吸 收 30 点 伤 害 都 会 增 加 1 点 失 衡 值， 并 进 行 一 次 鉴 定， 若 鉴 定 失 败， 则 护 盾 会 破 碎 且 技 能 会 进 入 冷 却 状 态。 
		 用 魔 法 攻 击 你 的 生 物 将 受 到 %0.2f 法 力 燃 烧 伤 害 ，每 回 合 至 多 触 发 10 次 ， 每 次 触 发 减 少 伤 害 25%% 。
		 受 精 神 或 物 理 强 度 较 高 者 影 响， 护 盾 的 最 大 伤 害 吸 收 值 有 额 外 加 成。]]):
		format(t.getMax(self, t), t.getBurn(self, t))
	end,
}

registerTalentTranslation{
	id = "T_MANA_CLASH",
	name = "奥术对撞",
	info = function(self, t)
		local base = combatTalentPhysicalMindDamage(self, t, 20, 460)
		local mana = base
		local vim = base / 2
		local positive = base / 4
		local negative = base / 4

		return ([[从 目 标 身 上 吸 收 %d 点 法 力， %d 点 活 力， %d 点 正 负 能 量， 并 触 发 一 次 链 式 反 应， 引 发 一 次 奥 术 对 撞。 
		 奥 术 对 撞 造 成 相 当 于 100%% 吸 收 的 法 力 值 或 200%% 吸 收 的 活 力 值 或 400%% 吸 收 的 正 负 能 量 的 伤 害， 按 最 高 值 计 算（称 为 法 力 燃 烧 ）。 
		 此 外， %d 回合内，你 每 次 攻 击 都 造 成 额 外 15%% 法 力 燃 烧 伤 害。
		 受 精 神 或 物 理 强 度 较 高 者 影 响， 效 果 有 额 外 加 成。]]):
		format(mana, vim, positive, t.getDur(self, t))
	end,
}


return _M
