

-----------------------------------------------------------------------
-- For non whitehooves
-----------------------------------------------------------------------
newChat{ id="nw-welcome",
	text = [[#LIGHT_GREEN#*在你面前站着一位引人注目的亡灵牛头人。*#WHITE#
我有一些话想对你说。]],
	answers = {
		{"好的?", jump="nw-explain", cond=function(npc, player) return not player:hasQuest("orcs+krimbul") end},
		{"梅塔什，你的氏族被解放了，暴君已经不复存在。", jump="nw-thanks", cond=function(npc, player) return player:hasQuest("orcs+krimbul") and player:isQuestStatus("orcs+krimbul", engine.Quest.DONE) end},
		{"现在不行."},
	}
}

newChat{ id="nw-explain",
	text = [[克鲁克部落的软足生物，我来到这里，是为了给你警告、道歉并请求帮助。强大的魔法力量在我们的长老-独角者纳克托沙身上觉醒，而他不能承受这股力量，逐渐疯狂。所有阻挡他的，都在他的独角射线下化为灰烬。他的射线射程极长，能穿过岩石，直至天际。
他让我们中某些人相信，他能用这股强大力量征服埃亚尔世界，同时他恐吓其他族人和他一起。
他宣布，他的第一步行动将是带着追随者们攻击克鲁克部落。]],
	answers = {
		{"[聆听]", jump="nw-explain2"},
	}
}

newChat{ id="nw-explain2",
	text = [[我们其他人都跑了，藏身在洞穴中... 凭良心说，我不应让你直面他的魔法，那一定会带来死亡。但只有抢先下手，才能拯救你的族民。他暂时不会进攻，为你赢得了一些时间。	但如果你不能在他进攻前打他个措手不及...我曾经看着他的力量穿越山脉，仿佛穿过一片树叶般轻松，软足生物。算了，不可能战胜这种魔法的。跑吧，躲起来，希望他能意外身亡，或者进一步失去理智以至于不能施法吧。]],
	answers = {
		{"我要去看看", action=function(npc, player) player:grantQuest("orcs+krimbul") end},
	}
}

newChat{ id="nw-thanks",
	text = [[我们氏族曾无数次直面灭族危机，哪怕是在我们的心脏停止跳动之后；然而，这是第一次，我们被外人的友善所拯救。没被纳克托沙和他的借口迷惑的人马上将重返魔法洞穴。在此之前，我们将加入你的部落，参与你的革命。你解放了我们，而在你脱离压迫者之前，我们也不会停下脚步。]],
	answers = {
		{"谢谢.",},
	}
}

-----------------------------------------------------------------------
-- For whitehooves
-----------------------------------------------------------------------
newChat{ id="w-welcome",
	text = [[嘿, @playername@!]],
	answers = {
		{"什么?", jump="w-explain", cond=function(npc, player) return not player:hasQuest("orcs+krimbul") end},
		{"我们自由了梅塔什，暴君被打败了！", jump="w-thanks", cond=function(npc, player) return player:hasQuest("orcs+krimbul") and player:isQuestStatus("orcs+krimbul", engine.Quest.DONE) end},
		{"现在没空."},
	}
}

newChat{ id="w-explain",
	text = [[我来这里是为了警告克鲁克部落独角者纳克托沙的危险，并请求他们的帮助。但他们有更迫切的威胁需要处理...我们应该帮他们抵抗蒸汽巨人。他们是唯一尊重我们的人，如果他们被气之部落或者联合王国摧毁，下一个就是我们。他们的成功就是我们的生存希望。

	不幸的是，他们现在分不出战士从暴君手中夺回魔法洞穴。我需要留在这保护他们。解放我们氏族的任务就交给你了，做好准备去吧。]],
	answers = {
		{"[聆听]", jump="w-explain2"},
	}
}

newChat{ id="w-explain2",
	text = [[独角者纳克托沙声称他是无可战胜无所不能的独角兽后裔。但他说的每一句话我都不信。他体内的恐怖而疯狂的魔法力量觉醒后，他用能这股力量制造护盾或者传送，甚至发射强力射线。但他瞄准似乎并不精确...他一定有着某个隐藏的弱点。勇敢战斗吧，我的白蹄伙伴，氏族的解放就交给你了!]],
	answers = {
		{"我会做到的!", action=function(npc, player) player:grantQuest("orcs+krimbul") end},
	}
}

newChat{ id="w-thanks",
	text = [[他...  他找到了一根魔棒？然后他发现能量快用完了，只能支撑到打败部落？我对此感到遗憾，但我不能原谅他牺牲如此多的白蹄族人和兽人来逃脱他疯狂能量失效的后果...
尽管如此，我个人请求你不要告诉别人他的想法。纳克托沙曾经将我们从埃亚尔深处的堕落魔法中拯救过，至少，他应该被认为是不幸死于堕落魔法的影响。

	当然，选择权在你手中；更重要是他的威胁解除了。虽然仍有人沉醉于他给予的虚假希望中，但我们马上就能夺回魔法洞穴了。我们都欠你很多。现在，我们没有什么紧迫危机，该是帮助克鲁克部落的时候了。
 祝你好运, @playername@.]],
	answers = {
		{"也祝你好运，梅塔什.",},
	}
}



if player.descriptor and player.descriptor.subrace == "Whitehoof" then
	return "w-welcome"
else
	return "nw-welcome"
end
