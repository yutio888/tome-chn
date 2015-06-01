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

newChat{ id="welcome",
	text = [[#VIOLET#*当你打开门，你注意到远处一个巨大的兽人，同时被冰与火包围着。*
#LAST#@playerdescriptor.race@！你不应该来这里！你的死期到了！
兽人部落不会为任何人让步！他们有他们的荣耀，你什么也做不了！]],
	answers = {
		{"整个兽人部落屈服于一个吸血鬼领主？我明白了……还真是“荣耀”啊！", jump="mock"},
		{"#LIGHT_GREEN#[攻击]"},
	}
}

newChat{ id="mock",
	text = [[部落选择了自己的盟友，我们从不屈服于人！攻击！]],
	answers = {
		{"#LIGHT_GREEN#[攻击]"},
	}
}

return "welcome"
