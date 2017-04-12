-- TE4 - T-Engine 4
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

--- Handles actors stats
-- @classmod engine.generator.interface.ActorTalents
module(..., package.seeall, class.make)

_M.talents_def = {}
_M.talents_types_def = {}

--- Defines actor talents
-- Static!
function _M:loadDefinition(file, env)
	env = env or setmetatable({
		DamageType = require("engine.DamageType"),
		Particles = require("engine.Particles"),
		Talents = self,
		Map = require("engine.Map"),
		MapEffect = require("engine.MapEffect"),
		newTalent = function(t) self:newTalent(t) end,
		newTalentType = function(t) self:newTalentType(t) end,
		registerTalentTranslation = function(t) self:registerTalentTranslation(t) end,
		load = function(f) self:loadDefinition(f, env) end
	}, {__index=getfenv(2)})
	local f, err = util.loadfilemods(file, env)
	if not f and err then error(err) end
	f()
end

--- Defines one talent type(group)
-- Static!
function _M:newTalentType(t)
	t.__ATOMIC = true
	assert(t.name, "no talent type name")
	assert(t.type, "no talent type type")
	
	-----------技能分类汉化
	if t_talent_type_name[t.name] then t.name = t_talent_type_name[t.name] end
	-----------END
	
	t.description = t.description or ""
	
	-----------技能分类描述汉化
	if t_talent_type_description[t.description] then t.description = t_talent_type_description[t.description] end
	-----------END
	
	t.points = t.points or 1
	t.talents = {}
	table.insert(self.talents_types_def, t)
	self.talents_types_def[t.type] = self.talents_types_def[t.type] or t
end

--- Defines one talent
-- Static!
function _M:newTalent(t)
	t.__ATOMIC = true
	assert(t.name, "no talent name")
	assert(t.type, "no or unknown talent type")
	if type(t.type) == "string" then t.type = {t.type, 1} end
	if not t.type[2] then t.type[2] = 1 end
	t.short_name = t.short_name or t.name	
	t.short_name = t.short_name:upper():gsub("[ ']", "_")
	t.mode = t.mode or "activated"
	t.points = t.points or 1
	assert(t.mode == "activated" or t.mode == "sustained" or t.mode == "passive", "wrong talent mode, requires either 'activated' or 'sustained'")
	assert(t.info, "no talent info")

	-- Can pass a string, make it into a function
	if type(t.info) == "string" then
		local infostr = t.info
		t.info = function() return infostr end
	end
	-- Remove line stat with tabs to be cleaner ..
	local info = t.info
	t.info = function(self, t) return info(self, t):gsub("\n\t+", "\n") end

	t.id = "T_"..t.short_name
	self.talents_def[t.id] = t
	assert(not self[t.id], "talent already exists with id T_"..t.short_name)
	self[t.id] = t.id
--	print("[TALENT]", t.name, t.short_name, t.id)

	-- Register in the type
	table.insert(self.talents_types_def[t.type[1]].talents, t)
end

--- Initialises stats with default values if needed
function _M:init(t)
	self.talents = t.talents or {}
	self.talents_types = t.talents_types or {}
	self.talents_types_mastery = self.talents_types_mastery  or {}
	self.talents_cd = self.talents_cd or {}
	self.sustain_talents = self.sustain_talents or {}
	self.talents_auto = self.talents_auto or {}
	self.talents_confirm_use = self.talents_confirm_use or {}
	self.talents_learn_vals = t.talents_learn_vals or {}
end

--- Resolve leveling talents
function _M:resolveLevelTalents()
	if not self.start_level or not self._levelup_talents then return end
	for tid, info in pairs(self._levelup_talents) do
		if not info.max or (self.talents[tid] or 0) < info.max then
			local last = info.last or self.start_level
			if self.level - last >= info.every then
				self:learnTalent(tid, true)
				info.last = self.level
			end
		end
	end
end

