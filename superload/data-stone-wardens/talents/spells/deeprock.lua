local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DEEPROCK_FORM",
	name = "深岩形态",
	info = function(self, t)
		local xs = ""
		local xsi = ""
		if self:knowTalent(self.T_VOLCANIC_ROCK) then
			xs = xs..(", 增 加 %0.1f%% 奥 术 伤 害 和 %0.1f%% 奥 术 抗 性 穿 透"):
			format(self:callTalent(self.T_VOLCANIC_ROCK, "getDam"), self:callTalent(self.T_VOLCANIC_ROCK, "getPen"))
		end
		if self:knowTalent(self.T_BOULDER_ROCK) then
			xs = (", 增 加 %0.1f%% 自 然 伤 害 和 %0.1f%% 自 然 抗 性 穿 透"):
			format(self:callTalent(self.T_BOULDER_ROCK, "getDam"), self:callTalent(self.T_BOULDER_ROCK, "getPen"))..xs
		end
		if self:knowTalent(self.T_MOUNTAINHEWN) then
			xsi = (" 和 %d%% 流 血 、 毒 素 、 疾 病 和 震 慑 免 疫"):
			format(self:callTalent(self.T_MOUNTAINHEWN, "getImmune")*100)
		end
		return ([[你 呼 唤 世 界 深 层 的 核 心 之 力 ， 用 来 改 造 自 己 的 身 体。
		%d 回 合 内 ， 你 将 变 成 深 岩 元 素 形 态 ， 增 加 2 点 体 型 %s 。
		同 时 ， 你 将 增 加 %0.1f%% 物 理 伤 害 和 %0.1f%% 物 理 抗 性 穿 透 %s ， 并 获 得 %d 点 护 甲。 %s
		效 果 受 法 术 强 度 加 成。]])
		:format(t.getTime(self, t), xsi, t.getDam(self, t),t.getPen(self, t), xs, t.getArmor(self, t), self:getTalentLevel(self.T_MOUNTAINHEWN) >=5 and "\n另 外，你 将 用 物 理 抗 性 取 代 其 他 伤 害 抗 性。" or "")
	end,
}

registerTalentTranslation{
	id = "T_VOLCANIC_ROCK",
	name = "火山熔岩",
	info = function(self, t)
		local tv = self:getTalentFromId(self.T_VOLCANO)
		return ([[当 你 进 入 深 岩 元 素 形 态 时，增 加 %0.1f%% 奥 术 伤 害 和 %0.1f%% 奥 术 抗 性 穿 透，同 时 获 得 激 发 火 山 的 能 力:
		%s]]):
		format(t.getDam(self, t),t.getPen(self, t), self:getTalentFullDescription(tv, self:getTalentLevelRaw(t) * 2):toString())
	end,
}

registerTalentTranslation{
	id = "T_BOULDER_ROCK",
	name = "岩石投掷",
	info = function(self, t)
		local tv = self:getTalentFromId(self.T_THROW_BOULDER)
		return ([[当 你 进 入 深 岩 元 素 形 态 时，增 加 %0.1f%% 自 然 伤 害 和 %0.1f%% 自 然 抗 性 穿 透，同 时 获 得 投 掷 巨 石 的 能 力:
		%s]]):
		format(t.getDam(self, t),t.getPen(self, t), self:getTalentFullDescription(tv, self:getTalentLevelRaw(t) * 2):toString())
	end,
}

registerTalentTranslation{
	id = "T_MOUNTAINHEWN",
	name = "山崩地裂",
	info = function(self, t)
		return ([[当 你 进 入 深 岩 元 素 形 态 时，你 获 得 %d%% 流 血 、 毒 素 、 疾 病 和 震 慑 免 疫。
		技 能 等 级 5 或 以 上 时 ， 在 深 岩 元 素 形 态 下 ， 你 将 用 物 理 抗 性 取 代 其 他 伤 害 抗 性。]]):
		format(t.getImmune(self, t)*100)
	end,
}


return _M
