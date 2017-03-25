-- TE4 - T-Engine 4
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
require "engine.ui.Base"
local Shader = require "engine.Shader"
local Mouse = require "engine.Mouse"
local Slider = require "engine.ui.Slider"

--- Module that handles message history in a mouse wheel scrollable zone
-- @classmod engine.LogDisplay
module(..., package.seeall, class.inherit(engine.ui.Base))

--- Creates the log zone
function _M:init(x, y, w, h, max, fontname, fontsize, color, bgcolor)
	self.color = color or {255,255,255}
	if type(bgcolor) ~= "string" then
		self.bgcolor = bgcolor or {0,0,0}
	else
		self.bgcolor = {0,0,0}
		self.bg_image = bgcolor
	end
	self.font = core.display.newFont(fontname or chn123_tome_font(), fontsize or 12)
	self.font_h = self.font:lineSkip()
	self.log = {}
	getmetatable(self).__call = _M.call
	self.max_log = max or 4000
	self.scroll = 0
	self.changed = true
	self.cache = {}
	setmetatable(self.cache, {__mode="v"})

	self:resize(x, y, w, h)

--	if config.settings.log_to_disk then self.out_f = fs.open("/game-log-"..(game and type(game) == "table" and game.__mod_info and game.__mod_info.short_name or "default").."-"..os.time()..".txt", "w") end
end

function _M:enableShadow(v)
	self.shadow = v
end

function _M:enableFading(v)
	self.fading = v
end

--- Resize the display area
function _M:resize(x, y, w, h)
	self.display_x, self.display_y = math.floor(x), math.floor(y)
	self.w, self.h = math.floor(w), math.floor(h)
	self.fw, self.fh = self.w - 4, self.font:lineSkip()
	self.max_display = math.floor(self.h / self.fh)
	self.changed = true

	if self.bg_image then
		local fill = core.display.loadImage(self.bg_image)
		local fw, fh = fill:getSize()
		self.bg_surface = core.display.newSurface(w, h)
		self.bg_surface:erase(0, 0, 0)
		for i = 0, w, fw do for j = 0, h, fh do
			self.bg_surface:merge(fill, i, j)
		end end
		self.bg_texture, self.bg_texture_w, self.bg_texture_h = self.bg_surface:glTexture()
	end

	self.scrollbar = Slider.new{size=self.h - 20, max=1, inverse=true}

	self.mouse = Mouse.new()
	self.mouse.delegate_offset_x = self.display_x
	self.mouse.delegate_offset_y = self.display_y
	self.mouse:registerZone(0, 0, self.w, self.h, function(button, x, y, xrel, yrel, bx, by, event) self:mouseEvent(button, x, y, xrel, yrel, bx, by, event) end)
end

