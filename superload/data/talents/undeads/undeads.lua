local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_UNDEAD_ID",
	name = "逝去的知识",
	info = function(self)
		return ([[你 集 中 精 神 回 想 你 生 前 时 的 知 识， 来 辨 识 一 些 稀 有 物 品。]])
	end,
}


return _M
