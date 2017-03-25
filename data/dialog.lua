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
local KeyBind = require "engine.KeyBind"
local Base = require "engine.ui.Base"
local Particles = require "engine.Particles"

--- A generic UI Dialog
-- @classmod engine.ui.Dialog
module(..., package.seeall, class.inherit(Base))

function _M:simpleWaiter(title, text, width, count, max)
	if simpleWaiterDlg and simpleWaiterDlg[title] then
		title,text = simpleWaiterDlg[title](text)
	end
	width = width or 400

	local _, th = self.font:size(title)
	local d = new(title, 1, 1)
	local max_h = 9999
	local textzone = require("engine.ui.Textzone").new{width=width+10, auto_height=true, scrollbar=true, text=text}
	if textzone.h > max_h then textzone.h = max_h
	else textzone.scrollbar = nil
	end
	local wait = require("engine.ui.Waiter").new{size=width, known_max=max}
	d:loadUI{
		{left = 3, top = 3, ui=textzone},
		{left = 3, bottom = 3, ui=wait},
	}
	d:setupUI(true, true)

	d.done = function(self) game:unregisterDialog(self) end
	d.timeout = function(self, secs, cb) wait:setTimeout(secs, function() cb() local done = self.done self.done = function()end done(self) end) end
	d.manual = function(self, ...) wait:manual(...) end
	d.manualStep = function(self, ...) wait:manualStep(...) end

	game:registerDialog(d)

	core.wait.enable(count, wait:getWaitDisplay(d))

	return d
end

--- Requests a simple waiter dialog
function _M:simpleWaiterTip(title, text, tip, width, count, max)
	if not tip then return self:simpleWaiter(title, text, width, count, max) end

	width = width or 400

	local _, th = self.font:size(title)
	local d = new(title, 1, 1)
	local wait = require("engine.ui.Waiter").new{size=width, known_max=max}
	local textzone = require("engine.ui.Textzone").new{width=wait.w, auto_height=true, scrollbar=false, text=text}
	local tipzone = require("engine.ui.Textzone").new{width=wait.w, auto_height=true, scrollbar=false, text=tip}
	local split = require("engine.ui.Separator").new{dir="vertical", size=wait.w - 12}
	d:loadUI{
		{left = 3, top = 3, ui=textzone},
		{left = 3+6, top = 3+textzone.h, ui=split},
		{left = 3, top = 3+textzone.h+split.h, ui=tipzone},
		{left = 3, bottom = 3, ui=wait},
	}
	d:setupUI(true, true)

	d.done = function(self) game:unregisterDialog(self) end
	d.timeout = function(self, secs, cb) wait:setTimeout(secs, function() cb() local done = self.done self.done = function()end done(self) end) end
	d.manual = function(self, ...) wait:manual(...) end
	d.manualStep = function(self, ...) wait:manualStep(...) end

	game:registerDialog(d)

	core.wait.enable(count, wait:getWaitDisplay(d))

	return d
end

--- Requests a simple, press any key, dialog
function _M:listPopup(title, text, list, w, h, fct)
	if title== "Blighted Path" then 
		title = "枯萎之路" 
		text = "选择一项用途："
		list[1].name=list[1].name:gsub("Attack for","攻击造成"):gsub("blight damage","枯萎伤害")
		list[2].name=list[2].name:gsub("Restore","恢复"):gsub("vim","活力")
	end
	local d = new(title, 1, 1)
	local desc = require("engine.ui.Textzone").new{width=w, auto_height=true, text=text, scrollbar=true}
	local l = require("engine.ui.List").new{width=w, height=h-16 - desc.h, list=list, fct=function() d.key:triggerVirtual("ACCEPT") end}
	d:loadUI{
		{left = 3, top = 3, ui=desc},
		{left = 3, top = 3 + desc.h + 3, ui=require("engine.ui.Separator").new{dir="vertical", size=w - 12}},
		{left = 3, bottom = 3, ui=l},
	}
	d.key:addBind("EXIT", function() if fct then fct() end game:unregisterDialog(d) end)
	d.key:addBind("ACCEPT", function() if list[l.sel].fct then list[l.sel].fct(list[l.sel]) return end if fct then fct(list[l.sel]) end game:unregisterDialog(d) end)
	d:setFocus(l)
	d:setupUI(true, true)
	game:registerDialog(d)
	return d
end

--- Requests a simple, press any key, dialog
function _M:simplePopup(title, text, fct, no_leave, any_leave)
	if simplePopDlg and simplePopDlg[title] then
		title,text = simplePopDlg[title](text)
	end
	local chn_w = utf8:new(text)
	local w = chn_w:len()*16
	local _, h = self.font:size(text)
	local d = new(title, 1, 1)
	d:loadUI{{left = 3, top = 3, ui=require("engine.ui.Textzone").new{width=w+10, height=h+5, text=text}}}
	if not no_leave then
		d.key:addBind("EXIT", function() game:unregisterDialog(d) if fct then fct() end end)
		if any_leave then d.key:addCommand("__DEFAULT", function() game:unregisterDialog(d) if fct then fct() end end) end
		local close = require("engine.ui.Button").new{text="关闭", fct=function() d.key:triggerVirtual("EXIT") end}
		d:loadUI{no_reset=true, {hcenter = 0, bottom = 3, ui=close}}
		d:setFocus(close)
	end
	d:setupUI(true, true)
	game:registerDialog(d)
	return d
end

