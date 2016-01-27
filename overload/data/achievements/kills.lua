-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2015 Nicolas Casalini
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

newAchievement{
	name = "That was close",
	show = "full", huge=true,
	desc = [[当你只剩1滴血时杀死目标。]],
}
newAchievement{
	name = "Size matters",
	show = "full",
	desc = [[在一次攻击中造成600点伤害。]],
	on_gain = function(_, src, personal)
		if src.descriptor and (src.descriptor.subclass == "Rogue" or src.descriptor.subclass == "Shadowblade") then
			game:setAllowedBuild("rogue_marauder", true)
		end
	end,
}
newAchievement{
	name = "Size is everything", id = "DAMAGE_1500",
	show = "full", huge=true,
	desc = [[在一次攻击中造成1500点伤害。]],
}
newAchievement{
	name = "The bigger the better!", id = "DAMAGE_3000",
	show = "full", huge=true,
	desc = [[在一次攻击中造成3000点伤害。]],
}
newAchievement{
	name = "Overpowered!", id = "DAMAGE_6000",
	show = "full", huge=true,
	desc = [[在一次攻击中造成6000点伤害。]],
}
newAchievement{
	name = "Exterminator",
	show = "full",
	desc = [[杀死1000个怪物。]],
	mode = "player",
	can_gain = function(self, who)
		self.nb = (self.nb or 0) + 1
		if self.nb >= 1000 then return true end
	end,
	track = function(self) return tstring{tostring(self.nb or 0)," / 1000"} end,
}
newAchievement{
	name = "Pest Control",
	image = "npc/vermin_worms_green_worm_mass.png",
	show = "full",
	desc = [[杀死1000个召唤出的害虫。]],
	mode = "player",
	can_gain = function(self, who, target)
		if target:knowTalent(target.T_MULTIPLY) or target.clone_on_hit then
			self.nb = (self.nb or 0) + 1
			if self.nb >= 1000 then return true end
		end
	end,
	track = function(self) return tstring{tostring(self.nb or 0)," / 1000"} end,
}
newAchievement{
	name = "Reaver",
	show = "full",
	desc = [[杀死1000个人形怪物。]],
	mode = "world",
	can_gain = function(self, who, target)
		if target.type == "humanoid" then
			self.nb = (self.nb or 0) + 1
			if self.nb >= 1000 then return true end
		end
	end,
	track = function(self) return tstring{tostring(self.nb or 0)," / 1000"} end,
	on_gain = function(_, src, personal)
		game:setAllowedBuild("corrupter")
		game:setAllowedBuild("corrupter_reaver", true)
	end,
}

newAchievement{
	name = "Backstabbing Traitor", id = "ESCORT_KILL",
	image = "object/knife_stralite.png",
	show = "full",
	desc = [[杀死6位请求你护送的冒险者。]],
	mode = "player",
	can_gain = function(self, who, target)
		self.nb = (self.nb or 0) + 1
		if self.nb >= 6 then return true end
	end,
	track = function(self) return tstring{tostring(self.nb or 0)," / 6"} end,
}

newAchievement{
	name = "Bad Driver", id = "ESCORT_LOST",
	show = "full",
	desc = [[在护送任务中未成功护送任何冒险者。]],
	mode = "player",
	can_gain = function(self, who, target)
		self.nb = (self.nb or 0) + 1
		if self.nb >= 9 then return true end
	end,
	track = function(self) return tstring{tostring(self.nb or 0)," / 9"} end,
}

newAchievement{
	name = "Guiding Hand", id = "ESCORT_SAVED",
	show = "full",
	desc = [[在护送任务中搭救所有的冒险者。]],
	mode = "player",
	can_gain = function(self, who, target)
		self.nb = (self.nb or 0) + 1
		if self.nb >= 9 then return true end
	end,
	track = function(self) return tstring{tostring(self.nb or 0)," / 9"} end,
}

newAchievement{
	name = "Earth Master", id = "GEOMANCER",
	show = "name",
	desc = [[杀死哈克祖并解锁石系魔法。]],
	mode = "player",
}

newAchievement{
	name = "Kill Bill!", id = "KILL_BILL",
	image = "object/artifact/bill_treestump.png",
	show = "full", huge=true,
	desc = [[用初始级别的人物杀死食人魔沼泽的比尔。]],
	mode = "player",
}

newAchievement{
	name = "Atamathoned!", id = "ATAMATHON",
	image = "npc/atamathon.png",
	show = "name", huge=true,
	desc = [[在愚蠢的启动巨型傀儡阿塔玛森后杀死它。]],
	mode = "player",
}

