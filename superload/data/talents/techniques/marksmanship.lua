local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MASTER_MARKSMAN",
	name = "射击精通",
	info = function (self,t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		local reload = t.getReload(self,t)
		local chance = t.getChance(self,t)
		return ([[使 用 弓 和 投 石 索 时 增 加 %d 物 理 强 度 、%d%% 武 器 伤 害 和 %d 填 弹 速 度。
		射 击 技 能 有 %d%% 几 率 标 记 目 标。
		标 记 持 续 5 回 合，令 你 能 感 知 到 目 标 ，同 时 让 他 们 面 对 爆 头 、 齐 射 和 精 巧 射 击 更 脆 弱 。]]):
format(damage, inc * 100, reload, chance)
	end,
}
registerTalentTranslation{
	id = "T_FIRST_BLOOD",
	name = "第一滴血",
	info = function (self,t)
		local bleed = t.getBleed(self,t)*100
		local sta = t.getStamina(self,t)
		return ([[你 趁 敌 人 尚 未 防 备 （90%% 血 量 以 上 ）施 展 攻 击，射 击、稳 固 射 击 和 爆 头 使 敌 人 流 血 5 回 合 造 成 额 外 %d%% 伤 害， 标 记 概 率 增 加 50%%。
此 外 ， 你 的 射 击、稳 固 射 击 和 爆 头 回 复 %0.1f 体 力。]])
		:format(bleed, sta)
	end,
}
registerTalentTranslation{
	id = "T_FLARE",
	name = "闪光弹",
	info = function (self,t)
		local blind = t.getBlindDuration(self,t)
		local dur = t.getDuration(self,t)
		local def = t.getDefensePenalty(self,t)
		return ([[发 射 闪 光 弹，致 盲 敌 人 %d 回 合, 标 记 他 们 2 回 合 并 照 亮 2 格 范 围 %d 回 合。 范 围 内 的 敌 人 降 低 %d 闪 避 和 潜 行 强 度，不 能 从 隐 匿 技 能 得 到 任 何 加 成。
		状 态 效 果 几 率 受 命 中 加 成 ，闪 避 削 减 受 敏 捷 加 成 。]])
		:format(blind, dur, def)
	end,
}
registerTalentTranslation{
	id = "T_TRUESHOT",
	name = "专注射击",
	info = function (self,t)
		local dur = t.getDuration(self,t)
		local speed = t.getSpeed(self,t)*100
		return ([[进 入 专 注 状 态 %d 回 合 ，远 程 攻 击 速 度 增 加 %d%%,射 击 不 消 耗 弹 药 ，标 记 概 率 翻 倍 。]]):
		format(dur, speed)
	end,
}

return _M