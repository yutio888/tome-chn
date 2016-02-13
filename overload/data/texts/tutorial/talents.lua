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

if not game.player.tutored_levels then
	game.player:learnTalent(game.player.T_SHIELD_PUMMEL, true, 1, {no_unlearn=true})
	game.player:learnTalent(game.player.T_SHIELD_WALL, true, 1, {no_unlearn=true})
	game.player.tutored_levels = true
end

return [[你现在学会了盾击和盾墙技能。
技能会在屏幕的右下方显示，并设有快捷键。
你可以右键点击一个技能将他们从快捷栏中移除，或者你可以按下 'M'键 打开技能列表来
设置快捷键。
默认快捷键是 1 到 0 数字键，也可以给物品设定快捷键。

你可以通过按下快捷键来使用技能，或者从技能列表里点击使用，或者点击快捷栏使用。

技能有三种类型：
* #GOLD#主动#WHITE#：在你激活并使用的瞬间生效。
* #GOLD#持续#WHITE#：你主动激活后会持续生效，直到效果被关闭为止。
通常它会消耗一些你可用的能量值(比如体力)。
* #GOLD#被动#WHITE#：学会后永久生效的技能。

一些技能需要选择目标，当你使用时会有一个高亮区域以选择你要施放的目标。
* #GOLD#使用键盘#WHITE#：按下方向键可以在允许施放的范围内移动选择目标，
按下 shift+方向键 可以随意移动目标，Enter 或者空格键确认目标。
* #GOLD#使用鼠标#WHITE#：移动鼠标可以选择目标，左键确认目标使用技能。

现在尝试使用以下技能：
* #GOLD#盾击#WHITE#：这个技能能攻击目标并有几率震慑它，使目标在一定回合内不能
对你造成伤害。
* #GOLD#盾墙#WHITE#：这个技能可以提高你的闪避和护甲值，可以减少你受到的伤害。
]]