--- Make the actor use a talent
-- @param id talent ID
-- @param who talent user
-- @param force_level talent level(raw) override
-- @param ignore_cd do not affect or consider cooldown
-- @param force_target the target of the talent (override)
-- @param silent do not display messages about use
-- @param no_confirm  Never ask confirmation
-- @return the return value from the talent code if successful or false:
--	activated talents: value returned from the action function
--	sustainable talents: value returned from the activate function (if inactive, should be a table of parameters)
--		or value returned from the talent deactivate function (if active)
--  talent code should always return a non false/nil result if successful
function _M:useTalent(id, who, force_level, ignore_cd, force_target, silent, no_confirm)
	who = who or self
	local ab, ret = _M.talents_def[id]
	assert(ab, "trying to use talent "..tostring(id).." but it is not defined")

	self.talent_error = nil
	local cancel = false
	local co, success, err
	
	local msg, line

	if ab.mode == "activated" and ab.action then
		if self:isTalentCoolingDown(ab) and not ignore_cd then
			game.logPlayer(who, "%s is still on cooldown for %d turns.", ab.name:capitalize(), self.talents_cd[ab.id])
			return false
		end
		co = coroutine.create(function() -- coroutine to run activated talent code
			if cancel then
				success = false
				return false
			end
			
			if not self:preUseTalent(ab, silent) then return false end
			
			msg, line = game.logNewest()
			if not silent then self:logTalentMessage(ab) end
			
			local ok, ret, special = xpcall(function() return ab.action(who, ab) end, debug.traceback)
			self.__talent_running = nil
			if not ok then self:onTalentLuaError(ab, ret) error(ret) end

			if not ret and self._silent_talent_failure then -- remove messages generated by failed talent
				local msg, newline = game.logNewest()
				if newline ~= line then game.logRollback(line) end
			end

			if not self:postUseTalent(ab, ret, silent) then return false end

			-- Everything went ok? then start cooldown if any
			if not ignore_cd and (not special or not special.ignore_cd) then self:startTalentCooldown(ab) end
			return ret
		end)
	elseif ab.mode == "sustained" and ab.activate and ab.deactivate then
		if self:isTalentCoolingDown(ab) and not ignore_cd then
			game.logPlayer(who, "%s is still on cooldown for %d turns.", ab.name:capitalize(), self.talents_cd[ab.id])
			return false
		end
		co = coroutine.create(function() -- coroutine to run sustainable talent code
			if cancel then
				success = false
				return false
			end
			if not self:preUseTalent(ab, silent) then return false end
			msg, line = game.logNewest()
			if not silent then self:logTalentMessage(ab) end
			
			local ok, ret, special
			if not self.sustain_talents[id] then -- activating
				ok, ret, special = xpcall(function() return ab.activate(who, ab) end, debug.traceback)
				if not ok then self:onTalentLuaError(ab, ret) error(ret) end
				if ret == true then ret = {} end -- fix for badly coded talents
				if ret then ret.name = ret.name or ab.name end

				if not ret and self._silent_talent_failure then -- remove messages generated by failed talent
					local msg, newline = game.logNewest()
					if newline ~= line then game.logRollback(line) end
				end

				if not self:postUseTalent(ab, ret, silent) then return false end

				self.sustain_talents[id] = ret

				if ab.sustain_lists then
					local lists = ab.sustain_lists
					if 'table' ~= type(lists) then lists = {lists} end
					for _, list in ipairs(lists) do
						if 'table' == type(list) then
							list = table.getTable(self, unpack(list))
						else
							list = table.getTable(self, list)
						end
						table.insert(list, id)
					end
				end
			else -- deactivating
				if self.deactivating_sustain_talent == ab.id then return end

				local p = self.sustain_talents[id]
				if p and type(p) == "table" and p.__tmpvals then
					for i = 1, #p.__tmpvals do
						self:removeTemporaryValue(p.__tmpvals[i][1], p.__tmpvals[i][2])
					end
				end
				p.__tmpvals = nil
				if p and type(p) == "table" and p.__tmpparticles then
					for i = 1, #p.__tmpparticles do
						self:removeParticles(p.__tmpparticles[i])
					end
				end
				p.__tmpparticles = nil
				ok, ret, special = xpcall(function() return ab.deactivate(who, ab, p) end, debug.traceback)
				if not ok then self:onTalentLuaError(ab, ret) error(ret) end
				
				if not ret and self._silent_talent_failure then -- remove messages generated by failed talent
					local msg, newline = game.logNewest()
					if newline ~= line then game.logRollback(line) end
				end

				self.deactivating_sustain_talent = ab.id
				if not self:postUseTalent(ab, ret, silent) then self.deactivating_sustain_talent = nil return false end
				self.deactivating_sustain_talent = nil

				-- Everything went ok? then start cooldown if any
				if not ignore_cd then self:startTalentCooldown(ab) end
				self.sustain_talents[id] = nil

				if ab.sustain_lists then
					local lists = ab.sustain_lists
					if 'table' ~= type(lists) then lists = {lists} end
					for _, list in ipairs(lists) do
						if 'table' == type(list) then
							list = table.getTable(self, unpack(list))
						else
							list = table.getTable(self, list)
						end
						table.removeFromList(list, id)
					end
				end
			end
			return ret
		end)
	else
		print("[useTalent] Attempt to use non activated or sustainable talent: "..id.." :: "..ab.name.." :: "..ab.mode)
	end
	if co then -- talent is usable and has passed checks
		-- Stub some stuff
		local old_level, old_target, new_target = nil, nil, nil
		if force_level then old_level = who.talents[id] end
		if ab.mode == "activated" then
			if ab.onAIGetTarget and not who.player then old_target = rawget(who, "getTarget"); new_target = function() return ab.onAIGetTarget(self, ab) end end
			if force_target and not old_target then old_target = rawget(who, "getTarget"); new_target = function(a) return force_target.x, force_target.y, not force_target.__no_self and force_target end end
		end
		
		local co_wrapper = coroutine.create(function() -- coroutine for talent interface
			success = true
			local ok
			while success do
				if new_target then who.getTarget = new_target end
				if force_level then who.talents[id] = force_level end
				self.__talent_running = ab
				ok, ret = coroutine.resume(co) -- ret == error or return value from co
				success = success and ok
				if new_target then who.getTarget = old_target end
				if force_level then who.talents[id] = old_level end
				self.__talent_running = nil
				if ok and coroutine.status(co) == "dead" then -- coroutine terminated normally
					if success and not ret then -- talent failed
						print("[useTalent] TALENT FAILED:", ab.id, "for", self.name, self.uid, success)
					--game.log("#ORANGE# %s TALENT USE FAILED [%s (silent_failure:%s at (%s, %s)]", ab.id, self.name, self._silent_talent_failure, self.x, self.y) -- debugging
					end
					return ret
				end
				if ret then error(ret) end --propagate error
				coroutine.yield()
			end
		end)
		if not no_confirm and self:isTalentConfirmable(ab) then
			local abname = game:getGenericTextTiles(ab)..tostring(self:getTalentDisplayName(ab))
			require "engine.ui.Dialog":yesnoPopup("Talent Use Confirmation", ("Use %s?"):format(abname),
			function(quit)
				if quit ~= false then
					cancel = true
				end
				success, ret = coroutine.resume(co_wrapper)
				if not success and ret then -- talent code error
					self:onTalentLuaError(ab, ret)
					--print("useTalent:", debug.traceback(co_wrapper), '\n')
					error(ret)
				end
			end,
			"Cancel","Continue")
		else
			success, ret = coroutine.resume(co_wrapper) -- cancel checked in coroutine
		end
		-- Cleanup in case we coroutine'd out
		self.__talent_running = nil
		if not success and ret then -- talent code error
			self:onTalentLuaError(ab, ret)
			--print("useTalent:", debug.traceback(co_wrapper), '\n')
			error(ret)
		end
	end
	self.changed = true
	
	return ret -- return value from successfully used talent
