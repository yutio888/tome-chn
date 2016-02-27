questCHN["Stargazers"] = {
	name = "观星者",
	description = function(desc)
		
		desc = desc:gsub("Our ultimate goal on the mainland is to get rid of the Sunwall once and for all.","我们在大陆上的最终目的是一劳永逸地清除太阳堡垒的威胁。")
		desc = desc:gsub("Our scouts have noticed the Gates of Morning is being reinforced with sun and moon orbs.","我们的哨兵注意到晨曦之门使用太阳球和月亮球来进行防护")
		desc = desc:gsub("Go to the Sunwall Observatory and destroy everything there to reduce their supplies.","前往太阳堡垒观星台，摧毁它来中断他们的供应。")
		desc = desc:gsub("You have destroyed the Observatory, the Gates of Morning defenses will be weakened.","你摧毁了观星台，晨曦之门的防御被削弱了。")

		return desc
	end}
