function tinkers_list_for_craft_chn(self, t)
	local l = {}
	l[#l+1] = "你需要该技能来制造下列插件（你仍需要相应的配方）："
	for tid, tinker in pairs(game.party.__tinkers_ings) do if tinker.random_schematic and not tinker.unique and tinker.talents and tinker.talents[t.id] then
		local known = ""
		if game.party:knowTinker(tinker.id) then known = " #LIGHT_BLUE#(已学会)#LAST#" end
		l[#l+1] = "#{italic}#* "..tinker.name..known.."#{normal}#"
	end end
	l[#l+1] = "#{italic}#* ...可能能发现更多...#{normal}#"	
	return table.concat(l, "\n")
end

tinkerCHN = {}
function tinkerCHN:getname(name)
	if tinkerCHN[name] then return tinkerCHN[name].name
	else return name
	end
end
dofile("data-chn123/tinkers/therapeutics.lua")
dofile("data-chn123/tinkers/smith.lua")
dofile("data-chn123/tinkers/mechanical.lua")
dofile("data-chn123/tinkers/explosive.lua")
dofile("data-chn123/tinkers/electricity.lua")
dofile("data-chn123/tinkers/chemistry.lua")

for name, value in pairs(tinkerCHN) do
	tinkerCHN[name:lower()] = value
	end