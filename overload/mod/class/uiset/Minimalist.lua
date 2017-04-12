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
local UI = require "engine.ui.Base"
local UISet = require "mod.class.uiset.UISet"
local DebugConsole = require "engine.DebugConsole"
local HotkeysDisplay = require "engine.HotkeysDisplay"
local HotkeysIconsDisplay = require "engine.HotkeysIconsDisplay"
local ActorsSeenDisplay = require "engine.ActorsSeenDisplay"
local LogDisplay = require "engine.LogDisplay"
local LogFlasher = require "engine.LogFlasher"
local FlyingText = require "engine.FlyingText"
local Shader = require "engine.Shader"
local ActorResource = require "engine.interface.ActorResource"
local Tooltip = require "mod.class.Tooltip"
local TooltipsData = require "mod.class.interface.TooltipsData"
local Dialog = require "engine.ui.Dialog"
local Map = require "engine.Map"
local FontPackage = require "engine.FontPackage"

module(..., package.seeall, class.inherit(UISet, TooltipsData))

local function imageLoader(file)
	local sfile = "/data/gfx/"..UI.ui.."-ui/minimalist/"..file
	if fs.exists(sfile) then
		return core.display.loadImage(sfile)
	else
		return core.display.loadImage( "/data/gfx/ui/"..file)
	end
end

local move_handle = {imageLoader("move_handle.png"):glTexture()}

local frames_colors = {
	ok = {0.3, 0.6, 0.3},
	sustain = {0.6, 0.6, 0},
	cooldown = {0.6, 0, 0},
	disabled = {0.65, 0.65, 0.65},
}

-- Load the various shaders used to display resources
air_c = {0x92/255, 0xe5, 0xe8}
air_sha = Shader.new("resources", {require_shader=4, delay_load=true, color=air_c, speed=100, amp=0.8, distort={2,2.5}})
life_c = {0xc0/255, 0, 0}
life_sha = Shader.new("resources", {require_shader=4, delay_load=true, color=life_c, speed=1000, distort={1.5,1.5}})
shield_c = {0.5, 0.5, 0.5}
shield_sha = Shader.new("resources", {require_shader=4, delay_load=true, color=shield_c, speed=5000, a=0.5, distort={0.5,0.5}})
psi_sha = Shader.new("resources", {require_shader=4, delay_load=true, color={colors.BLUE.r/255, colors.BLUE.g/255, colors.BLUE.b/255}, speed=2000, distort={0.4,0.4}})
feedback_c = {colors.YELLOW.r/255, colors.YELLOW.g/255, colors.YELLOW.b/255}
feedback_sha = Shader.new("resources", {require_shader=4, delay_load=true, color=feedback_c, speed=2000, distort={0.4,0.4}})
fortress_c = {0x39/255, 0xd5/255, 0x35/255}
fortress_sha = Shader.new("resources", {require_shader=4, delay_load=true, color=fortress_c, speed=2000, distort={0.4,0.4}})
save_c = {colors.GOLD.r/255, colors.GOLD.g/255, colors.GOLD.b/255}
save_sha = Shader.new("resources", {require_shader=4, delay_load=true, color=save_c, speed=1000, distort={1.6,0.2}})

sshat = {imageLoader("resources/shadow.png"):glTexture()}
bshat = {imageLoader("resources/back.png"):glTexture()}
shat = {imageLoader("resources/fill.png"):glTexture()}
fshat = {imageLoader("resources/front.png"):glTexture()}
fshat_life = {imageLoader("resources/front_life.png"):glTexture()}
fshat_life_dark = {imageLoader("resources/front_life_dark.png"):glTexture()}
fshat_shield = {imageLoader("resources/front_life_armored.png"):glTexture()}
fshat_shield_dark = {imageLoader("resources/front_life_armored_dark.png"):glTexture()}
fshat_feedback = {imageLoader("resources/front_psi.png"):glTexture()}
fshat_feedback_dark = {imageLoader("resources/front_psi_dark.png"):glTexture()}
fshat_air = {imageLoader("resources/front_air.png"):glTexture()}
fshat_air_dark = {imageLoader("resources/front_air_dark.png"):glTexture()}
fshat_fortress = {imageLoader("resources/front_fortress.png"):glTexture()}
fshat_fortress_dark = {imageLoader("resources/front_fortress_dark.png"):glTexture()}

fshat_hourglass = {imageLoader("resources/hourglass_front.png"):glTexture()}
sshat_hourglass = {imageLoader("resources/hourglass_shadow.png"):glTexture()}
shat_hourglass_top = {imageLoader("resources/hourglass_top.png"):glTexture()}
shat_hourglass_bottom = {imageLoader("resources/hourglass_bottom.png"):glTexture()}

ammo_shadow_default = {imageLoader("resources/ammo_shadow_default.png"):glTexture()}
ammo_default = {imageLoader("resources/ammo_default.png"):glTexture()}
ammo_shadow_arrow = {imageLoader("resources/ammo_shadow_arrow.png"):glTexture()}
ammo_arrow = {imageLoader("resources/ammo_arrow.png"):glTexture()}
ammo_shadow_shot = {imageLoader("resources/ammo_shadow_shot.png"):glTexture()}
ammo_shot = {imageLoader("resources/ammo_shot.png"):glTexture()}
_M['ammo_shadow_alchemist-gem'] = {imageLoader("resources/ammo_shadow_alchemist-gem.png"):glTexture()}
_M['ammo_alchemist-gem'] = {imageLoader("resources/ammo_alchemist-gem.png"):glTexture()}

font_sha = core.display.newFont(chn123_tome_font(), 14, true)
font_sha:setStyle("bold")
sfont_sha = core.display.newFont(chn123_tome_font(), 12, true)
sfont_sha:setStyle("bold")

icon_green = { imageLoader("talent_frame_ok.png"):glTexture() }
icon_yellow = { imageLoader("talent_frame_sustain.png"):glTexture() }
icon_red = { imageLoader("talent_frame_cooldown.png"):glTexture() }

local portrait = {imageLoader("party-portrait.png"):glTexture()}
local portrait_unsel = {imageLoader("party-portrait-unselect.png"):glTexture()}
local portrait_lev = {imageLoader("party-portrait-lev.png"):glTexture()}
local portrait_unsel_lev = {imageLoader("party-portrait-unselect-lev.png"):glTexture()}

local pf_bg_x, pf_bg_y = 0, 0
local pf_player_x, pf_player_y = 0, 0
local pf_bg = {imageLoader("playerframe/back.png"):glTexture()}
local pf_shadow = {imageLoader("playerframe/shadow.png"):glTexture()}
local pf_defend = {imageLoader("playerframe/defend.png"):glTexture()}
local pf_attackdefend_x, pf_attackdefend_y = 0, 0
local pf_attack = {imageLoader("playerframe/attack.png"):glTexture()}
local pf_levelup_x, pf_levelup_y = 0, 0
local pf_levelup = {imageLoader("playerframe/levelup.png"):glTexture()}
local pf_encumber_x, pf_encumber_y = 0, 0
local pf_encumber = {imageLoader("playerframe/encumber.png"):glTexture()}
local pf_exp_x, pf_exp_y = 0, 0
local pf_exp = {imageLoader("playerframe/exp.png"):glTexture()}
local pf_exp_levelup = {imageLoader("playerframe/exp_levelup.png"):glTexture()}
local pf_money_x, pf_money_y = 0, 0
local pf_exp_cur_x, pf_exp_cur_y = 0, 0
local pf_name_x, pf_name_y = 0, 0
local pf_level_x, pf_level_y = 0, 0

local mm_bg_x, mm_bg_y = 0, 0
local mm_bg = {imageLoader("minimap/back.png"):glTexture()}
local mm_comp = {imageLoader("minimap/compass.png"):glTexture()}
local mm_shadow = {imageLoader("minimap/shadow.png"):glTexture()}
local mm_transp = {imageLoader("minimap/transp.png"):glTexture()}

local tb_bg = {imageLoader("hotkeys/icons_bg.png"):glTexture()}
local tb_talents = {imageLoader("hotkeys/talents.png"):glTexture()}
local tb_inven = {imageLoader("hotkeys/inventory.png"):glTexture()}
local tb_lore = {imageLoader("hotkeys/lore.png"):glTexture()}
local tb_quest = {imageLoader("hotkeys/quest.png"):glTexture()}
local tb_mainmenu = {imageLoader("hotkeys/mainmenu.png"):glTexture()}
local tb_padlock_open = {imageLoader("padlock_open.png"):glTexture()}
local tb_padlock_closed = {imageLoader("padlock_closed.png"):glTexture()}

local hk1 = {imageLoader("hotkeys/hotkey_1.png"):glTexture()}
local hk2 = {imageLoader("hotkeys/hotkey_2.png"):glTexture()}
local hk3 = {imageLoader("hotkeys/hotkey_3.png"):glTexture()}
local hk4 = {imageLoader("hotkeys/hotkey_4.png"):glTexture()}
local hk5 = {imageLoader("hotkeys/hotkey_5.png"):glTexture()}
local hk6 = {imageLoader("hotkeys/hotkey_6.png"):glTexture()}
local hk7 = {imageLoader("hotkeys/hotkey_7.png"):glTexture()}
local hk8 = {imageLoader("hotkeys/hotkey_8.png"):glTexture()}
local hk9 = {imageLoader("hotkeys/hotkey_9.png"):glTexture()}

_M:bindHook("UISet:Minimalist:Load", function(self, data)
	if UI.ui ~= "dark" then return end
	data.alterlocal("pf_bg_y", -5)
	data.alterlocal("pf_attackdefend_x", 8)
	data.alterlocal("pf_attackdefend_y", -8)
	data.alterlocal("pf_player_x", 5)
	data.alterlocal("pf_player_y", -4)
	data.alterlocal("pf_levelup_x", -5)
	data.alterlocal("pf_levelup_y", -9)
	data.alterlocal("pf_exp_x", 10)
	data.alterlocal("pf_exp_y", -1)
	data.alterlocal("pf_level_x", 9)
	data.alterlocal("pf_level_y", -2)
	data.alterlocal("pf_name_x", 10)
	data.alterlocal("pf_name_y", -2)
	data.alterlocal("pf_money_x", 7)
	data.alterlocal("pf_money_y", -2)
	data.alterlocal("pf_exp_cur_x", 7)
	data.alterlocal("pf_exp_cur_y", -1)
	data.alterlocal("mm_bg_x", -5)
	data.alterlocal("mm_bg_y", -3)
end)

-- Note: could use a bit more room for some of the resource texts

-- Additional (optional) resource parameters for the Minimalist UI (defined in ActorResource:resources_def[resource_name].Minimalist):
--	images = {front = <highlighted graphic file path> , front_dark = <unhighlighted graphic file path>}
-- 		(base directories: "/data/gfx/"..UI.ui.."-ui/minimalist/" or "/data/gfx/ui/")
--	highlight = function(player, vc, vn, vm, vr) return true to display the highlighted resource graphic
--		vc, vn, vm, vr = resource current, min, max, regen values
--	shader_params = { shader parameters used to define the shader for the resource bar (merged into default parameters below)
--		display_resource_bar = function(player, shader, x, y, color, a) --function to draw the resource bar within the resource graphic
--			shader = a Shader object to be drawn at x, y with color = vector {r, g, b}/255 and alpha a (0-1)
--			called with the uiset fenv
--			Note: will be called with player = false before the ui is initialized
--	}
-- see Minimalist:initialize_resources, Minimalist:displayResources

-- Default shader parameters used to draw the resource bars
-- Overridden by resource_def.Minimalist.shader_params
_M.shader_params = {default = {name = "resources", require_shader=4, delay_load=true, speed=1000, distort={1.5,1.5}},
	air={name = "resources", require_shader=4, delay_load=true, color=air_c, speed=100, amp=0.8, distort={2,2.5}},
	life={name = "resources", require_shader=4, delay_load=true, color=life_c, speed=1000, distort={1.5,1.5}},
	stamina={name = "resources", require_shader=4, delay_load=true, color={0xff/255, 0xcc/255, 0x80/255}, speed=700, distort={1,1.4}},
	mana={name = "resources", require_shader=4, delay_load=true, color={106/255, 146/255, 222/255}, speed=1000, distort={0.4,0.4}},
	soul={name = "resources", require_shader=4, delay_load=true, color={128/255, 128/255, 128/255}, speed=1200, distort={0.4,-0.4}},
	equilibrium={name = "resources2", require_shader=4, delay_load=true, color1={0x00/255, 0xff/255, 0x74/255}, color2={0x80/255, 0x9f/255, 0x44/255}, amp=0.8, speed=20000, distort={0.3,0.25}},
	paradox={name = "resources2", require_shader=4, delay_load=true, color1={0x2f/255, 0xa0/255, 0xb4/255}, color2={0x8f/255, 0x80/255, 0x44/255}, amp=0.8, speed=20000, distort={0.1,0.25}},
	positive={name = "resources", require_shader=4, delay_load=true, color={colors.GOLD.r/255, colors.GOLD.g/255, colors.GOLD.b/255}, speed=1000, distort={1.6,0.2}},
	negative={name = "resources", require_shader=4, delay_load=true, color={colors.DARK_GREY.r/255, colors.DARK_GREY.g/255, colors.DARK_GREY.b/255}, speed=1000, distort={1.6,-0.2}},
	vim={name = "resources", require_shader=4, delay_load=true, color={210/255, 180/255, 140/255}, speed=1000, distort={0.4,0.4}},
	hate={name = "resources", require_shader=4, delay_load=true, color={0xF5/255, 0x3C/255, 0xBE/255}, speed=1000, distort={0.4,0.4}},
	psi={name = "resources", require_shader=4, delay_load=true, color={colors.BLUE.r/255, colors.BLUE.g/255, colors.BLUE.b/255}, speed=2000, distort={0.4,0.4}},
	feedback={require_shader=4, delay_load=true, speed=2000, distort={0.4,0.4}},
}

_M:triggerHook{"UISet:Minimalist:Load", alterlocal=function(k, v)
	local i = 1
	while true do
		local kk, _ = debug.getlocal(4, i)
		if not kk then break end
		if kk == k then debug.setlocal(4, i, v) break end
		i = i + 1
	end
end }

