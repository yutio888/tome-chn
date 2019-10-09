local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_UNDEAD_ID",
	name = "逝去的知识",
	info = function(self)
		return ([[你集中精神回想你生前时的知识，来辨识一些稀有物品。]])
	end,
}


return _M
