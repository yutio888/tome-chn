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

--------------------------------------------------------------------------
-- Tannen lore
--------------------------------------------------------------------------

newLore{
	id = "tannen-level1",
	category = "tannen's tower",
	name = "Welcome to your cell",
	lore = [[A Note to the Adventurer:

I am truly sorry about this; had circumstances been different, we could've been allies, my weapons and magic letting you fight the hordes of threats to Maj'Eyal.  As it stands, however, your continued existence is highly inconvenient to me.

See, my funding comes from the merchants of Last Hope, who want a functioning portal and will stop paying once they have one; furthermore, my portal research has proved to be a very useful cover story for the other experiments I'm conducting here.  Now that you've gotten a portal working, and will want to use it in full view of the city, I'm out of a job - and there is so much more knowledge for me to find!  The medical applications of necromancy, for one - the only other source of data on this subject went missing shortly after her husband's death, and everyone else has a Ziguranth-like fervor against the idea of using that magic baseline in any way whatsoever.  Also, selective drake breeding programs, experiments on zealots to shatter their anti-magic barriers, studying demons to learn more about their altered biologies and steal that magic for our own militaries...  I could go on, but I'd rather not waste enchanted ink.  The point is, you using the portal without further injury would mean an end to my experiments.  Ideally, you need to disappear, but if you were to emerge from my basement, wounded and raving with wild eyes about impossible beasts in the basement of my humble tower...  well, that'd just further my case that portals need more research to be used safely, wouldn't it?

#{italic}#As you move on to the next paragraph, you notice that everything above it has faded away, and the scroll is beginning to grow warm in your hands.#{normal}#

Worry not, though - you can still help the world, by devoting yourself to my quest for knowledge!  My sources have told me that you've grown exponentially more powerful since you first started making a name for yourself, and you continue to cause prodigious amounts of destruction.  The modified portal I used on you had about a 33% chance of draining some of the power you've accumulated; if you're feeling exhausted, simply lay down and wait for my imp servants to collect you for further testing.  If you aren't, however: I've sealed the way up, and placed the switches in each of the subject holding pens on this floor.  You can fight your way through them, and I'll be watching to see how a creature of your power fares against different types of foes.  I'm sure you'll want to get to the top floor and kill me in revenge, and I encourage you to try!  You may die, but the data you provide will be immortal - and if I can have my drolem subdue you non-lethally, I'll send you back to the bottom and repeat the experiment with tweaked parameters.  We can keep repeating this until I find your breaking point, or figure out what makes you so special, at which point you'll be held until I can work on a reliable method of controlling your mind.  And on the off chance that you do actually manage to kill me...  try not to do too much damage to my notes, please?  Knowledge and progress are bigger matters than either of us; don't let your spite doom thousands of lives that could rely on my research in the future.

Oh, and I can't risk this note getting into anyone else's hands, can I?  It's going to catch fire a few seconds after you're done reading.  Please drop it before it does - you having burnt hands isn't part of the experiment.

#{italic}#You throw the paper away.  After about fifteen seconds, it fizzles, then bursts into flame, not even leaving ashes behind.#{normal}#]],
}

newLore{
	id = "tannen-level2",
	category = "tannen's tower",
	name = "Personal note (1)",
	lore = [[Angolwen is too timid.  Too paranoid about repeating the mistakes of the past.  Too cautious and infuriatingly non-pragmatic.  Too prone to avoiding the "little sins," ignoring the big picture.  I've told them again and again that our ancestors' mistake wasn't trying to use the Sher'Tul portals, it was trying to weaponize them before we understood how they worked - couldn't we have plundered the Nargol facility for more data, or started kidnapping orc scouting parties as experimental subjects?  Couldn't we have tried to learn more about the Sher'Tul _before_ desperation pushed us into blowing up half of the world?  No, that was "forbidden" magic, "too powerful for mortals to tamper with," right up until we realized we needed all that power after all.  Like a pacifist finally picking up a flail to defend himself, only to bash himself in the head with it, our lack of familiarity led to catastrophe.

My arguments have just gotten me blank stares and an increasing amount of whispering behind my back (aside from a young couple whose abrupt departure might've been inspired by a particularly passionate rant in response to a lecture on "ethics").  Some of them have even resorted to deflecting my arguments, blaming them on my lack of magical power and saying I've spent too much time working on my drolem!  They think they can inspire the world and protect it from danger without getting their hands dirty; the orc invasions proved that, no, they can't, and I fear that if the demons ever start arriving in full force, we'll be even more woefully unprepared for it.  We even cower from the Ziguranth, no matter how many people die from diseases our healers could cure if they could roam freely, and no matter how easily we could find a way around their defenses if we started capturing a few of their agents.

Well, I won't have it.  I've been selling potions and inscriptions on the side for a couple of years now, in spite of Angolwen's regulations, and managed to amass enough money to set up a laboratory far away from Angolwen.  There, I intend to do the experiments my cowardly, squeamish peers won't.  I'm sure they won't approve, but I'm beyond caring - there are certain things we need to know before it's too late, and if a few zealots or criminals die in the process, it won't matter when my data saves countless lives in the long run.  Construction begins tomorrow - I've got three separate sets of contractors lined up to work on it, so none know the tower's full layout, and I've made arrangements with powerful merchants in Last Hope so I can conduct some of my experiments publicly (they want working portals for trade, and I convinced them I won't cause another Spellblaze trying to make one), providing a convenient cover story for the more...  controversial experiments.  I can have my drolem carry in sensitive equipment so I don't have to answer any problematic questions.  I will NOT escape one band of stuck-up fools just to have another confiscate bone-giants which I spent a fortune on.
]],
}

newLore{
	id = "tannen-level3",
	category = "tannen's tower",
	name = "Personal note (2)",
	lore = [[
Well...  that was interesting.

Setting up a portal took surprisingly little effort - conjured replicas of a Blood-Runed Athame and a Resonating Diamond work perfectly for setting up a portal, as it turns out, even if it burns them out after making just one.  This solution wouldn't work for the Orb of Many Ways, given that if it shorts out after one use, that means you're trapped on the other side of the portal, so I started working on a more tangible replica.  I noticed that most of them were disrupted by some form of interference, maybe echoes from the Spellblaze; my latest attempt at a more permanent orb was more of a curiosity than anything, an attempt to use those waves as constructive interference to lock onto their source.  I tossed a bandit through (my drolem's flight and relative silence have proven to be very convenient for securing test subjects!) with it tied to him, expecting him to pop into some magical maelstrom, quickly teleport back, and promptly die of terrible burn wounds (like the last four).

I didn't get a bandit back.  I got an imp.

My drolem grabbed it with its jaws, as usual, but I told it to back off on seeing the imp wasn't armed and wasn't even trying to cast any spells.  I apologized, treated its wounds, then asked it to explain what happened to my test subject.  Apparently, the demons have been running their own portal experiments!  The test subject was unharmed when he popped up in their laboratory; after the demons "questioned" him (boiling tar was involved), they realized that another inquisitive mind was on the other side, and hoped to communicate and possibly trade data with that person.  I've managed to make more progress than the demons have - either I'm a genius, or I've severely overestimated the threat the demons pose!

I've "officially" agreed to their deal - they'll supply me with materials, subjects, and what little progress they've made, and in return I've developed a modified orb that'll give them readings when it's used in a portal.  Needless to say, the readings are all bogus, and if they actually try to use those readings to make a second portal of their own, it'll blow them to bits.  The data they've given me has been VERY useful!  I've used it to construct a second altar from scratch - it still has some links to the demonic realm, but a single teleport with a genuine Orb of Many Ways will recalibrate it and cut those off completely, letting me get away scot-free with my knowledge and treasures, and preventing the demons from reaching me again.

Now, I just need to get a genuine orb before the demons catch on...]],
}

newLore{
	id = "tannen-level4",
	category = "tannen's tower",
	name = "Demon Orders",
	lore = [[Order to the Portal Excursion Team:

This egotistical human has proven to be very valuable.  We gave him only a very limited amount of data, and yet he still thinks he has the upper hand, thinking he could trick us by giving us faulty information.  No matter - the plans we gave him for a portal altar are feeding their measurements straight to us every time he uses them.  Every time he runs an experiment, we get much closer to devising a way to penetrate Eyal's shield; even the data we already have is enough to take us through one at a time, with the prohibitive limitation of creating a new Orb of Many Ways for each prospective invader.

Your orders are to play along.  Keep giving him what he says he wants - more components, more captured Eyalites, more assistants.  Above all, let him think he's got the upper hand - feign ineptitude, and never let on that we know the data he's giving us is false.  Compared to what we're getting in return, it's a bargain.]],
}
