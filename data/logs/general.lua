logCHN:newLog{
	log = "#YELLOW#%s's skin turns %s!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		if type(b) == "string" then
			b = b:gsub("red","红色")
			b = b:gsub("white","白色")
			b = b:gsub("blue","蓝色")
			b = b:gsub("green","绿色")
			b = b:gsub("dark","暗色")
			b = b:gsub("violet","紫色")
		end
		return ("#YELLOW#%s的皮肤变成了 %s ！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s explodes in an acidic cloud.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 爆炸产生了一团酸雾。"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#%s raises from the dead!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#LIGHT_RED#%s 从尸体中站了起来！"):format(a)
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#%s absorbs the energy of the destroyed fragment!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#AQUAMARINE#%s 吸收了被摧毁的碎片的能量！"):format(a)
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#%s is infused with all the energies of the fragments. The real Harkor'Zun is reconstituted!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#AQUAMARINE#%s吸收了所有碎片的能量，真正的哈卡祖重生了！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s exudes a corrupted gas as it dies.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 死亡时释放出腐气。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s has collapsed in upon itself.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s自爆了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#A carrion worm mass has spawned from %s' wounds!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("#LIGHT_RED#一团腐肉虫从%s的伤口了孵化了出来。"):format(a)
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#As %s falls %s seems to weaken!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("#AQUAMARINE#当 %s 倒下时 %s 好像醒了过来！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s is blinded by the loss of all its eyes.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 失去了它所有的眼睛，无法看见东西。"):format(a)
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#With Grgglck's death its tentacle also falls lifeless on the ground!",
	fct = function()
		return "#AQUAMARINE#随着格尔格勒克的死去它的那些触手也毫无生机地倒在了地上！"
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#The air bubbles are depleted!",
	fct = function()
		return "#AQUAMARINE#气泡被耗尽了！"
	end,
}

logCHN:newLog{
	log = "The unstable sand tunnel collapses!",
	fct = function()
		return "不稳定的流沙通道塌陷了！"
	end,
}

logCHN:newLog{
	log = "%s invokes the power of %s!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("%s召唤了%s的力量！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s's mind is clear!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的精神变得清晰了！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s's %s is disrupted!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return ("%s 的%s被打断了！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#CRIMSON#%s twitches, alerting %s that a trap is nearby.",
	fct = function(a,b)
		a = npcCHN:getName(a)
		b = npcCHN:getName(b)
		return ("#CRIMSON#%s抖动了两下，警告 %s 附近有一个陷阱。"):format(a,b)
	end,
}

logCHN:newLog{
	log = "%s is channeling mana!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 正在施展魔法！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s is cured of diseases!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 的疾病被治愈！"):format(a)
	end,
}

logCHN:newLog{
	log = "%s brandishes the %s, calling forth the might of the oceans!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		local name = objects:getObjectsChnName(a)
		return ("%s 挥舞着 %s ，唤起海洋的力量！"):format(a,name)
	end,
}

logCHN:newLog{
	log = "%s uses the %s!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		local name = objects:getObjectsChnName(b)
		return ("%s 使用了 %s！"):format(a,name)
	end,
}

logCHN:newLog{
	log = "#CRIMSON#As you wear both Garkul's heirlooms you can feel the mighty warrior's spirit flowing through you.",
	fct = function()
		return "#CRIMSON#当你穿上整套加库尔的遗物时，你感受到战士的精神流淌在你的身上。"
	end,
}

logCHN:newLog{
	log = "#CRIMSON#The spirit of Garkul fades away.",
	fct = function()
		return "#CRIMSON#加库尔的精神消失了。"
	end,
}

logCHN:newLog{
	log = "%s brandishes the %s and banishes all shadows!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		local name = objects:getObjectsChnName(b)
		return ("%s 挥舞着 %s，所有的阴影被驱散了！"):format(a,name)
	end,
}

logCHN:newLog{
	log = "%s brandishes the %s which radiates in all directions!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		local name = objects:getObjectsChnName(b)
		return ("%s 挥舞着 %s，向各个方向辐射！"):format(a,name)
	end,
}

logCHN:newLog{
	log = "%s quaffs the %s!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		local name = objects:getObjectsChnName(b)
		return ("%s 大口喝下 %s ！"):format(a,name)
	end,
}

logCHN:newLog{
	log = "#ANTIQUE_WHITE#The two blades glow brightly as they are brought close together.",
	fct = function()
		return "#ANTIQUE_WHITE#两把利刃互相靠近时发出耀眼的闪光。"
	end,
}

logCHN:newLog{
	log = "#ANTIQUE_WHITE#The light from the two blades fades as they are separated.",
	fct = function()
		return "#ANTIQUE_WHITE#两把利刃分开时耀眼的闪光消失了。"
	end,
}

logCHN:newLog{
	log = "#GOLD#Ureslak's Femur glows and shimers!",
	fct = function()
		return "#ANTIQUE_WHITE#乌尔斯拉克的腿骨闪动着光芒。"
	end,
}

logCHN:newLog{
	log = "#CRIMSON#The echoes of time resound as the blades are reunited once more.",
	fct = function()
		return "#CRIMSON#当剑重合在一起时出现了时间的回音。"
	end,
}

logCHN:newLog{
	log = "#CRIMSON#Time seems less perfect in your eyes as the blades are separated.",
	fct = function()
		return "#CRIMSON#当剑分开时在你的眼中似乎时空不再完美。"
	end,
}

logCHN:newLog{
	log = "#STEEL_BLUE#You feel a swell of arcane energy.",
	fct = function()
		return "#STEEL_BLUE#你感受到一股奥术能量在膨胀。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You carefully get away without making a sound.",
	fct = function()
		return "#LIGHT_BLUE#你小心翼翼地悄悄离开了。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You carefully open the trap door and enter the underground tunnels...",
	fct = function()
		return "#LIGHT_RED#你小心打开地板上的活门进入了地下通道..."
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#As you enter you notice the trap door has no visible handle on the inside. You are stuck here!",
	fct = function()
		return "#LIGHT_RED#当你进入了地道你发现活门没有出去的开关， 你被关在这里了！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You carefully open the door and enter the underground crypt...",
	fct = function()
		return "#LIGHT_RED#你打开了活门， 小心翼翼地进入了地窖..."
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You notice an entrance to an underwater cave.",
	fct = function()
		return "#LIGHT_BLUE#你发现了一个水下洞穴的入口。"
	end,
}

logCHN:newLog{
	log = "The water poisons you!",
	fct = function()
		return "水令你中毒了！"
	end,
}

logCHN:newLog{
	log = "You are crushed by the collapsing tunnel! You suffocate!",
	fct = function()
		return "你被压在了倒塌的通道中！你感到无法呼吸！"
	end,
}

logCHN:newLog{
	log = "Not enough space to invoke the vampire!",
	fct = function()
		return "没有足够的空间召唤吸血鬼！"
	end,
}

logCHN:newLog{
	log = "#GOLD#As the crystalline weapon and armour are brought together, they begin to emit a constant humming.",
	fct = function()
		return "#GOLD#当水晶般的武器和护甲放在一起时，他们开始产生共鸣。"
	end,
}

logCHN:newLog{
	log = "#GOLD#The humming from the crystalline artifacts fades as they are separated.",
	fct = function()
		return "#GOLD#当两件水晶装备分开时共鸣消失了。"
	end,
}

logCHN:newLog{
	log = "You fix the crystal on the %s and create the %s.",
	fct = function(a,b)
		local name = objects:getObjectsChnName(a)
		return ("你将水晶安装在 %s ，制造了 %s 。"):format(name,b)
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You feel uneasy carrying %s.",
	fct = function(a)
		local name = objects:getObjectsChnName(a)
		return ("#LIGHT_RED#你感到无法携带 %s 。"):format(name)
	end,
}

logCHN:newLog{
	log = "Your negative mana regeneration rate is unaffected by the staff.",
	fct = function()
		return "你的负能量回复率不受法杖影响。"
	end,
}

logCHN:newLog{
	log = "Another mana surge is currently active.",
	fct = function()
		return "另外一种法力恢复效果已激活。"
	end,
}

logCHN:newLog{
	log = "Your nonexistant mana regeneration rate is unaffected by the staff.",
	fct = function()
		return "你的法力恢复效果不受法杖影响。"
	end,
}

logCHN:newLog{
	log = "#00FFFF#You drink the elixir and feel forever transformed!",
	fct = function()
		return "#00FFFF#你喝下了药剂，你感受到你的身体发生了永久性的变化！"
	end,
}

logCHN:newLog{
	log = "#00FF00#The elixir has given you foxlike physical and mental agility!",
	fct = function()
		return "#00FF00#药剂给予了你狐狸般的物理、精神能力！"
	end,
}

logCHN:newLog{
	log = "#00FF00#The elixir has improved your defensive instincts!",
	fct = function()
		return "#00FF00#药剂提高了你的防御本能！"
	end,
}

logCHN:newLog{
	log = "#00FF00#The elixir has improved your eye for an enemy's weak points!",
	fct = function()
		return "#00FF00#药剂提高了你发现敌人弱点的能力！"
	end,
}

logCHN:newLog{
	log = "#00FF00#The elixir has augmented your magical and mental capacity!",
	fct = function()
		return "#00FF00#药剂增加了你的魔法和精神能量！"
	end,
}

logCHN:newLog{
	log = "#00FF00#The elixir has improved your resistance to unpleasant effects!",
	fct = function()
		return "#00FF00#药剂增加了你抵抗不良效果的能力！"
	end,
}

logCHN:newLog{
	log = "#00FF00#The elixir has greatly expanded your capacity for improving your mind and body.",
	fct = function()
		return "#00FF00#药剂大大提升了你的智力和体能。"
	end,
}

logCHN:newLog{
	log = "#00FF00#The elixir has improved your eye for an enemy's magical weak points!",
	fct = function()
		return "#00FF00#药剂提升了你发现敌人魔法弱点的能力！"
	end,
}

logCHN:newLog{
	log = "#00FF00#The elixir seems to have subtly repositioned your entire being within the fabric of reality!",
	fct = function()
		return "#00FF00#这瓶炼金药剂似乎完全改变了你的整个人生！"
	end,
}

logCHN:newLog{
	log = "#00FF00#The elixir has improved your capacity for exercising your core talents.",
	fct = function()
		return "#00FF00#药剂提升了你核心技能的能力！"
	end,
}

logCHN:newLog{
	log = "#00FF00#The elixir has augmented your physical might and resilience!",
	fct = function()
		return "#00FF00#药剂提升了你物理打击能力和抵抗力！"
	end,
}

logCHN:newLog{
	log = "#00FF00#The elixir has reinforced your entire body!",
	fct = function()
		return "#00FF00#药剂重组了你整个身体！"
	end,
}

logCHN:newLog{
	log = "#00FF00#You feel indestructible!",
	fct = function()
		return "#00FF00#你变得刀枪不入！"
	end,
}

logCHN:newLog{
	log = "You pickup %0.2f gold pieces.",
	fct = function(...)
		return ("你拾取了 %0.2f 金币。"):format(...)
	end,
}

logCHN:newLog{
	log = "This power seems too much to wield, you fear it might absorb YOU.",
	fct = function()
		return "这件装备的力量太强大了， 你害怕它会把你吸收进去， 无法装备它。"
	end,
}

logCHN:newLog{
	log = "The rod emits a strange noise, glows briefly and returns to normal.",
	fct = function()
		return "法杖发出奇怪的响声，闪了下光又恢复了正常。"
	end,
}

logCHN:newLog{
	log = "Space around you starts to dissolve...",
	fct = function()
		return "你周围的空间开始消解..."
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You feel a great hero guiding you!",
	fct = function()
		return "#LIGHT_BLUE#你感到有个伟大的英雄在指引着你！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#You feel the Blood of Life rushing through your veins.",
	fct = function()
		return "#LIGHT_RED#你感到生命之血涌入了你每一根血管。"
	end,
}

logCHN:newLog{
	log = "The Blood of Life seems to have no effect on you.",
	fct = function()
		return "生命之血对你似乎没有什么作用。"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You feel as surge of power as you wear the vestments of the old Human Conclave!",
	fct = function()
		return "#LIGHT_BLUE#你一穿上这件法袍你感到全身涌入了一股力量！"
	end,
}

logCHN:newLog{
	log = "The fusing fails!",
	fct = function()
		return "熔合失败了！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You feel as surge of power as you wield the axe of your ancestors!",
	fct = function()
		return "#LIGHT_BLUE#你一装备这把战斧你感到全身涌入了一股力量！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You feel a great hero watching over you!",
	fct = function()
		return "#LIGHT_BLUE#你感到有位伟大的英雄正在守护着你！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#You feel the whisper of your ancestors as you wield this pickaxe!",
	fct = function()
		return "#LIGHT_BLUE#当你装备上这把鹤嘴锄你似乎听到了先祖们的窃窃私语！"
	end,
}

logCHN:newLog{
	log = "#STEEL_BLUE#The arcane energies surrounding you dissapate.",
	fct = function()
		return "#STEEL_BLUE#围绕你的奥术能量消散了。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You hear a door opening.",
	fct = function()
		return "#VIOLET#你听到一扇门被打开了。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You hear a door closing.",
	fct = function()
		return "#VIOLET#你听到一扇门被关上了。"
	end,
}

logCHN:newLog{
	log = "#VIOLET#You hear a mechanism clicking.",
	fct = function()
		return "#VIOLET#你听到了机械转动的声音。"
	end,
}


logCHN:newLog{
	log = "#VIOLET#The world twists sickeningly around you and you find yourself someplace unexpected! It felt nothing like your previous uses of the Orb of Many Ways. Tannen must have switched the Orb out for a fake!",
	fct = function()
		return "#VIOLET#你周围的世界发生了扭曲，之后你发现你自己出现在了意料之外的地方。 这和之前你使用多元水晶球时的情形完全不同，泰恩肯定用假水晶球掉了包！"
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#With the horror's death the blade clatters to the ground!",
	fct = function()
		return "#VIOLET#随着恶魔的死亡，剑刃“喀拉”一声掉在了地上！"
	end,
}

logCHN:newLog{
	log = "A rift opens, spawning a free floating blade!",
	fct = function()
		return "一道传送门打开了，释放出了1个漂浮的次元之刃！"
	end,
}

logCHN:newLog{
	log = "A rift opens, a blade emerging. It does not look like the others.",
	fct = function()
		return "一道传送门打开了，1只次元之刃浮现了出来。它似乎和那些其他的剑刃有所不同。"
	end,
}

logCHN:newLog{
	log = "%s is affected by the glimmerstone!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 受到了闪光石的影响。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s's soul is absorbed by the pedestal. A glowing orb appears.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s的灵魂被基座吸收了。一个发光的水晶球出现了。"):format(a)
	end,
}

