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

if not game.player.tutored_levels2 then
	game.player:learnTalent(game.player.T_SHOOT, true, 1, {no_unlearn=true})
	game.player.tutored_levels2 = true
end

return [[远程攻击主要包括射箭、用投石索发射子弹或者施法。
你现在获得了一把弓，你得用双手来装备它。
你有无限弹药，你也能装备特殊的箭矢来提升攻击或者获得额外的攻击效果。
想要射箭，使用射击技能。攻击目标会显示高亮，其他技能也是一样。

装备你的弓和箭矢的方法：
* 打开你的物品栏。
* Click on the Off Set button to switch weapons.
* 选择你的弓和箭矢，选择装备。

西部有一些巨魔，用弓箭来杀死他们！
]]
