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

local DamageType = require "engine.DamageType"
local src = version

local function has_ward(which)
	if not src.wards then return false end
	if src.wards[which] and src.wards[which] ~= 0 then return true end
	return false
end

local function set_ward(which, charges)
	src:setEffect(src.EFF_WARD, 10, {nb=charges, d_type=which})
	state.set_ward = true
end

newChat{ id="welcome",
	text = [[在魔杖中注入何种属性？]],
	answers = {
		{"火焰 ["..(src.wards[DamageType.FIRE] or 0).."]", 
			cond = function() return has_ward(DamageType.FIRE) end,
			action = function() return set_ward(DamageType.FIRE, (src.wards[DamageType.FIRE] or 0)) end,
		},
		{"闪电 ["..(src.wards[DamageType.LIGHTNING] or 0).."]",
			cond = function() return has_ward(DamageType.LIGHTNING) end,
			action = function() return set_ward(DamageType.LIGHTNING, (src.wards[DamageType.LIGHTNING] or 0)) end,
		},
		{"寒冰 ["..(src.wards[DamageType.COLD] or 0).."]",
			cond = function(who) return has_ward(DamageType.COLD) end,
			action = function() return set_ward(DamageType.COLD, (src.wards[DamageType.COLD] or 0)) end,
		},
		{"奥术 ["..(src.wards[DamageType.ARCANE] or 0).."]",
			cond = function(who) return has_ward(DamageType.ARCANE) end,
			action = function() return set_ward(DamageType.ARCANE, (src.wards[DamageType.ARCANE] or 0)) end,
		},
		{"光系 ["..(src.wards[DamageType.LIGHT] or 0).."]", 
			cond = function() return has_ward(DamageType.LIGHT) end,
			action = function() return set_ward(DamageType.LIGHT, (src.wards[DamageType.LIGHT] or 0)) end,
		},
		{"暗影 ["..(src.wards[DamageType.DARKNESS] or 0).."]", 
			cond = function() return has_ward(DamageType.DARKNESS) end,
			action = function() return set_ward(DamageType.DARKNESS, (src.wards[DamageType.DARKNESS] or 0)) end,
		},
		{"时空 ["..(src.wards[DamageType.TEMPORAL] or 0).."]", 
			cond = function() return has_ward(DamageType.TEMPORAL) end,
			action = function() return set_ward(DamageType.TEMPORAL, (src.wards[DamageType.TEMPORAL] or 0)) end,
		},
		{"物理 ["..(src.wards[DamageType.PHYSICAL] or 0).."]", 
			cond = function() return has_ward(DamageType.PHYSICAL) end,
			action = function() return set_ward(DamageType.PHYSICAL, (src.wards[DamageType.PHYSICAL] or 0)) end,
		},
		{"自然 ["..(src.wards[DamageType.NATURE] or 0).."]", 
			cond = function() return has_ward(DamageType.NATURE) end,
			action = function() return set_ward(DamageType.NATURE, (src.wards[DamageType.NATURE] or 0)) end,
		},
		{"枯萎 ["..(src.wards[DamageType.BLIGHT] or 0).."]", 
			cond = function() return has_ward(DamageType.BLIGHT) end,
			action = function() return set_ward(DamageType.BLIGHT, (src.wards[DamageType.BLIGHT] or 0)) end,
		},
		{"酸性 ["..(src.wards[DamageType.ACID] or 0).."]", 
			cond = function() return has_ward(DamageType.ACID) end,
			action = function() return set_ward(DamageType.ACID, (src.wards[DamageType.ACID] or 0)) end,
		},
		{"精神 ["..(src.wards[DamageType.MIND] or 0).."]", 
			cond = function() return has_ward(DamageType.MIND) end,
			action = function() return set_ward(DamageType.MIND, (src.wards[DamageType.MIND] or 0)) end,
		},

		{"没事了。"},
	}
}

return "welcome"

