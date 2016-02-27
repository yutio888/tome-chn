npcNameCHN = {}
npcDescCHN = {}

npcCHN = {}

function npcCHN:getName(name)
	if not name then return nil end
	if name:find("'s temporal clone") then name =npcCHN:getName(name:gsub("'s temporal clone","")).."的时空复制体"	
	elseif name:find("'s Inner Demon") then name = npcCHN:getName(name:gsub("'s Inner Demon","")).."的心魔"	
	elseif name:find("Crystaline Half") then name = npcCHN:getName(name:gsub("Crystaline Half","")).."的水晶分身"
	elseif name:find("Stone Half") then name = npcCHN:getName(name:gsub("Stone Half","")).."的岩石分身"
	elseif name:find("enthralled ") then name = "被奴役的"..npcCHN:getName(name:gsub("enthralled ",""))
	elseif name:find("demonic husk") then name = npcCHN:getName(name:gsub(" %(demonic husk%)","")).."(恶魔傀儡)"
	elseif name:find("servant") then 
		local tname = name:gsub("golem %(servant of ",""):gsub("Golem %(servant of ",""):gsub("%)","")
		local chnname = npcCHN:getName(tname)
		name = name:gsub("golem %(servant of","傀儡%("):gsub("Golem %(servant of","傀儡%("):gsub("%)","的仆人)"):gsub(tname,chnname)
	elseif name:find("\'s dream projection") then
		name = npcCHN:getName(name:gsub("\'s dream projection","")).."的梦境守卫"
	elseif name:find(" :") then
		local f,e=name:find(" :")
		local tname=name:sub(1,f-1)
		name = npcCHN:getName(tname)..name:gsub(tname,"")
	elseif npcNameCHN[name] then return npcNameCHN[name]
	elseif npcNameCHN[string.lower(name)] then return npcNameCHN[string.lower(name)]
	elseif name:find("gloomy ") or name:find("Gloomy ") then
		if npcNameCHN[name:gsub("gloomy ","")] then
			name = "黑暗的" .. npcNameCHN[name:gsub("gloomy ","")]
		elseif npcNameCHN[name:gsub("Gloomy ","")] then
			name = "黑暗的" .. npcNameCHN[name:gsub("Gloomy ","")]
		end
	elseif name:find("deformed ") or name:find("Deformed ") then
		if npcNameCHN[name:gsub("deformed ","")] then
			name = "畸形的" .. npcNameCHN[name:gsub("deformed ","")]
		elseif npcNameCHN[name:gsub("Deformed ","")] then
			name = "畸形的" .. npcNameCHN[name:gsub("Deformed ","")]
		end
	elseif name:find("sick ") or name:find("Sick ") then
		if npcNameCHN[name:gsub("sick ","")] then
			name = "生病的" .. npcNameCHN[name:gsub("sick ","")]
		elseif npcNameCHN[name:gsub("Sick ","")] then
			name = "生病的" .. npcNameCHN[name:gsub("Sick ","")]
		end
	elseif name:find("dreaming ") or name:find("Dreaming ") then
		if npcNameCHN[name:gsub("dreaming ","")] then
			name = "梦游的" .. npcNameCHN[name:gsub("dreaming ","")]
		elseif npcNameCHN[name:gsub("Dreaming ","")] then
			name = "梦游的" .. npcNameCHN[name:gsub("Dreaming ","")]
		end
	elseif name:find("slumbering ") or name:find("Slumbering ") then
		if npcNameCHN[name:gsub("slumbering ","")] then
			name = "睡着的" .. npcNameCHN[name:gsub("slumbering ","")]
		elseif npcNameCHN[name:gsub("Slumbering ","")] then
			name = "睡着的" .. npcNameCHN[name:gsub("Slumbering ","")]
		end	
	elseif name:find("dozing ") or name:find("Dozing ") then
		if npcNameCHN[name:gsub("dozing ","")] then
			name = "打瞌睡的" .. npcNameCHN[name:gsub("dozing ","")]
		elseif npcNameCHN[name:gsub("Dozing ","")] then
			name = "打瞌睡的" .. npcNameCHN[name:gsub("Dozing ","")]
		end
	elseif name:find("shade of ") and npcNameCHN[name:gsub("shade of ","")] then 
		name = npcNameCHN[name:gsub("shade of ","")] .. "之影"
	end

	return name
end

function npcCHN:getDesc(name, desc)
	if not name then return nil end
	if npcDescCHN[name] then 
        if type(npcDescCHN[name]) == 'table' then
            return npcDescCHN[name][desc] or desc
        else 
            return npcDescCHN[name]
        end
	elseif npcDescCHN[string.lower(name)] then return npcCHN:getDesc(string.lower(name), desc)
	elseif name:find("Crystaline Half %(") then
        return [[从你的完整身体中抽出的水晶分身。]]
	elseif name:find("Stone Half %(") then
        return [[从你的完整身体中抽出的岩石分身。]]
	elseif name:find("demonic husk") then
		name = name:gsub(" %(demonic husk%)","")
		return npcCHN:getDesc(name, desc)
	elseif name:find(" :") then
		local f,e=name:find(" :")
		local tname=name:sub(1,f-1)
		return npcCHN:getDesc(tname, desc)
	elseif name:find("\'s dream projection") then
		return npcCHN:getDesc(name:gsub("\'s dream projection",""), desc)
	elseif name:find("gloomy ") or name:find("Gloomy ") then
		if npcNameCHN[name:gsub("gloomy ","")] then return npcDescCHN[name:gsub("gloomy ","")]
		elseif npcNameCHN[name:gsub("Gloomy ","")] then return npcDescCHN[name:gsub("Gloomy ","")]
		end
	elseif name:find("deformed ") or name:find("Deformed ") then
		if npcNameCHN[name:gsub("deformed ","")] then return npcDescCHN[name:gsub("deformed ","")]
		elseif npcNameCHN[name:gsub("Deformed ","")] then return npcDescCHN[name:gsub("Deformed ","")]
		end
	elseif name:find("sick ") or name:find("Sick ") then
		if npcNameCHN[name:gsub("sick ","")] then return npcDescCHN[name:gsub("sick ","")]
		elseif npcNameCHN[name:gsub("Sick ","")] then return npcDescCHN[name:gsub("Sick ","")]
		end
	elseif name:find("dreaming ") or name:find("Dreaming ") then
		if npcNameCHN[name:gsub("dreaming ","")] then return npcDescCHN[name:gsub("dreaming ","")]
		elseif npcNameCHN[name:gsub("Dreaming ","")] then return npcDescCHN[name:gsub("Dreaming ","")]
		end
	elseif name:find("slumbering ") or name:find("Slumbering ") then
		if npcNameCHN[name:gsub("slumbering ","")] then return npcDescCHN[name:gsub("slumbering ","")]
		elseif npcNameCHN[name:gsub("Slumbering ","")] then return npcDescCHN[name:gsub("Slumbering ","")]
		end	
	elseif name:find("dozing ") or name:find("Dozing ") then
		if npcNameCHN[name:gsub("dozing ","")] then return npcDescCHN[name:gsub("dozing ","")]
		elseif npcNameCHN[name:gsub("Dozing ","")] then return npcDescCHN[name:gsub("Dozing ","")]
		end
	elseif name:find("shade of ") then
		return "通过一些可怕的秘法，这只生物的影子被剥离出了它原本的身体并获得了亡灵之躯。"
	else return nil
	end
end

npcNameCHN["shadow"] = "阴影"
npcNameCHN["will o' the wisp"] = "鬼火"
--蚂蚁(ant)
npcNameCHN["giant white ant"] = "白色巨蚁"
npcDescCHN["giant white ant"] = "一只巨大的白蚁。"

npcNameCHN["giant brown ant"] = "棕色巨蚁"
npcDescCHN["giant brown ant"] = "一只巨大的棕色蚂蚁。"

npcNameCHN["giant carpenter ant"] = "啮木巨蚁"
npcDescCHN["giant carpenter ant"] = "一只巨大的黑色蚂蚁，有巨大的下颚。"

npcNameCHN["giant green ant"] = "绿色巨蚁"
npcDescCHN["giant green ant"] = "一只巨大的绿色蚂蚁。"

npcNameCHN["giant red ant"] = "红色巨蚁"
npcDescCHN["giant red ant"] = "一只巨大的红色蚂蚁。"

npcNameCHN["giant blue ant"] = "蓝色巨蚁"
npcDescCHN["giant blue ant"] = "一只巨大的蓝色蚂蚁。"

npcNameCHN["giant yellow ant"] = "黄色巨蚁"
npcDescCHN["giant yellow ant"] = "一只巨大的黄色蚂蚁。"

npcNameCHN["giant black ant"] = "黑色巨蚁"
npcDescCHN["giant black ant"] = "一只巨大的黑色蚂蚁。"

npcNameCHN["giant fire ant"] = "火焰巨蚁"
npcDescCHN["giant fire ant"] = "一只巨大的红色蚂蚁，全身燃烧着火焰。"

npcNameCHN["giant ice ant"] = "寒冰巨蚁"
npcDescCHN["giant ice ant"] = "一只巨大的白色蚂蚁，它四周的空气都凝固了。"

npcNameCHN["giant lightning ant"] = "闪电巨蚁"
npcDescCHN["giant lightning ant"] = "一只巨大的黄色蚂蚁，身体闪耀着电火花。"

npcNameCHN["giant acid ant"] = "强酸巨蚁"
npcDescCHN["giant acid ant"] = "一只巨大的黑色蚂蚁，皮肤渗透出酸液。"

npcNameCHN["giant army ant"] = "近卫巨蚁"
npcDescCHN["giant army ant"] = "一只巨大的蚂蚁，有厚重的用于战斗的外壳。"

npcNameCHN["Queen Ant"] = "蚁后"
npcDescCHN["Queen Ant"] = "蚂蚁皇后，掌控死亡之啮的皇后！"

--水生生物(aquatic_critter)
npcNameCHN["giant eel"] = "巨型鳗鱼"
npcDescCHN["giant eel"] = "像蛇一样的生物，径直朝你游来。"

npcNameCHN["electric eel"] = "电鳗"
npcDescCHN["electric eel"] = "一个辐射出电流的蛇形生物。"

npcNameCHN["dragon turtle"] = "龙龟"
npcDescCHN["dragon turtle"] = "一只巨大、细长且泛着海蓝色的爬行动物。"

npcNameCHN["ancient dragon turtle"] = "远古龙龟"
npcDescCHN["ancient dragon turtle"] = "一只巨大、细长泛着海蓝色的爬行动物。看上去苍老而结实。"

npcNameCHN["squid"] = "乌贼"
npcDescCHN["squid"] = "它向你伸出能变形的魔爪，试图把你困住。"

npcNameCHN["ink squid"] = "喷墨乌贼"
npcDescCHN["ink squid"] = "它向你伸出能变形的魔爪，并使用黑色的墨汁喷向你，使你失明。"

--水生恶魔(aquatic_demon)
npcNameCHN["water imp"] = "小水怪"
npcDescCHN["water imp"] = "水中的小恶魔，向你缓慢投射法术。"

npcNameCHN["Walrog"] = "乌尔罗格"
npcDescCHN["Walrog"] = {}
npcDescCHN["Walrog"]["Walrog, the lord of Water, is fearsome to behold. The water writhes around him as if trying to escape, making his form indistinct. He does not seem surprised to see you."] = "乌尔罗格，水之主，是水中的恐怖恶魔。水如同想要逃离一般在他的周围沸腾，使他的影子若隐若现。他面对你的表情似乎并不惊讶。"
npcDescCHN["Walrog"]["Walrog, the lord of Water, is #AQUAMARINE#fearsome#LAST# to behold. The water boils and writhes around him as if trying to escape, frothing steam making his form indistinct.  He does not seem surprised to see you."] = "乌尔罗格，水之主，是水中的#AQUAMARINE#恐怖#LAST#恶魔。水如同想要逃离一般在他的周围沸腾，蔓延的蒸汽使他的影子若隐若现。他面对你的表情似乎并不惊讶。"

--动物——熊(bear)
npcNameCHN["brown bear"] = "棕熊"
npcDescCHN["brown bear"] = "有着棕色蓬松皮毛的熊。"

npcNameCHN["black bear"] = "黑熊"
npcDescCHN["black bear"] = "你闻起来有蜂蜜味吗？这只熊喜欢蜂蜜哦～"

npcNameCHN["cave bear"] = "穴居熊"
npcDescCHN["cave bear"] = "它已经离开洞穴觅食了许久。不幸的是，它找到了你。"

npcNameCHN["war bear"] = "战熊"
npcDescCHN["war bear"] = "被训练过杀人技巧的獠牙巨熊。"

npcNameCHN["grizzly bear"] = "灰熊"
npcDescCHN["grizzly bear"] = "一头巨大野蛮的熊，它比同类们更加凶残。"

npcNameCHN["polar bear"] = "北极熊"
npcDescCHN["polar bear"] = "这只巨大的白熊正在向南寻找食物。"

--飞禽(bird)
npcNameCHN["Phoenix"] = "凤凰"
npcDescCHN["Phoenix"] = "无尽的燃烧，无尽的死亡，无尽的重生，这只凤凰试图将它燃烧的命运带给你。"

--骨巨人(bone-giant)
npcNameCHN["bone giant"] = "骨巨人"
npcDescCHN["bone giant"] = "像铁塔一样的生物，由数不清的骨头构成。它全身围绕着邪恶的气息。"

npcNameCHN["eternal bone giant"] = "永恒骨巨人"
npcDescCHN["eternal bone giant"] = "像铁塔一样的生物，由数不清的骨头构成。它全身围绕着邪恶的气息。"

npcNameCHN["heavy bone giant"] = "重型骨巨人"
npcDescCHN["heavy bone giant"] = "像铁塔一样的生物，由数不清的骨头构成。它全身围绕着邪恶的气息。"

npcNameCHN["runed bone giant"] = "符文骨巨人"
npcDescCHN["runed bone giant"] = "像铁塔一样的生物，由数不清的骨头构成，它的骨头上布满符文和充斥着憎恨的魔法印记。"

--犬科动物(canine)
npcNameCHN["wolf"] = "狼"
npcDescCHN["wolf"] = "一头瘦弱的、狡猾的皮毛蓬松的饿狼，它正用贪婪的眼神看着你。"

npcNameCHN["great wolf"] = "巨狼"
npcDescCHN["great wolf"] = "当你行走在路上时，这只巨狼突然从草丛里跳出来扑向了你。"

npcNameCHN["dire wolf"] = "狂狼"
npcDescCHN["dire wolf"] = "这头狼几乎和一匹马一样大，它的尖牙利齿令人望而生畏。"

npcNameCHN["white wolf"] = "白狼"
npcDescCHN["white wolf"] = "一头来自北部荒野的狼，它膘肥身健，体型匀称。它的呼吸冰冷而急促且全身都凝结着冰霜。"

npcNameCHN["warg"] = "座狼"
npcDescCHN["warg"] = "这是一只狡猾且体型巨大的狼。"

npcNameCHN["fox"] = "狐狸"
npcDescCHN["fox"] = "这只灵巧的棕色狐狸从一只懒狗身上跳了过去。"

npcNameCHN["Rungof the Warg Titan"] = "泰坦座狼郎格夫"
npcDescCHN["Rungof the Warg Titan"] = "这只狼比普通座狼大三倍，它正用狡猾的眼神看着你。"

--冰龙(cold-drake)
npcNameCHN["cold drake hatchling"] = "冰龙幼仔"
npcDescCHN["cold drake hatchling"] = "一只冰龙幼仔。它本身并不强大，但是它们经常集体行动。"

npcNameCHN["cold drake"] = "冰龙"
npcDescCHN["cold drake"] = "一只成年冰龙，拥有冰冷刺骨的吐息和锋利的爪子。"

npcNameCHN["ice wyrm"] = "冰霜巨龙"
npcDescCHN["ice wyrm"] = "一只年长且强大的冰龙，拥有冰冷刺骨的吐息和锋利的爪子。"

--机械(construct)
npcNameCHN["broken golem"] = "破损的傀儡"
npcDescCHN["broken golem"] = "这个傀儡遭受过严重的破坏。"

npcNameCHN["golem"] = "傀儡"
npcDescCHN["golem"] = "这个傀儡的眼睛闪烁着魔法的能量。"

npcNameCHN["alchemist golem"] = "炼金傀儡"
npcDescCHN["alchemist golem"] = "这个傀儡的眼睛闪烁着魔法的能量。"

--水晶怪(crystal)
npcNameCHN["wisp"] = "元素结晶"
npcDescCHN["wisp"] = "一个充满了魔法能量的球体。它散发着耀眼的光芒，当它们接触其他物体时会发生爆炸。"

npcNameCHN["red crystal"] = "红色水晶体"
npcDescCHN["red crystal"] = "一个由红色水晶构成的生物，它散发着耀眼的红色光芒。"

npcNameCHN["white crystal"] = "白色水晶体"
npcDescCHN["white crystal"] = "一个由白色水晶构成的生物，它散发着冰冷的黑色气息。"

npcNameCHN["black crystal"] = "黑色水晶体"
npcDescCHN["black crystal"] = "一个由黑色水晶构成的生物，它可以吸收周围的光芒，黑暗笼着着它。"

npcNameCHN["crimson crystal"] = "深红水晶体"
npcDescCHN["crimson crystal"] = "一个通体由深红色水晶构成的生物，它通体散发着血红色的光芒。"

npcNameCHN["blue crystal"] = "海蓝水晶体"
npcDescCHN["blue crystal"] = "一个由蓝色水晶构成的生物，它通体荡漾着海蓝色的光芒。"

npcNameCHN["multi-hued crystal"] = "彩虹水晶体"
npcDescCHN["multi-hued crystal"] = "一个由各色水晶构成的生物，它通体散发着彩虹般的光芒。"

npcNameCHN["shimmering crystal"] = "闪光水晶体"
npcDescCHN["shimmering crystal"] = "一个由闪光水晶构成的生物，它通体围绕着球状的光芒。"

--精灵施法者(elven-caster)
npcNameCHN["elven mage"] = "精灵法师"
npcDescCHN["elven mage"] = "一位身穿黑色长袍的精灵法师。"

npcNameCHN["elven tempest"] = "精灵风暴术士"
npcDescCHN["elven tempest"] = "一位身穿散发着死鱼味蓝色长袍的精灵法师。"

npcNameCHN["elven cultist"] = "精灵信徒"
npcDescCHN["elven cultist"] = "一位身穿墨绿色长袍的精灵信徒。"

npcNameCHN["elven blood mage"] = "精灵血法师"
npcDescCHN["elven blood mage"] = "一位身穿黑色且鲜血斑斑长袍的精灵血法师。"

npcNameCHN["elven corruptor"] = "精灵堕落者"
npcDescCHN["elven corruptor"] = "一位精灵堕落者，生存于不毛之地上。"

--精灵战士(elven-warrior)
npcNameCHN["elven guard"] = "精灵守卫"
npcDescCHN["elven guard"] = "一位精灵守卫。"

npcNameCHN["mean looking elven guard"] = "凶巴巴的精灵守卫"
npcDescCHN["mean looking elven guard"] = "一位阴沉的刀疤脸精灵守卫。"

npcNameCHN["elven warrior"] = "精灵战士"
npcDescCHN["elven warrior"] = "一位身穿重甲的精灵战士。"

npcNameCHN["elven elite warrior"] = "精英精灵战士"
npcDescCHN["elven elite warrior"] = "一位身穿重甲的精灵战士。"

--元素生物 火焰(faeros)
npcNameCHN["faeros"] = "法罗"
npcDescCHN["faeros"] = "法罗是高智商的火元素，大家很少能在火山以外的地方看到它们。也许，它们根本不属于这个世界。"

npcNameCHN["greater faeros"] = "强化法罗"
npcDescCHN["greater faeros"] = "法罗是高智商的火元素，大家很少能在火山以外的地方看到它们。也许，它们根本不属于这个世界。"

npcNameCHN["ultimate faeros"] = "究极法罗"
npcDescCHN["ultimate faeros"] = "法罗是高智商的火元素，大家很少能在火山以外的地方看到它们。也许，它们根本不属于这个世界。"

--猫科动物(feline)
npcNameCHN["snow cat"] = "雪猫"
npcDescCHN["snow cat"] = "一只巨大的花猫。"

npcNameCHN["panther"] = "黑豹"
npcDescCHN["panther"] = "一只体型匀称的黑豹。"

npcNameCHN["tiger"] = "老虎"
npcDescCHN["tiger"] = "一只真正的肉食动物，它有着黄黑相间的毛皮。"

npcNameCHN["sabertooth tiger"] = "剑齿虎"
npcDescCHN["sabertooth tiger"] = "这只凶残的老虎有着短剑般大小的锋利牙齿。"

--火龙(fire-drake)
npcNameCHN["fire drake hatchling"] = "火龙幼仔"
npcDescCHN["fire drake hatchling"] = "一只火龙幼仔。它本身并不强大，但是它们经常集体行动。"

npcNameCHN["fire drake"] = "火龙"
npcDescCHN["fire drake"] = "一只成年火龙，拥有炽烈的火焰吐息和锋利的爪子。"

npcNameCHN["fire wyrm"] = "火焰巨龙"
npcDescCHN["fire wyrm"] = "一只年长且强大的火龙，拥有炽烈的火焰吐息和锋利的爪子。"

--鬼魂(ghost)
npcNameCHN["dread"] = "梦靥"
npcDescCHN["dread"] = "它的可怕形象冲击着你的双眼。它是死亡的化身，它丑恶的身体似乎在向宇宙宣告着它与现实的格格不入。"

npcNameCHN["dreadmaster"] = "梦靥之王"
npcDescCHN["dreadmaster"] = "它代表着无可匹敌的非生命力量。是对现实存在的否定。对它的轻微接触都会影响生命的流动，它那纯粹的不可思议的黑色边缘能够轻松的使岩石崩解，血肉成灰。"

npcNameCHN["banshee"] = "哀嚎女妖"
npcDescCHN["banshee"] = "一个发出凄惨尖叫的女妖。"

