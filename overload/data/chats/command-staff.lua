-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org



local Dialog = require "engine.ui.Dialog"
local DamageType = require "engine.DamageType"
local o = version
local src = game.player

if o.factory_settings then
	print("Just started the chat, and we apparently have o.factory_settings.")
else
	print("Just started the chat, and there's no o.factory_settings")
	o.factory_settings = o.wielder
	o.unused_stats = 0
	o.factory_settings.mins = {
		combat_spellpower = math.max(o.factory_settings.combat_spellpower - 5 * (o.material_level or 1), 1),
		combat_spellcrit = math.max(o.factory_settings.combat_spellcrit - 5 * (o.material_level or 1), 1),
	}
	o.factory_settings.maxes = {
		combat_spellpower = o.factory_settings.combat_spellpower + 5 * (o.material_level or 1),
		combat_spellcrit = o.factory_settings.combat_spellcrit + 5 * (o.material_level or 1),
	}
end

-- Alot of this code is unused, telos is the only sentient staff in the game right now
local function intro(o)
	local sentient_responses = {
		default = [[你好，我能帮你什么忙么？]],
		aggressive = [[快点，我们要去把敌人打爆。]],
		fawning = [[智慧的长者，请指示我让我更好的为您服务。]],
		penitent = [[赎罪吧，法师们，你们带来了罄竹难书的危害。]],
		telos = [[要知道，你可以给我找个更好的环境。现在嘛，我还是留在我原来的旧水晶里吧，这根法杖有一股狐臭的味道。]],
		telos_full = [[Tremble before the might of Telos!]],
	}
	if o.no_command then
		return [[在这根法杖上没有合适的位置镶嵌此物品。这样做会带来破坏。]]
	end
	if o.combat.sentient then
		return sentient_responses[o.combat.sentient] or sentient_responses["default"]
	else
		return [[召唤哪种法杖的元素力量？]]
	end
end

