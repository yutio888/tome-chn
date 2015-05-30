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
require "mod.class.interface.TooltipsData"
local Dialog = require "engine.ui.Dialog"
local DamageType = require "engine.DamageType"
local Talents = require "engine.interface.ActorTalents"
local Tab = require "engine.ui.Tab"
local Button = require "engine.ui.Button"
local SurfaceZone = require "engine.ui.SurfaceZone"
local Separator = require "engine.ui.Separator"
local Stats = require "engine.interface.ActorStats"
local Textzone = require "engine.ui.Textzone"
local FontPackage = require "engine.FontPackage"

module(..., package.seeall, class.inherit(Dialog, mod.class.interface.TooltipsData))

cs_player_dup = nil

function _M:init(actor)
	if _M.cs_player_dup and _M.cs_player_dup.name ~= actor.name then _M.cs_player_dup = nil end

	self.actor = actor
	Dialog.init(self, "角色面板   "..self.actor.name, math.max(game.w * 0.7, 950), 500)

	self.font = core.display.newFont(chn123_tome_font(), 12)
	self.font_h = self.font:lineSkip()

	self.talent_sorting = config.settings.tome.charsheet_talent_sorting or 1
	self.c_general = Tab.new{title="综合", default=true, fct=function() end, on_change=function(s) if s then self:switchTo("general") end end}
	self.c_attack = Tab.new{title="攻击", default=false, fct=function() end, on_change=function(s) if s then self:switchTo("attack") end end}
	self.c_defence = Tab.new{title="防御", default=false, fct=function() end, on_change=function(s) if s then self:switchTo("defence") end end}
	self.c_talents = Tab.new{title="技能", default=false, fct=function() end, on_change=function(s) if s then self:switchTo("talents") end end}
	self.b_talents_sorting = Button.new{text="分类: "..({"技能树", "名称", "类型"})[self.talent_sorting], hide=true, width=100, fct=function()
		self.talent_sorting = self.talent_sorting + 1
		if self.talent_sorting > 3 then self.talent_sorting = 1 end

		--Save to config
		config.settings.tome.charsheet_talent_sorting = self.talent_sorting
		game:saveSettings("tome.charsheet_talent_sorting", ("tome.charsheet_talent_sorting = %d\n"):format(self.talent_sorting))

		self.b_talents_sorting.text = "分类: "..({"技能树", "名称", "类型"})[self.talent_sorting]
		self.b_talents_sorting:generate()
		self:switchTo("talents") -- Force a redraw
	end}


	local tw, th = self.font_bold:size(self.title)

	self.vs = Separator.new{dir="vertical", size=self.iw}

	self.c_tut = Textzone.new{width=self.iw * 0.6, auto_height=true, no_color_bleed=true, font = self.font, text=[[
括弧#00FF00#( )#LAST#内显示的是与最近一次载入角色面板属性值属性的变化。
按键盘(#00FF00#d#LAST#)键来保存角色资料，按(#00FF00#TAB#LAST#)键在各分类面板中切换。
鼠标滑动查看数据。
]]}

	game.total_playtime = (game.total_playtime or 0) + (os.time() - (game.last_update or game.real_starttime))
	game.last_update = os.time()

	local playtime = ""
	local days = math.floor(game.total_playtime/86400)
	local hours = math.floor(game.total_playtime/3600) % 24
	local minutes = math.floor(game.total_playtime/60) % 60
	local seconds = game.total_playtime % 60

	if days > 0 then
		playtime = ("%i 天 %i 小时 %i 分 %s 秒"):format(days,  hours, minutes,seconds)
	elseif hours > 0 then
		playtime = ("%i 小时 %i 分 %s 秒"):format(hours, minutes,seconds)
	elseif minutes > 0 then
		playtime = ("%i 分 %s 秒"):format(minutes,seconds)
	else
		playtime = ("%s 秒"):format(seconds)
	end

	local all_kills_kind = self.actor.all_kills_kind or {}
	local playtimetext = ([[#GOLD#冒险日/月：#LAST# %d / %s
#GOLD#游戏时间：#LAST# %s
#GOLD#杀死的总生物数:           #ANTIQUE_WHITE#%d
#GOLD#杀死的精英/稀有/Boss数: #YELLOW#%d/#SALMON#%d/#ORANGE#%d
]]):format(
		game.turn / game.calendar.DAY,
		game.calendar:getMonthName(game.calendar:getDayOfYear(game.turn)),
		playtime,
		all_kills_kind.creature or 0,
		all_kills_kind.elite or 0,
		all_kills_kind.rare or 0,
		all_kills_kind.boss or 0
	)

	self.c_playtime = Textzone.new{width=self.iw * 0.4, auto_height=true, no_color_bleed=true, font = self.font, text=playtimetext}

	self.c_desc = SurfaceZone.new{width=self.iw, height=self.ih - self.c_general.h - self.vs.h - self.c_tut.h,alpha=0}

	self:loadUI{
		{left=0, top=0, ui=self.c_tut},
		{left=self.iw * 0.5, top=0, ui=self.c_playtime},
		{left=15, top=self.c_tut.h, ui=self.c_general},
		{left=15+self.c_general.w, top=self.c_tut.h, ui=self.c_attack},
		{left=15+self.c_general.w+self.c_attack.w, top=self.c_tut.h, ui=self.c_defence},
		{left=15+self.c_general.w+self.c_attack.w+self.c_defence.w, top=self.c_tut.h, ui=self.c_talents},
		{left=0, top=self.c_tut.h + self.c_general.h, ui=self.vs},
		{right=0, bottom=0, ui=self.b_talents_sorting},

		{left=0, top=self.c_tut.h + self.c_general.h + 5 + self.vs.h, ui=self.c_desc},
	}
	self:setFocus(self.c_general)
	self:setupUI()

	self:switchTo("general")

	self:updateKeys()
end

function _M:innerDisplay(x, y, nb_keyframes)
	self.actor:toScreen(nil, x + self.iw - 128, y + 6, 128, 128)
end

function _M:switchTo(kind)
	self.b_talents_sorting.hide = true
	self:drawDialog(kind, _M.cs_player_dup)
	if kind == "general" then self.c_attack.selected = false self.c_defence.selected = false self.c_talents.selected = false
	elseif kind == "attack" then self.c_general.selected = false self.c_defence.selected = false self.c_talents.selected = false
	elseif kind == "defence" then self.c_attack.selected = false self.c_general.selected = false self.c_talents.selected = false
	elseif kind == "talents" then
		self.b_talents_sorting.hide = false
		self.c_attack.selected = false self.c_general.selected = false self.c_defence.selected = false
	end
	self:updateKeys()
end

function _M:on_register()
	game:onTickEnd(function() self.key:unicodeInput(true) end)
end

function _M:updateKeys()
	self.key:addCommands{
	_TAB = function() self:tabTabs() end,
	__TEXTINPUT = function(c)
		if (c == 'd' or c == 'D') and self.actor.player then
			self:dump()
		end
	end,
	}

	self.key:addBinds{
		EXIT = function() _M.cs_player_dup = game.player:clone() game:unregisterDialog(self) end,
	}
end

function _M:tabTabs()
	if self.c_general.selected == true then self.c_attack:select()
	elseif self.c_attack.selected == true then self.c_defence:select()
	elseif 	self.c_defence.selected == true then self.c_talents:select()
	elseif self.c_talents.selected == true then self.c_general:select()
	end
end

function _M:mouseZones(t, no_new)
	self.c_desc.mouse:registerZones(t)
	self.c_desc.can_focus = true
end

function _M:mouseTooltip(text, _, _, _, w, h, x, y)
	self:mouseZones({
		{ x=x, y=y, w=w, h=h, fct=function(button) game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, text) end},
	}, true)
end

function _M:mouseLink(link, text, _, _, _, w, h, x, y)
	self:mouseZones({
		{ x=x, y=y, w=w, h=h, fct=function(button)
			game.tooltip_x, game.tooltip_y = 1, 1; game:tooltipDisplayAtMap(game.w, game.h, text)
			if button == "left" then
				util.browserOpenUrl(link, {is_external=true})
			end
		end},
	}, true)
end

function _M:drawDialog(kind, actor_to_compare)
	--actor_to_compare = actor_to_compare or {}
	self.c_desc.mouse:reset()
	self.c_desc.key:reset()

