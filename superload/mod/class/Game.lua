local _M = loadPrevious(...)


require "data-chn123.delayed_damage"
-- 出生界面，跳出的intro标题未翻译
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
	if logTableCHN[style] then style = logTableCHN[style].fct(...) end
	style = style:format(...)
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
	if logTableCHN[style] then style = logTableCHN[style].fct(...) end
	
    
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
	style = delayed_damage_trans(style)
	return style
end

--- Collate and push all queued delayed log damage information to the combat log
-- Called at the end of each game tick
function _M:displayDelayedLogDamage()
	if not self.uiset or not self.uiset.logdisplay then return end
	for real_src, psrcs in pairs(self.delayed_log_damage) do
		for src, tgts in pairs(psrcs) do
			for target, dams in pairs(tgts) do
				if #dams.descs > 1 then
					game.uiset.logdisplay(self:logMessage(src, dams.srcSeen, target, dams.tgtSeen, "#Source# 击中 #Target# 造成 %s (%0.0f 总伤害)%s。", table.concat(dams.descs, ", "), dams.total, dams.healing<0 and (" #LIGHT_GREEN#[%0.0f 治疗]#LAST#"):format(-dams.healing) or ""))
				else
					if dams.healing >= 0 then
						game.uiset.logdisplay(self:logMessage(src, dams.srcSeen, target, dams.tgtSeen, "#Source# 击中 #Target# 造成 %s 伤害。", table.concat(dams.descs, ", ")))
					elseif src == target then
						game.uiset.logdisplay(self:logMessage(src, dams.srcSeen, target, dams.tgtSeen, "#Source# 受到 %s。", table.concat(dams.descs, ", ")))
					else
						game.uiset.logdisplay(self:logMessage(src, dams.srcSeen, target, dams.tgtSeen, "#Target# 从 #Source#处受到%s。", table.concat(dams.descs, ", ")))
					end
				end
				local rsrc = real_src.resolveSource and real_src:resolveSource() or real_src
				local rtarget = target.resolveSource and target:resolveSource() or target
				local x, y = target.x or -1, target.y or -1
				local sx, sy = self.level.map:getTileToScreen(x, y, true)
				if target.dead then
					if dams.tgtSeen and (rsrc == self.player or rtarget == self.player or self.party:hasMember(rsrc) or self.party:hasMember(rtarget)) then
						self.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, rng.float(-2.5, -1.5), ("Kill (%d)!"):format(dams.total), {255,0,255}, true)
						self:delayedLogMessage(target, nil,  "death", self:logMessage(src, dams.srcSeen, target, dams.tgtSeen, "#{bold}##Source#杀死了#Target#!#{normal}#"))
					end
				elseif dams.total > 0 or dams.healing == 0 then
					if dams.tgtSeen and (rsrc == self.player or self.party:hasMember(rsrc)) then
						self.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, rng.float(-3, -2), tostring(-math.ceil(dams.total)), {0,255,dams.is_crit and 200 or 0}, dams.is_crit)
					elseif dams.tgtSeen and (rtarget == self.player or self.party:hasMember(rtarget)) then
						self.flyers:add(sx, sy, 30, (rng.range(0,2)-1) * 0.5, -rng.float(-3, -2), tostring(-math.ceil(dams.total)), {255,dams.is_crit and 200 or 0,0}, dams.is_crit)
					end
				end
			end
		end
	end
	if self.delayed_death_message then game.log(self.delayed_death_message) end
	self.delayed_death_message = nil
	self.delayed_log_damage = {}
end

return _M
