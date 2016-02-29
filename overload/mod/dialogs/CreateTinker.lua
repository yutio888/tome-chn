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
local Textbox = require "engine.ui.Textbox"
local TextzoneList = require "engine.ui.TextzoneList"
local Separator = require "engine.ui.Separator"
local Button = require "engine.ui.Button"
local EntityDisplay = require "engine.ui.EntityDisplay"
local Checkbox = require "engine.ui.Checkbox"
local FontPackage = require "engine.FontPackage"
local Object = require "mod.class.Object"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(party, actor)
	self.actor = actor
	self.party = party
	self.search_filter = nil
	self.cur_tier = 1
	Dialog.init(self, "Tinkers", game.w * 0.8, game.h * 0.8)

	self.tinkerslist = Object:loadList("/data-orcs/general/objects/tinker.lua")
	self.tinkerslist.__real_type = "object"

	self.c_search = Textbox.new{title="搜索: ", text="", chars=30, max_len=60, fct=function() end, on_change=function(text) self:search(text) end}

	self.c_entity = EntityDisplay.new{width=64, height=64}

	self.c_list = ListColumns.new{width=math.floor(self.iw / 2 - 10), height=self.ih - 20 - self.c_search.h, scrollbar=true, sortable=true, columns={
		{name="", width={24,"fixed"}, display_prop="", direct_draw=function(item, x, y) item.tdef.display_entity:toScreen(nil, x+2, y+2, 20, 20) end},
		{name="配件", width=45, display_prop="name", sort="sort_name"},
		{name="装备位置", width=15, display_prop="slot", sort="slot"},
		{name="类型", width=20, display_prop="base_category", sort="base_category"},
		{name="状态", width=20, display_prop="status", sort="status"},
	}, list={}, fct=function(item) self:use(item) end, select=function(item, sel) self:select(item) end}
	
	self:generateList()

	self.c_create = Button.new{text="制造", fct=function() self:create() end}
	self.c_cur_desc = TextzoneList.new{scrollbar=true, width=math.floor(self.iw / 2 - 10), height=self.ih - 200}
	self.c_cur_name = TextzoneList.new{scrollbar=true, width=math.floor(self.iw / 2 - 10), height=64, font={FontPackage:getFont("default"), 48}}
	self.c_cur_tier1 = Checkbox.new{title="材质等级 1", default=false, fct=function() end, on_change=function(s) if s then self:selectTier(1) end end}
	self.c_cur_tier2 = Checkbox.new{title="材质等级 2", default=false, fct=function() end, on_change=function(s) if s then self:selectTier(2) end end}
	self.c_cur_tier3 = Checkbox.new{title="材质等级 3", default=false, fct=function() end, on_change=function(s) if s then self:selectTier(3) end end}
	self.c_cur_tier4 = Checkbox.new{title="材质等级 4", default=false, fct=function() end, on_change=function(s) if s then self:selectTier(4) end end}
	self.c_cur_tier5 = Checkbox.new{title="材质等级 5", default=false, fct=function() end, on_change=function(s) if s then self:selectTier(5) end end}

	self:loadUI{
		{left=0, top=0, ui=self.c_list},
		{left=5, bottom=self.c_search.h - 4, ui=Separator.new{dir="vertical", size=math.floor(self.iw / 2 - 10)}},
		{left=0, bottom=0, ui=self.c_search},
		{hcenter=0, top=5, ui=Separator.new{dir="horizontal", size=self.ih - 10}},
		{right=5, top=0, ui=self.c_entity},
		{right=5, top=0, ui=self.c_cur_name, hidden=true},
		{right=5, top=self.c_cur_name.h, ui=self.c_cur_desc, hidden=true},
		{right=5, bottom=5, ui=self.c_create, hidden=true},
		{right=self.c_create, bottom=5, ui=self.c_cur_tier5, hidden=true},
		{right=self.c_cur_tier5, bottom=5, ui=self.c_cur_tier4, hidden=true},
		{right=self.c_cur_tier4, bottom=5, ui=self.c_cur_tier3, hidden=true},
		{right=self.c_cur_tier3, bottom=5, ui=self.c_cur_tier2, hidden=true},
		{right=self.c_cur_tier2, bottom=5, ui=self.c_cur_tier1, hidden=true},
	}
	self:setFocus(self.c_search)
	self:setupUI()
	self.c_list:selectColumn(3)

	self.key:addBinds{
		EXIT = function() game:unregisterDialog(self) end,
	}

	self:select(self.list[1])
