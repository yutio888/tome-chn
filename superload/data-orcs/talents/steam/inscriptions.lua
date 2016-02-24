local _M = loadPrevious(...)
registerInscriptionTranslation = function(t)
	for i = 1, 6 do
		local tt = table.clone(t)
		tt.id = "T_"..t.name:upper():gsub("[ ]", "_").."_"..i
		tt.name = tt.display_name or tt.name
		tt.extra_data = {["old_info"] = tt.info}
		tt.info = function(self, t)
			local ret = t.extra_data.old_info(self, t)
			local data = self:getInscriptionData(t.short_name)
			if data.use_stat and data.use_stat_mod then
				ret = ret..("\n受 你 的 %s 影 响， 此 效 果 按 比 例 加 成。 "):format(s_stat_name[self.stats_def[data.use_stat].name] or self.stats_def[data.use_stat].name)
			end
			return ret
		end
		registerTalentTranslation(tt)
	end
end
function change_infusion_eff(str)
	str = str:gsub("mental"," 精 神 "):gsub("magical"," 魔 法 "):gsub("physical"," 物 理 ")
	return str
end
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
