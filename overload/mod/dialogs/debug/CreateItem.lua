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
local Dialog = require "engine.ui.Dialog"
local List = require "engine.ui.List"
local Checkbox = require "engine.ui.Checkbox"
local GetQuantity = require "engine.dialogs.GetQuantity"
local Focusable = require "engine.ui.Focusable"
local UIGroup = require "engine.ui.UIGroup"
local Object = require "mod.class.Object"

module(..., package.seeall, class.inherit(Dialog, Focusable, UIGroup))

function _M:init()
	self.actor = game.player
	self:generateList()
	Dialog.init(self, "DEBUG -- Create Object", 1, 1)
	self.list_width = 500
	
	local get_global = Checkbox.new{title="Load from other zones ", default=false, check_last=false,
		fct=function(checked)
			self:setFocus(self.o_list)
		end,
		on_change=function(checked)
			if checked then
				if not self.o_list2 then
					local obj_list = table.clone(game.zone.object_list, true)
					obj_list.ignore_loaded = true

					-- protected load of objects from a file
					local function load_file(file, obj_list)
						local ok, ret = xpcall(function()
							Object:loadList(file, false, obj_list, nil, obj_list.__loaded_files)
							end, debug.traceback)
						if not ok then
							game.log("#ORANGE# Create Object: Unable to load all objects from file %s:#GREY#\n %s", file, ret)
						end
					end
					-- load all objects from a base directory
					local function load_objects(base)
						local file
						file = base.."/general/objects/objects.lua"
						if fs.exists(file) then load_file(file, obj_list) end

						file = base.."/general/objects/world-artifacts.lua"
						if fs.exists(file) then load_file(file, obj_list) end

						file = base.."/general/objects/boss-artifacts.lua"
						if fs.exists(file) then load_file(file, obj_list) end

						file = base.."/general/objects/quest-artifacts.lua"
						if fs.exists(file) then load_file(file, obj_list) end
					
						for i, dir in ipairs(fs.list(base.."/zones/")) do
							file = base.."/zones/"..dir.."/objects.lua"
							if dir ~= game.zone.short_name and fs.exists(file) and not dir:find("infinite%-dungeon") and not dir:find("noxious%-caldera") then
								load_file(file, obj_list)
							end
						end
					end
					
					-- load base global and zone objects
					load_objects("/data", "")

					-- load all objects defined by addons (in standard directories)
					for i, dir in ipairs(fs.list("/")) do
						local _, _, addon = dir:find("^data%-(.+)$")
						if addon then
							load_objects("/"..dir)
						end
					end
					self:generateList(obj_list)
					self.o_list2 = List.new{width=self.list_width, height=500, list=self.list, 
						fct=function(item) self:use(item) end,
						select=function(item, sel) return self:list_select(item, sel) end,
					}
				end
				self.o_list = self.o_list2
				self.list = self.o_list.list
				self.alt_uis = {
					{left=0, top=self.get_global.h+10, ui=self.o_list2},
					{left=10, top=0, ui=self.get_global},
					{left=self.get_global.w + 20, top=0, ui=self.id_check},
				}
				self:loadUI(self.alt_uis)
				self:setupUI(true, true)

			else
				self.o_list = self.o_list1
				self.list = self.o_list.list
				self:loadUI(self.base_uis)
				self:setupUI(true, true)
			end
			self:setFocus(self.o_list)
		end
	}
	self.get_global = get_global

	local id_check = Checkbox.new{title="Generate examples (right-click refreshes) ", text="Text", default=false, check_last=false,
		fct=function(checked)
			self.do_ids = checked
			self:setFocus(self.o_list)
		end,
		on_change=function(checked)
			self.do_ids = checked
			self:setFocus(self.o_list)
		end
	}
	self.id_check = id_check
	
	self.o_list1 = List.new{width=self.list_width, height=500, list=self.list, 
		fct=function(item) self:use(item) end,
		select=function(item, sel) return self:list_select(item, sel) end,
	}
	self.o_list = self.o_list1
	self.base_uis = {
		{left=0, top=get_global.h+10, ui=self.o_list},
		{left=10, top=0, ui=self.get_global},
		{left=self.get_global.w + 20, top=0, ui=self.id_check},
	}
	self:loadUI(self.base_uis)
	self:setupUI(true, true)
	self.mouse:registerZone(0, 0, self.w, self.h, function(button, x, y, xrel, yrel, bx, by, event)
		self:mouseEvent(button, x, y, xrel, yrel, bx, by, event)
	end)

	self.key:addCommands{ __TEXTINPUT = function(c)
		for i = self.o_list.sel + 1, #self.o_list.list do
			local v = self.o_list.list[i]
			if v.name:sub(1, 1):lower() == c:lower() then self.o_list:select(i) return end
		end
		for i = 1, self.o_list.sel do
			local v = self.o_list.list[i]
			if v.name:sub(1, 1):lower() == c:lower() then self.o_list:select(i) return end
		end
		self:setFocus(self.o_list)
	end}
	self.key:addCommands{
		_UP = function() self.o_list.key:triggerVirtual("MOVE_UP") end,
		_DOWN = function() self.o_list.key:triggerVirtual("MOVE_DOWN") end,
	}
	self.key:addBinds{ EXIT = function() game:unregisterDialog(self) end,
		ACCEPT = function() self.o_list.key:triggerVirtual("ACCEPT") end,
		LUA_CONSOLE = function()
			if config.settings.cheat then
				local DebugConsole = require "engine.DebugConsole"
				game:registerDialog(DebugConsole.new())
			end
		end,
	}
	self:setFocus(self.o_list)
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

