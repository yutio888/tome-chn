-- ToME - Tales of Maj'Eyal
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
local Dialog = require "engine.ui.Dialog"
local Object = require "mod.class.Object"
local Tiles = require "engine.Tiles"
local Entity = require "engine.Entity"

module(..., package.seeall, class.make)

_M.__tinkers_ings = {}

--- Defines actor talents
-- Static!
function _M:loadDefinition(file, env)
	local f, err = util.loadfilemods(file, setmetatable(env or {
		newRecipe = function(t) self:newTinkerRecipe(t) end,
		load = function(f) self:loadDefinition(f, getfenv(2)) end
	}, {__index=_G}))
	if not f and err then error(err) end
	f()
end

--- Defines a new tinker recipe
-- Static!
function _M:newTinkerRecipe(t)
	assert(t.id, "no tinker id")
	assert(t.name, "no tinker name")
	assert(t.desc, "no tinker desc")
	assert(t.icon, "no tinker icon")

	if not t.icon then
		t.icon = "object/"..t.name:lower():gsub("[^a-z0-9_]", "_")..".png"
	end
	if fs.exists(Tiles.baseImageFile(t.icon)) then t.display_entity = Entity.new{image=t.icon, is_tinker=true}
	else t.display_entity = Entity.new{image="talents/default.png", is_talent=true}
	end
	t.enName = t.name
	if tinkerCHN and tinkerCHN[t.name] then
		t.desc = tinkerCHN[t.name].desc
		t.name = tinkerCHN[t.name].name
	end
	_M.__tinkers_ings[t.id] = t
end

function _M:initTinker()
	self.known_tinkers = {}
end

function _M:createTinkerUI()
	package.loaded["mod.dialogs.CreateTinker"] = nil
	local d = require("mod.dialogs.CreateTinker").new(self, game.player)
	game:registerDialog(d)
	return d
end

function _M:canMakeTinker(who, id, ml)
	local tdef = self.__tinkers_ings[id]
	if not tdef then return false, "unknown tinker" end

	if tdef.base_ml and ml < tdef.base_ml then return false, "can not create tier "..ml end
	if tdef.max_ml and ml > tdef.max_ml then return false, "can not create tier "..ml end

	if tdef.talents then for tid, level in pairs(tdef.talents) do
		if who:getTalentLevel(tid) < level then return false, "requires "..who:getTalentFromId(tid).name.." level "..level end
	end end

	if tdef.ingredients then for ing, qty in pairs(tdef.ingredients) do
		if not self:hasIngredient(ing..ml, qty) and not self:hasIngredient(ing, qty) then return false, "requires "..qty.." "..(self:getIngredient(ing..ml) or self:getIngredient(ing)).name end
	end end

	local inven = who:getInven("INVEN")
	if tdef.items then for ing, name in pairs(tdef.items) do
		ing = util.getval(ing, ml)
		name = util.getval(name, ml)
		if not who:findInInventoryBy(inven, "define_as", ing..ml) and not who:findInInventoryBy(inven, "define_as", ing) then return false, "requires "..name end
	end end

	if tdef.special then for _, d in ipairs(tdef.special) do
		if not d.cond(tdef, self, who) then return false, "requires "..d.desc end
	end end

	return true
end

function _M:makeTinker(who, id, ml, silent)
	local tdef = self.__tinkers_ings[id]
	if not tdef then return end
	local ok, err = self:canMakeTinker(who, id, ml)
	if not ok then
		if not silent then Dialog:simplePopup("Impossible to create "..tdef.name.."("..ml..")", err:capitalize()) end
		return
	end

	local list = Object:loadList("/data-orcs/general/objects/tinker.lua")
	local oid = "TINKER_"..id..ml
	if not tdef.create and not list[oid] then return end

	local remove = function(ok)
		if not ok then return end
		if tdef.ingredients then for ing, qty in pairs(tdef.ingredients) do
			if self:hasIngredient(ing..ml, qty) then self:useIngredient(ing..ml, qty)
			else self:useIngredient(ing, qty) end
		end end
		if tdef.items then for ing, _ in pairs(tdef.items) do
			ing = util.getval(ing, ml)
			name = util.getval(name, ml)
			local inven = who:getInven("INVEN")
			if who:findInInventoryBy(inven, "define_as", ing..ml) then
				local o, item = who:findInInventoryBy(inven, "define_as", ing..ml)
				who:removeObject(inven, item)
			else
				local o, item = who:findInInventoryBy(inven, "define_as", ing)
				who:removeObject(inven, item)
			end
		end end
	end

	if tdef.create then
		tdef.create(tdef, self, who, ml, silent, remove)
	else
		list.__real_type = "object"
		local o = game.zone:makeEntityByName(game.level, list, oid)
		if not o then return end

		o:identify(true)
		who:addObject(who.INVEN_INVEN, o)
		who:sortInven()
		game.zone:addEntity(game.level, o, "object")
		game.log("制造配件: %s", o:getName{do_color=true})
		game.bignews:saySimple(110, "制造配件: %s", o:getName{do_color=true})
		remove(true)

		if tdef.auto_hotkey_item and who.addNewHotkey then
			who:addNewHotkey("inventory", o:getName{no_count=true, force_id=true, no_add_name=true})
		end
	end
end

function _M:knowTinker(id)
	if self.known_tinkers[id] then return true end
	return false
end

function _M:learnTinker(id, vocal)
	local tdef = self.__tinkers_ings[id]
	if not tdef then return end
	if self.known_tinkers[id] then return end
	self.known_tinkers[id] = true
	game.log("学会新配方: #LIGHT_GREEN#%s", tdef.name)
	if vocal then game.bignews:saySimple(180, "Learnt new tinker schematic: #LIGHT_GREEN#%s", tdef.name) end
end