npcNameCHN["ruin banshee"] = "毁灭女妖"
npcDescCHN["ruin banshee"] = "乌鲁洛克的吐息中诞生，不断嚎叫的复仇之魂。恐惧之地的气息不断从她次元扭曲的身体中渗出，不断灼烧和腐蚀着周围的一切。"

--恶鬼(ghoul)
npcNameCHN["ghoul"] = "食尸鬼"
npcDescCHN["ghoul"] = "肉块正在不断的从这个腐朽的身体上掉落。"

npcNameCHN["ghast"] = "妖鬼"
npcDescCHN["ghast"] = "这个肮脏的生物是食尸鬼的分支，并且经常带领着一群食尸鬼。它散发着令人作呕的气息，并且它的噬咬会传播瘟疫。"

npcNameCHN["ghoulking"] = "食尸鬼王"
npcDescCHN["ghoulking"] = "这具腐烂的身躯散发着一股恶臭。它的脊背用金子装饰着，当它在你的面前闪过时你看到了它眼睛里的仇恨。"

npcNameCHN["risen corpse"] = "浮尸"
npcDescCHN["risen corpse"] = "一具通过黑暗魔法漂浮着的尸体"

--元素生物 大气(gwelgoroth)
npcNameCHN["gwelgoroth"] = "格维格罗斯"
npcDescCHN["gwelgoroth"] = "格维格罗斯是非常强大的气系元素，它们被一股强大的魔法从老家里赶出来。"

npcNameCHN["greater gwelgoroth"] = "强化格维格罗斯"
npcDescCHN["greater gwelgoroth"] = "格维格罗斯是非常强大的气系元素，它们被一股强大的魔法从老家里赶出来。"

npcNameCHN["ultimate gwelgoroth"] = "究极格维格罗斯"
npcDescCHN["ultimate gwelgoroth"] = "格维格罗斯是非常强大的气系元素，它们被一股强大的魔法从老家里赶出来。"
--元素生物 寒冰(Shivgoroth)
npcNameCHN["shivgoroth"] = "西弗格罗斯"
npcDescCHN["shivgoroth"] = "西弗格罗斯是非常强大的元素，它们被一股强大的魔法从老家里赶出来"

npcNameCHN["greater shivgoroth"] = "强化西弗格罗斯"
npcDescCHN["greater shivgoroth"] = "强化西弗格罗斯是非常强大的元素，它们被一股强大的魔法从老家里赶出来"

npcNameCHN["ultimate shivgoroth"] = "究极西弗格罗斯"
npcDescCHN["ultimate shivgoroth"] = "究极西弗格罗斯是非常强大的元素，它们被一股强大的魔法从老家里赶出来"
--艾尔德里奇(horror)
npcNameCHN["worm that walks"] = "蠕虫合体"
npcDescCHN["worm that walks"] = "一件鼓鼓囊囊的长袍，长袍的缝隙里不断蠕动着浮肿的蠕虫。它有着两只臂膀一样的附属物，每只手都由重叠的蠕虫组成，各握着一柄覆有胆汁的斧子。每次挥舞武器的时，它都会溅出尸僵毒液，每滴毒液在落到地面前都在沸腾和翻滚着。"

npcNameCHN["nightmare horror"] = "梦靥恐魔"
npcDescCHN["nightmare horror"] = "一只漆黑的生物，它深邃的黑色身体反射出了你深深的恐惧。"

npcNameCHN["bloated horror"] = "浮肿恐魔"
npcDescCHN["bloated horror"] = "这是一只有着人头的漂浮物。它的孩子似的光头大的不成比例，并且它还有着满身恶臭的脓疮。"

npcNameCHN["headless horror"] = "无头恐魔"
npcDescCHN["headless horror"] = "一只高高瘦瘦的无头人形怪物，它有着巨大的胃。"

npcNameCHN["eldritch eye"] = "艾尔德里奇之眼"
npcDescCHN["eldritch eye"] = "一只小小的充血眼球，它游荡在这里。"

npcNameCHN["luminous horror"] = "金色恐魔"
npcDescCHN["luminous horror"] = "一只身材瘦长的怪物，它的身体由金色的光芒组成。"

npcNameCHN["radiant horror"] = "灼眼恐魔"
npcDescCHN["radiant horror"] = "一只身材瘦长的四臂人形怪物，它的身体由金色的光芒组成。它的光芒令人无法直视，你可以感受到高温从它身上不断的向外辐射。"

npcNameCHN["devourer"] = "吞噬者"
npcDescCHN["devourer"] = "一只无头怪物，它有着圆润的体型和又粗又短的四肢。它的牙齿似乎占据了整个身体。"

npcNameCHN["blade horror"] = "刀锋恐魔"
npcDescCHN["blade horror"] = "刀锋环绕在这只薄薄的漂浮着的恐魔周围。它周围的空气中环绕着锋利的能量，撕裂着靠近的任何东西。"

npcNameCHN["oozing horror"] = "黏液恐魔"
npcDescCHN["oozing horror"] = "一个巨大的有着绿色斑点的黏糊糊的物体从地上爬过来。在一堆黏糊糊中隐藏着的眼睛，寻找着潜藏的猎物。"

npcNameCHN["umbral horror"] = "暗影恐魔"
npcDescCHN["umbral horror"] = "一个闪过黑暗的阴影，迅速遁入了无尽的黑暗。"

npcNameCHN["dreaming horror"] = "梦境恐魔"
npcDescCHN["dreaming horror"] = {}
npcDescCHN["dreaming horror"][ [[A vaguely tentacled yet constantly changing form rests here apparently oblivious to your existence.
With each slow breath it takes reality distorts around it.  Blue twirls into red, green twists into yellow, and the air sings softly before bursting into a myriad of pastel shapes and colors.]] ] = "这是一只混沌状的触手生物，它在这里惬意的休息并不断的变幻着颜色，显然无视了你的存在。它的每次呼吸都会使周围的空间发生轻微的扭曲。在它身上氤氲着的光芒由蓝转红、由绿转黄，交织成一片五彩缤纷的和谐幻景。"
npcDescCHN["dreaming horror"][ [[A vaguely tentacled yet rapidly changing shape floats here.  With each breath you can feel reality twist, shatter, and break. 
Blue burns into red, green bursts into yellow, and the air crackles and hisses before exploding into a thousand fragments of sharp shapes and colors.]] ] = "这是一只混沌状的触手生物，被吵醒的它快速变幻着颜色。它的每次呼吸都会使周围的空间剧烈地扭曲，撕裂，粉碎。在它身上氤氲着的光芒由蓝转红、由绿转黄，周围的空气鼓动着迸射出无数五彩斑斓的晶莹碎片。"

npcNameCHN["dream seed"] = "梦境之种"
npcDescCHN["dream seed"] = "这是一个漂浮着的粉红色泡沫，它似乎能够反映出世界的另一面，但是由于这虚幻的空间，它所反映的事物只可能存在于我们的梦境中。"

npcNameCHN["Grgglck the Devouring Darkness"] = "格尔格勒克·黑暗吞噬者"
npcDescCHN["Grgglck the Devouring Darkness"] = "这是来自地底最深处的恐魔。看起来像是一团巨大触手，它在不断的向你靠近。你可以在它那血盆大口里看到剃刀般的牙齿。"

npcNameCHN["Grgglck's Tentacle"] = "格尔格勒克的触须"
npcDescCHN["Grgglck's Tentacle"] = "这是格尔格勒克的一条触须。它看起来比主体更加脆弱。"

npcNameCHN["Ak'Gishil"] = "阿克·吉希尔"
npcDescCHN["Ak'Gishil"] = "这只刀锋般的恐魔生于强大的能量漩涡中，并逐渐掌握了时空之核。它能够不断的撕裂空间，召唤出成群的刀刃在其身周飞舞。"

npcNameCHN["Animated Sword"] = "次元之刃"
npcDescCHN["Animated Sword"] = "时空在其周围扭曲。"

npcNameCHN["Distorted Animated Sword"] = "极·次元之刃"
npcDescCHN["Distorted Animated Sword"] = "时空在其周围崩塌。"

npcNameCHN["ravenous horror"] = "贪婪恐魔"
npcDescCHN["ravenous horror"] = "这个丑陋怪物的牙齿中不断滴落邪恶的液体。"

npcNameCHN["swarming horror"] = "群生恐魔"
npcDescCHN["swarming horror"] = "体型小的、象鱼一样的怪物，总是成群出现。"

npcNameCHN["abyssal horror"] = "深渊恐魔"
npcDescCHN["abyssal horror"] = "这个深黑的物体被黑暗围绕，你只能认出一对猩红的眼睛，藏在一堆触手后面。"

npcNameCHN["boiling horror"] = "沸腾恐魔"
npcDescCHN["boiling horror"] = "这个充满泡沫的水球有着极高的温度。"

npcNameCHN["entrenched horror"] = "巨石恐魔 "
npcDescCHN["entrenched horror"] = "这个巨大的石状生物有规律的震动着，它的触手为了水和食物正在四处游走探测。"

npcNameCHN["swarm hive"] = "育种恐魔"
npcDescCHN["swarm hive"] = "巨大的肉块在不断振动、摇晃，从孔口处不断涌现生物。"

npcNameCHN["necrotic mass"] = "亡灵集合"
npcDescCHN["necrotic mass"] = "这块腐烂的血肉不断变形颤抖，不过似乎没有智力和移动力。"

npcNameCHN["necrotic abomination"] = "亡灵憎恶"
npcDescCHN["necrotic abomination"] = "这块腐烂的被切碎的血肉，挣扎着向你移动，在路上喷出的血液和内脏。"

npcNameCHN["bone horror"] = "骨灵恐魔"
npcDescCHN["bone horror"] = "中空的胸腔里传出巨大的破碎声，似乎许多骷髅在里面，突出，缠绕，融合，形成长长的骨架来支撑它，而其他部分倒塌向内。与此同时，似乎它们都想抓住你。"

npcNameCHN["sanguine horror"] = "血红恐魔"
npcDescCHN["sanguine horror"] = "这个不断跳动不断颤抖的物体是深红色的，似乎完全由浓厚致命的血液组成。在其表面仍有富有节奏的波纹，也许在其身上的某个地方仍有心脏跳动"

npcNameCHN["animated blood"] = "活化血液"
npcDescCHN["animated blood"] = "血红色的物体不断滴落液体，散落在地面上。滴落下来的血液似乎有着自己的意志。"
--时空兽(horror_temporal)
npcNameCHN["dredgling"] = "坠灵恐魔"
npcDescCHN["dredgling"] = "一只小小的红皮人型生物，它有着巨大的眼睛。"

npcNameCHN["dredge"] = "挖掘魔"
npcDescCHN["dredge"] = "一只灰色皮肤的生物，它的手臂像树干一样粗壮有力。它拖动着膝关节，缓慢的向你爬过来。"

npcNameCHN["dredge captain"] = "挖掘魔首领"
npcDescCHN["dredge captain"] = "一只灰色皮肤的生物，它的手臂像树干一样粗壮有力。它的半边身体又老又皱，另外半边身体则显得格外年轻。"

npcNameCHN["temporal stalker"] = "时空猎手"
npcDescCHN["temporal stalker"] = "瘦长的金属怪物，它有着金属的爪子和锋利的牙齿。"

npcNameCHN["void horror"] = "虚空靥魔"
npcDescCHN["void horror"] = "它乍一看像是时空中的一道缝隙，但你对它的印象远远不止于此。"

--堕落者(horror-corrupted)
npcNameCHN["dremling"] = "德瑞姆矮人"
npcDescCHN["dremling"] = "身材矮小且拥有部分矮人特征的人形怪物。它的战斧和盾牌看起来又锈又钝，几乎从未修理过。"

npcNameCHN["drem"] = "德瑞姆"
npcDescCHN["drem"] = "皮肤粗糙且长有角质骨刺的黑色巨人。它没有明显的脸部特征，眼神空旷而呆滞。"

npcNameCHN["drem master"] = "德瑞姆领主"
npcDescCHN["drem master"] = "丑陋且具有部分矮人特征的人形怪物，它装备了一件破烂不堪的重甲。尽管它无法说话，但是它却领导着其他矮人。"

npcNameCHN["brecklorn"] = "布瑞克隆"
npcDescCHN["brecklorn"] = "一只巨大的无毛蝙蝠，它有着一张不停尖叫且扭曲的矮人脸。躁狂症症在它畸形的身体内蔓延，当它靠近时，你感觉心跳都快停止了。"

npcNameCHN["grannor'vor"] = "格兰诺伏尔"
npcDescCHN["grannor'vor"] = "一只长的类似蛞蝓的生物，当它缓慢经过时，会留下一滩酸性的踪迹。它的头部有着奇怪的人类特征。"

npcNameCHN["grannor'vin"] = "格兰诺文"
npcDescCHN["grannor'vin"] = "一只长有人脸的类似蛞蝓的生物。阴影似乎都被扯向了它厚重的身体，当它靠近你时，灯光似乎都模糊了。"

--人型随机BOSS(humanoid_random_boss)
npcNameCHN["human"] = "人类"
npcDescCHN["human"] = "人类"

npcNameCHN["thalore"] = "自然精灵"
npcDescCHN["thalore"] = "自然精灵"

npcNameCHN["shalore"] = "永恒精灵"
npcDescCHN["shalore"] = "永恒精灵"

npcNameCHN["halfling"] = "半身人"
npcDescCHN["halfling"] = "半身人"

npcNameCHN["dwarf"] = "矮人"
npcDescCHN["dwarf"] = "矮人"

--果冻怪(jelly)
npcNameCHN["green jelly"] = "绿果冻怪"
npcDescCHN["green jelly"] = "地板上的一团绿色胶状物体。"

npcNameCHN["red jelly"] = "红果冻怪"
npcDescCHN["red jelly"] = "地板上的一团红色胶状物体。"

npcNameCHN["blue jelly"] = "蓝果冻怪"
npcDescCHN["blue jelly"] = "地板上的一团蓝色胶状物体。"

npcNameCHN["white jelly"] = "白果冻怪"
npcDescCHN["white jelly"] = "地板上的一团白色胶状物体。"

npcNameCHN["yellow jelly"] = "黄果冻怪"
npcDescCHN["yellow jelly"] = "地板上的一团黄色胶状物体。"

npcNameCHN["black jelly"] = "黑果冻怪"
npcDescCHN["black jelly"] = "地板上的一团黑色胶状物体。"

npcNameCHN["Malevolent Dimensional Jelly"] = "恶毒次元果冻怪"
npcDescCHN["Malevolent Dimensional Jelly"] = "地板上的一团黑色胶状物体。通过它的身体可以看到异次元，当你盯着它时，你发现有东西正从它身体里冒出来。"

--巫妖(lich)
npcNameCHN["lich"] = "巫妖"
npcDescCHN["lich"] = "为了探索永恒的生命，这些人允许不死族剥夺他们的生趣。现在，他们同样在毁灭生者。"

npcNameCHN["ancient lich"] = "远古巫妖"
npcDescCHN["ancient lich"] = "一位存活了不知多少岁月的巫妖，它对这个世界和生者充满了仇恨，所以它试图去剥夺生者所拥有而它所没有的财富——生命。"

npcNameCHN["archlich"] = "高阶巫妖"
npcDescCHN["archlich"] = "从比漆黑的夜还要深邃的黑暗中，你感受到了一股冰冷的寒意。很久以前它放弃了生命，但却没忘记力量，相反，它被怨恨和邪念所强化，这只扭曲的不死生物要毁灭所有的生者。"

npcNameCHN["blood lich"] = "血巫妖"
npcDescCHN["blood lich"] = "来自一位非常强大的死灵法师的沸腾的、跳动的、有形的血液。跟它战斗等于要饱受Fearscape的摧残。"

--虚空兽(losgoroth)
npcNameCHN["losgoroth"] = "洛斯格罗斯"
npcDescCHN["losgoroth"] = "洛斯格罗斯是非常强大的虚空生物，居住于群星之间的星空中。在星球表面几乎看不到这种生物。"

npcNameCHN["manaworm"] = "魔法蠕虫"
npcDescCHN["manaworm"] = "魔法蠕虫是以施法者的魔力为食的虚空生物。如果它们近距离接触到法师，它们会缠上去并吸干对方的魔力。"

--大恶魔(major-demon)
npcNameCHN["dolleg"] = "多雷格"
npcDescCHN["dolleg"] = "一只畸形的恶魔，身上长有酸性尖刺。"

npcNameCHN["dúathedlen"] = "多瑟顿"
npcDescCHN["dúathedlen"] = "在黑暗之雾的笼罩下，依稀可见恶魔的形态。"

npcNameCHN["uruivellas"] = "乌尔维拉斯"
npcDescCHN["uruivellas"] = "这只恶魔长的类似于一只拥有炽焰光环的米诺陶斯，并且这只米诺陶斯全身长满了尖角。哦，还有两倍大的体型……"

npcNameCHN["thaurhereg"] = "修尔希瑞格"
npcDescCHN["thaurhereg"] = "这只可怕的恶魔浑身是血，鲜血在它的身上以某种形式流淌。仅仅看了一眼，你就感到浑身不舒服。"

npcNameCHN["daelach"] = "达莱奇"
npcDescCHN["daelach"] = "你无法猜测这只恶魔的真实形态。它的身体被一层炽热的黑暗所笼罩。它向你发起快速的冲锋，同时向你发射致命的法术。"

npcNameCHN["champion of Urh'Rok"] = "乌鲁洛克的精英卫兵"
npcDescCHN["champion of Urh'Rok"] = "乌鲁洛克精英卫队的一员。千年的梦靥使血肉和被诅咒的钢铁融合为一只钢铁怪物站在你面前。"

npcNameCHN["forge-giant"] = "锻造巨人"
npcDescCHN["forge-giant"] = "锻造巨人的每只手都有一柄地底锻造大锤——被乌鲁洛克加持以锻造魔钢的大锤。进入他们的领地是极度危险的事情。"

npcNameCHN["Khulmanar, General of Urh'Rok"] = "库马纳·乌鲁洛克之近卫将军"
npcDescCHN["Khulmanar, General of Urh'Rok"] = "这个庞大的躯体笼罩在黑暗之炎中，他在一群小恶魔中显得鹤立鸡群。在他手里握着一柄沉重的战斧，火焰在刀锋处舞动。"

--小恶魔(minor-demon)
npcNameCHN["fire imp"] = "火魔婴"
npcDescCHN["fire imp"] = "一只小恶魔，它向你发射法术。"

npcNameCHN["wretchling"] = "酸液树魔"
npcDescCHN["wretchling"] = "酸液从这只小恶魔的身体上渗出。当心，它们喜欢群体行动。"

npcNameCHN["quasit"] = "夸塞魔"
npcDescCHN["quasit"] = "一只装备了重甲的小恶魔，它向你发起冲锋。"

--米诺陶(minotaur)
npcNameCHN["minotaur"] = "米诺陶"
npcDescCHN["minotaur"] = "它拥有人类和牛的特征。"

npcNameCHN["maulotaur"] = "玛诺陶"
npcDescCHN["maulotaur"] = "好战的米诺陶，装备有一柄大锤且拥有强力的魔法。"

--霉菌(molds)
npcNameCHN["grey mold"] = "灰色霉菌"
npcDescCHN["grey mold"] = "地板上的奇特灰色植物。"

npcNameCHN["brown mold"] = "棕色霉菌"
npcDescCHN["brown mold"] = "地板上的奇特棕色植物。"

npcNameCHN["shining mold"] = "闪光霉菌"
npcDescCHN["shining mold"] = "地板上的奇特闪光植物。"

npcNameCHN["green mold"] = "绿色霉菌"
npcDescCHN["green mold"] = "地板上的奇特绿色植物。"

npcNameCHN["Z'quikzshl the skeletal mold"] = "骨化霉菌兹基克茨"
npcDescCHN["Z'quikzshl the skeletal mold"] = "这只野心勃勃的霉菌拒绝死亡。然而，一只霉菌如何成为骷髅超出了你的知识范畴。也许是它自己的骨头，也许是那些倒霉的冒险者的？"

--多彩龙(multihued-drake)
npcNameCHN["multi-hued drake hatchling"] = "七彩龙幼仔"
npcDescCHN["multi-hued drake hatchling"] = "一只七彩龙幼仔。它本身并不强大，但是它们经常集体行动。"

npcNameCHN["multi-hued drake"] = "七彩龙"
npcDescCHN["multi-hued drake"] = "一只成年七彩龙，拥有许多致命的吐息和锋利的爪子。"

npcNameCHN["greater multi-hued wyrm"] = "强化七彩巨龙"
npcDescCHN["greater multi-hued wyrm"] = "一只年长且强大的火龙，拥有许多致命的吐息和锋利的爪子。"

npcNameCHN["Ureslak the Prismatic"] = "七色闪光，乌瑞斯拉克"
npcDescCHN["Ureslak the Prismatic"] = "一只巨大的七彩龙。它似乎在快速的变幻颜色。"

--木乃伊(mummy)

--纳迦(naga)
npcNameCHN["naga myrmidon"] = "娜迦侍从"
npcDescCHN["naga myrmidon"] = "在你面前站着一个高大的人影——一个非常高的人型怪物，在腿部长着巨大的蛇尾巴，他以此来支撑他的身体。他的上半身是人形,护甲下面隐约可见发达的肌肉，两只巨大的双手紧握着锋利的三叉戟。他用黑暗视觉盯着你，就像一只狼一样，随时准备扑向毫无防备的猎物。"

npcNameCHN["naga tide huntress"] = "娜迦潮汐女猎手"
npcDescCHN["naga tide huntress"] = "尽管那根指向你的锋利箭矢是令人恐惧的，但是更加令人恐惧的是使用它的生物。一个身材姣好，杨柳细腰的女人，身后却拖了一条数英尺的尾巴。她的眼睛变的冰冷，似乎有魔力凝聚在她那锋利的箭矢上。突然间，你又感到箭矢的恐怖了。"