--	self:setupUI()

	local player = self.actor
	local s = self.c_desc.s

	s:erase(0,0,0,0)

	local h = 0
	local w = 0

	local text = ""
	local dur_text = ""

	if player.__te4_uuid and profile.auth and profile.auth.drupid then
		local path = "http://te4.org/characters/"..profile.auth.drupid.."/tome/"..player.__te4_uuid
		local LinkTxt = "Online URL: #LIGHT_BLUE##{underline}#"..path.."#{normal}#"
		local Link_w, Link_h = self.font:size(LinkTxt)
		h = self.c_desc.h - Link_h
		w = (self.c_desc.w - Link_w) * 0.5
		self:mouseLink(path, "You can find your character sheet online", s:drawColorStringBlended(self.font, LinkTxt, w, h, 255, 255, 255, true))
	end

	local compare_fields = function(item1, item2, field, outformat, diffoutformat, mod, isinversed, nobracets, ...)
		mod = mod or 1
		isinversed = isinversed or false
		local ret = tstring{}
		local added = 0
		local add = false
		local value
		if type(field) == "function" then
			value = field(item1, ...)
		else
			value = item1[field]
		end
		ret:add(outformat:format((value or 0) * mod))

		if value then
			add = true
		end

		local value2
		if item2 then
			if type(field) == "function" then
				value2 = field(item2, ...)
			else
				value2 = item2[field]
			end
		end

		if value and value2 and value2 ~= value then
			if added == 0 and not nobracets then
				ret:add(" (")
			elseif added > 1 then
				ret:add(" / ")
			end
			added = added + 1
			add = true

			if isinversed then
				ret:add(value2 < value and {"color","RED"} or {"color","LIGHT_GREEN"}, diffoutformat:format(((value or 0) - value2) * mod), {"color", "LAST"})
			else
				ret:add(value2 > value and {"color","RED"} or {"color","LIGHT_GREEN"}, diffoutformat:format(((value or 0) - value2) * mod), {"color", "LAST"})
			end
		end
		if added > 0 and not nobracets then
			ret:add(")")
		end
		if add then
			return ret:toString()
		end
		return nil
	end

	local compare_table_fields = function(item1, item2, field, outformat, text, kfunct, mod, isinversed)
		mod = mod or 1
		isinversed = isinversed or false
		local ret = tstring{}
		local added = 0
		local add = false
		ret:add(text)
		local tab = {}
		if item1[field] then
			for k, v in pairs(item1[field]) do
				tab[k] = {}
				tab[k][1] = v
			end
		end
		if item2[field] then
			for k, v in pairs(item2[field]) do
				tab[k] = tab[k] or {}
				tab[k][2] = v
			end
		end
		local count1 = 0
		for k, v in pairs(tab) do
			local count = 0
			if isinversed then
				ret:add(("%s"):format((count1 > 0) and " / " or ""), (v[1] or 0) > 0 and {"color","RED"} or {"color","LIGHT_GREEN"}, outformat:format((v[1] or 0)), {"color","LAST"})
			else
				ret:add(("%s"):format((count1 > 0) and " / " or ""), (v[1] or 0) < 0 and {"color","RED"} or {"color","LIGHT_GREEN"}, outformat:format((v[1] or 0)), {"color","LAST"})
			end
			count1 = count1 + 1
			if v[1] then
				add = true
			end
			for kk, vv in pairs(v) do
				if kk > 1 and (v[1] or 0) ~= vv then
					if count == 0 then
						ret:add("(")
					elseif count > 0 then
						ret:add(" / ")
					end
					if isinversed then
						ret:add((v[1] or 0) > vv and {"color","RED"} or {"color","LIGHT_GREEN"}, outformat:format((v[1] or 0) - vv), {"color","LAST"})
					else
						ret:add((v[1] or 0) < vv and {"color","RED"} or {"color","LIGHT_GREEN"}, outformat:format((v[1] or 0) - vv), {"color","LAST"})
					end
					add = true
					count = count + 1
				end
			end
			if count > 0 then
				ret:add(")")
			end
			ret:add(kfunct(k))
		end

		if add then
			return ret:toString()
		end
		return nil
	end

	if kind == "general" then
		local cur_exp, max_exp = player.exp, player:getExpChart(player.level+1)
		h = 0
		w = 0
		s:drawStringBlended(self.font, "性别："..((player.descriptor and player.descriptor.sex) or (player.female and "女性" or "男性")), w, h, 0, 200, 255, true) h = h + self.font_h
		s:drawStringBlended(self.font, "种族："..((player.descriptor and player.descriptor.subrace) or player.type:capitalize()), w, h, 0, 200, 255, true) h = h + self.font_h
		s:drawStringBlended(self.font, "职业："..((player.descriptor and player.descriptor.subclass) or player.subtype:capitalize()), w, h, 0, 200, 255, true) h = h + self.font_h
		s:drawStringBlended(self.font, "体型："..player:TextSizeCategory(), w, h, 0, 200, 255, true) h = h + self.font_h

		h = h + self.font_h
		if player:attr("forbid_arcane") then
			local follow = (player.faction == "zigur" or player:attr("zigur_follower")) and "伊格追随者" or "反魔志愿者"
			s:drawColorStringBlended(self.font, "#ORCHID#伊格追随者", w, h, 255, 255, 255, true) h = h + self.font_h
		end
		if player:attr("blood_life") then
			s:drawColorStringBlended(self.font, "#DARK_RED#生命之血", w, h, 255, 255, 255, true) h = h + self.font_h
		end

		h = h + self.font_h
		self:mouseTooltip(self.TOOLTIP_LEVEL, s:drawColorStringBlended(self.font,  "等级：#00ff00#"..player.level, w, h, 255, 255, 255, true)) h = h + self.font_h
		self:mouseTooltip(self.TOOLTIP_LEVEL, s:drawColorStringBlended(self.font, ("经验值：#00ff00#%2d%%"):format(100 * cur_exp / max_exp), w, h, 255, 255, 255, true)) h = h + self.font_h
		self:mouseTooltip(self.TOOLTIP_GOLD, s:drawColorStringBlended(self.font, ("金币：#00ff00#%0.2f"):format(player.money), w, h, 255, 255, 255, true)) h = h + self.font_h

		h = h + self.font_h

		text = compare_fields(player, actor_to_compare, "max_life", "%d", "%+.0f")
		if player.die_at ~=  0 or (actor_to_compare and actor_to_compare.die_at ~=0) then 
			text = text .. " #a08080#[" .. compare_fields(player, actor_to_compare, "die_at", "生命底线：%+d","%+.0f", 1, true) .. "]"
		end
		if player.life < 0 then self:mouseTooltip(self.TOOLTIP_LIFE, s:drawColorStringBlended(self.font, ("#c00000#生命值：#00ff00#???/%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		else self:mouseTooltip(self.TOOLTIP_LIFE, s:drawColorStringBlended(self.font, ("#c00000#生命值：#00ff00#%d/%s"):format(player.life, text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end

		if player:knowTalent(player.T_STAMINA_POOL) then
			text = compare_fields(player, actor_to_compare, "max_stamina", "%d", "%+.0f")
			self:mouseTooltip(self.TOOLTIP_STAMINA, s:drawColorStringBlended(self.font, ("#ffcc80#体力值：#00ff00#%d/%s"):format(player:getStamina(), text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		if player:knowTalent(player.T_MANA_POOL) then
			text = compare_fields(player, actor_to_compare, "max_mana", "%d", "%+.0f")
			self:mouseTooltip(self.TOOLTIP_MANA, s:drawColorStringBlended(self.font, ("#7fffd4#法力值：#00ff00#%d/%s"):format(player:getMana(), text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		if player:knowTalent(player.T_POSITIVE_POOL) then
			text = compare_fields(player, actor_to_compare, "max_positive", "%d", "%+.0f")
			self:mouseTooltip(self.TOOLTIP_POSITIVE, s:drawColorStringBlended(self.font, ("#7fffd4#正能量：#00ff00#%d/%s"):format(player:getPositive(), text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		if player:knowTalent(player.T_NEGATIVE_POOL) then
			text = compare_fields(player, actor_to_compare, "max_negative", "%d", "%+.0f")
			self:mouseTooltip(self.TOOLTIP_NEGATIVE, s:drawColorStringBlended(self.font, ("#7fffd4#负能量：#00ff00#%d/%s"):format(player:getNegative(), text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		if player:knowTalent(player.T_VIM_POOL) then
			text = compare_fields(player, actor_to_compare, "max_vim", "%d", "%+.0f")
			self:mouseTooltip(self.TOOLTIP_VIM, s:drawColorStringBlended(self.font, ("#904010#活力：#00ff00#%d/%s"):format(player:getVim(), text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		if player:knowTalent(player.T_HATE_POOL) then
			self:mouseTooltip(self.TOOLTIP_HATE, s:drawColorStringBlended(self.font, ("#F53CBE#仇恨：#00ff00#%d/%d"):format(player:getHate(), player.max_hate), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		if player:knowTalent(player.T_PARADOX_POOL) then
			text = compare_fields(player, actor_to_compare, function(actor) local _, chance = actor:paradoxFailChance() return chance end, "%d%%", "%+.1f%%", 1, true)
			self:mouseTooltip(self.TOOLTIP_PARADOX, s:drawColorStringBlended(self.font, ("#LIGHT_STEEL_BLUE#紊乱值：#00ff00#%d(fail: %s)"):format(player:getParadox(), text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		if player:knowTalent(player.T_PSI_POOL) then
			text = compare_fields(player, actor_to_compare, "max_psi", "%d", "%+.0f")
			self:mouseTooltip(self.TOOLTIP_PSI, s:drawColorStringBlended(self.font, ("#7fffd4#意念力：#00ff00#%d/%s"):format(player:getPsi(), text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		if player:getMaxFeedback() > 0 then
			text = compare_fields(player, actor_to_compare, "psionic_feedback_max", "%d", "%+.0f")
			local tt = self.TOOLTIP_FEEDBACK..(" 现在获得的反馈值为受到伤害的%0.1f％"):format(player:callTalent(player.T_FEEDBACK_POOL, "getFeedbackRatio")*100)
			self:mouseTooltip(tt, s:drawColorStringBlended(self.font, ("#7fffd4#反馈值: #00ff00#%d/%s"):format(player:getFeedback(), text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end

		if player:knowTalent(player.T_EQUILIBRIUM_POOL) then
			text = compare_fields(player, actor_to_compare, function(actor) local _, chance = actor:equilibriumChance() return 100 - chance end, "%d%%", "%+.1f%%", 1, true)
			self:mouseTooltip(self.TOOLTIP_EQUILIBRIUM, s:drawColorStringBlended(self.font, ("#00ff74#失衡值：#00ff00#%d(fail: %s)"):format(player:getEquilibrium(), text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end

		h = 0
		w = self.w * 0.25

		s:drawColorStringBlended(self.font, "#LIGHT_BLUE#速度:", w, h, 255, 255, 255, true) h = h + self.font_h
		local color = player.global_speed
		color = color >= 1 and "#LIGHT_GREEN#" or "#LIGHT_RED#"
		text = compare_fields(player, actor_to_compare, "global_speed", color.."%.1f%%", "%+.1f%%",100)
		self:mouseTooltip(self.TOOLTIP_SPEED_GLOBAL,   s:drawColorStringBlended(self.font, ("整体速度：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		color = 1/player:getSpeed("movement")
		color = color >= 1 and "#LIGHT_GREEN#" or "#LIGHT_RED#"
		text = compare_fields(player, actor_to_compare, function(actor) return (1/actor:getSpeed("movement")) end, color.."%.1f%%", "%+.1f%%", 100)
		self:mouseTooltip(self.TOOLTIP_SPEED_MOVEMENT, s:drawColorStringBlended(self.font, ("移动速度：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		color = 1/player:getSpeed("spell")
		color = color >= 1 and "#LIGHT_GREEN#" or "#LIGHT_RED#"
		text = compare_fields(player, actor_to_compare, function(actor, ...) return 1/actor:getSpeed("spell") end, color.."%.1f%%", "%+.1f%%", 100)
		self:mouseTooltip(self.TOOLTIP_SPEED_SPELL,    s:drawColorStringBlended(self.font, ("施法速度：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h

		color = 1/player:getSpeed("weapon")
		color = color >= 1 and "#LIGHT_GREEN#" or "#LIGHT_RED#"
		text = compare_fields(player, actor_to_compare, function(actor, ...) return 1/actor:getSpeed("weapon") end, color.."%.1f%%", "%+.1f%%", 100)
		self:mouseTooltip(self.TOOLTIP_SPEED_ATTACK,   s:drawColorStringBlended(self.font, ("战斗速度：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		color = 1/player:getSpeed("mind")
		color = color >= 1 and "#LIGHT_GREEN#" or "#LIGHT_RED#"
		text = compare_fields(player, actor_to_compare, function(actor, ...) return 1/actor:getSpeed("mind") end, color.."%.1f%%", "%+.1f%%", 100)
		self:mouseTooltip(self.TOOLTIP_SPEED_MENTAL,   s:drawColorStringBlended(self.font, ("精神速度： #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		h = h + self.font_h
		if player.died_times then
			text = compare_fields(player, actor_to_compare, function(actor) return #actor.died_times end, "%3d", "%+.0f")
			self:mouseTooltip(self.TOOLTIP_LIVES,       s:drawColorStringBlended(self.font, ("死亡次数：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		if player.easy_mode_lifes then
			text = compare_fields(player, actor_to_compare, "easy_mode_lifes", "%3d", "%+.0f")
			self:mouseTooltip(self.TOOLTIP_LIVES, s:drawColorStringBlended(self.font,   ("剩余生命：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		color = player.healing_factor
		color = color >= 1 and "#LIGHT_GREEN#" or "#LIGHT_RED#"
		text = compare_fields(player, actor_to_compare, function(actor) return util.bound((actor.healing_factor or 1), 0, 2.5) end, color.."%.1f%%", "%+.1f%%", 100)
		self:mouseTooltip(self.TOOLTIP_HEALING_MOD, s:drawColorStringBlended(self.font, ("治疗系数：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		color = player.life_regen
		color = color >= 0 and "#LIGHT_GREEN#" or "#LIGHT_RED#"
		text = compare_fields(player, actor_to_compare, "life_regen", color.."%.1f", "%+.1f")
		self:mouseTooltip(self.TOOLTIP_LIFE_REGEN,  s:drawColorStringBlended(self.font, ("生命回复：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor) return actor.life_regen * util.bound((actor.healing_factor or 1), 0, 2.5) end, "%.2f", "%+.2f")
		self:mouseTooltip(self.TOOLTIP_LIFE_REGEN,  s:drawColorStringBlended(self.font, ("生命回复（加成后）#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h

		h = h + self.font_h
		s:drawColorStringBlended(self.font, "#LIGHT_BLUE#视野：", w, h, 255, 255, 255, true) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, "lite", "%d", "%+.0f")
		if text then
			self:mouseTooltip(self.TOOLTIP_VISION_LITE,  s:drawColorStringBlended(self.font, ("光照范围：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		text = compare_fields(player, actor_to_compare, "sight", "%d", "%+.0f")
		if text then
			self:mouseTooltip(self.TOOLTIP_VISION_SIGHT,  s:drawColorStringBlended(self.font, ("视觉范围：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		text = compare_fields(player, actor_to_compare, function(actor) return (actor:attr("infravision") or actor:attr("heightened_senses")) and math.max((actor.heightened_senses or 0), (actor.infravision or 0)) end, "%d", "%+.0f")
		if text then
			self:mouseTooltip(self.TOOLTIP_VISION_INFRA,  s:drawColorStringBlended(self.font, ("强化感知: #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		text = compare_fields(player, actor_to_compare, function(who) return who:attr("stealth") and who.stealth + (who:attr("inc_stealth") or 0) end, "%.1f", "%+.1f")
		if text then
			self:mouseTooltip(self.TOOLTIP_VISION_STEALTH,  s:drawColorStringBlended(self.font, ("潜行：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		text = compare_fields(player, actor_to_compare, function(actor) return actor:combatSeeStealth() end, "%.1f", "%+.1f")
		if text then
			self:mouseTooltip(self.TOOLTIP_VISION_SEE_STEALTH,  s:drawColorStringBlended(self.font, ("侦测潜行：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		text = compare_fields(player, actor_to_compare, "invisible", "%.1f", "%+.1f")
		if text then
			self:mouseTooltip(self.TOOLTIP_VISION_INVISIBLE,  s:drawColorStringBlended(self.font, ("隐形：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		text = compare_fields(player, actor_to_compare, function(actor) return actor:combatSeeInvisible() end, "%.1f", "%+.1f")
		if text then
			self:mouseTooltip(self.TOOLTIP_VISION_SEE_INVISIBLE,  s:drawColorStringBlended(self.font, ("侦测隐形：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end

		local any_esp = false
		local esps_compare = {}
		if actor_to_compare and actor_to_compare.esp_all and actor_to_compare.esp_all ~= 0 then
			esps_compare["All"] = {}
			esps_compare["All"][1] = v
			any_esp = true
		end
		if player.esp_all and player.esp_all ~= 0 then
			esps_compare["All"] = esps_compare["All"] or {}
			esps_compare["All"][2] = v
			any_esp = true
		end
		for type, v in pairs(actor_to_compare and (actor_to_compare.esp or {}) or {}) do
			if v ~= 0 then
				esps_compare[type] = {}
				esps_compare[type][1] = v
				any_esp = true
			end
		end
		for type, v in pairs(player.esp or {}) do
			if v ~= 0 then
				esps_compare[type] = esps_compare[type] or {}
				esps_compare[type][2] = v
				any_esp = true
			end
		end
		if any_esp then
			text = compare_fields(player, actor_to_compare, "esp_range", "%d", "%+.0f")
			if text then
				self:mouseTooltip(self.TOOLTIP_ESP_RANGE,  s:drawColorStringBlended(self.font, ("感知范围：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
			end
		end

		-- player.forbid_arcane
		-- player.exp_mod
		-- player.can_breath[]

		h = 0
		w = self.w * 0.5

		s:drawColorStringBlended(self.font, "#LIGHT_BLUE#属性：       基础值/当前值", w, h, 255, 255, 255, true) h = h + self.font_h

		local print_stat = function(stat, name, tooltip)
			local StatVal = player:getStat(stat, nil, nil, true)
			local StatTxt = ""
			text = compare_fields(player, actor_to_compare, function(actor) return actor:getStat(stat, nil, nil, true) end, "", "%+.0f", 1, false, true)
			local text2 = compare_fields(player, actor_to_compare, function(actor) return actor:getStat(stat) end, "", "%+.0f", 1, false, true)

			local text3 = ("(%s / %s)"):format(text~="" and text or "0", text2~="" and text2 or "0")
			if text3 == "(0 / 0)" then
				text3 = ""
			end
			
			local stat_chn = ""
			
			if stat == 1 then stat_chn = "力量："
			elseif stat == 2 then stat_chn = "敏捷："
			elseif stat == 6 then stat_chn = "体质："
			elseif stat == 3 then stat_chn = "魔法："
			elseif stat == 4 then stat_chn = "意志："
			elseif stat == 5 then stat_chn = "灵巧："
			end
			
			if StatVal > player:getStat(stat) then
				StatTxt = stat_chn..(" #ff0000#%3d / %d#LAST#%s"):format(player:getStat(stat, nil, nil, true), player:getStat(stat), text3)
			else
				StatTxt = stat_chn..(" #00ff00#%3d / %d#LAST#%s"):format(player:getStat(stat, nil, nil, true), player:getStat(stat), text3)
			end

			self:mouseTooltip(tooltip, s:drawColorStringBlended(self.font, StatTxt, w, h, 255, 255, 255, true)) h = h + self.font_h
		end

		print_stat(self.actor.STAT_STR, ("%-12s"):format(Stats.stats_def[self.actor.STAT_STR].name:capitalize()), self.TOOLTIP_STR)
		print_stat(self.actor.STAT_DEX, ("%-12s"):format(Stats.stats_def[self.actor.STAT_DEX].name:capitalize()), self.TOOLTIP_DEX)
		print_stat(self.actor.STAT_CON, ("%-12s"):format(Stats.stats_def[self.actor.STAT_CON].name:capitalize()), self.TOOLTIP_CON)
		print_stat(self.actor.STAT_MAG, ("%-12s"):format(Stats.stats_def[self.actor.STAT_MAG].name:capitalize()), self.TOOLTIP_MAG)
		print_stat(self.actor.STAT_WIL, ("%-12s"):format(Stats.stats_def[self.actor.STAT_WIL].name:capitalize()), self.TOOLTIP_WIL)
		print_stat(self.actor.STAT_CUN, ("%-12s"):format(Stats.stats_def[self.actor.STAT_CUN].name:capitalize()), self.TOOLTIP_CUN)
		h = h + self.font_h

		local nb_inscriptions = 0
		for i = 1, player.max_inscriptions do if player.inscriptions[i] then nb_inscriptions = nb_inscriptions + 1 end end
		self:mouseTooltip(self.TOOLTIP_INSCRIPTIONS, s:drawColorStringBlended(self.font, ("#AQUAMARINE#纹身 (%d/%d)"):format(nb_inscriptions, player.max_inscriptions), w, h, 255, 255, 255, true)) h = h + self.font_h
		for i = 1, player.max_inscriptions do if player.inscriptions[i] then
			local t = player:getTalentFromId("T_"..player.inscriptions[i])
			local desc = player:getTalentFullDescription(t)
			self:mouseTooltip("#GOLD##{bold}#"..t.name.."#{normal}##WHITE#\n"..tostring(desc), s:drawColorStringBlended(self.font, ("#LIGHT_GREEN#%s"):format(t.name), w, h, 255, 255, 255, true)) h = h + self.font_h
		end end

		if any_esp then
			h = h + self.font_h
			self:mouseTooltip(self.TOOLTIP_ESP,  s:drawColorStringBlended(self.font, ("心灵感应: "), w, h, 255, 255, 255, true)) h = h + self.font_h
--			if not esps_compare["All"] then
			if not esps_compare["All"] or not esps_compare["All"][2] or esps_compare["All"][2] == 0 then
				for type, v in pairs(esps_compare) do
					self:mouseTooltip(self.TOOLTIP_ESP,  s:drawColorStringBlended(self.font, ("%s%s "):format(v[2] and (v[1] and "#GOLD#" or "#00ff00#") or "#ff0000#", type:capitalize()), w, h, 255, 255, 255, true)) h = h + self.font_h
				end
			else
--				self:mouseTooltip(self.TOOLTIP_ESP_ALL,  s:drawColorStringBlended(self.font, ("%sAll "):format(esps_compare["All"][1] and "#GOLD#" or "#00ff00#"), w, h, 255, 255, 255, true)) h = h + self.font_h
				self:mouseTooltip(self.TOOLTIP_ESP_ALL,  s:drawColorStringBlended(self.font, ("%sAll "):format(esps_compare["All"][2] and (esps_compare["All"][1] and "#GOLD#" or "#00ff00#") or "#ff0000#"), w, h, 255, 255, 255, true)) h = h + self.font_h
			end
		end

		h = 0
		w = self.w * 0.77
		s:drawColorStringBlended(self.font, "#LIGHT_BLUE#当前状态：", w, h, 255, 255, 255, true) h = h + self.font_h
		for tid, act in pairs(player.sustain_talents) do
			if act then
				local t = player:getTalentFromId(tid)
				local desc = "#GOLD##{bold}#"..t.name.."#{normal}##WHITE#\n"..tostring(player:getTalentFullDescription(t))
				self:mouseTooltip(desc, s:drawColorStringBlended(self.font, ("#LIGHT_GREEN#%s"):format(player:getTalentFromId(tid).name), w, h, 255, 255, 255, true)) h = h + self.font_h
			end
		end
		for eff_id, p in pairs(player.tmp) do
			local e = player.tempeffect_def[eff_id]
			--汉化
			local long_desc
			local name
				if effCHN[e.name] then
					name = effCHN[e.name].chName
					if effCHN[e.name].desc then long_desc = effCHN[e.name].desc 
					else long_desc = e.long_desc end
				else 
					name = e.desc
					long_desc = e.long_desc
			end
			local temp = long_desc
			if type(temp)=="string" then long_desc = function(a,b) return temp end end
			local desc = long_desc(player, p)
			if e.status == "detrimental" then
				self:mouseTooltip(desc, s:drawColorStringBlended(self.font, ("#LIGHT_RED#%s"):format(name), w, h, 255, 255, 255, true)) h = h + self.font_h
			else
				self:mouseTooltip(desc, s:drawColorStringBlended(self.font, ("#LIGHT_GREEN#%s"):format(name), w, h, 255, 255, 255, true)) h = h + self.font_h
			end
		end
	elseif kind=="attack" then
		h = 0
		w = 0
		
		local color
		local mainhand = player:getInven(player.INVEN_MAINHAND)
		if mainhand and (#mainhand > 0) and not player:attr("disarmed") then
			local WeaponTxt = "#LIGHT_BLUE#主手"
			if player:hasTwoHandedWeapon() then
				WeaponTxt = WeaponTxt.."(双手武器)"
			end
			WeaponTxt = WeaponTxt..":"

			for i, o in ipairs(player:getInven(player.INVEN_MAINHAND)) do
				local mean, dam = player:getObjectCombat(o, "mainhand"), player:getObjectCombat(o, "mainhand")
				local range
				if o.archery and mean then
					local ammo = player:getInven("QUIVER") and player:getInven("QUIVER")[1]
					if ammo and ammo.archery_ammo == o.archery then -- make sure ammo matches launcher
						dam = player:getObjectCombat(ammo, "mainhand")
						range = mean.range
					end
				end
				if mean and dam then
					s:drawColorStringBlended(self.font, WeaponTxt, w, h, 255, 255, 255, true) h = h + self.font_h
					text = compare_fields(player, actor_to_compare, function(actor, ...) return math.floor(actor:combatAttack(...)) end, "%3d", "%+.0f", 1, false, false, mean, dam)
					self:mouseTooltip(self.TOOLTIP_COMBAT_ATTACK, s:drawColorStringBlended(self.font, ("命中：    #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
					text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatDamage(...) end, "%3d", "%+.0f", 1, false, false, dam)
					self:mouseTooltip(self.TOOLTIP_COMBAT_DAMAGE, s:drawColorStringBlended(self.font, ("伤害：    #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
					text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatAPR(...) end, "%3d", "%+.0f", 1, false, false, dam)
					self:mouseTooltip(self.TOOLTIP_COMBAT_APR,    s:drawColorStringBlended(self.font, ("护甲穿透：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
					text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatCrit(...) end, "%3d%%", "%+.0f%%", 1, false, false, dam)
					self:mouseTooltip(self.TOOLTIP_COMBAT_CRIT,   s:drawColorStringBlended(self.font, ("暴击率：  #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
					color = 1/player:combatSpeed(mean)
					color = color >= 1 and "#LIGHT_GREEN#" or "#LIGHT_RED#"
					text = compare_fields(player, actor_to_compare, function(actor, ...) return 1/actor:combatSpeed(...) end, color.."%.1f%%", "%+.1f%%", 100, true, false, mean)
					self:mouseTooltip(self.TOOLTIP_COMBAT_SPEED,  s:drawColorStringBlended(self.font, ("速度：    #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
				end
				if range then
					self:mouseTooltip(self.TOOLTIP_COMBAT_RANGE, s:drawColorStringBlended(self.font, ("范围(主手)：#00ff00#%3d"):format(range), w, h, 255, 255, 255, true)) h = h + self.font_h
				end
			end
		-- Handle bare-handed combat
		else
			s:drawColorStringBlended(self.font, "#LIGHT_BLUE#徒手：", w, h, 255, 255, 255, true) h = h + self.font_h
			local mean, dam = player:getObjectCombat(nil, "barehand"), player:getObjectCombat(nil, "barehand")
			if mean and dam then
				text = compare_fields(player, actor_to_compare, function(actor, ...) return math.floor(actor:combatAttack(...)) end, "%3d", "%+.0f", 1, false, false, mean)
				self:mouseTooltip(self.TOOLTIP_COMBAT_ATTACK, s:drawColorStringBlended(self.font, ("命中：      #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
				text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatDamage(...) end, "%3d", "%+.0f", 1, false, false, dam)
				self:mouseTooltip(self.TOOLTIP_COMBAT_DAMAGE, s:drawColorStringBlended(self.font, ("伤害：      #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
				text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatAPR(...) end, "%3d", "%+.0f", 1, false, false, dam)
				self:mouseTooltip(self.TOOLTIP_COMBAT_APR,    s:drawColorStringBlended(self.font, ("护甲穿透：  #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
				text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatCrit(...) end, "%3d%%", "%+.0f%%", 1, false, false, dam)
				self:mouseTooltip(self.TOOLTIP_COMBAT_CRIT,   s:drawColorStringBlended(self.font, ("暴击率：    #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
				color = 1/player:combatSpeed(mean)
				color = color >= 1 and "#LIGHT_GREEN#" or "#LIGHT_RED#"
				text = compare_fields(player, actor_to_compare, function(actor, ...) return 1/actor:combatSpeed(...) end, color.."%.1f%%", "%+.1f%%", 100, false, false, mean)
				self:mouseTooltip(self.TOOLTIP_COMBAT_SPEED,  s:drawColorStringBlended(self.font, ("速度：      #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
			end
			if mean and mean.range then
				self:mouseTooltip(self.TOOLTIP_COMBAT_RANGE, s:drawColorStringBlended(self.font, ("范围(主手)：#00ff00#%3d"):format(mean.range), w, h, 255, 255, 255, true)) h = h + self.font_h
			end
		end

		h = h + self.font_h
		-- All weapons in off hands
		-- Offhand attacks are with a damage penalty, that can be reduced by talents
		if player:getInven(player.INVEN_OFFHAND) then
			for i, o in ipairs(player:getInven(player.INVEN_OFFHAND)) do
				local offmult = player:getOffHandMult(o.combat)
				local mean, dam = player:getObjectCombat(o, "offhand"), player:getObjectCombat(o, "offhand")
				if o.archery and mean then
					dam = (player:getInven("QUIVER") and player:getInven("QUIVER")[1] and player:getInven("QUIVER")[1].combat)
				end
				if mean and dam then
					s:drawColorStringBlended(self.font, "#LIGHT_BLUE#副手："..(player:attr("disarmed") and " (disabled)" or ""), w, h, 255, 255, 255, true) h = h + self.font_h
					text = compare_fields(player, actor_to_compare, function(actor, ...) return math.floor(actor:combatAttack(...)) end, "%3d", "%+.0f", 1, false, false, mean)
					self:mouseTooltip(self.TOOLTIP_COMBAT_ATTACK, s:drawColorStringBlended(self.font, ("命中：      #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
					text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatDamage(...) end, "%3d", "%+.0f", offmult, false, false, dam)
					self:mouseTooltip(self.TOOLTIP_COMBAT_DAMAGE, s:drawColorStringBlended(self.font, ("伤害：      #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
					text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatAPR(...) end, "%3d", "%+.0f", 1, false, false, dam)
					self:mouseTooltip(self.TOOLTIP_COMBAT_APR,    s:drawColorStringBlended(self.font, ("护甲穿透：  #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
					text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatCrit(...) end, "%3d%%", "%+.0f%%", 1, false, false, dam)
					self:mouseTooltip(self.TOOLTIP_COMBAT_CRIT,   s:drawColorStringBlended(self.font, ("暴击率：    #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
					color = 1/player:combatSpeed(mean)
					color = color >= 1 and "#LIGHT_GREEN#" or "#LIGHT_RED#"
					text = compare_fields(player, actor_to_compare, function(actor, ...) return 1/actor:combatSpeed(...) end, color.."%.1f%%", "%+.1f%%", 100, false, false, mean)
					self:mouseTooltip(self.TOOLTIP_COMBAT_SPEED,  s:drawColorStringBlended(self.font, ("速度：      #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
				end
				if mean and mean.range then self:mouseTooltip(self.TOOLTIP_COMBAT_RANGE, s:drawColorStringBlended(self.font, ("范围(副手)：#00ff00#%3d"):format(mean.range), w, h, 255, 255, 255, true)) h = h + self.font_h end
			end
		end

		-- player.combat_physcrit
		-- player.combat_mindcrit

		h = 0
		w = self.w * 0.25

		s:drawColorStringBlended(self.font, "#LIGHT_BLUE#魔法：", w, h, 255, 255, 255, true) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatSpellpower() end, "%3d", "%+.0f")
		self:mouseTooltip(self.TOOLTIP_SPELL_POWER, s:drawColorStringBlended(self.font, ("法术强度：  #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatSpellCrit() end, "%d%%", "%+.0f%%")
		self:mouseTooltip(self.TOOLTIP_SPELL_CRIT, s:drawColorStringBlended(self.font,  ("暴击率：    #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		color = 1/player:combatSpellSpeed()
		color = color >= 1 and "#LIGHT_GREEN#" or "#LIGHT_RED#"
		text = compare_fields(player, actor_to_compare, function(actor, ...) return 1/actor:combatSpellSpeed() end, color.."%.1f%%", "%+.1f%%", 100)
		self:mouseTooltip(self.TOOLTIP_SPELL_SPEED, s:drawColorStringBlended(self.font, ("施法速度：  #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return (1 - (actor.spell_cooldown_reduction or 0)) * 100 end, "%3d%%", "%+.0f%%", nil, true)
		self:mouseTooltip(self.TOOLTIP_SPELL_COOLDOWN  , s:drawColorStringBlended(self.font,   ("法术冷却： #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		h = h + self.font_h
		s:drawColorStringBlended(self.font, "#LIGHT_BLUE#精神属性：", w, h, 255, 255, 255, true) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatMindpower() end, "%3d", "%+.0f")
		dur_text = ("%d"):format(math.floor(player:combatMindpower()/5))
		self:mouseTooltip(self.TOOLTIP_MINDPOWER, s:drawColorStringBlended(self.font, ("精神强度：#00ff00#%s"):format(text, dur_text), w, h, 255, 255, 255, true)) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatMindCrit() end, "%d%%", "%+.0f%%")
		self:mouseTooltip(self.TOOLTIP_MIND_CRIT, s:drawColorStringBlended(self.font,  ("暴击率：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		color = 1/player:combatMindSpeed()
		color = color >= 1 and "#LIGHT_GREEN#" or "#LIGHT_RED#"
		text = compare_fields(player, actor_to_compare, function(actor, ...) return 1/actor:combatMindSpeed() end, color.."%.1f%%", "%+.1f%%", 100)
		self:mouseTooltip(self.TOOLTIP_MIND_SPEED, s:drawColorStringBlended(self.font, ("精神速度：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h

		h = 0
		w = self.w * 0.5

		s:drawColorStringBlended(self.font, "#LIGHT_BLUE#伤害加成：", w, h, 255, 255, 255, true) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return 150 + (actor.combat_critical_power or 0) end, "%3d%%", "%+.0f%%")
		self:mouseTooltip(self.TOOLTIP_INC_CRIT_POWER  , s:drawColorStringBlended(self.font,   ("暴击加成： #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h

		if player.inc_damage.all then
			text = compare_fields(player, actor_to_compare, function(actor, ...) return actor.inc_damage and actor.inc_damage.all or 0 end, "%3d%%", "%+.0f%%")
			self:mouseTooltip(self.TOOLTIP_INC_DAMAGE_ALL, s:drawColorStringBlended(self.font, ("伤害加成（全体）：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end

		local inc_damages = {}
		for i, t in pairs(DamageType.dam_def) do
			if player:combatHasDamageIncrease(DamageType[t.type]) then
				inc_damages[t] = inc_damages[t] or {}
				inc_damages[t][1] = player:combatGetDamageIncrease(DamageType[t.type])
			end
			if actor_to_compare and actor_to_compare:combatHasDamageIncrease(DamageType[t.type]) then
				inc_damages[t] = inc_damages[t] or {}
				inc_damages[t][2] = actor_to_compare:combatGetDamageIncrease(DamageType[t.type])
			end
		end

		for i, ts in pairs(inc_damages) do
			if ts[1] then
				if ts[2] and ts[2] ~= ts[1] then
					self:mouseTooltip(self.TOOLTIP_INC_DAMAGE, s:drawColorStringBlended(self.font, ("%s%-20s: #00ff00#%+d%%%s(%+.0f%%)"):format((i.text_color or "#WHITE#"), i.name.."#LAST# 伤害", ts[1], ts[2] > ts[1] and "#ff0000#" or "#00ff00#", ts[1] - ts[2] ), w, h, 255, 255, 255, true)) h = h + self.font_h
				else
					self:mouseTooltip(self.TOOLTIP_INC_DAMAGE, s:drawColorStringBlended(self.font, ("%s%-20s: #00ff00#%+d%%"):format((i.text_color or "#WHITE#"), i.name.."#LAST# 伤害", ts[1]), w, h, 255, 255, 255, true)) h = h + self.font_h
				end
			else
				if ts[2] then
					self:mouseTooltip(self.TOOLTIP_INC_DAMAGE, s:drawColorStringBlended(self.font, ("%s%-20s: #00ff00#%+d%%(%+.0f%%)"):format((i.text_color or "#WHITE#"), i.name.."#LAST# 伤害", (player.inc_damage.all or 0),(player.inc_damage.all or 0)-ts[2] ), w, h, 255, 255, 255, true)) h = h + self.font_h
				end
			end
		end

		local inc_damage_actor_types = {}
		if player.inc_damage_actor_type then
			for i, t in pairs(player.inc_damage_actor_type) do
				if player.inc_damage_actor_type[i] and player.inc_damage_actor_type[i] ~= 0 then
					inc_damage_actor_types[i] = inc_damage_actor_types[i] or {}
					inc_damage_actor_types[i][1] = player.inc_damage_actor_type[i]
				end
			end
		end
		if actor_to_compare and actor_to_compare.inc_damage_actor_type then
			for i, t in pairs(actor_to_compare.inc_damage_actor_type) do
				if actor_to_compare.inc_damage_actor_type[i] and actor_to_compare.inc_damage_actor_type[i] ~= 0 then
					inc_damage_actor_types[i] = inc_damage_actor_types[i] or {}
					inc_damage_actor_types[i][2] = actor_to_compare.inc_damage_actor_type[i]
				end
			end
		end
		for i, ts in pairs(inc_damage_actor_types) do
			if ts[1] then
				if ts[2] and ts[2] ~= ts[1] then
					self:mouseTooltip(self.TOOLTIP_INC_DAMAGE, s:drawColorStringBlended(self.font, ("#ORANGE#%-20s: #00ff00#%+d%%%s(%+.0f%%)"):format(i:capitalize().."#LAST# damage", ts[1], ts[2] > ts[1] and "#ff0000#" or "#00ff00#", ts[1] - ts[2] ), w, h, 255, 255, 255, true)) h = h + self.font_h
				else
					self:mouseTooltip(self.TOOLTIP_INC_DAMAGE, s:drawColorStringBlended(self.font, ("#ORANGE#%-20s: #00ff00#%+d%%"):format(i:capitalize().."#LAST# damage", ts[1]), w, h, 255, 255, 255, true)) h = h + self.font_h
				end
			else
				if ts[2] then
					self:mouseTooltip(self.TOOLTIP_INC_DAMAGE, s:drawColorStringBlended(self.font, ("#ORANGE#%-20s: #00ff00#%+d%%(%+.0f%%)"):format(i:capitalize().."#LAST# damage", 0,-ts[2] ), w, h, 255, 255, 255, true)) h = h + self.font_h
				end
			end
		end

		h = 0
		w = self.w * 0.75

		s:drawColorStringBlended(self.font, "#LIGHT_BLUE#伤害穿透：", w, h, 255, 255, 255, true) h = h + self.font_h

		if player.resists_pen.all then
			text = compare_fields(player, actor_to_compare, function(actor, ...) return actor.resists_pen and actor.resists_pen.all or 0 end, "%3d%%", "%+.0f%%")
			self:mouseTooltip(self.TOOLTIP_RESISTS_PEN_ALL, s:drawColorStringBlended(self.font, ("伤害穿透（全体）：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end

		local resists_pens = {}
		for i, t in pairs(DamageType.dam_def) do
			if player.resists_pen[DamageType[t.type]] and player.resists_pen[DamageType[t.type]] ~= 0 then
				resists_pens[t] = resists_pens[t] or {}
				resists_pens[t][1] = player.resists_pen[DamageType[t.type]]
			end
			if actor_to_compare and actor_to_compare.resists_pen[DamageType[t.type]] and actor_to_compare.resists_pen[DamageType[t.type]] ~= 0 then
				resists_pens[t] = resists_pens[t] or {}
				resists_pens[t][2] = actor_to_compare.resists_pen[DamageType[t.type]]
			end
		end

		for i, ts in pairs(resists_pens) do
			if ts[1] then
				if ts[2] and ts[2] ~= ts[1] then
					self:mouseTooltip(self.TOOLTIP_RESISTS_PEN, s:drawColorStringBlended(self.font, ("%s%-20s: #00ff00#%+d%%%s(%+.0f%%)"):format((i.text_color or "#WHITE#"), i.name.."#LAST# 伤害", ts[1] + (player.resists_pen.all or 0), ts[2] > ts[1] and "#ff0000#" or "#00ff00#", ts[1] - ts[2] ), w, h, 255, 255, 255, true)) h = h + self.font_h
				else
					self:mouseTooltip(self.TOOLTIP_RESISTS_PEN, s:drawColorStringBlended(self.font, ("%s%-20s: #00ff00#%+d%%"):format((i.text_color or "#WHITE#"), i.name.."#LAST# 伤害", ts[1] + (player.resists_pen.all or 0)), w, h, 255, 255, 255, true)) h = h + self.font_h
				end
			else
				if ts[2] then
					self:mouseTooltip(self.TOOLTIP_RESISTS_PEN, s:drawColorStringBlended(self.font, ("%s%-20s: #00ff00#%+d%%(%+.0f%%)"):format((i.text_color or "#WHITE#"), i.name.."#LAST# 伤害", (player.resists_pen.all or 0),-ts[2] ), w, h, 255, 255, 255, true)) h = h + self.font_h
				end
			end
		end

	elseif kind=="defence" then
		h = 0
		w = 0

		local ArmorTxt = "#LIGHT_BLUE#"
		if player:hasHeavyArmor() then
			ArmorTxt = ArmorTxt.."重甲"
		elseif player:hasMassiveArmor() then
			ArmorTxt = ArmorTxt.."板甲"
		else
			ArmorTxt = ArmorTxt.."轻甲"
		end

		ArmorTxt = ArmorTxt.."："

		s:drawColorStringBlended(self.font, ArmorTxt, w, h, 255, 255, 255, true) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatFatigue() end, "%3d%%", "%+.0f%%", 1, true)
		self:mouseTooltip(self.TOOLTIP_FATIGUE, s:drawColorStringBlended(self.font,           ("疲劳值        ： #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatArmorHardiness() end, "%3d%%", "%+.0f%%")
		self:mouseTooltip(self.TOOLTIP_ARMOR_HARDINESS,   s:drawColorStringBlended(self.font, ("护甲强度      ： #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatArmor() end, "%3d", "%+.0f")
		self:mouseTooltip(self.TOOLTIP_ARMOR,   s:drawColorStringBlended(self.font,           ("护甲值        ： #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatDefense(true) end, "%3d", "%+.0f")
		self:mouseTooltip(self.TOOLTIP_DEFENSE, s:drawColorStringBlended(self.font,           ("近身闪避      ： #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatDefenseRanged(true) end, "%3d", "%+.0f")
		self:mouseTooltip(self.TOOLTIP_RDEFENSE,s:drawColorStringBlended(self.font,           ("远程防御      ： #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:combatCritReduction()  end, "%d%%", "%+.0f%%")
		self:mouseTooltip(self.TOOLTIP_CRIT_REDUCTION,s:drawColorStringBlended(self.font,           ("暴击减免      ： #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return actor:attr("ignore_direct_crits") or 0 end, "%d%%", "%+.0f%%")
		self:mouseTooltip(self.TOOLTIP_CRIT_SHRUG,s:drawColorStringBlended(self.font,           ("暴击伤害减免    ： #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h

		h = h + self.font_h
		s:drawColorStringBlended(self.font, "#LIGHT_BLUE#豁免：", w, h, 255, 255, 255, true) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return math.floor(actor:combatPhysicalResist(true)) end, "%3d", "%+.0f")
		self:mouseTooltip(self.TOOLTIP_PHYS_SAVE,   s:drawColorStringBlended(self.font, ("物理豁免：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return math.floor(actor:combatSpellResist(true)) end, "%3d", "%+.0f")
		self:mouseTooltip(self.TOOLTIP_SPELL_SAVE,  s:drawColorStringBlended(self.font, ("法术豁免：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		text = compare_fields(player, actor_to_compare, function(actor, ...) return math.floor(actor:combatMentalResist(true)) end, "%3d", "%+.0f")
		self:mouseTooltip(self.TOOLTIP_MENTAL_SAVE, s:drawColorStringBlended(self.font, ("精神豁免：#00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h

		h = 0
		w = self.w * 0.25

		s:drawColorStringBlended(self.font, "#LIGHT_BLUE#抗性 基础 / 上限：", w, h, 255, 255, 255, true) h = h + self.font_h

		local resists = {}
		for i, t in pairs(DamageType.dam_def) do
			if player.resists[DamageType[t.type]] and player.resists[DamageType[t.type]] ~= 0 then
				resists[t] = resists[t] or {}
				resists[t][1] = player:combatGetResist(DamageType[t.type])
			end
			if actor_to_compare and actor_to_compare.resists[DamageType[t.type]] and actor_to_compare.resists[DamageType[t.type]] ~= 0 then
				resists[t] = resists[t] or {}
				resists[t][2] = actor_to_compare:combatGetResist(DamageType[t.type])
			end
		end

		if player.resists.all then
			text = compare_fields(player, actor_to_compare, function(actor, ...) return actor.resists.all end, "", "%+.0f%%", 1, false, true)
			local res_cap = compare_fields(player, actor_to_compare, function(actor, ...) return actor.resists_cap.all or 0 end, "", "%+.0f%%",  1, false, true)
			local res_text = ("(%s / %s)"):format(text ~= "" and text or "0", res_cap ~= "" and res_cap or "0")
			if res_text == "(0 / 0)" then
				res_text = ""
			end
			self:mouseTooltip(self.TOOLTIP_RESIST_ALL, s:drawColorStringBlended(self.font, ("%-10s: #00ff00#%3d%% / %d%%%s"):format("全体", player.resists.all, player.resists_cap.all or 0, res_text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end
		for i, t in pairs(DamageType.dam_def) do
			if player.resists[DamageType[t.type]] and player.resists[DamageType[t.type]] ~= 0 then
				self:mouseTooltip(self.TOOLTIP_RESIST, s:drawColorStringBlended(self.font, ("%s%-10s#LAST#: #00ff00#%3d%% / %d%%"):format((t.text_color or "#WHITE#"), t.name:capitalize(), player:combatGetResist(DamageType[t.type]), (player.resists_cap[DamageType[t.type]] or 0) + (player.resists_cap.all or 0)), w, h, 255, 255, 255, true)) h = h + self.font_h
			end
		end
		if player.resists_actor_type then
			for i, t in pairs(player.resists_actor_type) do
				if t and t ~= 0 then
					self:mouseTooltip(self.TOOLTIP_RESIST, s:drawColorStringBlended(self.font, ("#ORANGE#%-10s#LAST#: #00ff00#%3d%% / %d%%"):format(i:capitalize(), t, player.resists_cap_actor_type or 100), w, h, 255, 255, 255, true)) h = h + self.font_h
				end
			end
		end

		h = h + self.font_h
		s:drawColorStringBlended(self.font, "#LIGHT_BLUE#伤害吸收:", w, h, 255, 255, 255, true) h = h + self.font_h

		if player.damage_affinity.all then
			text = compare_fields(player, actor_to_compare, function(actor, ...) return actor.damage_affinity and actor.damage_affinity.all or 0 end, "%3d%%", "%+.0f%%")
			self:mouseTooltip(self.TOOLTIP_AFFINITY_ALL, s:drawColorStringBlended(self.font, ("全体伤害    : #00ff00#%s"):format(text), w, h, 255, 255, 255, true)) h = h + self.font_h
		end

		local damage_affinitys = {}
		for i, t in pairs(DamageType.dam_def) do
			if player.damage_affinity[DamageType[t.type]] and player.damage_affinity[DamageType[t.type]] ~= 0 then
				damage_affinitys[t] = damage_affinitys[t] or {}
				damage_affinitys[t][1] = player.damage_affinity[DamageType[t.type]]
			end
			if actor_to_compare and actor_to_compare.damage_affinity[DamageType[t.type]] and actor_to_compare.damage_affinity[DamageType[t.type]] ~= 0 then
				damage_affinitys[t] = damage_affinitys[t] or {}
				damage_affinitys[t][2] = actor_to_compare.damage_affinity[DamageType[t.type]]
			end
		end

		for i, ts in pairs(damage_affinitys) do
			if ts[1] then
				if ts[2] and ts[2] ~= ts[1] then
					self:mouseTooltip(self.TOOLTIP_AFFINITY, s:drawColorStringBlended(self.font, ("%s%-20s: #00ff00#%+d%%%s(%+.0f%%)"):format((i.text_color or "#WHITE#"), i.name:capitalize().."#LAST# 伤害", ts[1] + (player.damage_affinity.all or 0), ts[2] > ts[1] and "#ff0000#" or "#00ff00#", ts[1] - ts[2] ), w, h, 255, 255, 255, true)) h = h + self.font_h
				else
					self:mouseTooltip(self.TOOLTIP_AFFINITY, s:drawColorStringBlended(self.font, ("%s%-20s: #00ff00#%+d%%"):format((i.text_color or "#WHITE#"), i.name:capitalize().."#LAST# 伤害", ts[1] + (player.damage_affinity.all or 0)), w, h, 255, 255, 255, true)) h = h + self.font_h
				end
			else
				if ts[2] then
					self:mouseTooltip(self.TOOLTIP_AFFINITY, s:drawColorStringBlended(self.font, ("%s%-20s: #00ff00#%+d%%(%+.0f%%)"):format((i.text_color or "#WHITE#"), i.name:capitalize().."#LAST# 伤害", (player.damage_affinity.all or 0),-ts[2] ), w, h, 255, 255, 255, true)) h = h + self.font_h
				end
			end
		end

		h = 0
		w = self.w * 0.52

		s:drawColorStringBlended(self.font, "#LIGHT_BLUE#特效抗性：", w, h, 255, 255, 255, true) h = h + self.font_h


		immune_type = "poison_immune" immune_name =    "毒素     " if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end
		immune_type = "disease_immune" immune_name =   "疾病    " if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end
		immune_type = "cut_immune" immune_name =       "流血      " if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end
		immune_type = "confusion_immune" immune_name = "混乱  " if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end
		immune_type = "blind_immune" immune_name =     "致盲      " if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end
		immune_type = "silence_immune" immune_name =   "沉默    " if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end
		immune_type = "disarm_immune" immune_name =    "缴械     " if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end
		immune_type = "pin_immune" immune_name =       "定身    " if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end
		immune_type = "stun_immune" immune_name =      "震慑/冻结" if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end
		immune_type = "sleep_immune" immune_name =     "睡眠      " if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end
		immune_type = "fear_immune" immune_name =      "恐惧       " if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end
		immune_type = "knockback_immune" immune_name = "击退  " if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end
		immune_type = "stone_immune" immune_name =     "石化    " if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end
		immune_type = "instakill_immune" immune_name = "即死 " if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end
		immune_type = "teleport_immune" immune_name =  "传送   " if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end

		immune_type = "negative_status_effect_immune" immune_name =	"全体        " if player:attr(immune_type) then text = compare_fields(player, actor_to_compare, function(actor, ...) return util.bound((actor:attr(...) or 0) * 100, 0, 100) end, "%3d%%", "%+.0f%%", 1, false, false, immune_type) self:mouseTooltip(self.TOOLTIP_SPECIFIC_IMMUNE, s:drawColorStringBlended(self.font, ("%s: #00ff00#%s"):format(immune_name, text), w, h, 255, 255, 255, true)) h = h + self.font_h end

		h = 0
		w = self.w * 0.75

		s:drawColorStringBlended(self.font, "#LIGHT_BLUE#被击中后伤害反弹：", w, h, 255, 255, 255, true) h = h + self.font_h
		for i, t in pairs(DamageType.dam_def) do
			if player.on_melee_hit[DamageType[t.type]] and player.on_melee_hit[DamageType[t.type]] ~= 0 then
				local dval = player.on_melee_hit[DamageType[t.type]]
				if t.tdesc then
					dval = t.tdesc(dval)
					dval = itemDamagedesc(dval)
					self:mouseTooltip(self.TOOLTIP_ON_HIT_DAMAGE, s:drawColorStringBlended(self.font, ("%s"):format(dval), w, h, 255, 255, 255, true)) h = h + self.font_h
				else
					dval = Talents.damDesc(player, DamageType[t.type] ,type(dval) == "number" and dval or dval.dam)
					self:mouseTooltip(self.TOOLTIP_ON_HIT_DAMAGE, s:drawColorStringBlended(self.font, ("%s%-10s#LAST#: #00ff00#%.1f"):format((t.text_color or "#WHITE#"), t.name:capitalize(), dval), w, h, 255, 255, 255, true)) h = h + self.font_h

				end
			end
		end

		--player.combat_mentalresist

	elseif kind=="talents" then
		h = 0
		w = 0


		local function sort_talents()

			local talents = {}

			local get_group
			if self.talent_sorting == 1 then
				-- Get the group/display name for a given talent type
				get_group = function(t, tt)
					if tt.type:match("inscriptions/.*") then
						return "纹身"
					elseif tt.type:match("uber/.*") then
						return "觉醒"
					elseif tt.type:match(".*/objects") then
						return "物品技能"
					end

					local cat = tt.type:gsub("/.*", "")
					return (t_talent_cat[cat] or cat) .."/"..(tt.name or ""):bookCapitalize()
				end
			elseif self.talent_sorting == 2 then
				-- Alphabetically, so no groups at all.
				get_group = function(t, tt)
					return "技能"
				end
			else
				-- Sort by usage type/speed
				get_group = function(t, tt)
					if t.mode == "activated" then
						local no_energy = util.getval(t.no_energy, player, t)
						return no_energy and "瞬间" or "主动"
					else
						return t.mode:gsub("sustained","维持"):gsub("passive","被动")
					end
				end
			end

			-- Process the talents
			for j, t in pairs(player.talents_def) do
				if player:knowTalent(t.id) and (not t.hide or t.hide ~= "always") then
					local lvl = player:getTalentLevelRaw(t)
					local tt = player:getTalentTypeFrom(t.type[1])

					local data = {type_name = tt,
						talent = t,
						name = ("%s (%d)"):format(t.name, lvl),
						desc = player:getTalentFullDescription(t):toString(),
					}

					if self.talent_sorting == 2 then
						if not talents["All"] then
							talents["All"] = {type_name = "All", talent_type=nil, talents={} }
						end
						table.insert(talents["All"]["talents"], data)
					else
						local group_name = get_group(t, tt)

						if not talents[group_name] then
							talents[group_name] = {type_name = group_name, talent_type=tt, talents={}}
						end
						table.insert(talents[group_name]["talents"], data)
					end
				end
			end

			local sort_tt

			-- Decide what sorting method do use
			if self.talent_sorting == 1 then
				-- Sorting of talent groups, Racial/infusions first, then alphabetical order
				local sort_rank = {"race/.*", "Inscriptions", "Prodigies", "Item Talents"} -- Relies on the groups
				sort_tt = function(a, b)
					a, b = a["type_name"], b["type_name"]
					for i, v in ipairs(sort_rank) do
						local rank_a, rank_b
						rank_a = a:match(v)
						if not rank_a then
							rank_b = b:match(v)
							if rank_b then return false end
						else
							return true
						end
					end
					return a < b
				end
			elseif self.talent_sorting == 2 then
				-- Only care about alphabetically sorting
				sort_tt = function(a, b)
					return a.name < b.name end
			else
				-- instant > activated > sustained > passive > alphabetically
				local sort_rank = {"Instant", "Activated", "Sustained", "Passive" }
				sort_tt = function(a, b)
					a, b = a["type_name"], b["type_name"]
					for i, v in ipairs(sort_rank) do
						local rank_a, rank_b
						rank_a = a:match(v)
						if not rank_a then
							rank_b = b:match(v)
							if rank_b then return false end
						else
							return true
						end
					end
					return a < b
				end
			end
			-- Sort the talent type stuff
			local sorted = {}
			if self.talent_sorting == 2 then
				if not talents["All"] or not talents["All"]["talents"] then talents["All"] = {type_name = "All", talent_type=nil, talents={} } end
				table.sort(talents["All"]["talents"], sort_tt)
				return talents
			end
			for k, v in pairs(talents) do
				sorted[#sorted+1] = v
			end

			if self.talent_sorting == 2 then
				table.sort(sorted[1], sort_tt)
				return sorted
			else
				table.sort(sorted, sort_tt)
			end

			return sorted

		end

		local sorted = sort_talents()

		-- The color used to display it
		local function get_talent_color(t)
			if t.mode == "activated" then
				local no_energy = util.getval(t.no_energy, player, t)
				if no_energy == true then
					return "#00c91b##{italic}#"--return "#E56F48#"
				else
					return "#00c91b#"
				end
			elseif t.mode == "passive" then
				return "#LIGHT_STEEL_BLUE#"--return "#486FE5#"
			else --Sustains
				return "#C49600#"--return "#E5D848#"
			end
		end

		-- Now display it!
		for ts, tt in pairs(sorted) do
			-- Display talent type
			local tt_name = tt["type_name"]
			local talent_type_name = tt["talent_type"] and tt["talent_type"].description or tt_name or ""
			local talents = tt["talents"]
			if tt_name then
				self:mouseTooltip(talent_type_name, s:drawColorStringBlended(self.font, ("#{bold}##KHAKI#%s#{normal}#"):format(tt_name), w, h, 255, 255, 255, true)) h = h + self.font_h
			end

			-- Display the talents in the talent type
			for _, t in ipairs(talents) do
				self:mouseTooltip(t.desc, s:drawColorStringBlended(self.font, (get_talent_color(t.talent).."%s".."#{normal}#"):format(t.name), w, h, 255, 255, 255, true)) h = h + self.font_h

				if h + self.font_h >= self.c_desc.h then h = 0 w = w + self.c_desc.w / 6 end
			end
		-- Add extra space to seperate categories
		h = h + self.font_h
		end
	end

	self.c_desc:update()
	self.changed = false
end

function _M:dump()
	local player = self.actor

	fs.mkdir("/character-dumps")
	local file = "/character-dumps/"..(player.name:gsub("[^a-zA-Z0-9_-.]", "_")).."-"..os.date("%Y%m%d-%H%M%S")..".txt"
	local fff = fs.open(file, "w")
	local labelwidth = 17
	local nl = function(s) s = s or "" fff:write(s:removeColorCodes()) fff:write("\n") end
	local nnl = function(s) s = s or "" fff:write(s:removeColorCodes()) end
	--prepare label and value
	local makelabel = function(s,r) while s:len() < labelwidth do s = s.." " end return ("%s: %s"):format(s, r) end

	local cur_exp, max_exp = player.exp, player:getExpChart(player.level+1)
	nl("  [ToME4 @ www.te4.org Character Dump]")
	nl()

	nnl(("%-32s"):format(makelabel("Sex", (player.descriptor and player.descriptor.sex) or (player.female and "Female" or "Male"))))
	nl(("STR:  %d"):format(player:getStr()))

	nnl(("%-32s"):format(makelabel("Race", (player.descriptor and player.descriptor.subrace) or player.type:capitalize())))
	nl(("DEX:  %d"):format(player:getDex()))

	nnl(("%-32s"):format(makelabel("Class", (player.descriptor and player.descriptor.subclass) or player.subtype:capitalize())))
	nl(("MAG:  %d"):format(player:getMag()))

	nnl(("%-32s"):format(makelabel("Level", ("%d"):format(player.level))))
	nl(("WIL:  %d"):format(player:getWil()))

	nnl(("%-32s"):format(makelabel("Exp", ("%d%%"):format(100 * cur_exp / max_exp))))
	nl(("CUN:  %d"):format(player:getCun()))

	nnl(("%-32s"):format(makelabel("Gold", ("%.2f"):format(player.money))))
	nl(("CON:  %d"):format(player:getCon()))

	if player.died_times then
		nl(("Times died       : %d"):format(#player.died_times))
	end
	if player.easy_mode_lifes then
		nl(("Lifes left       : %d"):format(player.easy_mode_lifes))
	end

	 -- All weapons in main hands
	local strings = {}
	for i = 1, 6 do strings[i]="" end
	if player:getInven(player.INVEN_MAINHAND) then
		for i, o in ipairs(player:getInven(player.INVEN_MAINHAND)) do
			local mean, dam = o.combat, o.combat
			if o.archery and mean then
				dam = (player:getInven("QUIVER")[1] and player:getInven("QUIVER")[1].combat)
			end
			if mean and dam then
				strings[1] = ("Accuracy(Main Hand): %3d"):format(player:combatAttack(mean))
				strings[2] = ("Damage  (Main Hand): %3d"):format(player:combatDamage(dam))
				strings[3] = ("APR     (Main Hand): %3d"):format(player:combatAPR(dam))
				strings[4] = ("Crit    (Main Hand): %3d%%"):format(player:combatCrit(dam))
				strings[5] = ("Speed   (Main Hand): %0.2f"):format(player:combatSpeed(mean))
			end
			if mean and mean.range then strings[6] = ("Range (Main Hand): %3d"):format(mean.range) end
		end
	end
	--Unarmed??
	if player:isUnarmed() then
		local mean, dam = player.combat, player.combat
		if mean and dam then
			strings[1] = ("Accuracy(Unarmed): %3d"):format(player:combatAttack(mean))
			strings[2] = ("Damage  (Unarmed): %3d"):format(player:combatDamage(dam))
			strings[3] = ("APR     (Unarmed): %3d"):format(player:combatAPR(dam))
			strings[4] = ("Crit    (Unarmed): %3d%%"):format(player:combatCrit(dam))
			strings[5] = ("Speed   (Unarmed): %0.2f"):format(player:combatSpeed(mean))
		end
		if mean and mean.range then strings[6] = ("Range (Unarmed): %3d"):format(mean.range) end
	end

	local enc, max = player:getEncumbrance(), player:getMaxEncumbrance()

	nl()
	nnl(("%-32s"):format(strings[1]))
	nnl(("%-32s"):format(makelabel("Life", ("    %d/%d"):format(player.life, player.max_life))))
	nl(makelabel("Encumbrance", enc .. "/" .. max))

	nnl(("%-32s"):format(strings[2]))
	if player:knowTalent(player.T_STAMINA_POOL) then
		nnl(("%-32s"):format(makelabel("Stamina", ("    %d/%d"):format(player:getStamina(), player.max_stamina))))
	else
		 nnl(("%-32s"):format(" "))
	end
	nl(makelabel("Difficulty", (player.descriptor and player.descriptor.difficulty) or "???"))
	nl(makelabel("Permadeath", (player.descriptor and player.descriptor.permadeath) or "???"))

	nnl(("%-32s"):format(strings[3]))
	if player:knowTalent(player.T_MANA_POOL) then
		nl(makelabel("Mana", ("    %d/%d"):format(player:getMana(), player.max_mana)))
	else
		nl()
	end
	nnl(("%-32s"):format(strings[4]))
	if player:knowTalent(player.T_POSITIVE_POOL) then
		nl(makelabel("Positive", ("    %d/%d"):format(player:getPositive(), player.max_positive)))
	else
		nl()
	end
	nnl(("%-32s"):format(strings[5]))
	if player:knowTalent(player.T_NEGATIVE_POOL) then
		nl(makelabel("Negative", ("    %d/%d"):format(player:getNegative(), player.max_negative)))
	else
		nl()
	end
	nnl(("%-32s"):format(strings[6]))
	if player:knowTalent(player.T_VIM_POOL) then
		nl(makelabel("Vim", ("    %d/%d"):format(player:getVim(), player.max_vim)))
	else
		nl()
	end
	nnl(("%-32s"):format(""))
	if player:knowTalent(player.T_EQUILIBRIUM_POOL) then
		nl((makelabel("Equilibrium", ("    %d"):format(player:getEquilibrium()))))
	else
		nl()
	end
	nnl(("%-32s"):format(""))
	if player:knowTalent(player.T_PARADOX_POOL) then
		nl((makelabel("Paradox", ("    %d"):format(player:getParadox()))))
	else
		nl()
	end

	-- All weapons in off hands
	-- Offhand attacks are with a damage penalty, that can be reduced by talents
	if player:getInven(player.INVEN_OFFHAND) then
		for i, o in ipairs(player:getInven(player.INVEN_OFFHAND)) do
			local offmult = player:getOffHandMult(o.combat)
			local mean, dam = o.combat, o.combat
			if o.archery and mean then
				dam = (player:getInven("QUIVER")[1] and player:getInven("QUIVER")[1].combat)
			end
			if mean and dam then
				nl()
				nl(("Accuracy(Off Hand): %3d"):format(player:combatAttack(mean)))
				nl(("Damage  (Off Hand): %3d"):format(player:combatDamage(dam) * offmult))
				nl(("APR     (Off Hand): %3d"):format(player:combatAPR(dam)))
				nl(("Crit    (Off Hand): %3d%%"):format(player:combatCrit(dam)))
				nl(("Speed   (Off Hand): %0.2f"):format(player:combatSpeed(mean)))
			end
			if mean and mean.range then strings[6] = ("Range (Off Hand): %3d"):format(mean.range) end
		end
	end

	nl()
	nnl(("%-32s"):format(makelabel("Fatigue", player:combatFatigue() .. "%")))
	nl(makelabel("Spellpower", player:combatSpellpower() ..""))
	nnl(("%-32s"):format(makelabel("Armor", player:combatArmor() .. "")))
	nl(makelabel("Spell Crit", player:combatSpellCrit() .."%"))
	nnl(("%-32s"):format(makelabel("Armor Hardiness", player:combatArmorHardiness() .. "%")))
	nl(makelabel("Spell Speed", player:combatSpellSpeed() ..""))
	nnl(("%-32s"):format(makelabel("Defense", player:combatDefense(true) .. "")))
	nl()
	nnl(("%-32s"):format(makelabel("Ranged Defense", player:combatDefenseRanged(true) .. "")))

	nl()
	if player.inc_damage.all then nl(makelabel("All damage", player.inc_damage.all.."%")) end
	for i, t in ipairs(DamageType.dam_def) do
		if player.inc_damage[DamageType[t.type]] and player.inc_damage[DamageType[t.type]] ~= 0 then
			nl(makelabel(t.name:capitalize().." damage", (player.inc_damage[DamageType[t.type]] + (player.inc_damage.all or 0)).."%"))
		end
	end

	nl()
	nl(makelabel("Physical Save",player:combatPhysicalResist(true) ..""))
	nl(makelabel("Spell Save",player:combatSpellResist(true) ..""))
	nl(makelabel("Mental Save",player:combatMentalResist(true) ..""))

	nl()
	if player.resists.all then nl(("All Resists: %3d%%"):format(player.resists.all, player.resists_cap.all or 0)) end
	for i, t in ipairs(DamageType.dam_def) do
		if player.resists[DamageType[t.type]] and player.resists[DamageType[t.type]] ~= 0 then
			nl(("%s Resist(cap): %3d%%(%3d%%)"):format(t.name:capitalize(), player:combatGetResist(DamageType[t.type]), (player.resists_cap[DamageType[t.type]] or 0) + (player.resists_cap.all or 0)))
		end
	end

	immune_type = "poison_immune" immune_name = "Poison Resistance" if player:attr(immune_type) then nl(("%s: %3d%%"):format(immune_name, util.bound(player:attr(immune_type) * 100, 0, 100))) end
	immune_type = "disease_immune" immune_name = "Disease Resistance" if player:attr(immune_type) then nl(("%s: %3d%%"):format(immune_name, util.bound(player:attr(immune_type) * 100, 0, 100))) end
	immune_type = "cut_immune" immune_name = "Bleed Resistance" if player:attr(immune_type) then nl(("%s: %3d%%"):format(immune_name, util.bound(player:attr(immune_type) * 100, 0, 100))) end
	immune_type = "confusion_immune" immune_name = "Confusion Resistance" if player:attr(immune_type) then nl(("%s: %3d%%"):format(immune_name, util.bound(player:attr(immune_type) * 100, 0, 100))) end
	immune_type = "blind_immune" immune_name = "Blind Resistance" if player:attr(immune_type) then nl(("%s: %3d%%"):format(immune_name, util.bound(player:attr(immune_type) * 100, 0, 100))) end
	immune_type = "silence_immune" immune_name = "Silence Resistance" if player:attr(immune_type) then nl(("%s: %3d%%"):format(immune_name, util.bound(player:attr(immune_type) * 100, 0, 100))) end
	immune_type = "disarm_immune" immune_name = "Disarm Resistance" if player:attr(immune_type) then nl(("%s: %3d%%"):format(immune_name, util.bound(player:attr(immune_type) * 100, 0, 100))) end
	immune_type = "pin_immune" immune_name = "Pinning Resistance" if player:attr(immune_type) then nl(("%s: %3d%%"):format(immune_name, util.bound(player:attr(immune_type) * 100, 0, 100))) end
	immune_type = "stun_immune" immune_name = "Stun Resistance" if player:attr(immune_type) then nl(("%s: %3d%%"):format(immune_name, util.bound(player:attr(immune_type) * 100, 0, 100))) end
	immune_type = "sleep_immune" immune_name = "Sleep Resistance" if player:attr(immune_type) then nl(("%s: %3d%%"):format(immune_name, util.bound(player:attr(immune_type) * 100, 0, 100))) end
	immune_type = "fear_immune" immune_name = "Fear Resistance" if player:attr(immune_type) then nl(("%s: %3d%%"):format(immune_name, util.bound(player:attr(immune_type) * 100, 0, 100))) end
	immune_type = "knockback_immune" immune_name = "Knockback Resistance" if player:attr(immune_type) then nl(("%s: %3d%%"):format(immune_name, util.bound(player:attr(immune_type) * 100, 0, 100))) end
	immune_type = "stone_immune" immune_name = "Stoning Resistance" if player:attr(immune_type) then nl(("%s: %3d%%"):format(immune_name, util.bound(player:attr(immune_type) * 100, 0, 100))) end
	immune_type = "instakill_immune" immune_name = "Instadeath Resistance" if player:attr(immune_type) then nl(("%s: %3d%%"):format(immune_name, util.bound(player:attr(immune_type) * 100, 0, 100))) end
	immune_type = "teleport_immune" immune_name = "Teleport Resistance" if player:attr(immune_type) then nl(("%s: %3d%%"):format(immune_name, util.bound(player:attr(immune_type) * 100, 0, 100))) end

	nl()
	local most_kill, most_kill_max = "none", 0
	local total_kill = 0
	for name, nb in pairs(player.all_kills or {}) do
		if nb > most_kill_max then most_kill_max = nb most_kill = name end
		total_kill = total_kill + nb
	end
	nl(("Number of NPC killed: %s"):format(total_kill))
	nl(("Most killed NPC: %s (%d)"):format(most_kill, most_kill_max))

	if player.winner then
		nl()
		nl("  [Winner!]")
		nl()
		for i, line in ipairs(player.winner_text) do
			nl(("%s"):format(line:removeColorCodes()))
		end
	end

	-- Talents
	nl()
	nl("  [Talents Chart]")
	nl()
	for i, tt in ipairs(player.talents_types_def) do
		 local ttknown = player:knowTalentType(tt.type)
		if not (player.talents_types[tt.type] == nil) and ttknown then
			local cat = tt.type:gsub("/.*", "")
			local catname = ("%s / %s"):format(cat:capitalize(), tt.name:capitalize())
			nl((" - %-35s(mastery %.02f)"):format(catname, player:getTalentTypeMastery(tt.type)))

			-- Find all talents of this school
			if (ttknown) then
				for j, t in ipairs(tt.talents) do
					if not t.hide then
						local typename = "class"
						if t.generic then typename = "generic" end
						local skillname = ("    %s (%s)"):format(t.name, typename)
						nl(("%-37s %d/%d"):format(skillname, player:getTalentLevelRaw(t.id), t.points))
					end
				end
			end
		end
	end

	-- Inscriptions
	local nb_inscriptions = 0
	for i = 1, player.max_inscriptions do if player.inscriptions[i] then nb_inscriptions = nb_inscriptions + 1 end end
	nl()
	nl(("  [Inscriptions (%d/%d)]"):format(nb_inscriptions, player.max_inscriptions))
	nl()
	for i = 1, player.max_inscriptions do if player.inscriptions[i] then
		local t = player:getTalentFromId("T_"..player.inscriptions[i])
		local desc = player:getTalentFullDescription(t)
		nl(("%s"):format(t.name))
	end end

	 -- Current Effects

	 nl()
	 nl("  [Current Effects]")
	 nl()

	for tid, act in pairs(player.sustain_talents) do
		if act then nl("- "..player:getTalentFromId(tid).name)	end
	end
	for eff_id, p in pairs(player.tmp) do
		local e = player.tempeffect_def[eff_id]
		if e.status == "detrimental" then
			 nl("+ "..e.desc)
		else
			 nl("- "..e.desc)
		end
	end

	-- Quests, Active and Completed

	local first = true
	for id, q in pairs(game.party.quests or {}) do
		if q:isEnded() then
			if first then
					nl()
					nl("  [Completed Quests]")
					nl()
					first=false
			end
			nl(" -- ".. q.name)
			nl(q:desc(game.party):gsub("#.-#", "   "))
		end
	end

	 first=true
	for id, q in pairs(game.party.quests or {}) do
		if not q:isEnded() then
			if first then
					first=false
					nl()
					nl("  [Active Quests]")
					nl()
				end
			nl(" -- ".. q.name)
			nl(q:desc(game.party):gsub("#.-#", "   "))
		end
	end


	--All Equipment
	nl()
	nl("  [Character Equipment]")
	nl()
	local index = 0
	for inven_id =  1, #player.inven_def do
		if player.inven[inven_id] and player.inven_def[inven_id].is_worn then
			nl((" %s"):format(player.inven_def[inven_id].name))

			for item, o in ipairs(player.inven[inven_id]) do
				if not self.filter or self.filter(o) then
					local char = string.char(string.byte('a') + index)
					nl(("%s) %s"):format(char, o:getName{force_id=true}))
					nl(("   %s"):format(tostring(o:getTextualDesc())))
					if o.droppedBy then
						nl(("   Dropped by %s"):format(o.droppedBy))
					end
					index = index + 1
				end
			end
		end
	end

	nl()
	nl("  [Player Achievements]")
	nl()
	local achs = {}
	for id, data in pairs(player.achievements or {}) do
		local a = world:getAchievementFromId(id)
		achs[#achs+1] = {id=id, data=data, name=a.name}
	end
	table.sort(achs, function(a, b) return a.name < b.name end)
	for i, d in ipairs(achs) do
		local a = world:getAchievementFromId(d.id)
		nl(("'%s' was achieved for %s At %s"):format(a.name, a.desc, d.data.when))
	end

	nl()
	nl("  [Character Inventory]")
	nl()
	for item, o in ipairs(player:getInven("INVEN")) do
		if not self.filter or self.filter(o) then
			local char = " "
			if item < 26 then string.char(string.byte('a') + item - 1) end
			nl(("%s) %s"):format(char, o:getName{force_id=true}))
			nl(("   %s"):format(tostring(o:getTextualDesc())))
			if o.droppedBy then
				nl(("   Dropped by %s"):format(o.droppedBy))
			end
		end
	end

	nl()
	nl("  [Last Messages]")
	nl()

	nl(table.concat(game.uiset.logdisplay:getLines(40), "\n"):removeColorCodes())

	fff:close()

	Dialog:simplePopup("Character dump complete", "File: "..fs.getRealPath(file))
end