logCHN:newLog{
	log = "#GOLD#An object rolls from the chest!",
	fct = function()
		return "#GOLD#一件物品从宝箱中掉了出来!"
	end,
}

logCHN:newLog{
	log = "#GOLD#But the chest was guarded!",
	fct = function()
		return "#GOLD#但是这个宝箱有怪物守护!"
	end,
}

logCHN:newLog{
	log = "#LIGHT_RED#As you enter you notice the door has no visible handle on the inside. You are stuck here!",
	fct = function()
		return "#LIGHT_RED#当你进入后，你发现这扇门的里侧没有门把，你被困在这了！"
	end,
}

logCHN:newLog{
	log = "%s pulls a dagger and opens his own chest, piercing his beating heart. The stone glows with malevolent colors.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 拿出了一把匕首，扎进了自己的胸膛。瞬间，他身后的石头发出了七彩的光芒。"):format(a)
	end,
}

logCHN:newLog{
	log = "There is nothing there.",
	fct = function()
		return "那里什么也没有。"
	end,
}
logCHN:newLog{
	log = "%s thinks things really need to slow down for a bit.",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 认为现在到了减速一会的时候。"):format(a)
	end,
}
logCHN:newLog{
	log = "%s revels in blood!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("%s 沐浴鲜血！"):format(a)
	end,
}

