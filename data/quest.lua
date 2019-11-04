--转化任务名字 
questCHN = {}

function questCHN:getquestname(name)
	local qname = name
	if questCHN[name] then
		qname = questCHN[name].name
	elseif name:find("Escort") then
		qname = questCHN["Escort"].name(name)
	elseif name:find("Infinite Dungeon Challenge") then
		qname = questCHN["Infinite Dungeon Challenge"].name(name)
	end
	return qname
end
function questCHN:getquestdesc(name, desc)
	local qdesc = desc
	if questCHN[name] then
		qdesc = questCHN[name].description(desc)
	elseif name:find("Escort") then
		qdesc = questCHN["Escort"].description(desc)
	elseif name:find("Infinite Dungeon Challenge") then
		qdesc = questCHN["Infinite Dungeon Challenge"].description(desc)
	end
	return qdesc
end
questCHN["Hidden treasure"] = {
name = " 隐藏的财宝 ",
description = function(desc)
    desc = string.gsub(desc,"You have found all the clues leading to the hidden treasure. There should be a way on the third level of the Trollmire."," 你已经找到了所有有关秘密财宝的线索，在食人魔沼泽第三层应该能找到一条通往那里的路。")
	desc = string.gsub(desc,[[It looks extremely dangerous, however %- beware.]],[[ 注意：看样子那里非常危险。]])
	desc = string.gsub(desc,"You have slain Bill. His treasure is yours for the taking."," 你已经干掉了比尔，他的财宝现在归你了。")
	return desc
end}

questCHN["The fall of Zigur"] = {
name = " 伊格的陷落 ",
description = function(desc)
	desc = string.gsub(desc,"You decided to side with the Grand Corruptor and joined forces to assault the Ziguranth main base of power."," 你决定与大堕落者并肩战斗，加入对伊格兰斯的大本营的攻击。")
	desc = string.gsub(desc,"The Grand Corruptor died during the attack before he had time to teach you his ways."," 大堕落者还没来得及教会你他的技巧，就在战斗中战死了")
	desc = string.gsub(desc,"The defenders of Zigur were crushed, the Ziguranth scattered and weakened."," 伊格城的防御被击溃了，伊格兰斯的势力瓦解衰落了。")
	desc = string.gsub(desc,"In the aftermath you turned against the Grand Corruptor and dispatched him."," 最后，你背叛了大堕落者并杀死了他。")
	return desc
end}

questCHN["The Curse of Magic"] = {
name = " 魔法的诅咒 ",
description = function(desc)
	desc = string.gsub(desc,"You have been invited to join a group called the Ziguranth, dedicated to opposing magic."," 你被邀请参加一个叫做伊格兰斯的组织，致力于对抗魔法。")
	return desc
end}

questCHN["The Arena"] = {
name = " 竞技场 ",
description = function(desc)
	desc = string.gsub(desc,"Seeking wealth, glory, and a great fight, you challenge the Arena!"," 寻找财富、荣耀和强大的对手，去挑战竞技场吧！ ")
	desc = string.gsub(desc,"Can you defeat your foes and become Master of Arena%?"," 你能打败你的对手，甚至打败竞技场主宰么？ ")
	desc = string.gsub(desc,"Well done! You have won the Arena: Challenge of the Master"," 干的好！你已经赢得了竞技场：竞技之王的挑战战役！ ")
	desc = string.gsub(desc,"You valiantly fought every creature the arena could throw at you and you emerged victorious!"," 你勇敢地战胜了竞技场里的所有生物并赢得了最终胜利！ ")
	desc = string.gsub(desc,"Glory to you, you are now the new master and your future characters will challenge you."," 荣耀归于你，现在你是新的竞技场主宰，你可以用以后的角色来挑战你自己。")
	return desc
end}

questCHN["The agent of the arena"] = {
name = " 竞技场代理人 ",
description = function(desc)
	desc = string.gsub(desc,"You were asked to prove your worth as a fighter by a rogue, in order to participate in the arena"," 你被一个盗贼邀请，证明你作为一个斗士的能力，以获得进入竞技场的资格。")
	desc = string.gsub(desc,"You succesfully defeated your adversaries and gained access to the arena!"," 你成功战胜了你的对手，你现在可以进入竞技场了！ ")
	return desc
end}

questCHN["The Brotherhood of Alchemists"] = {
name = " 炼金术士兄弟会 ",
description = function(desc)
	desc = string.gsub(desc,"Thanks to your timely aid, "," 谢谢你的及时帮助， ")
	desc = string.gsub(desc," is the newest member of the Brotherhood of Alchemists."," 是炼金术士兄弟会的新成员了。")
	desc = string.gsub(desc,"You aided various denizens of Maj'Eyal in their attempts to join the Brotherhood of Alchemists, though you did not prove the deciding factor for any. This year's new member is "," 虽然你没有证明那些决定性因素，你还是帮助了不同的马基埃亚尔的居民加入了炼金术士兄弟会，今年的新成员是 ")
	desc = string.gsub(desc,"Various alchemists around Maj'Eyal are competing to gain entry into the great Brotherhood of Alchemists, and one or more have enlisted your aid."," 很多马基埃亚尔的炼金术士想竞争加入强大的炼金术士兄弟会，其中有一个或者几个人请求你的帮助。")
	desc = string.gsub(desc,"You have aided "," 你帮助了 ")
	desc = string.gsub(desc," in creating an "," 制造 ")
	desc = string.gsub(desc," has completed an "," 已经制造了 ")
	desc = string.gsub(desc," without your aid.","，并没有获得你的帮助。")
	desc = string.gsub(desc,"Having failed to gain admittance to the Brotherhood of the Alchemists, "," 没有获得炼金术士兄弟会的承认， ")
	desc = string.gsub(desc," no longer needs your help making the "," 不在需要你帮忙制作 ")
	desc = string.gsub(desc," needs your help making an "," 需要你的帮助来制作 ")
	desc = string.gsub(desc,". He has given you some notes on the ingredients:","。他给了你一张写着配方的小纸条： ")
	desc = string.gsub(desc," 'Needed: one "," 需要材料： ")
	desc = string.gsub(desc," You've found the needed "," 你找到了所需的 ")
	desc = string.gsub(desc,"elixir of the fox"," 狡诈药剂 ")
	desc = string.gsub(desc,"elixir of avoidance"," 闪避药剂 ")
	desc = string.gsub(desc,"elixir of precision"," 精准药剂 ")
	desc = string.gsub(desc,"elixir of mysticism"," 神秘药剂 ")
	desc = string.gsub(desc,"elixir of the savior"," 守护药剂 ")
	desc = string.gsub(desc,"elixir of mastery"," 掌握药剂 ")
	desc = string.gsub(desc,"elixir of explosive force"," 爆炸药剂 ")
	desc = string.gsub(desc,"elixir of serendipity"," 幸运药剂 ")
	desc = string.gsub(desc,"elixir of focus"," 专注药剂 ")
	desc = string.gsub(desc,"elixir of brawn"," 蛮牛药剂 ")
	desc = string.gsub(desc,"elixir of stoneskin"," 石肤药剂 ")
	desc = string.gsub(desc,"elixir of foundations"," 领悟药剂 ")
	desc = string.gsub(desc,"Stire of Derth"," 德斯镇的斯泰尔 ")
	desc = string.gsub(desc,"Marus of Elvala"," 埃尔瓦拉的马鲁斯 ")
	desc = string.gsub(desc,"Agrimley the hermit"," 隐居者亚格雷姆利 ")
	desc = string.gsub(desc,"Ungrol of Last Hope"," 最后的希望的温格洛 ")
	desc = changeElixir(desc)
	return desc
end}

questCHN["The Doom of the World!"] = {
name = " 世界末日！ ",
description = function(desc)
	desc = string.gsub(desc,"You were sent to the Charred Scar at the heart of which lies a huge volcano. In the Age of Pyre it destroyed the old Sher'Tul ruins that stood there, absorbing much of their latent magic."," 你被送到了灼烧之痕，其中部是一个巨大的火山，在派尔纪元这里曾是夏 · 图尔遗址的所在，吸收了大量潜藏的魔法。")
	desc = string.gsub(desc,"This place is still full of that power and the orcs intend to absorb this power using the Staff of Absorption!"," 这里仍然充满了那种能量，兽人打算用吸能法杖的力量来吸收这里的能量。")
	desc = string.gsub(desc,"Whatever their plan may be, they must be stopped at all cost."," 不管他们的目的是要干什么，必须不惜一切代价阻止他们。")
	desc = string.gsub(desc,"The volcano is attacked by orcs. A few Sun Paladins made it there with you. They will hold the line at the cost of their lives to buy you some time."," 火山受到了兽人的攻击，一些太阳骑士正顶在最前线用他们的生命来帮助你争取一些时间。")
	desc = string.gsub(desc,"Honor their sacrifice; do not let the orcs finish their work!"," 向他们的献身精神致敬！不要让兽人们达成所愿。")
	desc = string.gsub(desc,"You arrived too late. The place has been drained of its power and the sorcerers have left."," 你来的太晚了，这里的能量已经被吸干，而那些法师已经离开了。")
	desc = string.gsub(desc,"Use the portal to go back to the Far East. You *MUST* stop them, no matter the cost."," 使用传送门到达远东大陆，你必须阻止他们，不惜一切代价！ ")
	desc = string.gsub(desc,"You arrived in time and interrupted the ritual. The sorcerers have departed."," 你终于及时赶来阻止了仪式，法师们被驱散了。")
	return desc
end}

questCHN["From bellow, it devours"] = {
name = " 地下吞噬者 ",
description = function(desc)
	desc = string.gsub(desc,"Your escape from Reknor got your heart pounding and your desire for wealth and power increased tenfold."," 你从瑞库纳逃了出来，你觉得你的心脏狂跳不止，你对财富和力量的渴望增加了十倍～ ")
	desc = string.gsub(desc,"Maybe it is time for you to start an adventurer's career. Deep below the Iron Throne mountains lies the Deep Bellow."," 也许是你开始冒险生涯的时候了，在钢铁王座山脉的深处有个无尽深渊地下城。")
	desc = string.gsub(desc,"It has been long sealed away but still, from time to time adventurers go there looking for wealth."," 那里已被尘封已久，但是还是不断有冒险者前去寻找财宝。")
	desc = string.gsub(desc,"None that you know of has come back yet, but you did survive Reknor. You are great."," 据你所知没有一个人能活着回来，不过你从瑞库纳幸存了下来，你比较牛 X。")
	return desc
end}

