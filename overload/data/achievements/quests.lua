-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
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

--------------- Tutorial objectives
newAchievement{
	name = "Baby steps", id = "TUTORIAL_DONE",
	desc = [[完成Tome4教学模式。]],
	tutorial = true,
	no_difficulty_duplicate = true,
	on_gain = function(_, src, personal)
		game:setAllowedBuild("tutorial_done")
	end,
}

--------------- Main objectives
newAchievement{
	name = "Vampire crusher",
	image = "npc/the_master.png",
	show = "name", huge=true,
	desc = [[杀死恐惧王座的领主。]],
}
newAchievement{
	name = "A dangerous secret",
	show = "name",
	desc = [[找到神秘法杖并通知最后的希望。]],
}
newAchievement{
	name = "The secret city",
	show = "none",
	desc = [[发现法师城。]],
}
newAchievement{
	name = "Burnt to the ground", id="APPRENTICE_STAFF",
	show = "none",
	desc = [[把湮灭法杖交给法师学徒并观看烟火。]],
}
newAchievement{
	name = "Against all odds", id = "KILL_UKRUK",
	show = "name", huge=true,
	desc = [[在埋伏战里杀死乌克鲁克。]],
}
newAchievement{
	name = "Sliders",
	image = "object/artifact/orb_many_ways.png",
	show = "name",
	desc = [[用多元水晶球激活传送门。]],
	on_gain = function()
		game:onTickEnd(function() game.party:learnLore("first-farportal") end)
	end
}
newAchievement{
	name = "Destroyer's bane", id = "DESTROYER_BANE",
	show = "name",
	desc = [[杀死毁灭者高尔布格。]],
}
newAchievement{
	name = "Brave new world", id = "STRANGE_NEW_WORLD",
	show = "name",
	desc = [[奔赴远东并加入战争。]],
}
newAchievement{
	name = "Race through fire", id = "CHARRED_SCAR_SUCCESS",
	show = "name",
	desc = [[穿过灼烧之痕的火海并成功阻止巫师们。]],
}
newAchievement{
	name = "Orcrist", id = "ORC_PRIDE",
	show = "name",
	desc = [[杀死兽族部落的首领。]],
}

