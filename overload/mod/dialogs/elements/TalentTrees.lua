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
local Tiles = require "engine.Tiles"

--- A talent trees display
module(..., package.seeall, class.inherit(Base, Focusable))

function _M:init(t)
	self.tiles = assert(t.tiles, "no Tiles class")
	self.tree = t.tree or {}
	self.w = assert(t.width, "no width")
	self.h = assert(t.height, "no height")
	self.tooltip = assert(t.tooltip, "no tooltip")
	self.on_use = assert(t.on_use, "no on_use")
	self.on_expand = t.on_expand
	
	self.no_cross = t.no_cross
	self.dont_select_top = t.dont_select_top
	self.no_tooltip = t.no_tooltip
	self.clip_area = t.clip_area or { w = self.w, h = self.h }

	self.icon_size = 48
	self.frame_size = 50
	self.icon_offset = 1
	self.frame_offset = 5
	_, self.fh = self.font:size("")
	self.fh = self.fh - 2
	
	self.scrollbar = t.scrollbar
	self.scroll_inertia = 0
	
	self.shadow = 0.7
	self.last_input_was_keyboard = false

	self.frame_sel = self:makeFrame("ui/selector-sel", self.frame_size, self.frame_size)
	self.frame_usel = self:makeFrame("ui/selector", self.frame_size, self.frame_size)
	self.talent_frame = self:makeFrame("ui/icon-frame/frame", self.frame_size, self.frame_size)
	self.plus = _M:getUITexture("ui/plus.png")
	self.minus = _M:getUITexture("ui/minus.png")
	self.tiles = Tiles.new(iw, ih, self.fontname or "/data/font/DroidSansMono.ttf", self.fontsize or 10, true, true)
	self.tiles.use_images = true
	self.tiles.force_back_color = {r=0, g=0, b=0}

	Base.init(self, t)
end

