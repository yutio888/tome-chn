-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2016 Nicolas Casalini
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

local has_staff = false
local carry, o, item, inven_id = game.party:findInAllInventoriesBy("define_as", "STAFF_ABSORPTION")
if o then has_staff = true end
local carry, o, item, inven_id = game.party:findInAllInventoriesBy("define_as", "STAFF_ABSORPTION_AWAKENED")
if o then has_staff = true end

local speak
if has_staff then
	speak = [["你不应该来这里。你怎么……"#{normal}#它突然停了下来，似乎被你手中的法杖所吸引。 #{italic}#"你怎么弄到这个的？蠢货，你知不知道你手中掌握着什么力量！离开这里！给我消失！"]]
else
	speak = [["你不应该来这里，你是怎么过来的，给我消失！"]]
end

newChat{ id="welcome",
	text = [[#{italic}#当你打开门时，你很吃惊的看着眼前的一切。一个生物站在你面前，长着触手一样的附属物，在脑袋的位置有个肿块一样的鼓起物。它的身上放射出一种你从来没有碰到过的力量光环。有可能是一只夏·图尔，活着的夏·图尔！

不过你的惊愕没有持续多久，那个夏·图尔注意到了你，你感觉到它身上释放出一种令你窒息的压倒性的力量。一个声音在你的脑海中响起 #{normal}#]]..speak..[[#{italic}#

流星的力量对你形成一股精神和魔法的冲击，你被举到空中，强大的力量侵入了你的每一寸肌肤，差点把你撕成碎片，你挣扎着抵抗了一会，直到——#{normal}#]],
	answers = {
		{"[继续]", jump="next", action=function(npc, player)
			game:changeLevel(1, "shertul-fortress", {direct_switch=true})
			local spot = game.level:pickSpot{type="spawn", subtype="farportal"} or {x=39, y=29}
			game.player:move(spot.x, spot.y, true)
			world:gainAchievement("CALDIZAR", game.player)
			game.party:learnLore("shertul-fortress-caldizar")
		end},
	}
}

newChat{ id="next",
	text = [[#{italic}#你在远古传送门边上突然醒了过来，你感觉头痛欲裂。你感觉到你脸颊上很潮湿，当你用手从脸上拂过，你发现你的指尖沾着血液——你流出了血泪。你感觉到你的脑海中埋藏着黑暗、可怕的记忆，但是你越是极力回想越是想不起来，它慢慢地从你的脑海深处完全消失，就像做了一场梦。#{normal}#]],
	answers = {
		{"[完成]"},
	}
}

return "welcome"
