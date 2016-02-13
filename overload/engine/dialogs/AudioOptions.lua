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
local Dialog = require "engine.ui.Dialog"
local Textzone = require "engine.ui.Textzone"
local Checkbox = require "engine.ui.Checkbox"
local Numberbox = require "engine.ui.Numberbox"
local NumberSlider = require "engine.ui.NumberSlider"
local Separator = require "engine.ui.Separator"

--- Shows audio options
-- @classmod engine.dialogs.AudioOptions
module(..., package.seeall, class.inherit(Dialog))

function _M:init()
	Dialog.init(self, "声音选项", 400, 300)

	self.c_enable = Checkbox.new{title="开启音效", default=config.settings.audio.enable, fct=function() end, on_change=function(s) self:sfxEnable(s) end}

	self.c_music_vol = NumberSlider.new{title="音乐音量: ", size_title="Effects: ", w=400, max=100, min=0, value=config.settings.audio.music_volume, on_change = function(v) self:sfxVolume("music", v) end}
	self.c_effects_vol = NumberSlider.new{title="音效音量: ", w=400, max=100, min=0, value=config.settings.audio.effects_volume, on_change = function(v) self:sfxVolume("effects", v) end}

	self:loadUI{
		{left=0, top=0, ui=self.c_enable},
		{left=0, top=self.c_enable.h + 10, ui=self.c_music_vol},
		{left=0, top=self.c_enable.h + 10 + self.c_music_vol.h, ui=self.c_effects_vol},
	}
	self:setupUI(true, true)

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}
end

function _M:sfxEnable(s)
	config.settings.audio.enable = s and true or false
	core.sound.enable(s)
	game:audioSaveSettings()
end

function _M:sfxVolume(what, s)
	if what == "music" and game.volumeMusic then game:volumeMusic(s)
	elseif what == "effects" and game.volumeSoundEffects then game:volumeSoundEffects(s) end
end
