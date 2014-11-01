-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
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

return [[
看上去似乎有很多种方式来匹配攻击性 #GOLD#战斗属性#WHITE#...
#LIGHT_GREEN#命中#WHITE#
#LIGHT_GREEN#物理强度#WHITE#
#LIGHT_GREEN#法术强度#WHITE#
#LIGHT_GREEN#精神强度#WHITE#

和防御性 #GOLD#战斗属性#WHITE#。
#LIGHT_GREEN#闪避#WHITE#
#LIGHT_GREEN#物理豁免#WHITE#
#LIGHT_GREEN#法术豁免#WHITE#
#LIGHT_GREEN#精神豁免#WHITE#

别着急，通常有两种方法很容易知道是怎么计算的：

#GOLD#1)#WHITE#  防御性 #GOLD#战斗属性#WHITE# 一般都是固定的；物理效果使用 #LIGHT_GREEN#物理豁免#WHITE#而无论效果来源是什么。
魔法效果则使用 #LIGHT_GREEN#魔法豁免#WHITE#。精神效果则使用 #LIGHT_GREEN#精神豁免#WHITE#。

#GOLD#2)#WHITE#  大多数情况下，某种职业都使用单一的攻击性 #GOLD#战斗属性#WHITE#，所以也不太会混淆。
狂战士只会用 #LIGHT_GREEN#物理强度#WHITE# 判定效果，而法师基本都使用 #LIGHT_GREEN#法术强度#WHITE#。 
]]
