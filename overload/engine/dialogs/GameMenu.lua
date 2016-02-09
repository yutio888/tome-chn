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
local List = require "engine.ui.List"

--- Main game menu
-- @classmod engine.dialogs.GameMenu
module(..., package.seeall, class.inherit(Dialog))

function _M:init(actions)
	self:generateList(actions)

	Dialog.init(self, "游戏主菜单", 300, 20)

	self.c_list = List.new{width=self.iw, nb_items=#self.list, list=self.list, fct=function(item) self:use(item) end}

	self:loadUI{
		{left=0, top=0, ui=self.c_list},
	}
	self:setFocus(self.c_list)
	self:setupUI(false, true)

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}
end

function _M:use(item)
	item.fct()
end

function _M:generateList(actions)
	local default_actions = {
		resume = { "返回游戏", function() game:unregisterDialog(self) end },
		keybinds = { "按键绑定", function()
			game:unregisterDialog(self)
			local menu = require("engine.dialogs.KeyBinder").new(game.normal_key, nil, game.gestures)
			game:registerDialog(menu)
		end },
		keybinds_all = { "按键绑定", function()
			game:unregisterDialog(self)
			local menu = require("engine.dialogs.KeyBinder").new(game.normal_key, true, game.gestures)
			game:registerDialog(menu)
		end },
		video = { "视频选项", function()
			game:unregisterDialog(self)
			local menu = require("engine.dialogs.VideoOptions").new()
			game:registerDialog(menu)
		end },
		resolution = { "显示选项", function()
			game:unregisterDialog(self)
			local menu = require("engine.dialogs.DisplayResolution").new()
			game:registerDialog(menu)
		end },
		achievements = { "查看成就", function()
			game:unregisterDialog(self)
			local menu = require("engine.dialogs.ShowAchievements").new(nil, game:getPlayer())
			game:registerDialog(menu)
		end },
		sound = { "音频选项", function()
			game:unregisterDialog(self)
			local menu = require("engine.dialogs.AudioOptions").new()
			game:registerDialog(menu)
		end },
		highscores = { "查看积分榜", function()
			game:unregisterDialog(self)
			local menu = require("engine.dialogs.ViewHighScores").new()
			game:registerDialog(menu)
		end },
		steam = { "Steam", function()
			game:unregisterDialog(self)
			local menu = require("engine.dialogs.SteamOptions").new()
			game:registerDialog(menu)
		end },
		cheatmode = { "#GREY#开发者模式", function()
			game:unregisterDialog(self)
			if config.settings.cheat then
				Dialog:yesnoPopup("Developer Mode", "关闭开发者模式?", function(ret) if ret then
					config.settings.cheat = false
					game:saveSettings("cheat", "cheat = nil\n")
					util.showMainMenu()
				end end, nil, nil, true)
			else
				Dialog:yesnoLongPopup("Developer Mode", [[开启开发者模式?
开发者模式是一种特殊的模式，用于Debug和制作Addon。
开启它会令加载的存档失效。
开启后获得以下快捷键：
——CTRL+L:开启Lua调查窗口
——CTRL+A:打开快捷菜单（生成NPC，转移地点……）
——CTRL+鼠标左键：传送至指定地点
]], 500, function(ret) if not ret then
					config.settings.cheat = true
					game:saveSettings("cheat", "cheat = true\n")
					util.showMainMenu()
				end end, "No", "Yes", true)
		
			end
		end },
		save = { "保存游戏", function() game:unregisterDialog(self) game:saveGame() end },
		quit = { "返回主菜单", function() game:unregisterDialog(self) game:onQuit() end },
		exit = { "退出游戏", function() game:unregisterDialog(self) game:onExit() end },
	}

	-- Makes up the list
	local list = {}
	local i = 0
	for _, act in ipairs(actions) do
		if type(act) == "string" then
			if act ~= "steam" or core.steam then
				local a = default_actions[act]
				list[#list+1] = { name=a[1], fct=a[2] }
				i = i + 1
			end
		else
			local a = act
			list[#list+1] = { name=a[1], fct=a[2] }
			i = i + 1
		end
	end
	self.list = list
end