questCHN["The Island of Dread"] = {
name = " 恐怖之岛 ",
description = function(desc)
	desc = string.gsub(desc,"You have heard that near the Charred Scar, to the south, lies a ruined tower known as the Dreadfell."," 你听说在灼烧之痕南部有一个叫做恐惧王座的荒塔废墟。")
	desc = string.gsub(desc,"There are disturbing rumors of greater undead, and nobody who reached it ever returned."," 传说那里有强大的亡灵生物，凡是到达那里的人都有去无回。")
	desc = string.gsub(desc,"Perhaps you should explore it and find the truth, and the treasures, for yourself!"," 也许你应该去那里一探究竟，顺便可以找到埋藏在那里的财宝。")
	return desc
end}

questCHN["Back and there again"] = {
name = " 穿越过去 ",
description = function(desc)
	desc = string.gsub(desc,"You have created a portal back to Maj'Eyal. You should try to talk to someone in Last Hope about establishing a link back."," 你创造了一个回到马基埃亚尔的传送门，你应该试试找最后的希望的某个人谈谈关于这件事。")
	desc = string.gsub(desc,"You talked to the Elder in Last Hope who in turn told you to talk to Tannen, who lives in the north of the city."," 你和最后的希望的长者交谈，得知要去找城市北边的泰恩 ")
	desc = string.gsub(desc,"You gave the Orb of Many Ways to Tannen to study while you look for the athame and diamond in Reknor."," 你把多元水晶球交给了泰恩进一步研究，然后去瑞库纳继续寻找血符祭剑和共鸣宝石。")
	desc = string.gsub(desc,"You kept the Orb of Many Ways despite Tannen's request to study it. You must now look for the athame and diamond in Reknor."," 虽然泰恩要求拿来研究但是你还是把多元水晶球保留了下来，下一步你必须去瑞库纳寻找血符祭剑和共鸣宝石了。")
	desc = string.gsub(desc,"You brought back the diamond and athame to Tannen who asked you to check the tower of Telmur, looking for a text of portals, although he is not sure it is even there. He told you to come back in a few days."," 你把血符祭剑和共鸣宝石带回给泰恩，他告诉你去泰尔玛之塔看看，寻找那里的传送密文，他告诉几天之后再回去找他。")
	desc = string.gsub(desc,"You brought back the diamond and athame to Tannen who asked you to contact Zemekkys to ask some delicate questions."," 你把血符祭剑和共鸣宝石带回给 Tannen，他告诉你去找伊莫克斯问一些细节问题。")
	desc = string.gsub(desc,"You brought back the diamond and athame to Tannen who asked you to come back in a few days."," 你把血符祭剑和共鸣宝石带回给泰恩，他告诉你过几天再去找他。")
	desc = string.gsub(desc,"Tannen has tricked you! He swapped the orb for a false one that brought you to a demonic plane. Find the exit, and get revenge!"," 泰恩把你耍了！他换了个错的水晶球给你，把你传送到了恶魔的空间，找到出口回去找他算账！ ")
	desc = string.gsub(desc,"Tannen revealed himself as the vile scum he really is and trapped you in his tower."," 泰恩暴露出了他的确是个卑鄙的人渣，他把你囚禁在他的塔牢里。")
	desc = string.gsub(desc,"The portal to the Far East is now functional and can be used to go back."," 前往远东大陆的传送门现在可以使用了，并可以通过它返回。")
	return desc
end}

questCHN["And now for a grave"] = {
name = " 绝望的坟墓 ",
description = function(desc)
	desc = string.gsub(desc,"Ungrol of Last Hope asked you to look for his wife's friend Celia, who has been reported missing. She frequently visits her late husband's mausoleum, in the graveyard near Last Hope."," 最后的希望的温格洛要帮忙找她妻子失踪的朋友希利娅，她经常去他亡夫的陵墓那里，在最后的希望附近的墓地里。")
	desc = string.gsub(desc,"You searched for Celia in the graveyard near Last Hope, and found a note. In it, Celia reveals that she has been conducting experiments in the dark arts, in an attempt to extend her life... also, she is pregnant."," 你在最后的希望附近的目的搜寻希利娅的踪迹，找到一个纸条。从纸条中写的内容你得知，希利娅正在进行一些黑暗魔法仪式，试图延长她的寿命，另外。。。她还有孕在身！ ")
	desc = string.gsub(desc,"You have tracked Celia to her husband's mausoleum in the graveyard near Last Hope. It seems she has taken some liberties with the corpses there."," 你跟踪希利娅到了她亡夫在最后的希望附近墓地的陵墓里，似乎她在那里复活了一些尸体。")
	desc = string.gsub(desc,"You have laid Celia to rest, putting an end to her gruesome experiments."," 你埋葬了希利娅，终结了她阴森恐怖的实验。")
	desc = string.gsub(desc,"You have laid Celia to rest, putting an end to her failed experiments. You have taken her heart, for your own experiments. You do not plan to fail as she did."," 你埋葬了希利娅，终结了她失败的实验，你拿走了她的心脏为自己的实验做准备，你相信你不会重蹈她的覆辙。")
	return desc
end}

questCHN["Falling Toward Apotheosis"] = {
name = " 拜倒在神的脚下 ",
description = function(desc)
	desc = string.gsub(desc,"You have vanquished the masters of the Orc Pride. Now you must venture inside the most dangerous place of this world: the High Peak."," 你征服了兽人军团的最高领袖，现在你必须向这个世界最危险的地方挺进：巅峰。")
	desc = string.gsub(desc,"Seek the Sorcerers and stop them before they bend the world to their will."," 找到那些妄图扭曲这个世界的法师并阻止他们。")
	desc = string.gsub(desc,"To enter, you will need the four orbs of command to remove the shield over the peak."," 想要进去的话，你必须找到那四个指令水晶来移除塔顶的防护罩。")
	desc = string.gsub(desc,"The entrance to the peak passes through a place called 'the slime tunnels', probably located inside or near Grushnak Pride."," 通往塔顶的路需要穿过一个地方，叫做“史莱姆通道”，就在格鲁希纳克部落里面或者附近。")
	desc = string.gsub(desc,"You have reached the summit of the High Peak, entered the sanctum of the Sorcerers and destroyed them, freeing the world from the threat of evil."," 你到达了巅峰的最高处，进入法师们的圣所并摧毁他们，把这个世界从恶魔的威胁之中解放出来吧。")
	desc = string.gsub(desc,"You have won the game!"," 你通关了！ ")
	desc = string.gsub(desc,"You encountered Sun Paladin Aeryn who blamed you for the loss of the Sunwall. You were forced to kill her."," 你遭遇了太阳骑士艾伦，他把太阳堡垒的陷落责任全部推卸于你的头上，你不得不杀了他。")
	desc = string.gsub(desc,"You encountered Sun Paladin Aeryn who blamed you for the loss of the Sunwall, but you spared her."," 你遭遇了太阳骑士艾伦，他把太阳堡垒的陷落责任全部推卸于你的头上，但是你饶恕了他。")
	desc = string.gsub(desc,"You defeated the Sorcerers before the Void portal could open."," 你在虚空传送门打开之前击败了那些法师。")
	desc = string.gsub(desc,"You defeated the Sorcerers and Aeryn sacrificed herself to close the Void portal."," 你击败了那些法师，艾伦牺牲了她自己关闭了虚空传送门。")
	desc = string.gsub(desc,"You defeated the Sorcerers and sacrificed yourself to close the Void portal."," 你击败了那些法师，并牺牲了自己关闭虚空传送门。")
	desc = string.gsub(desc,"Well done! You have won the Tales of Maj'Eyal: The Age of Ascendancy"," 干的好！你赢得了马基埃亚尔的传说：卓越时代 ")
	desc = string.gsub(desc,"The Sorcerers are dead, and the Orc Pride lies in ruins, thanks to your efforts."," 那些法师死了，兽人部落被埋葬在废墟之中，感谢你为此付出的努力。")
	desc = string.gsub(desc,"Your sacrifice worked. Your mental energies were imbued with farportal energies. The Way radiated from the High Peak toward the rest of Eyal like a mental tidal wave."," 你的牺牲起作用了，你的精神能量被原自传送门的能量所感染，从巅峰通往埃亚尔的辐射状维网形成了一股精神冲击波。")
	desc = string.gsub(desc,"Every sentient being in Eyal is now part of the Way. Peace and happiness are enforced for all."," 所有埃亚尔有感觉的生物都成为了维网的一部分，和平和幸福被传输给大家。")
	desc = string.gsub(desc,"Only the mages of Angolwen were able to withstand the mental shock and thus are the only unsafe people left. But what can they do against the might of the Way%?"," 只有安格利文的法师能够抵制住这道精神冲击，从而他们成为了仅存的危险人类，不过他们又能对强大的维网怎么样呢？ ")
	desc = string.gsub(desc,"In the aftermath of the battle the Way tried to force you to act as a vessel to bring the Way to every sentient being."," 在战斗结束后，维网试图强迫你用你的身躯作为通道将维网传输到所有知觉生物的身体中。")
	desc = string.gsub(desc,"Through an incredible display of willpower you resisted long enough to ask Aeryn to kill you."," 然而，你强大的意志力让你支撑下来，向艾伦发送了信息。")
	desc = string.gsub(desc,"She sadly agreed and ran her sword through you, enabling you to do the last sacrifice you could for the world."," 她怀着悲痛的心情用长剑刺穿了你的身躯，你终于为这个世界做出了最后的贡献。")
	desc = string.gsub(desc,"You have prevented the portal to the Void from opening and thus stopped the Creator from bringing about the end of the world."," 你阻止了虚空传送门的开启，并终止了世界末日的到来。")
	desc = string.gsub(desc,"In a selfless act, High Sun Paladin Aeryn sacrificed herself to close the portal to the Void and thus stopped the Creator from bringing about the end of the world."," 高阶太阳骑士艾伦非常无私的牺牲了她自己，阻止了虚空传送门的开启，解救了这个世界。")
	desc = string.gsub(desc,"In a selfless act, you sacrificed yourself to close the portal to the Void and thus stopped the Creator from bringing about the end of the world."," 你非常无私的牺牲了你自己，阻止了虚空传送门的开启，解救了这个世界。")
	desc = string.gsub(desc,"The Gates of Morning have been destroyed and the Sunwall has fallen. The last remnants of the free people in the Far East will surely diminish, and soon only orcs will inhabit this land."," 晨曦之门被摧毁了，太阳堡垒陷落了。远东大陆幸存的人口比以前明显减少，很快兽人会占据整个大陆。")
	desc = string.gsub(desc,"The orc presence in the Far East has greatly been diminished by the loss of their leaders and the destruction of the Sorcerers. The free people of the Sunwall will be able to prosper and thrive on this land."," 失去了恶魔法师和兽人首领的兽人部落人口急剧减少，太阳堡垒的人们得以这片大陆上继续发展、繁荣。")
	desc = string.gsub(desc,"Maj'Eyal will once more know peace. Most of its inhabitants will never know they even were on the verge of destruction, but then this is what being a true hero means: to do the right thing even though nobody will know about it."," 马基埃亚尔再一次回复了和平和宁静，大多数居民也许并不知道他们到了差点毁灭的边缘，不过这正是称之为一个真正的英雄：就算不会被人所知也要去维护正义。")
	desc = string.gsub(desc,"You may continue playing and enjoy the rest of the world."," 你可以继续在这个世界上探险。")
	return desc
end}

