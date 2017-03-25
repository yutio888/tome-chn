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
local Dialog = require "engine.ui.Dialog"
local TreeList = require "engine.ui.TreeList"
local Textzone = require "engine.ui.Textzone"
local Separator = require "engine.ui.Separator"
local GetQuantity = require "engine.dialogs.GetQuantity"
local GetQuantitySlider = require "engine.dialogs.GetQuantitySlider"

--- Video Options
-- @classmod engine.dialogs.VideoOptions
module(..., package.seeall, class.inherit(Dialog))

function _M:init()
	Dialog.init(self, "视频选项", game.w * 0.8, game.h * 0.8)

	self.c_desc = Textzone.new{width=math.floor(self.iw / 2 - 10), height=self.ih, text=""}

	self:generateList()

	self.c_list = TreeList.new{width=math.floor(self.iw / 2 - 10), height=self.ih - 10, scrollbar=true, columns={
		{width=60, display_prop="name"},
		{width=40, display_prop="status"},
	}, tree=self.list, fct=function(item) end, select=function(item, sel) self:select(item) end}

	self:loadUI{
		{left=0, top=0, ui=self.c_list},
		{right=0, top=0, ui=self.c_desc},
		{hcenter=0, top=5, ui=Separator.new{dir="horizontal", size=self.ih - 10}},
	}
	self:setFocus(self.c_list)
	self:setupUI()

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}
end

function _M:select(item)
	if item and self.uis[2] then
		self.uis[2].ui = item.zone
	end
end