npcNameCHN["naga psyren"] = "娜迦海妖"
npcDescCHN["naga psyren"] = "你从未见过如此妖娆和恐怖的结合。上半身是一个美丽而出尘，性感而又迷人的女人。下半身是厚实而光滑的蛇尾。尾巴在她身后缓慢的来回摆动着，摆动的幅度醒目而又具有迷惑性。当你抬头看她时，你看到她性感的嘴角漾起神秘的微笑。"

--食人魔(ogre)
npcNameCHN["ogre guard"] = "食人魔守卫"
npcDescCHN["ogre guard"] = "一个手里拿着重锤的食人魔，随时准备将你一锤击碎。"

npcNameCHN["ogre warmaster"] = "食人魔战争领主"
npcDescCHN["ogre warmaster"] = "一个精于战斗技巧的食人魔，她已经等不及在你身上试试自己的新技能了。"

npcNameCHN["ogre mauler"] = "食人魔重击者"
npcDescCHN["ogre mauler"] = "冲击！碾碎！摧毁一切！"

npcNameCHN["ogre pounder"] = "食人魔摔跤手"
npcDescCHN["ogre pounder"] = "这个食人魔快速地接近你，张开他死亡的拥抱。"

npcNameCHN["ogre rune-spinner"] = "食人魔符文师"
npcDescCHN["ogre rune-spinner"] = "一个高大的食人魔守卫，她的身上印刻着充满魔力的符文。"

--软泥怪(ooze)
npcNameCHN["green ooze"] = "绿泥怪"
npcDescCHN["green ooze"] = "又绿又粘的软泥怪。"

npcNameCHN["red ooze"] = "红泥怪"
npcDescCHN["red ooze"] = "又红又粘的软泥怪。"

npcNameCHN["blue ooze"] = "蓝泥怪"
npcDescCHN["blue ooze"] = "又蓝又粘的软泥怪。"

npcNameCHN["white ooze"] = "白泥怪"
npcDescCHN["white ooze"] = "又白又粘的软泥怪。"

npcNameCHN["yellow ooze"] = "黄泥怪"
npcDescCHN["yellow ooze"] = "又黄又粘的软泥怪。"

npcNameCHN["black ooze"] = "黑泥怪"
npcDescCHN["black ooze"] = "又黑又粘的软泥怪。"

npcNameCHN["gelatinous cube"] = "粘胶方块"
npcDescCHN["gelatinous cube"] = "这是一个奇怪的、巨大的凝胶状的立方体结构，它沿着走廊的四壁巡逻。通过它的透明果冻状结构，你可以看到它吞噬的宝物和一些尸体。"

npcNameCHN["crimson ooze"] = "深红泥怪"
npcDescCHN["crimson ooze"] = "深红且粘的软泥怪。"

npcNameCHN["brittle clear ooze"] = "透明泥怪"
npcDescCHN["brittle clear ooze"] = "半透明且粘的软泥怪。"

npcNameCHN["slimy ooze"] = "史莱姆泥怪"
npcDescCHN["slimy ooze"] = "粘糊糊的软泥怪。"

npcNameCHN["poison ooze"] = "剧毒泥怪"
npcDescCHN["poison ooze"] = "粘糊糊且有毒的软泥怪。"

--npcNameCHN["morphic ooze"] = "善变泥怪"
--npcDescCHN["morphic ooze"] = "它的形态在不断的发生变化。"

npcNameCHN["bloated ooze"] = "浮肿泥怪"
npcDescCHN["bloated ooze"] = "血肉制成的软泥怪"

npcNameCHN["mucus ooze"] = "粘液泥怪"
npcDescCHN["mucus ooze"] = "粘液形成的软泥怪"
--兽人(orc)
npcNameCHN["orc warrior"] = "兽人战士"
npcDescCHN["orc warrior"] = "它是一个勇敢的，历经多次战争洗礼的幸存者。"

npcNameCHN["orc archer"] = "兽人弓箭手"
npcDescCHN["orc archer"] = "它是一个勇敢的，历经多次战争洗礼的幸存者。"

npcNameCHN["orc soldier"] = "兽人士兵"
npcDescCHN["orc soldier"] = "一个勇猛的兽人士兵。"

npcNameCHN["fiery orc wyrmic"] = "炽焰兽人龙战士"
npcDescCHN["fiery orc wyrmic"] = "一个彪悍的、经过龙战士训练的兽人。"

npcNameCHN["icy orc wyrmic"] = "冰霜兽人龙战士"
npcDescCHN["icy orc wyrmic"] = "一个彪悍的、经过龙战士训练的兽人。"

npcNameCHN["orc assassin"] = "兽人刺客"
npcDescCHN["orc assassin"] = "一个掌握刺杀和潜行的兽人刺客。"

npcNameCHN["orc master assassin"] = "兽人刺客大师"
npcDescCHN["orc master assassin"] = "一个精通刺杀和潜行的兽人刺客。"

npcNameCHN["orc grand master assassin"] = "高阶兽人刺客大师"
npcDescCHN["orc grand master assassin"] = "一个精通刺杀和潜行的兽人刺客。"

npcNameCHN["Kra'Tor the Gluttonous"] = "贪吃的克拉塔"
npcDescCHN["Kra'Tor the Gluttonous"] = "一只肥胖过度的兽人，他有一头乌黑的秀发，皮肤油腻且长满了痘痘。他身穿板甲，手握一个几乎和他一样大的车轮战斧。"

--兽族野性师(orc-gorbat)
npcNameCHN["orc summoner"] = "兽人召唤师"
npcDescCHN["orc summoner"] = "一个可以和自然交流的兽人。"

npcNameCHN["orc grand summoner"] = "高阶兽人召唤师"
npcDescCHN["orc grand summoner"] = "一个擅长和自然交流的兽人。"

npcNameCHN["orc master wyrmic"] = "兽人龙战士大师"
npcDescCHN["orc master wyrmic"] = "一个彪悍的、经过龙战士训练的兽人士兵。"

npcNameCHN["orc mage-hunter"] = "兽人猎法者"
npcDescCHN["orc mage-hunter"] = "一只穿着板甲的兽人，魔法能量在它的周围湮灭。"

--兽族斗士(orc-grushnak)
npcNameCHN["orc fighter"] = "兽人斗士"
npcDescCHN["orc fighter"] = "一只身穿板甲的兽人，装备有一面盾牌和一个致命的斧头。"

npcNameCHN["orc elite fighter"] = "精英兽人斗士"
npcDescCHN["orc elite fighter"] = "一只身穿板甲的兽人，装备有一面盾牌和一个致命的斧头。"

npcNameCHN["orc berserker"] = "兽人狂战士"
npcDescCHN["orc berserker"] = "一只身穿板甲的兽人，手里握着一把巨斧。"

npcNameCHN["orc elite berserker"] = "精英兽人狂战士"
npcDescCHN["orc elite berserker"] = "一只身穿板甲的兽人，手里握着一把巨斧。"

--兽族死灵师(orc-rak-shor)
npcNameCHN["orc necromancer"] = "兽人死灵法师"
npcDescCHN["orc necromancer"] = "一只身穿黑色长袍的兽人。它在用嘶哑的声音低语。"

npcNameCHN["orc blood mage"] = "兽人血法师"
npcDescCHN["orc blood mage"] = "一只穿着鲜血斑斑长袍的兽人。它在用嘶哑的声音低语。"

npcNameCHN["orc corruptor"] = "兽人堕落者"
npcDescCHN["orc corruptor"] = "一只穿着破烂长袍的兽人。它在用嘶哑的声音低语。"

--兽族施法者(orc-vor)
npcNameCHN["orc pyromancer"] = "兽人烈焰术士"
npcDescCHN["orc pyromancer"] = "一只身穿亮红色长袍的兽人。它在用嘶哑的声音低语。"

npcNameCHN["orc high pyromancer"] = "高阶兽人烈焰术士"
npcDescCHN["orc high pyromancer"] = "一只身穿亮红色长袍的兽人。它在用嘶哑的声音低语。"

npcNameCHN["orc cryomancer"] = "兽人冰霜术士"
npcDescCHN["orc cryomancer"] = "一只身穿冰蓝色长袍的兽人。它在用嘶哑的声音低语。"

npcNameCHN["orc high cryomancer"] = "高阶兽人冰霜术士"
npcDescCHN["orc high cryomancer"] = "一只身穿冰蓝色长袍的兽人。它在用嘶哑的声音低语。"

--植物(plant)
npcNameCHN["giant venus flytrap"] = "巨大捕蝇草"
npcDescCHN["giant venus flytrap"] = "这棵巨大的肉食性植物正在寻找果腹的东西。"

npcNameCHN["treant"] = "树精"
npcDescCHN["treant"] = "一棵有着极强近距离感知的树，它对周围的生物造成了威胁。"

npcNameCHN["poison ivy"] = "毒藤陷阱"
npcDescCHN["poison ivy"] = "这棵不起眼的小植物使你全身发痒。"

npcNameCHN["honey tree"] = "蜜蜂树"
npcDescCHN["honey tree"] = "当你靠近它时，你听到一阵刺耳的嗡嗡声。"

--里奇昆虫(ritch)
npcNameCHN["ritch larva"] = "里奇幼虫"
npcDescCHN["ritch larva"] = "里奇是体型巨大的昆虫，生活在远东南部的不毛之地。它们是恶毒的捕食者，可以将致病的毒素注入猎物体内，并且它们锋利的爪子可以撕裂大部分护甲。"

npcNameCHN["ritch hunter"] = "里奇猎手"
npcDescCHN["ritch hunter"] = "里奇是体型巨大的昆虫，生活在远东南部的不毛之地。它们是恶毒的捕食者，可以将致病的毒素注入猎物体内，并且它们锋利的爪子可以撕裂大部分护甲。"

npcNameCHN["ritch hive mother"] = "里奇虫母"
npcDescCHN["ritch hive mother"] = "里奇是体型巨大的昆虫，生活在远东南部的不毛之地。它们是恶毒的捕食者，可以将致病的毒素注入猎物体内，并且它们锋利的爪子可以撕裂大部分护甲。"

--小动物(rodent)
npcNameCHN["giant white mouse"] = "巨大白鼠"
npcDescCHN["giant white mouse"] = "巨大白鼠"

npcNameCHN["giant brown mouse"] = "巨大棕鼠"
npcDescCHN["giant brown mouse"] = "巨大棕鼠"

npcNameCHN["giant white rat"] = "巨大白耗子"
npcDescCHN["giant white rat"] = "巨大白耗子"

npcNameCHN["giant brown rat"] = "巨大棕耗子"
npcDescCHN["giant brown rat"] = "巨大棕耗子"

npcNameCHN["giant rabbit"] = "巨大兔子"
npcDescCHN["giant rabbit"] = "快去打小白兔，哼哼哈嘿；快去打小白兔，哼哼哈嘿；吾辈就是要去，打小白兔……"

npcNameCHN["giant crystal rat"] = "巨大水晶耗子"
npcDescCHN["giant crystal rat"] = "与普通耗子不同，这只耗子背上长着晶化皮毛，它因此获得了额外的保护。"

npcNameCHN["giant grey mouse"] = "巨大灰鼠"
npcDescCHN["giant grey mouse"] = "巨大灰鼠"

npcNameCHN["giant grey rat"] = "巨大灰耗子"
npcDescCHN["giant grey rat"] = "巨大灰耗子"

--沙虫(sandworm)
npcNameCHN["sandworm"] = "沙虫"
npcDescCHN["sandworm"] = "一只伪装成沙子颜色的巨大沙虫。它很不高兴你闯入它的地盘。"

npcNameCHN["sandworm destroyer"] = "沙虫毁灭者"
npcDescCHN["sandworm destroyer"] = "一只伪装成沙子颜色的巨大沙虫。这只特殊的沙虫生来只有一个目标：消灭所有非沙虫的异类，比如……你。"

npcNameCHN["sand-drake"] = "沙蜉蝣"
npcDescCHN["sand-drake"] = "这只邪恶的生物从体型上看更像一只短翼龙，并且和沙虫一样伪装自己。"

npcNameCHN["gigantic sandworm tunneler"] = "巨大沙虫挖掘者"
npcDescCHN["gigantic sandworm tunneler"] = "这只巨大的沙虫挖地道靠近你时，大地在震颤。它的巨口似乎能吞下和石头一样硬的猎物。"

npcNameCHN["gigantic gravity worm"] = "巨大重力沙虫"
npcDescCHN["gigantic gravity worm"] = "这只沙虫似乎扭曲了周围的时空。"

npcNameCHN["gigantic corrosive tunneler"] = "巨大腐蚀挖掘者"
npcDescCHN["gigantic corrosive tunneler"] = "这只巨大的沙虫使用它腐蚀性的唾液挖掘泥土。"

--暗影(shade)
npcNameCHN["shade"] = "暗影"
npcDescCHN["shade"] = "通过某种神秘的可怕手段，这只生物的影子被剥离出来并被赋予了生命。"

--骷髅(skeleton)
npcNameCHN["degenerated skeleton warrior"] = "腐化骷髅战士"
npcDescCHN["degenerated skeleton warrior"] = "这具仿佛是死灵法师随意收集而成的，摇摇欲坠的骨骸，生涩地从你的眼前走过，仿佛孩童手中玩弄的木偶。虽然它只有一条手臂，不过反正这对于拿一把剑也够了，对吧。"

npcNameCHN["degenerated skeleton archer"] = "腐化骷髅弓箭手"
npcDescCHN["degenerated skeleton archer"] = "这具破烂不堪的骨架只有一根骨头是好的：它手持长弓的手臂。尽管它缺少了一只手，不过残缺的骨骼上雕刻的凹槽刚好可以卡住弓弦拉弓上箭。"

npcNameCHN["skeleton mage"] = "骷髅法师"
npcDescCHN["skeleton mage"] = "看着它残破的样子，你与其相信这只骷髅会释放魔法，不如相信是在它身躯逐渐破碎的同时将奥术能量胡乱喷射出来。不过，这一点也没有降低它的危险性，小心。"

npcNameCHN["skeleton warrior"] = "骷髅战士"
npcDescCHN["skeleton warrior"] = "施展在这只骷髅身上的魔法已经足够灵活，足以让它像还活着的时候那样严阵以待，挥动武器。它仍然穿着它原来的那件老盔甲，锈迹斑斑却值得信赖。"

npcNameCHN["skeleton archer"] = "骷髅弓箭手"
npcDescCHN["skeleton archer"] = "在被复活之前，这位弓箭手的遗体上居然还保留着一张还不错的弓。你开始觉得，世界上如果有更多的盗墓贼就好了。"

npcNameCHN["skeleton magus"] = "骷髅魔导师"
npcDescCHN["skeleton magus"] = "这只骷髅的身上充盈着更加丰沛的魔法力量，作为它的主人强大魔力的明证。"

npcNameCHN["armoured skeleton warrior"] = "武装骷髅战士"
npcDescCHN["armoured skeleton warrior"] = "这只骷髅战士没有任何痛感，它的动作行云流水，强大的挥斩足以将常人的肌肉撕裂。它一定是来自一具新鲜的尸体：它的骨头、装甲和武器还是崭新的。并且，他仿佛怒不可遏。"

npcNameCHN["skeleton master archer"] = "骷髅弓箭手大师"
npcDescCHN["skeleton master archer"] = "这只骷髅可以飞速的拈弓射箭，奥术的力量使它的身躯达到了常人无法企及的精确度——它的射击永远不会颤动，也永远不会疲累。"

npcNameCHN["skeleton assassin"] = "骷髅刺客"
npcDescCHN["skeleton assassin"] = "普通骷髅骨节之间的吱嘎猛响会早早暴露他们的行踪，但这只骷髅的身躯被烧焦成暗夜的黑色，关节间的软骨缓冲着骨节的转动。当你看到它时，它银光闪耀的刀刃已经出现在你的眼前。"

--蛇(snake)
npcNameCHN["large brown snake"] = "巨型棕蛇"
npcDescCHN["large brown snake"] = "这只蛇向你发出嘶嘶声，你的闯入使它很生气。"

npcNameCHN["large white snake"] = "巨型白蛇"
npcDescCHN["large white snake"] = "这只蛇向你发出嘶嘶声，你的闯入使它很生气。"

npcNameCHN["copperhead snake"] = "铜头蛇"
npcDescCHN["copperhead snake"] = "它有坚硬的脑袋和锋利的毒牙。"

npcNameCHN["rattlesnake"] = "响尾蛇"
npcDescCHN["rattlesnake"] = "你一靠近，这只蛇便盘旋竖起并用尾巴发出警告的声音。"

npcNameCHN["king cobra"] = "眼镜王蛇"
npcDescCHN["king cobra"] = "这是一条有冠状头部的巨蛇。"

npcNameCHN["black mamba"] = "黑曼巴"
npcDescCHN["black mamba"] = "它有着光滑的黑色皮肤，节状的身体和锋利的毒牙。"

npcNameCHN["anaconda"] = "巨蟒"
npcDescCHN["anaconda"] = "当你看到这只10米长的庞然巨物时，本能的后退了一步。它在寻找突袭你的机会。"

--雪巨人(snow-giant)
npcNameCHN["snow giant"] = "雪巨人"
npcDescCHN["snow giant"] = "一只酷似人类却很高大的生物。它手握一个巨锤，看起来不是很友好。"

npcNameCHN["snow giant thunderer"] = "闪电雪巨人"
npcDescCHN["snow giant thunderer"] = "一只酷似人类却很高大的生物。它手握一个巨锤，看起来不是很友好。闪电在它周身流动。"

npcNameCHN["snow giant boulder thrower"] = "雪巨人投石者"
npcDescCHN["snow giant boulder thrower"] = "一只酷似人类却很高大的生物。它手握一个巨锤，看起来不是很友好。"

npcNameCHN["snow giant chieftain"] = "雪巨人酋长"
npcDescCHN["snow giant chieftain"] = "一只酷似人类却很高大的生物。它手握一个巨锤，看起来不是很友好。"

npcNameCHN["Burb the snow giant champion"] = "雪巨人勇士巴布"
npcDescCHN["Burb the snow giant champion"] = "一个被激怒的、远远高于其他雪巨人的勇士。你以前听说过关于这个雪巨人的故事：据说，平时他不像现在这样愤怒的口沫横飞时，他会坐下来，像个孩子一样，在他能找到的任何一块平整的石头表面雕刻难以理解的图案。"

--蜘蛛(spider)
npcNameCHN["giant spider"] = "巨型蜘蛛"
npcDescCHN["giant spider"] = "一只巨大的蛛形纲动物，它可以织出更大的网。"

npcNameCHN["spitting spider"] = "吐毒蜘蛛"
npcDescCHN["spitting spider"] = "一只巨大的蛛形纲动物，它向猎物喷射毒液。"

npcNameCHN["chitinous spider"] = "硬壳蜘蛛"
npcDescCHN["chitinous spider"] = "一只巨大的蛛形纲动物，它有着厚重的外壳。"

npcNameCHN["gaeramarth"] = "盖瑞麦斯"
npcDescCHN["gaeramarth"] = "这些狡猾的蜘蛛威胁着进入它们地盘的生物。没有人能从它们这生还。"

npcNameCHN["ninurlhing"] = "林尔荷"
npcDescCHN["ninurlhing"] = "在它周围，毒雾散播，大地枯萎。"

npcNameCHN["faerlhing"] = "费尔荷"
npcDescCHN["faerlhing"] = "这只蜘蛛善于控制法力流动，它可以使法力在它体内有节奏的跳跃。"

npcNameCHN["ungolmor"] = "阿格尔莫"
npcDescCHN["ungolmor"] = "它是体型最大的蜘蛛，它褶皱的皮肤看起来牢不可破。"

npcNameCHN["losselhing"] = "卢瑟尔荷"
npcDescCHN["losselhing"] = "这只寒冷的蜘蛛似乎使周围的空气都凝固了。"

npcNameCHN["weaver young"] = "编织者幼体"
npcDescCHN["weaver young"] = "一只小小的蜘蛛，它在不断的出入相位现实。"
npcNameCHN["weaver hatchling"] = "编织者幼体"
npcDescCHN["weaver hatchling"] = "一只小小的蜘蛛，它在不断的出入相位现实。"
npcNameCHN["weaver patriarch"] = "雄性编织者"
npcDescCHN["weaver patriarch"] = "一只胸部有着白色花纹的巨大蓝蜘蛛。它不断的移动和闪烁，好像它只有部分连接在时间线上。"

npcNameCHN["weaver matriarch"] = "雌性编织者"
npcDescCHN["weaver matriarch"] = "一只胸部有着白色花纹的巨大黄蜘蛛。它不断的移动和闪烁，好像它只有部分连接在时间线上。"

npcNameCHN["Ninandra, the Great Weaver"] = "妮娜卓·伟大的编织者"
npcDescCHN["Ninandra, the Great Weaver"] = "一只不断移动和闪烁于相位现实间的巨大蜘蛛，身上有着蓝黄相间的花纹。她可以编制命运之网并将猎物的命运捆绑在网上。"

npcNameCHN["orb spinner"] = "球蛛纺织者"
npcDescCHN["orb spinner"] = "一只巨大的褐色蜘蛛，它的尖牙不断的滴落奇怪的液体。"

npcNameCHN["orb weaver"] = "球蛛编织者"
npcDescCHN["orb weaver"] = "一只正在结网的巨大褐色蜘蛛，你的打扰使它很不高兴。"

npcNameCHN["fate spinner"] = "命运纺织者"
npcDescCHN["fate spinner"] = "像一只马一样大的蜘蛛，它的尖牙利齿已经饥渴难耐了。"

npcNameCHN["fate weaver"] = "命运编织者"
npcDescCHN["fate weaver"] = "一只巨大的白色蜘蛛。"

npcNameCHN["Weaver Queen"] = "织网蛛后"
npcDescCHN["Weaver Queen"] = "一只巨大的白色蜘蛛。"

--风暴龙(storm-drake)
npcNameCHN["storm drake hatchling"] = "风暴幼龙"
npcDescCHN["storm drake hatchling"] = "一只幼龙。单只幼龙也许不是很强大，但是它们经常一起行动。"

npcNameCHN["storm drake"] = "风暴翼龙"
npcDescCHN["storm drake"] = "一只成年巨龙，拥有致命的吐息和锋利的爪子。"

