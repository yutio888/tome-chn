t_talent_name["T_BURNING_SACRIFICE"] = "燃烧献祭"
talentInfoCHN["T_BURNING_SACRIFICE"] = function(self, t)
	local mult = t.getMult(self, t) * 100
	local dam = t.getDam(self, t) * 100
	return ([[每 次 你 击 杀 一 个 燃 烧 的 敌 对 生 物 时 ，会 立 刻 对 一 个 随 机 相 邻 敌 对 生 物 进 行 一 次 攻 击， 造 成 %d%% 武 器 伤 害。
	另 外 ， 焚 尽 强 击 必 定 被 此 效果 触 发 （ 或 者 下 一 次 攻 击 ） ，对 所 有 击 中 的 敌 对 生 物 造 成 %d%% 倍 伤 害。
	此 效 果 每 回 合 只 能 触 发 一 次。]]):format(dam, mult)
end

t_talent_name["T_DEVOURING_FLAMES"] = "吞噬之焰"
talentInfoCHN["T_DEVOURING_FLAMES"] = function(self, t)
	return ([[恶 魔 之 炎 抚 育 你 成 长 。 你 对 范 围 5 内 燃 烧 的 敌 对 生 物 施 加 诅 咒 。 
	范 围 内 每 有 一 个 燃 烧 的 敌 对 生 物 ，每 回 合 你 获 得 %d 点 生 命 值 和 %d 点 活 力。]]):format(t.getHeal(self, t), t.getVim(self, t))
end

t_talent_name["T_INFERNO_NEXUS"] = "狱火之核"
talentInfoCHN["T_INFERNO_NEXUS"] = function(self, t)
	return ([[火 焰 在 你 四 周 怒 吼 激 荡 。 每 回 合 对 10 码 内 所 有 燃 烧 敌 对 生 物 造 成 %0.2f点 %d 码 范 围 的 AOE 伤 害 。
	无 论 敌 对 生 物 周  围 有 多 少 个 燃 烧 敌 对 生 物 ， 每 个 敌 对 生 物 只 会 被 伤 害 一 次。 ]]):	format( t.getDam(self, t), t.getRange(self, t))
end
	
t_talent_name["T_BLAZING_REBIRTH"] = "烈焰重生"
talentInfoCHN["T_BLAZING_REBIRTH"] = function(self, t)
	return ([[生 命 值 恢 复 为 满 值 ， 但 治 疗 值 转 化 为 持 续 %d 回 合 的 伤 害 。 
	伤 害 会 平 均 分 配 给 你 自 己 和 %d 码 范 围 内 的 燃 烧 敌 对 生 物。
	你 受 到 的 伤 害 无 法 减 免 ， 敌 对 生 物 受 到 火 焰 伤 害。]]):format(t.getDur(self, t), t.getRange(self, t))
end