end

--- Set true to remove game log messages generated by talents that started but did not complete
--	affects messages logged after preUseTalent check when action/activate/deactivate function returns nil or false
_M._silent_talent_failure = false

--- Get the talent use message, replacing some markers in its message string with info on the talent
function _M:useTalentMessage(ab)
	if not ab.message then return nil end
	local str = util.getval(ab.message, self, ab)
	local _, _, target = self:getTarget()
	local tname = "unknown"
	if target then tname = target.name end
	local sname = "unknown"
	if str:find("@Source@") then
		sname = npcCHN:getName(self.name)
		str = str:gsub("@Source@","%%s")
	end
	if str:find("@source@") then
		sname = npcCHN:getName(self.name)
		str = str:gsub("@source@","%%s")
	end
	if str:find("@target@") then
		tname = npcCHN:getName(tname)
		str = str:gsub("@target@","%%s")
	end
	if str:find("@Target@") then
		tname = npcCHN:getName(tname)
		str = str:gsub("@Target@","%%s")
	end
	if str:find("@hisher@") then
		tname = npcCHN:getName(tname)
		str = str:gsub("@hisher@","%%s")
	end
	return str,sname,tname
end
--- Display the talent use message in the game log
-- Redefine as needed
-- called in useTalent after successful preUseTalent check
-- @param[type=table] talent the talent (not the id, the table)
-- uses ab.message if defined or generates default use text (ab.message == false suppresses)
function _M:logTalentMessage(ab)
	if ab.message == false then return
	elseif ab.message then
		game.logSeen(self, "%s", self:useTalentMessage(ab))
	elseif ab.mode == "sustained" then
		game.logSeen(self, "%s %s %s.", self.name:capitalize(), self:isTalentActive(ab.id) and "deactivates" or "activates", ab.name)
	else
		game.logSeen(self, "%s uses %s.", self.name:capitalize(), ab.name)
	end
end
--- Called BEFORE a talent is used -- CAN it be used?
-- Redefine as needed
-- @param[type=table] ab the talent (not the id, the table)
-- @param[type=boolean] silent no messages will be outputted
-- @param[type=boolean] fake no actions are taken, only checks
-- @return[1] true to continue
-- @return[2] false to stop
function _M:preUseTalent(ab, silent, fake)
	return true
end

--- Called AFTER a talent is used -- WAS it successfully used?
-- Redefine as needed
-- @param[type=table] ab the talent (not the id, the table)
-- @param ret the return of the talent action, activate, or deactivate function
-- @param[type=boolean] silent no messages will be outputted
-- @return[1] true to continue
-- @return[2] false to stop
function _M:postUseTalent(ab, ret, silent)
	return true
end

--- Called if a talent errors out when used
-- Redefine as needed
-- @param ab the talent table
-- @param err the table of errors returned from xpcall
-- sets self.talent_error and logs errors to _M._talent_errors
-- 		data forma: {[ab.id]=ab, Actor=self, uid=, x=, y=, err=err, turn=game.turn}
function _M:onTalentLuaError(ab, err)
	if self.talent_error then return end -- handle only the first error
	self.talent_error = {[ab.id]=ab, Actor=self, uid=self.uid, name=self.name, err=err, x=self.x, y=self.y, turn=game.turn}
	print("##Use Talent Lua Error##", ab and ab.id, "Actor:", self.uid, self.name)
	_M._talent_errors = _M._talent_errors or {} -- log the error globally
	table.insert(_M._talent_errors, self.talent_error)
	return
