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
local Tiles = require "engine.Tiles"
local Dialog = require "engine.ui.Dialog"
local ListColumns = require "engine.ui.ListColumns"
local TextzoneList = require "engine.ui.TextzoneList"
local Separator = require "engine.ui.Separator"
local Image = require "engine.ui.Image"
local Checkbox = require "engine.ui.Checkbox"

--- Dialog for showing achievements
--
-- See also: @{Achievement}
-- @classmod engine.dialogs.ShowAchievements
module(..., package.seeall, class.inherit(Dialog))

function _M:init(title, player)
	self.player = player
	local total = #world.achiev_defs
	local nb = 0
	for id, data in pairs(world.achieved) do nb = nb + 1 end

	Dialog.init(self, (title or "成就").." ("..nb.."/"..total..")", game.w * 0.8, game.h * 0.8)

	self.c_self = Checkbox.new{title="当前角色成就", default=false, fct=function() end, on_change=function(s) if s then self:switchTo("self") end end}
	self.c_main = Checkbox.new{title="所有完成的成就", default=true, fct=function() end, on_change=function(s) if s then self:switchTo("main") end end}
	self.c_all = Checkbox.new{title="所有成就", default=false, fct=function() end, on_change=function(s) if s then self:switchTo("all") end end}

	self.c_image = Image.new{file="trophy_gold.png", width=128, height=128, shadow=true}
	self.c_desc = TextzoneList.new{scrollbar=true, width=math.floor(self.iw * 0.4 - 10), height=self.ih - self.c_self.h}

	self:generateList("main")
	
	local direct_draw= function(item, x, y, w, h, total_w, total_h, loffset_x, loffset_y, dest_area)
		-- if there is object and is withing visible bounds
		if item.tex and total_h + h > loffset_y and total_h < loffset_y + dest_area.h then 
			local clip_y_start, clip_y_end = 0, 0
			-- if it started before visible area then compute its top clip
			if total_h < loffset_y then 
				clip_y_start = loffset_y - total_h
			end
			-- if it ended after visible area then compute its bottom clip
			if total_h + h > loffset_y + dest_area.h then 
			   clip_y_end = total_h + h - loffset_y - dest_area.h 
			end

			local one_by_tex_h = 1 / h
			item.tex[1]:toScreenPrecise(x, y, h, h - clip_y_start - clip_y_end, 0, 1, clip_y_start * one_by_tex_h, (h - clip_y_end) * one_by_tex_h)
			return h, h, 0, 0, clip_y_start, clip_y_end
		end 
		return 0, 0, 0, 0, 0, 0
	end

	self.c_list = ListColumns.new{width=math.floor(self.iw * 0.6 - 10), height=self.ih - 10 - self.c_self.h, floating_headers = true, scrollbar=true, sortable=true, columns={
		{name="", width={24,"fixed"}, display_prop="--", direct_draw=direct_draw},
		{name="成就", width=50, display_prop="name", sort="name"},
		{name="分类", width=20, display_prop="category", sort="category"},
		{name="完成时间", width=15, display_prop="when", sort="when"},
		{name="完成角色", width=15, display_prop="who", sort="who"},
	}, list=self.list, fct=function(item) end, select=function(item, sel) self:select(item) end}

	local sep = Separator.new{dir="horizontal", size=self.ih - 10 - self.c_self.h}
	self:loadUI{
		{left=0, top=0, ui=self.c_self},
		{left=self.c_self.w, top=0, ui=self.c_main},
		{left=self.c_self.w+self.c_main.w, top=0, ui=self.c_all},

		{left=0, top=self.c_self.h, ui=self.c_list},
		{left=self.c_list.w+sep.w+(self.c_desc.w-self.c_image.w)/2, top=self.c_self.h, ui= self.c_image},
		{left=self.c_list.w+sep.w, top=self.c_image.h + self.c_self.h, ui=self.c_desc},
		{left=self.iw * 0.6 - 5, top=self.c_self.h + 5, ui=sep},
	}
	self:setFocus(self.c_list)
	self:setupUI()

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}
end

