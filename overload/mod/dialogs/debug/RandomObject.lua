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
require "engine.ui.Dialog"
local List = require "engine.ui.List"
local GetQuantity = require "engine.dialogs.GetQuantity"
local Textbox = require "engine.ui.Textbox"
local Button = require "engine.ui.Button"
local Textzone = require "engine.ui.Textzone"
local Dropdown = require "engine.ui.Dropdown"
local Dialog = require "engine.ui.Dialog"
local DebugConsole = require "engine.DebugConsole"
local CreateItem = require "mod.dialogs.debug.CreateItem"

module(..., package.seeall, class.inherit(engine.ui.Dialog))

_M._default_random_filter = ""
_M._random_filter = _M._default_random_filter

-- default from game.state:generateRandart
_M._default_base_filter =[[{ignore_material_restriction=true, no_tome_drops=true, ego_filter={keep_egos=true, ego_chance=-1000}, special=function(e) return (not e.unique and e.randart_able) and (not e.material_level or e.material_level >= 2) and true or false end}]]
_M._base_filter = config.settings.tome.cheat_create_object_default_filter or _M._default_base_filter
_M._default_randart_data = "{lev=resolvers.current_level}"
_M._randart_data = config.settings.tome.cheat_create_object_default_randart_data or _M._default_randart_data

--- formats function help for dialog output
local function formatHelp(f_lines, f_name, f_lnum)
	local help = ("#LIGHT_GREEN#(From %-10.60s, line: %s):#LAST#"):format(f_name or "unknown", f_lnum or "unknown")
	for _, line in ipairs(f_lines or {}) do
		line = line:gsub("#", "_")
		help = help.."\n    "..line:gsub("\t", "    ")
	end
	return help
end

-- set up context sensitive help
local lines, fname, lnum = DebugConsole:functionHelp(game.zone.checkFilter)
_M.filter_help = "#GOLD#FILTER HELP#LAST# "..formatHelp(lines, fname, lnum)
lines, fname, lnum = DebugConsole:functionHelp(game.state.entityFilter)
_M.filter_help = _M.filter_help.."\n#GOLD#FILTER HELP#LAST# "..formatHelp(lines, fname, lnum)
lines, fname, lnum = DebugConsole:functionHelp(game.state.entityFilterAlter)
_M.filter_help = _M.filter_help.."\n#GOLD#FILTER HELP#LAST# "..formatHelp(lines, fname, lnum)
lines, fname, lnum = DebugConsole:functionHelp(game.state.entityFilterPost)
_M.filter_help = _M.filter_help.."\n#GOLD#FILTER HELP#LAST# "..formatHelp(lines, fname, lnum)

lines, fname, lnum = DebugConsole:functionHelp(game.state.generateRandart)
_M.data_help = "#GOLD#RANDART DATA HELP#LAST# "..formatHelp(lines, fname, lnum)

lines, fname, lnum = DebugConsole:functionHelp(resolvers.resolveObject)
_M.resolver_genObj_help = "#GOLD#resolvers.resolveObject#LAST# "..formatHelp(lines, fname, lnum)

