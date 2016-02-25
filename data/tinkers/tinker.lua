function tinkers_list_for_craft_chn(self, t)
	local l = {}
	l[#l+1] = "你 需 要 该 技 能 来 制 造 下 列 插 件 （你 仍 需 要 相 应 的 配 方 ）："
	for tid, tinker in pairs(game.party.__tinkers_ings) do if tinker.random_schematic and not tinker.unique and tinker.talents and tinker.talents[t.id] then
		local known = ""
		if game.party:knowTinker(tinker.id) then known = " #LIGHT_BLUE#(known)#LAST#" end
		l[#l+1] = "#{italic}#* "..tinker.name..known.."#{normal}#"
	end end
	l[#l+1] = "#{italic}#* ...可能能发现更多...#{normal}#"	
	return table.concat(l, "\n")
end

tinkerCHN = {}
tinkerCHN["Healing Salve"] = {
	name = "治疗药剂",
	desc = "强力的治疗药剂，需要药剂注射器来使用。",
	}