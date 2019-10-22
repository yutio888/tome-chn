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

local delivered_staff = game.player:resolveSource():isQuestStatus("staff-absorption", engine.Quest.COMPLETED, "survived-ukruk")

if delivered_staff then
return [[@playername@，这份报告极其重要。 

 你留在最后的希望的法杖不见了，一群兽人发动了突然袭击，守卫被他们传送到了一个密室内干掉。 
 我们的部队设法追上了其中的一个兽人，并强迫他开了口。 
 他知道的不多，但他提到了远东大陆的“主人”。 
 他提到了高尔布格，貌似是瑞库纳的一个战士头领，带队将一个神秘的包裹穿过了传送门。 

 事情非常紧急，请你调查一下这个高尔布格或者传送门。 

               #GOLD#-- 托拉克，联合王国国王。]]

else

return [[@playername@，这份报告极其重要。 

 我们的长老从古老文献中查找你提到的那个法杖的线索。 
 它的确是一件非常强大的神器，它可以从周边物体和生物身上吸收能量。 
 所以它绝对不能落入坏人的手中，很显然包括兽人。 
 你不在的时候，我们的一个巡逻队遭遇了乌克鲁克带领的一个小分队， 
 我们没法阻止他们，不过我们抓了他们中的一个。 

 他知道的不多，但他提到了远东大陆的“主人”。 
 他提到了高尔布格，貌似是瑞库纳的一个战士头领，带队将一个神秘的包 
 裹穿过了传送门。 

               #GOLD#-- 托拉克，联合王国国王。]]
end