-- load and set up resource graphics
function _M:initialize_resources()
	local res_gfx = {}
	for res, res_def in ipairs(ActorResource.resources_def) do
		local rname = res_def.short_name

		res_gfx[rname] = table.clone(res_def.minimalist_gfx) or {color = {}, shader = {}} -- use the graphics defined with the resource, if possible
		local res_color = res_def.color or "#WHITE#"

		-- set up color
		if type(res_color) == "string" then
			local r, g, b
			res_color = res_color:gsub("#", ""):upper()
			if colors[res_color] then -- lookup
				r, g, b = colors.unpack(colors[res_color])
				r, g, b = r/255, g/255, b/255
			else -- parse
				r, g, b = colors.hex1unpack(res_color)
			end
			res_gfx[rname].color = {r, g, b}
		else
			res_gfx[rname].color = res_color
		end

		local shad_params = table.clone(_M.shader_params[rname] or _M.shader_params.default)
		local extra_shader_params = table.get(res_def, "Minimalist", "shader_params")
		-- note: Shader init calls all arg functions
		if extra_shader_params then -- update fenv for custom functions
			for p, val in pairs(extra_shader_params) do
				if type(val) == "function" then
					 setfenv(val, getfenv(_M.init))
				end
			end
			table.merge(shad_params, extra_shader_params)
		end
		-- get color from resource_definition.Minimalist.shader_params, then _M.shader_params (defined here), then resource_definition.color
		shad_params.color = table.get(res_def, "Minimalist", "shader_color") or shad_params.color or res_gfx[rname].color
		res_gfx[rname].shader = Shader.new(shad_params.name, shad_params)
		-- optional custom highlight select function
		res_gfx[rname].highlight = table.get(res_def, "Minimalist", "highlight")	
		-- load graphic images
		local res_imgs = table.merge({front = "resources/front_"..rname..".png", front_dark = "resources/front_"..rname.."_dark.png"}, table.get(res_def, "Minimalist", "images") or {})
		local sbase, bbase = "/data/gfx/"..UI.ui.."-ui/minimalist/", "/data/gfx/ui/"
		for typ, file in pairs(res_imgs) do
			local sfile = sbase..file
			local bfile = bbase..file
			if fs.exists(sfile) then -- load the specific image
				print("[Minimalist] resource ui:", rname, "gfx file", sfile, "found")
				res_gfx[rname][typ] = {core.display.loadImage(sfile):glTexture()}
			elseif fs.exists(bfile) then -- load the specific image
				print("[Minimalist] resource base:", rname, "gfx file", bfile, "found")
				res_gfx[rname][typ] = {core.display.loadImage(bfile):glTexture()}
			else -- load a default image (Psi graphics)
				print("[Minimalist] Warning: resource", rname, "gfx file", file, "**NOT FOUND** in directories", sbase, "or", bbase, "(using default image)")
				if typ == "front" then
					res_gfx[rname][typ] = {imageLoader("resources/front_psi.png"):glTexture()}
				else
					res_gfx[rname][typ] = {imageLoader("resources/front_psi_dark.png"):glTexture()}
				end
			end
		end
		-- generate default tooltip if needed
		res_gfx[rname].tooltip = _M["TOOLTIP_"..rname:upper()] or ([[#GOLD#%s#LAST#
%s]]):format(res_def.name, res_def.description or "no description")

	end
	self.res_gfx = res_gfx
end

function _M:init()
	UISet.init(self)

	self.mhandle = {}
	self.res = {}
	self.party = {}
	self.tbuff = {}
	self.pbuff = {}

	self.locked = true

	self.mhandle_pos = {
		player = {x=296, y=73, name="角色信息"},
		resources = {x=fshat[6] / 2 - move_handle[6], y=0, name="能量槽"},
		minimap = {x=208, y=176, name="微缩地图"},
		buffs = {x=40 - move_handle[6], y=0, name="当前效果"},
		party = {x=portrait[6] - move_handle[6], y=0, name="队伍列表"},
		gamelog = {x=function(self) return self.logdisplay.w - move_handle[6] end, y=function(self) return self.logdisplay.h - move_handle[6] end, name="游戏记录"},
		chatlog = {x=function(self) return profile.chat.w - move_handle[6] end, y=function(self) return profile.chat.h - move_handle[6] end, name="在线聊天记录"},
		hotkeys = {x=function(self) return self.places.hotkeys.w - move_handle[6] end, y=function(self) return self.places.hotkeys.h - move_handle[6] end, name="热键"},
		mainicons = {x=0, y=0, name="游戏设定"},
	}

	self:resetPlaces()
	table.merge(self.places, config.settings.tome.uiset_minimalist and config.settings.tome.uiset_minimalist.places or {}, true)

	local w, h = core.display.size()

	-- Adjsut to account for resolution change
	if config.settings.tome.uiset_minimalist and config.settings.tome.uiset_minimalist.save_size then
		local ow, oh = config.settings.tome.uiset_minimalist.save_size.w, config.settings.tome.uiset_minimalist.save_size.h

		-- Adjust UI
		local w2, h2 = math.floor(ow / 2), math.floor(oh / 2)
		for what, d in pairs(self.places) do
			if d.x > w2 then d.x = d.x + w - ow end
			if d.y > h2 then d.y = d.y + h - oh end
		end
	end

	self.sizes = {}

	self.tbbuttons = {inven=0.6, talents=0.6, mainmenu=0.6, lore=0.6, quest=0.6}

	self.buffs_base = UI:makeFrame("ui/icon-frame/frame", 40, 40)
	self:initialize_resources()
end

function _M:isLocked()
	return self.locked
end

function _M:switchLocked()
	self.locked = not self.locked
	if self.locked then
		game.bignews:say(60, "#CRIMSON#Interface locked, mouse enabled on the map")
	else
		game.bignews:say(60, "#CRIMSON#Interface unlocked, mouse disabled on the map")
	end
end

function _M:getMainMenuItems()
	return {
		{"重置界面布局", function() Dialog:yesnoPopup("Reset UI", "Reset all the interface?", function(ret) if ret then
			self:resetPlaces() self:saveSettings() 
		end end) end},
	}
end

--- Forbid some options from showing up, they are useless for this ui
function _M:checkGameOption(name)
	local list = table.reverse{"icons_temp_effects", "icons_hotkeys", "hotkeys_rows", "log_lines"}
	return not list[name]
end

function _M:resetPlaces()
	local w, h = core.display.size()

	local th = 52
	if config.settings.tome.hotkey_icons then th = (8 + config.settings.tome.hotkey_icons_size) * config.settings.tome.hotkey_icons_rows end
	local hup = h - th

	self.places = {
		player = {x=0, y=0, scale=1, a=1},
		resources = {x=0, y=111, scale=1, a=1},
		minimap = {x=w - 239, y=0, scale=1, a=1},
		buffs = {x=w - 40, y=200, scale=1, a=1},
		party = {x=pf_bg[6], y=0, scale=1, a=1},
		gamelog = {x=0, y=hup - 210, w=math.floor(w/2), h=200, scale=1, a=1},
		chatlog = {x=math.floor(w/2), y=hup - 210, w=math.floor(w/2), h=200, scale=1, a=1},
		mainicons = {x=w - tb_bg[6] * 0.5, y=h - tb_bg[7] * 6 * 0.5 - 5, scale=1, a=1},
		hotkeys = {x=10, y=h - th, w=w-60, h=th, scale=1, a=1},
	}
end

function _M:boundPlaces(w, h)
	w = w or game.w
	h = h or game.h

	for what, d in pairs(self.places) do
		if d.x then
			d.x = math.floor(d.x)
			d.y = math.floor(d.y)
			if d.w and d.h then
				d.scale = 1

				d.x = util.bound(d.x, 0, w - d.w)
				d.y = util.bound(d.y, 0, h - d.h)
			elseif d.scale then
				d.scale = util.bound(d.scale, 0.5, 2)

				local mx, my = util.getval(self.mhandle_pos[what].x, self), util.getval(self.mhandle_pos[what].y, self)

				d.x = util.bound(d.x, -mx * d.scale, w - mx * d.scale - move_handle[6] * d.scale)
				d.y = util.bound(d.y, -my * d.scale, self.map_h_stop - my * d.scale - move_handle[7] * d.scale)
			end
		end
	end
end

