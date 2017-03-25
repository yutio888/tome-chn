module(..., package.seeall)

_M.artifactCHN = {}
function registerArtifactTranslation(t)
	_M.artifactCHN[t.originName] = t
end
function _M.fetchArtifactTranslation(item)
	if not item.name then return end
	local t = _M.artifactCHN[item.name]
	if not t then return end
	for k, v in pairs(t) do
		local sf = item
		while k:find("%.") do
			l, _ = k:find("%.")
			sf = sf[k:sub(1, l - 1)]
			k = k:sub(l + 1, k:len() )
		end
		sf[k] = v
	end
end
registerArtifactTranslation{
	originName = "Rungof's Fang",
	name = "郎格夫之牙",
	unided_name = "血痕覆盖的尖牙",
	desc = "巨型座狼郎格夫之牙，上面仍被血痕覆盖。",
}

registerArtifactTranslation{
	originName = "Wintertide",
	name = "霜华",
	unided_name = "闪耀的长剑",
	desc = "这把剑带给这片区域无尽的寒冷，剑锋周围的空气似乎都要凝固了。据说是第一次厄流纪大战期间，孔克雷夫大师为他们的战争之王所打造。",
	special_desc = function(self)
		if not self.winterStorm then
			return ("风暴持续时间:  无") 
		else
			return ("风暴持续时间: " .. (self.winterStorm.duration or "无"))
		end
	end,
	["combat.special_on_hit.desc"] = function(self, who, special) 
		local dam = who:damDesc(engine.DamageType.COLD, special:damage(self, who))
		return ("制造不断扩张的寒冰风暴（从半径 %d 到半径 %d），每回合造成 %.2f 寒冷伤害（基于力量）并减速  20%%。接下来的近战攻击将重置  风暴位置并延长持续时间。 "):format(special.radius, special.max_radius, dam)
	end,
	["use_power.name"] = "强化冰风暴的冰雪，冻结成冰墙，持  续 10 回合。",
}

registerArtifactTranslation{
	originName = "Wintertide Phial",
	name = "霜华之瓶",
	unided_name = "充满黑暗的瓶子",
	desc = "这个小瓶子似乎充满了黑暗，但却净化了你的思想。",
	["use_power.name"] = function(self, who) 
		return ("净化你的思想，解除至多 %d 个（基于魔法）负  面精神状态。")
		:format(self.use_power.nbcure(self, who)) 
	end,
}

registerArtifactTranslation{
	originName = "Fiery Choker",
	name = "炽焰护符",
	unided_name = "火焰制造的护符",
	desc = "一个由火焰形成的护符，在它的佩戴者身上不断地改变着形状。它的火焰似乎不会伤害到佩戴者。",
}

registerArtifactTranslation{
	originName = "Frost Treads",
	name = "踏雪",
	unided_name = "覆盖着冰霜的皮靴",
	desc = "一双摸起来冰凉的皮靴，闪烁着冰冷的蓝色光芒。",
}

registerArtifactTranslation{
	originName = "Dragonskull Helm",
	name = "苍龙之盔",
	unided_name = "头骨做成的头盔",
	desc = "在这个灰白而残破的头骨中还残留着巨龙的能量。",
}

registerArtifactTranslation{
	originName = "Eel-skin armour",
	name = "电鳗皮甲",
	unided_name = "光滑的护甲",
	desc = "这个护甲似乎由很多电鳗碎片拼接起来。真烦人。",
}

registerArtifactTranslation{
	originName = "Chromatic Harness",
	name = "七彩鳞甲",
	unided_name = "色彩丰富的鳞片护甲",
	desc = "这个以巨龙鳞片制成的护甲闪耀着五颜六色的光芒，它们在鳞甲表面不断的变化着。",
}

registerArtifactTranslation{
	originName = "Glory of the Pride",
	name = "普莱德之荣耀",
	unided_name = "深黑色的戒指",
	desc = "这是普莱德的战争之王格鲁希纳克最宝贵的财富。这枚金戒指上铭刻着失传的兽人语。",
}

registerArtifactTranslation{
	originName = "Nightsong",
	name = "暗夜颂歌",
	unided_name = "黑曜石戒指",
	desc = "一枚纯黑色的戒指。似乎无尽的黑暗缠绕着它。",
}

registerArtifactTranslation{
	originName = "Steel Helm of Garkul",
	name = "加库尔的钢盔",
	unided_name = "部落头盔",
	desc = "这是迄今为止，最伟大的兽人毁灭者加库尔的头盔。",
	set_desc = {garkul = "另一件加库尔的遗物将唤醒他的英灵。" },
}

registerArtifactTranslation{
	originName = "Lunar Shield",
	name = "银月辉盾",
	unided_name = "甲壳质盾牌",
	desc = "一个从尼米斯尔身上剥离下来的巨大甲壳。它持续发出奇异的白色光芒。",
}

registerArtifactTranslation{
	originName = "Wrathroot's Barkwood",
	name = "愤怒之根的树皮",
	unided_name = "巨大的树皮",
	desc = "用狂怒树精的树皮制成的粗糙盾牌。",
}

registerArtifactTranslation{
	originName = "Petrified Wood",
	name = "硅化木",
	unided_name = "烧毁的木头残片",
	desc = "从断裂之根身上得到的木头残片。",
}

registerArtifactTranslation{
	originName = "Crystal Shard",
	name = "水晶之杖",
	unided_name = "水晶般的树枝",
	desc = "这柄法杖像水晶般透明，尺寸精确无比，从不同角度看去，反射出种种光芒。凝视着它，你会好奇：它的魔力究竟来自哪里。",
	["use_power.name"] = "制造两片活的水晶体来为你服务 10 回合。",
}

registerArtifactTranslation{
	originName = "Black Robe",
	name = "暗黑礼服",
	unided_name = "黑色的礼服",
	desc = "一件比夜色还黑的丝绸礼服，它向外辐射出能量。",
}

registerArtifactTranslation{
	originName = "Malediction",
	name = "诅咒",
	unided_name = "散发着瘟疫气息的斧头",
	desc = "无论这把斧头在哪里，大地都会枯萎和凋零。",
}

registerArtifactTranslation{
	originName = "Kor's Fall",
	name = "卡·普尔的陨落",
	unided_name = "黑暗的法杖",
	desc = "这根法杖由许多生物的骨头制成并散发着能量。你甚至可以在很远的地方感受到它的邪恶气息。",
}

registerArtifactTranslation{
	originName = "Vox",
	name = "呐喊",
	unided_name = "吵闹的护身符",
	desc = "没有任何力量能使这个护身符的主人安静下来。",
}

registerArtifactTranslation{
	originName = "Telos's Staff (Top Half)",
	name = "泰勒斯的法杖（上半部）",
	unided_name = "损坏的法杖",
	desc = "泰勒斯破损法杖的上半部分。",
}

registerArtifactTranslation{
	originName = "Choker of Dread",
	name = "恐惧护符",
	unided_name = "黑暗的护符",
	desc = "这件护符散发着不死生物的邪恶气息。",
	["use_power.name"] = "召唤一个吸血鬼为你服务 15 回合。",
}

registerArtifactTranslation{
	originName = "Runed Skull",
	name = "符文头骨",
	unided_name = "人类的头骨",
	desc = "暗红色的符文遍布着这块黑色头骨。",
}

registerArtifactTranslation{
	originName = "Bill's Tree Trunk",
	name = "比尔的树干",
	unided_name = "巨大的树干",
	desc = "这是一个巨大的、丑陋的树干，但是巨魔比尔把它当做武器。如果你够强壮，你也可以把它当做武器！",
}

registerArtifactTranslation{
	originName = "Sanguine Shield",
	name = "血色盾牌",
	unided_name = "血迹斑斑的盾牌",
	desc = "尽管这个盾牌被鲜血染上并玷污了，但是阳光会继续照耀着它。",
}

registerArtifactTranslation{
	originName = "Whip of Urh'Rok",
	name = "厄洛克之鞭",
	unided_name = "炽热的鞭子",
	desc = "用这根炽焰打造的鞭子，恶魔领主厄洛克未尝一败。",
}

registerArtifactTranslation{
	originName = "Warmaster Gnarg's Murderblade",
	name = "战争之王格纳哥的饮血剑",
	unided_name = "血迹斑斑的巨剑",
	desc = "一把血迹斑斑的巨剑，它洞穿了许多敌人。",
	["combat.special_on_hit.desc"] = "10%% 几率令持有者进入嗜血状态。",
}

registerArtifactTranslation{
	originName = "Crown of the Elements",
	name = "元素王冠",
	unided_name = "镶嵌宝石的王冠",
	desc = "这顶镶嵌宝石的王冠闪闪发光。",
}

registerArtifactTranslation{
	originName = "Flamewrought",
	name = "炽焰手套",
	unided_name = "甲壳制成的手套",
	desc = "这副手套似乎是由里奇之焰的骨骼组成。它们摸上去非常热。",
}

registerArtifactTranslation{
	originName = "Crystal Focus",
	name = "魔力结晶",
	unided_name = "闪耀的水晶",
	desc = "这个水晶散发着魔力的光辉。",
	["use_power.name"] = "安装至一把白板武器",
}

registerArtifactTranslation{
	originName = "Crystal Heart",
	name = "水晶之心",
	unided_name = "曲线状的水晶",
	desc = "这颗水晶很大，几乎和你的头一样大。它闪烁着动人的光辉。",
	["use_power.name"] = "安装至一件护甲",
}

registerArtifactTranslation{
	originName = "Rod of Annulment",
	name = "废除之枝",
	unided_name = "黑暗的枝条",
	desc = "你可以感受到枝条周围的魔力流失，甚至它自己也似乎受到了影响。",
	["use_power.name"] = function(self, who) 
		return ("将半径 %d 内的一个目标的至多 3 个纹身、符文或技能打入 3-5 回合的冷却。")
		:format(self.use_power.range)
	end,
}

registerArtifactTranslation{
	originName = "Skullcleaver",
	name = "碎颅战斧",
	unided_name = "深红色的战斧",
	desc = "一把小巧而锋利的斧头，斧柄由打磨过的骨头制成。这把斧头打破了许多头骨，并被染成了鲜红色。",
}

registerArtifactTranslation{
	originName = "Tooth of the Mouth",
	name = "深渊之牙",
	unided_name = "一个钉耙",
	desc = "在无尽深渊中得到的一颗巨大牙齿。",
}

registerArtifactTranslation{
	originName = "The Warped Boots",
	name = "扭曲之靴",
	unided_name = "有着难看痕迹的靴子",
	desc = "这些被玷污的靴子已经丧失了它们以前的荣耀，现在，它们只能作为深渊的存在以及腐蚀力量的证明。",
}

registerArtifactTranslation{
	originName = "The Gaping Maw",
	name = "贪婪之胃",
	unided_name = "巨大的冰冷战斧",
	desc = "这柄战斧看起来更像狼牙棒，它的手柄是由黑木制成并包裹着一层蜉蝣皮，它的刃锋处闪耀着粘稠的绿色液体。",
	["combat.special_on_crit.desc"] = "在 3 码锥形范围内造成等于精神强度的法力燃烧伤害。",
}

registerArtifactTranslation{
	originName = "Withering Orbs",
	name = "枯萎眼球",
	unided_name = "阴影缠绕的眼球",
	desc = "这些泛着乳白色光芒的眼球用死亡的眼神看着你，你的虚荣和虚伪使其苏醒。他们曾经在难以想象的恐惧中死亡，现在它们被黑色的丝线串起，周围缠绕着片片阴影。如果你闭上眼睛一段时间，你甚至可以感受到它们曾经看到的恐怖画面……",
}

registerArtifactTranslation{
	originName = "Borfast's Cage",
	name = "波法斯特的牢笼",
	unided_name = "一套满是凹痕的板甲",
	desc = "英尺厚的蓝锆石板甲，关节部分由沃瑞钽组成。整套铠甲看起来异常坚固，但是显然它有过非常可怕的经历——巨大的凹痕、扭曲的关节以及腐蚀的表面。尽管现在看起来只是一块坚固的铁板，但是它显然有着辉煌的过去。",
}

registerArtifactTranslation{
	originName = "Aletta's Diadem",
	name = "阿蕾塔的王冠",
	unided_name = "镶有珠宝的王冠",
	desc = "一个镶嵌有很多珠宝的银制艺术品，这顶王冠看起来光芒四射而又美丽优雅。但是当你碰到它时，你感到你的皮肤都要冻僵了，许多狂暴的意识涌向你的大脑。你想丢弃它，扔掉它，但是你最终无法抗拒它能带给你的力量。是你的意志太薄弱，还是这件史诗支配了你？",
}

registerArtifactTranslation{
	originName = "Hare-Skin Sling",
	name = "大白兔投石索",
	unided_name = "兔皮投石索",
	desc = "这把投石索是由一只巨大的野兔皮精制而成。它摸起来光滑柔软却十分耐用。有人说，野兔皮可以带来幸运。很难说它是否会真的帮助使用者，但是很显然这副毛皮既结实又可靠。",
}

registerArtifactTranslation{
	originName = "Prox's Lucky Halfling Foot",
	name = "普洛克斯的幸运半身人脚",
	unided_name = "一只风干的半身人脚",
	desc = "一只用细线串起来的巨大毛脚，很显然这是一位半身人的。目前的状态，很难讲它多久以前被割了下来，但是从脚踝处的齿痕来看，应该不是出于自愿。它的外面有一层盐和粘土，被很好的保护着，尽管如此，大自然还是剥夺了它的活力，它已经成为了一块死肉。有人说，半身人的脚可以带来好运，但是现在唯一可确认的是——它臭死了！",
	special_desc = function(self)
		local ready = self:min_power_to_trigger() - self.power
		return ("侦查陷阱。\n25%% 几率解除至多 3 个震  慑、定身或眩晕效果。%s"):format((ready > 0) and (" (冷却: %d 回合)"):format(ready) or "")
	end,
}

registerArtifactTranslation{
	originName = "Storm Fury",
	name = "风暴之怒",
	unided_name = "电弧缠绕的长弓",
	desc = "这把龙骨长弓由精钢镶制而成，一道道电弧缠绕在其身上，闪电球在其弓弦上徘徊，但是却绕过了你的手臂。",
	special_desc = function(self) return "自动发射闪电攻击附近敌人，有几率使之眩晕。" end,
}

registerArtifactTranslation{
	originName = "Frozen Shroud",
	name = "冰霜斗篷",
	unided_name = "冰冷的斗篷",
	desc = "格拉希尔·雷金的全部剩余。这件斗篷散发着的寒气冻结了周围的一切。",
	["use_power.name"] = function(self, who)
			local dam = who:damDesc(engine.DamageType.COLD, self.use_power.damage(self, who))
			return ("在半径 %d 范围内制造寒冰霜雾，每回合造成 %0.2f 寒冷伤害（基于魔法），持续 %d 回合。"):format(self.use_power.radius, dam, self.use_power.duration)
	end,
}

registerArtifactTranslation{
	originName = "Blighted Maul",
	name = "枯萎之锤",
	unided_name = "腐烂的石化肢体",
	desc = "这是腐化泰坦的一部分沉重肢体，一大块腐烂的石化躯体。你认为你可以轻易举起它，但事实证明，它重的不可思议。",
	["combat.special_on_hit.desc"] = function(self, who, special)
		local dam = who:damDesc(engine.DamageType.PHYSICAL, special.shockwavedam(self, who, special))
		return ("制造半径 1 的冲击波，造成 %0.2f 到 %0.2f 枯萎伤害。 ( 基于力量)。"):format(dam, dam *3)
	end,
	["use_power.name"] = function(self, who)
		local dam = who:damDesc(engine.DamageType.PHYSICAL, self.use_power.damage(self, who))
		return ("击退半径 %d 的生物，造成 %0.2f 到 %0.2f 物理伤害   ( 基于力量  )。"):format(self.use_power.radius, dam, dam*2)
	end,
}

registerArtifactTranslation{
	originName = "Molten Skin",
	name = "炽热之皮",
	unided_name = "炙热的骨甲" ,
	desc = "这件由笨重的森提内尔身上扒下的皮甲散发着阵阵高温。由于森提内尔核心的强大能量，它一直在发红发亮。不过它似乎不会伤害到你。",
}

registerArtifactTranslation{
	originName = "Void Orb",
	name = "虚空之球",
	unided_name = "飘渺的戒指",
	desc = "这只戒指装饰有深黑色的水晶。仿佛有白色的星云在戒指上缭绕，水晶的核心处偶尔有紫色的光一闪而过。",
}

registerArtifactTranslation{
	originName = "Khulmanar's Wrath",
	name = "库马纳的怒火",
	unided_name = "燃烧的黑色战斧",
	desc = "黑色的浓烟缠绕在这把战斧上，恐惧长廊的烈焰在其身上咆哮。这把战斧由厄洛克授予他最强大的指挥官，它可以焚尽一切，包括最强大的敌人。",
}

registerArtifactTranslation{
	originName = "Bladed Rift",
	name = "次元裂隙",
	unided_name = "空间中的裂隙",
	desc = "在击败阿克·吉希尔后，它留下了这个小巧的裂隙。你无从知道，它是如何保持这样的稳定状态。冥冥中你感受到，你能从这个裂隙中召唤出一把剑。",
}

registerArtifactTranslation{
	originName = "Blade of Distorted Time",
	name = "时光扭曲之刃",
	unided_name = "扭曲时间的剑",
	desc = "这把剑由一段损坏的时间线构成，它在不断的出入相位现实。",
	["combat.special_on_hit.desc"] = "造成额外时空伤害并减速目标 ",
}

registerArtifactTranslation{
	originName = "Rune of Reflection",
	name = "反射符文",
	unided_name = "闪光的符文",
	desc = "你可以在这块银色的符文表面看到自己的倒影。",
}

registerArtifactTranslation{
	originName = "Psionic Fury",
	name = "灵能之怒",
	unided_name = "震动的灵晶",
	desc = "这颗灵晶在不停的震动，仿佛其中有一股强大的力量试图从中逃脱。",
	["use_power.name"] = function(self, who) 
		return ("释放灵能冲击波，造成%0.2f精神伤害（基于意志），伤害半径%d。")
		:format(who:damDesc(engine.DamageType.MIND, self.use_power.damage(self, who)), self.use_power.radius)
	end,
}

registerArtifactTranslation{
	originName = "Life Drinker",
	name = "生命汲取者",
	unided_name = "沾满了鲜血的匕首",
	desc = "愚者之血，邪魔之刃。",
}

registerArtifactTranslation{
	originName = "Trident of the Tides",
	name = "潮汐之戟",
	unided_name = "不停滴水的三叉戟",
	desc = "这把三叉戟上流动着潮汐的力量。需习得异形武器天赋才能正确使用三叉戟。",
}

registerArtifactTranslation{
	originName = "Telos Spire of Power",
	name = "泰勒斯之力",
	unided_name = "脉动的法杖",
	desc = "泰勒斯是黄昏纪的一位强大法师，为对手所嫉恨，为弱者所惧怕。最终，虽然他陨落在了他的所在之处——泰尔玛，但是他的灵魂仍长存于世。",
}

registerArtifactTranslation{
	originName = "Staff of Destruction",
	name = "毁灭之杖",
	unided_name = "充满黑暗气息的法杖",
	desc = "这个品相独特的法杖上刻印着毁灭符文。",
}

registerArtifactTranslation{
	originName = "Penitence",
	name = "忏悔",
	unided_name = "通红的法杖",
	desc = "永恒精灵密送到安格利文，用以对抗魔法大爆炸所引起灾难的强大法杖。",
	["use_power.name"] = function(self, who) 
		return ("治愈至多 %d 项疾病和毒素。 ( 基于魔法 )")
		:format(self.use_power.cures(self, who)) 
		end,
}

registerArtifactTranslation{
	originName = "Lost Staff of Archmage Tarelion",
	name = "大法师泰尔兰丢失的法杖",
	unided_name = "闪光的法杖",
	desc = "大法师泰尔兰在年轻的时候曾环游世界。但是这个世界并不是那么美好以至于我们的大法师不得不飞速逃跑。",
}

registerArtifactTranslation{
	originName = "Bolbum's Big Knocker",
	name = "鲍尔本的大门扣",
	unided_name = "一根厚重的法杖",
	desc = "这是一根末端有着厚重门扣的沉重法杖。据说是炼金魔导师鲍尔本在厄流纪使用的法杖。它之所以闻名于世，大部分来源于鲍尔本的学生们对他的恐惧以及被它打伤脑袋的超高几率。鲍尔本被7把匕首插在后背而死，那根被众人诅咒的法杖也从此消失不见。",
}

