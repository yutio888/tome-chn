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
require "mod.class.Actor"
require "engine.interface.PlayerRest"
require "engine.interface.PlayerRun"
require "engine.interface.PlayerHotkeys"
require "engine.interface.PlayerSlide"
require "engine.interface.PlayerMouse"
require "mod.class.interface.PlayerStats"
require "mod.class.interface.PlayerDumpJSON"
require "mod.class.interface.PlayerExplore"
require "mod.class.interface.PartyDeath"
local Map = require "engine.Map"
local Dialog = require "engine.ui.Dialog"
local ActorTalents = require "engine.interface.ActorTalents"

--- Defines the player for ToME
-- It is a normal actor, with some redefined methods to handle user interaction.<br/>
-- It is also able to run and rest and use hotkeys
module(..., package.seeall, class.inherit(
	mod.class.Actor,
	engine.interface.PlayerRest,
	engine.interface.PlayerRun,
	engine.interface.PlayerHotkeys,
	engine.interface.PlayerMouse,
	engine.interface.PlayerSlide,
	mod.class.interface.PlayerStats,
	mod.class.interface.PlayerDumpJSON,
	mod.class.interface.PlayerExplore,
	mod.class.interface.PartyDeath
))

-- Allow character registration even after birth
allow_late_uuid = true

function _M:init(t, no_default)
	t.display=t.display or '@'
	t.color_r=t.color_r or 230
	t.color_g=t.color_g or 230
	t.color_b=t.color_b or 230

	t.unique = t.unique or "player"
	t.player = true
	if type(t.open_door) == "nil" then t.open_door = true end
	t.type = t.type or "humanoid"
	t.subtype = t.subtype or "player"
	t.faction = t.faction or "players"

	t.ai = t.ai or "tactical"
	t.ai_state = t.ai_state or {talent_in=1, ai_move="move_astar"}

	if t.fixed_rating == nil then t.fixed_rating = true end

	-- Dont give free resists & higher stat max to players
	t.resists_cap = t.resists_cap or {}

	t.lite = t.lite or 0

	t.rank = t.rank or 3
	t.shader_old_life = 0
	t.old_air = 0
	t.old_psi = 0

	t.money_value_multiplier = t.money_value_multiplier or 1 -- changes amounts in gold piles and such

	mod.class.Actor.init(self, t, no_default)
	engine.interface.PlayerHotkeys.init(self, t)

	self.descriptor = self.descriptor or {}
	self.died_times = self.died_times or {}
	self.last_learnt_talents = self.last_learnt_talents or { class={}, generic={} }
	self.puuid = self.puuid or util.uuid()

	self.damage_log = self.damage_log or {weapon={}}
	self.damage_intake_log = self.damage_intake_log or {weapon={}}
	self.talent_kind_log = self.talent_kind_log or {}
end