function _M:saveSettings()
	self:boundPlaces()

	local lines = {}
	lines[#lines+1] = ("tome.uiset_minimalist = {}"):format()
	lines[#lines+1] = ("tome.uiset_minimalist.save_size = {w=%d, h=%d}"):format(game.w, game.h)
	lines[#lines+1] = ("tome.uiset_minimalist.places = {}"):format(w)
	for _, w in ipairs{"player", "resources", "party", "buffs", "minimap", "gamelog", "chatlog", "hotkeys", "mainicons"} do
		lines[#lines+1] = ("tome.uiset_minimalist.places.%s = {}"):format(w)
		if self.places[w] then for k, v in pairs(self.places[w]) do
			lines[#lines+1] = ("tome.uiset_minimalist.places.%s.%s = %f"):format(w, k, v)
		end end
	end

	self:triggerHook{"UISet:Minimalist:saveSettings", lines=lines}

	game:saveSettings("tome.uiset_minimalist", table.concat(lines, "\n"))
end

function _M:toggleUI()
	UISet.toggleUI(self)
	print("Toggling UI", self.no_ui)
	self:resizeIconsHotkeysToolbar()
	self.res = {}
	self.party = {}
	self.tbuff = {}
	self.pbuff = {}
	if game.level then self:setupMinimap(game.level) end
	game.player.changed = true
end

function _M:activate()
	Shader:setDefault("textoutline", "textoutline")

	local size, size_mono, font, font_mono, font_mono_h, font_h
	if config.settings.tome.fonts.type == "fantasy" then
		size = ({normal=16, small=14, big=18})[config.settings.tome.fonts.size]
		size_mono = ({normal=14, small=10, big=16})[config.settings.tome.fonts.size]
		font = chn123_tome_font()
		font_mono = chn123_tome_font()
	else
		size = ({normal=12, small=10, big=14})[config.settings.tome.fonts.size]
		size_mono = ({normal=12, small=10, big=14})[config.settings.tome.fonts.size]
		font = chn123_tome_font()
		font_mono = chn123_tome_font()
	end
	local f = core.display.newFont(font, size)
	font_h = f:lineSkip()
	f = core.display.newFont(font_mono, size_mono)
	font_mono_h = f:lineSkip()
	self.init_font = font
	self.init_size_font = size
	self.init_font_h = font_h
	self.init_font_mono = font_mono
	self.init_size_mono = size_mono
	self.init_font_mono_h = font_mono_h

	self.buff_font = core.display.newFont(font_mono, size_mono * 2, true)
	self.buff_font_small = core.display.newFont(font_mono, size_mono * 1.4, true)
	self.buff_font_smaller = core.display.newFont(font_mono, size_mono * 1, true)

	self.hotkeys_display_text = HotkeysDisplay.new(nil, self.places.hotkeys.x, self.places.hotkeys.y, self.places.hotkeys.w, self.places.hotkeys.h, nil, font_mono, size_mono)
	self.hotkeys_display_text:enableShadow(0.6)
	self.hotkeys_display_text:setColumns(3)
	self:resizeIconsHotkeysToolbar()

	self.logdisplay = LogDisplay.new(0, 0, self.places.gamelog.w, self.places.gamelog.h, nil, font, size, nil, nil)
	self.logdisplay.resizeToLines = function() end
	self.logdisplay:enableShadow(1)
	self.logdisplay:enableFading(config.settings.tome.log_fade or 3)

	profile.chat:resize(0, 0, self.places.chatlog.w, self.places.chatlog.h, font, size, nil, nil)
	profile.chat.resizeToLines = function() profile.chat:resize(0 + (game.w) / 2, self.map_h_stop - font_h * config.settings.tome.log_lines -16, (game.w) / 2, font_h * config.settings.tome.log_lines) end
	profile.chat:enableShadow(1)
	profile.chat:enableFading(config.settings.tome.log_fade or 3)
	profile.chat:enableDisplayChans(false)

	self.npcs_display = ActorsSeenDisplay.new(nil, 0, game.h - font_mono_h * 4.2, game.w, font_mono_h * 4.2, "/data/gfx/ui/talents-list.png", font_mono, size_mono)
	self.npcs_display:setColumns(3)

	game.log = function(style, ...) if type(style) == "number" then game.uiset.logdisplay(...) else game.uiset.logdisplay(style, ...) end end
	game.logChat = function(style, ...)
		if true or not config.settings.tome.chat_log then return end
		if type(style) == "number" then
		local old = game.uiset.logdisplay.changed
		game.uiset.logdisplay(...) else game.uiset.logdisplay(style, ...) end
		if game.uiset.show_userchat then game.uiset.logdisplay.changed = old end
	end
	game.logRollback = function(line, ...) return self.logdisplay:rollback(line, ...) end
	game.logNewest = function() return self.logdisplay:getNewestLine() end
--	game.logSeen = function(e, style, ...) if e and e.player or (not e.dead and e.x and e.y and game.level and game.level.map.seens(e.x, e.y) and game.player:canSee(e)) then game.log(style, ...) end end
	game.logPlayer = function(e, style, ...) if e == game.player or e == game.party then game.log(style, ...) end end

	self:boundPlaces()
end

function _M:setupMinimap(level)
	level.map._map:setupMiniMapGridSize(3)
end

function _M:resizeIconsHotkeysToolbar()
	local h = 52
	if config.settings.tome.hotkey_icons then h = (8 + config.settings.tome.hotkey_icons_size) * config.settings.tome.hotkey_icons_rows end

	local oldstop = self.map_h_stop_up or (game.h - h)
	self.map_h_stop = game.h
	self.map_h_stop_up = game.h - h
	self.map_h_stop_tooltip = self.map_h_stop_up

	if not self.hotkeys_display_icons then
		self.hotkeys_display_icons = HotkeysIconsDisplay.new(nil, self.places.hotkeys.x, self.places.hotkeys.y, self.places.hotkeys.w, self.places.hotkeys.h, nil, self.init_font_mono, self.init_size_mono, config.settings.tome.hotkey_icons_size, config.settings.tome.hotkey_icons_size)
		self.hotkeys_display_icons:enableShadow(0.6)
	else
		self.hotkeys_display_icons:resize(self.places.hotkeys.x, self.places.hotkeys.y, self.places.hotkeys.w, self.places.hotkeys.h, config.settings.tome.hotkey_icons_size, config.settings.tome.hotkey_icons_size)
	end

	if self.no_ui then
		self.map_h_stop = game.h
		game:resizeMapViewport(game.w, self.map_h_stop, 0, 0)
		self.logdisplay.display_y = self.logdisplay.display_y + self.map_h_stop_up - oldstop
		profile.chat.display_y = profile.chat.display_y + self.map_h_stop_up - oldstop
		game:setupMouse(true)
		return
	end

	if game.inited then
		game:resizeMapViewport(game.w, self.map_h_stop, 0, 0)
		self.logdisplay.display_y = self.logdisplay.display_y + self.map_h_stop_up - oldstop
		profile.chat.display_y = profile.chat.display_y + self.map_h_stop_up - oldstop
		game:setupMouse(true)
	end

	self.hotkeys_display = config.settings.tome.hotkey_icons and self.hotkeys_display_icons or self.hotkeys_display_text
	self.hotkeys_display.actor = game.player
end

function _M:handleResolutionChange(w, h, ow, oh)
	print("minimalist:handleResolutionChange: adjusting UI")
	-- what was the point of this recursive call?
--	local w, h = core.display.size()
--	game:setResolution(w.."x"..h, true)

	-- Adjust UI
	local w2, h2 = math.floor(ow / 2), math.floor(oh / 2)
	for what, d in pairs(self.places) do
		if d.x > w2 then d.x = d.x + w - ow end
		if d.y > h2 then d.y = d.y + h - oh end
	end

	print("minimalist:handleResolutionChange: toggling UI to refresh")
	-- Toggle the UI to refresh the changes
	self:toggleUI()
	self:toggleUI()

	self:boundPlaces()
	self:saveSettings()
	print("minimalist:handleResolutionChange: saved settings")

	return true
end

function _M:getMapSize()
	local w, h = core.display.size()
	return 0, 0, w, (self.map_h_stop or 80) - 16
end

function _M:uiMoveResize(what, button, mx, my, xrel, yrel, bx, by, event, mode, on_change, add_text)
	if self.locked then return end

	mode = mode or "rescale"

	game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, self.mhandle_pos[what].name.."\n---\n鼠标左键拖曳移动框体位置\n鼠标右键拖曳进行缩放\n鼠标中键返回默认"..(add_text or ""))
	if event == "button" and button == "middle" then self.places[what].scale = 1 self:saveSettings()
	elseif event == "motion" and button == "left" then
		self.ui_moving = what
		game.mouse:startDrag(mx, my, s, {kind="ui:move", id=what, dx=bx*self.places[what].scale, dy=by*self.places[what].scale},
			function(drag, used) self:saveSettings() self.ui_moving = nil if on_change then on_change("move") end end,
			function(drag, _, x, y) if self.places[drag.payload.id] then self.places[drag.payload.id].x = x-drag.payload.dx self.places[drag.payload.id].y = y-drag.payload.dy self:boundPlaces() if on_change then on_change("move") end end end,
			true
		)
	elseif event == "motion" and button == "right" then
		if mode == "rescale" then
			game.mouse:startDrag(mx, my, s, {kind="ui:rescale", id=what, bx=bx, by=by},
				function(drag, used) self:saveSettings() if on_change then on_change(mode) end end,
				function(drag, _, x, y) if self.places[drag.payload.id] then
					self.places[drag.payload.id].scale = util.bound(math.max((x-self.places[drag.payload.id].x)/drag.payload.bx), 0.5, 2)
					self:boundPlaces()
					if on_change then on_change(mode) end
				end end,
				true
			)
		elseif mode == "resize" and self.places[what] then
			game.mouse:startDrag(mx, my, s, {kind="ui:resize", id=what, ox=mx - (self.places[what].x + util.getval(self.mhandle_pos[what].x, self)), oy=my - (self.places[what].y + util.getval(self.mhandle_pos[what].y, self))},
				function(drag, used) self:saveSettings() if on_change then on_change(mode) end end,
				function(drag, _, x, y) if self.places[drag.payload.id] then
					self.places[drag.payload.id].w = math.max(20, x - self.places[drag.payload.id].x + drag.payload.ox)
					self.places[drag.payload.id].h = math.max(20, y - self.places[drag.payload.id].y + drag.payload.oy)
					if on_change then on_change(mode) end
				end end,
				true
			)
		end
	end
end

function _M:computePadding(what, x1, y1, x2, y2)
	self.sizes[what] = {}
	local size = self.sizes[what]
	if x2 < x1 then x1, x2 = x2, x1 end
	if y2 < y1 then y1, y2 = y2, y1 end
	size.x1 = x1
	size.x2 = x2
	size.y1 = y1
	size.y2 = y2
	-- This is Marson's code to make you not get stuck under UI elements
	-- I have tested and love it but I don't understand it very well, may be oversights
	--if config.settings.marson.view_scrolling == "No Hiding" then
		if x2 <= Map.viewport.width / 4 then
			Map.viewport_padding_4 = math.max(Map.viewport_padding_4, math.ceil(x2 / Map.tile_w))
		end
		if x1 >= (Map.viewport.width / 4) * 3 then
			Map.viewport_padding_6 = math.max(Map.viewport_padding_6, math.ceil((Map.viewport.width - x1) / Map.tile_w))
		end
		if y2 <= Map.viewport.height / 4 then
			Map.viewport_padding_8 = math.max(Map.viewport_padding_8, math.ceil(y2 / Map.tile_h))
		end
		if y1 >= (Map.viewport.height / 4) * 3 then
			Map.viewport_padding_2 = math.max(Map.viewport_padding_2, math.ceil((Map.viewport.height - y1) / Map.tile_h))
		end

	if x1 <= 0 then
			size.orient = "right"
		end
		if x2 >= Map.viewport.width then
			size.orient = "left"
		end
		if y1 <= 0 then
			size.orient = "down"
		end
		if y2 >= Map.viewport.height then
			size.orient = "up"
		end
	--[[
	else
	if x1 <= 0 then
		Map.viewport_padding_4 = math.max(Map.viewport_padding_4, math.floor((x2 - x1) / Map.tile_w))
		size.left = true
	end
	if x2 >= Map.viewport.width then
		Map.viewport_padding_6 = math.max(Map.viewport_padding_6, math.floor((x2 - x1) / Map.tile_w))
		size.right = true
	end
	if y1 <= 0 then
		Map.viewport_padding_8 = math.max(Map.viewport_padding_8, math.floor((y2 - y1) / Map.tile_h))
		size.top = true
	end
	if y2 >= Map.viewport.height then
		Map.viewport_padding_2 = math.max(Map.viewport_padding_2, math.floor((y2 - y1) / Map.tile_h))
		size.bottom = true
	end

	if size.top then size.orient = "down"
	elseif size.bottom then size.orient = "up"
	elseif size.left then size.orient = "right"
	elseif size.right then size.orient = "left"
	end
	end --]]
end

function _M:showResourceTooltip(x, y, w, h, id, desc, is_first)
	if not game.mouse:updateZone(id, x, y, w, h, nil, self.places.resources.scale) then
		game.mouse:registerZone(x, y, w, h, function(button, mx, my, xrel, yrel, bx, by, event)
			if is_first then
				if event == "out" then self.mhandle.resources = nil return
				else self.mhandle.resources = true end

				-- Move handle
				if not self.locked and bx >= self.mhandle_pos.resources.x and bx <= self.mhandle_pos.resources.x + move_handle[6] and by >= self.mhandle_pos.resources.y and by <= self.mhandle_pos.resources.y + move_handle[7] then
					if event == "button" and button == "right" then
						local player = game.player
						local list = {}
						local rname
						for res, res_def in ipairs(ActorResource.resources_def) do
							rname = res_def.short_name
							if not res_def.hidden_resource and player:knowTalent(res_def.talent) then
								list[#list+1] = {name=res_def.name, id=rname}
							end
						end
						if player:knowTalent(player.T_FEEDBACK_POOL) then list[#list+1] = {name="Feedback", id="feedback"} end
						if player.is_fortress and player:hasQuest("shertul-fortress") then list[#list+1] = {name="Fortress Energy", id="fortress"} end
						
						Dialog:listPopup("Display/Hide resources", "Toggle:", list, 300, util.bound((8+#list)*(self.init_font_h+1), 14*(self.init_font_h+1), game.h*.75), function(sel)
							if not sel or not sel.id then return end
							game.player["_hide_resource_"..sel.id] = not game.player["_hide_resource_"..sel.id]
						end)
						return
					end
					self:uiMoveResize("resources", button, mx, my, xrel, yrel, bx, by, event, nil, nil, "\nRight click to toggle resources bars visibility")
					return
				end
			end

			local extra = {log_str=desc}
			game.mouse:delegate(button, mx, my, xrel, yrel, nil, nil, event, "playmap", extra)
		end, nil, id, true, self.places.resources.scale)
	end
end

function _M:resourceOrientStep(orient, bx, by, scale, x, y, w, h)
	if orient == "down" or orient == "up" then
		x = x + w
		if (x + w) * scale >= game.w - bx then x = 0 y = y + h end
	elseif orient == "right" or orient == "left" then
		y = y + h
		if (y + h) * scale >= self.map_h_stop - by then y = 0 x = x + w end
	end
	return x, y
end

function _M:displayResources(scale, bx, by, a)
	local player = game.player
	if player then
		local orient = self.sizes.resources and self.sizes.resources.orient or "right"
		local x, y = 0, 0

		-----------------------------------------------------------------------------------
		-- Air
		if player.air < player.max_air then
			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3], 1, 1, 1, a)
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3], 1, 1, 1, a)
			if air_sha.shad then air_sha:setUniform("a", a) air_sha.shad:use(true) end
			local p = math.min(1, math.max(0, player:getAir() / player.max_air))
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], air_c[1], air_c[2], air_c[3], a)
			if air_sha.shad then air_sha.shad:use(false) end

			if not self.res.air or self.res.air.vc ~= player.air or self.res.air.vm ~= player.max_air or self.res.air.vr ~= player.air_regen then
				self.res.air = {
					vc = player.air, vm = player.max_air, vr = player.air_regen,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d/%d"):format(player.air, player.max_air), 255, 255, 255):glTexture()},
					regen={core.display.drawStringBlendedNewSurface(sfont_sha, ("%+0.2f"):format(player.air_regen), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.air.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7 * a)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 1, 1, 1, a)
			dt = self.res.air.regen
			dt[1]:toScreenFull(2+x+144, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7 * a)
			dt[1]:toScreenFull(x+144, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 1, 1, 1, a)

			local front = fshat_air_dark
			if player.air >= player.max_air * 0.5 then front = fshat_air end
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3], 1, 1, 1, a)
			self:showResourceTooltip(bx+x*scale, by+y*scale, fshat[6], fshat[7], "res:air", self.TOOLTIP_AIR)
			x, y = self:resourceOrientStep(orient, bx, by, scale, x, y, fshat[6], fshat[7])
		elseif game.mouse:getZone("res:air") then game.mouse:unregisterZone("res:air") end

		-----------------------------------------------------------------------------------
		-- Life & shield
		sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3], 1, 1, 1, a)
		bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3], 1, 1, 1, a)
		if life_sha.shad then life_sha:setUniform("a", a) life_sha.shad:use(true) end
		local p = math.min(1, math.max(0, player.life / player.max_life))
		shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], life_c[1], life_c[2], life_c[3], a)
		if life_sha.shad then life_sha.shad:use(false) end

		local life_regen = player.life_regen * util.bound((player.healing_factor or 1), 0, 2.5)
		if not self.res.life or self.res.life.vc ~= player.life or self.res.life.vm ~= player.max_life or self.res.life.vr ~= life_regen then
			local status_text = ("%s/%d"):format(math.round(player.life), math.round(player.max_life))
			local reg_text = string.limit_decimals(life_regen,3, "+")
			self.res.life = {
				vc = player.life, vm = player.max_life, vr = life_regen,
				cur = {core.display.drawStringBlendedNewSurface(#status_text*1.1 + #reg_text <=14 and font_sha or sfont_sha, status_text, 255, 255, 255):glTexture()}, -- adjust font for space
				regen={core.display.drawStringBlendedNewSurface(sfont_sha, reg_text, 255, 255, 255):glTexture()},
			}
		end

		local shield, max_shield = 0, 0
		if player:attr("time_shield") then shield = shield + (player.time_shield_absorb or 0) max_shield = max_shield + (player.time_shield_absorb_max or 0) end
		if player:attr("damage_shield") then shield = shield + (player.damage_shield_absorb or 0) max_shield = max_shield + (player.damage_shield_absorb_max or 0) end
		if player:attr("displacement_shield") then shield = shield + (player.displacement_shield or 0) max_shield = max_shield + (player.displacement_shield_max or 0) end
		
		local front = fshat_life_dark
		if max_shield > 0 then
			front = fshat_shield_dark
			if shield >= max_shield * 0.8 then front = fshat_shield end
		elseif player.life >= player.max_life then front = fshat_life end
		front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3], 1, 1, 1, a)
	
		-- draw text on top of graphic for legibility
		local dt = self.res.life.cur
		dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7 * a)
		dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 1, 1, 1, a)
		dt = self.res.life.regen
		dt[1]:toScreenFull(2+x+144, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7 * a)
		dt[1]:toScreenFull(x+144, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 1, 1, 1, a)
		
		if max_shield > 0 then
			if shield_sha.shad then shield_sha:setUniform("a", a * 0.5) shield_sha.shad:use(true) end
			local p = math.min(1, math.max(0, shield / max_shield))
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], shield_c[1], shield_c[2], shield_c[3], 0.5 * a)
			if shield_sha.shad then shield_sha.shad:use(false) end

			if not self.res.shield or self.res.shield.vc ~= shield or self.res.shield.vm ~= max_shield then
				self.res.shield = {
					vc = shield, vm = max_shield,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d/%d"):format(shield, max_shield), 255, 215, 0):glTexture()},
				}
			end
			local dt = self.res.shield.cur
			dt[1]:toScreenFull(2+x+45+(shat[6]-dt[6])/2, 2+y+front[7]-dt[7], dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7 * a) -- shadow
			dt[1]:toScreenFull(x+45+(shat[6]-dt[6])/2, y+front[7]-dt[7], dt[6], dt[7], dt[2], dt[3], 1, 1, 1, a)
			self:showResourceTooltip(bx+x*scale, by+y*scale, fshat[6], fshat[7], "res:shield", self.TOOLTIP_DAMAGE_SHIELD.."\n---\n"..self.TOOLTIP_LIFE, true)
			if game.mouse:getZone("res:life") then game.mouse:unregisterZone("res:life") end
		else
			self:showResourceTooltip(bx+x*scale, by+y*scale, fshat[6], fshat[7], "res:life", self.TOOLTIP_LIFE, true)
			if game.mouse:getZone("res:shield") then game.mouse:unregisterZone("res:shield") end
		end

		x, y = self:resourceOrientStep(orient, bx, by, scale, x, y, fshat[6], fshat[7])

		if not self.locked then
			move_handle[1]:toScreenFull(fshat[6] / 2 - move_handle[6], 0, move_handle[6], move_handle[7], move_handle[2], move_handle[3])
		end

		-- Note: unnatural_body_heal not shown (difference from classic ui)

		-- display standard resources
		local vc, vn, vm, vr
		for res, res_def in ipairs(ActorResource.resources_def) do
			local rname = res_def.short_name
			local rgfx = self.res_gfx[rname]
			local rshad_args = rgfx.shader and rgfx.shader.args
			
			if not res_def.hidden_resource then
				if player:knowTalent(res_def.talent) and not player["_hide_resource_"..res_def.short_name] then
					sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3], 1, 1, 1, a) --shadow
					bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3], 1, 1, 1, a) --background
					vc, vn, vm, vr = player[res_def.getFunction](player), player[res_def.getMinFunction](player), player[res_def.getMaxFunction](player), player[res_def.regen_prop]

					-- draw the resource bar
					if rshad_args.display_resource_bar then -- use a resource-specific method
						rshad_args.display_resource_bar(player, rgfx.shader, x, y, rgfx.color, a)
					else -- use the default method, as fraction of maximum
						if rgfx.shader and rgfx.shader.shad then rgfx.shader:setUniform("a", a) rgfx.shader.shad:use(true) end
						local p -- proportion of resource bar to display
						if vn and vm then
							p = math.min(1, math.max(0, vc/vm))
						else p = 1
						end
						shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], rgfx.color[1], rgfx.color[2], rgfx.color[3], a)
						if rgfx.shader and rgfx.shader.shad then rgfx.shader.shad:use(false) end
					end

					-- draw the resource graphic using the highlighted/dim resource display based on values
					local front = self.res_gfx[rname].front_dark
					if self.res_gfx[rname].highlight then
						if util.getval(self.res_gfx[rname].highlight, player, vc, vn, vm, vr) then
							front = self.res_gfx[rname].front
						end
					elseif vm and vc >= vm then
						front = self.res_gfx[rname].front
					end
					front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3], 1, 1, 1, a)

					-- update display values (draw text on top of graphics for legibility)
					if not self.res[rname] or self.res[rname].vc ~= vc or self.res[rname].vn ~= vn or self.res[rname].vm ~= vm or self.res[rname].vr ~= vr then

						local status_text = util.getval(res_def.status_text, player) or ("%d/%d"):format(vc, vm)
						status_text = (status_text):format() -- fully resolve format codes (%%)
						self.res[rname] = {
							hidable = rname:capitalize(),
							vc = vc, vn = vn, vm = vm, vr = vr,
							-- use smaller font if needed for room
							cur = {core.display.drawStringBlendedNewSurface(#status_text <=15 and font_sha or sfont_sha, status_text, 255, 255, 255):glTexture()},
							-- only draw regen if it's non-zero and there is room
							regen = vr and vr ~= 0 and #status_text < 10 and {core.display.drawStringBlendedNewSurface(sfont_sha, string.limit_decimals(vr, 3, "+"), 255, 255, 255):glTexture()},
						}
					end
					local dt = self.res[rname].cur
					dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7 * a)
					dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 1, 1, 1, a)
					dt = self.res[rname].regen
					if dt then
						dt[1]:toScreenFull(2+x+144, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7 * a)
						dt[1]:toScreenFull(x+144, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 1, 1, 1, a)
					end
					self:showResourceTooltip(bx+x*scale, by+y*scale, fshat[6], fshat[7], "res:"..rname, self.res_gfx[rname].tooltip)
					x, y = self:resourceOrientStep(orient, bx, by, scale, x, y, fshat[6], fshat[7])
				elseif game.mouse:getZone("res:"..rname) then game.mouse:unregisterZone("res:"..rname) end
			end
		end

		-----------------------------------------------------------------------------------
		-- Feedback -- pseudo resource
		if player.psionic_feedback_max and player:knowTalent(player.T_FEEDBACK_POOL) and not player._hide_resource_feedback then
			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3], 1, 1, 1, a)
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3], 1, 1, 1, a)
			if feedback_sha.shad then feedback_sha:setUniform("a", a) feedback_sha.shad:use(true) end
			local p = player:getFeedback() / player:getMaxFeedback()
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], feedback_c[1], feedback_c[2], feedback_c[3], a)
			if feedback_sha.shad then feedback_sha.shad:use(false) end

			local front = fshat_feedback_dark
			if player.psionic_feedback >= player.psionic_feedback_max then front = fshat_feedback end
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3], 1, 1, 1, a)
			
			if not self.res.feedback or self.res.feedback.vc ~= player:getFeedback() or self.res.feedback.vm ~= player:getMaxFeedback() or self.res.feedback.vr ~= player:getFeedbackDecay() then
				self.res.feedback = {
					hidable = "Feedback",
					vc = player:getFeedback(), vm = player:getMaxFeedback(), vr = player:getFeedbackDecay(),
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d/%d"):format(player:getFeedback(), player:getMaxFeedback()), 255, 255, 255):glTexture()},
					regen={core.display.drawStringBlendedNewSurface(sfont_sha, ("%+0.2f"):format(-player:getFeedbackDecay()), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.feedback.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7 * a)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 1, 1, 1, a)
			dt = self.res.feedback.regen
			dt[1]:toScreenFull(2+x+144, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7 * a)
			dt[1]:toScreenFull(x+144, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 1, 1, 1, a)

			self:showResourceTooltip(bx+x*scale, by+y*scale, fshat[6], fshat[7], "res:feedback", self.TOOLTIP_FEEDBACK)
			x, y = self:resourceOrientStep(orient, bx, by, scale, x, y, fshat[6], fshat[7])
		elseif game.mouse:getZone("res:feedback") then game.mouse:unregisterZone("res:feedback") end

		-----------------------------------------------------------------------------------
		-- Fortress Energy -- special
		if player.is_fortress and not player._hide_resource_fortress then
			local q = game:getPlayer(true):hasQuest("shertul-fortress")
			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3], 1, 1, 1, a)
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3], 1, 1, 1, a)
			local p = 100 / 100
			if fortress_sha.shad then fortress_sha:setUniform("a", a) fortress_sha.shad:use(true) end
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], fortress_c[1], fortress_c[2], fortress_c[3], a)
			if fortress_sha.shad then fortress_sha.shad:use(false) end

			local front = fshat_fortress
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3], 1, 1, 1, a)
			
			if not self.res.fortress or self.res.fortress.vc ~= q.shertul_energy then
				self.res.fortress = {
					hidable = "Fortress",
					vc = q.shertul_energy,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d"):format(q.shertul_energy), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.fortress.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7 * a)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 1, 1, 1, a)

			self:showResourceTooltip(bx+x*scale, by+y*scale, fshat[6], fshat[7], "res:fortress", self.TOOLTIP_FORTRESS_ENERGY)
			x, y = self:resourceOrientStep(orient, bx, by, scale, x, y, fshat[6], fshat[7])
		elseif game.mouse:getZone("res:fortress") then game.mouse:unregisterZone("res:fortress") end

		-- Any hooks?
		-- Use to display other pseudo resources or those with .hidden_resource set under special circumstances
		local hd = {"UISet:Minimalist:Resources", a=a, player=player, x=x, y=y, bx=bx, by=by, orient=orient, scale=scale}
		if self:triggerHook(hd) then 
			x, y = hd.x, hd.y
		end

		-----------------------------------------------------------------------------------
		-- Ammo
		local quiver = player:getInven("QUIVER")
		local ammo = quiver and quiver[1]
		if ammo then
			local amt, max = 0, 0
			local shad, bg
			if ammo.type == "alchemist-gem" then
				shad, bg = _M["ammo_shadow_alchemist-gem"], _M["ammo_alchemist-gem"]
				amt = ammo:getNumber()
			else
				shad, bg = _M["ammo_shadow_"..ammo.subtype] or ammo_shadow_default, _M["ammo_"..ammo.subtype] or ammo_default
				amt, max = ammo.combat.shots_left, ammo.combat.capacity
			end

			shad[1]:toScreenFull(x, y, shad[6], shad[7], shad[2], shad[3], 1, 1, 1, a)
			bg[1]:toScreenFull(x, y, bg[6], bg[7], bg[2], bg[3], 1, 1, 1, a)

			if not self.res.ammo or self.res.ammo.vc ~= amt or self.res.ammo.vm ~= max then
				self.res.ammo = {
					vc = amt, vm = max,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, max > 0 and ("%d/%d"):format(amt, max) or ("%d"):format(amt), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.ammo.cur
			dt[1]:toScreenFull(2+x+44, 2+y+3 + (bg[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7 * a)
			dt[1]:toScreenFull(x+44, y+3 + (bg[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 1, 1, 1, a)
			self:showResourceTooltip(bx+x*scale, by+y*scale, shad[6], shad[7], "res:ammo", self.TOOLTIP_COMBAT_AMMO)
			x, y = self:resourceOrientStep(orient, bx, by, scale, x, y, fshat[6], fshat[7])
		elseif game.mouse:getZone("res:ammo") then game.mouse:unregisterZone("res:ammo")
		end

-- consider separating these from resources into their own frame
		-----------------------------------------------------------------------------------
		-- Hourglass
		if game.level and game.level.turn_counter then
			sshat_hourglass[1]:toScreenFull(x-6, y+8, sshat_hourglass[6], sshat_hourglass[7], sshat_hourglass[2], sshat_hourglass[3], 1, 1, 1, a)
			local c = game.level.turn_counter
			local m = math.max(game.level.max_turn_counter, c)
			local p = 1 - c / m
			shat_hourglass_top[1]:toScreenPrecise(x+11, y+32 + shat_hourglass_top[7] * p, shat_hourglass_top[6], shat_hourglass_top[7] * (1-p), 0, 1/shat_hourglass_top[4], p/shat_hourglass_top[5], 1/shat_hourglass_top[5], save_c[1], save_c[2], save_c[3], a)
			shat_hourglass_bottom[1]:toScreenPrecise(x+12, y+72 + shat_hourglass_bottom[7] * (1-p), shat_hourglass_bottom[6], shat_hourglass_bottom[7] * p, 0, 1/shat_hourglass_bottom[4], (1-p)/shat_hourglass_bottom[5], 1/shat_hourglass_bottom[5], save_c[1], save_c[2], save_c[3], a)

			if not self.res.hourglass or self.res.hourglass.vc ~= c or self.res.hourglass.vm ~= m then
				self.res.hourglass = {
					vc = c, vm = m,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d"):format(c/10), 255, 255, 255):glTexture()},
				}
			end
			local front = fshat_hourglass
			local dt = self.res.hourglass.cur
			dt[1]:toScreenFull(2+x+(front[6]-dt[6])/2, 2+y+90, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7 * a)
			dt[1]:toScreenFull(x+(front[6]-dt[6])/2, y+90, dt[6], dt[7], dt[2], dt[3], 1, 1, 1, a)

			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3], 1, 1, 1, a)
			self:showResourceTooltip(bx+x*scale, by+y*scale, front[6], front[7], "res:hourglass", game.level.turn_counter_desc or "")
			x, y = self:resourceOrientStep(orient, bx, by, scale, x, y, fshat[6], front[7])
		elseif game.mouse:getZone("res:hourglass") then game.mouse:unregisterZone("res:hourglass") end

		-----------------------------------------------------------------------------------
		-- Arena display
		if game.level and game.level.arena then
			local h = self.init_font_h + 2
			if not self.arenaframe then
				self.arenaframe = UI:makeFrame("ui/textbox", 250, 7 + h * 6)
				UI:drawFrame(self.arenaframe, x, y, 1, 1, 1, 0.65)
			else
				UI:drawFrame(self.arenaframe, x, y, 1, 1, 1, 0.65)
			end
			local py = y + 2
			local px = x + 5
			local arena = game.level.arena
			local aprint = function (_x, _y, _text, r, g, b)
				local surf = { core.display.drawStringBlendedNewSurface(font_sha, _text, r, g, b):glTexture() }
				surf[1]:toScreenFull(_x, _y, surf[6], surf[7], surf[2], surf[3], 0, 0, 0, 0.7 * a)
				surf[1]:toScreenFull(_x, _y, surf[6], surf[7], surf[2], surf[3], 1, 1, 1, a)
			end
			if arena.score > world.arena.scores[1].score then
				aprint(px, py, ("Score[1st]: %d"):format(arena.score), 255, 255, 100)
			else
				aprint(px, py, ("Score: %d"):format(arena.score), 255, 255, 255)
			end
			local _event = ""
			if arena.event > 0 then
				if arena.event == 1 then
					_event = "[MiniBoss]"
				elseif arena.event == 2 then
					_event = "[Boss]"
				elseif arena.event == 3 then
					_event = "[Final]"
				end
			end
			py = py + h
			if arena.currentWave > world.arena.bestWave then
				aprint(px, py, ("Wave(TOP) %d %s"):format(arena.currentWave, _event), 255, 255, 100)
			elseif arena.currentWave > world.arena.lastScore.wave then
				aprint(px, py, ("Wave %d %s"):format(arena.currentWave, _event), 100, 100, 255)
			else
				aprint(px, py, ("Wave %d %s"):format(arena.currentWave, _event), 255, 255, 255)
			end
			py = py + h
			if arena.pinch == true then
				aprint(px, py, ("Bonus: %d (x%.1f)"):format(arena.bonus, arena.bonusMultiplier), 255, 50, 50)
			else
				aprint(px, py, ("Bonus: %d (x%.1f)"):format(arena.bonus, arena.bonusMultiplier), 255, 255, 255)
			end
			py = py + h
			if arena.display then
				aprint(px, py, arena.display[1], 255, 0, 255)
				aprint(px, py + h, " VS", 255, 0, 255)
				aprint(px, py + h + h,  arena.display[2], 255, 0, 255)
			else
				aprint(px, py, "Rank: "..arena.printRank(arena.rank, arena.ranks), 255, 255, 255)
			end
		end

		-----------------------------------------------------------------------------------
		-- Specific display for zone
		if game.zone and game.zone.specific_ui then
			local w, h = game.zone.specific_ui(self, game.zone, x, y)
			if w and h then
				self:showResourceTooltip(bx+x*scale, by+y*scale, w, h, "res:levelspec", "")
				x, y = self:resourceOrientStep(orient, bx, by, scale, x, y, w, h)
			end
		elseif game.mouse:getZone("res:levelspec") then game.mouse:unregisterZone("res:levelspec") end

		-----------------------------------------------------------------------------------
		-- Saving
		if savefile_pipe.saving then
			sshat[1]:toScreenFull(x-6, y+8, sshat[6], sshat[7], sshat[2], sshat[3], 1, 1, 1, a)
			bshat[1]:toScreenFull(x, y, bshat[6], bshat[7], bshat[2], bshat[3], 1, 1, 1, a)
			if save_sha.shad then save_sha:setUniform("a", a) save_sha.shad:use(true) end
			local p = savefile_pipe.current_nb / savefile_pipe.total_nb
			shat[1]:toScreenPrecise(x+49, y+10, shat[6] * p, shat[7], 0, p * 1/shat[4], 0, 1/shat[5], save_c[1], save_c[2], save_c[3], a)
			if save_sha.shad then save_sha.shad:use(false) end

			if not self.res.save or self.res.save.vc ~= p then
				self.res.save = {
					vc = p,
					cur = {core.display.drawStringBlendedNewSurface(font_sha, ("Saving... %d%%"):format(p * 100), 255, 255, 255):glTexture()},
				}
			end
			local dt = self.res.save.cur
			dt[1]:toScreenFull(2+x+64, 2+y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7 * a)
			dt[1]:toScreenFull(x+64, y+10 + (shat[7]-dt[7])/2, dt[6], dt[7], dt[2], dt[3], 1, 1, 1, a)

			local front = fshat
			front[1]:toScreenFull(x, y, front[6], front[7], front[2], front[3], 1, 1, 1, a)
			x, y = self:resourceOrientStep(orient, bx, by, scale, x, y, fshat[6], fshat[7])
		end

		-- Compute how much space to reserve on the side
		self:computePadding("resources", bx, by, bx + (x + fshat[6]) * scale, by + y * scale)
	end
end

function _M:buffOrientStep(orient, bx, by, scale, x, y, w, h, next)
	if orient == "down" or orient == "up" then
		x = x + w
		if (x + w) * scale >= game.w - bx or next then x = 0 y = y + h * (orient == "down" and 1 or -1) end
	elseif orient == "right" or orient == "left" then
		y = y + h
		if (y + h) * scale >= self.map_h_stop - by or next then y = 0 x = x + w * (orient == "right" and 1 or -1) end
	end
	return x, y
end

function _M:handleEffect(player, eff_id, e, p, x, y, hs, bx, by, is_first, scale, allow_remove)
	local shader = Shader.default.textoutline and Shader.default.textoutline.shad

	local dur = p.dur + 1
	local charges = e.charges and tostring(e.charges(player, p)) or "0"

	if not self.tbuff[eff_id..":"..dur..":"..charges] then
		--local name = e.desc
		local name
		local save_chn = {}
		save_chn["Mental save"] = "精 神 豁 免"
		save_chn["Physical save"] = "物 理 豁 免"
		save_chn["Spell save"] = "魔 法 豁 免"
		if effCHN[e.name] then
			name = effCHN[e.name].chName
		else name = e.desc
		end
		local desc = nil
		--local eff_subtype = table.concat(table.keys(e.subtype), "/")
		local eff_subtype
		if effCHN[e.name] then
			eff_subtype = effCHN[e.name].subtype
		else eff_subtype = table.concat(table.keys(e.subtype), "/")
		end
		--if e.display_desc then name = e.display_desc(self, p) end
		
		local long_desc=e.long_desc
		if effCHN[e.name] and effCHN[e.name].desc then long_desc = effCHN[e.name].desc end
		local temp=long_desc
		if type(long_desc) == "string" then 
			long_desc = function(a,b) return temp end
		end
		if p.save_string and p.amount_decreased and p.maximum and p.total_dur then
			desc = ("#{bold}##GOLD#%s\n(%s: %s)#WHITE##{normal}#\n"):format(name, (effCHN[e.name] and effCHN[e.name].type) or e.type, eff_subtype)..long_desc(player, p).." "..("%s 降低该效果持续时间 %d 回合，从 %d 至 %d。"):format(save_chn[p.save_string] or p.save_string, p.amount_decreased, p.maximum, p.total_dur)
		else
			desc = ("#{bold}##GOLD#%s\n(%s: %s)#WHITE##{normal}#\n"):format(name, (effCHN[e.name] and effCHN[e.name].type) or e.type, eff_subtype)..long_desc(player, p)
		end
		
		if allow_remove then desc = desc.."\n---\n右键点击终止这个效果。" end

		local txt = nil
		local txt2 = nil
		if e.decrease > 0 then
			local font = e.charges and self.buff_font_small or self.buff_font
			dur = tostring(dur)
			txt = font:draw(dur, 40, colors.WHITE.r, colors.WHITE.g, colors.WHITE.b, true)[1]
			txt.fw, txt.fh = font:size(dur)
		end
		if e.charges then
			local font = e.decrease > 0 and self.buff_font_small or self.buff_font
			txt2 = font:draw(charges, 40, colors.WHITE.r, colors.WHITE.g, colors.WHITE.b, true)[1]
			txt2.fw, txt2.fh = font:size(charges)
			dur = dur..":"..charges
		end
		local icon = e.status ~= "detrimental" and frames_colors.ok or frames_colors.cooldown

		local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
			if is_first then
				if event == "out" then self.mhandle.buffs = nil return
				else self.mhandle.buffs = true end

				-- Move handle
				if not self.locked and bx >= self.mhandle_pos.buffs.x and bx <= self.mhandle_pos.buffs.x + move_handle[6] and by >= self.mhandle_pos.buffs.y and by <= self.mhandle_pos.buffs.y + move_handle[7] then self:uiMoveResize("buffs", button, mx, my, xrel, yrel, bx, by, event) end
			end
			if config.settings.cheat and event == "button" and core.key.modState("shift") then
				if button == "left" then
					p.dur = p.dur + 1
				elseif button == "right" then
					p.dur = p.dur - 1
				end
			elseif allow_remove and event == "button" and button == "right" then
				Dialog:yesnoPopup(name, "真的要取消 "..name.."？", function(ret)
					if ret then
						player:removeEffect(eff_id)
					end
				end)
			end
			game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, desc)
		end

		local flash = 0

		if p.__set_time and p.__set_time >= self.now - 500 then
			flash = 5
		end

		self.tbuff[eff_id..":"..dur..":"..charges] = {eff_id, "tbuff"..eff_id, function(x, y)
			core.display.drawQuad(x+4, y+4, 32, 32, 0, 0, 0, 255)
			e.display_entity:toScreen(self.hotkeys_display_icons.tiles, x+4, y+4, 32, 32)
			if e.get_fractional_percent then
				core.display.drawQuadPart(x +4 , y + 4, 32, 32, e.get_fractional_percent(self, p), 128, 128, 128, 200)
			end
			UI:drawFrame(self.buffs_base, x, y, icon[1], icon[2], icon[3], 1)

			if txt and not txt2 then
				if shader then
					shader:use(true)
					shader:uniOutlineSize(1, 1)
					shader:uniTextSize(txt._tex_w, txt._tex_h)
				else
					txt._tex:toScreenFull(x+4+2 + (32 - txt.fw)/2, y+4+2 + (32 - txt.fh)/2, txt.w, txt.h, txt._tex_w, txt._tex_h, 0, 0, 0, 0.7)
				end
				txt._tex:toScreenFull(x+4 + (32 - txt.fw)/2, y+4 + (32 - txt.fh)/2, txt.w, txt.h, txt._tex_w, txt._tex_h)
			elseif not txt and txt2 then
				if shader then
					shader:use(true)
					shader:uniOutlineSize(1, 1)
					shader:uniTextSize(txt2._tex_w, txt2._tex_h)
				else
					txt2._tex:toScreenFull(x+4+2, y+4+2 + (32 - txt2.fh)/2+5, txt2.w, txt2.h, txt2._tex_w, txt2._tex_h, 0, 0, 0, 0.7)
				end
				txt2._tex:toScreenFull(x+4, y+4 + (32 - txt2.fh)/2+5, txt2.w, txt2.h, txt2._tex_w, txt2._tex_h, 0, 1, 0, 1)
			elseif txt and txt2 then
				if shader then
					shader:use(true)
					shader:uniOutlineSize(1, 1)
					shader:uniTextSize(txt._tex_w, txt._tex_h)
				else
					txt._tex:toScreenFull(x+4+2 + (32 - txt.fw), y+4+2 + (32 - txt.fh)/2-5, txt.w, txt.h, txt._tex_w, txt._tex_h, 0, 0, 0, 0.7)
				end
				txt._tex:toScreenFull(x+4 + (32 - txt.fw), y+4 + (32 - txt.fh)/2-5, txt.w, txt.h, txt._tex_w, txt._tex_h)

				if shader then
					shader:uniOutlineSize(1, 1)
					shader:uniTextSize(txt2._tex_w, txt2._tex_h)
				else
					txt2._tex:toScreenFull(x+4+2, y+4+2 + (32 - txt2.fh)/2+5, txt2.w, txt2.h, txt2._tex_w, txt2._tex_h, 0, 0, 0, 0.7)
				end
				txt2._tex:toScreenFull(x+4, y+4 + (32 - txt2.fh)/2+5, txt2.w, txt2.h, txt2._tex_w, txt2._tex_h, 0, 1, 0, 1)
			end

			if shader and (txt or txt2) then shader:use(false) end

			if flash > 0 then
				if e.status ~= "detrimental" then core.display.drawQuad(x+4, y+4, 32, 32, 0, 255, 0, 170 - flash * 30)
				else core.display.drawQuad(x+4, y+4, 32, 32, 255, 0, 0, 170 - flash * 30)
				end
				flash = flash - 1
			end
		end, desc_fct}
	end

	if not game.mouse:updateZone("tbuff"..eff_id, bx+x*scale, by+y*scale, hs, hs, self.tbuff[eff_id..":"..dur..":"..charges][4], scale) then
		game.mouse:unregisterZone("tbuff"..eff_id)
		game.mouse:registerZone(bx+x*scale, by+y*scale, hs, hs, self.tbuff[eff_id..":"..dur..":"..charges][4], nil, "tbuff"..eff_id, true, scale)
	end

	self.tbuff[eff_id..":"..dur..":"..charges][3](x, y)
end

function _M:displayBuffs(scale, bx, by)
	local player = game.player
	local shader = Shader.default.textoutline and Shader.default.textoutline.shad

	if player then
		if player.changed then
			for _, d in pairs(self.pbuff) do if not player.sustain_talents[d[1]] then game.mouse:unregisterZone(d[2]) end end
			for _, d in pairs(self.tbuff) do if not player.tmp[d[1]] then game.mouse:unregisterZone(d[2]) end end
			self.tbuff = {} self.pbuff = {}
		end

		local orient = self.sizes.buffs and self.sizes.buffs.orient or "right"
		local hs = 40
		local x, y = 0, 0
		local is_first = true

		for tid, act in pairs(player.sustain_talents) do
			if act then
				if not self.pbuff[tid] or act.__update_display then
					local t = player:getTalentFromId(tid)
					if act.__update_display then game.mouse:unregisterZone("pbuff"..tid) end
					act.__update_display = false
					local displayName = t.name
					if t.getDisplayName then displayName = t.getDisplayName(player, t, player:isTalentActive(tid)) end

					local overlay = nil
					if t.iconOverlay then
						overlay = {}
						overlay.fct = function(x, y, overlay)
							local o, fnt = t.iconOverlay(player, t, act)
							if not overlay.txt or overlay.str ~= o then
								overlay.str = o

								local font = self[fnt or "buff_font_small"]
								txt = font:draw(o, 40, colors.WHITE.r, colors.WHITE.g, colors.WHITE.b, true)[1]
								txt.fw, txt.fh = font:size(o)
								overlay.txt = txt
							end
							local txt = overlay.txt
							
							if shader then
								shader:use(true)
								shader:uniOutlineSize(1, 1)
								shader:uniTextSize(txt._tex_w, txt._tex_h)
							else
								txt._tex:toScreenFull(x+4+2 + (32 - txt.fw)/2, y+4+2 + (32 - txt.fh)/2, txt.w, txt.h, txt._tex_w, txt._tex_h, 0, 0, 0, 0.7)
							end
							txt._tex:toScreenFull(x+4 + (32 - txt.fw)/2, y+4 + (32 - txt.fh)/2, txt.w, txt.h, txt._tex_w, txt._tex_h)
							if shader then shader:use(false) end
						end
					end

					local is_first = is_first
					local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
						if is_first then
							if event == "out" then self.mhandle.buffs = nil return
							else self.mhandle.buffs = true end
							-- Move handle
							if not self.locked and bx >= self.mhandle_pos.buffs.x and bx <= self.mhandle_pos.buffs.x + move_handle[6] and by >= self.mhandle_pos.buffs.y and by <= self.mhandle_pos.buffs.y + move_handle[7] then self:uiMoveResize("buffs", button, mx, my, xrel, yrel, bx, by, event) end
						end
						local desc = "#GOLD##{bold}#"..displayName.."#{normal}##WHITE#\n"..tostring(player:getTalentFullDescription(t))
						game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, desc)
					end
					self.pbuff[tid] = {tid, "pbuff"..tid, function(x, y)
						core.display.drawQuad(x+4, y+4, 32, 32, 0, 0, 0, 255)
						t.display_entity:toScreen(self.hotkeys_display_icons.tiles, x+4, y+4, 32, 32)
						if overlay then overlay.fct(x, y, overlay) end
						UI:drawFrame(self.buffs_base, x, y, frames_colors.sustain[1], frames_colors.sustain[2], frames_colors.sustain[3], 1)
					end, desc_fct}
				end

				if not game.mouse:updateZone("pbuff"..tid, bx+x*scale, by+y*scale, hs, hs, nil, scale) then
					game.mouse:unregisterZone("pbuff"..tid)
					game.mouse:registerZone(bx+x*scale, by+y*scale, hs, hs, self.pbuff[tid][4], nil, "pbuff"..tid, true, scale)
				end

				self.pbuff[tid][3](x, y)

				is_first = false
				x, y = self:buffOrientStep(orient, bx, by, scale, x, y, hs, hs)
			end
		end

		local good_e, bad_e = {}, {}
		for eff_id, p in pairs(player.tmp) do
			local e = player.tempeffect_def[eff_id]
			if e.status == "detrimental" then bad_e[eff_id] = p else good_e[eff_id] = p end
		end

		for eff_id, p in pairs(good_e) do
			local e = player.tempeffect_def[eff_id]
			self:handleEffect(player, eff_id, e, p, x, y, hs, bx, by, is_first, scale, (e.status == "beneficial" and not e.no_player_remove) or config.settings.cheat)
			is_first = false
			x, y = self:buffOrientStep(orient, bx, by, scale, x, y, hs, hs)
		end

		x, y = self:buffOrientStep(orient, bx, by, scale, x, y, hs, hs, true)

		for eff_id, p in pairs(bad_e) do
			local e = player.tempeffect_def[eff_id]
			self:handleEffect(player, eff_id, e, p, x, y, hs, bx, by, is_first, scale, config.settings.cheat)
			is_first = false
			x, y = self:buffOrientStep(orient, bx, by, scale, x, y, hs, hs)
		end

		if not self.locked then
			move_handle[1]:toScreenFull(40 - move_handle[6], 0, move_handle[6], move_handle[7], move_handle[2], move_handle[3])
		end

		if orient == "down" or orient == "up" then
			self:computePadding("buffs", bx, by, bx + x * scale + hs, by + hs)
		else
			self:computePadding("buffs", bx, by, bx + hs, by + y * scale + hs)
		end
	end
end

function _M:partyOrientStep(orient, bx, by, scale, x, y, w, h)
	if orient == "down" or orient == "up" then
		x = x + w
		if (x + w) * scale >= game.w - bx then x = 0 y = y + h end
	elseif orient == "right" or orient == "left" then
		y = y + h
		if (y + h) * scale >= self.map_h_stop - by then y = 0 x = x + w end
	end
	return x, y
end

function _M:displayParty(scale, bx, by)
	if game.player.changed and next(self.party) then
		for a, d in pairs(self.party) do if not game.party:hasMember(a) then game.mouse:unregisterZone(d[2]) end end
		self.party = {}
	end

	-- Party members
	if #game.party.m_list >= 2 and game.level then
		local orient = self.sizes.party and self.sizes.party.orient or "down"
		local hs = portrait[7] + 3
		local x, y = 0, 0
		local is_first = true

		for i = 1, #game.party.m_list do
			local a = game.party.m_list[i]

			if not self.party[a] then
				local def = game.party.members[a]

				local text = "#GOLD##{bold}#"..a.name.."\n#WHITE##{normal}#Life: "..math.floor(100 * a.life / a.max_life).."%\nLevel: "..a.level.."\n"..def.title
				if a.summon_time then
					text = text.."\n召唤剩余时间: "..a.summon_time
				end
				local is_first = is_first
				local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
					if is_first then
						if event == "out" then self.mhandle.party = nil return
						else self.mhandle.party = true end
						-- Move handle
						if not self.locked and bx >= self.mhandle_pos.party.x and bx <= self.mhandle_pos.party.x + move_handle[6] and by >= self.mhandle_pos.party.y and by <= self.mhandle_pos.party.y + move_handle[7] then
							self:uiMoveResize("party", button, mx, my, xrel, yrel, bx, by, event)
							return
						end
					end

					game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, text)

					if event == "button" and button == "left" then
						if def.control == "full" then game.party:select(a)
						elseif def.orders then game.party:giveOrders(a)
						end
					elseif event == "button" and button == "right" then
						if def.orders then game.party:giveOrders(a) end
					end
				end

				self.party[a] = {a, "party"..a.uid, function(x, y)
					core.display.drawQuad(x, y, 40, 40, 0, 0, 0, 255)
					if life_sha.shad then life_sha.shad:use(true) end
					local p = math.min(1, math.max(0, a.life / a.max_life))
					core.display.drawQuad(x+1, y+1 + (1-p)*hs, 38, p*38, life_c[1]*255, life_c[2]*255, life_c[3]*255, 178)
					if life_sha.shad then life_sha.shad:use(false) end

					local scale, bx, by = self.places.party.scale, self.places.party.x, self.places.party.y
					core.display.glScissor(true, bx+x*scale, by+y*scale, 40*scale, 40*scale)
					a:toScreen(nil, x+4, y+4, 32, 32)
					core.display.glScissor(false)
					local p = (game.player == a) and portrait or portrait_unsel
					if a.unused_stats > 0 or a.unused_talents > 0 or a.unused_generics > 0 or a.unused_talents_types > 0 and def.control == "full" then
						p = (game.player == a) and portrait_lev or portrait_unsel_lev
					end
					p[1]:toScreenFull(x, y, p[6], p[7], p[2], p[3])
					-- Display turns remaining on summon's portrait Marson
					if a.summon_time and a.name ~= "shadow" then
						local gtxt = self.party[a].txt_summon_time
						if not gtxt or self.party[a].cur_summon_time ~= a.summon_time then
							local txt = tostring(a.summon_time)
							local fw, fh = self.buff_font_small:size(txt)
							self.party[a].txt_summon_time = self.buff_font_small:draw(txt, fw, colors.WHITE.r, colors.WHITE.g, colors.WHITE.b, true)[1]
							gtxt = self.party[a].txt_summon_time
							gtxt.fw, gtxt.fh = fw, fh
							self.party[a].cur_summon_time = a.summon_time
						end
						if shader then
							shader:use(true)
							shader:uniOutlineSize(0.7, 0.7)
							shader:uniTextSize(gtxt._tex_w, gtxt._tex_h)
						else
							gtxt._tex:toScreenFull(x-gtxt.fw+36+1, y-2+1, gtxt.w, gtxt.h, gtxt._tex_w, gtxt._tex_h, 0, 0, 0, self.shadow or 0.6)
						end
						gtxt._tex:toScreenFull(x-gtxt.fw+36, y-2, gtxt.w, gtxt.h, gtxt._tex_w, gtxt._tex_h)
						if shader then shader:use(false) end					
					end
				end, desc_fct}
			end

			if not game.mouse:updateZone("party"..a.uid, bx+x*scale, by+y*scale, hs, hs, self.party[a][4], scale) then
				game.mouse:unregisterZone("party"..a.uid)
				game.mouse:registerZone(bx+x*scale, by+y*scale, hs, hs, self.party[a][4], nil, "party"..a.uid, true, scale)
			end

			self.party[a][3](x, y)

			is_first = false
			x, y = self:partyOrientStep(orient, bx, by, scale, x, y, hs, hs)
		end


		if not self.locked then
			move_handle[1]:toScreenFull(portrait[6] - move_handle[6], 0, move_handle[6], move_handle[7], move_handle[2], move_handle[3])
		end

		self:computePadding("party", bx, by, bx + x * scale, by + y * scale)
	end
end

function _M:displayPlayer(scale, bx, by)
	local player = game.player
	if not game.player then return end

	pf_shadow[1]:toScreenFull(0, 0, pf_shadow[6], pf_shadow[7], pf_shadow[2], pf_shadow[3])
	pf_bg[1]:toScreenFull(pf_bg_x, pf_bg_y, pf_bg[6], pf_bg[7], pf_bg[2], pf_bg[3])
	core.display.glScissor(true, bx+15*scale, by+15*scale, 54*scale, 54*scale)
	player:toScreen(nil, 22 + pf_player_x, 22 + pf_player_y, 40, 40)
	core.display.glScissor(false)

	if (not config.settings.tome.actor_based_movement_mode and self or player).bump_attack_disabled then
		pf_defend[1]:toScreenFull(22 + pf_attackdefend_x, 67 + pf_attackdefend_y, pf_defend[6], pf_defend[7], pf_defend[2], pf_defend[3])
	else
		pf_attack[1]:toScreenFull(22 + pf_attackdefend_x, 67 + pf_attackdefend_y, pf_attack[6], pf_attack[7], pf_attack[2], pf_attack[3])
	end

	if player.unused_stats > 0 or player.unused_talents > 0 or player.unused_generics > 0 or player.unused_talents_types > 0 then
		local glow = (1+math.sin(core.game.getTime() / 500)) / 2 * 100 + 120
		pf_levelup[1]:toScreenFull(269 + pf_levelup_x, 78 + pf_levelup_y, pf_levelup[6], pf_levelup[7], pf_levelup[2], pf_levelup[3], 1, 1, 1, glow / 255)
		pf_exp_levelup[1]:toScreenFull(108 + pf_exp_x, 74 + pf_exp_y, pf_exp_levelup[6], pf_exp_levelup[7], pf_exp_levelup[2], pf_exp_levelup[3], 1, 1, 1, glow / 255)
	end

	local cur_exp, max_exp = player.exp, player:getExpChart(player.level+1)
	local p = math.min(1, math.max(0, cur_exp / max_exp))
	pf_exp[1]:toScreenPrecise(117 + pf_exp_x, 85 + pf_exp_y, pf_exp[6] * p, pf_exp[7], 0, p * 1/pf_exp[4], 0, 1/pf_exp[5])

	if not self.res.exp or self.res.exp.vc ~= p then
		self.res.exp = {
			vc = p,
			cur = {core.display.drawStringBlendedNewSurface(sfont_sha, ("%d%%"):format(p * 100), 255, 255, 255):glTexture()},
		}
	end
	local dt = self.res.exp.cur
	dt[1]:toScreenFull(pf_exp_cur_x + 2+87 - dt[6] / 2, pf_exp_cur_y + 2+89 - dt[7] / 2, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
	dt[1]:toScreenFull(pf_exp_cur_x + 87 - dt[6] / 2, pf_exp_cur_y + 89 - dt[7] / 2, dt[6], dt[7], dt[2], dt[3])

	if not self.res.money or self.res.money.vc ~= player.money then
		self.res.money = {
			vc = player.money,
			cur = {core.display.drawStringBlendedNewSurface(font_sha, ("%d"):format(player.money), 255, 215, 0):glTexture()},
		}
	end
	local dt = self.res.money.cur
	dt[1]:toScreenFull(pf_money_x + 2+112 - dt[6] / 2, pf_money_y + 2+43, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
	dt[1]:toScreenFull(pf_money_x + 112 - dt[6] / 2, pf_money_y + 43, dt[6], dt[7], dt[2], dt[3])

	if not self.res.pname or self.res.pname.vc ~= player.name then
		self.res.pname = {
			vc = player.name,
			cur = {core.display.drawStringBlendedNewSurface(font_sha, player.name, 255, 255, 255):glTexture()},
		}
	end
	local dt = self.res.pname.cur
	dt[1]:toScreenFull(pf_name_x + 2+166, pf_name_y + 2+13, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
	dt[1]:toScreenFull(pf_name_x + 166, pf_name_y + 13, dt[6], dt[7], dt[2], dt[3])

	if not self.res.plevel or self.res.plevel.vc ~= player.level then
		self.res.plevel = {
			vc = player.level,
			cur = {core.display.drawStringBlendedNewSurface(font_sha, "Lvl "..player.level, 255, 255, 255):glTexture()},
		}
	end
	local dt = self.res.plevel.cur
	dt[1]:toScreenFull(pf_level_x + 2+253, pf_level_y + 2+46, dt[6], dt[7], dt[2], dt[3], 0, 0, 0, 0.7)
	dt[1]:toScreenFull(pf_level_x + 253, pf_level_y + 46, dt[6], dt[7], dt[2], dt[3])

	if player:attr("encumbered") then
		local glow = (1+math.sin(core.game.getTime() / 500)) / 2 * 100 + 120
		pf_encumber[1]:toScreenFull(162, 38, pf_encumber[6], pf_encumber[7], pf_encumber[2], pf_encumber[3], 1, 1, 1, glow / 255)
	end

	if not self.locked then
		move_handle[1]:toScreenFull(self.mhandle_pos.player.x, self.mhandle_pos.player.y, move_handle[6], move_handle[7], move_handle[2], move_handle[3])
	end

	if not game.mouse:updateZone("pframe", bx, by, pf_bg[6], pf_bg[7], nil, scale) then
		game.mouse:unregisterZone("pframe")

		local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
			if event == "out" then self.mhandle.player = nil return
			else self.mhandle.player = true end

			-- Attack/defend
			if bx >= 22 and bx <= 22 + pf_defend[6] and by >= 67 and by <= 67 + pf_defend[7] then
				game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, "切换移动模式。\n默认：向敌对目标移动则会直接攻击。\n被动：向一个生物移动不会攻击（可以使用Ctrl+ 方向键或者右键点击来攻击）。")
				if event == "button" and button == "left" then game.key:triggerVirtual("TOGGLE_BUMP_ATTACK") end
			-- Character sheet
			elseif bx >= 22 and bx <= 22 + 40 and by >= 22 and by <= 22 + 40 then
				game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, "查看角色信息")
				if event == "button" and button == "left" then game.key:triggerVirtual("SHOW_CHARACTER_SHEET") end
			-- Levelup
			elseif bx >= 269 and bx <= 269 + pf_levelup[6] and by >= 78 and by <= 78 + pf_levelup[7] and (player.unused_stats > 0 or player.unused_talents > 0 or player.unused_generics > 0 or player.unused_talents_types > 0) then
				game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, "点击来分配你的属性和技能点！")
				if event == "button" and button == "left" then game.key:triggerVirtual("LEVELUP") end
			-- Move handle
			elseif not self.locked and bx >= self.mhandle_pos.player.x and bx <= self.mhandle_pos.player.x + move_handle[6] and by >= self.mhandle_pos.player.y and by <= self.mhandle_pos.player.y + move_handle[7] then
				self:uiMoveResize("player", button, mx, my, xrel, yrel, bx, by, event)
			else
				game.mouse:delegate(button, mx, my, xrel, yrel, nil, nil, event, "playmap", nil)
			end
		end
		game.mouse:registerZone(bx, by, pf_bg[6], pf_bg[7], desc_fct, nil, "pframe", true, scale)
	end

	-- Compute how much space to reserve on the side
	self:computePadding("player", bx, by, bx + pf_bg[6] * scale, by + pf_bg[7] * scale)
end

function _M:displayMinimap(scale, bx, by)
	if self.no_minimap then game.mouse:unregisterZone("minimap") return end

	local map = game.level.map

	mm_shadow[1]:toScreenFull(0, 2, mm_shadow[6], mm_shadow[7], mm_shadow[2], mm_shadow[3])
	mm_bg[1]:toScreenFull(mm_bg_x, mm_bg_y, mm_bg[6], mm_bg[7], mm_bg[2], mm_bg[3])
	if game.player.x then game.minimap_scroll_x, game.minimap_scroll_y = util.bound(game.player.x - 25, 0, map.w - 50), util.bound(game.player.y - 25, 0, map.h - 50)
	else game.minimap_scroll_x, game.minimap_scroll_y = 0, 0 end

	map:minimapDisplay(50 - mm_bg_x, 30 - mm_bg_y, game.minimap_scroll_x, game.minimap_scroll_y, 50, 50, 0.85)
	mm_transp[1]:toScreenFull(50 - mm_bg_x, 30 - mm_bg_y, mm_transp[6], mm_transp[7], mm_transp[2], mm_transp[3])

	mm_comp[1]:toScreenFull(169, 178, mm_comp[6], mm_comp[7], mm_comp[2], mm_comp[3])

	if not self.locked then
		move_handle[1]:toScreenFull(self.mhandle_pos.minimap.x, self.mhandle_pos.minimap.y, move_handle[6], move_handle[7], move_handle[2], move_handle[3])
	end

	if not game.mouse:updateZone("minimap", bx, by, mm_bg[6], mm_bg[7], nil, scale) then
		game.mouse:unregisterZone("minimap")

		local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
			if event == "out" then self.mhandle.minimap = nil return
			else self.mhandle.minimap = true end
			if self.no_minimap then return end

			game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, "左键点击移动\n右键点击滚动地图\n中键点击显示大地图")

			-- Move handle
			if not self.locked and bx >= self.mhandle_pos.minimap.x and bx <= self.mhandle_pos.minimap.x + move_handle[6] and by >= self.mhandle_pos.minimap.y and by <= self.mhandle_pos.minimap.y + move_handle[7] then
				self:uiMoveResize("minimap", button, mx, my, xrel, yrel, bx, by, event)
				return
			end

			if bx >= 50 and bx <= 50 + 150 and by >= 30 and by <= 30 + 150 then
				if button == "left" and not xrel and not yrel and event == "button" then
					local tmx, tmy = math.floor((bx-50) / 3), math.floor((by-30) / 3)
					game.player:mouseMove(tmx + game.minimap_scroll_x, tmy + game.minimap_scroll_y)
				elseif button == "right" then
					local tmx, tmy = math.floor((bx-50) / 3), math.floor((by-30) / 3)
					game.level.map:moveViewSurround(tmx + game.minimap_scroll_x, tmy + game.minimap_scroll_y, 1000, 1000)
				elseif event == "button" and button == "middle" then
					game.key:triggerVirtual("SHOW_MAP")
				end
			end
		end
		game.mouse:registerZone(bx, by, mm_bg[6], mm_bg[7], desc_fct, nil, "minimap", true, scale)
	end

	if game.zone_name_s then
		game.zone_name_s:toScreenFull(
			(mm_bg[6] - game.zone_name_w) / 2,
			0,
			game.zone_name_w, game.zone_name_h,
			game.zone_name_tw, game.zone_name_th
		)
	end

	-- Compute how much space to reserve on the side
	self:computePadding("minimap", bx, by, bx + mm_bg[6] * scale, by + (mm_bg[7] + (game.zone_name_h or 0)) * scale)
