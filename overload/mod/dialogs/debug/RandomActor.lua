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
local Textbox = require "engine.ui.Textbox"
local Button = require "engine.ui.Button"
local Textzone = require "engine.ui.Textzone"
local DebugConsole = require "engine.DebugConsole"
local SummonCreature = require "mod.dialogs.debug.SummonCreature"

module(..., package.seeall, class.inherit(engine.ui.Dialog))

_M._default_base_filter = ""
_M._base_filter = _M._default_base_filter
_M._default_boss_data = "{}"
_M._boss_data = _M._default_boss_data

--- formats function help for dialog output
local function formatHelp(f_lines, f_name, f_lnum)
	local help = ("#LIGHT_GREEN#(From %s, line %s):#LAST#"):format(f_name or "unknown", f_lnum or "unknown")
	for _, line in ipairs(f_lines) do
		line = line:gsub("#", "_")
		help = help.."\n    "..line:gsub("\t", "    ")
	end
	return help
end

-- set up context sensitive help
local lines, fname, lnum = DebugConsole:functionHelp(game.zone.checkFilter)
_M.filter_help = "#GOLD#FILTER HELP#LAST# "..formatHelp(lines, fname, lnum)
lines, fname, lnum = DebugConsole:functionHelp(game.state.entityFilterPost)
_M.filter_help = _M.filter_help.."\n#GOLD#FILTER HELP#LAST# "..formatHelp(lines, fname, lnum)

lines, fname, lnum = DebugConsole:functionHelp(game.state.createRandomBoss)
_M.data_help = "#GOLD#DATA HELP#LAST# "..formatHelp(lines, fname, lnum)
lines, fname, lnum = DebugConsole:functionHelp(game.state.applyRandomClass)
_M.data_help = _M.data_help.."\n#GOLD#DATA HELP#LAST# "..formatHelp(lines, fname, lnum)
lines, fname, lnum = DebugConsole:functionHelp(mod.class.Actor.levelupClass)
_M.data_help = _M.data_help.."\n#GOLD#DATA HELP#LAST# "..formatHelp(lines, fname, lnum)

function _M:init()
	engine.ui.Dialog.init(self, "DEBUG -- Create Random Actor", 1, 1)

	local tops={0}	self.tops = tops
	