npcNameCHN["storm wyrm"] = "风暴巨龙"
npcDescCHN["storm wyrm"] = "一只年长且强大的风暴巨龙，拥有致命的吐息和锋利的爪子。"

--太阳之墙(sunwall-town)
npcNameCHN["human guard"] = "人类守卫"
npcDescCHN["human guard"] = "一个严肃的守卫，他禁止你进入城镇。"

npcNameCHN["elven archer"] = "精灵弓箭手"
npcDescCHN["elven archer"] = "一个严肃的守卫，他禁止你进入城镇。"

npcNameCHN["human sun-paladin"] = "人类太阳骑士"
npcDescCHN["human sun-paladin"] = "一位穿着闪耀板甲的人类。"

npcNameCHN["elven sun-mage"] = "精灵太阳法师"
npcDescCHN["elven sun-mage"] = "一位穿着鲜艳长袍的精灵。"

--虫群(swarm)
npcNameCHN["midge swarm"] = "蚊群"
npcDescCHN["midge swarm"] = "一群蚊子，它们渴望鲜血。"

npcNameCHN["bee swarm"] = "蜜蜂群"
npcDescCHN["bee swarm"] = "它们向你发出嗡嗡的警告声，因为你离它们的巢穴太近了。"

npcNameCHN["hornet swarm"] = "黄蜂群"
npcDescCHN["hornet swarm"] = "你已经闯入了它们的地盘，它们会不择手段的攻击你。"

npcNameCHN["hummerhorn"] = "大黄蜂"
npcDescCHN["hummerhorn"] = "一只巨大的黄蜂，它的尾刺滴着毒液。"

--时空兽(telugoroth)
npcNameCHN["telugoroth"] = "泰鲁戈洛斯"
npcDescCHN["telugoroth"] = "一只时间元素，很少被世人所知。它模糊的形态不断在你眼前闪过。"

npcNameCHN["greater telugoroth"] = "强化泰鲁戈洛斯"
npcDescCHN["greater telugoroth"] = "一只更大的时间元素，很少被世人所知。它模糊的形态不断在你眼前闪过。"

npcNameCHN["ultimate telugoroth"] = "究极泰鲁戈洛斯"
npcDescCHN["ultimate telugoroth"] = "一只巨大的时间元素，很少被世人所知。它模糊的形态不断在你眼前闪过。"

npcNameCHN["teluvorta"] = "泰鲁沃塔"
npcDescCHN["teluvorta"] = "时空在这只漂泊的时间元素周围不断塌陷。"

npcNameCHN["greater teluvorta"] = "强化泰鲁沃塔"
npcDescCHN["greater teluvorta"] = "时空在这只漂泊的时间元素周围不断塌陷。"

npcNameCHN["ultimate teluvorta"] = "究极泰鲁沃塔"
npcDescCHN["ultimate teluvorta"] = "时空在这只漂泊的时间元素周围不断塌陷。"

--小偷(thieve)
npcNameCHN["cutpurse"] = "扒手"
npcDescCHN["cutpurse"] = "盗贼中最低等的人群，他们仅仅会一点欺诈的小技巧。"

npcNameCHN["rogue"] = "盗贼"
npcDescCHN["rogue"] = "比扒手略强，这个盗贼被训练过。"

npcNameCHN["thief"] = "小偷"
npcDescCHN["thief"] = "他盯着你和你的背包，然后突然消失不见……好奇怪，你的背包似乎轻了许多？"

npcNameCHN["bandit"] = "强盗"
npcDescCHN["bandit"] = "这些恶棍通常在行窃过程中施以暴行，同时他们也很擅长隐匿。"

npcNameCHN["bandit lord"] = "强盗首领"
npcDescCHN["bandit lord"] = "他是这伙强盗的首领，当心他的手下。"

npcNameCHN["assassin"] = "刺客"
npcDescCHN["assassin"] = "只见眼前闪过一道……金属光芒……你死了。"

npcNameCHN["shadowblade"] = "影武者"
npcDescCHN["shadowblade"] = "隐形的斗士，他们一直在追求欺诈的巅峰技巧。小心，他们会随时偷走你的生命！"

--巨魔(troll)
npcNameCHN["forest troll"] = "森林巨魔"
npcDescCHN["forest troll"] = "丑陋的绿皮生物正盯着你，同时它握紧了满是肉瘤的绿色拳头。"

npcNameCHN["stone troll"] = "岩石巨魔"
npcDescCHN["stone troll"] = "有着粗糙黑色皮肤的巨魔，一阵战栗后，你惊讶的发现他的腰带是用矮人头骨制成。"

npcNameCHN["cave troll"] = "洞穴巨魔"
npcDescCHN["cave troll"] = "这只巨魔手握一根笨重的长矛，同时在它那贪婪的眼睛里，你看出了一丝令人不安的信息。"

npcNameCHN["mountain troll"] = "山岭巨魔"
npcDescCHN["mountain troll"] = "一只高大且强壮的巨魔，身披一张丑陋但异常坚硬的兽皮。"

npcNameCHN["mountain troll thunderer"] = "闪电山岭巨魔"
npcDescCHN["mountain troll thunderer"] = "一只高大且强壮的巨魔，身披一张丑陋但异常坚硬的兽皮。"

npcNameCHN["patchwork troll"] = "憎恶巨魔"
npcDescCHN["patchwork troll"] = "一只由死灵法术拼接而成的挥舞着武器的恶心巨魔。它用不可思议的力量摧毁周围的一切，令人困惑的是，它的移动速度也世所罕见。"

npcNameCHN["Forest Troll Hedge-Wizard"] = "海哲·维萨德"
npcDescCHN["Forest Troll Hedge-Wizard"] = "这只老迈的巨魔恶狠狠的盯着你。尽管它已经年老力衰，但是你仍能感受到一股强大的能量环绕着它。"

--不死鼠(undead-rat)
npcNameCHN["skeletal rat"] = "骷髅鼠"
npcDescCHN["skeletal rat"] = "一只被邪恶能量支配的巨大老鼠骨骼。在它们追赶你之前，没人知道亡灵啮齿动物的可怕。"

npcNameCHN["ghoulish rat"] = "僵尸鼠"
npcDescCHN["ghoulish rat"] = "斑驳的皮肤从这只老鼠身上脱落，它的一只眼窝空洞的看着你。"

npcNameCHN["spectral rat"] = "幽灵鼠"
npcDescCHN["spectral rat"] = "怪异的烟雾环绕着这只透明的老鼠。"

npcNameCHN["vampire rat"] = "吸血鼠"
npcDescCHN["vampire rat"] = "不谈那大了一号的牙齿，它看起来还算比较正常的一只老鼠。"

npcNameCHN["gigantic bone rat"] = "巨型骨鼠"
npcDescCHN["gigantic bone rat"] = "这只巨大的怪物看起来像是许多骨头拼起来的老鼠。"

npcNameCHN["Rat Lich"] = "鼠巫妖"
npcDescCHN["Rat Lich"] = {}
npcDescCHN["Rat Lich"]["The master of the pit is before you. It squeaks with menace as it and a horde of minions approach you."] = "这只军团的主人站在你面前。它吱吱叫着并指挥一大群怪物接近你。"
npcDescCHN["Rat Lich"]["The master of the pit is before you. It squeaks with menace as it and a horde of minions approach you.\nThe Rat Lich's true power has been unveiled! Swirling with arcane energy, it stalks towards you uttering warsqueaks at its minions!"] = "这只军团的主人站在你面前。它吱吱叫着并指挥一大群怪物接近你。\n鼠巫妖的真正力量展现出来了！它的身躯环绕着奥术能量，昂首阔步地带领着它的仆从包围着你，发出吱吱的战吼！"

--吸血鬼(vampire)
npcNameCHN["lesser vampire"] = "小吸血鬼"
npcDescCHN["lesser vampire"] = "这只吸血鬼刚开始它的新生活，还不能熟练运用它的新能力，但是它同样渴望鲜血。"

npcNameCHN["vampire"] = "吸血鬼"
npcDescCHN["vampire"] = "这是一只成年吸血鬼，你注意到他有一副獠牙。"

npcNameCHN["master vampire"] = "吸血鬼大师"
npcDescCHN["master vampire"] = "这是一只穿着长袍的人形吸血鬼，魔法波动不断的从他手中的冰焰溢出。"

npcNameCHN["elder vampire"] = "吸血鬼长老"
npcDescCHN["elder vampire"] = "这只吸血鬼一副可怕的披长袍的不死族形象，它在漫长的岁月中偷取了许多他人的生命。它可以奴役牺牲者们的影子来协助它"

npcNameCHN["vampire lord"] = "吸血鬼族长"
npcDescCHN["vampire lord"] = "当这只可怕的生物靠近时，你感到脊背一阵发凉。"

--蠕虫(vermin)
npcNameCHN["white worm mass"] = "白色蠕虫团"
npcDescCHN["white worm mass"] = ""

npcNameCHN["green worm mass"] = "绿色蠕虫团"
npcDescCHN["green worm mass"] = ""

npcNameCHN["carrion worm mass"] = "腐烂蠕虫团"
npcDescCHN["carrion worm mass"] = ""

--毒龙(venom drake)
npcNameCHN["venom drake hatchling"] = "毒龙幼仔"
npcDescCHN["venom drake hatchling"] = "一只毒龙幼仔。它本身并不强大，但是它们经常集体行动。"

npcNameCHN["venom drake"] = "毒龙"
npcDescCHN["venom drake"] = "一只成年毒龙，拥有致命的吐息和锋利的爪子。"

npcNameCHN["venom wyrm"] = "猛毒巨龙"
npcDescCHN["venom wyrm"] = "一只年长且强大的毒龙，拥有致命的吐息和锋利的爪子。"

--尸妖(wight)
npcNameCHN["forest wight"] = "森林尸妖"
npcDescCHN["forest wight"] = "它有着人类的脸孔，幽灵般的影子。"

npcNameCHN["grave wight"] = "墓穴尸妖"
npcDescCHN["grave wight"] = "它呈幽灵形态，眼睛一直盯着你。"

npcNameCHN["barrow wight"] = "古墓尸妖"
npcDescCHN["barrow wight"] = "它是幽灵般的梦靥。"

npcNameCHN["emperor wight"] = "帝王尸妖"
npcDescCHN["emperor wight"] = "当这只强大的不死生物靠近时，你感觉生命能量被不断地撕扯出身体。"

--巨龙(wild-drak)
npcNameCHN["spire dragon"] = "螺旋巨龙"
npcDescCHN["spire dragon"] = "一只奇特的、盘绕的巨龙，它可憎却沉稳。它的表皮上布满了倒刺和利刃，可以轻松抵挡金属武器攻击和魔法能量。"

npcNameCHN["blinkwyrm"] = "相位巨龙"
npcDescCHN["blinkwyrm"] = "一只不断闪烁和换位的蛇状巨龙，它只是在等你回头。"

--索尔石怪(xorn)
npcNameCHN["umber hulk"] = "褐色巨兽"
npcDescCHN["umber hulk"] = "这只巨大的生物有着铜铃般的眼睛和一个能够咬断岩石的上颚。"

npcNameCHN["xorn"] = "索尔石怪"
npcDescCHN["xorn"] = "一只巨大的土元素。它有四只巨大的手臂，并且可以融合泥土。"

npcNameCHN["xaren"] = "钻石索尔石怪"
npcDescCHN["xaren"] = "这是一个相对较硬的索尔石怪。它用石质护甲把闪光的内在掩盖起来。"

npcNameCHN["The Fragmented Essence of Harkor'Zun"] = "哈卡祖的精华碎片"
npcDescCHN["The Fragmented Essence of Harkor'Zun"] = "精华碎片……如果它仍然呈碎裂状态就好了。"

npcNameCHN["Harkor'Zun"] = "哈卡祖"
npcDescCHN["Harkor'Zun"] = "一个由土元素构成的巨大恶魔，它长的像一只被放大且扭曲过的钻石土元素。似乎你的到来使它很不高兴。"

--夺魂魔(yaech)
npcNameCHN["yaech diver"] = "夺魂魔扒手"
npcDescCHN["yaech diver"] = "夺魂魔是夺心魔的一支亚种。他们拥有同样的超能力，但夺魂魔拒绝加入维网。"

npcNameCHN["yaech hunter"] = "夺魂魔猎手"
npcDescCHN["yaech hunter"] = "夺魂魔是夺心魔的一支亚种。他们拥有同样的超能力，但夺魂魔拒绝加入维网。"

npcNameCHN["yaech mindslayer"] = "夺魂魔心灵杀手"
npcDescCHN["yaech mindslayer"] = "夺魂魔是夺心魔的一支亚种。他们拥有同样的超能力，但夺魂魔拒绝加入维网。"

npcNameCHN["yaech psion"] = "夺魂魔超能力者"
npcDescCHN["yaech psion"] = "夺魂魔是夺心魔的一支亚种。他们拥有一样的超能力，但夺魂魔拒绝加入维网。"

--伊格兰斯(ziguranth)
npcNameCHN["ziguranth warrior"] = "伊格兰斯战士"
npcDescCHN["ziguranth warrior"] = "一位身穿重甲的伊格兰斯战士。"

npcNameCHN["ziguranth summoner"] = "伊格兰斯召唤师"
npcDescCHN["ziguranth summoner"] = "一位能沟通自然的伊格兰斯自然法师。"

npcNameCHN["ziguranth wyrmic"] = "伊格兰斯龙战士"
npcDescCHN["ziguranth wyrmic"] = "一位能沟通自然的伊格兰斯自然战士。"

--zones
--abashed-expanse
npcNameCHN["Spacial Disturbance"] = "虚空虫洞"
npcDescCHN["Spacial Disturbance"] = "一个由虚空构成的虫洞，它似乎是空间不稳的原因。"

--ancient-elven-ruins
npcNameCHN["Greater Mummy Lord"] = "巨型木乃伊领主"
npcDescCHN["Greater Mummy Lord"] = "这只木乃伊身上所缠绕的裹尸布散发着巨大的能量，似乎它的能量改变了空气的流动。"

npcNameCHN["ancient elven mummy"] = "远古精灵木乃伊"
npcDescCHN["ancient elven mummy"] = "一具缠绕着裹尸布的鲜活尸体。"

npcNameCHN["animated mummy wrappings"] = "蠕动的裹尸布"
npcDescCHN["animated mummy wrappings"] = "一条蠕动的木乃伊裹尸布，里面没有尸体……它看起来无法移动。"

npcNameCHN["rotting mummy"] = "腐烂木乃伊"
npcDescCHN["rotting mummy"] = "缠绕着裹尸布的腐烂尸体。"

--ardhungol
npcNameCHN["Ungolë"] = "温格勒"
npcDescCHN["Ungolë"] = "一只被黑暗围绕的巨大蜘蛛，她用血红的眼睛盯着你。她看起来很饥渴。"

--arena
npcNameCHN["flying skull"] = "虚空头骨"
npcDescCHN["flying skull"] = "一颗缠绕着黑暗能量，漂浮在空中的头骨。"

npcNameCHN["skeletal rat"] = "亡灵鼠"
npcDescCHN["skeletal rat"] = "一只充满了邪恶能量的老鼠骨架。没有人知道啮齿类生物的骨架会有何用处，这需要你亲身体会。"

npcNameCHN["homeless fighter"] = "无家可归的斗士"
npcDescCHN["homeless fighter"] = "为一餐温饱而战！"

npcNameCHN["golden crystal"] = "金色水晶体"
npcDescCHN["golden crystal"] = "一块金色的水晶体。它向外辐射出像太阳一样的光芒。"

npcNameCHN["master alchemist"] = "炼金魔导师"
npcDescCHN["master alchemist"] = "使用宝石进行攻击的致命斗士。"

npcNameCHN["multihued wyrmic"] = "七彩龙战士"
npcDescCHN["multihued wyrmic"] = "一位精通数种元素的强大龙战士。"

npcNameCHN["master slinger"] = "投石索大师"
npcDescCHN["master slinger"] = "受竞技场雇佣的投石索大师。他们非常专业。"

npcNameCHN["gladiator"] = "角斗者"
npcDescCHN["gladiator"] = "只为娱乐竞技场而请的雇佣兵。他们靠娱乐群众生存。"

npcNameCHN["reaver"] = "收割者"
npcDescCHN["reaver"] = "致命的战士。"

npcNameCHN["headless horror"] = "无头恐魔"
npcDescCHN["headless horror"] = "一只高高瘦瘦的无头人形怪物，它有着巨大的胃。它被竞技场的第一任主人捕获并生存至今。"

npcNameCHN["Ryal"] = "瑞尔"
npcDescCHN["Ryal"] = "一只巨大的骨头巨兽，它的前身似乎是一只地行龙。它有着敏锐的意识和惊人的速度。"

npcNameCHN["Fryjia Loren"] = "弗里嘉·劳伦"
npcDescCHN["Fryjia Loren"] = "一位有着雪白肌肤的年轻女孩。虽然她很小，但却擅长战斗，她可以在战斗中射出密集的冰箭。"

npcNameCHN["Riala Shalarak"] = "里娅拉·夏洛克"
npcDescCHN["Riala Shalarak"] = "一位强大的女法师。多年的经验使她成为非常致命的决斗者。"

npcNameCHN["Valfren Loren"] = "瓦弗伦·劳尔"
npcDescCHN["Valfren Loren"] = "身穿重甲手持巨斧的被诅咒之人。他被诅咒战斗不止。"

npcNameCHN["Rej Arkatis"] = "瑞吉·阿卡提斯"
npcDescCHN["Rej Arkatis"] = "一位有着优秀战技的普通人类斗士。他来历不明却成为了战斗大师。"

npcNameCHN["slinger"] = "投石者"
npcDescCHN["slinger"] = "前来竞技场寻求财富和荣誉的远程斗士，就像你我一样。"

npcNameCHN["high slinger"] = "高阶投石者"
npcDescCHN["high slinger"] = "前来竞技场寻求财富和荣誉的远程斗士，就像你我一样。"

npcNameCHN["alchemist"] = "炼金术师"
npcDescCHN["alchemist"] = "使用宝石进行攻击的致命斗士。"

npcNameCHN["blood mage"] = "血法师"
npcDescCHN["blood mage"] = "一位穿着黑色长袍的人。当你听到他们的低吟时，你感到一阵虚弱。"

npcNameCHN["hexer"] = "诅咒者"
npcDescCHN["hexer"] = "一位穿着黑色长袍的人。你感到身上中了许多诅咒。"

npcNameCHN["rogue"] = "盗贼"
npcDescCHN["rogue"] = "善用诡计的潜行斗士。当心你的背后！"

npcNameCHN["trickster"] = "欺诈者"
npcDescCHN["trickster"] = "善用诡计的潜行远程斗士。小心他们射穿你的心脏！"

npcNameCHN["shadowblade"] = "影武者"
npcDescCHN["shadowblade"] = "善用诡计的潜行斗士。当心他们带走你的生命！"

npcNameCHN["fire wyrmic"] = "炎龙战士"
npcDescCHN["fire wyrmic"] = "一位立志赢得比赛的炎龙战士。他常和一位冰龙战士一起。"

npcNameCHN["ice wyrmic"] = "冰龙战士"
npcDescCHN["ice wyrmic"] = "一位立志赢得比赛的冰龙战士。他常和一位炎龙战士一起。"

npcNameCHN["sand wyrmic"] = "沙龙战士"
npcDescCHN["sand wyrmic"] = "一位立志赢得比赛的沙龙战士。他常和一位风龙战士一起。"

npcNameCHN["storm wyrmic"] = "风龙战士"
npcDescCHN["storm wyrmic"] = "一位立志赢得比赛的风龙战士。他常和一位沙龙战士一起。"

npcNameCHN["high gladiator"] = "高阶角斗者"
npcDescCHN["high gladiator"] = "只为娱乐竞技场而请的雇佣兵。他们靠娱乐群众生存。"

npcNameCHN["great gladiator"] = "宗师角斗者"
npcDescCHN["great gladiator"] = "只为娱乐竞技场而请的雇佣兵。他们靠娱乐群众生存。"

npcNameCHN["martyr"] = "殉教者"
npcDescCHN["martyr"] = "一位虔诚的战士。"

npcNameCHN["anorithil"] = "星月术士"
npcDescCHN["anorithil"] = "来自远方的战士。他们使用光暗魔法攻击你。"

npcNameCHN["sun paladin"] = "太阳骑士"
npcDescCHN["sun paladin"] = "来自远方的战士。他们擅长光魔法和华丽的剑技。"

npcNameCHN["star crusader"] = "星辰骑士"
npcDescCHN["star crusader"] = "来自远方的战士。他们擅长光魔法和华丽的剑技，同样也精通暗魔法。"

--arena-unlock
npcNameCHN["gladiator"] = "角斗者"
npcDescCHN["gladiator"] = "只为娱乐竞技场而请的雇佣兵。他们靠娱乐群众生存。"

npcNameCHN["halfling slinger"] = "半身人投石者"
npcDescCHN["halfling slinger"] = "一位半身人投石者，他似乎很擅长角斗。"

npcNameCHN["arcane blade"] = "奥术之刃"
npcDescCHN["arcane blade"] = "一位人类奥术之刃。他的周身在战斗中不断的变换颜色。"

--blighted-ruins
npcNameCHN["Necromancer"] = "死灵法师"
npcDescCHN["Necromancer"] = "一位穿着黑色长袍的人类。他发出刺耳的声音，看起来他想把你变为他的奴隶。"

npcNameCHN["Half-Finished Bone Giant"] = "未完成的骨巨人"
npcDescCHN["Half-Finished Bone Giant"] = [[一只铁塔一样的怪物，由上百只尸体的骨头组成。它周身环绕着不洁的光环。
这只看起来体型较小，似乎尚未完成。]]

npcNameCHN["fleshy experiment"] = "血肉试验品"
npcDescCHN["fleshy experiment"] = "这团腐肉抽动着，发出可怕的噪音。"

npcNameCHN["boney experiment"] = "骨骸试验品"
npcDescCHN["boney experiment"] = "这团骨头试着想要自己移动起来，但是看来它好像没法把自己变成更加强大的形态。"

