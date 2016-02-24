local _M = loadPrevious(...)

registerInscriptionTranslation{
	name = "Implant: Steam Generator",
	display_name = "Implant: Steam Generator",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Steam generator that permanently creates %d steam per turn.
		Can be activated for an instant burst of %d steam.]]):format(data.power + data.inc_stat, (data.power + data.inc_stat) * 5)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[steam %d]]):format(data.power + data.inc_stat)
	end,
}

registerInscriptionTranslation{
	name = "Implant: Medical Injector",
	display_name = "Implant: Medical Injector",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[Medical injector allows using therapeutics with %d%% efficiency and cooldown mod of %d%%.]])
		:format(data.power + data.inc_stat, data.cooldown_mod)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[efficiency %d%% / cooldown %d%%]]):format(data.power + data.inc_stat, data.cooldown_mod)
	end,
}