end

function _M:select(item)
	if item then
		-- self.c_desc:switchItem(item, item.desc)
	end
end


function _M:use(item)
	if not item then return end
	if self.current_item then self.current_item.color = self.current_item.dcolor end
	self.current_item = item
	item.color = colors.simple(colors.LIGHT_GREEN)

	self.c_entity.entity = item.tdef.display_entity
	self.c_cur_name:switchItem(item, "#LIGHT_BLUE#"..item.name)
	self:getUIElement(self.c_create).hidden = false
	self:getUIElement(self.c_cur_desc).hidden = false
	self:getUIElement(self.c_cur_name).hidden = false

	self:getUIElement(self.c_cur_tier1).hidden = true
	self:getUIElement(self.c_cur_tier2).hidden = true
	self:getUIElement(self.c_cur_tier3).hidden = true
	self:getUIElement(self.c_cur_tier4).hidden = true
	self:getUIElement(self.c_cur_tier5).hidden = true
	if self.party:canMakeTinker(self.actor, self.current_item.id, 1) then self:getUIElement(self.c_cur_tier1).hidden = false if not self.changing_tier then self:selectTier(1) end end
	if self.party:canMakeTinker(self.actor, self.current_item.id, 2) then self:getUIElement(self.c_cur_tier2).hidden = false if not self.changing_tier then self:selectTier(2) end end
	if self.party:canMakeTinker(self.actor, self.current_item.id, 3) then self:getUIElement(self.c_cur_tier3).hidden = false if not self.changing_tier then self:selectTier(3) end end
	if self.party:canMakeTinker(self.actor, self.current_item.id, 4) then self:getUIElement(self.c_cur_tier4).hidden = false if not self.changing_tier then self:selectTier(4) end end
	if self.party:canMakeTinker(self.actor, self.current_item.id, 5) then self:getUIElement(self.c_cur_tier5).hidden = false if not self.changing_tier then self:selectTier(5) end end

	local desc_tier = util.bound(self.cur_tier or 1, item.tdef.base_ml or 1, item.tdef.max_ml or 5)
	if not item.desc[desc_tier] then
		item.desc[desc_tier] = self:getDescription(item.tdef, desc_tier)
	end
	self.c_cur_desc:switchItem(item.desc[desc_tier], item.desc[desc_tier])
end

function _M:selectTier(ml)
	self.c_cur_tier1.checked = false
	self.c_cur_tier2.checked = false
	self.c_cur_tier3.checked = false
	self.c_cur_tier4.checked = false
	self.c_cur_tier5.checked = false
	self.cur_tier = ml
	self["c_cur_tier"..ml].checked = true
	if self.current_item then self.changing_tier = true self:use(self.current_item) self.changing_tier = false end
end

function _M:create()
	if not self.current_item then return end

	self.party:makeTinker(self.actor, self.current_item.id, self.cur_tier)
	game:playSound({"ambient/town/town_large2", vol=300})
	game:unregisterDialog(self)
end
local function transItemname(name)
	if objectG[name] then name = objectG[name].chName
	elseif tinkerCHN[name] then name = tinkerCHN[name].name 

	end
	return name
