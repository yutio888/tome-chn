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

--------------------------------------------------------------------------
-- Trollmire
--------------------------------------------------------------------------

newLore{
	id = "trollmire-note-1",
	category = "trollmire",
	name = "tattered paper scrap (trollmire)",
	lore = [[你找到了一张残破不堪的纸页。也许是一本日记条目的某部分。
“……那是一块非常美的林间空地，但是我发誓他妈的看起来像是人的大腿骨。”
……
“看到非常大的一只巨魔，幸运的是我通过其他气味甩掉了它。”]],
}

newLore{
	id = "trollmire-note-2",
	category = "trollmire",
	name = "tattered paper scrap (trollmire)",
	lore = [[你找到了一张残破不堪的纸页。也许是一本日记条目的某部分。
“……又一只巨魔, 但是这次是只又老又蠢的巨魔，想让它闻不到我的气味实在太简单了。”
……
“……发现他的宝藏就藏在不远处了，但是不得不返回来。如果你看到这个场景，救命啊！”]],
}

newLore{
	id = "trollmire-note-3",
	category = "trollmire",
	name = "tattered paper scrap (trollmire)",
	lore = [[你找到了一张残破不堪的纸页。也许是一本日记条目的某部分。
“……把这写在树上，它就在树下面等着我。他的藏宝室长不多跟体型大一点的矮人一样高。我才不要去那里。”
……
在这段记录的旁边是这块区域平面图的一部分。]],
	bloodstains = 3,
	on_learn = function(who)
		local p = game:getPlayer(true)
		p:grantQuest("trollmire-treasure")
	end,
}
