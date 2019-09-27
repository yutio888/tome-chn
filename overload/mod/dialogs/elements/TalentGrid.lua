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
local Base = require "engine.ui.Base"
local Focusable = require "engine.ui.Focusable"
local Slider = require "engine.ui.Slider"

--- A talent trees display
module(..., package.seeall, class.inherit(Base, Focusable))

function _M:init(t)
	self.tiles = assert(t.tiles, "no Tiles class")
	self.grid = t.grid or {}
	self.w = assert(t.width, "no width")
	self.h = assert(t.height, "no height")
	self.tooltip = assert(t.tooltip, "no tooltip")
	self.on_use = assert(t.on_use, "no on_use")
	self.on_expand = t.on_expand

	self.icon_size = 48
	self.frame_size = 50
	self.icon_offset = 1
	self.frame_offset = 5
	
	self.scrollbar = t.scrollbar
	self.scroll_inertia = 0
	
	self.frame_sel = self:makeFrame("ui/selector-sel", self.frame_size, self.frame_size)
	self.frame_usel = self:makeFrame("ui/selector", self.frame_size, self.frame_size)
	self.talent_frame = self:makeFrame("ui/icon-frame/frame", self.frame_size, self.frame_size)

	Base.init(self, t)
end

function _M:generate()
	self.mouse:reset()
	self.key:reset()
	
	-- generate the scrollbar
	if self.scrollbar then self.scrollbar = Slider.new{size=self.h, max=1} end
	
	self.sel_i = 1
	self.sel_j = 1
	self.max_h = self.grid.max * (self.frame_size + self.frame_offset)

	if self.scrollbar then self.scrollbar.max = self.max_h - self.h end
	
	self.mousezones = {}
	self:redrawAllItems()
	
	-- Add UI controls
	self.mouse:registerZone(0, 0, self.w, self.h, function(button, x, y, xrel, yrel, bx, by, event)
		if event == "button" and button == "wheelup" then if self.scrollbar then self.scroll_inertia = math.min(self.scroll_inertia, 0) - 5 end
		elseif event == "button" and button == "wheeldown" then if self.scrollbar then self.scroll_inertia = math.max(self.scroll_inertia, 0) + 5 end
		end

		local done = false
		for i = 1, #self.mousezones do
			local mz = self.mousezones[i]
			if x >= mz.x1 and x <= mz.x2 and y >= mz.y1 and y <= mz.y2 then
				if not self.last_mz or mz.item ~= self.last_mz.item then
					self.tooltip(mz.item)
				end

				if event == "button" and (button == "left" or button == "right") then
					if mz.item.type then
						if x - mz.x1 >= self.plus.w then self:onUse(mz.item, button == "left")
						else self:onExpand(mz.item, button == "left") end
					else
						self:onUse(mz.item, button == "left")
					end
				end

				self.last_mz = mz
				self.sel_i = mz.i
				self.sel_j = mz.j
				done = true
				break
			end
		end
		if not done then game.tooltip_x = nil self.last_mz = nil end

	end)
	self.key:addBinds{
		ACCEPT = function() if self.last_mz then self:onUse(self.last_mz.item, true) end end,
		MOVE_UP = function() self.last_input_was_keyboard = true self:moveSel(0, -1) end,
		MOVE_DOWN = function() self.last_input_was_keyboard = true self:moveSel(0, 1) end,
		MOVE_LEFT = function() self.last_input_was_keyboard = true self:moveSel(-1, 0) end,
		MOVE_RIGHT = function() self.last_input_was_keyboard = true self:moveSel(1, 0) end,
	}
	self.key:addCommands{
		[{"_RETURN","ctrl"}] = function() if self.last_mz then self:onUse(self.last_mz.item, false) end end,
		[{"_UP","ctrl"}] = function() self.last_input_was_keyboard = false if self.scrollbar then self.scroll_inertia = math.min(self.scroll_inertia, 0) - 5 end end,
		[{"_DOWN","ctrl"}] = function() self.last_input_was_keyboard = false if self.scrollbar then self.scroll_inertia = math.max(self.scroll_inertia, 0) + 5 end end,
		_HOME = function() if self.scrollbar then self.scrollbar.pos = 0 end end,
		_END = function() if self.scrollbar then self.scrollbar.pos = self.scrollbar.max end end,
		_PAGEUP = function() if self.scrollbar then self.scrollbar.pos = util.minBound(self.scrollbar.pos - self.h, 0, self.scrollbar.max) end end,
		_PAGEDOWN = function() if self.scrollbar then self.scrollbar.pos = util.minBound(self.scrollbar.pos + self.h, 0, self.scrollbar.max) end end,
		_SPACE = function() if self.last_mz and self.last_mz.item.type then self:onExpand(self.last_mz.item) end end
	}
end

function _M:onUse(item, inc)
	self.on_use(item, inc)
end