end
function _M:getDescription(tdef, ml)
	ml = ml or 1
	ml = ml < 1 and 1 or ml
	local str = tstring{}
	local desc = tdef.desc
	desc = cutChrCHN(desc, 25)
	str:merge(desc:toTString())
	str:add(true)
	if tdef.talents then
		str:add("需要技能:", true)
		for tid, level in pairs(tdef.talents) do
			local color = {"color", "LIGHT_RED"}
			if self.actor:getTalentLevel(tid) >= level then color = {"color", "LIGHT_GREEN"} end
			str:add("- ", color, self.actor:getTalentFromId(tid).name, " (", tostring(level), ")", {"color", "LAST"}, true)
		end
	end
	if tdef.ingredients then
		str:add("需要材料:", true)
		for ing, qty in pairs(tdef.ingredients) do
			local color = {"color", "LIGHT_RED"}
			if self.party:hasIngredient(ing..ml, qty) or self.party:hasIngredient(ing, qty) then color = {"color", "LIGHT_GREEN"} end
			local name = (self.party:getIngredient(ing..ml) or self.party:getIngredient(ing)).name
			if i_ingredient[name].chName then name =i_ingredient[name].chName end
			str:add("- ", color, name, " (", tostring(qty), ")", {"color", "LAST"}, true)
		end
	end
	if tdef.items then
		local inven = self.actor:getInven("INVEN")
		str:add("需要物品:", true)
		for ing, name in pairs(tdef.items) do
			ing = util.getval(ing, ml)
			name = util.getval(name, ml)
			name = transItemname(name)
			local color = {"color", "LIGHT_RED"}
			if self.actor:findInInventoryBy(inven, "define_as", ing..ml) or self.actor:findInInventoryBy(inven, "define_as", ing) then color = {"color", "LIGHT_GREEN"} end
			str:add("- ", color, name, {"color", "LAST"}, true)
		end
	end
	if tdef.special then
		str:add("需要:", true)
		for _, d in ipairs(tdef.special) do
			local color = {"color", "LIGHT_RED"}
			if d.cond(tdef, self.party, self.actor) then color = {"color", "LIGHT_GREEN"} end
			local desc = d.desc
			if desc:find("handed") then desc ="单手剑、斧、锤(非传奇装备，非特殊伤害类型)"
			elseif desc:find("sling")then desc = "投石索(非传奇)"
			end
			str:add("- ", color, desc, {"color", "LAST"}, true)
		end
	end


	local oid = "TINKER_"..tdef.id..ml
	if self.tinkerslist[oid] then
		local o = game.zone:makeEntityByName(game.level, self.tinkerslist, oid)
		if o then
			o.identified = true -- To not trigger unique lore pop
			str:add(true, {"color", "ORANGE"}, {"font", "bold"}, "范例物品:", {"font", "italic"}, {"color", "WHITE"}, true)
			str:merge(o:getDesc())
			str:add({"font", "normal"})
		end
	end

	return str
end

function _M:search(text)
	if text == "" then self.search_filter = nil
	else self.search_filter = text end

	self:generateList()
end

function _M:matchSearch(name)
	if not self.search_filter then return true end
	return name:lower():find(self.search_filter:lower(), 1, 1)
end

function _M:generateList()
	-- Makes up the list
	local list = {}
	for id, tdef in pairs(self.party.__tinkers_ings or {}) do
		if self.party:knowTinker(id) and self:matchSearch(tdef.name) then
			local slot = "--"
			local upto = 5
			while upto >= 1 and not self.party:canMakeTinker(self.actor, id, upto) do upto = upto - 1 end

			if tdef.display_entity then tdef.display_entity:getMapObjects(game.uiset.hotkeys_display_icons.tiles, {}, 1) end

			if tdef.fake_slot then
				slot = tdef.fake_slot:lower():gsub('_', ' ')
			end

			for ml = 1, 5 do
				local oid = "TINKER_"..id..ml
				if self.tinkerslist[oid] then
					local o = self.tinkerslist[oid]
					if o.on_type then
						if o.on_subtype then
							slot = o.on_type.." / "..o.on_subtype break
						else
							slot = o.on_type break
						end
					elseif o.on_slot then
						slot = o.on_slot:lower():gsub('_', ' ') break
					elseif o.slot then
						slot = o.slot:lower():gsub('_', ' ') break
					end
				end
			end
			slot = slot:gsub("mainhand","主手"):gsub("offhand","副手"):gsub("finger","手指"):gsub("body","躯干")
					:gsub("hands","手套"):gsub("feet","脚部"):gsub("head","头部"):gsub("cloak","披风"):gsub("belt","腰带")
					:gsub("lite","灯具"):gsub("neck","项链"):gsub("tool","工具"):gsub("quiver","弹药")
					:gsub("armor","护甲"):gsub("weapon","武器"):gsub("shield","盾牌"):gsub("staff","法杖")
			list[#list+1] = {
				id=id,
				sort_name = (upto>0 and 1 or 2)..tdef.name,
				name=tdef.name,
				base_category=tdef.base_category:gsub("smith","铁匠"):gsub("chemistry","药剂学"):gsub("electricity","电子")
																				:gsub("explosives","爆炸学"):gsub("mechanical","机械"):gsub("therapeutics","治疗学"),
				status=upto > 0 and ("最高"..upto.."材质等级") or "缺少材料",
				desc={},
				tdef=tdef,
				slot=slot,
				max_ml = upto,
				color = colors.simple(upto > 0 and colors.WHITE or colors.RED),
				dcolor = colors.simple(upto > 0 and colors.WHITE or colors.RED),
			}
		end
	end
	table.sort(list, function(a, b) return a.sort_name < b.sort_name end)
	self.list = list

	self.c_list:setList(list)
end
