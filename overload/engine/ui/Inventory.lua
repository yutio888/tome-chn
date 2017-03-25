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
local Focusable = require "engine.ui.Focusable"
local ImageList = require "engine.ui.ImageList"
local ListColumns = require "engine.ui.ListColumns"
local KeyBind = require "engine.KeyBind"
local UIGroup = require "engine.ui.UIGroup"

--- A generic inventory, with possible tabs
-- @classmod engine.ui.Inventory
module(..., package.seeall, class.inherit(Base, Focusable, UIGroup))

function _M:init(t)
	self.inven = assert(t.inven, "no inventory inven")
	self.actor = assert(t.actor, "no inventory actor")
	self.w = assert(t.width, "no inventory width")
	self.h = assert(t.height, "no inventory height")
	self.tabslist = t.tabslist
	self.columns = t.columns
	self.filter = t.filter
	self.fct = t.fct
	self.on_select = t.select
	self.on_select_tab = t.select_tab
	self.on_drag = t.on_drag
	self.on_drag_end = t.on_drag_end
	self.on_focus_change = t.on_focus_change
	self.special_bg = t.special_bg
	self.default_last_tabs = t.default_last_tabs

	self._last_x, _last_y, self._last_ox, self._last_oy = 0, 0, 0, 0

	if self.tabslist == nil and self.default_tabslist then
		if type(self.default_tabslist) == "function" then self.tabslist = self.default_tabslist(self)
		else self.tabslist = self.default_tabslist
		end
	end

	Base.init(self, t)
end

