questCHN["Mystery of the Yetis"] = {
	name = "雪人之谜",
	description = function(desc)
		
		desc = desc:gsub("You have found a bit of preserved yeti muscle, probably somebody somewhere will be interested.","你找到了一些保存好的雪人肌肉，或许哪里有谁会有什么兴趣吧…")
		desc = desc:gsub("For each yeti muscle you return to the psy-machines in the ruins of a lost city you will gain a great reward.","你每找到一份雪人肌肉并交给在失落之城废墟的超能机器，你就会获得一份奖励。")
		desc = desc:gsub("You have helped the strange psionic machines and got rewards out of them. You still feel like somehow you did wrong...","你帮助了那个奇怪的机器并从那里得到了回报。可是，你总觉得你好像做错了什么…")

		return desc
	end}