newAchievement{
	name = "Huge Appetite", id = "EAT_BOSSES",
	show = "full",
	desc = [[使用大地吞噬吃掉20个BOSS。]],
	mode = "player",
	can_gain = function(self, who, target)
		if target.rank < 3.5 then return false end
		self.nb = (self.nb or 0) + 1
		if self.nb >= 20 then return true end
	end,
	track = function(self) return tstring{tostring(self.nb or 0)," / 20"} end,
}

newAchievement{
	name = "Headbanger", id = "HEADBANG",
	show = "full", huge=true,
	desc = [[用铁头功艹爆20个BOSS。]],
	mode = "player",
	can_gain = function(self, who, target)
		if target.rank < 3.5 then return false end
		self.nb = (self.nb or 0) + 1
		if self.nb >= 20 then return true end
	end,
	track = function(self) return tstring{tostring(self.nb or 0)," / 20"} end,
}

newAchievement{
	name = "Are you out of your mind?!", id = "UBER_WYRMS_OPEN",
	image = "npc/dragon_multihued_multi_hued_drake.png",
	show = "name", huge=true,
	desc = [[在沃尔的军械库进入超级七彩龙的地盘。也许，离开是最好的主意。]],
	mode = "player",
}

newAchievement{
	name = "I cleared the room of death and all I got was this lousy achievement!", id = "UBER_WYRMS",
	image = "npc/dragon_multihued_multi_hued_drake.png",
	show = "name", huge=true,
	desc = [[在沃尔的军械库的“死亡之屋”杀死7只超级七彩龙。]],
	mode = "player",
	can_gain = function(self, who)
		self.nb = (self.nb or 0) + 1
		if self.nb >= 7 then return true end
	end,
}

newAchievement{
	name = "I'm a cool hero", id = "NO_DERTH_DEATH",
	image = "npc/humanoid_human_human_farmer.png",
	show = "name", huge=true,
	desc = [[在拯救德斯镇任务中没有村民死亡。]],
	mode = "player",
}

newAchievement{
	name = "Kickin' it old-school", id = "FIRST_BOSS_URKIS",
	image = "npc/humanoid_human_urkis__the_high_tempest.png",
	show = "full", huge=true,
	desc = [[杀死厄奇斯，使她掉落回城之杖。]],
	mode = "player",
}

newAchievement{
	name = "Leave the big boys alone", id = "FIRST_BOSS_MASTER",
	image = "npc/the_master.png",
	show = "full", huge=true,
	desc = [[杀死主人，使他掉落回城之杖。]],
	mode = "player",
}

newAchievement{
	name = "You know who's to blame", id = "FIRST_BOSS_GRAND_CORRUPTOR",
	image = "npc/humanoid_shalore_grand_corruptor.png",
	show = "full", huge=true,
	desc = [[杀死堕落领主，使他掉落回城之杖。]],
	mode = "player",
}

newAchievement{
	name = "You know who's to blame (reprise)", id = "FIRST_BOSS_MYSSIL",
	image = "npc/humanoid_halfling_protector_myssil.png",
	show = "full", huge=true,
	desc = [[杀死米歇尔，使她掉落回城之杖。]],
	mode = "player",
}

newAchievement{
	name = "Now, this is impressive!", id = "LINANIIL_DEAD",
	image = "npc/humanoid_human_linaniil_supreme_archmage.png",
	show = "full", huge=true,
	desc = [[杀死安格利文的超阶魔导师莱娜尼尔。]],
	mode = "player",
}

newAchievement{
	name = "Fear of Fours", id = "SLIME_TUNNEL_BOSSES",
	show = "full", huge=true,
	desc = [[杀死史莱姆通道的4个boss]],
	mode = "player",
	can_gain = function(self, who, target)
		self.nb = (self.nb or 0) + 1
		if self.nb >= 4 then return true end
	end,
	track = function(self) return tstring{tostring(self.nb or 0)," / 4"} end,
}

newAchievement{
	name = "Well trained", id = "TRAINING_DUMMY_1000000",
	show = "full", huge=true,
	desc = [[在一次训练中对假人造成攻击一百万伤害。]],
	mode = "player",
}

newAchievement{
	name = "I meant to do that...", id = "AVOID_DEATH",
	show = "full",
	desc = [[使用技能躲避50次死亡]],
	mode = "player",
	can_gain = function(self, who)
		self.nb = (self.nb or 0) + 1
		if self.nb >= 50 then return true end
	end,
	track = function(self) return tstring{tostring(self.nb or 0)," / 50"} end,
}
