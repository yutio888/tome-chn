local _M = loadPrevious(...)


registerTalentTranslation{
	id = "T_SUBCUTANEOUS_METALLISATION",
	name = "金属内皮",
	info = function(self, t)
		return ([[当你的生命值降到总生命的 50%% 以下时，一个自动程序将会把你的一部分内层皮肤（或别的什么器官）传化为致密的金属内层 6 回合。
		在效果持续期间，你受到的所有伤害都将被减少等于你体质 100%% 的数值。
		该效果有 12 回合冷却时间。]])
		:format()
	end,
}
return _M