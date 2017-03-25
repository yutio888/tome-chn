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
require "engine.Entity"
local Map = require "engine.Map"
local Dialog = require "engine.ui.Dialog"
local GetQuantity = require "engine.dialogs.GetQuantity"
local PartyOrder = require "mod.dialogs.PartyOrder"
local PartyIngredients = require "mod.class.interface.PartyIngredients"
local PartyLore = require "mod.class.interface.PartyLore"
local PartyRewardSelector = require "mod.dialogs.PartyRewardSelector"

module(..., package.seeall, class.inherit(
	engine.Entity, PartyIngredients, PartyLore
))

function _M:init(t, no_default)
	t.name = t.name or "party"
	engine.Entity.init(self, t, no_default)
	PartyIngredients.init(self, t)
	PartyLore.init(self, t)

	self.members = {}
	self.m_list = {}
	self.energy = {value = 0, mod=100000} -- "Act" every tick
	self.on_death_show_achieved = {}
end

function _M:addMember(actor, def)
	if self.members[actor] then
		print("[PARTY] error trying to add existing actor: ", actor.uid, actor.name)
		return false
	end

	-- Notify existing party members (but not the new one) that a new member is joining
	for i, pm in ipairs(self.m_list) do
		pm:fireTalentCheck("callbackOnPartyAdd", actor, def)
	end

	if type(def.control) == "nil" then def.control = "no" end
	def.title = def.title or "Party member"
	self.members[actor] = def
	self.m_list[#self.m_list+1] = actor
	def.index = #self.m_list

	if #self.m_list >= 6 then
		game:getPlayer(true):attr("huge_party", 1)
	end

	actor.ai_state = actor.ai_state or {}
	actor.ai_state.tactic_leash_anchor = actor.ai_state.tactic_leash_anchor or game.player
	actor.ai_state.tactic_leash = actor.ai_state.tactic_leash or 10

	actor.addEntityOrder = function(self, level)
		print("[PARTY] New member, add after", self.name, game.party.m_list[1].name)
		return game.party.m_list[1] -- Make the sure party is always consecutive in the level entities list
	end

	-- Turn NPCs into party members
	if not actor.no_party_class then
		local uid = actor.uid
		actor.replacedWith = false
		actor:replaceWith(require("mod.class.PartyMember").new(actor))
		actor.uid = uid
		__uids[uid] = actor
		actor.replacedWith = nil
	end

	-- Notify the UI
	if game.player then game.player.changed = true end
end

function _M:removeMember(actor, silent)
	if not self.members[actor] then
		if not silent then
			print("[PARTY] error trying to remove non-existing actor: ", actor.uid, actor.name)
		end
		return false
	end
	local olddef = self.members[actor]
	table.remove(self.m_list, self.members[actor].index)
	self.members[actor] = nil

	actor.addEntityOrder = nil

	-- Update indexes
	for i = 1, #self.m_list do
		self.members[self.m_list[i]].index = i
	end

	-- Notify existing party members (but not the old one) that a new member is leaving
	for i, pm in ipairs(self.m_list) do
		pm:fireTalentCheck("callbackOnPartyRemove", actor, def)
	end

	-- Notify the UI
	game.player.changed = true
end

function _M:leftLevel()
	local todel = {}
	local newplayer = false
	for i, actor in ipairs(self.m_list) do
		local def = self.members[actor]
		if def.temporary_level then
			todel[#todel+1] = actor
			if actor == game.player then newplayer = true end
		end
		if def.leave_level then -- Special function on leaving the level.
			def.leave_level(actor, def)
		end
	end
	for i = 1, #todel do
		self:removeMember(todel[i])
		todel[i]:disappear()
	end
	if not game.player or not self.members[game.player] or not self.members[game.player].keep_between_levels then
		self:findSuitablePlayer()
	end
end

function _M:hasMember(actor)
	return self.members[actor]
end

function _M:findMember(filter)
	for i, actor in ipairs(self.m_list) do
		local ok = true
		local def = self.members[actor]

		if filter.main and not def.main then ok = false end
		if filter.type and def.type ~= filter.type then ok = false end

		if ok then return actor end
	end
end

function _M:countInventoryAble()
	local nb = 0
	for i, actor in ipairs(self.m_list) do
		if not actor.no_inventory_access and actor:getInven(actor.INVEN_INVEN) then nb = nb + 1 end
	end
	return nb
end

function _M:setDeathTurn(actor, turn)
	local def = self.members[actor]
	if not def then return end
	def.last_death_turn = turn
end

function _M:findLastDeath()
	local max_turn = -9999
	local last = nil

	for i, actor in ipairs(self.m_list) do
		local def = self.members[actor]

		if def.last_death_turn and def.last_death_turn > max_turn then max_turn = def.last_death_turn; last = actor end
	end
	return last or self:findMember{main=true}
end

function _M:canControl(actor, vocal)
	if not actor then return false end
	if actor == game.player then
		print("[PARTY] error trying to set player, same")
		return false
	end

	if game.player and game.player.no_leave_control then
		print("[PARTY] error trying to set player but current player is modal")
		return false
	end
	if not self.members[actor] then
		print("[PARTY] error trying to set player, not a member of party: ", actor.uid, actor.name)
		return false
	end
	if self.members[actor].control ~= "full" then
		print("[PARTY] error trying to set player, not controlable: ", actor.uid, actor.name)
		return false
	end
	if actor.dead or (game.level and not game.level:hasEntity(actor)) then
		if vocal then game.logPlayer(game.player, "Can not switch control to this creature.") end
		print("[PARTY] error trying to set player, no entity or dead")
		return false
	end
	if actor.on_can_control and not actor:on_can_control(vocal) then
		print("[PARTY] error trying to set player, forbade")
		return false
	end
	return true
end

function _M:setPlayer(actor, bypass)
	if type(actor) == "number" then actor = self.m_list[actor] end

	if not bypass then
		local ok, err = self:canControl(actor, true)
		if not ok then return nil, err end
	end

	if actor == game.player then return true end

	-- Stop!!
	if game.player and game.player.runStop then game.player:runStop("Switching control") end
	if game.player and game.player.restStop then game.player:restStop("Switching control") end

	local def = self.members[actor]
	local oldp = self.player
	self.player = actor

	-- Convert the class to always be a player
	if actor.__CLASSNAME ~= "mod.class.Player" and not actor.no_party_class then
		actor.__PREVIOUS_CLASSNAME = actor.__CLASSNAME
		local uid = actor.uid
		actor.replacedWith = false
		actor:replaceWith(mod.class.Player.new(actor))
		actor.replacedWith = nil
		actor.uid = uid
		__uids[uid] = actor
		actor.changed = true
	end

	-- Setup as the curent player
	actor.player = true
	game.paused = actor:enoughEnergy()
	game.player = actor
	game.uiset.hotkeys_display.actor = actor
	Map:setViewerActor(actor)
	if game.target then game.target.source_actor = actor end
	if game.level and actor.x and actor.y then game.level.map:moveViewSurround(actor.x, actor.y, 8, 8) end
	actor._move_others = actor.move_others
	actor.move_others = true

	-- Change back the old actor to a normal actor
	if oldp and oldp ~= actor then
		if self.members[oldp] and self.members[oldp].on_uncontrol then self.members[oldp].on_uncontrol(oldp) end

		if oldp.__PREVIOUS_CLASSNAME then
			local uid = oldp.uid
			oldp.replacedWith = false
			oldp:replaceWith(require(oldp.__PREVIOUS_CLASSNAME).new(oldp))
			oldp.replacedWith = nil
			oldp.uid = uid
			__uids[uid] = oldp
		end

		actor.move_others = actor._move_others
		oldp.changed = true
		oldp.player = nil
		if game.level and oldp.x and oldp.y then oldp:move(oldp.x, oldp.y, true) end
	end

	if def.on_control then def.on_control(actor) end

	if game.level and actor.x and actor.y then actor:move(actor.x, actor.y, true) end

	if not actor.hotkeys_sorted then actor:sortHotkeys() end

	game.logPlayer(actor, "#MOCCASIN#Character control switched to %s.", actor.name)

	if game.player.resetMainShader then game.player:resetMainShader() end

	return true
end

function _M:findSuitablePlayer(type)
	for i, actor in ipairs(self.m_list) do
		local def = self.members[actor]
		if def.control == "full" and (not type or def.type == type) and not actor.dead and game.level:hasEntity(actor) then
			if self:setPlayer(actor, true) then
				return true
			end
		end
	end
	return false
end

function _M:canOrder(actor, order, vocal)
	if not actor then return false end
	if actor == game.player then return false end

	if not self.members[actor] then
		print("[PARTY] error trying to order, not a member of party: ", actor.uid, actor.name)
		return false
	end
	if (self.members[actor].control ~= "full" and self.members[actor].control ~= "order") or not self.members[actor].orders then
		print("[PARTY] error trying to order, not controlable: ", actor.uid, actor.name)
		return false
	end
	if actor.dead or (game.level and not game.level:hasEntity(actor)) then
		if vocal then game.logPlayer(game.player, "Can not give orders to this creature.") end
		return false
	end
	if actor.on_can_order and not actor:on_can_order(vocal) then
		print("[PARTY] error trying to order, can order forbade")
		return false
	end
	if order and not self.members[actor].orders[order] then
		print("[PARTY] error trying to order, unknown order: ", actor.uid, actor.name)
		return false
	end
	return true
end

function _M:giveOrders(actor)
	if type(actor) == "number" then actor = self.m_list[actor] end

	local ok, err = self:canOrder(actor, nil, true)
	if not ok then return nil, err end

	local def = self.members[actor]

	game:registerDialog(PartyOrder.new(actor, def))

	return true
end

function _M:giveOrder(actor, order)
	if type(actor) == "number" then actor = self.m_list[actor] end

	local ok, err = self:canOrder(actor, order, true)
	if not ok then return nil, err end

	local def = self.members[actor]

	if order == "leash" then
		game:registerDialog(GetQuantity.new("设置跟随半径: "..actor.name, "设置跟随的最大距离", actor.ai_state.tactic_leash, actor.ai_state.tactic_leash_max or 100, function(qty)
			actor.ai_state.tactic_leash = util.bound(qty, 1, actor.ai_state.tactic_leash_max or 100)
			game.logPlayer(game.player, "%s maximum action radius set to %d.", actor.name:capitalize(), actor.ai_state.tactic_leash)
		end), 1)
	elseif order == "anchor" then
		local co = coroutine.create(function()
			local x, y, act = game.player:getTarget({type="hit", range=10, nowarning=true})
			local anchor
			if x and y then
				if act then
					anchor = act
				else
					anchor = {x=x, y=y, name="that location"}
				end
				actor.ai_state.tactic_leash_anchor = anchor
				game.logPlayer(game.player, "%s will stay near %s.", actor.name:capitalize(), anchor.name)
			end
		end)
		local ok, err = coroutine.resume(co)
		if not ok and err then print(debug.traceback(co)) error(err) end
	elseif order == "target" then
		local co = coroutine.create(function()
			local x, y, act = game.player:getTarget({type="hit", range=10})
			if act then
				actor:setTarget(act)
				game.player:logCombat(act, "%s 设定 #Target#为目标.", actor.name:capitalize())
			end
		end)
		local ok, err = coroutine.resume(co)
		if not ok and err then print(debug.traceback(co)) error(err) end
	elseif order == "behavior" then
		game:registerDialog(require("mod.dialogs.orders."..order:capitalize()).new(actor, def))
	elseif order == "talents" then
		game:registerDialog(require("mod.dialogs.orders."..order:capitalize()).new(actor, def))

	-------------------------------------------
	-- Escort specifics
	-------------------------------------------
	elseif order == "escort_rest" then
		-- Rest for a few turns
		if actor.ai_state.tactic_escort_rest then actor:doEmote("不！我们必须得抓紧时间！", 40) return true end
		actor.ai_state.tactic_escort_rest = rng.range(6, 10)
		actor:doEmote("好吧，但时间不要太长。", 40)
	elseif order == "escort_portal" then
		local dist = core.fov.distance(actor.escort_target.x, actor.escort_target.y, actor.x, actor.y)
		if dist < 8 then dist = "很接近了"
		elseif dist < 16 then dist = "接近了"
		else dist = "还很远"
		end

		local dir
		if     actor.escort_target.x < actor.x and actor.escort_target.y < actor.y then dir = "西北方向"
		elseif actor.escort_target.x > actor.x and actor.escort_target.y < actor.y then dir = "东北方向"
		elseif actor.escort_target.x < actor.x and actor.escort_target.y > actor.y then dir = "西南方向"
		elseif actor.escort_target.x > actor.x and actor.escort_target.y > actor.y then dir = "东南方向"
		elseif actor.escort_target.x > actor.x and actor.escort_target.y == actor.y then dir = "东面"
		elseif actor.escort_target.x < actor.x and actor.escort_target.y == actor.y then dir = "西面"
		elseif actor.escort_target.x == actor.x and actor.escort_target.y < actor.y then dir = "北面"
		elseif actor.escort_target.x == actor.x and actor.escort_target.y > actor.y then dir = "南面"
		end

		actor:doEmote(("传送门%s，在%s。"):format(dist, dir), 45)
	end

	return true
end

function _M:select(actor)
	if not actor then return false end
	if type(actor) == "number" then actor = self.m_list[actor] end
	if actor == game.player then print("[PARTY] control fail, same", actor, game.player) return false end

	if self:canControl(actor) then return self:setPlayer(actor)
	elseif self:canOrder(actor) then return self:giveOrders(actor)
	end
	return false
end

function _M:canReward(actor)
	if not actor then return false end

	if not self.members[actor] then
		return false
	end
	if self.members[actor].control ~= "full" then
		return false
	end
	if actor.dead or (game.level and not game.level:hasEntity(actor)) then
		return false
	end
	if actor.summon_time then
		return false
	end
	if actor.no_party_reward then
		return false
	end
	return true
end

function _M:reward(title, action)
	local d = PartyRewardSelector.new(title, action)
	if #d.list == 1 then
		action(d.list[1].actor)
		return
	end
	game:registerDialog(d)
end

function _M:findInAllPartyInventoriesBy(prop, value)
	local o, item, inven_id
	for i, mem in ipairs(game.party.m_list) do
		o, item, inven_id = mem:findInAllInventoriesBy(prop, value)
		if o then return mem, o, item, inven_id  end
	end
end
_M.findInAllInventoriesBy = _M.findInAllPartyInventoriesBy 


function _M:goToEidolon(actor)
	if not actor then actor = self:findMember{main=true} end

	local oldzone = game.zone
	local oldlevel = game.level
	local zone = mod.class.Zone.new("eidolon-plane")
	local level = zone:getLevel(game, 1, 0)

	level.data.eidolon_exit_x = actor.x
	level.data.eidolon_exit_y = actor.y

	local acts = {}
	for act, _ in pairs(game.party.members) do
		if not act.dead then
			acts[#acts+1] = act
			if oldlevel:hasEntity(act) then oldlevel:removeEntity(act) end
		end
	end

	level.source_zone = oldzone
	level.source_level = oldlevel
	game.zone = zone
	game.level = level
	game.zone_name_s = nil

	for _, act in ipairs(acts) do
		local x, y = util.findFreeGrid(23, 25, 20, true, {[Map.ACTOR]=true})
		if x then
			level:addEntity(act)
			act:move(x, y, true)
			act.changed = true
			game.level.map:particleEmitter(x, y, 1, "teleport")
		end
	end

	for uid, act in pairs(game.level.entities) do
		if act.setEffect then
			if game.level.data.zero_gravity then act:setEffect(act.EFF_ZERO_GRAVITY, 1, {})
			else act:removeEffect(act.EFF_ZERO_GRAVITY, nil, true) end
		end
	end

	return zone
end
