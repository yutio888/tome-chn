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

local _M = loadPrevious(...)

local getStatDesc = _M.getStatDesc
function _M:getStatDesc(item)

	local stat_id = item.stat
	if not stat_id then return item.desc end
	local text = tstring{}
	text:merge(item.desc:toTString())
	text:add(true, true)
	local diff = self.actor:getStat(stat_id, nil, nil, true) - self.actor_dup:getStat(stat_id, nil, nil, true)
	local color = diff >= 0 and {"color", "LIGHT_GREEN"} or {"color", "RED"}
	local dc = {"color", "LAST"}

	text:add("当前值： ", {"color", "LIGHT_GREEN"}, ("%d"):format(self.actor:getStat(stat_id)), dc, true)
	text:add("基础值： ", {"color", "LIGHT_GREEN"}, ("%d"):format(self.actor:getStat(stat_id, nil, nil, true)), dc, true, true)

	text:add({"color", "LIGHT_BLUE"}, "属性加成:", dc, true)
	if stat_id == self.actor.STAT_CON then
		local multi_life = 4 + (self.actor.inc_resource_multi.life or 0)
		text:add("生命值上限： ", color, ("%0.2f"):format(diff * multi_life), dc, true)
		text:add("物理豁免： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
	elseif stat_id == self.actor.STAT_WIL then
		if self.actor:knowTalent(self.actor.T_MANA_POOL) then
			local multi_mana = 5 + (self.actor.inc_resource_multi.mana or 0)
			text:add("法力上限： ", color, ("%0.2f"):format(diff * multi_mana), dc, true)
		end
		if self.actor:knowTalent(self.actor.T_STAMINA_POOL) then
			local multi_stamina = 2.5 + (self.actor.inc_resource_multi.stamina or 0)
			text:add("体力上限： ", color, ("%0.2f"):format(diff * multi_stamina), dc, true)
		end
		if self.actor:knowTalent(self.actor.T_PSI_POOL) then
			local multi_psi = 1 + (self.actor.inc_resource_multi.psi or 0)
			text:add("超能力上限： ", color, ("%0.2f"):format(diff * multi_psi), dc, true)
		end
		text:add("精神强度： ", color, ("%0.2f"):format(diff * 0.7), dc, true)
		text:add("精神豁免： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		text:add("法术豁免： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		if self.actor:attr("use_psi_combat") then
			text:add("命中： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		end
	elseif stat_id == self.actor.STAT_STR then
		text:add("物理强度： ", color, ("%0.2f"):format(diff), dc, true)
		text:add("负重上限： ", color, ("%0.2f"):format(diff * 1.8), dc, true)
		text:add("物理豁免： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
	elseif stat_id == self.actor.STAT_CUN then
		text:add("暴击几率： ", color, ("%0.2f"):format(diff * 0.3), dc, true)
		text:add("精神豁免： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		text:add("精神强度： ", color, ("%0.2f"):format(diff * 0.4), dc, true)
		if(mod.class.OrcCampaign) then
			text:add("蒸汽强度： ", color, ("%0.2f"):format(diff), dc, true)
		end
		if self.actor:attr("use_psi_combat") then
			text:add("命中： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		end
	elseif stat_id == self.actor.STAT_MAG then
		text:add("法术豁免： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		text:add("法术强度： ", color, ("%0.2f"):format(diff * 1), dc, true)
	elseif stat_id == self.actor.STAT_DEX then
		text:add("近身闪避： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		text:add("远程闪避： ", color, ("%0.2f"):format(diff * 0.35), dc, true)
		text:add("命中： ", color, ("%0.2f"):format(diff), dc, true)
		text:add("暴击摆脱率： ", color, ("%0.2f%%"):format(diff * 0.3), dc, true)
	end

	if self.actor.player and self.desc_def and self.desc_def.getStatDesc and self.desc_def.getStatDesc(stat_id, self.actor) then
		text:add({"color", "LIGHT_BLUE"}, "职业强度：", dc, true)
		text:add(self.desc_def.getStatDesc(stat_id, self.actor))
	end
	return text
end

return _M
