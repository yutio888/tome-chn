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

local p = game.party:findMember{main=true}

local descs = {}
for name, q in pairs(p.quests) do
	if q.onWin then
		local order, d = q:onWin(p)
		if order and d then descs[#descs+1] = {o=order, d=d} print("[ENDING] from quest", name, order, d[1]) end
	end
end
table.sort(descs, function(a, b) return a.o < b.o end)

local desc = {}
for i, d in ipairs(descs) do
	for j, line in ipairs(d.d) do
		desc[#desc+1] = line
	end
	desc[#desc+1] = ""
end
p.winner_text = desc

return table.concat(desc, "\n")