function _M:registerOnBirthForceWear(data)
	self._on_birth = self._on_birth or {}
	self._on_birth[#self._on_birth+1] = function()
		local o = game.zone:makeEntityByName(game.level, "object", data, true)
		o:identify(true)
		local ro = self:wearObject(o, true, true)
		if ro then
			if type(ro) == "table" then self:addObject(self:getInven(self.INVEN_INVEN), ro) end
		elseif not ro then
			self:addObject(self:getInven(self.INVEN_INVEN), o)
		end

	end
end

function _M:registerOnBirth(f)
	self._on_birth = self._on_birth or {}
	self._on_birth[#self._on_birth+1] = f
end

function _M:onBirth(birther)
	-- Make a list of random escort levels
	local race_def = birther.birth_descriptor_def.race[self.descriptor.race]
	local subrace_def = birther.birth_descriptor_def.subrace[self.descriptor.subrace]
	local def = subrace_def.random_escort_possibilities or race_def.random_escort_possibilities
	if def then
		local zones = {}
		for i, zd in ipairs(def) do for j = zd[2], zd[3] do zones[#zones+1] = {zd[1], j} end end
		self.random_escort_levels = {}
		for i = 1, 9 do
			local z = rng.tableRemove(zones)
			print("Random escort on", z[1], z[2])
			self.random_escort_levels[z[1]] = self.random_escort_levels[z[1]] or {}
			self.random_escort_levels[z[1]][z[2]] = true
		end
	end

	for i, f in ipairs(self._on_birth or {}) do f(self, birther) end
	self._on_birth = nil
end

function _M:onEnterLevel(zone, level)
	-- Save where we entered
	self.entered_level = {x=self.x, y=self.y}

	-- mark entrance (if applicable) as noticed
	game.level.map.attrs(self.x, self.y, "noticed", true)

	local escort_zone_name = zone.short_name
	local escort_zone_offset = 0

	if zone.tier1_escort then
		escort_zone_offset = zone.tier1_escort - 1

		self.entered_tier1_zones = self.entered_tier1_zones or {}
		self.entered_tier1_zones.seen = self.entered_tier1_zones.seen or {}
		self.entered_tier1_zones.nb = self.entered_tier1_zones.nb or 0
		if not self.entered_tier1_zones.seen[zone.short_name] then
			self.entered_tier1_zones.nb = self.entered_tier1_zones.nb + 1
			self.entered_tier1_zones.seen[zone.short_name] = self.entered_tier1_zones.nb
		end

		escort_zone_name = "tier1."..self.entered_tier1_zones.seen[zone.short_name]
		print("Entering tier1 zone for escort", escort_zone_name, escort_zone_offset, level.level - escort_zone_offset)
		if self.random_escort_levels and self.random_escort_levels[escort_zone_name] then
			table.print(self.random_escort_levels[escort_zone_name])
		end
	end

	-- Fire random escort quest
	if self.random_escort_levels and self.random_escort_levels[escort_zone_name] and self.random_escort_levels[escort_zone_name][level.level - escort_zone_offset] then
		self:grantQuest("escort-duty")
	end

	-- Cancel effects
	local effs = {}
	for eff_id, p in pairs(self.tmp) do
		if self.tempeffect_def[eff_id].cancel_on_level_change then
			effs[#effs+1] = eff_id
			if type(self.tempeffect_def[eff_id].cancel_on_level_change) == "function" then self.tempeffect_def[eff_id].cancel_on_level_change(self, p) end
		end
	end
	for i, eff_id in ipairs(effs) do self:removeEffect(eff_id) end

	-- Clear existing player created effects on the map
	for i, eff in ipairs(level.map.effects) do
		if eff.src and eff.src.player then
			eff.duration = 0
			eff.grids = {}
			print("[onEnterLevel] Cancelling player created effect ", tostring(eff.name))
		end
	end
	-- Clear existing player created entities from the map
	local todel = {}
	for uid, ent in pairs(level.entities) do
		if ((ent.summoner and ent.summoner.player) or (ent.src and ent.src.player)) and not game.party:hasMember(ent) then
			print("[onEnterLevel] Terminating player created entity ", uid, ent.name, ent:getEntityKind())
			if ent.temporary then ent.temporary = 0 end
			if ent.summon_time then ent.summon_time = 0 end
			if ent.duration then ent.duration = 0 end
			if ent:getEntityKind() == "projectile" then
				todel[#todel+1] = ent
			end
		end
	end
	for _, ent in ipairs(todel) do
		level:removeEntity(ent, true)
		ent.dead = true
	end

	self:fireTalentCheck("callbackOnChangeLevel", "enter", zone, level)

	game:updateCurrentChar()
end

function _M:onEnterLevelEnd(zone, level)
	if level._player_enter_scatter then return end
	level._player_enter_scatter = true

	if level.data.generator and level.data.generator.map and level.data.generator.map.class == "engine.generator.map.Static" and not level.data.static_force_scatter then return end

	self:project({type="ball", radius=5}, self.x, self.y, function(px, py)
		local a = level.map(px, py, Map.ACTOR)
		if a and self:reactionToward(a) < 0 then
			a:teleportRandom(self.x, self.y, 50, 5)
		end
	end)
end

function _M:onLeaveLevel(zone, level)
	if self:hasEffect(self.EFF_FEED) then
		self:removeEffect(self.EFF_FEED, true)
	end

	-- Fail past escort quests
	local eid = "escort-duty-"..zone.short_name.."-"..level.level
	if self:hasQuest(eid) and not self:hasQuest(eid):isEnded() then
		local q = self:hasQuest(eid)
		q.abandoned = true
		self:setQuestStatus(eid, q.FAILED)
	end

	self:fireTalentCheck("callbackOnChangeLevel", "leave", zone, level)
end

-- Wilderness encounter
function _M:onWorldEncounter(target, x, y)
	if target.on_encounter then
		if x and y and game.level.map(x, y, Map.ACTOR) == target then
			game.level.map:remove(x, y, Map.ACTOR)
		end
		game.state:handleWorldEncounter(target)
	end
end

function _M:describeFloor(x, y, force)
	if self.old_x == x and self.old_y == y and not force then return end

	-- Autopickup things on the floor
	if self:getInven(self.INVEN_INVEN) and not self.no_inventory_access and not (self:attr("sleep") and not self:attr("lucid_dreamer")) then
		local i, nb = game.level.map:getObjectTotal(x, y), 0
		local obj = game.level.map:getObject(x, y, i)
		while obj do
			local desc = true
			if obj.auto_pickup and self:pickupFloor(i, true) then desc = false end
			if desc and self:attr("has_transmo") and obj.__transmo == nil then
				obj.__transmo_pre = true
				if self:pickupFloor(i, true) then
					desc = false
					if not obj.quest and not obj.plot then obj.__transmo = true end
				end
				obj.__transmo_pre = nil
			end
			if desc then
				if self:attr("auto_id") and obj:getPowerRank() <= self.auto_id then obj:identify(true) end
				nb = nb + 1
				game.logSeen(self, "There is an item here: %s", obj:getName{do_color=true})
			end
			i = i - 1
			obj = game.level.map:getObject(x, y, i)
		end
	end

	local g = game.level.map(x, y, game.level.map.TERRAIN)
	if g and g.change_level then
		game.logPlayer(self, "#YELLOW_GREEN#这里是“"..(gridCHN[g.name] or g.name).."”，（按下'<', '>'或右键使用）")
		local sx, sy = game.level.map:getTileToScreen(x, y)
		game.flyers:add(sx, sy, 60, 0, -1.5, ("地图切换 (%s)!"):format(gridCHN[g.name] or g.name), colors.simple(colors.YELLOW_GREEN), true)
	end
end

function _M:openVault(vault_id)
	local v = game.level.vaults_list[vault_id]
	if not v then return end

	print("Vault id", vault_id, "opens:", v.x, v.y, v.w, v.h)
	for i = v.x, v.x + v.w - 1 do for j = v.y, v.y + v.h - 1 do
		if  game.level.map.attrs(i, j, "vault_id") == vault_id then
			-- game.level.map.attrs(i, j, "vault_id", false)
			 local act = game.level.map(i, j, Map.ACTOR)
			 if act and not act.player then
			 	act:removeEffect(act.EFF_VAULTED, true, true)
			 end
		end
	end end
end

function _M:move(x, y, force)
	local ox, oy = self.x, self.y

	if not force and self:enoughEnergy() and game.level.map:checkEntity(x, y, Map.TRAP, "is_store") then
		game.level.map:checkEntity(x, y, Map.TRAP, "block_move", self, true)
		return false
	end

	local moved = mod.class.Actor.move(self, x, y, force)

	if not moved and self.encumbered then
		game.logPlayer(self, "#FF0000#You carry too much--you are encumbered!")
		game.logPlayer(self, "#FF0000#Drop some of your items.")
	end

	if not force and ox == self.x and oy == self.y and self.doPlayerSlide then
		self.doPlayerSlide = nil
		local tx, ty = self:tryPlayerSlide(x, y, false)
		if tx then moved = self:move(tx, ty, false) end
	end
	self.doPlayerSlide = nil

	if moved then
		game.level.map:moveViewSurround(self.x, self.y, config.settings.tome.scroll_dist, config.settings.tome.scroll_dist)
		game.level.map.attrs(self.x, self.y, "walked", true)

		if self.describeFloor then self:describeFloor(self.x, self.y) end

		if not force and game.level.map.attrs(self.x, self.y, "vault_id") and not game.level.map.attrs(self.x, self.y, "vault_only_door_open") then self:openVault(game.level.map.attrs(self.x, self.y, "vault_id")) end
	end

--	if not force and ox == self.x and oy == self.y and self.tryPlayerSlide then
--		x, y = self:tryPlayerSlide(x, y, false)
--		self.tryPlayerSlide = false
--		moved = self:move(x, y, false)
--		self.tryPlayerSlide = nil
--	end

	-- Update wilderness coords
	if game.zone.wilderness and not force then
		-- Cheat with time
		game.turn = game.turn + 1000
		self.wild_x, self.wild_y = self.x, self.y
		if self.x ~= ox or self.y ~= oy then
			game.state:worldDirectorAI()
		end
	end

	-- Update zone name
	if game.zone.variable_zone_name then game:updateZoneName() end

	self.old_x, self.old_y = self.x, self.y

	return moved
end

function _M:actBase()
	mod.class.Actor.actBase(self)

	-- Run out of time ?
	if self.summon_time then
		self.summon_time = self.summon_time - 1
		if self.summon_time <= 0 then
			game.logPlayer(self, "#PINK#Your summoned %s disappears.", self.name)
			self:die()
			return true
		end
	end
end

function _M:act()
	if not mod.class.Actor.act(self) then return end

	-- Funky shader things !
	self:updateMainShader()

	self.shader_old_life = self.life
	self.old_air = self.air
	self.old_psi = self.psi
	self.old_healwarn = (self:attr("no_healing") or ((self.healing_factor or 1) <= 0))

	-- Clean log flasher
--	game.flash:empty()

	-- update feed/beckoned immediately before the player moves for best visual consistency (this is not perfect but looks much better than updating mid-move)
	if self:hasEffect(self.EFF_FEED) then
		self.tempeffect_def[self.EFF_FEED].updateFeed(self, self:hasEffect(self.EFF_FEED))
	elseif self:hasEffect(self.EFF_FED_UPON) then
		local fed_upon_eff = self:hasEffect(self.EFF_FED_UPON)

		fed_upon_eff.src.tempeffect_def[fed_upon_eff.src.EFF_FEED].updateFeed(fed_upon_eff.src, fed_upon_eff.src:hasEffect(self.EFF_FEED))
	end

	-- Resting ? Running ? Otherwise pause
	if self.player and self:enoughEnergy() then
		if self:restStep() then
			while self:enoughEnergy() and self:restStep() do end
		elseif self:runStep() then
			while self:enoughEnergy() and self:runStep() do end
		end
		
		if self:enoughEnergy() then
			game.paused = true
			if game.uiset.logdisplay:getNewestLine() ~= "" then game.log("") end
		end
	elseif not self.player then
		self:useEnergy()
	end
end

function _M:tooltip(x, y, seen_by)
	local str = mod.class.Actor.tooltip(self, x, y, seen_by)
	if not str then return end
	if config.settings.cheat then str:add(true, "UID: "..self.uid, true, self.image) end

	return str
end

function _M:resetMainShader()
	self.shader_old_life = nil
	self.old_air = nil
	self.old_psi = nil
	self.old_healwarn = nil
	self:updateMainShader()
end

--- Funky shader stuff
function _M:updateMainShader()
	if game.fbo_shader then
		local effects = {}
		local pf = game.posteffects or {}

		-- Set shader HP warning
		if self.life ~= self.shader_old_life then
			if self.life < self.max_life / 2 then game.fbo_shader:setUniform("hp_warning", 1 - (self.life / self.max_life))
			else game.fbo_shader:setUniform("hp_warning", 0) end
		end
		-- Set shader air warning
		if self.air ~= self.old_air then
			if self.air < self.max_air / 2 then game.fbo_shader:setUniform("air_warning", 1 - (self.air / self.max_air))
			else game.fbo_shader:setUniform("air_warning", 0) end
		end
		if self:attr("solipsism_threshold") and self.psi ~= self.old_psi then
			local solipsism_power = self:attr("solipsism_threshold") - self:getPsi()/self:getMaxPsi()
			if solipsism_power > 0 then game.fbo_shader:setUniform("solipsism_warning", solipsism_power)
			else game.fbo_shader:setUniform("solipsism_warning", 0) end
		end
		if ((self:attr("no_healing") or ((self.healing_factor or 1) <= 0)) ~= self.old_healwarn) and not self:attr("no_healing_no_warning") then
			if (self:attr("no_healing") or ((self.healing_factor or 1) <= 0)) then
				game.fbo_shader:setUniform("intensify", {0.3,1.3,0.3,1})
			else
				game.fbo_shader:setUniform("intensify", {0,0,0,0})
			end
		end

		-- Colorize shader
		if self:attr("stealth") and self:attr("stealth") > 0 then game.fbo_shader:setUniform("colorize", {0.9,0.9,0.9,0.6})
		elseif self:attr("invisible") and self:attr("invisible") > 0 then game.fbo_shader:setUniform("colorize", {0.3,0.4,0.9,0.8})
		elseif self:attr("unstoppable") then game.fbo_shader:setUniform("colorize", {1,0.2,0,1})
		elseif self:attr("lightning_speed") then game.fbo_shader:setUniform("colorize", {0.2,0.3,1,1})
		elseif game.level and game.level.data.is_eidolon_plane then game.fbo_shader:setUniform("colorize", {1,1,1,1})
--		elseif game:hasDialogUp() then game.fbo_shader:setUniform("colorize", {0.9,0.9,0.9})
		else game.fbo_shader:setUniform("colorize", {0,0,0,0}) -- Disable
		end

		-- Blur shader
		if config.settings.tome.fullscreen_confusion and pf.blur and pf.blur.shad then
			if self:attr("confused") and self.confused >= 1 then pf.blur.shad:uniBlur(2) effects[pf.blur.shad] = true
			elseif self:attr("sleep") and not self:attr("lucid_dreamer") and self.sleep >= 1 then pf.blur.shad:uniBlur(2) effects[pf.blur.shad] = true
			end
		end

		-- Moving Blur shader
		if pf.motionblur and pf.motionblur.shad then
			if self:attr("invisible") then pf.motionblur.shad:uniMotionblur(3) effects[pf.motionblur.shad] = true
			elseif self:attr("lightning_speed") then pf.motionblur.shad:uniMotionblur(2) effects[pf.motionblur.shad] = true
			elseif game.level and game.level.data and game.level.data.motionblur then pf.motionblur.shad:uniMotionblur(game.level.data.motionblur) effects[pf.motionblur.shad] = true
			end
		end

		-- Underwater shader
		if game.level and game.level.data and game.level.data.underwater and pf.underwater and pf.underwater.shad then effects[pf.underwater.shad] = true
		end

		-- Wobbling shader
		if config.settings.tome.fullscreen_stun and pf.wobbling and pf.wobbling.shad then
			if self:attr("stunned") and self.stunned >= 1 then pf.wobbling.shad:uniWobbling(1) effects[pf.wobbling.shad] = true
			elseif self:attr("dazed") and self.dazed >= 1 then pf.wobbling.shad:uniWobbling(0.7) effects[pf.wobbling.shad] = true
			end
		end

		-- Timestop shader
		if self:attr("timestopping") and pf.timestop and pf.timestop.shad then
			effects[pf.timestop.shad] = true
			pf.timestop.shad:paramNumber("tick_start", core.game.getTime())
		end

		game.posteffects_use = table.keys(effects)
		game.posteffects_use[#game.posteffects_use+1] = game.fbo_shader.shad
	end
end

-- Precompute FOV form, for speed
local fovdist = {}
for i = 0, 30 * 30 do
	fovdist[i] = math.max((20 - math.sqrt(i)) / 17, 0.6)
end
local wild_fovdist = {}
for i = 0, 10 * 10 do
	wild_fovdist[i] = math.max((5 - math.sqrt(i)) / 1.4, 0.6)
end

function _M:playerFOV()
	-- Clean FOV before computing it
	game.level.map:cleanFOV()

	-- Do wilderness stuff, nothing else
	if game.zone.wilderness then
		self:computeFOV(game.zone.wilderness_see_radius, "block_sight", function(x, y, dx, dy, sqdist) game.level.map:applyLite(x, y, wild_fovdist[sqdist]) end, true, true, true)
		return
	end

	-- Compute ESP FOV, using cache
	if (self.esp_all and self.esp_all > 0) or next(self.esp) then
		self:computeFOV(self.esp_range or 10, "block_esp", function(x, y) game.level.map:applyESP(x, y, 0.6) end, true, true, true)
	end

	-- Handle Sense spell, a simple FOV, using cache. Note that this means some terrain features can be made to block sensing
	if self:attr("detect_range") then
		self:computeFOV(self:attr("detect_range"), "block_sense", function(x, y)
			local ok = false
			if self:attr("detect_actor") and game.level.map(x, y, game.level.map.ACTOR) then ok = true end
			if self:attr("detect_object") and game.level.map(x, y, game.level.map.OBJECT) then ok = true end
			if self:attr("detect_trap") and game.level.map(x, y, game.level.map.TRAP) then
				game.level.map(x, y, game.level.map.TRAP):setKnown(self, true, x, y)
				game.level.map.remembers(x, y, true)
				game.level.map:updateMap(x, y)
				ok = true
			end

			if ok then
				if self.detect_function then self.detect_function(self, x, y) end
				game.level.map.seens(x, y, 0.6)
			end
		end, true, true, true)
	end

	-- Handle arcane eye
	if self:hasEffect(self.EFF_ARCANE_EYE) then
		local eff = self:hasEffect(self.EFF_ARCANE_EYE)
		local map = game.level.map

		core.fov.calc_circle(
			eff.x, eff.y, game.level.map.w, game.level.map.h, eff.radius, function(_, x, y) if map:checkAllEntities(x, y, "block_sight", self) then return true end end,
			function(_, x, y)
				local t = map(x, y, map.ACTOR)
				if t and (eff.true_seeing or self:canSee(t)) then
					map.seens(x, y, 1)
					if self.can_see_cache[t] then self.can_see_cache[t]["nil/nil"] = {true, 100} end
					if t ~= self then t:setEffect(t.EFF_ARCANE_EYE_SEEN, 1, {src=self, true_seeing=eff.true_seeing}) end
				end
			end,
			cache and map._fovcache["block_sight"]
		)
	end

	core.fov.calc_circle(self.x, self.y, game.level.map.w, game.level.map.h, 10,
		function(d, x, y)end, -- block
		function(d, x, y) -- apply
			local act = game.level.map(x, y, game.level.map.ACTOR)
			if act then
			local eff = act:hasEffect(act.EFF_MARKED)
				if eff and eff.src==self then
					game.level.map.seens(x, y, 0.6)
				end
			end
		end,
	nil)

	-- Handle Preternatural Senses talent, a simple FOV, using cache.
	if self:knowTalent(self.T_PRETERNATURAL_SENSES) then
		local t = self:getTalentFromId(self.T_PRETERNATURAL_SENSES)
		local range = self:getTalentRange(t)
		self:computeFOV(range, "block_sense", function(x, y)
			if game.level.map(x, y, game.level.map.ACTOR) then
				game.level.map.seens(x, y, 0.6)
			end
		end, true, true, true)

		local effStalker = self:hasEffect(self.EFF_STALKER)
		if effStalker then
			if core.fov.distance(self.x, self.y, effStalker.target.x, effStalker.target.y) <= 10 then
				game.level.map.seens(effStalker.target.x, effStalker.target.y, 0.6)
			end
		end
	end

	if self:knowTalent(self.T_SHADOW_SENSES) then
		local t = self:getTalentFromId(self.T_SHADOW_SENSES)
		local range = self:getTalentRange(t)
		local sqsense = range * range

		for shadow, _ in pairs(game.party.members) do if shadow.is_doomed_shadow and not shadow.dead then
			local arr = shadow.fov.actors_dist
			local tbl = shadow.fov.actors
			local act
			for i = 1, #arr do
				act = arr[i]
				if act and not act.dead and act.x and tbl[act] and shadow:canSee(act) and tbl[act].sqdist <= sqsense then
					game.level.map.seens(act.x, act.y, 0.6)
				end
			end
		end end
	end

	if not self:attr("blind") then
		-- Handle dark vision; same as infravision, but also sees past creeping dark
		-- this is treated as a sense, but is filtered by custom LOS code
		if self:knowTalent(self.T_DARK_VISION) then
			local t = self:getTalentFromId(self.T_DARK_VISION)
			local range = self:getTalentRange(t)
			self:computeFOV(range, "block_sense", function(x, y)
				local actor = game.level.map(x, y, game.level.map.ACTOR)
				if actor and self:hasLOS(x, y) then
					game.level.map.seens(x, y, 0.6)
				end
			end, true, true, true)
		end

		-- Handle infravision/heightened_senses which allow to see outside of lite radius but with LOS
		-- Note: Overseer of Nations bonus already factored into attributes
		if self:attr("infravision") or self:attr("heightened_senses") then
			local radius = math.max((self.heightened_senses or 0), (self.infravision or 0))
			radius = math.min(radius, self.sight)
			local rad2 = math.max(1, math.floor(radius / 4))
			self:computeFOV(radius, "block_sight", function(x, y, dx, dy, sqdist) if game.level.map(x, y, game.level.map.ACTOR) then game.level.map.seens(x, y, fovdist[sqdist]) end end, true, true, true)
			self:computeFOV(rad2, "block_sight", function(x, y, dx, dy, sqdist) game.level.map:applyLite(x, y, fovdist[sqdist]) end, true, true, true)
		end

		-- Compute both the normal and the lite FOV, using cache
		-- Do it last so it overrides others
		self:computeFOV(self.sight or 10, "block_sight", function(x, y, dx, dy, sqdist)
			game.level.map:apply(x, y, fovdist[sqdist])
		end, true, false, true)
		local lradius = self.lite
		if self.radiance_aura and lradius < self.radiance_aura then lradius = self.radiance_aura end
		if self.lite <= 0 then game.level.map:applyLite(self.x, self.y)
		else self:computeFOV(lradius, "block_sight", function(x, y, dx, dy, sqdist) game.level.map:applyLite(x, y) end, true, true, true) end

		-- For each entity, generate lite
		local uid, e = next(game.level.entities)
		while uid do
			if e ~= self and ((e.lite and e.lite > 0) or (e.radiance_aura and e.radiance_aura > 0)) and e.computeFOV then
				e:computeFOV(math.max(e.lite or 0, e.radiance_aura or 0), "block_sight", function(x, y, dx, dy, sqdist) game.level.map:applyExtraLite(x, y, fovdist[sqdist]) end, true, true)
			end
			uid, e = next(game.level.entities, uid)
		end
	else
		self:computeFOV(self.sight or 10, "block_sight") -- Still compute FOV so NPCs may target us even while blinded
		-- Inner Sight; works even while blinded
		if self:attr("blind_sight") then
			self:computeFOV(self:attr("blind_sight"), "block_sight", function(x, y, dx, dy, sqdist) game.level.map:applyLite(x, y, 0.6) end, true, true, true)
		end
	end
	self:postFOVCombatCheck()
end

function _M:doFOV()
	self:playerFOV()
end

--- Create a line to target based on field of vision
function _M:lineFOV(tx, ty, extra_block, block, sx, sy)
	sx = sx or self.x
	sy = sy or self.y
	local act = game.level.map(x, y, Map.ACTOR)
	local sees_target = game.level.map.seens(tx, ty)

	local darkVisionRange
	if self:knowTalent(self.T_DARK_VISION) then
		local t = self:getTalentFromId(self.T_DARK_VISION)
		darkVisionRange = self:getTalentRange(t)
	end
	local inCreepingDark = false

	extra_block = type(extra_block) == "function" and extra_block
		or type(extra_block) == "string" and function(_, x, y) return game.level.map:checkAllEntities(x, y, extra_block) end

	block = block or function(_, x, y)
		if darkVisionRange then
			if game.level.map:checkAllEntities(x, y, "creepingDark") then
				inCreepingDark = true
			end
			if inCreepingDark and core.fov.distance(sx, sy, x, y) > darkVisionRange then
				return true
			end
		end

		if sees_target then
			return game.level.map:checkAllEntities(x, y, "block_sight") or
				game.level.map:checkEntity(x, y, engine.Map.TERRAIN, "block_move") and not game.level.map:checkEntity(x, y, engine.Map.TERRAIN, "pass_projectile") or
				extra_block and extra_block(self, x, y)
		elseif core.fov.distance(sx, sy, x, y) <= self.sight and (game.level.map.remembers(x, y) or game.level.map.seens(x, y)) then
			return game.level.map:checkEntity(x, y, Map.TERRAIN, "block_sight") or
				game.level.map:checkEntity(x, y, engine.Map.TERRAIN, "block_move") and not game.level.map:checkEntity(x, y, engine.Map.TERRAIN, "pass_projectile") or
				extra_block and extra_block(self, x, y)
		else
			return true
		end
	end

	return core.fov.line(sx, sy, tx, ty, block)
end

--- Called before taking a hit, overload mod.class.Actor:onTakeHit() to stop resting and running
function _M:onTakeHit(value, src, death_note)
	self:runStop("taken damage")
	self:restStop("taken damage")
	local ret = mod.class.Actor.onTakeHit(self, value, src, death_note)
	if self.life < self.max_life * 0.3 then
		local sx, sy = game.level.map:getTileToScreen(self.x, self.y, true)
		game.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, 2, "LOW HEALTH!", {255,0,0}, true)
	end

	-- Hit direction warning
	if src.x and src.y and (self.x ~= src.x or self.y ~= src.y) then
		local range = core.fov.distance(src.x, src.y, self.x, self.y)
		if range > 1 then
			local angle = math.atan2(src.y - self.y, src.x - self.x)
			game.level.map:particleEmitter(self.x, self.y, 1, "hit_warning", {angle=math.deg(angle)})
		end
	end

	return ret
end

function _M:on_set_temporary_effect(eff_id, e, p)
	local ret = mod.class.Actor.on_set_temporary_effect(self, eff_id, e, p)

	if e.status == "detrimental" and not e.no_stop_resting and p.dur > 0 then
		self:runStop("detrimental status effect")
		self:restStop("detrimental status effect")
	end

	return ret
end

function _M:heal(value, src)
	-- Difficulty settings
	if game.difficulty == game.DIFFICULTY_EASY then
		value = value * 1.3
	end

	return mod.class.Actor.heal(self, value, src)
end

function _M:die(src, death_note)
	if self.runStop then self:runStop("died") end
	if self.restStop then self:restStop("died") end

	return self:onPartyDeath(src, death_note)
end

--- Suffocate a bit, lose air
function _M:suffocate(value, src, death_msg)
	local dead, affected = mod.class.Actor.suffocate(self, value, src, death_msg)
	if affected and value > 0 and self.runStop then
		-- only stop autoexplore when air is less than 75% of max.
		if self.air < 0.75 * self.max_air and self.air < 100 then
			self:runStop("suffocating")
			self:restStop("suffocating")
		end
	end
	return dead, affected
end

function _M:onChat()
	self:runStop("chat started")
	self:restStop("chat started")
end

function _M:setName(name)
	self.name = name
	game.save_name = name
end

--- Notify the player of available cooldowns
function _M:onTalentCooledDown(tid)
	if not self:knowTalent(tid) then return end
	local t = self:getTalentFromId(tid)

	local x, y = game.level.map:getTileToScreen(self.x, self.y, true)
	game.flyers:add(x, y, 30, -0.3, -3.5, ("%s available"):format(t.name:capitalize()), {0,255,00})
	game.log("#00ff00#%sTalent %s is ready to use.", (t.display_entity and t.display_entity:getDisplayString() or ""), t.name)
end

--- Tries to get a target from the user
function _M:getTarget(typ)
	if self:attr("encased_in_ice") then
		if type(typ) ~= "table" then
			return self.x, self.y, self
		end
		local orig_range = typ.range
		typ.range = 0
		local x, y, act = game:targetGetForPlayer(typ)
		typ.range = orig_range
		if x then
			return self.x, self.y, self
		else
			return
		end
	else
		if type(typ) == "table" and typ.range and typ.range == 1 and config.settings.tome.immediate_melee_keys then
			local oldft = typ.first_target
			typ = table.clone(typ)
			typ.first_target = "friend"
			typ.immediate_keys = true
			typ.default_target = self

			if config.settings.tome.immediate_melee_keys_auto and not oldft and not typ.simple_dir_request then
				local foes = {}
				for _, c in pairs(util.adjacentCoords(self.x, self.y)) do
 					local target = game.level.map(c[1], c[2], Map.ACTOR)
 					if target and self:reactionToward(target) < 0 then foes[#foes+1] = target end
 				end
 				if #foes == 1 then
					game.target.target.entity = foes[1]
					game.target.target.x = foes[1].x
					game.target.target.y = foes[1].y
					return game.target.target.x, game.target.target.y, game.target.target.entity
				end
			end
		end
		return game:targetGetForPlayer(typ)
	end
end

--- Sets the current target
function _M:setTarget(target)
	return game:targetSetForPlayer(target)
end

local function spotHostiles(self, actors_only)
	local seen = {}
	if not self.x then return seen end

	-- Check for visible monsters, only see LOS actors, so telepathy wont prevent resting
	core.fov.calc_circle(self.x, self.y, game.level.map.w, game.level.map.h, self.sight or 10, function(_, x, y) return game.level.map:opaque(x, y) end, function(_, x, y)
		local actor = game.level.map(x, y, game.level.map.ACTOR)
		if actor and self:reactionToward(actor) < 0 and self:canSee(actor) and game.level.map.seens(x, y) then
			seen[#seen + 1] = {x=x,y=y,actor=actor, entity=actor, name=actor.name}
		end
	end, nil)

	if not actors_only then
		-- Check for projectiles in line of sight
		core.fov.calc_circle(self.x, self.y, game.level.map.w, game.level.map.h, self.sight or 10, function(_, x, y) return game.level.map:opaque(x, y) end, function(_, x, y)
			local proj = game.level.map(x, y, game.level.map.PROJECTILE)
			if not proj or not game.level.map.seens(x, y) then return end

			-- trust ourselves but not our friends
			if proj.src and self == proj.src then return end
			local sx, sy = proj.start_x, proj.start_y
			local tx, ty

			-- Bresenham is too so check if we're anywhere near the mathematical line of flight
			if type(proj.project) == "table" then
				tx, ty = proj.project.def.x, proj.project.def.y
			elseif proj.homing then
				tx, ty = proj.homing.target.x, proj.homing.target.y
			end
			if tx and ty then
				local dist_to_line = math.abs((self.x - sx) * (ty - sy) - (self.y - sy) * (tx - sx)) / core.fov.distance(sx, sy, tx, ty)
				local our_way = ((self.x - x) * (tx - x) + (self.y - y) * (ty - y)) > 0
				if our_way and dist_to_line < 1.0 then
					seen[#seen+1] = {x=x, y=y, projectile=proj, entity=proj, name=(proj.getName and proj:getName()) or proj.name}
				end
			end
		end, nil)
	end
	return seen
end

_M.spotHostiles = spotHostiles

--- Try to auto use listed talents
-- This should be called in your actors "act()" method
function _M:automaticTalents()
	if self.no_automatic_talents then return end

	self:attr("_forbid_sounds", 1)
	local uses = {}
	for tid, c in pairs(self.talents_auto) do
		local t = self.talents_def[tid]
		local spotted = spotHostiles(self, true)
		local cd = self:getTalentCooldown(t) or (t.is_object_use and t.cycle_time(self, t)) or 0
		local turns_used = util.getval(t.no_energy, self, t) == true and 0 or 1
		if cd <= turns_used and t.mode ~= "sustained" then
			game.logPlayer(self, "Automatic use of talent %s #DARK_RED#skipped#LAST#: cooldown too low (%d).", self:getTalentDisplayName(t), cd)
		elseif (t.mode ~= "sustained" or not self.sustain_talents[tid]) and not self.talents_cd[tid] and self:preUseTalent(t, true, true) and (not t.auto_use_check or t.auto_use_check(self, t)) then
			if (c == 1) or (c == 2 and #spotted <= 0) or (c == 3 and #spotted > 0) then
				if c ~= 2 then
					uses[#uses+1] = {name=t.name, turns_used=turns_used, cd=cd, fct=function() self:useTalent(tid) end}
				else
					if not self:attr("blind") then
						uses[#uses+1] = {name=t.name, turns_used=turns_used, cd=cd, fct=function() self:useTalent(tid,nil,nil,nil,self) end}
					end
				end
			end
			if c == 4 and #spotted > 0 then
				for fid, foe in pairs(spotted) do
					if foe.x >= self.x-1 and foe.x <= self.x+1 and foe.y >= self.y-1 and foe.y <= self.y+1 then
						uses[#uses+1] = {name=t.name, turns_used=turns_used, cd=cd, fct=function() self:useTalent(tid) end}
					end
				end
			end
		end
	end
	table.sort(uses, function(a, b)
		local an, nb = a.turns_used, b.turns_used
		if an < nb then return true
		elseif an > nb then return false
		else
			if a.cd > b.cd then return true
			else return false
			end
		end
	end)
	for _, use in ipairs(uses) do
		use.fct()
		if use.turns_used > 0 then break end
	end
	self:attr("_forbid_sounds", -1)
end

--- We started resting
function _M:onRestStart()
	if self.resting and self:attr("equilibrium_regen_on_rest") and not self.resting.equilibrium_regen then
		self:attr("equilibrium_regen", self:attr("equilibrium_regen_on_rest"))
		self.resting.equilibrium_regen = self:attr("equilibrium_regen_on_rest")
	end
	if self.resting and self:attr("mana_regen_on_rest") and not self.resting.mana_regen then
		self:attr("mana_regen", self:attr("mana_regen_on_rest"))
		self.resting.mana_regen = self:attr("mana_regen_on_rest")
	end
	if self:knowTalent(self.T_SPACETIME_TUNING) then
		self:callTalent(self.T_SPACETIME_TUNING, "startTuning")
	end
	self:fireTalentCheck("callbackOnRest", "start")
end

--- We stopped resting
function _M:onRestStop()
	if self.resting and self.resting.equilibrium_regen then
		self:attr("equilibrium_regen", -self.resting.equilibrium_regen)
		self.resting.equilibrium_regen = nil
	end
	if self.resting and self.resting.mana_regen then
		self:attr("mana_regen", -self.resting.mana_regen)
		self.resting.mana_regen = nil
	end
	self:fireTalentCheck("callbackOnRest", "stop")
end

--- Can we continue resting ?
-- We can rest if no hostiles are in sight, and if we need life/mana/stamina/psi (and their regen rates allows them to fully regen)
function _M:restCheck()
	if game:hasDialogUp(1) then return false, "dialog is displayed" end

	local spotted = spotHostiles(self)
	if #spotted > 0 then
		for _, node in ipairs(spotted) do
			node.entity:addParticles(engine.Particles.new("notice_enemy", 1))
		end
		local dir = game.level.map:compassDirection(spotted[1].x - self.x, spotted[1].y - self.y)
		if dir == "northwest" then dir = "西北方向"
		elseif dir == "northeast" then dir = "东北方向"
		elseif dir == "southwest" then dir = "西南方向"
		elseif dir == "southeast" then dir = "东南方向"
		elseif dir == "east" then dir = "东面"
		elseif dir == "west" then dir = "西面"
		elseif dir == "south" then dir = "南面"
		elseif dir == "north" then dir = "北面"
		end
		return false, ("发现敌人位于 %s (%s%s)"):format(dir or "???", npcCHN:getName(spotted[1].name), game.level.map:isOnScreen(spotted[1].x, spotted[1].y) and "" or " - 位于屏幕外")
	end

	-- Resting improves regen
	for act, def in pairs(game.party.members) do if game.level:hasEntity(act) and not act.dead then
		local perc = math.min(self.resting.cnt / 10, 8)
		local old_shield = act.arcane_shield
		act.arcane_shield = nil
		act:heal(act.life_regen * perc)
		act.arcane_shield = old_shield
		act:incStamina(act.stamina_regen * perc)
		act:incMana(act.mana_regen * perc)
		act:incPsi(act.psi_regen * perc)
	end end

	-- Reload
	local ammo = self:hasAmmo()
	if ammo and ammo.combat.shots_left < ammo.combat.capacity then return true end
	-- Spacetime Tuning handles Paradox regen
	if self:hasEffect(self.EFF_SPACETIME_TUNING) then return true end
	if self:knowTalent(self.T_THROWING_KNIVES) then
		local eff = self:hasEffect(self.EFF_THROWING_KNIVES)
		if not eff or (eff and eff.stacks < eff.max_stacks) then return true end
	end
	
	-- Check resources, make sure they CAN go up, otherwise we will never stop
	if not self.resting.rest_turns then
		if self.air_regen < 0 then return false, "窒息！" end
		if self.life_regen <= 0 then return false, "生命值下降！" end

		if self.life < self.max_life and self.life_regen > 0 and not self:attr("no_life_regen") then return true end
		if self.air < self.max_air and self.air_regen > 0 and not self.is_suffocating then return true end
		for act, def in pairs(game.party.members) do if game.level:hasEntity(act) and not act.dead then
			if act.life < act.max_life and act.life_regen > 0 and not act:attr("no_life_regen") then return true end
		end end
		if ammo and ammo.combat.shots_left < ammo.combat.capacity then return true end

		-- Check for resources
		for res, res_def in ipairs(_M.resources_def) do
			if res_def.wait_on_rest and res_def.regen_prop and self:attr(res_def.regen_prop) then
				if not res_def.invert_values then
					if self[res_def.regen_prop] > 0.0001 and self:check(res_def.getFunction) < self:check(res_def.getMaxFunction) then return true end
				else
					if self[res_def.regen_prop] < -0.0001 and self:check(res_def.getFunction) > self:check(res_def.getMinFunction) then return true end
				end
			end
		end

		-- Check for detrimental effects
		for id, _ in pairs(self.tmp) do
			local def = self.tempeffect_def[id]
			if def.type ~= "other" and def.status == "detrimental" and (def.decrease or 1) > 0 then
				return true
			end
		end

		if self:fireTalentCheck("callbackOnRest", "check") then return true end
	else
		return true
	end

	-- Enter cooldown waiting rest if we are at max already
	if self.resting.cnt == 0 then
		self.resting.wait_cooldowns = true
	end

	if self.resting.wait_cooldowns then
		for tid, cd in pairs(self.talents_cd) do
--			if self:isTalentActive(self.T_CONDUIT) and (tid == self.T_KINETIC_AURA or tid == self.T_CHARGED_AURA or tid == self.T_THERMAL_AURA) then
				-- nothing
--			else
			if self.talents_auto[tid] then
				-- nothing
			else
				if cd > 0 then return true end
			end
		end
		for tid, sus in pairs(self.talents) do
			local p = self:isTalentActive(tid)
			if p and p.rest_count and p.rest_count > 0 then return true end
		end
		for inven_id, inven in pairs(self.inven) do
			for _, o in ipairs(inven) do
				local cd = o:getObjectCooldown(self)
				if cd and cd > 0 then return true end
			end
		end
	end

	self.resting.wait_cooldowns = nil


	-- Enter recall waiting rest if we are at max already
	if self.resting.cnt == 0 and self:hasEffect(self.EFF_RECALL) then
		self.resting.wait_recall = true
	end

	if self.resting.wait_recall then
		if self:hasEffect(self.EFF_RECALL) then
			return true
		end
	end

	self.resting.wait_recall = nil

	-- Enter full recharge rest if we waited for cooldowns already
	if self.resting.cnt == 0 then
		self.resting.wait_powers = true
	end

	if self.resting.wait_powers then
		for inven_id, inven in pairs(self.inven) do
			for _, o in ipairs(inven) do
				if o.power and o.power_regen and o.power_regen > 0 and o.power < o.max_power then
					return true
				end
			end
		end
	end

	self.resting.wait_powers = nil

	self.resting.rested_fully = true

	return false, "所有能量及生命值均已恢复满"
end

--- Can we continue running?
-- We can run if no hostiles are in sight, and if no interesting terrain or characters are next to us.
-- Known traps aren't interesting.  We let the engine run around traps, or stop if it can't.
-- 'ignore_memory' is only used when checking for paths around traps.  This ensures we don't remember items "obj_seen" that we aren't supposed to
function _M:runCheck(ignore_memory)
	if game:hasDialogUp(1) then return false, "dialog is displayed" end
	local is_main_player = self == game:getPlayer(true)

	local spotted = spotHostiles(self)
	if #spotted > 0 then
		local dir = game.level.map:compassDirection(spotted[1].x - self.x, spotted[1].y - self.y)
		if dir == "northwest" then dir = "西北方向"
		elseif dir == "northeast" then dir = "东北方向"
		elseif dir == "southwest" then dir = "西南方向"
		elseif dir == "southeast" then dir = "东南方向"
		elseif dir == "east" then dir = "东面"
		elseif dir == "west" then dir = "西面"
		elseif dir == "south" then dir = "南面"
		elseif dir == "north" then dir = "北面"
		end
		return false, ("发现敌人位于 %s (%s%s)"):format(dir or "???", npcCHN:getName(spotted[1].name), game.level.map:isOnScreen(spotted[1].x, spotted[1].y) and "" or " - 位于屏幕外")
	end

	if self:fireTalentCheck("callbackOnRun") then return false, "talent prevented" end

	if self.air_regen < 0 and self.air < 0.75 * self.max_air then return false, "窒息！" end

	-- Notice any noticeable terrain
	local noticed = false
	self:runScan(function(x, y, what)
		-- Objects are always interesting, only on curent spot
		local obj_seen = game.level.map.attrs(x, y, "obj_seen")
		if what == "self" and obj_seen ~= self and obj_self ~= true then
			local obj = game.level.map:getObject(x, y, 1)
			if obj then
				if not ignore_memory then game.level.map.attrs(x, y, "obj_seen", true) end
				noticed = "发现物品"
				return false, noticed
			end
		end

		local grid = game.level.map(x, y, Map.TERRAIN)
		if grid and grid.special and not grid.autoexplore_ignore and not game.level.map.attrs(x, y, "autoexplore_ignore") and self.running and self.running.path then
			game.level.map.attrs(x, y, "autoexplore_ignore", true)
			noticed = "发现有趣的事"
			return false, noticed
		end

		-- Only notice interesting terrains, but allow auto-explore and A* to take us to the exit.  Auto-explore can also take us through "safe" doors
		if grid and grid.notice and not (grid.special and self.running and self.running.explore and not grid.block_move and (grid.autoexplore_ignore or game.level.map.attrs(x, y, "autoexplore_ignore")))
			and not (self.running and self.running.path and (game.level.map.attrs(x, y, "noticed")
				or (what ~= self and (self.running.explore and grid.door_opened                     -- safe door
				or #self.running.path == self.running.cnt and (self.running.explore == "exit"       -- auto-explore onto exit
				or not self.running.explore and grid.change_level))                                 -- A* onto exit
				or #self.running.path - self.running.cnt < 2 and (self.running.explore == "portal"  -- auto-explore onto portal
				or not self.running.explore and grid.orb_portal)                                    -- A* onto portal
				or self.running.cnt < 3 and grid.orb_portal and                                     -- path from portal
				game.level.map:checkEntity(self.running.path[1].x, self.running.path[1].y, Map.TERRAIN, "orb_portal"))))
		then
			if grid and grid.special then
				game.level.map.attrs(x, y, "autoexplore_ignore", true)
				noticed = "发现有趣的事"
			elseif self.running and self.running.explore and self.running.path and self.running.explore ~= "unseen" and self.running.cnt == #self.running.path + 1 then
				noticed = "at " .. self.running.explore
			else
				noticed = "发现有趣的地点"
			end
			-- let's only remember and ignore standard interesting terrain
			if not ignore_memory and (grid.change_level or grid.orb_portal or grid.escort_portal) then game.level.map.attrs(x, y, "noticed", true) end
			return false, noticed
		end
		if grid and grid.type and grid.type == "store" then noticed = "发现商店入口" ; return false, noticed end

		-- Only notice interesting characters
		local actor = game.level.map(x, y, Map.ACTOR)
		if actor and actor.can_talk then noticed = "发现有趣的NPC" ; return false, noticed end

		-- We let the engine take care of traps, but we should still notice "trap" stores.
		if game.level.map:checkAllEntities(x, y, "store") then noticed = "发现商店入口" ; return false, noticed end
	end)
	if noticed then return false, noticed end

	return engine.interface.PlayerRun.runCheck(self)
end

--- Move with the mouse
-- We just feed our spotHostile to the interface mouseMove
function _M:mouseMove(tmx, tmy, force_move)
	local astar_check = function(x, y)
		-- Dont do traps
		local trap = game.level.map(x, y, Map.TRAP)
		if trap and trap:knownBy(self) and trap:canTrigger(x, y, self, true) then return false end

		-- Dont go where you cant breath
		if not self:attr("no_breath") then
			local air_level, air_condition = game.level.map:checkEntity(x, y, Map.TERRAIN, "air_level"), game.level.map:checkEntity(x, y, Map.TERRAIN, "air_condition")
			if air_level then
				if not air_condition or not self.can_breath[air_condition] or self.can_breath[air_condition] <= 0 then
					return false
				end
			end
		end
		return true
	end
	return engine.interface.PlayerMouse.mouseMove(self, tmx, tmy, function() local spotted = spotHostiles(self) ; return #spotted > 0 end, {recheck=true, astar_check=astar_check}, force_move)
end

--- Called after running a step
function _M:runMoved()
	self:playerFOV()
	if self.running and self.running.explore then
		game.level.map:particleEmitter(self.x, self.y, 1, "dust_trail")
	end
end

--- Called after stopping running
function _M:runStopped()
	game.level.map.clean_fov = true
	self:playerFOV()
	local spotted = spotHostiles(self)
	if #spotted > 0 then
		for _, node in ipairs(spotted) do
			node.entity:addParticles(engine.Particles.new("notice_enemy", 1))
		end
	end

	-- if you stop at an object (such as on a trap), then mark it as seen
	local obj = game.level.map:getObject(x, y, 1)
	if obj then game.level.map.attrs(x, y, "obj_seen", true) end
end

--- Uses an hotkeyed talent
-- This requires the ActorTalents interface to use talents and a method player:playerUseItem(o, item, inven) to use inventory objects
function _M:activateHotkey(id)
	-- Visual feedback to show whcih key was pressed
	if config.settings.tome.visual_hotkeys and game.uiset.hotkeys_display and game.uiset.hotkeys_display.clics and game.uiset.hotkeys_display.clics[id] and self.hotkey[id] then
		local zone = game.uiset.hotkeys_display.clics[id]
		game.uiset:addParticle(
			game.uiset.hotkeys_display.display_x + zone[1] + zone[3] / 2, game.uiset.hotkeys_display.display_y + zone[2] + zone[4] / 2,
			"hotkey_feedback", {w=zone[3], h=zone[4]}
		)
	end

	return engine.interface.PlayerHotkeys.activateHotkey(self, id)
end

--- Activates a hotkey with a type "inventory"
function _M:hotkeyInventory(name)
	local find = function(name)
		local os = {}
		-- Sort invens, use worn first
		local invens = {}
		for inven_id, inven in pairs(self.inven) do
			invens[#invens+1] = {inven_id, inven}
		end
		table.sort(invens, function(a,b) return (a[2].worn and 1 or 0) > (b[2].worn and 1 or 0) end)
		for i = 1, #invens do
			local inven_id, inven = unpack(invens[i])
			local o, item = self:findInInventory(inven, name, {no_count=true, force_id=true, no_add_name=true})
			if o and item then os[#os+1] = {o, item, inven_id, inven} end
		end
		if #os == 0 then return end
		table.sort(os, function(a, b) return (a[4].use_speed or 1) < (b[4].use_speed or 1) end)
		return os[1][1], os[1][2], os[1][3]
	end

	local o, item, inven = find(name)
	if not o then
		Dialog:simplePopup("Item not found", "You do not have any "..name..".")
	else
		-- Wear it ??
		if o:wornInven() and not o.wielded and inven == self.INVEN_INVEN then
			if not o.use_no_wear then
				self:doWear(inven, item, o)
				return
			end
		end
		self:playerUseItem(o, item, inven)
	end
end

function _M:playerPickup()
	-- If 2 or more objects, display a pickup dialog, otherwise just picks up
	if game.level.map:getObject(self.x, self.y, 2) then
		local titleupdator = self:getEncumberTitleUpdator("Pickup")
		local d d = self:showPickupFloor(titleupdator(), nil, function(o, item)
			if self:attr("sleep") and not self:attr("lucid_dreamer") then
				game:delayedLogMessage(self, nil, "sleep pickup", "You cannot pick up items from the floor while asleep!")
				return
			end
			local o = self:pickupFloor(item, true)
			if o and type(o) == "table" then o.__new_pickup = true end
			self.changed = true
			d:updateTitle(titleupdator())
			d:used()
		end)
	else
		if self:attr("sleep") and not self:attr("lucid_dreamer") then
			return
		end
		local o = self:pickupFloor(1, true)
		if o and type(o) == "table" then
			self:useEnergy()
			o.__new_pickup = true
		end
		self.changed = true
	end
end

function _M:playerDrop()
	if self.no_inventory_access then return end
	local inven = self:getInven(self.INVEN_INVEN)
	local titleupdator = self:getEncumberTitleUpdator("Drop object")
	local d d = self:showInventory(titleupdator(), inven, nil, function(o, item)
		self:doDrop(inven, item, function() d:updateList() end)
		d:updateTitle(titleupdator())
		return true
	end)
end

function _M:playerWear()
	if self.no_inventory_access then return end
	local inven = self:getInven(self.INVEN_INVEN)
	local titleupdator = self:getEncumberTitleUpdator("Wield/wear object")
	local d d = self:showInventory(titleupdator(), inven, function(o)
		return o:wornInven() and self:getInven(o:wornInven()) and true or false
	end, function(o, item)
		self:doWear(inven, item, o)
		d:updateTitle(titleupdator())
		return true
	end)
end

function _M:playerTakeoff()
	if self.no_inventory_access then return end
	local titleupdator = self:getEncumberTitleUpdator("Take off object")
	local d d = self:showEquipment(titleupdator(), nil, function(o, inven, item)
		self:doTakeoff(inven, item, o)
		d:updateTitle(titleupdator())
		return true
	end)
end

function _M:playerUseItem(object, item, inven)
	if self.no_inventory_access then return end
	if not game.zone or game.zone.wilderness then game.logPlayer(self, "You cannot use items on the world map.") return end

	local use_fct = function(o, inven, item)
		if not o then return end
		local co = coroutine.create(function()
			self.changed = true

			-- Count magic devices
			if (o.power_source and o.power_source.arcane) and self:attr("forbid_arcane") then
				game.logPlayer(self, "Your antimagic disrupts %s.", o:getName{no_count=true, do_color=true})
				return true
			end

			local ret = o:use(self, nil, inven, item) or {}
			if not ret.used then return end
			if ret.id then
				o:identify(true)
			end
			if ret.destroy then
				if o.multicharge and o.multicharge > 1 then
					o.multicharge = o.multicharge - 1
				else
					local _, del = self:removeObject(self:getInven(inven), item)
					if del then
						game.log("You have no more %s.", o:getName{no_count=true, do_color=true})
					else
						game.log("You have %s.", o:getName{do_color=true})
					end
					self:sortInven(self:getInven(inven))
				end
				return true
			end
			self.changed = true
		end)
		local ok, ret = coroutine.resume(co)
		if not ok and ret then print(debug.traceback(co)) error(ret) end
		return true
	end

	if object and item then return use_fct(object, inven, item) end

	local titleupdator = self:getEncumberTitleUpdator("Use object")
	self:showEquipInven(titleupdator(),
		function(o)
			return o:canUseObject()
		end,
		use_fct
	)
end

--- Put objects with usable powers on cooldown when worn (apply only to party members)
function _M:cooldownWornObject(o)
	if not self.no_power_reset_on_wear then
		o:forAllStack(function(so)
			if so.power and so:attr("power_regen") then
				if self:attr("quick_equip_cooldown") then
					so.power = math.min(so.power, (so.max_power or 2) / self:attr("quick_equip_cooldown"))
				else
					so.power = 0
				end
			end
			if so.talent_cooldown and (not self:attr("quick_equip_cooldown") or self:attr("quick_equip_cooldown") > 1) then
				self.talents_cd[so.talent_cooldown] = math.max(self.talents_cd[so.talent_cooldown] or 0, math.min(4, math.floor((so.use_power or so.use_talent or {power=10}).power / 5)))
				if self:attr("quick_equip_cooldown") then
					self.talents_cd[so.talent_cooldown] = math.floor(self.talents_cd[so.talent_cooldown] / self:attr("quick_equip_cooldown"))
					if self.talents_cd[so.talent_cooldown] <= 0 then self.talents_cd[so.talent_cooldown] = nil end
				end
			end
		end)
	end
end

--- Call when an object is worn
-- This doesnt call the base interface onWear, it copies the code because we need some tricky stuff
function _M:onWear(o, slot, bypass_set)
	mod.class.Actor.onWear(self, o, slot, bypass_set)
	self:cooldownWornObject(o)
	if self.hotkey and o:canUseObject() and config.settings.tome.auto_hotkey_object and not o.no_auto_hotkey then
		local position
		local name = o:getName{no_count=true, force_id=true, no_add_name=true}

		if not self:isHotkeyBound("inventory", name) then
			self:addNewHotkey("inventory", name)
		end
	end

	if o.power_source and o.power_source.antimagic and not game.party:knownLore("nature-vs-magic") and self:attr("has_arcane_knowledge") then
		game.party:learnLore("nature-vs-magic")
	end

	-- Shimmer stuff
	local invendef = self:getInvenDef(slot)
	if invendef and invendef.infos and invendef.infos.shimmerable then
		world:unlockShimmer(o)
	end
end

--- Call when an object is added
function _M:onAddObject(o, inven_id, slot)
	mod.class.Actor.onAddObject(self, o, inven_id, slot)
	if self.hotkey and o:attr("auto_hotkey") and config.settings.tome.auto_hotkey_object then
		local position
		local name = o:getName{no_count=true, force_id=true, no_add_name=true}

		if self.player then
			if self == game:getPlayer(true) then
				position = self:findQuickHotkey("Player: Specific", "inventory", name)
				if not position then
					local global_hotkeys = engine.interface.PlayerHotkeys.quickhotkeys["Player: Global"]
					if global_hotkeys and global_hotkeys["inventory"] then position = global_hotkeys["inventory"][name] end
				end
			else
				position = self:findQuickHotkey(self.name, "inventory", name)
			end
		end

		if position and not self.hotkey[position] then
			self.hotkey[position] = {"inventory", name}
		else
			for i = 1, 12 * (self.nb_hotkey_pages or 5) do
				if not self.hotkey[i] then
					self.hotkey[i] = {"inventory", name}
					break
				end
			end
		end
	end
end

function _M:playerLevelup(on_finish, on_birth)
	local LevelupDialog = require "mod.dialogs.LevelupDialog"
	local ds = LevelupDialog.new(self, on_finish, on_birth)
	game:registerDialog(ds)
end

--- Use a portal with the orb of many ways
function _M:useOrbPortal(portal)
	if portal.special then portal:special(self) return end

	local spotted = spotHostiles(self, true)
	if #spotted > 0 then
		local dir = game.level.map:compassDirection(spotted[1].x - self.x, spotted[1].y - self.y)
		self:logCombat(spotted[1].actor, "You can not use the Orb with foes watching (#Target# to the %s%s)",dir, game.level.map:isOnScreen(spotted[1].x, spotted[1].y) and "" or " - offscreen")
		return
	end
	if portal.on_preuse then portal:on_preuse(self) end

	if portal.nothing then -- nothing
	elseif portal.teleport_level then
		local x, y = util.findFreeGrid(portal.teleport_level.x, portal.teleport_level.y, 2, true, {[Map.ACTOR]=true})
		if x and y then self:move(x, y, true) end
	else
		if portal.change_wilderness then
			if portal.change_wilderness.spot then
				game:onLevelLoad(portal.change_wilderness.level_name or (portal.change_zone.."-"..portal.change_level), function(zone, level, spot)
					local spot = level:pickSpot(spot)
					game.player.wild_x = spot and spot.x or 0
					game.player.wild_y = spot and spot.y or 0
				end, portal.change_wilderness.spot)
			else
				self.wild_x = portal.change_wilderness.x or 0
				self.wild_y = portal.change_wilderness.y or 0
			end
		end
		game:changeLevel(portal.change_level, portal.change_zone, {direct_switch=true})

		if portal.after_zone_teleport then
			self:move(portal.after_zone_teleport.x, portal.after_zone_teleport.y, true)
			for e, _ in pairs(game.party.members) do if e ~= self then
				local x, y = util.findFreeGrid(portal.after_zone_teleport.x, portal.after_zone_teleport.y, 10, true, {[Map.ACTOR]=true})
				if x then e:move(x, y, true) end
			end end
		end
	end

	if portal.message then game.logPlayer(self, portal.message) end
	if portal.on_use then portal:on_use(self) end
	self.energy.value = self.energy.value + game.energy_to_act
end

--- Use the orbs of command
function _M:useCommandOrb(o, x, y)
	x = x or self.x
	y = y or self.y
	local g = game.level.map(x, y, Map.TERRAIN)
	if not g then return end
	if not g.define_as or not o.define_as or o.define_as ~= g.define_as then
		game.logPlayer(self, "This does not seem to have any effect.")
		return
	end

	if g.orb_command then
		g.orb_command:special(self, g)
		if not g.orb_command.continue then return end
	end
	g.orbed = true

	game.logPlayer(self, "You use the %s on the pedestal. There is a distant 'clonk' sound.", o:getName{do_colour=true})
	self:grantQuest("orb-command")
	self:setQuestStatus("orb-command", engine.Quest.COMPLETED, o.define_as)

	if g.once_used_image and g.add_displays and g.add_displays[1] then
		g.add_displays[1].image = g.once_used_image
		g:removeAllMOs()
		game.level.map:updateMap(x, y)
	end
end

--- Notify of object pickup
function _M:on_pickup_object(o)
	if self:attr("auto_id") and o:getPowerRank() <= self.auto_id then
		o:identify(true)
	end
	if o.pickup_sound then game:playSound(o.pickup_sound) end
end

--- Tell us when we are targeted
function _M:on_targeted(act)
	if self:attr("invisible") or self:attr("stealth") then
		if self:canSee(act) and game.level.map.seens(act.x, act.y) then
			game.logPlayer(self, "#LIGHT_RED#%s briefly catches sight of you!", act.name:capitalize())
		else
			game.logPlayer(self, "#LIGHT_RED#Something briefly catches sight of you!")
		end
	end
end

------ Quest Events
local quest_popups = {}
local function tick_end_quests()
	local QuestPopup = require "mod.dialogs.QuestPopup"

	local list = {}
	for quest_id, status in pairs(quest_popups) do
		list[#list+1] = { id=quest_id, status=status }
	end
	quest_popups = {}
	table.sort(list, function(a, b) return a.status > b.status end)

	local lastd = nil
	for _, q in ipairs(list) do
		local quest = game.player:hasQuest(q.id)
		local d = QuestPopup.new(quest, q.status)
		if lastd then
			lastd.unload = function(self) game:registerDialog(d) end
		else
			game:registerDialog(d)
		end
		lastd = d
	end
end

function _M:questPopup(quest, status)
	if game and game.creating_player then return end
	if not quest_popups[quest.id] or quest_popups[quest.id] < status then
		quest_popups[quest.id] = status
		if not game:onTickEndGet("quest_popups") then game:onTickEnd(tick_end_quests, "quest_popups") end
	end
end

function _M:on_quest_grant(quest)
	game.logPlayer(game.player, "#LIGHT_GREEN#Accepted quest '%s'! #WHITE#(Press 'j' to see the quest log)", quest.name)
	if not config.settings.tome.quest_popup then game.bignews:saySimple(60, "#LIGHT_GREEN#Accepted quest '%s'!", quest.name)
	else self:questPopup(quest, -1) end
end

function _M:on_quest_status(quest, status, sub)
	if sub then
		game.logPlayer(game.player, "#LIGHT_GREEN#Quest '%s' status updated! #WHITE#(Press 'j' to see the quest log)", quest.name)
		if not config.settings.tome.quest_popup then game.bignews:saySimple(60, "#LIGHT_GREEN#Quest '%s' updated!", quest.name)
		else self:questPopup(quest, engine.Quest.PENDING) end
	elseif status == engine.Quest.COMPLETED then
		game.logPlayer(game.player, "#LIGHT_GREEN#Quest '%s' completed! #WHITE#(Press 'j' to see the quest log)", quest.name)
		if not config.settings.tome.quest_popup then game.bignews:saySimple(60, "#LIGHT_GREEN#Quest '%s' completed!", quest.name)
		else self:questPopup(quest, status) end
	elseif status == engine.Quest.DONE then
		game.logPlayer(game.player, "#LIGHT_GREEN#Quest '%s' is done! #WHITE#(Press 'j' to see the quest log)", quest.name)
		if not config.settings.tome.quest_popup then game.bignews:saySimple(60, "#LIGHT_GREEN#Quest '%s' done!", quest.name)
		else self:questPopup(quest, status) end
	elseif status == engine.Quest.FAILED then
		game.logPlayer(game.player, "#LIGHT_RED#Quest '%s' is failed! #WHITE#(Press 'j' to see the quest log)", quest.name)
		if not config.settings.tome.quest_popup then game.bignews:saySimple(60, "#LIGHT_RED#Quest '%s' failed!", quest.name)
		else self:questPopup(quest, status) end
	end
end

function _M:attackOrMoveDir(dir)
	local game_or_player = not config.settings.tome.actor_based_movement_mode and game or self
	local tmp = game_or_player.bump_attack_disabled

	game_or_player.bump_attack_disabled = false
	self:moveDir(dir)
	game_or_player.bump_attack_disabled = tmp
end

return _M