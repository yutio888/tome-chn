-- ToME - Tales of Maj'Eyal
-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2019 Nicolas Casalini
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
require "engine.ui.Dialog"
local Shader = require "engine.Shader"
local Textbox = require "engine.ui.Textbox"

module(..., package.seeall, class.inherit(engine.ui.Dialog))

_M.last_max_tl = 10

function _M:init(actor, t)
	actor = actor:cloneFull()
	engine.ui.Dialog.init(self, ("Values plot for: %s (mastery %0.1f)"):format(t.name, actor:getTalentMastery(t)), game.w * 0.8, game.h * 0.8)
	self.vos = {}
	self.points_texts = {}

	self:generatePlot(actor, t, _M.last_max_tl)
	local tlbox = Textbox.new{title="TL: ", text=tostring(_M.last_max_tl), chars=5, max_len=3, fct=function() end, on_change=function(text) self:generatePlot(actor, t, util.bound(tonumber(text) or 20, 5, 500)) end}
	self:loadUI{
		{left=0, top=0, ui=tlbox}
	}
	self:setupUI(false, false)

	self.key:addBinds{ EXIT = function() game:unregisterDialog(self) end, }
end

function _M:generatePlot(actor, t, nb_tl)
	_M.last_max_tl = nb_tl
	local points_texts = {}
	local vos = {}
	local display_step = 1
	if nb_tl >= 400 then display_step = 20
	elseif nb_tl >= 200 then display_step = 10
	elseif nb_tl >= 100 then display_step = 5
	elseif nb_tl >= 50 then display_step = 3
	elseif nb_tl > 20 then display_step = 2
	end
	
	local vo = core.display.newVO()
	for tl = 1, nb_tl do
		local i = tl * self.iw / nb_tl
		for j = 0, self.ih, 30 do
			vo:addQuad(tl<=5 and 0.3 or 0.09, tl<=5 and 0.3 or 0.09, tl<=5 and 0.3 or 0.09, 1,
				{i,   j, 0, 0},
				{i+1, j, 1, 0},
				{i+1, j+20, 1, 0},
				{i,   j+20, 0, 1}
			)
		end
		if tl % display_step == 0 then
			local etl = tl * actor:getTalentMastery(t)
			local txt = {core.display.drawStringBlendedNewSurface(self.font, ("%0.1f"):format(etl), 255, 255, 255):glTexture()}
			points_texts[#points_texts+1] = {txt=txt, x=i, y=self.ih+txt[7]*2}
		end
	end
	vos[#vos+1] = vo

	local vars = {}
	for k, e in pairs(t) do
		-- if type(e) == "function" and (k == "radius") then
		if type(e) == "function" and (k == "radius" or k == "range" or k:find("^get[A-Z]")) then
			local ok, testval = pcall(e, actor, t)
			if ok and type(testval) == "number" then vars[#vars+1] = k end
		end
	end
	table.sort(vars)

	local allcolors = {colors.GREEN, colors.LIGHT_BLUE, colors.LIGHT_RED, colors.ORANGE}
	for _, var in ipairs(vars) do
		local vo = core.display.newVO()
		local color = table.remove(allcolors)
		local vals = {}
		local min, max = 9999999, -9999999
		print("******", var)
		for tl = 1, nb_tl do
			actor.talents[t.id] = tl
			local val = t[var](actor, t)
			vals[#vals+1] = {val=val, tl=tl}
			if val > max then max = val end
			if val < min then min = val end
			print("!!", t.name, tl, var, "==", val)
		end
		min = 0
		if max <= 1 then max = 1
		elseif max <= 5 then max = 5
		elseif max <= 10 then max = 10
		elseif max <= 50 then max = 50
		elseif max <= 100 then max = 100
		elseif max <= 500 then max = 500
		elseif max <= 1000 then max = 1000
		end
		local range = max - min

		local firstvy = nil
		for i, val in ipairs(vals) do
			local v = val.val
			local tl = val.tl
			local vx = i * self.iw / #vals
			local vy = self.ih - (v - min) / range * self.ih
			if not firstvy then firstvy = vy end
			if i > 1 then
				local pv = vals[i - 1].val
				local px = (i-1) * self.iw / #vals
				local py = self.ih - (pv - min) / range * self.ih
				local a = math.atan2(vy - py, vx - py)
				print("======", var, tl, "::", vx, vy, "::", px, py, "::", a)

				vo:addQuad(color.r/255*0.5, color.g/255*0.5, color.b/255*0.5, 1,
					{vx, vy - 2, 0, 0},
					{px, py - 2, 1, 0},
					{px, py + 2, 0, 1},
					{vx, vy + 2, 1, 0}
				)
			end
			if tl % display_step == 0 then
				local txt = {core.display.drawStringBlendedNewSurface(self.font, (math.floor(v) == v) and v or ("%0.2f"):format(v), color.r, color.g, color.b):glTexture()}
				points_texts[#points_texts+1] = {txt=txt, x=vx, y=vy}
			end
		end
		vos[#vos+1] = vo

		local txt = {core.display.drawStringBlendedNewSurface(self.font, var, color.r, color.g, color.b):glTexture()}
		points_texts[#points_texts+1] = {txt=txt, x=self.iw/nb_tl*0.7-txt[6]/2, y=firstvy+txt[7]/2}
	end

	self.vos = vos
	self.points_texts = points_texts
end

function _M:innerDisplay(bx, by)
	for _, vo in ipairs(self.vos) do
		vo:toScreen(bx, by, nil, 1, 1, 1, 1)
	end

	local shader = Shader.default.textoutline and Shader.default.textoutline.shad

	if shader then shader:use(true) shader:uniOutlineSize(1, 1) end
	for _, pt in ipairs(self.points_texts) do
		if shader then shader:uniTextSize(pt.txt[2], pt.txt[3]) end
		pt.txt[1]:toScreenFull(bx + pt.x - pt.txt[6] / 2, by + pt.y - pt.txt[7], pt.txt[6], pt.txt[7], pt.txt[2], pt.txt[3])
	end
	if shader then shader:use(false) end
end
