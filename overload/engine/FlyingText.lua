-- TE4 - T-Engine 4
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

require "engine.class"

module(..., package.seeall, class.make)

function _M:init(fontname, fontsize, bigfontname, bigfontsize)
	self.font = core.display.newFont("/data-chn123/font/main.ttf", fontsize or 12)
	self.bigfont = core.display.newFont("/data-chn123/font/main.ttf", bigfontsize or 14)
	self.font_h = self.font:lineSkip()
	self.flyers = {}
end

function _M:enableShadow(v)
	self.shadow = v
end

function _M:add(x, y, duration, xvel, yvel, str, color, bigfont)
	if not x or not y or not str then return end
	color = color or {255,255,255}
	local strCHN=flyCHN(str)
	local s = core.display.drawStringBlendedNewSurface(bigfont and self.bigfont or self.font, strCHN, color[1], color[2], color[3])
	if not s then return end
	local w, h = s:getSize()
	local t, tw, th = s:glTexture()
	local f = {
		x=x,
		y=y,
		w=w, h=h,
		tw=tw, th=th,
		duration=duration or 10,
		xvel = xvel or 0,
		yvel = yvel or 0,
		t = t,
	}
	f.popout_dur = math.max(3, math.floor(f.duration / 4))
	self.flyers[f] = true
	return f
end

function _M:empty()
	self.flyers = {}
end

function _M:display(nb_keyframes)
	if not next(self.flyers) then return end

	local dels = {}

	for fl, _ in pairs(self.flyers) do
		local zoom = nil
		local x, y = fl.x, fl.y
		local tx, ty = fl.x, fl.y
		if fl.duration <= fl.popout_dur then
			zoom = (fl.duration / fl.popout_dur)
			x, y = -fl.w / 2 * zoom, -fl.h / 2 * zoom
			core.display.glTranslate(tx, ty, 0)
			core.display.glScale(zoom, zoom, zoom)
		end

		if self.shadow then fl.t:toScreenFull(x+1, y+1, fl.w, fl.h, fl.tw, fl.th, 0, 0, 0, self.shadow) end
		fl.t:toScreenFull(x, y, fl.w, fl.h, fl.tw, fl.th)
		fl.x = fl.x + fl.xvel * nb_keyframes
		fl.y = fl.y + fl.yvel * nb_keyframes
		fl.duration = fl.duration - nb_keyframes

		if zoom then
			core.display.glScale()
			core.display.glTranslate(-tx, -ty, 0)
		end

		-- Delete the flyer
		if fl.duration <= 0 then
			dels[#dels+1] = fl
		end
	end

	for i, fl in ipairs(dels) do self.flyers[fl] = nil end
end