end

function _M:displayGameLog(scale, bx, by)
	local log = self.logdisplay

	if not self.locked then
		core.display.drawQuad(0, 0, log.w, log.h, 0, 0, 0, 60)
	end

	local ox, oy = log.display_x, log.display_y
	log.display_x, log.display_y = 0, 0
	log:toScreen()
	log.display_x, log.display_y = ox, oy

	if not self.locked then
		move_handle[1]:toScreenFull(util.getval(self.mhandle_pos.gamelog.x, self), util.getval(self.mhandle_pos.gamelog.y, self), move_handle[6], move_handle[7], move_handle[2], move_handle[3])
	end

	if not game.mouse:updateZone("gamelog", bx, by, log.w, log.h, nil, scale) then
		game.mouse:unregisterZone("gamelog")

		local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
			if event == "out" then self.mhandle.gamelog = nil return
			else self.mhandle.gamelog = true end

			-- Move handle
			local mhx, mhy = util.getval(self.mhandle_pos.gamelog.x, self), util.getval(self.mhandle_pos.gamelog.y, self)
			if not self.locked and bx >= mhx and bx <= mhx + move_handle[6] and by >= mhy and by <= mhy + move_handle[7] then
				self:uiMoveResize("gamelog", button, mx, my, xrel, yrel, bx, by, event, "resize", function(mode)
					log:resize(self.places.gamelog.x, self.places.gamelog.x, self.places.gamelog.w, self.places.gamelog.h)
					log:display()
					log:resetFade()
				end)
				return
			end

			log:mouseEvent(button, mx, my, xrel, yrel, bx, by, event)
		end
		game.mouse:registerZone(bx, by, log.w, log.h, desc_fct, nil, "gamelog", true, scale)
	end