questCHN["The Infinite Dungeon"] = {
name = " 无尽地下城 ",
description = function(desc)
	desc = string.gsub(desc,"You have entered the Infinite Dungeon. There is no going back now."," 你进入了无限地下城。你已不能再走回头路了。")
	desc = string.gsub(desc,"Go deep, fight, win or die in a blaze of glory!"," 深入地下城去战斗吧，胜利或者为荣耀而死！ ")
	return desc
end}

questCHN["The Sect of Kryl-Feijan"] = {
name = " 卡洛 · 斐济教派 ",
description = function(desc)
	desc = string.gsub(desc,"You discovered a sect worshipping a demon named Kryl%-Feijan in a crypt."," 你在一个地城内发现了一个膜拜恶魔的教派，卡洛 · 斐济教派 ")
	desc = string.gsub(desc,"They were trying to bring it back into the world using a human sacrifice."," 他们试图用献祭活人来召唤恶魔到这个世界上。")
	desc = string.gsub(desc,"You defeated the acolytes and saved the woman. She told you she is the daughter of a rich merchant of Last Hope."," 你打败了那些寺僧并救了这个女人的命。她告诉你她是最后的希望一个富商的女儿。")
	desc = string.gsub(desc,"You failed to protect her when escorting her out of the crypt."," 你没有能成功地将她护送出这个地城。")
	desc = string.gsub(desc,"You failed to defeat the acolytes in time %- the woman got torn apart by the demon growing inside her."," 你没能及时杀死那些寺僧，那个女人被从她体内召唤出的恶魔撕成了碎片。")
	return desc
end}

questCHN["Keepsake"] = {
name = " 往昔信物 ",
description = function(desc)
	desc = string.gsub(desc,"You have begun to look for a way to overcome the curse that afflicts you."," 你开始寻求方法以驱除一直困扰着你的诅咒。")
	desc = string.gsub(desc,"You have found a small iron acorn which you keep as a reminder of your past"," 你找到了一个小小的铁质橡果，似乎可以让你回想起以前的往事。")
	desc = string.gsub(desc,"You have destroyed the merchant caravan that you once considered family."," 你摧毁了那个你曾经视作家人的商队。")
	desc = string.gsub(desc,"Kyless, the one who brought the curse, is dead by your hand."," 克里斯，那个曾经为你带来诅咒的人，死在了你的手上。")
	desc = string.gsub(desc,"Berethh is dead, may he rest in peace."," 贝里斯已死，但愿他能安息。")
	desc = string.gsub(desc,"Your curse has changed the iron acorn which now serves as a cruel reminder of your past and present."," 你的诅咒使铁橡果成为了使你回忆起残酷过去和现实的信物。")
	desc = string.gsub(desc,"Your curse has defiled the iron acorn which now serves as a reminder of your vile nature."," 你的诅咒污浊了铁橡果，它成为了使你回想起你卑劣本性的信物。")
	desc = string.gsub(desc,"You need to find Berethh, the last person who may be able to help you."," 你得找到贝里斯，也许他是最后一个可以帮助你的人。")
	desc = string.gsub(desc,"Seek out Kyless' cave in the northern part of the meadow and end him. Perhaps the curse will end with him."," 找出位于草原北部的克里斯的洞穴，然后杀掉他，他的死也许会解除这个诅咒。")
	desc = string.gsub(desc,"Discover the meaning of the acorn and the dream."," 搞清楚铁橡果与这个梦境的含义。")
	desc = string.gsub(desc,"You may have to revist your past to unlock some secret buried there."," 你可以回忆一下过去来解开埋藏在这里的秘密。")
	return desc
end}

questCHN["From Death, Life"] = {
name = " 起死回生 ",
description = function(desc)
	desc = string.gsub(desc,"The affairs of this mortal world are trifling compared to your true goal: To conquer death."," 凡人世界的那些琐事对于你的终极目标：超越死亡来说是微不足道的。")
	desc = string.gsub(desc,"Your studies have uncovered much surrounding this subject, but now you must prepare for your glorious rebirth."," 你关于这个主题的研究已经令你发现了很多东西，现在，你必须准备你辉煌的重生仪式。")
	desc = string.gsub(desc,"You will need:"," 你需要： ")
	desc = string.gsub(desc,"You are experienced enough."," 你有足够的经验。")
	desc = string.gsub(desc,"The ceremony will require that you are worthy, experienced, and possessed of a certain amount of power"," 仪式需要你有足够的财富、经验并拥有足够的力量。")
	desc = string.gsub(desc,"You have 'extracted' the heart of one of your fellow necromancers."," 你已经取得了你死灵法师同类的心脏。")
	desc = string.gsub(desc,"The beating heart of a powerful necromancer."," 一个死灵法师跳动的心脏。")
	desc = string.gsub(desc,"Yiilkgur the Sher'tul Fortress is a suitable location."," 夏 · 图尔堡垒伊克格是个合适的地方。")
	desc = string.gsub(desc,"Yiilkgur has enough energy."," 伊克格有足够的能量。")
	desc = string.gsub(desc,"You are now on the path of lichdom."," 你已经做好了成为巫妖的准备。")
	desc = string.gsub(desc,"Use the control orb of Yiilkgur to begin the ceremony."," 使用伊克格的控制水晶来开启仪式。")
	desc = string.gsub(desc,"Your lair must amass enough energy to use in your rebirth (40 energy)."," 你的堡垒中必须积累足够的能量才能开启重生仪式。（ 40 能量） ")
	desc = string.gsub(desc,"The ceremony will require a suitable location, secluded and given to the channelling of energy"," 仪式必须在一个合适的地方进行，要足够隐蔽但是又能传输能量。")
	return desc
end}

questCHN["Storming the city"] = {
name = " 雷鸣之城 ",
description = function(desc)
	desc = string.gsub(desc,"As you approached Derth you saw a huge dark cloud over the small town."," 当你接近德斯村时你看到一个巨大的黑色乌云笼罩在小镇上方。")
	desc = string.gsub(desc,"When you entered you were greeted by an army of air elementals slaughtering the population."," 当你进入村庄时，你看到的景象：一群空气元素正在屠杀村民。")
	desc = string.gsub(desc,"You have dispatched the elementals but the cloud lingers still. You must find a powerful ally to remove it. There are rumours of a secret town in the mountains, to the southwest. You could also check out the Ziguranth group that is supposed to fight magic."," 你已经驱散了元素生物，但是天上乌云并未就此散去。 \n 西南方的山脉之中有一个传说中的小镇，你也能顺便调查一下伊格兰斯这个反魔法军团。")
	desc = string.gsub(desc,"You have learned the real threat comes from a rogue Archmage, a Tempest named Urkis. The mages of Angolwen are ready to teleport you there."," 你得知真正的威胁来自于一个堕落元素法师，名字叫厄奇斯，精通风暴法术，安格利文的法师已经准备好把你传送到那里去了。")
	desc = string.gsub(desc,"You have learned the real threat comes from a rogue Archmage, a Tempest. You have been shown a secret entrance to his stronghold."," 你得知真正的威胁来自于一个堕落元素法师，你已经找到前往他要塞的秘密通道。")
	desc = desc:gsub("You have slain Urkis.  Return to Angolwen or Zigur for a reward.", "你干掉了厄奇斯。现在返回安格列文或者伊格领取奖励吧。")
	des = desc:gsub("Urkis has been dealt with. Permanently.", "厄奇斯被永远解决掉了。")
	return desc
end}

questCHN["Trapped!"] = {
name = " 陷阱！ ",
description = function(desc)
	desc = string.gsub(desc,"You heard a plea for help and decided to investigate..."," 你听到了求救声，决定去调查一下…… ")
	desc = string.gsub(desc,"Only to find yourself trapped inside an unknown tunnel complex."," 结果落到了一个未知的复杂通道的陷阱里。")
	return desc
end}

questCHN["Melinda, lucky girl"] = {
name = " 幸运女孩梅琳达 ",
description = function(desc)
	desc = string.gsub(desc,"After rescuing Melinda from Kryl%-Feijan and the cultists you met her again in Last Hope."," 在你从卡洛 · 斐济邪教手中解救了梅琳达之后，你在最后的希望又碰到了她。")
	desc = string.gsub(desc,"Melinda was saved from the brink of death at the beach, by a strange wave of blight."," 在海滩上，梅琳达被一股奇怪的枯萎能量拯救。")
	desc = string.gsub(desc,"The Fortress Shadow said she could be cured."," 堡垒之影说她会得到治疗。")
	desc = string.gsub(desc,"Melinda decided to come live with you in your Fortress."," 梅琳达决定和你一起在堡垒里生活。")
	desc = string.gsub(desc,"The Fortress Shadow has established a portal for her so she can come and go freely."," 堡垒之影为她建造了一个传送门，他让她能够自由来去。")
	return desc
end}

questCHN["The beast within"] = {
name = " 林中的野兽 ",
description = function(desc)
	desc = string.gsub(desc,"You met a half%-mad lumberjack fleeing a small village, rambling about an untold horror lurking there, slaughtering people."," 你遇到了一个吓得魂飞魄散的伐木工人从一个小村庄里跑出来，大声喊着有个没见过的吓人的东西在里面杀人。")
	desc = string.gsub(desc," lumberjacks have died."," 个伐木工人死了。")
	return desc
end}

questCHN["An apprentice task"] = {
name = " 学徒的任务 ",
description = function(desc)
	desc = string.gsub(desc,"You met a novice mage who was tasked to collect an arcane powered artifact."," 你碰到了一个法师学徒，他被指派去搜集一件充满奥术力量的神器。")
	desc = string.gsub(desc,"He asked for your help, should you collect some that you do not need."," 他请求你的帮助，你能帮他搜集一点么。")
	desc = string.gsub(desc,"Collect an artifact arcane powered item."," 搜集一件充满奥术力量的神器。")
	return desc
end}

