

local answers = {}

player:inventoryApplyAll(function(inven, item, o) if o.vinyl_lore then
	table.insert(answers, {"[insert "..o:getName{do_color=1}.."]", cond=function() return not game.party:knownLore(o.vinyl_lore) end, action=function() game.party:learnLore(o.vinyl_lore) end, jump="welcome"})
end end)

table.insert(answers, {"[leave]"})

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*This machine seems to have a slot for some kind of disks.*#WHITE#]],
	answers = answers
}

return "welcome"
