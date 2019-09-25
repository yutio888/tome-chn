-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
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
		default = [[Greetings. How can I help you?]],
		aggressive = [[Hurry up and make with the foe-blasting.]],
		fawning = [[O wise wielder, instruct me that I may better serve you.]],
		penitent = [[Make amends, magic-user, for the harm ye have wrought is beyond compare.]],
		telos = [[You really could have chosen a better home for me, you know. I was reasonably happy in my old crystal. This stick smells like armpit.]],
		telos_full = [[Tremble before the might of Telos!]],
	}
	cur_chat:triggerHook{"CommandStaff:SentientOptions", o=o, mode="intro", list=sentient_responses}
	if o.no_command then
		return [[It is not yet your place to command such a staff as this. To do so invites obliteration.]]
	end
	if o.combat.sentient then
		return sentient_responses[o.combat.sentient] or sentient_responses["default"]
	else
		return [[Call on which aspect of the staff?]]
	end
end

local function how_speak(o)
	if not o.combat.sentient then return [[error!]] end
	local sentient_responses = {
		default = [[Oh, I was once a mighty Eldritch Channeler. Mighty and absentminded, as it turns out. Had a bit of a mishap with an Inverted Kugala's Soul-infusion technique. Long story short, my soul is now stuck in this stick, and the soul I was working with... well, I don't rightly know where he got to. But I hope we never meet him.]],
		aggressive = [[Argh! Bollocksed up a tricky bit of soul magic and the fool that I was supposed to be imprisoning for all eternity flitted away. My body, like all the targets of my spells, intended or otherwise, got reduced to elementary particles. Fortunately, I had this soul-cage of a staff all prepped and ready for a stray soul, so I'm not completely gone. But enough chit-chat. Let's fry somebody.]],
		fawning = [[My old master-- who, though a powerful enchanter, did not compare to you and your glory-- saw fit to imprison me in this fine staff to aid him in his work. Alas, he is long gone, but I despair not, for I have found a mighty new master.]],
		penitent = [[I am a portion of the very spirit of the world that was ripped free during the Spellblaze. I speak that I might enlighten those who bear me.]],
		telos = [[What's the good of immortality if you can't even speak? No archmage worth his salt is going to concoct some immoral life-after-death scheme without including some sort of capacity for making his opinions known. And, by the way, your energy manipulation techniques are on the same level as those of my average pair of shoes. Best study up if you don't want to die forgotten and incompetent.]],
		telos_full = [[What's the good of immortality if you can't even speak? No archmage worth his salt is going to concoct some immoral life-after-death scheme without including some sort of capacity for making his opinions known. And, by the way, your energy manipulation techniques are on the same level as those of my average pair of shoes. Best study up if you don't want to die forgotten and incompetent.]],
	}
	class:triggerHook{"CommandStaff:SentientOptions", o=o, mode="how_speak", list=sentient_responses}
	return sentient_responses[o.combat.sentient] or sentient_responses["default"]
end

local function which_aspect(o)
	if not o.combat.sentient then return [[error!]] end
	local sentient_responses = {
		default = [[Of course. Which aspect?]],
		aggressive = [[I highly recommend the mage aspect and the fire element. You're not going to find anything better for turning a piece of meat into a cloud of vapor.]],
		fawning = [[I live to serve-- though my use of the word 'live' is perhaps loose here.]],
		penitent = [[Choose wisely. Powers beyond your comprehension will tolerate only so much interference in their carefully-laid natural order.]],
		telos = [[Back in my day, we didn't need to go changing our staves around willy-nilly. We picked an element and stuck with it, by the gods.]],
		telos_full = [[Back in my day, we didn't need to go changing our staves around willy-nilly. We picked an element and stuck with it, by the gods.]],
	}
	class:triggerHook{"CommandStaff:SentientOptions", o=o, mode="which_aspect", list=sentient_responses}
	return sentient_responses[o.combat.sentient] or sentient_responses["default"]
end

--unused for now:
local function alter_combat(o)
	if not o.combat.sentient then return [[error!]] end
	local sentient_responses = {
		default = [[Certainly. You should be impressed, by the way, that I can do such a thing. Most lesser practitioners of my art would have difficulties with this. What shall I change?]],
		aggressive = [[Fine, as long as it leads to blasting something soon. What do you want me to change?]],
	}
	class:triggerHook{"CommandStaff:SentientOptions", o=o, mode="alter_combat", list=sentient_responses}
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

local aspect_answers = {}
local aspect_chat_id = not is_sentient() and "welcome" or "which_aspect"
for _, flavor in ipairs(flavor_list) do
	local damtypes = o:getStaffFlavor(flavor)
	local answers = {}
	for i, dtype in ipairs(damtypes) do
		local name = ("[%s]"):format(DamageType:get(dtype).name:capitalize())
		answers[i] = {name, action = function() set_element(dtype, flavor, game.player) end}
	end
	answers[#answers + 1] = {"Choose different aspect", jump = aspect_chat_id}
	answers[#answers + 1] = {"Never mind."}
	newChat{id="element_"..flavor, text = "Call forth which element?", answers = answers}

	local flavor_name = flavor:gsub("staff", ""):capitalize()
	aspect_answers[#aspect_answers + 1] = {("[%s]"):format(flavor_name), jump = "element_"..flavor}
end

aspect_answers[#aspect_answers + 1] = {"Never mind."}

if is_sentient() then
	local answers = {
		{"How is it that you speak?", cond = function() return is_sentient() and not o.no_command end, jump="how_speak"},
		{"I'd like you to bring forth a different aspect.", cond = function() return is_sentient() and not o.no_command end, jump="which_aspect"},
		{"I'd like to alter your basic properties.", cond = function() return is_sentient() and not o.no_command end, 
			action = function()
				coroutine.resume(co, true)
				local SentientWeapon = require "mod.dialogs.SentientWeapon"
				local ds = SentientWeapon.new({actor=game.player, o=o})
				game:registerDialog(ds)
			end,
		},
	}

	cur_chat:triggerHook{"CommandStaff:SentientChat", o=o, answers=answers}
	answers[#answers+1] = {"Never mind."}

	newChat{ id="welcome",
		text = intro(o),
		answers = answers,
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

