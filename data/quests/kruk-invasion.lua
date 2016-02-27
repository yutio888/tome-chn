questCHN["Homeland"] = {
	name = "家园",
	description = function(desc)
		
		desc = desc:gsub("The giants have breached the mountain",""):gsub("side of Kruk pride!","巨人们已经进犯了克鲁克部族的靠山侧！"):gsub("-","")
		desc = desc:gsub("They are invading the town just when most of our forces are outside.","他们进攻了城镇，而我们的部队却还在外面。")
		desc = desc:gsub("Only you and few others are left to close the breach by collapsing the tunnel from the inside.","只有你和少量同伴还留在这里，必须炸毁他们的隧道，封锁突破口。")
		desc = desc:gsub("You have collapsed the tunnel, saving the Pride. For now.","你成功炸毁了隧道，挽救了部落的燃眉之急")
		desc = desc:gsub("You must place the bomb at the end of the tunnel to destroy it.","你必须在隧道尽头安装炸弹来炸毁它。")

		return desc
	end}
