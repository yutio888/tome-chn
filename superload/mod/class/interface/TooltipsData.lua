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

require "engine.class"

--module(..., package.seeall, class.make)

local _M = loadPrevious(...)
-------------------------------------------------------------
-- Resources
-------------------------------------------------------------
_M.TOOLTIP_STEAM = [[#GOLD#蒸汽#LAST#
蒸汽由特殊的蒸汽机产生，用于驱动大部分科技设备。
很难提升你的最大蒸汽储量，但是蒸汽可以快速被补充。
因此，它的产生和消耗都很快。
]]
-------------------------------------------------------------
-- Steamtech
-------------------------------------------------------------
_M.TOOLTIP_STEAMPOWER = [[#GOLD#蒸汽强度#LAST#
你的蒸汽强度代表了你的蒸汽科技能力的强度和效果。
它的工作方式类似于物理强度，但是受到灵巧值而非力量值的加成。
]] --dgdgdgdg need to finish description?
_M.TOOLTIP_STEAM_CRIT = [[#GOLD#蒸汽暴击率#LAST#
这一属性决定了你使用蒸汽科技造成伤害的时候，发动暴击，造成额外伤害的几率。
一些技能也会提升你的蒸汽暴击率。
暴击率受灵巧值加成。
]]
_M.TOOLTIP_STEAM_SPEED = [[#GOLD#蒸汽速度#LAST#
蒸汽速度代表你使用你蒸汽科技工具的时候，相比于平常状况的速度。
这一数值越高越好。
]]
return _M