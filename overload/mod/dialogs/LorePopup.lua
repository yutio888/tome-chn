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
local Dialog = require "engine.ui.Dialog"
local ListColumns = require "engine.ui.ListColumns"
local TextzoneList = require "engine.ui.TextzoneList"
local Image = require "engine.ui.Image"
local Separator = require "engine.ui.Separator"
local r = require "data-chn123.rewrite_descriptor"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(l, w, force_height)
	self.title_shadow = false
	self.color = l.text_color or {r=0x3a, g=0x35, b=0x33}

	self.ui = l.special_ui or "parchment"

	Dialog.init(self, "新手札：#0080FF#"..l.name, 1, 1)

	r.rewrite()
	local text = util.getval(l.lore).."\n"
	r.recover()
	if (l.chn_translated) then text = cutChrCHN(text, 40) end

	if text:find("Athrall") then text = "‘为了主人的荣耀’ ——阿夏尔" end
	self.font = core.display.newFont("/data-chn123/font/lorefont.ttf", 16)
	local list = text:splitLines(w - 10, self.font)

	if l.bloodstains then
		local ovs = {}
		for i = 1, l.bloodstains do
			ovs[#ovs+1] = {image="ui/parchmentblood"..rng.range(1, 5)..".png", gen=function(self, dialog)
				self.x = rng.range(30, dialog.w - 60)
				self.y = rng.range(30, dialog.h - 60)
				self.a = rng.float(0.5, 0.8)
			end}
		end
		self.frame.overlays = ovs
	end
	if l.red_rose then
		local ovs = {}
		ovs[#ovs+1] = {image="ui/red_rose.png", gen=function(self, dialog)
			self.x = dialog.w - 80
			self.y = dialog.h - 80
			self.a = 1
		end}
		self.frame.overlays = ovs
	end

	local required_h = self.font:height() + self.font_h * (#list - 1)
	local h = math.min(force_height and (force_height * game.h) or 999999999, required_h)
	local c_text = require("engine.ui.Textzone").new{
		width=w+10, height=h, scrollbar=(h < required_h) and true or false, text=text, color=self.color,font=self.font
	}
	c_text:setTextShadow(false)

	local uis = { {left = 3, top = 3, ui=c_text} }
	local image
	if l.image then
		image = Image.new{file="lore/"..l.image, auto_width=true, auto_height=true}
		uis = {
			{hcenter = 0, top = 3, ui=image},
			{left = 3, top = 3 + image.h, ui=c_text},
		}
	end
	
	local on_end = function() 
		game.tooltip.inhibited = false
		game:unregisterDialog(self) 
		if fct then 
			fct() 
		end  
	end

	self:loadUI(uis)
	self.key:addBind("EXIT", on_end)
	self.key:addBind("ACCEPT", on_end)
	self:setupUI(true, true)

	if self.w >= game.w or self.h >= game.h then
		if l.image then
			image.w = math.floor(image.w / 2)
			image.h = math.floor(image.h / 2)
			uis = {
				{hcenter = 0, top = 3, ui=image},
				{left = 3, top = 3 + image.h, ui=c_text},
			}
		end
		self:loadUI(uis)
		self:setupUI(true, true)
	end

	game:registerDialog(self)
	game:playSound("actions/read")
	
	game.tooltip.inhibited = true
end
