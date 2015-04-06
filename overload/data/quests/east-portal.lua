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

name = "Back and there again"
desc = function(self, who)
	local desc = {}
	desc[#desc+1] = "You have created a portal back to Maj'Eyal. You should try to talk to someone in Last Hope about establishing a link back."

	if self:isCompleted("talked-elder") then
		desc[#desc+1] = "You talked to the Elder in Last Hope who in turn told you to talk to Tannen, who lives in the north of the city."
	end

	if self:isCompleted("gave-orb") then
		desc[#desc+1] = "You gave the Orb of Many Ways to Tannen to study while you look for the athame and diamond in Reknor."
	end
	if self:isCompleted("withheld-orb") then
		desc[#desc+1] = "You kept the Orb of Many Ways despite Tannen's request to study it. You must now look for the athame and diamond in Reknor."
	end
	if self:isCompleted("open-telmur") then
		desc[#desc+1] = "You brought back the diamond and athame to Tannen who asked you to check the tower of Telmur, looking for a text of portals, although he is not sure it is even there. He told you to come back in a few days."
	end
	if self:isCompleted("ask-east") then
		desc[#desc+1] = "You brought back the diamond and athame to Tannen who asked you to contact Zemekkys to ask some delicate questions."
	end
	if self:isCompleted("just-wait") then
		desc[#desc+1] = "You brought back the diamond and athame to Tannen who asked you to come back in a few days."
	end
	if self:isCompleted("tricked-demon") then
		desc[#desc+1] = "Tannen has tricked you! He swapped the orb for a false one that brought you to a demonic plane. Find the exit, and get revenge!"
	end
	if self:isCompleted("trapped") then
		desc[#desc+1] = "Tannen revealed himself as the vile scum he really is and trapped you in his tower."
	end

	if self:isCompleted() then
		desc[#desc+1] = ""
		desc[#desc+1] = "#LIGHT_GREEN#* The portal to the Far East is now functional and can be used to go back.#WHITE#"
	end

	return table.concat(desc, "\n")
end

on_status_change = function(self, who, status, sub)
	if sub then
		if self:isCompleted("orb-back") and self:isCompleted("diamon-back") and self:isCompleted("athame-back") then
			self:tannen_exit(who)

			if game:getPlayer(true).alchemy_golem then
				game:setAllowedBuild("cosmetic_class_alchemist_drolem", true)
			end
		end
	end
end

create_portal = function(self, npc, player)
	self:remove_materials(player)

	-- Farportal
	local g1 = game.zone:makeEntityByName(game.level, "terrain", "FAR_EAST_PORTAL")
	local g2 = game.zone:makeEntityByName(game.level, "terrain", "CFAR_EAST_PORTAL")
	local spot = game.level:pickSpot{type="pop-quest", subtype="farportal"}
	game.zone:addEntity(game.level, g1, "terrain", spot.x, spot.y)
	game.zone:addEntity(game.level, g1, "terrain", spot.x+1, spot.y)
	game.zone:addEntity(game.level, g1, "terrain", spot.x+2, spot.y)
	game.zone:addEntity(game.level, g1, "terrain", spot.x, spot.y+1)
	game.zone:addEntity(game.level, g2, "terrain", spot.x+1, spot.y+1)
	game.zone:addEntity(game.level, g1, "terrain", spot.x+2, spot.y+1)
	game.zone:addEntity(game.level, g1, "terrain", spot.x, spot.y+2)
	game.zone:addEntity(game.level, g1, "terrain", spot.x+1, spot.y+2)
	game.zone:addEntity(game.level, g1, "terrain", spot.x+2, spot.y+2)

	player:setQuestStatus(self.id, engine.Quest.DONE)
	world:gainAchievement("EAST_PORTAL", game.player)
end

give_orb = function(self, player)
	player:setQuestStatus(self.id, engine.Quest.COMPLETED, "gave-orb")

	local orb_o, orb_item, orb_inven_id = player:findInAllInventories("多元水晶球")
	player:removeObject(orb_inven_id, orb_item, true)
	orb_o:removed()
end

withheld_orb = function(self, player)
	player:setQuestStatus(self.id, engine.Quest.COMPLETED, "withheld-orb")
end

remove_materials = function(self, player)
	local gem_o, gem_item, gem_inven_id = player:findInAllInventories("共鸣宝石")
	if gem_o then
		player:removeObject(gem_inven_id, gem_item, false)
		gem_o:removed()
	end

	local athame_o, athame_item, athame_inven_id = player:findInAllInventories("血符祭剑")
	if athame_o then
		player:removeObject(athame_inven_id, athame_item, false)
		athame_o:removed()
	end
end

open_telmur = function(self, player)
	self:remove_materials(player)

	-- Reveal entrances
	game:onLevelLoad("wilderness-1", function(zone, level)
		local g = game.zone:makeEntityByName(level, "terrain", "TELMUR")
		local spot = level:pickSpot{type="zone-pop", subtype="telmur"}
		game.zone:addEntity(level, g, "terrain", spot.x, spot.y)
		game.nicer_tiles:updateAround(game.level, spot.x, spot.y)
		game.state:locationRevealAround(spot.x, spot.y)
	end)

	game.logPlayer(game.player, "Tannen points to the location of Telmur on your map.")
	player:setQuestStatus(self.id, engine.Quest.COMPLETED, "open-telmur")
	self.wait_turn = game.turn + game.calendar.DAY * 3
end

ask_east = function(self, player)
	self:remove_materials(player)

	-- Swap the orbs! Tricky bastard!
	local orb_o, orb_item, orb_inven_id = player:findInAllInventories("多元水晶球")
	player:removeObject(orb_inven_id, orb_item, true)
	orb_o:removed()

	local demon_orb = game.zone:makeEntityByName(game.level, "object", "ORB_MANY_WAYS_DEMON")
	player:addObject(orb_inven_id, demon_orb)
	demon_orb:added()

	player:setQuestStatus(self.id, engine.Quest.COMPLETED, "ask-east")
end

tannen_tower = function(self, player)
	game:changeLevel(1, "tannen-tower", {direct_switch=true})
	player:setQuestStatus(self.id, engine.Quest.COMPLETED, "trapped")
end

tannen_exit = function(self, player)
	require("engine.ui.Dialog"):simplePopup("Back and there again", "A portal appears in the center of the tower!")
	local g = game.zone:makeEntityByName(game.level, "terrain", "PORTAL_BACK")
	game.zone:addEntity(game.level, g, "terrain", 12, 12)
end

back_to_last_hope = function(self)
	-- TP last hope
	game:changeLevel(1, "town-last-hope", {direct_switch=true})
	-- Move to the portal spot
	local spot = game.level:pickSpot{type="pop-quest", subtype="farportal-player"}
	game.player:move(spot.x, spot.y, true)
	-- Remove tannen
	local spot = game.level:pickSpot{type="pop-quest", subtype="tannen-remove"}
	game.level.map(spot.x, spot.y, engine.Map.TERRAIN, game.level.map(spot.x, spot.y-1, engine.Map.TERRAIN))

	-- Add the mage
	local g = mod.class.NPC.new{
		name="Meranas, Herald of Angolwen",
		type="humanoid", subtype="human", faction="angolwen",
		display='p', color=colors.RED,
	}
	g:resolve() g:resolve(nil, true)
	local spot = game.level:pickSpot{type="pop-quest", subtype="farportal-npc"}
	game.zone:addEntity(game.level, g, "actor", spot.x, spot.y)
	game.level.map:particleEmitter(spot.x, spot.y, 1, "teleport")
	game.nicer_tiles:postProcessLevelTiles(game.level)

	local Chat = require("engine.Chat")
	local chat = Chat.new("east-portal-end", g, game.player)
	chat:invoke()
	game.logPlayer(who, "#VIOLET#You enter the swirling portal and in the blink of an eye you are back in Last Hope.")
end
