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

local ShimmerRemoveSustains = require("mod.dialogs.ShimmerRemoveSustains")

local function shimmer(player, slot)
	return function()
		package.loaded['mod.dialogs.Shimmer'] = nil
		local d = require("mod.dialogs.Shimmer").new(player, slot)
		game:registerDialog(d)
	end
end

local function shimmer_other(player, slot)
	return function()
		package.loaded['mod.dialogs.ShimmerOther'] = nil
		local d = require("mod.dialogs.ShimmerOther").new(player, slot)
		game:registerDialog(d)
	end
end

local function sustains_aura_remove(player)
	return function()
		package.loaded['mod.dialogs.ShimmerRemoveSustains'] = nil
		local d = require("mod.dialogs.ShimmerRemoveSustains").new(player)
		game:registerDialog(d)
	end
end

local function sustains_aura_remove(player)
	return function()
		package.loaded['mod.dialogs.ShimmerRemoveSustains'] = nil
		local d = require("mod.dialogs.ShimmerRemoveSustains").new(player)
		game:registerDialog(d)
	end
end

local answers = {}

for slot, inven in pairs(player.inven) do
	if player.inven_def[slot].infos and player.inven_def[slot].infos.shimmerable and inven[1] then
		local o = inven[1]
		if o.slot then
			answers[#answers+1] = {"[改变你 "..o:getName{do_color=true, no_add_name=true}.."的形象。]", action=shimmer(player, slot), jump="welcome"}
		end
	end
end
if world.unlocked_shimmers and world.unlocked_shimmers.SHIMMER_DOLL then
	answers[#answers+1] = {"[改变你身体的形象。]", action=shimmer_other(player, "SHIMMER_DOLL"), jump="welcome"}
end
if world.unlocked_shimmers and world.unlocked_shimmers.SHIMMER_FACIAL then
	answers[#answers+1] = {"[改变你的脸部特征。]", action=shimmer_other(player, "SHIMMER_FACIAL"), jump="welcome"}
end
if world.unlocked_shimmers and world.unlocked_shimmers.SHIMMER_HAIR then
	answers[#answers+1] = {"[改变你的发型。]", action=shimmer_other(player, "SHIMMER_HAIR"), jump="welcome"}
end
if world.unlocked_shimmers and world.unlocked_shimmers.SHIMMER_AURA then
	answers[#answers+1] = {"[改变你外观的光环。]", action=shimmer_other(player, "SHIMMER_AURA"), jump="welcome"}
end

if ShimmerRemoveSustains:hasRemovableAuras(player) then
	answers[#answers+1] = {"[取消你持续技能的动画效果。]", action=sustains_aura_remove(player), jump="welcome"}
end

answers[#answers+1] = {"[离开镜子]"}
	
newChat{ id="welcome",
	text = [[*#LIGHT_GREEN#当你凝视镜子时，你会看到无数个略有不同的你自己的倒影。你感到一阵头晕。#WHITE#*]],
	answers = answers
}

return "welcome"