--- Requests a simple, press any key, dialog
function _M:simpleLongPopup(title, text, w, fct, no_leave, force_height)
	if simpleLongDlg and simpleLongDlg[title] then
		title,text = simpleLongDlg[title](text)
	end
	local list = text:splitLines(w - 10, self.font)
	local _, th = self.font:size(title)
	local d = new(title, 1, 1)
	local max_h = force_height and force_height * game.h or 9999
	local textzone = require("engine.ui.Textzone").new{width=w+10, auto_height=true, scrollbar=true, text=text}
	if textzone.h > max_h then textzone.h = max_h
	else textzone.scrollbar = nil
	end
	d:loadUI{{left = 3, top = 3, ui=textzone}}
	if not no_leave then
		d.key:addBind("EXIT", function() game:unregisterDialog(d) if fct then fct() end end)
		local close = require("engine.ui.Button").new{text="关闭", fct=function() d.key:triggerVirtual("EXIT") end}
		d:loadUI{no_reset=true, {hcenter = 0, bottom = 3, ui=close}}
		d:setFocus(close)
	end
	d:setupUI(true, true)
	game:registerDialog(d)
	return d
end

--- Requests a simple yes-no dialog
function _M:yesnoPopup(title, text, fct, yes_text, no_text, no_leave, escape, preexit_fct)
	local my_yes_text, my_no_text = nil, nil
	if yesnoPopDlg and yesnoPopDlg[title] then
		title,text,my_yes_text,my_no_text = yesnoPopDlg[title](text)
	end
	yes_text = my_yes_text or yes_text
	no_text = my_no_text or no_text
	if title:find("Demon Statue of ") then
		local _, f = string.find(title, "Demon Statue of ")
		local ts = title:sub(f + 1, string.len(title))
		if ts == "a forge giant" then
			title = "一个锻造巨人的恶魔雕像"
		elseif ts:sub(1, 2) == "a " then
			title = "一个" .. npcCHN:getName(ts:sub(3, string.len(ts) ) ) .. "的恶魔雕像"
		elseif ts:sub(1, 3) == "an " then
			title = "一个" .. npcCHN:getName(ts:sub(4, string.len(ts) ) ) .. "的恶魔雕像"
		elseif ts:sub(1, 4) == "the " then
			title = npcCHN:getName(ts:sub(5, string.len(ts) ) ) .. "的恶魔雕像"
		else
			title = npcCHN:getName(ts) .. "的恶魔雕像"
		end
		text = "你#{strong}#确定#{normal}#要触摸它么？#" 
		yes_text = "否"
		no_text = "是"
	end
	if text=="Are you sure you want to target yourself?" then text = "你确定要以自己为目标释放技能？"  yes_text = "否" no_text = "是" end
	local w, h = self.font:size(text)
	local d = new(title, 1, 1)

--	d.key:addBind("EXIT", function() game:unregisterDialog(d) fct(false) end)
	local ok = require("engine.ui.Button").new{text=yes_text or "是", fct=function() if preexit_fct then preexit_fct(true) end game:unregisterDialog(d) fct(true) end}
	local cancel = require("engine.ui.Button").new{text=no_text or "否", fct=function() if preexit_fct then preexit_fct(false) end game:unregisterDialog(d) fct(false) end}
	if not no_leave then d.key:addBind("EXIT", function() if preexit_fct then preexit_fct(escape) end game:unregisterDialog(d) game:unregisterDialog(d) fct(escape) end) end
	d:loadUI{
		{left = 3, top = 3, ui=require("engine.ui.Textzone").new{width=w+20, height=h+5, text=text}},
		{left = 3, bottom = 3, ui=ok},
		{right = 3, bottom = 3, ui=cancel},
	}
	d:setFocus(ok)
	d:setupUI(true, true)

	game:registerDialog(d)
	return d
end

--- Requests a long yes-no dialog
function _M:yesnoLongPopup(title, text, w, fct, yes_text, no_text, no_leave, escape, preexit_fct)
	local my_yes_text, my_no_text = nil, nil
	if yesnoLongPopDlg and yesnoLongPopDlg[title] then
		title,text,my_yes_text,my_no_text = yesnoLongPopDlg[title](text)
	end
	yes_text = my_yes_text or yes_text
	no_text = my_no_text or no_text
	local d
	local ok = require("engine.ui.Button").new{text=yes_text or "Yes", fct=function() if preexit_fct then preexit_fct(true) end game:unregisterDialog(d) fct(true) end}
	local cancel = require("engine.ui.Button").new{text=no_text or "No", fct=function() if preexit_fct then preexit_fct(false) end game:unregisterDialog(d) fct(false) end}

	w = math.max(w + 20, ok.w + cancel.w + 10)

	d = new(title, w + 6, 1)


--	d.key:addBind("EXIT", function() game:unregisterDialog(d) fct(false) end)
	if not no_leave then d.key:addBind("EXIT", function() if preexit_fct then preexit_fct(escape) end game:unregisterDialog(d) fct(escape) end) end
	d:loadUI{
		{left = 3, top = 3, ui=require("engine.ui.Textzone").new{width=w, auto_height = true, text=text}},
		{left = 3, bottom = 3, ui=ok},
		{right = 3, bottom = 3, ui=cancel},
	}
	d:setFocus(ok)
	d:setupUI(false, true)

	game:registerDialog(d)
	return d
end

--- Requests a simple yes-no dialog
function _M:yesnocancelPopup(title, text, fct, yes_text, no_text, cancel_text, no_leave, escape, preexit_fct)
	if yesnocancelPopDlg and yesnocancelPopDlg[title] then
		title,text = yesnocancelPopDlg[title](text)
	end
	--local w, h = self.font:size(text)
	local w, h = 200, 50
	local d = new(title, 1, 1)

