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

newChat{ id="welcome",
	text = [[*#LIGHT_GREEN#突然你的头顶上出现了一个声音。#WHITE#*
@playername@，我是太阳堡垒的高阶太阳骑士艾伦。我借助星月术士的能力和你取得联系。
我有个非常紧急的消息要告诉你：我们已经知道你一直在寻找的法杖去向。]],
	answers = {
		{"在哪里？！", jump="where"},
	}
}

newChat{ id="where",
	text = [[我们的一个巡逻队在南部大陆艾露安沙漠注意到了一些兽人的奇怪行踪。
一群兽人在守卫着一件东西，看上去好像是你提到的那个法杖。
你应该去调查一下，这可能是你仅有的机会。]],
	answers = {
		{"我马上就去！"},
	}
}
return "welcome"