end

--- Force a talent to activate without using energy or such  
-- "def" can have a field "ignore_energy" to not consume energy; other parameters can be passed and handled by an overload of this method.  
-- Object activation interface calls this method with an "ignore_ressources" parameter
function _M:forceUseTalent(t, def)
	local oldpause = game.paused
	local oldenergy = self.energy.value
	if def.ignore_energy then self.energy.value = 10000 end

	if def.ignore_ressources then self:attr("force_talent_ignore_ressources", 1) end
	local ret = {self:useTalent(t, def.force_who, def.force_level, def.ignore_cd or def.ignore_cooldown, def.force_target, def.silent, true)}
	if def.ignore_ressources then self:attr("force_talent_ignore_ressources", -1) end

	if def.ignore_energy then
		game.paused = oldpause
		self.energy.value = oldenergy
	end
	return unpack(ret)
end

--- Is the sustained talent activated ?
function _M:isTalentActive(t_id)
	return self.sustain_talents[t_id]
end

--- Returns how many talents of this type the actor knows
-- @param type the talent type to count
-- @param exclude_id if not nil the count will ignore this talent id
-- @param limit_type if not nil the count will ignore talents with talent category level equal or higher that this
function _M:numberKnownTalent(type, exclude_id, limit_type)
	local nb = 0
	for id, _ in pairs(self.talents) do
		local t = _M.talents_def[id]
		if t.type[1] == type and (not exclude_id or exclude_id ~= id) and (not limit_type or not t.type[2] or t.type[2] < limit_type) then nb = nb + 1 end
	end
	return nb
end

--- Actor learns a talent
-- @param t_id the id of the talent to learn
-- @param force if true do not check canLearnTalent
-- @param nb the amount to increase the raw talent level by, default 1
-- @return[1] nil if failed
-- @return[1] an error message
-- @return[2] true if the talent was learned
function _M:learnTalent(t_id, force, nb)
--	print("[TALENT]", self.name, self.uid, "learning", t_id, force, nb)
	local t = _M.talents_def[t_id]
	assert(t, "Learning unknown talent: "..tostring(t_id))

	if not force then
		local ok, err = self:canLearnTalent(t)
		if not ok and err then return nil, err end
	end

	if not self.talents[t_id] then
		-- Auto assign to hotkey
		if t.mode ~= "passive" and not t.no_auto_hotkey and self.hotkey then
			local position

			if self.player then
				if self == game:getPlayer(true) then
					position = self:findQuickHotkey("Player: Specific", "talent", t_id)
					if not position then
						local global_hotkeys = engine.interface.PlayerHotkeys.quickhotkeys["Player: Global"]
						if global_hotkeys and global_hotkeys["talent"] then position = global_hotkeys["talent"][t_id] end
					end
				else
					position = self:findQuickHotkey(self.name, "talent", t_id)
				end
			end

			if position and not self.hotkey[position] then
				self.hotkey[position] = {"talent", t_id}
			else
				for i = 1, 12 * (self.nb_hotkey_pages or 5) do
					if not self.hotkey[i] then
						self.hotkey[i] = {"talent", t_id}
						break
					end
				end
			end
		end

		if t.learn_lists then
			local lists = t.learn_lists
			if 'table' ~= type(lists) then lists = {lists} end
			for _, list in ipairs(lists) do
				if 'table' == type(list) then
					list = table.getTable(self, unpack(list))
				else
					list = table.getTable(self, list)
				end
				table.insert(list, t.id)
			end
		end
	end

	for i = 1, (nb or 1) do
		self.talents[t_id] = (self.talents[t_id] or 0) + 1
		if t.on_learn then
			local ret = t.on_learn(self, t)
			if ret then
				if ret == true then ret = {} end
				self.talents_learn_vals[t.id] = self.talents_learn_vals[t.id] or {}
				self.talents_learn_vals[t.id][self.talents[t_id]] = ret
			end
		end
	end

	if t.passives then
		self.talents_learn_vals[t.id] = self.talents_learn_vals[t.id] or {}
		local p = self.talents_learn_vals[t.id]

		if p.__tmpvals then for i = 1, #p.__tmpvals do
			self:removeTemporaryValue(p.__tmpvals[i][1], p.__tmpvals[i][2])
		end end
		self.talents_learn_vals[t.id] = {}

		t.passives(self, t, self.talents_learn_vals[t.id])
	end

	self.changed = true
	return true
end

--- Actor forgets a talent completely
-- @param t_id the id of the talent to learn
-- @return[1] nil if failed
-- @return[1] an error message
-- @return[2] true if the talent was unlearned
function _M:unlearnTalentFull(t_id)
	local lvl = self:getTalentLevelRaw(t_id)
	if lvl > 0 then self:unlearnTalent(t_id, lvl) end
end

