logCHN:newLog{
	log = "#GOLD#A bolt of lightning fires from #Source#'s bow, striking #Target#!",
	fct = function()
		return "#GOLD# 一道闪电从 #Source# 的弓中射出，击中了 #Target# ！"
	end,
}

logCHN:newLog{
	log = "#Source# unleashes cosmic retribution at #Target#!",
	fct = function()
		return "#Source# 朝 #Target# 释放了宇宙的愤怒！"
	end,
}

logCHN:newLog{
	log = "#Source# strikes #Target# with %s %s, sending out an arc of lightning!",
	fct = function()
		return "#Source# 用 %s %s 击中了 #Target# ，射出一道闪电！"
	end,
}

logCHN:newLog{
	log = "Anmalice focuses its mind-piercing eye on #Target#!",
	fct = function()
		return "扭曲之刃·圣灵之眼将它穿透灵魂的目光集中在了 #Target# 上！"
	end,
}

logCHN:newLog{
	log = "#Source#'s three headed flail lashes at #Target#%s!",
	fct = function(a)
		if a:find(" and ") then
			a = " 和 " .. npcCHN:getName(a:gsub(" and ", ""))
		end
		return ("#Source# 的三头连枷扫过了 #Target#%s ！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Source#'s three headed flail lashes at #Target#!",
	fct = function()
		return "#Source# 的三头连枷扫过了 #Target# ！"
	end,
}

logCHN:newLog{
	log = "A wave of icy water sprays out from #Source# towards #Target#!",
	fct = function()
		return "一束冰冷的水流从 #Source# 处喷射出来冲向 #Target# ！"
	end,
}
logCHN:newLog{
	log = "#LIGHT_RED#You see no place to land near there.",
	fct = function()
		return "#LIGHT_RED#那边你看不见着陆的空间。"
	end,
}

logCHN:newLog{
	log = "#ORCHID#Black tendrils from #Source# grab #Target#!",
	fct = function()
		return "#ORCHID#黑暗触须从#Source#处伸出，抓住了 #Target#!"
	end,
}

logCHN:newLog{
	log = "#ORCHID#%s resists the tendrils' pull!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#ORCHID#%s 抵抗了触须的抓取!"):format(a)
	end,
}
logCHN:newLog{
	log = "#ORCHID#%s empowers %s %s",
	fct = function(a,b,c)
		a = npcCHN:getName(a)
		return ("#ORCHID#%s 强化了 %s %s"):format(a,b,c)
	end,
}
logCHN:newLog{
	log = "#YELLOW_GREEN#An ironic harmony surrounds Ureslak's remains as they reunite.",
	fct = function()
		return "#YELLOW_GREEN#乌尔斯拉克的遗物重聚时，和谐力量在此流转。"
	end,
}
logCHN:newLog{
	log = "#YELLOW_GREEN#Ureslak's remains seem more unsettled.",
	fct = function()
		return "#YELLOW_GREEN#乌尔斯拉克的遗物似乎更加不安定了。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#Ice and snow form a barrier!",
	fct = "#LIGHT_BLUE# 冰和雪组成了屏障",
}

logCHN:newLog{
	log = "#LIGHT_RED#You can not do that with a tinker attached. Remove it first.",
	fct = "#LIGHT_RED#当有配件附着时，你不能这么做。先移除配件。"
}

logCHN:newLog{
	log = "%s releases an icy blast from %s %s!",
	fct = function(a,b,c) return("%s用%s %s释放一股冰冷冲击！"):format(npcCHN:getName(a),b,objects:getObjectsChnName(c)) end,
		
}