logCHN:newLog{
	log = "#Source# unleashes cosmic retribution at #Target#!",
	fct = function()
		return "#Source# 朝 #Target#释放了宇宙的愤怒!"
	end,
}

logCHN:newLog{
	log = "Black tendrils shoot out of the mesh and pull %s to you!",
	fct = function(a)
		a = npcCHN:getName(a)
		return ("黑色的触须从血肉中伸出，将%s拉了过来！"):format(a)
	end,
}
logCHN:newLog{
	log = "#CRIMSON#Rogue Plight transfers an effect to its source!",
	fct = function()
		return "#CRIMSON#刺客契约将一项效果转移给其来源!"
	end,
}

logCHN:newLog{
	log = "A wave of icy water bursts out from #Source#'s shield towards #Target#!",
	fct = function()
		return "一股冰水从#Source#的盾牌喷射出来，喷向了#Target#!"
	end,
}

logCHN:newLog{
	log = "#RED#The ring refuses to be removed!",
	fct = function()
		return "#RED#戒指拒绝被卸下！"
	end,
}

logCHN:newLog{
	log = "#RED#The ring does not react.",
	fct = function()
		return "#RED#戒指没有反应。"
	end,
}

logCHN:newLog{
	log = "#GREEN#The skull embossed in the ring twists around momentarily. ...Did it just laugh?",
	fct = function()
		return "#GREEN#戒指里的头骨似乎扭曲了一瞬间……它刚才笑了么？"
	end,
}