--- Actor forgets a talent
-- @param t_id the id of the talent to learn
-- @param nb
-- @return true if the talent was unlearnt, nil and an error message otherwise
function _M:unlearnTalent(t_id, nb)
	if not self:knowTalent(t_id) then return false, "talent not known" end

	local t = _M.talents_def[t_id]

	nb = math.min(nb or 1, self.talents[t_id])

	for j = 1, nb do
		if self.talents[t_id] and self.talents[t_id] == 1 then
			if self.hotkey then
				for i, known_t_id in pairs(self.hotkey) do
					if known_t_id[1] == "talent" and known_t_id[2] == t_id then self.hotkey[i] = nil end
				end
			end
		end

		self.talents[t_id] = self.talents[t_id] - 1
		if self.talents[t_id] == 0 then self.talents[t_id] = nil end

		if t.on_unlearn then
			local p = nil
			if self.talents_learn_vals[t.id] and self.talents_learn_vals[t.id][(self.talents[t_id] or 0) + 1] then
				p = self.talents_learn_vals[t.id][(self.talents[t_id] or 0) + 1]
				if p.__tmpvals then
					for i = 1, #p.__tmpvals do
						self:removeTemporaryValue(p.__tmpvals[i][1], p.__tmpvals[i][2])
					end
				end
			end
			t.on_unlearn(self, t, p)
		end
	end

	if t.passives then
		self.talents_learn_vals[t.id] = self.talents_learn_vals[t.id] or {}
		local p = self.talents_learn_vals[t.id]

		if p.__tmpvals then for i = 1, #p.__tmpvals do
			self:removeTemporaryValue(p.__tmpvals[i][1], p.__tmpvals[i][2])
		end end

		if self:knowTalent(t_id) then
			self.talents_learn_vals[t.id] = {}
			t.passives(self, t, self.talents_learn_vals[t.id])
		else
			self.talents_learn_vals[t.id] = nil
		end
	end

	if t.learn_lists and not self:knowTalent(t_id) then
		local lists = t.learn_lists
		if 'table' ~= type(lists) then lists = {lists} end
		for _, list in ipairs(lists) do
			if 'table' == type(list) then
				list = table.getTable(self, unpack(list))
			else
				list = table.getTable(self, list)
			end
			table.removeFromList(list, t.id)
		end
	end

	if self.talents[t_id] == nil then self.talents_auto[t_id] = nil end

	self.changed = true
	return true
end

--- Force passives update
function _M:updateTalentPassives(tid)
	if not self:knowTalent(tid) then return end

	local t = self:getTalentFromId(tid)
	if not t.passives then return end

	self.talents_learn_vals[t.id] = self.talents_learn_vals[t.id] or {}
	local p = self.talents_learn_vals[t.id]

	if p.__tmpvals then for i = 1, #p.__tmpvals do
		self:removeTemporaryValue(p.__tmpvals[i][1], p.__tmpvals[i][2])
	end end

	self.talents_learn_vals[t.id] = {}
	t.passives(self, t, self.talents_learn_vals[t.id])
end

--- Checks if the talent can be learned
-- @param t the talent to check
-- @param offset the level offset to check, defaults to 1
-- @param ignore_special ignore requirement of special
function _M:canLearnTalent(t, offset, ignore_special)
	-- Check prerequisites
	if rawget(t, "require") then
		local req = t.require
		if type(req) == "function" then req = req(self, t) end
		local tlev = self:getTalentLevelRaw(t) + (offset or 1)

		-- Obviously this requires the ActorStats interface
		if req.stat then
			for s, v in pairs(req.stat) do
				v = util.getval(v, tlev)
				if self:getStat(s) < v then return nil, "not enough stat: "..s:upper() end
			end
		end
		if req.level then
			if self.level < util.getval(req.level, tlev) then
				return nil, "not enough levels"
			end
		end
		if req.special and not ignore_special then
			if not req.special.fct(self, t, offset) then
				return nil, req.special.desc
			end
		end
		if req.talent then
			for _, tid in ipairs(req.talent) do
				if type(tid) == "table" then
					if type(tid[2]) == "boolean" and tid[2] == false then
						if self:knowTalent(tid[1]) then return nil, "missing dependency" end
					else
						if self:getTalentLevelRaw(tid[1]) < tid[2] then return nil, "missing dependency" end
					end
				else
					if not self:knowTalent(tid) then return nil, "missing dependency" end
				end
			end
		end
	end

	if not self:knowTalentType(t.type[1]) and not t.type_no_req then return nil, "unknown talent type" end

	-- Check talent type
	local known = self:numberKnownTalent(t.type[1], t.id, t.type[2])
	if t.type[2] and known < t.type[2] - 1 then
		return nil, "not enough talents of this type known"
	end

	-- Ok!
	return true
end