--------------- Wins
newAchievement{
	name = "Evil denied", id = "WIN_FULL",
	show = "name", huge=true,
	desc = [[成功阻止虚空传送门，通关ToME。]],
}
newAchievement{
	name = "The High Lady's destiny", id = "WIN_AERYN",
	show = "name", huge=true,
	desc = [[以艾伦的牺牲来阻止虚空传送门，通关ToME。]],
}
newAchievement{
	name = "The Sun Still Shines", id = "WIN_AERYN_SURVIVE",
	show = "name", huge=true,
	desc = [[太阳骑士亚伦在最后一战存活。]],
}
newAchievement{
	name = "Selfless", id = "WIN_SACRIFICE",
	show = "name", huge=true,
	desc = [[以自己的牺牲来阻止虚空传送门，通关ToME。]],
}
newAchievement{
	name = "Triumph of the Way", id = "YEEK_SACRIFICE",
	show = "name", huge=true,
	desc = [[以自己的牺牲来换取维网在埃亚尔的传递，通关ToME。]],
}
newAchievement{
	name = "No Way!", id = "YEEK_SELFLESS",
	show = "name", huge=true,
	desc = [[关闭虚空传送门并让自己被亚伦杀死以防止维网控制埃亚尔所有生物，通关ToME。]],
}
newAchievement{
	name = "Tactical master", id = "SORCERER_NO_PORTAL",
	show = "name", huge=true,
	desc = [[在不关闭传送门的情况下，杀死2名巫师。]],
}
newAchievement{
	name = "Portal destroyer", id = "SORCERER_ONE_PORTAL",
	show = "name", huge=true,
	desc = [[在关闭1扇传送门的情况下，杀死2名巫师。]],
}
newAchievement{
	name = "Portal reaver", id = "SORCERER_TWO_PORTAL",
	show = "name", huge=true,
	desc = [[在关闭2扇传送门的情况下，杀死2名巫师。]],
}
newAchievement{
	name = "Portal ender", id = "SORCERER_THREE_PORTAL",
	show = "name", huge=true,
	desc = [[在关闭3扇传送门的情况下，杀死2名巫师。]],
}
newAchievement{
	name = "Portal master", id = "SORCERER_FOUR_PORTAL",
	show = "name", huge=true,
	desc = [[在关闭4扇传送门的情况下，杀死2名巫师。]],
}
newAchievement{
	name = "Never Look Back And There Again", id = "WIN_NEVER_WEST",
	show = "full", huge=true,
	desc = [[在没有去过旧大陆的情况下通关游戏]],
}
newAchievement{
	name = "Bikining along!", id = "WIN_BIKINI",
	show = "full", huge=true,
	desc = [[Won the game without ever taking off her bikini.]],
}
newAchievement{
	name = "Mankining it happen!", id = "WIN_MANKINI",
	show = "full", huge=true,
	desc = [[Won the game without ever taking off his mankini.]],
}
-------------- Other quests
newAchievement{
	name = "Rescuer of the lost", id = "LOST_MERCHANT_RESCUE",
	show = "name",
	desc = [[从盗贼头目手中救回商人。]],
}
newAchievement{
	name = "Poisonous", id = "LOST_MERCHANT_EVIL",
	show = "name",
	desc = [[与盗贼头目同流合污。]],
}
newAchievement{
	name = "Destroyer of the creation", id = "SLASUL_DEAD",
	show = "name",
	desc = [[杀死斯拉苏尔。]],
}
newAchievement{
	name = "Treacherous Bastard", id = "SLASUL_DEAD_PRODIGY_LEARNT",
	show = "name",
	desc = [[杀死萨拉苏尔，尽管你曾与他并肩作战并了解过纳鲁精灵的传奇。]],
}
newAchievement{
	name = "Flooder", id = "UKLLMSWWIK_DEAD",
	show = "name",
	desc = [[在做乌克勒姆斯维奇托付的任务时击败他。]],
}
newAchievement{
	name = "Gem of the Moon", id = "MASTER_JEWELER",
	show = "name", huge=true,
	desc = [[使用利米尔完成珠宝匠托付的任务“失落的知识”。]],
}
newAchievement{
	name = "Curse Lifter", id = "CURSE_ERASER",
	show = "name",
	desc = [[杀死被诅咒者本·克鲁塞达尔。]],
}
newAchievement{
	name = "Fast Curse Dispel", id = "CURSE_ALL",
	show = "name", huge=true,
	desc = [[杀死被诅咒者本·克鲁塞达尔并拯救所有伐木工。]],
}
newAchievement{
	name = "Eye of the storm", id = "EYE_OF_THE_STORM",
	show = "name",
	desc = [[从风暴魔导师厄奇斯手里成功解救德斯镇。]],
}
newAchievement{
	name = "Antimagic!", id = "ANTIMAGIC",
	show = "name",
	desc = [[在伊格兰斯训练营完成反魔法训练。]],
}
newAchievement{
	name = "Anti-Antimagic!", id = "ANTI_ANTIMAGIC",
	show = "name",
	desc = [[和罗兰精灵的同盟队伍一起，摧毁伊格兰斯训练营。]],
}
newAchievement{
	name = "There and back again", id = "WEST_PORTAL",
	show = "name", huge=true,
	desc = [[从远东打开回到马基埃亚尔的传送门。]],
}
newAchievement{
	name = "Back and there again", id = "EAST_PORTAL",
	show = "name", huge=true,
	desc = [[从马基埃亚尔打开去远东的传送门。]],
}
newAchievement{
	name = "Arachnophobia", id = "SPYDRIC_INFESTATION",
	show = "name",
	desc = [[清除蜘蛛威胁。]],
}
newAchievement{
	name = "Clone War", id = "SHADOW_CLONE",
	show = "name",
	desc = [[击败你自己的影子。]],
}
newAchievement{
	name = "Home sweet home", id = "SHERTUL_FORTRESS",
	show = "name",
	desc = [[除去威尔德林兽并控制伊克格，夏·图尔堡垒成为你的私有物。]],
}
newAchievement{
	name = "Squadmate", id = "NORGAN_SAVED",
	show = "name",
	desc = [[你和同伴诺尔甘从瑞库纳死里逃生。]],
}
newAchievement{
	name = "Genocide", id = "GREATMOTHER_DEAD",
	show = "name", huge=true,
	desc = [[在繁衍地穴中杀死兽族王后，这对兽族来说不啻于一场灾难。]],
}
newAchievement{
	name = "Savior of the damsels in distress", id = "MELINDA_SAVED",
	show = "name",
	desc = [[从卡洛·斐济邪教手中把梅琳达从厄运中拯救出来。]],
}
newAchievement{
	name = "Impossible Death", id = "PARADOX_NOW",
	show = "name",
	desc = [[被未来的自己杀死。]],
	on_gain = function(_, src, personal)
		if world:hasAchievement("PARADOX_FUTURE") then world:gainAchievement("PARADOX_FULL", src) end
	end,
}
newAchievement{
	name = "Self-killer", id = "PARADOX_FUTURE",
	show = "name",
	desc = [[杀死未来的自己。]],
	on_gain = function(_, src, personal)
		if world:hasAchievement("PARADOX_NOW") then world:gainAchievement("PARADOX_FULL", src) end
	end,
}
newAchievement{
	name = "Paradoxology", id = "PARADOX_FULL",
	show = "name",
	desc = [[你和未来的自己同归于尽。]],
}
newAchievement{
	name = "Explorer", id = "EXPLORER",
	show = "name",
	desc = [[同一角色通关夏·图尔堡垒的随机迷宫7次以上。]],
}
newAchievement{
	name = "Orbituary", id = "ABASHED_EXPANSE",
	show = "name",
	desc = [[控制次元浮岛使其稳定在轨道上。]],
}
newAchievement{
	name = "Wibbly Wobbly Timey Wimey Stuff", id = "UNHALLOWED_MORASS",
	show = "name",
	desc = [[杀死编织者女皇和时空污秽魔。]],
}
newAchievement{
	name = "Matrix style!", id = "ABASHED_EXPANSE_NO_BLAST",
	show = "full", huge=true,
	desc = [[探索完整个次元浮岛并且毫发无损。我闪！]],
	can_gain = function(self, who, zone)
		if not who:isQuestStatus("start-archmage", engine.Quest.DONE) then return false end
		if zone.void_blast_hits and zone.void_blast_hits == 0 then return true end
	end,
}
newAchievement{
	name = "The Right thing to do", id = "RING_BLOOD_KILL",
	show = "name",
	desc = [[你在血色之环做出了正确的选择并处置了血色领主。]],
}
newAchievement{
	name = "Thralless", id = "RING_BLOOD_FREED",
	show = "full",
	mode = "player",
	desc = [[在奴隶营解救至少30名奴隶。]],
	can_gain = function(self)
		self.nb = (self.nb or 0) + 1
		if self.nb >= 30 then return true end
	end,
	track = function(self) return tstring{tostring(self.nb or 0)," / 30"} end,
}
newAchievement{
	name = "Lost in translation", id = "SUNWALL_LOST",
	show = "name",
	desc = [[在斯拉伊什沼泽摧毁娜迦传送门，并被带回旧大陆。]],
}
newAchievement{
	name = "Dreaming my dreams", id = "ALL_DREAMS",
	show = "full",
	desc = [[经历并完成达格罗斯火山的梦境。]],
	mode = "world",
	can_gain = function(self, who, kind)
		self[kind] = true
		if self.mice and self.lost then return true end
	end,
	track = function(self)
		return tstring{tostring(
			(self.mice and 1 or 0) +
			(self.lost and 1 or 0)
		)," / 2"}
	end,
	on_gain = function(_, src, personal)
		game:setAllowedBuild("psionic")
		game:setAllowedBuild("psionic_solipsist", true)
	end,
}
newAchievement{
	name = "Oozemancer", id = "OOZEMANCER",
	show = "name",
	desc = [[杀死堕落的粘液使者。]],
}
newAchievement{
	name = "Lucky Girl", id = "MELINDA_LUCKY",
	show = "name",
	desc = [[再次拯救梅琳达并邀请她到堡垒去。]],
}
