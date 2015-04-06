function emote_chn_get(e)
	if not e then return nil end
	if emote_chn[e] then return emote_chn[e]
	elseif e:find("! We will hold the line!") then
		e = e:gsub("Go","去吧 ")
		e = e:gsub("! We will hold the line!","！我们会守住这里！")
	elseif e:find(" go to the west, and find Kruk Pride!") then
		e = e:gsub(" go to the west, and find Kruk Pride!","往西方走，找到克鲁克部落!")
	elseif e:find(" go to the southeast, and tell Aeryn what happened to me!") then
		e = e:gsub(" go to the southeast, and tell Aeryn what happened to me!","往东南方走，把我的事情报告给艾琳！")
	end
	return e
end

emote_chn = {}
emote_chn["Ra'kk kor merk ZUR!!!"] = "啊呃……咔咔……呜呃……！"
emote_chn["Hey you. Come here."] = "喂！说你呢，到我这儿来！"
emote_chn["I am free!"] = "我自由啦！"
emote_chn["At last, freedom!"] = "终于，我自由啦！"
emote_chn["Thanks for this!"] = "非常感谢！"
emote_chn["The mental hold is gone!"] = "精神枷锁终于解除了！"
emote_chn["GRrrrrrllllll!"] = "噶呃～！"
emote_chn["Activating defenses. Targetting hostile. **DESTRUCTION**!"] = "启动防御系统，瞄准目标，**启动摧毁命令**！"
emote_chn["Sacrifice for the Way!"] = "为维网而献身！"
emote_chn["Meet the guardian!"] = "去见守卫！"
emote_chn["Victory is mine!"] = "胜利是属于我的！"
emote_chn["LET US BE BOUND!"] = "我们合体吧！"
emote_chn["So be it... Die now!"] = "那好……你去死吧！"
emote_chn["If you refuse to see reason, you leave me no choice!"] = "既然你不听我解释，那我别无选择！"
emote_chn["As you wish. It did not have to come to this..."] = "如你所愿吧，本来不至于如此……"
emote_chn["You think so? Die."] = "是么？那去死吧！"
emote_chn["ARRGGggg... You are alone! You will be destroyed!"] = "啊噶……只有你一个人了！我要毁灭你！"
emote_chn["DIE!"] = "去死！"
emote_chn["My soul for her!"] = "我的灵魂属于她！"
emote_chn["The Dark Queen shall reign!"] = "黑暗女王会再次降临！"
emote_chn["Take me! Take me!"] = "杀了我！杀了我！"
emote_chn["From death comes life!"] = "至于死地而复生！"
emote_chn["This is too soon!"] = "一切都将到来！"
emote_chn["No the ritual will weaken!"] = "住手！不能破坏仪式！"
emote_chn["This place is corrupted! I will cleanse it! Protect me while I do it!"] = "这地方快塌了！我会清理道路！为我掩护！"
emote_chn["Damn you, you only postpone your death! Fyrk!"] = "见鬼，你不过是在拖延你的死期！我＠＃％！"