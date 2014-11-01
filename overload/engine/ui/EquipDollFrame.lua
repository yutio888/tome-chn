-- TE4 - T-Engine 4
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

require "engine.class"
local Base = require "engine.ui.Base"
local Focusable = require "engine.ui.Focusable"

module(..., package.seeall, class.inherit(Base, Focusable))

_M.font = core.display.newFont("/data-chn123/font/main.ttf", 10)
_M.font_h = _M.font:lineSkip()

function _M:init(t)
	self.actor = assert(t.actor, "no equipdollframe actor")
	self.inven = assert(t.inven, "no equipdollframe inven")
	self.item = assert(t.item, "no equipdollframe item")
	self.w = assert(t.w, "no equipdollframe w")
	self.h = assert(t.h, "no equipdollframe h")
	self.f_iw = assert(t.iw, "no equipdollframe iw")
	self.f_ih = assert(t.ih, "no equipdollframe ih")
	self.f_ix = assert(t.ix, "no equipdollframe ix")
	self.f_iy = assert(t.iy, "no equipdollframe iy")
	self.bg = assert(t.bg, "no equipdollframe bg")
	self.bg_sel = assert(t.bg_sel, "no equipdollframe bg_sel")
	self.bg_empty = t.bg_empty
	self.drag_enable = t.drag_enable
	self.fct = t.fct
	self.filter = t.filter
	self.name_pos = t.name_pos
	self.subobject = t.subobject
	self.font = core.display.newFont("/data-chn123/font/main.ttf", 10)

	Base.init(self, t)
end

function _M:generate()
	self.mouse:reset()
	self.key:reset()

	self.bg = self:getUITexture(self.bg)
	self.bg_sel = self:getUITexture(self.bg_sel)
	if self.bg_empty then self.bg_empty = self:getUITexture(self.bg_empty) end

	self.mouse:registerZone(0, 0, self.w, self.h, function(button, x, y, xrel, yrel, bx, by, event)
		if button == "left" and event == "button" then self:onUse(button, event) end
		if event == "motion" and button == "left" and self:getItem() then self:onDrag(self.inven, self.item, self:getItem())
		elseif button == "drag-end" and self.drag_enable then
			local drag = game.mouse.dragged.payload
--			print(table.serialize(drag,nil,true))
			if drag.kind == "inventory" and drag.inven and self.actor:getInven(drag.inven) and not self.actor:getInven(drag.inven).worn then
				self:actorWear(drag.inven, drag.item_idx, drag.object)
				game.mouse:usedDrag()
			end
		end
	end)
	self.key:addBinds{
		ACCEPT = function() self:onUse("left", "key") end,
	}
end

function _M:getItem()
	local o = self.inven[self.item]
	if not o then return end
	if self.subobject then o = o[self.subobject](o) if not o then return end end
	if self.filter and not self.filter(o) then return end
	return o
end

function _M:onUse(...)
	if not self.fct then return end
	self:sound("button")
	self.fct(...)
end

-- Overload to do as you need
function _M:actorWear(inven, item, o)
end

function _M:onDrag(inven, item, o)
	if not self.drag_enable then return end
	if o then
		local s = o:getEntityFinalSurface(nil, 64, 64)
		local x, y = core.mouse.get()
		game.mouse:startDrag(x, y, s, {kind="inventory", item_idx=item, inven=inven, object=o, id=o:getName{no_add_name=true, force_id=true, no_count=true}}, function(drag, used)
			local x, y = core.mouse.get()
			game.mouse:receiveMouse("drag-end", x, y, true, nil, {drag=drag})
		end)
	end
end

function _M:drawItemShortName(o, x, y)
	if not o then return end

	local t = nil
	if self.last_o == o then
		t = self.last_t
	else
		--汉化
		local name = o:getName({do_color=true, no_image=true, no_add_name=true})
		--local name = (o.getShortName or o.getName)(o, {do_color=true, no_image=true, no_add_name=true}):toString()
		t = self.font:draw(name, self.font:size(name), 255, 255, 255)[1]
	end

	if not self.name_pos then
		x = x - (t.w - self.w) / 2
		y = y - t.h
	elseif self.name_pos == "bottom" then
		x = x - (t.w - self.w) / 2
		y = y + self.h
	elseif self.name_pos == "topleft" then
		x = x - t.w + self.w
		y = y - t.h
	elseif self.name_pos == "topright" then
		x = x
		y = y - t.h
	end

	t._tex:toScreenFull(x, y, t.w, t.h, t._tex_w, t._tex_h)
--	if self.text_shadow then t._tex:toScreenFull(x - (t.w - self.w) / 2 + 1, y - t.h + 1, t.w, t.h, t._tex_w, t._tex_h, 0, 0, 0, self.text_shadow) end

	self.last_t = t
	self.last_o = o
end

function _M:display(x, y, nb_keyframes, ox, oy)
	if self.focused then
		self.bg_sel.t:toScreenFull(x, y, self.w, self.h, self.bg_sel.tw, self.bg_sel.th)
	else
		self.bg.t:toScreenFull(x, y, self.w, self.h, self.bg.tw, self.bg.th)
	end

	local o = self:getItem()
	if o and o.toScreen then
		o:toScreen(nil, x + self.f_ix, y + self.f_iy, self.f_iw, self.f_ih)
	elseif self.bg_empty then
		self.bg_empty.t:toScreenFull(x + self.f_ix, y + self.f_iy, self.f_iw, self.f_ih, self.bg_empty.tw, self.bg_empty.th)
	end

	self:drawItemShortName(o, x, y)

	self.last_display_x = ox
	self.last_display_y = oy
end
