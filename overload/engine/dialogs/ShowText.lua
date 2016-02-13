-- TE4 - T-Engine 4
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

require "engine.class"
local Dialog = require "engine.ui.Dialog"
local Textzone = require "engine.ui.Textzone"

--- Show Text
-- @classmod engine.dialogs.ShowText
module(..., package.seeall, class.inherit(Dialog))

function _M:init(title, file, replace, w, h, on_exit, accept_key)
	local rw, rh = w, h
	w = math.floor(w or game.w * 0.6)
	h = math.floor(h or game.h * 0.8)

	Dialog.init(self, title or "Text", w, h)

	self:generateList(file, replace)

	self.c_desc = Textzone.new{width=math.floor(self.iw - 10), height=self.ih, no_color_bleed=true, auto_height=true, text=self.text}

	self:loadUI{
		{left=0, top=0, ui=self.c_desc},
	}
	self:setupUI(not rw, not rh)

	self.key:addBinds{
		ACCEPT = accept_key and "EXIT",
		EXIT = function()
			game:unregisterDialog(self)
			if on_exit then on_exit() end
		end,
	}
end

function _M:generateList(file, replace)
	local f, err
	if textCHN and textCHN[file] then
		f, err = loadfile("/data-chn123/texts/"..file..".lua")
	else
		f, err = loadfile("/data/texts/"..file..".lua")
	end
	if not f and err then error(err) end
	local env = setmetatable({}, {__index=_G})
	setfenv(f, env)

	local str = f()

	str = str:gsub("@([^@]+)@", function(what)
		if not replace[what] then return "" end
		return util.getval(replace[what])
	end)

	self.text = str

	if env.title then
		self.title = env.title
	end
	return true
end