questCHN["Lost Knowledge"] = {
name = " 遗失的知识 ",
description = function(desc)
	desc = string.gsub(desc,"You found an ancient tome about gems."," 你发现一本关于珠宝的旧书。")
	desc = string.gsub(desc,"You should bring it to the jeweler in the Gates of Morning."," 你应该把这本书带给晨曦之门的珠宝匠看看。")
	desc = string.gsub(desc,"Limmir told you to look for the Valley of the Moon in the southern mountains.","利米尔告诉你去到南部的山脉中寻找新月峡谷 ")
	return desc
end}

questCHN["The Orbs of Command"] = {
name = " 指令水晶 ",
description = function(desc)
	desc = string.gsub(desc,"You have found an orb of command that seems to be used to open the shield protecting the High Peak."," 你找到了一个指令水晶球，似乎是用来开启巅峰护盾的钥匙。")
	desc = string.gsub(desc,"There seems to be a total of four of them. The more you have the weaker the shield will be."," 似乎一共有四个水晶球，你得到的越多，护盾的防御力越弱。")
	return desc
end}

questCHN["Let's hunt some Orc"] = {
name = " 狩猎兽人 ",
description = function(desc)
	desc = string.gsub(desc,"The elder in Last Hope sent you to the old Dwarven kingdom of Reknor, deep under the Iron Throne, to investigate the orc presence."," 最后的希望的长者将你传送到瑞库纳的古代矮人国王那里，在钢铁王座的深处，去调查兽人的行踪。")
	desc = string.gsub(desc,"Find out if they are in any way linked to the lost staff."," 查清楚他们是不是和遗失的法杖有关。")
	desc = string.gsub(desc,"But be careful %-%- even the Dwarves have not ventured in these old halls for many years."," 小心，矮人们已经很多年没有进过那些古老的大厅了。")
	return desc
end}

questCHN["The many Prides of the Orcs"] = {
name = " 兽人部落 ",
description = function(desc)
	 desc = string.gsub(desc,"Investigate the bastions of the Pride."," 调查兽人部落的基地。")
	desc = string.gsub(desc,"You have destroyed Rak'shor."," 你已经摧毁了拉克 · 肖部落。")
	desc = string.gsub(desc,"Rak'shor Pride, in the west of the southern desert."," 拉克 · 肖部落在南部的沙漠里。")
	desc = string.gsub(desc,"You have killed the master of Eastport."," 你已经杀死了东部港口的首领。")
	desc = string.gsub(desc,"A group of corrupted Humans live in Eastport on the southern coastline. They have contact with the Pride."," 一队堕落人族驻扎在南部海岸线的东部港口，他们和部落有关联。")
	desc = string.gsub(desc,"You have destroyed Vor."," 你击败了沃尔部落。")
	desc = string.gsub(desc,"Vor Pride, in the north east."," 沃尔部落在东北部。")
	desc = string.gsub(desc,"You have destroyed Grushnak."," 你击败了格鲁希纳克部落。")
	desc = string.gsub(desc,"Grushnak Pride, near a small mountain range in the north west."," 格鲁希纳克部落在西北部一个小山脉附近。")
	desc = string.gsub(desc,"You have destroyed Gorbat."," 你击败了加伯特部落。")
	desc = string.gsub(desc,"Gorbat Pride, in a mountain range in the southern desert."," 加伯特部落，在南部沙漠的一个山脉中。")
	desc = string.gsub(desc,"All the bastions of the Pride lie in ruins, their masters destroyed. High Sun Paladin Aeryn would surely be glad of the news!"," 所有的部落基地被摧毁，他们的首领被杀死了，高阶太阳骑士艾伦应该对这个消息感到很高兴！ ")
	return desc
end}

questCHN["The Way We Weren't"] = {
name = " 穿越时空 ",
description = function(desc)
	desc = string.gsub(desc,"You have met what seems to be a future version of yourself."," 你看到了一个未来的自己。")
	desc = string.gsub(desc,"You tried to kill yourself to prevent you from doing something, or going somewhere... you were not very clear."," 你尝试杀掉自己，以免他做什么你不知道的事或者到某个你也不清楚的地方。")
	desc = string.gsub(desc,"You were killed by your future self, and thus this event never occured."," 你被未来的自己杀掉了，从此这种事就再没有发生过。")
	desc = string.gsub(desc,"You killed your future self. In the future, you might wish to avoid time%-traveling back to this moment..."," 你杀死了未来的自己，在未来，你可不希望再穿越时空到这个时间点 ...")
	return desc
end}

questCHN["Important news"] = {
name = " 重要的消息 ",
description = function(desc)
	desc = string.gsub(desc,"Orcs were spotted with the staff you seek in an arid waste in the southern desert."," 在南部沙漠的一个干旱的荒地里，你发现了兽人和法杖的踪迹。")
	desc = string.gsub(desc,"You should go investigate what is happening there."," 你得去调查一下那里发生了什么事。")
	return desc
end}

questCHN["Light at the end of the tunnel"] = {
name = " 隧道尽头的亮光 ",
description = function(desc)
	desc = string.gsub(desc,"You must find a way to Maj'Eyal through the tunnel to the north of the island."," 你必须在小岛北部找到一条穿过这个通道到达马基埃亚尔的路。")
	return desc
end}

questCHN["Till the Blood Runs Clear"] = {
name = " 鲜血之环 ",
description = function(desc)
	desc = string.gsub(desc,"You have found a slavers' compound and entered it."," 你发现了一个奴隶收容所并走了进去。")
	desc = string.gsub(desc,"You decided to join the slavers and take part in their game. You won the ring of blood!"," 你决定加入那些奴隶间的游戏，你赢得了鲜血之环的胜利！ ")
	desc = string.gsub(desc,"You decided you cannot let slavers continue their dirty work and destroyed them!"," 你觉得不能让那些奴隶继续做他们肮脏工作并把他们都做掉了！ ")
	return desc
end}

questCHN["Sher'Tul Fortress"] = {
name = " 夏 · 图尔堡垒 ",
description = function(desc)
	desc = string.gsub(desc,"You found notes from an explorer inside the Old Forest. He spoke about Sher'Tul ruins sunken below the surface of the lake of Nur, at the forest's center."," 在古老森林里找到了一个探险者的笔记，里面提到在森林中心的纳尔湖底下有一个沉没的夏 · 图尔遗迹。")
	desc = string.gsub(desc,"With one of the notes there was a small gem that looks like a key."," 和笔记在一起被发现的还有个小小的宝石，样子看上去像一把钥匙。")
	desc = string.gsub(desc,"You used the key inside the ruins of Nur and found a way into the fortress of old."," 你使用这把钥匙进入了古老森林中的纳尔废墟。")
	desc = string.gsub(desc,"The Weirdling Beast is dead, freeing the way into the fortress itself."," 怪兽被杀掉了，进入森林的障碍被扫除。")
	desc = string.gsub(desc,"You have activated what seems to be a ... butler%? with your rod of recall."," 你用你的召回之杖激活了一个男。。。管家？ ")
	desc = string.gsub(desc,"You have upgraded your rod of recall to transport you to the fortress."," 你升级了你的召回之杖，可以使你传送到这片森林。")
	desc = string.gsub(desc,"You have unlocked the training room."," 你解锁了训练室。")
	desc = string.gsub(desc,"The fortress shadow has asked that you come back as soon as possible."," 现在你可以随时随地回到这里了。")
	desc = string.gsub(desc,"You have forced a recall while into an exploratory farportal zone, the farportal was rendered unusable in the process."," 你在远古传送门的空间中使用了召回之杖，传送门被损坏了。")
	desc = string.gsub(desc,"You have entered the exploratory farportal room and defeated the horror lurking there. You can now use the farportal."," 你进入了传送区域并清除了那里的怪物，你现在可以使用传送门了。")
	desc = string.gsub(desc,"You have re%-enabled the fortress flight systems. You can now fly around in your fortress!"," 你激活了森林的飞行系统，你现在可以在森林里到处飞行了！ ")
	desc = string.gsub(desc,"The fortress shadow has asked that you find an Ancient Storm Saphir, along with at least 250 energy, to re%-enable the fortress flight systems."," 你要找到古代风暴蓝宝石，还有至少 250 点能量来激活森林飞行系统。")
	desc = string.gsub(desc,"The fortress's current energy level is:"," 堡垒目前的能量是： ")
	desc = string.gsub(desc,"You have bound the transmogrification chest to the Fortress power system."," 你将转化之盒绑定至堡垒的能量系统。")
	desc = string.gsub(desc,"You have upgraded the transmogrification chest to automatically transmute metallic items into gems before transmogrifying them."," 你升级了转化之盒，它会在你转化金属物品之前自动将其变成宝石。")
	return desc
end}

questCHN["Eight legs of wonder"] = {
name = " 八脚怪物 ",
description = function(desc)
	desc = string.gsub(desc,"Enter the caverns of Ardhungol and look for Sun Paladin Rashim."," 进入阿尔德胡格山洞寻找太阳骑士拉希姆。")
	desc = string.gsub(desc,"But be careful; those are not small spiders..."," 当心，那里的蜘蛛个头可不小。。。")
	desc = string.gsub(desc,"You have killed Ungolë in Ardhungol and saved the Sun Paladin."," 你杀死了阿尔德胡格里的温格勒并救了太阳骑士。")
	return desc
end}