--- Returns the full log
function _M:getLog(extra, timestamp)
	local log = {}
	for i = 1, #self.log do
		if timestamp and self.log[i].timestamp <= timestamp then break end
		if not extra then
			log[#log+1] = self.log[i].str
		else
			log[#log+1] = {str=self.log[i].str, src=self.log[i]}
		end
	end
	return log
end

function _M:getLogLast()
	if not self.log[1] then return 0 end
	return self.log[1].timestamp
end

--- Make a dialog popup with the full log
function _M:showLogDialog(title, shadow)
	local log = self:getLog()
	local d = require_first("mod.dialogs.ShowLog", "engine.dialogs.ShowLog").new(title or "Message Log", shadow, {log=log})
	game:registerDialog(d)
end

local urlfind = (lpeg.P"http://" + lpeg.P"https://") * (1-lpeg.P" ")^0
local urlmatch = lpeg.anywhere(lpeg.C(urlfind))

--- Appends text to the log
-- This method is set as the call methamethod too, this means it is usable like this:<br/>
-- log = LogDisplay.new(...)<br/>
-- log("foo %s", s)
function _M:call(str, ...)
	--str = str:format(...)
	str = str or ""
	print("[logerr]"..str)
	if logTableCHN[str] then
		str = logTableCHN[str].fct(...)
	else
		str = str:format(...)
	end
	if str:find("#CRIMSON#The ") and str:find("glows ominously.") then
		str = "#CRIMSON#恶魔雕像闪耀着光芒。"
	end
	print("[LOG]", str)
	local tstr = str:toString()
	if self.out_f then self.out_f:write(tstr:removeColorCodes()) self.out_f:write("\n") end

	local url = urlmatch:match(tstr)
	if url then
		tstr = tstr:lpegSub(urlfind, "#LIGHT_BLUE##{italic}#"..url.."#{normal}##LAST#")
	end

	table.insert(self.log, 1, {str=tstr, timestamp = core.game.getTime(), url=url})
	while #self.log > self.max_log do
		local old = table.remove(self.log)
		self.cache[old] = nil
	end
	self.max = #self.log
	self.changed = true
end

--- Gets the newest log line
function _M:getNewestLine()
	if self.log[1] then return self.log[1].str, self.log[1] end
	return nil
end

--- Clear the log
function _M:empty()
	self.cache = {}
	self.log = {}
	self.changed = true
end

--- Remove some lines from the log, starting with the newest
-- @param line = number of lines to remove (default 1) or the last line (table, reference) to leave in the log
-- @param [type=table, optional] ret table in which to append removed lines
-- @param [type=number, optional] timestamp of the oldest line to remove
-- @return the table of removed lines or nil
function _M:rollback(line, ret, timestamp)
	local nb = line or 1
	if type(line) == "table" then
		nb = 0
		for i, ln in ipairs(self.log) do
			if ln == line then nb = i - 1 break end
		end
	end
	if nb > 0 then
		for i = 1, nb do
			local removed = self.log[1]
			if not timestamp or removed.timestamp >= timestamp then
				print("[LOG][remove]", removed.timestamp, removed.str)
				table.remove(self.log, 1)
				if ret then ret[#ret+1] = removed end
			else break
			end
		end
		self.changed = true
	end
	return ret
end

--- Get the oldest lines from the log
-- @param number number of lines to retrieve
function _M:getLines(number)
	local from = number
	if from > #self.log then from = #self.log end
	local lines = { }
	for i = from, 1, -1 do
		lines[#lines+1] = tostring(self.log[i].str)
	end
	return lines
end

function _M:onMouse(fct)
	self.on_mouse = fct
end

function _M:mouseEvent(button, x, y, xrel, yrel, bx, by, event)
	if button == "wheelup" then self:scrollUp(1)
	elseif button == "wheeldown" then self:scrollUp(-1)
	else
		if not self.on_mouse or not self.dlist then return end
		local citem = nil
		local ci
		for i = 1, #self.dlist do
			local item = self.dlist[i]
			if item.dh and by >= item.dh - self.mouse.delegate_offset_y then citem = self.dlist[i] ci=i break end
		end
		if citem then
			local sub_es = {}
			for e, _ in pairs(citem.item._dduids) do sub_es[#sub_es+1] = e end

			if citem.url and button == "left" and event == "button" then
				util.browserOpenUrl(citem.url, {is_external=true})
			else
				self.on_mouse(citem, sub_es, button, event, x, y, xrel, yrel, bx, by)
			end
		else
			self.on_mouse(nil, nil, button, event, x, y, xrel, yrel, bx, by)
		end
	end
end

function _M:display()
	-- If nothing changed, return the same surface as before
	if not self.changed then return end
	self.changed = false

	-- Erase and the display
	self.dlist = {}
	local h = 0
	local old_style = self.font:getStyle()
	for z = 1 + self.scroll, #self.log do
		local stop = false
		local tstr = self.log[z].str
		local gen
		if self.cache[tstr] then
			gen = self.cache[tstr]
		else
			gen = self.font:draw(tstr, self.w, 255, 255, 255, false, true)
			self.cache[tstr] = gen
		end
		for i = #gen, 1, -1 do
			self.dlist[#self.dlist+1] = {item=gen[i], date=self.log[z].reset_fade or self.log[z].timestamp, url=self.log[z].url}
			h = h + self.fh
			if h > self.h - self.fh then stop=true break end
		end
		if stop then break end
	end
	self.font:setStyle(old_style)
	return
end

function _M:toScreen()
	self:display()

	if self.bg_texture then self.bg_texture:toScreenFull(self.display_x, self.display_y, self.w, self.h, self.bg_texture_w, self.bg_texture_h) end

	local now = core.game.getTime()
	local shader = Shader.default.textoutline and Shader.default.textoutline.shad

	local h = self.display_y + self.h -  self.fh
	for i = 1, #self.dlist do
		local item = self.dlist[i].item

		local fade = 1
		if self.fading and self.fading > 0 then
			fade = now - self.dlist[i].date
			if fade < self.fading * 1000 then fade = 1
			elseif fade < self.fading * 2000 then fade = (self.fading * 2000 - fade) / (self.fading * 1000)
			else fade = 0 end
			self.dlist[i].faded = fade
		end

		self.dlist[i].dh = h
		if self.shadow then
			if shader then
				shader:use(true)
				shader:uniOutlineSize(0.7, 0.7)
				shader:uniTextSize(item._tex_w, item._tex_h)
			else
				item._tex:toScreenFull(self.display_x+2, h+2, item.w, item.h, item._tex_w, item._tex_h, 0,0,0, self.shadow * fade)
			end
		end
		item._tex:toScreenFull(self.display_x, h, item.w, item.h, item._tex_w, item._tex_h, 1, 1, 1, fade)
		if self.shadow and shader then shader:use(false) end
		for e, d in pairs(item._dduids) do e:toScreen(nil, self.display_x + d.x, h, d.w, d.w, fade, false, false) end
		h = h - self.fh
	end

	if not self.fading then
		self.scrollbar.pos = self.scroll
		self.scrollbar.max = self.max - self.max_display + 1
		self.scrollbar:display(self.display_x + self.w - self.scrollbar.w, self.display_y)
	end
end

--- Scroll the zone
-- @param i number representing how many lines to scroll
function _M:scrollUp(i)
	self.scroll = self.scroll + i
	if self.scroll > #self.log - 1 then self.scroll = #self.log - 1 end
	if self.scroll < 0 then self.scroll = 0 end
	self.changed = true
	self:resetFade()
end

function _M:resetFade()
	local log = self.log

	-- Reset fade
	for i = 1,#log do
		log[i].reset_fade = core.game.getTime()
	end
end