function _M:generate()
	self.mouse:reset()
	self.key:reset()
	
	-- generate the scrollbar
	self.scroll_inertia = 0
	self.scroll = 0
	if self.scrollbar then self.scrollbar = Slider.new{size=self.h, max=10000} end
	
	self.sel_i = 1
	self.sel_j = 1
	self.max_h = 0
	
	self.mousezones = {}
	self:redrawAllItems()
	
	-- Add UI controls
	self.mouse:registerZone(0, 0, self.w, self.h, function(button, x, y, xrel, yrel, bx, by, event)
		self.last_input_was_keyboard = false

		if event == "button" and button == "wheelup" then if self.scrollbar then self.scroll_inertia = math.min(self.scroll_inertia, 0) - 5 end
		elseif event == "button" and button == "wheeldown" then if self.scrollbar then self.scroll_inertia = math.max(self.scroll_inertia, 0) + 5 end
		end

		if button == "middle" and self.scrollbar then
			if not self.scroll_drag then
				self.scroll_drag = true
				self.scroll_drag_x_start = x
				self.scroll_drag_y_start = y
			else
				self.scrollbar.pos = util.minBound(self.scrollbar.pos + y - self.scroll_drag_y_start, 0, self.scrollbar.max)
				self.scroll_drag_x_start = x
				self.scroll_drag_y_start = y
			end
		else
			self.scroll_drag = false
		end

		y = y - (self.scrollbar and -self.scrollbar.pos or 0)

		local done = false
		for i = 1, #self.mousezones do
			local mz = self.mousezones[i]
			if x >= mz.x1 and x <= mz.x2 and y >= mz.y1 and y <= mz.y2 then
				if not self.last_mz or mz.item ~= self.last_mz.item then
					self.last_mz = mz
					self:updateTooltip()
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

--[[
		if self.last_mz and event == "button" and (button == "left" or button == "right") then
			if self.last_mz.item.type then
				if x - self.last_mz.x1 >= self.plus.w then self:onUse(self.last_mz.item, button == "left")
				elseif not self.no_cross then self:onExpand(self.last_mz.item, button == "left") end
			else
				self:onUse(self.last_mz.item, button == "left")
			end
		end
]]
	end)
	self.key:addBinds{
		ACCEPT = function() if self.last_mz then self:onUse(self.last_mz.item, true) end end,
		MOVE_UP = function() self.last_input_was_keyboard = true self:moveSel(-1, 0) end,
		MOVE_DOWN = function() self.last_input_was_keyboard = true self:moveSel(1, 0) end,
		MOVE_LEFT = function() self.last_input_was_keyboard = true self:moveSel(0, -1) end,
		MOVE_RIGHT = function() self.last_input_was_keyboard = true self:moveSel(0, 1) end,
	}
	self.key:addCommands{
		[{"_RETURN","ctrl"}] = function() if self.last_mz then self:onUse(self.last_mz.item, false) end end,
		[{"_UP","ctrl"}] = function() self.last_input_was_keyboard = false if self.scrollbar then self.scroll_inertia = math.min(self.scroll_inertia, 0) - 5 end end,
		[{"_DOWN","ctrl"}] = function() self.last_input_was_keyboard = false if self.scrollbar then self.scroll_inertia = math.max(self.scroll_inertia, 0) + 5 end end,
		_HOME = function() if self.scrollbar then self.scrollbar.pos = 0 self.last_input_was_keyboard = true self:moveSel(0, 0) end end,
		_END = function() if self.scrollbar then self.scrollbar.pos = self.scrollbar.max self.last_input_was_keyboard = true self:moveSel(0, 0) end end,
		_PAGEUP = function() if self.scrollbar then self.scrollbar.pos = util.minBound(self.scrollbar.pos - self.h, 0, self.scrollbar.max) self.last_input_was_keyboard = true self:moveSel(0, 0) end end,
		_PAGEDOWN = function() if self.scrollbar then self.scrollbar.pos = util.minBound(self.scrollbar.pos + self.h, 0, self.scrollbar.max) self.last_input_was_keyboard = true self:moveSel(0, 0) end end,
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
		self.scrollbar.max = self.max_h
		self.scrollbar.pos = util.minBound(self.scrollbar.pos, 0, self.scrollbar.max)
	end
	item.h = current_h
	self.last_scroll = nil
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
	local match = nil

	if i == 0 then
		local t = self.tree[self.sel_i]
		if t.nodes then
			self.sel_j = util.bound(self.sel_j + j, 1, #t.nodes)
			match = t.nodes[self.sel_j]
		end
	elseif i == 1 then
		local t = self.tree[self.sel_i]
		if t.shown and self.sel_j == 0 and t.nodes and #t.nodes > 0 then
			self.sel_j = 1
			match = t.nodes[1]
		else
			self.sel_i = util.bound(self.sel_i + i, 1, #self.tree)
			self.sel_j = 0
			local t = self.tree[self.sel_i]
			match = t
		end
	elseif i == -1 then
		local t = self.tree[self.sel_i]
		if t.shown and self.sel_j > 0 and t.nodes and #t.nodes > 0 then
			self.sel_j = 0
			match = t
		else
			self.sel_i = util.bound(self.sel_i + i, 1, #self.tree)
			local t = self.tree[self.sel_i]
			if t.shown and t.nodes and #t.nodes > 0 then
				self.sel_j = 1
				match = t.nodes[1]
			else
				self.sel_j = 0
				match = t
			end
		end
	end

	for i = 1, #self.mousezones do
		local mz = self.mousezones[i]
		if mz.item == match then self.last_mz = mz break end
	end

	if self.scrollbar and self.last_input_was_keyboard then
		local pos = 0
		for i = 1, #self.tree do
			local tree = self.tree[i]
			pos = pos + tree.h
			-- we've reached selected row
			if self.sel_i == i then
				-- check if it was visible if not go scroll over there
				if pos - tree.h < self.scrollbar.pos then self.scrollbar.pos = util.minBound(pos - tree.h, 0, self.scrollbar.max)
				elseif pos > self.scrollbar.pos + self.h then self.scrollbar.pos = util.minBound(pos - self.h, 0, self.scrollbar.max)
				end
				break
			end
		end
	end

	self:updateTooltip()
end

function _M:drawItem(item)
	if item.stat then
		local str = item:status():toString()
		local d = self.font:draw(str, self.font:size(str), 255, 255, 255, true)[1]
		item.text_status = d
	elseif item.type_stat then
		local str = item.name:toString()
		self.font:setStyle("bold")
		local d = self.font:draw(str, self.font:size(str), 255, 255, 255, true)[1]
		self.font:setStyle("normal")
		item.text_status = d
	elseif item.talent then
		local str = item:status():toString()
		local d = self.font:draw(str, self.font:size(str), 255, 255, 255, true)[1]
		item.text_status = d
	elseif item.type then
		local str = item:rawname():toString()
		local c = item:color()
		self.font:setStyle("bold")
		local d = self.font:draw(str, self.font:size(str), c[1], c[2], c[3], true)[1]
		self.font:setStyle("normal")
		item.text_status = d
		if ((not self.no_cross) and self.plus.w + 3 or 0) + item.text_status.w > self.w - (self.scrollbar and self.scrollbar.sel.w * 0.8 or 0) + 10 then
			item.text_status.display_offset = { x_dir = 0, x = 0 }
		end
	end
end

function _M:on_focus_change(status)
	--remember scrollbar
	local old_pos
	if self.scrollbar then old_pos = self.scrollbar.pos end
	self.last_input_was_keyboard = true
	if status then
		self.prev_item = nil
		self.focus_decay = focus_decay_max * 32
		if not self.last_mz then
			for i = 1, #self.tree do
				local tree = self.tree[i]
				if tree.text_status then
					self.sel_i = i
					self.sel_j = 0
					self:moveSel(0, 0)
					break
				end
				if tree.shown then
					for j = 1, #tree.nodes do
						self.sel_i = i
						self.sel_j = j
						self:moveSel(0, 0)
						break
					end
				end
			end
		end
	end
	if self.scrollbar then self.scrollbar.pos = old_pos end
end


function _M:redrawAllItems()
	for i = 1, #self.tree do
		local tree = self.tree[i]
		self:drawItem(tree)
		for j = 1, #tree.nodes do
			local tal = tree.nodes[j]
			if not tal.texture then tal.texture = self.tiles:loadImage(tal.entity.image):glTexture() end
			self:drawItem(tal)
		end
	end

	-- calculate each tree items height
	self.max_h = 0
	for i = 1, #self.tree do
		local dy = 0
		local tree = self.tree[i]

		if tree.text_status then
			local key = tree.text_status
			dy = dy + key.h + 4
		end
		local addh = 0
		if tree.shown then for j = 1, #tree.nodes do
			local tal = tree.nodes[j]
			if tal.text_status then
				local key = tal.text_status
				addh = key.h
			end
			addh = addh + self.frame_size
		end end
		dy = dy + addh + 12
		tree.h = dy
		self.max_h = self.max_h + dy
	end
	
	-- generate the scrollbar
	if self.scrollbar then self.scrollbar.max = self.max_h end
end

function _M:on_select(item, force)
	if self.prev_item == item and not force then return end
	local str, fx, fy = self.tooltip(item)
	local tx,ty = fx or (self.last_display_x + self.last_mz.x2), fy or (self.last_display_y + self.last_mz.y1)
	if not self.no_tooltip then game:tooltipDisplayAtMap(tx, ty, str) end
	self.prev_item = item
end

function _M:display(x, y, nb_keyframes, screen_x, screen_y)
	self.last_display_bx = x
	self.last_display_by = y
	self.last_display_x = screen_x
	self.last_display_y = screen_y

	if self.focus_decay then
		core.display.drawQuad(x, y, self.w, self.h, 255, 255, 255, self.focus_decay * self.one_by_focus_decay)
		self.focus_decay = self.focus_decay - nb_keyframes * 64
		if self.focus_decay <= 0 then self.focus_decay = nil end
	end

	if self.scrollbar then
		local tmp_pos = self.scrollbar.pos
		self.scrollbar.pos = util.minBound(self.scrollbar.pos + self.scroll_inertia, 0, self.scrollbar.max)
		if self.scroll_inertia > 0 then self.scroll_inertia = math.max(self.scroll_inertia - 1, 0)
		elseif self.scroll_inertia < 0 then self.scroll_inertia = math.min(self.scroll_inertia + 1, 0)
		end
		if self.scrollbar.pos == 0 or self.scrollbar.pos == self.scrollbar.max then self.scroll_inertia = 0 end
	end

	local mz = {}
	if not self.scrollbar or self.last_scroll ~= self.scrollbar.pos then self.mousezones = mz end

	local dx, dy = 0, self.scrollbar and -self.scrollbar.pos or 0
	local bdx, bdy = dx, dy

	core.display.glScissor(true, screen_x, screen_y, self.w, self.h)

	if self.last_mz then
		self:drawFrame(self.focused and self.frame_sel or self.frame_usel, dx+x+self.last_mz.x1-2, dy+y+self.last_mz.y1-2, 1, 1, 1, 1, self.last_mz.x2-self.last_mz.x1+4, self.last_mz.y2-self.last_mz.y1+4)
	end

	self.max_display = 1
	for i = 1, #self.tree do
		local tree = self.tree[i]
 	
		if tree.text_status then
			local key = tree.text_status
			local cross = not tree.shown and self.plus or self.minus

			mz[#mz+1] = {i=i,j=1, name=tree.name, item=tree, x1=dx-bdx, y1=dy-bdy, x2=dx-bdx+cross.w + 3 + key.w, y2=dy-bdy+cross.h}

			if not self.no_cross then
				cross.t:toScreenFull(dx+x, dy+y + (-cross.h + key.h) / 2, cross.w, cross.h, cross.tw, cross.th)
				dx = dx + cross.w + 3
			end

			if self.shadow then key._tex:toScreenFull(dx+x + 2, dy+y + 2, key.w, key.h, key._tex_w, key._tex_h, 0, 0, 0, self.shadow) end
			key._tex:toScreenFull(dx+x, dy+y, key.w, key.h, key._tex_w, key._tex_h)
			dy = dy + key.h + 4
		end

		local addh = 0
		local startdx = dx
		if tree.shown then for j = 1, #tree.nodes do
			local tal = tree.nodes[j]

			tal.entity:toScreen(self.tiles, dx+x + self.icon_offset, dy+y + self.icon_offset, self.icon_size, self.icon_size)
			local do_shadow = util.getval(tal.do_shadow, tal) and 3 or 1
			if do_shadow > 1 then core.display.drawQuad(dx+x + self.icon_offset, dy+y + self.icon_offset, self.icon_size, self.icon_size, 0, 0, 0, 200) end

			local rgb = tal:color()
			self:drawFrame(self.talent_frame, dx+x, dy+y, rgb[1]/255 / do_shadow, rgb[2]/255 / do_shadow, rgb[3]/255 / do_shadow, 1)

			if tal.text_status then
				local key = tal.text_status
				if self.shadow then key._tex:toScreenFull(dx+x + (self.frame_size - key.w)/2 + 2, dy+y + self.frame_size + 4, key.w, key.h, key._tex_w, key._tex_h, 0, 0, 0, self.shadow) end
				key._tex:toScreenFull(dx+x + (self.frame_size - key.w)/2, dy+y + self.frame_size + 2, key.w, key.h, key._tex_w, key._tex_h)
				addh = key.h
			end

			mz[#mz+1] = {i=i, j=j, name=tal.name, item=tal, x1=dx-bdx, y1=dy-bdy, x2=dx+self.frame_size-bdx, y2=dy-bdy+self.frame_size+addh}

			if tal.break_line then
				dx = startdx
				dy = dy + self.frame_size + addh + 8
			else
				dx = dx + self.frame_size + self.frame_offset
				addh = addh + self.frame_size
			end
		end end
		--self.max_display = i - self.scroll + 1
		dx = 0
		dy = dy + addh + 12
		if dy >= self.h then break end
	end

	core.display.glScissor(false)

	if self.focused and self.scrollbar then
--		self.scrollbar.pos = self.scroll
		self.scrollbar:display(x + self.w - self.scrollbar.w, y)

		self.last_scroll = self.scrollbar.pos
	end
end