function _M:mouseEvent(button, x, y, xrel, yrel, bx, by, event)
	if self.o_list.focused then
		local item = self.o_list.list[self.o_list.sel]
		if item and button == "right" and event == "button-down" then
			item.obj, item.desc = nil, nil
			self:list_select(item, self.o_list.sel)
		end
	end

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

function _M:list_select(item, sel)
	if not item or not self.do_ids then return end

	if item.e then
		if not item.desc then
			local ok, ret, special = xpcall(function()
				item.obj = game.zone:finishEntity(game.level, "object", item.e)
				item.obj.identified = true
				local od = item.obj:getDesc({do_color=true}, nil, true, self.actor)
				if type(od) == "string" then od = od:toTString() end
				table.insert(od, 1, true)
				table.insert(od, 1, "#CRIMSON#==Resolved Example==#LAST#")
				item.desc = tostring(od)
			end, debug.traceback)
			if not ok then
				print("[DEBUG] Item generation error:", ret)
				item.error = ret
				game.log("#LIGHT_BLUE#Object %s could not be generated or identified. Error:\n%s", item.e.name, ret)
				item.desc = tstring{("#GOLD#%s#LAST#"):format(item.e.name), true, "Object could not be resolved/identified.", true, ("Error:\n%s"):format(ret)}
			end
		end
		game:tooltipDisplayAtMap(game.w, game.h, item.desc or "")
	end
end

--- add object to targeted creature's inventory
function _M:objectToTarget(obj)
	local p = game.player
	game:unregisterDialog(self)
	local tg = {type="hit", range=100, nolock=true, no_restrict=true, nowarning=true, no_start_scan=true, act_exclude={[p.uid]=true}}
	local x, y, act
	local co = coroutine.create(function()
		x, y, act = p:getTarget(tg)
		if x and y then
			if act then
				if act:getInven(act.INVEN_INVEN) then
					if act:addObject(act.INVEN_INVEN, obj) then
						game.zone:addEntity(game.level, obj, "object")
						_M.findObject(self, obj, act)
					else game.log("#LIGHT_BLUE#Could not add object to %s at (%d, %d)", act.name, x, y)
					end
				end
			else
				game.log("#LIGHT_BLUE#No creature to add object to at (%d, %d)", x, y)
			end
		end
		game:registerDialog(self)
	end)
	coroutine.resume(co)
end

