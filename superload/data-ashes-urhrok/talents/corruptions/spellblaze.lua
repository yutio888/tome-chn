local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RAIN_OF_FIRE",
	name = "陨星火雨",
	info = function(self, t)
		return ([[你 释 放 魔 法 大 爆 炸 的 力 量 ，持 续 消 耗 活 力 。
		 当 技 能 开 启 时 ，每 回 合 将 召 唤 2 个 陨 石 坠 落 在 你 身 边 ，在 半 径 2 的 范 围 内 造 成 %0.2f 物 理 与 %0.2f 火 焰 伤 害 。
		 这 项 法 术 在 休 息 或 跑 步 时 自 动 关 闭 。
		 效 果 受 法 术 强 度 加 成 。]])
		:format(t.getDam(self, t), t.getDam(self, t))
	end,
}


registerTalentTranslation{
	id = "T_ONLY_ASHES_LEFT",
	name = "唯余灰烬",
	info = function(self, t)
		return ([[通 过 引 发 魔 法 大 爆 炸 最 黑 暗 的 时 候 的 场 景 ，你 加 速 了 敌 人 的 死 亡 。
		 每 次 你 对 半 径 %d 内 的 生 物 造 成 伤 害 后 ，如 果 它 生 命 值 低 于 33%% ，将 会 承 受 魔 法 大 爆 炸 的 力 量 。
		 受 影 响 的 敌 人 每 回 合 将 受 到 %0.2f 暗 影 伤 害 ，直 到 死 亡 或 者 离 开 范 围 。
		 伤 害 受 法 术 强 度 加 成 。]]):
		format(self:getTalentRadius(t), t.getDam(self, t), self:getTalentRadius(t))
	end,
}


registerTalentTranslation{
	id = "T_SHATTERED_MIND",
	name = "精神破碎",
	info = function(self, t)
		return ([[当 你 格 挡 攻 击 时 ，你 能 将 魔 法 大 爆 炸 的 力 量 传 导 至 攻 击 者 的 精 神 中 ，持 续 5 回 合 。
		 受 影 响 的 生 物 每 次 使 用 技 能 时 有 %d%% 几 率 失 败 ，同 时 全 体 豁 免 下 降 %d 点 。 ]]):
		format(t.getFail(self, t), t.getSaves(self, t))
	end,
}


registerTalentTranslation{
	id = "T_TALE_OF_DESTRUCTION",
	name = "毁灭传说",
	info = function(self, t)
		return ([[你 赞 颂 恶 魔 家 乡 Mal'Rok 的 毁 灭 。
		 每 次 你 杀 死 生 物 时 ，你 将 释 放 魔 法 波 动 ，在 半 径 %d 范 围 内 的 生 物 将 承 受 %d 回 合 的 混 乱 或 目 盲 毒 素 。
		 中 毒 的 生 物 每 回 合 将 受 到 %0.2f 暗 影 伤 害 。
		 伤 害 受 法 术 强 度 加 成 。]]):
		format(self:getTalentRadius(t), t.getDur(self, t), t.getDamage(self, t))
	end,
}


return _M
