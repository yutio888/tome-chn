local PartyTinker = require "mod.class.interface.PartyTinker"
for tid, t in pairs(PartyTinker.__tinkers_ings) do 
objects:addObjects({
	subtype = "schematic",
	enName = "schematic: "..t.enName,
	chName = "配方:".. t.name,
	chDesc = "配方被工匠用于制作新的发明。",
})
end
