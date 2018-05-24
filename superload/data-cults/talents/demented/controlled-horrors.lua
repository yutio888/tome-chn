local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DECAYED_DEVOURERS",
	name = "腐败吞噬者",
	info = function(self, t)
		return ([[你 利 用 和 恐 魔 的 联 系 召 唤 三 个 持 续 %d  轮 的 腐 败 吞 噬 者 。
		 腐 败 吞 噬 者 不 能 移 动 ，能 攻 击 周 围 所 有 敌 对 生 物 。它 们 拥 有 浴 血 奋 战 、咬 牙 切 齿 和 狂 乱 撕 咬 技 能 。
		 它 们 的 所 有 主 属 性 将 设 为  %d (基 于 你 的 魔 法 属 性 )，  生 命 回 复 速 度 增 加  %d  ，所 有 技 能 等 级 设 为  %d  。  许 多 其 他 属 性 与 技 能 等 级 相 关 。
		 它 们 将 继 承 你 的 伤 害 加 成 、伤 害 抗 性 穿 透 、暴 击 几 率 和 暴 击 伤 害 系 数 。]]):
		format(t.getDur(self, t), t.getStats(self, t), t.getLifeRating(self, t), math.floor(self:getTalentLevel(t)))
	end,
}

registerTalentTranslation{
	id = "T_DECAYED_BLADE_HORROR",
	name = "腐败浮肿恐魔",
	info = function(self, t)
		return ([[你 利 用 和 恐 魔 的 联 系 召 唤 一 个 持 续 %d 回 合 的 腐 败 浮 肿 恐 魔。
		腐 败 的 恐 魔 不 能 移 动 ，能 攻 击 范 围 内 的 所 有 敌 对 生 物 。 它 拥 有 精 神 干 扰 和 精 神 光 束 技 能 。
		它 们 的 所 有 主 属 性 将 设 为  %d (基 于 你 的 魔 法 属 性 )，  生 命 回 复 速 度 增 加  %d  ，所 有 技 能 等 级 设 为  %d  。  许 多 其 他 属 性 与 技 能 等 级 相 关 。
		 它 们 将 继 承 你 的 伤 害 加 成 、伤 害 抗 性 穿 透 、暴 击 几 率 和 暴 击 伤 害 系 数 。、
		]]):
		format(t.getDur(self, t), t.getStats(self, t), t.getLifeRating(self, t), math.floor(self:getTalentLevel(t)))
	end,
}

-- Check for permanently changing target and possible general overpoweredness
registerTalentTranslation{
	id = "T_HORRIFIC_DISPLAY",
	name = "恐魔具现化",
	info = function(self, t)
		return ([[你 强 行 让 一 个 生 物 变 化 为 恐 魔。
		如 果 目 标 生 物 未 能 通 过 魔 法 豁 免， %d 回 合 内 它 的 相 貌 将 转 变 为 恐 魔， 令 周 围 其 他 生 物 与 之 敌 对。
		目 标 生 物 周 围 的 敌 人 将 重 新 考 虑 其 攻 击目 标。
		该 法 术 对 恐 魔 无 效 。]])
		:format(t.getDur(self, t))
	end,
}

registerTalentTranslation{
	name = "阿玛克塞尔的呼唤", 
	id = "T_DEMENTED_CALL_AMAKTHEL",
	info = function(self, t)
		return ([[ 你 将 你 的 恐 魔 和 已 死 之 神 阿 玛 克 塞 尔 同 化 ， 增 加 恐 魔 %d%% 伤 害。
		技 能 等 级 3 后 ， 你 的 腐 败 吞 噬 者 法 术 将 额 外 召 唤 四 名 吞 噬 者 在 随 机 敌 人 周 围， 你 的 浮 肿 恐 魔 将 学 会 极 度 痛 苦 。 
		技 能 等 级 5 后 ， 你 的 恐 魔 具 现 化 的 目标 将 获 得 “ 每 回 合 将 周 围 敌 人 朝 你 身 边 拉 1 格” 的 法 术。
伤 害 加 成 随 法 术 强 度 而 增 加。]]):
		format(t.getDam(self, t))
	end,
}
return _M
