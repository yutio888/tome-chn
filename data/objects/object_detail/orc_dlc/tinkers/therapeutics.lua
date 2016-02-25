local medical = {"simple", "potent", "powerful", "great", "amazing"}
local medicalchn = {"简易的","有效的","强效的","极好的","惊人的"}

for i = 1, 5 do
objects:addObjects({
	subtype = "salve",
	enName = medical[i].." healing salve",
	chName = medicalchn[i].."治疗药剂",
	chDesc = "药剂。",
})
end

