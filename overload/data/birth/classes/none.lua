-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
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

newBirthDescriptor{
	type = "class",
	name = "None",
	desc = {
		" 你 的 种 族 无 法 选 择 职 业， 它 有 自 己 的 天 赋 力 量。 ",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			None = "allow",
		},
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "None",
	desc = {
		" 你 的 种 族 无 法 选 择 职 业， 它 有 自 己 的 天 赋 力 量。 ",
	},
	not_on_random_boss = true,
}
  