questCHN["Mole Down, Two To Go"] = {
	name = "再一次，钻下地",
	description = function(desc)
		
		desc = desc:gsub("As you left the Gates of Morning in ruins you noticed a strange powerful tremor that seems to come from nearby.","当你离开晨曦之门的废墟，你注意到周围似乎又一股强大的震撼。")
		desc = desc:gsub("Investigating you have found a huge mechanical mole of obvious steam giant origin.","一番调查后，你找到了一个巨大的机械鼹鼠，一定是蒸汽巨人们造的。")
		desc = desc:gsub("You have crushed both the horrors and the giants, making sure no precious information will come back to the Palace of Fumes.","你击败了巨人和恐魔们，他们无法把珍贵的信息带回烟雾宫殿了。")

		return desc
	end}
