
local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_RAKSHOR_CUNNING",
	name = "拉克·肖的狡诈", 
	require_special_desc = "已经解锁了骷髅和尸鬼且不是亡灵。",
	info = function(self, t)
		return ([[准备一个应对死亡的应急方案。
	如果你死了，你可以选择从死亡归来，代价则是你将随机成为一个骷髅或者尸鬼。
	当你选择以这种方法归来时，你会失去你的种族技能树并收回其中一半的点数，然后获得骷髅或者尸鬼的种族技能树。 
	作为一个亡灵，你无法使用纹身。你会在转化时失去所有的纹身。]])
		:format()
	end,
}
return _M