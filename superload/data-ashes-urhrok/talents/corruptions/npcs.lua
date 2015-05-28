local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_DEMON_SOUL_EATER",
	name = "灵魂吞噬者",
	info = function(self, t)
		return ([[任何附近的友方非召唤生物将与你的意志链接。
		每次与你意志链接的生物死亡时，将会以恶魔外壳的形式复活。
		恶魔外壳具有如下性质：
		- 缓慢的移动速度
		- 更多生命值
		- 新的恶魔技能]]):
		format()
	end,
}

return _M