registerArtifactTranslation{
	originName = "Vargh Redemption",
	name = "瓦尔弗的救赎",
	unided_name = "海蓝色的戒指",
	desc = "这个海蓝色的戒指看上去总是水汪汪的。",
	["use_power.name"] = function(self, who)
	local dam = self.use_power.damage(self, who)
		return ("召唤缓慢扩张的半径 %d 的潮汐，持续 %d 回合，每回合造成 %0.2f 寒冷和 %0.2f 物理伤害，并击退敌人。")
		:format(self.use_power:radius(who), self.use_power.duration(self, who), who:damDesc(engine.DamageType.COLD, dam/2), who:damDesc(engine.DamageType.PHYSICAL, dam/2)) 
	end,
}

registerArtifactTranslation{
	originName = "Ring of the Dead",
	name = "亡者之戒",
	unided_name = "黯淡的戒指",
	desc = "这枚戒指充溢着坟墓的气息。据说佩戴它的人会在走投无路时发现新的道路。",
	special_desc = function(self) return "能把你从死亡的边缘挽救一次。" end,
}

registerArtifactTranslation{
	originName = "Elemental Fury",
	name = "元素之怒",
	unided_name = "多彩戒指",
	desc = "这枚戒指闪耀着多种不同的色彩。",
	special_desc = function(self) return "你造成的所有伤害被转化均分为奥术、火焰、寒冷和闪电伤害。" end,
}

registerArtifactTranslation{
	originName = "Spellblaze Echoes",
	name = "魔法大爆炸回响",
	unided_name = "深黑色的项链",
	desc = "当你戴上这个古老的项链，似乎耳边仍回荡着魔法大爆炸的回响。",
	["use_power.name"] = function(self, who)
		return ("释放毁灭哀嚎，摧毁地形，造成 %0.2f 物理伤害 (基于魔法) 伤害半径 %d"):format(engine.interface.ActorTalents.damDesc(who, engine.DamageType.PHYSICAL, self.use_power.damage(who)), self.use_power.radius)
	end,
}

registerArtifactTranslation{
	originName = "Feathersteel Amulet",
	name = "失重项链",
	unided_name = "很轻的项链",
	desc = "当你带着这个项链，似乎整个世界都轻飘飘的。",
}

registerArtifactTranslation{
	originName = "Daneth's Neckguard",
	name = "丹纳斯的护颈",
	unided_name = "一个沉重的钢制护颈",
	desc = "一个厚重的钢护喉，旨在保护其穿着者颈部免受致命攻击。这个特殊的护喉是半身人将军丹纳斯·坦德莫恩在派尔纪战争中佩戴过的，上面的各种伤痕表明其可能救过这位将军不止一次。",
}

registerArtifactTranslation{
	originName = "Garkul's Teeth",
	name = "加库尔的牙齿",
	unided_name = "一个用牙齿串成的项链",
	desc = "数以百计的人类牙齿被串在用多股皮革结成的绳索上，组成了这个部落项链。那些牙齿并非吞噬者加库尔自己的，而是来自于加库尔的食物。",
	set_desc = {garkul = "另一件加库尔的遗物将唤醒他的英灵。" },
}

registerArtifactTranslation{
	originName = "Summertide Phial",
	name = "夏日之殇",
	unided_name = "通红的小药瓶",
	desc = "一个小水晶瓶里捕获了夏日的阳光。",
	["use_power.name"] = function(self, who) 
		return ("召唤阳光 (%d强度 ,基于意志 )"):format(self.use_power.litepower(self, who)) 
	end,
}

registerArtifactTranslation{
	originName = "Burning Star",
	name = "灼炎之星",
	unided_name = "燃烧着的宝石",
	desc = "第一个发现如何将日光捕获并注入宝石之中的人是厄流纪的一个半身人大法师。这颗宝石是他们的工艺结晶。光芒从宝石那玲珑剔透的黄色表面放射出来。",
	["use_power.name"] = "揭示周围20码的地形",
}

registerArtifactTranslation{
	originName = "Dúathedlen Heart",
	name = "多瑟顿之心",
	unided_name = "一个暗红色的肉块",
	desc = "这颗暗红色的心脏虽然离开了它的主人，但仍在跳动着。它还会熄灭任何靠近它的光源。",
}

registerArtifactTranslation{
	originName = "Guidance",
	name = "指引者",
	unided_name = "一颗散发着柔和光芒的水晶",
	desc = [[曾经属于魔法狩猎时期的检察官玛库斯·丹。这个拳头大小的石英晶体不断散发出柔和的白光。而且据说对冥想有相当大的帮助，不但可以帮助集中精神、身体，还可以保护持有者的灵魂，并且保护他们免遭邪恶魔法的侵蚀。
似乎只有拥有反魔力量的人才能发挥它的全部潜能。]],
}

registerArtifactTranslation{
	originName = "Blood of Life",
	name = "生命之血",
	unided_name = "血红的药瓶",
	desc = "生命之血！它可以把一个生物复活以防他英年早逝。但是只能用一次！",
	["use_simple.name"] = "喝下生命之血以获得一次额外生命。",
}

registerArtifactTranslation{
	originName = "Thaloren-Tree Longbow",
	name = "精灵树长弓",
	unided_name = "光辉的精灵木长弓",
	desc = "在魔法大爆炸的余波里，自然精灵不得不从敌人和大火中保卫他们的森林。尽管精灵们奋力的抢救它们，许多树还是死掉了。它们的遗体被打造成一张弓用来抵御黑暗的侵袭。",
}

registerArtifactTranslation{
	originName = "Corpsebow",
	name = "腐尸之弓",
	unided_name = "腐朽的长弓",
	desc = "一件黄昏纪遗失的武器，腐尸之弓浑身缠绕着那个时代的瘟疫精华。被腐朽弓弦射出的箭所击中的人，会因古老疾病在体内的共鸣而倍受折磨。",
}

registerArtifactTranslation{
	originName = "Eldoral Last Resort",
	name = "艾德瑞尔的最后手段",
	unided_name = "精良的投石器",
	desc = "投石器的把手上有一段铭文：“愿持有者于对抗黑暗之时被赐予神一般的机智。”",
}

registerArtifactTranslation{
	originName = "Spellblade",
	name = "魔宗利刃",
	unided_name = "光辉的长剑",
	desc = "法师总是时不时冒出古怪的点子。大法师沃利尔曾学会了怎样擎起一柄剑，同时发现自己对耍剑比玩法杖更感冒。",
}

registerArtifactTranslation{
	originName = "Genocide",
	name = "兽人末日·灭族之刃",
	unided_name = "漆黑的剑",
	desc = "法瑞安曾是图库纳国王的指挥官，在最后希望的伟大战役中跟随国王并肩作战。然而，当战争结束，凯旋归来之时，他却发现故乡处处燃烧着兽人的火焰，无边的怒火吞噬了他。复仇的欲望使他离开军队，孤身一人踏上了征程，他除了护甲之外只带了一柄剑。大多数人认为他已经死了。直到有消息称有一个毁灭者般的身影正在摧残兽人的营地，他屠杀了所有见到的兽人并残忍的肢解对方的尸体。据说他每天要用100个兽人的鲜血来祭刀直到杀光马基埃亚尔的兽人。当最后一个兽人被杀死并且没有发现更多的时候，法瑞安最终把利刃转向了自己——那把剑刺穿了他的胸膛。那些在附近的目击者说，当法瑞安这样做的时候身体伴随着阵阵痉挛，他们说不清他到底是哭是笑。",
}

registerArtifactTranslation{
	originName = "Unerring Scalpel",
	name = "精准的解剖刀",
	unided_name = "锋利的长解剖刀",
	desc = "这把解剖刀曾经被可怕的男巫卡·普尔在黄昏纪刚开始学习通灵术时使用。许多人，生物和尸体都成为了他那可怕实验的牺牲品。",
}

registerArtifactTranslation{
	originName = "Eden's Guile",
	name = "艾登的狡诈",
	unided_name = "一双黄色的靴子",
	desc = "这双靴子属于一位流浪的盗贼，他处理麻烦的方法就是三十六计走为上计。",
	["use_power.name"] = function(self, who)
	return ("增加 %d%% 速度(基于灵巧)"):format(100 * self.use_power.speedboost(self, who)) end,
}

registerArtifactTranslation{
	originName = "Fire Dragon Shield",
	name = "火龙之盾",
	unided_name = "龙盾",
	desc = "这个巨大的盾牌使用了很多生活在塔·埃亚尔失落之地的火龙的鳞片打造而成。",
	["on_block.desc"] = "30% 几率对6格内的攻击者 发射具有震慑效果 的火焰吐息",

}

registerArtifactTranslation{
	originName = "Titanic",
	name = "泰坦尼克",
	unided_name = "巨型盾牌",
	desc = "这面用最深邃的蓝锆石打造的盾牌巨大、沉重且相当坚固。",
}

registerArtifactTranslation{
	originName = "Rogue Plight",
	name = "刺客契约",
	unided_name = "破烂的轻皮护甲",
	desc = "盗贼之刃将不能加于装备者之身。",
	special_desc = function(self) 
		return "每 4 回合将一项流血、毒素或伤口效果转移给效果来源或者附近的敌人" 
	end,
}

registerArtifactTranslation{
	originName = "Mummified Egg-sac of Ungolë",
	name = "温格勒的僵化卵囊",
	unided_name = "黝黑的蛋",
	desc = "摸起来又干又脏，它看起来仍旧保存着一些生命的气息。",
	["use_power.name"] = "召唤两个蜘蛛",
}

registerArtifactTranslation{
	originName = "Helm of the Dwarven Emperors",
	name = "矮人王头盔",
	unided_name = "闪光头盔",
	desc = "镶嵌着一颗钻石的矮人头盔，这颗宝石的光辉可以驱散地下一切阴影。",
}

registerArtifactTranslation{
	originName = "Orc Feller",
	name = "兽人砍伐者",
	unided_name = "光辉的匕首",
	desc = "据说在艾德瑞尔战争中，半身人盗贼赫拉在保护一群难民时杀死了100多个兽人。",
}

registerArtifactTranslation{
	originName = "Silent Blade",
	name = "静寂之刃",
	unided_name = "光辉的匕首",
	desc = "一把锋利，阴暗，完全融入了阴影中的匕首。",
}

registerArtifactTranslation{
	originName = "Moon",
	name = "月",
	unided_name = "月牙形匕首",
	desc = "一把弧形的匕首，传说是用取自月亮的材料打造的。它吞噬了周围的光芒，显得黯淡。",
	set_desc = {moon = "没有星星的天空里，月亮显得非常孤单。" }	,
}

registerArtifactTranslation{
	originName = "Star",
	name = "星",
	unided_name = "锯齿短刃",
	desc = "传说之刃，闪耀如星。由取自陨石的材料锻造而成，它散发着光芒。",
	set_desc = {star = "没有月亮的天空里，星星显得非常孤单。" },
}

registerArtifactTranslation{
	originName = "Ring of the War Master",
	name = "战争领主之戒",
	unided_name = "边缘锋利的戒指",
	desc = "散发能量、边缘开刃的戒指。当你戴上它时，陌生的痛苦念头和毁灭的情景涌入你脑海。",
}

registerArtifactTranslation{
	originName = "Voratun Hammer of the Deep Bellow",
	name = "沃瑞钽的咆哮",
	unided_name = "被火烧焦的沃瑞钽之锤",
	desc = "矮人神匠的传奇铁锤。由于年复一年的在高温下打造强力的武器，自身也变的相当强力。",
}

registerArtifactTranslation{
	originName = "Unstoppable Mauler",
	name = "势不可挡之槌",
	unided_name = "重槌",
	desc = "拥有难以想象重量的巨型大槌。挥舞它让你感觉势不可挡。",
}

registerArtifactTranslation{
	originName = "Crooked Club",
	name = "畸形法杖",
	unided_name = "不可思议的棍子",
	desc = "诡异扭曲的法杖，尾部异常沉重。",
}

registerArtifactTranslation{
	originName = "Nature's Vengeance",
	name = "自然的复仇",
	unided_name = "木质粗权杖",
	desc = "这把加粗的权杖曾属于猎魔人沃尔兰，他从一棵在魔法大爆炸中被连根拔起的古老橡树中取材制造了它。众多法师和女巫倒在了这把武器之下，他们对自然犯下的罪行得到了制裁。",
}

registerArtifactTranslation{
	originName = "Spider-Silk Robe of Spydrë",
	name = "斯派德的蛛丝礼服",
	unided_name = "蛛丝礼服",
	desc = "这套礼服完全用蛛丝制成。它看起来充满异国风情，一些智者推测它来自另一个世界，很可能穿越过时空之门。",
}

registerArtifactTranslation{
	originName = "Dragon-helm of Kroltar",
	name = "库洛塔的龙盔",
	unided_name = "龙盔",
	desc = "一个装饰着黄金浮雕的钢铁全盔。库洛塔的头盔上昂立着最伟大的喷火龙作为装饰。",
	set_desc = {kroltar = "库洛塔的力量隐藏在他的鳞片里。" },
}

registerArtifactTranslation{
	originName = "Crown of Command",
	name = "领袖的皇冠",
	unided_name = "无瑕的纯银王冠",
	desc = "半身人国王洛帕曾佩戴这顶王冠，他曾于黄昏纪统治着纳格尔大陆。那是黑暗的年代，国王通过最残暴的手段执行他的命令和法律。任何违背他思想的人都被严厉的惩罚，任何反对他的人都被无情的镇压，这些人大部分都无声无息的消失了——被关进了国王那不计其数的监狱里。所有人都必须表示忠诚或者付出昂贵的代价。他在没有子嗣的情况下死去，皇冠失踪的同时他的国家也陷入了混乱。",
}

registerArtifactTranslation{
	originName = "Gloves of the Firm Hand",
	name = "铁腕之手套",
	unided_name = "沉重的手套",
	desc = "这副手套让你觉得坚如磐石！这双充满魔力的手套从里面摸起来无比松软。在其外，魔法石创造了一个不断转动的粗糙表面。当你振作精神，一束包含大地能量的魔法射线会将它自动扎根在地面上，赋予你更高的稳定性。",
}

registerArtifactTranslation{
	originName = "Dakhtun's Gauntlets",
	name = "达克顿的臂铠",
	unided_name = "精工打造的矮人钢护手",
	desc = "厄流纪由大师级铁匠打造而成。那些矮人钢臂铠镂刻着晦涩难懂的金色符文，据说它们可以赋予穿戴者强大的魔武力量。",
}

registerArtifactTranslation{
	originName = "Fists of the Desert Scorpion",
	name = "沙蝎之拳",
	unided_name = "有着锋利尖刺的拳套",
	desc = [[这只有着锋利尖刺的拳套属于一位派尔纪统治西部荒野的兽人领主，他依靠它们对埃尔瓦拉发动了数次袭击。他外号沙蝎，在战场上所向披靡，他可以用精神力量将敌人拉过来，也可以用拳套把箭矢挡下。通常永恒精灵法师们在死前看到的最后物品，便是这只黄黑相间的拳套残影。最终沙蝎在决斗中，被炼金术师奈瑟莉亚击败。当这副拳套的主人将精灵拉向他，还没来得及将她撕成两半时，精灵掀开了她的长袍——下面捆着的是八十多枚炼金炸弹。精灵指尖的火花，引发了数里外都能看到的大爆炸。直到今天，民间仍流传着奈瑟莉亚为保护她的子民而牺牲的诗歌。]],
}

registerArtifactTranslation{
	originName = "Snow Giant Wraps",
	name = "冰霜巨人护手",
	unided_name = "毛衬里的皮护手",
	desc = "两大块皮革被设计成包裹手和前臂。这副独特的护手经过了附魔，可给予穿戴者巨大的力量。",
	set_desc = {giantset = "如果有一条相衬的腰带就好了。" },
}

registerArtifactTranslation{
	originName = "Mighty Girdle",
	name = "巨人腰带",
	unided_name = "结实而肮脏的腰带",
	desc = "这条腰带被赋予了神秘的魔力来对抗膨胀的腰围。不管它蕴含着的是何种力量，它总是能在你负重不足时助你一臂之力。",
	set_desc = {giantset = "如果有一对大些的手套就好了。" },
}

registerArtifactTranslation{
	originName = "Storm Bringer's Gauntlets",
	name = "风暴使者臂铠",
	unided_name = "细孔臂铠",
	desc = "这副细孔沃瑞钽臂铠被闪烁着蓝色能量的雕文所覆盖。这种金属柔软且轻盈，不会对施法造成阻碍。制造这副手套的时间和地点都是一个谜，但是可以确认的是，制造者对于魔法技术有一定的了解。",
}

registerArtifactTranslation{
	originName = "Serpentine Cloak",
	name = "蛇纹斗篷",
	unided_name = "破碎的斗篷",
	desc = "这件斗篷散发着恶毒和狡诈的气息。",
}

registerArtifactTranslation{
	originName = "Wind's Whisper",
	name = "风之密语",
	unided_name = "流彩斗篷",
	desc = "当魔法师瑞兹恩被猎魔人在岱卡拉的山隘逼入绝境时，她用斗篷包裹着自己逃下了峡谷。猎手们接连不断的把箭射向她，但由于奇迹或是魔法，他们全部射空了。瑞兹恩得以逃生并躲进了西部的隐秘之城。",
}

registerArtifactTranslation{
	originName = "Vestments of the Conclave",
	name = "孔克雷夫法袍",
	unided_name = "破烂的长袍",
	desc = "这件古老的礼服从厄流纪保存了下来。上古的魔法力量占据着它。它由人类专门为人类制造；只有他们才能驾驭这件长袍的真正力量。",
}

registerArtifactTranslation{
	originName = "Firewalker",
	name = "烈焰行者",
	unided_name = "燃烧的长袍",
	desc = "这件炙热的长袍曾属于疯狂的烈焰术士哈克特，他在黄昏纪威胁过很多城镇，正当人们努力从战争中恢复元气的时候，他竟然对城镇烧杀抢掠。最终他被伊格兰斯捕获了。伊格兰斯割下他的舌头，砍掉他的脑袋，并把他的身体撕成小块。他的脑袋被封在一个大冰块里，并且在附近城镇的居民欢庆中进行了游街。只有这件长袍从哈克特的烈焰中保留了下来。",
}

registerArtifactTranslation{
	originName = "Robe of the Archmage",
	name = "大法师的长袍",
	unided_name = "闪闪发光的长袍",
	desc = "朴素的精灵丝绸长袍。如果不是它放射出的惊人威力，它真的毫不起眼。",
}

registerArtifactTranslation{
	originName = "Temporal Augmentation Robe - Designed In-Style",
	name = "时空增益·引领时尚",
	unided_name = "有领带的时髦长袍",
	desc = "被有些古怪的时空法师设计出来，无论穿戴者在哪个时代，这袍子都显得格外时髦。它为协助时空法师冒险而制作。这件法袍对掌握时间多样性的人来说有着巨大的作用。有趣的是，由于它第四任主人参与了一场相当漫长的战斗，长袍上附带了一条很长的幻彩领带。",
	set_desc = {tardis = "奇怪的是，它没有一顶帽子。" },
}

registerArtifactTranslation{
	originName = "Telos's Staff Crystal",
	name = "泰勒斯的法杖水晶",
	unided_name = "闪耀的白水晶",
	desc = "近距离欣赏这颗纯净的白水晶，你会发现很多种颜色在上面盘旋闪耀。",
}

registerArtifactTranslation{
	originName = "Voice of Telos",
	name = "泰勒斯之声",
	unided_name = "闪耀的白色法杖",
	desc = "对这根纯净的白色法杖近距离欣赏会发现很多种颜色在上面盘旋闪耀。",
}

registerArtifactTranslation{
	originName = "Gwai's Burninator",
	name = "戈瓦的燃烧斗志",
	unided_name = "炽热的魔杖",
	desc = "戈瓦，一个生活在魔法狩猎时的火焰术士，她被一群猎魔人逼入了绝境。她战斗至最后一刻，据说在她流尽最后一滴血之前她用这把魔杖干掉了至少十人。",
	["use_power.name"] = function(self, who)
		return ("发射长度 %d 的锥形火焰，造成 %0.2f 火焰伤害（基于魔法）。"):format(self.use_power.radius, engine.interface.ActorTalents.damDesc(who, engine.DamageType.FIRE, self.use_power.damage(self, who)))
	end,
}

