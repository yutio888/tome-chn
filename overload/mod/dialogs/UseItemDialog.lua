-- ToME - Tales of Maj'Eyal
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
require "engine.ui.Dialog"
local List = require "engine.ui.List"
local Savefile = require "engine.Savefile"
local Map = require "engine.Map"
local GetQuantity = require "engine.dialogs.GetQuantity"
local PartySendItem = require "mod.dialogs.PartySendItem"

module(..., package.seeall, class.inherit(engine.ui.Dialog))

function _M:init(center_mouse, actor, object, item, inven, onuse, no_use, dst_actor)
	self.actor = actor
	self.dst_actor = dst_actor
	self.object = object
	self.inven = inven
	self.item = item
	self.onuse = onuse
	self.no_use_allowed = no_use

	self:generateList()
	local name = object:getName()
	local w = self.font_bold:size(name)
	engine.ui.Dialog.init(self, name, 1, 1)

	local list = List.new{width=math.max(w, self.max) + 10, nb_items=#self.list, list=self.list, fct=function(item) self:use(item) end}

	self:loadUI{
		{left=0, top=0, ui=list},
	}
	self:setupUI(true, true, function(w, h)
		if center_mouse then
			local mx, my = core.mouse.get()
			self.force_x = mx - w / 2
			self.force_y = my - (self.h - self.ih + list.fh / 3)
		end
	end)

	self.key:addBinds{ EXIT = function() game:unregisterDialog(self) end, }
end

function _M:use(item)
	if not item then return end
	game:unregisterDialog(self)

	local act = item.action

	if act == "use" then
		if self.object:wornInven() and not self.object.wielded and not self.object.use_no_wear then
			self:simplePopup("Impossible", "You must wear this object to use it!")
		else
			self.actor:playerUseItem(self.object, self.item, self.inven, self.onuse)
			self.onuse(self.inven, self.item, self.object, true)
		end
	elseif act == "identify" then
		self.object:identify(true)
		self.onuse(self.inven, self.item, self.object, false)
	elseif act == "drop" then
		if self.object:getNumber() > 1 then
			game:registerDialog(GetQuantity.new("Drop how many?", "1 to "..self.object:getNumber(), self.object:getNumber(), self.object:getNumber(), function(qty)
				qty = util.bound(qty, 1, self.object:getNumber())
				self.actor:doDrop(self.inven, self.item, function() self.onuse(self.inven, self.item, self.object, false) end, qty)
			end, 1))
		else
			self.actor:doDrop(self.inven, self.item, function() self.onuse(self.inven, self.item, self.object, false) end)
		end
	elseif act == "wear" then
		self.actor:doWear(self.inven, self.item, self.object, self.dst_actor)
		if self.object.wielded and not self.actor.player and game.party:hasMember(self.actor) then -- make sure usable equipment worn by party members begins cooling down
			mod.class.Player.cooldownWornObject(self.actor, self.object)
		end
		self.onuse(self.inven, self.item, self.object, false)
	elseif act == "takeoff" then
		self.actor:doTakeoff(self.inven, self.item, self.object, nil, self.dst_actor)
		self.onuse(self.inven, self.item, self.object, false)
	elseif act == "tinker-remove" then
		self.actor:doTakeoffTinker(self.inven[self.item], self.object)
		self.actor:sortInven()
		self.onuse(self.inven, self.item, self.object, false)
	elseif act == "tinker-detach" then
		self.actor:doTakeoffTinker(self.object, self.object.tinker)
		self.actor:sortInven()
		self.onuse(self.inven, self.item, self.object, false)
	elseif act == "tinker-add" then
		local list = {}
		for inven_idx, inven in pairs(self.actor.inven) do if inven.worn then
			for item_idx, o in ipairs(inven) do
				if o:canAttachTinker(self.object, true) then list[#list+1] = {name=o:getName{do_color=true}, inven=inven, item=item_idx, o=o} end
			end
		end end
		local doit = function(w)
			if not w then return end
			self.actor:doWearTinker(self.inven, self.item, self.object, w.inven, w.item, w.o, true)
			self.actor:sortInven()
			self.onuse(self.inven, self.item, self.object, false)
		end
		if #list == 1 then doit(list[1])
		elseif #list == 0 then
			self:simplePopup("Attach to item", "You do not have any equipped items that it can be attached to.")
		else
			self:listPopup("Attach to item", "Select which item to attach it to:", list, 300, 400, doit)
		end
	elseif act == "transfer" then
		game:registerDialog(PartySendItem.new(self.actor, self.object, self.inven, self.item, function()
			self.onuse(self.inven, self.item, self.object, false)
		end))		
	elseif act == "transmo" then
		self:yesnoPopup("转化物品", "是否转化 "..self.object:getName{}, function(ret)
			if not ret then return end
			self.actor:transmoInven(self.inven, self.item, self.object)
			self.onuse(self.inven, self.item, self.object, false)
		end)
	elseif act == "toinven" then
		self.object.__transmo = false
		self.actor:checkEncumbrance()
		self.onuse(self.inven, self.item, self.object, false)
	elseif act == "untag" then
		self.object.__tagged = nil
		self.onuse(self.inven, self.item, self.object, false)
	elseif act == "tag" then
		local d = require("engine.dialogs.GetText").new("Tag object (tagged objects can not be destroyed or dropped)", "Tag:", 2, 25, function(tag) if tag then
			self.object.__tagged = tag
			self.object.__transmo = false
			self.onuse(self.inven, self.item, self.object, false)
		end end)
		game:registerDialog(d)
	elseif act == "chat-link" then
		profile.chat.uc_ext:sendObjectLink(self.object)
	elseif act == "debug-inspect" then
		local DebugConsole = require"engine.DebugConsole"
		local d = DebugConsole.new()
		game:registerDialog(d)
		DebugConsole.line = "=__uids["..self.object.uid.."]"
		DebugConsole.line_pos = #DebugConsole.line
		d.changed = true
	else
		self:triggerHook{"UseItemMenu:use", actor=self.actor, object=self.object, inven=self.inven, item=self.item, act=act, onuse=self.onuse}
	end
end

function _M:generateList()
	local list = {}

	local transmo_chest = self.actor:attr("has_transmo")

	if not self.object:isIdentified() and self.actor:attr("auto_id") and self.actor:attr("auto_id") >= 2 then list[#list+1] = {name="辨识", action="identify"} end
	if not self.dst_actor and self.object.__transmo then list[#list+1] = {name="转移至装备栏", action="toinven"} end
	if not self.dst_actor and not self.object.__transmo and not self.no_use_allowed then if self.object:canUseObject() then list[#list+1] = {name="使用", action="use"} end end
	if self.inven == self.actor.INVEN_INVEN and self.object:wornInven() and self.actor:getInven(self.object:wornInven()) then list[#list+1] = {name="装备", action="wear"} end
	if not self.object.__transmo then if self.inven ~= self.actor.INVEN_INVEN and self.object:wornInven() then list[#list+1] = {name="卸下", action="takeoff"} end end
	if not self.object.__transmo then if self.inven ~= self.actor.INVEN_INVEN and self.object.is_tinker and self.object.tinkered then list[#list+1] = {name="解除附着", action="tinker-remove"} end end
	if not self.object.__transmo then if self.inven == self.actor.INVEN_INVEN and self.object.is_tinker and not self.object.tinkered then list[#list+1] = {name="附着", action="tinker-add"} end end
	if not self.object.__transmo and self.object.tinker then list[#list+1] = { name = '解除附着', action='tinker-detach' } end
	if not self.dst_actor and not self.object.__tagged and self.inven == self.actor.INVEN_INVEN then list[#list+1] = {name="丢下", action="drop"} end
	if not self.dst_actor and self.inven == self.actor.INVEN_INVEN and game.party:countInventoryAble() >= 2 then list[#list+1] = {name="交给队友", action="transfer"} end
	if not self.dst_actor and not self.object.__tagged and self.inven == self.actor.INVEN_INVEN and transmo_chest and self.actor:transmoFilter(self.object) then list[#list+1] = {name="立即转化", action="transmo"} end
	if profile.auth and profile.hash_valid then list[#list+1] = {name="链接至聊天栏", action="chat-link"} end
	if config.settings.cheat then list[#list+1] = {name="Lua inspect", action="debug-inspect", color=colors.simple(colors.LIGHT_BLUE)} end
	if not self.object.__tagged then list[#list+1] = {name="标记", action="tag"} end
	if self.object.__tagged then list[#list+1] = {name="解除标记", action="untag"} end

	self:triggerHook{"UseItemMenu:generate", actor=self.actor, object=self.object, inven=self.inven, item=self.item, menu=list}

	self.max = 0
	self.maxh = 0
	for i, v in ipairs(list) do
		local w, h = self.font:size(v.name)
		self.max = math.max(self.max, w)
		self.maxh = self.maxh + self.font_h
	end

	self.list = list
end
