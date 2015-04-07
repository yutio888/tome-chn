-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2015 Nicolas Casalini
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
require "engine.GameTurnBased"
require "engine.interface.GameMusic"
require "engine.interface.GameSound"
require "engine.interface.GameTargeting"
local KeyBind = require "engine.KeyBind"
local Savefile = require "engine.Savefile"
local DamageType = require "engine.DamageType"
local Zone = require "mod.class.Zone"
local Tiles = require "engine.Tiles"
local Map = require "engine.Map"
local Level = require "engine.Level"
local Birther = require "mod.dialogs.Birther"
local Astar = require "engine.Astar"
local DirectPath = require "engine.DirectPath"
local Shader = require "engine.Shader"
local HighScores = require "engine.HighScores"
local FontPackage = require "engine.FontPackage"

local NicerTiles = require "mod.class.NicerTiles"
local GameState = require "mod.class.GameState"
local Store = require "mod.class.Store"
local Trap = require "mod.class.Trap"
local Grid = require "mod.class.Grid"
local Actor = require "mod.class.Actor"
local Party = require "mod.class.Party"
local Player = require "mod.class.Player"
local NPC = require "mod.class.NPC"

local DebugConsole = require "engine.DebugConsole"
local FlyingText = require "engine.FlyingText"
local Tooltip = require "mod.class.Tooltip"
local BigNews = require "mod.class.BigNews"

local Calendar = require "engine.Calendar"
local Gestures = require "engine.ui.Gestures"

local Dialog = require "engine.ui.Dialog"
local MapMenu = require "mod.dialogs.MapMenu"

module(..., package.seeall, class.inherit(engine.GameTurnBased, engine.interface.GameMusic, engine.interface.GameSound, engine.interface.GameTargeting))

-- Difficulty settings
DIFFICULTY_EASY = 1
DIFFICULTY_NORMAL = 2
DIFFICULTY_NIGHTMARE = 3
DIFFICULTY_INSANE = 4
DIFFICULTY_MADNESS = 5
PERMADEATH_INFINITE = 1
PERMADEATH_MANY = 2
PERMADEATH_ONE = 3

-- Tell the engine that we have a fullscreen shader that supports gamma correction
support_shader_gamma = true

function _M:init()
	engine.GameTurnBased.init(self, engine.KeyBind.new(), 1000, 100)
	engine.interface.GameMusic.init(self)
	engine.interface.GameSound.init(self)

	-- Pause at birth
	self.paused = true

	-- Same init as when loaded from a savefile
	self:loaded()

	self.visited_zones = {}
	self.tiles_attachements = {}
	self.tiles_facing = {}
end

function _M:run()
	class:triggerHook{"ToME:run"}
	local ret = self:runReal()
	class:triggerHook{"ToME:runDone"}
	return ret
end

function _M:runReal()
	self.delayed_log_damage = {}
	self.delayed_log_messages = {}
	self.calendar = Calendar.new("/data/calendar_allied.lua", "今天是 %s %s 第 %s 年 卓越纪，马基埃亚尔。\n现在时间是 %02d:%02d.", 122, 167, 11)

	self.uiset:activate()

	local flyfont, flysize = FontPackage:getFont("flyer")
	self.tooltip = Tooltip.new(self.uiset.init_font_mono, self.uiset.init_size_mono, {255,255,255}, {30,30,30,230})
	self.tooltip2 = Tooltip.new(self.uiset.init_font_mono, self.uiset.init_size_mono, {255,255,255}, {30,30,30,230})
	self.flyers = FlyingText.new(flyfont, flysize, flyfont, flysize + 3)
	self.flyers:enableShadow(0.6)
	game:setFlyingText(self.flyers)

	self.bignews = BigNews.new("/data-chn123/font/main.ttf", 30)

	self.nicer_tiles = NicerTiles.new()

	-- Ok everything is good to go, activate the game in the engine!
	self:setCurrent()

	-- Start time
	self.real_starttime = os.time()

	self:setupDisplayMode(false, "postinit")
	if self.level and self.level.data.day_night then self.state:dayNightCycle() end
	if self.level and self.player then self.calendar = Calendar.new("/data/calendar_"..(self.player.calendar or "allied")..".lua", "今天是 %s %s 第 %s 年 卓越纪，马基埃亚尔。\n现在时间是 %02d:%02d.", 122, 167, 11) end

	-- Setup inputs
	self:setupCommands()
	self:setupMouse()

	-- Starting from here we create a new game
	if self.player and self.player.dead then
		print("Player is dead, rebooting")
		util.showMainMenu()
		return
	end
	if not self.player then self:newGame() end

	engine.interface.GameTargeting.init(self)
	if self.target then self.target:enableFBORenderer("ui/targetshader.png", "target_fbo") end

	self.uiset.hotkeys_display.actor = self.player
	self.uiset.npcs_display.actor = self.player

	-- Run the current music if any
	self:onTickEnd(function()
		self:playMusic()
		if self.level then
			self.level.map:moveViewSurround(self.player.x, self.player.y, config.settings.tome.scroll_dist, config.settings.tome.scroll_dist)
		end
	end)

	-- Create the map scroll text overlay
	local lfont = core.display.newFont("/data-chn123/font/main.ttf", 30)
	lfont:setStyle("bold")
	local s = core.display.drawStringBlendedNewSurface(lfont, "<Scroll mode, press keys to scroll, caps lock to exit>", unpack(colors.simple(colors.GOLD)))
	lfont:setStyle("normal")
	self.caps_scroll = {s:glTexture()}
	self.caps_scroll.w, self.caps_scroll.h = s:getSize()

	self.zone_font = core.display.newFont("/data-chn123/font/main.ttf", 12)

	self.inited = true

	if self.level and self.level.map then
		self.nicer_tiles:postProcessLevelTilesOnLoad(self.level)
	end
end

--- Resize the hotkeys
function _M:resizeIconsHotkeysToolbar()
	self.uiset:resizeIconsHotkeysToolbar()
end

--- Checks if the current character is "tainted" by cheating
function _M:isTainted()
	if config.settings.cheat then return true end
	return (game.player and game.player.__cheated) and true or false
end

--- Sets the player name
function _M:setPlayerName(name)
	name = name:removeColorCodes():gsub("#", " "):sub(1, 25)
	self.save_name = name
	self.player_name = name
	if self.party and self.party:findMember{main=true} then
		self.party:findMember{main=true}.name = name
	end
end

