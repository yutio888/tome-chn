local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ARCANE_EYE",
	name = "奥术之眼",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		local duration = t.getDuration(self, t)
		return ([[召 唤 1 个 奥 术 之 眼 放 置 于 指 定 地 点， 持 续 %d 回 合。 
		 此 眼 睛 不 会 被 其 他 生 物 看 见 或 攻 击， 它 提 供 魔 法 视 觉， 可 看 到 它 周 围 %d 码 范 围 的 怪 物。 
		 它 不 需 要 灯 光 去 提 供 能 量， 且 它 的 视 线 无 法 穿 墙。 
		 召 唤 奥 术 之 眼 不 消 耗 回 合。 
		 同 时 只 能 存 在 1 个 奥 术 之 眼。 
		 在 等 级 4 时， 可 以 在 怪 物 身 上 放 置 奥 术 之 眼， 持 续 时 间 直 到 技 能 结 束 或 怪 物 死 亡。 
		 在 等 级 5 时， 它 可 以 在 怪 物 身 上 放 置 一 个 魔 法 标 记 并 无 视 隐 形 和 潜 行 效 果。]]):
		format(duration, radius)
	end,
}

registerTalentTranslation{
	id = "T_KEEN_SENSES",
	name = "敏锐直觉",
	info = function(self, t)
		local seeinvisible = t.getSeeInvisible(self, t)
		local seestealth = t.getSeeStealth(self, t)
		local criticalchance = t.getCriticalChance(self, t)
		return ([[你 集 中 精 神， 通 过 直 觉 获 取 未 来 的 信 息。 
		 增 加 侦 测 隐 形 等 级 +%d
		 增 加 侦 测 潜 行 等 级 +%d
		 增 加 法 术 暴 击 几 率 +%d%%
		 受 法 术 强 度 影 响， 此 效 果 有 额 外 加 成。]]):
		format(seeinvisible, seestealth, criticalchance)
	end,
}

registerTalentTranslation{
	id = "T_VISION",
	name = "探测",
	info = function(self, t)
		local radius = t.getRadius(self, t)
		return ([[通 过 意 念 探 测 周 围 地 形， 有 效 范 围： %d  码。]]):
		format(radius)
	end,
}

registerTalentTranslation{
	id = "T_PREMONITION",
	name = "预感",
	info = function(self, t)
		local resist = t.getResist(self, t)
		return ([[你 的 眼 前 会 闪 烁 未 来 的 景 象， 让 你 能 够 预 知 对 你 的 攻 击。 
		 如 果 攻 击 是 元 素 类 或 魔 法 类 的， 那 么 你 会 创 造 一 个 临 时 性 的 护 盾 来 减 少 %d%% 所 有 此 类 攻 击 伤 害， 持 续 5 回 合。 
		 此 效 果 每 隔 5 回 合 只 能 触 发 一 次， 且 在 承 受 伤 害 前 被 激 活。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):format(resist)
	end,
}


return _M