npcNameCHN["sanguine experiment"] = "鲜血试验品"
npcDescCHN["sanguine experiment"] = "它看起来就像一个巨大的血块。它的创造者到底想做啥？"

--briagh-lair
npcNameCHN["Briagh, Great Sand Wyrm"] = "精英沙龙战士布莱亚"
npcDescCHN["Briagh, Great Sand Wyrm"] = "一只铁塔般的沙龙战士站在你面前。这只陆行龙非常强大且可以轻易撕碎你。"

--charred-scar
npcNameCHN["human sun-paladin"] = "人类太阳骑士"
npcDescCHN["human sun-paladin"] = "穿着闪亮盔甲的人类。"

npcNameCHN["High Sun-Paladin Rodmour"] = "高阶太阳骑士罗德莫"
npcDescCHN["High Sun-Paladin Rodmour"] = "穿着闪亮盔甲的人类。"

npcNameCHN["orc warrior"] = "兽人战士"
npcDescCHN["orc warrior"] = "一位凶残的兽人战士。"

npcNameCHN["Elandar"] = "埃兰达"
npcDescCHN["Elandar"] = "叛逃安格利文的法师，恶魔法师建立于远东并缓慢成长。现在他们的末日来临了。"

npcNameCHN["Argoniel"] = "艾格尼尔"
npcDescCHN["Argoniel"] = "叛逃安格利文的法师，恶魔法师建立于远东并缓慢成长。现在他们的末日来临了。"

npcNameCHN["Fyrk, Faeros High Guard"] = "炎魔守卫弗莱克"
npcDescCHN["Fyrk, Faeros High Guard"] = [[炎魔是高智慧的火焰元素，在火山以外的其他地方很少看到。它们很可能不属于这个世界。
这只看起来更加凶残，它用蔑视的眼神看着你。火焰在它的身上流转。]]

--conclave-vault
npcNameCHN["degenerated ogric mass"] = "腐化的食人魔碎肉"
npcDescCHN["degenerated ogric mass"] = "这团变形的腐肉看上去曾经是某个食人魔身体器官的一部分，不过——好像出了点什么问题"

npcNameCHN["ogric abomination"] = "憎恶食人魔"
npcDescCHN["ogric abomination"] = "这个食人魔似乎试图把傀儡的身躯嫁接在自己的身体上。各种意义上有趣的结果。"

npcNameCHN["ogre sentry"] = "食人魔哨兵"
npcDescCHN["ogre sentry"] = "这个挥舞着巨剑的食人魔用带着鄙视和仇恨的眼神凝视着你。"

npcNameCHN["Healer Astelrid"] = "孔克雷夫医师亚斯特莉"
npcDescCHN["Healer Astelrid"] = "一个巨大的食人魔，身上穿着的破烂长袍上是一枚亮闪闪的官员徽章。她用手抓住一把治疗用的法杖，被石膏浇铸并裹挟着手术刀，用作一个巨大的狼牙棒。"

npcNameCHN["old vats"] = "古老的培养槽"
npcDescCHN["old vats"] = ""

--crypt-kryl-feijan
npcNameCHN["Kryl-Feijan"] = "卡洛·斐济"
npcDescCHN["Kryl-Feijan"] = "这只巨大的恶魔被黑暗所包围。它的“母亲”的碎肉仍悬挂在它的利爪上。"

npcNameCHN["Melinda"] = "米琳达"
npcDescCHN["Melinda"] = {}
npcDescCHN["Melinda"]["A female Human with twisted sigils scored into her naked flesh. Her wrists and ankles are sore and hurt by ropes and chains. You can discern great beauty beyond the stains of blood covering her skin."] = "一位赤裸并且全身刻有扭曲符文的女人。她的四肢被镣铐绑在了祭台上。尽管她的皮肤上满是鲜血，你仍然能发现她的美丽。"
npcDescCHN["Melinda"]["Enjoying a lovely day at the beach."] = "在海滩上享受生活。"
npcDescCHN["Melinda"]["You saved her from the depth of a cultists' lair and fell in love with her. She has moved into the Fortress to see you more often."] = "你将她从邪教徒手中拯救出来，同时你爱上了她。她搬到堡垒里了，这样能常常看到你。"

npcNameCHN["Acolyte of the Sect of Kryl-Feijan"] = "卡洛·斐济的邪教徒"
npcDescCHN["Acolyte of the Sect of Kryl-Feijan"] = "穿着黑色长袍的精灵，他们的眼中满是疯狂。"

--daikara
npcNameCHN["Rantha the Worm"] = "巨龙兰莎"
npcDescCHN["Rantha the Worm"] = "尖牙利齿，冰冷致命。似乎龙族并没有完全灭绝……"

npcNameCHN["Varsha the Writhing"] = "巨龙瓦莎"
npcDescCHN["Varsha the Writhing"] = "尖牙利齿，火焰致命。似乎龙族并没有灭绝……"

npcNameCHN["Massok the Dragonslayer"] = "弑龙者马萨克"
npcDescCHN["Massok the Dragonslayer"] = "手持巨剑、身披重甲的兽人。他的头盔由一只龙的头骨做成。"

--deep-bellow
npcNameCHN["The Mouth"] = "大嘴怪"
npcDescCHN["The Mouth"] = "“来自深渊，吞噬四方。”"

npcNameCHN["slimy crawler"] = "泥泞爬行怪"
npcDescCHN["slimy crawler"] = [[这只恶心的……东西在地板上迅速的向你爬来。
似乎它是由某个消化系统中的嘴部演化而来。]]

npcNameCHN["The Abomination"] = "憎恶"
npcDescCHN["The Abomination"] = "一只由无数碎肉、肌腱和骨头组成的恐怖混合体，它看起来痛苦万分。它的双头恶毒的看着你，因为你闯入了它的地盘。"

--demon-plane
npcNameCHN["Draebor, the Imp"] = "小恶魔德瑞宝"
npcDescCHN["Draebor, the Imp"] = "具有强烈刺激性气味的小怪兽。"

--dreadfell
npcNameCHN["The Master"] = "领主"
npcDescCHN["The Master"] ="一个拥有强大力量的可怕吸血鬼，他的长袍无风自动，周身环绕着恐惧光环。他冰冷而强壮的肉体似乎在向世界宣告着贪婪和怨恨，他的眼神透露着一股睥睨天下的自信。周围的不死族都完全服从于他，尽管如此，他还是表现出厌恶的神情，就好像他不需要这些废物来御敌一样。你的目光被他手里的黑色法杖所吸引，这根法杖似乎在不断的吸取周围的活力。它看起来古老而可怕，看到它的瞬间，你心底的欲望被彻底点燃了。"

npcNameCHN["Pale Drake"] = "亡灵德瑞克"
npcDescCHN["Pale Drake"] = "一位邪恶的骷髅法师，自从领主大人死后，他便继承了恐惧王座。"

npcNameCHN["Borfast the Broken"] = "扭曲的波法斯特"
npcDescCHN["Borfast the Broken"] = "在你面前的是一只步履蹒跚、肌肉松弛的——怪物。从他下巴中伸出的浓密胡须以及他的毛发来看，这是一位矮人。看起来他的半边脸曾经被硫酸泼过，血肉从他的脸部脱落，其中一只眼睛从它的眼窝中掉了出来。他的独眼有一种莫名的悲伤，透露着深深的无奈。如此威风的英雄人物怎会落得如此下场？"

npcNameCHN["Aletta Soultorn"] = "阿蕾塔·苏尔顿"
npcDescCHN["Aletta Soultorn"] = [[这只幽灵以前肯定是一位高等人类美人。她瘦弱而优雅的身躯在空中轻轻的摇晃，但是她的长袍却始终紧贴着身体。她的脸部除了疯狂便是万分的痛苦，她的眼睛在眼眶里不安的来回转动。
有时她会看到一些东西，她的下巴会突然收缩，分裂的脸部会发出一阵充满痛苦和折磨的哀嚎。]]

npcNameCHN["Filio Flightfond"] = "菲里奥·弗莱特冯德"
npcDescCHN["Filio Flightfond"] = [[一个矮小的猥琐骷髅，它的脚底有着一层肉垫。他迅捷而隐蔽，并且擅长融入黑暗。他的左手拿着投石索，右手则拿着一柄匕首。
他中空的头骨里有着一团灵活的空气，他空旷的眼孔中再也看不到任何的狡诈和诡计。]]

--dreadfell-ambush
npcNameCHN["Ukruk the Fierce"] = "凶残的乌克鲁克"
npcDescCHN["Ukruk the Fierce"] = "这只丑陋的兽人看起来邪恶而丑陋。显然他正在寻找某物，并且他在不断的用盾牌发出信号。"

--dreams
npcNameCHN["frail mouse"] = "脆弱的老鼠"

npcNameCHN["lost man"] = "迷路的男人"

npcNameCHN["yeek illusion"] = "夺心魔幻象"
npcDescCHN["yeek illusion"] = "纳尼？！"

npcNameCHN["lost wife"] = "迷路的妻子"
npcDescCHN["lost wife"] = "你的妻子变成了一只铁塔般的浮肿怪物。囊肿和粘糊糊的液体从每个毛孔向外溢出，不断的滴落在地板上。此情此景使你异常反胃。"

--eidolon-plane
npcNameCHN["The Eidolon"] = "艾德隆"
npcDescCHN["The Eidolon"] = "看起来更像是一团虚无的活生生的……光，这只生物对你很感兴趣。"

--eruan
npcNameCHN["Sun Paladin Guren"] = "太阳骑士古伦"
npcDescCHN["Sun Paladin Guren"] = "一位身披板甲的人类战士。他身上洋溢着光辉。"

--flooded-cave
npcNameCHN["Ukllmswwik the Wise"] = "智慧的厄库尔维斯克"
npcDescCHN["Ukllmswwik the Wise"] = "它看起来像是鲨鱼和龙的混合体，只是更加丑陋。"

--golem-graveyard
npcNameCHN["Atamathon the Giant Golem"] = "傀儡之王阿塔玛森"
npcDescCHN["Atamathon the Giant Golem"] = "这只巨大的傀儡是半身人在派尔纪对抗兽人时所造，但是被吞噬者加库尔摧毁。有些笨蛋试图重修它，但是控制核心已经丢失，现在它在疯狂的寻找它的制造者——某个死了无数年的家伙。它的躯体由花岗岩制成，它的关节由沃瑞钽制成，它的眼睛则是纯净的红宝石。它有着40英尺高，像铁塔般站在你面前，它闪亮的红宝石眼睛似乎散发着怒意。"

--gorbat-pride
npcNameCHN["Gorbat, Supreme Wyrmic of the Pride"] = "普莱德龙战士领主加伯特"
npcDescCHN["Gorbat, Supreme Wyrmic of the Pride"] = "一只皮肤上布有鳞片的兽人，他的背后有着锋利的爪子和一对翅膀。"

--grushnak-pride
npcNameCHN["Grushnak, Battlemaster of the Pride"] = "普莱德战争领主格鲁希纳克"
npcDescCHN["Grushnak, Battlemaster of the Pride"] = "一只浑身都是伤疤的年老兽人，他看起来异常的凶残和危险。"

--halfling-ruins
npcNameCHN["Subject Z"] = "代号“Z”"
npcDescCHN["Subject Z"] = "这个似乎是文献中提到的代号“Z”。它看起来和人类一样，但却不是人类，它至少有5000多岁了！"

npcNameCHN["Yeek Wayist"] = "夺心魔超能力者"
npcDescCHN["Yeek Wayist"] = "这只生物像半身人一样高。他浑身被有白色的毛发并有一颗不相称的大头。最不可思议的是，他的武器就那样悬浮在他面前。"

npcNameCHN["Director Hompalan"] = "研究主管 红帕兰"
npcDescCHN["Director Hompalan"] = "这个研究设施的主人，曾经如此高傲的研究主管红帕兰，现在已经只剩下摇摇欲坠的枯骨。尽管这具遗骸只剩下空洞无神的眼窝，你也能从中察觉到他凝视着你的神情。"

--heart-gloom
npcNameCHN["The Withering Thing"] = "凋零"
npcDescCHN["The Withering Thing"] = "这只畸形的巨兽之前或许是头狼，不过现在……它很可怕。"

npcNameCHN["The Dreaming One"] = "梦境之眼"
npcDescCHN["The Dreaming One"] = "这个奇怪的发光球体似乎是活的，而且正在熟睡。不过，尽管它还没有移动，你已经感受到它梦境的力量在冲击自己的精神。"

--high-peak
npcNameCHN["Elandar"] = "埃兰达"
npcDescCHN["Elandar"] = "叛逃安格利文的法师，恶魔法师建立于远东并缓慢成长。现在他们的末日来临了。"

npcNameCHN["Argoniel"] = "艾格尼尔"
npcDescCHN["Argoniel"] = "叛逃安格利文的法师，恶魔法师建立于远东并缓慢成长。现在他们的末日来临了。"

npcNameCHN["Fallen Sun Paladin Aeryn"] = "堕落太阳骑士艾琳"
npcDescCHN["Fallen Sun Paladin Aeryn"] = "一位身披板甲的美女。她的周身闪耀着光辉。"

npcNameCHN["High Sun Paladin Aeryn"] = "太阳骑士艾琳"
npcDescCHN["High Sun Paladin Aeryn"] = "一位身披板甲的美女。她的周身闪耀着光辉。"

--illusory-castle

--infinite-dungeon

--keepsake-meadow
npcNameCHN["caravan merchant"] = "商队商人"
npcDescCHN["caravan merchant"] = "一个商队里的商人"

npcNameCHN["caravan guard"] = "商队守卫"
npcDescCHN["caravan guard"] = "一个商队里的守卫"

npcNameCHN["caravan porter"] = "商队搬运工"
npcDescCHN["caravan porter"] = "一个商队里的搬运工"

npcNameCHN["war dog"] = "猎犬"
npcDescCHN["war dog"] = "这是一条老练的猎犬，被培育和训练用于战斗。"

npcNameCHN["corrupted war dog"] = "被诅咒的猎犬"
npcDescCHN["corrupted war dog"] = "这是一条老练的猎犬，被培育和训练用于战斗。不过，他运动起来的方式似乎有些不太正常。"

npcNameCHN["shadow claw"] = "阴影之爪"
npcDescCHN["shadow claw"] = {}
npcDescCHN["shadow claw"]["A shadow, almost humanoid in shape. Long claws extend in front of it as is swims through the air."] = "一个影子，看起来几乎是人类的形状。长长的触手在它面前延伸，如同在空气中游动。"
npcDescCHN["shadow claw"]["A shadow, almost humanoid in shape. At times its form seems to be a force of will rather than something real."] = "一个影子，看起来几乎是人类的形状。有时它的形态看上去不像是某种真实存在的物体，而是某种意志的力量。"

npcNameCHN["shadow stalker"] = "阴影潜行者"
npcDescCHN["shadow stalker"] = "一个影子，看起来几乎是人类的形状。它狡猾地闪现，出其不意地发动攻击。"

npcNameCHN["Companion Warrior"] = "同伴战士"
npcDescCHN["Companion Warrior"] = "这个精灵战士是贝里斯的同伴。他身穿皮甲，手拿长剑。"

npcNameCHN["Companion Archer"] = "同伴弓手"
npcDescCHN["Companion Archer"] = "这个精灵弓手是贝里斯的同伴。他身穿皮甲，手拿长弓。"

npcNameCHN["Kyless"] = "克里斯"
npcDescCHN["Kyless"] = "这是克里斯，你的老朋友。他比你的记忆中更加蓬头垢面，也更加危险。"

npcNameCHN["Berethh"] = "贝里斯"
npcDescCHN["Berethh"] = "这是贝里斯，你的老朋友，久经沙场的皮甲和长弓显示着他的实力。他平静的表情透露出大义凛然的气势。"

--last-hope-graveyard
npcNameCHN["Celia"] = "赛利亚"
npcDescCHN["Celia"] = "一位穿着肮脏长袍的高瘦女人。她灰色的皮肤上满是疮痕，但她的眼睛清澈明亮。她肚子上的反映出她至少有几个月的身孕了。"

--mark-spellblaze
npcNameCHN["Grand Corruptor"] = "堕落领主"
npcDescCHN["Grand Corruptor"] = "一位堕落精灵，他生活在这片荒芜大陆上。"

--maze
npcNameCHN["Minotaur of the Labyrinth"] = "魔宫的米诺陶斯"
npcDescCHN["Minotaur of the Labyrinth"] = "一只可怕的牛头怪，它挥舞着巨斧毁灭前方的一切。"

npcNameCHN["Horned Horror"] = "长角恐魔"
npcDescCHN["Horned Horror"] = "可怕的能量让这个牛头怪转变成更加恐怖的怪物，从它的背上伸出触手，正在四处伸展游走，时而缠绕在它的拳头上。"

npcNameCHN["Nimisil"] = "尼米希尔"
npcDescCHN["Nimisil"] = "覆盖着可怕的发光物和瘤状物，这只蜘蛛挡住了迷宫的空旷过道。"

--murgol-lair
npcNameCHN["Murgol, the Yaech Lord"] = "夺魂魔领主穆格尔"
npcDescCHN["Murgol, the Yaech Lord"] = "你可以在这只夺魂魔身上感受到庞大的超能力。"

npcNameCHN["Lady Nashva the Streambender"] = "激流盘旋者纳纱瓦女士"
npcDescCHN["Lady Nashva the Streambender"] = "水流缓慢的围绕着这位娜迦的尾巴旋转。她黑色的尾巴蜷缩起来，使她看起来较为矮小，但是她沉着而自信的脸庞使你感受到她无所畏惧。当水流在她周围蒸腾时，星空都仿佛失去了光芒，你感到她的眼神看穿了你的内心。"


--norgos-lair
npcNameCHN["Norgos, the Guardian"] = "守护者诺尔格斯"
npcDescCHN["Norgos, the Guardian"] = "这只远古巨熊一直守护着西边的丛林，但是不知何时他变的疯狂并到处攻击自然精灵们。"

npcNameCHN["Norgos, the Frozen"] = "冻结者诺尔格斯"
npcDescCHN["Norgos, the Frozen"] = "这只远古巨熊一直守护着西边的丛林，但是不知何时他变的疯狂并到处攻击自然精灵们。\n它似乎已经成为了进入这片领地的寒冰元素的牺牲品，死去并且冻结，就像一座雕塑，被元素能量所支配。"

--noxious-caldera
npcNameCHN["Mindworm"] = "心灵蠕虫"
npcDescCHN["Mindworm"] = "这只高大精灵的眼球落在了远处，你觉得它在窥视你。"

--old-forest
npcNameCHN["Wrathroot"] = "狂怒树精"
npcDescCHN["Wrathroot"] = "这颗远古的柳树统治着整个古老树林。他蔑视一切闯入者。"

npcNameCHN["Shardskin"] = "水晶树精"
npcDescCHN["Shardskin"] = "这个水晶一样的生物内部似乎充满了邪恶能量，透过水晶表面，你似乎还能看到里面曾是树的部分。"

npcNameCHN["cute little bunny"] = "可爱的小白兔"
npcDescCHN["cute little bunny"] = "它用无辜的眼神看着你，同时用剃刀般锋利的牙齿扑向你。"

npcNameCHN["Snaproot"] = "远古树精"
npcDescCHN["Snaproot"] = "这棵远古巨树的树皮几乎变成了黑色。它视人类为灾难，灾难必须消灭。"

--orc-breeding-pit
npcNameCHN["orc baby"] = "兽人宝宝"
npcDescCHN["orc baby"] = "虽然只能用四肢在地上爬行，这只绿皮生物和可爱却丝毫没有关联。它有着锋利的牙齿和指甲，并且它的皮肤上沾了一层粘糊糊的液体。"

npcNameCHN["orc child"] = "兽人儿童"
npcDescCHN["orc child"] = "这只小兽人的眼里透露着怨恨和贪婪。它有着旺盛的活力并能以惊人的速度移动。虽然还没完全长大，但是你能看到他全身上下微微隆起的肌肉。"

npcNameCHN["young orc"] = "年轻兽人"
npcDescCHN["young orc"] = "这只兽人已经快成年了，它的皮肤下有着强壮的肌肉。虽然由于狂暴能量的影响它失去了许多兄弟姐妹，但你仍可以从他的眼中发现一闪而过的智慧和狡诈。"

npcNameCHN["orc mother"] = "兽人母体"
npcDescCHN["orc mother"] = "这是一只巨大的扭曲的铁塔般的生物。她身上的每个毛孔中都溢出了黏液，并滴落在地上。兽人儿童们互相争斗来获得哺乳的权利，同时新生儿也会不时地从她的身体里落下。这里的情景和气味让你恶心。"

npcNameCHN["Orc Greatmother"] = "巨型兽人母体"
npcDescCHN["Orc Greatmother"] = "站在我们面前的是一只跟龙差不多体型的怪物。皮肤下鼓起了无数浮肿的肉块，粗大的毛孔里不断流淌出粘稠的液体。上百个乳头喂养了一批互相争吵打斗的兽人——只有最强壮的才能获得补充营养的优先权，弱小的只能在地上等待死亡。数十个生殖器在不断的抽动，不时的挤出新的兽人。在这只怪物的头顶是一头蓬乱长发的枯萎面容，茫然的眼神中混合着些许悲伤和痛苦。但是当她看到你时，她变的异常愤怒，她愤怒的面孔里透露着她护子的决心。"

--paradox-plane
npcNameCHN["Epoch"] = "亚伯契"
npcDescCHN["Epoch"] = "在你面前的是一只黄蓝双色能量线的混合体。它快速的闪现和移动，看起来优雅又飘逸。"

--rak-shor-pride
npcNameCHN["Rak'shor, Grand Necromancer of the Pride"] = "普莱德死灵魔导师拉克·肖"
npcDescCHN["Rak'shor, Grand Necromancer of the Pride"] = "一只穿着黑色长袍的年老兽人。他命令不死大军攻击你。"

npcNameCHN["Rotting Titan"] = "堕落泰坦"
npcDescCHN["Rotting Titan"] = "这只行动缓慢的巨大石化怪物每走一步都会使大地为之震颤。它的身体看起来似乎在不断的颤动和重塑。厚重的石化指尖成为了它强大的钝器。"

