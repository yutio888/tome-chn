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
local Separator = require "engine.ui.Separator"
local Image = require "engine.ui.Image"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(party)
	self.party = party

	Dialog.init(self, "搜集到的材料", game.w * 0.8, game.h * 0.8)

	self.c_desc = TextzoneList.new{width=math.floor(self.iw / 2 - 10), scrollbar=true, height=self.ih}

	self:generateList()

	local vsep = Separator.new{dir="horizontal", size=self.ih - 10}
	self.c_list = ListColumns.new{width=math.floor(self.iw / 2 - vsep.w / 2), height=self.ih - 10, scrollbar=true, sortable=true, columns={
		{name="材料", width=50, display_prop="name", sort="name"},
		{name="分类", width=30, display_prop="cat", sort="cat"},
		{name="数量", width=20, display_prop="nb", sort="nb"},
	}, list=self.list, fct=function(item) end, select=function(item, sel) self:select(item) end}

	self:loadUI{
		{left=0, top=0, ui=self.c_list},
		{right=0, top=0, ui=self.c_desc},
		{hcenter=0, top=5, ui=vsep},
	}
	self:setFocus(self.c_list)
	self:setupUI()
	self:select(self.list[1])

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}
end

function _M:generateList()
	-- Makes up the list
	local list = {}
	local i = 0
	for id, nb in pairs(self.party.ingredients) do
		local d = self.party:getIngredient(id)
		local name_chn, desc_chn, cat_chn
		if i_ingredient[d.name] then
			name_chn = i_ingredient[d.name].chName
			desc_chn = i_ingredient[d.name].chDesc
			cat_chn = i_ingredient[d.name].type
		end
		list[#list+1] = { dname=d.name, name=d.display_entity:getDisplayString(true):add(name_chn or d.name), desc=util.getval(desc_chn or d.desc), cat=cat_chn or d.type, nb=nb==-1 and "inf" or tostring(nb) }
		i = i + 1
	end
	-- Add known artifacts
	table.sort(list, function(a, b) return a.dname < b.dname end)
	self.list = list
end

function _M:select(item)
	if item then
		self.c_desc:switchItem(item, ("#GOLD#分类：#AQUAMARINE# %s\n#GOLD#材料：#0080FF# %s\n#GOLD#数量：#0080FF# %s\n#GOLD#描述：#ANTIQUE_WHITE# %s"):format(item.cat, item.name:toString(), item.nb, cutChrCHN(item.desc,30)))
	end
end