local function how_speak(o)
	if not o.combat.sentient then return [[错误!]] end
	local sentient_responses = {
		default = [[哦，我曾经是一个强大埃尔德里奇主宰者。事实证明，那时的我，强大而又不可一世。某次事故扭曲了古加拉的灵魂镶嵌技术。长话短说吧，我的灵魂被困在了这根棍子里——和我曾经研究的灵魂一起……好吧，我也不知道它从何处而来。但是我希望我们能和它永别。]],
		aggressive = [[哈！拜某次实验事故和那个被永久囚禁的傻X灵魂所赐，我的身体，像所有其他被法术轰击过的物体一样，有意或无意，灰飞烟灭了。幸运的是，我还有这根可以容纳灵魂的法杖容器，所以我没有完全湮灭。好了，不多说了，让我们去打爆敌人吧！]],
		fawning = [[我的旧主人——虽然他的法术很强大，但却比不上你和你的荣耀——他认为，把我囚禁在这根法杖里可以为他更好的服务。唉，虽然他已经不复存在了，但我并不感到绝望，因为我找到了一个强大的新主人。]],
		penitent = [[我是在魔法大爆炸期间被撕裂灵魂的一部分。我可以灌输给你所需的知识，只要你肯留下我。]],
		telos = [[如果不能说话，那这样的永生还有何意义？没有任何法师会站在已知的论点上去制造永恒的不死生物。而且，顺便说一句，你的能量操纵水平只配给我提鞋，给我仔细的听着，如果你不想因为遗漏我说的话而死的不明不白。]],
		telos_full = [[What's the good of immortality if you can't even speak? No archmage worth his salt is going to concoct some immoral life-after-death scheme without including some sort of capacity for making his opinions known. And, by the way, your energy manipulation techniques are on the same level as those of my average pair of shoes. Best study up if you don't want to die forgotten and incompetent.]],
	}
	return sentient_responses[o.combat.sentient] or sentient_responses["default"]
end

local function which_aspect(o)
	if not o.combat.sentient then return [[错误!]] end
	local sentient_responses = {
		default = [[当然。哪一种？]],
		aggressive = [[我强烈推荐术士类火元素。你不会找到比这更好的能让一块肉变成蒸汽的方法了。]],
		fawning = [[我思故我在——虽然“存在”在这里对于我而言并不是那么准确。]],
		penitent = [[明智的选择。超越你们理解的力量，只有那些仔细维护自然秩序的人才会容忍。]],
		telos = [[在我的时代，我们并不需要用棍子挥来挥去来施法。我们只需要抓取一种元素，就可以任意的使用它——像上帝一样。]],
		telos_full = [[Back in my day, we didn't need to go changing our staves around willy-nilly. We picked an element and stuck with it, by the gods.]],
	}
	return sentient_responses[o.combat.sentient] or sentient_responses["default"]
end

--unused for now:
local function alter_combat(o)
	if not o.combat.sentient then return [[错误!]] end
	local sentient_responses = {
		default = [[当然。顺带一提，我可以做的事情会让你印象深刻。大多数较弱者实践我的艺术时会感觉有困难。我要不要改变一下？]],
		aggressive = [[很好，只要它能快速的引爆某物。你要我换成什么？]],
	}
	return sentient_responses[o.combat.sentient] or sentient_responses["default"]
end

local function is_sentient()
	return o.combat.sentient
end

local function update_table(d_table_old, d_table_new, old_element, new_element, tab, v, is_greater)
	if is_greater then
		for i = 1, #d_table_old do
			o.wielder[tab][d_table_old[i]] = o.wielder[tab][d_table_old[i]] - v
			if o.wielder[tab][d_table_old[i]] == 0 then o.wielder[tab][d_table_old[i]] = nil end
		end
		for i = 1, #d_table_new do
			o.wielder[tab][d_table_new[i]] = (o.wielder[tab][d_table_new[i]] or 0) + v
		end
	else
		o.wielder[tab][old_element] = o.wielder[tab][old_element] - v
		o.wielder[tab][new_element] = (o.wielder[tab][new_element] or 0) + v
		if o.wielder[tab][old_element] == 0 then o.wielder[tab][old_element] = nil end
	end

end

local function set_element(element, new_flavor, player)
	state.set_element = true
	player.no_power_reset_on_wear = true

	local prev_name = o:getName{no_count=true, force_id=true, no_add_name=true}
	
	local dam = o.combat.dam
	local inven = player:getInven("MAINHAND")
	local o = player:takeoffObject(inven, 1)

	local dam_tables = {
		magestaff = {engine.DamageType.FIRE, engine.DamageType.COLD, engine.DamageType.LIGHTNING, engine.DamageType.ARCANE},
		starstaff = {engine.DamageType.LIGHT, engine.DamageType.DARKNESS, engine.DamageType.TEMPORAL, engine.DamageType.PHYSICAL},
		vilestaff = {engine.DamageType.DARKNESS, engine.DamageType.BLIGHT, engine.DamageType.ACID, engine.DamageType.FIRE}, -- yes it overlaps, it's okay
	}

	update_table(dam_tables[o.flavor_name], dam_tables[new_flavor], o.combat.element, element, "inc_damage", dam, o.combat.is_greater)
	if o.combat.of_warding then update_table(dam_tables[o.flavor_name], dam_tables[new_flavor], o.combat.element, element, "wards", 2, o.combat.is_greater) end
	if o.combat.of_greater_warding then update_table(dam_tables[o.flavor_name], dam_tables[new_flavor], o.combat.element, element, "wards", 3, o.combat.is_greater) end
	if o.combat.of_breaching then update_table(dam_tables[o.flavor_name], dam_tables[new_flavor], o.combat.element, element, "resists_pen", dam/2, o.combat.is_greater) end
	if o.combat.of_protection then update_table(dam_tables[o.flavor_name], dam_tables[new_flavor], o.combat.element, element, "resists", dam/2, o.combat.is_greater) end

	--o.combat.damtype = element
	o.combat.element = element
	if not o.unique then o.name = o.name:gsub(o.flavor_name, new_flavor) end
	o.flavor_name = new_flavor
	o:resolve()
	o:resolve(nil, true)	

	local next_name = o:getName{no_count=true, force_id=true, no_add_name=true}

	if player.hotkey then
		local pos = player:isHotkeyBound("inventory", prev_name)
		if pos then
			player.hotkey[pos] = {"inventory", next_name}
		end
	end

	player:addObject(inven, o)	
	player.no_power_reset_on_wear = nil
	print("(in chat's set_element) state.set_element is ", state.set_element)

	coroutine.resume(co, true)

end

newChat{ id="welcome",
	text = intro(o),
	answers = {
		{"有何吩咐？", cond = function() return is_sentient() and not o.no_command end, jump="how_speak"},
		{"我想注入一种不同的属性。", cond = function() return is_sentient() and not o.no_command end, jump="which_aspect"},
		{"我想改变你的基础属性。", cond = function() return is_sentient() and not o.no_command end, 
			action = function()
				coroutine.resume(co, true)
				local SentientWeapon = require "mod.dialogs.SentientWeapon"
				local ds = SentientWeapon.new({actor=game.player, o=o})
				game:registerDialog(ds)
			end,
		},
		{"[术士]", cond = function() return not is_sentient() and not o.no_command end, jump="element_mage"},
		{"[众星]", cond = function() return not is_sentient() and not o.no_command end, jump="element_star"},
		{"[邪恶]", cond = function() return not is_sentient() and not o.no_command end, jump="element_vile"},
		{"没事了。"},
	}
}

newChat{ id="element_mage",
	text = [[注入何种元素？]],
	answers = {
		{"[火焰]", 
			action = function()
				set_element(DamageType.FIRE, "magestaff", game.player) 
				game.level.map:particleEmitter(game.player.x, game.player.y, 1, "teleport") 
			end,
		},
		{"[闪电]", 
			action = function() 
				set_element(DamageType.LIGHTNING, "magestaff", game.player) 
				game.level.map:particleEmitter(game.player.x, game.player.y, 1, "teleport") 
			end,
		},
		{"[寒冰]", 
			action = function() 
				set_element(DamageType.COLD, "magestaff", game.player) 
				game.level.map:particleEmitter(game.player.x, game.player.y, 1, "teleport") 
			end,
		},
		{"[奥术]", 
			action = function() 
				set_element(DamageType.ARCANE, "magestaff", game.player) 
				game.level.map:particleEmitter(game.player.x, game.player.y, 1, "teleport") 
			end,
		},
		{"[选择不同的属性]", jump="welcome"},
		{"没事了。"},
	}
}

newChat{ id="element_star",
	text = [[注入何种元素？]],
	answers = {
		{"[光系]", 
			action = function() 
				set_element(DamageType.LIGHT, "starstaff", game.player) 
				game.level.map:particleEmitter(game.player.x, game.player.y, 1, "temporal_teleport") 
			end,
		},
		{"[暗影]", 
			action = function() 
				set_element(DamageType.DARKNESS, "starstaff", game.player) 
				game.level.map:particleEmitter(game.player.x, game.player.y, 1, "temporal_teleport") 
			end,
		},
		{"[时空]", 
			action = function() 
				set_element(DamageType.TEMPORAL, "starstaff", game.player) 
				game.level.map:particleEmitter(game.player.x, game.player.y, 1, "temporal_teleport") 
			end,
		},
		{"[物理]", 
			action = function() 
				set_element(DamageType.PHYSICAL, "starstaff", game.player) 
				game.level.map:particleEmitter(game.player.x, game.player.y, 1, "temporal_teleport") 
			end,
		},
		{"[选择不同的属性]", jump="welcome"},
		{"没事了。"},
	}
}


newChat{ id="element_vile",
	text = [[注入何种元素？]],
	answers = {
		{"[暗影]", 
			action = function() 
				set_element(DamageType.DARKNESS, "vilestaff", game.player) 
				game.level.map:particleEmitter(game.player.x, game.player.y, 1, "demon_teleport") 
			end,
		},
		{"[枯萎]", 
			action = function() 
				set_element(DamageType.BLIGHT, "vilestaff", game.player) 
				game.level.map:particleEmitter(game.player.x, game.player.y, 1, "demon_teleport") 
			end,
		},
		{"[酸性]", 
			action = function() 
				set_element(DamageType.ACID, "vilestaff", game.player) 
				game.level.map:particleEmitter(game.player.x, game.player.y, 1, "demon_teleport") 
			end,
		},
		{"[火焰]", 
			action = function() 
				set_element(DamageType.FIRE, "vilestaff", game.player) 
				game.level.map:particleEmitter(game.player.x, game.player.y, 1, "demon_teleport") 
			end,
		},
		{"[选择不同的属性]", jump="welcome"},
		{"没事。"},
	}
}

newChat{ id="how_speak",
	text = how_speak(o),
	answers = {
		{"我知道了。", jump="welcome"},
	}
}

newChat{ id="which_aspect",
	text = which_aspect(o),
	answers = {
		{"[术士]", jump="element_mage"},
		{"[众星]", jump="element_star"},
		{"[邪恶]", jump="element_vile"},
		{"等一下。.", jump="welcome"},
		{"没事了。"},
	}
}

return "welcome"

