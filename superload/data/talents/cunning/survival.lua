local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_HEIGHTENED_SENSES",
	name = "强化感知",
	info = function(self, t)
		return ([[你 注 意 到 他 人 注 意 不 到 的 细 节， 甚 至 能 在 阴 影 区 域 “ 看 到 ” 怪 物， %d 码 半 径 范 围。 
		 注 意 此 能 力 不 属 于 心 灵 感 应， 仍 然 受 到 视 野 的 限 制。 
		 同 时 你 的 细 致 观 察 也 能 使 你 发 现 周 围 的 陷 阱 (%d 侦 查 强 度 )。  
		 受 灵 巧 影 响， 陷 阱 侦 查 强 度 有 额 外 加 成。]]):
		format(t.sense(self,t),t.seePower(self,t))
	end,
}

registerTalentTranslation{
	id = "T_DEVICE_MASTERY",
	name = "装置掌握",
	info = function(self, t)
		return ([[你 灵 活 的 头 脑， 使 你 可 以 更 加 有 效 的 使 用 装 置（ 魔 杖、 图 腾 和 项 圈）， 减 少 %d%% 饰 品 的 冷 却 时 间。
		同 时 ， 你 对 装 置 的 知 识 让 你 能 够 解 除 被 发 现 的 陷 阱（+ %d 解 除 强 度， 随 灵 巧 提 升）。
		]]):
		format(t.cdReduc(self, t), t.trapDisarm(self, t))
	end,
}

registerTalentTranslation{
	id = "T_TRACK",
	name = "追踪",
	info = function (self,t)
		local rad = self:getTalentRadius(t)
		return ([[感 知 范 围 %d 内 的 敌 人 ， 持 续 %d 回 合 。
		范 围 随 灵 巧 提 升 而 提 升。]]):format(rad, t.getDuration(self, t))
	end,
}
registerTalentTranslation{
	id = "T_DANGER_SENSE",
	name = "危机感知",
	info = function (self,t)
		return ([[你 拥 有 了 更 高 级  的 自 我 保 护 感 知 力，敏 锐 的 直 觉 让 你 察 觉 到 他 人 会 忽 略 的 危 险 。
		你 感 知 陷 阱 的 能 力 提 升 了 （+%d 点 侦 察 强 度 ）。
		对 你 发 动 的 攻 击 的 暴 击 率 减 少 %0.1f%%，同 时 潜 行 单 位 因 未 被 发 现 而 对 你 造 成 的 额 外 伤 害 的 倍 率 减 小 %d%%。
		抵 抗 负 面 状 态 效 果 时， 豁 免 +%d 。
		侦 测 点 数 和 豁 免  随 灵 巧 提 升 。]]):
		format(t.trapDetect(self, t), t.critResist(self, t), t.getUnseenReduction(self, t)*100, -t.savePenalty(self, t))
	end,
}
registerTalentTranslation{
	id = "T_DISARM_TRAP",
	name = "解除陷阱",
	info = function (self,t)
		local tdm = self:getTalentFromId(self.T_DEVICE_MASTERY)
		local t_det, t_dis = self:attr("see_traps") or 0, tdm.trapDisarm(self, tdm)
		return ([[你 搜 索 周 围 地 格 的 陷 阱 （ %d 侦 察 强 度），并 尝 试 解 除 (%d 解 除 强 度 ，基 于 技 能 %s)。
		解 除 陷 阱 有 最 低 技 能 等 级 需 求，且 你 必 须 能 够 移 动 到 陷 阱 的 所 在 格 ，尽 管 你 仍 然 留 在 你 的 当 前 位 置。
		解 除 陷 阱 失 败 可 能 会 触 发 陷 阱。
		Your skill improves with your your Cunning.]]):format(t_det, t_dis, tdm.name)
	end,
}
return _M