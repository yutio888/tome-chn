questCHN["Clan of the Unicorn"] = {
	name = "独角兽部族",
	description = function(desc)
		
		desc = desc:gsub("Metash has asked you to investigate the Krimbul Clan, south of the peninsula.","马塔什希望你调查半岛南部的克里布尔部落。")
		desc = desc:gsub("A whitehoof turned mad with power is trying to lead them in a war against Kruk Pride.","一群获得了力量的白蹄变得疯狂，他们想要战争对抗克鲁克部族。")
		desc = desc:gsub("You have stopped the pitiful Nektosh, ensuring one less threat for the Pride and a future for the Whitehooves.","你阻止了可怜的纳克托沙，部落少了一个敌人，多了一个朋友，白蹄族也迎来了更光辉的命运。")
		return desc
	end}