--	if not _M._base_actor then self:generateBase() end
	
	local dialog_txt = Textzone.new{auto_width=true, auto_height=true, no_color_bleed=true, font=self.font,
	text=([[Randomly generate actors subject to a filter and/or create random bosses according to a data table.
Filters are interpreted by game.zone:checkFilter.
#ORANGE#Boss Data:#LAST# is interpreted by game.state:createRandomBoss, game.state:applyRandomClass, and Actor.levelupClass.
Generation is performed within the _G environment (used by the Lua Console) using the current zone's #LIGHT_GREEN#npc_list#LAST#.
Press #GOLD#'F1'#LAST# for help.
Mouse over controls for an actor preview (which may be further adjusted when placed on to the level).
(Press #GOLD#'L'#LAST# to lua inspect or #GOLD#'C'#LAST# to open the character sheet.)

The #LIGHT_BLUE#Base Filter#LAST# is used to filter the actor randomly generated.]]):format(), can_focus=false}
	self.dialog_txt = dialog_txt
	tops[#tops+1]=tops[#tops] + dialog_txt.h + 5
	
	local function base_text()
		local txt
		if _M._base_actor then
			local r, rc = _M._base_actor:TextRank()
			txt = (rc or "#WHITE#").._M._base_actor.name.."#LAST#"
		else
			txt = "#GREY#None#LAST#"
		end
		return ([[Current Base Actor: %s]]):format(txt)
	end
	local base_txt = Textzone.new{auto_width=true, auto_height=true, no_color_bleed=true, font=self.font,
	text = base_text(), can_focus=true}
	base_txt.refresh = function(self, actor)
		self.text = base_text()
		self:generate()
	end
	base_txt.on_focus = function() _M.tooltip(_M._base_actor) _M.help_display = "filter_help" end
	self.base_txt = base_txt
	
	local base_refresh = self.newButton{text="Generate", _actor_field="_base_actor",
		fct=function()
			self:generateBase()
			game.log("#LIGHT_BLUE# Current base actor: %s", _M._base_actor and _M._base_actor.name or "none")
			self.base_txt:refresh(_M._base_actor)
			self.base_refresh.on_select()
		end,
		help_display = "filter_help"
	}
	self.base_refresh = base_refresh
	tops[#tops+1]=tops[#tops] + base_refresh.h + 5
	
	local base_make = self.newButton{text="Place", _actor_field="_base_actor",
		fct=function()
			self:placeActor(_M._base_actor)
		end,
		help_display = "filter_help"
	}
	self.base_make = base_make
	
	local base_reset_filter = self.newButton{text="Default Filter", _actor_field="_base_actor",
		fct=function()
			game.log("#LIGHT_BLUE# Reset base filter")
			_M._base_filter = _M._default_base_filter
			self.bf_box:setText(_M._base_filter)
		end,
		help_display = "filter_help"
	}
	self.base_reset_filter = base_reset_filter
	
	local base_clear = self.newButton{text="Clear", _actor_field="_base_actor",
		fct=function()
			game.log("#LIGHT_BLUE# Clear base actor: %s", _M._base_actor and _M._base_actor.name or "none")
			if _M._base_actor then
				_M._base_actor:removed()
				_M._base_actor = nil
			end
			base_txt:refresh(_M._base_actor)
			game.tooltip:erase()
		end,
		help_display = "filter_help"
	}
	self.base_clear = base_clear
	
	local bf_box = _M.newTextbox{title="#LIGHT_BLUE#Base Filter:#LAST# ", text=_M._base_filter or "{}", chars=120, max_len=500,
		fct=function(text)
			_M._base_filter = text
			self:generateBase()
			self.base_txt:refresh(_M._base_actor)
			self.base_refresh.on_select()
		end,
		on_change=function(text)
			_M._base_filter = text
		end,
		help_display = "filter_help"
	}
	self.bf_box = bf_box
	tops[#tops+1]=tops[#tops] + bf_box.h + 10
	
	local boss_info = Textzone.new{auto_width=true, auto_height=true, no_color_bleed=true, font=self.font,
	text=[[The #ORANGE#Boss Data#LAST# is used to transform the base actor into a random boss (which will use a random actor if needed).]]}
	self.boss_info = boss_info
	tops[#tops+1]=tops[#tops] + boss_info.h + 5
	
	local function boss_text()
		local txt
		if _M._boss_actor then
			local r, rc = _M._boss_actor:TextRank()
			txt = (rc or "#ORANGE#").._M._boss_actor.name.."#LAST#"
		else
			txt = "#GREY#None#LAST#"
		end
		return ([[Current Boss Actor: %s]]):format(txt)
	end
	local boss_txt = Textzone.new{auto_width=true, auto_height=true, no_color_bleed=true, font=self.font,
	text=boss_text(), can_focus=true}
	boss_txt.refresh = function(self)
		self.text = boss_text()
		self:generate()
	end
	boss_txt.on_focus = function() _M.tooltip(_M._boss_actor) _M.help_display = "data_help" end
	self.boss_txt = boss_txt
	
	local boss_refresh = self.newButton{text="Generate", _actor_field="_boss_actor",
		fct=function()
			self:generateBoss()
			boss_txt:refresh()
			self.boss_refresh.on_select()
		end,
		help_display = "data_help"
	}
	self.boss_refresh = boss_refresh
	tops[#tops+1]=tops[#tops] + boss_refresh.h + 5
	
	local boss_reset_data = self.newButton{text="Default Data", _actor_field="_boss_actor",
		fct=function()
			game.log("#LIGHT_BLUE# Reset Randboss Data")
			_M._boss_data = _M._default_boss_data
			self.boss_data_box:setText(_M._boss_data)
		end,
		help_display = "data_help"
	}
	self.boss_reset_data = boss_reset_data
	
	local boss_make = self.newButton{text="Place", _actor_field="_boss_actor",
		fct=function()
			boss_txt:refresh()
			self:placeActor(_M._boss_actor)
		end,
		help_display = "data_help"
	}
	self.boss_make = boss_make
	
	local boss_data_box = _M.newTextbox{title="#ORANGE#Boss Data:#LAST# ", text=_M._boss_data or "{}", chars=120, max_len=500,
		fct=function(text)
			_M._boss_data = text
			self:generateBoss()
			boss_txt:refresh()
			self.boss_refresh.on_select()
		end,
		on_change=function(text)
			_M._boss_data = text
		end,
		help_display = "data_help"
	}
	self.boss_data_box = boss_data_box
	tops[#tops+1]=tops[#tops] + boss_data_box.h + 5

	self:loadUI{
		{left=0, top=tops[1], ui=dialog_txt},
		{left=0, top=tops[2], ui=base_refresh},
		{left=base_refresh.w+10, top=tops[2], ui=base_make},
		{left=base_refresh.w+base_make.w+15, top=tops[2], ui=base_reset_filter},
		{left=base_refresh.w+base_make.w+base_reset_filter.w+20, top=tops[2], ui=base_clear},
		{left=base_refresh.w+base_make.w+base_reset_filter.w+base_clear.w+25, top=tops[2]+(base_refresh.h-base_txt.h)/2, ui=base_txt},
		{left=0, top=tops[3], ui=bf_box},
		{left=0, top=tops[4], ui=boss_info},
		{left=0, top=tops[5], ui=boss_refresh},
		{left=boss_refresh.w+10, top=tops[5], ui=boss_make},
		{left=boss_refresh.w+boss_make.w+15, top=tops[5], ui=boss_reset_data},
		{left=boss_refresh.w+boss_reset_data.w+boss_make.w+20, top=tops[5]+(boss_make.h-boss_txt.h)/2, ui=boss_txt},
		{left=0, top=tops[6], ui=boss_data_box},
	}

	self:setFocus(base_make)
	self:setupUI(true, true)
	self.key:addBinds{ EXIT = function()
			game:unregisterDialog(self) 
		end,
		LUA_CONSOLE = function()
			if config.settings.cheat then
				game:registerDialog(DebugConsole.new())
			end
		end,}
	self.key:addCommands{ 
		_F1 = function() -- Help for filters and data (at upper left)
			local d = Dialog:simpleLongPopup("Filter and Data Help", 
([[%s]]):format(_M[_M.help_display] or _M.filter_help), math.max(500, game.w/2)
		)
		engine.Dialog.resize(d, d.w, d.h, 25, 25)
		end,
	}
end

-- display the tooltip for an actor
function _M.tooltip(act)
	if act then
		local plr = game.player
		game:tooltipDisplayAtMap(game.w, game.h, act:tooltip(plr.x, plr.y, plr), nil, true)
	else
		game:tooltipDisplayAtMap(game.w, game.h, "#GREY#No Actor to Display#LAST#", nil, true)
	end
end

--- Generate a Textbox with some extra properties
_M.newTextbox = function(t)
	local self = Textbox.new(t)
	self.help_display = t.help_display
	self.on_focus_change = function(status)	_M.help_display = self.help_display	end
	return self
end

--- Generate a Button with some additional properties
_M.newButton = function(t)
	local self = Button.new(t)
	self._actor_field = t._actor_field or "_base_actor"
	self.help_display = t.help_display
	self.on_select = function()
		_M.help_display = self.help_display
		_M.tooltip(_M[self._actor_field])
	end
	self.key:addCommands{
		_c = function() -- open character sheet
			local act = _M[self._actor_field]
			if act then
				game.log("#LIGHT_BLUE#Inspect [%s]%s", act.uid, act.name)
				game:registerDialog(require("mod.dialogs.CharacterSheet").new(act))
			else
				game.log("#LIGHT_BLUE#No actor to inspect")
			end
		end,
		_l = function() -- lua inspect actor
			if core.key.modState("ctrl") then
				game.key:triggerVirtual("LUA_CONSOLE")
				return
			end
			local act = _M[self._actor_field]
			if act then
				game.log("#LIGHT_BLUE#Lua Inspect [%s]%s", act.uid, act.name)
				local DebugConsole = require"engine.DebugConsole"
				local d = DebugConsole.new()
				game:registerDialog(d)
				DebugConsole.line = "=__uids["..act.uid.."]"
				DebugConsole.line_pos = #DebugConsole.line
				d.changed = true
			else
				game.log("#LIGHT_BLUE#No actor to Lua inspect")
			end
		end,
		}
	return self
end

-- generate base actor
function _M:generateBase()
	local ok, filter
	local fx = loadstring("return "..tostring(_M._base_filter))
	self.base_filter_function = fx
	if fx then
		setfenv(fx, _G)
		ok, filter = pcall(fx)
	end
	if not ok or filter and type(filter) ~= "table" then
		game.log("#LIGHT_BLUE#Bad filter for base actor: %s", _M._base_filter)
		return
	end
	local m
	ok, m = pcall(game.zone.makeEntity, game.zone, game.level, "actor", filter)

	if ok then
		if m then
			if _M._base_actor then _M._base_actor:removed() end
			local plr = game.player
			m = SummonCreature.finishActor(self, m, plr.x, plr.y)
			_M._base_actor = m
		else
			game.log("#LIGHT_BLUE#Could not generate a base actor with filter: %s", _M._base_filter)
		end
	else
		print("[DEBUG:RandomActor] actor creation error:", m)
		game.log("#LIGHT_BLUE#Base actor could not be generated with filter [%s].\n Error:%s", _M._base_filter, m)
	end
end

-- generate random boss
-- note: difficulty effects will not be reapplied when a base actor is used
function _M:generateBoss()
	local base = _M._base_actor
	if not base then
		print("[DEBUG:RandomActor] generating random base actor")
		base = game.zone:makeEntity(game.level, "actor") 
	end
	
	if base then
		local ok, data
		local fx = loadstring("return "..tostring(_M._boss_data))
		self.boss_data_function = fx
		if fx then
			setfenv(fx, _G)
			ok, data = pcall(fx)
		end
		if not ok or data and type(data) ~= "table" then
			game.log("#LIGHT_BLUE#Bad data for random boss actor: %s", _M._boss_data)
			return
		end

		local m
		ok, m = pcall(game.state.createRandomBoss, game.state, base, data)
		if ok then
			if m then
				m._debug_finished = false
				if _M._boss_actor then _M._boss_actor:removed() end
				local plr = game.player
				m = SummonCreature.finishActor(self, m, plr.x, plr.y)
				_M._boss_actor = m
			else
				game.log("#LIGHT_BLUE#Could not generate a base actor with data: %s", _M._boss_data)
			end
		else
			print("[DEBUG:RandomActor] Random Boss creation error:", m)
			game.log("#LIGHT_BLUE#ERROR: Random Boss could not be generated with data [%s].\n Error:%s", _M._boss_data, m)
		end
	end
end

--- Place the generated actor
function _M:placeActor(actor)
	if actor then
		local place_actor = actor:cloneFull()
		SummonCreature.placeCreature(self, place_actor)
	end
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