npcNameCHN["Glacial Legion"] = "格拉希尔·雷金"
npcDescCHN["Glacial Legion"] = "一个巨大的无定形态的漂浮灵魂体，它包裹在一颗冰封的血球中。冰雾从地板上冉冉升起。"

npcNameCHN["Heavy Sentinel"] = "笨重的森提内尔"
npcDescCHN["Heavy Sentinel"] = "像铁塔一样的生物，由数不清的骨头构成。它的胸前缠绕着一圈烈焰。"

npcNameCHN["Arch Zephyr"] = "阿克·伊法"
npcDescCHN["Arch Zephyr"] = "这只远古吸血鬼的长袍无风自动。闪电在他的周身环绕。他手里握着一把长弓，电弧在这把弓上流转。"

npcNameCHN["Void Spectre"] = "虚空亡魂"
npcDescCHN["Void Spectre"] = "无尽的奥术能量在它永恒的身躯周围环绕。"

--reknor
npcNameCHN["Golbug the Destroyer"] = "毁灭者高尔布格"
npcDescCHN["Golbug the Destroyer"] = "一只膘肥身健的巨大兽人。他看起来既危险又狡猾……"

npcNameCHN["Harno, Herald of Last Hope"] = "最后希望的传令官哈诺"
npcDescCHN["Harno, Herald of Last Hope"] = "他是最后希望传令官中的一员。他似乎找你有事。"

npcNameCHN["Lithfengel"] = "里斯丰格"
npcDescCHN["Lithfengel"] = "一只缠绕着枯萎和衰竭的可怕恶魔，他被传送门的能量吸引而来。这只瘟神！"

--reknor-escape
npcNameCHN["Brotoq the Reaver"] = "收割者布罗托克"
npcDescCHN["Brotoq the Reaver"] = "一只阻挡了钢铁王座道路的兽人。你必须打倒他。"

npcNameCHN["Norgan"] = "诺尔甘"
npcDescCHN["Norgan"] = "诺尔甘和你都是瑞库纳探险队的幸存者，你的任务是把消息带回钢铁王座。"

--rhaloren-camp
npcNameCHN["Rhaloren Inquisitor"] = "罗兰精灵检察官"
npcDescCHN["Rhaloren Inquisitor"] = "这位高大的精灵冲向你，同时带来她锋利的巨剑和魔法的怒吼。"

--ring-of-blood
npcNameCHN["Blood Master"] = "血之领主"
npcDescCHN["Blood Master"] = "这只矮小的人形生物有着白色的毛发。他似乎能看穿你的心灵。"

npcNameCHN["spectator"] = "观众"
npcDescCHN["spectator"] = "一名观众，他可能为了看这场血腥的“游戏”花了很多钱。"

npcNameCHN["slave combatant"] = "奴隶斗士"
npcDescCHN["slave combatant"] = "这个人类已经被夺魂魔心灵控制。"

npcNameCHN["slaver"] = "奴隶商"
npcDescCHN["slaver"] = "一名奴隶商。"

npcNameCHN["enthralled slave"] = "被束缚的奴隶"
npcDescCHN["enthralled slave"] = "一名奴隶。"

--ritch-tunnels
npcNameCHN["ritch flamespitter"] = "火焰里奇"
npcDescCHN["ritch flamespitter"] = "里奇是体型巨大的昆虫，生活在远东南部的不毛之地。它们是恶毒的捕食者，可以将致病的毒素注入猎物体内，并且它们锋利的爪子可以撕裂大部分护甲。"

npcNameCHN["ritch impaler"] = "锋刺里奇"
npcDescCHN["ritch impaler"] = "里奇是体型巨大的昆虫，生活在远东南部的不毛之地。它们是恶毒的捕食者，可以将致病的毒素注入猎物体内，并且它们锋利的爪子可以撕裂大部分护甲。"

npcNameCHN["chitinous ritch"] = "厚甲里奇"
npcDescCHN["chitinous ritch"] = "里奇是体型巨大的昆虫，生活在远东南部的不毛之地。它们是恶毒的捕食者，可以将致病的毒素注入猎物体内，并且它们锋利的爪子可以撕裂大部分护甲。"

npcNameCHN["Ritch Great Hive Mother"] = "里奇女皇"
npcDescCHN["Ritch Great Hive Mother"] = "这只巨大的里奇似乎是所有里奇的母亲。她锋利的爪子向你扑来！"

--ruins-kor-pul
npcNameCHN["The Shade"] = "暗影骷髅"
npcDescCHN["The Shade"] = "这只骷髅看起来很邪恶。它的眼眶里有红色的燃烧火焰。它手持一把巨剑冲向你，并向你投掷法术。"

npcNameCHN["The Possessed"] = "幽灵附体的强盗头目"
npcDescCHN["The Possessed"] = "这是那伙杀死暗影骷髅的强盗的头目，但显然暗影骷髅上的灵魂并没有这么甘心离去，曾经不可一世的强盗头目也只是被其附体的行尸走肉罢了。"

npcNameCHN["Kor's Fury"] = "卡·普尔之怒"
npcDescCHN["Kor's Fury"] = "暗影骷髅使用强大的能量使它存留于世。现在，它成为了疯狂的复仇之魂。"

--sandworm-lair
npcNameCHN["sandworm burrower"] = "沙虫挖掘者"
npcDescCHN["sandworm burrower"] = "这只沙虫似乎毫不在意你的出现，只顾埋头挖掘。也许跟着它才能找到出路。"

npcNameCHN["huge sandworm burrower"] = "巨型沙虫挖掘者"
npcDescCHN["huge sandworm burrower"] = "这只沙虫似乎毫不在意你的出现，只顾埋头挖掘。也许跟着它才能找到出路。"

npcNameCHN["Sandworm Queen"] = "沙虫女皇"
npcDescCHN["Sandworm Queen"] = "在你面前站着的是沙虫女皇。她带着厚重的甲壳和肥胖的身体向你冲来，同时她还在召唤子孙！"

npcNameCHN["Corrupted Sand Wyrm"] = "堕落沙龙"
npcDescCHN["Corrupted Sand Wyrm"] = "沙虫们已经死了，它们被这只扭曲的恐怖所吞噬。"

--scintillating-caves
npcNameCHN["Spellblaze Crystal"] = "魔能水晶体"
npcDescCHN["Spellblaze Crystal"] = "一种紫色水晶。它有着奇特的意识。"

npcNameCHN["Spellblaze Simulacrum"] = "魔能幻象"
npcDescCHN["Spellblaze Simulacrum"] = "一种紫色水晶，如果其他水晶可以被定义为多面体的话，那么这个水晶只能说……和你一样，如果你大个几倍的话。"

--shadow-crypt
npcNameCHN["Rak'Shor Cultist"] = "拉克·肖邪教徒"
npcDescCHN["Rak'Shor Cultist"] = "一只穿着黑色长袍的老兽人。看起来他就是阴影的缔造者。"

--shertul-fortress
npcNameCHN["Weirdling Beast"] = "异形触手"
npcDescCHN["Weirdling Beast"] = "一只类人生物，在四肢的位置它长出了触须状的关节。当你发现他没有头时你吓了一跳。瘤状物在它的皮肤上不断的冒出又爆炸。"

npcNameCHN["Fortress Shadow"] = "堡垒之影"
npcDescCHN["Fortress Shadow"] = "堡垒制造的阴影，就像你之前看到的恐怖生物一样，不过显然它们有着本质的区别。"

npcNameCHN["Training Dummy"] = "训练用傀儡"
npcDescCHN["Training Dummy"] = ""

--shertul-fortress-caldizar
npcNameCHN["Caldizar"] = "凯尔帝勒"
npcDescCHN["Caldizar"] = "四肢是触须，头部由某种突起代替的奇怪生物。一种强烈的能量在他周围流动，这股能量不同于你之前认识的任何一种。他只能是夏·图尔人。一名活生生的夏·图尔人！"

--slazish-fen
npcNameCHN["naga tidewarden"] = "娜迦潮汐守卫"
npcDescCHN["naga tidewarden"] = "在你的面前站着一位高大的生物，在他的腿部是像蛇一样的尾巴。他的身躯看起来高大威猛，并且他还有着一张精灵般美貌的脸庞和一头秀丽的长发。但同样的，这个生物也异常危险，你可以从他的眼睛中看到潜藏的愤怒。"

npcNameCHN["naga tidecaller"] = "娜迦潮汐呼唤者"
npcDescCHN["naga tidecaller"] = "在这只奇怪的生物爬行时伴随着摩擦的噪声，像蛇一样的尾巴却支撑着美丽动人的躯体。当她游动时，她将面前的水抬向大地，你感到面前的不是怪物，而是令人敬畏的力量。"

npcNameCHN["naga nereid"] = "娜迦海卫"
npcDescCHN["naga nereid"] = "绿色的眼睛后面是披落在白皙肩膀的金发。你的眼睛被裸露的肌肤所吸引，但是当你往下看时，你会发现黑色的长蛇尾巴。当她移动时你看向她的脸部，在金发之下是红润而美丽的脸庞，有着高颧骨和丰满的嘴唇。虽然从各方面看来，她都很完美，但是仍掩饰不住你眼皮底下的蛇尾巴带来的恐怖。"

npcNameCHN["Lady Zoisla the Tidebringer"] = "潮汐毁灭者佐西拉夫人"
npcDescCHN["Lady Zoisla the Tidebringer"] = "水流缓慢的围绕着这位娜迦的尾巴旋转，有些水柱在不安的跳动，似乎它们迫不及待去执行主人的命令。她黑色的尾巴蜷缩起来，使她看起来较为矮小，但是她沉着而自信的脸庞使你感受到她无所畏惧。当水流在她周围蒸腾时，星空都仿佛失去了光芒，你感到她的眼神看穿了你的内心。"

--tannen-tower
npcNameCHN["Tannen"] = "泰恩"
npcDescCHN["Tannen"] = "这个叛徒表示，他并不打算让你逃脱来告诉别人这件事。"

npcNameCHN["Drolem"] = "卓勒姆"
npcDescCHN["Drolem"] = "这是泰恩的作品，一只巨大的龙形傀儡。它是如此强大，可以摧毁任何阻挡它的人。"

--telmur
npcNameCHN["The Shade of Telos"] = "泰勒之影"
npcDescCHN["The Shade of Telos"] = "所有人都认为泰勒已经形神俱灭了，但现在看起来他似乎仍徘徊在他的能量之源。"

--tempest-peak
npcNameCHN["Urkis, the High Tempest"] = "风暴魔导师厄奇斯"
npcDescCHN["Urkis, the High Tempest"] = "电弧在这名中年男子周围回绕。他正在积蓄能量。"

--temple-of-creation
npcNameCHN["Slasul"] = "萨拉苏尔"
npcDescCHN["Slasul"] = "这只铁塔般的娜迦散发着强大的能量，并拥有一张英俊潇洒的脸庞。他刚毅的面容紧张的盯着你，尽管你试图逃避他的凝视。他的上身赤裸，只有一串珍珠挂在胸前，他强壮的臂膀分别握着一把大锤和一面盾牌。你发现这里似乎是他的主场，好像整个海洋的能量都集中在了这位娜迦身上，海洋之怒似乎会随时向你涌来。"

--temporal-rift
npcNameCHN["Ben Cruthdar, the Abomination"] = "本·克鲁塞达尔，憎恶形态"
npcDescCHN["Ben Cruthdar, the Abomination"] = "这个疯子似乎被时空能量所扭曲，他的肉体不断的出入相位现实。"

npcNameCHN["Rantha the Abomination"] = "兰莎，憎恶形态"
npcDescCHN["Rantha the Abomination"] = "尖牙利齿，冰冷致命。似乎龙族并没有完全灭绝……并且这只似乎被时空能量所扭曲。"

npcNameCHN["Chronolith Twin"] = "双生琼纳里斯"
npcDescCHN["Chronolith Twin"] = "身穿长袍、有着昆虫样复眼的六臂生物。"

npcNameCHN["Chronolith Clone"] = "克隆琼纳里斯"
npcDescCHN["Chronolith Clone"] = "身穿长袍、有着昆虫样复眼的六臂生物。"

--thieves-tunnels
npcNameCHN["Assassin Lord"] = "盗贼领主"
npcDescCHN["Assassin Lord"] = "他是一帮盗贼的头头，小心他的手下。"

npcNameCHN["Lost Merchant"] = "迷路商人"
npcDescCHN["Lost Merchant"] = ""

--town-angolwen
npcNameCHN["Linaniil, Supreme Archmage of Angolwen"] = "安格利文超阶魔导师·莱娜尼尔"
npcDescCHN["Linaniil, Supreme Archmage of Angolwen"] = "一位穿着启迪丝绸长袍的高挑女人。她的目光是如此的炽热，似乎会融尽一切。"

npcNameCHN["Archmage Tarelion"] = "魔导师泰尔兰"
npcDescCHN["Archmage Tarelion"] = "一位穿着光滑长袍的高大永恒精灵，他看起来很稳重，你可以感受到他体内蕴含的强大能量。"

npcNameCHN["apprentice mage"] = "法师学徒"
npcDescCHN["apprentice mage"] = "一位学徒，正在学习法术的奥秘。"

npcNameCHN["pyromancer"] = "烈焰术士"
npcDescCHN["pyromancer"] = "一位精通火焰法术的法师。"

npcNameCHN["cryomancer"] = "冰霜术士"
npcDescCHN["cryomancer"] = "一位精通冰系法术的法师。"

npcNameCHN["geomancer"] = "地卜师"
npcDescCHN["geomancer"] = "一位精通土系法术的法师。"

npcNameCHN["tempest"] = "风暴术士"
npcDescCHN["tempest"] = "一位精通闪电法术的法师。"

--town-derth
npcNameCHN["derth guard"] = "德斯守卫"
npcDescCHN["derth guard"] = "一名严肃的守卫，他不会允许任何人打扰镇子的宁静。"

npcNameCHN["halfling slinger"] = "半身人投石者"
npcDescCHN["halfling slinger"] = "一位携带投石索的半身人。当心。"

npcNameCHN["human farmer"] = "人类农民"
npcDescCHN["human farmer"] = "穿着普通的人类农民。"

npcNameCHN["halfling gardener"] = "半身人园丁"
npcDescCHN["halfling gardener"] = "一名正在寻找植物的半身人。"

npcNameCHN["Shady cornac man"] = "鬼鬼祟祟的普通人类"
npcDescCHN["Shady cornac man"] = ""

--town-elvala
npcNameCHN["elvala guard"] = "埃尔瓦拉守卫"
npcDescCHN["elvala guard"] = "一名严肃的守卫，他不会允许任何人打扰城里的宁静。"

npcNameCHN["shalore rune master"] = "精灵符文大师"
npcDescCHN["shalore rune master"] = "一名高大的精灵，他的皮肤刻上了各种纹身。"

--town-gates-of-morning
npcNameCHN["High Sun Paladin Aeryn"] = "太阳骑士艾琳"
npcDescCHN["High Sun Paladin Aeryn"] = "一位身披板甲的美女。她的周身闪耀着光辉。"

--town-irkkk
npcNameCHN["yeek mindslayer"] = "夺心魔心灵杀手"
npcDescCHN["yeek mindslayer"] = "一名正在训练的夺心魔杀手。"

npcNameCHN["yeek psionic"] = "夺心魔超能力者"
npcDescCHN["yeek psionic"] = "你可以感受到这名夺心魔周围的能量。"

npcNameCHN["gem crafter"] = "珠宝匠"
npcDescCHN["gem crafter"] = "这名夺心魔出售所有品种的宝石。"

npcNameCHN["two hander weapons crafter"] = "双手武器铁匠"
npcDescCHN["two hander weapons crafter"] = "这名夺心魔出售所有种类的双手武器。"

npcNameCHN["one hander weapons crafter"] = "单手武器铁匠"
npcDescCHN["one hander weapons crafter"] = "这名夺心魔出售所有种类的单手武器。"

npcNameCHN["tailor"] = "裁缝"
npcDescCHN["tailor"] = "这名夺心魔出售所有种类的衣服。"

npcNameCHN["tanner"] = "皮革商"
npcDescCHN["tanner"] = "这名夺心魔出售所有种类的皮革。"

npcNameCHN["natural infusions"] = "纹身师"
npcDescCHN["natural infusions"] = "这名夺心魔出售所有种类的纹身。"

--town-iron-council
npcNameCHN["dwarven guard"] = "矮人守卫"
npcDescCHN["dwarven guard"] = "一名严肃的矮人守卫，他看起来脾气火爆。"

npcNameCHN["dwarven earthwarden"] = "矮人岩石守卫"
npcDescCHN["dwarven earthwarden"] = "一名严肃的矮人守卫，他看起来脾气火爆。"

--town-last-hope
npcNameCHN["last hope guard"] = "最后的希望守卫"
npcDescCHN["last hope guard"] = "一名严肃的守卫，他不会允许任何人打扰镇子的宁静。"

npcNameCHN["halfling guard"] = "半身人守卫"
npcDescCHN["halfling guard"] = "一位携带投石索的半身人。当心。"

npcNameCHN["human citizen"] = "人类市民"
npcDescCHN["human citizen"] = "一位面容清秀的最后希望市民。"

npcNameCHN["halfling citizen"] = "半身人市民"
npcDescCHN["halfling citizen"] = "一位面容清秀的最后希望市民。"

--town-lumberjack-village
npcNameCHN["Ben Cruthdar, the Cursed"] = "被诅咒者本·克鲁塞达尔"
npcDescCHN["Ben Cruthdar, the Cursed"] = "这个疯子看起来相当危险。他手持巨斧并精通战技。黑暗光环从他身上向周围扩散。"

npcNameCHN["lumberjack"] = "伐木工"
npcDescCHN["lumberjack"] = "一名伐木工。伐木是他的工作，梦幻而激情。"

--town-town-point-zero
npcNameCHN["guardian of reality"] = "时空守卫"
npcDescCHN["guardian of reality"] = "一名严肃的守卫，他时刻警惕着对零点圣域的威胁。"

npcNameCHN["monstrous losgoroth"] = "大型洛斯格罗斯"
npcDescCHN["monstrous losgoroth"] = "洛斯格罗斯是非常强大的虚空生物，居住于群星之间的星空中。在星球表面几乎看不到这种生物。"

npcNameCHN["Zemekkys, Grand Keeper of Reality"] = "伊莫克斯·时空守护者"
npcDescCHN["Zemekkys, Grand Keeper of Reality"] = "一位中年精灵站在你面前，岁月不曾在其脸上留下痕迹。尽管你不知道他活了多久，但是你仍能感到他已经遍览世间万物。"

npcNameCHN["Temporal Defiler"] = "时空污秽魔"
npcDescCHN["Temporal Defiler"] = "一只瘦长的生物，在其手指部位有着锋利的剃刀般的爪子，此外，它还拥有锋利的牙齿。它似乎在这里寻找着什么。"

--town-shatur
npcNameCHN["thalore hunter"] = "精灵猎人"
npcDescCHN["thalore hunter"] = "一名严肃的守卫，他不会允许任何人打扰城里的宁静。"

npcNameCHN["thalore wilder"] = "精灵野性师"
npcDescCHN["thalore wilder"] = "一名高大的精灵，他的皮肤覆有青苔。"

--town-zigur
npcNameCHN["Grand Corruptor"] = "堕落领主"
npcDescCHN["Grand Corruptor"] = "一位堕落精灵，他生活在这片荒芜大陆上。"

npcNameCHN["Protector Myssil"] = "守护者米歇尔"
npcDescCHN["Protector Myssil"] = "一名身穿黑色板甲的半身人伊格兰斯。她是伊格目前的首领。"

--trollmire
npcNameCHN["Prox the Mighty"] = "大力巨魔普罗克斯"
npcDescCHN["Prox the Mighty"] = "一只巨大的巨魔，虽然他行动缓慢，但是毫无疑问他看起来危险无比。"

npcNameCHN["Shax the Slimy"] = "水上巨魔夏克斯"
npcDescCHN["Shax the Slimy"] = "一只巨大的巨魔，他似乎已经习惯了水中的生活。"

npcNameCHN["Bill the Stone Troll"] = "岩石巨魔比尔"
npcDescCHN["Bill the Stone Troll"] = "高大、强壮且嗜食半身人。他手持一柄小巧的树干并冲向你。这就是手稿里提到的那只巨魔，没跑了……"

npcNameCHN["Aluin the Fallen"] = "堕落骑士阿鲁因"
npcDescCHN["Aluin the Fallen"] = "他曾经闪亮的盔甲如今又锈又钝且满是鲜血，这名太阳骑士已经陷入了深深的绝望。"


--tutorial
npcNameCHN["skeleton mage"] = "骷髅法师"
--npcDescCHN["skeleton mage"] = ""

npcNameCHN["half-dead forest troll"] = "半死的森林巨魔"
npcDescCHN["half-dead forest troll"] = "绿皮丑陋的生物，这只笨重的人形生物在盯着你并握紧了满是肉瘤的绿色拳头。他看起来受伤了。"

npcNameCHN["Lone Wolf"] = "寂寞的狼"
npcDescCHN["Lone Wolf"] = "这是一只狡诈的狼，只有普通狼的3倍大。它看起来很饥渴，而你——很美味！"

--tutorial-combat-stats
npcNameCHN["Nain the Guide"] = "指引者耐恩"
npcDescCHN["Nain the Guide"] = "一名带着微笑留着扫把头的人类。"

npcNameCHN["skeleton mage"] = "骷髅法师"
--npcDescCHN["skeleton mage"] = ""

npcNameCHN["half-dead forest troll"] = "半死的森林巨魔"
npcDescCHN["half-dead forest troll"] = "绿皮丑陋的生物，这只笨重的人形生物在盯着你并握紧了满是肉瘤的拳头。他看起来受伤了。"

npcNameCHN["Lone Wolf"] = "寂寞的狼"
npcDescCHN["Lone Wolf"] = "这是一只狡诈的狼，只有普通狼的3倍大。它看起来很饥渴，而你——很美味！"