questCHN["A mysterious staff"] = {
name = " 奇怪的法杖 ",
description = function(desc)
	desc = string.gsub(desc,"Deep in the Dreadfell you fought and destroyed the Master, a powerful vampire."," 在恐惧王座深处你和一个强大的吸血鬼大法师战斗并杀死了他。")
	desc = string.gsub(desc,"On your way out of the Dreadfell you were ambushed by a band of orcs."," 当你走出恐惧王座的时候你受到了一队兽人小队的偷袭。")
	desc = string.gsub(desc,"They asked about the staff."," 他们想抢走法杖。")
	desc = string.gsub(desc,"On your way out of the Dreadfell you were ambushed by a band of orcs and left for dead."," 当你走出恐惧王座的时候你受到了一队兽人小队的偷袭，他们把你干掉了。")
	desc = string.gsub(desc,"They asked about the staff and stole it from you."," 他们从你那里把法杖抢走了。")
	desc = string.gsub(desc,"Go at once to Last Hope to report those events!"," 立刻到最后的希望去报告发生的情况！ ")
	desc = string.gsub(desc,"On your way out of Last Hope you were ambushed by a band of orcs."," 当你走出最后的希望的时候你中了一群兽人的埋伏。")
	desc = string.gsub(desc,"They asked about the staff and stole it from you."," 他们想从你那里抢走了法杖。")
	desc = string.gsub(desc,"You told them nothing and vanquished them."," 你没告诉他们任何事并把它们都消灭了。")
	desc = string.gsub(desc,"Go at once to Last Hope to report those events!"," 立刻到最后的希望汇报所发生的情况。")
	desc = string.gsub(desc,"In its remains, you found a strange staff. It radiates power and danger and you dare not use it yourself."," 在他的尸体上，你发现了一根奇怪的法杖，它辐射出的力量和危险使你不敢使用它。")
	desc = string.gsub(desc,"You should bring it to the elders of Last Hope in the southeast."," 你应该把它带到最后的希望西南部的长者那里给他看看。")
	return desc
end}

questCHN["Of trolls and damp caves"] = {
name = " 食人魔巢穴 ",
description = function(desc)
	desc = string.gsub(desc,"Explore the caves below the ruins of Kor'Pul and the Trollmire in search of treasure and glory!"," 到卡 · 普尔和食人魔沼泽的地下城去发现宝藏和荣耀！ ")
	desc = string.gsub(desc,"You have explored the Trollmire and vanquished Prox the Troll."," 你已经探索了食人魔巢穴并击败了食人魔普洛克斯。")
	desc = string.gsub(desc,"You have explored the Trollmire and vanquished Shax the Troll."," 你已经探索了食人魔巢穴并击败了食人魔夏克斯。")
	desc = string.gsub(desc,"You must explore the Trollmire and find out what lurks there and what treasures are to be gained!"," 你必须进入食人魔沼泽去调查那里潜伏着什么怪物并找到那里的宝藏！ ")
	desc = string.gsub(desc,"You have explored the ruins of Kor'Pul and vanquished the Shade."," 你探索了卡 · 普尔废墟并击败了暗影骷髅。")
	desc = string.gsub(desc,"You have explored the ruins of Kor'Pul and vanquished the Possessed."," 你探索了卡 · 普尔废墟并击败了强盗头目。")
	desc = string.gsub(desc,"You must explore the ruins of Kor'Pul and find out what lurks there and what treasures are to be gained!"," 你必须进入卡 · 普尔去调查那里潜伏着什么怪物并找到那里的宝藏！ ")
	return desc
end}

questCHN["Spellblaze Fallouts"] = {
name = " 魔法大爆炸的余波 ",
description = function(desc)
	desc = string.gsub(desc,"The Abashed Expanse is a part of Eyal torn apart by the Spellblaze and thrown into the void between the stars."," 次元浮岛曾是埃亚尔大陆的一部分，在魔法大爆炸中被撕裂并轰击到星辰之间的虚无之中 .")
	desc = string.gsub(desc,"It has recently begun to destabilize, threatening to crash onto Eyal, destroying everything in its path."," 现在变的越来越不稳定，有与 Eyal 大陆发生碰撞的危险，摧毁一切它所碰到的东西。")
	desc = string.gsub(desc,"You have entered it and must now stabilize three wormholes by firing any spell at them."," 你现在必须进入那里，对三个虫洞进行施法以稳定它们。")
	desc = string.gsub(desc,"Remember, the floating islands are not stable and might teleport randomly. However, the disturbances also help you: your Phase Door spell is fully controllable even if not of high level yet."," 记住，浮岛上很不稳定，有可能将你随机传送，不过也有一个好处，你可以完全控制你的相位门技能，就算你的技能等级不够高也没关系。")
	desc = string.gsub(desc,"You have explored the expanse and closed all three wormholes."," 你已经探索了整个浮岛并关闭了所有三个虫洞。")
	desc = string.gsub(desc,"You have closed"," 你关闭了 ")
	return desc
end}

questCHN["Reknor is lost!"] = {
name = " 在瑞克纳迷路了！ ",
description = function(desc)
	desc = string.gsub(desc,"You were part of a group of dwarves sent to investigate the situation of the kingdom of Reknor."," 你是被指派到瑞库纳王国去调查情况的一个矮人小分队的一员。")
	desc = string.gsub(desc,"When you arrived there you found nothing but orcs, well organized and very powerful."," 当你到达那里时，你受到了大量有组织的强力兽人的阻击。")
	desc = string.gsub(desc,"Most of your team was killed there and now you and Norgan %(the sole survivor besides you%) must hurry back to the Iron Council to bring the news."," 你队伍中大多数人被杀死，现在你和诺尔甘 ( 除你以外的唯一幸存者 ) 必须赶紧突围回到钢铁议会去汇报这里的情况。")
	desc = string.gsub(desc,"Let nothing stop you."," 不惜一切代价冲出去。")
	desc = string.gsub(desc,"Both Norgan and you made it home."," 你和诺尔甘都回到了家。")
	return desc
end}

questCHN["Into the darkness"] = {
name = " 进入黑暗 ",
description = function(desc)
	desc = string.gsub(desc,"It is time to explore some new places %-%- dark, forgotten and dangerous ones."," 是时候去一些新的地方探索一下了——那些黑暗、被遗忘和危险的地方。")
	desc = string.gsub(desc,"The Old Forest is just south%-east of the town of Derth."," 在德斯镇东南方向是古老森林。")
	desc = string.gsub(desc,"The Maze is west of Derth."," 在德斯镇西面是迷宫。")
	desc = string.gsub(desc,"The Sandworm Lair is to the far west of Derth, near the sea."," 在德斯镇远一点的西面，靠近海岸的地方是沙虫巢穴。")
	desc = string.gsub(desc,"The Daikara is on the eastern borders of the Thaloren forest."," 在自然精灵树林的东部边境那里是岱卡拉。")
	desc = string.gsub(desc,"You have explored the Old Forest and vanquished Wrathroot."," 你已经探索了古老森林并杀死了狂怒树精。")
	desc = string.gsub(desc,"You have explored the Old Forest and vanquished Shardskin."," 你已经探索了古老森林并杀死了水晶树精。")
	desc = string.gsub(desc,"You must explore the Old Forest and find out what lurks there and what treasures are to be gained!"," 你已经探索了古老森林并查清了那里潜伏的危险，还获得了那里的宝藏。")
	desc = string.gsub(desc,"You have explored the Maze and vanquished the Minotaur."," 你已经探索了迷宫并杀死了米诺陶。")
	desc = string.gsub(desc,"You have explored the Maze and vanquished the Horned Horror"," 你已经探索了迷宫并杀死了长角恐魔。")
	desc = string.gsub(desc,"You must explore the Maze and find out what lurks there and what treasures are to be gained!"," 你已经探索了迷宫并查清了那里潜伏的危险，还获得了那里的宝藏。")
	desc = string.gsub(desc,"You have explored the Sandworm Lair and vanquished their Queen."," 你已经探索了沙虫巢穴并杀死了沙虫皇后。")
	desc = string.gsub(desc,"You must explore the Sandworm Lair and find out what lurks there and what treasures are to be gained!"," 你已经探索了沙虫巢穴并查清了那里潜伏的危险，还获得了那里的宝藏。")
	desc = string.gsub(desc,"You have explored the Daikara and vanquished the huge ice dragon that dwelled there."," 你已经探索了岱卡拉并杀死了这里的冰龙。")
	desc = string.gsub(desc,"You have explored the Daikara and vanquished the huge fire dragon that dwelled there."," 你已经探索了岱卡拉并杀死了这里的火龙。")
	desc = string.gsub(desc,"You must explore the Daikara and find out what lurks there and what treasures are to be gained!"," 你已经探索了岱卡拉并查清了那里潜伏的危险，还获得了那里的宝藏。")
	return desc
end}

questCHN["Future Echoes"] = {
name = " 未来的回音 ",
description = function(desc)
	desc = string.gsub(desc,"The unhallowed morass is the name of the 'zone' surrounding Point Zero."," 混沌之沼是零点圣域周围区域的名字。")
	desc = string.gsub(desc,"The temporal spiders that inhabit it are growing restless and started attacking at random. You need to investigate what is going on."," 栖息在那里的时空蜘蛛开始变得有攻击性，你得去调查一下到底发生了什么事。")
	desc = string.gsub(desc,"You have explored the morass and destroyed the weaver queen, finding strange traces on it."," 你探索了混沌之沼并杀死了织网蛛后，发现了奇怪的痕迹。")
	desc = string.gsub(desc,"You must explore the morass."," 你必须探索混沌之沼。")
	desc = string.gsub(desc,"You have helped defend Point Zero."," 你成功守卫了零点圣域。")
	return desc
end}

questCHN["Echoes of the Spellblaze"] = {
name = " 魔法大爆炸的回音 ",
description = function(desc)
	desc = string.gsub(desc,"You have heard that within the scintillating caves lie strange crystals imbued with Spellblaze energies."," 你听说在闪光洞穴中有一些被魔法大爆炸能量影响的奇怪水晶。")
	desc = string.gsub(desc,"There are also rumours of a regenade Shaloren camp to the west."," 有传闻说西面有堕落的永恒精灵的营地。")
	desc = string.gsub(desc,"You have explored the scintillating caves and destroyed the Spellblaze Crystal."," 你已经探索了闪光洞穴，并摧毁了魔法烈焰水晶体。")
	desc = string.gsub(desc,"You must explore the scintillating caves."," 你必须探索闪光洞穴。")
	desc = string.gsub(desc,"You have explored the Rhaloren camp and killed the Inquisitor."," 你已经探索了罗兰精灵营地并杀死了检察官。")
	desc = string.gsub(desc,"You must explore the renegade Shaloren camp."," 你已经探索了堕落的永恒精灵的营地。")
	return desc
end}

questCHN["Serpentine Invaders"] = {
name = " 蛇形的侵略者 ",
description = function(desc)
	desc = string.gsub(desc,"Nagas are invading the slazish fens. The Sunwall cannot fight on two fronts; you need to stop the invaders before it is too late.\n Locate and destroy the invaders' portal."," 纳迦正在攻击斯拉伊什沼泽，太阳堡垒不能同时两线作战，你必须抓紧时间阻止那些侵略者，以免为时过晚。 \n 找到并摧毁侵略者的传送门。")
	desc = string.gsub(desc,"You have destroyed the naga portal. The invasion is stopped."," 你摧毁了纳迦的传送门，侵略者被阻止了。")
	desc = string.gsub(desc,"You are back in Var'Eyal, the Far East as the people from the west call it."," 你回到了瓦 · 埃亚尔——来自西方的人称呼远东大陆的名字。")
	desc = string.gsub(desc,"However, you were teleported to a distant land. You must find a way back to the Gates of Morning."," 然而，你被传送到了一个遥远的区域，你必须找到返回晨曦之门的方法。")
	desc = string.gsub(desc,"You must stop the nagas."," 你必须阻止那些纳迦。")
	return desc
end}