--- Formats the requirements as a (multiline) string
-- @param t_id the id of the talent to desc
-- @param levmod a number (1 should be the smartest) to add to current talent level to display requirements, defaults to 0
function _M:getTalentReqDesc(t_id, levmod)
	local t = _M.talents_def[t_id]
	local req = t.require
	if not req then return "" end
	if type(req) == "function" then req = req(self, t) end

	local tlev = self:getTalentLevelRaw(t_id) + (levmod or 0)

	local str = tstring{}

	if not t.type_no_req then
		str:add((self:knowTalentType(t.type[1]) and {"color", 0x00,0xff,0x00} or {"color", 0xff,0x00,0x00}), "- 技能树已学会", true)
	end

	if t.type[2] and t.type[2] > 1 then
		local known = self:numberKnownTalent(t.type[1], t.id, t.type[2])
		local c = (known >= t.type[2] - 1) and {"color", 0x00,0xff,0x00} or {"color", 0xff,0x00,0x00}
		str:add(c, ("- 技能树中已学技能数： %d"):format(t.type[2] - 1), true)
	end

	-- Obviously this requires the ActorStats interface
	if req.stat then
		for s, v in pairs(req.stat) do
			v = util.getval(v, tlev)
			local c = (self:getStat(s) >= v) and {"color", 0x00,0xff,0x00} or {"color", 0xff,0x00,0x00}
			str:add(c, ("- %s %d"):format(s_stat_name[self.stats_def[s].name] or self.stats_def[s].name, v), true)
		end
	end
	if req.level then
		local v = util.getval(req.level, tlev)
		local c = (self.level >= v) and {"color", 0x00,0xff,0x00} or {"color", 0xff,0x00,0x00}
		str:add(c, ("- 等级 %d"):format(v), true)
	end
	if req.special then
		local c = (req.special.fct(self, t, offset)) and {"color", 0x00,0xff,0x00} or {"color", 0xff,0x00,0x00}
		str:add(c, ("- %s"):format(req.special.desc), true)
	end
	if req.talent then
		for _, tid in ipairs(req.talent) do
			if type(tid) == "table" then
				if type(tid[2]) == "boolean" and tid[2] == false then
					local c = (not self:knowTalent(tid[1])) and {"color", 0x00,0xff,0x00} or {"color", 0xff,0x00,0x00}
					str:add(c, ("- 技能 %s (未学习)\n"):format(self:getTalentFromId(tid[1]).name), true)
				else
					local c = (self:getTalentLevelRaw(tid[1]) >= tid[2]) and {"color", 0x00,0xff,0x00} or {"color", 0xff,0x00,0x00}
					str:add(c, ("- 技能 %s (%d)\n"):format(self:getTalentFromId(tid[1]).name, tid[2]), true)
				end
			else
				local c = self:knowTalent(tid) and {"color", 0x00,0xff,0x00} or {"color", 0xff,0x00,0x00}
				str:add(c, ("- 技能 %s\n"):format(self:getTalentFromId(tid).name), true)
			end
		end
	end

	return str
end

--- Return the full description of a talent
-- You may overload it to add more data (like power usage, ...)
function _M:getTalentFullDescription(t)
	return tstring{t.info(self, t), true}
end

--- Do we know this talent type
function _M:knowTalentType(name)
	return self.talents_types[name]
end

--- Do we know this talent
function _M:knowTalent(id)
	if type(id) == "table" then id = id.id end
	return (self:getTalentLevelRaw(id) > 0) and true or false
end

--- Talent level, 0 if not known
function _M:getTalentLevelRaw(id)
	if type(id) == "table" then id = id.id end
	return self.talents[id] or 0
end

--- Talent level, 0 if not known
-- Includes mastery (defaults to 1)
function _M:getTalentLevel(id)
	local t

	if type(id) == "table" then
		t, id = id, id.id
	else
		t = _M.talents_def[id]
	end
	return t and (self:getTalentLevelRaw(id)) * ((self.talents_types_mastery[t.type[1]] or 0) + 1) or 0
end

--- Talent type level, sum of all raw levels of talents inside
function _M:getTalentTypeLevelRaw(tt)
	local nb = 0
	for tid, lev in pairs(self.talents) do
		local t = self:getTalentFromId(tid)
		if t.type[1] == tt then nb = nb + lev end
	end
	return nb
end

--- Return talent type mastery
function _M:getTalentTypeMastery(tt)
	return (self.talents_types_mastery[tt] or 0) + 1
end

--- Return talent type mastery for this talent
function _M:getTalentMastery(t)
	local tt = t.type[1]
	return self:getTalentTypeMastery(tt)
end

--- Sets talent type mastery
function _M:setTalentTypeMastery(tt, v)
	-- "v - 1" because a mastery is expressed as x + 1, not x, so that 0 is the default value (thus getting 1)
	self.talents_types_mastery[tt] = v - 1

	self:updateTalentTypeMastery(tt)
end

--- Recompute things that need recomputing
function _M:updateTalentTypeMastery(tt)
	for i, t in pairs(self.talents_types_def[tt] and self.talents_types_def[tt].talents or {}) do
		if t.auto_relearn_passive or t.passives then
			local lvl = self:getTalentLevelRaw(t)
			if lvl > 0 then
				self:unlearnTalent(t.id, lvl)
				self:learnTalent(t.id, true, lvl)
			end
		end
	end
	if self.talents_types_def[tt] and self.talents_types_def[tt].on_mastery_change then
		self.talents_types_def[tt].on_mastery_change(self, self:getTalentTypeMastery(tt), tt)
	end