end

function _M:displayChatLog(scale, bx, by)
	local log = profile.chat

	if not self.locked then
		core.display.drawQuad(0, 0, log.w, log.h, 0, 0, 0, 60)
	end

	local ox, oy = log.display_x, log.display_y
	log.display_x, log.display_y = 0, 0
	log:toScreen()
	log.display_x, log.display_y = ox, oy

	if not self.locked then
		move_handle[1]:toScreenFull(util.getval(self.mhandle_pos.chatlog.x, self), util.getval(self.mhandle_pos.chatlog.y, self), move_handle[6], move_handle[7], move_handle[2], move_handle[3])
	end

	if not game.mouse:updateZone("chatlog", bx, by, log.w, log.h, nil, scale) then
		game.mouse:unregisterZone("chatlog")

		local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
			if event == "out" then self.mhandle.chatlog = nil return
			else self.mhandle.chatlog = true end

			-- Move handle
			local mhx, mhy = util.getval(self.mhandle_pos.chatlog.x, self), util.getval(self.mhandle_pos.chatlog.y, self)
			if not self.locked and bx >= mhx and bx <= mhx + move_handle[6] and by >= mhy and by <= mhy + move_handle[7] then
				self:uiMoveResize("chatlog", button, mx, my, xrel, yrel, bx, by, event, "resize", function(mode)
					log:resize(self.places.chatlog.x, self.places.chatlog.y, self.places.chatlog.w, self.places.chatlog.h)
					log:resetFade()
				end)
				return
			end

			profile.chat:mouseEvent(button, mx, my, xrel, yrel, bx, by, event)
		end
		game.mouse:registerZone(bx, by, log.w, log.h, desc_fct, nil, "chatlog", true, scale)
	end
