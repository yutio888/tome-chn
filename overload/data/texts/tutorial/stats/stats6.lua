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
假如你是一个狂战士，你尝试震慑一个目标，如果成功必须达到两个状态：

首先，你的攻击必须命中目标！这意味着将你的 #LIGHT_GREEN#命中#WHITE# 和对方的 #LIGHT_GREEN#闪避#WHITE# 进行比较计算。

然后，震慑必须生效，你的角色是一个狂战士，所以我们选择 #LIGHT_GREEN#物理强度#WHITE# 来判定。
震慑是一个物理效果，所以我们使用目标的 #LIGHT_GREEN#物理豁免#WHITE# 来与攻击者的物理强度进行比
较计算。

看上去 #LIGHT_GREEN#物理强度#WHITE# 和 #LIGHT_GREEN#物理豁免#WHITE# 之间比较是非常自然的事情，但我们来看另一个例子。 
]]