--	d.key:addBind("EXIT", function() game:unregisterDialog(d) fct(false) end)
	local ok = require("engine.ui.Button").new{text=yes_text or "是", fct=function() if preexit_fct then preexit_fct(true, false) end game:unregisterDialog(d) fct(true, false) end}
	local no = require("engine.ui.Button").new{text=no_text or "否", fct=function() if preexit_fct then preexit_fct(false, false) end game:unregisterDialog(d) fct(false, false) end}
	local cancel = require("engine.ui.Button").new{text=cancel_text or "取消", fct=function() if preexit_fct then preexit_fct(false, true) end game:unregisterDialog(d) fct(false, true) end}
	if not no_leave then d.key:addBind("EXIT", function() if preexit_fct then preexit_fct(false, not escape) end game:unregisterDialog(d) fct(false, not escape) end) end
	d:loadUI{
		{left = 3, top = 3, ui=require("engine.ui.Textzone").new{width=w+20, height=h + 5, text=text}},
		{left = 3, bottom = 3, ui=ok},
		{left = 3 + ok.w, bottom = 3, ui=no},
		{right = 3, bottom = 3, ui=cancel},
	}
	d:setFocus(ok)
	d:setupUI(true, true)

	game:registerDialog(d)
	return d
end

--- Requests a simple yes-no dialog
function _M:yesnocancelLongPopup(title, text, w, fct, yes_text, no_text, cancel_text, no_leave, escape, preexit_fct)
	local d = new(title, 1, 1)

--	d.key:addBind("EXIT", function() game:unregisterDialog(d) fct(false) end)
	local ok = require("engine.ui.Button").new{text=yes_text or "Yes", fct=function() if preexit_fct then preexit_fct(true, false) end game:unregisterDialog(d) fct(true, false) end}
	local no = require("engine.ui.Button").new{text=no_text or "No", fct=function() if preexit_fct then preexit_fct(false, false) end game:unregisterDialog(d) fct(false, false) end}
	local cancel = require("engine.ui.Button").new{text=cancel_text or "Cancel", fct=function() if preexit_fct then preexit_fct(false, true) end game:unregisterDialog(d) fct(false, true) end}
	if not no_leave then d.key:addBind("EXIT", function() game:unregisterDialog(d) if preexit_fct then preexit_fct(false, not escape) end game:unregisterDialog(d) fct(false, not escape) end) end
	d:loadUI{
		{left = 3, top = 3, ui=require("engine.ui.Textzone").new{width=w+20, auto_height=true, text=text}},
		{left = 3, bottom = 3, ui=ok},
		{left = 3 + ok.w, bottom = 3, ui=no},
		{right = 3, bottom = 3, ui=cancel},
	}
	d:setFocus(ok)
	d:setupUI(true, true)

	game:registerDialog(d)
	return d
end

--- Requests a multiple-choice dialog, with a button for each choice
-- @param title = text at top of dialog box
-- @param text = message to display inside the box
-- @param button_list = ordered table of button choices {choice1=, choice2=, ....}
-- 		each choice: {name=<button text>, fct=<optional function(choice) to run on selection>, more vars...}
-- @param choice_fct = function(choice) to handle the button pressed (if choice.fct is not defined)
-- @param w, h = width and height of the dialog (in pixels, optional: dialog sized to its elements by default)
-- @param no_leave set true to force a selection
-- @param escape = the default choice (number) to select if escape is pressed
function _M:multiButtonPopup(title, text, button_list, w, h, choice_fct, no_leave, escape)
	escape = escape or 1
	-- compute display limits
	local max_w, max_h = w or game.w*.75, h or game.h*.75

	-- use tex params to place text
	local text_w, text_h = self.font:size(text)
	local tex, text_lines, text_width = self.font:draw(text, (w or max_w)*.9, 255, 255, 255, false, true)
	local text_height = text_lines*text_h+5
	local button_spacing = 10
	
	local d = new(title, w or 1, h or 1)