npcNameCHN["Orc"] = "兽人"
npcDescCHN["Orc"] = ""

npcNameCHN["Quick-healing orc"] = "快速自愈的兽人"
npcDescCHN["Quick-healing orc"] = ""

npcNameCHN["Robe-clad elf"] = "披着长袍的精灵"
npcDescCHN["Robe-clad elf"] = "这名精灵看起来一生都花费在了手势和颂歌中。"

npcNameCHN["Stubborn orc"] = "顽固的兽人"
npcDescCHN["Stubborn orc"] = ""

npcNameCHN["Obstinate orc"] = "顽强的兽人"
npcDescCHN["Obstinate orc"] = ""

npcNameCHN["Pushy orc"] = "冲动的兽人"
npcDescCHN["Pushy orc"] = ""

npcNameCHN["Rude orc"] = "粗暴的兽人"
npcDescCHN["Rude orc"] = ""

npcNameCHN["Troll"] = "巨魔"
npcDescCHN["Troll"] = ""

npcNameCHN["Ugly troll"] = "丑陋的巨魔"
npcDescCHN["Ugly troll"] = ""

npcNameCHN["Gross troll"] = "粗野的巨魔"
npcDescCHN["Gross troll"] = ""

npcNameCHN["Ghastly troll"] = "可怕的巨魔"
npcDescCHN["Ghastly troll"] = ""

npcNameCHN["Forum troll"] = "高等巨魔"
npcDescCHN["Forum troll"] = ""

npcNameCHN["Pushy elf"] = "冲动的精灵"
npcDescCHN["Pushy elf"] = ""

npcNameCHN["Blustering elf"] = "狂暴的精灵"
npcDescCHN["Blustering elf"] = ""

npcNameCHN["Breezy elf"] = "活泼的精灵"
npcDescCHN["Breezy elf"] = ""

npcNameCHN["giant spider"] = "巨大的蜘蛛"
npcDescCHN["giant spider"] = "一只巨大的蛛形纲生物。"

npcNameCHN["chittering spider"] = "肥胖的蜘蛛"
npcDescCHN["chittering spider"] = "一只巨大的肥胖蜘蛛。"

npcNameCHN["hairy spider"] = "毛蜘蛛"
npcDescCHN["hairy spider"] = "一只巨大的毛蜘蛛。"

npcNameCHN["Bored elf"] = "无聊的精灵"
npcDescCHN["Bored elf"] = ""

npcNameCHN["Idle elf"] = "懒惰的精灵"
npcDescCHN["Idle elf"] = ""

npcNameCHN["Loitering elf"] = "流浪的精灵"
npcDescCHN["Loitering elf"] = ""

npcNameCHN["Dull-eyed orc"] = "笨拙的兽人"
npcDescCHN["Dull-eyed orc"] = ""

npcNameCHN["Keen-eyed orc"] = "敏锐的兽人"
npcDescCHN["Keen-eyed orc"] = ""

--unremarkable-cave
npcNameCHN["Fillarel Aldaren"] = "菲拉瑞尔·阿达兰"
npcDescCHN["Fillarel Aldaren"] = "一名精灵女子。她穿着日月图案的长袍，手持一根法杖。"

npcNameCHN["Krogar"] = "克罗格"
npcDescCHN["Krogar"] = "一名穿着锁甲的兽人，他手持法杖并且看起来凶残异常。"

--valley-moon
npcNameCHN["Corrupted Daelach"] = "堕落达莱奇"
npcDescCHN["Corrupted Daelach"] = "阴影和火焰。这团火焰怪物向你冲来，它的巨大暗影翅膀逐渐张开。"

npcNameCHN["Limmir the Jeweler"] = "珠宝匠利米尔"
npcDescCHN["Limmir the Jeweler"] = "一名精灵星月术士，擅长珠宝技艺。"

--void
npcNameCHN["Gerlyk, the Creator"] = "创世神·盖里克"
npcDescCHN["Gerlyk, the Creator"] = [[在混沌纪几乎大部分神祗被夏·图尔的弑神者所杀。但仍有少部分逃离。
盖里克，人类缔造者，则选择走进群星间的虚空来避免死亡。他至今仍毫无踪迹。
恶魔法师们正在试图将他召回，并已经接近成功。
现在是你结束夏·图尔人未完成事业的时刻了，去成为一名弑神者吧！]]

--vor-armoury
npcNameCHN["Warmaster Gnarg"] = "战争领主格纳哥"
npcDescCHN["Warmaster Gnarg"] = "这名丑陋的兽人看起来阴险狡诈。他手持双手大剑并擅长此道。"

npcNameCHN["overpowered greater multi-hued wyrm"] = "超强的七彩龙精英"
npcDescCHN["overpowered greater multi-hued wyrm"] = ""

--vor-pride
npcNameCHN["Vor, Grand Geomancer of the Pride"] = "普莱德地卜师将军沃尔"
npcDescCHN["Vor, Grand Geomancer of the Pride"] = "一名身穿彩色长袍的年老兽人。冰霜在他周围盘旋，他在走过的路上留下一条雷火之径。"

--traps
npcNameCHN["Intruder alarm"] = "入侵警报"
npcNameCHN["Summoning alarm"] = "召唤警报"
npcNameCHN["Lethargy trap"] = "昏睡陷阱"
npcNameCHN["Burning curse trap"] = "燃烧诅咒陷阱"
npcNameCHN["Giant boulder trap"] = "滚石陷阱"
npcNameCHN["Acid trap"] = "酸液陷阱"
npcNameCHN["Fire trap"] = "火焰陷阱"
npcNameCHN["Ice trap"] = "冰霜陷阱"
npcNameCHN["Lightning trap"] = "闪电陷阱"
npcNameCHN["Poison trap"] = "毒液陷阱"
npcNameCHN["Acid blast trap"] = "酸液爆炸陷阱"
npcNameCHN["Fire blast trap"] = "火焰爆炸陷阱"
npcNameCHN["Ice blast trap"] = "冰霜爆炸陷阱"
npcNameCHN["Lightning blast trap"] = "闪电爆炸陷阱"
npcNameCHN["Poison blast trap"] = "毒液爆炸陷阱"
npcNameCHN["Sliding rock"] = "光滑的石块"
npcNameCHN["Poison vine"] = "剧毒藤蔓"
npcNameCHN["Teleport trap"] = "传送陷阱"
npcNameCHN["Water jet"] = "喷射陷阱"
npcNameCHN["Water siphon"] = "虹吸陷阱"

--summons
npcNameCHN["war hound"] = "战争猎犬"
npcDescCHN["war hound"] = ""

npcNameCHN["black jelly"] = "黑果冻怪"
npcDescCHN["black jelly"] = "地板上的一团黑色胶状物体。"

npcNameCHN["minotaur"] = "米诺陶"
npcDescCHN["minotaur"] = "它拥有人类和牛的特征。"

npcNameCHN["stone golem"] = "岩石傀儡"
npcDescCHN["stone golem"] = "这是一个厚重的活化石像。"

npcNameCHN["3-headed hydra"] = "三头蛇"
npcDescCHN["3-headed hydra"] = "这是一只拥有三颗头颅的奇异爬行生物。"

npcNameCHN["rimebark"] = "雾凇"
npcDescCHN["rimebark"] = "这颗树环绕着凛冬之怒。"

npcNameCHN["fire drake"] = "火龙"
npcDescCHN["fire drake"] = "一只成年火龙，拥有炽烈的火焰吐息和锋利的爪子。"

npcNameCHN["turtle"] = "乌龟"
npcDescCHN["turtle"] = ""

npcNameCHN["giant spider"] = "巨大的蜘蛛"
npcDescCHN["giant spider"] = "一只巨大的蛛形纲生物。"

npcNameCHN["orc spirit"] = "兽族之魂"
npcDescCHN["orc spirit"] = "一位穿着板甲的兽人，他手持着一柄擎天巨斧。"

npcNameCHN["void shard"] = "虚空碎片"
npcDescCHN["void shard"] = "它看起来就像是无尽虚空中的一个缝隙。"

npcNameCHN["Vilespawn"] = "业障"
npcDescCHN["Vilespawn"] = "这团史莱姆样的恶魔，诞生于卡帕萨斯之中，它张开了大嘴，试图吞噬你。"

npcNameCHN["walking corpse"] = "行尸"
npcDescCHN["walking corpse"] = "这具尸体是刚复活的，看起来它正在学习怎么走路。"

npcNameCHN["terror"] = "暗夜恐魔"
npcDescCHN["terror"] = "这只形态模糊的恐魔，将敌人连同周围的空气一起切成两半。"

npcNameCHN["tormentor"] = "折磨者"
npcDescCHN["tormentor"] = "恐惧的场景折磨着你的脑海。"

npcNameCHN["dark tendril"] = "黑暗触须"
npcDescCHN["dark tendril"] = ""

----thought-form
npcNameCHN["thought-forged bowman"] = "精神体弓箭手"
npcDescCHN["thought-forged bowman"] = "一位身穿皮甲的精神体弓箭手。他时刻准备着战斗。"

npcNameCHN["thought-forged warrior"] = "精神体狂战士"
npcDescCHN["thought-forged warrior"] = "一位身穿重甲的精神体狂战士。他时刻准备着战斗。"

npcNameCHN["thought-forged defender"] = "精神体盾战士"
npcDescCHN["thought-forged defender"] = "一位身穿重甲的精神体盾战士。他手持剑盾，时刻准备着战斗。"

--events
--cultists
npcNameCHN["Cultist"] = "异教徒"
npcDescCHN["Cultist"] = "一名精灵异教徒，他似乎无视了你。"
npcNameCHN["Shasshhiy'Kaish"] = "莎西·凯希"
npcDescCHN["Shasshhiy'Kaish"] = "不看她那盘旋在头上的火焰王冠、三条小尾巴以及那锋利的爪子，这只恶魔仍然充满了奇异的魅惑。当你看着她时，你感觉痛苦像利刃一样，深入骨髓，她是痛苦的使者。"

--kitty
npcNameCHN["Lost Kitty"] = "迷路的猫咪"
npcNameCHN["Pumpkin, the little kitty"] = "小南瓜，可爱的小猫咪"
npcDescCHN["Pumpkin, the little kitty"] = "一只橙色的小猫咪，胸前有一颗白色的星星。只要有机会就会舔你的脸颊。"


--DLC
--tome-ashes-urhrok

--major-demon
npcNameCHN["wretch titan"] = "腐化泰坦"
npcDescCHN["wretch titan"] = "许多冒险家都遭遇过酸液树魔。相当可怕，酸液树魔们，成群出现，灼烧腐蚀。但这些冒险家们不知道，酸液树魔只是它的未成熟的孩子。"

--zones

--anteroom-agony
npcNameCHN["quasit squad leader"] = "夸塞魔队长"
npcDescCHN["quasit squad leader"] = "一只装备了重甲的小恶魔，它向你发起冲锋。"

npcNameCHN["Rogroth, Eater of Souls"] = "罗格洛斯，灵魂吞噬者"
npcDescCHN["Rogroth, Eater of Souls"] = "火焰和枯萎的力量在蜘蛛一样的黑色金属皮肤上闪现。它没有明显的头部，只有一个大大的嘴巴。"

--searing-halls
npcNameCHN["demonic clerk"] = "恶魔职员"
npcDescCHN["demonic clerk"] = "一个小恶魔，他对你的自由感到非常惊惶。"

npcNameCHN["mutilator"] = "恶魔切割者"
npcDescCHN["mutilator"] = "一个长着三只手的恶魔，准备切割你。不是娱乐，而是实验！"

npcNameCHN["investigator"] = "恶魔调查者"
npcDescCHN["investigator"] = "这个恶魔专心于从#{italic}#志愿者#{normal}#手里#{italic}#获取#{normal}#资料。"

npcNameCHN["Planar Controller"] = "空间控制者"
npcDescCHN["Planar Controller"] = "一个巨大的恶魔朝你走来，显然他控制着附近所有的传送门。"

--temporal-hound
npcNameCHN["temporal hound"] = "时空猎犬"
npcDescCHN["temporal hound"] = "一条受训的猎犬，同时呈现出小狗崽和老掉牙两种状态。"
--地图巡逻队
npcNameCHN["adventurers party"] = "冒险家分队"
npcNameCHN["ziguranth patrol"] = "伊格巡逻队"
npcNameCHN["Allied Kingdoms human patrol"] = "联合王国人类巡逻队"
npcNameCHN["Allied Kingdoms halfling patrol"] = "联合王国半身人巡逻队"
npcNameCHN["Sun Paladins patrol"] = "太阳骑士巡逻队"
npcNameCHN["Anorithil patrol"] = "星月术士巡逻队"
npcNameCHN["Orcs patrol"] = "兽人巡逻队"



