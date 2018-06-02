local _M = loadPrevious(...)


require "data-chn123.delayed_damage"
-- 选择职业界面，标题未翻译
class:bindHook("Game:alterGameMenu", function (self, data)
	data.menu[2][1] = data.menu[2][1]:gsub("Show Achievements","查看成就")
	data.menu[3][1] = data.menu[3][1]:gsub("Show known Lore","查看手札")
	data.menu[4][1] = data.menu[4][1]:gsub("Show ingredients","查看原料")
	data.menu[6][1] = data.menu[6][1]:gsub("Inventory","查看物品")
	data.menu[7][1] = data.menu[7][1]:gsub("Character Sheet","查看面板")
	data.menu[9][1] = data.menu[9][1]:gsub("Game Options","游戏选项")
	end
)


function _M:getZoneName()
	if self.zone.display_name then
		name = self.zone.display_name()
		if name == "Maj'Eyal" then name = "马基埃亚尔"
		else
			name = name:gsub("Yiilkgur, the Sher'Tul Fortress","伊克格 夏·图尔堡垒"):gsub("Control Room","控制室"):gsub("Storage Room","储藏室"):gsub("Portal Room","传送室"):gsub("Exploratory Farportal","探险传送门"):gsub("Library of Lost Mysteries","失落的秘密图书馆")
		end
	else
		local lev = self.level.level
		if self.level.data.reverse_level_display then lev = 1 + self.level.data.max_level - lev end
		if self.zone.max_level == 1 then
			name = self.zone.name
		else
			name = ("%s (%d)"):format(zoneName[self.zone.name] or self.zone.name, lev)
		end
	end
	return name

end
--- Update the zone name, if needed
function _M:updateZoneName()
	if not self.zone_font then return end
	local name = self:getZoneName()
	if self.zone_name_s and self.old_zone_name == name then return end

	name = zoneName[name] or name

	local s = core.display.drawStringBlendedNewSurface(self.zone_font, name, unpack(colors.simple(colors.GOLD)))
	self.zone_name_w, self.zone_name_h = s:getSize()
	self.zone_name_s, self.zone_name_tw, self.zone_name_th = s:glTexture()
	self.old_zone_name = name
	print("Updating zone name", name)
end
function _M:logMessage(source, srcSeen, target, tgtSeen, style, ...)
	print("logMsgCheck", style)
	style = logCHN:trans(style,...)
	print("logMsgTrans", style)
	--style = style:format(...)
	local srcname = "something"
	local Dstring
		if source.player then
			srcname = "#fbd578#"..source.name.."#LAST#"
		elseif srcSeen then
			srcname = engine.Entity.check(source, "getName") or source.name or "unknown"
		end
		if srcname ~= "something" then Dstring = source.__is_actor and source.getDisplayString and source:getDisplayString() end
	if source.name and source.name=="spatial tether" then srcname ="时空锁链" end
	srcname = logCHN:getName(srcname)
	if source.name and source.name:find("maelstrom") then srcname ="灵能漩涡" end
	--if logTableCHN[style] then style = logTableCHN[style].fct(...) end
	
    
	style = style:gsub("#source#", srcname)
	style = style:gsub("#Source#", (Dstring or "")..srcname:capitalize())
	if target then
		local tgtname = "something"
			if target.player then
				tgtname = "#fbd578#"..target.name.."#LAST#"
			elseif tgtSeen then
				tgtname = engine.Entity.check(target, "getName") or target.name or "unknown"
			end
		if target and target.name=="Iceblock" then tgtname = "冰块"
		else tgtname = logCHN:getName(tgtname) end
		
		style = style:gsub("#target#", tgtname)
		style = style:gsub("#Target#", tgtname:capitalize())
	end
	--style = delayed_damage_trans(style)
	return style
end

--I don't know why I cannot use local old=_m.delayedLogDamage and I need to paste the function from Game.lua
function _M:delayedLogDamage(src, target, dam, desc, crit)
	desc = delayed_damage_trans(desc)
	if not target or not src then return end
	local psrc = src.__project_source or src -- assign message to indirect damage source if available
	local visible, srcSeen, tgtSeen = self:logVisible(psrc, target)
	if visible then -- only log damage the player is aware of
		local t = table.getTable(self.delayed_log_damage, src, psrc, target)
		table.update(t, {total=0, healing=0, descs={}})
		t.descs[#t.descs+1] = desc
		if dam>=0 then
			t.total = t.total + dam
		else
			t.healing = t.healing + dam
		end
		t.is_crit = t.is_crit or crit
		t.srcSeen = srcSeen
		t.tgtSeen = tgtSeen
	end
end
return _M
