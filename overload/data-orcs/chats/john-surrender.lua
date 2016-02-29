

local Stats = require "engine.interface.ActorStats"

local function destroy(npc, player)
	local ring, item, inven_id = player:findInAllInventoriesBy("define_as", "RING_LOST_LOVE")
	if not ring then return end

	player:onTakeoff(ring, inven_id, true)
	ring.wielder.resists.all = 10
	ring.wielder.inc_damage = {all = 10}
	ring.wielder.inc_stats[Stats.STAT_STR] = 6
	ring.wielder.inc_stats[Stats.STAT_CUN] = 6
	ring.wielder.inc_stats[Stats.STAT_DEX] = 6
	ring.wielder.esp = { humanoid = 1, giant = 1 }
	ring.wielder.esp_range = 10
	player:onWear(ring, inven_id, true)

	npc:die(player)
end

local function bind(npc, player)
	local ring, item, inven_id = player:findInAllInventoriesBy("define_as", "RING_LOST_LOVE")
	if not ring then return end

	player:onTakeoff(ring, inven_id, true)

	local john = game.zone:makeEntityByName(game.level, "actor", "JOHN_SUMMON", true)
	ring.john_base = john

	ring.power = 100
	ring.max_power = 100
	ring.power_regen = 1
	ring.use_power = { name = "召唤深红骑士约翰", power = 80, use = function(self, who)
		if not who:canBe("summon") then game.logPlayer(who, "你不能召唤；你被压制了") return end

		for i = 1, 1 do
			-- Find space
			local x, y = util.findFreeGrid(who.x, who.y, 5, true, {[engine.Map.ACTOR]=true})
			if not x then break end

			local john = self.john_base:cloneFull()
			john.make_escort = nil
			john.silent_levelup = true
			john.faction = who.faction
			john.ai = "summoned"
			john.ai_real = "tactical"
			john.summoner = who
			john.summon_time = 12
			john.exp_worth = 0

			local setupSummon = getfenv(who:getTalentFromId(who.T_SPIDER).action).setupSummon
			setupSummon(who, john, x, y)
			game:playSoundNear(who, "talents/slime")

			john:doEmote(rng.table{
				"仇恨!", "苦痛!", "悔恨!", "我的爱人...", "我感觉迷茫.", "让我死吧!", "RAAAAARGGGG!",
				"你会遭报应的!", "死亡!"
			}, 120)
		end
		return {id=true, used=true}
	end }

	player:onWear(ring, inven_id, true)
	game:addEntity(ring)

	world:gainAchievement("ORCS_JOHN_CAPTURED", player)

	npc:die(player)
end

newChat{ id="welcome",
	text = [[#LIGHT_GREEN#*深红圣武士看上去极其疲惫，濒临死亡。你感觉戒指在和他共鸣，突然你意识到你能吸收他的力量来强化戒指。*#WHITE#
来杀了我吧@playername@! 我的生活被摧毁，我的朋友被杀死，我的爱人艾琳也死了。都被你无情而残忍的双手杀死了！干掉我吧，让我就这样 #{italic}#休息#{normal}#吧.]],
	answers = {
		{"#LIGHT_GREEN#[杀死他来强化戒指]#WHITE# 如你所愿!", action=destroy, jump="destroy"},
		{"#LIGHT_GREEN#[将他绑定到戒指上]#WHITE# 不，你活着对我更有用!", action=bind, jump="bind"},
	}
}

newChat{ id="destroy",
	text = [[#LIGHT_GREEN#*在你周围的邪恶能量凝聚到戒指中，吸收了约翰的剩余力量。
戒指变得更加强大了。*#WHITE#
艾琳... 我的爱人...]],
	answers = {
		{"#LIGHT_GREEN#[完成]#WHITE#"},
	}
}

newChat{ id="bind",
	text = [[#LIGHT_GREEN#*在你周围的邪恶能量凝聚到戒指中，将约翰绑定到戒指上。
戒指现在具有召唤他的能力。*#WHITE#
#{bold}#我恨你!#{normal}#]],
	answers = {
		{"#LIGHT_GREEN#[完成]#WHITE#"},
	}
}

return "welcome"
