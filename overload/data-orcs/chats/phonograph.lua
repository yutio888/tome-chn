

local answers = {}

player:inventoryApplyAll(function(inven, item, o) if o.vinyl_lore then
	table.insert(answers, {"[插入 "..o:getName{do_color=1}.."]", cond=function() return not game.party:knownLore(o.vinyl_lore) end, action=function() game.party:learnLore(o.vinyl_lore) end, jump="welcome"})
end end)

table.insert(answers, {"[leave]"})

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*这台机器上有一个槽，似乎能将光盘放进去。*#WHITE#]],
	answers = answers
}

return "welcome"
