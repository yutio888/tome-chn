local PartyTinker = require "mod.class.interface.PartyTinker"
for tid, t in pairs(PartyTinker.__tinkers_ings) do if t.random_schematic then
objects:addObjects({
	subtype = "schematic",
	egos = "helm",
	enName = "schematic: "..t.name,
	chName = "设计图".. getTinkerCHN and getTinkerCHN(t.name) or t.name,
	chDesc = "设计图被工匠用于制作新的发明。",
})
end end
