-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
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

newTalent{
	name = "Thick Skin",
	type = {"technique/combat-training", 1},
	mode = "passive",
	points = 5,
	require = { stat = { con=function(level) return 14 + level * 9 end }, },
	getRes = function(self, t) return self:combatTalentScale(t, 4, 15, 0.75, 0, 0, true) end,
	passives = function(self, t, p)
		self:talentTemporaryValue(p, "resists", {all = t.getRes(self, t)})
	end,
	info = function(self, t)
		local res = t.getRes(self, t)
		return ([[你 的 皮 肤 变 的 更 加 坚 硬。 增 加 所 有 伤 害 抵 抗 %0.1f%% 。]]):
		format(res)
	end,
}

newTalent{
	name = "Armour Training",
	type = {"technique/combat-training", 1},
	mode = "passive",
	no_unlearn_last = true,
	points = 5,
	require = {stat = {str = function(level) return 16 + (level + 2) * (level - 1) end}},
	ArmorEffect = function(self, t)  -- Becomes more effective with heavier armors
		if not self:getInven("BODY") then return 0 end
		local am = self:getInven("BODY")[1] or {}
--		if am.subtype == "cloth" then return 0.75
--		elseif am.subtype == "light" then return 1.0
		if am.subtype == "cloth" then return 0
		elseif am.subtype == "light" then return 0
		elseif am.subtype == "heavy" then return 1.5
		elseif am.subtype == "massive" then	return 2.0
		end
		return 0
	end,
	-- Called by _M:combatArmor in mod.class.interface.Combat.lua
	getArmor = function(self, t)  return self:getTalentLevel(t) * t.ArmorEffect(self, t) * 1.4 end,
	-- Called by _M:combatArmorHardiness in mod.class.interface.Combat.lua
	getArmorHardiness = function(self, t) -- Matches previous progression for "heavy" armor
		return math.max(0, self:combatLimit(self:getTalentLevel(t) * 5 * t.ArmorEffect(self, t), 100, 5, 3.75, 50, 37.5))
	end,
	getCriticalChanceReduction = function(self, t) -- Matches previous progression for "heavy" armor
		return math.max(0, self:combatScale(self:getTalentLevel(t) * 3.8 * (t.ArmorEffect(self, t)/2)^0.5, 3.8, 3.3, 19, 16.45, 0.75))
	end,
	on_unlearn = function(self, t)
		for inven_id, inven in pairs(self.inven) do if inven.worn then
			for i = #inven, 1, -1 do
				local o = inven[i]
				local ok, err = self:canWearObject(o)
				if not ok and err == "missing dependency" then
					game.logPlayer(self, "You cannot use your %s anymore.", o:getName{do_color=true})
					local o = self:removeObject(inven, i, true)
					self:addObject(self.INVEN_INVEN, o)
					self:sortInven()
				end
			end
		end end
	end,
--	getArmorHardiness = function(self, t) return self:getTalentLevel(t) * 10 end,
--	getArmor = function(self, t) return self:getTalentLevel(t) * 2.8 end,
--	getCriticalChanceReduction = function(self, t) return self:getTalentLevel(t) * 3.8 end,
	info = function(self, t)
		local hardiness = t.getArmorHardiness(self, t)
		local armor = t.getArmor(self, t)
		local criticalreduction = t.getCriticalChanceReduction(self, t)
		local classrestriction = ""
		if self.descriptor and self.descriptor.subclass == "Brawler" then
			classrestriction = "(注 意  当 格 斗 家 穿 戴 板 甲 时 ， 他 们 的 大 部 分 技 能 无 法 使 用 。 )"
		end
		if self:knowTalent(self.T_STEALTH) then
			classrestriction = "(注 意 当 你 穿 戴 锁  甲 时 会 干 扰 潜 行。)"
		end
		return ([[ 你 使 用 防 具 来 偏 转 攻 击 和 保 护 重 要 部 位 的 能 力 加 强 了。 
		根 据 现 有 防 具， 提 高 %d 护 甲 值 和 %d%% 护 甲 韧 性， 并 减 少 %d%% 被 暴 击 几 率。 
		( 这 项 技 能 只 对 重 甲 或 板 甲 提 供 加 成。 ) 
		在 等 级 1 时， 能 使 你 装 备 锁 甲、 金 属 手 套、 头 盔 和 重 靴。 
		在 等 级 2 时， 能 使 你 装 备 盾 牌。 
		在 等 级 3 时， 能 使 你 装 备 板 甲。
		%s]]):format(armor, hardiness, criticalreduction, classrestriction)
	end,
}

newTalent{
	name = "Combat Accuracy", short_name = "WEAPON_COMBAT",
	type = {"technique/combat-training", 1},
	points = 5,
	levelup_screen_break_line = true,
	require = { level=function(level) return (level - 1) * 4 end },
	mode = "passive",
	--getAttack = function(self, t) return self:getTalentLevel(t) * 10 end,
	getAttack = function(self, t) return self:combatTalentScale(t, 10, 50) end, -- match values at 1 and 5 for old formula
	info = function(self, t)
		local attack = t.getAttack(self, t)
		return ([[增 加 你 的 徒 手、 近 身 和 远 程 武 器 命 中 %d 点。]]):
		format(attack)
	end,
}

newTalent{
	name = "Weapons Mastery",
	type = {"technique/combat-training", 1},
	points = 5,
	require = { stat = { str=function(level) return 12 + level * 6 end }, },
	mode = "passive",
	getDamage = function(self, t) return self:getTalentLevel(t) * 10 end,
	getPercentInc = function(self, t) return math.sqrt(self:getTalentLevel(t) / 5) / 2 end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[增 加 %d 点 物 理 强 度。 同 时 增 加 剑、 斧、 狼 牙 棒 伤 害 %d%% 。]]):
		format(damage, 100*inc)
	end,
}


newTalent{
	name = "Dagger Mastery", short_name = "KNIFE_MASTERY",
	type = {"technique/combat-training", 1},
	points = 5,
	require = { stat = { dex=function(level) return 10 + level * 6 end }, },
	mode = "passive",
	getDamage = function(self, t) return self:getTalentLevel(t) * 10 end,
	getPercentInc = function(self, t) return math.sqrt(self:getTalentLevel(t) / 5) / 2 end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[增 加 %d 点 物 理 强 度。 同 时 增 加 匕 首 武 器 伤 害 %d%% 。]]):
		format(damage, 100*inc)
	end,
}

newTalent{
	name = "Exotic Weapons Mastery",
	type = {"technique/combat-training", 1},
	hide = true,
	points = 5,
	require = { stat = { str=function(level) return 10 + level * 6 end, dex=function(level) return 10 + level * 6 end }, },
	mode = "passive",
	getDamage = function(self, t) return self:getTalentLevel(t) * 10 end,
	getPercentInc = function(self, t) return math.sqrt(self:getTalentLevel(t) / 5) / 2 end,
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local inc = t.getPercentInc(self, t)
		return ([[增 加 物 理 强 度 %d 。 增 加 特 殊 武 器 伤 害 %d%% 。]]):
		format(damage, 100*inc)
	end,
}