end

--- Return talent definition from id
function _M:getTalentFromId(id)
	if type(id) == "table" then return id end
	return _M.talents_def[id]
end

--- Return talent definition from id
function _M:getTalentTypeFrom(id)
	return _M.talents_types_def[id]
end

--- Actor learns a talent type
-- @param tt the id of the talent to learn
-- @param v value
-- @return[1] nil if failed
-- @return[1] an error message
-- @return[2] true if the talent was learned
function _M:learnTalentType(tt, v)
	if v == nil then v = true end
	if self.talents_types[tt] then return end
	self.talents_types[tt] = v
	self.talents_types_mastery[tt] = self.talents_types_mastery[tt] or 0
	self.changed = true
	return true
end

--- Actor forgets a talent type
-- @param tt the id of the talent to unlearn
-- @return[1] nil if failed
-- @return[1] an error message
-- @return[2] true if the talent was unlearned
function _M:unlearnTalentType(tt)
	self.talents_types[tt] = false
	self.changed = true
	return true
end

--- Gets a talent cooldown
-- @param t the talent to get cooldown
function _M:getTalentCooldown(t)
	if not t.cooldown then return end
	local cd = t.cooldown
	if type(cd) == "function" then cd = cd(self, t) end
	return cd
end

--- Starts a talent cooldown
-- @param t the talent to cooldown
-- @param v override the normal cooldown that that, nil to get the normal effect
function _M:startTalentCooldown(t, v)
	t = self:getTalentFromId(t)
	local cd = t.cooldown
	if v then cd = math.max(v, self.talents_cd[t.id] or 0) end
	if not cd then return end
	if type(cd) == "function" then cd = cd(self, t) end
	self.talents_cd[t.id] = cd
	self.changed = true
	if t.cooldownStart then t.cooldownStart(self, t) end
end

--- Alter the remanining cooldown of a talent
-- @param t the talent affect cooldown
-- @param v the value to add/remove to the cooldown
function _M:alterTalentCoolingdown(t, v)
	t = self:getTalentFromId(t)
	if not self.talents_cd[t.id] then return nil end
	self.talents_cd[t.id] = self.talents_cd[t.id] + v
	if self.talents_cd[t.id] <= 0 then self.talents_cd[t.id] = nil end
	return self.talents_cd[t.id]
end

--- Is talent in cooldown?
function _M:isTalentCoolingDown(t)
	t = self:getTalentFromId(t)
	if not t or not t.cooldown then return false end
	if self.talents_cd[t.id] and self.talents_cd[t.id] > 0 then return self.talents_cd[t.id] else return false end
end

--- Returns the range of a talent (defaults to 1)
function _M:getTalentRange(t)
	if not t.range then return 1 end
	if type(t.range) == "function" then return t.range(self, t) end
	return t.range
end

--- Returns the radius of a talent (defaults to 0)
function _M:getTalentRadius(t)
	if not t.radius then return 0 end
	if type(t.radius) == "function" then return t.radius(self, t) end
	return t.radius
end

--- Returns the target table for a talent
function _M:getTalentTarget(t)
	if type(t.target) == "function" then return t.target(self, t) end
	return t.target
end

-- Returns whether the talent needs a target or not
function _M:getTalentRequiresTarget(t)
	if type(t.requires_target) == "function" then return t.requires_target(self, t) end
	return t.requires_target
end

--- Returns the projectile speed of a talent
function _M:getTalentProjectileSpeed(t)
	if not t.proj_speed then return nil end
	if type(t.proj_speed) == "function" then return t.proj_speed(self, t) end
	return t.proj_speed
end

--- Returns display name
function _M:getTalentDisplayName(t)
	if not t.display_name then return t.name end
	if type(t.display_name) == "function" then return t.display_name(self, t) end
	return t.display_name
end

--- Cooldown all talents by one
-- This should be called in your actors "act()" method
function _M:cooldownTalents()
	for tid, c in pairs(self.talents_cd) do
		self.changed = true
		self.talents_cd[tid] = self.talents_cd[tid] - 1
		if self.talents_cd[tid] <= 0 then
			self.talents_cd[tid] = nil
			if self.onTalentCooledDown then self:onTalentCooledDown(tid) end
			local t = _M.talents_def[tid]
			if t and t.cooldownStop then t.cooldownStop(self, t) end
		end
	end
end

--- Setup the talent as autocast
function _M:setTalentAuto(tid, v)
	if type(tid) == "table" then tid = tid.id end
	if v then self.talents_auto[tid] = true
	else self.talents_auto[tid] = nil
	end
end

--- Setup the talent as autocast
function _M:isTalentAuto(tid)
	if type(tid) == "table" then tid = tid.id end
	return self.talents_auto[tid]
end