--- Create the object, either dropping it or adding it to the player or npc's inventory
function _M:acceptObject(obj, actor)
	if not obj then game.log("#LIGHT_BLUE#No object to create")
	else
		obj = obj:cloneFull()
		actor = actor or self.actor or game.player
		-- choose where to put object (default is current actor's inventory)
		local d = Dialog:multiButtonPopup("Place Object", "Place the object where?",
			{{name=("Inventory of %s%s"):format( actor.name, actor.player and " #LIGHT_GREEN#(player)#LAST#" or ""), choice="player", fct=function(sel)
				-- if not obj.quest and not obj.plot then obj.__transmo = true end
				actor:addObject(actor.INVEN_INVEN, obj)
				game.zone:addEntity(game.level, obj, "object")
				_M.findObject(self, obj, actor)
			end},
			{name=("Drop @ (%s, %s)%s"):format(actor.x, actor.y, actor.player and " #LIGHT_GREEN#(player)#LAST#" or ""), choice="drop", fct=function(sel)
				game.zone:addEntity(game.level, obj, "object", actor.x, actor.y)
				game.log("#LIGHT_BLUE#Dropped %s at (%d, %d)", obj:getName({do_color=true}), actor.x, actor.y)
			end},
			{name=("NPC Inventory"):format(), choice="npc", fct=function(sel)
				local x, y, act = _M.objectToTarget(self, obj)
			end},
			{name=("Cancel"):format(), choice="cancel", fct=function(sel)
			end}
			},
			nil, nil, -- autosize
			function(sel)
				if sel.fct then sel.fct(sel) end
			end,
			false, 4, 1 -- cancel on escape, default
		)
	end
end

--- Report all locations of obj in actor's inventories
function _M:findObject(obj, actor)
	if not (obj and actor) then return end
	local inv, slot, attached = actor:searchAllInventories(obj, function(o, who, inven, slot, attached)
		game.log("#LIGHT_BLUE#OBJECT:#LAST# %s%s: #LIGHT_BLUE#[%s] %s {%s, slot %s} at (%s, %s)#LAST#", o:getName({do_color=true, no_add_name=true}), attached and (" (attached to: %s)"):format(attached:getName({do_color=true, no_add_name=true})) or "", who.uid, who.name, inven.name, slot, who.x, who.y)
	end)
	return inv, slot, attached
end

-- debugging: check for bad objects
function _M:check_selections()
	self.do_ids = true
	for i, item in ipairs(self.o_list.list) do
		self:list_select(item)
	end
end

function _M:use(item)
	if not item then return end

	if item.action then
		item:action()
	elseif item.unique then
		local n = not item.error and item.obj or game.zone:finishEntity(game.level, "object", item.e)
		if n then
			n:identify(true)
			self:acceptObject(n)
		end
	else
		local example = item.obj and not item.error
		game:registerDialog(GetQuantity.new("Number of items to make", "Enter 1-100"..(example and ", or 0 for the example item" or ""), 20, 100, function(qty)
			if qty == 0 and item.obj and not item.error then
				self:acceptObject(item.obj)
			else
				game.log("#LIGHT_BLUE# Creating %d items:", qty)
				Dialog:yesnoPopup("Ego", "Add an ego enhancement if possible?", function(ret)
					if not ret then
						for i = 1, qty do
							local n = game.zone:finishEntity(game.level, "object", item.e, {ego_chance=-1000})
							n:identify(true)
							game.zone:addEntity(game.level, n, "object", self.actor.x, self.actor.y)
							game.log("#LIGHT_BLUE#Created %s", n:getName({do_color=true}))
						end
					else
						Dialog:yesnoPopup("Greater Ego", "Add a greater ego enhancement if possible?", function(ret)
							local f
							if not ret then
								f = {ego_chance=1000}
							else
								f = {ego_chance=1000, properties={"greater_ego"}}
							end
							for i = 1, qty do
								local n = game.zone:finishEntity(game.level, "object", item.e, f)
								n:identify(true)
								game.zone:addEntity(game.level, n, "object", self.actor.x, self.actor.y)
								game.log("#LIGHT_BLUE#Created %s", n:getName({do_color=true}))
							end
						end)
					end
				end)
			end
		end), example and 0 or 1)
	end
end

function _M:generateList(obj_list)
	local list = {}
	self.uniques = {}
	obj_list = obj_list or game.zone.object_list
	self.raw_list = obj_list
	for i, e in ipairs(obj_list) do
		if e.name and not (e.unique and self.uniques[e.unique]) then
			list[#list+1] = {name=e.name, unique=e.unique, e=e}
			if e.unique then self.uniques[e.unique] = true end
		end
	end
	table.sort(list, function(a,b)
		if a.unique and not b.unique then return true
		elseif not a.unique and b.unique then return false end
		return a.name < b.name
	end)

	table.insert(list, 1, {name = " #GOLD#All Artifacts#LAST#", action=function(item)
		game.log("#LIGHT_BLUE#Creating All Artifacts.")
		local count = 0
		for i, e in ipairs(obj_list) do
			if e.unique and e.define_as ~= "VOICE_SARUMAN" and e.define_as ~= "ORB_MANY_WAYS_DEMON" then
				local a = game.zone:finishEntity(game.level, "object", e)
				a.no_unique_lore = true -- to not spam
				a:identify(true)
				game.zone:addEntity(game.level, a, "object", game.player.x, game.player.y)
				if a.slot then
					local invendef = game.player:getInvenDef(a.slot)
					if invendef and invendef.infos and invendef.infos.shimmerable then
						world:unlockShimmer(a)
					end
				end
				count = count + 1
			end
		end
		game.log("#LIGHT_BLUE#%d artifacts created.", count)
	end})
	table.insert(list, 1, {name = " #YELLOW#Random Object#LAST#", action=function(item)
		game:unregisterDialog(self)
		local d = require("mod.dialogs.debug.RandomObject").new()
		game:registerDialog(d)
	end}
	)

	local chars = {}
	for i, v in ipairs(list) do
		v.name = v.name
		chars[self:makeKeyChar(i)] = i
	end
	list.chars = chars

	self.list = list
end
