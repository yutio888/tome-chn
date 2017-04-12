local _M = loadPrevious(...)
for i = 1, 8 do
registerTalentTranslation{
	id = "T_POSSESSION_TALENT_"..i,
	name = "所 有 物 技 能"..i,
	info = function (self,t)
			return ([[附 身 时 ，该 技 能 会 被 替 换 成 身 体 的 其 中 一 个 技 能 。
			该 技 能 的 唯 一 用 法 是 放 在 热 键 栏 上 。]]):
			format()
		end,
	}
end

local function bodies_desc(self)
	if #self.bodies_storage < 1 then return "none" end
	local b_list = ""
	for i, store in ipairs(self.bodies_storage) do
		local body = store.body
		local name = body.name
		if #name > 18 then name = string.sub(name, 1, 15).."..." end
		name = npcCHN:getName(name)
		local in_use = body._in_possession and body:getDisplayString() or " "
		local _, rankcolor = body:TextRank()
		b_list = b_list..("\n%s%s%d)%s#LAST# (#LIGHT_BLUE#等级 %d#LAST#, #LIGHT_RED#生命值:%d/%d#LAST#)"):format(in_use, rankcolor, store.uses, name, body.level, body.life, body.max_life)
	end
	return b_list
end

registerTalentTranslation{
	id = "T_DESTROY_BODY",
	name = "摧 毁 身 体",
	on_pre_use = function(self, t, silent) if #self.bodies_storage == 0 then if not silent then game.logPlayer(self, "You have no stored bodies to delete.") end return false end return true end,
	action = function(self, t)
		package.loaded['mod.dialogs.AssumeForm'] = nil
		self:talentDialog(require("mod.dialogs.AssumeForm").new(self, t, "destroy"))
		return true
	end,
	info = function(self, t)
		return ([[从 你 的 灵 能 仓 库 中 丢 弃 身 体 。
		拥 有 的 身 体 :
		%s]]):
		format(bodies_desc(self))
	end,
}
registerTalentTranslation{
	id = "T_ASSUME_FORM",
	name = "附 身",
	info = function (self,t)
		return ([[选 择 一 个 身 体 ，附 身 。
		以 这 种 方 式 使 用 的 身 体 可 能 不 会 被 任 何 方 式 治 愈 。
		你 可 以 随 时 通 过 再 次 使 用 这 个 技 能 来 选 择 退 出 身 体 ，将 其 恢 复 原 状 ，包 括 任 何 物 理 效 果 。精 神 , 魔 法 和 “ 其 他 ” 效 果 仍 然 对 你 有 效 。
		当 生 命 为 0 时 被 迫 离 开 身 体 ，冲 击 对 你 最 大 血 量 造 成 %d%% 的 损 失 并 减 少 50%% 移 动 速 度 和 60%% 伤 害 持 续 6 回 合 。
		技 能 冷 却 仅 在 恢 复 正 常 形 式 时 开 始 冷 却 。
		附 身 时 仍 会 获 得 经 验 ，但 不 会 被 应 用 ，直 到 你 离 开 身 体 。
		附 身 时 你 无 法 更 换 装 备 。
		冷 却 时 间 随 主 宰 技 能 等 级 提 高 。
		拥 有 的 身 体 :
		%s]]):
		format(self:callTalent(self.T_POSSESS, "getShock"), bodies_desc(self))
	end,
}
registerTalentTranslation{
	id = "T_POSSESS",
	name = "主 宰",
	info = function (self,t)
		local fake = {rank=2}
		local rt0, rc0 = self.TextRank(fake)
		fake.rank = 3; local rt3, rc3 = self.TextRank(fake)
		fake.rank = 3.5; local rt5, rc5 = self.TextRank(fake)
		fake.rank = 4; local rt7, rc7 = self.TextRank(fake)
		rc0 = rc0:gsub("normal","普通")
		rc3 = rc3:gsub("elite","精英")
		rc5 = rc5:gsub("unique","史诗")
		rc7 = rc7:gsub("boss","Boss")
		return ([[你 对 目 标 投 掷 一 个 持 续 %d 回 合 的 灵 能 网 。每 回 合 造 成 %0.2f 精 神 伤 害 。
		如 果 目 标 在 持 续 时 间 内 死 亡 ， 你 会 获 得 它 的 身 体 并 放 入 你 的 灵 能 仓 库 中 。
		在 任 何 时 候 ，你 可 以 使 用 附 身 技 能 暂 时 脱 离 你 的 身 体 进 入 新 的 身 体 ，继 承 其 优 势 和 弱 点 。
		灵 能 仓 库 有 位 置 时 才 能 使 用 该 技 能 。

		你 可 以 偷 取 以 下 阶 级 生 物 的 身 体 %s%s#LAST# 或 者 更 低。
		等 级 3 时 最 多 可 偷 取 %s%s#LAST#.
		等 级 5 时 最 多 可 偷 取 %s%s#LAST#.
		等 级 7 时 最 多 可 偷 取 %s%s#LAST#.

		你 可 能 只 会 偷 走 以 下 类 型 的 生 物 的 尸 体 : #LIGHT_BLUE#%s#LAST#
		当 你 尝 试 拥 有 不 同 类 型 的 生 物 时 ，你 可 以 永 久 学 习 此 类 型 ，你 还 可 以 执 行 %d 次 。]]):
		format(
			t.getDur(self, t), damDesc(self, DamageType.MIND, t.getDamage(self, t)),
			rc0, rt0, rc3, rt3, rc5, rt5, rc7, rt7,
			table.concat(table.append({"humanoid", "animal"}, table.keys(self.possess_allowed_extra_types or {})), ", "), t.allowedTypesExtraNb(self, t)
		)
	end,
}
registerTalentTranslation{
	id = "T_SELF_PERSISTENCE",
	name = "自 我 坚 持",
	info = function (self,t)
		return ([[当 你 附 身 时 ，你 还 可 以 保 留 自 己 身 体 的 属 性 %d%% 。 (闪 避, 暴 击, 强 度, 豁 免, ...)]]):
		format(100 - t.getPossessScale(self, t))
	end,
}
registerTalentTranslation{
	id = "T_IMPROVED_FORM",
	name = "身 体 改 进",
	info = function (self,t)
		return ([[当 你 附 身 时 ，你 获 得 身 体 %d%% 的 数 值 (闪 避, 暴 击, 强 度, 豁 免, ...)。
		此 外 ，从 身 体 获 得 的 技 能 等 级 最 高 为 %0.1f.]]):
		format(t.getPossessScale(self, t), t.getMaxTalentsLevel(self, t))
	end,
}
registerTalentTranslation{
	id = "T_FULL_CONTROL",
	name = "完 全 控 制",
	info = function (self,t)
		return ([[附 身 时 ，可 更 好 的 控 制 身 体 :
		- 在 等 级 1 时 ，可 额 外 获 得 一 个 技 能 位
		- 在 等 级 2 时 ，可 额 外 获 得 一 个 技 能 位
		- 在 等 级 3 时 ，可 获 得 抗 性 和 固 定 减 伤
		- 在 等 级 4 时 ，可 额 外 获 得 一 个 技 能 位
		- 在 等 级 5 时 ，可 获 得 得 所 有 速 度 （只 有 当 他 们 优 于 你 时）
		- 在 等 级 6 以 上 时 ，可 额 外 获 得 一 个 技 能 位
		]]):
		format(t.getNbTalents(self, t))
	end,
}
return _M