registerArtifactTranslation{
	originName = "Crude Iron Battle Axe of Kroll",
	name = "克罗尔的生铁战斧",
	unided_name = "生铁战斧",
	desc = "打造于矮人学会精巧工艺之前，外表的粗糙掩盖了这把斧头的强大威力。不过也只有矮人才能让它发挥出真正的力量。",
}

registerArtifactTranslation{
	originName = "Drake's Bane",
	name = "屠龙",
	unided_name = "凶猛的锋利战斧",
	desc = "库洛塔的噩梦，最强大的龙，7个月的时间她带走了20，000矮人战士的生命。这条猛兽的力气最终被耗尽了，工匠大师格鲁克西姆，站在同伴们尸体的顶端，他用这把精工打造的斧头斩开了龙的鳞甲，剖开了龙的喉咙。",
}

registerArtifactTranslation{
	originName = "Blood-Letter",
	name = "血字",
	unided_name = "冰冷的手斧",
	desc = "用北部荒原的寒冰之核雕成的手斧。",
}

registerArtifactTranslation{
	originName = "Scorpion's Tail",
	name = "猩红毒针",
	unided_name = "合金鞭",
	desc = "一条金属串接的长鞭，尾端锋利的邪恶倒刺渗透着毒液。",
}

registerArtifactTranslation{
	originName = "Rope Belt of the Thaloren",
	name = "自然精灵的绳索腰带",
	unided_name = "一截短绳",
	desc = "最朴素的腰带，被奈希拉·坦泰兰在领导她的人民和森林期间穿戴了几个世纪。这条腰带永久的保存了她的部分智慧和力量。",
}

registerArtifactTranslation{
	originName = "Girdle of Preservation",
	name = "防腐腰带",
	unided_name = "闪烁的完美腰带",
	desc = "一条有着沃瑞钽雕刻标志的皮带扣，用纯白色皮革制作的古朴的腰带。不论时间还是环境都不能对它造成任何损害。",
}

registerArtifactTranslation{
	originName = "Girdle of the Calm Waters",
	name = "静水腰带",
	unided_name = "金色腰带",
	desc = "传说这条腰带曾被孔克雷夫的医师们佩戴。",
}

registerArtifactTranslation{
	originName = "Behemoth Hide",
	name = "巨兽之皮",
	unided_name = "坚韧的风化兽皮",
	desc = "一张取自巨型猛兽的粗制兽皮。鉴于它已经被风吹日晒了这么久还能凑合用用，没准会有一点特别的……",
}

registerArtifactTranslation{
	originName = "Skin of Many",
	name = "人皮",
	unided_name = "缝制的皮甲",
	desc = "缝在一起的许多人皮。有些眼睛和嘴巴依然待在这件袍子上，并且有一些仍然活着，在被酷刑折磨的痛苦中尖啸。",
}

registerArtifactTranslation{
	originName = "Nature's Blessing",
	name = "自然之赐",
	unided_name = "柔韧的皮甲被柳木条缠绕着",
	desc = "曾被守护者亚当穿著，他在魔法战争中首次于人类和半身人之间建立了伊格兰斯。这件护甲被灌注了大自然的能量，并被用来对抗魔法破坏者。",
}

registerArtifactTranslation{
	originName = "Iron Mail of Bloodletting",
	name = "嗜血铁甲",
	unided_name = "刺穿外壳之铁甲",
	desc = "鲜血不断的从这套骇人的铁甲上滴落，几乎可以看得见黑魔法在它的周围流动。胆敢阻挡装备者的人会遭到血腥的毁灭。",
}

registerArtifactTranslation{
	originName = "Scale Mail of Kroltar",
	name = "库洛塔的龙鳞甲",
	unided_name = "用龙甲完美打造的正装",
	desc = "一件用库洛塔的遗物打造的重甲，她的护甲有盾牌的十倍重。",
	set_desc = {kroltar = "库洛塔的头会被这热量唤醒。" },
}

registerArtifactTranslation{
	originName = "Plate Armor of the King",
	name = "国王的板甲",
	unided_name = "隐隐放光的沃瑞钽板甲",
	desc = "精细描绘着国王图库纳为最后的希望浴血奋战的影像。即便是彻头彻尾的恶棍看到它，心底也会充满深深的绝望。",
}

registerArtifactTranslation{
	originName = "Cuirass of the Thronesmen",
	name = "钢铁战士胸甲",
	unided_name = "重型矮人钢护甲",
	desc = "这件沉重的矮人钢护甲打造于钢铁王座最深的熔炉。虽然它被赋予了举世无双的防护能力，但你必须得靠自己的力量使用它。",
}

registerArtifactTranslation{
	originName = "Golden Three-Edged Sword 'The Truth'",
	name = "金色三棱剑·真理",
	unided_name = "三棱剑",
	desc = "有些聪明人说真理是把三刃剑。因为有些时候，“真理”是会伤到人的。",
}

registerArtifactTranslation{
	originName = "Ureslak's Femur",
	name = "乌尔斯拉克的大腿",
	unided_name = "染的稀奇古怪的骨头",
	desc = "强大的棱晶龙乌尔斯拉克被截断的腿骨，这根奇怪的棍子仍然流动着乌尔斯拉克的天性。",
	set_desc = {ureslak = "当乌尔斯拉克更多遗物聚集在一起时 ，会发生什么呢？",},
}
registerArtifactTranslation{
	originName = "Ureslak's Molted Scales",
	name = "乌尔斯拉克之皮",
	unided_name = "多彩鳞甲",
	desc = "这件长袍用某些大型爬行动物的鳞片制成。它看上去可以反射出彩虹的每种颜色。",
	set_desc = {ureslak = "当乌尔斯拉克更多遗物聚集在一起时 ，会发生什么呢？",},
	["use_power.name"] = function(self, who)
			local resists={"火焰", "寒冷", "闪电", "自然", "黑暗"}
			if self.set_complete then table.insert(resists, "奥术") end
			return ("为鳞片充能16回合，让你在受 %s 伤害前增加相应抗性15%%，持续5回合，只对一种伤害生效。"):format(table.concatNice(resists, ", ", ", or "))
		end,
}

registerArtifactTranslation{
	originName = "Razorblade, the Cursed Waraxe",
	name = "剃刀·诅咒战斧",
	unided_name = "剃刀战斧",
	desc = "这把强力的斧头可以像剑一样劈开护甲，却能造成如同钝器一般的重击。据说持有者会慢慢变得疯狂。这个，不管怎样，从来没有被证实过——没有任何持有者能活到揭开真相。",
}

registerArtifactTranslation{
	originName = "Sword of Potential Futures",
	name = "进化之剑",
	unided_name = "未完工的剑",
	desc = "传说这把长剑是一对兵器中的其中一个；这对兵器打造于瓦登斯最初的年代。对于未经训练的持有者来说它还不是那么完善；对于时空守卫来说，它将随着时间展现威力。",
	set_desc = {twsword = "过去有柄匕首和它成套" },
}

registerArtifactTranslation{
	originName = "Dagger of the Past",
	name = "历练之匕",
	unided_name = "锈蚀的匕首",
	desc = "传说这把匕首是一对兵器中的一个；这对兵器打造于瓦登斯最初的年代。对于未经训练的持有者来说它还不是那么完善；对于时空守卫来说，它表示着从以前的失误中吸取教训的机会。",
	set_desc = {twsword = "未来可能有把剑和它成套" },
}

registerArtifactTranslation{
	originName = "Witch-Bane",
	name = "巫师毁灭者",
	unided_name = "象牙柄沃瑞钽长剑",
	desc = "一把沃瑞钽长剑，象牙的剑柄被紫色的布包裹着。这把兵器的传奇性跟它上一任拥有者玛库斯·丹差不多了，人们都以为这把剑在魔法狩猎末期玛库斯被害的时候被摧毁了。",
}

registerArtifactTranslation{
	originName = "Stone Gauntlets of Harkor'Zun",
	name = "哈克祖的岩石臂铠",
	unided_name = "黑曜石臂铠",
	desc = "古时候由哈克祖的狂热崇拜者制作，这副花岗岩臂铠被设计为可以保护穿戴者免于遭受黑暗之主的暴怒。",
}

registerArtifactTranslation{
	originName = "Unflinching Eye",
	name = "怒视之眼",
	unided_name = "充血的眼球",
	desc = "有人用一条黑色的粗线穿过这颗充血的眼球，把它挂在脖子上。你也应该这样做。",
}



registerArtifactTranslation{
	originName = "Pick of Dwarven Emperors",
	name = "矮人皇帝的十字镐",
	unided_name = "生铁之十字镐",
	desc = "这把古老的十字镐被用来一代代的往下传颂矮人的传奇。从镐头到镐把每一寸都覆盖着记述矮人故事的诗歌。",
}

registerArtifactTranslation{
	originName = "Staff of Arcane Supremacy",
	name = "至尊法杖",
	unided_name = "银色符文法杖",
	desc = "一根又细又长的法杖，由远古龙骨制成，它通体铭刻着银色的符文。它会发出微弱的嗡嗡声，似乎有一股强大的力量被锁在了里面，整体来看，它似乎是不完整的。",
	set_desc = {channelers = "只有理解奥术才能完全使用它的力量。" },
}

registerArtifactTranslation{
	originName = "Hat of Arcane Understanding",
	name = "奥术理解之帽",
	unided_name = "银色符文帽子",
	desc = "一只传统巫师的尖帽子，由紫色的精灵丝绸制成，上面还有亮银色的装饰物。你意识到它来自远古时代，一个拥有众多伟大法师的时代。通过触摸你可以感受到远古的知识和能量，但仍有一部分被密封着，等待有缘人来释放它。",
	set_desc = {channelers = "只有奥术至尊才能完全发挥它的力量  。" },
}

registerArtifactTranslation{
	originName = "Quiver of the Sun",
	name = "日冕箭壶",
	unided_name = "发光的箭壶",
	desc = "这个奇特的橙色箭壶由黄铜制成，在阳光下，你可以看到壶身铭刻着许多亮红色的发光符文。箭矢似乎配有燃烧的箭杆，就像被锻造过的阳光。",
}

registerArtifactTranslation{
	originName = "Blightstopper",
	name = "枯萎终结者",
	unided_name = "藤蔓覆盖的盾牌",
	desc = "这块沃瑞坦盾牌表面被厚实的藤蔓所缠绕，其中注入了许多年前的半身人将军阿尔曼达·鲁伊尔的自然力量，他在派尔之战中用这个盾牌驱散了兽人堕落者的魔法疫病。",
	["use_power.name"] = function(self, who)
		local effpower = self.use_power.effpower(self, who)
		return ("除去至多 %d 项疾病（基于意志 ) 并获得疾病免疫、%d%% 枯萎抗性和 %d  法术豁免 5 回合。"):format(self.use_power.nbdisease(self, who), effpower, effpower)
	end,
}

registerArtifactTranslation{
	originName = "Star Shot",
	name = "星辰弹",
	unided_name = "闪光的弹药",
	desc = "子弹中放射出极高的热量。",
}

registerArtifactTranslation{
	originName = "Nexus of the Way",
	name = "维网之核",
	unided_name = "闪耀的绿色灵晶",
	desc = "巨大的意念力在这颗宝石之中回响，仅仅轻触就可以让你获得无穷的力量和无限的思维。",
}

registerArtifactTranslation{
	originName = "Amethyst of Sanctuary",
	name = "紫水晶的庇护",
	unided_name = "深紫色灵晶",
	desc = "这颗明亮的紫色宝石渗透出宁静、专注的力量，当你紧握它时，你可以感受到它保护你与外界力量隔绝。",
}

registerArtifactTranslation{
	originName = "Sceptre of the Archlich",
	name = "死灵权杖",
	unided_name = "白骨雕刻的权杖",
	desc = "这根权杖上有古老焦黑的白骨雕刻，镶嵌着一颗黑曜石，你感受到里面有一股黑暗力量呼之欲出。",
	set_desc = {archlich = "它渴望被亡灵围绕。" },
}

registerArtifactTranslation{
	originName = "Oozing Heart",
	name = "史莱姆之心",
	unided_name = "粘糊糊的灵晶",
	desc = "这只灵晶在不断的向外渗出粘糊糊的液体。魔法似乎消逝在它周围。",
}

registerArtifactTranslation{
	originName = "Bloomsoul",
	name = "夏花之魂",
	unided_name = "鲜花覆盖的灵晶",
	desc = "纯洁的花瓣覆盖着灵晶，当你触摸它时你感受到宁静和清新。",
}

registerArtifactTranslation{
	originName = "Gravitational Staff",
	name = "重力之杖",
	unided_name = "沉重的法杖",
	desc = "法杖的尖端时空似乎陷入了扭曲。",
}

registerArtifactTranslation{
	originName = "Eye of the Wyrm",
	name = "七彩龙之眼",
	unided_name = "多彩的灵晶",
	desc = "灵晶的核心穿过一道彩虹，投射出七色的光芒，不断变换着颜色。",
	set_desc = {wyrm = "七彩龙之眼寻求一种元素。" },
}

registerArtifactTranslation{
	originName = "Great Caller",
	name = "伟大的召唤师",
	unided_name = "吟唱的灵晶",
	desc = "这只灵晶不断的发出低鸣，你感觉到生命能量似乎在向它聚拢。",
}

registerArtifactTranslation{
	originName = "Corrupted Gaze",
	name = "堕落凝视",
	unided_name = "黑色的遮面盔",
	desc = "这顶头盔散发着黑暗的力量。它似乎能够扭曲和腐化装备者的视觉。你不能穿戴它太长时间，以免堕入魔道。",
}

registerArtifactTranslation{
	originName = "Umbral Razor",
	name = "影之刃",
	unided_name = "黝黑的匕首",
	desc = "这只匕首覆盖着一层纯净的阴影，并且似乎有一团瘴气围绕着它。",
}

registerArtifactTranslation{
	originName = "Emblem of Evasion",
	name = "闪避徽记",
	unided_name = "镶金的纹饰腰带",
	desc = "据说它曾属于一位闪避大师，这根镀金的腰带部分的保存了他的能力。",
}

registerArtifactTranslation{
	originName = "Surefire",
	name = "神火",
	unided_name = "制作精良的弓",
	desc = "这把做工精良的弓相传由一位不知名的大师打造。当你拉动弓弦时，你能感受到这把弓蕴藏着难以置信的力量。",
}

registerArtifactTranslation{
	originName = "Frozen Shards",
	name = "冰极碎",
	unided_name = "一袋水晶质的冰弹",
	desc = "在这个深蓝色的袋子里，躺着许多冰晶弹。一团奇异的冰雾环绕着它们，当你触摸它们时，你感到刺骨的凉意。",
}

registerArtifactTranslation{
	originName = "Stormlash",
	name = "风暴之鞭",
	unided_name = "缠绕着电弧的鞭子",
	desc = "这根钢质的鞭子缠绕着许多电弧。你可以感受这根鞭子上散发出的力量强大且不可控制。",
	["use_power.name"] = function(self, who)
		local dam = who:damDesc(engine.DamageType.LIGHTNING, self.use_power.damage(self, who))
		return ("攻击距离 %d 内的敌人，造成 100%% 闪电武器伤害并在半径 %d 内释放电弧，造成 %0.2f 到 %0.2f 点闪电伤害 ( 基于魔法和敏捷)")
		:format(self.use_power.range, self.use_power.radius, dam/3, dam)
	end,
}

registerArtifactTranslation{
	originName = "Focus Whip",
	name = "聚灵鞭",
	unided_name = "镶有宝石的柄",
	desc = "这只手柄上镶有一颗小小的灵晶。当你触摸它时，一根半透明的绳子浮现在你面前，并随着你的意志闪烁。",
}

registerArtifactTranslation{
	originName = "Latafayn",
	name = "焱剑·拉塔法",
	unided_name = "附着火焰的巨剑",
	desc = "这只沉重的、火焰覆盖的巨剑，是黄昏纪中，英雄科斯汀·赫菲因偷来。这把剑曾经属于一个强大的恶魔，赤红之弗朗拉尔。它炽热的火焰怒吼着，仿佛可以焚烧万物。",
	["use_power.name"] = function(self, who) 
		return ("加速半径 %d 范围内的所有燃烧效果，范围 %d, 立刻造成 125%% 剩余燃烧伤害。")
		:format(self.use_power.radius(self, who), self.use_power.range(self, who)) 
		end,
}

registerArtifactTranslation{
	originName = "Robe of Force",
	name = "灵能长袍",
	unided_name = "无风自动的长袍",
	desc = "这件薄薄的长袍被一团神秘的精神力量所包围。",
	["use_power.name"] = function(self, who)
		local dam = who:damDesc(engine.DamageType.PHYSICAL, self.use_power.damage(self, who))
		return ("发射长度 %d 的动能射线，造成 %0.2f 到 %0.2f 点物理击退伤害（基于意志和灵巧）"):format(self.use_power.range, 0.8*dam, dam) 
		end,
}

registerArtifactTranslation{
	originName = "Serpent's Glare",
	name = "蛇灵怒视",
	unided_name = "泛着绿光的宝石",
	desc = "凝厚的毒液不断地从这个灵晶上滴落。",
}

registerArtifactTranslation{
	originName = "The Inner Eye",
	name = "心眼",
	unided_name = "镶嵌有独眼的帽子",
	desc = "这只嵌有独眼的皮帽，据说可以让使用者感知周围的人，代价是你的视觉。你怀疑在使用这件帽子后视力会需要很长的时间来恢复。",
}

registerArtifactTranslation{
	originName = "Corpathus",
	name = "束缚之剑·卡帕萨斯",
	unided_name = "被束缚的长剑",
	desc = "这把剑被厚重的带所束缚。两排锯齿状的锋刃沿着剑身直到剑柄，它试图挣脱带子的束缚，但似乎缺乏足够的力量。",
}

registerArtifactTranslation{
	originName = "Anmalice",
	name = "扭曲之刃·圣灵之眼",
	unided_name = "扭曲的利刃",
	desc = "剑柄上的眼睛似乎直视着你，试图撕裂你的灵魂。剑柄上环绕的触手可以使其很好的固定在你手上。",
}

registerArtifactTranslation{
	originName = "Hydra's Bite",
	name = "三头龙之牙",
	unided_name = "有三个头的连枷",
	desc = "这把三头的蓝锆石连枷，使用的是一只三头龙的力量。它的攻击可以伤害到周围的所有敌人。",
}

registerArtifactTranslation{
	originName = "Spellhunt Remnants",
	name = "魔法狩猎遗物",
	unided_name = "破旧的沃瑞钽臂铠",
	desc = "你从这副锈迹斑斑的臂铠上勉强能看出其曾经的辉煌。它起源于魔法狩猎时期，用于摧毁奥术类装备，以惩罚法师们对这个世界的暴行。",
}

registerArtifactTranslation{
	originName = "Merkul's Second Eye",
	name = "米库尔的第二只眼",
	unided_name = "丝弦光滑的弓",
	desc = "这把弓据说属于一位臭名昭著的矮人间谍。更有传言称，这把弓能帮助他利用所有敌人的眼睛。被射中的敌人虽然不会丧命，但却没有意识到自己的眼睛已经把周围的秘密全都泄漏给了他。",
}

registerArtifactTranslation{
	originName = "Mirror Shards",
	name = "镜影碎片",
	unided_name = "镶有锁链的镜片",
	desc = "据说是由一位强大的魔法师在他的家园被猎魔行动的暴民摧毁后制造。虽然他逃脱了追捕，但是他的财产都被破坏和烧毁殆尽。当他回去时，发现家里已成废墟，墙上的斑驳和地上的碎片说明了这里曾遭到怎样的劫难。最终，他捡起了其中一块镜子残片，将其做成了这副项链。",
	["use_power.name"] = function(self, who) 
		return ("制造反射护盾（50%%反射率， %d 吸收量，基于魔法) 持续5 回合。"):format(self.use_power.shield(self, who)) 
		end,
}

