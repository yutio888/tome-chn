-- TE4 - T-Engine 4
-- Copyright (C) 2009 - 2017 Nicolas Casalini
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
require "engine.dialogs.Chat"
local slt2 = require "slt2"

--- Handle chats between the player and NPCs
-- @classmod engine.Chat
module(..., package.seeall, class.make)

--- Init
-- @string name used to load a chat file
-- @param[type=Actor] npc the NPC that the player is talking to
-- @param[type=Actor] player the player
-- @param[type=table] data
function _M:init(name, npc, player, data)
	self.quick_replies = 0
	self.chats = {}
	self.npc = npc
	self.player = player
	self.name = name
	data = setmetatable(data or {}, {__index=_G})
	self.data = data
	if not data.player then data.player = player end
	if not data.npc then data.npc = npc end

	local f, err = loadfile(self:getChatFile(name))
	if not f and err then error(err) end
	setfenv(f, setmetatable({
		setDialogWidth = function(w) self.force_dialog_width = w end,
		newChat = function(c) self:addChat(c) end,
	}, {__index=data}))
	self.default_id = f()

	self:triggerHook{"Chat:load", data=data}
end

--- Get chat file
-- Also has support for chat files in addons
-- @string file /data*/chats/{file}.lua
function _M:getChatFile(file)
	local _, _, addon, rfile = file:find("^([^+]+)%+(.+)$")
	if addon and rfile then
		return "/data-"..addon.."/chats/"..rfile..".lua"
	end
	return "/data/chats/"..file..".lua"
end

--- Switch the NPC talking
-- @param[type=Actor] npc
-- @return NPC we switched from
function _M:switchNPC(npc)
	local old = self.npc
	self.npc = npc
	return old
end

--- Adds a chat to the list of possible chats
-- @param[type=table] c
function _M:addChat(c)
	self:triggerHook{"Chat:add", c=c}

	assert(c.id, "no chat id")
	assert(c.text or c.template, "no chat text or template")
	assert(c.answers, "no chat answers")
	self.chats[c.id] = c
	print("[CHAT] loaded", c.id, c)

	-- Parse answers looking for quick replies
	for i, a in ipairs(c.answers) do
		if a.quick_reply then
			a.jump = "quick_reply"..self.quick_replies
			self:addChat{id="quick_reply"..self.quick_replies, text=a.quick_reply, answers={{"[leave]"}}}
			self.quick_replies = self.quick_replies + 1
		end
	end
end

--- Invokes a chat
-- @string[opt=self.default_id] id the id of the first chat to run
-- @return `engine.dialog.Chat`
function _M:invoke(id)
	if self.npc.onChat then self.npc:onChat() end
	if self.player.onChat then self.player:onChat() end

	local d = engine.dialogs.Chat.new(self, id or self.default_id, self.force_dialog_width or 500)
	game:registerDialog(d)
	return d
end

--- Gets the chat with the given id
-- @string id the id of the chat
-- @return `Chat`
function _M:get(id)
	local c = self.chats[id]
	if c and c.template then
		local tpl = slt2.loadstring(c.template)
		c.text = slt2.render(tpl, {data=self.data, player=self.player, npc=self.npc})
	end
	return c
end

--- Replace some keywords in the given text
-- @string text @playername@, @npcname@, @playerdescriptor.(.-)@
function _M:replace(text)
	text = text:gsub("@playername@", self.player.name):gsub("@npcname@", self.npc.name)
	text = text:gsub("@playerdescriptor.(.-)@", function(what) local q = self.player.descriptor["fake_"..what] or self.player.descriptor[what] q = s_stat_name[q] or q return q end)
	return cutChrCHN(text,25)
	--return text
end