questCHN["Madness of the Ages"] = {
name = " 疯狂的岁月 ",
description = function(desc)
	desc = string.gsub(desc,"The Thaloren forest is disrupted. Corruption is spreading. Norgos the guardian bear is said to have gone mad."," 自然精灵森林陷入了混乱，到处肆虐着堕落。据说守护巨熊诺尔格斯已经陷入了疯狂。")
	desc = string.gsub(desc,"On the western border of the forest a gloomy aura has been set up. Things inside are... twisted."," 在森林的西部边境被设置了一个黑暗光环，里面的东西已陷入了扭曲。")
	desc = string.gsub(desc,"You have explored Norgos' Lair and put it to rest."," 你已经探索了诺尔格斯的巢穴并埋葬了它。")
	desc = string.gsub(desc,"You have explored Norgos' Lair and stopped the shivgoroth invasion."," 你已经探索了诺尔格斯的巢穴并阻止了寒冰元素的侵略。")
	desc = string.gsub(desc,"You must explore Norgos' Lair."," 你必须调查诺尔格斯的巢穴。")
	desc = string.gsub(desc,"You have explored the Heart of the Gloom and slain the Withering Thing."," 你已经探索了黑暗中心并杀死了凋零。")
	desc = string.gsub(desc,"You have explored the Heart of the Gloom and slain the Dreaming One."," 你已经探索了黑暗中心并杀死了梦境之眼。")
	desc = string.gsub(desc,"You must explore the Heart of the Gloom."," 你必须调查一下黑暗之心。")
	return desc
end}

questCHN["The rotting stench of the dead"] = {
name = " 腐臭的尸体 ",
description = function(desc)
	desc = string.gsub(desc,"You have been resurrected as an undead by some dark powers."," 你被黑暗力量复活了。")
	desc = string.gsub(desc,"However, the ritual failed in some way and you retain your own mind. You need to get out of this dark place and try to carve a place for yourself in the world."," 不过，复活仪式似乎出了点问题，你保留了自己的意识，你必须离开这个黑暗地方并找到属于自己的栖息地。")
	desc = string.gsub(desc,"You have found a very special cloak that will help you walk among the living without trouble."," 你发现了一个非常神奇的斗篷，可以使你在活人之中自由生活而不会陷入麻烦。")
	return desc
end}

questCHN["Following The Way"] = {
name = " 保卫维网 ",
description = function(desc)
	desc = string.gsub(desc,"You have been tasked to remove two threats to the yeeks."," 你被派去清除对夺心魔的两大威胁。")
	desc = string.gsub(desc,"Protect the Way, and vanquish your foes."," 守护维网，征服你的敌人。")
	desc = string.gsub(desc,"You have explored the underwater zone and vanquished Murgol."," 你已经探索了水下区域并击败了穆格尔。")
	desc = string.gsub(desc,"You must explore the underwater lair of Murgol."," 你必须调查一下穆格尔位于水下的巢穴。")
	desc = string.gsub(desc,"You have explored the ritch tunnels and vanquished their queen."," 你调查了里奇通道并击败了他们的皇后。")
	desc = string.gsub(desc,"You must explore the ritch tunnels."," 你必须调查一下里奇通道。")
	return desc
end}

questCHN["Strange new world"] = {
name = " 奇怪的世界 ",
description = function(desc)
	desc = string.gsub(desc,"You arrived through the farportal in a cave, probably in the Far East."," 你穿过了山洞的远古传送门，可能会到达远东大陆。")
	desc = string.gsub(desc,"Upon arrival you met an Elf and an orc fighting."," 你碰到了一个精灵在和一个兽人战斗。")
	desc = string.gsub(desc,"You decided to side with the Elven lady."," 你决定帮帮那个精灵。")
	desc = string.gsub(desc,"You decided to side with the orc."," 你决定帮帮那个兽人。")
	desc = string.gsub(desc,"Fillarel told you to go to the southeast and meet with High Sun Paladin Aeryn."," 菲拉瑞尔告诉你去东南方会见高阶太阳骑士艾伦。")
	desc = string.gsub(desc,"Krogar told you to go to the west and look for the Kruk Pride."," 克洛加尔告诉你去西面寻找克鲁克部落。")
	return desc
end}

questCHN["The Temple of Creation"] = {
name = " 造物者神庙 ",
description = function(desc)
	desc = string.gsub(desc,"Ukllmswwik asked you to take his portal to the Temple of Creation and kill Slasul who has turned mad."," 乌克勒姆斯维奇请求你穿过他的传送门到造物者神庙去杀死发疯了的萨拉苏尔。")
	desc = string.gsub(desc,"Slasul told you his side of the story. Now you must decide: which of them is corrupt%?"," 萨拉苏尔告诉了你关于他的故事，你现在必须决定：到底谁才是真正的堕落者。")
	desc = string.gsub(desc,"You have killed both Ukllmswwik and Slasul, betraying them both."," 你把乌克勒姆斯维奇和萨拉苏尔都杀掉了，同时背叛了他们两个。")
	desc = string.gsub(desc,"You have sided with Ukllmswwik and killed Slasul."," 你选择相信乌克勒姆斯维奇并杀死了萨拉苏尔。")
	desc = string.gsub(desc,"You have sided with Slasul and killed Ukllmswwik."," 你选择相信萨拉苏尔并杀死了乌克勒姆斯维奇。")
	desc = string.gsub(desc,"Slasul bound his lifeforce to yours and gave your a powerful trident in return."," 萨拉苏尔赋予你他的生命之力，并交给你一把强力的三叉戟。")
	return desc
end}

questCHN["Back and Back and Back to the Future"] = {
name = " 回到未来 ",
description = function(desc)
	desc = string.gsub(desc,"After passing through some kind of time anomaly you met a temporal warden who told you to destroy the abominations of this alternate timeline."," 穿过了异常时空你碰到了一个时空看守，他告诉你去摧毁这个变换时间线里的怪物。")
	return desc
end}

questCHN["Tutorial"] = {
name = " 教程 ",
description = function(desc)
	desc = string.gsub(desc,"You must venture in the heart of the forest and kill the Lone Wolf, who randomly attacks villagers."," 你必须进入森林的中心地带并杀死孤狼——那个肆意屠杀村民的凶手。")
	return desc
end}

questCHN["Tutorial: combat stats"] = {
name = " 教程：战斗属性 ",
description = function(desc)
	desc = string.gsub(desc,"Explore the Dungeon of Adventurer Enlightenment to learn about ToME's combat mechanics."," 探索地下城冒险启蒙版学习一下 ToME 里的战斗机制。")
	desc = string.gsub(desc,"You have navigated the Dungeon of Adventurer Enlightenment!"," 你通过了地下城冒险启蒙版！ ")
	return desc
end}

questCHN["In the void, no one can hear you scream"] = {
name = " 虚空之中无人会听到你的叫喊 ",
description = function(desc)
	desc = string.gsub(desc,"You have destroyed the sorcerers. Sadly, the portal to the Void remains open; the Creator is coming."," 你杀死了那些法师，但是悲剧的是，虚空传送门还是被打开了，造物之主就要降临人间。")
	desc = string.gsub(desc,"This cannot be allowed to happen. After thousands of years trapped in the Void between the stars, Gerlyk is mad with rage."," 这些事本不能发生的，被困在虚空星界之间几千年后，加莱克被愤怒逼疯了。")
	desc = string.gsub(desc,"You must now finish what the Sher'tuls started. Take the Staff of Absorption and become a Godslayer yourself."," 你现在必须像夏 · 图尔开始时候那样，拿起吸能法杖，成为一个弑神者。")
	return desc
end}

questCHN["There and back again"] = {
name = " 穿越回来 ",
description = function(desc)
	desc = string.gsub(desc,"Zemekkys in the Gates of Morning can build a portal back to Maj'Eyal for you."," 晨曦之门的伊莫克斯可以为你制造一个传送门使你回到马基埃亚尔。")
	desc = string.gsub(desc,"You have found a Blood%-Runed Athame."," 你找到了血符祭祀之刃。")
	desc = string.gsub(desc,"Find a Blood%-Runed Athame."," 寻找血符祭祀之刃。")
	desc = string.gsub(desc,"You have found the Resonating Diamond."," 你找到了共鸣宝石。")
	desc = string.gsub(desc,"Find a Resonating Diamond."," 寻找共鸣宝石。")
	desc = string.gsub(desc,"The portal to Maj'Eyal is now functional and can be used to go back, although, like all portals, it is one%-way only."," 到马基埃亚尔的传送门被激活了，你可以用它返回，不过和其他传送门一样，传送过去之后不能传回来。")
	return desc
end}

questCHN["The wild wild east"] = {
name = " 遥远的东方 ",
description = function(desc)
	desc = string.gsub(desc,"There must be a way to go into the far east from the lair of Golbug. Find it and explore the unknown far east, looking for clues."," 在高尔布格巢穴内肯定有一条通往远东大陆的路，去寻找线索并找到它，然后探索那未知而遥远的东方。")
	return desc
end}

