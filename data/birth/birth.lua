birthCHN = {}
birthCHN["race"] = {}
birthCHN["subrace"] = {}
birthCHN["class"] = {}
birthCHN["subclass"] = {}
birthCHN["world"] = {}

function registerBirthDescriptorTranslation(t)
	birthCHN[t.name] = t
	if t.type then birthCHN[t.type][t.name] = t end
end


dofile("data-chn123/birth/classes/adventurer.lua")
dofile("data-chn123/birth/classes/afflicted.lua")
dofile("data-chn123/birth/classes/celestial.lua")
dofile("data-chn123/birth/classes/chronomancer.lua")
dofile("data-chn123/birth/classes/corrupted.lua")
dofile("data-chn123/birth/classes/mage.lua")
dofile("data-chn123/birth/classes/none.lua")
dofile("data-chn123/birth/classes/psionic.lua")
dofile("data-chn123/birth/classes/rogue.lua")
dofile("data-chn123/birth/classes/tutorial.lua")
dofile("data-chn123/birth/classes/warrior.lua")
dofile("data-chn123/birth/classes/wilder.lua")

dofile("data-chn123/birth/races/construct.lua")
dofile("data-chn123/birth/races/dwarf.lua")
dofile("data-chn123/birth/races/elf.lua")
dofile("data-chn123/birth/races/giant.lua")
dofile("data-chn123/birth/races/halfling.lua")
dofile("data-chn123/birth/races/human.lua")
dofile("data-chn123/birth/races/tutorial.lua")
dofile("data-chn123/birth/races/undead.lua")
dofile("data-chn123/birth/races/yeek.lua")

dofile("data-chn123/birth/dlc.lua")