function _M:newGame()
	self.party = Party.new{}
	local player = Player.new{name=self.player_name, game_ender=true}
	self.party:addMember(player, {
		control="full",
		type="player",
		title="Main character",
		main=true,
		orders = {target=true, anchor=true, behavior=true, leash=true, talents=true},
	})
	self.party:setPlayer(player)

	-- Create the entity to store various game state things
	self.state = GameState.new{}
	local birth_done = function()
		if self.state.birth.__allow_rod_recall then game.state:allowRodRecall(true) self.state.birth.__allow_rod_recall = nil end
		if self.state.birth.__allow_transmo_chest and profile.mod.allow_build.birth_transmo_chest then
			self.state.birth.__allow_transmo_chest = nil
			local chest = game.zone:makeEntityByName(game.level, "object", "TRANSMO_CHEST")
			if chest then
				game.zone:addEntity(game.level, chest, "object")
				self.player:addObject(self.player:getInven("INVEN"), chest)
			end
		end

		for i = 1, 50 do
			local o = self.state:generateRandart{add_pool=true}
			self.zone.object_list[#self.zone.object_list+1] = o
		end

		if config.settings.cheat then self.player.__cheated = true end

		self.player:recomputeGlobalSpeed()

		-- Force the hotkeys to be sorted.
		self.player:sortHotkeys()

		-- Register the character online if possible
		self.player:getUUID()
		self:updateCurrentChar()
	end

	if not config.settings.tome.tactical_mode_set then
		self.always_target = true
	else
		self.always_target = config.settings.tome.tactical_mode
	end
	local nb_unlocks, max_unlocks = self:countBirthUnlocks()
	self.creating_player = true
	local birth; birth = Birther.new("角色创建 ("..nb_unlocks.."/"..max_unlocks.." 未解锁项)", self.player, {"base", "world", "difficulty", "permadeath", "race", "subrace", "sex", "class", "subclass" }, function(loaded)
		if not loaded then
			self.calendar = Calendar.new("/data/calendar_"..(self.player.calendar or "allied")..".lua", "今天是 %s %s 第 %s 年 卓越纪，马基埃亚尔。\n现在时间是 %02d:%02d.", 122, 167, 11)
			self.player:check("make_tile")
			self.player.make_tile = nil
			self.player:check("before_starting_zone")
			self.player:check("class_start_check")

			-- Configure & create the worldmap
			self.player.last_wilderness = self.player.default_wilderness[3] or "wilderness"
			game:onLevelLoad(self.player.last_wilderness.."-1", function(zone, level)
				game.player.wild_x, game.player.wild_y = game.player.default_wilderness[1], game.player.default_wilderness[2]
				if type(game.player.wild_x) == "string" and type(game.player.wild_y) == "string" then
					local spot = level:pickSpot{type=game.player.wild_x, subtype=game.player.wild_y} or {x=1,y=1}
					game.player.wild_x, game.player.wild_y = spot.x, spot.y
				end
			end)

			-- Generate
			if self.player.__game_difficulty then self:setupDifficulty(self.player.__game_difficulty) end
			self:setupPermadeath(self.player)
			--self:changeLevel(1, "test")
			self:changeLevel(self.player.starting_level or 1, self.player.starting_zone, {force_down=self.player.starting_level_force_down})
			
			print("[PLAYER BIRTH] resolve...")
			self.player:resolve()
			self.player:resolve(nil, true)
			self.player.energy.value = self.energy_to_act
			Map:setViewerFaction(self.player.faction)
			self.player:updateModdableTile()

			self.paused = true
			print("[PLAYER BIRTH] resolved!")
			local birthend = function()
				local d = require("engine.dialogs.ShowText").new("欢迎来到 #LIGHT_BLUE#马基埃亚尔", "intro-"..self.player.starting_intro, {name=self.player.name}, nil, nil, function()
					self.player:resetToFull()
					self.player:registerCharacterPlayed()
					self.player:onBirth(birth)
					-- For quickbirth
					savefile_pipe:push(self.player.name, "entity", self.party, "engine.CharacterVaultSave")
					self.creating_player = false

					self.player:grantQuest(self.player.starting_quest)

					birth_done()
					self.player:check("on_birth_done")
					self:setTacticalMode(self.always_target)

					if __module_extra_info.birth_done_script then loadstring(__module_extra_info.birth_done_script)() end
				end, true)
				self:registerDialog(d)
				if __module_extra_info.no_birth_popup then d.key:triggerVirtual("EXIT") end
			end

			if self.player.no_birth_levelup or __module_extra_info.no_birth_popup then birthend()
			else self.player:playerLevelup(birthend, true) end
		-- Player was loaded from a premade
		else
			self.calendar = Calendar.new("/data/calendar_"..(self.player.calendar or "allied")..".lua", "今天是 %s %s 第 %s 年 卓越纪，马基埃亚尔。\n现在时间是 %02d:%02d.", 122, 167, 11)
			Map:setViewerFaction(self.player.faction)
			if self.player.__game_difficulty then self:setupDifficulty(self.player.__game_difficulty) end
			self:setupPermadeath(self.player)

			-- Configure & create the worldmap
			self.player.last_wilderness = self.player.default_wilderness[3] or "wilderness"
			game:onLevelLoad(self.player.last_wilderness.."-1", function(zone, level)
				game.player.wild_x, game.player.wild_y = game.player.default_wilderness[1], game.player.default_wilderness[2]
				if type(game.player.wild_x) == "string" and type(game.player.wild_y) == "string" then
					local spot = level:pickSpot{type=game.player.wild_x, subtype=game.player.wild_y} or {x=1,y=1}
					game.player.wild_x, game.player.wild_y = spot.x, spot.y
				end
			end)

			-- Tell the level gen code to add all the party
			self.to_re_add_actors = {}
			for act, _ in pairs(self.party.members) do if self.player ~= act then self.to_re_add_actors[act] = true end end

			self:changeLevel(self.player.starting_level or 1, self.player.starting_zone, {force_down=self.player.starting_level_force_down})
			self.player:grantQuest(self.player.starting_quest)
			self.creating_player = false

			-- Add all items so they regen correctly
			self.player:inventoryApplyAll(function(inven, item, o) game:addEntity(o) end)

			birth_done()
			self.player:check("on_birth_done")
			self:setTacticalMode(self.always_target)
		end
	end, quickbirth, 800, 600)
	self:registerDialog(birth)
end

function _M:setupDifficulty(d)
	self.difficulty = d
end
function _M:setupPermadeath(p)
	if p:attr("infinite_lifes") then self.permadeath = PERMADEATH_INFINITE
	elseif p:attr("easy_mode_lifes") then self.permadeath = PERMADEATH_MANY
	else self.permadeath = PERMADEATH_ONE
	end
end

function _M:loaded()
	engine.GameTurnBased.loaded(self)
	engine.interface.GameMusic.loaded(self)
	engine.interface.GameSound.loaded(self)
	Zone:setup{
		npc_class="mod.class.NPC", grid_class="mod.class.Grid", object_class="mod.class.Object", trap_class="mod.class.Trap",
		on_setup = function(zone)
			-- Increases zone level for higher difficulties
			if not zone.__applied_difficulty then
				zone.__applied_difficulty = true
				if self.difficulty == self.DIFFICULTY_NIGHTMARE then
					zone.base_level_range = table.clone(zone.level_range, true)
					zone.specific_base_level.object = -10 -zone.level_range[1]
					zone.level_range[1] = zone.level_range[1] * 1.5 + 2
					zone.level_range[2] = zone.level_range[2] * 1.5 + 2
				elseif self.difficulty == self.DIFFICULTY_INSANE then
					zone.base_level_range = table.clone(zone.level_range, true)
					zone.specific_base_level.object = -10 -zone.level_range[1]
					zone.level_range[1] = zone.level_range[1] * 1.5 + 3
					zone.level_range[2] = zone.level_range[2] * 1.5 + 3
				elseif self.difficulty == self.DIFFICULTY_MADNESS then
					zone.base_level_range = table.clone(zone.level_range, true)
					zone.specific_base_level.object = -10 -zone.level_range[1]
					zone.level_range[1] = zone.level_range[1] * 2.5 + 6
					zone.level_range[2] = zone.level_range[2] * 2.5 + 6
				end
			end
		end,
	}
	Zone.check_filter = function(...) return self.state:entityFilter(...) end
	Zone.default_prob_filter = true
	Zone.default_filter = function(...) return self.state:defaultEntityFilter(...) end
	Zone.alter_filter = function(...) return self.state:entityFilterAlter(...) end
	Zone.post_filter = function(...) return self.state:entityFilterPost(...) end
	Zone.ego_filter = function(...) return self.state:egoFilter(...) end

	self.uiset = (require("mod.class.uiset."..(config.settings.tome.uiset_mode or "Minimalist"))).new()

	Map:setViewerActor(self.player)
	self:setupDisplayMode(false, "init")
	self:setupDisplayMode(false, "postinit")
	if self.player then self.player.changed = true end
	self.key = engine.KeyBind.new()

	if self.always_target == true or self.always_target == "old" then Map:setViewerFaction(self.player.faction) end
	if self.player and config.settings.cheat then self.player.__cheated = true end
	self:updateCurrentChar()

	if self.zone and self.zone.on_loaded then self.zone.on_loaded(self.level.level) end
end

function _M:computeAttachementSpotsFromTable(ta)
	local base = ta.default_base or 64
	local res = { }

	for tile, data in pairs(ta.tiles or {}) do
		local base = data.base or base
		local yoff = data.yoff or 0
		local t = {}
		res[tile] = t
		for kind, d in pairs(data) do if kind ~= "base" and kind ~= "yoff" then
			t[kind] = { x=d.x / base, y=(d.y + yoff) / base }
		end end
	end

	for race, data in pairs(ta.dolls or {}) do
		local base = data.base or base
		for sex, d in pairs(data) do if sex ~= "base" then
			local t = {}
			res["dolls_"..race.."_"..sex] = t
			local yoff = d.yoff or 0
			local base = d.base or base
			for kind, d in pairs(d) do if kind ~= "yoff" and kind ~= "base" then
				t[kind] = { x=d.x / base, y=(d.y + yoff) / base }
			end end
		end end
	end

	self.tiles_attachements = res
end

function _M:computeAttachementSpots()
	local t = {}
	if fs.exists(Tiles.prefix.."attachements.lua") then
		print("Loading tileset attachements from ", Tiles.prefix.."attachements.lua")
		local f, err = loadfile(Tiles.prefix.."attachements.lua")
		if not f then print("Loading tileset attachements error", err)
		else
			setfenv(f, t)
			local ok, err = pcall(f)
			if not ok then print("Loading tileset attachements error", err) end
		end		
	end
	for _, file in ipairs(fs.list(Tiles.prefix)) do if file:find("^attachements%-.+.lua$") then
		print("Loading tileset attachements from ", Tiles.prefix..file)
		local f, err = loadfile(Tiles.prefix..file)
		if not f then print("Loading tileset attachements error", err)
		else
			setfenv(f, t)
			local ok, err = pcall(f)
			if not ok then print("Loading tileset attachements error", err) end
		end		
	end end
	self:computeAttachementSpotsFromTable(t)
end

function _M:computeFacingsFromTable(ta)
	local base = ta.default_base or 64
	local res = { }

	for tile, data in pairs(ta.tiles or {}) do
		res[tile] = data
	end

	for race, data in pairs(ta.dolls or {}) do
		local base = data.base or base
		for sex, d in pairs(data) do if sex ~= "base" then
			local t = {}
			res["dolls_"..race.."_"..sex] = d
		end end
	end

	self.tiles_facing = res
end

function _M:computeFacings()
	local t = {}
	if fs.exists(Tiles.prefix.."facings.lua") then
		print("Loading tileset facings from ", Tiles.prefix.."facings.lua")
		local f, err = loadfile(Tiles.prefix.."facings.lua")
		if not f then print("Loading tileset facings error", err)
		else
			setfenv(f, t)
			local ok, err = pcall(f)
			if not ok then print("Loading tileset facings error", err) end
		end		
	end
	for _, file in ipairs(fs.list(Tiles.prefix)) do if file:find("^facings%-.+.lua$") then
		print("Loading tileset facings from ", Tiles.prefix..file)
		local f, err = loadfile(Tiles.prefix..file)
		if not f then print("Loading tileset facings error", err)
		else
			setfenv(f, t)
			local ok, err = pcall(f)
			if not ok then print("Loading tileset facings error", err) end
		end		
	end end
	self:computeFacingsFromTable(t)
end

function _M:setupDisplayMode(reboot, mode)
	if not mode or mode == "init" then
		local gfx = config.settings.tome.gfx
		self:saveSettings("tome.gfx", ('tome.gfx = {tiles=%q, size=%q, tiles_custom_dir=%q, tiles_custom_moddable=%s, tiles_custom_adv=%s}\n'):format(gfx.tiles, gfx.size, gfx.tiles_custom_dir or "", gfx.tiles_custom_moddable and "true" or "false", gfx.tiles_custom_adv and "true" or "false"))

		if reboot then
			self.change_res_dialog = true
			self:saveGame()
			util.showMainMenu(false, nil, nil, self.__mod_info.short_name, self.save_name, false)
		end

		Map:resetTiles()
	end

	if not mode or mode == "postinit" then
		local gfx = config.settings.tome.gfx

		-- Select tiles
		Tiles.prefix = "/data/gfx/"..gfx.tiles.."/"
		if config.settings.tome.gfx.tiles == "customtiles" then
			Tiles.prefix = "/data/gfx/"..config.settings.tome.gfx.tiles_custom_dir.."/"
		end
		print("[DISPLAY MODE] Tileset: "..gfx.tiles)
		print("[DISPLAY MODE] Size: "..gfx.size)

		-- Load attachement spots for this tileset
		self:computeAttachementSpots()
		self:computeFacings()

		local do_bg = gfx.tiles == "ascii_full"
		local _, _, tw, th = gfx.size:find("^([0-9]+)x([0-9]+)$")
		tw, th = tonumber(tw), tonumber(th)
		if not tw then tw, th = 64, 64 end
		local pot_th = math.pow(2, math.ceil(math.log(th-0.1) / math.log(2.0)))
		local fsize = math.floor( pot_th/th*(0.7 * th + 5) )

		local map_x, map_y, map_w, map_h = self.uiset:getMapSize()
		if th <= 20 then
			Map:setViewPort(map_x, map_y, map_w, map_h, tw, th, "/data/font/FSEX300.ttf", pot_th, do_bg)
		else
			Map:setViewPort(map_x, map_y, map_w, map_h, tw, th, nil, fsize, do_bg)
		end

		-- Show a count for stacked objects
		Map.object_stack_count = true

		Map.tiles.use_images = true
		if gfx.tiles == "ascii" then
			Map.tiles.use_images = false
			Map.tiles.force_back_color = {r=0, g=0, b=0, a=255}
			Map.tiles.no_moddable_tiles = true
		elseif gfx.tiles == "ascii_full" then
			Map.tiles.use_images = false
			Map.tiles.no_moddable_tiles = true
		elseif gfx.tiles == "shockbolt" then
			Map.tiles.nicer_tiles = true
			if tw > 64 then Map.tiles.sharp_scaling = true end
		elseif gfx.tiles == "oldrpg" then
			Map.tiles.nicer_tiles = true
			Map.tiles.sharp_scaling = true
		elseif gfx.tiles == "customtiles" then
			Map.tiles.no_moddable_tiles = not config.settings.tome.gfx.tiles_custom_moddable
			Map.tiles.nicer_tiles = config.settings.tome.gfx.tiles_custom_adv
		end

		if self.level then
			if self.level.map.finished then
				self.level.map:recreate()
				self.level.map:moveViewSurround(self.player.x, self.player.y, 8, 8)
			end
			engine.interface.GameTargeting.init(self)
		end
		self:setupMiniMap()

		self:createFBOs()

		self:createMapGridLines()
	end
end

function _M:createMapGridLines()
	if not config.settings.tome.show_grid_lines then
		Map:setupGridLines(0, 0, 0, 0, 0)
	elseif self.posteffects and self.posteffects.line_grids and self.posteffects.line_grids.shad then
		Map:setupGridLines(6, unpack(colors.hex1alpha"d5990880"))
	else
		Map:setupGridLines(2, unpack(colors.hex1alpha"d5990880"))
	end
	if self.level and self.level.map then self.level.map:regenGridLines() end
end

function _M:createFBOs()
	print("[GAME] Creating FBOs")

	-- Create the framebuffer
	self.fbo = core.display.newFBO(Map.viewport.width, Map.viewport.height)
	if self.fbo then
		self.fbo_shader = Shader.new("main_fbo")
		self.posteffects = {
			wobbling = Shader.new("main_fbo/wobbling"),
			underwater = Shader.new("main_fbo/underwater"),
			motionblur = Shader.new("main_fbo/motionblur"),
			blur = Shader.new("main_fbo/blur"),
			timestop = Shader.new("main_fbo/timestop"),
			line_grids = Shader.new("main_fbo/line_grids"),
			gestures = Shader.new("main_fbo/gestures"),
		}
		self.posteffects_use = { self.fbo_shader.shad }
		if not self.fbo_shader.shad then self.fbo = nil self.fbo_shader = nil end 
		self.fbo2 = core.display.newFBO(Map.viewport.width, Map.viewport.height)

		if self.gestures and self.posteffects and self.posteffects.gestures and self.posteffects.gestures.shad then self.gestures.shader = self.posteffects.gestures.shad end
	end
	
	if self.player then self.player:updateMainShader() end

	self.full_fbo = core.display.newFBO(self.w, self.h)
	if self.full_fbo then self.full_fbo_shader = Shader.new("full_fbo") if not self.full_fbo_shader.shad then self.full_fbo = nil self.full_fbo_shader = nil end end

	if self.fbo and self.fbo2 then core.particles.defineFramebuffer(self.fbo)
	else core.particles.defineFramebuffer(nil) end

	if self.target then self.target:enableFBORenderer("ui/targetshader.png", "target_fbo") end

	Map:enableFBORenderer("target_fbo")

--	self.mm_fbo = core.display.newFBO(200, 200)
--	if self.mm_fbo then self.mm_fbo_shader = Shader.new("mm_fbo") if not self.mm_fbo_shader.shad then self.mm_fbo = nil self.mm_fbo_shader = nil end end
end

function _M:resizeMapViewport(w, h, x, y)
	x = x and math.floor(x) or Map.display_x
	y = y and math.floor(y) or Map.display_y
	w = math.floor(w)
	h = math.floor(h)

	-- convert from older faulty versions
	if game.level and game.level.map and (rawget(game.level.map, "display_x") or rawget(game.level.map, "display_y")) then
		game.level.map.display_x, game.level.map.display_y = nil, nil
	end
	Map.display_x = x
	Map.display_y = y
	Map.viewport.width = w
	Map.viewport.height = h
	Map.viewport.mwidth = math.floor(w / Map.tile_w)
	Map.viewport.mheight = math.floor(h / Map.tile_h)

	self:createFBOs()

	if self.level then
		self.level.map:makeCMap()
		self.level.map:redisplay()
		if self.player then
			self.player:updateMainShader()
			self.level.map:moveViewSurround(self.player.x, self.player.y, config.settings.tome.scroll_dist, config.settings.tome.scroll_dist)
		end
	end
end

function _M:setupMiniMap()
	if self.level and self.level.map and self.level.map.finished then self.uiset:setupMinimap(self.level) end
end

--- Sets up a text flyers
function _M:setFlyingText(fl)
	self.flyers = fl
	function self.flyers:add(x, y, duration, xvel, yvel, str, color, bigfont)
		local slowness = (config.settings.tome.flyers_fade_time or 10)/10
		return FlyingText.add(fl, x, y, duration*slowness, xvel/slowness, yvel/slowness, str, color, bigfont)
	end
end

function _M:save()
	self.total_playtime = (self.total_playtime or 0) + (os.time() - (self.last_update or self.real_starttime))
	self.last_update = os.time()
	return class.save(self, self:defaultSavedFields{difficulty=true, permadeath=true, to_re_add_actors=true, party=true, _chronoworlds=true, total_playtime=true, on_level_load_fcts=true, visited_zones=true, bump_attack_disabled=true, show_npc_list=true, always_target=true}, true)
end

function _M:updateCurrentChar()
	if not self.party then return end
	local player = self.party:findMember{main=true}
	profile:currentCharacter(self.__mod_info.full_version_string, ("%s the level %d %s %s"):format(player.name, player.level, player.descriptor.subrace, player.descriptor.subclass), player.__te4_uuid)
end

function _M:getSaveDescription()
	local player = self.party:findMember{main=true}

	return {
		name = player.name,
		description = ([[%s the level %d %s %s.
Difficulty: %s / %s
Campaign: %s
Exploring level %d of %s.]]):format(
		player.name, player.level, player.descriptor.subrace, player.descriptor.subclass,
		player.descriptor.difficulty, player.descriptor.permadeath,
		player.descriptor.world,
		self.level and self.level.level or "--", self.zone and self.zone.name or "--"
		),
	}
end

function _M:getVaultDescription(e)
	e = e:findMember{main=true} -- Because vault "chars" are actualy parties for tome
	return {
		name = ([[%s the %s %s]]):format(e.name, e.descriptor.subrace, e.descriptor.subclass),
		descriptors = e.descriptor,
		description = ([[%s the %s %s.
Difficulty: %s / %s
Campaign: %s]]):format(
		e.name, e.descriptor.subrace, e.descriptor.subclass,
		e.descriptor.difficulty, e.descriptor.permadeath,
		e.descriptor.world
		),
	}
end

function _M:getStore(def)
	print("[STORE] Grabbing", def)
	return Store.stores_def[def]:clone()
end

function _M:leaveLevel(level, lev, old_lev)
	self.to_re_add_actors = self.to_re_add_actors or {}

	if level:hasEntity(self.player) then
		level.exited = level.exited or {}
		if lev > old_lev then
			level.exited.down = {x=self.player.x, y=self.player.y}
		else
			level.exited.up = {x=self.player.x, y=self.player.y}
		end
	end

	if level.no_remove_entities then return end

	level.last_turn = self.turn
	for act, _ in pairs(self.party.members) do
		if self.player ~= act and level:hasEntity(act) then
			level:removeEntity(act)
			self.to_re_add_actors[act] = true
		end
	end
	if level:hasEntity(self.player) then level:removeEntity(self.player) end
end

function _M:onLevelLoad(id, fct, data)
	if self.zone and self.level and id == self.zone.short_name.."-"..self.level.level then
		print("Direct execute of on level load", id, fct, data)
		fct(self.zone, self.level, data)
		return
	end

	self.on_level_load_fcts = self.on_level_load_fcts or {}
	self.on_level_load_fcts[id] = self.on_level_load_fcts[id] or {}
	local l = self.on_level_load_fcts[id]
	l[#l+1] = {fct=fct, data=data}
	print("Registering on level load", id, fct, data)
end

function _M:onLevelLoadRun()
	self.on_level_load_fcts = self.on_level_load_fcts or {}
	print("Running on level loads", self.zone.short_name.."-"..self.level.level)
	for i, fct in ipairs(self.on_level_load_fcts[self.zone.short_name.."-"..self.level.level] or {}) do
		fct.fct(self.zone, self.level, fct.data)
	end
	self.on_level_load_fcts[self.zone.short_name.."-"..self.level.level] = nil
end

function _M:changeLevel(lev, zone, params)
	params = params or {}
	if not self.player.can_change_level then
		self.logPlayer(self.player, "#LIGHT_RED#You may not change level without your own body!")
		return
	end
	if zone and not self.player.can_change_zone then
		self.logPlayer(self.player, "#LIGHT_RED#You may not leave the zone with this character!")
		return
	end
	if self.player:hasEffect(self.player.EFF_PARADOX_CLONE) or self.player:hasEffect(self.player.EFF_IMMINENT_PARADOX_CLONE) then
		self.logPlayer(self.player, "#LIGHT_RED#You cannot escape your fate by leaving the level!")
		return
	end

	-- Transmo!
	local p = self:getPlayer(true)
	local oldzone, oldlevel = game.zone, game.level
	if not params.direct_switch and p:attr("has_transmo") and p:transmoGetNumberItems() > 0 and not game.player.no_inventory_access then
		local d
		local titleupdator = self.player:getEncumberTitleUpdator(p:transmoGetName())
		d = self.player:showEquipInven(titleupdator(), nil, function(o, inven, item, button, event)
			if not o then return end
			local ud = require("mod.dialogs.UseItemDialog").new(event == "button", self.player, o, item, inven, function(_, _, _, stop)
				d:generate()
				d:generateList()
				d:updateTitle(titleupdator())
				if stop then self:unregisterDialog(d) end
			end, true)
			self:registerDialog(ud)
		end)
		d.unload = function()
			local inven = p:getInven("INVEN")
			for i = #inven, 1, -1 do
				local o = inven[i]
				if o.__transmo then
					p:transmoInven(inven, i, o)
				end
			end
			if game.zone == oldzone and game.level == oldlevel then
				self:changeLevelReal(lev, zone, params)
			end
		end
		-- Select the chest tab
		d.c_inven.dont_update_last_tabs = true
		d.c_inven:switchTab{kind="transmo"}
		p:transmoHelpPopup()
	else
		self:changeLevelReal(lev, zone, params)
	end
end

function _M:changeLevelReal(lev, zone, params)
	-- Unlock first!
	if not params.temporary_zone_shift_back and self.level and self.level.temp_shift_zone then
		self:changeLevelReal(1, "useless", {temporary_zone_shift_back=true})
	end

	local st = core.game.getTime()
	local sti = 1

	-- Flush particles remaining to draw
	core.particles.flushLast()

	-- Finish stuff registered for the previous level
	self:onTickEndExecute()

	if self.zone and self.level then self.party:leftLevel() end

	if self.player:isTalentActive(self.player.T_JUMPGATE) then
		self.player:forceUseTalent(self.player.T_JUMPGATE, {ignore_energy=true})
	end

	if self.player:isTalentActive(self.player.T_JUMPGATE_TWO) then
		self.player:forceUseTalent(self.player.T_JUMPGATE_TWO, {ignore_energy=true})
	end

	-- clear chrono worlds and their various effects
	if self._chronoworlds then self._chronoworlds = nil end

	local left_zone = self.zone
	local old_lev = (self.level and not zone) and self.level.level or -1000
	if params.keep_old_lev then old_lev = self.level.level end

	local force_recreate = false
	local recreate_nothing = false
	local popup = nil
	local afternicer = nil

	-- We only switch temporarily, keep the old one around
	if params.temporary_zone_shift then
		self:leaveLevel(self.level, lev, old_lev)

		local oz, ol = self.zone, self.level
		if type(zone) == "string" then
			self.zone = Zone.new(zone)
		else
			self.zone = zone
		end
		if type(self.zone.save_per_level) == "nil" then self.zone.save_per_level = config.settings.tome.save_zone_levels and true or false end

		self.zone:getLevel(self, lev, old_lev, true)
		self.visited_zones[self.zone.short_name] = true
		world:seenZone(self.zone.short_name)

		self.level.temp_shift_zone = oz
		self.level.temp_shift_level = ol
	-- We switch back
	elseif params.temporary_zone_shift_back then
		popup = Dialog:simpleWaiter("载入区域", "载入区域中，请稍候...", nil, 10000)
		core.display.forceRedraw()

		local old = self.level

		if self.zone and self.zone.on_leave then
			local nl, nz, stop = self.zone.on_leave(lev, old_lev, zone)
			if stop then return end
			if nl then lev = nl end
			if nz then zone = nz end
		end

		if self.zone and self.level then self.player:onLeaveLevel(self.zone, self.level) end
		if self.zone then
			self.zone:leaveLevel(false, lev, old_lev)
			self.zone:leave()
		end

		self.zone = old.temp_shift_zone
		self.level = old.temp_shift_level

		self.visited_zones[self.zone.short_name] = true
		world:seenZone(self.zone.short_name)
--		if self.level.map.closed then
			force_recreate = true
--		else
--			print("Reloading back map without having it closed")
--			recreate_nothing = true
--		end
	-- We move to a new zone as normal
	elseif not params.temporary_zone_shift then
		if self.zone and self.zone.on_leave then
			local nl, nz, stop = self.zone.on_leave(lev, old_lev, zone)
			if stop then return end
			if nl then lev = nl end
			if nz then zone = nz end
		end

		if self.zone and self.level then self.player:onLeaveLevel(self.zone, self.level) end

		if zone then
			if self.zone then
				self.zone:leaveLevel(false, lev, old_lev)
				self.zone:leave()
			end
			if type(zone) == "string" then
				self.zone = Zone.new(zone)
			else
				self.zone = zone
			end
			if self.zone.tier1 then
				if lev == 1 and game.state:tier1Killed(game.state.birth.start_tier1_skip or 3) then
					self.zone.tier1 = nil
					Dialog:yesnoPopup("Easy!", "这个区域太简单了，你能直接走到最后一层。", function(ret) if ret then
						game:changeLevel(self.zone.max_level)
					end end, "直接深入", "停在入口")
				end
			end
			if type(self.zone.save_per_level) == "nil" then self.zone.save_per_level = config.settings.tome.save_zone_levels and true or false end
		end
		local _, new_level = self.zone:getLevel(self, lev, old_lev)
		self.visited_zones[self.zone.short_name] = true
		world:seenZone(self.zone.short_name)

		if new_level then
			afternicer = self.state:startEvents()
		end
	end

	-- Post process walls
	self.nicer_tiles:postProcessLevelTiles(self.level)

	-- Post process if needed once the nicer tiles are done
	if self.level.data and self.level.data.post_nicer_tiles then self.level.data.post_nicer_tiles(self.level) end

	-- After ? events ?
	if afternicer then afternicer() end

	-- Check if we need to switch the current guardian
	self.state:zoneCheckBackupGuardian()

	-- Check if we must do some special things on load of this level
	self:onLevelLoadRun()

	-- Decay level ?
	if self.level.last_turn and self.level.data.decay and self.level.last_turn + self.level.data.decay[1] * 10 < self.turn then
		local only = self.level.data.decay.only or nil
		if not only or only.actor then
--			local nb_actor, remain_actor = self.level:decay(Map.ACTOR, function(e) return not e.unique and not e.lore and not e.quest and self.level.last_turn + rng.range(self.level.data.decay[1], self.level.data.decay[2]) < self.turn * 10 end)
--			if not self.level.data.decay.no_respawn then
--				local gen = self.zone:getGenerator("actor", self.level)
--				if gen.regenFrom then gen:regenFrom(remain_actor) end
--			end
		end

		if not only or only.object then
			local nb_object, remain_object = self.level:decay(Map.OBJECT, function(e) return not e.unique and not e.lore and not e.quest and self.level.last_turn + rng.range(self.level.data.decay[1], self.level.data.decay[2]) < self.turn * 10 end)
--			if not self.level.data.decay.no_respawn then
--				local gen = self.zone:getGenerator("object", self.level)
--				if gen.regenFrom then gen:regenFrom(remain_object) end
--			end
		end
	end

	-- Move back to old wilderness position
	if self.zone.wilderness then
		self.player:move(self.player.wild_x, self.player.wild_y, true)
		self.player.last_wilderness = self.zone.short_name
	else
		local x, y = nil, nil
		if params.auto_zone_stair and left_zone then
			-- Dirty but quick
			local list = {}
			for i = 0, self.level.map.w - 1 do for j = 0, self.level.map.h - 1 do
				local idx = i + j * self.level.map.w
				if self.level.map.map[idx][Map.TERRAIN] and self.level.map.map[idx][Map.TERRAIN].change_zone == left_zone.short_name then
					list[#list+1] = {i, j}
				end
			end end
			if #list > 0 then x, y = unpack(rng.table(list)) end
		elseif params.auto_level_stair then
			-- Dirty but quick
			local list = {}
			for i = 0, self.level.map.w - 1 do for j = 0, self.level.map.h - 1 do
				local idx = i + j * self.level.map.w
				if self.level.map.map[idx][Map.TERRAIN] and not self.level.map.map[idx][Map.TERRAIN].change_zone and self.level.map.map[idx][Map.TERRAIN].change_level == old_lev - self.level.level then
					list[#list+1] = {i, j}
				end
			end end
			if #list > 0 then x, y = unpack(rng.table(list)) end
		end

		-- Default to stairs
		if not x then
			if lev > old_lev and not params.force_down then x, y = self.level.default_up.x, self.level.default_up.y
			else x, y = self.level.default_down.x, self.level.default_down.y
			end
			if not x then x, y = self.level.default_up.x, self.level.default_up.y end
		end

		-- Check if there is already an actor at that location, if so move it
		x = x or 1 y = y or 1
		local blocking_actor = self.level.map(x, y, engine.Map.ACTOR)
		if blocking_actor then
			local newx, newy = util.findFreeGrid(x, y, 20, true, {[Map.ACTOR]=true})
			if newx and newy then blocking_actor:move(newx, newy, true)
			else blocking_actor:teleportRandom(x, y, 200) end
		end
		if self.player:canMove(x, y) then
			self.player:move(x, y, true)
		else
			self.player:move(x, y, true)
			self.player:teleportRandom(x, y, 200)
		end
	end
	self.player.changed = true
	if self.to_re_add_actors and not self.zone.wilderness and not self.zone.stellar_map then for act, _ in pairs(self.to_re_add_actors) do
		local x, y = util.findFreeGrid(self.player.x, self.player.y, 20, true, {[Map.ACTOR]=true})
		if x then act:move(x, y, true) end
	end end

	-- Re add entities
	self.level:addEntity(self.player)
	if self.to_re_add_actors and not self.zone.wilderness and not self.zone.stellar_map then
		for act, _ in pairs(self.to_re_add_actors) do
			self.level:addEntity(act)
			act:setTarget(nil)
			if act.ai_state and act.ai_state.tactic_leash_anchor then
				act.ai_state.tactic_leash_anchor = self.player
			end
		end
		self.to_re_add_actors = nil
	end

	if self.zone.on_enter then
		self.zone.on_enter(lev, old_lev, zone)
	end

	self.player:onEnterLevel(self.zone, self.level)
	self.player:resetMoveAnim()

	local musics = {}
	local keep_musics = false
	if self.level.data.ambient_music then
		if self.level.data.ambient_music ~= "last" then
			if type(self.level.data.ambient_music) == "string" then musics[#musics+1] = self.level.data.ambient_music
			elseif type(self.level.data.ambient_music) == "table" then for i, name in ipairs(self.level.data.ambient_music) do musics[#musics+1] = name end
			elseif type(self.level.data.ambient_music) == "function" then for i, name in ipairs{self.level.data.ambient_music()} do musics[#musics+1] = name end
			end
		elseif self.level.data.ambient_music == "last" then
			keep_musics = true
		end
	end
	if not keep_musics then self:playAndStopMusic(unpack(musics)) end

	-- Update the minimap
	self:setupMiniMap()

	-- Tell the map to use path strings to speed up path calculations
	for uid, e in pairs(self.level.entities) do
		if e.getPathString then
			self.level.map:addPathString(e:getPathString())
		end
	end
	self.zone_name_s = nil

	-- Special stuff
	for uid, act in pairs(self.level.entities) do if act.removeEffectsFilter then act:removeEffectsFilter(function(e) return e.zone_wide_effect end, nil, nil, true) end end
	for uid, act in pairs(self.level.entities) do
		if act.setEffect then
			if self.level.data.zero_gravity then act:setEffect(act.EFF_ZERO_GRAVITY, 1, {})
			else act:removeEffect(act.EFF_ZERO_GRAVITY, nil, true) end
		end
	end
	if self.level.data.effects then
		for uid, act in pairs(self.level.entities) do 
			if act.setEffect then for _, effid in ipairs(self.level.data.effects) do
				act:setEffect(effid, 1, {})
			end end
		end
	end
	self.level.data.effects_allow = true

	-- Level feeling
	local feeling
	if self.level.special_feeling then
		feeling = self.level.special_feeling
	else
		local lev = self.zone.base_level + self.level.level - 1
		if self.zone.level_adjust_level then lev = self.zone:level_adjust_level(self.level) end
		local diff = lev - self.player.level
		if diff >= 5 then feeling = "你因恐惧而感到不安，你觉得你的心跳开始加速， 你感到进入这个区域对你有极大的威胁。"
		elseif diff >= 2 then feeling = "你感到稍微有点不安，开始小心前行。"
		elseif diff >= -2 then feeling = nil
		elseif diff >= -5 then feeling = "你充满自信地进入了这个区域。"
		else feeling = "你大步流星地走进这片区域，打了个哈欠，你感到待在这里可能是浪费时间， 最好到别的地方去看看。"
		end
	end
	if feeling then self.log("#TEAL#%s", feeling) end

	-- Autosave
--	if config.settings.tome.autosave and not config.settings.cheat and ((left_zone and left_zone.short_name ~= "wilderness") or self.zone.save_per_level) and (left_zone and left_zone.short_name ~= self.zone.short_name) then self:saveGame() end

	self.player:onEnterLevelEnd(self.zone, self.level)

	-- Day/Night cycle
	if self.level.data.day_night then self.state:dayNightCycle() end

	if not recreate_nothing then
		--self.level.map:redisplay() -- not needed, reopen doest it
		self.level.map:reopen(true)
		if force_recreate then self.level.map:recreate() end
	end

	-- Anti stairscum
	if self.level.last_turn and self.level.last_turn < self.turn then
		local perc = util.bound(math.floor((self.turn - self.level.last_turn) / 10), 0, 10)
		for uid, target in pairs(self.level.entities) do
			if target.life and target.max_life and self.player:reactionToward(target) < 0 then
				target.life = util.bound(target.life + target.max_life * perc / 10, 0, target.max_life)
				target.changed = true
				target.talents_cd = {}

				local todel = {}
				for eff_id, p in pairs(target.tmp) do
					local e = target.tempeffect_def[eff_id]
					if e.status == "detrimental" then todel[#todel+1] = eff_id end
				end
				while #todel > 0 do
					target:removeEffect(table.remove(todel))
				end
			end
		end
	end

	if popup then popup:done() end

	self:dieClonesDie()
end

function _M:dieClonesDie()
	if not self.level then return end
	local p = self:getPlayer(true)
	if not p.puuid then return end
	for uid, e in pairs(self.level.entities) do
		if p.puuid == e.puuid and e ~= p then self.level:removeEntity(e) end
	end
end

function _M:getPlayer(main)
	if main then
		return self.party:findMember{main=true}
	else
		return self.player
	end
end

function _M:getCampaign()
	return self:getPlayer(true).descriptor.world
end

--- Says if this savefile is usable or not
function _M:isLoadable()
	if not self:getPlayer(true).dead or not self.player.dead then return true end
	return false
end

--- Clones the game world for chronomancy spells
function _M:chronoClone(name)
	self:getPlayer(true):attr("time_travel_times", 1)

	local d = Dialog:simpleWaiter("Chronomancy", "Folding the space time structure...")

	local to_reload = {}
	for uid, e in pairs(self.level.entities) do
		if type(e.project) == "table" and e.project.def and e.project.def.typ and e.project.def.typ.line_function then
			e.project.def.typ.line_function.line = { game.level.map.w, game.level.map.h, e.project.def.typ.line_function:export() }
			to_reload[#to_reload + 1] = e
		end
	end

	local ret = self:cloneFull()

	for uid, e in pairs(to_reload) do e:loaded() end

	if name then
		self._chronoworlds = self._chronoworlds or {}
		self._chronoworlds[name] = ret
		ret = nil
	end
	d:done()
	return ret
end

--- Restores a chronomancy clone
function _M:chronoRestore(name, remove)
	local ngame
	if type(name) == "string" then
		ngame = self._chronoworlds[name]
		if remove then self._chronoworlds[name] = nil end
	else ngame = name end
	if not ngame then return false end

	local d = Dialog:simpleWaiter("Chronomancy", "Unfolding the space time structure...")

	_G.game = ngame
	ngame:cloneReloaded()

	game.inited = nil
	game:runReal()
	game.key:setupRebootKeys() -- engine does it for us but not on chronoworld reload
	game.key:setCurrent()
	game.mouse:setCurrent()
	profile.chat:setupOnGame()

	core.wait.disable() -- "game" changed, we cant just unload the dialog, it doesnt exist anymore
	if game.player.resetMainShader then game.player:resetMainShader() end
	return true
end

--- Update the zone name, if needed
function _M:updateZoneName()
	local name
	if self.zone.display_name then
		name = self.zone.display_name()
		if name == "Maj'Eyal" then name = "马基埃亚尔"
		else
			name = name:gsub("Yiilkgur, the Sher'Tul Fortress","伊克格 夏·图尔堡垒"):gsub("Control Room","控制室"):gsub("Storage Room","储藏室"):gsub("Portal Room","传送室"):gsub("Exploratory Farportal","探险传送门"):gsub("Library of Lost Mysteries","失落的秘密图书馆")
		end
	else
		local lev = self.level.level
		if self.level.data.reverse_level_display then lev = 1 + self.level.data.max_level - lev end
		if self.zone.max_level == 1 then
			name = self.zone.name
		else
			name = ("%s (%d)"):format(zoneName[self.zone.name] or self.zone.name, lev)
		end
	end
	if self.zone_name_s and self.old_zone_name == name then return end

	name = zoneName[name] or name

	local s = core.display.drawStringBlendedNewSurface(self.zone_font, name, unpack(colors.simple(colors.GOLD)))
	self.zone_name_w, self.zone_name_h = s:getSize()
	self.zone_name_s, self.zone_name_tw, self.zone_name_th = s:glTexture()
	self.old_zone_name = name
	print("Updating zone name", name)
end

function _M:tick()
	if self.level then
		self:targetOnTick()

		engine.GameTurnBased.tick(self)
		-- Fun stuff: this can make the game realtime, although calling it in display() will make it work better
		-- (since display is on a set FPS while tick() ticks as much as possible
		-- engine.GameEnergyBased.tick(self)
	else
		engine.Game.tick(self)
	end

	-- Check damages to log
	self:displayDelayedLogMessages()
	self:displayDelayedLogDamage()

	if self.tick_loopback then
		self.tick_loopback = nil
		return self:tick()
	end

	if savefile_pipe.saving then self.player.changed = true end
	if self.on_tick_end and #self.on_tick_end > 0 then return false end -- Force a new tick
	if self.creating_player then return true end
	if self.paused and not savefile_pipe.saving then return true end
end

-- Game Log management functions:
-- logVisible to determine if a message should be visible to the player
-- logMessage to add a message to the display
-- delayedLogMessage to queue an actor-specific message for display at the end of the current game tick
-- displayDelayedLogMessages() to display the queued messages (before combat damage messages)
-- delayedLogDamage to queue a combat (damage) message for display at the end of the current game tick
-- displayDelayedLogDamage to display the queued combat messages

-- output a message to the log based on the visibility of an actor to the player
function _M.logSeen(e, style, ...) 
	if e and e.player or (not e.dead and e.x and e.y and game.level and game.level.map.seens(e.x, e.y) and game.player:canSee(e)) then game.log(style, ...) end 
end

-- determine whether an action between 2 actors should produce a message in the log and if the player
-- can identify them
-- output: src, srcSeen: source display?, identify?
-- tgt, tgtSeen: target display?, identify?
-- output: Visible? and srcSeen (source is identified by the player), tgtSeen(target is identified by the player)
function _M:logVisible(source, target)
	-- target should display if it's the player, an actor in a seen tile, or a non-actor without coordinates
	local tgt = target and (target.player or (target.__is_actor and game.level.map.seens(target.x, target.y)) or (not target.__is_actor and not target.x))
	local tgtSeen = tgt and (target.player or game.player:canSee(target)) or false
	local src, srcSeen = false, false
--	local srcSeen = src and (not source.x or (game.player:canSee(source) and game.player:canSee(target)))
	-- Special cases
	if not source.x then -- special case: unpositioned source uses target parameters (for timed effects on target)
		if tgtSeen then
			src, srcSeen = tgt, tgtSeen
		else
			src, tgt = nil, nil
		end
	else -- source should display if it's the player or an actor in a seen tile, or same as target for non-actors
		src = source.player or (source.__is_actor and game.level.map.seens(source.x, source.y)) or (not source.__is_actor and tgt)
		srcSeen = src and game.player:canSee(source) or false
	end	
	
	return src or tgt or false, srcSeen, tgtSeen
end

-- Generate a message (string) for the log with possible source and target,
-- highlighting the player and taking visibility into account
-- srcSeen, tgtSeen = can player see(identify) the source, target?
-- style text message to display, may contain:
-- #source#|#Source# -> <displayString>..self.name|self.name:capitalize()
-- #target#|#Target# -> target.name|target.name:capitalize()
function _M:logMessage(source, srcSeen, target, tgtSeen, style, ...)
	style = style:format(...)
	local srcname = "something"
	local Dstring
		if source.player then
			srcname = "#fbd578#"..source.name.."#LAST#"
		elseif srcSeen then
			srcname = engine.Entity.check(source, "getName") or source.name or "unknown"
		end
		if srcname ~= "something" then Dstring = source.__is_actor and source.getDisplayString and source:getDisplayString() end
	if source.name and source.name=="spatial tether" then srcname ="时空锁链" end
	srcname = logCHN:getName(srcname)
	if source.name and source.name:find("maelstrom") then srcname ="灵能漩涡" end
	
	style = style:gsub("#source#", srcname)
	style = style:gsub("#Source#", (Dstring or "")..srcname:capitalize())
	if target then
		local tgtname = "something"
			if target.player then
				tgtname = "#fbd578#"..target.name.."#LAST#"
			elseif tgtSeen then
				tgtname = engine.Entity.check(target, "getName") or target.name or "unknown"
			end
		if target and target.name=="Iceblock" then tgtname = "冰块"
		else tgtname = logCHN:getName(tgtname) end
		
		style = style:gsub("#target#", tgtname)
		style = style:gsub("#Target#", tgtname:capitalize())
	end
	if logTableCHN[style] then style = logTableCHN[style].fct() end
	style = style:gsub("#source#", srcname):gsub("#Source#", srcname):gsub("#target#", tgtname):gsub("#Target#", tgtname)
	style = style:gsub("blocked","格挡"):gsub("knocks back","击退了"):gsub("summons","召唤了"):gsub("something","某物"):gsub("projectile","抛射物")
		     :gsub("to psi shield","超能护盾吸收"):gsub(" to armor","护甲吸收"):gsub("smeared","时空转化"):gsub("antimagic","反魔盾吸收")
		     :gsub("dissipated","驱散"):gsub("reduction","减免"):gsub("gestured","手势防御"):gsub("parried","回避"):gsub("absorbed","护盾吸收")
		     :gsub("warded","守护"):gsub("resist armor","护盾减免"):gsub("STATIC","静电"):gsub("dismissed","豁免")
		     :gsub("fire","火焰"):gsub("lightning","闪电"):gsub("arcane","奥术"):gsub("cold","寒冷")
		     :gsub("blight","枯萎"):gsub("darkness","暗影"):gsub("physical","物理"):gsub("temporal","时空")
		     :gsub("light","光系"):gsub("acid","酸性"):gsub("mental","精神"):gsub("nature","自然")
		     :gsub("turned into osmosis","渗透吸收"):gsub("webs of fate","命运之网")
	return style
end

-- log an entity-specific message for display later with displayDelayedLogDamage
-- only one message (processed with logMessage) will be logged for each source and label
-- useful to avoid spamming repeated messages
-- target is optional and is used only to resolve the msg
function _M:delayedLogMessage(source, target, label, msg, ...)
	local visible, srcSeen, tgtSeen = self:logVisible(source, target)
	if visible then
		self.delayed_log_messages[source] = self.delayed_log_messages[source] or {}
		local src = self.delayed_log_messages[source]
		src[label] = self:logMessage(source, srcSeen, target, tgtSeen, msg, ...)
	end
end

-- display the delayed log messages
function _M:displayDelayedLogMessages()
	if not self.uiset or not self.uiset.logdisplay then return end
	for src, msgs in pairs(self.delayed_log_messages) do
		for label, msg in pairs(msgs) do
			game.uiset.logdisplay(self:logMessage(src, true, nil, nil, msg))
		end
	end
	self.delayed_log_messages = {}
end

-- Note: There can be up to a 1 tick delay in displaying log information
function _M:displayDelayedLogDamage()
	if not self.uiset or not self.uiset.logdisplay then return end
	for real_src, psrcs in pairs(self.delayed_log_damage) do
		for src, tgts in pairs(psrcs) do
			for target, dams in pairs(tgts) do
				if #dams.descs > 1 then
					game.uiset.logdisplay(self:logMessage(src, dams.srcSeen, target, dams.tgtSeen, "#Source# 击中 #Target# 造成 %s (%0.0f 总伤害)%s。", table.concat(dams.descs, ", "), dams.total, dams.healing<0 and (" #LIGHT_GREEN#[%0.0f 治疗]#LAST#"):format(-dams.healing) or ""))
				else
					if dams.healing >= 0 then
						game.uiset.logdisplay(self:logMessage(src, dams.srcSeen, target, dams.tgtSeen, "#Source# 击中 #Target# 造成 %s 伤害。", table.concat(dams.descs, ", ")))
					elseif src == target then
						game.uiset.logdisplay(self:logMessage(src, dams.srcSeen, target, dams.tgtSeen, "#Source# 受到 %s。", table.concat(dams.descs, ", ")))
					else
						game.uiset.logdisplay(self:logMessage(src, dams.srcSeen, target, dams.tgtSeen, "#Target# 从 #Source#处受到%s。", table.concat(dams.descs, ", ")))
					end
				end
				local rsrc = real_src.resolveSource and real_src:resolveSource() or real_src
				local rtarget = target.resolveSource and target:resolveSource() or target
				local x, y = target.x or -1, target.y or -1
				local sx, sy = self.level.map:getTileToScreen(x, y)
				if target.dead then
					if dams.tgtSeen and (rsrc == self.player or rtarget == self.player or self.party:hasMember(rsrc) or self.party:hasMember(rtarget)) then
						self.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, rng.float(-2.5, -1.5), ("Kill (%d)!"):format(dams.total), {255,0,255}, true)
						self:delayedLogMessage(target, nil,  "death", self:logMessage(src, dams.srcSeen, target, dams.tgtSeen, "#{bold}##Source#杀死了#Target#!#{normal}#"))
					end
				elseif dams.total > 0 or dams.healing == 0 then
					if dams.tgtSeen and (rsrc == self.player or self.party:hasMember(rsrc)) then
						self.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, rng.float(-3, -2), tostring(-math.ceil(dams.total)), {0,255,dams.is_crit and 200 or 0}, dams.is_crit)
					elseif dams.tgtSeen and (rtarget == self.player or self.party:hasMember(rtarget)) then
						self.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, -rng.float(-3, -2), tostring(-math.ceil(dams.total)), {255,dams.is_crit and 200 or 0,0}, dams.is_crit)
					end
				end
			end
		end
	end
	if self.delayed_death_message then game.log(self.delayed_death_message) end
	self.delayed_death_message = nil
	self.delayed_log_damage = {}
end

-- log and collate combat damage for later display with displayDelayedLogDamage
function _M:delayedLogDamage(src, target, dam, desc, crit)
	if not target or not src then return end
	local psrc = src.__project_source or src -- assign message to indirect damage source if available
	local visible, srcSeen, tgtSeen = self:logVisible(psrc, target)
	if visible then -- only log damage the player is aware of
		local t = table.getTable(self.delayed_log_damage, src, psrc, target)
		table.update(t, {total=0, healing=0, descs={}})
		t.descs[#t.descs+1] = desc
		if dam>=0 then
			t.total = t.total + dam
		else
			t.healing = t.healing + dam
		end
		t.is_crit = t.is_crit or crit
		t.srcSeen = srcSeen
		t.tgtSeen = tgtSeen
	end
end

--- Called every game turns
function _M:onTurn()
	if self.zone then
		if self.zone.on_turn then self.zone:on_turn() end
	end

	-- Process overlay effects
	self.level.map:processEffects(self.turn % 10 ~= 0)

	-- The following happens only every 10 game turns (once for every turn of 1 mod speed actors)
	if self.turn % 10 ~= 0 then return end

	-- Day/Night cycle
	if self.level.data.day_night then self.state:dayNightCycle() end

	if not self.day_of_year or self.day_of_year ~= self.calendar:getDayOfYear(self.turn) then
		self.log(self.calendar:getTimeDate(self.turn))
		self.day_of_year = self.calendar:getDayOfYear(self.turn)
	end

	if self.turn % 500 ~= 0 then return end
	self:dieClonesDie()
end

function _M:updateFOV()
	self.player:playerFOV()
end

function _M:displayMap(nb_keyframes)
	-- Now the map, if any
	if self.level and self.level.map and self.level.map.finished then
		local map = self.level.map

		-- Display the map and compute FOV for the player if needed
		local changed = map.changed
		if changed then self:updateFOV() end

		-- Ugh I dont like that but .. special case for timestop, for now it'll do!
		if self.player and self.player:attr("timestopping") and self.player.x and self.posteffects and self.posteffects.timestop and self.posteffects.timestop.shad then
			self.posteffects.timestop.shad:paramNumber2("texSize", map.viewport.width, map.viewport.height)
			local sx, sy = map:getTileToScreen(self.player.x, self.player.y)
			self.posteffects.timestop.shad:paramNumber2("playerPos", sx + map.tile_w / 2, sy + map.tile_h / 2)
			self.posteffects.timestop.shad:paramNumber("tick_real", core.game.getTime())
		end

		-- Display using Framebuffer, so that we can use shaders and all
		if self.fbo then
			self.fbo:use(true)
				if self.level.data.background then self.level.data.background(self.level, 0, 0, nb_keyframes) end
				map:display(0, 0, nb_keyframes, config.settings.tome.smooth_fov, self.fbo)
				if self.level.data.foreground then self.level.data.foreground(self.level, 0, 0, nb_keyframes) end
				if self.level.data.weather_particle then self.state:displayWeather(self.level, self.level.data.weather_particle, nb_keyframes) end
				if self.level.data.weather_shader then self.state:displayWeatherShader(self.level, self.level.data.weather_shader, map.display_x, map.display_y, nb_keyframes) end
			self.fbo:use(false, self.full_fbo)

			-- 2nd pass to apply distorting particles
			self.fbo2:use(true)
				self.fbo:toScreen(0, 0, map.viewport.width, map.viewport.height)
				core.particles.drawAlterings()
				if self.posteffects and self.posteffects.line_grids and self.posteffects.line_grids.shad then self.posteffects.line_grids.shad:use(true) end
				map._map:toScreenLineGrids(map.display_x, map.display_y)
				if self.posteffects and self.posteffects.line_grids and self.posteffects.line_grids.shad then self.posteffects.line_grids.shad:use(false) end
				if config.settings.tome.smooth_fov then map._map:drawSeensTexture(0, 0, nb_keyframes) end
			self.fbo2:use(false, self.full_fbo)

			_2DNoise:bind(1, false)
			self.fbo2:postEffects(self.fbo, self.full_fbo, map.display_x, map.display_y, map.viewport.width, map.viewport.height, unpack(self.posteffects_use))
			if self.target then self.target:display(nil, nil, self.full_fbo, nb_keyframes) end

		-- Basic display; no FBOs
		else
			if self.level.data.background then self.level.data.background(self.level, map.display_x, map.display_y, nb_keyframes) end
			map:display(nil, nil, nb_keyframes, config.settings.tome.smooth_fov, nil)
			if self.target then self.target:display(nil, nil, self.full_fbo, nb_keyframes) end
			if self.level.data.foreground then self.level.data.foreground(self.level, map.display_x, map.display_y, nb_keyframes) end
			if self.level.data.weather_particle then self.state:displayWeather(self.level, self.level.data.weather_particle, nb_keyframes) end
			if self.level.data.weather_shader then self.state:displayWeatherShader(self.level, self.level.data.weather_shader, map.display_x, map.display_y, nb_keyframes) end
			core.particles.drawAlterings()
			if self.posteffects and self.posteffects.line_grids and self.posteffects.line_grids.shad then self.posteffects.line_grids.shad:use(true) end
			map._map:toScreenLineGrids(map.display_x, map.display_y)
			if self.posteffects and self.posteffects.line_grids and self.posteffects.line_grids.shad then self.posteffects.line_grids.shad:use(false) end
			if config.settings.tome.smooth_fov then map._map:drawSeensTexture(map.display_x, map.display_y, nb_keyframes) end
		end

		-- Handle ambient sounds
		if self.level.data.ambient_bg_sounds then self.state:playAmbientSounds(self.level, self.level.data.ambient_bg_sounds, nb_keyframes) end

		if not self.zone_name_s then self:updateZoneName() end

		-- emotes display
		map:displayEmotes(nb_keyframe or 1)

		-- Mouse gestures
		self.gestures:update()
		-- self.gestures:display(map.display_x, map.display_y + map.viewport.height - self.gestures.font_h - 5)
		self.gestures:display(map.display_x, map.display_y, nb_keyframes)

		-- Inform the player that map is in scroll mode
		if core.key.modState("caps") then
			local w = map.viewport.width * 0.5
			local h = w * self.caps_scroll.h / self.caps_scroll.w
			self.caps_scroll[1]:toScreenFull(
				map.display_x + (map.viewport.width - w) / 2,
				map.display_y + (map.viewport.height - h) / 2,
				w, h,
				self.caps_scroll[2] * w / self.caps_scroll.w, self.caps_scroll[3] * h / self.caps_scroll.h,
				1, 1, 1, 0.5
			)
		end
	end
end

--- Called when screen resolution changes
function _M:checkResolutionChange(w, h, ow, oh)
	self:createFBOs()

	return self.uiset:handleResolutionChange(w, h, ow, oh)
end

function _M:display(nb_keyframes)
	-- If switching resolution, blank everything but the dialog
	if self.change_res_dialog then engine.GameTurnBased.display(self, nb_keyframes) return end

	-- Reset gamma setting, something somewhere is disrupting it, this is a stop gap solution
	if self.support_shader_gamma and self.full_fbo_shader and self.full_fbo_shader.shad then self.full_fbo_shader.shad:uniGamma(config.settings.gamma_correction / 100) end

	if self.full_fbo then self.full_fbo:use(true) end

	-- Now the ui
	self.uiset:display(nb_keyframes)

	-- "Big News"
	self.bignews:display(nb_keyframes)

	if self.player then self.player.changed = false end

	engine.GameTurnBased.display(self, nb_keyframes)

	-- Tooltip is displayed over all else, even dialogs but before FBO
	local mx, my, button = core.mouse.get()

	self.old_ctrl_state = self.ctrl_state
	self.ctrl_state = core.key.modState("ctrl")

	-- if tooltip is in way of mouse and its not locked then move it
	if self.tooltip.w and mx > self.w - self.tooltip.w and my > Tooltip:tooltip_bound_y2() - self.tooltip.h and not self.tooltip.locked then
		self:targetDisplayTooltip(Map.display_x, self.h, self.old_ctrl_state~=self.ctrl_state, nb_keyframes )
	else
		self:targetDisplayTooltip(self.w, self.h, self.old_ctrl_state~=self.ctrl_state, nb_keyframes )
	end

	if self.full_fbo then
		self.full_fbo:use(false)
		self.full_fbo:toScreen(0, 0, self.w, self.h, self.full_fbo_shader.shad)
	end

end

--- Called when a dialog is registered to appear on screen
function _M:onRegisterDialog(d)
	-- Clean up tooltip
	self.tooltip_x, self.tooltip_y = nil, nil
	self.tooltip2_x, self.tooltip2_y = nil, nil
	if self.player then self.player:updateMainShader() end

--	if self.player and self.player.runStop then self.player:runStop("dialog poping up") end
--	if self.player and self.player.restStop then self.player:restStop("dialog poping up") end
end
function _M:onUnregisterDialog(d)
	-- Clean up tooltip
	self.tooltip_x, self.tooltip_y = nil, nil
	self.tooltip2_x, self.tooltip2_y = nil, nil
	if self.player then self.player:updateMainShader() self.player.changed = true end
end

function _M:setTacticalMode(mode, silent)
	local vs = "true"
	if mode == "old" then
		self.always_target = "old"
		vs = "'old'"
		Map:setViewerFaction(self.player.faction)
		if not silent then self.log("Showing big healthbars and tactical borders.") end
	elseif mode == "health" then
		self.always_target = "health"
		vs = "'health'"
		Map:setViewerFaction(nil)
		if not silent then self.log("Showing healthbars only.") end
	elseif mode == nil then
		self.always_target = nil
		vs = "nil"
		Map:setViewerFaction(nil)
		if not silent then self.log("Showing no tactical information.") end
	elseif mode == true then
		self.always_target = true
		vs = "true"
		Map:setViewerFaction(self.player.faction)
		if not silent then self.log("Showing small healthbars and tactical borders.") end
	end

	config.settings.tome.tactical_mode = self.always_target
	config.settings.tome.tactical_mode_set = true
	game:saveSettings("tome.tactical_mode", ([[
tome.tactical_mode = %s
tome.tactical_mode_set = true
]]):format(vs))
end

function _M:setupCommands()
	-- Make targeting work
	self.normal_key = self.key
	self:targetSetupKey()

	-- Activate profiler keybinds
	self.key:setupProfiler()

	-- Activate mouse gestures
	self.gestures = Gestures.new("Gesture: ", self.key, true)
	if self.posteffects and self.posteffects.gestures and self.posteffects.gestures.shad then self.gestures.shader = self.posteffects.gestures.shad end

	-- Helper function to not allow some actions on the wilderness map
	local not_wild = function(f, bypass) return function(...) if self.zone and (not self.zone.wilderness or (bypass and bypass())) then f(...) else self.logPlayer(self.player, "You cannot do that on the world map.") end end end

	-- Debug mode
	self.key:addCommands{
		[{"_d","ctrl"}] = function() if config.settings.cheat then
			local g = self.level.map(self.player.x, self.player.y, Map.TERRAIN)
			print(g.define_as, g.image, g.z)
			for i, a in ipairs(g.add_mos or {}) do print(" => ", a.image) end
			local add = g.add_displays
			if add then for i, e in ipairs(add) do
				print(" -", e.image, e.z or "+"..i)
				for i, a in ipairs(e.add_mos or {}) do print("   => ", a.image, (a.display_x or 0).."x"..(a.display_y or 0)) end
			end end
			print("---")
			local mos = {}
			g:getMapObjects(game.level.map.tiles, mos, 1)
			table.print(mos)
			print("===============")
		end end,
		[{"_g","ctrl"}] = function() if config.settings.cheat then
			for i = 1, 10000 do
				game.log("PLOP")
				profile.chat:addMessage("talk", "tome", "test", "test", "test", {"test", colors.GOLD})
			end
do return end
			local o = game.zone:makeEntity(game.level, "object", {random_object=true}, nil, true)
			if o then
				o:identify(true)
				game.zone:addEntity(game.level, o, "object", game.player.x, game.player.y-1)
			end
do return end
			local f, err = loadfile("/data/general/events/fearscape-portal.lua")
			print(f, err)
			setfenv(f, setmetatable({level=self.level, zone=self.zone}, {__index=_G}))
			print(pcall(f))
do return end
			self:registerDialog(require("mod.dialogs.DownloadCharball").new())
		end end,
		[{"_f","ctrl"}] = function() if config.settings.cheat then
			self.player.quests["love-melinda"] = nil
			self.player:grantQuest("love-melinda")
			self.player:hasQuest("love-melinda"):melindaCompanion(self.player, "Defiler", "Corruptor")
		end end,
		[{"_UP","ctrl"}] = function()
			game.tooltip.container.scrollbar.pos = util.minBound(game.tooltip.container.scrollbar.pos - 1, 0, game.tooltip.container.scrollbar.max)
		end,
		[{"_DOWN","ctrl"}] = function()
			game.tooltip.container.scrollbar.pos = util.minBound(game.tooltip.container.scrollbar.pos + 1, 0, game.tooltip.container.scrollbar.max)
		end,
		[{"_HOME","ctrl"}] = function()
			game.tooltip.container.scrollbar.pos = 0
		end,
		[{"_END","ctrl"}] = function()
			game.tooltip.container.scrollbar.pos = game.tooltip.container.scrollbar.max
		end,
	}

	self.key.any_key = function(sym)
		-- Control resets the tooltip
		if sym == self.key._LCTRL or sym == self.key._RCTRL then
			self.player.changed = true
			self.tooltip.old_tmx = nil
		elseif sym == self.key._LSHIFT or sym == self.key._RSHIFT then
			self.player.changed = true
		end
	end
	self.key:unicodeInput(true)
	self.key:addBinds
	{
		-- Movements
		MOVE_LEFT = function() if core.key.modState("caps") and self.level then self.level.map:scrollDir(4) else self.player:moveDir(4) end end,
		MOVE_RIGHT = function() if core.key.modState("caps") and self.level then self.level.map:scrollDir(6) else self.player:moveDir(6) end end,
		MOVE_UP = function() if core.key.modState("caps") and self.level then self.level.map:scrollDir(8) else self.player:moveDir(8) end end,
		MOVE_DOWN = function() if core.key.modState("caps") and self.level then self.level.map:scrollDir(2) else self.player:moveDir(2) end end,
		MOVE_LEFT_UP = function() if core.key.modState("caps") and self.level then self.level.map:scrollDir(7) else self.player:moveDir(7) end end,
		MOVE_LEFT_DOWN = function() if core.key.modState("caps") and self.level then self.level.map:scrollDir(1) else self.player:moveDir(1) end end,
		MOVE_RIGHT_UP = function() if core.key.modState("caps") and self.level then self.level.map:scrollDir(9) else self.player:moveDir(9) end end,
		MOVE_RIGHT_DOWN = function() if core.key.modState("caps") and self.level then self.level.map:scrollDir(3) else self.player:moveDir(3) end end,
		MOVE_STAY = function() if core.key.modState("caps") and self.level then self.level.map:centerViewAround(self.player.x, self.player.y) else if self.player:enoughEnergy() then self.player:describeFloor(self.player.x, self.player.y) self.player:waitTurn() end end end,

		RUN = function()
			self.log("Run in which direction?")
			local co = coroutine.create(function()
				local x, y = self.player:getTarget{type="hit", no_restrict=true, range=1, immediate_keys=true, default_target=self.player}
				if x and y then self.player:runInit(util.getDir(x, y, self.player.x, self.player.y)) end
			end)
			local ok, err = coroutine.resume(co)
			if not ok and err then print(debug.traceback(co)) error(err) end
		end,

		RUN_AUTO = function()
			local ae = function() if self.level and self.zone then
				local seen = {}
				-- Check for visible monsters.  Only see LOS actors, so telepathy wont prevent it
				core.fov.calc_circle(self.player.x, self.player.y, self.level.map.w, self.level.map.h, self.player.sight or 10,
					function(_, x, y) return self.level.map:opaque(x, y) end,
					function(_, x, y)
						local actor = self.level.map(x, y, self.level.map.ACTOR)
						if actor and actor ~= self.player and self.player:reactionToward(actor) < 0 and
							self.player:canSee(actor) and self.level.map.seens(x, y) then seen[#seen + 1] = {x=x, y=y, actor=actor} end
					end, nil)
				if self.zone.no_autoexplore or self.level.no_autoexplore then
					self.log("你不能自动探索这一层。")
				elseif #seen > 0 then
					local dir = game.level.map:compassDirection(seen[1].x - self.player.x, seen[1].y - self.player.y)
					if dir == "northwest" then dir = "西北方向"
					elseif dir == "northeast" then dir = "东北方向"
					elseif dir == "southwest" then dir = "西南方向"
					elseif dir == "southeast" then dir = "东南方向"
					elseif dir == "east" then dir = "东面"
					elseif dir == "west" then dir = "西面"
					elseif dir == "south" then dir = "南面"
					elseif dir == "north" then dir = "北面"
					end
					self.log("当有敌人在视野里时，你不能自动探索！ (%s 在 %s方%s)!", npcCHN:getName(seen[1].actor.name), dir, self.level.map:isOnScreen(seen[1].x, seen[1].y) and "" or " - 屏幕外")
					for _, node in ipairs(seen) do
						node.actor:addParticles(engine.Particles.new("notice_enemy", 1))
					end
				elseif not self.player:autoExplore() then
					self.log("这一层没有地方可以探索了。")
				end
			end end

			if config.settings.tome.rest_before_explore then
				local ok = false
				self.player:restInit(nil, nil, nil, function() ok = self.player.resting.rested_fully end, function() if ok then self:onTickEnd(ae) self.tick_loopback = true end end)
			else
				ae()
			end
		end,

		RUN_LEFT = function() self.player:runInit(4) end,
		RUN_RIGHT = function() self.player:runInit(6) end,
		RUN_UP = function() self.player:runInit(8) end,
		RUN_DOWN = function() self.player:runInit(2) end,
		RUN_LEFT_UP = function() self.player:runInit(7) end,
		RUN_LEFT_DOWN = function() self.player:runInit(1) end,
		RUN_RIGHT_UP = function() self.player:runInit(9) end,
		RUN_RIGHT_DOWN = function() self.player:runInit(3) end,

		ATTACK_OR_MOVE_LEFT = function() self.player:attackOrMoveDir(4) end,
		ATTACK_OR_MOVE_RIGHT = function() self.player:attackOrMoveDir(6) end,
		ATTACK_OR_MOVE_UP = function() self.player:attackOrMoveDir(8) end,
		ATTACK_OR_MOVE_DOWN = function() self.player:attackOrMoveDir(2) end,
		ATTACK_OR_MOVE_LEFT_UP = function() self.player:attackOrMoveDir(7) end,
		ATTACK_OR_MOVE_LEFT_DOWN = function() self.player:attackOrMoveDir(1) end,
		ATTACK_OR_MOVE_RIGHT_UP = function() self.player:attackOrMoveDir(9) end,
		ATTACK_OR_MOVE_RIGHT_DOWN = function() self.player:attackOrMoveDir(3) end,

		-- Hotkeys
		-- bindings done after
		HOTKEY_PREV_PAGE = not_wild(function() self.player:prevHotkeyPage() self.log("Hotkey page %d is now displayed.", self.player.hotkey_page) end),
		HOTKEY_NEXT_PAGE = not_wild(function() self.player:nextHotkeyPage() self.log("Hotkey page %d is now displayed.", self.player.hotkey_page) end),

		-- Party commands
		SWITCH_PARTY_1 = not_wild(function() self.party:select(1) end),
		SWITCH_PARTY_2 = not_wild(function() self.party:select(2) end),
		SWITCH_PARTY_3 = not_wild(function() self.party:select(3) end),
		SWITCH_PARTY_4 = not_wild(function() self.party:select(4) end),
		SWITCH_PARTY_5 = not_wild(function() self.party:select(5) end),
		SWITCH_PARTY_6 = not_wild(function() self.party:select(6) end),
		SWITCH_PARTY_7 = not_wild(function() self.party:select(7) end),
		SWITCH_PARTY_8 = not_wild(function() self.party:select(8) end),
		SWITCH_PARTY = not_wild(function() self:registerDialog(require("mod.dialogs.PartySelect").new()) end),
		ORDER_PARTY_1 = not_wild(function() self.party:giveOrders(1) end),
		ORDER_PARTY_2 = not_wild(function() self.party:giveOrders(2) end),
		ORDER_PARTY_3 = not_wild(function() self.party:giveOrders(3) end),
		ORDER_PARTY_4 = not_wild(function() self.party:giveOrders(4) end),
		ORDER_PARTY_5 = not_wild(function() self.party:giveOrders(5) end),
		ORDER_PARTY_6 = not_wild(function() self.party:giveOrders(6) end),
		ORDER_PARTY_7 = not_wild(function() self.party:giveOrders(7) end),
		ORDER_PARTY_8 = not_wild(function() self.party:giveOrders(8) end),

		-- Actions
		CHANGE_LEVEL = function()
			local e = self.level.map(self.player.x, self.player.y, Map.TERRAIN)
			if self.player:enoughEnergy() and e.change_level then
				if self.player:attr("never_move") then self.log("You cannot currently leave the level.") return end

				local stop = {}
				for eff_id, p in pairs(self.player.tmp) do
					local e = self.player.tempeffect_def[eff_id]
					if e.status == "detrimental" and not e.no_stop_enter_worlmap then stop[#stop+1] = e.desc end
				end

				if e.change_zone and #stop > 0 and e.change_zone:find("^wilderness") then
					self.log("You cannot go into the wilds with the following effects: %s", table.concat(stop, ", "))
				else
					-- Do not unpause, the player is allowed first move on next level
					if e.change_level_check and e:change_level_check(self.player) then return end
					self:changeLevel(e.change_zone and e.change_level or self.level.level + e.change_level, e.change_zone, {keep_old_lev=e.keep_old_lev, force_down=e.force_down, auto_zone_stair=e.change_zone_auto_stairs, auto_level_stair=e.change_level_auto_stairs, temporary_zone_shift_back=e.change_level_shift_back})
				end
			else
				self.log("There is no way out of this level here.")
			end
		end,

		REST = function()
			self.player:restInit()
		end,

		PICKUP_FLOOR = not_wild(function()
			if self.player.no_inventory_access then return end
			self.player:playerPickup()
		end),
		DROP_FLOOR = function()
			if self.player.no_inventory_access then return end
			self.player:playerDrop()
		end,
		SHOW_INVENTORY = function()
			if self.player.no_inventory_access then return end
			local d
			local titleupdator = self.player:getEncumberTitleUpdator("Inventory")
			d = self.player:showEquipInven(titleupdator(), nil, function(o, inven, item, button, event)
				if not o then return end
				local ud = require("mod.dialogs.UseItemDialog").new(event == "button", self.player, o, item, inven, function(_, _, _, stop)
					d:generate()
					d:generateList()
					d:updateTitle(titleupdator())
					if stop then self:unregisterDialog(d) end
				end)
				self:registerDialog(ud)
			end)
		end,
		SHOW_EQUIPMENT = "SHOW_INVENTORY",
		WEAR_ITEM = function()
			if self.player.no_inventory_access then return end
			self.player:playerWear()
		end,
		TAKEOFF_ITEM = function()
			if self.player.no_inventory_access then return end
			self.player:playerTakeoff()
		end,
		USE_ITEM = not_wild(function()
			if self.player.no_inventory_access then return end
			self.player:playerUseItem()
		end),

		QUICK_SWITCH_WEAPON = function()
			if self.player.no_inventory_access then return end
			self.player:quickSwitchWeapons()
		end,

		USE_TALENTS = not_wild(function()
			self:registerDialog(require("mod.dialogs.UseTalents").new(self.player))
		end),

		LEVELUP = function()
			if self.player.no_levelup_access then return end
			self.player:playerLevelup(nil, false)
		end,

		TOGGLE_AUTOTALENT = function()
			self.player.no_automatic_talents = not self.player.no_automatic_talents
			game.log("#GOLD#Automatic talent usage: %s", not self.player.no_automatic_talents and "#LIGHT_GREEN#enabled" or "#LIGHT_RED#disabled")
		end,

		SAVE_GAME = function()
			self:saveGame()
		end,

		SHOW_QUESTS = function()
			self:registerDialog(require("engine.dialogs.ShowQuests").new(self.party:findMember{main=true}))
		end,

		SHOW_CHARACTER_SHEET = function()
			self:registerDialog(require("mod.dialogs.CharacterSheet").new(self.player))
		end,

		SHOW_MESSAGE_LOG = function()
			self:registerDialog(require("mod.dialogs.ShowChatLog").new("Message Log", 0.6, self.uiset.logdisplay, profile.chat))
		end,

		-- Show time
		SHOW_TIME = function()
			self.log(self.calendar:getTimeDate(self.turn))
		end,
		-- Exit the game
		QUIT_GAME = function()
			self:onQuit()
		end,
		-- Lua console
		LUA_CONSOLE = function()
			if config.settings.cheat then
				self:registerDialog(DebugConsole.new())
			end
		end,
		-- Debug dialog
		DEBUG_MODE = function()
			if config.settings.cheat then
				self:registerDialog(require("mod.dialogs.debug.DebugMain").new())
			end
		end,

		-- Toggle monster list
		TOGGLE_NPC_LIST = function()
			self.show_npc_list = not self.show_npc_list
			self.player.changed = true

			if (self.show_npc_list) then
				self.log("Displaying creatures.")
			else
				self.log("Displaying talents.")
			end
			if self.uiset.resizeIconsHotkeysToolbar then self.uiset:resizeIconsHotkeysToolbar() end
		end,

		SCREENSHOT = function() self:saveScreenshot() end,

		HELP = "EXIT",
		EXIT = function()
			if self.tooltip.locked then
				self.tooltip.locked = false
				self.tooltip.container.focused = self.tooltip.locked
				game.log("Tooltip %s", self.tooltip.locked and "locked" or "unlocked")
			end
			local menu
			local l = {
				"resume",
				{ "查看成就", function() self:unregisterDialog(menu) self:registerDialog(require("mod.dialogs.ShowAchievements").new("Tales of Maj'Eyal Achievements", self.player)) end },
				{ "查看手札", function() self:unregisterDialog(menu) self:registerDialog(require("mod.dialogs.ShowLore").new("马基埃亚尔札记", self.party)) end },
				{ "查看材料", function() self:unregisterDialog(menu) self:registerDialog(require("mod.dialogs.ShowIngredients").new(self.party)) end },
				"highscores",
				{ "查看物品", function() self:unregisterDialog(menu) self.key:triggerVirtual("SHOW_INVENTORY") end },
				{ "角色面板", function() self:unregisterDialog(menu) self.key:triggerVirtual("SHOW_CHARACTER_SHEET") end },
				"keybinds",
				{ "游戏选项", function() self:unregisterDialog(menu) self:registerDialog(require("mod.dialogs.GameOptions").new()) end},
				"video",
				"sound",
				"save",
				"quit",
				"exit",
			}
			local adds = self.uiset:getMainMenuItems()
			for i = #adds, 1, -1 do table.insert(l, 10, adds[i]) end
			self:triggerHook{"Game:alterGameMenu", menu=l, unregister=function() self:unregisterDialog(menu) end}
			menu = require("engine.dialogs.GameMenu").new(l)
			self:registerDialog(menu)
		end,

		TACTICAL_DISPLAY = function()
			if self.always_target == true then
				self:setTacticalMode("old")
			elseif self.always_target == "old" then
				self:setTacticalMode("health")
			elseif self.always_target == "health" then
				self:setTacticalMode(nil)
			elseif self.always_target == nil then
				self:setTacticalMode(true)
			end
		end,

		LOOK_AROUND = function()
			self.log("Looking around... (direction keys to select interesting things, shift+direction keys to move freely)")
			local co = coroutine.create(function()
				local x, y = self.player:getTarget{type="hit", no_restrict=true, range=2000}
				if x and y then
					local tmx, tmy = self.level.map:getTileToScreen(x, y)
					self:registerDialog(MapMenu.new(tmx, tmy, x, y))
				end
			end)
			local ok, err = coroutine.resume(co)
			if not ok and err then print(debug.traceback(co)) error(err) end
		end,

		LOCK_TOOLTIP = function()
			if not self.tooltip.empty then
				self.tooltip.locked = not self.tooltip.locked
				self.tooltip.container.focused = self.tooltip.locked
				game.log("Tooltip %s", self.tooltip.locked and "locked" or "unlocked")
			end
		end,

		LOCK_TOOLTIP_COMPARE = function()
			if not self.tooltip.empty then
				self.tooltip.locked = not self.tooltip.locked
				self.tooltip.container.focused = self.tooltip.locked
				game.log("Tooltip %s", self.tooltip.locked and "locked" or "unlocked")
			end
		end,

		SHOW_MAP = function()
			if config.settings.tome.uiset_mode == "Minimalist" then
				self.uiset.mm_mode = util.boundWrap((self.uiset.mm_mode or 2) + 1, 1, 3)
				if self.uiset.mm_mode == 1 then
					self.uiset.no_minimap = true
				elseif self.uiset.mm_mode == 2 then
					self.uiset.no_minimap = false
				elseif self.uiset.mm_mode == 3 then
					game:registerDialog(require("mod.dialogs.ShowMap").new(function() self.uiset.mm_mode = 1 self.uiset.no_minimap = true end))
				end
			else
				game:registerDialog(require("mod.dialogs.ShowMap").new())
			end
		end,

		USERCHAT_SHOW_TALK = function()
			self.show_userchat = not self.show_userchat
		end,

		TOGGLE_UI = function()
			self.uiset:toggleUI()
		end,

		TOGGLE_BUMP_ATTACK = function()
			local game_or_player = not config.settings.tome.actor_based_movement_mode and self or game.player

			if game_or_player.bump_attack_disabled then
				self.log("Movement Mode: #LIGHT_GREEN#Default#LAST#.")
				game_or_player.bump_attack_disabled = false
			else
				self.log("Movement Mode: #LIGHT_RED#Passive#LAST#.")
				game_or_player.bump_attack_disabled = true
			end
		end
	}
	engine.interface.PlayerHotkeys:bindAllHotkeys(self.key, not_wild(function(i)
		self:targetTriggerHotkey(i)
		self.player:activateHotkey(i)
	end, function() return self.player.allow_talents_worldmap end))

	self.key:setCurrent()
end

function _M:setupMouse(reset)
	if reset == nil or reset then self.mouse:reset() end

	local cur_obj = nil
	local outline = Shader.new("objectsoutline").shad

	self.mouse:registerZone(Map.display_x, Map.display_y, Map.viewport.width, Map.viewport.height, function(button, mx, my, xrel, yrel, bx, by, event, extra)
		if not self.uiset:isLocked() or not game.level then return end

		local tmx, tmy = game.level.map:getMouseTile(mx, my)
		if core.shader.allow("adv") and outline then
			local o = self.level.map(tmx, tmy, Map.OBJECT)
			if cur_obj and cur_obj._mo then cur_obj._mo:shader(nil) end
			if o and o._mo and not o.shader then
				outline:uniTextSize(Map.tile_w, Map.tile_h)
				o._mo:shader(outline)
				cur_obj = o
			end
		end

		self.tooltip.add_map_str = extra and extra.log_str


		if game.tooltip.locked then
			if button == "wheelup" and event == "button" then
				game.tooltip.container.scrollbar.pos = util.minBound(game.tooltip.container.scrollbar.pos - 1, 0, game.tooltip.container.scrollbar.max)
			elseif button == "wheeldown" and event == "button" then
				game.tooltip.container.scrollbar.pos = util.minBound(game.tooltip.container.scrollbar.pos + 1, 0, game.tooltip.container.scrollbar.max)
			end
			if button == "middle" then
				if not game.tooltip.container.draging then
					game.tooltip.container.draging = true
					game.tooltip.container.drag_x_start = mx
					game.tooltip.container.drag_y_start = my
				else
					game.tooltip.container.scrollbar.pos = util.minBound(game.tooltip.container.scrollbar.pos + my - game.tooltip.container.drag_y_start, 0, game.tooltip.container.scrollbar.max)
					game.tooltip.container.drag_x_start = mx
					game.tooltip.container.drag_y_start = my
				end
			else
				game.tooltip.container.draging = false
			end
		end

		-- Handle targeting
		if not config.settings.tome.disable_mouse_targeting and self:targetMouse(button, mx, my, xrel, yrel, event) then return end

		-- Cheat kill
		if config.settings.cheat and button == "right" and core.key.modState("ctrl") and core.key.modState("shift") and not xrel and not yrel and event == "button" and self.zone and not self.zone.wilderness then
			local target = game.level.map(tmx, tmy, Map.ACTOR)
			if target then
				target:die(game.player)
			end
			return
		end

		-- Handle Use menu
		if button == "right" then
			if event == "motion" then
				self.gestures:changeMouseButton(true)
				self.gestures:mouseMove(mx, my)
			elseif event == "button" then
				if not self.gestures:isGesturing() then
					if not xrel and not yrel then
						-- Handle Use menu
						self:mouseRightClick(mx, my, extra)
						return
					end
				else
					self.gestures:changeMouseButton(false)
					self.gestures:useGesture()
					self.gestures:reset()
				end
			end
		end

		-- Default left button action
		if button == "left" and not xrel and not yrel and event == "button" and self.zone and not self.zone.wilderness then if self:mouseLeftClick(mx, my) then return end end

		-- Default middle button action
		if button == "middle" and not xrel and not yrel and event == "button" and self.zone and not self.zone.wilderness then if self:mouseMiddleClick(mx, my) then return end end

		-- Handle the mouse movement/scrolling
		self.player:mouseHandleDefault(self.key, self.key == self.normal_key, button, mx, my, xrel, yrel, event)
	end, nil, "playmap")

	self.uiset:setupMouse(self.mouse)

	if not reset then self.mouse:setCurrent() end
end

--- Left mouse click on the map
function _M:mouseLeftClick(mx, my)
	if not self.level then return end
	local tmx, tmy = self.level.map:getMouseTile(mx, my)
	local p = self.player
	local a = self.level.map(tmx, tmy, Map.ACTOR)
	if not p:canSee(a) then return end
	if not p.auto_shoot_talent then return end
	local t = p:getTalentFromId(p.auto_shoot_talent)
	if not t then return end

	local target_dist = core.fov.distance(p.x, p.y, a.x, a.y)

	if p:enoughEnergy() and p:reactionToward(a) < 0 and p:knowTalent(t) and not p:isTalentCoolingDown(t) and p:preUseTalent(t, true, true) and target_dist <= p:getTalentRange(t) and p:canProject({type="hit"}, a.x, a.y) then
		p:useTalent(t.id, nil, nil, nil, a)
		return true
	end
end

--- Middle mouse click on the map
function _M:mouseMiddleClick(mx, my)
	if not self.level then return end
	local tmx, tmy = self.level.map:getMouseTile(mx, my)
	local p = self.player
	local a = self.level.map(tmx, tmy, Map.ACTOR)
	if not p:canSee(a) then return end
	if not p.auto_shoot_midclick_talent then return end
	local t = p:getTalentFromId(p.auto_shoot_midclick_talent)
	if not t then return end

	local target_dist = core.fov.distance(p.x, p.y, a.x, a.y)

	if p:enoughEnergy() and p:reactionToward(a) < 0 and p:knowTalent(t) and not p:isTalentCoolingDown(t) and p:preUseTalent(t, true, true) and target_dist <= p:getTalentRange(t) and p:canProject({type="hit"}, a.x, a.y) then
		p:useTalent(t.id, nil, nil, nil, a)
		return true
	end
end

--- Right mouse click on the map
function _M:mouseRightClick(mx, my, extra)
	if not self.level then return end
	local tmx, tmy = self.level.map:getMouseTile(mx, my)
	self:registerDialog(MapMenu.new(mx, my, tmx, tmy, extra and extra.add_map_action))
end

--- Ask if we really want to close, if so, save the game first
function _M:onQuit()
	self.player:runStop("quitting")
	self.player:restStop("quitting")

	if not self.quit_dialog and not self.player.dead and not self:hasDialogUp() then
		self.quit_dialog = Dialog:yesnoPopup("Save and go back to main menu?", "Save and go back to main menu?", function(ok)
			if ok then
				-- savefile_pipe is created as a global by the engine
				self:saveGame()
				util.showMainMenu()
			end
			self.quit_dialog = nil
		end)
	end
end

function _M:onExit()
	self.player:runStop("quitting")
	self.player:restStop("quitting")

	if not self.quit_dialog and not self.player.dead and not self:hasDialogUp() then
		self.quit_dialog = Dialog:yesnoPopup("Save and exit game?", "Save and exit game?", function(ok)
			if ok then
				-- savefile_pipe is created as a global by the engine
				self:saveGame()
				savefile_pipe:forceWait()
				engine.GameTurnBased.onExit(self)
			end
			self.quit_dialog = nil
		end)
	end
end

--- Called when we leave the module
function _M:onDealloc()
	local time = os.time() - self.real_starttime
	print("Played ToME for "..time.." seconds")
end

function _M:saveVersion(token)
	if token == "new" then
		token = util.uuid()
		self.__savefile_version_tokens[token] = true
		return token
	end
--	return true
	return self.__savefile_version_tokens[token]
end

--- When a save is being made, stop running/resting
function _M:onSavefilePush()
	self.player:runStop("saving")
	self.player:restStop("saving")
end

--- When a save has been done, if it's a zone or level, also save the main game
function _M:onSavefilePushed(savename, type, object, class)
	if config.settings.cheat then return end -- Dont annoy debug
	if type == "zone" or type == "level" then self:onTickEnd(function() self:saveGame() end) end
end

--- Saves the highscore of the current char
function _M:registerHighscore()
	local player = self:getPlayer(true)
	local campaign = player.descriptor.world

	local details = {
		world = player.descriptor.world,
		subrace = player.descriptor.subrace,
		subclass = player.descriptor.subclass,
		difficulty = player.descriptor.difficulty,
		level = player.level,
		name = player.name,
		where = self.zone and self.zone.name or "???",
		dlvl = self.level and self.level.level or 1
	}
	if campaign == 'Arena' then
		details.score = self.level.arena.score
	else
		-- fallback score based on xp, this is a placeholder
		details.score = math.floor(10 * (player.level + (player.exp / player:getExpChart(player.level)))) + math.floor(player.money / 100)
	end

	if player.dead then
		details.killedby = player.killedBy and player.killedBy.name or "???"
		HighScores.registerScore(campaign, details)
	else
		HighScores.noteLivingScore(campaign, player.name, details)
	end
end

--- Requests the game to save
function _M:saveGame()
	self:registerHighscore()

	if self.party then for actor, _ in pairs(self.party.members) do engine.interface.PlayerHotkeys:updateQuickHotkeys(actor) end end

	-- savefile_pipe is created as a global by the engine
	local clone = savefile_pipe:push(self.save_name, "game", self)
	world:saveWorld()
	if not self.creating_player then
		local oldplayer = self.player
		self.party:setPlayer(self:getPlayer(true), true)

		_G.game = clone
		print("Saving JSON", pcall(function() if not game.player.__no_save_json then
			local party = game.party:cloneFull()
			party.__te4_uuid = game:getPlayer(true).__te4_uuid
			for m, _ in pairs(party.members) do
				m:attr("save_cleanup", 1)
				m:stripForExport()
				m:attr("save_cleanup", -1)
			end
			party:attr("save_cleanup", 1)
			party:stripForExport()
			party:attr("save_cleanup", -1)
			game.player:saveUUID(party)
		end end))
		_G.game = self

		self.party:setPlayer(oldplayer, true)
	end
	self.log("Saving game...")
end

--- Take a screenshot of the game
-- @param for_savefile The screenshot will be used for savefile display
function _M:takeScreenshot(for_savefile)
	if for_savefile then
		self.suppressDialogs = true
		core.display.forceRedraw()

		local x, y = self.w / 4, self.h / 4
		if self.level then
			x, y = self.level.map:getTileToScreen(self.player.x, self.player.y)
			x, y = x - self.w / 4, y - self.h / 4
			x, y = util.bound(x, 0, self.w / 2), util.bound(y, 0, self.h / 2)
		end
		local sc = core.display.getScreenshot(x, y, self.w / 2, self.h / 2)

		self.suppressDialogs = nil
		core.display.forceRedraw()

		return sc
	else
		return core.display.getScreenshot(0, 0, self.w, self.h)
	end
end

function _M:setAllowedBuild(what, notify)
	-- Do not unlock things in easy mode
	--if self.difficulty == self.DIFFICULTY_EASY then return end

	local old = profile.mod.allow_build[what]
	profile:saveModuleProfile("allow_build", {name=what})

	if old then return end

	if notify then
		self.state:checkDonation() -- They gained someting nice, they could be more receptive
		self:registerDialog(require("mod.dialogs.UnlockDialog").new(what))

		if type(unlocks_list[what]) == "string" then self.party.on_death_show_achieved[#self.party.on_death_show_achieved+1] = "Unlocked: "..unlocks_list[what] end
	end

	return true
end

function _M:unlockBackground(kind, name)
	if not config.settings['unlock_background_'..kind] then
		game.log("#ANTIQUE_WHITE#Splash screen unlocked: #GOLD#"..name)
	end
	config.settings['unlock_background_'..kind] = true
	local save = {}
	for k, v in pairs(config.settings) do if k:find("^unlock_background_") then
		save[#save+1] = k.."=true"
	end end
	game:saveSettings("unlock_background", table.concat(save, "\n"))
end

function _M:playSoundNear(who, name)
	if who and (not who.attr or not who:attr("_forbid_sounds")) and self.level and self.level.map.seens(who.x, who.y) then
		local pos = {x=0,y=0,z=0}
		if self.player and self.player.x then pos.x, pos.y = who.x - self.player.x, who.y - self.player.y end
		self:playSound(name, pos)
	end
end

--- Create a random lore object and place it
function _M:placeRandomLoreObjectScale(base, nb, level)
	local dist = ({
		[5] = { {1}, {2,3}, {4,5} }, -- 5 => 3
		korpul = { {1,2}, {3,4} }, -- 5 => 3
		maze = { {1,2,3,4},{5,6,7} }, -- 5 => 3
		daikara = { {1}, {2}, {3}, {4,5} },
		[7] = { {1,2}, {3,4}, {5,6}, {7} }, -- 7 => 4
	})[nb][level]
	if not dist then return end
	for _, i in ipairs(dist) do self:placeRandomLoreObject(base..i) end
end

--- Create a random lore object and place it
function _M:placeRandomLoreObject(define)
	if type(define) == "table" then define = rng.table(define) end
	local o = self.zone:makeEntityByName(self.level, "object", define)
	if not o then return end
	if o.checkFilter and not o:checkFilter({}) then return end

	local x, y = rng.range(0, self.level.map.w-1), rng.range(0, self.level.map.h-1)
	local tries = 0
	while (self.level.map:checkEntity(x, y, Map.TERRAIN, "block_move") or self.level.map(x, y, Map.OBJECT) or self.level.map.room_map[x][y].special) and tries < 100 do
		x, y = rng.range(0, self.level.map.w-1), rng.range(0, self.level.map.h-1)
		tries = tries + 1
	end
	if tries < 100 then
		self.zone:addEntity(self.level, o, "object", x, y)
		print("Placed lore", o.name, x, y)
		o:identify(true)
	end
end

unlocks_list = {
	birth_transmo_chest = "Birth option: Transmogrification Chest",
	birth_zigur_sacrifice = "Birth option: Zigur sacrifice",
	cosmetic_race_human_redhead = "Cosmetic: Redheads",
	cosmetic_race_dwarf_female_beard = "Cosmetic: Female dwarves facial pilosity",
	
	difficulty_insane = "Difficulty: Insane",
	difficulty_madness = "Difficulty: Madness",

	campaign_infinite_dungeon = "Campaign: Infinite Dungeon",
	campaign_arena = "Campaign: The Arena",

	undead_ghoul = "Race: Ghoul",
	undead_skeleton = "Race: Skeleton",
	yeek = "Race: Yeek",

	mage = "Class: Archmage",
	mage_tempest = "Class tree: Storm",
	mage_geomancer = "Class tree: Stone",
	mage_pyromancer = "Class tree: Wildfire",
	mage_cryomancer = "Class tree: Uttercold",
	mage_necromancer = "Class: Necromancer",
	cosmetic_class_alchemist_drolem = "Class feature: Alchemist's Drolem",

	rogue_marauder = "Class: Marauder",
	rogue_skirmisher = "Class: Skirmisher",
	rogue_poisons = "Class tree: Poisons",

	divine_anorithil = "Class: Anorithil",
	divine_sun_paladin = "Class: Sun Paladin",

	wilder_wyrmic = "Class: Wyrmic",
	wilder_summoner = "Class: Summoner",
	wilder_oozemancer = "Class: Oozemancer",

	corrupter_reaver = "Class: Reaver",
	corrupter_corruptor = "Class: Corruptor",

	afflicted_cursed = "Class: Cursed",
	afflicted_doomed = "Class: Doomed",

	chronomancer_temporal_warden = "Class: Temporal Warden",
	chronomancer_paradox_mage = "Class: Paradox Mage",

	psionic_mindslayer = "Class: Mindslayer",
	psionic_solipsist = "Class: Solipsist",

	warrior_brawler = "Class: Brawler",

	adventurer = "Class: Adventurer",
}

--- Returns the current number of birth unlocks and the max
function _M:countBirthUnlocks()
	local nb = 0
	local max = 0

	for name, _ in pairs(self.unlocks_list) do
		max = max + 1
		if profile.mod.allow_build[name] then nb = nb + 1 end
	end
	return nb, max
end

-- get a text-compatible texture (icon) for an entity
function _M:getGenericTextTiles(en)
	local disp = en
	if not disp then return "" end
	if not en.getDisplayString then
		if en.display_entity and en.display_entity.getDisplayString then
			disp = en.display_entity 
		else
			return ""
		end
	end
	disp:getMapObjects(game.uiset.hotkeys_display_icons.tiles, {}, 1)
	return tostring((disp:getDisplayString() or ""):toTString())
end