--Orc DLC
npcNameCHN["sewer alligator"] = "下水道鳄鱼"
npcDescCHN["sewer alligator"] = [[多 么 的 老 套！]]
npcNameCHN["giant alligator"] = "巨型鳄鱼"
npcDescCHN["giant alligator"] = [[多 么 的 老 套， 并 且 可 怕！]]
npcNameCHN["pet yeti"] = "宠物雪人"
npcDescCHN["pet yeti"] = [[这 个 雪 人 比 一 般 的 雪 人 要 小 一 些， 它 的 毛 发 看 起 来 被 梳 理 过。 不 仅 如 此， 它 看 起 来 对 它 主 人 的 家 园 被 入 侵 了 不 太 高 兴。]]
npcNameCHN["guard yeti"] = "雪人守卫"
npcDescCHN["guard yeti"] = [[这 个 雪 人 巨 大 且 愤 怒， 他 的 爪 子 被 打 磨 的 远 比 那 些 野 生 雪 人 的 锋 利。]]
npcNameCHN["basaligator"] = "蛇蜥魔鳄"
npcDescCHN["basaligator"] = [[这 个 东 西 看 上 去 像 是 只 鳄 鱼， 但 是 它 有 一 双 大 的 不 自 然 的 灰 色 眼 睛。 它 正 在 紧 紧 的 盯 着 你。]]
npcNameCHN["attack yeti"] = "雪人攻击者"
npcDescCHN["attack yeti"] = [[这 个 雪 人 的 爪 子 上 套 着 锋 利 的 铁 刺， 狂 怒 的 瞪 着 你。]]
npcNameCHN["hethugoroth"] = "赫斯格鲁斯"
npcDescCHN["hethugoroth"] = [[一 个 灼 热 的 蒸 汽 漩 涡 所 形 成 的 生 命 体。]]
npcNameCHN["greater hethugoroth"] = "大型赫斯格鲁斯"
npcDescCHN["greater hethugoroth"] = [[一 个 灼 热 的 蒸 汽 漩 涡 所 形 成 的 生 命 体。]]
npcNameCHN["ultimate hethugoroth"] = "终极赫斯格鲁斯"
npcDescCHN["ultimate hethugoroth"] = [[一 个 灼 热 的 蒸 汽 漩 涡 所 形 成 的 生 命 体。]]
npcNameCHN["..."] = "..."
npcDescCHN["..."] = [[这 是 个 看 上 去 很 像 蜘 蛛 的 八 腿 机 械 构 造 体。 它 正 向 你 飞 速 冲 来 并 准 备 用 颚 部 的 旋 转 锯 刃 将 你 撕 成 碎 片。]]
npcNameCHN["ritch larva"] = "里奇幼虫"
npcDescCHN["ritch larva"] = [[里 奇 是 一 种 远 东 南 部 的 巨 型 土 著 昆 虫。]]
npcNameCHN["ritch hunter"] = "里奇猎手"
npcDescCHN["ritch hunter"] = [[里 奇 是 一 种 远 东 南 部 的 巨 型 土 著 昆 虫。]]
npcNameCHN["ritch hive mother"] = "里奇巢母"
npcDescCHN["ritch hive mother"] = [[里 奇 是 一 种 远 东 南 部 的 巨 型 土 著 昆 虫。]]
npcNameCHN["ritch centipede"] = "里奇百足虫"
npcDescCHN["ritch centipede"] = [[这 个 奇 怪 的 生 物 看 上 去 像 是 一 个 里 奇 猎 手， 但 是 它 的 脚 要 多 多 了， 多 很 多 很 多。]]
npcNameCHN["larvae bloated ritch mother"] = "满载幼虫的里奇巢母"
npcDescCHN["larvae bloated ritch mother"] = [[这 个 生 物 的 皮 肤 上 爬 满 了 幼 虫， 字 面 意 义 上 的 爬 满。 尽 管 如 此， 她 向 你 前 进 的 速 度 非 常 快。]]
npcNameCHN["necropsych's ghost"] = "通灵师的鬼魂"
npcDescCHN["necropsych's ghost"] = [[这 是 一 个 在 近 期 死 亡 的 通 灵 师 的 灵 魂。 它 痛 苦 的 哀 鸣 着， 无 视 现 实 世 界 的 一 切。]]
npcNameCHN["steam giant necropsych"] = "蒸汽巨人通灵师"
npcDescCHN["steam giant necropsych"] = [[这 个 被 死 亡 符 文 所 覆 盖 的 蒸 汽 巨 人 是 个 大 麻 烦。]]
npcNameCHN["steam giant blood carver"] = "蒸汽巨人血雕者"
npcDescCHN["steam giant blood carver"] = [[尽 管 血 液 不 停 地 从 这 个 高 大 的 巨 人 身 上 渗 出， 他 看 上 去 却 没 有 任 何 不 适。]]
npcNameCHN["steam giant gunner"] = "蒸汽巨人枪手"
npcDescCHN["steam giant gunner"] = [[这 个 蒸 汽 巨 人 拿 着 一 把 看 上 去 威 力 很 强 的 枪。]]
npcNameCHN["steam giant gunslinger"] = "蒸汽巨人快枪手"
npcDescCHN["steam giant gunslinger"] = [[这 个 蒸 汽 巨 人 双 手 各 拿 着 一 把 蒸 汽 枪。]]
npcNameCHN["steam giant guard"] = "蒸汽巨人守卫"
npcDescCHN["steam giant guard"] = [[这 个 拿 着 巨 型 剑 盾 的 庞 大 人 形 正 在 向 你 走 来。]]
npcNameCHN["steam giant flameshot"] = "蒸汽巨人火焰射手"
npcDescCHN["steam giant flameshot"] = [[这 个 蒸 汽 巨 人 双 手 各 拿 着 一 把 枪 管 在 燃 烧 的 蒸 汽 枪。]]
npcNameCHN["steam giant berserker"] = "蒸汽巨人狂战士"
npcDescCHN["steam giant berserker"] = [[这 个 蒸 汽 巨 人 双 手 拿 着 一 柄 无 比 庞 大 的 巨 剑， 你 看 到 剑 刃 被 厚 厚 的 蒸 汽 云 团 包 裹 着。]]
npcNameCHN["steam giant yeti rider"] = "蒸汽巨人雪人骑士"
npcDescCHN["steam giant yeti rider"] = [[这 个 拿 着 巨 剑 的 蒸 汽 巨 人 骑 在 一 只 重 甲 雪 人 身 上。]]
npcNameCHN["retaliator of Atmos"] = "阿特姆斯复仇者"
npcDescCHN["retaliator of Atmos"] = [[这 个 蒸 汽 巨 人 双 手 各 拿 着 一 把 蒸 汽 枪。 她 来 此 唯 一 的 目 的 就 是 消 灭 任 何 对 阿 特 姆 斯 部 落 的 威 胁。]]
npcNameCHN["sun-mage recruit"] = "太阳法师新兵"
npcDescCHN["sun-mage recruit"] = [[一 个 穿 着 荧 光 法 袍 的 法 师。]]
npcNameCHN["mecharachnid warrior"] = "机械蛛武士"
npcDescCHN["mecharachnid warrior"] = [[这 是 个 看 上 去 很 像 蜘 蛛 的 八 腿 机 械 构 造 体。 它 正 向 你 飞 速 冲 来 并 准 备 用 颚 部 的 旋 转 锯 刃 将 你 撕 成 碎 片。]]
npcNameCHN["sun-mage"] = "太阳法师"
npcDescCHN["sun-mage"] = [[一 个 穿 着 闪 亮 法 袍 的 法 师。]]
npcNameCHN["anorithil"] = "星月术士"
npcDescCHN["anorithil"] = [[一 个 穿 着 同 时 描 绘 了 光 与 暗 的 华 丽 法 袍 的 法 师。]]
npcNameCHN["astral conjurer"] = "星空咒术师"
npcDescCHN["astral conjurer"] = [[一 个 穿 着 同 时 描 绘 了 光 与 暗 的 华 丽 法 袍 的 法 师。]]
npcNameCHN["mecharachnid flame thrower"] = "机械蛛喷火者"
npcDescCHN["mecharachnid flame thrower"] = [[这 是 个 看 上 去 很 像 蜘 蛛 的 八 腿 机 械 构 造 体。 尽 管 蜘 蛛 可 不 会 有 它 背 后 装 载 的 巨 型 火 焰 喷 射 器。]]
npcNameCHN["elven astromancer"] = "精灵星术师"
npcDescCHN["elven astromancer"] = [[一 个 将 毕 生 精 力 投 入 到 了 对 星 辰 及 其 原 理 的 学 习 中 的 法 师。]]
npcNameCHN["mecharachnid destroyer"] = "机械蛛毁灭者"
npcDescCHN["mecharachnid destroyer"] = [[这 是 个 看 上 去 很 像 蜘 蛛 的 八 腿 机 械 构 造 体。 一 个 武 装 到 牙 齿， 呃， 颚 部 的 蜘 蛛。]]
npcNameCHN["mecharachnid repairbot"] = "机械蛛维修者"
npcDescCHN["mecharachnid repairbot"] = [[这 是 个 看 上 去 很 像 蜘 蛛 的 八 腿 机 械 构 造 体。 比 起 你， 它 似 乎 更 关 心 它 的 同 胞 们。]]
npcNameCHN["sunwall guard"] = "太阳堡垒守卫"
npcDescCHN["sunwall guard"] = [[这 个 身 着 太 阳 堡 垒 徽 记 的 守 卫 挺 拔 而 骄 傲 的 站 立 着。]]
npcNameCHN["sunwall archer"] = "太阳堡垒弓箭手"
npcDescCHN["sunwall archer"] = [[你 看 到 了 一 个 拉 着 弓 的 射 手， 他 的 护 甲 上 有 金 色 太 阳 的 压 纹。]]
npcNameCHN["sun paladin recruit"] = "太阳骑士新兵"
npcDescCHN["sun paladin recruit"] = [[这 个 士 兵 的 盾 牌 闪 耀 着 强 光。 你 看 到 盾 牌 的 中 央 雕 刻 着 一 个 金 色 的 太 阳， 同 时 他 的 另 一 只 手 拿 着 一 柄 剑。]]
npcNameCHN["titan battlesmasher"] = "泰坦碎颅者"
npcDescCHN["titan battlesmasher"] = [[这 个 生 物 看 上 去 像 是 一 个 蒸 汽 巨 人， 但 是 更 巨 大， 更 恶 心， 并 且 被 某 种 未 知 力 量 腐 化 了。 天 啊， 他 还 拿 着 一 个 巨 锤！]]
npcNameCHN["sun paladin"] = "太阳骑士"
npcDescCHN["sun paladin"] = [[这 个 士 兵 的 盾 牌 与 剑 都 闪 耀 着 强 光。 你 看 到 盾 牌 的 中 央 雕 刻 着 一 个 金 色 的 太 阳。]]
npcNameCHN["titanic horror"] = "泰坦恐魔"
npcDescCHN["titanic horror"] = [[尽 管 一 般 的 泰 坦 看 上 去 像 是 一 个 堕 落 的 蒸 汽 巨 人， 这 一 个 看 上 去 更 像 是 一 个 巨 人 大 小 的 恐 怖 血 肉 团 块。]]
npcNameCHN["sunwall vindicator"] = "太阳堡垒维护者"
npcDescCHN["sunwall vindicator"] = [[这 个 看 上 去 十 分 凶 恶 的 太 阳 堡 垒 士 兵 稳 稳 地 握 着 一 柄 双 手 剑， 他 正 在 用 危 险 的 目 光 看 着 你。]]
npcNameCHN["titan searing seer"] = "泰坦炙热先知"
npcDescCHN["titan searing seer"] = [[你 能 感 受 到 从 这 个 被 奥 术 火 焰 所 环 绕 的 泰 坦 所 放 射 出 的 强 大 的 精 神 力 量 正 在 你 的 心 灵 中 回 荡。]]
npcNameCHN["titan vile spewer"] = "泰坦呕吐魔"
npcDescCHN["titan vile spewer"] = [[这 个 恶 心 的 泰 坦 的 皮 肤 呈 现 一 种 粘 乎 乎 的 绿 色， 满 是 不 停 的 流 着 粘 液 的 伤 口， 裂 缝， 和 脓 疱。 蠕 虫 和 其 他 各 种 卑 劣 的 东 西 在 他 身 上 爬 来 爬 去。]]
npcNameCHN["troll pirate"] = "巨魔海盗"
npcDescCHN["troll pirate"] = [[这 是 一 个 巨 魔 海 盗。]]
npcNameCHN["troll marauder"] = "巨魔掠夺者"
npcDescCHN["troll marauder"] = [[这 个 精 壮 的 巨 魔 熟 练 使 用 着 一 对 匕 首。 他 看 向 你 的 目 光 中 满 是 狡 诈。]]
npcNameCHN["titan dreadnought"] = "泰坦无畏勇士"
npcDescCHN["titan dreadnought"] = [[这 是 你 见 过 的 最 大 的 泰 坦， 他 被 一 身 深 黑 色 的 蓝 锆 石 全 身 甲 所 覆 盖， 正 迈 着 可 怕 的 步 伐 向 你 冲 来。]]
npcNameCHN["troll captain"] = "巨魔船长"
npcDescCHN["troll captain"] = [[这 个 巨 魔 正 在 咆 哮 着 地 对 他 身 旁 的 巨 魔 下 达 命 令。 他 毫 不 费 力 的 双 手 各 拿 着 一 柄 长 剑。]]
npcNameCHN["sher'tan"] = "夏尔泰坦"
npcDescCHN["sher'tan"] = [[这 个 孽 物 和 其 他 泰 坦 差 不 多 高， 但 是 他 的 特 征 让 你 回 想 起 了 你 见 过 的 那 些 夏 图 尔 人 图 片。 你 竭 尽 全 力 的 抗 拒 这 些 想 法， 你 的 心 灵 已 被 纯 粹 的 恐 惧 所 控 制。]]
npcNameCHN["troll guard"] = "巨魔守卫"
npcDescCHN["troll guard"] = [[这 只 巨 魔 拿 着 巨 大 的 剑 盾， 身 上 穿 了 一 些 零 碎 的 护 甲。]]
npcNameCHN["troll aquamancer"] = "巨魔控水师"
npcDescCHN["troll aquamancer"] = [[这 只 巨 魔 一 只 手 拿 着 一 柄 长 杖。 他 的 身 边 盘 绕 着 由 水 组 成 的 触 手。]]
npcNameCHN["gargantuan sher'tan"] = "庞大的夏尔泰坦"
npcDescCHN["gargantuan sher'tan"] = [[这 个 孽 物 和 其 他 泰 坦 差 不 多 高， 但 是 他 的 特 征 让 你 回 想 起 了 你 见 过 的 那 些 夏 图 尔 人 图 片。 你 竭 尽 全 力 的 抗 拒 这 些 想 法， 你 的 心 灵 已 被 纯 粹 的 恐 惧 所 控 制。]]
npcNameCHN["whitehoof ghoul"] = "白蹄尸鬼"
npcDescCHN["whitehoof ghoul"] = [[他 像 是 人 类 和 公 牛 组 合 出 来 的， 除 了 更…… 死。]]
npcNameCHN["undead drake hatchling"] = "亡灵幼龙"
npcDescCHN["undead drake hatchling"] = [[一 只 骷 髅 幼 龙； 并 不 怎 么 强， 但 是 如 果 他 们 的 习 性 还 像 活 着 的 时 候 那 样 的 话， 这 里 恐 怕 有 不 止 一 只。]]
npcNameCHN["whitehoof maulotaur"] = "巨锤白蹄"
npcDescCHN["whitehoof maulotaur"] = [[这 个 巨 大 的 亡 灵 牛 头 人 拿 着 一 把 灌 注 了 闪 电 的 可 怕 巨 锤。]]
npcNameCHN["undead drake"] = "亡灵飞龙"
npcDescCHN["undead drake"] = [[一 只 骷 髅 飞 龙， 有 着 致 命 的 吐 息 和 可 怕 的 利 爪。]]
npcNameCHN["whitehoof invoker"] = "白蹄唤魔者"
npcDescCHN["whitehoof invoker"] = [[不 详 的 奥 术 能 量 环 绕 着 这 个 强 大 的 死 灵。]]
npcNameCHN["undead wyrm"] = "亡灵巨龙"
npcDescCHN["undead wyrm"] = [[一 只 活 了 很 久 的 巨 龙 的 骷 髅， 有 着 致 命 的 吐 息 和 可 怕 的 利 爪。]]
npcNameCHN["whitehoof hailstorm"] = "白蹄霜雹使"
npcDescCHN["whitehoof hailstorm"] = [[看 上 去 这 个 可 怕 的 死 灵 身 周 的 空 气 都 冻 结 凋 零 了。]]
npcNameCHN["yeti cub"] = "雪人幼崽"
npcDescCHN["yeti cub"] = [[这 个 类 人 生 物 身 上 长 着 厚 实 的 白 毛。]]
npcNameCHN["yeti"] = "雪人"
npcDescCHN["yeti"] = [[这 个 大 型 的 类 人 生 物 身 上 长 着 厚 实 的 白 毛。]]
npcNameCHN["yeti warrior"] = "雪人勇士"
npcDescCHN["yeti warrior"] = [[这 个 巨 大 的 类 人 生 物 身 上 长 着 厚 实 的 白 毛， 和 危 险 的 巨 爪。 他 看 上 去 十 分 愤 怒。]]
npcNameCHN["yeti demolisher"] = "雪人爆破者"
npcDescCHN["yeti demolisher"] = [[这 个 巨 大 的 类 人 生 物 身 上 长 着 厚 实 的 白 毛， 和 危 险 的 巨 爪。 你 会 喜 欢 被 他 肌 肉 满 满 的 双 臂 拥 抱 一 下 吗？]]
npcNameCHN["shadow of pain"] = "痛之煞"
npcDescCHN["shadow of pain"] = [[一团由痛苦具现成的阴影。]]
npcNameCHN["shadow of hate"] = "恨之煞"
npcDescCHN["shadow of hate"] = [[一团由恨意具现成的阴影。]]
npcNameCHN["shadow of despair"] = "惘之煞"
npcDescCHN["shadow of despair"] = [[一团由绝望具现成的阴影。]]
npcNameCHN["shadow of remorse"] = "悔之煞"
npcDescCHN["shadow of remorse"] = [[一团由悔恨具现成的阴影。]]
npcNameCHN["shadow of guilt"] = "罪之煞"
npcDescCHN["shadow of guilt"] = [[一团由罪怨具现成的阴影。]]
npcNameCHN["shadow of anger"] = "怒之煞"
npcDescCHN["shadow of anger"] = [[一团由愤怒具现成的阴影。]]
npcNameCHN["Crimson Templar John"] = "血红圣堂武士约翰"
npcDescCHN["Crimson Templar John"] = [[这位曾经沐浴在阳光下的战士，一位你曾经尊敬的勇士，现在已经被仇恨所吞噬。
这个战士曾经闪耀着光辉的护甲已经被阴沉的血红色掩盖。他径直向你冲来，只见他的眼神空洞无物。]]
npcNameCHN["Admiral Korbek"] = "海军上将库贝克"
npcDescCHN["Admiral Korbek"] = [[这只年长的巨魔昂首挺胸，身穿华丽的服装；不用说，他一定是一个重要人物。它右手持一把邪恶长剑，左手拿着一把古色古香的手枪。]]
npcNameCHN["mutant snake"] = "变异蛇"
npcDescCHN["mutant snake"] = [[这种蛇看起来在这片污染的下水道里…生活得很兴旺嘛。]]
npcNameCHN["Captured Yeti Behemoth"] = "被捕获的雪人巨兽。"
npcDescCHN["Captured Yeti Behemoth"] = [[这只巨大的雪人远远高出附近的巨魔，极度的狂怒让它变得疯狂。]]
npcNameCHN["High Sun Paladin Aeryn"] = "太阳骑士艾琳"
npcDescCHN["High Sun Paladin Aeryn"] = [[一位身披板甲的美女。她的周身闪耀着光辉。]]
npcNameCHN["halfling pyremaster"] = "半身人火魔导师"
npcDescCHN["halfling pyremaster"] = [[这团火热的小球看来是联合王国派来支援太阳堡垒的援军。他一定会后悔来到这里的！]]
npcNameCHN["shalore liberator"] = "永恒精灵解放者"
npcDescCHN["shalore liberator"] = [[这个强大的永恒精灵看起来是联合王国派来支援太阳堡垒的援军。他一定会后悔来到这里的！]]
npcNameCHN["sun orb"] = "太阳球"
npcDescCHN["sun orb"] = [[一个注入了太阳能量的小球。]]
npcNameCHN["moon orb"] = "月亮球"
npcDescCHN["moon orb"] = [[一个注入了月亮能量的小球。]]
npcNameCHN["Haze Commander Parmor"] = "阴霾指挥官派拉莫尔"
npcDescCHN["Haze Commander Parmor"] = [[G.E.M.的指挥官。这个高贵的巨人用藐视的眼神居高临下地看着你。她手里拿着两个巨大的旋转圆锯，上面还带有恐魔的内脏。]]
npcNameCHN["Half-Mechanized Yeti"] = "半机械化雪人"
npcDescCHN["Half-Mechanized Yeti"] = [[虽然不知道是谁把这个雪人折磨成这样，它的确变成了一个恐怖的杀戮机器。当你凝视着它的皮毛，你注意到它身上的重要部分都被蓝锆石装甲所覆盖。他的一只手臂也被替换成了蒸汽链锯。]]
npcNameCHN["Mindwall"] = "意念之墙"
npcDescCHN["Mindwall"] = [[.]]
npcNameCHN["Mindcontrol Pillar"] = "心灵控制柱"
npcDescCHN["Mindcontrol Pillar"] = [[这个玻璃柱子中完好地保存着一个大脑。]]
npcNameCHN["Arch-Merchant Kaltor"] = "大商人卡托尔"
npcDescCHN["Arch-Merchant Kaltor"] = [[一个精心打扮的巨人，身穿珠光宝气的外衣。他的手中拿着着两把奇怪的枪。不过奇怪的是，他看起来对你比较友好，并盯上了你装满钱的钱包。]]
npcNameCHN["Nektosh the One-Horned"] = "独角者纳克托沙"
npcDescCHN["Nektosh the One-Horned"] = [[一个干瘪的白蹄，他的两只角在头上弯曲成螺旋形合并起来。他头上的角发出强烈的闪光，但闪光逐渐消退。他努力让自己显得充满自信，但他飘忽不定的眼神展露出了内心的恐惧。]]
npcNameCHN["guardian psi-ghost"] = "超能幽魂守卫"
npcDescCHN["guardian psi-ghost"] = [[一个奇怪的人形幽灵，它的身形忽闪忽现，似乎是被某种超能力所启动。]]
npcNameCHN["Council Member Nashal"] = "议会成员纳沙尔"
npcDescCHN["Council Member Nashal"] = [[这位女巨人高贵的面容与她邪恶的微笑和手中旋转的巨大链锯形成了鲜明的反差]]
npcNameCHN["Council Member Tormak"] = "议会成员托马克"
npcDescCHN["Council Member Tormak"] = [[作为一位奥术领域的大师，托马克正站在你的面前，试图用它强大的的法术粉碎你。]]
npcNameCHN["Council Member Pendor"] = "议会成员佩多尔"
npcDescCHN["Council Member Pendor"] = [[这位手拿两把巨大的蒸汽枪的巨人却表现出令人吃惊的敏捷和难以捉摸。十分致命！]]
npcNameCHN["Council Member Palaquie"] = "议会成员派拉奎尔"
npcDescCHN["Council Member Palaquie"] = [[这位女巨人骄傲的站在你面前，手中拿着蒸汽枪和灵晶，当子弹飞来时，你感觉一股强大的精神力向你冲来。]]
npcNameCHN["Council Member Tantalos"] = "议会成员坦塔罗斯"
npcDescCHN["Council Member Tantalos"] = [[我们应该假设气之部族的最高官员应该并不是一个面目可憎的巨大怪物。他让你联想起你对夏图尔人的模糊印象，但这不自然的外观和令人作呕的咕噜声让你从理性到情感的每一个层面都充满延误。憎恶这种恐怖生物的原始本能似乎潜藏于你的心灵中，比一切语言都要古老。如果他真的是的话…好吧，他还真是个贿选高手。]]
npcNameCHN["Maltoth the Mad"] = "疯狂者马尔托斯"
npcDescCHN["Maltoth the Mad"] = [[这个可怜的人似乎在时间的洪流中被困住了。]]
npcNameCHN["crystalbark"] = "晶化树精"
npcDescCHN["crystalbark"] = [[一个强大的有智能的树精，现在已经被晶体结构所侵蚀。]]
npcNameCHN["Crystallized Primal Root"] = "晶化巨木"
npcDescCHN["Crystallized Primal Root"] = [[这个曾经伟大的原始数目已经被疯狂蔓延的水晶侵蚀注入和腐化。真是可怕的解决。]]
npcNameCHN["Amakthel's Hand"] = "阿马克泰尔的头部"
npcDescCHN["Amakthel's Hand"] = [[你从没想象这样的事情居然会发生，你不相信你居然会遇到它。但是这是真的，在你面前矗立着的就是阿马克泰尔肢体的一部分。
神话说，夏·图尔人杀死了阿马克泰尔，他们已经消逝在神话中。
但是他就在这里，处于生死交接的沉眠中。你可以在脑海中感受到他的思维，没有错：#{bold}#已死之神就在这里！#{normal}#]]
npcNameCHN["Amakthel's Mouth"] = "阿马克泰尔的嘴"
npcDescCHN["Amakthel's Mouth"] = [[你从没想象这样的事情居然会发生，你不相信你居然会遇到它。但是这是真的，在你面前矗立着的就是阿马克泰尔肢体的一部分。
神话说，夏·图尔人杀死了阿马克泰尔，他们已经消逝在神话中。
但是他就在这里，处于生死交接的沉眠中。你可以在脑海中感受到他的思维，没有错：#{bold}#已死之神就在这里！#{normal}#]]
npcNameCHN["Amakthel's Eye"] = "阿马克泰尔的眼睛"
npcDescCHN["Amakthel's Eye"] = [[你从没想象这样的事情居然会发生，你不相信你居然会遇到它。但是这是真的，在你面前矗立着的就是阿马克泰尔肢体的一部分。
神话说，夏·图尔人杀死了阿马克泰尔，他们已经消逝在神话中。
但是他就在这里，处于生死交接的沉眠中。你可以在脑海中感受到他的思维，没有错：#{bold}#已死之神就在这里！#{normal}#]]
npcNameCHN["spiked tentacle"] = "尖刺触手"
npcDescCHN["spiked tentacle"] = [[一个巨大的触手，准备用他的尖刺粉碎你。]]
npcNameCHN["oozing tentacle"] = " 粘液触手。"
npcDescCHN["oozing tentacle"] = [[粘液从这个恶心的触手中渗出。]]
npcNameCHN["eyed tentacle"] = "带眼触手"
npcDescCHN["eyed tentacle"] = [[触手上长着一只恶毒的眼睛。它正紧盯着你。]]
npcNameCHN["Sher'Tul High Priest"] = "Sher'Tul High Priest"
npcDescCHN["Sher'Tul High Priest"] = [[夏·图尔人！他们是存在的！神话和传奇的来源，远古的恐怖和噩梦，拥有无尽力量的强大生物，他们的种族曾经战胜了古神。这只夏·图尔人似乎想要复活阿马克泰尔，最强的神。你不知道他为什么要这么做，但你知道，如果他的阴谋得逞，兽人乃至整个世界都会遭受灭顶之灾。]]
npcNameCHN["Automated Defense System"] = "自动防御系统"
npcDescCHN["Automated Defense System"] = [[这个重装的机械蜘蛛看起来极其危险，全副武装，准备保卫采石场。]]
npcNameCHN["Star Gazer"] = "观星者"
npcDescCHN["Star Gazer"] = [[这个星术师放射着天体的强大能量。你可以在飞舞的长袍下面前辨认出精灵的身形。]]
npcNameCHN["Astral-Infused Yeti"] = "星辰雪人"
npcDescCHN["Astral-Infused Yeti"] = [[你想知道为什么雪人会从它在克拉克半岛的栖息地跋山涉水来到这里。你还想知道为什么这个被注入了强大的天空力量的雪人会愤怒地向你冲来。]]
npcNameCHN["Outpost Leader John"] = "前哨站领袖约翰"
npcDescCHN["Outpost Leader John"] = [[这位战士的盔甲闪耀着璀璨的金光。他挥动华丽的剑与盾，自信地向你冲来。]]
npcNameCHN["orc retaliator"] = "兽人反击者"
npcDescCHN["orc retaliator"] = [[一个严肃的兽人，武装到牙齿]]
npcNameCHN["orc gunslinger"] = "兽人快枪手"
npcDescCHN["orc gunslinger"] = [[一个严肃的兽人，手拿双枪。]]
npcNameCHN["Ancient Automated Teacher"] = "远古教学机器人"
npcDescCHN["Ancient Automated Teacher"] = [[一份远古知识的宝库！他似乎能和你对话。]]
npcNameCHN["orc guard"] = "兽人守卫"
npcDescCHN["orc guard"] = [[一个严肃的守卫，阻止任何打扰城镇安宁的人。]]
npcNameCHN["orc gunslinger"] = "兽人快枪手"
npcDescCHN["orc gunslinger"] = [[一个严肃的兽人，手拿双枪。]]
npcNameCHN["Commander Fralor"] = "指挥官法罗尔"
npcDescCHN["Commander Fralor"] = [[这个身穿重甲的蒸汽巨人手持巨大的战斧，恶狠狠挥舞着向你冲来。]]
npcNameCHN["Metash the Maulotaur"] = "玛诺陶梅塔什"
npcDescCHN["Metash the Maulotaur"] = [[这个巨大的亡灵牛头人手拿一把灌注了闪电力量的锤子。]]
npcNameCHN["Ureslak the Eternal"] = "永恒的乌瑞斯拉克"
npcDescCHN["Ureslak the Eternal"] = [[这条传奇巨龙似乎已经陨落，不过这似乎并不影响他的霸权继续统治大陆。]]
npcNameCHN["steam giant commoner"] = "蒸汽巨人平民"
npcDescCHN["steam giant commoner"] = [[巨人的腰间传来了金币的叮当响。]]
npcNameCHN["steam giant scribe"] = "蒸汽巨人书记员"
npcDescCHN["steam giant scribe"] = [[这个精心打扮的巨人身上满是墨水的污渍，看起来十分惊慌。]]
npcNameCHN["steam giant shopkeeper"] = "蒸汽巨人店主"
npcDescCHN["steam giant shopkeeper"] = [[巨人的腰间传来了金币的叮当响。]]
npcNameCHN["steam giant child"] = "蒸汽巨人孩童"
npcDescCHN["steam giant child"] = [[这个巨人比他的同伴矮一些， 但还是很高！]]
npcNameCHN["High Guard Talosis"] = "高阶守卫泰勒西斯"
npcDescCHN["High Guard Talosis"] = [[这个身穿重甲的蒸汽巨人双手各持一把枪，左手的枪华丽但却陈旧。]]
npcNameCHN["Yeti Patriarch"] = "雪人族长"
npcDescCHN["Yeti Patriarch"] = [[这个雪人比他的同胞们搞出一个头。你看到他的眼中充满了其他雪人所没有的狡猾。]]