questCHN["Ashes in the Wind"] = {
name = "风中灰烬",
description = function(desc)
	desc = string.gsub(desc,"You do not remember much of your life before you were on this burning continent, floating in the void between worlds.  You have been helping demons, happily participating in their experiments to shatter some sort of shield preventing them from taking their righteous revenge on Eyal.","你已经不太记得来到这片漂浮在虚空中的燃烧大陆之前的记忆了。你曾经帮助过恶魔，欢欣着参与他们的实验，以打破某种阻止恶魔降临大举复仇的无形屏障。")
	desc = string.gsub(desc,"You are being taken by your handler to the torture%-pits to help them figure out how to cause the most pain to those on Eyal, when you hear a roaring above you; you look up and see a burning meteor, flying closer, and the demons' spells failing to divert its course!  It lands near you, knocking you off your feet with its shockwave and killing your handler instantly.","你被你的 ' 主人 ' 带到这里以帮助研究如何对埃亚尔大陆  造成更严重的伤害，突然一阵轰鸣从天上传来，你抬头，看见一颗燃烧着的陨石正在坠落。恶魔试图用法术将其粉碎，但没有成功！它落在你身边，砸死了你的 ' 主人 ' ，同时你也被砸晕在地。")
	desc = string.gsub(desc,"As you recover, and your platform of searing earth splits from the main continent, your old memories flood your mind and you come to your senses %- the demons are out to destroy your home!  You must escape... but not without destroying the crystal they've used to keep track of you.","当你醒来后，你发现你身处一个和主大陆分离的平台，而你旧时的记忆渐渐涌来。你立刻惊醒——恶魔们要毁灭你的故乡！你必须逃离。。。同时别忘了摧毁他们用以追踪你的水晶体。")
	desc = string.gsub(desc,"You have destroyed the controlling crystal. The demons can no track you down anymore.","你摧毁了控制水晶，恶魔们不能再追踪你了。")
	desc = string.gsub(desc,"You have destroyed the Planar Controller. Flee now!","你摧毁了空间控制者。趁现在逃跑吧！")
	desc = string.gsub(desc,"You have to destroy the Planar Controller to escape.","想要逃跑，你必须摧毁空间控制者。")
	desc = string.gsub(desc,"You have to destroy the controlling crystal before leaving or the demons will be able to track you down.","你必须在逃跑前摧毁控制水晶")
	return desc
end
}

questCHN["I've a feeling we're not on Eyal anymore"] = {
name = "我感觉我已不在埃亚尔大陆",
description = function(desc)
	desc = string.gsub(desc,"Somehow you did not recall out as usual but instead ended up on a sadly familiar area.","不知怎的，你并没有像往常一样回城，而是到了一片令人沮丧的熟悉的地方。")
	desc = string.gsub(desc,"You are back in the Fearscape. Back and with a welcome committee.","你又回到了恶魔空间，同时面临着一群热情的迎接者们。")
	desc = string.gsub(desc,"You must find a way to escape, again.","你必须要逃离，再一次。")
	desc = string.gsub(desc,"You have destroyed Rogroth the Eater of Souls and made your escape possible. Flee!","你已经消灭了罗格洛斯灵魂吞噬者，趁现在赶快逃！")
	desc = string.gsub(desc,"You have found your way out of the primary ambush.","你找到摆脱面前伏击的方法。")
	desc = string.gsub(desc,"Find a way back to Eyal.","寻找回到埃亚尔大陆的路。")
	desc = string.gsub(desc,"You have escaped the Anteroom of Agony.","你成功地再一次逃离恶魔。")
		
	return desc
end
}
questCHN["Escort"] = {
name = function(n)
	local replaceEscortName = require("data-chn123.escorts").replaceEscortName
	n = n:gsub("Escort: "," 护送： ")
	n = replaceEscortName(n)
	
	local m = n:gsub(".+%(level %d+ of ",""):gsub("%)","")
	local l = n:match("level (%d+) of ")
	if zoneName[m] then m = zoneName[m] end
	n = string.gsub(n,"%(level %d+ of .+","").."("..m.." 第 "..l.." 层 )"
	return n 
	end,
description = function(desc)
	local match_chr = ""

	desc = string.gsub(desc,"You successfully escorted the "," 你成功的护送了 ")
	desc = string.gsub(desc,"You failed to protect the "," 你没能成功护送 ")
	if desc:find(" from death by ") then
		match_chr = desc:match(" from death by (.+)%.")
		desc = string.gsub(desc," from death by ","，杀死他（她）的是： ")
		desc = desc:gsub(match_chr,npcCHN:getName(match_chr))
	end
	desc = string.gsub(desc,"Escort the "," 护送 ")
	if desc:find(" to the recall portal on level ") then
		match_chr = desc:match(" to the recall portal on level %d+ of (.+)%.\n")
		desc = string.gsub(desc," to the recall portal on level "," 到达传送门，位于第 ")
		if zoneName[match_chr] then desc = desc:gsub("of " .. match_chr, " 层， " .. zoneName[match_chr]) end
	end
	desc = string.gsub(desc,"You abandoned "," 你扔下了 ")
	desc = string.gsub(desc," to death."," 任其自生自灭。")
	local replaceEscortName = require("data-chn123.escorts").replaceEscortName
	desc = replaceEscortName(desc)
	desc = string.gsub(desc,"As a reward you"," 作为报答你得到奖励： ")

	if desc:find("improved .+ save by") then
		match_chr = desc:match("improved (.+) save by")
		desc = desc:gsub("improved .+ save by"," 提升 " .. (s_stat_name[match_chr] or match_chr) .."豁免")
	elseif desc:find("improved .+ by") then
		match_chr = desc:match("improved (.+) by")
		desc = desc:gsub("improved .+ by"," 提升 " .. (s_stat_name[match_chr] or match_chr))
	elseif desc:find(" talent .+level") then
		desc = desc:gsub("improved"," 提升 ")
		desc = desc:gsub("learnt"," 习得 ")
		desc = desc:gsub("talent"," 技能　 ")
		desc = desc:gsub("level%(s%)"," 等级 ")
	elseif desc:find("gained talent category .+at mastery") then
		match_chr = desc:match("gained talent category (.+) / ")
		desc = desc:gsub("gained talent category"," 获得技能树点数 ")
		desc = desc:gsub("at mastery"," 技能树等级 ")
		if t_talent_cat[string.lower(match_chr)] then desc = desc:gsub(match_chr,t_talent_cat[string.lower(match_chr)]) end
	end

	return desc
end}
questCHN["Infinite Dungeon Challenge"] = {
	name = function(name)
		name = name:gsub("Infinite Dungeon Challenge", "无尽地下城挑战")
		name = name:gsub("Level", "层数")
		name = name:gsub("Pacifist", "和平主义者")
		name = name:gsub("Exterminator", "歼灭者")
		name = name:gsub("Rush Hour", "决胜时刻")
		name = name:gsub("Dream Hunter", "梦境猎手")
		name = name:gsub("Mirror Match", "镜像战斗")
		name = name:gsub("Near Sighted", "近视眼")
		name = name:gsub("Multiplicity", "复制")
		name = name:gsub("Headhunter", "猎头者")
		return name
	end,
	description = function(desc)
		desc = desc:gsub("Leave the level %(to the next level%) without killing a single creature. You will get #{italic}#two#{normal}# rewards.", "在不杀死任何怪物的情况下离开这一层（到达下一层）。你将得到 #{italic}#两份#{normal}# 奖励。")
		desc = desc:gsub("Exterminate every foe on the level.", "杀死这一层的所有敌人。")
		desc = desc:gsub("Foes left:", "剩余敌人：")
		desc = desc:gsub("Leave the level in less than", "在 ")
		desc = desc:gsub("turns %(exit is revealed on your map%).", "回合内离开该层。（出口已标记在地图上）")
		desc = desc:gsub("Turns left:", "剩余回合：")
		desc = desc:gsub("Wake up and kill the dreaming horror boss", "唤醒并杀死梦魇恐魔")
		desc = desc:gsub("Find, challenge, and kill your mirror clone on the level.", "在本层找到，挑战并杀死你的克隆体。")
		desc = desc:gsub("Finish the level with -7 sight range.", "在 -7 视野下完成本层。")
		desc = desc:gsub("All foes have the multiply talent!", "所有敌人都有复制能力！")
		desc = desc:gsub("Kill ", "在杀死任何精英怪之前，先杀死 ")
		desc = desc:gsub("spawns of Urh'Rok on the level before killing any elite creatures.", " 个乌鲁克的子嗣。")
		desc = desc:gsub("You completed the challenge and received:", "你完成了挑战，获得了：")
		return desc
	end,
}

--	quest.name =  string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(txt,"Escort: "),),),),),),),)
		

-- 替换任务状态 
function getQuestStat(txt)
	if txt == "active" then return " 进行中 "
	elseif txt == "done" then return " 完成 "
	elseif txt == "failed" then return " 失败 "
	else return txt
	end
end

