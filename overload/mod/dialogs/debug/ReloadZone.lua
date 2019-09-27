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
require "engine.ui.Dialog"
local Zone = require "engine.Zone"
local Savefile = require "engine.Savefile"

module(..., package.seeall, class.make)

function _M:run()
	local zname, llevel = game.zone.short_name, game.level.level
	local zid = Savefile:nameLoadZone(zname)
	local lid = Savefile:nameLoadLevel(zname, llevel)

	-- Delete the files to force a regen by the Zone class
	local save = Savefile.new(game.save_name)
	fs.delete(save.save_dir..zid)
	fs.delete(save.save_dir..lid)

	-- Delete from memory cache
	Zone:removeLastPersistZone(zname)

	-- Now fake entering
	game.zone = nil
	game.level = nil
	game:changeLevelReal(llevel, zname, {})
end