logCHN:newLog{
	log = "%s uses %s %s!",
	fct = function(a,b,c) return("%s使用了%s %s！"):format(npcCHN:getName(a),b,objects:getObjectsChnName(c)) end,
		
}
--[[to add 
./data/general/objects/boss-artifacts-far-east.lua:				game.logSeen(who, "%s's %s shakes the ground with its impact!", who.name:capitalize(), o:getName({no_add_name = true}))
./data/general/objects/boss-artifacts-far-east.lua:			game.logSeen(who, "%s slams %s %s into the ground, sending out a shockwave!", who.name:capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
./data/general/objects/boss-artifacts-maj-eyal.lua:					game.logSeen(target, "#LIGHT_BLUE#A Winter Storm forms around %s.", target.name:capitalize())
./data/general/objects/boss-artifacts-maj-eyal.lua:			game.logSeen(who, "#LIGHT_BLUE#%s brandishes %s %s, releasing a wave of Winter cold!", who.name:capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}))
./data/general/objects/boss-artifacts-maj-eyal.lua:			game.logSeen(who, "%s uses %s %s to cleanse %s mind!", who.name:capitalize(), who:his_her(), self:getName({no_add_name = true, do_color=true}), who:his_her())
./data/general/objects/boss-artifacts-maj-eyal.lua:		game.logSeen(who, "Crystals splinter off of %s's %s and animate!", who.name:capitalize(), self:getName({no_add_name = true, do_color=true}))
./data/general/objects/boss-artifacts-maj-eyal.lua:		game.logSeen(who, "%s taps %s %s, summoning a vampire thrall!", who.name:capitalize(), who:his_her(), self:getName({no_add_name = true, do_color=true}))
./data/general/objects/boss-artifacts-maj-eyal.lua:					game.logSeen(target, "%s's %s is disrupted!", target.name:capitalize(), t.name)
./data/general/objects/boss-artifacts-maj-eyal.lua:				game.logSeen(actor, "#CRIMSON#%s twitches, alerting %s that a hidden trap is nearby.", self:getName(), actor.name:capitalize())
./data/general/objects/boss-artifacts-maj-eyal.lua:				game.logSeen(who, "%s shrugs off some effects!", who.name:capitalize())
./data/general/objects/boss-artifacts-maj-eyal.lua:			game.logSeen(who, "%s's %s sends out a blast of psionic energy!", who.name:capitalize(), self:getName({no_add_name = true, do_color = true}))
./data/general/objects/egos/ammo.lua:			game.logSeen(target, "%s's %s has been #ORCHID#burned#LAST#!", target.name:capitalize(), t.name)
./data/general/objects/egos/mindstars.lua:				game.logSeen(who, "%s feeds %s %s with psychic energy from %s!", who.name:capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}), target.name:capitalize())
./data/general/objects/egos/staves.lua:			game.logSeen(who, "%s fires a bolt of %s%s#LAST# energy from %s %s!", who.name:capitalize(), damTyp.text_color, damTyp.name, who:his_her(), self:getName({no_add_name = true, do_color = true}))
./data/general/objects/egos/staves.lua:			game.logSeen(who, "%s unleashes a blastwave of %s%s#LAST# energy from %s %s!", who.name:capitalize(), damTyp.text_color, damTyp.name, who:his_her(), self:getName({no_add_name = true, do_color = true}))
./data/general/objects/egos/staves.lua:				game.logSeen(who, "%s channels mana through %s %s!", who.name:capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}))
./data/general/objects/egos/staves.lua:			game.logSeen(who, "%s channels a cone of %s%s#LAST# energy through %s %s!", who.name:capitalize(), damTyp.text_color, damTyp.name, who:his_her(), self:getName({no_add_name = true, do_color = true}))
./data/general/objects/egos/wands-powers.lua:		game.logSeen(who, "%s conjures a wall of fire from %s %s!", who.name:capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}))
./data/general/objects/special-artifacts.lua:			game.logSeen(who, "%s brandishes %s %s, turning into a corrupted losgoroth!", who.name:capitalize(), who:his_her(), self:getName({do_color = true, no_add_name =true}))
./data/general/objects/world-artifacts-far-east.lua:			game.logSeen(who, "#GOLD#As the blade touches %s's spilt blood, the blood rises, animated!", target.name:capitalize())
./data/general/objects/world-artifacts-far-east.lua:				game.logSeen(who, "#GOLD#%s draws power from the spilt blood!", who.name:capitalize())
./data/general/objects/world-artifacts-far-east.lua:			game.logSeen(who, "%s raises %s and sends out a burst of light!", who.name:capitalize(), self:getName())
./data/general/objects/world-artifacts-far-east.lua:			game.logSeen(who, "The %s fires a bolt of kinetic force!", self:getName())
./data/general/objects/world-artifacts-maj-eyal.lua:			game.logSeen(who, "%s uses %s %s, curing %s afflictions!", who.name:capitalize(), who:his_her(), self:getName({do_color=true, no_add_name = true}), who:his_her())
./data/general/objects/world-artifacts-maj-eyal.lua:			game.logSeen(who, "%s uses the %s!", who.name:capitalize(), self:getName())
./data/general/objects/world-artifacts-maj-eyal.lua:			game.logSeen(who, "%s activates %s %s!", who.name:capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}))
./data/general/objects/world-artifacts-maj-eyal.lua:		game.logSeen(game.player, "#CRIMSON#Telos's gem seems to flare and glows an unearthly colour.")
./data/general/objects/world-artifacts-maj-eyal.lua:			game.logSeen(who, "%s invokes the memory of Neira!", who.name:capitalize())
./data/general/objects/world-artifacts-maj-eyal.lua:		game.logSeen(who, "#STEEL_BLUE#You feel a swell of arcane energy.")
./data/general/objects/world-artifacts-maj-eyal.lua:			game.logSeen(who, "%s activates %s, forging a reflective barrier!", who.name:capitalize(), self:getName({no_add_name = true}))
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s brandishes %s, calling forth the might of the oceans!", who.name:capitalize(), self:getName({no_add_name = true, do_color = true}))
./data/general/objects/world-artifacts.lua:		game.logSeen(who, "#CRIMSON#As you wear both Garkul's heirlooms you can feel the mighty warrior's spirit flowing through you.")
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s brandishes %s %s and banishes all shadows!", who.name:capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}))
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s brandishes the %s which radiates in all directions!", who.name:capitalize(), self:getName({no_add_name = true, do_color = true}))
./data/general/objects/world-artifacts.lua:		game.logSeen(who, "%s quaffs the %s!", who.name:capitalize(), self:getName({no_add_name = true, do_color = true}))
./data/general/objects/world-artifacts.lua:			game.logSeen(src, "#ORCHID#%s resists the tendrils' pull!", src.name:capitalize())
./data/general/objects/world-artifacts.lua:		game.logSeen(who, "#ANTIQUE_WHITE#The two blades glow brightly as they are brought close together.")
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "#GOLD#Ureslak's Femur glows and shimmers!")
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s empowers %s %s!", who.name:capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
./data/general/objects/world-artifacts.lua:		game.logSeen(who, "#YELLOW_GREEN#An ironic harmony surrounds Ureslak's remains as they reunite.")
./data/general/objects/world-artifacts.lua:		game.logSeen(who, "#YELLOW_GREEN#Ureslak's remains seem more unsettled.")
./data/general/objects/world-artifacts.lua:		game.logSeen(who, "#CRIMSON#The echoes of time resound as the blades are reunited once more.")
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s holds %s %s close, cleansing %s of corruption!", who.name:capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}), who:his_her_self())
./data/general/objects/world-artifacts.lua:			if known then game.logSeen(who, "%s is purged of diseases!", who.name:capitalize()) end
./data/general/objects/world-artifacts.lua:				game.logSeen(who, "%s rejects the inferior psionic blade!", self.name:capitalize())
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s's %s lashes out in a flaming arc, intensifying the burning of %s enemies!", who.name:capitalize(), self:getName({do_color = true, no_add_name = true}), who:his_her())
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s focuses a beam of force from %s %s!", who.name:capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
./data/general/objects/world-artifacts.lua:		game.logSeen(who, "Corpathus bursts open, unleashing a horrific mass!")
./data/general/objects/world-artifacts.lua:				game.logSeen(who, "%s's %s #SALMON#CONSUMES THE SOUL#LAST# of %s, gaining the power of %s!", who.name:capitalize(), o:getName({no_add_name = true, do_color = true}), target.name, o.use_talent.name)
./data/general/objects/world-artifacts.lua:				game.logSeen(who, "%s unleashes antimagic forces from %s %s!", who.name:capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
./data/general/objects/world-artifacts.lua:						game.logSeen(target, "%s's animating magic is disrupted by the burst of power!", target.name:capitalize())
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s's %s flashes!", who.name:capitalize(), self:getName({do_color = true, no_add_name = true}))
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s is #PURPLE#ENVELOPED#LAST# in a deep purple aura from %s %s!", who.name:capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s unshutters %s %s, unleashing a torrent of shadows!", who.name:capitalize(), who:his_her(), self:getName({no_add_name = true, do_color = true}))
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s siphons space and time into %s %s!", who.name:capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
./data/general/objects/world-artifacts.lua:				game.logSeen(target, "%s's magical shields are shattered!", target.name:capitalize())
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s merges with %s %s!", who.name:capitalize(), who:his_her(), self:getName({do_color=true, no_add_name = true}))
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s pulls %s %s around %s like a dark shroud!", who.name:capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}), who:his_her_self())
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s flips %s %s over...", who.name:capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
./data/general/objects/world-artifacts.lua:				game.logSeen(target, "%s is knocked back and pinned!", target.name:capitalize())
./data/general/objects/world-artifacts.lua:				game.logSeen(target, "#RED#%s#GOLD# has been decapitated!#LAST#", target.name:capitalize())
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s grasps %s %s and has a sudden vision!", who.name:capitalize(), who:his_her(), self:getName({do_color=true, no_add_name=true}))
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s digs in %s %s.", who.name:capitalize(), who:his_her(), self:getName({do_color=true, no_add_name = true}))
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s focuses time flows through %s %s!", who.name:capitalize(), who:his_her(), self:getName({do_color=true, no_add_name=true}))
./data/general/objects/world-artifacts.lua:			game.logSeen(src, "The eye locks onto %s, freezing it in place!", src.name:capitalize())
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s rebalances the bulky plates of %s %s, and thngs slow down a bit.", who.name:capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s revels in the bloodlust of %s %s!", who.name:capitalize(), who:his_her(), self:getName({do_color = true, no_add_name = true}))
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "#GREEN#You feel the seasons in perfect balance.")
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "%s's weapon returns to %s!", who.name:capitalize(), who:him_her())
./data/general/objects/world-artifacts.lua:			game.logSeen(who, "#YELLOW#You feel psionic energy linking the mindstars.")

]]