-- 替换炼金配料 
function changeElixir(desc)
	desc = string.gsub(desc,"Kindly empty it before returning."," 在把它带回来之前请把它清理干净。")
	desc = string.gsub(desc,"length of troll intestine"," 较长的巨魔肠子 ")
	
	desc = string.gsub(desc,"If the eyes are still glowing, please bash it around a bit until they fade. I'll not have another one of those coming alive and wreaking havoc in my lab."," 如果它的眼睛仍然亮着，请猛击它直到不再发光为止。我不想再要一个会突然活过来并把我的实验室搞的一塌糊涂的头骨了。")
	desc = string.gsub(desc,"skeleton mage skull"," 骷髅法师头骨 ")
	
	desc = string.gsub(desc,"Keep as much venom in it as possible."," 请尽可能多的保持螫针的毒液。")
	desc = string.gsub(desc,"ritch stinger"," 里奇螫针 ")
	
	desc = string.gsub(desc,"If you can fetch me a still%-beating orc heart, that would be even better. But you don't look like a master necromancer to me."," 如果你能给我一个新鲜的、跳动着的兽人心脏，那就太好了。但是在我看来，你不像是一个死灵魔导师。")
	desc = string.gsub(desc,"orc heart"," 兽人心脏 ")
	
	desc = string.gsub(desc,"Best results occur with tongues never tainted by profanity, so if you happen to know any saintly nagas..."," 最好的结果便是从未被污言秽语亵渎过的舌头，所以如果你正好碰到那些圣者娜迦…… ")
	desc = string.gsub(desc,"naga tongue"," 娜迦舌头 ")
	
	desc = string.gsub(desc,"Don't drink it, even if it tells you to."," 不要去喝它，即使它诱惑着你…… ")
	desc = string.gsub(desc,"vial of greater demon bile"," 大恶魔的胆汁 ")
	
	desc = string.gsub(desc,"Never, ever to be confused with garlic powder. Trust me."," 绝对绝对不要和大蒜粉搞混，相信我…… ")
	desc = string.gsub(desc,"pouch of bone giant dust"," 一袋骨巨人的骨灰 ")
	
	desc = string.gsub(desc,"If you've the means to eliminate the little venom problem, these make miraculous instant drink%-chilling straws."," 如果你有方法消除小小的毒液问题，这些螫针可以成为不可思议的冷冻吸管。")
	desc = string.gsub(desc,"ice ant stinger"," 冰蚁的螫针 ")
	
	desc = string.gsub(desc,"You'll need to find one with a ring, preferably an expensive one."," 你要寻找 1 个带有圆环的，最好是比较贵的那个。")
	desc = string.gsub(desc,"minotaur nose"," 米诺陶的鼻子 ")
	
	desc = string.gsub(desc,"Once you've gotten it, cross some moving water on your way back."," 取得它之后，你最好在回去的路上用活水写些十字。")
	desc = string.gsub(desc,"vial of elder vampire blood"," 一瓶高级吸血鬼的血液 ")
	
	desc = string.gsub(desc,"If you think collecting one of these is hard, try liquefying one."," 如果你认为收集一片龙鳞很困难，那么去尝试溶解它吧。")
	desc = string.gsub(desc,"multi%-hued wyrm scale"," 多彩的龙鳞 ")
	
	desc = string.gsub(desc,"The spiders in your barn won't do. You'll know a giant spider when you see one, though they're rare in Maj'Eyal."," 你家仓库里的蜘蛛是不行的。当你看到一只时，你就会明白什么是巨型蜘蛛，尽管在马基埃亚尔这种蜘蛛很稀少。")
	desc = string.gsub(desc,"giant spider spinneret"," 巨蛛的丝腺 ")
	
	desc = string.gsub(desc,"Keep a firm grip on it. These things will dig themselves right back into the ground if you drop them."," 牢牢的抓住它，如果你不小心把它掉在地上，它会立刻挖地逃走。")
	desc = string.gsub(desc,"honey tree root"," 蜜蜂树的根 ")
	
	desc = string.gsub(desc,"Don't worry if it dissolves. Just don't get any on you."," 不要担心它的腐烂，只要不碰到你身上就没事。")
	desc = string.gsub(desc,"bloated horror heart"," 浮肿的恐魔心脏 ")
	
	desc = string.gsub(desc,"I know, I know. Where does the eel stop and the tail start%? It doesn't much matter. The last ten inches or so should do nicely."," 我知道，我知道。你想问电鳗的尾巴是哪一段？没有确切的答案。最后 10 英寸或许是最合适的。")
	desc = string.gsub(desc,"electric eel tail"," 电鳗尾巴 ")
	
	desc = string.gsub(desc,"However annoying this will be for you to gather, I promise that the reek it produces in my lab will prove even more annoying."," 不管你怎样讨厌它，都需要你去采集，我向你保证我在实验室用它做出的东西会更加令人讨厌。")
	desc = string.gsub(desc,"vial of squid ink"," 一瓶乌贼墨汁 ")
	
	desc = string.gsub(desc,"You'd think I could get one of these from a local hunter, but they've had no luck. Don't get eaten."," 你认为我可以从本地的猎户手上取得它吗？甭想了，他们没那个运气。不要被吃掉了。")
	desc = string.gsub(desc,"bear paw"," 熊爪 ")
	
	desc = string.gsub(desc,"Ice Wyrms lose teeth fairly often, so you might get lucky and not have to do battle with one. But dress warm just in case."," 冰龙每隔一段时间会换齿，所以你幸运的话，可以捡到几颗而不需要和它战斗。保险起见穿的暖和点…… ")
	desc = string.gsub(desc,"ice wyrm tooth"," 冰霜巨龙的牙齿 ")
	
	desc = string.gsub(desc,"I hear these can be found in a cave near Elvala. I also hear that they can cause you to spontaneously combust, so no need to explain if you come back hideously scarred."," 我听说这些小家伙可以在埃尔瓦拉附近的洞穴里找到。我还听说它们会使你自燃，所以当你高度烧伤回来的话，不要向我诉苦。")
	desc = string.gsub(desc,"red crystal shard"," 红色水晶碎片 ")
	
	desc = string.gsub(desc,"Keep this stuff well away from your campfire unless you want me to have to find a new, more alive adventurer."," 把这个瓶子离你的篝火远一些，我可不想明天重新找一个活的冒险家。")
	desc = string.gsub(desc,"vial of fire wyrm saliva"," 一瓶火龙涎 ")
	
	desc = string.gsub(desc,"Unfortunately for you, the chunks that regularly fall off ghouls won't do. I need one freshly carved off."," 告诉你一个不幸的消息，平时从食尸鬼身上掉下来的肉是不行的。我需要新鲜的，刚切下来的肉。")
	desc = string.gsub(desc,"chunk of ghoul flesh"," 腐烂的食尸鬼肉块 ")
	
	desc = string.gsub(desc,"That is, a bone from a corpse that's undergone mummification. Actually, any bit of the body would do, but the bones are the only parts you're certain to find when you kick a mummy apart. I recommend finding one that doesn't apply curses."," 那就是，经过木乃伊化的尸体身上的骨头。实际上，身体的任何部位都可以，只是从它们身上只能找到骨头了。我推荐你去找一根没有被诅咒的骨头。")
	desc = string.gsub(desc,"mummified bone"," 木乃伊骨头 ")
	
	desc = string.gsub(desc,"Yes, sandworms have teeth. They're just very small and well back from where you're ever likely to see them and live."," 是的，沙虫也有牙齿。它们只是很小，藏得很好，如果你把头伸进去找它你就没法活着回来了。")
	desc = string.gsub(desc,"sandworm tooth"," 沙虫之牙 ")
	
	desc = string.gsub(desc,"If you get bitten, I can save your life if you still manage to bring back the head... and if it happens within about a minute from my door. Good luck."," 如果你被它咬到了，只要你坚持到把它带回来我就可以拯救你……但是如果你不能及时带回来，那么，祝你好运。")
	desc = string.gsub(desc,"black mamba head"," 黑曼巴头 ")
	
	desc = string.gsub(desc,"I suggest not killing the snow giant by impaling it through the kidneys. You'll just have to find another."," 我建议你不要从雪巨人的肾脏部位刺死它，否则你不得不寻找另外一个。")
	desc = string.gsub(desc,"snow giant kidney"," 雪巨人的肾脏 ")
	
	desc = string.gsub(desc,"I recommend severing one of dewclaws. They're smaller and easier to remove, but they've never been blunted by use, so be careful you don't poke yourself. Oh yes, and don't get eaten."," 我建议你割断其中一只爪子，它们更小而且容易被割下。但是它们从来不会因使用而钝化，所以当心点别划伤你自己。哦，对了，还有别被吃掉。")
	desc = string.gsub(desc,"storm wyrm claw"," 风暴之龙的爪子 ")
	
	desc = string.gsub(desc,"Try to get any knots out before returning. Wear gloves."," 在回来之前把打结在上面的其他蠕虫统统清理掉。戴上手套。")
	desc = string.gsub(desc,"green worm"," 翡翠蠕虫 ")
	
	desc = string.gsub(desc,"If you ingest any of this, never mind coming back here. Please."," 如果你不小心喝掉一点，请不要介意回到我这。")
	desc = string.gsub(desc,"vial of wight ectoplasm"," 一瓶尸妖的血浆 ")
	
	desc = string.gsub(desc,"Avoid fragments that contained the xorn's eyes. You've no idea how unpleasant it is being watched by your ingredients."," 不要带回包含着索尔石怪眼睛的碎片。你不知道被你的原材料盯着是多么难受的一件事。")
	desc = string.gsub(desc,"xorn fragment"," 索尔石碎片 ")
	
	desc = string.gsub(desc,"My usual ingredient gatherers draw the line at hunting wargs. Feel free to mock them on your way back."," 我对原料的需求使我想到了猎杀座狼。在你回来的时候请弄一只爪子回来。")
	desc = string.gsub(desc,"warg claw"," 座狼爪 ")
	
	desc = string.gsub(desc,"They're creatures of pure flame, and likely of extraplanar origin, but the ash of objects consumed by their fire has remarkable properties."," 它们是由纯粹的火焰组成的生物，似乎来自另一个世界。然而，由它们的火焰燃烧成的灰烬有着非凡的功效。")
	desc = string.gsub(desc,"pouch of faeros ash"," 法罗的灰烬 ")
	
	desc = string.gsub(desc,"Evil little things, wretchlings. Feel free to kill as many as you can, though I just need the one intact eyeball."," 邪恶的小恶魔，酸液树魔。你可以尽情的杀戮它们，尽管我只需要一只完整的眼球。")
	desc = string.gsub(desc,"wretchling eyeball"," 酸液树魔之眼 ")
	
	desc = string.gsub(desc,"I've lost a number of adventurers to this one, but I'm sure you'll be fine."," 我已经在这个工作中失去了许多冒险者，但我确信你会安全归来。")
	desc = string.gsub(desc,"faerlhing fang"," 费尔荷毒牙 ")
	
	desc = string.gsub(desc,"You should definitely consider not pricking yourself with it."," 你必须确保自己不会被它划伤。")
	desc = string.gsub(desc,"vampire lord fang"," 吸血鬼族长的毒牙 ")
	
	desc = string.gsub(desc,"If you've not encountered hummerhorns before, they're like wasps, only gigantic and lethal."," 如果你以前没看过杀人蜂，你可以想象下……它们像大黄蜂一样，只不过变的巨大而致命。")
	desc = string.gsub(desc,"hummerhorn wing"," 半透明的昆虫翅膀 ")
	
	desc = string.gsub(desc,"Not to be confused with radiant horrors. If you encounter the latter, then I suppose there are always more adventurers."," 不要被恐魔发出的强光所吓倒，如果你被吓倒，我会考虑更多的冒险者来接替你的使命。")
	desc = string.gsub(desc,"pouch of luminous horror dust"," 一袋金色恐魔的粉尘 ")
	return desc
end


dofile("data-chn123/quests/amakthel.lua")
dofile("data-chn123/quests/destroy-sunwall.lua")
dofile("data-chn123/quests/free-prides.lua")
dofile("data-chn123/quests/gem.lua")
dofile("data-chn123/quests/kaltor-shop.lua")
dofile("data-chn123/quests/kill-dominion.lua")
dofile("data-chn123/quests/krimbul.lua")
dofile("data-chn123/quests/kruk-invasion.lua")
dofile("data-chn123/quests/palace.lua")
dofile("data-chn123/quests/quarry.lua")
dofile("data-chn123/quests/ritch-hive.lua")
dofile("data-chn123/quests/start-orc.lua")
dofile("data-chn123/quests/sunwall-observatory.lua")
dofile("data-chn123/quests/to-mainland.lua")
dofile("data-chn123/quests/voyage.lua")
dofile("data-chn123/quests/weissi.lua")
dofile("data-chn123/quests/yeti-abduction.lua")
dofile("data-chn123/quests/cults/grung.lua")
dofile("data-chn123/quests/cults/illusory-castle.lua")
dofile("data-chn123/quests/cults/krogs-rescue.lua")
dofile("data-chn123/quests/cults/start-cults.lua")