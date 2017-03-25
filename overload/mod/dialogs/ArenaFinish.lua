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
local Dialog = require "engine.ui.Dialog"
local Textzone = require "engine.ui.Textzone"
local Separator = require "engine.ui.Separator"
local List = require "engine.ui.List"
local Savefile = require "engine.Savefile"
local Map = require "engine.Map"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(actor)
	self.actor = actor
	Dialog.init(self, "Arena mode", 500, 300)

	actor:saveUUID()

	self:generateList()

	self.c_desc = Textzone.new{width=self.iw, auto_height=true, text=self:printRanking() }
	self.c_list = List.new{width=self.iw, nb_items=#self.list, list=self.list, fct=function(item) self:use(item) end}

	self:loadUI{
		{left=0, top=0, ui=self.c_desc},
		{left=5, top=self.c_desc.h, padding_h=10, ui=Separator.new{dir="vertical", size=self.iw - 10}},
		{left=0, bottom=0, ui=self.c_list},
	}
	self:setFocus(self.c_list)
	self:setupUI(false, true)
end

function _M:printRanking()
	local scores = world.arena.scores
	if not scores[1].name then return "#LIGHT_GREEN#没有排行。这可不科学。"
	else
		local text = ""
		local tmp = ""
		local line = function (txt, col) return " "..col..txt.."\n" end
		local stri = "%s (%s %s %s)\n 分数 %d[%s]) - 波次: %d"
		local i = 1
		while(scores[i] and scores[i].name) do
			p = scores[i]
			tmp = stri:format((p.name or "unknown"):capitalize(), p.sex or "unknown", p.race or "unknown", p.class or "unknown", p.score or "unknown", p.perk or "unknown", p.wave or -1)
			if p.name == world.arena.lastScore.name and p.score == world.arena.lastScore.score and p.wave == world.arena.lastScore.wave and p.perk == world.arena.lastScore.perk then
				text = text..line(tmp, "#YELLOW#")
			else
				text = text..line(tmp, "#LIGHT_BLUE#")
			end
			i = i + 1
		end
	return text
	end
end

--- Clean the actor from debuffs/buffs
function _M:cleanActor(actor)
	local effs = {}

	-- Go through all spell effects
	for eff_id, p in pairs(actor.tmp) do
		local e = actor.tempeffect_def[eff_id]
		effs[#effs+1] = {"effect", eff_id}
	end

	-- Go through all sustained spells
	for tid, act in pairs(actor.sustain_talents) do
		if act then
			effs[#effs+1] = {"talent", tid}
		end
	end

	while #effs > 0 do
		local eff = rng.tableRemove(effs)

		if eff[1] == "effect" then
			actor:removeEffect(eff[2])
		else
			actor:forceUseTalent(eff[2], {ignore_energy=true})
		end
	end
end

--- Restore resources
function _M:restoreResources(actor)
	if actor.resetToFull then
		actor:resetToFull()
		actor.energy.value = game.energy_to_act
	end
end

--- Basic resurrection
function _M:resurrectBasic(actor)
	actor.dead = false
	actor.died = (actor.died or 0) + 1

	local x, y = util.findFreeGrid(actor.x, actor.y, 20, true, {[Map.ACTOR]=true})
	if not x then x, y = actor.x, actor.y end
	actor.x, actor.y = nil, nil

	actor:move(x, y, true)
	game.level:addEntity(actor)
	game:unregisterDialog(self)
	game.level.map:redisplay()
	actor.energy.value = game.energy_to_act
	actor.changed = true
	game.paused = true
end

function _M:use(item)
	if not item then return end
	local act = item.action

	if act == "exit" then
		game:getPlayer(true).dead = true
		game:saveGame()

		world:saveWorld()
		if item.subaction == "none" then
			util.showMainMenu()
		elseif item.subaction == "restart" then
			util.showMainMenu(false, engine.version[4], engine.version[1].."."..engine.version[2].."."..engine.version[3], game.__mod_info.short_name, game.save_name, true, ("auto_quickbirth=%q"):format(game:getPlayer(true).name))
		elseif item.subaction == "restart-new" then
			util.showMainMenu(false, engine.version[4], engine.version[1].."."..engine.version[2].."."..engine.version[3], game.__mod_info.short_name, game.save_name, true)
		end
	elseif act == "cheat" then
		game.logPlayer(self.actor, "#LIGHT_BLUE#你复活了！作弊者！")

		self:cleanActor(self.actor)
		self:restoreResources(self.actor)
		self:resurrectBasic(self.actor)
	elseif act == "dump" then
		game:registerDialog(require("mod.dialogs.CharacterSheet").new(self.actor))
	elseif act == "log" then
		game:registerDialog(require("mod.dialogs.ShowChatLog").new("Message Log", 0.6, game.uiset.logdisplay, profile.chat))
	elseif act == "lichform" then
		local t = self.actor:getTalentFromId(self.actor.T_LICHFORM)

		self:cleanActor(self.actor)
		self:resurrectBasic(self.actor)
		self:restoreResources(self.actor)
		world:gainAchievement("LICHFORM", actor)
		t.becomeLich(self.actor, t)
		self.actor:updateModdableTile()
		--game:saveGame()
	end
end

function _M:generateList()
	local list = {}

	if config.settings.cheat then list[#list+1] = {name="靠作弊复活", action="cheat"} end
	list[#list+1] = {name=(not profile.auth and "消息日志" or "消息/聊天日志（允许聊天）"), action="log"}
	list[#list+1] = {name="存储角色", action="dump"}
	list[#list+1] = {name="以这个角色重新开始", action="exit", subaction="restart"}
	list[#list+1] = {name="以新角色重新开始", action="exit", subaction="restart-new"}
	list[#list+1] = {name="回到主菜单", action="exit", subaction="none"}

	self.list = list
	if self.actor:isTalentActive(self.actor.T_LICHFORM) then
		self:use{action="lichform"}
		self.dont_show = true
		return
	end
end
