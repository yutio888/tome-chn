-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2017 Nicolas Casalini
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
local UIContainer = require "engine.ui.UIContainer"
local TalentTrees = require "mod.dialogs.elements.TalentTrees"
local StatusBox = require "mod.dialogs.elements.StatusBox"
local Separator = require "engine.ui.Separator"
local Checkbox = require "engine.ui.Checkbox"
local Empty = require "engine.ui.Empty"
local DamageType = require "engine.DamageType"
local FontPackage = require "engine.FontPackage"

module(..., package.seeall, class.inherit(Dialog, mod.class.interface.TooltipsData))

local function backup(original)
	local bak = original:clone()
	bak.uid = original.uid -- Yes ...
	return bak
end

local function restore(dest, backup)
	local bx, by = dest.x, dest.y
	backup.replacedWith = false
	dest:replaceWith(backup)
	dest.replacedWith = nil
	dest.x, dest.y = bx, by
	dest.changed = true
	dest:removeAllMOs()
	if game.level and dest.x then game.level.map:updateMap(dest.x, dest.y) end
end

function _M:init(actor, on_finish, on_birth)
	self.on_birth = on_birth
	actor.is_dialog_talent_leveling = true
	actor.no_last_learnt_talents_cap = true
	self.actor = actor
	self.unused_stats = self.actor.unused_stats
	self.new_stats_changed = false
	self.new_talents_changed = false

	self.talents_changed = {}
	self.on_finish = on_finish
	self.running = true
	self.prev_stats = {}
	self.font_h = self.font:lineSkip()
	self.talents_learned = {}
	self.talent_types_learned = {}
	self.stats_increased = {}

	self.font = core.display.newFont(chn123_tome_font(), 12)
	self.font_h = self.font:lineSkip()

	self.actor.__hidden_talent_types = self.actor.__hidden_talent_types or {}
	self.actor.__increased_talent_types = self.actor.__increased_talent_types or {}

	actor.last_learnt_talents = actor.last_learnt_talents or { class={}, generic={} }
	self.actor_dup = backup(actor)
	if actor.alchemy_golem then self.golem_dup = backup(actor.alchemy_golem) end

	if actor.descriptor then
		for _, v in pairs(engine.Birther.birth_descriptor_def) do
			if v.type == "subclass" and v.name == actor.descriptor.subclass then self.desc_def = v break end
		end
	end

	Dialog.init(self, "Levelup: "..actor.name, game.w * 0.9, game.h * 0.9, game.w * 0.05, game.h * 0.05)
	if game.w * 0.9 >= 1000 then
		self.no_tooltip = true
	end

	self:generateList()

	self:loadUI(self:createDisplay())
	self:setupUI()

	self.key:addCommands{
		__TEXTINPUT = function(c)
			if self.focus_ui.ui.last_mz then
				if c == "+" and self.focus_ui and self.focus_ui.ui.onUse then
					self.focus_ui.ui:onUse(self.focus_ui.ui.last_mz.item, true)
				elseif c == "-" then
					self.focus_ui.ui:onUse(self.focus_ui.ui.last_mz.item, false)
				end
			end
		end,
	}
	self.key:addBinds{
		EXIT = function()
			local changed = #self.actor.last_learnt_talents.class ~= #self.actor_dup.last_learnt_talents.class or #self.actor.last_learnt_talents.generic ~= #self.actor_dup.last_learnt_talents.generic
			for i = 1, #self.actor.last_learnt_talents.class do if self.actor.last_learnt_talents.class[i] ~= self.actor_dup.last_learnt_talents.class[i] then changed = true end end
			for i = 1, #self.actor.last_learnt_talents.generic do if self.actor.last_learnt_talents.generic[i] ~= self.actor_dup.last_learnt_talents.generic[i] then changed = true end end

			if self.actor.unused_stats~=self.actor_dup.unused_stats or self.actor.unused_talents_types~=self.actor_dup.unused_talents_types or
			self.actor.unused_talents~=self.actor_dup.unused_talents or self.actor.unused_generics~=self.actor_dup.unused_generics or self.actor.unused_prodigies~=self.actor_dup.unused_prodigies or changed then
				self:yesnocancelPopup("Finish","Do you accept changes?", function(yes, cancel)
				if cancel then
					return nil
				else
					if yes then ok = self:finish() else ok = true self:cancel() end
				end
				if ok then
					game:unregisterDialog(self)
					self.actor_dup = {}
					if self.on_finish then self.on_finish() end
				end
				end)
			else
				game:unregisterDialog(self)
				self.actor_dup = {}
				if self.on_finish then self.on_finish() end
			end
		end,
	}
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

function _M:unload()
	self.actor.is_dialog_talent_leveling = nil
	self.actor.no_last_learnt_talents_cap = nil
	self.actor:capLastLearntTalents("class")
	self.actor:capLastLearntTalents("generic")
end

function _M:cancel()
	restore(self.actor, self.actor_dup)
	if self.golem_dup then restore(self.actor.alchemy_golem, self.golem_dup) end
end

function _M:getMaxTPoints(t)
	if t.points == 1 then return 1 end
	return t.points + math.max(0, math.floor((self.actor.level - 50) / 10)) + (self.actor.talents_inc_cap and self.actor.talents_inc_cap[t.id] or 0)
end

function _M:subtleMessage(title, message, color)
	if simplePopDlg and simplePopDlg[title] then
		title,message = simplePopDlg[title](message)
	end
	if not self.t_messages then return self:simplePopup(title, message) end
	return self.t_messages:setTextColor(message, color)
end

-- Some common colors
local subtleMessageErrorColor = {r=255, g=100, b=100}
local subtleMessageWarningColor = {r=255, g=255, b=80}
local subtleMessageOtherColor = {r=255, g=215, b=0}