function _M:switchTo(kind)
	self:generateList(kind)
	if kind == "self" then self.c_main.checked = false self.c_all.checked = false
	elseif kind == "main" then self.c_self.checked = false self.c_all.checked = false
	elseif kind == "all" then self.c_main.checked = false self.c_self.checked = false
	end

	self.c_list:setList(self.list)
	self.c_desc.items = {}
	self.c_desc:switchItem(nil)
end

function _M:select(item)
	if item then
		local also = ""
		if self.player and self.player.achievements and self.player.achievements[item.id] then
			also = "#GOLD#你的当前角色完成了这个成就。#LAST#\n"
		end
		self.c_image.item = item.tex
		self.c_image.iw = item.tex[6]
		self.c_image.ih = item.tex[7]
		local track = self:getTrack(item.a)
		local desc = ("#GOLD#完成时间：#LAST# %s\n#GOLD#完成角色：#LAST# %s\n%s\n#GOLD#描述：#LAST# %s"):format(item.when, item.who, also, item.desc):toTString()
		if track then
			desc:add(true, true, {"color","GOLD"}, "进度：", {"color","LAST"})
			desc:merge(track)
		end
		self.c_desc:switchItem(item, desc)
	end
end

function _M:getTrack(a)
	if a.track then
		local src = self.player
		local id = a.id
		local data = nil
		if a.mode == "world" then
			world.achievement_data = world.achievement_data or {}
			world.achievement_data[id] = world.achievement_data[id] or {}
			data = world.achievement_data[id]
		elseif a.mode == "game" then
			game.achievement_data = game.achievement_data or {}
			game.achievement_data[id] = game.achievement_data[id] or {}
			data = game.achievement_data[id]
		elseif a.mode == "player" then
			src.achievement_data = src.achievement_data or {}
			src.achievement_data[id] = src.achievement_data[id] or {}
			data = src.achievement_data[id]
		end
		return a.track(data, src)
	end
	return nil
end

function _M:generateList(kind)
	local tiles = Tiles.new(16, 16, nil, nil, true)
	local cache = {}

	-- Makes up the list
	local list = {}
	local i = 0
	local function handle(id, data)
		local a = world:getAchievementFromId(id)
		local color = nil
		if self.player and self.player.achievements and self.player.achievements[id] then
			color = colors.simple(colors.LIGHT_GREEN)
		end
		local img = a.image or "trophy_gold.png"
		local tex = cache[img]
		if not tex then
			local image = tiles:loadImage(img)
			if image then
				tex = {image:glTexture()}
				cache[img] = tex
			end
		end
		if not data.notdone or a.show then
			if a.show == "full" or not data.notdone then
				list[#list+1] = { name=a.name, color=color, desc=a.desc, category=a.category or "--", when=data.when, who=data.who, order=a.order, id=id, tex=tex, a=a }
			elseif a.show == "none" then
				list[#list+1] = { name="???", color=color, desc="-- Unknown --", category=a.category or "--", when=data.when, who=data.who, order=a.order, id=id, tex=tex, a=a }
			elseif a.show == "name" then
				list[#list+1] = { name=a.name, color=color, desc="-- Unknown --", category=a.category or "--", when=data.when, who=data.who, order=a.order, id=id, tex=tex, a=a }
			else
				list[#list+1] = { name=a.name, color=color, desc=a.desc, category=a.category or "--", when=data.when, who=data.who, order=a.order, id=id, tex=tex, a=a }
			end
			i = i + 1
		end
	end
	if kind == "self" and self.player and self.player.achievements then
		for id, data in pairs(self.player.achievements) do handle(id, world.achieved[id] or {notdone=true, when="--", who="--"}) end
	elseif kind == "main" then
		for id, data in pairs(world.achieved) do handle(id, data or {notdone=true, when="--", who="--"}) end
	elseif kind == "all" then
		for _, a in ipairs(world.achiev_defs) do handle(a.id, world.achieved[a.id] or {notdone=true, when="--", who="--"}) end
	end
	table.sort(list, function(a, b) return a.name < b.name end)
	self.list = list
end
