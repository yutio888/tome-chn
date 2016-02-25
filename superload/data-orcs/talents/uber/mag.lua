
local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_ARCANE_AMPLIFICATION_DRONE_EFFECT",
	name = "奥术增幅装置效果",
	info = function(self, t)
		return ([[其 受 到 的 法 术 伤 害 转 化 为 波 纹 , 对 半 径 4 内 的 所 有 目 标 造 成 等 同 于 该 伤 害 160%% 的 奥 术 伤 害 。]])
	end,}

registerTalentTranslation{
	id = "T_ARCANE_AMPLIFICATION_DRONE",
	name = "奥术增幅装置",
	require_special_desc = "当 前 或 之 前 的 角 色 在 当 前 难 度 与 模 式 下 解 锁 过 #{italic}#大 灾 变 的 故 事#{normal}# 这 个 成 就。", 
	info = function(self, t)
		return ([[你 在 目 标 地 点 放 置 一 个 持 续 3 回 合 的 奥 术 增 幅 装 置。
		每 当 你 释 放 的 法 术 对 其 造 成 伤 害 时 ， 增 幅 装 置 把 伤 害 转 化 为 波 纹 对 半 径 4 内 的 所 有 目 标 造 成 等 同 于 该 伤 害 160%% 的 奥 术 伤 害 。]])
		:format()
	end,
}
return _M