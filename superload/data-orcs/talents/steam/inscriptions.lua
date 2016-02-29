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
	display_name = "植入物: 蒸汽制造机",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[蒸 汽 制 造 机 每 回 合 制 造 %0.1f 点 蒸 汽 。
		能 直 接 使 用 ，立 即 制 造 %d 蒸 汽。]]):format(data.power + data.inc_stat, (data.power + data.inc_stat) * 5)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[蒸汽 %0.1f]]):format(data.power + data.inc_stat)
	end,
}

registerInscriptionTranslation{
	name = "Implant: Medical Injector",
	display_name = "植入物: 药物注射器",
	info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[该 药 物 注 射 器 注 射 药 物 效 率 为 %d%%，冷 却 时 间 修 正 为 %d%%。]])
		:format(data.power + data.inc_stat, data.cooldown_mod)
	end,
	short_info = function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[效率 %d%% / 冷却 %d%%]]):format(data.power + data.inc_stat, data.cooldown_mod)
	end,
}
return _M