function _M:finish()
	local ok, dep_miss = self:checkDeps(true, true)
	if not ok then
		self:simpleLongPopup("Impossible", "You cannot learn this talent(s): "..dep_miss, game.w * 0.4)
		return nil
	end

	local txt = "#LIGHT_BLUE#警告: 你改变了你的某些技能或属性。下列持续技能：\n %s 如果其中某些技能和你改变的属性点相关，你需要重新使用该技能来使新的属性生效。"
	local talents = ""
	local reset = {}
	for tid, act in pairs(self.actor.sustain_talents) do
		if act then
			local t = self.actor:getTalentFromId(tid)
			if t.no_sustain_autoreset and self.actor:knowTalent(tid) then
				talents = talents.."#GOLD# - "..t.name.."#LAST#\n"
			else
				reset[#reset+1] = tid
			end
		end
	end
	if talents ~= "" then
		game.logPlayer(self.actor, txt:format(talents))
	end
	self.actor.turn_procs.resetting_talents = true
	for i, tid in ipairs(reset) do
		self.actor:forceUseTalent(tid, {ignore_energy=true, ignore_cd=true, no_talent_fail=true})
		if self.actor:knowTalent(tid) then self.actor:forceUseTalent(tid, {ignore_energy=true, ignore_cd=true, no_talent_fail=true, talent_reuse=true}) end
	end
	self.actor.turn_procs.resetting_talents = nil
	-- Prodigies
	if self.on_finish_prodigies then
		for tid, ok in pairs(self.on_finish_prodigies) do if ok then self.actor:learnTalent(tid, true, nil, {no_unlearn=true}) end end
	end

	if not self.on_birth then
		for t_id, _ in pairs(self.talents_learned) do
			local t = self.actor:getTalentFromId(t_id)
			if not self.actor:isTalentCoolingDown(t) and not self.actor_dup:knowTalent(t_id) then self.actor:startTalentCooldown(t) end
		end
	end

	for t_id, _ in pairs(self.talents_learned) do
		local t = self.actor:getTalentFromId(t_id)
		if t.on_levelup_close then
			local lvl = self.actor:getTalentLevel(t_id)
			local lvl_raw = self.actor:getTalentLevelRaw(t_id)
			local old_lvl = self.actor_dup:getTalentLevel(t_id)
			local old_lvl_raw = self.actor_dup:getTalentLevelRaw(t_id)
			t.on_levelup_close(self.actor, t, lvl, old_lvl, lvl_raw, old_lvl_raw, true)
		end
	end

	if self.actor.player then
		if self.actor.descriptor and self.actor.descriptor.race == "Dwarf" then
			local count_nature, count_spell = 0, 0
			for tid, lev in pairs(self.actor.talents) do
				local t = self.actor:getTalentFromId(tid)
				if t and t.is_spell then count_spell = count_spell + lev end
				if t and t.is_nature then count_nature = count_nature + lev end
			end
			if count_nature >= 10 and count_spell >= 10 then
				game:setAllowedBuild("wilder_stone_warden", true)
			end
		end
	end
	return true
end

function _M:incStat(sid, v)
	if v == 1 then
		if self.actor.unused_stats <= 0 then
			self:subtleMessage("Not enough stat points", "You have no stat points left!", subtleMessageErrorColor)
			return
		end
		if self.actor:getStat(sid, nil, nil, true) >= self.actor.level * 1.4 + 20 then
			self:subtleMessage("Stat is at the maximum for your level", "You cannot increase this stat further until next level!", subtleMessageOtherColor)
			return
		end
		if self.actor:isStatMax(sid) or self.actor:getStat(sid, nil, nil, true) >= 60 + math.max(0, (self.actor.level - 50)) then
			self:subtleMessage("Stat is at the maximum", "You cannot increase this stat further!", subtleMessageWarningColor)
			return
		end
	else
		if self.actor_dup:getStat(sid, nil, nil, true) == self.actor:getStat(sid, nil, nil, true) then
			self:subtleMessage("Impossible", "You cannot take out more points!", subtleMessageErrorColor)
			return
		end
	end

	self.actor:incStat(sid, v)
	self.actor.unused_stats = self.actor.unused_stats - v

	self.stats_increased[sid] = (self.stats_increased[sid] or 0) + v
	self:updateTooltip()
end

function _M:computeDeps(t)
	local d = {}
	self.talents_deps[t.id] = d

	-- Check prerequisites
	if rawget(t, "require") then
		local req = t.require
		if type(req) == "function" then req = req(self.actor, t) end

		if req.talent then
			for _, tid in ipairs(req.talent) do
				if type(tid) == "table" then
					d[tid[1]] = true
--					print("Talent deps: ", t.id, "depends on", tid[1])
				else
					d[tid] = true
--					print("Talent deps: ", t.id, "depends on", tid)
				end
			end
		end
	end

	-- Check number of talents
	for id, nt in pairs(self.actor.talents_def) do
		if nt.type[1] == t.type[1] and not t.no_levelup_category_deps then
			d[id] = true
--			print("Talent deps: ", t.id, "same category as", id)
		end
	end
end

function _M:checkDeps(simple, ignore_special)
	local talents = ""
	local stats_ok = true

	local checked = {}

	local function check(t_id, force)
		if checked[t_id] then return end
		checked[t_id] = true

		local t = self.actor:getTalentFromId(t_id)
		local ok, reason = self.actor:canLearnTalent(t, 0, ignore_special)
		if not ok and (self.actor:knowTalent(t) or force) then talents = talents.."\n#GOLD##{bold}#    - "..t.name.."#{normal}##LAST#("..reason..")" end
		if reason == "not enough stat" then
			stats_ok = false
		end

		local dlist = self.talents_deps[t_id]
		if dlist and not simple then for dtid, _ in pairs(dlist) do check(dtid) end end
	end

	for t_id, _ in pairs(self.talents_changed) do check(t_id) end

	-- Prodigies
	if self.on_finish_prodigies then
		for tid, ok in pairs(self.on_finish_prodigies) do if ok then check(tid, true) end end
	end

	if talents ~="" then
		return false, talents, stats_ok
	else
		return true, "", stats_ok
	end
end

function _M:isUnlearnable(t, limit)
	if not self.actor.last_learnt_talents then return end
	if self.on_birth and self.actor:knowTalent(t.id) and not t.no_unlearn_last then return 1 end -- On birth we can reset any talents except a very few
	local list = self.actor.last_learnt_talents[t.generic and "generic" or "class"]
	local max = self.actor:lastLearntTalentsMax(t.generic and "generic" or "class")
	local min = 1
	if limit then min = math.max(1, #list - (max - 1)) end
	for i = #list, min, -1 do
		if list[i] == t.id then
			if not game.state.birth.force_town_respec or (game.level and game.level.data and game.level.data.allow_respec == "limited") then
				return i
			else
				return nil, i
			end
		end
	end
	return nil
end

function _M:learnTalent(t_id, v)
	self.talents_learned[t_id] = self.talents_learned[t_id] or 0
	local t = self.actor:getTalentFromId(t_id)
	local t_type, t_index = "class", "unused_talents"
	if t.generic then t_type, t_index = "generic", "unused_generics" end
	if v then
		if self.actor[t_index] < 1 then
			self:subtleMessage("Not enough "..t_type.." talent points", "You have no "..t_type.." talent points left!", subtleMessageErrorColor)
			return
		end
		if not self.actor:canLearnTalent(t) then
			self:subtleMessage("Cannot learn talent", "Prerequisites not met!", subtleMessageErrorColor)
			return
		end
		if self.actor:getTalentLevelRaw(t_id) >= self:getMaxTPoints(t) then
			self:subtleMessage("Already known", "You already fully know this talent!", subtleMessageWarningColor)
			return
		end
		self.actor:learnTalent(t_id, true)
		self.actor[t_index] = self.actor[t_index] - 1
		self.talents_changed[t_id] = true
		self.talents_learned[t_id] = self.talents_learned[t_id] + 1
		self.new_talents_changed = true
	else
		if not self.actor:knowTalent(t_id) then
			self:subtleMessage("Impossible", "You do not know this talent!", subtleMessageErrorColor)
			return
		end
		if not self:isUnlearnable(t, true) and self.actor_dup:getTalentLevelRaw(t_id) >= self.actor:getTalentLevelRaw(t_id) then
			local _, could = self:isUnlearnable(t, true)
			if could then
				self:subtleMessage("Impossible here", "你只能在#{bold}#城市#{normal}#里进行这项操作.", {r=200, g=200, b=255})
			else
				self:subtleMessage("Impossible", "You cannot unlearn this talent!", subtleMessageErrorColor)
			end
			return
		end
		self.actor:unlearnTalent(t_id, nil, true, {no_unlearn=true})
		self.talents_changed[t_id] = true
		local _, reason = self.actor:canLearnTalent(t, 0)
		local ok, dep_miss, stats_ok = self:checkDeps(nil, true)
		self.actor:learnTalent(t_id, true, nil, {no_unlearn=true})
		if ok or reason == "not enough stat" or not stats_ok then
			self.actor:unlearnTalent(t_id)
			self.actor[t_index] = self.actor[t_index] + 1
			self.talents_learned[t_id] = self.talents_learned[t_id] - 1
			self.new_talents_changed = true
		else
			self:simpleLongPopup("Impossible", "You cannot unlearn this talent because of talent(s): "..dep_miss, game.w * 0.4)
			return
		end
	end
	self:updateTooltip()
end

function _M:learnType(tt, v)
	self.talent_types_learned[tt] = self.talent_types_learned[tt] or {}
	if v then
		if self.actor:knowTalentType(tt) and self.actor.__increased_talent_types[tt] and self.actor.__increased_talent_types[tt] >= 1 then
			self:subtleMessage("Impossible", "You can only improve a category mastery once!", subtleMessageWarningColor)
			return
		end
		if self.actor.unused_talents_types <= 0 then
			self:subtleMessage("Not enough talent category points", "You have no category points left!", subtleMessageErrorColor)
			return
		end
		if not self.actor.talents_types_def[tt] or (self.actor.talents_types_def[tt].min_lev or 0) > self.actor.level then
			self:simplePopup("Too low level", ("This talent tree only provides talents starting at level %d. Learning it now would be useless."):format(self.actor.talents_types_def[tt].min_lev))
			return
		end
		if not self.actor:knowTalentType(tt) then
			self.actor:learnTalentType(tt)
			self.talent_types_learned[tt][1] = true
		else
			self.actor.__increased_talent_types[tt] = (self.actor.__increased_talent_types[tt] or 0) + 1
			self.actor:setTalentTypeMastery(tt, self.actor:getTalentTypeMastery(tt) + 0.2)
			self.talent_types_learned[tt][2] = true
		end
		self:triggerHook{"PlayerLevelup:addTalentType", actor=self.actor, tt=tt}
		self.actor.unused_talents_types = self.actor.unused_talents_types - 1
		self.new_talents_changed = true
	else
		if self.actor_dup:knowTalentType(tt) == true and self.actor:knowTalentType(tt) == true and (self.actor_dup.__increased_talent_types[tt] or 0) >= (self.actor.__increased_talent_types[tt] or 0) then
			self:subtleMessage("Impossible", "You cannot take out more points!", subtleMessageErrorColor)
			return
		end
		if self.actor_dup:knowTalentType(tt) == true and self.actor:knowTalentType(tt) == true and (self.actor.__increased_talent_types[tt] or 0) == 0 then
			self:subtleMessage("Impossible", "You cannot unlearn this category!", subtleMessageWarningColor)
			return
		end
		if not self.actor:knowTalentType(tt) then
			self:subtleMessage("Impossible", "You do not know this category!", subtleMessageErrorColor)
			return
		end

		if (self.actor.__increased_talent_types[tt] or 0) > 0 then
			self.actor.__increased_talent_types[tt] = (self.actor.__increased_talent_types[tt] or 0) - 1
			self.actor:setTalentTypeMastery(tt, self.actor:getTalentTypeMastery(tt) - 0.2)
			self.actor.unused_talents_types = self.actor.unused_talents_types + 1
			self.new_talents_changed = true
			self.talent_types_learned[tt][2] = nil
		else
			self.actor:unlearnTalentType(tt)
			local ok, dep_miss = self:checkDeps(nil, true)
			if ok then
				self.actor.unused_talents_types = self.actor.unused_talents_types + 1
				self.new_talents_changed = true
				self.talent_types_learned[tt][1] = nil
			else
				self:simpleLongPopup("Impossible", "You cannot unlearn this category because of: "..dep_miss, game.w * 0.4)
				self.actor:learnTalentType(tt)
				return
			end
		end
		self:triggerHook{"PlayerLevelup:subTalentType", actor=self.actor, tt=tt}
	end
	self:updateTooltip()
end

function _M:generateList()
	self.actor.__show_special_talents = self.actor.__show_special_talents or {}

	-- Makes up the list
	local ctree = {}
	local gtree = {}
	self.talents_deps = {}
	for i, tt in ipairs(self.actor.talents_types_def) do
		local ttknown = self.actor:knowTalentType(tt.type)
		if (ttknown or not self.actor.levelup_hide_unknown_catgories) and not tt.hide and not (self.actor.talents_types[tt.type] == nil) then
			local cat = tt.type:gsub("/.*", "")
			local isgeneric = self.actor.talents_types_def[tt.type].generic
			local tshown = (self.actor.__hidden_talent_types[tt.type] == nil and ttknown) or (self.actor.__hidden_talent_types[tt.type] ~= nil and not self.actor.__hidden_talent_types[tt.type])
			local node = {
				name=function(item) return tstring{{"font", "bold"}, (t_talent_cat[cat] or cat:capitalize()).." / "..tt.name:capitalize() ..(" (%s)"):format((isgeneric and "通用技能" or "职业技能")), {"font", "normal"}} end,
				rawname=function(item) return (t_talent_cat[cat] or cat:capitalize()).." / "..tt.name:capitalize() ..(" (%s, 技能等级 %.2f)"):format((isgeneric and "通用技能" or "职业技能"), self.actor:getTalentTypeMastery(item.type)) end,
				type=tt.type,
				color=function(item) return ((self.actor:knowTalentType(item.type) ~= self.actor_dup:knowTalentType(item.type)) or ((self.actor.__increased_talent_types[item.type] or 0) ~= (self.actor_dup.__increased_talent_types[item.type] or 0))) and {255, 215, 0} or self.actor:knowTalentType(item.type) and {0,200,0} or {175,175,175} end,
				shown = tshown,
				status = function(item) return self.actor:knowTalentType(item.type) and tstring{{"font", "bold"}, ((self.actor.__increased_talent_types[item.type] or 0) >=1) and {"color", 255, 215, 0} or {"color", 0x00, 0xFF, 0x00}, ("%.2f"):format(self.actor:getTalentTypeMastery(item.type)), {"font", "normal"}} or tstring{{"color",  0xFF, 0x00, 0x00}, "需解锁"} end,
				nodes = {},
				isgeneric = isgeneric and 0 or 1,
				order_id = i,
			}
			if isgeneric then gtree[#gtree+1] = node
			else ctree[#ctree+1] = node end

			local list = node.nodes

			-- Find all talents of this school
			for j, t in ipairs(tt.talents) do
				if not t.hide or self.actor.__show_special_talents[t.id] then
					self:computeDeps(t)
					local isgeneric = self.actor.talents_types_def[tt.type].generic

					-- Pregenenerate icon with the Tiles instance that allows images
					if t.display_entity then t.display_entity:getMapObjects(game.uiset.hotkeys_display_icons.tiles, {}, 1) end

					list[#list+1] = {
						__id=t.id,
						name=t.name:toTString(),
						rawname=t.name..(isgeneric and " （通用技能）" or " （职业技能）"),
						entity=t.display_entity,
						talent=t.id,
						break_line=t.levelup_screen_break_line,
						isgeneric=isgeneric and 0 or 1,
						_type=tt.type,
						do_shadow = function(item) if not self.actor:canLearnTalent(t) then return true else return false end end,
						color=function(item)
							if ((self.actor.talents[item.talent] or 0) ~= (self.actor_dup.talents[item.talent] or 0)) then return {255, 215, 0}
							elseif self:isUnlearnable(t, true) then return colors.simple(colors.LIGHT_BLUE)
							elseif self.actor:knowTalentType(item._type) then return {255,255,255}
							else return {175,175,175}
							end
						end,
					}
					list[#list].status = function(item)
						local t = self.actor:getTalentFromId(item.talent)
						local ttknown = self.actor:knowTalentType(item._type)
						if self.actor:getTalentLevelRaw(t.id) == self:getMaxTPoints(t) then
							return tstring{{"color", 0x00, 0xFF, 0x00}, self.actor:getTalentLevelRaw(t.id).."/"..self:getMaxTPoints(t)}
						else
							if not self.actor:canLearnTalent(t) then
								return tstring{(ttknown and {"color", 0xFF, 0x00, 0x00} or {"color", 0x80, 0x80, 0x80}), self.actor:getTalentLevelRaw(t.id).."/"..self:getMaxTPoints(t)}
							else
								return tstring{(ttknown and {"color", "WHITE"} or {"color", 0x80, 0x80, 0x80}), self.actor:getTalentLevelRaw(t.id).."/"..self:getMaxTPoints(t)}
							end
						end
					end
				end
			end
		end
	end
	table.sort(ctree, function(a, b)
		if self.actor:knowTalentType(a.type) and not self.actor:knowTalentType(b.type) then return 1
		elseif not self.actor:knowTalentType(a.type) and self.actor:knowTalentType(b.type) then return nil
		else return a.order_id < b.order_id end
	end)
	self.ctree = ctree
	table.sort(gtree, function(a, b)
		if self.actor:knowTalentType(a.type) and not self.actor:knowTalentType(b.type) then return 1
		elseif not self.actor:knowTalentType(a.type) and self.actor:knowTalentType(b.type) then return nil
		else return a.order_id < b.order_id end
	end)
	self.gtree = gtree

	-- Makes up the stats list
	local stats = {}
	self.tree_stats = stats

	for i, sid in ipairs{self.actor.STAT_STR, self.actor.STAT_DEX, self.actor.STAT_CON, self.actor.STAT_MAG, self.actor.STAT_WIL, self.actor.STAT_CUN } do
		local s = self.actor.stats_def[sid]
		local e = engine.Entity.new{image="stats/"..s.name:lower()..".png", is_stat=true}
		e:getMapObjects(game.uiset.hotkeys_display_icons.tiles, {}, 1)

		stats[#stats+1] = {shown=true, nodes={{
			name=s.name,
			rawname=s.name,
			entity=e,
			stat=sid,
			desc=s.description,
			color=function(item)
				if self.actor:getStat(sid, nil, nil, true) ~= self.actor_dup:getStat(sid, nil, nil, true) then return {255, 215, 0}
				elseif self.actor:getStat(sid, nil, nil, true) >= self.actor.level * 1.4 + 20 or
				   self.actor:isStatMax(sid) or
				   self.actor:getStat(sid, nil, nil, true) >= 60 + math.max(0, (self.actor.level - 50)) then
					return {0, 255, 0}
				else
					return {175,175,175}
				end
			end,
			status = function(item)
				if self.actor:getStat(sid, nil, nil, true) >= self.actor.level * 1.4 + 20 or
				   self.actor:isStatMax(sid) or
				   self.actor:getStat(sid, nil, nil, true) >= 60 + math.max(0, (self.actor.level - 50)) then
					return tstring{{"color", 175, 175, 175}, ("%d (%d)"):format(self.actor:getStat(sid), self.actor:getStat(sid, nil, nil, true))}
				else
					return tstring{{"color", 0x00, 0xFF, 0x00}, ("%d (%d)"):format(self.actor:getStat(sid), self.actor:getStat(sid, nil, nil, true))}
				end
			end,
		}}}
	end
end

-----------------------------------------------------------------
-- UI Stuff
-----------------------------------------------------------------

local _points_left = [[
属性点剩余： #00FF00#%d#LAST#
技能树解锁点剩余： #00FF00#%d#LAST#
职业技能点剩余： #00FF00#%d#LAST#
通用技能点剩余： #00FF00#%d#LAST#]]

local desc_stats = ([[属 性 点 可 以 提 高 你 的 基 础 属 性。 
人 物 等 级 每 升 一 级 可 以 获 得 3 点 自 由 分 配。 

每 项 属 性 基 础 值 上 限 为 60 点。 加 点 不 能 超 过 这 个 上 限， 另 外 属 性 上 限 也 受 你 的 人 物 等 级 限 制。]]):toTString()

local desc_class = ([[职 业 技 能 点 可 以 让 你 学 习 新 的 或 者 提 升 已 学 习 的 职 业 技 能。 职 业 技 能 是 你 所 选 择 职 业 的 核 心 技 能， 不 能 从 训 练 师 处 学 到。 

人 物 等 级 每 升 一 级 可 以 获 得 1 点 职 业 技 能 点。 此 外 每 5 级 可 以 额 外 获 得 1 点 职 业 技 能 点。
]]):toTString()

local desc_generic = ([[通 用 技 能 点 可 以 让 你 学 习 新 的 或 者 提 升 已 学 习 的 通 用 技 能。 
通 用 技 能 可 以 是 你 选 择 职 业 或 种 族 自 身 拥 有， 或 者 在 你 的 冒 险 生 涯 中 习 得。 

通 常 人 物 等 级 每 升 一 级 可 以 获 得 1 点 通 用 技 能 点。 
不 过 每 5 级 时 不 能 获 得。
]]):toTString()

local desc_types = ([[技 能 树 解 锁 点 有 以 下 作 用： 
- 解 锁 职 业 或 通 用 技 能 树 
- 提 升 一 个 技 能 树 所 有 技 能 等 级， 每 点 提 升 0.2
- 解 锁 新 的 纹 身 槽（ 最 多 5 个， 你 使 用 纹 身、 符 文 等 时 会 自 动 消 耗 点 数 解 锁） 

你 会 在 人 物 等 级 达 到 10、 20 和 36 级 时 各 获 得 1 个 点 数。 
某 些 种 族 和 物 品 可 以 获 得 额 外 的 点 数。]]):toTString()

local desc_prodigies = ([[觉 醒 技 是 角 色 足 够 强 大 时 才 能 获 得 的 特 殊 技 能。 
所 有 觉 醒 技 能 必 须 在 人 物 某 项 核 心 属 性 达 到 50 点 并 满 足 所 需 的 特 殊 要 求 后 才 能 习 得。 
你 可 以 在 人 物 等 级 达 到 30 级 和 42 级 时 各 获 得 一 个 觉 醒 技 能 点。]]):toTString()

local desc_inscriptions = ([[你 可 以 消 耗 1 个 技 能 树 解 锁 点 来 解 锁 一 个 新 的 纹 身 槽（ 最 多 5 个）。]]):toTString()

function _M:createDisplay()
	self.b_prodigies = Button.new{text="觉醒技", fct=function()
			self.on_finish_prodigies = self.on_finish_prodigies or {}
			local d = require("mod.dialogs.UberTalent").new(self.actor, self.on_finish_prodigies)
			game:registerDialog(d)
		end, on_select=function()
		local str = desc_prodigies
		if self.no_tooltip then
			self.c_desc:erase()
			self.c_desc:switchItem(str, str, true)
		else
			game:tooltipDisplayAtMap(self.b_stat.last_display_x + self.b_stat.w, self.b_stat.last_display_y, str)
		end
	end}

	if self.actor.inscriptions_slots_added < 2 then
		self.b_inscriptions = Button.new{text="纹身", fct=function()
				if self.actor.inscriptions_slots_added >= 2 then
					Dialog:simplePopup("Inscriptions", "You have learnt all the inscription slots you could.")
				else
					if self.actor.unused_talents_types > 0 then
						Dialog:yesnoPopup("Inscriptions", ("You can learn %d new slot(s). Do you wish to buy one with one category point?"):format(2 - self.actor.inscriptions_slots_added), function(ret) if ret then
							self.actor.unused_talents_types = self.actor.unused_talents_types - 1
							self.actor.max_inscriptions = self.actor.max_inscriptions + 1
							self.actor.inscriptions_slots_added = self.actor.inscriptions_slots_added + 1
							self.b_types.text = "Category points: "..self.actor.unused_talents_types
							self.b_types:generate()
						end end)
					else
						Dialog:simplePopup("Inscriptions", ("You can still learn %d new slot(s) but you need a category point."):format(2 - self.actor.inscriptions_slots_added))
					end
				end
			end, on_select=function()
			local str = desc_inscriptions
			if self.no_tooltip then
				self.c_desc:erase()
				self.c_desc:switchItem(str, str, true)
			else
				game:tooltipDisplayAtMap(self.b_stat.last_display_x + self.b_stat.w, self.b_stat.last_display_y, str)
			end
		end}
	end

	if self.actor.unused_prodigies > 0 then self.b_prodigies.glow = 0.6 end
	if self.actor.unused_talents_types > 0 and self.b_inscriptions then self.b_inscriptions.glow = 0.6 end

	local recreate_trees = function()
		self.c_ctree = TalentTrees.new{
			font = core.display.newFont(chn123_tome_font(), 14),
			tiles=game.uiset.hotkeys_display_icons,
			tree=self.ctree,
			width=320, height=self.ih-50,
			tooltip=function(item)
				local x = self.display_x + self.uis[5].x - game.tooltip.max
				if self.display_x + self.w + game.tooltip.max <= game.w then x = self.display_x + self.w end
				local ret = self:getTalentDesc(item), x, nil
				if self.no_tooltip then
					self.c_desc:erase()
					self.c_desc:switchItem(ret, ret)
				end
				return ret
			end,
			on_use = function(item, inc) self:onUseTalent(item, inc) end,
			on_expand = function(item) self.actor.__hidden_talent_types[item.type] = not item.shown end,
			scrollbar = true, no_tooltip = self.no_tooltip,
			message_box = self.t_
		}

		self.c_gtree = TalentTrees.new{
			font = core.display.newFont(chn123_tome_font(), 14),
			tiles=game.uiset.hotkeys_display_icons,
			tree=self.gtree,
			width=320, height=(self.no_tooltip and self.ih - 50) or self.ih-50 - math.max((not self.b_prodigies and 0 or self.b_prodigies.h + 5), (not self.b_inscriptions and 0 or self.b_inscriptions.h + 5)),
			tooltip=function(item)
				local x = self.display_x + self.uis[8].x - game.tooltip.max
				if self.display_x + self.w + game.tooltip.max <= game.w then x = self.display_x + self.w end
				local ret = self:getTalentDesc(item), x, nil
				if self.no_tooltip then
					self.c_desc:erase()
					self.c_desc:switchItem(ret, ret)
				end
				return ret
			end,
			on_use = function(item, inc) self:onUseTalent(item, inc) end,
			on_expand = function(item) self.actor.__hidden_talent_types[item.type] = not item.shown end,
			scrollbar = true, no_tooltip = self.no_tooltip,
		}
	end
	recreate_trees()

	self.c_stat = TalentTrees.new{
		font = core.display.newFont(chn123_tome_font(), 14),
		tiles=game.uiset.hotkeys_display_icons,
		tree=self.tree_stats, no_cross = true,
		width=50, height=self.ih,
		dont_select_top = true,
		tooltip=function(item)
			local x = self.display_x + self.uis[2].x + self.uis[2].ui.w
			if self.display_x + self.w + game.tooltip.max <= game.w then x = self.display_x + self.w end
			local ret = self:getStatDesc(item), x, nil
			if self.no_tooltip then
				self.c_desc:erase()
				self.c_desc:switchItem(ret, ret)
			end
			return ret
		end,
		on_use = function(item, inc) self:onUseTalent(item, inc) end,
		no_tooltip = self.no_tooltip,
	}

	self.b_stat = Button.new{can_focus = false, can_focus_mouse=true, text="属性点: "..self.actor.unused_stats, fct=function() end, on_select=function()
		local str = desc_stats
		if self.no_tooltip then
			self.c_desc:erase()
			self.c_desc:switchItem(str, str, true)
		elseif self.b_stat.last_display_x then
			game:tooltipDisplayAtMap(self.b_stat.last_display_x + self.b_stat.w, self.b_stat.last_display_y, str)
		end
	end}
	self.b_class = Button.new{can_focus = false, can_focus_mouse=true, text="职业技能点："..self.actor.unused_talents, fct=function() end, on_select=function()
		local str = desc_class
		if self.no_tooltip then
			self.c_desc:erase()
			self.c_desc:switchItem(str, str, true)
		elseif self.b_stat.last_display_x then
			game:tooltipDisplayAtMap(self.b_stat.last_display_x + self.b_stat.w, self.b_stat.last_display_y, str)
		end
	end}
	self.b_generic = Button.new{can_focus = false, can_focus_mouse=true, text="通用技能点："..self.actor.unused_generics, fct=function() end, on_select=function()
		local str = desc_generic
		if self.no_tooltip then
			self.c_desc:erase()
			self.c_desc:switchItem(str, str, true)
		elseif self.b_stat.last_display_x then
			game:tooltipDisplayAtMap(self.b_stat.last_display_x + self.b_stat.w, self.b_stat.last_display_y, str)
		end
	end}
	self.b_types = Button.new{can_focus = false, can_focus_mouse=true, text="技能树解锁点："..self.actor.unused_talents_types, fct=function() end, on_select=function()
		local str = desc_types
		if self.no_tooltip then
			self.c_desc:erase()
			self.c_desc:switchItem(str, str, true)
		elseif self.b_stat.last_display_x then
			game:tooltipDisplayAtMap(self.b_stat.last_display_x + self.b_stat.w, self.b_stat.last_display_y, str)
		end
	end}

	self.c_hide_unknown = Checkbox.new{title="隐藏未学习技能树", default=self.actor.levelup_hide_unknown_catgories, fct=function() end, on_change=function(s)
		self.actor.levelup_hide_unknown_catgories = s
		self:generateList()
		local oldctree, oldgtree = self.c_ctree, self.c_gtree
		recreate_trees()
		self:replaceUI(oldctree, self.c_ctree)
		self:replaceUI(oldgtree, self.c_gtree)
	end}

	self.t_messages = StatusBox.new{
		font = core.display.newFont("/data/font/DroidSans.ttf", 16),
		width = math.floor(2 * self.iw / 3), delay = 1,
	}
	local vsep1 = Separator.new{dir="horizontal", size=self.ih - self.b_stat.h - 10}
	local vsep2 = Separator.new{dir="horizontal", size=self.ih - self.b_stat.h - 10}
	local hsep = Separator.new{dir="vertical", size=180}
	local align_empty1 = Empty.new{width=0,height=10}
	local align_empty2 = Empty.new{width=0,height=0}


	local ret = {
		{left=-10, top=0, ui=self.b_stat},
		{left=0, top=self.b_stat, ui=align_empty1},
		{left=0, top=align_empty1, ui=self.c_stat},

		{left=self.c_stat, top=align_empty1, ui=vsep1},

		{left=vsep1, top=0, ui=self.b_class},
		{left=vsep1, top=align_empty1, ui=self.c_ctree},

		{left=self.c_ctree, top=align_empty1, ui=vsep2},

		{left=vsep2, top=align_empty1, ui=self.c_gtree},
		{left=self.c_gtree, top=0, ui=align_empty2},
		{right=align_empty2, top=0, ui=self.b_generic},

		{hcenter=vsep2, top=0, ui=self.b_types},

		{right=0, bottom=0, ui=self.b_prodigies},

		{hcenter=self.b_types, top=-self.t_messages.h, ui=self.t_messages},
	}
	if self.b_inscriptions then table.insert(ret, {right=self.b_prodigies.w, bottom=0, ui=self.b_inscriptions}) end
	table.insert(ret, {right=self.b_inscriptions or self.b_prodigies, bottom=0, ui=self.c_hide_unknown})

	if self.no_tooltip then
		local vsep3 = Separator.new{dir="horizontal", size=self.ih - self.b_stat.h - 10}
		-- will be recalculated
		self.c_desc = TextzoneList.new{ focus_check = true, scrollbar = true, pingpong=20, width=200, height = self.ih - (self.b_prodigies and self.b_prodigies.h + 5 or 0), dest_area = { h = self.ih - (self.b_prodigies and self.b_prodigies.h + 5 or 0) } }
		ret[#ret+1] = {left=self.c_gtree, top=align_empty1, ui=vsep3}
		ret[#ret+1] = {left=vsep3, right=0, top=0, ui=self.c_desc, calc_width=3}
	end

	return ret
end

function _M:getStatDesc(item)
	local stat_id = item.stat
	if not stat_id then return item.desc end
	local text = tstring{}
	text:merge(item.desc:toTString())
	text:add(true, true)
	local diff = self.actor:getStat(stat_id, nil, nil, true) - self.actor_dup:getStat(stat_id, nil, nil, true)
	local color = diff >= 0 and {"color", "LIGHT_GREEN"} or {"color", "RED"}
	local dc = {"color", "LAST"}

	text:add("当前值： ", {"color", "LIGHT_GREEN"}, ("%d"):format(self.actor:getStat(stat_id)), dc, true)
	text:add("基础值： ", {"color", "LIGHT_GREEN"}, ("%d"):format(self.actor:getStat(stat_id, nil, nil, true)), dc, true, true)

	text:add({"color", "LIGHT_BLUE"}, "属性加成:", dc, true)
	if stat_id == self.actor.STAT_CON then
		local multi_life = 4 + (self.actor.inc_resource_multi.life or 0)
		text:add("生命值上限： ", color, ("%0.2f"):format(diff * multi_life), dc, true)
		text:add("物理豁免： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		text:add("治疗系数： ", color, ("%0.1f%%"):format((self.actor:combatStatLimit("con", 1.5, 0, 0.5) - self.actor_dup:combatStatLimit("con", 1.5, 0, 0.5))*100), dc, true)
	elseif stat_id == self.actor.STAT_WIL then
		if self.actor:knowTalent(self.actor.T_MANA_POOL) then
			local multi_mana = 5 + (self.actor.inc_resource_multi.mana or 0)
			text:add("法力上限： ", color, ("%0.2f"):format(diff * multi_mana), dc, true)
		end
		if self.actor:knowTalent(self.actor.T_STAMINA_POOL) then
			local multi_stamina = 2.5 + (self.actor.inc_resource_multi.stamina or 0)
			text:add("体力上限： ", color, ("%0.2f"):format(diff * multi_stamina), dc, true)
		end
		if self.actor:knowTalent(self.actor.T_PSI_POOL) then
			local multi_psi = 1 + (self.actor.inc_resource_multi.psi or 0)
			text:add("超能力上限： ", color, ("%0.2f"):format(diff * multi_psi), dc, true)
		end
		text:add("精神强度： ", color, ("%0.2f"):format(diff * 0.7), dc, true)
		text:add("精神豁免： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		text:add("法术豁免： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		if self.actor:attr("use_psi_combat") then
			text:add("命中： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		end
	elseif stat_id == self.actor.STAT_STR then
		text:add("物理强度： ", color, ("%0.2f"):format(diff), dc, true)
		text:add("负重上限： ", color, ("%0.2f"):format(diff * 1.8), dc, true)
		text:add("物理豁免： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
	elseif stat_id == self.actor.STAT_CUN then
		text:add("暴击几率： ", color, ("%0.2f"):format(diff * 0.3), dc, true)
		text:add("精神豁免： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		text:add("精神强度： ", color, ("%0.2f"):format(diff * 0.4), dc, true)
		if self.actor:attr("use_psi_combat") then
			text:add("命中： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		end
	elseif stat_id == self.actor.STAT_MAG then
		text:add("法术豁免： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		text:add("法术强度： ", color, ("%0.2f"):format(diff * 1), dc, true)
	elseif stat_id == self.actor.STAT_DEX then
		text:add("近身闪避： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		text:add("远程闪避： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		text:add("命中： ", color, ("%0.2f"):format(diff), dc, true)
		text:add("暴击摆脱率： ", color, ("%0.2f%%"):format(diff * 0.3), dc, true)
	end

	if self.actor.player and self.desc_def and self.desc_def.getStatDesc and self.desc_def.getStatDesc(stat_id, self.actor) then
		text:add({"color", "LIGHT_BLUE"}, "职业强度：", dc, true)
		text:add(self.desc_def.getStatDesc(stat_id, self.actor))
	end
	return text
end


function _M:getTalentDesc(item)
	local text = tstring{}

 	text:add({"color", "GOLD"}, {"font", "bold"}, util.getval(item.rawname, item), {"color", "LAST"}, {"font", "normal"})
	text:add(true, true)

	if item.type then
		text:add({"color",0x00,0xFF,0xFF}, "技能树", true)
		text:add({"color",0x00,0xFF,0xFF}, "一 个 技 能 树 包 括 一 些 你 可 以 学 习 的 技 能。 你 分 别 在 等 级 达 到 10、 20、 36 级 时 可 以 获 得 一 个 技 能 分 类 点 数， 你 也 能 在 游 戏 中 找 到 技 能 训 练 师 来 学 习 更 多 技 能。 每 一 点 技 能 分 类 点 数 可 以 解 锁 一 个 未 知 的 技 能 树 或 者 强 化 一 个 已 知 的 技 能 树。", true, true, {"color", "WHITE"})

		if self.actor.talents_types_def[item.type].generic then
			text:add({"color",0x00,0xFF,0xFF}, "通用技能树", true)
			text:add({"color",0x00,0xFF,0xFF}, "一 个 通 用 技 能 树 可 以 为 你 的 角 色 增 加 一 些 实 用 的 技 能。 这 些 技 能 所 有 人 都 可 以 学 习（ 只 要 你 受 到 过 相 应 的 训 练 或 者 能 找 到 对 应 的 训 练 师）。 你 每 升 1 级 可 以 获 得 一 个 通 用 技 能 点 数（ 每 第 5 级 时 除 外）， 你 可 以 找 到 不 同 的 训 练 师 学 习 更 多 通 用 技 能。", true, true, {"color", "WHITE"})
		else
			text:add({"color",0x00,0xFF,0xFF}, "职业技能树", true)
			text:add({"color",0x00,0xFF,0xFF}, "职 业 技 能 树 可 以 让 你 学 习 到 与 你 选 择 的 职 业 相 关 的 一 些 战 斗、 施 法 和 强 化 角 色 的 技 能。 每 升 1 级 可 以 获 得 1 点 职 业 技 能 点 数， 每 升 第 5 级 时 获 得 2 点 职 业 技 能 点 数， 你 也 可 以 找 到 训 练 师 来 学 习 更 多 的 职 业 技 能。", true, true, {"color", "WHITE"})
		end

		text:add(self.actor:getTalentTypeFrom(item.type).description)

	else
		local t = self.actor:getTalentFromId(item.talent)

		local unlearnable, could_unlearn = self:isUnlearnable(t, true)
		if unlearnable then
			local max = tostring(self.actor:lastLearntTalentsMax(t.generic and "generic" or "class"))
			text:add({"color","LIGHT_BLUE"}, "你 刚 在 此 技 能 上 加 点， 你 还 可 以 移 除。 ", true, "最后的 ", max, t.generic and " 通用" or " 职业", " 技 能 点 你 还 可 以 移 除。", {"color","LAST"}, true, true)
		elseif t.no_unlearn_last then
			text:add({"color","YELLOW"}, "本 技 能 会 永 久 性 的 影 响 这 个 游 戏 世 界， 所 以 学 习 之 后 无 法 移 除。", {"color","LAST"}, true, true)
		elseif could_unlearn then
			local max = tostring(self.actor:lastLearntTalentsMax(t.generic and "generic" or "class"))
			text:add({"color","LIGHT_BLUE"}, "你 刚 在 此 技 能 上 加 点，在 #{bold}#城 市#{normal}# 里 你 还 可 以 移 除", true, "最 后 的 ", max, t.generic and " 通用" or " 职业", " 技 能 点 你 还 可 以 移 除。", {"color","LAST"}, true, true)
		end

		local traw = self.actor:getTalentLevelRaw(t.id)
		local diff = function(i2, i1, res)
			res:add({"color", "LIGHT_GREEN"}, i1, {"color", "LAST"}, " [->", {"color", "YELLOW_GREEN"}, i2, {"color", "LAST"}, "]")
		end
		if traw == 0 then
			local req = self.actor:getTalentReqDesc(item.talent, 1):toTString():tokenize(" ()[]")
			text:add{"color","WHITE"}
			text:add({"font", "bold"}, "第一级需求： ", tostring(traw+1), {"font", "normal"})
			text:add(true)
			text:merge(req)
			text:merge(self.actor:getTalentFullDescription(t, 1))
		elseif traw < self:getMaxTPoints(t) then
			local req = self.actor:getTalentReqDesc(item.talent):toTString():tokenize(" ()[]")
			local req2 = self.actor:getTalentReqDesc(item.talent, 1):toTString():tokenize(" ()[]")
			text:add{"color","WHITE"}
			text:add({"font", "bold"}, traw == 0 and "下一等级" or "当前等级：", tostring(traw), " [-> ", tostring(traw + 1), "]", {"font", "normal"})
			text:add(true)
			text:merge(req2:diffWith(req, diff))
			text:merge(self.actor:getTalentFullDescription(t, 1):diffWith(self.actor:getTalentFullDescription(t), diff))
		else
			local req = self.actor:getTalentReqDesc(item.talent)
			text:add({"font", "bold"}, "当前等级："..traw, {"font", "normal"})
			text:add(true)
			text:merge(req)
			text:merge(self.actor:getTalentFullDescription(t))
		end
	end

	return text
end

function _M:onUseTalent(item, inc)
	if item.type then
		self:learnType(item.type, inc)
		item.shown = (self.actor.__hidden_talent_types[item.type] == nil and self.actor:knowTalentType(item.type)) or (self.actor.__hidden_talent_types[item.type] ~= nil and not self.actor.__hidden_talent_types[item.type])
		local t = (item.isgeneric==0 and self.c_gtree or self.c_ctree)
		item.shown = not item.shown t:onExpand(item, inc)
		t:redrawAllItems()
	elseif item.talent then
		self:learnTalent(item.talent, inc)
		local t = (item.isgeneric==0 and self.c_gtree or self.c_ctree)
		t:redrawAllItems()
	elseif item.stat then
		self:incStat(item.stat, inc and 1 or -1)
		self.c_stat:redrawAllItems()
		self.c_ctree:redrawAllItems()
		self.c_gtree:redrawAllItems()
	end

	self.b_stat.text = "属性： "..self.actor.unused_stats
	self.b_stat:generate()
	self.b_class.text = "职业技能点： "..self.actor.unused_talents
	self.b_class:generate()
	self.b_generic.text = "通用技能点： "..self.actor.unused_generics
	self.b_generic:generate()
	self.b_types.text = "技能树解锁点： "..self.actor.unused_talents_types
	self.b_types:generate()
end

function _M:updateTooltip()
	self.c_gtree:updateTooltip()
	self.c_ctree:updateTooltip()
	self.c_stat:updateTooltip()
	if self.focus_ui and self.focus_ui.ui and self.focus_ui.ui.updateTooltip then self.focus_ui.ui:updateTooltip() end
end
