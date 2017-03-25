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

--- Flying Text
-- @classmod engine.FlyingText
module(..., package.seeall, class.make)

--- Init
-- @string[opt="DroidSans"] fontname
-- @int[opt=12] fontsize
-- @string[opt="DroidSans-Bold"] bigfontname
-- @int[opt=14] bigfontsize
function _M:init(fontname, fontsize, bigfontname, bigfontsize)
	self.font = core.display.newFont(chn123_tome_font(), fontsize or 12)
	self.bigfont = core.display.newFont(chn123_tome_font(), bigfontsize or 14)
	self.font_h = self.font:lineSkip()
	self.flyers = {}
end

--- @param[type=boolean] v enable the shadowssss
function _M:enableShadow(v)
	self.shadow = v
end

--- Add a new flying text
-- @int x x position
-- @int y y position
-- @int[opt=10] duration
-- @param[type=?number] xvel horizontal velocity
-- @param[type=?number] yvel vertical velocity
-- @string str what the text says
-- @param[type=?table] color color of the text, defaults to colors.White
-- @param[type=?boolean] bigfont use the big font?
-- @return `FlyingText`
function _M:add(x, y, duration, xvel, yvel, str, color, bigfont)
	if not x or not y or not str then return end
	color = color or {255,255,255}
	local strCHN=flyCHN(str)
	--local s = core.display.drawStringBlendedNewSurface(bigfont and self.bigfont or self.font, strCHN, color[1], color[2], color[3])
	--if not s then return end
	--local w, h = s:getSize()
	--local t, tw, th = s:glTexture()
	local gen, max_lines, max_w = self.font:draw(strCHN, strCHN:toTString():maxWidth(self.font), color[1], color[2], color[3])
	if not gen or not gen[1] then return end
	local f = {
		item = gen[1],
		x=x,
		y=y,
		w=gen[1].w, h=gen[1].h,
		duration=duration or 10,
		xvel = xvel or 0,
		yvel = yvel or 0,
		t = t,
	}
	f.popout_dur = math.max(3, math.floor(f.duration / 4))
	self.flyers[f] = true
	return f
end

--- Removes all FlyingText
function _M:empty()
	self.flyers = {}
end

--- Display loop function
-- @int nb_keyframes
function _M:display(nb_keyframes)
	if not next(self.flyers) then return end

	local dels = {}

	for fl, _ in pairs(self.flyers) do
		local zoom = nil
		local x, y = -fl.w / 2, -fl.h / 2
		local tx, ty = fl.x, fl.y
		core.display.glTranslate(tx, ty, 0)

		if fl.duration <= fl.popout_dur then
			zoom = (fl.duration / fl.popout_dur)
			core.display.glScale(zoom, zoom, zoom)
		end

		if self.shadow then fl.item._tex:toScreenFull(x+1, y+1, fl.item.w, fl.item.h, fl.item._tex_w, fl.item._tex_h, 0, 0, 0, self.shadow) end
		fl.item._tex:toScreenFull(x, y, fl.item.w, fl.item.h, fl.item._tex_w, fl.item._tex_h)

		-- if self.shadow then fl.t:toScreenFull(x+1, y+1, fl.w, fl.h, fl.tw, fl.th, 0, 0, 0, self.shadow) end
		-- fl.t:toScreenFull(x, y, fl.w, fl.h, fl.tw, fl.th)
		fl.x = fl.x + fl.xvel * nb_keyframes
		fl.y = fl.y + fl.yvel * nb_keyframes
		fl.duration = fl.duration - nb_keyframes

		if zoom then core.display.glScale() end
		core.display.glTranslate(-tx, -ty, 0)

		-- Delete the flyer
		if fl.duration <= 0 then
			dels[#dels+1] = fl
		end
	end

	for i, fl in ipairs(dels) do self.flyers[fl] = nil end
end
