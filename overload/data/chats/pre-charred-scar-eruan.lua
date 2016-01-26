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
	text = [[@playername@我是艾伦派来的太阳骑士团的一员，我们跟踪兽人的踪迹到了这里。
他们穿过了传送门，我的几个朋友也被卷了进去。
之前我们抓住过一个兽人。他透露你寻找的法杖是用来吸收远方某个地方举行的黑暗仪式的能量的。
你必须通过这个传送门，要是你有什么办法，一定要阻止那些兽人。]],
	answers = {
		{"我想我能够使用这个传送门，别担心！"},
	}
}

return "welcome"
