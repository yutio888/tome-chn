-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2015 Nicolas Casalini
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
		telos_full = [[在泰勒斯的强大力量下颤抖吧！]],
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
		telos = [[如果不能说话，那这样的永生还有何意义？凡是想要达到永生不死的大法师，没有一个留下一种方法让自己的伟大知识永久流传。而且，顺便说一句，你的能量操纵水平只配给我提鞋，给我仔细的听着，如果你不想因为遗漏我说的话而死的不明不白。]],
		telos_full = [[如果不能说话，那这样的永生还有何意义？凡是想要达到永生不死的大法师，没有一个留下一种方法让自己的伟大知识永久流传。而且，顺便说一句，你的能量操纵水平只配给我提鞋，给我仔细的听着，如果你不想因为遗漏我说的话而死的不明不白。]],
	}
	return sentient_responses[o.combat.sentient] or sentient_responses["default"]
end

local function which_aspect(o)
	if not o.combat.sentient then return [[错误!]] end
	local sentient_responses = {
		default = [[当然。哪一种？]],
		aggressive = [[我强烈推荐术士类火焰元素。你不会找到比这更好的能让一块肉变成蒸汽的方法了。]],
		fawning = [[我毕生为你效劳——虽然“毕生”在这里对于我而言并不是那么准确。]],
		penitent = [[明智地进行选择。只有那些仔细维护自然秩序的人才会被那些超越你们理解的力量所容忍。]],
		telos = [[在我的时代，我们并不需要用棍子挥来挥去来施法。我们只需要抓取一种元素，就可以任意的使用它——像上帝一样。]],
		telos_full = [[在我的时代，我们并不需要用棍子挥来挥去来施法。我们只需要抓取一种元素，就可以任意的使用它——像上帝一样。]],
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

local function set_element(element, new_flavor, player)
	state.set_element = true
	local old_reset = player.no_power_reset_on_wear
	player.no_power_reset_on_wear = true
	local prev_name = o:getName{no_count=true, force_id=true, no_add_name=true}

	local _, item, inven_id = player:findInAllInventoriesByObject(o)
	if inven_id then player:onTakeoff(o, inven_id, true) end

	o:commandStaff(element, new_flavor)
	local next_name = o:getName{no_count=true, force_id=true, no_add_name=true}

	if player.hotkey then
		local pos = player:isHotkeyBound("inventory", prev_name)
		if pos then
			player.hotkey[pos] = {"inventory", next_name}
		end
	end

	if inven_id then player:onWear(o, inven_id, true) end
	player.no_power_reset_on_wear = old_reset
	print("(in chat's set_element) state.set_element is ", state.set_element)

	coroutine.resume(co, true)

end

local DamageType = require "engine.DamageType"
local flavors = o:getStaffFlavorList()
local flavor_list = table.keys(flavors)
table.sort(flavor_list)
local standard_flavors = {
	magestaff = {engine.DamageType.FIRE, engine.DamageType.COLD, engine.DamageType.LIGHTNING, engine.DamageType.ARCANE},
	starstaff = {engine.DamageType.LIGHT, engine.DamageType.DARKNESS, engine.DamageType.TEMPORAL, engine.DamageType.PHYSICAL},
	vilestaff = {engine.DamageType.DARKNESS, engine.DamageType.BLIGHT, engine.DamageType.ACID, engine.DamageType.FIRE}, -- yes it overlaps, it's okay
	powerstaff = {DamageType.ARCANE, DamageType.BLIGHT, DamageType.COLD, DamageType.DARKNESS, DamageType.ACID, DamageType.LIGHT},
	harmonystaff = {DamageType.PHYSICAL, DamageType.MIND, DamageType.NATURE, DamageType.ARCANE},
}
local aspect_answers = {}
local aspect_chat_id = not is_sentient() and "welcome" or "which_aspect"
for _, flavor in ipairs(flavor_list) do
--和汉化冲突，原因未知，待修复
--[[	local damtypes = o:getStaffFlavor(flavor)
	local answers = {}
	for i, dtype in ipairs(damtypes) do
		local name = ("[%s]"):format(DamageType:get(dtype).name)
		
		answers[i] = {name, action = function() set_element(dtype, flavor, game.player) end}
	end]]
	local answers = {}
	if standard_flavors[flavor] then
		for i, dtype in ipairs(standard_flavors[flavor]) do
			local name = ("[%s]"):format(DamageType:get(dtype).name)
		
			answers[i] = {name, action = function() set_element(dtype, flavor, game.player) end}
		end
		end
	answers[#answers + 1] = {"选择其他领域", jump = aspect_chat_id}
	answers[#answers + 1] = {"别介意."}
	newChat{id="element_"..flavor, text = "召唤哪种元素？", answers = answers}
	
	local flavor_name = flavor:gsub("staff", ""):gsub("mage","法术"):gsub("star","众星"):gsub("vile","邪恶"):gsub("power","力量"):gsub("harmony","和谐")
	aspect_answers[#aspect_answers + 1] = {("[%s]"):format(flavor_name), jump = "element_"..flavor}
end

aspect_answers[#aspect_answers + 1] = {"别介意."}

if is_sentient() then
	newChat{ id="welcome",
		text = intro(o),
			answers = {
			{"你怎么会说话？", cond = function() return is_sentient() and not o.no_command end, jump="how_speak"},
			{"我希望切换到其他领域。", cond = function() return is_sentient() and not o.no_command end, jump="which_aspect"},
			{"我希望改变你的基础属性。", cond = function() return is_sentient() and not o.no_command end, 
				action = function()
					coroutine.resume(co, true)
					local SentientWeapon = require "mod.dialogs.SentientWeapon"
					local ds = SentientWeapon.new({actor=game.player, o=o})
					game:registerDialog(ds)
				end,
			},
			{"Never mind."},
		}
	}
	newChat{ id="which_aspect",
		text = which_aspect(o),
		answers = aspect_answers,
	}
else
	newChat{ id="welcome",
		text = intro(o),
		answers = aspect_answers,
	}
end

newChat{ id="how_speak",
	text = how_speak(o),
	answers = {
		{"I see.", jump="welcome"},
	}
}

return "welcome"