registerArtifactTranslation{
	originName = "Summertide",
	name = "夏夜",
	unided_name = "闪光的金色盾牌",
	desc = "从这面盾牌的中心放射出耀眼的光芒，当你紧握这面盾牌时，你的思维变得清晰。",
	["use_power.name"] = function(self, who)
		local dam = who:damDesc(engine.DamageType.LIGHT, self.use_power.damage(self, who))
		return ("发射长度 %d 的射线，照亮路径，并造成  %0.2f 到 %0.2f 点光系伤害   ( 基于意志和灵巧 )"):format(self.use_power.range, 0.8*dam, dam)
	end,
}

registerArtifactTranslation{
	originName = "Wanderer's Rest",
	name = "旅者的休憩",
	unided_name = "没有重量的靴子",
	desc = "这双靴子几乎没有重量，触摸它，你觉得身上的重担一下子减轻了许多。",
}

registerArtifactTranslation{
	originName = "Silk Current",
	name = "流波法袍",
	unided_name = "平滑的法袍",
	desc = "这件深蓝色的法袍荡起涟漪，仿佛有一股看不见的浪潮在涌动。",
}

registerArtifactTranslation{
	originName = "Skeletal Claw",
	name = "白骨之握",
	unided_name = "连着骨爪的鞭子",
	desc = "这根鞭子看上去像是人类的脊骨做成，一端有一个柄，另一端是一个磨光的爪子。",
}

registerArtifactTranslation{
	originName = "Core of the Forge",
	name = "熔炉之核",
	unided_name = "灼热的灵晶",
	desc = "这块灼热发光的灵晶有节奏地律动着，每次攻击会放出一波热量。",
}

registerArtifactTranslation{
	originName = "Piercing Gaze",
	name = "锐利目光",
	unided_name = "刻有岩石眼的盾牌",
	desc = "这个巨大的盾牌上嵌有一个石质的眼睛",
}

registerArtifactTranslation{
	originName = "Shantiz the Stormblade",
	name = "风暴之刃",
	unided_name = "很薄的短刃",
	desc = "这柄超现实的匕首周围环绕有强大的风暴",
}

registerArtifactTranslation{
	originName = "The Calm",
	name = "宁静",
	unided_name = "华丽的绿色长袍",
	desc = "这件绿色长袍上刻有云朵和漩涡。它最初的主人，大法师普偌卡拉，因其善行和力量被人们敬畏",
}

registerArtifactTranslation{
	originName = "Borosk's Hate",
	name = "博瑞思科的仇恨",
	unided_name = "双刃剑",
	desc = "这柄剑令人印象深刻，因为它有两个平行刀锋。",
}

registerArtifactTranslation{
	originName = "Windborne Azurite",
	name = "风之铜蓝",
	unided_name = "微风环绕的宝石",
	desc = "空气在这块亮蓝色宝石周围旋转。",
}

registerArtifactTranslation{
	originName = "Primal Infusion",
	name = "原初之纹身",
	unided_name = "有活力的纹身",
	desc = "这个纹身已经进化了",
}

registerArtifactTranslation{
	originName = "Swordbreaker",
	name = "破剑匕",
	unided_name = "带锯齿的匕首",
	desc = "这柄普通的匕首是由精制坚硬的沃瑞坦制成的，配有锯齿钩边。看似平凡的外表背后潜藏着强大的力量——它破坏过诸多刀刃，收割走那些战士的生命和未来。",
}

registerArtifactTranslation{
	originName = "Shieldsmaiden",
	name = "女武神之心",
	unided_name = "冰冻的盾",
	desc = "传说中的女武神，来自马基埃亚尔世界的北方荒地。她的美貌和力量吸引了众多爱慕者前去，然而所有人都空手而归。因此，有这样一句谚语：女武神的心同她的盾一样冰冷而不可打破。",
}

registerArtifactTranslation{
	originName = "Tirakai's Maul",
	name = "提瑞卡之锤",
	unided_name = "锤子",
	desc = "这柄巨型锤子是用一种厚厚的古怪结晶体制成的，锤子里面能看到一个空槽，似乎很容易就能将宝石放进去。",
}

registerArtifactTranslation{
	originName = "Fist of the Destroyer",
	name = "毁灭者之拳",
	unided_name = "邪恶的手套",
	desc = "这对手套看上去十分恐怖，闪耀着不明能量。",
	set_desc = {destroyer = "只有受虐狂才能解锁它的能量." },
}

registerArtifactTranslation{
	originName = "Masochism",
	name = "受虐狂",
	unided_name = "破损的衣物",
	desc = "窃取血肉,\n窃取苦痛,\n舍弃本我,\n秽尸复苏。",
	set_desc = {masochism = "如果有更好的掌控力，它将摧毁敌人。" },
}

registerArtifactTranslation{
	originName = "Obliterator",
	name = "抹杀者",
	unided_name = "巨型锤子",
	desc = "这柄巨大的锤子挥击时拥有能粉碎骨头的巨力。",
}

registerArtifactTranslation{
	originName = "Champion's Will",
	name = "冠军意志",
	unided_name = "一把发出炫目光芒的剑",
	desc = "初看这把外形令人印象深刻的长剑，最先吸引你目光的是雕刻在剑柄之中的金色太阳。而蚀刻在剑刃之上的复杂的符文仿佛在告诉你，只有真正掌握自己肉体和精神力量之人才能发挥出这把武器的最大威力。",
	["use_power.name"] = function(self, who) 
		return ("攻击长度为 %d 的直线上所有目标 , 造成 100%% 光系武器伤  害,  并将 50%% 伤害转化为治疗。"):format(self.use_power.range) 
		end,
}

registerArtifactTranslation{
	originName = "Tarrasca",
	name = "泰拉斯奎巨铠",
	unided_name = "一件荒诞般巨大的铠甲",
	desc = "这件结实硕大的板甲有着夸张的体积和难以想象的重量。相传这件板甲属于一位不知名的士兵，为了抵御洪水般的兽人军团入侵他的家乡，这名士兵守护在通向他村庄的大桥上。经过几天几夜惨烈的进攻，兽人没能击倒他，最终敌人撤退了。而这名传奇般的士兵，也因为精疲力竭当场倒毙，这件盔甲最终夺去了他的生命。",
}

registerArtifactTranslation{
	originName = "Aetherwalk",
	name = "以太漫步者",
	unided_name = "飘渺的靴子",
	desc = "一圈紫色光环围绕着这双半透明的黑色靴子。",
}

registerArtifactTranslation{
	originName = "Colaryem",
	name = "克拉伊姆·飞翔之剑",
	unided_name = "漂浮的剑",
	desc = "这把长得不可思议的剑几乎和人一样宽，与其巨大尺寸格格不入的是，它的重量极轻，而且似乎总想要从你的手中飞走一样。要么足够强壮，要么足够高大，你才能握紧这剑，防止其飞走。",
}

registerArtifactTranslation{
	originName = "Void Quiver",
	name = "虚空箭壶",
	unided_name = "飘渺的箭壶",
	desc = "这个深黑色的箭壶中可以源源不断的抽出箭矢，它的表面闪烁着点点微光。",
}

registerArtifactTranslation{
	originName = "Hornet Stingers",
	name = "黄蜂尾钉",
	unided_name = "镶着尖刺的箭矢",
	desc = "箭矢的尖端滴落着剧毒。",
	["combat.special_on_hit.desc"] = "使目标中毒， 每回合造成20伤害， 使用技能有20%几率失败， 持续6回合。",
	
}

registerArtifactTranslation{
	originName = "Umbraphage",
	name = "安布瑞吉·暗影吞噬者",
	unided_name = "深黑色的灯笼",
	desc = "这个灰白色水晶制成的灯笼周围笼罩着一片黑暗，但是它仍放射着光芒。光之所在，黑暗尽除。",
	special_desc = function(self) 
		return ("在光照范围内吸收所有黑暗(强度 %d,基于意志和灵巧) 并增加亮度. (当前增幅： %d).")
		:format(self.worn_by and self.use_power.litepower(self, self.worn_by) or 100, self.charge) 
	end,
	["use_power.name"] = function(self, who)
		local dam = who:damDesc(engine.DamageType.DARKNESS, self.use_power.damage(self, who))
		return ("在 %d 码的锥形范围内释放吸收的黑暗，有 %d%% 几率致盲（基于光照半径） , 并造成 %0.2f 暗影伤害 ( 基于精神强度和吸收量)"):format(self.use_power.radius(self, who), self.use_power.blindchance(self, who), dam)
	end,
}

registerArtifactTranslation{
	originName = "Spellblaze Shard",
	name = "魔爆碎片",
	unided_name = "水晶匕首",
	desc = "这块锯齿状的水晶放射出异常的亮光，它的一端绑着几圈布条当作握把。",
}

registerArtifactTranslation{
	originName = "Spectral Cage",
	name = "幽灵牢笼",
	unided_name = "天蓝色的灯笼",
	desc = "这个古老、褪色的灯笼放射出淡蓝色的光芒。它的金属表面摸上去像冰一样冷。",
}

registerArtifactTranslation{
	originName = "The Guardian's Totem",
	name = "守卫者图腾",
	unided_name = "损坏的石头图腾",
	desc = "这个古老的石制图腾的石缝里不断涌出粘液。尽管如此，你仍能感受到它的巨大能量。",
}

registerArtifactTranslation{
	originName = "Cloth of Dreams",
	name = "梦幻披风 ",
	unided_name = "破烂的披风",
	desc = "当你触摸这件超脱尘俗的披风时你既觉得昏昏欲睡又十分清醒。",
}

registerArtifactTranslation{
	originName = "Void Shard",
	name = "虚空碎片",
	unided_name = "奇怪的锯齿状碎片",
	desc = "这个锯齿状的影像看上去像是时空中的黑洞，但它又是固态的，尽管重量非常的轻。",
	["use_power.name"] = function(self, who)
		local dam = self.use_power.damage(self, who)/2
		return ("在 %d 码范围内释放虚空能量，至多距离 %d。造成 %0.2f 时空和 %0.2f 暗影伤害。(基于魔法)"):format(self.use_power.radius, self.use_power.range, who:damDesc(engine.DamageType.TEMPORAL, dam), who:damDesc(engine.DamageType.DARKNESS, dam))
	end,
}

registerArtifactTranslation{
	originName = "Thalore-Wood Cuirass",
	name = "精灵木胸甲",
	unided_name = "厚木板甲",
	desc = "由树皮制成，做工相当精巧，重量很轻，却能提供很好的防护。",
}

registerArtifactTranslation{
	originName = "Coral Spray",
	name = "云雾珊瑚",
	unided_name = "厚重的珊瑚板甲",
	desc = "用大块的珊瑚制成，源自大海深处。",
	["on_block.desc"] = "30% 几率朝目标喷射4格锥形冰冷的水流。", 
}

registerArtifactTranslation{
	originName = "Shard of Insanity",
	name = "狂乱碎片",
	unided_name = "损坏的黑色项链",
	desc = "从这条损坏的黑色项链上放出暗红色的光亮，当你触摸它时，你能听到脑海里的窃窃私语。",
}

registerArtifactTranslation{
	originName = "Pouch of the Subconscious",
	name = "欲望之核",
	unided_name = "常见的弹药袋",
	desc = "你情不自禁的想使用这袋弹药。",
	["combat.special_on_hit.desc"] = "50%% 几率回复一颗子弹。",
}

registerArtifactTranslation{
	originName = "Wind Worn Shot",
	name = "风化弹",
	unided_name = "极其光滑的弹药",
	desc = "这些白色的弹丸似乎饱经风霜。",
}

registerArtifactTranslation{
	originName = "Spellcrusher",
	name = "奥术摧毁者",
	unided_name = "藤蔓覆盖的锤子",
	desc = "这柄巨大的铁制巨锤，其手柄上覆盖着一层厚厚的藤蔓。",
}

registerArtifactTranslation{
	originName = "Telekinetic Core",
	name = "念力之核",
	unided_name = "沉重的项圈",
	desc = "这副沉重的项圈将周围的所有物体拉向它。",
}

registerArtifactTranslation{
	originName = "Spectral Blade",
	name = "幽灵之刃",
	unided_name = "虚幻的剑",
	desc = "这把剑飘渺无形。",
}

registerArtifactTranslation{
	originName = "Crystle's Astral Bindings",
	name = "众星之握",
	unided_name = "水晶手套",
	desc = "相传这副手套曾属于一位不知名的星月法师。无数的星辰从这副手套的表面反射出来，显得超凡脱俗。",
}

registerArtifactTranslation{
	originName = "Prothotipe's Prismatic Eye",
	name = "普罗斯泰普的七彩之眼",
	unided_name = "损坏的傀儡之眼",
	desc = "这枚损坏的宝石看起来似乎有一定的年月了。种种迹象表面它曾经是某个傀儡的眼珠。",
}

registerArtifactTranslation{
	originName = "Plate of the Blackened Mind",
	name = "堕落灵魂之甲",
	unided_name = "黑色胸甲",
	desc = "这件黑色的胸甲吸收了附近的所有光线。你能感受到其中沉睡着一股邪恶的力量。当你触摸它时，你感到黑暗的思想在不断的涌现在你的脑海。",
}

registerArtifactTranslation{
	originName = "Tree of Life",
	name = "生命之树",
	unided_name = "树状的图腾",
	desc = "你能在这根小巧的树状图腾上感受到强大的治愈能量。",
}

registerArtifactTranslation{
	originName = "Ring of Growth",
	name = "生命之戒",
	unided_name = "藤蔓缠绕的戒指",
	desc = "这枚小巧的戒指上缠绕着一根藤蔓，藤蔓似乎仍然在不断的吐出新叶。",
}

registerArtifactTranslation{
	originName = "Wrap of Stone",
	name = "石化风衣",
	unided_name = "石头斗篷",
	desc = "尽管这件石头斗篷又硬又厚，但是你仍能轻松的折叠它。",
}

registerArtifactTranslation{
	originName = "Death's Embrace",
	name = "死亡拥抱",
	unided_name = "黑色的皮甲",
	desc = "这件黑色的皮甲上覆盖着一层厚厚的丝绸，触感冰凉。",
	["use_power.name"] = function(self, who) 
		return ("隐形10回合(强度%d, 基于灵巧和魔法）"):format(self.use_power.invispower(self, who)) 
		end,
}

registerArtifactTranslation{
	originName = "Breath of Eyal",
	name = "埃亚尔的呼吸",
	unided_name = "薄薄的绿色护甲",
	desc = "这件护甲由数以千计的豆芽缠绕编成，豆芽们仍在不停的生长缠绕。尽管在你手里很轻，但当穿上它时，你感觉到肩上那世界一般的重量。",
}

registerArtifactTranslation{
	originName = "Eternity's Counter",
	name = "永恒沙漏",
	unided_name = "水晶沙漏",
	desc = "这只漂亮的沙漏里装载着数以千计的宝石，用以代替沙子。当它们落下时，你能够感受到时间的变化。",
	["use_power.name"] = function(self, who) 
		return ("反转沙漏 (沙子当前流向 %s)"):format(self.direction > 0 and "稳定" or "熵") 
		end,
}

registerArtifactTranslation{
	originName = "Malslek the Accursed's Hat",
	name = "马斯拉克·诅咒之帽",
	unided_name = "黑色的烧焦帽子",
	desc = "这顶黑色的帽子曾属于一名强大的法师马斯拉克，在黄昏纪时以交游位面之广而著称。值得一提的是，他还与许多恶魔进行了交易。直到某一天，一名恶魔厌烦了契约的约束而背叛了他并偷走了马斯拉克的力量。马斯拉克一气之下烧毁了自己的高塔，意图杀死这只恶魔。最终，废墟中只剩下了这顶帽子流传至今。",
}

registerArtifactTranslation{
	originName = "Fortune's Eye",
	name = "幸运之眼",
	unided_name = "金色望远镜",
	desc = "这副精致的望远镜曾属于一位著名的冒险家和探险家科斯汀·赫菲因。有此宝在手，赫菲因遍历了整个马基埃亚尔大陆，在他死前据说他搜集了许多宝贵的财富。他相信这副望远镜能带给他好运，有此物在手，无论面对任何险境，都能死里逃生。相传，他死于一名恶魔的报复，报复他偷走了恶魔私藏的一把剑。海风留给世间的最后遗言是——想要我的财富吗？那就去找吧，我的一切都在那里，大幕才刚刚拉开。",
}

registerArtifactTranslation{
	originName = "Anchoring Ankh",
	name = "稳固十字架",
	unided_name = "发光的十字架",
	desc = "当你举起这个十字架时你觉得异常的稳定。你感到周围的世界也变的更加稳定了。",
}

registerArtifactTranslation{
	originName = "Ancient Tome titled 'Gems and their uses'",
	name = "远古之书《宝石之秘》",
	unided_name = "远古之书",
	desc = "",
}

registerArtifactTranslation{
	originName = "Scroll of Summoning (Limmir the Jeweler)",
	name = "召唤卷轴（召唤珠宝匠利米尔）",
	unided_name = "",
	desc = "",
}

registerArtifactTranslation{
	originName = "Pendant of the Sun and Moons",
	name = "日月垂饰",
	unided_name = "一个闪烁着金色灰色的垂饰",
	desc = "一个小小的垂饰，雕刻着红月吞日的图案。传说其主人是太阳堡垒的建立者之一。",
}

registerArtifactTranslation{
	originName = "Unsetting Sun",
	name = "永恒光辉",
	unided_name = "闪耀着金色光芒的盾牌",
	desc = "当冲锋队队长艾米奥·帕纳森为他的遇难船员们寻求庇护所的时候，他的盾牌反射着落日的光辉。他们在光辉照耀的地方休息宿营，之后太阳堡垒在那里成立。在随后那些暗无天日的日子里，这面盾牌被人们当做美好未来希望的象征。",
	set_desc = {dawn = "在黎明下闪耀光芒。" },
}

registerArtifactTranslation{
	originName = "Scorched Boots",
	name = "烧焦的长靴",
	unided_name = "一双熏黑的靴子",
	desc = "血魔导师鲁·克汉是派尔纪第一个使用夏·图尔远程传送门进行试验的兽人。试验不是很成功，能量爆炸后，只剩下了一双烧焦的靴子。",
}

registerArtifactTranslation{
	originName = "Goedalath Rock",
	name = "高达勒斯之石",
	unided_name = "神秘的黑色石头",
	desc = "这块小石头看起来不是这个世界的，它不时产生着激烈的能量震动，让人感到扭曲、可怕、邪恶……而又强大的能量。",
}

registerArtifactTranslation{
	originName = "Threads of Fate",
	name = "命运之弦",
	unided_name = "一件闪着微光的白色斗篷",
	desc = "这件精致的白色斗篷由异界材料制成，随光线变化而闪烁，永恒如新。",
}

registerArtifactTranslation{
	originName = "Blood-Edge",
	name = "饮血剑",
	unided_name = "红色的水晶剑",
	desc = [[这把深红色的剑不断的向下滴血。它诞生于兽人堕落者胡里克的实验室。最初，胡里克寻找了一枚水晶来制造他的命匣，但他的计划很快被一群太阳骑士打断，尽管大部分骑士死于不死军团的阻拦，但骑士团团长瑞苏尔却单枪匹马杀入了胡里克的实验室。在那里，两位强者展开了对决，利剑与血魔法你来我往，直到他们都重伤倒地。兽人想拼尽最后一分力气，拿到他的命匣，希望能拯救自己，但是瑞苏尔识破了他的阴谋，将浸满鲜血的利剑掷向了命匣。命匣破碎的瞬间，胡里克的灵魂和利剑以及水晶融为了一体。
现在，残存的胡里克灵魂被困在了这件可怕的武器中，他的思维因数十年的监禁而扭曲。只有鲜血的味道能引起他的兴奋，他的灵魂在不断的侵蚀他人的血肉，希望有朝一日能够重组自我，摆脱这痛苦的存在形式。]],
}

registerArtifactTranslation{
	originName = "Dawn's Blade",
	name = "黎明之刃",
	unided_name = "闪光的长剑",
	desc = "传说是在太阳堡垒成立之初打造，这把长剑闪耀着黎明破晓之光，可以破除一切黑暗。",
	["use_power.name"] = function(self, who) 
		return ("激发黎明的光芒，在半径 %d 内造成 %0.2f 光系伤害（基于魔法），并照明 %d 码。")
		:format(self.use_power.radius, engine.interface.ActorTalents.damDesc(who, engine.DamageType.LIGHT, self.use_power.damage(who)), self.use_power.radius*2) end,
	set_desc = {dawn = "如果太阳永不落山，黎明的光辉将永恒。" },
}