--- configure resolvers that can be used
_M.resolver_choices = {{name="None", resolver=nil, desc="Don't apply a resolver"},
	{name="Equipment", resolver="equip", desc="Object will be equipped if possible, otherwise added to main inventory",
	generate=function(dialog) -- generate an object, forcing antimagic check
		local res_input, ok, t
		if dialog._random_filter then
			ok, t = dialog:interpretTable(dialog._random_filter, "equip resolver filter")
			if not ok then return end
			res_input = t
		end
		res_input = res_input or {}
		res_input.check_antimagic = true
		_M._random_filter_table = res_input
		return resolvers.resolveObject(_M.actor, res_input, false, 5)
	end,
	},
	{name="Inventory", resolver="inventory", desc="Object added to main inventory"},
	{name="Drops", resolver="drops", desc="Object added to main inventory (dropped on death)"},
	{name="Attach Tinker", resolver="attachtinker", desc="Tinker will be attached to a worn object"},
	{name="Drop Randart (auto data)", resolver="drop_randart", desc="Random Artifact (dropped on death) added to main inventory, uses the Base Object or Base Filter plus Randart Data as input",
	generate=function(dialog) -- build input from Randart Data and the base object filter
		local res_input, ok, t = {}
		if dialog._randart_data then
			ok, t = dialog:interpretTable(dialog._randart_data, "Randart Data")
			if not ok then return end
			res_input.data = t
		end
		if res_input.data and _M._base_object then
			res_input.data.base = _M._base_object
		else
			ok, t = dialog:interpretTable(dialog._base_filter, "base object filter")
			if not ok then return end
			res_input.filter = t
		end
		res_input.no_add = true
		_M._drop_randart_input = res_input
		return resolvers.calc.drop_randart({res_input}, dialog.actor)
	end,
	accept=function(o, filter, dialog)
		local res_input = table.clone(_M._drop_randart_input) or {}
		res_input._use_object = o
		res_input.no_add = nil
		local res = resolvers.drop_randart(res_input)
		return resolvers.calc.drop_randart(res, dialog.actor)
	end
	},
	{name="Drop Randart", resolver="drop_randart", desc="Random Artifact (dropped on death) added to main inventory",
	generate=function(dialog) -- drop_randart using the random filter as its input
		local res_input, ok, t
		if dialog._random_filter then
			ok, t = dialog:interpretTable(dialog._random_filter, "drop_randart data")
			if not ok then return end
			res_input = t
		end
		res_input = res_input or {}
		res_input.no_add = true
		_M._drop_randart_input = res_input
		return resolvers.calc.drop_randart({res_input}, dialog.actor)
	end,
	accept=function(o, filter, dialog)
		local res_input = table.clone(_M._drop_randart_input) or {}
		res_input._use_object = o
		res_input.no_add = nil
		local res = resolvers.drop_randart(res_input)
		return resolvers.calc.drop_randart(res, dialog.actor)
	end
	},
}

for i, item in ipairs(_M.resolver_choices) do
	item.desc = "#SALMON#"..item.desc.."#LAST#\n"
	item.resolver_num = i
	if item.resolver and resolvers[item.resolver] then
		local lines, fname, lnum = DebugConsole:functionHelp(resolvers[item.resolver])
		item.help = "resolver_help_"..item.resolver
		_M[item.help] = "#GOLD#RESOLVER HELP#LAST#\n"..item.desc.."#GOLD#resolvers."..item.resolver.."#LAST# "..formatHelp(lines, fname, lnum).."\n".._M.resolver_genObj_help
	end
	item.help = item.help or "resolver_genObj_help"
end
_M.resolver_num = 1 -- default to no resolver

-- object_list to use? (Not for now)

