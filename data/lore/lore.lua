load("data-chn123/lore/age-allure.lua")
load("data-chn123/lore/age-pyre.lua")
load("data-chn123/lore/angolwen.lua")
load("data-chn123/lore/ardhungol.lua")
load("data-chn123/lore/arena.lua")
load("data-chn123/lore/blighted-ruins.lua")
load("data-chn123/lore/daikara.lua")
load("data-chn123/lore/derth.lua")
load("data-chn123/lore/dreadfell.lua")
load("data-chn123/lore/elvala.lua")
load("data-chn123/lore/elvala.lua")
load("data-chn123/lore/fearscape.lua")
load("data-chn123/lore/fun.lua")
load("data-chn123/lore/high-peak.lua")
load("data-chn123/lore/infinite-dungeon.lua")
load("data-chn123/lore/iron-throne.lua")
load("data-chn123/lore/keepsake.lua")
load("data-chn123/lore/kor-pul.lua")
load("data-chn123/lore/last-hope.lua")
load("data-chn123/lore/maze.lua")
load("data-chn123/lore/misc.lua")
load("data-chn123/lore/noxious-caldera.lua")
load("data-chn123/lore/old-forest.lua")
load("data-chn123/lore/orc-prides.lua")
load("data-chn123/lore/rhaloren.lua")
load("data-chn123/lore/sandworm.lua")
load("data-chn123/lore/scintillating-caves.lua")
load("data-chn123/lore/shertul.lua")
load("data-chn123/lore/slazish.lua")
load("data-chn123/lore/spellblaze.lua")
load("data-chn123/lore/spellhunt.lua")
load("data-chn123/lore/sunwall.lua")
load("data-chn123/lore/tannen.lua")
load("data-chn123/lore/trollmire.lua")
load("data-chn123/lore/zigur.lua")

load("data-chn123/lore/demon.lua")
local PartyLore = require "mod.class.interface.PartyLore"
if PartyLore.lore_defs["destructicus"] ~= nil then
    load("data-chn123/lore/orcs/destructicus.lua")
    load("data-chn123/lore/orcs/dominion-port.lua")
    load("data-chn123/lore/orcs/emporium.lua")
end
if PartyLore.lore_defs["cults-lost-merchant-glyph"] ~= nil then
    load("data-chn123/lore/cults/misc.lua")
    load("data-chn123/lore/cults/zones.lua")
    load("data-chn123/lore/cults/dremwarves.lua")
end