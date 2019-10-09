local _M = loadPrevious(...)
local DamageType = require "engine.DamageType"
local Object = require "engine.Object"
local Map = require "engine.Map"

local function knives(self)
	local combat = {
		talented = "knife",
		sound = {"actions/melee_hit_squish", pitch=1.2, vol=1.2}, sound_miss = {"actions/melee_miss", pitch=1, vol=1.2},

		damrange = 1.4,
		physspeed = 1,
		dam = 0,
		apr = 0,
		atk = 0,
		physcrit = 0,
		dammod = {dex=0.7, str=0.5},
		melee_project = {},
		special_on_crit = {fct=function(combat, who, target)
			if not self:knowTalent(self.T_PRECISE_AIM) then return end
			if not rng.percent(self:callTalent(self.T_PRECISE_AIM, "getChance")) then return end
			local eff = rng.table{"disarm", "pin", "silence",}
			if not target:canBe(eff) then return end
			local check = who:combatAttack()
			if not who:checkHit(check, target:combatPhysicalResist()) then return end
			if eff == "disarm" then target:setEffect(target.EFF_DISARMED, 2, {})
			elseif eff == "pin" then target:setEffect(target.EFF_PINNED, 2, {})
			elseif eff == "silence" then target:setEffect(target.EFF_SILENCED, 2, {})
			end

		end},
	}
	if self:knowTalent(self.T_THROWING_KNIVES) then
		local t = self:getTalentFromId(self.T_THROWING_KNIVES)
		local t2 = self:getTalentFromId(self.T_PRECISE_AIM)
		combat.dam = 0 + t.getBaseDamage(self, t)
		combat.apr = 0 + t.getBaseApr(self, t)
		combat.physcrit = 0 + t.getBaseCrit(self,t) + t2.getCrit(self,t2)
		combat.crit_power = 0 + t2.getCritPower(self,t2)
		combat.atk = 0 + self:combatAttack()
	end
	if self:knowTalent(self.T_LETHALITY) then 
		combat.dammod = {dex=0.7, cun=0.5}
	end
	return combat
end

registerTalentTranslation{
	id = "T_THROWING_KNIVES",
	name = "飞刀投掷",
	knivesInfo = function(self, t)
		local combat = knives(self)
		local atk = self:combatAttack(combat)
		local talented = combat.talented or "knife"
		local dmg =  self:combatDamage(combat)
		local apr = self:combatAPR(combat)
		local damrange = combat.damrange or 1.1
		local crit = self:combatCrit(combat)
		local crit_mult = (self.combat_critical_power or 0) + 150
		if self:knowTalent(self.T_PRECISE_AIM) then crit_mult = crit_mult + self:callTalent(self.T_PRECISE_AIM, "getCritPower") end
		
		local stat_desc = {}
		for stat, i in pairs(combat.dammod or {}) do
			local name = engine.interface.ActorStats.stats_def[stat].short_name:capitalize()
			if self:knowTalent(self.T_STRENGTH_OF_PURPOSE) then
				if name == "Str" then name = "Mag" end
			end
			if talented == "knife" and self:knowTalent(self.T_LETHALITY) then
				if name == "Str" then name = "Cun" end
			end
			stat_desc[#stat_desc+1] = ("%d%% %s"):format(i * 100, name:gsub("Cun","灵巧"):gsub("Dex","敏捷"))
		end
		stat_desc = table.concat(stat_desc, ", ")
		return ([[射程: %d
基础伤害: %d - %d
命中: %d (%s)
护甲穿透: %d
暴击几率: %+d%%
暴击伤害: %d%%
使用属性: %s
]]):format(t.range(self, t), dmg, dmg*damrange, atk, talented:gsub("knife","飞刀"), apr, crit, crit_mult, stat_desc)
	end,
	info = function (self,t)
		local nb = t.getNb(self,t)
		local reload = t.getReload(self,t)
		local knives = knives(self)
		local weapon_damage = knives.dam
		local weapon_range = knives.dam * knives.damrange
		local weapon_atk = knives.atk
		local weapon_apr = knives.apr
		local weapon_crit = knives.physcrit
		return ([[装备腰带用来装填 %d 把飞刀, 允许你进行远程攻击. 每回合休息的时候自动装填 %d 把飞刀, 移动时只有一半效果.
		飞刀的基础强度、命中、护甲穿透、暴击几率随技能等级提升, 伤害根据匕首掌握提升.
		投掷飞刀被认为是近战攻击命中目标.
		投掷飞刀效果统计:

%s]]):format(nb, reload, t.knivesInfo(self, t))
	end,
}
registerTalentTranslation{
	id = "T_FAN_OF_KNIVES",
	name = "刀扇",
	info = function (self,t)
		return ([[额外存储 %d 把飞刀,可以一次性扔出，每把飞刀对 %d 格锥形范围内的敌人造成 %d%% 伤害 .
		如果飞刀数量多于敌人, 每个目标最多被同时击中 5 次. 飞刀无法穿透生物.]]):
		format(t.getNb(self,t), self:getTalentRadius(t), t.getDamage(self, t)*100)
	end,
}
registerTalentTranslation{
	id = "T_PRECISE_AIM",
	name = "精确瞄准",
	info = function (self,t)
		local crit = t.getCrit(self,t)
		local power = t.getCritPower(self,t)
		local chance = t.getChance(self,t)
		return ([[精准地投掷飞刀, 增加 %d%% 暴击几率、 %d%% 暴击伤害. 
此外, 飞刀暴击时还有 %d%% 几率缴械沉默或者定身敌人持续 2 回合.]])
		:format(crit, power, chance)
	end,
}
registerTalentTranslation{
	id = "T_QUICKDRAW",
	name = "快速投掷",
	info = function (self,t)
		local speed = t.getSpeed(self, t)*100
		local chance = t.getChance(self, t)
		return ([[你可以闪电般地投掷你的飞刀. 增加 %d%% 攻击速度, 近战攻击时有 %d%% 几率投掷一把飞刀随机对 7 格范围内的一名敌人造成 100%% 伤害. 
		每回合仅触发 1 次, 不会被投掷飞刀触发.]]):
		format(speed, chance)
	end,
}
registerTalentTranslation{
	id = "T_VENOMOUS_THROW",
	name = "剧毒飞刀",
	info = function (self,t)
		local t = self:getTalentFromId(self.T_VENOMOUS_STRIKE)
		local dam = 100 * t.getDamage(self,t)
		local desc = t.effectsDescription(self, t)
		return ([[投掷一把剧毒飞刀, 造成 %d%% 自然伤害并根据你当前生效的毒药造成中毒效果（和毒素爆发相同）:
		
		%s
		使用这技能将使毒素爆发进入冷却.]]):
		format(dam, desc)
	end,
}
return _M