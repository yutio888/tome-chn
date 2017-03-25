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
local Shader = require "engine.Shader"
local Dialog = require "engine.ui.Dialog"
local Textzone = require "engine.ui.Textzone"
local Separator = require "engine.ui.Separator"
local List = require "engine.ui.List"
local Savefile = require "engine.Savefile"
local Map = require "engine.Map"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(actor)
	self.actor = actor
	self.ui = "deathbox"
	Dialog.init(self, "你 已 经 #LIGHT_RED#死 亡#LAST#!", 500, 600)

	actor:saveUUID()

	self:generateList()
	if self.dont_show then return end
	if not config.settings.cheat then game:saveGame() end

	local text = [[你 已 经 #LIGHT_RED# 死 亡 #LAST#!
在 ToME 里 死 亡 是 永 久 的， 但 是 如 果 你 有 某 种 复 活 的 方 法 它 会 在 菜 单 上 显 示 出 来...
你 可 以 将 你 的 角 色 数 据 存 起 来 留 作 纪 念， 或 者 你 可 以 退 出 并 再 次 尝 试 野 外 生 存！
]]

	if #game.party.on_death_show_achieved > 0 then
		self.c_achv = Textzone.new{width=self.iw, scrollbar=true, height=100, text="#LIGHT_GREEN#During your game you#WHITE#:\n* "..table.concat(game.party.on_death_show_achieved, "\n* ")}
	end

	self:setTitleShadowShader(Shader.default.textoutline and Shader.default.textoutline.shad, 1.5)
	self.c_desc = Textzone.new{width=self.iw, auto_height=true, text=text}
	self.c_desc:setTextShadow(1)
	self.c_desc:setShadowShader(Shader.default.textoutline and Shader.default.textoutline.shad, 1.2)

	self.c_list = List.new{width=self.iw, nb_items=#self.list, list=self.list, fct=function(item) self:use(item) end, select=function(item) self.cur_item = item end}

	self.graphical_options = {
		blood_life = {
			available   = self:getUITexture("ui/active_blood_life.png"),
			unavailable = self:getUITexture("ui/inactive_blood_life.png"),
		},
		consume = {
			available   = self:getUITexture("ui/active_consume.png"),
			unavailable = self:getUITexture("ui/inactive_consume.png"),
		},
		skeleton = {
			available   = self:getUITexture("ui/active_skeleton.png"),
			unavailable = self:getUITexture("ui/inactive_skeleton.png"),
		},
	}


	if self.c_achv then
		self:loadUI{
			{left=0, top=0, ui=self.c_desc},
			{left=0, top=self.c_desc.h, ui=self.c_achv},
			{left=5, top=self.c_desc.h+self.c_achv.h, padding_h=10, ui=Separator.new{ui="deathbox", dir="vertical", size=self.iw - 10}},
			{left=0, bottom=0, ui=self.c_list},
		}
	else
		self:loadUI{
			{left=0, top=0, ui=self.c_desc},
			{left=5, top=self.c_desc.h, padding_h=10, ui=Separator.new{ui="deathbox", dir="vertical", size=self.iw - 10}},
			{left=0, bottom=0, ui=self.c_list},
		}
	end
	self:setFocus(self.c_list)
	self:setupUI(false, true)
end

--- Clean the actor from debuffs/buffs
function _M:cleanActor(actor)
	local effs = {}

	-- Remove chronoworlds
	if game._chronoworlds then game._chronoworlds = nil end

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
			actor:removeEffect(eff[2], false, true)
		else
			actor:forceUseTalent(eff[2], {ignore_energy=true, no_equilibrium_fail=true, no_paradox_fail=true, save_cleanup=true})
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

	-- Find the position of the last dead
	local last = game.party:findLastDeath()

	local x, y = util.findFreeGrid(last.x, last.y, 20, true, {[Map.ACTOR]=true})
	if not x then x, y = last.x, last.y end
	
	-- invulnerable while moving so we don't get killed twice
	local old_invuln = actor.invulnerable
	actor.invulnerable = 1
	actor.x, actor.y = nil, nil
	actor:move(x, y, true)
	actor.invulnerable = old_invuln

	game.level:addEntity(actor)
	game:unregisterDialog(self)
	game.level.map:redisplay()
	actor.energy.value = game.energy_to_act

	-- apply cursed equipment
	if actor.hasTalent and actor.hasTalent(actor.T_DEFILING_TOUCH) then
		local t = actor:getTalentFromId(actor.T_DEFILING_TOUCH)
		t.updateCurses(actor, t, true)
	end

	actor.changed = true
	game.paused = true
end

--- Send the party to the Eidolon Plane
function _M:eidolonPlane()
--	self.actor:setEffect(self.actor.EFF_EIDOLON_PROTECT, 1, {})
	game:onTickEnd(function()
		if not self.actor:attr("infinite_lifes") then
			self.actor:attr("easy_mode_lifes", -1)
			game.log("#LIGHT_RED#你还剩 %s 。", (self.actor:attr("easy_mode_lifes") and self.actor:attr("easy_mode_lifes").." 条生命") or "0条生命")
		end


		local is_exploration = game.permadeath == game.PERMADEATH_INFINITE
		self:cleanActor(self.actor)
		self:resurrectBasic(self.actor)
		for e, _ in pairs(game.party.members) do
			self:cleanActor(e)
		end
		for uid, e in pairs(game.level.entities) do
			if not is_exploration or game.party:hasMember(e) then
				self:restoreResources(e)
			end
		end

		game.party:goToEidolon(self.actor)

		game.log("#LIGHT_RED#在死亡的边缘，你被拉入了另一个位面。")
		game.player:updateMainShader()
		if not config.settings.cheat then game:saveGame() end
	end)
	return true
end

function _M:use(item)
	if not item then return end
	local act = item.action

	if type(act) == "function" then
		act()
	elseif act == "exit" then
		if item.subaction == "none" then
			util.showMainMenu()
		elseif item.subaction == "restart" then
			local addons = {}
			for add, _ in pairs(game.__mod_info.addons) do addons[#addons+1] = "'"..add.."'" end
			util.showMainMenu(false, engine.version[4], engine.version[1].."."..engine.version[2].."."..engine.version[3], game.__mod_info.short_name, game.save_name, true, ("auto_quickbirth=%q set_addons={%s}"):format(game:getPlayer(true).name, table.concat(addons, ", ")))
		elseif item.subaction == "restart-new" then
			util.showMainMenu(false, engine.version[4], engine.version[1].."."..engine.version[2].."."..engine.version[3], game.__mod_info.short_name, game.save_name, true)
		end
	elseif act == "dump" then
		game:registerDialog(require("mod.dialogs.CharacterSheet").new(self.actor))
	elseif act == "log" then
		game:registerDialog(require("mod.dialogs.ShowChatLog").new("Message Log", 0.6, game.uiset.logdisplay, profile.chat))
	elseif act == "cheat" then
		game.logPlayer(self.actor, "#LIGHT_BLUE#你复活了！作弊者！")

		self:cleanActor(self.actor)
		self:resurrectBasic(self.actor)
		self:restoreResources(self.actor)
		self.actor:check("on_resurrect", "cheat")
	elseif act == "blood_life" then
		self.actor.blood_life = false
		game.logPlayer(self.actor, "#LIGHT_RED#生命之血在你的尸体里流淌。你复活了！")

		self:cleanActor(self.actor)
		self:resurrectBasic(self.actor)
		self:restoreResources(self.actor)
		world:gainAchievement("UNSTOPPABLE", actor)
		self.actor:check("on_resurrect", "blood_life")
		game:saveGame()
	elseif act == "lichform" then
		local t = self.actor:getTalentFromId(self.actor.T_LICHFORM)

		self:cleanActor(self.actor)
		self:resurrectBasic(self.actor)
		self:restoreResources(self.actor)
		world:gainAchievement("LICHFORM", actor)
		t.becomeLich(self.actor, t)
		self.actor:updateModdableTile()
		self.actor:check("on_resurrect", "lichform")
		game:saveGame()
	elseif act == "threads" then
		game:chronoRestore("see_threads_base", true)
		game:onTickEnd(function()
			game._chronoworlds = nil
			game.player:removeEffect(game.player.EFF_SEE_THREADS)end
		)
		game:saveGame()
	elseif act == "easy_mode" then
		self:eidolonPlane()
	elseif act == "skeleton" then
		self.actor:attr("re-assembled", 1)
		game.logPlayer(self.actor, "#YELLOW#你的骨头奇迹般的拼合在了一起。你可以再次把痛苦施加于敌人了！")

		self:cleanActor(self.actor)
		self:resurrectBasic(self.actor)
		self:restoreResources(self.actor)
		world:gainAchievement("UNSTOPPABLE", actor)
		self.actor:check("on_resurrect", "skeleton")
		game:saveGame()
	elseif act:find("^consume") then
		local inven, item, o = item.inven, item.item, item.object
		self.actor:removeObject(inven, item)
		game.logPlayer(self.actor, "#YELLOW#你的 %s 耗尽并消失了！你复活了！", o:getName{do_colour=true})

		self:cleanActor(self.actor)
		self:resurrectBasic(self.actor)
		self:restoreResources(self.actor)
		world:gainAchievement("UNSTOPPABLE", actor)
		self.actor:check("on_resurrect", "consume", o)
		game:saveGame()
	end
end

function _M:generateList()
	local list = {}
	self.possible_items = {}
	local allow_res = true

	-- Pause the game
	game:onTickEnd(function()
		game.paused = true
		game.player.energy.value = game.energy_to_act
	end)

	if game.zone.is_eidolon_plane then
		game.logPlayer(self, "你成功地死于幻象位面！死吧！")
		game:onTickEnd(function() world:gainAchievement("EIDOLON_DEATH", self.actor) end)
		allow_res = false
	end

	if config.settings.cheat then list[#list+1] = {name="Resurrect by cheating", action="cheat"} end
	if not self.actor.no_resurrect and allow_res then
		if self.actor:hasEffect(self.actor.EFF_SEE_THREADS) and game._chronoworlds then
			self:use{action="threads"}
			self.dont_show =true
			return
		end
		if self.actor:isTalentActive(self.actor.T_LICHFORM) then
			self:use{action="lichform"}
			self.dont_show = true
			return
		end
		if self.actor:attr("easy_mode_lifes") or self.actor:attr("infinite_lifes") then
			self:use{action="easy_mode"}
			self.dont_show = true
			return
		end
		if self.actor:attr("blood_life") and not self.actor:attr("undead") then list[#list+1] = {name="通过生命之血复活", action="blood_life"} end
		if self.actor:getTalentLevelRaw(self.actor.T_SKELETON_REASSEMBLE) >= 5 and not self.actor:attr("re-assembled") then list[#list+1] = {name="Re-assemble your bones and resurrect (Skeleton ability)", action="skeleton"} end

		local consumenb = 1
		self.actor:inventoryApplyAll(function(inven, item, o)
			if o.one_shot_life_saving and (not o.slot or inven.worn) then
				list[#list+1] = {name="Resurrect by consuming "..o:getName{do_colour=true}, action="consume"..consumenb, inven=inven, item=item, object=o, is_consume=true}
				consumenb = consumenb + 1
				self.possible_items.consume = true
			end
		end)

		self.actor:fireTalentCheck("callbackOnDeathbox", self, list)
	end

	list[#list+1] = {name=(not profile.auth and "消息日志" or "消息/聊天日志(允许聊天)"), action="log"}
	list[#list+1] = {name="存储角色", action="dump"}
	list[#list+1] = {name="以这个角色重新开始", action="exit", subaction="restart"}
	list[#list+1] = {name="以新角色重新开始", action="exit", subaction="restart-new"}
	list[#list+1] = {name="回到主菜单", action="exit", subaction="none"}

	self.list = list
	for _, item in ipairs(list) do self.possible_items[item.action] = true end
end

function _M:innerDisplayBack(x, y, nb_keyframes, tx, ty)
	x = x + self.frame.ox1
	y = y + self.frame.oy1

	if self.possible_items.blood_life then
		local d = self.graphical_options.blood_life[self.cur_item and self.cur_item.action == "blood_life" and "available" or "unavailable"]
		d.t:toScreenFull(x + self.frame.w - d.w, y, d.w, d.h, d.tw, d.th, 1, 1, 1, 1)
	end
	if self.possible_items.consume then
		local d = self.graphical_options.consume[self.cur_item and self.cur_item.is_consume and "available" or "unavailable"]
		d.t:toScreenFull(x, y, d.w, d.h, d.tw, d.th, 1, 1, 1, 1)
	end
	if self.possible_items.skeleton then
		local d = self.graphical_options.skeleton[self.cur_item and (self.cur_item.action == "skeleton" or self.cur_item.action == "lichform") and "available" or "unavailable"]
		d.t:toScreenFull(x, y + self.frame.h - d.h, d.w, d.h, d.tw, d.th, 1, 1, 1, 1)
	end
end