function _M:generateList()
	-- Makes up the list
	local list = {}
	local i = 0

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text="显示分辨率。"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#分辨率#WHITE##{normal}#", status=function(item)
		return config.settings.window.size
	end, fct=function(item)
		local menu = require("engine.dialogs.DisplayResolution").new(function()	self.c_list:drawItem(item) end)
		game:registerDialog(menu)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"如果你有一个高分辨率的屏幕，你可以调高该数值。重启后生效。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#Screen Zoom#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.screen_zoom * 100).."%"
	end, fct=function(item)
		game:registerDialog(GetQuantitySlider.new("Enter Zoom %", "From 50 to 400", math.floor(config.settings.screen_zoom * 100), 50, 400, 5, function(qty)
			qty = util.bound(qty, 50, 400)
			game:saveSettings("screen_zoom", ("screen_zoom = %f\n"):format(qty / 100))
			config.settings.screen_zoom = qty / 100
			self.c_list:drawItem(item)
		end))
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"帧密度选项。\n降低帧密度可以减轻CPU占用，提高可以提升显示效果。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#帧密度设定#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.display_fps)
	end, fct=function(item)
		game:registerDialog(GetQuantity.new("设定密度", "从 5 到 60", config.settings.display_fps, 5, 60, 1, function(qty)
			qty = util.bound(qty, 5, 60)
			game:saveSettings("display_fps", ("display_fps = %d\n"):format(qty))
			config.settings.display_fps = qty
			core.game.setFPS(qty)
			self.c_list:drawItem(item)
		end))
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"设定粒子效果的密度。\n可以改变游戏内的粒子效果密度。\n如果你在施法时发现游戏速度进行较慢请尝试降低这个设置。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#粒子效果密度#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.particles_density)
	end, fct=function(item)
		game:registerDialog(GetQuantitySlider.new("输入密度", "从 0 到 100", config.settings.particles_density, 0, 100, 1, function(qty)
			game:saveSettings("particles_density", ("particles_density = %d\n"):format(qty))
			config.settings.particles_density = qty
			self.c_list:drawItem(item)
		end))
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"启用抗锯齿效果。\n激活该效果会使文字看上去更美观但有些电脑运行速度会变慢。\n\n#LIGHT_RED#你必须重启游戏才能看到效果。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#抗锯齿文字#WHITE##{normal}#", status=function(item)
		return tostring(core.display.getTextBlended() and "启用" or "关闭")
	end, fct=function(item)
		local state = not core.display.getTextBlended()
		core.display.setTextBlended(state)
		game:saveSettings("aa_text", ("aa_text = %s\n"):format(tostring(state)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"全局字体大小调整，重启游戏后生效"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#字体大小#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.font_scale).."%"
	end, fct=function(item)
		game:registerDialog(GetQuantity.new("Font Scale %", "从 50 到 300", config.settings.font_scale, 300, function(qty)
			qty = util.bound(qty, 50, 300)
			game:saveSettings("font_scale", ("font_scale = %d\n"):format(qty))
			config.settings.font_scale = qty
			self.c_list:drawItem(item)
		end, 50))
	end,}
	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"激活帧缓冲。\n这个选项可以激活一些特殊的视频效果。\n如果画面碰到异常请尝试关闭这个效果。\n\n#LIGHT_RED#你必须重启游戏才能看到效果。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#帧缓冲#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.fbo_active and "启用" or "关闭")
	end, fct=function(item)
		config.settings.fbo_active = not config.settings.fbo_active
		game:saveSettings("fbo_active", ("fbo_active = %s\n"):format(tostring(config.settings.fbo_active)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"开启OpenGL着色器效果。\n这个选项可以激活一些特殊的视频效果。\n如果画面碰到异常请尝试关闭这个效果。\n\n#LIGHT_RED#你必须重启游戏才能看到效果。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#OpenGL 着色器#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.shaders_active and "启用" or "关闭")
	end, fct=function(item)
		config.settings.shaders_active = not config.settings.shaders_active
		game:saveSettings("shaders_active", ("shaders_active = %s\n"):format(tostring(config.settings.shaders_active)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"开启高级着色器效果。\n这个选项可以激活一些高级的视频效果（例如水面效果……）\n关闭它可以提升运行速度。\n#LIGHT_RED#你必须重启游戏才能看到效果。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#OpenGL 着色器: 高级#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.shaders_kind_adv and " 开启" or "关闭")
	end, fct=function(item)
		config.settings.shaders_kind_adv = not config.settings.shaders_kind_adv
		game:saveSettings("shaders_kind_adv", ("shaders_kind_adv = %s\n"):format(tostring(config.settings.shaders_kind_adv)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"开启扭曲着色器效果，\n这个选项可以激活一些扭曲视频特效（例如会造成视觉扭曲的法术）\n关闭它可以提升运行速度。\n#LIGHT_RED#你必须重启游戏才能看到效果。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#OpenGL 着色器: 扭曲#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.shaders_kind_distort and "开启" or "关闭")
	end, fct=function(item)
		config.settings.shaders_kind_distort = not config.settings.shaders_kind_distort
		game:saveSettings("shaders_kind_distort", ("shaders_kind_distort = %s\n"):format(tostring(config.settings.shaders_kind_distort)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"开启特殊着色器效果。\n这个选项可以激活一些特殊的视频效果（例如星空特效）。\n开启它会显著降低运行速度。\n#LIGHT_RED#你必须重启游戏才能看到效果。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#OpenGL 着色器: 特殊#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.shaders_kind_volumetric and "开启" or "关闭")
	end, fct=function(item)
		config.settings.shaders_kind_volumetric = not config.settings.shaders_kind_volumetric
		game:saveSettings("shaders_kind_volumetric", ("shaders_kind_volumetric = %s\n"):format(tostring(config.settings.shaders_kind_volumetric)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"使用自定义鼠标贴图。\n关闭这个选项将使用系统默认鼠标。\n（译者注：游戏中滑动鼠标屏幕有闪烁的请关闭这个选项。）#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#鼠标贴图#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.mouse_cursor and "开启" or "关闭")
	end, fct=function(item)
		config.settings.mouse_cursor = not config.settings.mouse_cursor
		game:updateMouseCursor()
		game:saveSettings("mouse_cursor", ("mouse_cursor = %s\n"):format(tostring(config.settings.mouse_cursor)))
		self.c_list:drawItem(item)
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"设定画面亮度。\n提高数值会使画面变量。#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#画面亮度#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.gamma_correction)
	end, fct=function(item)
		game:registerDialog(GetQuantity.new("亮度设定", "从 50 到 300", config.settings.gamma_correction, 50, 300, 5, function(qty)
			qty = util.bound(qty, 50, 300)
			game:saveSettings("gamma_correction", ("gamma_correction = %d\n"):format(qty))
			config.settings.gamma_correction = qty
			game:setGamma(config.settings.gamma_correction / 100)
			self.c_list:drawItem(item)
		end))
	end,}

	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text=string.toTString"开启/关闭图块使用。\n在某些显卡/显卡驱动的很差且很慢的机器上，开启这个选项可能带来负面效果。"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#图块使用#WHITE##{normal}#", status=function(item)
		return tostring(config.settings.disable_tilesets and "关闭" or "开启")
	end, fct=function(item)
		config.settings.disable_tilesets = not config.settings.disable_tilesets
		game:saveSettings("disable_tilesets", ("disable_tilesets = %s\n"):format(tostring(config.settings.disable_tilesets)))
		self.c_list:drawItem(item)
	end,}

	-- *Requested* Window Position
	--  SDL tends to lie about where windows are positioned in fullscreen mode,
	-- so always store the position requests, not the actual positions. 
	local zone = Textzone.new{width=self.c_desc.w, height=self.c_desc.h, text="Request a specific origin point for the game window.\nThis point corresponds to where the upper left corner of the window will be located.\nUseful when dealing with multiple monitors and borderless windows.\n\nThe default origin is (0,0).\n\nNote: This value will automatically revert after ten seconds if not confirmed by the user.#WHITE#"}
	list[#list+1] = { zone=zone, name=string.toTString"#GOLD##{bold}#Requested Window Position#WHITE##{normal}#", status=function(item)
		config.settings.window.pos = config.settings.window.pos or {x=0, y=0}
		local curX, curY = config.settings.window.pos.x, config.settings.window.pos.y
		return table.concat({"(", curX, ",", curY, ")"})
	end, fct=function(item)
		local itemRef = item
		local oldX, oldY = config.settings.window.pos.x, config.settings.window.pos.y
		local newX, newY
		local function revertMove() 
			core.display.setWindowPos(oldX, oldY)
			config.settings.window.pos.x = oldX
			config.settings.window.pos.y = oldY
			self.c_list:drawItem(itemRef)						 
		end		
		-- TODO: Maybe change this to a GetText and parse?
		game:registerDialog(GetQuantity.new("Window Origin: X-Coordinate", "Enter the x-coordinate", oldX, 99999
			, function(qty) 
				newX=util.bound(qty, -99999, 99999) 
				game:registerDialog(GetQuantity.new("Window Origin: Y-Coordinate", "Enter the y-coordinate", oldY, 99999
					, function(qty)
						newY = util.bound(qty, -99999, 99999)
						core.display.setWindowPos(newX, newY)
						config.settings.window.pos.x = newX
						config.settings.window.pos.y = newY
						self.c_list:drawItem(itemRef)
						local userAnswered = false
						local confirmDialog = Dialog:yesnoPopup("Position changed.", "Save position?"
							, function(ret)
								userAnswered = true
								if ret then
									-- Write out settings
									game:onWindowMoved(newX, newY)
								else
									-- Revert
									revertMove()
								end
							end
							,  "Accept", "Revert")
						game:registerTimer(10
							, function()
								-- Blast out changes if no response
								if not userAnswered then
									game:unregisterDialog(confirmDialog)
									revertMove()
								end
							end	)
					end, -99999))
			end, -99999))
	end,}
	
	self.list = list
end