registerArtifactTranslation{
	originName = "Zemekkys' Broken Hourglass",
	name = "伊莫克斯的破沙漏",
	unided_name = "坏掉的沙漏",
	desc = "这个坏掉的小沙漏系在一根金子做的细链上。沙漏的玻璃被打破了，里面的沙子早就掉光了。",
}

registerArtifactTranslation{
	originName = "Mandible of Ungolmor",
	name = "恩格莫的上颚",
	unided_name = "弯曲的锯齿状黑色匕首",
	desc = "这把黑曜石打造的利刃镶嵌有恩格莫的致命毒牙。光明在它周围消逝，无尽的黑暗缠绕着它。",
}

registerArtifactTranslation{
	originName = "Kinetic Spike",
	name = "灵能钉刺",
	unided_name = "短刃匕首",
	desc = "看似只是简单雕刻过的石柄，然而其前端显现着一道摇晃的刀锋。当你试图去抓住刀锋的时候，你感受到这是一股如热气般无形的力量。尽管外观粗糙，但它在意志足够坚强并且懂得使用它的人手里却可以削铁如泥。",
	["use_power.name"] = function(self, who) 
		return ("发射灵能之力，在距离 %d 范围内造成 150%% 武器伤害。")
		:format(self.use_power.range) end,
}

registerArtifactTranslation{
	originName = "Yeek-fur Robe",
	name = "夺心魔皮袍",
	unided_name = "光滑的毛皮袍子",
	desc = "美丽、柔软、洁白，这显然是为半身人贵族设计的衣物，褶边上还缀着几颗明亮的蓝宝石。尽管它是如此迷人，当你披上它时却忍不住有些恶心。",
}

registerArtifactTranslation{
	originName = "Void Star",
	name = "虚空之星",
	unided_name = "小巧的黑色星星",
	desc = "它看起来像是一颗非常小巧的星星——深邃的黑暗——不时闪着光芒。",
}

registerArtifactTranslation{
	originName = "Bindings of Eternal Night",
	name = "永夜绷带",
	unided_name = "染黑的滑腻木乃伊绷带",
	desc = "这根由亡灵能量编织成的绷带，给任何它们接触到的东西带来死亡。任何穿上它们的人会发现他处于生死的边缘。",
	set_desc = {eternalnight = "能与其匹敌的只有永夜无上的荣耀。" },
}

registerArtifactTranslation{
	originName = "Crown of Eternal Night",
	name = "永夜王冠",
	unided_name = "染黑的王冠",
	desc = "这顶王冠看起来毫无用处，尽管如此你仍能感受到它是由亡灵能量编织而成的。可能会有些用处吧。",
	set_desc = {eternalnight = "你需要找到一样东西来给予它力量。" },
}

registerArtifactTranslation{
	originName = "Rod of Spydric Poison",
	name = "蜘蛛毒枝",
	unided_name = "滴着毒液的枝条",
	desc = "这根枝条雕刻着巨大蜘蛛的毒牙，它往下不断的滴落毒液。",
}

registerArtifactTranslation{
	originName = "Cloak of Deception",
	name = "欺诈斗篷",
	unided_name = "黑色斗篷",
	desc = "一只黑色的斗篷，它在编织的过程中加入了幻觉特效。",
}

registerArtifactTranslation{
	originName = "Rune of the Rift",
	name = "符文：时空裂缝",
	unided_name = "",
	desc = "",
}

registerArtifactTranslation{
	originName = "Shifting Boots",
	name = "闪现靴",
	unided_name = "一双可以闪现的靴子",
	desc = "这双靴子可以使任何人像它以前的主人小恶魔德瑞宝一样淘气。",
	["use_power.name"] = function(self, who) return ("传送到半径 %d 范围内的随机位置 (基于魔法)"):format(self.use_power.range(self, who)) end,
}

registerArtifactTranslation{
	originName = "Atamathon's Ruby Eye",
	name = "阿塔玛森的红宝石眼睛",
	unided_name = "",
	desc = "那只传奇傀儡——阿塔玛森的一只眼睛。据说它是半身人在派尔纪为了对抗兽人所造的武器。虽然它被破坏了，但是它也成功的使对方的首领吞噬者加库尔走向死亡。",
}

