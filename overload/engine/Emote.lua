-- TE4 - T-Engine 4
-- Copyright (C) 2009 - 2017 Nicolas Casalini
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
local Base = require "engine.ui.Base"

--- Emotes for actors
-- @classmod engine.Emote
module(..., package.seeall, class.inherit(Base))

frame_ox1 = -15
frame_ox2 = 15
frame_oy1 = -15
frame_oy2 = 15

--- @string text
-- @int[opt=60] dur
-- @param[opt=colors.Black] color
function _M:init(text, dur, color)
	self.text = text
	self.dur = dur or 60
	self.color = color or colors.BLACK

	Base.init(self, {font = {chn123_tome_font(), 16}})
end

--- on loaded
function _M:loaded()
	Base.init(self, {font = {chn123_tome_font(), 16}})
end

--- Serialization
-- @return if we successfully saved or not
function _M:save()
	return class.save(self, {x=true, y=true, text=true, dur=true, color=true}, true)
end

--- Update emote
function _M:update()
	self.dur = self.dur - 1
	if self.dur < 0 then return true end
end

--- Generate emote
function _M:generate()
	-- Draw UI
	self.text = emote_chn_get(self.text)
	local chn_w = utf8:new(self.text)
	local w = chn_w:len()*15
	local _, h = self.font:size(self.text)
	self.w, self.h = w - frame_ox1 + frame_ox2, h - frame_oy1 + frame_oy2

	local s = core.display.newSurface(w, h)
	s:drawColorStringBlended(self.font, self.text, 0, 0, self.color.r, self.color.g, self.color.b, true)
	self.tex = {s:glTexture()}

	self.rw, self.rh = w, h
	self.frame = self:makeFrame("ui/emote/", self.w, self.h)
end

--- Display emote
function _M:display(x, y)
	local a = 1
	if self.dur < 10 then
		a = (self.dur) / 10
	end

	self:drawFrame(self.frame, x, y, 1, 1, 1, a * 0.7)
	self.tex[1]:toScreenFull(x-frame_ox1, y-frame_oy1, self.rw, self.rh, self.tex[2], self.tex[3], 1, 1, 1, a)
end
