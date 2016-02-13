-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2016 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even th+e implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

require "engine.class"
require "mod.class.interface.TooltipsData"

local Dialog = require "engine.ui.Dialog"
local Button = require "engine.ui.Button"
local Textzone = require "engine.ui.Textzone"
local TextzoneList = require "engine.ui.TextzoneList"
local TalentGrid = require "mod.dialogs.elements.TalentGrid"
local Separator = require "engine.ui.Separator"
local DamageType = require "engine.DamageType"
local FontPackage = require "engine.FontPackage"

module(..., package.seeall, class.inherit(Dialog, mod.class.interface.TooltipsData))

function _M:init(actor, levelup_end_prodigies)
	self.actor = actor
	self.levelup_end_prodigies = levelup_end_prodigies

	self.font = core.display.newFont(chn123_tome_font(), 12)
	self.font_h = self.font:lineSkip()

	self.actor_dup = actor:clone()
	self.actor_dup.uid = actor.uid -- Yes ...

	Dialog.init(self, "Prodigies: "..actor.name, 800, game.h * 0.9)

	self:generateList()

	self:loadUI(self:createDisplay())
	self:setupUI()

	self.key:addCommands{
	}
	self.key:addBinds{
		EXIT = function()
			game:unregisterDialog(self)
		end,
	}

	self.actor:learnTalentType("uber/strength", true)
	self.actor:learnTalentType("uber/dexterity", true)
	self.actor:learnTalentType("uber/constitution", true)
	self.actor:learnTalentType("uber/magic", true)
	self.actor:learnTalentType("uber/willpower", true)
	self.actor:learnTalentType("uber/cunning", true)
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

function _M:generateList()

	-- Makes up the list
	local max = 0
	local cols = {}
	local list = {}
	for tid, t in pairs(self.actor.talents_def) do
		if t.uber then
			cols[t.type[1]] = cols[t.type[1]] or {}
			local c = cols[t.type[1]]
			c[#c+1] = t
		end
	end
	max = math.max(#cols["uber/strength"], #cols["uber/dexterity"], #cols["uber/constitution"], #cols["uber/magic"], #cols["uber/willpower"], #cols["uber/cunning"])

	for _, s in ipairs{"uber/strength", "uber/dexterity", "uber/constitution", "uber/magic", "uber/willpower", "uber/cunning"} do
		local n = {}
		table.sort(cols[s], function(a,b) return a.name < b.name end)

		for i = 1, max do
			if not cols[s][i] then

			else
				local t = cols[s][i]
				if t.display_entity then t.display_entity:getMapObjects(game.uiset.hotkeys_display_icons.tiles, {}, 1) end

				n[#n+1] = {
					rawname = t.name,
					talent = t.id,
					entity=t.display_entity,
					do_shadow = function(item) if not self.actor:canLearnTalent(t) then return true else return false end end,
					color=function(item)
						if self.actor:knowTalent(t) or self.levelup_end_prodigies[t.id] then return {0,255,0} 
						elseif not self.actor:canLearnTalent(t) then return {75,75,75} 
						else return {175,175,175} 
						end
					end,
					status = function(item)
						return tstring{}
					end,
				}
			end
		end

		list[#list+1] = n
	end
	list.max = max
	self.list = list
end

-----------------------------------------------------------------
-- UI Stuff
-----------------------------------------------------------------

local tuttext = [[觉醒技是角色足够强大时才能获得的特殊技能。
所有觉醒技能必须在人物某项核心属性达到50点并满足所需
的特殊要求后才能习得。
你可以在人物等级达到30级和42级时各获得一个觉醒技能点。
#LIGHT_GREEN#当前可用觉醒技能点： %d]]

function _M:createDisplay()
	self.c_tut = Textzone.new{ width=self.iw, auto_height = true, text=tuttext:format(self.actor.unused_prodigies or 0)}
	
	local vsep = Separator.new{dir="horizontal", size=self.ih - 20 - self.c_tut.h}
	self.c_desc = TextzoneList.new{ focus_check = true, scrollbar = true, pingpong = 20, width=self.iw - 370 - vsep.w - 20, height = self.ih - self.c_tut.h, dest_area = { h = self.ih - self.c_tut.h } }
	self.c_list = TalentGrid.new{
		font = core.display.newFont("/data/font/DroidSans.ttf", 14),
		tiles=game.uiset.hotkeys_display_icons,
		grid=self.list,
		width=370, height=self.ih - self.c_tut.h,
		scrollbar = true,
		tooltip=function(item)
			local x = self.display_x + self.uis[2].x + self.uis[2].ui.w
			if self.display_x + self.w + game.tooltip.max <= game.w then x = self.display_x + self.w end
			local ret = self:getTalentDesc(item), x, nil
			self.c_desc:erase()
			self.c_desc:switchItem(ret, ret)
			return ret
		end,
		on_use = function(item, inc) self:use(item) end,
		no_tooltip = true,
	}

	local ret = {
		{left=0, top=0, ui=self.c_tut},
		{left=0, top=self.c_tut.h, ui=self.c_list},
		{left=self.c_list, top=self.c_tut.h, ui=vsep},
		{right=0, top=self.c_tut.h, ui=self.c_desc},
	}


	return ret
end

function _M:use(item)
	if self.actor:knowTalent(item.talent) then
	elseif self.levelup_end_prodigies[item.talent] then
		self.levelup_end_prodigies[item.talent] = false
		self.actor.unused_prodigies = self.actor.unused_prodigies + 1
		self.c_tut.text = tuttext:format(self.actor.unused_prodigies or 0)
		self.c_tut:generate()
	elseif (self.actor:canLearnTalent(self.actor:getTalentFromId(item.talent)) and self.actor.unused_prodigies > 0) or config.settings.cheat then
		if not self.levelup_end_prodigies[item.talent] then
			self.levelup_end_prodigies[item.talent] = true
			self.actor.unused_prodigies = math.max(0, self.actor.unused_prodigies - 1)
		end
		self.c_tut.text = tuttext:format(self.actor.unused_prodigies or 0)
		self.c_tut:generate()
	else
	end
end

function _M:getTalentDesc(item)
	if not item.talent then return end
	local text = tstring{}

 	text:add({"color", "GOLD"}, {"font", "bold"}, util.getval(item.rawname, item), {"color", "LAST"}, {"font", "normal"})
	text:add(true, true)

	if item.talent then
		local t = self.actor:getTalentFromId(item.talent)
		local req = self.actor:getTalentReqDesc(item.talent)
		text:merge(req)
		if self.actor:knowTalent(t) then
			text:merge(self.actor:getTalentFullDescription(t))
		else
			text:merge(self.actor:getTalentFullDescription(t, 1))
		end
	end

	return text
end