logCHN:newLog{
	log = "%s shrugs off some effects!",
	fct = function(a)
		a = npcCHN:getName(a)
		return("%s摆脱了某些负面效果！"):format(a)
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#A dream seed escapes %s's sleeping mind.",
	fct = function(a)
		a = npcCHN:getName(a)
		return("#LIGHT_BLUE#一个梦境之种从%s的沉眠中释放"):format(a)
	end,
}

logCHN:newLog{
	log = "#YELLOW#%s has temporarily forgotten %s!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return("#YELLOW#%s暂时忘记了%s!"):format(a,b)
	end,
}
logCHN:newLog{
	log = "%s has temporarily forgotten %s!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return("%s暂时忘记了%s!"):format(a,b)
	end,
}
--dlc
logCHN:newLog{
	log = "#CRIMSON#The power of the Fearscape touches %s and fades away, leaving no traces.",
	fct = function(a)
		return("#CRIMSON#恶魔空间的力量触及了%s，然后消褪了，没留下一点痕迹。"):format(a)
	end,
}

logCHN:newLog{
	log = "#CRIMSON#The power of the Fearscape touches %s and fades away, leaving a nasty looking %s nearby.",
	fct = function(a,b)
		b = npcCHN:getName(b)
		return("#CRIMSON#恶魔空间的力量触及了%s，然后消褪了，留下%s站在你面前"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#CRIMSON#The power of the Fearscape touches %s and fades away, leaving a nasty effect upon you.",
	fct = function(a)
		return("#CRIMSON#恶魔空间的力量触及了%s，然后消褪了，留下一个负面效果。"):format(a)
	end,
}

logCHN:newLog{
	log = "#CRIMSON#The power of the Fearscape touches %s and fades away, leaving a strange effect upon you.",
	fct = function(a)
		return("#CRIMSON#恶魔空间的力量触及了%s，然后消褪了，留下一个奇怪的效果。"):format(a)
	end,
}


logCHN:newLog{
	log = "#CRIMSON#The power of the Fearscape touches %s and fades away, leaving a strange item being.",
	fct = function(a)
		return("#CRIMSON#恶魔空间的力量触及了%s，然后消褪了，留下一个道具。"):format(a)
	end,
}

logCHN:newLog{
	log = "%s's magic has been #ORCHID#purged#LAST#!",
	fct = function(a)
		return("%s的魔法被#ORCHID#净化#LAST#了!"):format(npcCHN:getName(a))
	end,
}

logCHN:newLog{
	log = "%s's %s has been #ORCHID#burned#LAST#!",
	fct = function(a,b)
		return("%s的%s被#ORCHID#燃烧#LAST#了!"):format(npcCHN:getName(a),b)
	end,
}

logCHN:newLog{
	log = "%s releases a blast of freezing vapors from %s %s!",
	fct = function(a,b,c)
		a = npcCHN:getName(a)
		b = b:gsub("his","他的"):gsub("her","她的")
		return("%s用%s %s释放了寒冰霜雾!"):format(a,b,c)
	end,
}

logCHN:newLog{
	log = "%s's %s shakes the ground with its impact!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return("%s的%s震动了大地！"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#DARK_GREEN#You feel like Nature's Wrath incarnate!",
	fct = function()
		return "#DARK_GREEN#你感受到了自然的怒火！"
	end,
}

logCHN:newLog{
	log = "%s uses the %s to cleanse %s mind!",
	fct = function(a,b,c)
		a = npcCHN:getName(a)
		return ("%s使用%s净化了自己的精神！"):format(a,b)
	end,
}
logCHN:newLog{
	log = "%s aims %s %s!",
	fct = function(a,b,c)
		a = npcCHN:getName(a)
		b = b:gsub("his","他的"):gsub("her","她的")
		return("%s举起了%s %s!"):format(a,b,c)
	end,
}
logCHN:newLog{
	log = "%s brandishes %s, calling forth the might of the oceans!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return("%s挥舞着%s，召唤了海洋的力量!"):format(a,b)
	end,
}
logCHN:newLog{
	log = "#GOLD#As the helm of Kroltar approaches the your scale armour, they begin to fume and emit fire.",
	fct = function()
		return("#GOLD#当库洛塔的头盔和鳞甲接触时，他们开始冒烟喷火了")
	end,
}
logCHN:newLog{
	log = "#GOLD#The fumes and fire fade away.",
	fct = function()
		return("#GOLD#烟和火消失了")
	end,
}
logCHN:newLog{
	log = "#PURPLE#You feel the spirit of the wyrm stirring inside you!",
	fct = function()
		return("#PURPLE#你感受到了体内充满了龙之精神!")
	end,
}
logCHN:newLog{
	log = "#SLATE#The link between the mindstars is broken.",
	fct = function()
		return("#SLATE#灵晶间的联系消失了。")
	end,
}
logCHN:newLog{
	log = "#Source# strikes #Target# with %s %s, sending out an arc of lightning!",
	fct = function(a,b)
		a = a:gsub("his","他的"):gsub("her","她的")
		return("#Source#用%s%s攻击了 #Target#，触发一阵电弧！"):format(a,b)
	end,
}
logCHN:newLog{
	log = "%s FIRST unleashes antimagic forces from %s %s!",
	fct = function(a,b,c)
		a = npcCHN:getName(a)
		b = b:gsub("his","他的"):gsub("her","她的")
		return("%s 用%s %s释放了反魔能量！"):format(a,b,c)
	end,
}
logCHN:newLog{
	log = "%s's %s flashes!",
	fct = function(a,b)
		a = npcCHN:getName(a)
		return("%s的%s 闪光了!"):format(a,b)
	end,
}

logCHN:newLog{
	log = "#GOLD#The sands slowly begin falling towards %s",
	fct = function(a)
		a = a:gsub("stability","稳定"):gsub("entropy","熵")
		return("#GOLD#沙子缓慢地流向 %s"):format(a)
	end,
}
logCHN:newLog{
	log = "%s evokes a mental assault from %s %s!",
	fct = function(a,b,c)
		a = a:gsub("his","他的"):gsub("her","她的")
		return("%s用%s %s激发精神攻击!"):format(a,b,c)
	end,
}
logCHN:newLog{
	log = "%s uses %s, curing %s afflictions!",
	fct = function(a,b,c)
		a = npcCHN:getName(a)
		c = npcCHN:getName(c)
		return("%s用%s 治疗了%s的痛苦!"):format(a,b,c)
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#As #Source# falls #Target# seems to weaken!",
	fct = function()
		return "#AQUAMARINE#当 #Source# 倒下时， #Target# 似乎被削弱了！"
	end,
}

logCHN:newLog{
	log = "#AQUAMARINE#As #Source# falls you notice that #Target# seems to shudder in pain!",
	fct = function()
		return "#AQUAMARINE#当 #Source# 倒下时， 你注意到 #Target# 似乎在痛苦中挣扎！"
	end,
}

logCHN:newLog{
	log = "#LIGHT_BLUE#The sleeper stirs...",
	fct = function()
		return "#LIGHT_BLUE#有人打扰了沉睡者的沉眠..."
	end,
}