function _M:onExpand(item, inc)
	item.shown = not item.shown
	local current_h = item.shown and (self.frame_size + 2 * self.fh + 16) or self.fh
	self.max_h = self.max_h + (item.shown and 1 or -1 ) * (self.frame_size + self.fh + 16)
	if self.scrollbar then 
		self.scrollbar.max = self.max_h - self.h 
		self.scrollbar.pos = util.minBound(self.scrollbar.pos, 0, self.scrollbar.max)
	end
	item.h = current_h
	if self.on_expand then self.on_expand(item) end
end

function _M:updateTooltip()
	if not self.last_mz then
		game.tooltip_x = nil
		return
	end
	local mz = self.last_mz
	local str = self.tooltip(mz.item)
	if not self.no_tooltip then game:tooltipDisplayAtMap(mz.tx or (self.last_display_x + mz.x2), mz.ty or (self.last_display_y + mz.y1), str) end
end

function _M:moveSel(i, j)
	if j ~= 0 then
		if j > 0 then
			if self.grid[self.sel_i][self.sel_j+1] then self.sel_j = self.sel_j + 1
			else self.sel_j = 1
			end
		else
			if self.grid[self.sel_i][self.sel_j-1] then self.sel_j = self.sel_j - 1
			else self.sel_j = #(self.grid[self.sel_i])
			end
		end
	end

	if i ~= 0 then
		self.sel_i = util.boundWrap(self.sel_i + i, 1, #self.grid)
	end
	self.sel_j = util.bound(self.sel_j, 1, #self.grid[self.sel_i])

	for i = 1, #self.mousezones do
		local mz = self.mousezones[i]
		if mz.item == self.grid[self.sel_i][self.sel_j] then self.last_mz = mz break end
	end
end

function _M:drawItem(item)
	if item.talent then
	end
end

function _M:redrawAllItems()
	for i = 1, #self.grid do
		local tree = self.grid[i]
		self:drawItem(tree)
		for j = 1, #tree do
			local tal = tree[j]
			self:drawItem(tal)
		end
	end
end

function _M:on_select(item, force)
	if self.prev_item == item and not force then return end
	local str, fx, fy = self.tooltip(item)
	tx,ty = fx or (self.last_display_x + self.last_mz.x2), fy or (self.last_display_y + self.last_mz.y1)
	if not self.no_tooltip then game:tooltipDisplayAtMap(tx, ty, str) end
	self.prev_item = item
end

function _M:display(x, y, nb_keyframes, screen_x, screen_y, offset_x, offset_y, local_x, local_y)
	offset_x = offset_x or 0

	self.last_display_bx = x
	self.last_display_by = y
	self.last_display_x = screen_x
	self.last_display_y = screen_y

	if self.scrollbar then
		local tmp_pos = self.scrollbar.pos
		self.scrollbar.pos = util.minBound(self.scrollbar.pos + self.scroll_inertia, 0, self.scrollbar.max)
		if self.scroll_inertia > 0 then self.scroll_inertia = math.max(self.scroll_inertia - 1, 0)
		elseif self.scroll_inertia < 0 then self.scroll_inertia = math.min(self.scroll_inertia + 1, 0)
		end
		if self.scrollbar.pos == 0 or self.scrollbar.pos == self.scrollbar.max then self.scroll_inertia = 0 end
	end

	local mz = {}
	self.mousezones = mz
	local dx, dy = 3, -self.scrollbar.pos + 3

	core.display.glScissor(true, screen_x, screen_y, self.w, self.h)

	if self.last_mz then
		self:drawFrame(self.focused and self.frame_sel or self.frame_usel, x+self.last_mz.x1-3, y+self.last_mz.y1-3, 1, 1, 1, 1, self.last_mz.x2-self.last_mz.x1+6, self.last_mz.y2-self.last_mz.y1+6)
	end

	for i = 1, #self.grid do
		local list = self.grid[i]
		local addw = 0

		for j = 1, #list do
			local tal = list[j]
			if tal then
				if tal.entity then
					tal.entity:toScreen(self.tiles, dx+x + self.icon_offset, dy+y + self.icon_offset, self.icon_size, self.icon_size)
					if util.getval(tal.do_shadow, tal) then core.display.drawQuad(dx+x + self.icon_offset, dy+y + self.icon_offset, self.icon_size, self.icon_size, 0, 0, 0, 200) end

					local rgb = tal:color()
					self:drawFrame(self.talent_frame, dx+x, dy+y, rgb[1]/255, rgb[2]/255, rgb[3]/255, 1)					

					mz[#mz+1] = {i=i, j=j, item=tal, x1=dx, y1=dy, x2=dx+self.frame_size+addw, y2=dy+self.frame_size}
				end

				dy = dy + self.frame_size + self.frame_offset

				if dy >= self.h then break end
			end
		end

		addw = addw + self.frame_size

		dy = -self.scrollbar.pos + 3
		dx = dx + addw + 12
	end
	core.display.glScissor(false)

	if self.focused and self.scrollbar and self.max_h > self.h then
		self.scrollbar:display(x + self.w - self.scrollbar.w, y)
	end
end
