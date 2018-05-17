local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ATROPHY",
	name = "衰亡",
	info = function(self, t)
		return ([[吸 收 他 人 时 间 的 熵 能 漩 涡 围 绕 着 你 。 当 你 释 放 法 术 时 ， 半 径 10 格 内 的 随 机 目 标 将 迅 速 老 化、凋 零 ，所 有 属 性 降 低 %d ，持 续 8 回 合 ， 效  果 可 叠 加 %d 层。
			每 次 施 法 可 以 释 放 最 多 %d 层 加 速 衰 老 ， 但 同 一 目 标 一 次 最 多 增 加 2 层 效 果。]]):
		format(t.getStat(self, t), t.getMaxStacks(self, t), t.getStacks(self, t))
	end
}

registerTalentTranslation{
	id = "T_SEVERED_THREADS",
	name = "断绝",
	info = function(self, t)
		local life = t.getLife(self,t)*100
		local dur = t.getDuration(self,t)
		local power = t.getPower(self,t)
		return ([[当 对 不 足 %d%% 最 大 生 命 值 的 目 标 释 放 衰 亡 时 ，你 将 尝 试 切 断 目 标 的 生 命 线 ， 立 刻 杀 死 目 标。 在 接 下 来 的 %d 回 合 中 ， 你 将 会 享 用 目 标 残 余 的 生 命 线 ， 增 加 你 的 生 命 回 复 %0.1f 并 使 没 有 固 定 冷 却 时 间 的 技 能 冷 却 速 度  加 倍 。
		这 个 技 能 的 增 益 效 果 每 15 回 合 只 能 发 动 一 次 。]])
		:format(life, dur, power)
	end
}

registerTalentTranslation{
	id = "T_TEMPORAL_FEAST",
	name = "盛宴",
	info = function(self, t)
		local speed = t.getSpeed(self,t)*100
		local slow = t.getSlow(self,t)*100
		return ([[你 进 一 步 榨 取 他 人 的 时 间 线 。每 次 使 用 衰 亡 时， 目 标 身 上 的 每 层 衰 亡 效 果 将 使 你获 得 %0.1f%% 施 法 速 度 ， 同 时 目 标 将 失 去 %d%% 回 合。
			计 算 施 法 速 度 增 加 时 ， 会 使 用 你 周 围 最 高 层 数 的 衰 亡 效 果 。]])
		:format(speed, slow)
	end
}

registerTalentTranslation{
	id = "T_TERMINUS",
	name = "终点",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local rad = self:getTalentRadius(t)
		local turn = t.getTurn(self,t)/10
		return ([[打 破 时 空 连 续 性 ， 对 %d 格 内 所 有 敌 人 造 成 %0.2f 时 空 伤 害。 同 时 ，衰 亡 状 态 将 窃 取 目 标 的 时 间 ，每 层 造 成 额 外 %0.2f 时 空 伤 害 并 使 你 获 得 %d%% 回 合 （ 最 多 获 得 3 回 合 ）。
		伤 害 随 法 术 强 度 增 加 。]]):format(rad,damDesc(self, DamageType.TEMPORAL, damage),  damDesc(self, DamageType.TEMPORAL, damage/6), turn)
	end
}

return _M
