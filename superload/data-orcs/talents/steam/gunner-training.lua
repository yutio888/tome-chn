local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_STEAMGUN_MASTERY",
	name = "蒸汽枪掌握",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local reloads = t.ammo_mastery_reload(self, t)
		return ([[当 你 使 用 蒸 汽 枪 时 ， 增 加 物 理 强 度 %d 和 武 器 伤 害  %d%% 。
		你 的 装 填 弹 药 速 率 增 加 %d 。]]):format(damage, inc * 100, reloads)
	end,}

registerTalentTranslation{
	id = "T_DOUBLE_SHOTS",
	name = "双重射击",
	info = function(self, t)
		return ([[你 快 速 地 射 击 两 次 ， 每 次 射 击 造 成 %d%% 伤 害 ， 并 震 慑 目 标 %d 回 合 。
		震 慑 成 功 率 受 蒸 汽 强 度 加 成。]]):format(100 * t.getMultiple(self, t), t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_UNCANNY_RELOAD",
	name = "神秘装填",
	info = function(self, t)
		return ([[你 集 中 精 力 于 蒸 汽 枪 弹 药 %d 回 合 。
		效 果 持 续 期 间 不 消 耗 弹 药 。]])
		:format(t.getDur(self, t))
	end,}

registerTalentTranslation{
	id = "T_STATIC_SHOT",
	name = "静电射击",
	info = function(self, t)
		return ([[你 射 出 一 发 特 制 电 击 子 弹。
		子 弹 击 中 目 标 时 ， 将 变 形 为 闪 电 榴 弹 ， 电 击 %d 范 围 内 所 有 目 标 ， 造 成 %d%% 电 击 武 器 伤 害 。
		被 电 击 的 目 标 失 去 至 多 %d 项 非 魔 法 效 果 （ 仅 第 一 发 有 效 ） 。
		该 技 能 不 消 耗 弹 药 。]])
		:format(self:getTalentRadius(t), 100 * t.getMultiple(self, t), t.getRemoveCount(self, t))
	end,}
return _M