end


function _M:displayHotkeys(scale, bx, by)
	local hkeys = self.hotkeys_display
	local ox, oy = hkeys.display_x, hkeys.display_y

	hk5[1]:toScreenFull(0, 0, self.places.hotkeys.w, self.places.hotkeys.h, hk5[2], hk5[3])

	hk8[1]:toScreenFull(0, -hk8[7], self.places.hotkeys.w, hk8[7], hk8[2], hk8[3])
	hk2[1]:toScreenFull(0, self.places.hotkeys.h, self.places.hotkeys.w, hk2[7], hk2[2], hk2[3])
	hk4[1]:toScreenFull(-hk4[6], 0, hk4[6], self.places.hotkeys.h, hk4[2], hk4[3])
	hk6[1]:toScreenFull(self.places.hotkeys.w, 0, hk6[6], self.places.hotkeys.h, hk6[2], hk6[3])

	hk7[1]:toScreenFull(-hk7[6], -hk7[6], hk7[6], hk7[7], hk7[2], hk7[3])
	hk9[1]:toScreenFull(self.places.hotkeys.w, -hk9[6], hk9[6], hk9[7], hk9[2], hk9[3])
	hk1[1]:toScreenFull(-hk7[6], self.places.hotkeys.h, hk1[6], hk1[7], hk1[2], hk1[3])
	hk3[1]:toScreenFull(self.places.hotkeys.w, self.places.hotkeys.h, hk3[6], hk3[7], hk3[2], hk3[3])

	hkeys.orient = self.sizes.hotkeys and self.sizes.hotkeys.orient or "down"
	hkeys.display_x, hkeys.display_y = 0, 0
	hkeys:toScreen()
	hkeys.display_x, hkeys.display_y = ox, oy

	if not self.locked then
		move_handle[1]:toScreenFull(util.getval(self.mhandle_pos.hotkeys.x, self), util.getval(self.mhandle_pos.hotkeys.y, self), move_handle[6], move_handle[7], move_handle[2], move_handle[3])
	end

	if not game.mouse:updateZone("hotkeys", bx, by, self.places.hotkeys.w, self.places.hotkeys.h, nil, scale) then
		game.mouse:unregisterZone("hotkeys")

		local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
			if event == "out" then self.mhandle.hotkeys = nil self.hotkeys_display.cur_sel = nil return
			else self.mhandle.hotkeys = true end

			-- Move handle
			local mhx, mhy = util.getval(self.mhandle_pos.hotkeys.x, self), util.getval(self.mhandle_pos.hotkeys.y, self)
			if not self.locked and bx >= mhx and bx <= mhx + move_handle[6] and by >= mhy and by <= mhy + move_handle[7] then
				self:uiMoveResize("hotkeys", button, mx, my, xrel, yrel, bx, by, event, "resize", function(mode)
					hkeys:resize(self.places.hotkeys.x, self.places.hotkeys.y, self.places.hotkeys.w, self.places.hotkeys.h)
				end)
				return
			end

			if event == "button" and button == "left" and ((game.zone and game.zone.wilderness and not game.player.allow_talents_worldmap) or (game.key ~= game.normal_key)) then return end
			self.hotkeys_display:onMouse(button, mx, my, event == "button",
				function(text)
					text = text:toTString()
					text:add(true, "---", true, {"font","italic"}, {"color","GOLD"}, "左键使用", true, "右键设定", true, "按下M设置", {"color","LAST"}, {"font","normal"})
					game:tooltipDisplayAtMap(game.w, game.h, text)
				end,
				function(i, hk)
					if button == "right" and hk and hk[1] == "talent" then
						local d = require("mod.dialogs.UseTalents").new(game.player)
						d:use({talent=hk[2], name=game.player:getTalentFromId(hk[2]).name}, "right")
						return true
					elseif button == "right" and hk and hk[1] == "inventory" then
						Dialog:yesnoPopup("取消绑定 "..hk[2], "从快捷栏去掉该物品？", function(ret) if ret then
							for i = 1, 12 * game.player.nb_hotkey_pages do
								if game.player.hotkey[i] and game.player.hotkey[i][1] == "inventory" and game.player.hotkey[i][2] == hk[2] then game.player.hotkey[i] = nil end
							end
						end end)
						return true
					end
				end
			)
		end
		game.mouse:registerZone(bx, by, self.places.hotkeys.w, self.places.hotkeys.h, desc_fct, nil, "hotkeys", true, scale)
	end

	-- Compute how much space to reserve on the side
	self:computePadding("hotkeys", bx, by, bx + hkeys.w * scale, by + hkeys.h * scale)