function _M:init(actor)
	_M.actor = actor or _M.actor or game.player
	if not game.level:hasEntity(_M.actor) then _M.actor = game.player end
	engine.ui.Dialog.init(self, "DEBUG -- Create Random Object", 1, 1)

	local tops={0} self.tops = tops
	
	local dialog_txt = Textzone.new{auto_width=true, auto_height=true, no_color_bleed=true, font=self.font,
	text=([[Generate objects randomly subject to filters and create Random Artifacts.
Use "Generate" to create objects for preview and inspection.
Use "Add Object" to choose where to put the object and add it to the game.
(Mouse over controls for a preview of the generated object/working Actor. (Press #GOLD#'L'#LAST# to lua inspect.)
#SALMON#Resolvers#LAST# act on the working actor (default: player) to generate a SINGLE object.
They use the #LIGHT_GREEN#Random filter#LAST# as input unless noted otherwise and control object destination.
Filters are interpreted by ToME and engine entity/object generation functions (game.zone:checkFilter, etc.).
Interpretation of tables is within the _G environment (used by the Lua Console) using the current zone's #YELLOW_GREEN#object_list#LAST#.
Hotkeys: #GOLD#'F1'#LAST# :: context sensitive help, #GOLD#'C'#LAST# :: Working Character Sheet, #GOLD#'I'#LAST# :: Working Character Inventory.
]])}

	self.dialog_txt = dialog_txt
	
	local random_info = Textzone.new{auto_width=true, auto_height=true, no_color_bleed=true, font=self.font,
	text=([[The #LIGHT_GREEN#Random Filter#LAST# controls random generation of a normal object.]]):format()}
	self.random_info = random_info
	tops[#tops+1]=tops[#tops] + dialog_txt.h + random_info.h + 10
	
	if not _M._random_object then self:generateRandom() end

	local function object_text(prefix, obj)
		local txt
		if obj then
			txt = obj:getName({do_color=true})
		else
			txt = "#GREY#None#LAST#"
		end
		return ([[%s: %s]]):format(prefix or "Object", txt)
	end
	
	local random_refresh = self.newButton{text="Generate", _object_field="_random_object",
		fct=function()
			self:generateRandom()
			self.random_txt:refresh(_M._random_object)
			self.random_refresh.on_select()
		end,
		help_display = "filter_help"
	}
	self.random_refresh = random_refresh
	tops[#tops+1]=tops[#tops] + random_refresh.h + 5
	
	local random_make = self.newButton{text="Add Object", _object_field="_random_object",
		fct=function()
			self:acceptObject(_M._random_object, true, _M._random_filter_table)
		end,
		help_display = "filter_help"
	}
	self.random_make = random_make
	
	local random_reset_filter = self.newButton{text="Default Filter", _object_field="_random_object",
		fct=function()
			_M._random_filter = _M._default_random_filter
			self.rf_box:setText(_M._random_filter)
		end,
		help_display = "filter_help"
	}
	self.random_reset_filter = random_reset_filter
	
	local random_clear = self.newButton{text="Clear Object", _object_field="_random_object",
		fct=function()
			if _M._random_object then
				_M._random_object = nil
			end
			self.random_txt:refresh(_M._random_object)
			self.random_txt:generate() -- force redraw
			game.tooltip:erase()
		end,
		help_display = "filter_help"
	}
	self.random_clear = random_clear
	
	local random_txt = Textzone.new{width=500, auto_height=true, height=random_refresh.h, no_color_bleed=true, font=self.font,
	text=object_text("#LIGHT_GREEN#Random Object#LAST#", _M._random_object), can_focus=true}
	random_txt.refresh = function(self, object)
		self.text = object_text("#LIGHT_GREEN#Random Object#LAST#", object)
		self:generate()
	end
	random_txt.on_focus = function() _M:tooltip(_M._random_object) _M.help_display = "filter_help" end
	self.random_txt = random_txt
	
	local rf_box = _M.newTextbox{title="#LIGHT_GREEN#Random Filter:#LAST# ", text=_M._random_filter or "{}", chars=120, max_len=1000,
		fct=function(text)
			_M._random_filter = text
			self:generateRandom()
			self.random_refresh.on_select()
			self.random_txt:refresh(_M._random_object)
		end,
		on_change=function(text)
			_M._random_filter = text
		end
	}
	self.rf_box = rf_box
	tops[#tops+1]=tops[#tops] + rf_box.h + 10

	local base_info = Textzone.new{auto_width=true, auto_height=true, no_color_bleed=true, font=self.font,
	text=([[The #LIGHT_BLUE#Base Filter#LAST# is to generate a base object for building a Randart.]]):format()}
	self.base_info = base_info
	tops[#tops+1]=tops[#tops] + base_info.h + 5
	
	
	local base_txt = Textzone.new{width=500, auto_height=true, height=random_refresh.h, no_color_bleed=true, font=self.font,
	text = object_text("#LIGHT_BLUE#Base Object#LAST#", _M._base_object), can_focus=true}
	base_txt.refresh = function(self, object)
		self.text = object_text("#LIGHT_BLUE#Base Object#LAST#", _M._base_object)
		self:generate()
	end
	base_txt.on_focus = function() _M:tooltip(_M._base_object) _M.help_display = "filter_help" end
	self.base_txt = base_txt

	local base_refresh = self.newButton{text="Generate", _object_field="_base_object", no_finish=true,
		fct=function()
			self:generateBase()
			self.base_txt:refresh(_M._base_object)
			self.base_refresh.on_select()
		end,
		help_display = "filter_help"
	}
	self.base_refresh = base_refresh
	tops[#tops+1]=tops[#tops] + base_refresh.h + 5
	
	local base_make = self.newButton{text="Add Object", _object_field="_base_object",
		fct=function()
			self:acceptObject(_M._base_object, false, _M._base_filter_table)
		end,
		help_display = "filter_help"
	}
	self.base_make = base_make
	
	local base_reset_filter = self.newButton{text="Default Filter", _object_field="_base_object",
		fct=function()
			_M._base_filter = _M._default_base_filter
			self.bf_box:setText(_M._base_filter)
		end,
		help_display = "filter_help"
	}
	self.base_reset_filter = base_reset_filter

	local base_clear = self.newButton{text="Clear Object", _object_field="_base_object",
		fct=function()
			if _M._base_object then
				_M._base_object = nil
			end
			self.base_txt:refresh(_M._base_object)
			self.base_txt:generate() -- force redraw
			game.tooltip:erase()
		end,
		help_display = "filter_help"
	}
	self.base_clear = base_clear
	
	local bf_box = _M.newTextbox{title="#LIGHT_BLUE#Base Filter:#LAST# ", text=_M._base_filter or "{}", chars=120, max_len=1000,
		fct=function(text)
			_M._base_filter = text
			self:generateBase()
			self.base_refresh:on_select()
			self.base_txt:refresh(_M._base_object)
		end,
		on_change=function(text)
			_M._base_filter = text
			game:saveSettings("tome.cheat_create_object_default_filter", ("tome.cheat_create_object_default_filter = %q\n"):format(text))
		end,
		help_display = "filter_help"
	}
	self.bf_box = bf_box
	tops[#tops+1]=tops[#tops] + bf_box.h + 10

	local resolver_info = Textzone.new{auto_width=true, auto_height=true, no_color_bleed=true, font=self.font,
	text=([[#SALMON#Resolver selected:#LAST# ]]):format()}
	resolver_info.on_focus = function(id, ui)
		_M.help_display = "resolver_genObj_help"
		game:tooltipDisplayAtMap(game.w, game.h, "An object resolver interprets additional filter fields to generate an object and determine where it will go.", nil, true)
	end
	self.resolver_info = resolver_info
	
	local resolver_sel = Dropdown.new{text="Dropdown text", width=200, nb_items=#_M.resolver_choices,
		list = _M.resolver_choices,
		fct=function(item)
			_M.resolver_num = item.resolver_num
		end,
		on_select=function(item, sel)
			_M.help_display = item.help
			game:tooltipDisplayAtMap(game.w, game.h, item.desc or "No Tooltip", nil, true)
		end,
	}
	resolver_sel.on_focus = function(r_sel, ui)
		_M.help_display = "resolver_genObj_help"
		local sel = r_sel.c_list and r_sel.c_list.sel
		if sel then _M.help_display = r_sel.c_list.list[sel].help end
		game:tooltipDisplayAtMap(game.w, game.h, "Use this selector to choose which resolver to use", nil, true)
	end
	self.resolver_sel = resolver_sel
	
	local randart_info = Textzone.new{auto_width=true, auto_height=true, no_color_bleed=true, font=self.font,
	text=([[#ORANGE#Randart Data#LAST# contains parameters used to generate a Randart (interpreted by game.state:generateRandart).
The #LIGHT_BLUE#Base Object#LAST# will be used if possible.]]):format()}
	self.randart_info = randart_info
	tops[#tops+1]=tops[#tops] + randart_info.h + 5

	local randart_refresh = self.newButton{text="Generate", _object_field="_randart",
		fct=function()
			self:generateRandart()
			self.randart_txt:refresh(_M._randart)
			self.randart_refresh.on_select()
		end,
		help_display = "data_help"
	}
	self.randart_refresh = randart_refresh
	tops[#tops+1]=tops[#tops] + randart_refresh.h + 5
	
	local randart_make = self.newButton{text="Add Object", _object_field="_randart",
		fct=function()
			self.randart_txt:refresh(_M._randart)
			self:acceptObject(_M._randart)
		end,
		help_display = "data_help"
	}
	self.randart_make = randart_make
	
	local randart_reset_data = self.newButton{text="Default Data", _object_field="_randart",
		fct=function()
			_M._randart_data = _M._default_randart_data
			self.randart_data_box:setText(_M._randart_data)
		end,
		help_display = "data_help"
	}
	self.randart_reset_data = randart_reset_data
	
	local randart_data_box = _M.newTextbox{title="#ORANGE#Randart Data:#LAST# ", text=_M._randart_data or "{}", chars=120, max_len=1000,
		fct=function(text)
			_M._randart_data = text
			self:generateRandart()
			self.randart_refresh.on_select()
			self.randart_txt:refresh(_M._randart)
		end,
		on_change=function(text)
			_M._randart_data = text
			game:saveSettings("tome.cheat_create_object_default_randart_data", ("tome.cheat_create_object_default_randart_data = %q\n"):format(text))
		end,
		help_display = "data_help"
	}
	self.randart_data_box = randart_data_box
	tops[#tops+1]=tops[#tops] + randart_data_box.h + 5
	
	local randart_txt = Textzone.new{width=600, auto_height=true, height=random_refresh.h, no_color_bleed=true, font=self.font,
	text=object_text("#ORANGE#Randart#LAST#", _M._randart), can_focus=true}
	randart_txt.refresh = function(self, object)
		self.text = object_text("#ORANGE#Randart#LAST#", object)
		self:generate()
	end
	randart_txt.on_focus = function() _M:tooltip(_M._randart) _M.help_display = "data_help" end
	self.randart_txt = randart_txt

	local show_inventory = _M.newButton{text="Show #GOLD#I#LAST#nventory", _object_field="actor",
		fct=function() self:showInventory()	end,
	}
	self.show_inventory = show_inventory
	
	local show_character_sheet = _M.newButton{text="Show #GOLD#C#LAST#haracter Sheet", _object_field="actor",
		fct=function() self:characterSheet() end,
	}
	self.show_character_sheet = show_character_sheet

	local set_actor = _M.newButton{text="Set working actor: "..("[%s] %s"):format(_M.actor.uid, _M.actor.name), _object_field="actor",
		fct=function() self:setWorkingActor() end,
	}
	set_actor.update = function(ui)
		ui.text = "Set working actor: "..("[%s] %s%s"):format(_M.actor.uid, _M.actor.name, _M.actor.player and " #LIGHT_GREEN#(player)#LAST#" or "")
		ui:generate()
	end
	set_actor:update()
	self.set_actor = set_actor
	
	self:loadUI{
		{left=0, top=tops[1], ui=dialog_txt},
		{left=0, top=tops[1]+dialog_txt.h+5, ui=random_info},
		
		{left=rf_box.w-resolver_info.w-resolver_sel.w+5, top=tops[2]-resolver_info.h, ui=resolver_info},
		{left=rf_box.w-resolver_sel.w+10, top=tops[2]-resolver_sel.h, ui=resolver_sel},
		
		{left=0, top=tops[2], ui=random_refresh},
		{left=random_refresh.w + 10, top=tops[2], ui=random_make},
		{left=random_refresh.w+random_make.w+15, top=tops[2], ui=random_reset_filter},
		{left=random_refresh.w+random_make.w+random_reset_filter.w+20, top=tops[2], ui=random_clear},
		{left=random_refresh.w+random_make.w+random_clear.w+random_reset_filter.w+25, top=tops[2]+(random_refresh.h-random_txt.h)/2, ui=random_txt},
		{left=0, top=tops[3], ui=rf_box},
		
		{left=0, top=tops[4], ui=base_info},
		{left=0, top=tops[5], ui=base_refresh},
		{left=random_refresh.w + 10, top=tops[5], ui=base_make},
		{left=random_refresh.w+random_make.w+15, top=tops[5], ui=base_reset_filter},
		{left=random_refresh.w+random_make.w+base_reset_filter.w + 20, top=tops[5], ui=base_clear},
		{left=random_refresh.w+random_make.w+random_clear.w+base_reset_filter.w+25, top=tops[5]+(base_refresh.h-base_txt.h)/2, ui=base_txt},
		{left=0, top=tops[6], ui=bf_box},
		
		{left=0, top=tops[7], ui=randart_info},
		{left=0, top=tops[8], ui=randart_refresh},
		{left=randart_refresh.w+10, top=tops[8], ui=randart_make},
		{left=randart_refresh.w+randart_make.w + 15, top=tops[8], ui=randart_reset_data},
		{left=randart_refresh.w+randart_make.w+randart_reset_data.w+20, top=tops[8]+(randart_refresh.h-randart_txt.h)/2, ui=randart_txt},
		{left=0, top=tops[9], ui=randart_data_box},
		{left=5, top=tops[10], ui=show_inventory},
		{left=show_inventory.w+10, top=tops[10], ui=show_character_sheet},
		{left=show_inventory.w+show_character_sheet.w+15, top=tops[10], ui=set_actor},
	}

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
		_F1 = function() self:help() end,
		__TEXTINPUT = function(c)
			if (c == 'i' or c == 'I') then
				self:showInventory()
			end
			if (c == 'c' or c == 'C') then
				self:characterSheet()
			end
		end,
		}
	
	if self.resolver_sel.c_list then
		resolver_sel.c_list:select(_M.resolver_num or 1)
		resolver_sel.c_list.key:addCommands{
			_F1 = function() -- help for resolver drop-down list
			self:help()
			end,}
	end
end

--- display the tooltip for an object or actor
function _M:tooltip(what)
	if what then
		if what.__CLASSNAME == "mod.class.Object" then
			game:tooltipDisplayAtMap(game.w, game.h, what:getDesc({do_color=true}, nil, true, _M.actor), nil, true)
		elseif what.__is_actor then
			game:tooltipDisplayAtMap(game.w, game.h, what:tooltip(what.x, what.y, what), nil, true)
		end
	else
		game:tooltipDisplayAtMap(game.w, game.h, "#GREY#No Tooltip to Display#LAST#", nil, true)
	end
end

--- Display context sensitive help (at upper left)
function _M:help()
	local d = Dialog:simpleLongPopup("Filter/Data/Resolver Reference", 
([[%s]]):format(_M[_M.help_display] or _M.filter_help), math.max(500, game.w/2)
		)
	engine.Dialog.resize(d, d.w, d.h, 25, 25)
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
	self.no_finish = t.no_finish
	self._object_field = t._object_field or "_random_object"
	self.help_display = t.help_display
	self.on_select = function()
		_M.help_display = self.help_display or _M.help_display
		_M:tooltip(_M[self._object_field])
		self.key:addCommands{
		_l = function() -- lua inspect object
			if core.key.modState("ctrl") then
				game.key:triggerVirtual("LUA_CONSOLE")
				return
			end
			local obj = _M[self._object_field]
			if obj then
				game.log("#LIGHT_BLUE#Lua Inspect [%s] %s", obj.uid, obj.name)
				local DebugConsole = require"engine.DebugConsole"
				local d = DebugConsole.new()
				game:registerDialog(d)
				DebugConsole.line = "=__uids["..obj.uid.."]"
				DebugConsole.line_pos = #DebugConsole.line
				d.changed = true
			else
				game.log("#LIGHT_BLUE#Nothing to Lua inspect")
			end
		end,
		}
	end
	return self
end

--- Generate an object using a filter
function _M:generateByFilter(filter)
	local o = game.zone:makeEntity(game.level, "object", filter, nil, true)
	return o
end

--- translate text into a table
function _M:interpretTable(text, label)
	local ok, t
	local fx = loadstring("return "..tostring(text))
	if fx then
		setfenv(fx, _G)
		ok, t = pcall(fx)
	end
	if not ok or t and type(t) ~= "table" then
		game.log("#LIGHT_BLUE#Bad %s: %s", label or "table definition", text)
		return ok
	end
	return ok, t
end

--- generate random object using the selected resolver if needed
function _M:generateRandom()
	local ok, filter = self:interpretTable(_M._random_filter, "random object filter")
	if not ok then return end
	_M._random_filter_table = filter
	local o
	local apply_resolver = _M.resolver_num and _M.resolver_choices[_M.resolver_num]
	local r_name = apply_resolver and apply_resolver.resolver
	if r_name then -- generate the object using the resolver's base code, but don't add it to the game
		game.log("#LIGHT_BLUE# Generate Random object using resolver: %s", r_name)
		if apply_resolver.generate then
			ok, o = pcall(apply_resolver.generate, self)
		else
			ok, o = pcall(resolvers.resolveObject, _M.actor, filter, false)
		end
	else
		ok, o = pcall(_M.generateByFilter, self, filter)
	end
	if ok then
		if o then
			game.log("#LIGHT_BLUE# New random%s object: %s", r_name and (" (resolver: %s)"):format(r_name) or "", o:getName({do_color=true}))
			_M._random_object = _M:finishObject(o)
		else
			game.log("#LIGHT_BLUE#Could not generate a random object with filter: %s", _M._random_filter)
		end
	else
		print("[DEBUG:RandomObject] random object generation error:", o)
		game.log("#LIGHT_BLUE#ERROR generating random object with filter [%s].\n Error: %s", _M._random_filter, o)
	end
end

--- generate base object for randart generation
function _M:generateBase()
	local ok, filter = self:interpretTable(_M._base_filter, "base object filter")
	if not ok then return end
	_M._base_filter_table = filter
	local o
	ok, o = pcall(_M.generateByFilter, self, filter)
	if ok then
		if o then
			_M._base_object = o
			o:identify(true)
		else
			game.log("#LIGHT_BLUE#Could not generate a base object with filter: %s", _M._base_filter)
		end
	else
		print("[DEBUG:RandomObject] Base object generation error:", o)
		game.log("#LIGHT_BLUE#ERROR generating base object with filter [%s].\n Error:%s", _M._base_filter, o)
	end
end

--- generate Randart
function _M:generateRandart()
	local ok, data = self:interpretTable(_M._randart_data, "Randart Data")
	if not ok then return end
	
	local base = _M._base_object
	data = data or {}
	if base then data.base = data.base or base end

	local o
	ok, o = pcall(game.state.generateRandart, game.state, data)
	if ok then
		if o then
			o._debug_finished = false
			_M._randart = _M:finishObject(o)
		else
			game.log("#LIGHT_BLUE#Could not generate a Randart with data: %s", _M._randart_data)
		end
	else
		print("[DEBUG:RandomObject] Randart creation error:", o)
		game.log("#LIGHT_BLUE#ERROR generating Randart with data [%s].\n Error:%s", _M._randart_data, o)
	end
end

-- finish generating the object (without adding it to the game)
function _M:finishObject(object)
	if object and not object._debug_finished then
		object._debug_finished = true
		object = game.zone:finishEntity(game.level, "object", object)
		object:identify(true)
	end
	return object
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

--- Add the object to the game, possibly using a resolver to do so
function _M:acceptObject(o, apply_resolver, filter)
	if not o then game.log("#LIGHT_BLUE#No object to add") return end
	apply_resolver = apply_resolver and _M.resolver_num and _M.resolver_choices[_M.resolver_num]
	local r_name = apply_resolver and apply_resolver.resolver
	if r_name then -- place the object according to the resolver
		o = o:cloneFull()
		local ok, ret
		--		game.log("#LIGHT_BLUE#Accept object %s with resolver %s", o:getName({do_color=true, no_add_name=true}), r_name)
		if apply_resolver.accept then
			ok, ret = pcall(apply_resolver.accept, o, filter, self)
		else
			local res_input = table.clone(filter) or {}
			res_input._use_object = o
			local res = resolvers[r_name]({res_input})
			ok, ret = pcall(resolvers.calc[r_name], res, _M.actor)
		end
		if not ok then
			print("[DEBUG:acceptObject] resolver error:", ret)
			game.log("#LIGHT_BLUE#ERROR accepting object with resolver %s.\n Error:%s", r_name, ret)
			return
		end
		-- report location of the object
		CreateItem.findObject(self, o, _M.actor)
	else -- select destination directly
		CreateItem.acceptObject(self, o, _M.actor)
	end
end

--- Set the working actor (default for resolvers and object placement)
function _M:setWorkingActor()
	local p = game.player
	game:unregisterDialog(self)
	local tg = {type="hit", range=100, nolock=true, no_restrict=true, nowarning=true, no_start_scan=true, act_exclude={[p.uid]=true}}
	local x, y, act
	local co = coroutine.create(function()
		x, y, act = p:getTarget(tg)
		if x and y then
			if act then
				game.log("#LIGHT_BLUE#Working Actor set to [%s]%s at (%d, %d)", act.uid, act.name, x, y)
				_M.actor = act
				self.set_actor:update()
			end
		end
		game:registerDialog(self)
	end)
	coroutine.resume(co)
end

--- show the inventory screen for the working actor
function _M:showInventory()
	local d
	local titleupdator = _M.actor:getEncumberTitleUpdator("Inventory")
	d = require("mod.dialogs.ShowEquipInven").new(titleupdator(), _M.actor, nil,
		function(o, inven, item, button, event)
			if not o then return end
			local ud = require("mod.dialogs.UseItemDialog").new(event == "button", _M.actor, o, item, inven, function(_, _, _, stop)
				d:generate()
				d:generateList()
				d:updateTitle(titleupdator())
				if stop then game:unregisterDialog(d) -- game:unregisterDialog(self)
				end
			end)
			game:registerDialog(ud)
		end
		)
	game:registerDialog(d)
	d._actor_to_compare = d._actor_to_compare or game.player:clone() -- save comparison info
end

--- Open character sheet for the working actor
function _M:characterSheet()
	local d = require("mod.dialogs.CharacterSheet").new(_M.actor, "equipment")
	game:registerDialog(d)
end