--- Try to auto use listed talents
-- This should be called in your actors "act()" method
function _M:automaticTalents()
	for tid, c in pairs(self.talents_auto) do
		local t = self.talents_def[tid]
		if not t.np_npc_use and (t.mode ~= "sustained" or not self.sustain_talents[tid]) and not self.talents_cd[tid] and self:preUseTalent(t, true, true) and (not t.auto_use_check or t.auto_use_check(self, t)) then
			self:useTalent(tid)
		end
	end
end

--- Set the talent confirmation
function _M:setTalentConfirmable(tid, v)
	if type(tid) == "table" then tid = tid.id end
	if v then self.talents_confirm_use[tid] = true
	else self.talents_confirm_use[tid] = nil
	end
end

--- Does the talent require confirmation to use?
function _M:isTalentConfirmable(tid)
	if type(tid) == "table" then tid = tid.id end
	if not self.talents_confirm_use then self.talents_confirm_use = {} end -- For compatibility with older versions, can be removed
	return self.player and self.talents_confirm_use[tid]
end

--- Show usage dialog
function _M:useTalents(add_cols)
	local d = require("engine.dialogs.UseTalents").new(self, add_cols)
	game:registerDialog(d)
end

--- Helper function to add temporary values and not have to remove them manualy
function _M:talentTemporaryValue(p, k, v)
	if not p.__tmpvals then p.__tmpvals = {} end
	p.__tmpvals[#p.__tmpvals+1] = {k, self:addTemporaryValue(k, v)}
end

--- Helper function to add temporary particles and not have to remove them manualy
function _M:talentParticles(p, ...)
	local Particles = require "engine.Particles"
	if not p.__tmpparticles then p.__tmpparticles = {} end
	for _, ps in ipairs{...} do
		p.__tmpparticles[#p.__tmpparticles+1] = self:addParticles(Particles.new(ps.type, 1, ps.args, ps.shader))
	end
end

--- Trigger a talent method
function _M:triggerTalent(tid, name, ...)
	if self:isTalentCoolingDown(tid) then return end

	local t = _M.talents_def[tid]
	name = name or "trigger"
	if t[name] then return t[name](self, t, ...) end
end

--- Trigger a talent method
function _M:callTalent(tid, name, ...)
	local t = _M.talents_def[tid]
	name = name or "trigger"
	if t[name] then return t[name](self, t, ...) 
	end
end

--- Trigger all talents matching
function _M:talentCallbackOn(on, ...)
	for tid, _ in pairs(self.sustain_talents) do
		local t = self:getTalentFromId(tid)
		if t and t[on] then
			self:callTalent(tid, on, ...)
		end
	end
end

local dialog_returns_list = setmetatable({}, {__mode="v"})
local dialog_returns = setmetatable({}, {__mode="k"})

--- Retrieve talent dialog data
function _M:talentDialogData()
	return dialog_returns_list, dialog_returns
end

--- Set the result for a talent dialog
function _M:talentDialogReturn(...)
	local d = dialog_returns_list[#dialog_returns_list]
	if not d then return end

	dialog_returns[d] = {...}
end

--- Get the dialog
function _M:talentDialogGet()
	return dialog_returns_list[#dialog_returns_list]
end

--- Show a dialog and wait for it to end in a talent
function _M:talentDialog(d)
	if not game:hasDialog(d) then game:registerDialog(d) end

	dialog_returns_list[#dialog_returns_list+1] = d

	local co = coroutine.running()
	d.unload = function(dialog)
		local ok, err = coroutine.resume(co, dialog_returns[d])
		if not ok and err then
			print(debug.traceback(co))
			self:onTalentLuaError(nil, err)
			error(err)
		end
	end
	local ret = coroutine.yield()

	dialog_returns[d] = nil
	table.removeFromList(dialog_returns_list, d)

	return unpack(ret or {})
end

--- Register talent translation descriptor from superload 
function _M:registerTalentTranslation(t)
	assert(t.id, "no talent id")
	assert(t.name, "no talent name")
	--assert(t.info, "no talent info")
	assert(self.talents_def[t.id], "talent id " .. t.id .. " undefineded")
	for k, v in pairs(t) do
		local old_talent = self.talents_def[t.id]
		while k:find("%.") do
			l, _ = k:find("%.")
			old_talent = old_talent[k:sub(1, l - 1)]
			k = k:sub(l + 1, k:len() )
		end
		if type(v)== "Table" then old_talent[k] = table.clone(v)
		else old_talent[k] = v
		end
	end
	if t.require_special_desc then
		self.talents_def[t.id].require.special.desc = t.require_special_desc
	end
	--[[
	self.talents_def[t.id].name = t.name
	self.talents_def[t.id].info = t.info
	
	if t.short_info then
		self.talents_def[t.id].short_info = t.short_info
	end
	if t.knivesInfo then
		self.talents_def[t.id].knivesInfo = t.knivesInfo
	end
	if t.action then 
		self.talents_def[t.id].action = t.action
	end
	if t.effectsDescription then
		self.talents_def[t.id].effectsDescription = t.effectsDescription
	end
	if t.extra_data then
		self.talents_def[t.id].extra_data = table.clone(t.extra_data)
	end
	]]
end