function _M:generate()
	self.mouse:reset()
	self.key:reset()

	self.uis = {}

	if self.tabslist then
		self.c_tabs = ImageList.new{width=self.w, height=36, tile_w=32, tile_h=32, padding=5, force_size=true, selection="ctrl-multiple", list=self.tabslist,
			fct=function() self:generateList() end,
			on_select=function(item, how) self:selectTab(item, how) end
		}

		if self.default_last_tabs and not _M._last_tabs then
			self:updateTabFilterList({{data={filter=self.default_last_tabs}}})
			for i = 1, #self.tabslist do if self.tabslist[i].kind == self.default_last_tabs then _M._last_tabs_i = i end end
		end

		self.c_tabs.no_keyboard_focus = true

		local found_tab = false
		if _M._last_tabs then -- reselect previously selected tabs if possible
			local sel_all = _M._last_tabs.all
			local last_kinds = {}
			for _, lt in ipairs(_M._last_tabs) do if lt.kind then last_kinds[lt.kind] = true end end
			for j, row in ipairs(self.c_tabs.dlist) do for i, item in ipairs(row) do
				if sel_all or last_kinds[item.data.kind] then
					item.selected = true
					found_tab = true
					self.c_tabs.sel_i, self.c_tabs.sel_j = i, j
					if sel_all and item.data.filter=="all" then _M._last_tabs_i = i end
				end
			end end
		end
		if not found_tab then
			self.c_tabs.sel_i, self.c_tabs.sel_j = 1, 1
			self.c_tabs.dlist[1][1].selected = true
		end

		self.uis[#self.uis+1] = {x=0, y=0, ui=self.c_tabs}
		self.c_tabs.on_focus_change = function(ui_self, status)
			if status == true then
				local item = ui_self.dlist[ui_self.sel_j] and ui_self.dlist[ui_self.sel_j][ui_self.sel_i]
				self.on_select(item, true)
			end
		end
	end

	local direct_draw= function(item, x, y, w, h, total_w, total_h, loffset_x, loffset_y, dest_area)
		-- if there is object and is withing visible bounds
		if core.display.FBOActive() and item.object and total_h + h > loffset_y and total_h < loffset_y + dest_area.h then
			local clip_y_start, clip_y_end = 0, 0
			-- if it started before visible area then compute its top clip
			if total_h < loffset_y then
				clip_y_start = loffset_y - total_h
			end
			-- if it ended after visible area then compute its bottom clip
			if total_h + h > loffset_y + dest_area.h then
				clip_y_end = total_h + h - loffset_y - dest_area.h
			end
			-- get entity texture with everything it has i.e particles
			local texture = item.object:getEntityFinalTexture(nil, h, h)
			if not texture then return 0, 0, 0, 0, 0, 0 end
			local one_by_tex_h = 1 / h
			texture:toScreenPrecise(x, y, h, h - clip_y_start - clip_y_end, 0, 1, clip_y_start * one_by_tex_h, (h - clip_y_end) * one_by_tex_h)
			return h, h, 0, 0, clip_y_start, clip_y_end
		end
		return 0, 0, 0, 0, 0, 0
	end

	self.c_inven = ListColumns.new{width=self.w, height=self.h - (self.c_tabs and self.c_tabs.h or 0), sortable=true, scrollbar=true, columns=self.columns or {
		{name="", width={33,"fixed"}, display_prop="char", sort="id"},
		{name="", width={24,"fixed"}, display_prop="object", sort="sortname", direct_draw=direct_draw},
		{name="物品", width=72, display_prop="name", sort="sortname"},
		{name="分类", width=20, display_prop="cat", sort="cat"},
		{name="负重", width=10, display_prop="encumberance", sort="encumberance"},
	}, list={},
		fct=function(item, sel, button, event) if self.fct then self.fct(item, button, event) end end,
		select=self.on_select,
		on_drag=function(item) if self.on_drag then self.on_drag(item) end end,
		on_drag_end=function() if self.on_drag_end then self.on_drag_end() end end,
	}

	self.c_inven.mouse.delegate_offset_x = 0
	self.c_inven.mouse.delegate_offset_y = self.c_tabs and self.c_tabs.h or 0

	self.uis[#self.uis+1] = {x=0, y=self.c_tabs and self.c_tabs.h or 0, ui=self.c_inven}

	self:generateList()

	self.mouse:registerZone(0, 0, self.w, self.h, function(button, x, y, xrel, yrel, bx, by, event)
		self:mouseEvent(button, x, y, xrel, yrel, bx, by, event)
	end)
	self.key = self.c_inven.key
	self.key:addCommands{
		_TAB = function() if not self.c_tabs then return end self.c_tabs.sel_j = 1 self.c_tabs.sel_i = util.boundWrap(self.c_tabs.sel_i+1, 1, #self.tabslist) self.c_tabs:onUse("left") self.c_tabs:onSelect("key") end,
		[{"_TAB","ctrl"}] = function() if not self.c_tabs then return end self.c_tabs.sel_j = 1 self.c_tabs.sel_i = util.boundWrap(self.c_tabs.sel_i-1, 1, #self.tabslist) self.c_tabs:onUse("left", false) self.c_tabs:onSelect("key") end,
	}
	if self.tabslist then
		for i = 1, #self.tabslist do
			self.key:addCommands{
				['_F'..i] = function() self.c_tabs.sel_j = 1 self.c_tabs.sel_i = i self.c_tabs:onUse("left") self.c_tabs:onSelect("key") end,
				[{'_F'..i,"ctrl"}] = function() self.c_tabs.sel_j = 1 self.c_tabs.sel_i = i self.c_tabs:onUse("left", true) self.c_tabs:onSelect("key") end,
			}
		end
	end

	self.c_inven:onSelect()
end

function _M:keyTrigger(c)
	if not self.focus_ui or not self.focus_ui.ui == self.c_inven then return end

	if self.inven_list.chars[c] then
		self.c_inven.sel = self.inven_list.chars[c]
		self.c_inven.key:triggerVirtual("ACCEPT")
	end
end

function _M:switchTab(filter)
	if not self.c_tabs then return end

	for i, d in ipairs(self.tabslist) do
		for k, e in pairs(filter) do if d[k] == e then
			self.c_tabs.sel_j = 1 self.c_tabs.sel_i = i
			self.c_tabs:onUse("left", false)
			self.c_tabs:onSelect("key")
			return
		end end
	end
end

function _M:selectTab(item, how)
	if self.on_select_tab then self.on_select_tab(item) end
	if how == "key" then self.c_inven:onSelect() end
end

function _M:mouseEvent(button, x, y, xrel, yrel, bx, by, event)
	-- Look for focus
	for i = 1, #self.uis do
		local ui = self.uis[i]
		if ui.ui.can_focus and bx >= ui.x and bx <= ui.x + ui.ui.w and by >= ui.y and by <= ui.y + ui.ui.h then
			self:setInnerFocus(i)

			-- Pass the event
			ui.ui.mouse:delegate(button, bx, by, xrel, yrel, bx, by, event)
			return
		end
	end
	self:no_focus()
end

function _M:keyEvent(...)
	if not self.focus_ui or not self.focus_ui.ui.key:receiveKey(...) then
		return KeyBind.receiveKey(self.key, ...)
	end
end

function _M:updateTabFilter()
	if not self.c_tabs then return end

	local list = self.c_tabs:getAllSelected()
	self:updateTabFilterList(list)
end

function _M:updateTabFilterList(list)
	local checks = {}
	local is_all = false

	-- Check if we selected all tabs
	for i, item in ipairs(list) do
		if item.data.filter == "all" then
			is_all = true
			for i, row in ipairs(self.c_tabs.dlist) do for j, item in ipairs(row) do item.selected = item.data.filter ~= "all" end end
			list = self.c_tabs:getAllSelected()
		end
	end

	for i, item in ipairs(list) do
		if item.data.filter == "others" then
			local misc
			misc = function(o)
				-- Anything else
				for i, item in ipairs(self.tabslist) do
					if type(item.filter) == "function" and item.filter(o) then return false end
				end
				return true
			end
			checks[#checks+1] = misc
		elseif type(item.data.filter) == "function" then
			checks[#checks+1] = item.data.filter
		end
	end

	self.tab_filter = function(o)
		for i = 1, #checks do if checks[i](o) then return true end end
		return false
	end

	-- Save for next dialog
	if not self.dont_update_last_tabs then
		_M._last_tabs = self.c_tabs:getAllSelectedKeys()
		if not is_all then
			local i = 1
			for _, d in ipairs(_M._last_tabs) do
				i = math.max(i, d[2]) d.kind = self.c_tabs.dlist[d[1]][d[2]].data.kind
			end
			_M._last_tabs_i = i
		else
			_M._last_tabs.all = true
			_M._last_tabs_i = #self.tabslist
		end
	end
end

function _M:generateList(no_update)
	self:updateTabFilter()

	-- Makes up the list
	self.inven_list = {}
	local list = self.inven_list
	local chars = {}
	local i = 1
	for item, o in ipairs(self.inven) do
		if (not self.filter or self.filter(o)) and (not self.tab_filter or self.tab_filter(o)) then
			local char = self:makeKeyChar(i)

			local enc = 0
			o:forAllStack(function(o) enc=enc+o.encumber end)

			list[#list+1] = { id=#list+1, char=char, name=o:getName(), sortname=o:getName():toString():removeColorCodes(), color=o:getDisplayColor(), object=o, inven=self.actor.INVEN_INVEN, item=item, cat=objectSType[o.subtype] or o.subtype, encumberance=enc, special_bg=self.special_bg }
			chars[char] = #list
			i = i + 1
		end
	end
	list.chars = chars

	if not no_update then
		self.c_inven:setList(self.inven_list)
		if self._last_x then self:display(self._last_x, _last_y, 0, self._last_ox, self._last_oy) end
	end
end

function _M:display(x, y, nb_keyframes, ox, oy)
	self._last_x, _last_y, self._last_ox, self._last_oy = x, y, ox, oy

	-- UI elements
	for i = 1, #self.uis do
		local ui = self.uis[i]
		if not ui.hidden then ui.ui:display(x + ui.x, y + ui.y, nb_keyframes, ox + ui.x, oy + ui.y) end
	end
end