--print(("[multiButtonPopup] initialized: (w:%s,h:%s), (maxw:%s,maxh:%s) "):format(w, h, max_w, max_h))
	if not no_leave then d.key:addBind("EXIT", function() game:unregisterDialog(d) game:unregisterDialog(d) choice_fct(button_list[escape]) end) end

	local num_buttons = math.min(#button_list, 50)
	local buttons, buttons_width, button_height = {}, 0, 0

	-- build list of buttons
	for i = 1, num_buttons do
		local b = require("engine.ui.Button").new{text=button_list[i].name,
			fct=function()
				print("[multiButtonPopup] button pressed:", i, button_list[i].name) table.print(button_list[i])
				game:unregisterDialog(d)
				if button_list[i].fct then button_list[i].fct(button_list[i])
				elseif choice_fct then choice_fct(button_list[i])
				end
			end}
		buttons[i] = b
		buttons_width = buttons_width + b.w
		button_height = math.max(button_height, b.h)
	end

	local rows_threshold = (buttons_width + (num_buttons - 1)*button_spacing)*1.1/math.ceil((buttons_width + (num_buttons - 1)*button_spacing)/max_w)
	local rows = {{buttons_width=0}}
	local left, top, nrow = 5, 0, #rows
	local max_buttons_width = 0
	-- assign buttons to rows, evenly distributed
	for i = 1, num_buttons do
		left = left + buttons[i].w + button_spacing
		buttons_width = buttons_width - buttons[i].w
		if left >= max_w or left > rows_threshold then -- add a row
			rows[nrow].left = left
			left = 5 + buttons[i].w + button_spacing
			table.insert(rows, {buttons_width=0})
			nrow = #rows
		end
		table.insert(rows[nrow], buttons[i])
		rows[nrow].buttons_width = rows[nrow].buttons_width + buttons[i].w
		max_buttons_width = math.max(max_buttons_width, rows[nrow].buttons_width+button_spacing*(#rows[nrow]-1))
	end
	-- if needed, compute the actual dialog size
	local width = w or math.min(max_w, math.max(text_width + 20, max_buttons_width + 20))
	local height = h or math.min(max_h, text_height + 10 + nrow*button_height)
	local uis = {
		{left = (width - text_width)/2, top = 3, ui=require("engine.ui.Textzone").new{width=text_width, height=text_height, text=text}}
	}
	-- actually place the buttons in the dialog
	top = math.max(text_height, text_height + (height - text_height - nrow*button_height - 5)/2)
	for i, row in ipairs(rows) do
		left = (width - row.buttons_width - (#row - 1)*button_spacing)/2
		top = top + button_height
		if top > max_h - button_height - d.iy then break end -- cut off buttons that trail out of bounds
		for j, button in ipairs(row) do
			uis[#uis+1] = {left=left, top=top, ui=button}
			left = left + button.w + button_spacing
		end
	end
	d:loadUI(uis)
	if uis[escape + 1] then d:setFocus(uis[escape + 1]) end
	d:setupUI(not w, not h)
	game:registerDialog(d)
	return d
end

function _M:webPopup(url)
	local d = new(url, game.w * 0.9, game.h * 0.9)
	local w = require("engine.ui.WebView").new{width=d.iw, height=d.ih, url=url, allow_downloads={addons=true, modules=true}}
	if w.unusable then return nil end
	local b = require("engine.ui.ButtonImage").new{no_decoration=true, alpha_unfocus=0.5, file="copy-icon.png", fct=function()
		if w.cur_url then
			local url = w.cur_url:gsub("%?_te4&", "?"):gsub("%?_te4", ""):gsub("&_te4", "")
			core.key.setClipboard(url)
			print("[WEBVIEW] url copy", url)
			self:simplePopup("Copy URL", "URL copied to your clipboard.")
		end
	end}
	w.on_title = function(title) d:updateTitle(title) end
	d:loadUI{
		{left=0, top=-b.h / 2, ui=b},
		{left=0, top=0, ui=w},
	}
	d:setupUI()
	d.key:addBind("EXIT", function() game:unregisterDialog(d) end)
	game:registerDialog(d)
	return d
end


title_shadow = true

function _M:init(title, w, h, x, y, alpha, font, showup, skin)
	self.title = title
	self.alpha = self.alpha or 255
	if showup ~= nil then
		self.__showup = showup
	else
		self.__showup = 2
	end
	self.color = self.color or {r=255, g=255, b=255}
	if skin then self.ui = skin end
	if not self.ui_conf[self.ui] then self.ui = "metal" end

	local conf = self.ui_conf[self.ui]
	self.frame = self.frame or {
		b7 = "ui/dialogframe_7.png",
		b8 = "ui/dialogframe_8.png",
		b9 = "ui/dialogframe_9.png",
		b1 = "ui/dialogframe_1.png",
		b2 = "ui/dialogframe_2.png",
		b3 = "ui/dialogframe_3.png",
		b4 = "ui/dialogframe_4.png",
		b6 = "ui/dialogframe_6.png",
		b5 = "ui/dialogframe_5.png",
		shadow = conf.frame_shadow,
		a = conf.frame_alpha or 1,
		darkness = conf.frame_darkness or 1,
		dialog_h_middles = conf.dialog_h_middles,
		dialog_v_middles = conf.dialog_v_middles,
		particles = table.clone(conf.particles, true),
	}
	self.frame.ox1 = self.frame.ox1 or conf.frame_ox1
	self.frame.ox2 = self.frame.ox2 or conf.frame_ox2
	self.frame.oy1 = self.frame.oy1 or conf.frame_oy1
	self.frame.oy2 = self.frame.oy2 or conf.frame_oy2

	if self.frame.dialog_h_middles then
		local t = type(self.frame.dialog_h_middles) == "table" and table.clone(self.frame.dialog_h_middles) or {}
		table.merge(t, self.dialog_h_middles_alter or {})
		self.frame.b8 = t.b8 or "ui/dialogframe_8_middle.png"
		self.frame.b8l = t.b8l or "ui/dialogframe_8_left.png"
		self.frame.b8r = t.b8r or "ui/dialogframe_8_right.png"
		self.frame.b2 = t.b2 or "ui/dialogframe_2_middle.png"
		self.frame.b2l = t.b2l or "ui/dialogframe_2_left.png"
		self.frame.b2r = t.b2r or "ui/dialogframe_2_right.png"
	end

	self.particles = {}

	self.frame.title_x = 0
	self.frame.title_y = 0
	if conf.title_bar then
		self.frame.title_x = conf.title_bar.x
		self.frame.title_y = conf.title_bar.y
		self.frame.title_w = conf.title_bar.w
		self.frame.title_h = conf.title_bar.h
		self.frame.b7 = self.frame.b7:gsub("dialogframe", "title_dialogframe")
		self.frame.b8 = self.frame.b8:gsub("dialogframe", "title_dialogframe")
		self.frame.b9 = self.frame.b9:gsub("dialogframe", "title_dialogframe")
	end

	self.uis = {}
	self.ui_by_ui = {}
	self.focus_ui = nil
	self.focus_ui_id = 0

	self.force_x = x
	self.force_y = y

	self.first_display = true

	Base.init(self, {}, true)

	self:resize(w, h, true)
end

function _M:resize(w, h, nogen)
	local gamew, gameh = core.display.size()
	self.w, self.h = math.floor(w), math.floor(h)
	self.display_x = math.floor(self.force_x or (gamew - self.w) / 2)
	self.display_y = math.floor(self.force_y or (gameh - self.h) / 2)
	if self.title then
		self.ix, self.iy = 5, 8 + 3 + self.font_bold_h
		self.iw, self.ih = w - 2 * 5, h - 8 - 8 - 3 - self.font_bold_h
	else
		self.ix, self.iy = 5, 8
		self.iw, self.ih = w - 2 * 5, h - 8 - 8
	end

--	self.display_x = util.bound(self.display_x, 0, game.w - (self.w+self.frame.ox2))
--	self.display_y = util.bound(self.display_y, 0, game.h - (self.h+self.frame.oy2))

	if not nogen then self:generate() end
end

function _M:generate()
	local gamew, gameh = core.display.size()

	self.frame.w = self.w - self.frame.ox1 + self.frame.ox2
	self.frame.h = self.h - self.frame.oy1 + self.frame.oy2

	self.b7 = self:getUITexture(self.frame.b7)
	self.b9 = self:getUITexture(self.frame.b9)
	self.b1 = self:getUITexture(self.frame.b1)
	self.b3 = self:getUITexture(self.frame.b3)
	self.b8 = self:getUITexture(self.frame.b8)
	self.b4 = self:getUITexture(self.frame.b4)
	self.b2 = self:getUITexture(self.frame.b2)
	self.b6 = self:getUITexture(self.frame.b6)
	self.b5 = self:getUITexture(self.frame.b5)

	if self.frame.dialog_h_middles then
		self.b8l = self:getUITexture(self.frame.b8l)
		self.b8r = self:getUITexture(self.frame.b8r)
		self.b2l = self:getUITexture(self.frame.b2l)
		self.b2r = self:getUITexture(self.frame.b2r)
	end

	self.overs = {}
	for i, o in ipairs(self.frame.overlays or {}) do
		local ov = self:getUITexture(o.image)
		if o.gen then
			o.gen(ov, self)
		else
			ov.x = o.x
			ov.y = o.y
			ov.a = o.a
		end
		self.overs[#self.overs+1] = ov
	end

	self:updateTitle(self.title)

	self.mouse:allowDownEvent(true)
	if self.absolute then
		self.mouse:registerZone(0, 0, gamew, gameh, function(button, x, y, xrel, yrel, bx, by, event) self:mouseEvent(button, x, y, xrel, yrel, bx - self.display_x, by - self.display_y, event) end)
	else
		self.mouse:registerZone(0, 0, gamew, gameh, function(button, x, y, xrel, yrel, bx, by, event) if button == "left" and event == "button" then  self.key:triggerVirtual("EXIT") end end)
		self.mouse:registerZone(self.display_x + self.frame.ox1, self.display_y + self.frame.ox2, self.frame.w, self.frame.h, function(...) self:no_focus() end)
		self.mouse:registerZone(self.display_x, self.display_y, self.w, self.h, function(...) self:mouseEvent(...) end)
	end
	self.key.receiveKey = function(_, ...) self:keyEvent(...) end
	self.key:addCommands{
		_TAB = function() self:moveFocus(1) end,
		_UP = function() self:moveFocus(-1) end,
		_DOWN = function() self:moveFocus(1) end,
		_LEFT = function() self:moveFocus(-1) end,
		_RIGHT = function() self:moveFocus(1) end,
	}
	self.key:addBind("SCREENSHOT", function() if type(game) == "table" and game.key then game.key:triggerVirtual("SCREENSHOT") end end)
end

function _M:updateTitle(title)
	if not title then return end
	local title = title
	if type(title)=="function" then title = title() end
	self.font_bold:setStyle("bold")
	self.title_tex = self:drawFontLine(self.font_bold, title)
	self.font_bold:setStyle("normal")
end

function _M:loadUI(t)
	if not t.no_reset then
		self.uis = {}
		self.ui_by_ui = {}
		self.focus_ui = nil
		self.focus_ui_id = 0
	end
	for i, ui in ipairs(t) do
		self.uis[#self.uis+1] = ui
		self.ui_by_ui[ui.ui] = ui

		if not self.focus_ui and ui.ui.can_focus then
			self:setFocus(i)
		elseif ui.ui.can_focus then
			ui.ui:setFocus(false)
		end
	end
end

function _M:setupUI(resizex, resizey, on_resize, addmw, addmh)
	local gamew, gameh = core.display.size()
	local mw, mh = nil, nil

	local padding = 3 -- to not glue stuff to each other

--	resizex, resizey = true, true
	local nw, nh
	if resizex or resizey then
		mw, mh = 0, 0
		local addw, addh = 0, 0

		for i, ui in ipairs(self.uis) do
			if not ui.absolute then
				if ui.top and type(ui.top) == "table" then ui.top = self.ui_by_ui[ui.top].top + self.ui_by_ui[ui.top].ui.h + padding end
				if ui.bottom and type(ui.bottom) == "table" then ui.bottom = self.ui_by_ui[ui.bottom].bottom + self.ui_by_ui[ui.bottom].ui.h + padding end
				if ui.left and type(ui.left) == "table" then ui.left = self.ui_by_ui[ui.left].left + self.ui_by_ui[ui.left].ui.w + padding end
				if ui.right and type(ui.right) == "table" then ui.right = self.ui_by_ui[ui.right].right + self.ui_by_ui[ui.right].ui.w + padding end
				
				if not ui.ignore_size then
					if ui.top then mh = math.max(mh, ui.top + ui.ui.h + (ui.padding_h or 0))
					elseif ui.bottom then addh = math.max(addh, ui.bottom + ui.ui.h + (ui.padding_h or 0))
					end

					if ui.left then mw = math.max(mw, ui.left + ui.ui.w + (ui.padding_w or 0))
					elseif ui.right then addw = math.max(addw, ui.right + ui.ui.w + (ui.padding_w or 0))
					end
				end
			end
		end
		mw = mw + addw + 5 * 2 + (addmw or 0) + padding

		local tw, th = 0, 0
		if self.title then tw, th = self.font_bold:size(self.title) end
		mw = math.max(tw + 6, mw)

		mh = mh + addh + 5 + 22 + 3 + (addmh or 0) + th + padding

		if on_resize then on_resize(resizex and mw or self.w, resizey and mh or self.h) end
		nw, nh = resizex and mw or self.w, resizey and mh or self.h
	else
		if on_resize then on_resize(self.w, self.h) end
		nw, nh = self.w, self.h
	end

	local disx = math.floor(self.force_x or (gamew - nw) / 2)
	local disy = math.floor(self.force_y or (gameh - nh) / 2)
	if self.no_offscreen == "bottom" then if disy + nh >= gameh then self.force_y = gameh - nh end
	elseif self.no_offscreen == "top" then if disy + nh < 0 then self.force_y = 0 end
	elseif self.no_offscreen == "right" then if disx + nw >= gamew then self.force_x = gamew - nw end
	elseif self.no_offscreen == "left" then if disx + nw < 0 then self.force_x = 0 end
	end
	self:resize(nw, nh)

	for i, ui in ipairs(self.uis) do
		local ux, uy

		if not ui.absolute then
			ux, uy = self.ix, self.iy

			-- At first, calculate ALL dependencies
			if ui.top and type(ui.top) == "table" then ui.top = self.ui_by_ui[ui.top].y - self.iy + ui.top.h + padding end
			if ui.bottom and type(ui.bottom) == "table" then
				local top = self.ui_by_ui[ui.bottom].y - self.iy  -- top of ui.bottom
				ui.bottom = self.ih - top + padding
			end
			if ui.vcenter and type(ui.vcenter) == "table" then
				local vcenter = self.ui_by_ui[ui.vcenter].y + ui.vcenter.h
				ui.vcenter = math.floor(vcenter - self.ih / 2)
			end

			if ui.left and type(ui.left) == "table" then ui.left = self.ui_by_ui[ui.left].x - self.ix + ui.left.w + padding end
			if ui.right and type(ui.right)== "table" then
				local left = self.ui_by_ui[ui.right].x - self.ix -- left of ui.right
				ui.right = self.iw - left + padding
			end
			if ui.hcenter and type(ui.hcenter) == "table" then
				local hcenter = self.ui_by_ui[ui.hcenter].x - self.ix + ui.hcenter.w / 2
				ui.hcenter = math.floor(hcenter - self.iw / 2)
			end
			if ui.hcenter_left and type(ui.hcenter_left) == "table" then  -- I still have no idea what that does
				ui.hcenter_left = self.ui_by_ui[ui.hcenter_left].x + ui.hcenter_left.w
			end

			local regenerate = false
			if ui.calc_width then
				if ui.left and ui.right then
					ui.ui.w = self.iw - (ui.right + ui.left)
				elseif ui.left and ui.hcenter then
					ui.ui.w = self.iw + 2 * (ui.hcenter - ui.left)
				elseif ui.hcenter and ui.right then
					ui.ui.w = self.iw + 2 * (-ui.hcenter - ui.right)
				end
				regenerate = true
			end
			if ui.calc_height then
				if ui.top and ui.bottom then
					ui.ui.h = self.ih - (ui.bottom + ui.top)
				elseif ui.top and ui.vcenter then
					ui.ui.h = self.ih + 2 * (ui.vcenter - ui.top)
				elseif ui.vcenter and ui.bottom then
					ui.ui.h = self.ih + 2 * (-ui.vcenter - ui.bottom)
				end
				regenerate = true
			end
			if regenerate then
				ui.ui:generate()
			end


			if ui.top then
				uy = uy + ui.top
			elseif ui.bottom then
				uy = uy + self.ih - ui.bottom - ui.ui.h
			elseif ui.vcenter then
				uy = uy + math.floor(self.ih / 2) + ui.vcenter - ui.ui.h / 2
			end

			if ui.left then 
				ux = ux + ui.left
			elseif ui.right then
				ux = ux + self.iw - ui.right - ui.ui.w
			elseif ui.hcenter then
				ux = ux + math.floor(self.iw / 2) + ui.hcenter - ui.ui.w / 2
			elseif ui.hcenter_left then
				ux = ux + math.floor(self.iw / 2) + ui.hcenter_left
			end
		else
			ux, uy = 0, 0

			if ui.top then uy = uy + ui.top
			elseif ui.bottom then uy = uy + game.h - ui.bottom - ui.ui.h
			elseif ui.vcenter then uy = uy + math.floor(game.h / 2) + ui.vcenter - ui.ui.h / 2 end

			if ui.left then ux = ux + ui.left
			elseif ui.right then ux = ux + game.w - ui.right - ui.ui.w
			elseif ui.hcenter then ux = ux + math.floor(game.w / 2) + ui.hcenter - ui.ui.w / 2 end

			ux = ux - self.display_x
			uy = uy - self.display_y
		end

		ui.x = ux
		ui.y = uy
		ui.ui.mouse.delegate_offset_x = ux
		ui.ui.mouse.delegate_offset_y = uy
		ui.ui:positioned(ux, uy, self.display_x + ux, self.display_y + uy)
	end

	self.setuped = true
end

function _M:replaceUI(oldui, newui)
	for i, ui in ipairs(self.uis) do
		if ui.ui == oldui then
			ui.ui = newui
			ui.ui.mouse.delegate_offset_x = ui.x
			ui.ui.mouse.delegate_offset_y = ui.y
			ui.ui:positioned(ui.x, ui.y, self.display_x + ui.x, self.display_y + ui.y)
		end
	end
end

function _M:setFocus(id, how)
	if type(id) == "table" then
		for i = 1, #self.uis do
			if self.uis[i].ui == id then id = i break end
		end
		if type(id) == "table" then self:no_focus() return end
	end

	local ui = self.uis[id]
	if self.focus_ui == ui then return end
	if self.focus_ui and (self.focus_ui.ui.can_focus or (self.focus_ui.ui.can_focus_mouse and how=="mouse")) then self.focus_ui.ui:setFocus(false) end
	if not ui.ui.can_focus then self:no_focus() return end
	self.focus_ui = ui
	self.focus_ui_id = id
	ui.ui:setFocus(true)
	self:on_focus(id, ui)
end

function _M:moveUIElement(id, left, right, top, bottom)
	if type(id) == "table" then
		for i = 1, #self.uis do
			if self.uis[i].ui == id then id = i break end
		end
		if type(id) == "table" then return end
	end

	self.uis[id].left = left or self.uis[id].left
	self.uis[id].right = right or self.uis[id].right
	self.uis[id].top = top or self.uis[id].top
	self.uis[id].bottom = bottom or self.uis[id].bottom
end

function _M:getUIElement(id)
	if type(id) == "table" then
		for i = 1, #self.uis do
			if self.uis[i].ui == id then id = i break end
		end
		if type(id) == "table" then return end
	end

	return self.uis[id]
end

function _M:toggleDisplay(ui, show)
	if not self.ui_by_ui[ui] then return end
	self.ui_by_ui[ui].hidden = not show
end

function _M:moveFocus(v)
	local id = self.focus_ui_id
	local start = id or 1
	local cnt = 0
	id = util.boundWrap((id or 1) + v, 1, #self.uis)
	while start ~= id and cnt <= #self.uis do
		if self.uis[id] and self.uis[id].ui and self.uis[id].ui.can_focus and not self.uis[id].ui.no_keyboard_focus then
			self:setFocus(id)
			break
		end
		id = util.boundWrap(id + v, 1, #self.uis)
		cnt = cnt + 1
	end
end

function _M:on_focus(id, ui)
end
function _M:no_focus()
end

function _M:mouseEvent(button, x, y, xrel, yrel, bx, by, event)
	-- Look for focus
	for i = 1, #self.uis do
		local ui = self.uis[i]
		if (ui.ui.can_focus or ui.ui.can_focus_mouse) and bx >= ui.x and bx <= ui.x + ui.ui.w and by >= ui.y and by <= ui.y + ui.ui.h then
			self:setFocus(i, "mouse")

			-- Pass the event
			ui.ui.mouse:delegate(button, bx, by, xrel, yrel, bx, by, event)
			return
		end
	end
	self:no_focus()
end

function _M:keyEvent(...)
	if not self.focus_ui or not self.focus_ui.ui.key:receiveKey(...) then
		KeyBind.receiveKey(self.key, ...)
	end
end
function _M:display() end

--- This does nothing and can be changed by other classes
function _M:unload()
end

--- This provides required cleanups, do not touch
function _M:cleanup()
	for p, _ in pairs(self.particles) do p:dieDisplay() end

	for i = 1, #self.uis do
		if self.uis[i].ui and self.uis[i].ui.on_dialog_cleanup then self.uis[i].ui:on_dialog_cleanup() end
	end
end

function _M:drawFrame(x, y, r, g, b, a)
	x = x + self.frame.ox1
	y = y + self.frame.oy1

	-- Sides
	if self.frame.dialog_h_middles then
		local mw = math.floor(self.frame.w / 2)
		local b8hw = math.floor(self.b8.w / 2)
		self.b8l.t:toScreenFull(x + self.b7.w, y, mw - self.b7.w - b8hw, self.b8l.h, self.b8l.tw, self.b8l.th, r, g, b, a)
		self.b8r.t:toScreenFull(x + mw + b8hw, y, mw - self.b9.w - b8hw, self.b8r.h, self.b8r.tw, self.b8r.th, r, g, b, a)
		self.b8.t:toScreenFull(x + mw - b8hw, y, self.b8.w, self.b8.h, self.b8.tw, self.b8.th, r, g, b, a)

		local b2hw = math.floor(self.b2.w / 2)
		self.b2l.t:toScreenFull(x + self.b1.w, y + self.frame.h - self.b3.h, mw - self.b1.w - b2hw, self.b2l.h, self.b2l.tw, self.b2l.th, r, g, b, a)
		self.b2r.t:toScreenFull(x + mw + b2hw, y + self.frame.h - self.b3.h, mw - self.b3.w - b2hw, self.b2r.h, self.b2r.tw, self.b2r.th, r, g, b, a)
		self.b2.t:toScreenFull(x + mw - b2hw, y + self.frame.h - self.b3.h, self.b2.w, self.b2.h, self.b2.tw, self.b2.th, r, g, b, a)
	else
		self.b8.t:toScreenFull(x + self.b7.w, y, self.frame.w - self.b7.w - self.b9.w, self.b8.h, self.b8.tw, self.b8.th, r, g, b, a)
		self.b2.t:toScreenFull(x + self.b7.w, y + self.frame.h - self.b3.h, self.frame.w - self.b7.w - self.b9.w, self.b2.h, self.b2.tw, self.b2.th, r, g, b, a)
	end
	self.b4.t:toScreenFull(x, y + self.b7.h, self.b4.w, self.frame.h - self.b7.h - self.b1.h, self.b4.tw, self.b4.th, r, g, b, a)
	self.b6.t:toScreenFull(x + self.frame.w - self.b9.w, y + self.b7.h, self.b6.w, self.frame.h - self.b7.h - self.b1.h, self.b6.tw, self.b6.th, r, g, b, a)

	-- Corners
	self.b1.t:toScreenFull(x, y + self.frame.h - self.b1.h, self.b1.w, self.b1.h, self.b1.tw, self.b1.th, r, g, b, a)
	self.b7.t:toScreenFull(x, y, self.b7.w, self.b7.h, self.b7.tw, self.b7.th, r, g, b, a)
	self.b9.t:toScreenFull(x + self.frame.w - self.b9.w, y, self.b9.w, self.b9.h, self.b9.tw, self.b9.th, r, g, b, a)
	self.b3.t:toScreenFull(x + self.frame.w - self.b3.w, y + self.frame.h - self.b3.h, self.b3.w, self.b3.h, self.b3.tw, self.b3.th, r, g, b, a)

	-- Body
	self.b5.t:toScreenFull(x + self.b7.w, y + self.b7.h, self.frame.w - self.b7.w - self.b3.w , self.frame.h - self.b7.h - self.b3.h, self.b5.tw, self.b5.th, r, g, b, a)

	-- Overlays
	for i = 1, #self.overs do
		local ov = self.overs[i]
		ov.t:toScreenFull(x + ov.x, y + ov.y, ov.w , ov.h, ov.tw, ov.th, r, g, b, a * ov.a)
	end

	if self.frame.particles then
		for i, pdef in ipairs(self.frame.particles) do
			if rng.chance(pdef.chance) then
				local p = Particles.new(pdef.name, 1, pdef.args)
				local pos = {x=0, y=0}
				if pdef.position.base == 7 then
					pos.x = pdef.position.ox
					pos.y = pdef.position.oy
				elseif pdef.position.base == 9 then
					pos.x = self.w + pdef.position.ox + self.b9.w
					pos.y = pdef.position.oy
				elseif pdef.position.base == 1 then
					pos.x = pdef.position.ox
					pos.y = self.h + pdef.position.oy + self.b1.h
				elseif pdef.position.base == 3 then
					pos.x = self.w + pdef.position.ox + self.b3.w
					pos.y = self.h + pdef.position.oy + self.b3.h
				end
				self.particles[p] = pos
			end
		end
	end

	if next(self.particles) then
		for p, pos in pairs(self.particles) do
			if p.ps:isAlive() then
				p.ps:toScreen(x + pos.x, y + pos.y, true, 1)
			else
				self.particles[p] = nil
			end
		end
	end
end

function _M:innerDisplayBack(x, y, nb_keyframes)
end
function _M:innerDisplay(x, y, nb_keyframes)
end

function _M:firstDisplay()
end

function _M:setTitleShadowShader(shader, power)
	self.shadow_shader = shader
	self.shadow_power = power
end

function _M:toScreen(x, y, nb_keyframes)
	if self.__hidden then return end

	local shader = self.shadow_shader

	local zoom = 1
	if self.__showup then
		local eff = self.__showup_effect or "pop"
		if eff == "overpop" then
			zoom = self.__showup / 7
			if self.__showup >= 9 then
				zoom = (9 - (self.__showup - 9)) / 7 - 1
				zoom = 1 + zoom * 0.5
			end
			self.__showup = self.__showup + nb_keyframes
			if self.__showup >= 11 then self.__showup = nil end
		else
			zoom = self.__showup / 7
			self.__showup = self.__showup + nb_keyframes
			if self.__showup >= 7 then self.__showup = nil end
		end
	end

	-- We translate and scale opengl matrix to make the popup effect easily
	local ox, oy = x, y
	local hw, hh = math.floor(self.w / 2), math.floor(self.h / 2)
	local tx, ty = x + hw, y + hh
	x, y = -hw, -hh
	core.display.glTranslate(tx, ty, 0)
	if zoom < 1 then core.display.glScale(zoom, zoom, zoom) end

	-- Draw the frame and shadow
	if self.frame.shadow then self:drawFrame(x + self.frame.shadow.x, y + self.frame.shadow.y, 0, 0, 0, self.frame.shadow.a) end
	self:drawFrame(x, y, self.frame.darkness, self.frame.darkness, self.frame.darkness, self.frame.a)

	-- Title
	if self.title then
		if self.title_shadow then
			if shader then
				shader:use(true)
				shader:uniOutlineSize(self.shadow_power, self.shadow_power)
				shader:uniTextSize(self.title_tex.tw, self.title_tex.th)
			else
				self:textureToScreen(self.title_tex, x + (self.w - self.title_tex.w) / 2 + 3 + self.frame.title_x, y + 3 + self.frame.title_y, 0, 0, 0, 0.5)
			end
		end
		self:textureToScreen(self.title_tex, x + (self.w - self.title_tex.w) / 2 + self.frame.title_x, y + self.frame.title_y)
		if self.title_shadow and shader then shader:use(false) end
	end

	self:innerDisplayBack(x, y, nb_keyframes, tx, ty)

	-- UI elements
	for i = 1, #self.uis do
		local ui = self.uis[i]
		if not ui.hidden then ui.ui:display(x + ui.x, y + ui.y, nb_keyframes, ox + ui.x, oy + ui.y) end
	end

	self:innerDisplay(x, y, nb_keyframes, tx, ty)

	if self.first_display then self:firstDisplay() self.first_display = false end

	-- Restore normal opengl matrix
	if zoom < 1 then core.display.glScale() end
	core.display.glTranslate(-tx, -ty, 0)
end