registerArtifactTranslation{
	originName = "Awakened Staff of Absorption",
	name = "觉醒的吸能法杖",
	unided_name = "",
	desc = [[杖身铭刻着符文，这根法杖似乎是很久以前制造的，虽然它毫无侵蚀的痕迹。它周围的光线会变的暗淡，当你触摸它时可以感受到惊人的魔力。
恶魔法师们似乎唤醒了它的力量。
#{italic}#"终于他们直面了阿马克泰尔，并且上千人牺牲在了他的王座前，其中有三名弑神者倒在了他的脚下。但是法利恩用他死前最后的力量将冰刃阿奇尔插入了真神的膝盖，看到这一机会，凯尔帝勒，弑神者的首领，立刻上前并用吸能法杖对阿马克泰尔造成了致命的一击。这样真神最终倒在了他自己的儿女手中，他的头颅也化作了尘埃。"#{normal}#"]],
}

registerArtifactTranslation{
	originName = "Pearl of Life and Death",
	name = "生死珍珠",
	unided_name = "闪光的珍珠",
	desc = "一颗比其他要大三倍的珍珠。它的表面不断的闪烁着光芒，似乎有奇妙的花纹在其表面一闪而逝。",
}

registerArtifactTranslation{
	originName = "Potion of Martial Prowess",
	name = "尚武药剂",
	unided_name = "金属质的药剂",
	desc = "这种强大的药剂可以给那些忽视基础的人提供最基本的武学技巧。",
}

registerArtifactTranslation{
	originName = "Antimagic Wyrm Bile Extract",
	name = "龙胆药剂（反魔）",
	unided_name = "粘糊糊的药剂",
	desc = "这种强大的药剂提取自一头龙的龙胆，可以给予你对抗魔法的力量。",
}

registerArtifactTranslation{
	originName = "folded up piece of paper",
	name = "折叠着的纸张",
	unided_name = "折叠着的纸张",
	desc = "一张折叠的纸张，上面写着一些文字。",
}

registerArtifactTranslation{
	originName = "Iron Acorn",
	name = "铁质橡果",
	unided_name = "铁质橡果",
	desc = "一只小巧的橡果，似乎是用粗糙的手法将铁球打磨而成。",
}

registerArtifactTranslation{
	originName = "Iron Acorn",
	name = "铁质橡果",
	unided_name = "铁质橡果",
	desc = "一只小巧的橡果，似乎是用粗糙的手法将铁球打磨而成。它曾经属于班德，但现在是你的。带着它可以坚定你的意志，使你在面对前方的挑战时能有充分的准备。",
}

registerArtifactTranslation{
	originName = "Cold Iron Acorn",
	name = "冰冷的铁质橡果",
	unided_name = "铁质橡果",
	desc = "一只小巧的橡果，似乎是用粗糙的手法将铁球打磨而成。这只橡果时刻提醒着你，你是何人，去往何处。",
}

registerArtifactTranslation{
	originName = "Kyless' Book",
	name = "克里斯的书",
	unided_name = "书",
	desc = "这就是那本带给克里斯力量和诅咒的书。书本用牛皮简单的装订着，封面上没有任何标记，翻开书本，入目尽是空白页。",
}

registerArtifactTranslation{
	originName = "Celia's Still Beating Heart",
	name = "赛利亚的跳动心脏",
	unided_name = "鲜红的心脏",
	desc = "亡灵法师赛利亚的跳动心脏，取自她的胸膛，上面充满了魔法的力量。",
}

registerArtifactTranslation{
	originName = "Epoch's Curve",
	name = "亚伯契的弧线",
	unided_name = "灰白的白蜡长弓",
	desc = "在亚伯契的弧线失踪前，它已经服务于守卫们数载，代代相传。根据历史记载，它是用魔法大爆炸后第一棵长出的白蜡树制成，拥有时空和恢复的力量。",
}

registerArtifactTranslation{
	originName = "Sealed Scroll of Last Hope",
	name = "最后希望的密封卷轴",
	unided_name = "",
	desc = "",
	["use_simple.name"] = "打开密封卷轴阅读消息。"
}

registerArtifactTranslation{
	originName = "Resonating Diamond",
	name = "共鸣宝石",
	unided_name = "",
	desc = "",
}

registerArtifactTranslation{
	originName = "Blood-Runed Athame",
	name = "血符祭剑",
	unided_name = "祭祀短剑",
	desc = "一柄祭祀短剑，上面刻有血色的符文。它散发着能量波动。",
}

registerArtifactTranslation{
	originName = "Fake Skullcleaver",
	name = "仿制碎颅战斧",
	unided_name = "仿制的血红战斧",
	desc = "一把小巧而锋利的斧头，斧柄由打磨过的骨头制成。这把斧头打破了许多头骨，并被染成了鲜红色。",
}

registerArtifactTranslation{
	originName = "Bloodcaller",
	name = "鲜血呼唤",
	unided_name = "血色的戒指",
	desc = "你赢得了鲜血之环的试炼，那是对你的奖赏。",
}

registerArtifactTranslation{
	originName = "Heart of the Sandworm Queen",
	name = "沙虫女皇之心",
	unided_name = "跳动的心脏",
	desc = "从沙虫女皇尸体上割下的心脏。你可以……吃了它，尽管你觉得这是疯狂之举。",
}

registerArtifactTranslation{
	originName = "Corrupted heart of the Sandworm Queen",
	name = "腐化沙虫女皇之心",
	unided_name = "跳动的心脏",
	desc = "从沙虫女皇尸体上割下的心脏,已被魔法大爆炸的力量腐化。你可以……吃了它，尽管你觉得这是疯狂之举。",
}

registerArtifactTranslation{
	originName = "Wyrm Bile",
	name = "巨龙胆汁",
	unided_name = "腐败的药剂",
	desc = "一瓶粘稠的浑浊液体。天知道你喝了它之后会发生什么？",
}

registerArtifactTranslation{
	originName = "Atamathon's Lost Ruby Eye",
	name = "阿塔玛森丢失的红宝石眼睛",
	unided_name = "",
	desc = "那只传奇傀儡——阿塔玛森的另一只眼睛。据说它是半身人在派尔纪为了对抗兽人所造的武器。虽然它被破坏了，但是它也成功的使对方的首领吞噬者加库尔走向死亡。",
}

registerArtifactTranslation{
	originName = "Robes of Deflection",
	name = "扭曲之袍",
	unided_name = "七彩的长袍",
	desc = "这套长袍闪烁着金属般的光辉。",
}

registerArtifactTranslation{
	originName = "Telos's Staff (Bottom Half)",
	name = "泰勒斯的法杖（下半部）",
	unided_name = "折断的法杖",
	desc = "泰勒斯折断法杖的下半部。",
}

registerArtifactTranslation{
	originName = "Eldritch Pearl",
	name = "埃尔德里奇珍珠",
	unided_name = "闪亮的珍珠",
	desc = "在创造神庙千年的时间使它被注入了波涛的愤怒。它向外辐射着光芒。",
}

registerArtifactTranslation{
	originName = "Legacy of the Naloren",
	name = "纳鲁精灵的馈赠",
	unided_name = "华丽的奥利哈刚三叉戟",
	desc = "这柄拥有着强大力量的三叉戟通体由奥利哈刚金属打造而成。一颗闪亮的珍珠镶嵌在其顶端，向前延伸而出的，是三道锋利的三叉戟刃。它被灌输了娜迦即纳鲁一族最强大战士的力量。现在，萨拉苏尔将它赐予你，作为他对你的信任。同时，它也寄托了纳鲁一族的希望，只有你能受到他们如此的信任。",
}

registerArtifactTranslation{
	originName = "Rune of the Rift",
	name = "龟裂符文",
	unided_name = "",
	desc = "",
}

registerArtifactTranslation{
	originName = "Lecture on Humility by Archmage Linaniil",
	name = "魔导师莱娜尼尔手记",
	unided_name = "",
	desc = "魔导师莱娜尼尔所写的文献，讲述了很久以前，一段有关于魔法大爆炸的故事。",
}

registerArtifactTranslation{
	originName = "'What is Magic' by Archmage Teralion",
	name = "魔导师泰尔兰的“魔法是什么”手记",
	unided_name = "",
	desc = "魔导师泰尔兰所写的关于魔法本质的文献。",
}

registerArtifactTranslation{
	originName = "The Diaries of King Toknor the Brave ",
	name = "狮心王图库纳的日记",
	unided_name = "",
	desc = "记载了最后希望以及狮心王图库纳的部分历史。",
}

registerArtifactTranslation{
	originName = "the Pale King part ",
	name = "亡灵国王的部分记载",
	unided_name = "",
	desc = "一份对南晶岛不同寻常统治者的研究报告。",
}

registerArtifactTranslation{
	originName = "Shard of Crystalized Time",
	name = "时空结晶碎片",
	unided_name = "闪光的碎片",
	desc = "这是一块紫色的闪光碎片。闪光时缓时快，时而亮如星辰，时而黯淡无光。握着它时，你感到自己既年轻又苍老，时而觉得自己是一个年轻人，时而又觉得自己像是活了几千年。你的肉体在短暂的瞬间似乎跨越了千年，但是灵魂却永恒不变。",
}

registerArtifactTranslation{
	originName = "The Great Evil",
	name = "罪恶之源",
	unided_name = "",
	desc = "魔法的恐怖历史。",
}

registerArtifactTranslation{
	originName = "Boots of Physical Save (+10)",
	name = "物理豁免之靴（+10）",
	unided_name = "干瘪的老旧靴子",
	desc = "可以提高你10点物理豁免的好靴。",
}

registerArtifactTranslation{
	originName = "Amulet of Mindpower (+3)",
	name = "精神强度之项链（+3）",
	unided_name = "闪光的项链",
	desc = "可以提高你3点精神强度的项链。",
}

registerArtifactTranslation{
	originName = "Helmet of Accuracy (+6)",
	name = "命中之头盔（+6）",
	unided_name = "难看的头盔",
	desc = "一只可以提高你6点命中的精工头盔。",
}

registerArtifactTranslation{
	originName = "Ring of Mental Save (+6)",
	name = "精神豁免之戒指（+6）",
	unided_name = "光滑的戒指",
	desc = "一只镶有红宝石的戒指。",
}

registerArtifactTranslation{
	originName = "Tome of Wildfire",
	name = "焱之书",
	unided_name = "燃烧的书",
	desc = "这本巨大的书本被明亮的火焰所围绕。但它们不会伤害你。",
}

registerArtifactTranslation{
	originName = "Tome of Uttercold",
	name = "冰之书",
	unided_name = "结冰的书",
	desc = "这本巨大的书本被无尽的雪花所围绕。但它们不会伤害你。",
}

registerArtifactTranslation{
	originName = "Black Mesh",
	name = "黑暗之网",
	unided_name = "一堆卷须",
	desc = "盾牌由许多黑色的触须交织而成。当你触摸它时，你可以感受它非常明显的反应，它缠绕住你的手臂并将其包裹在一团黑色而温暖的物质中。",
	["on_block.desc"] = "每回合一次， 将15格内一名攻击者拉到身边， 定身并使其窒息。",
}

registerArtifactTranslation{
	originName = "Neira's Memory",
	name = "尼耶拉的记忆",
	unided_name = "发出异常声音的腰带",
	desc = "许多年前这根腰带是年轻时的莱娜尼尔穿戴的，在魔法大爆炸的火焰之中它的力量保护了她，但却保护不了她的姐妹尼耶拉。",
	["use_power.name"] = function(self, who) return ("制造一层魔法护盾，( 强度 %d, 基于魔法) ，持续 10 回合。"):format(self.use_power.shield(self, who)) end,
}

registerArtifactTranslation{
	originName = "Quiver of Domination",
	name = "统御箭袋",
	unided_name = "灰色的箭袋",
	desc = "箭袋中的箭矢中散发出一股强大的意念力，尖端虽然看上去不锋利，但是当你触摸时却让你感到剧烈的疼痛。",
}

registerArtifactTranslation{
	originName = "Essence of Bearness",
	name = "巨熊精华",
	unided_name = "灰色的熊爪",
	desc = "巨熊的精华所在！",
}

registerArtifactTranslation{
	originName = "Crown of Burning Pain",
	name = "痛苦之焱",
	unided_name = "燃烧的王冠",
	desc = "这顶由纯粹火焰所打造的王冠上漂浮着许多小小的石块，每个都可以用意念扔出，化作一块真实的陨石砸向大地。",
}

registerArtifactTranslation{
	originName = "Skull of the Rat Lich",
	name = "巫妖鼠骨盔",
	unided_name = "燃烧的王冠",
	desc = "这顶古老的骨盔是巫妖鼠仅存于世的东西，上面残留了巫妖鼠的部分精华能量。",
}

registerArtifactTranslation{
	originName = "Morrigor",
	name = "摄魂剑·莫瑞格",
	unided_name = "锯齿状的剑",
	desc = "这把沉重的，有着锯齿状刀刃的长剑正在向外散发强大的魔法波动，当你握住剑时，一阵寒意从剑柄传来，直刺灵魂。你仿佛感觉到了葬身剑下的亡灵，他们渴望着更多同伴的到来。",
}

registerArtifactTranslation{
	originName = "Eye of the Forest",
	name = "森林之眼",
	unided_name = "长满苔藓的皮帽",
	desc = "这顶皮帽上长满了厚厚的苔藓，帽子正前方用木头刻上了一只眼睛——在眼睛中心，绿色的液体缓缓流动，仿佛眼泪一样。",
}

registerArtifactTranslation{
	originName = "Eyal's Will",
	name = "埃亚尔之意志",
	unided_name = "淡绿色的灵晶",
	desc = "光滑的绿色晶体，内部有闪亮的绿色液体在流动。偶尔一小滴液体渗了出来，滴在地上，地面马上就长满了青草。",
}

registerArtifactTranslation{
	originName = "Evermoss Robe",
	name = "真菌之袍",
	unided_name = "深绿的长袍",
	desc = "这件厚厚的长袍使用一大块深绿的苔藓织成的，十分牢固，摸上去很清凉。据说，它能让人恢复青春。",
}

registerArtifactTranslation{
	originName = "Nithan's Force",
	name = "尼森之力",
	unided_name = "巨型投石索",
	desc = "这个投石索曾属于大力士尼森，他投出的弹药能击倒砖墙，很可能得到了魔法的帮助。",
}

registerArtifactTranslation{
	originName = "The Titan's Quiver",
	name = "泰坦之箭",
	unided_name = "巨型陶制箭矢",
	desc = "巨大而尖锐的箭矢，不，与其说是箭，不如说是长钉。",
}

registerArtifactTranslation{
	originName = "Inertial Twine",
	name = "惯性编织之戒",
	unided_name = "缠绕着钢铁的戒指",
	desc = "双螺旋状的戒指，很难将它移动，戴上它后似乎可以将其力量延展到整个身体。",
}

registerArtifactTranslation{
	originName = "Everpyre Blade",
	name = "永火木剑",
	unided_name = "正在燃烧的木剑",
	desc = "从永不停止燃烧的树上截取下来的木头，精心雕刻后形成的华丽的剑。剑柄用宝石做外壳，暗示其奇特的状态。剑身的火焰似乎能按照剑主人的意愿扭曲。",
}

registerArtifactTranslation{
	originName = "Eclipse",
	name = "日食",
	unided_name = "幽暗而闪光的法杖",
	desc = "这根法杖前部镶嵌有黑色的倾斜球体，似乎正发出强光。",
}

registerArtifactTranslation{
	originName = "Eksatin's Ultimatum",
	name = "阿克萨丁的最后通牒",
	unided_name = "血迹斑斑的战斧",
	desc = "这把被血液浸满的战斧曾被一位不知名的虐待成性的国王使用，他用这把斧头亲自执行了不少死刑。国王有一个房间专门用来收藏他杀死的人的头骨，每一个都完好的保存者。当国王被推翻时，他自己的头颅也进入了这间房子，作为他暴行的证据而保存。",
}

registerArtifactTranslation{
	originName = "Radiance",
	name = "光辉",
	unided_name = "闪耀光辉的金色斗篷",
	desc = "这件古朴的金色斗篷随风漂浮着，内侧洁白无一物，外侧闪耀着强烈的光芒。",
}

registerArtifactTranslation{
	originName = "Unbreakable Greaves",
	name = "牢不可破之护胫",
	unided_name = "巨大的石靴",
	desc = "这对巨大的靴子似乎是用石头雕刻而成的，尽管已经风化破裂，但仍旧能抵抗一切伤害。",
}

registerArtifactTranslation{
	originName = "The Untouchable",
	name = "不可触及",
	unided_name = "硬皮甲",
	desc = "这件破旧的夹克流传在许多乡村传说中。有人说，它属于魔法大爆炸前的一位法师转职成的盗贼，在此之后就遗失了。行行色色的人都声称曾穿过这件衣服，并且在千钧一发时救过他的命，他们说，这就是其名为“不可触及”的原因。",
}

registerArtifactTranslation{
	originName = "Honeywood Chalice",
	name = "蜂蜜木酒杯",
	unided_name = "装满液体的杯子",
	desc = "这个酒杯里装满了粘稠的物质，尝一口能提神醒脑。",
}

registerArtifactTranslation{
	originName = "Eye of the Dreaming One",
	name = "梦境之眼",
	unided_name = "半透明的球体",
	desc = "这个眼睛永远是睁着的，似乎并不相信它见到的事物。",
}

registerArtifactTranslation{
	originName = "Wyrmbreath",
	name = "龙之吐息",
	unided_name = "嵌有龙爪的手套",
	desc = "这件龙鳞手套上嵌着一条恶龙的牙齿与爪子。手套摸上去十分温暖。",
}

registerArtifactTranslation{
	originName = "River's Fury",
	name = "河流之怒",
	unided_name = "华丽的三叉戟",
	desc = "这柄华丽的三叉戟曾被纳纱瓦女士使用过，当你握紧它时，你会听到奔腾河流的怒吼。",
}

registerArtifactTranslation{
	originName = "Rod of Sarrilon",
	name = "萨瑞伦之杖",
	unided_name = "礼仪用的法杖",
	desc = "看上去普普通通的法杖，但是它和时间的神秘联系连时空法师都不清楚。",
}

registerArtifactTranslation{
	originName = "Un'fezan's Cap",
	name = "Un'fezan之帽",
	unided_name = "时尚的红色毡帽",
	desc = "这顶土耳其毡帽曾经属于一位旅行家，他经常在奇怪的地方被人发现。#{italic}#帽子看上去很不错。#{normal}#",
	set_desc = {tardis = "需要一件同样时尚而炫酷的装备来搭配，" },
}

registerArtifactTranslation{
	originName = "Omniscience",
	name = "全知",
	unided_name = "朴素的皮帽",
	desc = "这顶白色的帽子朴素、笨拙，但是，当光线在它的表面反射时，你看到了世界的极远方。",
}

registerArtifactTranslation{
	originName = "Earthen Beads",
	name = "大地串珠",
	unided_name = "系在一起的陶珠",
	desc = "这是一串古朴而坚硬的陶制串珠，年代久远，已经破碎褪色。它制作于黄昏纪，用来增加和自然的联系。",
}

registerArtifactTranslation{
	originName = "Hand of the World-Shaper",
	name = "世界塑形之手",
	unided_name = "异世界的石质手套",
	desc = "当这双沉重的手套移动时，大地会随之扭曲。",
}

registerArtifactTranslation{
	originName = "Mercy",
	name = "慈悲",
	unided_name = "异常尖锐的匕首",
	desc = "这柄匕首曾被黄昏纪一名无名的医生使用。瘟疫袭击了城镇，而医者终究是凡人，他只能用这柄匕首结束那些绝望的病人的痛苦。尽管初衷是好的，这柄匕首现在已经被黑暗力量污染，用它伤害虚弱的敌人威力更大。",
}

registerArtifactTranslation{
	originName = "Guise of the Hated",
	name = "仇恨",
	unided_name = "黑暗围绕的斗篷",
	desc = "月色皎洁，星空璀璨\n阳光温暖，光辉耀闪\n我心暗淡，其光难入\n我心苦楚，莫可见述\n",
}

registerArtifactTranslation{
	originName = "Spelldrinker",
	name = "饮法者",
	unided_name = "怪异的黑色匕首",
	desc = "无数法师曾殒命这匕首之下，被那些渴望力量的同伴背叛。时光流逝，匆匆不还，这柄匕首也开始渴望杀戮。",
}

registerArtifactTranslation{
	originName = "Frost Lord's Chain",
	name = "冰霜领主之链",
	unided_name = "寒冰覆盖的铁链",
	desc = "这不可思议的金属链覆盖着极度寒霜，向外放射出诡异而强大的光环能量",
}

registerArtifactTranslation{
	originName = "Twilight's Edge",
	name = "晨昏之刃",
	unided_name = "发光的长剑",
	desc = "这柄长剑似乎是用沃瑞坦和蓝锆石混合制成，光与暗在不断旋转交融。",
}

registerArtifactTranslation{
	originName = "Mnemonic",
	name = "记忆",
	unided_name = "熟悉的戒指",
	desc = "只要你戴上这枚戒指，你永远不会忘却。",
}

registerArtifactTranslation{
	originName = "Acera",
	name = "腐蚀之剑·阿塞拉",
	unided_name = "被腐蚀的剑",
	desc = "这柄扭曲的黑刀从无数小孔中滴落酸液。",
}

registerArtifactTranslation{
	originName = "Butcher",
	name = "屠夫",
	unided_name = "血迹斑斑的短刃",
	desc = "或许是堕落，或许是疯狂，半身人屠夫凯莱布杀死他的亲戚代替牲口。他的疯狂还没有停止，他的人影却已经不见，只留下这把刀刃，留在了血泊之中。下面刻着一行字“真有趣，下次再试试”",
	special_desc = function(self)
		local maxp = self:min_power_to_trigger()
		return ("生命降至20%%下后进入暴走状态。\n%s"):format(self.power < maxp and (" (冷却时间： %d 回合)"):format(maxp - self.power) or "") 
	end,
	["combat.special_on_hit.desc"] = "试图吞噬一个低生命的敌人。",
	["combat.special_on_kill.desc"] = "进入暴走(共享冷却).",
}

registerArtifactTranslation{
	originName = "Ethereal Embrace",
	name = "以太之拥",
	unided_name = "脆弱的紫色斗篷",
	desc = "这件斗篷漂浮弯曲，发出闪耀的光芒，折射出空间深处、以太核心。",
}

registerArtifactTranslation{
	originName = "Boots of the Hunter",
	name = "猎人之靴",
	unided_name = "用旧了的靴子",
	desc = "这对有裂缝的靴子涂着厚厚的一层泥浆。目前还不清楚它以前属于谁,但显然,它曾被很多人使用过。",
}

registerArtifactTranslation{
	originName = "Sludgegrip",
	name = "泥泞之握",
	unided_name = "粘液覆盖的手套",
	desc = "这双手套被粘稠的绿色液体覆盖。",
}

registerArtifactTranslation{
	originName = "Ring of the Archlich",
	name = "大巫妖之戒",
	unided_name = "布满尘土的戒指",
	desc = "这枚戒指含有强大的力量，但是没有显现出来。它将生命拉入金属牢笼之中，而你自己不受伤害。似乎它感觉在不久的将来你会带来无尽的死亡。",
	set_desc = {archlich = "它渴望被亡灵围绕。" },
}

registerArtifactTranslation{
	originName = "Lightbringer's Wand",
	name = "光明使者之棒",
	unided_name = "明亮的魔棒",
	desc = "这个镶嵌着金子的魔棒散发出超自然的强光。",
}

registerArtifactTranslation{
	originName = "Destala's Scales",
	name = "德斯塔拉之鳞片",
	unided_name = "绿色的龙鳞斗篷",
	desc = "黄昏纪末年，一条不知名的毒龙威胁着乡村，冒险家科斯汀·赫菲因率领的小队杀死了这条恶龙，用它的鳞片制作了这件时尚的斗篷。",
}

registerArtifactTranslation{
	originName = "Temporal Rift",
	name = "时空裂缝",
	unided_name = "空间之洞",
	desc = "某些疯狂的时空法师在时空中开了一个洞。它似乎很有效，但是会以自己诡异的方式运转。",
}

registerArtifactTranslation{
	originName = "Arkul's Siege Arrows",
	name = "阿库尔的攻城矢",
	unided_name = "巨大的螺旋箭",
	desc = "巨大的双螺旋箭，似乎是为推倒高塔而非常规战斗设计。毫无疑问,它们会迅速干掉敌人。",
}

registerArtifactTranslation{
	originName = "Punae's Blade",
	name = "普纳之刃",
	unided_name = "很薄的剑",
	desc = "这柄超乎寻常的薄刃能轻松地在空气中挥舞，让你行动更为迅速。",
}

registerArtifactTranslation{
	originName = "Crimson Robe",
	name = "深红之袍",
	unided_name = "被血污染的长袍",
	desc = "这件长袍曾被卡利斯特拥有，他是一名强大的超能力者，拥有各种能力。在他的妻子被谋杀之后，卡利斯特执着于寻找凶手,用自己的仇恨作为燃料，创造了令人不安的技术。让杀手折磨自己致死后,他行走在地上,迫使任何他发现的人自杀——这是他从世界的恐怖中给予人解脱的方式。有一天,他消失了。这浸泡在血液中的长袍,是他留下的唯一物品。",
}

registerArtifactTranslation{
	originName = "Exiler",
	name = "放逐",
	unided_name = "荣誉之戒",
	desc = "时空法师索利斯在马基埃亚尔的世界中十分有名。他总是抓住了他的敌人落单之时。即使对手不是独自一人,他也能临场发挥。",
	["use_power.name"] = function(self, who)
		local Talents = require "engine.interface.ActorTalents"
		local tal = Talents:getTalentFromId(Talents.T_TIME_SKIP)
		local oldlevel = who.talents[Talents.T_TIME_SKIP]
		who.talents[Talents.T_TIME_SKIP] = 2
		local dam = who:damDesc(engine.DamageType.TEMPORAL, who:callTalent(Talents.T_TIME_SKIP, "getDamage", who, tal))
		who.talents[Talents.T_TIME_SKIP] = oldlevel
		return ("对召唤物造成 %0.2f 时空伤害（基于魔法和紊乱）如果仍存活则移出时间线, 半径 %d，距离%d。"):format(dam, self.use_power.radius, self.use_power.range)
	end,
}

registerArtifactTranslation{
	originName = "The Face of Fear",
	name = "恐惧之颜",
	unided_name = "骨质面具",
	desc = "这件面具似乎用某种不明生物的头骨制成的，那是一种本不应该存在于世间的可怕生物，畸形并且扭曲。每当你盯着这个面具时，它那空洞的眼窝似乎也在注视着你，令你感到发自内心的颤栗。",
}

registerArtifactTranslation{
	originName = "Cinderfeet",
	name = "余烬之足",
	unided_name = "一双被火焰覆盖的草鞋",
	desc = "这是一个警示故事，讲的是有个叫凯姆的古代术士，为了勘查地狱般的恶魔荒原，也为了考验自己，自命不凡的认为可以在恶魔的老巢高达勒斯天天散步。他每次从恶魔位面归来都小心翼翼地不敢带回任何东西，生怕成为恶魔找到他的指引。不幸的是，来回很多次以后，他的草鞋浸满了恐惧之地的烟尘和灰烬。地狱之焰随他的脚步被带到了世间，同时也注定了他悲惨的命运。",
	special_desc = function(self, who)
		local dam = who and who:damDesc(engine.DamageType.FIRE, self:trail_damage(who)) or 0
		return ("你每踏出一步会在脚下留下一条持续5回合的燃烧痕迹，对所有经过的生物造成 %d 火焰伤害 (基于法术强度)"):format(dam)
	end,
	}
registerArtifactTranslation{
	originName = "Cuirass of the Dark Lord",
	name = "黑暗领主胸甲",
	unided_name = "一件黑色的尖刺铠甲",
	desc = "这件胸甲属于一个早已被人遗忘的暴君，成千上万无辜死者的鲜血强化了这件铠甲。黑暗领主最终在衰老与虚弱中孤独的死去，他的统治分崩离析，他的人民四散而去。只有这件胸甲被保留了下来，渴望着再次品尝鲜血的味道。",
	["use_power.name"] = "吸收半径 5 内所有生物的血液 ,   令其在 4 回合内受到 1 2 0 点流  血伤害。每吸收一个生物（至多 1 0 ），护甲的属性增加。 10 回合后复原。",
}

registerArtifactTranslation{
	originName = "Yaldan Baoth",
	name = "雅尔丹宝石",
	unided_name = "昏暗的头盔",
	desc = "这顶金色的王冠属于传说之城雅尔丹之王——Veluca。【待翻译】他比他的任何亲戚活得都长，在生命的最后日子里，他行走在早期的世界上，教育人们反抗黑暗。临死前，这顶王冠交给了他的继任者，一同交付的还有他的遗言——勿惧邪恶",
}

registerArtifactTranslation{
	originName = "Blackfire Aegis",
	name = "黑炎石盾",
	unided_name = "黑色的石质盾牌",
	desc = "这个坚固的石盾闪烁着漆黑的火焰。",
}

registerArtifactTranslation{
	originName = "Will of Ul'Gruth",
	name = "Ul'Gruth的意志",
	unided_name = "巨型金属手套",
	desc = "这双巨大的手套曾经属于一个名叫Ul'Gruth的强大的恶魔。据说，这个怪物一挥手就能将一座城市夷为平地。",
}

registerArtifactTranslation{
	originName = "Fearfire Mantle",
	name = "恐惧之焰",
	unided_name = "火焰般的斗篷",
	desc = "黑色的火焰从漆黑的心脏中涌出。",
}

registerArtifactTranslation{
	originName = "Plague-Fire Sceptre",
	name = "疫火权杖",
	unided_name = "黑色的法杖",
	desc = "Mal'Rok的火焰比一般的火焰更加顽强。当它们无物可燃时，它们知道去哪里寻找。",
}

registerArtifactTranslation{
	originName = "Dethblyd",
	name = "Dethblyd",
	unided_name = "黑色的剑",
	desc = "毁灭者Grushgore以头脑简单四肢发达闻名。他从不擅长谋略，但他的力量无以伦比。",
}

registerArtifactTranslation{
	originName = "Quasit's Skull",
	name = "夸塞魔之颅",
	unided_name = "岩石头盔",
	desc = "一些有魄力的冒险者已经注意到了夸塞魔的皮肤其实比大多数金属都要坚硬，这个头盔就是一个夸塞魔的颅骨制成的。呣，气味浓郁。",
}

registerArtifactTranslation{
	originName = "Blackfire Aegis",
	name = "黑炎石盾",
	unided_name = "黑色的石质盾牌",
	desc = "这个坚固的石盾闪烁着漆黑的火焰。",
}

registerArtifactTranslation{
	originName = "Revenant",
	name = "亡魂",
	unided_name = "不断变形的胸甲",
	desc = "关节不祥的咯吱作响，骨架弯曲突起的呼吸。划痕与裂纹是金属的低语，有关苦楚、失去、坚持与复仇。",
}

registerArtifactTranslation{
	originName = "Imp Claw",
	name = "小鬼之爪",
	unided_name = "红色的爪子",
	desc = "这是一只火焰小鬼留下的满是伤痕的爪子。它还燃烧着不自然的火焰。",
}

registerArtifactTranslation{
	originName = "Wheel of Fate",
	name = "命运之轮",
	unided_name = "命运之轮",
	desc = "这不是我想要的结果！- Howar	Muransk,普通人类恶魔学家。\n狞笑着的骷髅图案在这个由黑曜石铸成的哥特式戒指上隐约浮现。骷髅似乎在召唤着你，使你情不自禁想要铤而走险地把它戴在手上，转动命运之轮。你会这么做吗？",
}

registerArtifactTranslation{
	originName = "Helm of the Dominated",
	name = "支配头盔",
	unided_name = "长角的头盔",
	desc = "这个头盔是为了提高魔化精灵的能力，而作为实验产品被制造出来。",
}

registerArtifactTranslation{
	originName = "The Black Crown",
	name = "黑之冠",
	unided_name = "破碎的黑曜石头盔",
	desc = "魔中之魔，加冕为王",
}

registerArtifactTranslation{
	originName = "The Black Core",
	name = "黑之核",
	unided_name = "黑色的宝石",
	desc = "锁住灵魂，死亡莫及。",
}

registerArtifactTranslation{
	originName = "The Black Spike",
	name = "黑之钉",
	unided_name = "很薄的黑色短剑",
	desc = "世界之心，终将刺穿",
}

registerArtifactTranslation{
	originName = "The Black Ring",
	name = "黑之戒",
	unided_name = "黑曜石戒指",
	desc = "勿视其中，安然无恙",
}

registerArtifactTranslation{
	originName = "The Black Boots",
	name = "黑之靴",
	unided_name = "黑色的靴子",
	desc = "背叛之路，直通天际",
}

registerArtifactTranslation{
	originName = "The Black Plate",
	name = "黑之铠",
	unided_name = "黑曜石胸甲",
	desc = "己身若残，何物能存?",
}

registerArtifactTranslation{
	originName = "The Black Maul",
	name = "黑之锤",
	unided_name = "巨大的黑曜石战锤",
	desc = "冠军之锤，举重若轻",
}

registerArtifactTranslation{
	originName = "The Black Maul",
	name = "黑之锤",
	unided_name = "巨大的黑曜石战锤",
	desc = "冠军之锤，举重若轻",
}

registerArtifactTranslation{
	originName = "The Black Wall",
	name = "黑之墙",
	unided_name = "巨大的黑曜石盾牌",
	desc = "披坚持盾，众莫能伤",
}

registerArtifactTranslation{
	originName = "Planar Beacon",
	name = "空间信标",
	unided_name = "闪光的红色球体",
	desc = "从恶魔手里拿到的奇怪的球体，它正闪耀着超现实的红光。",
}

registerArtifactTranslation{
	originName = "Jaw of Rogroth",
	name = "Rogroth的下颚",
	unided_name = "布满尖齿的腰带",
	desc = "真有趣，灵魂吞噬者Rogroth的嘴巴正好和你的腰一样大。",
}

registerArtifactTranslation{
	originName = "Bikini",
	name = "比基尼",
	unided_name = "小小的一块布",
	desc = [[性感，粉色，有趣。
#{bold}#如果你在全程不脱下它的情况下通关你将可以得到一个成就和吹牛的权利！#{normal}#]],
}

registerArtifactTranslation{
	originName = "Mankini",
	name = "男性比基尼",
	unided_name = "小小的一块布",
	desc = [[性感，绿色，有趣。
#{bold}#如果你在全程不脱下它的情况下通关你将可以得到一个成就和吹牛的权利！#{normal}#]],
}

registerArtifactTranslation{
	originName = "Staff of Absorption",
	name = "吸能法杖",
	unided_name = "黑暗符文法杖",
	desc = "杖身铭刻着符文，这根法杖似乎是很久以前制造的，虽然它毫无侵蚀的痕迹。它周围的光线会变的暗淡，当你触摸它时可以感受到惊人的魔力。",
}

registerArtifactTranslation{
	originName = "Orb of Many Ways",
	name = "多元水晶球",
	unided_name = "涡流水晶球",
	desc = "这个球体可以折射出远处的景象并快速的切换着，有些景象甚至不属于这个世界。如果你在传送点附近使用它，它可能会激活传送。",
}

registerArtifactTranslation{
	originName = "Orb of Undeath (Orb of Command)",
	name = "指令水晶球（亡灵） ",
	unided_name = "指令水晶球",
	desc = "当你拿起这个水晶球时，无尽的黑暗铺面而来。这个球摸上去冰凉。",
}

registerArtifactTranslation{
	originName = "Dragon Orb (Orb of Command)",
	name = "指令水晶球（巨龙）",
	unided_name = "指令水晶球",
	desc = "这个水晶球摸起来很暖和。",
}

registerArtifactTranslation{
	originName = "Elemental Orb (Orb of Command)",
	name = "指令水晶球（元素）",
	unided_name = "指令水晶球",
	desc = "火焰在覆满了冰霜的水晶球上旋转。",
}

registerArtifactTranslation{
	originName = "Orb of Destruction (Orb of Command)",
	name = "指令水晶球（毁灭）",
	unided_name = "指令水晶球",
	desc = "当你拿起这个水晶球时，你眼前浮现出死亡和毁灭的景象。",
}

registerArtifactTranslation{
	originName = "Scrying Orb",
	name = "鉴定水晶球",
	unided_name = "鉴定水晶球",
	desc = "这个球是半身人先知埃莉萨给你的，它会自动为你鉴定装备。",
}

registerArtifactTranslation{
	originName = "Rod of Recall",
	name = "回归之杖",
	unided_name = "不稳定的魔杖",
	desc = "这个法杖通体用沃瑞钽打造，充满了可以撕裂空间的奥术能量。你以前曾听说过此类物品。它们对于冒险者的快速旅行非常有帮助。",
}

registerArtifactTranslation{
	originName = "Transmogrification Chest",
	name = "转化之盒",
	unided_name = "",
	desc = [[这只宝箱是伊尔克古尔的延伸，任何扔在里面的物品会被自动传送到湖底要塞，由核心驱动，当能量耗尽时会被破坏。这件物品的副作用是，由于金币对要塞是没用的，它会自动返还给你。
当你有这只箱子时，所有你经过地面上的物品会被自动捡起，并且当你离开地下城时会自动交易成金币。
如果你想保留物品，只需要从宝箱里把它移到包裹中。在宝箱中的物品不会增加你的负重。]],
}

registerArtifactTranslation{
	originName = "Elixir of the Fox",
	name = "狡诈药剂",
	unided_name = "一瓶粉红色的液体",
	desc = "一瓶粉红色的透明液体。",
}

registerArtifactTranslation{
	originName = "Elixir of Avoidance",
	name = "闪避药剂",
	unided_name = "一瓶绿色的液体",
	desc = "一瓶浑浊的绿色液体。",
}

registerArtifactTranslation{
	originName = "Elixir of Precision",
	name = "精准药剂",
	unided_name = "一瓶红色的液体",
	desc = "一瓶粘稠的红色液体。",
}

registerArtifactTranslation{
	originName = "Elixir of Mysticism",
	name = "神秘药剂",
	unided_name = "一瓶青色的液体",
	desc = "一瓶炽热的青色液体。",
}

registerArtifactTranslation{
	originName = "Elixir of the Savior",
	name = "守护药剂",
	unided_name = "一瓶灰色的液体",
	desc = "一瓶翻滚着泡沫的灰色液体。",
}

registerArtifactTranslation{
	originName = "Elixir of Mastery",
	name = "掌握药剂",
	unided_name = "一瓶栗色的液体",
	desc = "一瓶浓郁的栗色液体。",
}

registerArtifactTranslation{
	originName = "Elixir of Explosive Force",
	name = "爆炸药剂",
	unided_name = "一瓶橙色的液体",
	desc = "一瓶浑浊的橙色液体。",
}

registerArtifactTranslation{
	originName = "Elixir of Serendipity",
	name = "幸运药剂",
	unided_name = "一瓶黄色的液体",
	desc = "一瓶流动的黄色液体。",
}

registerArtifactTranslation{
	originName = "Elixir of Focus",
	name = "专注药剂",
	unided_name = "一瓶透明的液体",
	desc = "一瓶透明的沸腾液体。",
}

registerArtifactTranslation{
	originName = "Elixir of Brawn",
	name = "蛮牛药剂",
	unided_name = "一瓶棕褐色的液体",
	desc = "一瓶粘稠的棕褐色液体。",
}

registerArtifactTranslation{
	originName = "Elixir of Stoneskin",
	name = "石肤药剂",
	unided_name = "一瓶有金属光泽的液体",
	desc = "一瓶带有特殊纹理、泛着金属光泽的液体。",
}

registerArtifactTranslation{
	originName = "Elixir of Foundations",
	name = "领悟药剂",
	unided_name = "一瓶白色的液体",
	desc = "一瓶朦胧的白色液体。",
}

registerArtifactTranslation{
	originName = "Taint of Telepathy",
	name = "堕落印记：感应",
	unided_name = "",
	desc = "",
}

registerArtifactTranslation{
	originName = "Infusion of Wild Growth",
	name = "纹身：根须缠绕",
	unided_name = "",
	desc = "",
}

registerArtifactTranslation{
	originName = "Lifebinding Emerald",
	name = "生命之心",
	unided_name = "半透明的厚重翡翠",
	desc = "一块不规则的厚重翡翠，表面有云纹浮动。",
}

registerArtifactTranslation{
	originName = "Elixir of Invulnerability",
	name = "无敌药剂",
	unided_name = "一瓶黑色的液体",
	desc = "一瓶粘稠的反射着金属光泽的液体。它有着难以置信的重量。",
}

registerArtifactTranslation{
	originName = "Decayed Visage",
	name = "堕落视觉",
	unided_name = "木乃伊皮面罩",
	desc = [[一小片人皮面具，是派尔纪一位死灵法师的遗物。他试图变成巫妖，但是没有成功。他的身体逐渐腐烂，但由于未成功的法术而不能死去，就这样过了数年。现在，他的灵魂仍藏身于这小块皮肤中，渴求着永恒的生命。]],
}

registerArtifactTranslation{
	originName = "Dream Malleus",
	name = "梦境之槌",
	unided_name = "发光木锤",
	desc = [[一个闪闪发光的大木槌,你的耳朵里似乎能听到它发出的声音.它既像思想一样有可塑性也像最强的钢铁那样坚硬.]],
}

registerArtifactTranslation{
	originName = "Cloud Caller",
	name = "唤云者",
	unided_name = "宽边帽",
	desc = [[这顶帽子宽阔的帽檐保护您免受恶劣的阳光和突如其来的暴风雨.]],
}

registerArtifactTranslation{
	originName = "The Jolt",
	name = "震撼",
	unided_name = "刺痛项圈",
	desc = [[这项圈摸起来让人觉得刺痛,但似乎增强了你的思考.]],
	special_desc = function(self) 
		return "每次当你的雷电伤害超过了目标 10%% 最大生命时，将附加锁脑状态。" end,
}

registerArtifactTranslation{
	originName = "Stormfront",
	name = "风暴前线",
	unided_name = "潮湿的钢铁战斧",
	desc = [[剑身泛着淡淡的蓝色,反射出了满天的乌云.]],
	["combat.special_on_crit.desc"] = "造成湿润或震撼效果。",
}

registerArtifactTranslation{
	originName = "Eye of Summer",
	name = "夏日之眼",
	unided_name = "温暖的灵晶",
	desc = [[这个灵晶散发着温暖的微光,但似乎有点残缺.]],
	set_desc = {eyesummer = "自然需要平衡的灵晶." },
}

registerArtifactTranslation{
	originName = "Eye of Winter",
	name = "冬日之眼",
	unided_name = "寒冰的灵晶",
	desc = [[这个灵晶散发着寒冷的微光,但似乎有点残缺.]],
	set_desc = {eyewinter = "自然需要平衡的灵晶." },
}

registerArtifactTranslation{
	originName = "Ruthless Grip",
	name = "无情之握",
	unided_name = "邪恶的手套",
	desc = [[一个军阀为了永远掌握他的臣民而制造的.黑暗的思想被真正的灌注进去这些手套里.]]	,
}

registerArtifactTranslation{
	originName = "Icy Kill",
	name = "冰冷杀戮",
	unided_name = "锋利的冰柱",
	desc = [[任何占卜师都知道，凶器乃是缉查凶手最重要的线索；他们往往顺着这条线索顺藤摸瓜，从人群中找出凶手的真身。
	然而，一个冷酷的杀手找到了一个办法：他用寒冰铸成了一把利刃，将其刺入受害者的胸口，让其随着受害者心脏的体温渐渐融化，消失于无形。
	最终，这名杀手仍然没有逍遥于法外。一名受害者幸运地夺下了利刃，反身刺入了杀手的心脏里。杀手冷酷的内心没有温度，而这把与其相融的利刃从此再也不会融化。]],
	["combat.special_on_crit.desc"] = "冻结目标",
	["combat.special_on_kill.desc"] = "令一个冻结生物爆炸 ( 伤害受意志加成)",
}

registerArtifactTranslation{
	originName = "Thunderfall",
	name = "落雷",
	unided_name = "巨型发声狼牙棒",
	desc = [[巨大的力量集中在这沉重的权杖里.只是掉落在地就可以摧毁附近的墙壁.]],
	["use_power.name"] = function(self, who) 
		return ("对范围 %d 内的一个目标造成自动暴击的雷电伤害。"):format(self.use_power.range) 
		end,
}

registerArtifactTranslation{
	originName = "Kinetic Focus",
	name = "动能之核",
	unided_name = "发出嗡嗡声的灵晶",
	desc = [[动能集中在这个灵晶的核心里.]],
	set_desc = {trifocus = "在这个物品里你感受到了两种不相关的能量。" },
}

registerArtifactTranslation{
	originName = "Charged Focus",
	name = "电能之核",
	unided_name = "发出火花的灵晶",
	desc = [[电能集中在这个灵晶的核心里.]],
	set_desc = {trifocus = "在这个物品里你感受到了两种不相关的能量。" },
}

registerArtifactTranslation{
	originName = "Thermal Focus",
	name = "热能之核",
	unided_name = "炽热的的灵晶",
	desc = [[热能集中在这个灵晶的核心里.]],
	set_desc = {trifocus = "在这个物品里你感受到了两种不相关的能量。" },
}

registerArtifactTranslation{
	originName = "Lightning Catcher",
	name = "雷电接收器",
	unided_name = "螺旋形金属腰带",
	desc = [[一个坚固的铁链缠着细金属丝网。火花在上面跳舞.]],
	special_desc = function(self)
		return [[每次接受雷电伤害或造成暴击雷电伤害时获得两点充能，每点充能提供 5%% 雷电伤害加成和 1 点全属性。每回合损失一点加成。]] 
	end,
}

registerArtifactTranslation{
	originName = "Astelrid's Clubstaff",
	name = "医师亚斯特莉的“狼牙棒”",
	unided_name = "一把巨锤",
	desc = [[如同它的前任主人一样，这曾经是无私治愈的工具，然而愤怒和恐惧将其扭曲成一把嗜血的武器。在插着锋利的手术设备的石膏涂层下，依稀可以感觉到流淌而出的治疗魔法的力量]],
	special_desc = function(self)
		return [[增加纹身和符文的属性加成效果 15%%]]
	end,
}
function registerArtifactTranslation(t)
	_M.artifactCHN[t.originName] = t
end
registerArtifactTranslation{
	originName = "Yeti-fur Cloak",
	name="雪人毛皮斗篷",
	unided_name="暗淡无光的毛皮斗篷",
	desc="这件毛皮斗篷厚重且暗淡无光，但是摸起来却不可思议的柔软。",
}

registerArtifactTranslation{
	originName = "Korbek's Spyglass",
	name="库贝克的小型望远镜",
	unided_name="金色的望远镜",
	desc="这个年代久远的小型望远镜由于使用过多有些褪色，但是仍然保养得很好。",
}
registerArtifactTranslation{
	originName = "Talosis' Counterpoint",
	name="Talosis的反驳",
	unided_name="华丽的手枪",
	desc="据说Talosis从没有输过一场争吵。现在你知道原因了。",
}
registerArtifactTranslation{
	originName = "The Twisted Blade",
	name="扭曲之刃",
	unided_name="邪恶、扭曲的蒸汽锯",
	desc="你在这块邪恶、扭曲的铁块上发现金色的斑点，暗示着它不同寻常的来历。然而曾经的辉煌，都已经成为了过去，如今已被更加邪恶的东西取代",
}
registerArtifactTranslation{
	originName = "Sunstone",
	name="太阳石",
	unided_name="温暖的石头",
	desc="这块奇怪的石头发出太阳的光和热。或许它可以用来产生更多的蒸汽？",
}

registerArtifactTranslation{
	originName = "Overseer",
	name="监视者",
	unided_name="破裂的灵晶",
	desc="意念之墙的力量碎片仍然依附在这块破裂的古老宝石上。",
	["use_power.name"] = function(self, who)
			return ("彻底支配或者震慑（取决于免疫）一个%d码范围内的目标%d回合（成功率基于精神强度）。"):format(self.use_power.range, self.use_power.duration)
		end,
}
registerArtifactTranslation{
	originName = "Ureslak's Focus",
	name = "乌瑞斯拉克的意志",
	unided_name="晶化龙心",
	desc = [[这块有裂痕的宝石从已经死亡的巨龙乌瑞斯拉克身上掉下来。它似乎已经变成了纯粹的水晶体。]],
}
	
registerArtifactTranslation{
	originName = "Starcaller",
	name="召星者",
	unided_name="黑色的法杖",
	desc="一把被蓝锆石和宝石覆盖的轻型法杖。即使在白天，似乎也在反射着星星的光芒。",
}
registerArtifactTranslation{
	originName = "Liquid Metal Cloak",
	name="液态金属披风",
	unided_name="闪亮的金属披风",
	desc="这片奇特的金属如同普通的披风一样随风摆动。打造它的人无疑是一位大师。",
}
registerArtifactTranslation{
	originName = "Automated Portable Extractor",
	name="便携式自动材料提取仪",
	unided_name="便携式自动材料提取仪",
	desc=[[这是一个神奇的仪器。它能临时存储当层所有捡到的道具，还能融化任何道具，将其转化为金子和相应的材料。金属装备会融化为相应的矿物块]],
	["use_power.name"] = "立刻融化并提炼仪器中所有道具（切换地图时自动执行）。",
	}
registerArtifactTranslation{
	originName = "Medical Urgency Vest",
	name="医疗急救背心",
	unided_name="医疗装甲",
	desc="这件轻型皮革背心配备有一个装用的医疗注射器。",
}
registerArtifactTranslation{
	originName = "Anti-Gravity Boots",
	name="反重力鞋",
	unided_name = "过热金属鞋",
	desc = [[这套鞋子似乎是被一位具有……创造力的大师制造出来的，他似乎认为用火箭将你发射到空中就是“反重力”了。
看上去这套鞋子能用，大概。
确实有可能。
只要你非常非常小心。]],
	special_desc = function(self, who) 
		return ("这个鞋子有 %d%% 几率不能正确操作。（随灵巧减少）"):format(self.use_power.fail_chance(self, who)) end,
	["use_power.name"] = function(self, who)
			local dam1 = who:damDesc(engine.DamageType.FIRE, self.use_power.damage1(self, who))
			local dam2 = who:damDesc(engine.DamageType.FIRE, self.use_power.damage2(self, who))
			return ("跳向%d码内的位置,在跳跃点2码范围内造成%d火焰燃烧伤害与2码的击退效果,在着陆点3码范围内造成%d火焰燃烧伤害与3码的击退效果.（伤害基于灵巧）"):format(self.use_power.range, dam1, dam2)
		end,
}
registerArtifactTranslation{
	originName = "Steam Powered Boots",
	name="蒸汽动力鞋",
	unided_name="蒸汽动力鞋",
	desc="蒸汽动力！",
	special_desc = function(self, who) 
		return ("每次行走生成 %d 蒸汽。"):format(self.steam_boots_on_move) 
	end,
	set_desc = { steamarmor =  "蒸汽多多益善！" },
}
registerArtifactTranslation{
	originName = "Steam Powered Helm",
	name="蒸汽动力头盔",
	unided_name="蒸汽动力头盔",
	desc="蒸汽动力！",
	set_desc = { steamarmor =  "蒸汽多多益善！" },
}
registerArtifactTranslation{
	originName = "Steam Powered Gauntlets",
	name="蒸汽动力手套",
	unided_name="蒸汽动力手套",
	desc="蒸汽动力！",
	set_desc = { steamarmor =  "蒸汽多多益善！" },
}
registerArtifactTranslation{
	originName = "Assassin's Surprise",
	name = "暗杀奇袭",
	unided_name = "闪耀光辉的铁手套",
	desc = [[这对铁手套左手大拇指处有一个精巧的毒箭发射机关。]],
	["use_power.name"] = function(self, who)
			local dam = self.use_power.damage(self, who)
			local dur = dam.dur
			local damage = who:damDesc(engine.DamageType.NATURE, dam.dam)
			return ("发 出 射 程 %d 的 毒 箭 ， 造 成 %d 自 然 伤 害 并 施 加 致 残 毒 素 ，目 标 有 %d%% 几 率 使 用 技 能 失 败，每 回 合 受 到 %d 额 外 自 然 伤 害 ， 持 续 %d 回 合 。  （ 伤 害 基 于 灵 巧 ） "):format(self.use_power.range, damage/dur, dam.fail, damage, dur)
		end,
}
registerArtifactTranslation{
	originName = "Nacrush's Decimator",
	name="Nacrush的屠杀者",
	unided_name="笨重的枪",
	desc="Nacrush因其滥杀而闻名。",
	special_desc = function(self) return "开火时反冲力将击退自己。" end,
}
registerArtifactTranslation{
	originName = "Signal",
	name="信号枪",
	unided_name="红色枪管的蒸汽枪",
	desc="一把奇特、粗短的枪，装有红色的枪管。",
}
registerArtifactTranslation{
	originName = "Glacia",
	name="冰川",
	unided_name="冰冻的枪",
	desc="奇怪的线圈环绕着这把极其冰冷的枪。",
}
registerArtifactTranslation{
	originName = "Tinkerer's Twinblaster",
	name="工程师的双重爆破",
	unided_name="双管蒸汽枪",
	desc="这把枪使用了实验性的技术一次射出多发子弹。\n设计尚未成熟，但似乎还算能用。",
}
registerArtifactTranslation{
	originName = "Flashpoint",
	name="燃点",
	unided_name="过热的枪",
	desc="你是否曾经看到一些人并且想：'你知道吗，我真的想要烧死这些人'，但是你又不想大费周章，现在有了一个更加方便的方法！",
}

registerArtifactTranslation{
	originName = "S.H. Spear",
	name="S.H.长矛",
	unided_name="被雕刻的蒸汽枪",
	desc=[[这把枪被一种能强化精神力量的神秘物质雕刻。
装备着它，你的大脑似乎更加灵敏了。]],
}
registerArtifactTranslation{
	originName = "Dreamweaver",
	name="梦想编织者",
	unided_name="闪光蒸汽枪",
	desc="这并不能算是一把枪，因为它只是一把枪的概念。当你丢掉它时你就记住它了。",
	["use_power.name"] = function(self, who) 
		return ("扔 出 枪 令 其 爆 炸 ， 造 成 %d 精 神 伤 害 ( 基于 灵 巧 和 意 志 ），并 附 加 沉 睡 效 果 。 同 时 你 被 视 为 缴 械 3 回 合 。")
		:format(self.use_power.dam(self, who)) end,
}

registerArtifactTranslation{
	originName = "Thoughtcaster",
	name="思维施法者",
	unided_name="透明的手枪",
	desc="从物质中诞生意识。从意识中诞生物质。",
	special_desc = function(self)
		return ("在半径1范围内造成等于精神强度的精神伤害。")
	end,
	["combat.special_on_hit.desc"] = function(self, who, special)
				local dam = special.damage(self, who)
				return ("在半径1范围内造成 %0.2f 精神伤害（基于精神强度）。"):format(who:damDesc(engine.DamageType.MIND, dam))
			end,
}

registerArtifactTranslation{
	originName = "Spider's Fangs",
	name="蜘蛛毒牙",
	unided_name="一袋有毒的弹丸",
	desc="一位热心的技师似乎将成吨的蜘蛛毒液注入了这些子弹里。不知道蜘蛛对此有多么高兴。",
	special_desc = function(self)
		local maxp = self:min_power_to_trigger()
		return ("%s"):format(self.power < maxp and ("(冷却剩余: %d 回合)"):format(maxp - self.power) or "准备就绪！") 
	end,
	["combat.special_on_crit.desc"]="爆发出一股具有定身效果的毒烟（10回合冷却）。",
}


registerArtifactTranslation{
	originName = "Scattermind",
	name="破碎意志",
	unided_name="破碎的灵晶",
	desc="一个亚麻布袋中装着锯齿状的灵晶碎片，让人清晰的感受到混乱和痛苦。在某个混蛋把它打成碎片之前，它一定是一个令人无法忘怀的整体。",
}

registerArtifactTranslation{
	originName = "Thundercrack",
	name="雷电打击",
	unided_name="一袋铜制弹丸",
	desc="这些弹药通过魔法和探针从天空引导强力的闪电冲击你的目标，灼烧目标及周边的单位。",
}
registerArtifactTranslation{
	originName = "Vindicator",
	name="维序者",
	unided_name="雕花的枪",
	desc="恼人的不死族在你的村庄传播瘟疫？死灵法师搜刮你的墓地？维序者可以解决一切。",
}
registerArtifactTranslation{
	originName = "Overburst",
	name="强力爆裂",
	unided_name="粗管蒸汽枪",
	desc="你曾经试过向一群怪兽中发射一粒粒弹药，然后觉得一定有更好的方法？好了，这就是了。",
}

registerArtifactTranslation{
	originName = "Murderfang's Surekill",
	name="Murderfang的必杀",
	unided_name = "粗管蒸汽枪",
	desc = [[Murderfang 昨天突然跑过来，和我讨论他对蒸汽枪的灵感。他详细地描述了这把枪的构造，几乎说了每一点细节，除了一件事——这把枪该怎么用。
	如何才能握住这样一把枪呢？尽管如此，我还是坚持着把它做出来，虽然有一些设计没有实现。
	他们都说这把枪做的棒极了。
-工匠大师Pizurk
	]],
	}
registerArtifactTranslation{
	originName="The Long-Arm",
	name="长手",
	unided_name="长管蒸汽枪",
	desc="这把枪的枪管长的出奇。你好奇这杆枪到底是为谁设计。",
	["use_power.name"] = function(self, who)
			return ("集中精力瞄准目标，令其接受死亡的印记 - 减少 %d 远程闪避和 %d%%全抗性。"):format(self.use_power.def, self.use_power.dam)
		end,
}

registerArtifactTranslation{
	originName = "Annihilator",
	name="歼灭者",
	unided_name="大型多管枪",
	desc="这把枪的转轮上附有多支枪管，看起来由引擎驱动。看起来令人印象深刻。",
	special_desc = function(self) return "射击速度随着射击而加快，最快1回合射5次。5回合内未射击则效果消失。" end,
	["combat.special_on_hit.desc"]="50% 几率装填1发子弹",	
}
registerArtifactTranslation{
	originName = "The Shotgonne",
	name="火枪",
	unided_name="巨大的枪",
	desc=[[这把巨大的蒸汽枪一次能装填多发子弹，并以锥形弹幕射出。
它精巧的设计令它能被双手持有。]],
	special_desc = function(self) 
		return "射击时，额外射出至多4发子弹，随机指向目标周围4码锥形范围内的敌人。" end,
}

registerArtifactTranslation{
	originName = "Cloak of Daggers",
	name="匕首披风",
	unided_name="布满刀刃的披风",
	desc = [[这件披风上布满了刀刃和机关。显然制作者认为'最好的防御就是进攻'。]],
	special_desc = function(self, who)
		local dam = who:damDesc(engine.DamageType.PHYSICAL, self:bleed_damage(who))
		return ("每回合50%%几率攻击一次，造成 %d 物理伤害 (基于灵巧)和流血效果。"):format(dam)
	end,
}
registerArtifactTranslation{
	originName = "Jetpack",
	name="飞行背包",
	unided_name="一个飞行背包。",
	desc="终于。",
}
registerArtifactTranslation{
	originName = "Therapeutic Platemail",
	name="医疗型板甲",
	unided_name="加热的板甲",
	desc="这个厚重的板甲配备有通风设备，可以使用加热的薄雾来治疗你。",
	["use_power.name"] = function(self, who)
			return "解除至多3种毒素或伤口。"
		end,
}
registerArtifactTranslation{
	originName = "Titan",
	name="泰坦",
	unided_name="巨型枪",
	desc="一把可以摧毁任何事物的枪，以及周边的一切。",
}
registerArtifactTranslation{
	originName = "Golden Gun",
	name="金色的枪",
	unided_name="金色的枪",
	desc="一把可以摧毁任何事物的枪，以及周边的一切。",
}
registerArtifactTranslation{
	originName = "Cautery Sword",
	name="灼烧之剑",
	unided_name="炽热的剑",
	desc="这把剑的炽热核心可以让敌人的伤口感到更加疼痛。",
}
registerArtifactTranslation{
	originName = "Stimulus",
	name="兴奋剂",
	unided_name="自动注射器",
	desc="这个注射单元由皮带栓起的小型药瓶组成，里面装满了粘稠的黄色液体。论文描述这些液体可以‘使人精力充沛’并‘增加作战能力’。",
	["use_power.name"] = function(self, who)
			return "注射镇痛剂，全伤害减少5点。最多叠加5次。效果结束后，每一层效果给予5%%最大生命值的伤害。"
		end,
}
registerArtifactTranslation{
	originName = "Qog's Essentials",
	name="Qog的精华",
	unided_name="奇怪的注射器",
	desc="一个无针注射器，里面装满了*某种*液体。你完全不知道你给自己注射了什么。",
	["use_power.name"] = function(self, who)
			return "获得随机增益。"
		end
}
registerArtifactTranslation{
	originName = "Sawrd",
	name="锯剑",
	unided_name="锯齿般刀刃的剑",
	desc="有无数刀刃的凶残武器。",
}
registerArtifactTranslation{
	originName = "Deflector",
	name="偏转",
	unided_name="颤动的盾牌",
	desc = [[盾牌的正面不停地颤动，似乎有着某种你不理解的节奏。]],
	special_desc = function(self) return "击退近战攻击者，距离和受到的伤害有关。" end,
	}
registerArtifactTranslation{
	originName = "Skysmasher",
	name="破天",
	unided_name="火箭锤",
	desc = [[火箭的发明被证明为极其危险。尚不清楚对谁。]],
	}
registerArtifactTranslation{
	originName = "Nimbus of Enlightenment",
	name="启蒙灵气",
	unided_name="精致的帽子",
	desc = [[从任何角度看，都只是一个装着天线的平凡的烹饪锅。附赠的使用手册写满了50页的疯言疯语、错乱的程序代码与杂乱无章的数字，没有任何可用的信息。
	直接把它戴在头上似乎不是个好点子。]],
	special_desc = function(self) return "他们来了！\n这不是真的不是真的不是真的不是真的真的不是真的不是" end,
}
registerArtifactTranslation{
	originName = "Pressurizer",
	name = "稳压器",
	desc="这件斗篷隐藏并保护着一套蒸汽压缩机。",
}
registerArtifactTranslation{
	originName = "Eastern Wood Hat",
	name="东方森林之帽",
	unided_name="破损的皮帽",
	desc="这顶皮帽的材料来自于遥远的树林，人们早已遗忘了树林的名字。据说它的主人曾是最早的枪手之一。",
}
registerArtifactTranslation{
	originName = "Steamcatcher",
	name="蒸汽捕捉器",
	unided_name="管道覆盖的帽子",
	desc="传说人体热量大部分从头部散失。对于体热来说并不是这样，但奇怪的是，蒸汽是从头部散失的。",
}
registerArtifactTranslation{
	originName = "Shoes of Moving Quickly",
	name="疾行之鞋",
	unided_name="火箭动力靴",
	desc="精确吗？并不。",
}
registerArtifactTranslation{
	originName = "Band of Protection",
	name="守护腰带",
	unided_name="强化的腰带",
	desc="这个腰带使用强化的宝石，将涌出的蒸汽聚集萎一个强力的屏障。",
	["use_power.name"] = function(self, who)
			return ("产生一道超能护盾，吸收%d伤害。护盾持续期间获得%d火焰反击伤害。"):format(self.use_power.shield_power(self, who), who:damDesc(engine.DamageType.FIRE, self.use_power.retaliate_damage(self, who)))
		end,
}
registerArtifactTranslation{
	originName = "Viletooth",
	name="恶毒锯齿",
	unided_name="生锈的蒸汽锯",
	desc="这个上了年头的链锯严重生锈，而且你发现锯刃上有一层薄薄的*东西*。",
	["combat.special_on_hit.desc"]="可能触发随机疾病",
}
registerArtifactTranslation{
	originName = "Mirrorazor",
	name="镜面剃刀",
	unided_name="泛起波纹的传送门",
	desc="一张羊皮纸上，记载了一些传说。",
}
registerArtifactTranslation{
	originName = "Razorlock",
	name="连锁刀片",
	unided_name="连锁在一起的蒸汽锯",
	desc="这套蒸汽链锯以奇特的方式锁在一起，看上去非常锋利",
}
registerArtifactTranslation{
	originName = "Ramroller",
	name = "剃刀平台",
	unided_name="一个。。。战车？",
	desc = "我们曾经这么想：你知道比锯子更好的是什么吗？巨大的锯子。可惜没人能够拿得动它们。所以我们想了一个新颖的主意：将他们安装在一个移动的平台上，以便让我们方便的运输，并获得无与伦比的切割能力。",
}
registerArtifactTranslation{
	originName = "Overcutter",
	name="超级切割者",
	unided_name="大型的蒸汽锯",
	desc="显然早期的蒸汽锯不是为单手使用设计的。",
}
registerArtifactTranslation{
	originName = "Turbocutter",
	name="涡轮切割者",
	unided_name="红色条纹的蒸汽锯",
	desc="你曾经觉得你的蒸汽锯太慢了吗？那么，我有你需要的东西",
}
registerArtifactTranslation{
	originName = "Whipsnap",
	name="鞭笞",
	unided_name="弹簧式蒸汽锯",
	desc="你是否已经厌倦了恼人的敌人用武器攻击你？那么，使用装载了弹簧的鞭笞，你可以迅速制止这一切！",
}
registerArtifactTranslation{
	originName = "Pinwheel",
	name="风车",
	unided_name="尖端装刺的蒸汽锯",
	desc="在他人的生命中建立全新，有趣的连接，比如他们的脚和地板！",
}
registerArtifactTranslation{
	originName = "Frostbite",
	name="霜咬",
	unided_name="冰冷的蒸汽锯",
	desc="因为魔法的冰块而知名，非常适合雕刻冰块——尤其是里面有人的那些。",
}
registerArtifactTranslation{
	originName = "The Lumberator",
	name="播种机",
	unided_name="爬满藤曼的蒸汽锯",
	desc="这台能够注射种子的蒸汽锯可以更快的传播自然的奇迹。在你意识到之前，你的敌人体内将会长出一棵树！",
	}
registerArtifactTranslation{
	originName = "Grinder",
	name="绞肉机",
	unided_name="染血的蒸汽锯",
	desc="起初这个锯子只是被巨人们用来切割坚硬、冰冻的尸体。不过这个例子似乎有一些非常邪恶的暗示。",
}
registerArtifactTranslation{
	originName = "Overclocked Radius",
	name = "超频",
	unided_name = "扭曲的蒸汽锯",
	desc = [[在传统物理学的困境前，某些疯狂的工程师将时间流嵌入链锯中，以达到最大速度。\n\n当然，这样存在一些小小的副作用。]],

}
registerArtifactTranslation{
	originName = "Heartrend",
	name = "心脏切割",
	unided_name = "扭曲的蒸汽锯",
	desc = [[上面粘着一页笔记。
 
'我将我的心血之作分离，感受它的跳动，像心脏一样跳动，在我的手心里。
总有些人不到血流尽，不撒手。']],
}
registerArtifactTranslation{
	originName = "Dethzaw",
	name = "死忘链据",
	unided_name="火焰蒸汽锯",
	desc = [[毁灭者Grushgore发现蒸汽链锯时十分激动，他立刻抓了几个工程师，强迫他们为他做了这个。
	他的取名技巧从没有得到提高。]],
	}
	
registerArtifactTranslation{
	originName = "Eye of the Lost",
	name = "迷失之眼",
	unided_name = "苍白的灵晶",
	desc = [[灵晶周围有一层奇怪的领域。你能感觉到某个存在，但它被遮蔽了，就像它不愿意被察觉到一样。]],
}
registerArtifactTranslation{
	originName = "Brass Goggles",
	name="铜制护目镜",
	unided_name="优质的护目镜",
	desc="没有任何一个自爱的工匠会被人发现没有佩戴它！",
}
registerArtifactTranslation{
	originName = "X-Ray Goggles",
	name = "X射线护目镜",
	unided_name = "漆黑的护目镜",
	desc = "这玩意到底怎么用?",
	}
registerArtifactTranslation{
	originName = "Yeti's Muscle Tissue (Behemoth)",
	name = "雪人族巨大的肌肉组织",
	unided_name = "肌肉",
	desc = "巨大的肌肉，从一个强大的雪人身上取得。某时、某地、某物，正等你过去。",
}
registerArtifactTranslation{
	originName = "Yeti's Muscle Tissue (Mech)",
	name = "雪人族巨大的肌肉组织(机械化)",
	unided_name = "肌肉",
	desc = "巨大的肌肉，从一个强大的雪人身上取得。某时、某地、某物，正等你过去。",
}
registerArtifactTranslation{
	originName = "Yeti's Muscle Tissue (Astral)",
	name = "雪人族巨大的肌肉组织(星界)",
	unided_name = "肌肉",
	desc = "巨大的肌肉，从一个强大的雪人身上取得。某时、某地、某物，正等你过去。",
}
registerArtifactTranslation{
	originName = "Yeti's Muscle Tissue (Patriarch)",
	name = "雪人族巨大的肌肉组织(族长)",
	unided_name = "肌肉",
	desc = "巨大的肌肉，从一个强大的雪人身上取得。某时、某地、某物，正等你过去。",
}
registerArtifactTranslation{
	originName = "Ring of Lost Love",
	name = "逝爱指环",
	unided_name = "纯净的深红色戒指",
	desc = [[这个深红色指环明显充满了甜蜜与苦涩。
它内侧刻有如下短语#{italic}#"献给我的挚爱，我的妻子，我的生命，艾琳。永远爱你的，约翰。"#{normal}#]],
	special_desc = function(self) 
		return "你感觉这个戒指#{bold}#不太对劲#{normal}#." 
	end,
}
registerArtifactTranslation{
	originName = "Pressure-enhanced Slashproof Combat Suit",
	name = "压力感应式作战服",
	unided_name = "蒸汽强化皮衣",
	desc = [[简约的皮甲背后隐藏着精巧的系统，能感应压力启动，确保安全性能。]],
}
registerArtifactTranslation{
	originName = "Brilliant Auto-loading Orc Expeller",
	name = "自动充能式兽人驱逐装置",
	unided_name = "昂贵的枪",
	desc = [[精心打造的枪，专为杀兽人而设计。偶尔也杀杀巨人。]],
}
registerArtifactTranslation{
	originName = "Visage of Nektosh",
	name = "纳克托沙的视野",
	unided_name = "带角头盔",
	desc = [[实话是说，你觉得他的角看上去有点蠢。]],
}

registerArtifactTranslation{
	originName = "The Forgotten",
	name = "被遗忘者",
	unided_name = "苍白的灵晶",
	desc = [[奇怪的灵晶，长满花岗岩而有裂缝。看上去非常古老，严重受损，但还能用。]],
	["use_power.name"] = "半径3内所有敌人混乱5回合。"
	}
registerArtifactTranslation{
	originName = "The Cage",
	name = "牢笼",
	unided_name = "厚皮帽",
	desc = "任何事物都无法再碰触你。",
	special_desc = function(self) 
		return "你免疫精神状态。" end,
}
registerArtifactTranslation{
	originName = "Ritch Claws",
	name = "里奇之爪",
	unided_name = "利爪手套",
	desc = [[从里奇穿刺者那里取下的尖锐的手套。]],
}
registerArtifactTranslation{
	originName = "Stinger",
	name = "针刺",
	unided_name = "奇怪的蒸汽链锯",
	desc = "这是。。。产卵管？",
	}
registerArtifactTranslation{
	originName = "Gardanion, the Light of God",
	name = "神之光辉",
	unided_name = "纯白项链",
	desc = [["#{italic}#阿马克泰尔降临，他创造了太阳，为世界带来生命。
现在，你带着他的一片太阳。不要忘了是谁将它给予你，以免让你变成和那些抛弃他的可怜虫一样。#{normal}#"]],
	special_desc = function(self) return "携带时，获得一个觉醒技能点。" end,
	on_wear = function(self, who)
		who.unused_prodigies = who.unused_prodigies + 1
		self.on_wear = nil
		self.special_desc = nil
		game.logPlayer(who, "#GOLD#神的光辉充盈着你的全身，然后渐渐消退。你感觉更加强大了。(+1觉醒点)")
		game.bignews:saySimple(160, "#GOLD#神的光辉充盈着你的全身，然后渐渐消退。你感觉更加强大了。(+1觉醒点)")
	end,
	}

registerArtifactTranslation{
	originName = "Cap of the Undisturbed Mind",
	name = "平静思维之帽",
	unided_name = "红色的帽子",
	desc = [[为了避免在凝视恐怖的虚空时损伤精神，这顶帽子上镶嵌有存活的大脑组织。
带上它，你能随意仰望星空。]],
	}
registerArtifactTranslation{
	originName = "Yeti Mind Controller",
	name = "雪人精神控制仪",
	unided_name = "雪人精神控制仪",
	desc = "该装置用于攻击雪人族的大脑，为战争武器而设计",
	["use_power.name"] = "操纵虚弱雪人的思维。"
	}			
for i = 1, 3 do
registerArtifactTranslation{
	originName = "strange black disk ("..i..")",
	name = "奇怪的黑色光盘"..i.."号",
	unided_name = "光盘",
	desc = "奇怪的黑色光盘",
}
end

registerArtifactTranslation{
	originName = "Payload",
	name = "荷载",
	unided_name = "奇怪的大枪",
	desc = [["我一点都不喜欢那个村庄。" - 疯狂科学家，查尔塔]],
}
registerArtifactTranslation{
	originName = "Brain Cap",
	name = "脑帽",
	unided_name = "脑帽",
	desc = [[通过把一个大脑装进沃瑞钽罐子里，这个装置可以增加你的精神抗性并让你可以发射出强大的魔法干扰波。]],
}

registerArtifactTranslation{
		originName = "Brain Flare",
		name = "脑耀",
		unided_name = "脑耀",
		desc = "通过把一个大脑装进沃瑞钽罐子里，这个装置可以增加你的精神抗性并让你可以侵入其他人的精神，操纵它们的躯体。",
}
registerArtifactTranslation{
		originName ="Rogue's Gallery",
		name = "盗贼画廊",
		unided_name = "盗贼画廊",
		desc = "内衬各种机械装置，这件披风包含着让你可以应对任何你有可能或不可能遇到的情况的特殊装备！",
		special_desc = function(self) return "生命掉落至20%以下时，释放一阵烟雾,混乱周围生物，令你潜行并有一定几率免疫伤害，持续5回合。" end,
		["use_power.name"] = function(self, who)
			 return "你的下一次伤害会施加致残毒素（毒素消耗前不会进行充能）,造成微弱伤害并令目标有10%几率使用技能失败。" end,
}
registerArtifactTranslation{
		originName ="Stormcutter",
		name = "风暴切割者",
		unided_name = "电化链锯",
		desc = [["适合战斗、烹饪甚至刮胡子！我们并不负责处理刮破皮的问题。"]],
		["combat.special_on_hit.desc"]="造成基于灵巧的闪电眩晕伤害,最多弹射至3名目标处。",
}
registerArtifactTranslation{
		originName = "Steam Powered Armour",
		name = "蒸汽动力甲",
		unided_name = "蒸汽动力甲",
		set_desc = {steamarmor =  "蒸汽多多益善!" },
		desc = "使用小型蒸汽机和你最新发现的自动化技术，你可以制造蒸汽动力装甲。这个板甲增强你的行动能力并提供强大的防护能力。",
}
registerArtifactTranslation{
		originName =  "Hands of Creation",
		name = "创造之手",
		unided_name = "平凡的手套",
		desc = "你的手中曾经创造出了无数惊人的作品，烈火中触摸无数作品的双手也被炽焰所围绕。",
		special_desc = function(self) 
			return "近战攻击将释放火焰冲击波，在范围3的锥形范围内造成等于蒸汽强度的火焰和物理伤害。"
		end,
		}
registerArtifactTranslation{
		originName =  "Life Support Suit",
		name = "生命支持服",
		unided_name = "高级医疗护甲",
		desc = "我们做到了。我们能治疗死亡。",
		special_desc = function(self) 
				local maxp = self:min_power_to_trigger()
			return ("你不会流血。\n当你生命掉落至20%%以下时，治疗30%%最大生命。 %s"):format(self.power < maxp and ("(%d 回合冷却中)"):format(maxp - self.power) or "(15 回合冷却时间)")
		end,
		}
function _M:bindHooks()
	local class = require "engine.class"
	class:bindHook("Entity:loadList", function (self,data)
		if data.file:find("artifact") or data.file:find("zones") or data.file:find("tinker") then
			for _, item in ipairs(data.res) do
				_M.fetchArtifactTranslation(item)
			end
		end
	end)
end