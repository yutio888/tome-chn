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
local List = require "engine.ui.List"
local Button = require "engine.ui.Button"
local Checkbox = require "engine.ui.Checkbox"
local Textzone = require "engine.ui.Textzone"
local Textbox = require "engine.ui.Textbox"
local GetQuantity = require "engine.dialogs.GetQuantity"
local Map = require "engine.Map"

module(..., package.seeall, class.inherit(Dialog))

tiles_packs = {
	shockbolt = {name= "默认材质", order=1},
	ascii = {name= "ASCII", order=5},
	ascii_full = {name= "ASCII有背景特效", order=6},
	customtiles = {name= "自定义贴图", order=7},
}
if fs.exists("/data/gfx/altefcat") then tiles_packs.altefcat = {name= "Altefcat/Gervais", order=3} end
if fs.exists("/data/gfx/oldrpg") then tiles_packs.oldrpg = {name= "Old RPG", order=4} end


function _M:init()
	self.cur_sel = "main"
	self:generateList()
	self.changed = false

	Dialog.init(self, "更改图像设置", 300, 20)

	self.c_list = List.new{width=self.iw, nb_items=7, list=self.list, fct=function(item) self:use(item) end}

	self:loadUI{
		{left=0, top=0, ui=self.c_list},
	}
	self:setFocus(self.c_list)
	self:setupUI(false, true)

	self.key:addBinds{
		EXIT = function()
			if self.changed then
				if self:isTome() then
					game:setupDisplayMode(true)
				else
					local gfx = config.settings.tome.gfx
					game:saveSettings("tome.gfx", ('tome.gfx = {tiles=%q, size=%q, tiles_custom_dir=%q, tiles_custom_moddable=%s, tiles_custom_adv=%s}\n'):format(gfx.tiles, gfx.size, gfx.tiles_custom_dir or "", gfx.tiles_custom_moddable and "true" or "false", gfx.tiles_custom_adv and "true" or "false"))
				end
			end
			game:unregisterDialog(self)
		end,
	}
end

function _M:isTome()
	return game.__mod_info.short_name == "tome"
end

function _M:doCustomTiles()
	local d = Dialog.new("自定义贴图", 100, 100)

	local help = Textzone.new{width=500, auto_height=true, text=[[你可以设置为自定义贴图。
你必须把你的贴图材质文件放在模组文件中的 data/gfx/ 文件夹内，和当前的贴图一样。
所有材质的文件名必须和已存在的默认材质文件名相同。]]}
	local dir = Textbox.new{title="文件夹名：", text="", chars=30, max_len=50, fct=function() end}
	local moddable_tiles = Checkbox.new{title="使用模组贴图(玩家装备贴图)", default=false, fct=function() end }
	local adv_tiles = Checkbox.new{title="使用高级贴图(渐变效果、大贴图, ...)", default=false, fct=function() end }
	local ok = Button.new{text="使用自定义贴图", fct=function()
		config.settings.tome.gfx.tiles = "customtiles"
		config.settings.tome.gfx.tiles_custom_dir = dir.text
		config.settings.tome.gfx.tiles_custom_moddable = moddable_tiles.checked
		config.settings.tome.gfx.tiles_custom_adv = adv_tiles.checked
		self.changed = true
		self:use{change_sel = "main"}
		game:unregisterDialog(d)
	end}
	local cancel = Button.new{text="取消", fct=function() game:unregisterDialog(d) end}

	d:loadUI{
		{left=0, top=0, ui=help},
		{left=0, top=help.h, ui=dir},
		{left=0, top=help.h+dir.h, ui=moddable_tiles},
		{left=0, top=help.h+dir.h+moddable_tiles.h, ui=adv_tiles},
		{left=0, bottom=0, ui=ok},
		{right=0, bottom=0, ui=cancel},
	}
	d:setFocus(dir)
	d:setupUI(true, true)

	game:registerDialog(d)
end

function _M:use(item)
	if not item then return end

	if item.sub and item.val then
		if item.val == "customsize" then
			game:registerDialog(GetQuantity.new("贴图尺寸", "从 10 到 128", Map.tile_w or 64, 128, function(qty)
				qty = math.floor(util.bound(qty, 10, 128))
				self:use{name=qty.."x"..qty, sub=item.sub, val=qty.."x"..qty}
			end, 10))
		elseif item.val == "customtiles" then
			self:doCustomTiles()
		else
			config.settings.tome.gfx[item.sub] = item.val
			self.changed = true
			item.change_sel = "main"
		end
	end

	if item.change_sel then
		self.cur_sel = item.change_sel
		self:generateList()
		self.c_list.list = self.list
		self.c_list:generate()
	end
end

function _M:generateList()
	local list

	if self.cur_sel == "main" then
		local cur = tiles_packs[config.settings.tome.gfx.tiles]
		list = {
			{name="选择材质样式 [当前："..(cur and cur.name or "???").."]", change_sel="tiles"},
			{name="选择贴图大小 [当前："..config.settings.tome.gfx.size.."]", change_sel="size"},
		}
	elseif self.cur_sel == "tiles" then
		list = {}
		for s, n in pairs(tiles_packs) do
			list[#list+1] = {name=n.name, order=n.order, sub="tiles", val=s}
		end
		table.sort(list, function(a, b) return a.order < b.order end)
	elseif self.cur_sel == "size" then
		list = {
			{name="64x64", sub="size", val="64x64"},
			{name="48x48", sub="size", val="48x48"},
			{name="32x32", sub="size", val="32x32"},
			{name="16x16", sub="size", val="16x16"},
			{name="自定义", sub="size", val="customsize"},
		}
	end

	self.list = list
end