end

function _M:toolbarOrientStep(orient, bx, by, scale, x, y, w, h)
	if orient == "down" or orient == "up" then
		x = x + w
		if (x + w) * scale >= game.w - bx then x = 0 y = y + h end
	elseif orient == "right" or orient == "left" then
		y = y + h
		if (y + h) * scale >= self.map_h_stop - by then y = 0 x = x + w end
	end
	return x, y
end

function _M:displayToolbar(scale, bx, by)
	-- Toolbar icons
	local x, y = 0, 0
	local orient = self.sizes.mainicons and self.sizes.mainicons.orient or "down"

	tb_bg[1]:toScreenFull		(x, y, tb_bg[6], tb_bg[7], tb_bg[2], tb_bg[3], 1, 1, 1, 1)
	tb_inven[1]:toScreenFull	(x, y, tb_inven[6], tb_inven[7], tb_inven[2], tb_inven[3], self.tbbuttons.inven, self.tbbuttons.inven, self.tbbuttons.inven, 1)
	if not game.mouse:updateZone("tb_inven", bx + x * scale, by +y*scale, tb_inven[6], tb_inven[7], nil, scale) then
		game.mouse:unregisterZone("tb_inven")
		local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
			if event == "out" then self.tbbuttons.inven = 0.6 return else self.tbbuttons.inven = 1 end
			game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, "左键点击显示物品栏")
			if button == "left" and not xrel and not yrel and event == "button" then game.key:triggerVirtual("SHOW_INVENTORY") end
		end
		game.mouse:registerZone(bx + x * scale, by +y*scale, tb_inven[6], tb_inven[7], desc_fct, nil, "tb_inven", true, scale)
	end
	x, y = self:toolbarOrientStep(orient, bx, by, scale, x, y, tb_bg[6], tb_bg[7])

	tb_bg[1]:toScreenFull		(x, y, tb_bg[6], tb_bg[7], tb_bg[2], tb_bg[3], 1, 1, 1, 1)
	tb_talents[1]:toScreenFull	(x, y, tb_talents[6], tb_talents[7], tb_talents[2], tb_talents[3], self.tbbuttons.talents, self.tbbuttons.talents, self.tbbuttons.talents, 1)
	if not game.mouse:updateZone("tb_talents", bx + x * scale, by +y*scale, tb_talents[6], tb_talents[7], nil, scale) then
		game.mouse:unregisterZone("tb_talents")
		local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
			if event == "out" then self.tbbuttons.talents = 0.6 return else self.tbbuttons.talents = 1 end
			game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, "左键点击显示技能")
			if button == "left" and not xrel and not yrel and event == "button" then game.key:triggerVirtual("USE_TALENTS") end
		end
		game.mouse:registerZone(bx + x * scale, by +y*scale, tb_talents[6], tb_talents[7], desc_fct, nil, "tb_talents", true, scale)
	end
	x, y = self:toolbarOrientStep(orient, bx, by, scale, x, y, tb_bg[6], tb_bg[7])

	tb_bg[1]:toScreenFull		(x, y, tb_bg[6], tb_bg[7], tb_bg[2], tb_bg[3], 1, 1, 1, 1)
	tb_quest[1]:toScreenFull	(x, y, tb_quest[6], tb_quest[7], tb_quest[2], tb_quest[3], self.tbbuttons.quest, self.tbbuttons.quest, self.tbbuttons.quest, 1)
	if not game.mouse:updateZone("tb_quest", bx + x * scale, by +y*scale, tb_quest[6], tb_quest[7], nil, scale) then
		game.mouse:unregisterZone("tb_quest")
		local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
			if event == "out" then self.tbbuttons.quest = 0.6 return else self.tbbuttons.quest = 1 end
			game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, "左键点击显示信息/聊天栏")
			if button == "left" and not xrel and not yrel and event == "button" then game.key:triggerVirtual("SHOW_MESSAGE_LOG") end
		end
		game.mouse:registerZone(bx + x * scale, by +y*scale, tb_quest[6], tb_quest[7], desc_fct, nil, "tb_quest", true, scale)
	end
	x, y = self:toolbarOrientStep(orient, bx, by, scale, x, y, tb_bg[6], tb_bg[7])

	tb_bg[1]:toScreenFull		(x, y, tb_bg[6], tb_bg[7], tb_bg[2], tb_bg[3], 1, 1, 1, 1)
	tb_lore[1]:toScreenFull		(x, y, tb_lore[6], tb_lore[7], tb_lore[2], tb_lore[3], self.tbbuttons.lore, self.tbbuttons.lore, self.tbbuttons.lore, 1)
	if not game.mouse:updateZone("tb_lore", bx + x * scale, by +y*scale, tb_lore[6], tb_lore[7], nil, scale) then
		game.mouse:unregisterZone("tb_lore")
		local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
			if event == "out" then self.tbbuttons.lore = 0.6 return else self.tbbuttons.lore = 1 end
			game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, "左键点击显示任务栏\n右键点击显示手札")
			if button == "left" and not xrel and not yrel and event == "button" then game.key:triggerVirtual("SHOW_QUESTS")
			elseif button == "right" and not xrel and not yrel and event == "button" then game:registerDialog(require("mod.dialogs.ShowLore").new("Tales of Maj'Eyal Lore", game.party)) end
		end
		game.mouse:registerZone(bx + x * scale, by +y*scale, tb_lore[6], tb_lore[7], desc_fct, nil, "tb_lore", true, scale)
	end
	x, y = self:toolbarOrientStep(orient, bx, by, scale, x, y, tb_bg[6], tb_bg[7])

	tb_bg[1]:toScreenFull		(x, y, tb_bg[6], tb_bg[7], tb_bg[2], tb_bg[3], 1, 1, 1, 1)
	tb_mainmenu[1]:toScreenFull	(x, y, tb_mainmenu[6], tb_mainmenu[7], tb_mainmenu[2], tb_mainmenu[3], self.tbbuttons.mainmenu, self.tbbuttons.mainmenu, self.tbbuttons.mainmenu, 1)
	if not game.mouse:updateZone("tb_mainmenu", bx + x * scale, by + y*scale, tb_mainmenu[6], tb_mainmenu[7], nil, scale) then
		game.mouse:unregisterZone("tb_mainmenu")
		local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
			if event == "out" then self.tbbuttons.mainmenu = 0.6 return else self.tbbuttons.mainmenu = 1 end
			game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, "左键点击显示主菜单")
			if button == "left" and not xrel and not yrel and event == "button" then game.key:triggerVirtual("EXIT") end
		end
		game.mouse:registerZone(bx + x * scale, by +y*scale, tb_mainmenu[6], tb_mainmenu[7], desc_fct, nil, "tb_mainmenu", true, scale)
	end
	x, y = self:toolbarOrientStep(orient, bx, by, scale, x, y, tb_bg[6], tb_bg[7])

	local padlock = self.locked and tb_padlock_closed or tb_padlock_open
	tb_bg[1]:toScreenFull		(x, y, tb_bg[6], tb_bg[7], tb_bg[2], tb_bg[3], 1, 1, 1, 1)
	padlock[1]:toScreenFull		(x, y, padlock[6], padlock[7], padlock[2], padlock[3], self.tbbuttons.padlock, self.tbbuttons.padlock, self.tbbuttons.padlock, 1)
	if not game.mouse:updateZone("padlock", bx + x * scale, by +y*scale, padlock[6], padlock[7], nil, scale) then
		game.mouse:unregisterZone("padlock")
		local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
			if event == "out" then self.tbbuttons.padlock = 0.6 return else self.tbbuttons.padlock = 1 end
			game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, self.locked and "解锁所有UI元素以调整位置和大小。" or "锁定所有UI元素使其无法移动或调整大小。")
			if button == "left" and not xrel and not yrel and event == "button" then self:switchLocked() end
		end
		game.mouse:registerZone(bx + x * scale, by +y*scale, padlock[6], padlock[7], desc_fct, nil, "padlock", true, scale)
	end
	x, y = self:toolbarOrientStep(orient, bx, by, scale, x, y, tb_bg[6], tb_bg[7])

	-- Any hooks
	local hd = {"UISet:Minimalist:Toolbar", x=x, y=y, bx=bx, by=by, orient=orient, scale=scale, tb_bg=tb_bg}
	if self:triggerHook(hd) then 
		x, y = hd.x, hd.y
	end

	local mhx, mhy = util.getval(self.mhandle_pos.mainicons.x, self), util.getval(self.mhandle_pos.mainicons.y, self)
	if not self.locked then
		move_handle[1]:toScreenFull(mhx, mhy, move_handle[6], move_handle[7], move_handle[2], move_handle[3])
	end

	if not game.mouse:updateZone("tb_handle", bx + mhx * scale, by + mhy * scale, move_handle[6], move_handle[7], nil, scale) then
		game.mouse:unregisterZone("tb_handle")

		local desc_fct = function(button, mx, my, xrel, yrel, bx, by, event)
			-- Move handle
			if not self.locked then
				self:uiMoveResize("mainicons", button, mx, my, xrel, yrel, bx+mhx*scale, by+mhy*scale, event)
				return
			end
		end
		game.mouse:registerZone(bx + mhx * scale, by + mhy * scale, move_handle[6], move_handle[7], desc_fct, nil, "tb_handle", true, scale)
	end

	-- Compute how much space to reserve on the side
	self:computePadding("mainicons", bx, by, bx + x * scale, by + y * scale)
