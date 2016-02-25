local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_VAPOROUS_STEP",
	name = "蒸汽步",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[你 集 中 精 神 来 将 一 些 你 发 动 机 中 的 蒸 汽 意 念 移 动 到 远 方 。 
		每 回 合 蒸 汽 都 会 在 那 里 累 积 ， 最 多 %d 层 。
		当 你 解 除 状 态 时 ， 你 会 释 放 累 积 的 精 神 力 和 蒸 汽 ， 瞬 间 移 动 到 该 地 点 并 制 造 一 个 半 径 4 码 的 炙 热 的 蒸 汽 爆 炸 。
		爆 炸 将 造 成 %0.2f 乘 以 每 层 33%% 的 火 焰 伤 害 并 附 加 浸 湿 状 态。
		如 果 目 标 地 点 已 经 被 占 据 或 不 在 视 线 之 内 ， 则 技 能 将 失 败 。
		伤 害 会 随 着 你 的 蒸 汽 值 增 加。]]):
		format(t.getMaxCharge(self, t), damDesc(self, DamageType.FIRE, damage))
	end,}

registerTalentTranslation{
	id = "T_INHALE_VAPOURS",
	name = "吸入蒸汽",
	info = function(self, t)
		return ([[当 你 解 除 蒸 汽 步 时 ， 如 果 意 念 移 动 成 功 了 ， 你 会 吸 入 一 些 蒸 汽 ， 回 复 %d 蒸 汽 和 %d 生 命 。
		效 果 会 乘 以 蒸 汽 步 的 层 数 乘 以 33%% 。
		治 疗 量 会 随 着 你 的 精 神 强 度 增 加 。]]):
		format(t.getSteam(self, t), t.getHeal(self, t))
	end,}

registerTalentTranslation{
	id = "T_PSIONIC_FOG",
	name = "心灵迷雾",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[你 将 你 发 动 机 里 的 蒸 汽 塑 形 为 持 续 %d 回 合 的 心 灵 迷 雾 。
		任 何 陷 入 其 中 的 敌 人 每 回 合 都 会 受 到 %0.2f 的 伤 害 ， 并 被 烧 焦 ，降 低 他 们 %d%% 火 焰 抗 性 和 %d 精 神 豁 免 。
		伤 害 会 随 着 你 的 精 神 强 度 增 加。]]):
		format(duration, damDesc(self, DamageType.MIND, damage), t.getSearing(self, t), t.getSearing(self, t))
	end,}

registerTalentTranslation{
	id = "T_UNCERTAINTY_PRINCIPLE",
	name = "测不准原理",
	info = function(self, t)
		return ([[你 能 在 心 灵 迷 雾 中 使 用 你 被 技 术 强 化 过 的 心 灵 力 量 来 掌 握 空 间 的 量 子 态 本 质 。
		当 你 将 被 击 中 时 ， 你 会 闪 现 到 一 个 临 近 的 位 置。
		这 个 效 果 有 冷 却 时 间 。]]):
		format()
	end,}
return _M