end

function _M:display(nb_keyframes)
	local d = core.display
	self.now = core.game.getTime()

	-- Now the map, if any
	game:displayMap(nb_keyframes)

	if game.creating_player then return end
	if self.no_ui then return end

	Map.viewport_padding_4 = 0
	Map.viewport_padding_6 = 0
	Map.viewport_padding_8 = 0
	Map.viewport_padding_2 = 0

	-- Game log
	d.glTranslate(self.places.gamelog.x, self.places.gamelog.y, 0)
	self:displayGameLog(1, self.places.gamelog.x, self.places.gamelog.y)
	d.glTranslate(-self.places.gamelog.x, -self.places.gamelog.y, -0)

	-- Chat log
	d.glTranslate(self.places.chatlog.x, self.places.chatlog.y, 0)
	self:displayChatLog(1, self.places.chatlog.x, self.places.chatlog.y)
	d.glTranslate(-self.places.chatlog.x, -self.places.chatlog.y, -0)

	-- Minimap display
	if game.level and game.level.map then
		d.glTranslate(self.places.minimap.x, self.places.minimap.y, 0)
		d.glScale(self.places.minimap.scale, self.places.minimap.scale, self.places.minimap.scale)
		self:displayMinimap(self.places.minimap.scale, self.places.minimap.x, self.places.minimap.y)
		d.glScale()
		d.glTranslate(-self.places.minimap.x, -self.places.minimap.y, -0)
	end

	-- Player
	d.glTranslate(self.places.player.x, self.places.player.y, 0)
	d.glScale(self.places.player.scale, self.places.player.scale, self.places.player.scale)
	self:displayPlayer(self.places.player.scale, self.places.player.x, self.places.player.y)
	d.glScale()
	d.glTranslate(-self.places.player.x, -self.places.player.y, -0)

	-- Resources
	d.glTranslate(self.places.resources.x, self.places.resources.y, 0)
	d.glScale(self.places.resources.scale, self.places.resources.scale, self.places.resources.scale)
	self:displayResources(self.places.resources.scale, self.places.resources.x, self.places.resources.y, 1)
	d.glScale()
	d.glTranslate(-self.places.resources.x, -self.places.resources.y, -0)

	-- Buffs
	d.glTranslate(self.places.buffs.x, self.places.buffs.y, 0)
	d.glScale(self.places.buffs.scale, self.places.buffs.scale, self.places.buffs.scale)
	self:displayBuffs(self.places.buffs.scale, self.places.buffs.x, self.places.buffs.y)
	d.glScale()
	d.glTranslate(-self.places.buffs.x, -self.places.buffs.y, -0)

	-- Party
	d.glTranslate(self.places.party.x, self.places.party.y, 0)
	d.glScale(self.places.party.scale, self.places.party.scale, self.places.party.scale)
	self:displayParty(self.places.party.scale, self.places.party.x, self.places.party.y)
	d.glScale()
	d.glTranslate(-self.places.party.x, -self.places.party.y, -0)

	-- Hotkeys
	d.glTranslate(self.places.hotkeys.x, self.places.hotkeys.y, 0)
	self:displayHotkeys(1, self.places.hotkeys.x, self.places.hotkeys.y)
	d.glTranslate(-self.places.hotkeys.x, -self.places.hotkeys.y, -0)

	-- Main icons
	d.glTranslate(self.places.mainicons.x, self.places.mainicons.y, 0)
	d.glScale(self.places.mainicons.scale * 0.5, self.places.mainicons.scale * 0.5, self.places.mainicons.scale * 0.5)
	self:displayToolbar(self.places.mainicons.scale * 0.5, self.places.mainicons.x, self.places.mainicons.y)
	d.glScale()
	d.glTranslate(-self.places.mainicons.x, -self.places.mainicons.y, -0)

	-- Display border indicators when possible
	if self.ui_moving and self.sizes[self.ui_moving] then
		local size = self.sizes[self.ui_moving]
		d.glTranslate(Map.display_x, Map.display_y, 0)
		if size.left then d.drawQuad(0, 0, 10, Map.viewport.height, 0, 200, 0, 50) end
		if size.right then d.drawQuad(Map.viewport.width - 10, 0, 10, Map.viewport.height, 0, 200, 0, 50) end
		if size.top then d.drawQuad(0, 0, Map.viewport.width, 10, 0, 200, 0, 50) end
		if size.bottom then d.drawQuad(0, Map.viewport.height - 10, Map.viewport.width, 10, 0, 200, 0, 50) end
		d.glTranslate(-Map.display_x, -Map.display_y, -0)
	end

	UISet.display(self, nb_keyframes)
end

function _M:setupMouse(mouse)
	-- Log tooltips
	self.logdisplay:onMouse(function(item, sub_es, button, event, x, y, xrel, yrel, bx, by)
		local mx, my = core.mouse.get()
		if ((not item or not sub_es or #sub_es == 0) and (not item or not item.url)) or (item and item.faded == 0) then game.mouse:delegate(button, mx, my, xrel, yrel, nil, nil, event, "playmap") return end

		local tooltips = {}
		if sub_es then for i, e in ipairs(sub_es) do
			if e.tooltip then
				local t = e:tooltip()
				if t then table.append(tooltips, t) end
				if i < #sub_es then table.append(tooltips, { tstring{ true, "---" } } )
				else table.append(tooltips, { tstring{ true } } ) end
			end
		end end
		if item.url then
			table.append(tooltips, tstring{"Clicking will open ", {"color", "LIGHT_BLUE"}, {"font", "italic"}, item.url, {"color", "WHITE"}, {"font", "normal"}, " in your browser"})
		end

		local extra = {}
		extra.log_str = tooltips
		game.tooltip.old_ttmx = -100
		game.mouse:delegate(button, mx, my, xrel, yrel, nil, nil, event, "playmap", extra)
	end)

	-- Chat tooltips
	profile.chat:onMouse(function(user, item, button, event, x, y, xrel, yrel, bx, by)
		local mx, my = core.mouse.get()
		if not item or not user or item.faded == 0 then game.mouse:delegate(button, mx, my, xrel, yrel, nil, nil, event, "playmap") return end

		local str = tstring{{"color","GOLD"}, {"font","bold"}, user.name, {"color","LAST"}, {"font","normal"}, true}
		if (user.donator and user.donator ~= "none") or (user.status and user.status == 'dev') then
			local text, color = "Donator", colors.WHITE
			if user.status and user.status == 'dev' then text, color = "Developer", colors.CRIMSON
			elseif user.status and user.status == 'mod' then text, color = "Moderator / Helper", colors.GOLD
			elseif user.donator == "oneshot" then text, color = "Donator", colors.LIGHT_GREEN
			elseif user.donator == "recurring" then text, color = "Recurring Donator", colors.LIGHT_BLUE end
			str:add({"color",unpack(colors.simple(color))}, text, {"color", "LAST"}, true)
		end
		str:add({"color","ANTIQUE_WHITE"}, "Playing: ", {"color", "LAST"}, user.current_char, true)
		str:add({"color","ANTIQUE_WHITE"}, "Game: ", {"color", "LAST"}, user.module, "(", user.valid, ")",true)

		if item.url then
			str:add(true, "---", true, "点击 ", {"color", "LIGHT_BLUE"}, {"font", "italic"}, item.url, {"color", "WHITE"}, {"font", "normal"}, " 将其在浏览器中打开")
		end

		local extra = {}
		if item.extra_data and item.extra_data.mode == "tooltip" then
			local rstr = tstring{item.extra_data.tooltip, true, "---", true, "Linked by: "}
			rstr:merge(str)
			extra.log_str = rstr
		else
			extra.log_str = str
			if button == "right" and event == "button" then
				extra.add_map_action = {
					{ name="Show chat user", fct=function() profile.chat:showUserInfo(user.login) end },
					{ name="Whisper", fct=function() profile.chat:setCurrentTarget(false, user.login) profile.chat:talkBox() end },
					{ name="Ignore", fct=function() Dialog:yesnoPopup("Ignore user", "Really ignore all messages from: "..user.login, function(ret) if ret then profile.chat:ignoreUser(user.login) end end) end },
					{ name="Report user for bad behavior", fct=function()
						game:registerDialog(require('engine.dialogs.GetText').new("Reason to report: "..user.login, "Reason", 4, 500, function(text)
							profile.chat:reportUser(user.login, text)
							game.log("#VIOLET#", "Report sent.")
						end))
					end },
				}
				if profile.chat:isFriend(user.login) then
					table.insert(extra.add_map_action, 3, { name="Remove Friend", fct=function() Dialog:yesnoPopup("Remove Friend", "Really remove "..user.login.." from your friends?", function(ret) if ret then profile.chat:removeFriend(user.login, user.id) end end) end })
				else
					table.insert(extra.add_map_action, 3, { name="Add Friend", fct=function() Dialog:yesnoPopup("Add Friend", "Really add "..user.login.." to your friends?", function(ret) if ret then profile.chat:addFriend(user.login, user.id) end end) end })
				end
			end
		end
		game.tooltip.old_tmx = -100
		game.mouse:delegate(button, mx, my, xrel, yrel, nil, nil, event, "playmap", extra)
	end)
end
