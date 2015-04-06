local class = require "engine.class"
class:bindHook("Entity:loadList", function (self,data)
	if data.file:find("artifact") or data.file:find("zones") then
   for _, item in ipairs(data.res) do
   		if item.name == "Rungof's Fang" then
				item.name = "郎格夫之牙"
				item.unided_name="血痕覆盖的尖牙"
				item.desc  =  "巨型座狼郎格夫之牙，上面仍被血痕覆盖。"
			end
		 if item.name == "Wintertide" then
				item.name = "霜华"
				item.unided_name  = "闪耀的长剑"
				item.desc  =  "这把剑带给这片区域无尽的寒冷，剑锋周围的空气似乎都要凝固了。据说是第一次厄流纪大战期间，孔克雷夫大师为他们的战争之王所打造。"
				item.special_desc = function(self)
					if not self.winterStorm then
						return ("风暴持续时间:  无") 
					else
						return ("风暴持续时间: " .. (self.winterStorm.duration or "无"))
					end
				end
				item.combat.special_on_hit.desc=function(self, who, special) 
					local dam = who:damDesc(engine.DamageType.COLD, special:damage(self, who))
					return ("制 造 不 断 扩 张 的 寒 冰 风 暴 （ 从 半 径 %d 到 半 径 %d） ， 每 回 合 造 成 %.2f 寒 冷 伤 害 （ 基 于 力 量 ） 并 减速  20%%。 接 下 来 的 近 战 攻 击 将 重 置  风暴 位 置 并 延 长 持 续 时间 。 "):format(special.radius, special.max_radius, dam)
				end
				item.use_power.name ="强 化 冰 风 暴 的 冰 雪 ， 冻 结 成 冰 墙 ， 持  续 10 回 合 。"
			end
			 if item.name == "Wintertide Phial" then
				item.name = "霜华之瓶"
				item.unided_name  = "充满黑暗的瓶子"
				item.desc  =  "这个小瓶子似乎充满了黑暗，但却净化了你的思想。"
				item.use_power.name = function(self, who) 
					return ("净 化 你 的 思 想 ， 解 除 至 多 %d 个 （ 基 于 魔 法 ） 负  面 精 神 状 态。")
					:format(self.use_power.nbcure(self, who)) 
				end
			end
			 if item.name == "Fiery Choker" then
				item.name = "炽焰护符"
				item.unided_name  = "火焰制造的护符"
				item.desc  =  "一个由火焰形成的护符，在它的佩戴者身上不断地改变着形状。它的火焰似乎不会伤害到佩戴者。"
			end
			 if item.name == "Frost Treads" then
				item.name = "踏雪"
				item.unided_name  = "覆盖着冰霜的皮靴"
				item.desc  =  "一双摸起来冰凉的皮靴，闪烁着冰冷的蓝色光芒。"
			end
			 if item.name == "Dragonskull Helm" then
				item.name = "苍龙之盔"
				item.unided_name  = "头骨做成的头盔"
				item.desc  =  "在这个灰白而残破的头骨中还残留着巨龙的能量。"
			end
			 if item.name == "Eel-skin armour" then
				item.name = "电鳗皮甲"
				item.unided_name  = "光滑的护甲"
				item.desc  =  "这个护甲似乎由很多电鳗碎片拼接起来。真烦人。"
			end
			 if item.name == "Chromatic Harness" then
				item.name = "七彩鳞甲"
				item.unided_name  = "色彩丰富的鳞片护甲"
				item.desc  =  "这个以巨龙鳞片制成的护甲闪耀着五颜六色的光芒，它们在鳞甲表面不断的变化着。"
			end
			 if item.name == "Glory of the Pride" then
				item.name = "普莱德之荣耀"
				item.unided_name  = "深黑色的戒指"
				item.desc  =  "这是普莱德的战争之王格鲁希纳克最宝贵的财富。这枚金戒指上铭刻着失传的兽人语。"
			end
			 if item.name == "Nightsong" then
				item.name = "暗夜颂歌"
				item.unided_name  = "黑曜石戒指"
				item.desc  =  "一枚纯黑色的戒指。似乎无尽的黑暗缠绕着它。"
			end
			 if item.name == "Steel Helm of Garkul" then
				item.name = "加库尔的钢盔"
				item.unided_name  = "部落头盔"
				item.desc  =  "这是迄今为止，最伟大的兽人毁灭者加库尔的头盔。"
				item.set_desc.garkul = "另 一 件 加 库 尔 的 遗 物 将 唤 醒 他 的 英 灵。"
			end
			 if item.name == "Lunar Shield" then
				item.name = "银月辉盾"
				item.unided_name  = "甲壳质盾牌"
				item.desc  =  "一个从尼米斯尔身上剥离下来的巨大甲壳。它持续发出奇异的白色光芒。"
			end
			 if item.name == "Wrathroot's Barkwood" then
				item.name = "愤怒之根的树皮"
				item.unided_name  = "巨大的树皮"
				item.desc  =  "用狂怒树精的树皮制成的粗糙盾牌。"
			end
			 if item.name == "Petrified Wood" then
				item.name = "硅化木"
				item.unided_name  = "烧毁的木头残片"
				item.desc  =  "从断裂之根身上得到的木头残片。"
			end
			 if item.name == "Crystal Shard" then
				item.name = "水晶之杖"
				item.unided_name="水晶般的树枝"
				item.desc  =  "这柄法杖像水晶般透明，尺寸精确无比，从不同角度看去，反射出种种光芒。凝视着它，你会好奇：它的魔力究竟来自哪里。"
				item.use_power.name = "制 造 两 片 活 的 水 晶 体 来 为 你 服 务 10 回 合。"
			end
			 if item.name == "Black Robe" then
				item.name = "暗黑礼服"
				item.unided_name  = "黑色的礼服"
				item.desc  =  "一件比夜色还黑的丝绸礼服，它向外辐射出能量。"
			end
			 if item.name == "Malediction" then
				item.name = "诅咒"
				item.unided_name  = "散发着瘟疫气息的斧头"
				item.desc  =  "无论这把斧头在哪里，大地都会枯萎和凋零。"
			end
			 if item.name == "Kor's Fall" then
				item.name = "卡尔的陨落"
				item.unided_name  = "黑暗的法杖"
				item.desc  =  "这根法杖由许多生物的骨头制成并散发着能量。你甚至可以在很远的地方感受到它的邪恶气息。"
			end
			 if item.name == "Vox" then
				item.name = "呐喊"
				item.unided_name  = "吵闹的护身符"
				item.desc  =  "没有任何力量能使这个护身符的主人安静下来。"
			end
			 if item.name == "Telos's Staff (Top Half)" then
				item.name = "泰勒斯的法杖（上半部）"
				item.unided_name  = "损坏的法杖"
				item.desc  =  "泰勒斯破损法杖的上半部分。"
			end
			 if item.name == "Choker of Dread" then
				item.name = "恐惧护符"
				item.unided_name  = "黑暗的护符"
				item.desc  =  "这件护符散发着不死生物的邪恶气息。"
				item.use_power.name = "召 唤 一 个 吸 血 鬼 为 你 服 务 15 回 合。"
			end
			 if item.name == "Runed Skull" then
				item.name = "符文头骨"
				item.unided_name  = "人类的头骨"
				item.desc  =  "暗红色的符文遍布着这块黑色头骨。"
			end
			 if item.name == "Bill's Tree Trunk" then
				item.name = "比尔的树干"
				item.unided_name  = "巨大的树干"
				item.desc  =  "这是一个巨大的、丑陋的树干，但是巨魔比尔把它当做武器。如果你够强壮，你也可以把它当做武器！"
			end
			 if item.name == "Sanguine Shield" then
				item.name = "血色盾牌"
				item.unided_name  = "血迹斑斑的盾牌"
				item.desc  =  "尽管这个盾牌被鲜血染上并玷污了，但是阳光会继续照耀着它。"
			end
			 if item.name == "Whip of Urh'Rok" then
				item.name = "厄洛克之鞭"
				item.unided_name  = "炽热的鞭子"
				item.desc  =  "用这根炽焰打造的鞭子，恶魔领主厄洛克未尝一败。"
			end
			 if item.name == "Warmaster Gnarg's Murderblade" then
				item.name = "战争之王格纳哥的饮血剑"
				item.unided_name  = "血迹斑斑的巨剑"
				item.desc  =  "一把血迹斑斑的巨剑，它洞穿了许多敌人。"
				item.combat.special_on_hit.desc="10%% 几 率 令 持 有 者 进 入 嗜 血 状 态。"
			end
			 if item.name == "Crown of the Elements" then
				item.name = "元素王冠"
				item.unided_name  = "镶嵌宝石的王冠"
				item.desc  =  "这顶镶嵌宝石的王冠闪闪发光。"
			end
			 if item.name == "Flamewrought" then
				item.name = "炽焰手套"
				item.unided_name  = "甲壳制成的手套"
				item.desc  =  "这副手套似乎是由里奇之焰的骨骼组成。它们摸上去非常热。"
			end
			 if item.name == "Crystal Focus" then
				item.name = "魔力结晶"
				item.unided_name  = "闪耀的水晶"
				item.desc  =  "这个水晶散发着魔力的光辉。"
				item.use_power.name = "安装至一把武器"
			end
			 if item.name == "Crystal Heart" then
				item.name = "水晶之心"
				item.unided_name  = "曲线状的水晶"
				item.desc  =  "这颗水晶很大，几乎和你的头一样大。它闪烁着动人的光辉。"
				item.use_power.name = "安装至一件护甲"
			end
			 if item.name == "Rod of Annulment" then
				item.name = "废除之枝"
				item.unided_name  = "黑暗的枝条"
				item.desc  =  "你可以感受到枝条周围的魔力流失，甚至它自己也似乎受到了影响。"
				item.use_power.name = function(self, who) 
					return ("将 半 径 %d 内 的 一 个 目 标 的 至 多 3 个 纹 身、 符 文 或 技 能 打 入 3-5 回 合 的 冷 却。")
					:format(self.use_power.range)
				end
			end
			 if item.name == "Skullcleaver" then
				item.name = "碎颅战斧"
				item.unided_name  = "深红色的战斧"
				item.desc  =  "一把小巧而锋利的斧头，斧柄由打磨过的骨头制成。这把斧头打破了许多头骨，并被染成了鲜红色。"
			end
			 if item.name == "Tooth of the Mouth" then
				item.name = "深渊之牙"
				item.unided_name  = "一个钉耙"
				item.desc  =  "在无尽深渊中得到的一颗巨大牙齿。"
			end
			 if item.name == "The Warped Boots" then
				item.name = "扭曲之靴"
				item.unided_name  = "有着难看痕迹的靴子"
				item.desc  =  "这些被玷污的靴子已经丧失了它们以前的荣耀，现在，它们只能作为深渊的存在以及腐蚀力量的证明。"
			end
			 if item.name == "The Gaping Maw" then
				item.name = "贪婪之胃"
				item.unided_name  = "巨大的冰冷战斧"
				item.desc  =  "这柄战斧看起来更像狼牙棒，它的手柄是由黑木制成并包裹着一层蜉蝣皮，它的刃锋处闪耀着粘稠的绿色液体。"
				item.combat.special_on_crit.desc="在 3 码 锥 形 范 围 内 造 成 等 于 精 神 强 度 的 法 力 燃 烧 伤 害。"
			end
			 if item.name == "Withering Orbs" then
				item.name = "枯萎眼球"
				item.unided_name  = "阴影缠绕的眼球"
				item.desc  =  "这些泛着乳白色光芒的眼球用死亡的眼神看着你，你的虚荣和虚伪使其苏醒。他们曾经在难以想象的恐惧中死亡，现在它们被黑色的丝线串起，周围缠绕着片片阴影。如果你闭上眼睛一段时间，你甚至可以感受到它们曾经看到的恐怖画面……"

			end
			 if item.name == "Borfast's Cage" then
				item.name = "波法斯特的牢笼"
				item.unided_name  = "一套满是凹痕的板甲"
				item.desc  =  "英尺厚的蓝锆石板甲，关节部分由沃瑞钽组成。整套铠甲看起来异常坚固，但是显然它有过非常可怕的经历——巨大的凹痕、扭曲的关节以及腐蚀的表面。尽管现在看起来只是一块坚固的铁板，但是它显然有着辉煌的过去。"

			end
			 if item.name == "Aletta's Diadem" then
				item.name = "阿蕾塔的王冠"
				item.unided_name  = "镶有珠宝的王冠"
				item.desc  =  "一个镶嵌有很多珠宝的银制艺术品，这顶王冠看起来光芒四射而又美丽优雅。但是当你碰到它时，你感到你的皮肤都要冻僵了，许多狂暴的意识涌向你的大脑。你想丢弃它，扔掉它，但是你最终无法抗拒它能带给你的力量。是你的意志太薄弱，还是这件史诗支配了你？"

			end
			 if item.name == "Hare-Skin Sling" then
				item.name = "大白兔投石索"
				item.unided_name  = "兔皮投石索"
				item.desc  =  "这把投石索是由一只巨大的野兔皮精制而成。它摸起来光滑柔软却十分耐用。有人说，野兔皮可以带来幸运。很难说它是否会真的帮助使用者，但是很显然这副毛皮既结实又可靠。"

			end
			 if item.name == "Prox's Lucky Halfling Foot" then
				item.name = "普洛克斯的幸运半身人脚"
				item.unided_name  = "一只风干的半身人脚"
				item.desc  =  "一只用细线串起来的巨大毛脚，很显然这是一位半身人的。目前的状态，很难讲它多久以前被割了下来，但是从脚踝处的齿痕来看，应该不是出于自愿。它的外面有一层盐和粘土，被很好的保护着，尽管如此，大自然还是剥夺了它的活力，它已经成为了一块死肉。有人说，半身人的脚可以带来好运，但是现在唯一可确认的是——它臭死了！"
				item.special_desc = function(self)
					local ready = self:min_power_to_trigger() - self.power
					return ("侦 查 陷 阱。\n25%% 几 率 解 除 至 多 3 个 震  慑 、 定 身 或 眩 晕 效 果。%s"):format((ready > 0) and (" (冷却: %d 回 合)"):format(ready) or "")
				end
			end
			 if item.name == "Storm Fury" then
				item.name = "风暴之怒"
				item.unided_name  = "电弧缠绕的长弓"
				item.desc  =  "这把龙骨长弓由精钢镶制而成，一道道电弧缠绕在其身上，闪电球在其弓弦上徘徊，但是却绕过了你的手臂。"
				item.special_desc = function(self) return "自 动 发 射 闪 电 攻 击 附 近 敌 人 ， 有 几 率 使 之 眩 晕。" end
			end
			 if item.name == "Frozen Shroud" then
				item.name = "冰霜斗篷"
				item.unided_name  = "冰冷的斗篷"
				item.desc  =  "格拉希尔·雷金的全部剩余。这件斗篷散发着的寒气冻结了周围的一切。"
				item.use_power.name = function(self, who)
						local dam = who:damDesc(engine.DamageType.COLD, self.use_power.damage(self, who))
						return ("在半 径 %d 范 围 内 制 造 寒 冰 霜 雾 ，每 回 合 造 成 %0.2f 寒 冷 伤 害 （ 基 于 魔 法 ），持 续 %d 回 合。"):format(self.use_power.radius, dam, self.use_power.duration)
				end
			end
			 if item.name == "Blighted Maul" then
				item.name = "枯萎之锤"
				item.unided_name  = "腐烂的石化肢体"
				item.desc  =  "这是腐化泰坦的一部分沉重肢体，一大块腐烂的石化躯体。你认为你可以轻易举起它，但事实证明，它重的不可思议。"
				item.combat.special_on_hit.desc = function(self, who, special)
					local dam = who:damDesc(engine.DamageType.PHYSICAL, special.shockwavedam(self, who, special))
					return ("制 造 半 径 1 的 冲 击 波 ， 造 成 %0.2f 到 %0.2f 枯 萎 伤 害 。 ( 基 于 力 量)。"):format(dam, dam *3)
				end
				item.use_power.name = function(self, who)
					local dam = who:damDesc(engine.DamageType.PHYSICAL, self.use_power.damage(self, who))
					return ("击 退 半 径 %d 的 生 物 ， 造 成 %0.2f 到 %0.2f 物 理 伤 害   ( 基 于 力 量  )。"):format(self.use_power.radius, dam, dam*2)
				end
			end
			 if item.name == "Molten Skin" then
				item.name = "炽热之皮"
				item.unided_name  = "炙热的骨甲" 
				item.desc  =  "这件由笨重的森提内尔身上扒下的皮甲散发着阵阵高温。由于森提内尔核心的强大能量，它一直在发红发亮。不过它似乎不会伤害到你。"

			end
			 if item.name == "Void Orb" then
				item.name = "虚空之球"
				item.unided_name  = "飘渺的戒指"
				item.desc  =  "这只戒指装饰有深黑色的水晶。仿佛有白色的星云在戒指上缭绕，水晶的核心处偶尔有紫色的光一闪而过。"

			end
			 if item.name == "Khulmanar's Wrath" then
				item.name = "库马纳的怒火"
				item.unided_name  = "燃烧的黑色战斧"
				item.desc  =  "黑色的浓烟缠绕在这把战斧上，恐惧长廊的烈焰在其身上咆哮。这把战斧由厄洛克授予他最强大的指挥官，它可以焚尽一切，包括最强大的敌人。"

			end
			 if item.name == "The Bladed Rift" then
				item.name = "次元裂隙"
				item.unided_name  = "空间中的裂隙"
				item.desc  =  "在击败阿克·吉希尔后，它留下了这个小巧的裂隙。你无从知道，它是如何保持这样的稳定状态。冥冥中你感受到，你能从这个裂隙中召唤出一把剑。"

			end
			 if item.name == "Blade of Distorted Time" then
				item.name = "时光扭曲之刃"
				item.unided_name  = "扭曲时间的剑"
				item.desc  =  "这把剑由一段损坏的时间线构成，它在不断的出入相位现实。"
				item.combat.special_on_hit.desc="造 成 额 外 时 空 伤 害 并 减 速 目 标 "

			end
			 if item.name == "Rune of Reflection" then
				item.name = "反射符文"
				item.unided_name  = "闪光的符文"
				item.desc  =  "你可以在这块银色的符文表面看到自己的倒影。"

			end
			 if item.name == "Psionic Fury" then
				item.name = "灵能之怒"
				item.unided_name  = "震动的灵晶"
				item.desc  =  "这颗灵晶在不停的震动，仿佛其中有一股强大的力量试图从中逃脱。"
				item.use_power.name = function(self, who) 
					return ("释放灵能冲击波，造成%0.2f精神伤害（基于意志），伤害半径%d。")
					:format(who:damDesc(engine.DamageType.MIND, self.use_power.damage(self, who)), self.use_power.radius)
				end
			end
			 if item.name == "Life Drinker" then
				item.name = "生命汲取者"
				item.unided_name  = "沾满了鲜血的匕首"
				item.desc  =  "愚者之血，邪魔之刃。"

			end
			 if item.name == "Trident of the Tides" then
				item.name = "潮汐之戟"
				item.unided_name  = "不停滴水的三叉戟"
				item.desc  =  "这把三叉戟上流动着潮汐的力量。需习得异形武器天赋才能正确使用三叉戟。"

			end
			 if item.name == "Telos Spire of Power" then
				item.name = "泰勒斯之力"
				item.unided_name  = "脉动的法杖"
				item.desc  =  "泰勒斯是黄昏纪的一位强大法师，为对手所嫉恨，为弱者所惧怕。最终，虽然他陨落在了他的所在之处——泰尔玛，但是他的灵魂仍长存于世。"

			end
			 if item.name == "Staff of Destruction" then
				item.name = "毁灭之杖"
				item.unided_name  = "充满黑暗气息的法杖"
				item.desc  =  "这个品相独特的法杖上刻印着毁灭符文。"

			end
			 if item.name == "Penitence" then
				item.name = "忏悔"
				item.unided_name  = "通红的法杖"
				item.desc  =  "永恒精灵密送到安格利文，用以对抗魔法大爆炸所引起灾难的强大法杖。"
				item.use_power.name = function(self, who) 
					return ("治愈至多 %d 项疾病和毒素。 ( 基于魔法 )")
					:format(self.use_power.cures(self, who)) 
					end
			end
			 if item.name == "Lost Staff of Archmage Tarelion" then
				item.name = "大法师泰尔兰丢失的法杖"
				item.unided_name  = "闪光的法杖"
				item.desc  =  "大法师泰尔兰在年轻的时候曾环游世界。但是这个世界并不是那么美好以至于我们的大法师不得不飞速逃跑。"

			end
			 if item.name == "Bolbum's Big Knocker" then
				item.name = "鲍尔本的大门扣"
				item.unided_name  = "一根厚重的法杖"
				item.desc  =  "这是一根末端有着厚重门扣的沉重法杖。据说是炼金魔导师鲍尔本在厄流纪使用的法杖。它之所以闻名于世，大部分来源于鲍尔本的学生们对他的恐惧以及被它打伤脑袋的超高几率。鲍尔本被7把匕首插在后背而死，那根被众人诅咒的法杖也从此消失不见。"

			end
			 if item.name == "Vargh Redemption" then
				item.name = "瓦尔弗的救赎"
				item.unided_name  = "海蓝色的戒指"
				item.desc  =  "这个海蓝色的戒指看上去总是水汪汪的。"
				item.use_power.name = function(self, who)
				local dam = self.use_power.damage(self, who)
					return ("召 唤 缓 慢 扩 张 的 半 径 %d 的 潮 汐 ， 持 续 %d 回 合 ， 每 回 合 造 成 %0.2f 寒 冷 和 %0.2f 物 理 伤 害 ， 并 击 退 敌 人。")
					:format(self.use_power:radius(who), self.use_power.duration(self, who), who:damDesc(engine.DamageType.COLD, dam/2), who:damDesc(engine.DamageType.PHYSICAL, dam/2)) 
				end
			end
			 if item.name == "Ring of the Dead" then
				item.name = "亡者之戒"
				item.unided_name  = "黯淡的戒指"
				item.desc  =  "这枚戒指充溢着坟墓的气息。据说佩戴它的人会在走投无路时发现新的道路。"
				item.special_desc = function(self) return "能 把 你 从 死 亡 的 边 缘 挽 救 一 次 。" end
			end
			 if item.name == "Elemental Fury" then
				item.name = "元素之怒"
				item.unided_name  = "多彩戒指"
				item.desc  =  "这枚戒指闪耀着多种不同的色彩。"
				item.special_desc = function(self) return "你 造 成 的 所 有 伤 害 被 转 化 均 分 为 奥 术 、火 焰 、 寒 冷 和 闪 电 伤 害。" end
			end
			 if item.name == "Spellblaze Echoes" then
				item.name = "战争回响"
				item.unided_name  = "深黑色的项链"
				item.desc  =  "当你戴上这个古老的项链，似乎耳边仍回荡着第一次大战的战鼓声。"
				item.use_power.name = function(self, who)
					return ("释放毁灭哀嚎，摧毁地形，造 成 %0.2f 物理伤害 (基于 魔法) 伤害半径 %d"):format(engine.interface.ActorTalents.damDesc(who, engine.DamageType.PHYSICAL, self.use_power.damage(who)), self.use_power.radius)
				end
			end
			 if item.name == "Feathersteel Amulet" then
				item.name = "失重项链"
				item.unided_name  = "很轻的项链"
				item.desc  =  "当你带着这个项链，似乎整个世界都轻飘飘的。"

			end
			 if item.name == "Daneth's Neckguard" then
				item.name = "丹纳斯的护颈"
				item.unided_name  = "一个沉重的钢制护颈"
				item.desc  =  "一个厚重的钢护喉，旨在保护其穿着者颈部免受致命攻击。这个特殊的护喉是半身人将军丹纳斯·坦德莫恩在派尔纪战争中佩戴过的，上面的各种伤痕表明其可能救过这位将军不止一次。"

			end
			 if item.name == "Garkul's Teeth" then
				item.name = "加库尔的牙齿"
				item.unided_name  = "一个用牙齿串成的项链"
				item.desc  =  "数以百计的人类牙齿被串在用多股皮革结成的绳索上，组成了这个部落项链。那些牙齿并非吞噬者加库尔自己的，而是来自于加库尔的食物。"
				item.set_desc.garkul = "另 一 件 加 库 尔 的 遗 物 将 唤 醒 他 的 英 灵。"
			end
			 if item.name == "Summertide Phial" then
				item.name = "夏日之殇"
				item.unided_name  = "通红的小药瓶"
				item.desc  =  "一个小水晶瓶里捕获了夏日的阳光。"
				item.use_power.name = function(self, who) 
					return ("召 唤 阳 光 (%d强 度 ,基 于 意志 )"):format(self.use_power.litepower(self, who)) 
				end
			end
			 if item.name == "Burning Star" then
				item.name = "灼炎之星"
				item.unided_name  = "燃烧着的宝石"
				item.desc  =  "第一个发现如何将日光捕获并注入宝石之中的人是厄流纪的一个半身人大法师。这颗宝石是他们的工艺结晶。光芒从宝石那玲珑剔透的黄色表面放射出来。"
				item.use_power.name = "揭示周围20码的地形"
			end
			 if item.name == "Dúathedlen Heart" then
				item.name = "多塞德兰之心"
				item.unided_name  = "一个暗红色的肉块"
				item.desc  =  "这颗暗红色的心脏虽然离开了它的主人，但仍在跳动着。它还会熄灭任何靠近它的光源。"

			end
			 if item.name == "Guidance" then
				item.name = "指引者"
				item.unided_name  = "一颗散发着柔和光芒的水晶"
				item.desc  =  "曾经属于魔法狩猎时期的检察官玛库斯·丹。这个拳头大小的石英晶体不断散发出柔和的白光。而且据说对冥想有相当大的帮助，不但可以帮助集中精神、身体，还可以保护持有者的灵魂，并且保护他们免遭邪恶魔法的侵蚀。"

			end
			 if item.name == "Blood of Life" then
				item.name = "生命之血"
				item.unided_name  = "血红的药瓶"
				item.desc  =  "生命之血！它可以把一个生物复活以防他英年早逝。但是只能用一次！"
				item.use_simple.name = "喝 下 生 命 之 血 以 获 得 一 次 额 外 生 命。"
			end
			 if item.name == "Thaloren-Tree Longbow" then
				item.name = "精灵树长弓"
				item.unided_name  = "光辉的精灵木长弓"
				item.desc  =  "在魔法大爆炸的余波里，自然精灵不得不从敌人和大火中保卫他们的森林。尽管精灵们奋力的抢救它们，许多树还是死掉了。它们的遗体被打造成一张弓用来抵御黑暗的侵袭。"

			end
			 if item.name == "Corpsebow" then
				item.name = "腐尸之弓"
				item.unided_name  = "腐朽的长弓"
				item.desc  =  "一件黄昏纪遗失的武器，腐尸之弓浑身缠绕着那个时代的瘟疫精华。被腐朽弓弦射出的箭所击中的人，会因古老疾病在体内的共鸣而倍受折磨。"

			end
			 if item.name == "Eldoral Last Resort" then
				item.name = "艾德瑞尔的最后手段"
				item.unided_name  = "精良的投石器"
				item.desc  =  "投石器的把手上有一段铭文：“愿持有者于对抗黑暗之时被赐予神一般的机智。”"

			end
			 if item.name == "Spellblade" then
				item.name = "魔宗利刃"
				item.unided_name  = "光辉的长剑"
				item.desc  =  "法师总是时不时冒出古怪的点子。大法师沃利尔曾学会了怎样擎起一柄剑，同时发现自己对耍剑比玩法杖更感冒。"

			end
			 if item.name == "Genocide" then
				item.name = "兽人末日·灭族之刃"
				item.unided_name  = "漆黑的剑"
				item.desc  =  "法瑞安曾是图库纳国王的指挥官，在最后希望的伟大战役中跟随国王并肩作战。然而，当战争结束，凯旋归来之时，他却发现故乡处处燃烧着兽人的火焰，无边的怒火吞噬了他。复仇的欲望使他离开军队，孤身一人踏上了征程，他除了护甲之外只带了一柄剑。大多数人认为他已经死了。直到有消息称有一个毁灭者般的身影正在摧残兽人的营地，他屠杀了所有见到的兽人并残忍的肢解对方的尸体。据说他每天要用100个兽人的鲜血来祭刀直到杀光马基埃亚尔的兽人。当最后一个兽人被杀死并且没有发现更多的时候，法瑞安最终把利刃转向了自己——那把剑刺穿了他的胸膛。那些在附近的目击者说，当法瑞安这样做的时候身体伴随着阵阵痉挛，他们说不清他到底是哭是笑。"

			end
			 if item.name == "Unerring Scalpel" then
				item.name = "精准的解剖刀"
				item.unided_name  = "锋利的长解剖刀"
				item.desc  =  "这把解剖刀曾经被可怕的男巫卡·普尔在尘埃纪刚开始学习通灵术时使用。许多人，生物和尸体都成为了他那可怕实验的牺牲品。"

			end
			 if item.name == "Eden's Guile" then
				item.name = "艾登的狡诈"
				item.unided_name  = "一双黄色的靴子"
				item.desc  =  "这双靴子属于一位流浪的盗贼，他处理麻烦的方法就是三十六计走为上计。"
				item.use_power.name = function(self, who)
				 return ("增 加 %d%% 速 度(基于灵巧)"):format(100 * self.use_power.speedboost(self, who)) end
			end
			 if item.name == "Fire Dragon Shield" then
				item.name = "火龙之盾"
				item.unided_name  = "龙盾"
				item.desc  =  "这个巨大的盾牌使用了很多生活在塔·埃亚尔失落之地的火龙的鳞片打造而成。"

			end
			 if item.name == "Titanic" then
				item.name = "泰坦尼克"
				item.unided_name  = "巨型盾牌"
				item.desc  =  "这面用最深邃的蓝锆石打造的盾牌巨大、沉重且相当坚固。"

			end
			 if item.name == "Rogue Plight" then
				item.name = "刺客契约"
				item.unided_name  = "破烂的轻皮护甲"
				item.desc  =  "盗贼之刃将不能加于装备者之身。"
				item.special_desc = function(self) 
					return "每 4 回 合 将 一 项 流 血 、 毒 素 或 伤 口 效 果 转 移 给 效 果 来 源 或 者 附 近 的 敌 人" 
				end
			end
			 if item.name == "Mummified Egg-sac of Ungolë" then
				item.name = "温格勒的僵化卵囊"
				item.unided_name  = "黝黑的蛋"
				item.desc  =  "摸起来又干又脏，它看起来仍旧保存着一些生命的气息。"
				item.use_power.name = "召唤两个蜘蛛"
			end
			 if item.name == "Helm of the Dwarven Emperors" then
				item.name = "矮人王头盔"
				item.unided_name  = "闪光头盔"
				item.desc  =  "镶嵌着一颗钻石的矮人头盔，这颗宝石的光辉可以驱散地下一切阴影。"

			end
			 if item.name == "Orc Feller" then
				item.name = "兽人砍伐者"
				item.unided_name  = "光辉的匕首"
				item.desc  =  "据说在艾德瑞尔战争中，半身人盗贼赫拉在保护一群难民时杀死了100多个兽人。"

			end
			 if item.name == "Silent Blade" then
				item.name = "静寂之刃"
				item.unided_name  = "光辉的匕首"
				item.desc  =  "一把锋利，阴暗，完全融入了阴影中的匕首。"

			end
			 if item.name == "Moon" then
				item.name = "月"
				item.unided_name  = "月牙形匕首"
				item.desc  =  "一把弧形的匕首，传说是用取自月亮的材料打造的。它吞噬了周围的光芒，显得黯淡。"
				item.set_desc.moon = "没 有 星 星 的 天 空 里 ， 月 亮 显 得 非 常 孤 单。"	
		end
			 if item.name == "Star" then
				item.name = "星"
				item.unided_name  = "锯齿短刃"
				item.desc  =  "传说之刃，闪耀如星。由取自陨石的材料锻造而成，它散发着光芒。"
				item.set_desc.star = "没 有 月 亮 的 天 空 里 ， 星 星 显 得 非 常 孤 单。"
			end
			 if item.name == "Ring of the War Master" then
				item.name = "战争领主之戒"
				item.unided_name  = "边缘锋利的戒指"
				item.desc  =  "散发能量、边缘开刃的戒指。当你戴上它时，陌生的痛苦念头和毁灭的情景涌入你脑海。"

			end
			 if item.name == "Voratun Hammer of the Deep Bellow" then
				item.name = "沃瑞钽的咆哮"
				item.unided_name  = "被火烧焦的沃瑞钽之锤"
				item.desc  =  "矮人神匠的传奇铁锤。由于年复一年的在高温下打造强力的武器，自身也变的相当强力。"

			end
			 if item.name == "Unstoppable Mauler" then
				item.name = "势不可挡之槌"
				item.unided_name  = "重槌"
				item.desc  =  "拥有难以想象重量的巨型大槌。挥舞它让你感觉势不可挡。"

			end
			 if item.name == "Crooked Club" then
				item.name = "畸形法杖"
				item.unided_name  = "不可思议的棍子"
				item.desc  =  "诡异扭曲的法杖，尾部异常沉重。"

			end
			 if item.name == "Nature's Vengeance" then
				item.name = "自然的复仇"
				item.unided_name  = "木质粗权杖"
				item.desc  =  "这把加粗的权杖曾属于猎魔人沃尔兰，他从一棵在魔法大爆炸中被连根拔起的古老橡树中取材制造了它。众多法师和女巫倒在了这把武器之下，他们对自然犯下的罪行得到了制裁。"

			end
			 if item.name == "Spider-Silk Robe of Spydrë" then
				item.name = "斯派德的蛛丝礼服"
				item.unided_name  = "蛛丝礼服"
				item.desc  =  "这套礼服完全用蛛丝制成。它看起来充满异国风情，一些智者推测它来自另一个世界，很可能穿越过时空之门。"

			end
			 if item.name == "Dragon-helm of Kroltar" then
				item.name = "库洛塔的龙盔"
				item.unided_name  = "龙盔"
				item.desc  =  "一个装饰着黄金浮雕的钢铁全盔。库洛塔的头盔上昂立着最伟大的喷火龙作为装饰。"
				item.set_desc.kroltar = "库 洛 塔 的 力 量 隐 藏 在 他 的 鳞 片 里。"
			end
			 if item.name == "Crown of Command" then
				item.name = "领袖的皇冠"
				item.unided_name  = "无瑕的纯银王冠"
				item.desc  =  "半身人国王洛帕曾佩戴这顶王冠，他曾于尘埃纪统治着纳格尔大陆。那是黑暗的年代，国王通过最残暴的手段执行他的命令和法律。任何违背他思想的人都被严厉的惩罚，任何反对他的人都被无情的镇压，这些人大部分都无声无息的消失了——被关进了国王那不计其数的监狱里。所有人都必须表示忠诚或者付出昂贵的代价。他在没有子嗣的情况下死去，皇冠失踪的同时他的国家也陷入了混乱。"

			end
			 if item.name == "Gloves of the Firm Hand" then
				item.name = "铁腕之手套"
				item.unided_name  = "沉重的手套"
				item.desc  =  "这副手套让你觉得坚如磐石！这双充满魔力的手套从里面摸起来无比松软。在其外，魔法石创造了一个不断转动的粗糙表面。当你振作精神，一束包含大地能量的魔法射线会将它自动扎根在地面上，赋予你更高的稳定性。"

			end
			 if item.name == "Dakhtun's Gauntlets" then
				item.name = "达克顿的臂铠"
				item.unided_name  = "精工打造的矮人钢护手"
				item.desc  =  "厄流纪由大师级铁匠打造而成。那些矮人钢臂铠镂刻着晦涩难懂的金色符文，据说它们可以赋予穿戴者强大的魔武力量。"

			end
			 if item.name == "Fists of the Desert Scorpion" then
				item.name = "沙蝎之拳"
				item.unided_name  = "有着锋利尖刺的拳套"
				item.desc  =  [[这只有着锋利尖刺的拳套属于一位派尔纪统治西部荒野的兽人领主，他依靠它们对埃尔瓦拉发动了数次袭击。他外号沙蝎，在战场上所向披靡，他可以用精神力量将敌人拉过来，也可以用拳套把箭矢挡下。通常永恒精灵法师们在死前看到的最后物品，便是这只黄黑相间的拳套残影。最终沙蝎在决斗中，被炼金术师奈瑟莉亚击败。当这副拳套的主人将精灵拉向他，还没来得及将她撕成两半时，精灵掀开了她的长袍——下面捆着的是八十多枚炼金炸弹。精灵指尖的火花，引发了数里外都能看到的大爆炸。直到今天，民间仍流传着奈瑟莉亚为保护她的子民而牺牲的诗歌。]]

			end
			 if item.name == "Snow Giant Wraps" then
				item.name = "冰霜巨人护手"
				item.unided_name  = "毛衬里的皮护手"
				item.desc  =  "两大块皮革被设计成包裹手和前臂。这副独特的护手经过了附魔，可给予穿戴者巨大的力量。"
				item.set_desc.giantset = "如果有一条相衬的腰带就好了。"
			end
			 if item.name == "Mighty Girdle" then
				item.name = "巨人腰带"
				item.unided_name  = "结实而肮脏的腰带"
				item.desc  =  "这条腰带被赋予了神秘的魔力来对抗膨胀的腰围。不管它蕴含着的是何种力量，它总是能在你负重不足时助你一臂之力。"
				item.set_desc.giantset = "如果有一对大些的手套就好了。"
			end
			 if item.name == "Storm Bringer's Gauntlets" then
				item.name = "风暴使者臂铠"
				item.unided_name  = "细孔臂铠"
				item.desc  =  "这副细孔沃瑞钽臂铠被闪烁着蓝色能量的雕文所覆盖。这种金属柔软且轻盈，不会对施法造成阻碍。制造这副手套的时间和地点都是一个谜，但是可以确认的是，制造者对于魔法技术有一定的了解。"

			end
			 if item.name == "Serpentine Cloak" then
				item.name = "蛇纹斗篷"
				item.unided_name  = "破碎的斗篷"
				item.desc  =  "这件斗篷散发着恶毒和狡诈的气息。"

			end
			 if item.name == "Wind's Whisper" then
				item.name = "风之密语"
				item.unided_name  = "流彩斗篷"
				item.desc  =  "当魔法师瑞兹恩被猎魔人在岱卡拉的山隘逼入绝境时，她用斗篷包裹着自己逃下了峡谷。猎手们接连不断的把箭射向她，但由于奇迹或是魔法，他们全部射空了。瑞兹恩得以逃生并躲进了西部的隐秘之城。"

			end
			 if item.name == "Vestments of the Conclave" then
				item.name = "主教的礼服"
				item.unided_name  = "破烂的长袍"
				item.desc  =  "这件古老的礼服从厄流纪保存了下来。上古的魔法力量占据着它。它由人类专门为人类制造；只有他们才能驾驭这件长袍的真正力量。"

			end
			 if item.name == "Firewalker" then
				item.name = "烈焰行者"
				item.unided_name  = "燃烧的长袍"
				item.desc  =  "这件炙热的长袍曾属于疯狂的烈焰术士哈克特，他在尘埃纪威胁过很多城镇，正当人们努力从战争中恢复元气的时候，他竟然对城镇烧杀抢掠。最终他被伊格兰斯捕获了。伊格兰斯割下他的舌头，砍掉他的脑袋，并把他的身体撕成小块。他的脑袋被封在一个大冰块里，并且在附近城镇的居民欢庆中进行了游街。只有这件长袍从哈克特的烈焰中保留了下来。"

			end
			 if item.name == "Robe of the Archmage" then
				item.name = "大法师的长袍"
				item.unided_name  = "闪闪发光的长袍"
				item.desc  =  "朴素的精灵丝绸长袍。如果不是它放射出的惊人威力，它真的毫不起眼。"

			end
			 if item.name == "Temporal Augmentation Robe - Designed In-Style" then
				item.name = "时空增益·引领时尚"
				item.unided_name  = "有领带的时髦长袍"
				item.desc  =  "被有些古怪的时空法师设计出来，无论穿戴者在哪个时代，这袍子都显得格外时髦。它为协助时空法师冒险而制作。这件法袍对掌握时间多样性的人来说有着巨大的作用。有趣的是，由于它第四任主人参与了一场相当漫长的战斗，长袍上附带了一条很长的幻彩领带。"
				item.set_desc.tardis = "奇怪的是，它没有一顶帽子。"
			end
			 if item.name == "Telos's Staff Crystal" then
				item.name = "泰勒斯的法杖水晶"
				item.unided_name  = "闪耀的白水晶"
				item.desc  =  "近距离欣赏这颗纯净的白水晶，你会发现很多种颜色在上面盘旋闪耀。"

			end
			 if item.name == "Voice of Telos" then
				item.name = "泰勒斯之声"
				item.unided_name  = "闪耀的白色法杖"
				item.desc  =  "对这根纯净的白色法杖近距离欣赏会发现很多种颜色在上面盘旋闪耀。"

			end
			 if item.name == "Gwai's Burninator" then
				item.name = "戈瓦的燃烧斗志"
				item.unided_name  = "炽热的魔杖"
				item.desc  =  "戈瓦，一个生活在魔法狩猎时的火焰术士，她被一群猎魔人逼入了绝境。她战斗至最后一刻，据说在她流尽最后一滴血之前她用这把魔杖干掉了至少十人。"
				item.use_power.name = function(self, who)
					return ("发 射 长 度 %d 的 锥 形 火 焰 ， 造 成 %0.2f 火 焰 伤 害 （ 基 于 魔 法）。"):format(self.use_power.radius, engine.interface.ActorTalents.damDesc(who, engine.DamageType.FIRE, self.use_power.damage(self, who)))
				end
			end
			 if item.name == "Crude Iron Battle Axe of Kroll" then
				item.name = "克罗尔的生铁战斧"
				item.unided_name  = "生铁战斧"
				item.desc  =  "打造于矮人学会精巧工艺之前，外表的粗糙掩盖了这把斧头的强大威力。不过也只有矮人才能让它发挥出真正的力量。"

			end
			 if item.name == "Drake's Bane" then
				item.name = "屠龙"
				item.unided_name  = "凶猛的锋利战斧"
				item.desc  =  "库洛塔的噩梦，最强大的龙，7个月的时间她带走了20，000矮人战士的生命。这条猛兽的力气最终被耗尽了，工匠大师格鲁克西姆，站在同伴们尸体的顶端，他用这把精工打造的斧头斩开了龙的鳞甲，剖开了龙的喉咙。"

			end
			 if item.name == "Blood-Letter" then
				item.name = "血字"
				item.unided_name  = "冰冷的手斧"
				item.desc  =  "用北部荒原的寒冰之核雕成的手斧。"

			end
			 if item.name == "Scorpion's Tail" then
				item.name = "猩红毒针"
				item.unided_name  = "合金鞭"
				item.desc  =  "一条金属串接的长鞭，尾端锋利的邪恶倒刺渗透着毒液。"

			end
			 if item.name == "Rope Belt of the Thaloren" then
				item.name = "自然精灵的绳索腰带"
				item.unided_name  = "一截短绳"
				item.desc  =  "最朴素的腰带，被奈希拉·坦泰兰在领导她的人民和森林期间穿戴了几个世纪。这条腰带永久的保存了她的部分智慧和力量。"

			end
			 if item.name == "Girdle of Preservation" then
				item.name = "防腐腰带"
				item.unided_name  = "闪烁的完美腰带"
				item.desc  =  "一条有着沃瑞钽雕刻标志的皮带扣，用纯白色皮革制作的古朴的腰带。不论时间还是环境都不能对它造成任何损害。"

			end
			 if item.name == "Girdle of the Calm Waters" then
				item.name = "静水腰带"
				item.unided_name  = "金色腰带"
				item.desc  =  "传说这条腰带曾被孔克雷夫的医师们佩戴。"

			end
			 if item.name == "Behemoth Hide" then
				item.name = "巨兽之皮"
				item.unided_name  = "坚韧的风化兽皮"
				item.desc  =  "一张取自巨型猛兽的粗制兽皮。鉴于它已经被风吹日晒了这么久还能凑合用用，没准会有一点特别的……"

			end
			 if item.name == "Skin of Many" then
				item.name = "人皮"
				item.unided_name  = "缝制的皮甲"
				item.desc  =  "缝在一起的许多人皮。有些眼睛和嘴巴依然待在这件袍子上，并且有一些仍然活着，在被酷刑折磨的痛苦中尖啸。"

			end
			 if item.name == "Nature's Blessing" then
				item.name = "自然之赐"
				item.unided_name  = "柔韧的皮甲被柳木条缠绕着"
				item.desc  =  "曾被守护者亚当穿著，他在魔法战争中首次于人类和半身人之间建立了伊格兰斯。这件护甲被灌注了大自然的能量，并被用来对抗魔法破坏者。"

			end
			 if item.name == "Iron Mail of Bloodletting" then
				item.name = "嗜血铁甲"
				item.unided_name  = "刺穿外壳之铁甲"
				item.desc  =  "鲜血不断的从这套骇人的铁甲上滴落，几乎可以看得见黑魔法在它的周围流动。胆敢阻挡装备者的人会遭到血腥的毁灭。"

			end
			 if item.name == "Scale Mail of Kroltar" then
				item.name = "库洛塔的龙鳞甲"
				item.unided_name  = "用龙甲完美打造的正装"
				item.desc  =  "一件用库洛塔的遗物打造的重甲，她的护甲有盾牌的十倍重。"
				item.set_desc.kroltar = "库洛塔的头会被这热量唤醒。"
			end
			 if item.name == "Plate Armor of the King" then
				item.name = "国王的板甲"
				item.unided_name  = "隐隐放光的沃瑞钽板甲"
				item.desc  =  "精细描绘着国王为最后的希望浴血奋战的影像。即便是彻头彻尾的恶棍看到它，心底也会充满深深的绝望。"

			end
			 if item.name == "Cuirass of the Thronesmen" then
				item.name = "钢铁战士胸甲"
				item.unided_name  = "重型矮人钢护甲"
				item.desc  =  "这件沉重的矮人钢护甲打造于钢铁王座最深的熔炉。虽然它被赋予了举世无双的防护能力，但你必须得靠自己的力量使用它。"

			end
			 if item.name == "Golden Three-Edged Sword 'The Truth'" then
				item.name = "金色三棱剑·真理"
				item.unided_name  = "三棱剑"
				item.desc  =  "有些聪明人说真理是把三刃剑。因为有些时候，“真理”是会伤到人的。"

			end
			 if item.name == "Ureslak's Femur" then
				item.name = "乌尔斯拉克的大腿"
				item.unided_name  = "染的稀奇古怪的骨头"
				item.desc  =  "强大的棱晶龙被截断的腿骨，这根奇怪的棍子仍然流动着乌尔斯拉克的天性。"

			end
			 if item.name == "Razorblade, the Cursed Waraxe" then
				item.name = "剃刀·诅咒战斧"
				item.unided_name  = "剃刀战斧"
				item.desc  =  "这把强力的斧头可以像剑一样劈开护甲，还能招架钝器的打击。据说持有者会慢慢变得疯狂。这个，不管怎样，从来没有被证实过——没有任何持有者能活到揭开真相。"

			end
			 if item.name == "Sword of Potential Futures" then
				item.name = "进化之剑"
				item.unided_name  = "未完工的剑"
				item.desc  =  "传说这把长剑是一对兵器中的其中一个；这对兵器打造于瓦登斯最初的年代。对于未经训练的持有者来说它还不是那么完善；对于时空守卫来说，它将随着时间展现威力。"
				item.set_desc.twsword = "过去有柄匕首和它成套"
			end
			 if item.name == "Dagger of the Past" then
				item.name = "历练之匕"
				item.unided_name  = "锈蚀的匕首"
				item.desc  =  "传说这把匕首是一对兵器中的一个；这对兵器打造于瓦登斯最初的年代。对于未经训练的持有者来说它还不是那么完善；对于时空守卫来说，它表示着从以前的失误中吸取教训的机会。"
				item.set_desc.twsword = "未来可能有把剑和它成套"
			end
			 if item.name == "Witch-Bane" then
				item.name = "巫师毁灭者"
				item.unided_name  = "象牙柄沃瑞钽长剑"
				item.desc  =  "一把沃瑞钽长剑，象牙的剑柄被紫色的布包裹着。这把兵器的传奇性跟它上一任拥有者玛库斯·丹差不多了，人们都以为这把剑在魔法狩猎末期玛库斯被害的时候被摧毁了。"

			end
			 if item.name == "Stone Gauntlets of Harkor'Zun" then
				item.name = "哈克祖的岩石臂铠"
				item.unided_name  = "黑曜石臂铠"
				item.desc  =  "古时候由哈克祖的狂热崇拜者制作，这副花岗岩臂铠被设计为可以保护穿戴者免于遭受黑暗之主的暴怒。"

			end
			 if item.name == "Unflinching Eye" then
				item.name = "怒视之眼"
				item.unided_name  = "充血的眼球"
				item.desc  =  "有人用一条黑色的粗线穿过这颗充血的眼球，把它挂在脖子上。你也应该这样做。"

			end
			 if item.name == "Ureslak's Molted Scales" then
				item.name = "乌尔斯拉克之皮"
				item.unided_name  = "多彩鳞甲"
				item.desc  =  "这件长袍用某些大型爬行动物的鳞片制成。它看上去可以反射出彩虹的每种颜色。"

			end
			 if item.name == "Pick of Dwarven Emperors" then
				item.name = "矮人皇帝的十字镐"
				item.unided_name  = "生铁之十字镐"
				item.desc  =  "这把古老的十字镐被用来一代代的往下传颂矮人的传奇。从镐头到镐把每一寸都覆盖着记述矮人故事的诗歌。"

			end
			 if item.name == "Staff of Arcane Supremacy" then
				item.name = "至尊法杖"
				item.unided_name  = "银色符文法杖"
				item.desc  =  "一根又细又长的法杖，由远古龙骨制成，它通体铭刻着银色的符文。它会发出微弱的嗡嗡声，似乎有一股强大的力量被锁在了里面，整体来看，它似乎是不完整的。"
				item.set_desc.channelers = "只 有 理 解 奥 术 才 能 完 全 使 用 它 的 力 量。"
			end
			 if item.name == "Hat of Arcane Understanding" then
				item.name = "奥术理解之帽"
				item.unided_name  = "银色符文帽子"
				item.desc  =  "一只传统巫师的尖帽子，由紫色的精灵丝绸制成，上面还有亮银色的装饰物。你意识到它来自远古时代，一个拥有众多伟大法师的时代。通过触摸你可以感受到远古的知识和能量，但仍有一部分被密封着，等待有缘人来释放它。"
				item.set_desc.channelers = "只 有 奥 术 至 尊 才 能 完 全 发 挥 它 的力 量  。"
			end
			 if item.name == "Quiver of the Sun" then
				item.name = "日冕箭壶"
				item.unided_name  = "发光的箭壶"
				item.desc  =  "这个奇特的橙色箭壶由黄铜制成，在阳光下，你可以看到壶身铭刻着许多亮红色的发光符文。箭矢似乎配有燃烧的箭杆，就像被锻造过的阳光。"

			end
			 if item.name == "Blightstopper" then
				item.name = "枯萎终结者"
				item.unided_name  = "藤蔓覆盖的盾牌"
				item.desc  =  "这块沃瑞坦盾牌表面被厚实的藤蔓所缠绕，其中注入了许多年前的半身人将军阿尔曼达·鲁伊尔的自然力量，他在派尔之战中用这个盾牌驱散了兽人堕落者的魔法疫病。"
				item.use_power.name = function(self, who)
					local effpower = self.use_power.effpower(self, who)
					return ("除 去 至 多 %d 项 疾 病 （ 基 于 意 志 ) 并 获 得 疾 病 免 疫 、%d%% 枯 萎 抗 性 和 %d  法 术 豁 免 5 回 合 。"):format(self.use_power.nbdisease(self, who), effpower, effpower)
				end
			end
			 if item.name == "Star Shot" then
				item.name = "星辰弹"
				item.unided_name  = "闪光的弹药"
				item.desc  =  "子弹中放射出极高的热量。"

			end
			 if item.name == "Nexus of the Way" then
				item.name = "维网之核"
				item.unided_name  = "闪耀的绿色灵晶"
				item.desc  =  "巨大的意念力在这颗宝石之中回响，仅仅轻触就可以让你获得无穷的力量和无限的思维。"

			end
			 if item.name == "Amethyst of Sanctuary" then
				item.name = "紫水晶的庇护"
				item.unided_name  = "深紫色灵晶"
				item.desc  =  "这颗明亮的紫色宝石渗透出宁静、专注的力量，当你紧握它时，你可以感受到它保护你与外界力量隔绝。"

			end
			 if item.name == "Sceptre of the Archlich" then
				item.name = "死灵权杖"
				item.unided_name  = "白骨雕刻的权杖"
				item.desc  =  "这根权杖上有古老焦黑的白骨雕刻，镶嵌着一颗黑曜石，你感受到里面有一股黑暗力量呼之欲出。"
				item.set_desc.archlich = "它渴望被亡灵围绕。"
			end
			 if item.name == "Oozing Heart" then
				item.name = "史莱姆之心"
				item.unided_name  = "粘糊糊的灵晶"
				item.desc  =  "这只灵晶在不断的向外渗出粘糊糊的液体。魔法似乎消逝在它周围。"

			end
			 if item.name == "Bloomsoul" then
				item.name = "夏花之魂"
				item.unided_name  = "鲜花覆盖的灵晶"
				item.desc  =  "纯洁的花瓣覆盖着灵晶，当你触摸它时你感受到宁静和清新。"

			end
			 if item.name == "Gravitational Staff" then
				item.name = "重力之杖"
				item.unided_name  = "沉重的法杖"
				item.desc  =  "法杖的尖端时空似乎陷入了扭曲。"

			end
			 if item.name == "Eye of the Wyrm" then
				item.name = "七彩龙之眼"
				item.unided_name  = "多彩的灵晶"
				item.desc  =  "灵晶的核心穿过一道彩虹，投射出七色的光芒，不断变换着颜色。"
				item.set_desc.wyrm = "七彩龙之眼寻求一种元素。"
			end
			 if item.name == "Great Caller" then
				item.name = "伟大的召唤师"
				item.unided_name  = "吟唱的灵晶"
				item.desc  =  "这只灵晶不断的发出低鸣，你感觉到生命能量似乎在向它聚拢。"

			end
			 if item.name == "Corrupted Gaze" then
				item.name = "堕落凝视"
				item.unided_name  = "黑色的遮面盔"
				item.desc  =  "这顶头盔散发着黑暗的力量。它似乎能够扭曲和腐化装备者的视觉。你不能穿戴它太长时间，以免堕入魔道。"

			end
			 if item.name == "Umbral Razor" then
				item.name = "影之刃"
				item.unided_name  = "黝黑的匕首"
				item.desc  =  "这只匕首覆盖着一层纯净的阴影，并且似乎有一团瘴气围绕着它。"

			end
			 if item.name == "Emblem of Evasion" then
				item.name = "闪避徽记"
				item.unided_name  = "镶金的纹饰腰带"
				item.desc  =  "据说它曾属于一位闪避大师，这根镀金的腰带部分的保存了他的能力。"

			end
			 if item.name == "Surefire" then
				item.name = "神火"
				item.unided_name  = "制作精良的弓"
				item.desc  =  "这把做工精良的弓相传由一位不知名的大师打造。当你拉动弓弦时，你能感受到这把弓蕴藏着难以置信的力量。"

			end
			 if item.name == "Frozen Shards" then
				item.name = "冰极碎"
				item.unided_name  = "一袋水晶质的冰弹"
				item.desc  =  "在这个深蓝色的袋子里，躺着许多冰晶弹。一团奇异的冰雾环绕着它们，当你触摸它们时，你感到刺骨的凉意。"

			end
			 if item.name == "Stormlash" then
				item.name = "风暴之鞭"
				item.unided_name  = "缠绕着电弧的鞭子"
				item.desc  =  "这根钢质的鞭子缠绕着许多电弧。你可以感受这根鞭子上散发出的力量强大且不可控制。"
				item.use_power.name = function(self, who)
					local dam = who:damDesc(engine.DamageType.LIGHTNING, self.use_power.damage(self, who))
					return ("攻击距离 %d 内的敌人，造成 100%% 闪电武器 伤害 并在半径 %d 内释放电弧， 造成 %0.2f 到 %0.2f 点闪电 伤害 ( 基于 魔法 和 敏捷)")
					:format(self.use_power.range, self.use_power.radius, dam/3, dam)
				end
			end
			 if item.name == "Focus Whip" then
				item.name = "聚灵鞭"
				item.unided_name  = "镶有宝石的柄"
				item.desc  =  "这只手柄上镶有一颗小小的灵晶。当你触摸它时，一根半透明的绳子浮现在你面前，并随着你的意志闪烁。"

			end
			 if item.name == "Latafayn" then
				item.name = "焱剑·拉塔法"
				item.unided_name  = "附着火焰的巨剑"
				item.desc  =  "这只沉重的、火焰覆盖的巨剑，是很久以前英雄贾斯丁·海风从某个强大的恶魔处得来。它炽热的火焰依旧可以焚烧万物。"
				item.use_power.name = function(self, who) 
					return ("加 速 半 径 %d 范 围 内 的 所 有 燃 烧 效 果 ， 范 围 %d, 立 刻 造 成 125%% 剩 余 燃 烧 伤 害。")
					:format(self.use_power.radius(self, who), self.use_power.range(self, who)) 
					end
			end
			 if item.name == "Robe of Force" then
				item.name = "灵能长袍"
				item.unided_name  = "无风自动的长袍"
				item.desc  =  "这件薄薄的长袍被一团神秘的精神力量所包围。"
				item.use_power.name = function(self, who)
					local dam = who:damDesc(engine.DamageType.PHYSICAL, self.use_power.damage(self, who))
					return ("发 射 长 度 %d 的 动 能 射 线 ， 造 成 %0.2f 到 %0.2f 点 物 理 击 退 伤 害 （ 基 于 意 志 和 灵 巧 ）"):format(self.use_power.range, 0.8*dam, dam) 
					end
			end
			 if item.name == "Serpent's Glare" then
				item.name = "蛇灵怒视"
				item.unided_name  = "泛着绿光的宝石"
				item.desc  =  "凝厚的毒液不断地从这个灵晶上滴落。"

			end
			 if item.name == "The Inner Eye" then
				item.name = "心眼"
				item.unided_name  = "镶嵌有独眼的帽子"
				item.desc  =  "这只嵌有独眼的皮帽，据说可以让使用者感知周围的人，代价是你的视觉。你怀疑在使用这件帽子后视力会需要很长的时间来恢复。"

			end
			 if item.name == "Corpathus" then
				item.name = "束缚之剑·卡帕萨斯"
				item.unided_name  = "被束缚的长剑"
				item.desc  =  "这把剑被厚重的带所束缚。两排锯齿状的锋刃沿着剑身直到剑柄，它试图挣脱带子的束缚，但似乎缺乏足够的力量。"

			end
			 if item.name == "Anmalice" then
				item.name = "扭曲之刃·圣灵之眼"
				item.unided_name  = "扭曲的利刃"
				item.desc  =  "剑柄上的眼睛似乎直视着你，试图撕裂你的灵魂。剑柄上环绕的触手可以使其很好的固定在你手上。"

			end
			 if item.name == "Hydra's Bite" then
				item.name = "三头龙之牙"
				item.unided_name  = "有三个头的连枷"
				item.desc  =  "这把三头的蓝锆石连枷，使用的是一只三头龙的力量。它的攻击可以伤害到周围的所有敌人。"

			end
			 if item.name == "Spellhunt Remnants" then
				item.name = "魔法狩猎遗物"
				item.unided_name  = "破旧的沃瑞钽臂铠"
				item.desc  =  "你从这副锈迹斑斑的臂铠上勉强能看出其曾经的辉煌。它起源于魔法狩猎时期，用于摧毁奥术类装备，以惩罚法师们对这个世界的暴行。"
			end
			 if item.name == "Merkul's Second Eye" then
				item.name = "米库尔的第二只眼"
				item.unided_name  = "丝弦光滑的弓"
				item.desc  =  "这把弓据说属于一位臭名昭著的矮人间谍。更有传言称，这把弓能帮助他利用所有敌人的眼睛。被射中的敌人虽然不会丧命，但却没有意识到自己的眼睛已经把周围的秘密全都泄漏给了他。"

			end
			 if item.name == "Mirror Shards" then
				item.name = "镜影碎片"
				item.unided_name  = "镶有锁链的镜片"
				item.desc  =  "据说是由一位强大的魔法师在他的家园被猎魔行动的暴民摧毁后制造。虽然他逃脱了追捕，但是他的财产都被破坏和烧毁殆尽。当他回去时，发现家里已成废墟，墙上的斑驳和地上的碎片说明了这里曾遭到怎样的劫难。最终，他捡起了其中一块镜子残片，将其做成了这副项链。"
				item.use_power.name = function(self, who) 
					return ("制造反射护盾（50%%反射率， %d 吸收量， 基于 魔法) 持续5 回合。"):format(self.use_power.shield(self, who)) 
					end
			end
			 if item.name == "Summertide" then
				item.name = "夏夜"
				item.unided_name  = "闪光的金色盾牌"
				item.desc  =  "从这面盾牌的中心放射出耀眼的光芒，当你紧握这面盾牌时，你的思维变得清晰。"
				item.use_power.name = function(self, who)
					local dam = who:damDesc(engine.DamageType.LIGHT, self.use_power.damage(self, who))
					return ("发 射 长 度 %d 的 射 线 ， 照 亮 路 径 ， 并 造 成  %0.2f 到 %0.2f 点 光 系 伤 害   ( 基 于 意 志 和 灵巧 )"):format(self.use_power.range, 0.8*dam, dam)
				end
			end
			 if item.name == "Wanderer's Rest" then
				item.name = "旅者的休憩"
				item.unided_name  = "没有重量的靴子"
				item.desc  =  "这双靴子几乎没有重量，触摸它，你觉得身上的重担一下子减轻了许多。"

			end
			 if item.name == "Silk Current" then
				item.name = "流波法袍"
				item.unided_name  = "平滑的法袍"
				item.desc  =  "这件深蓝色的法袍荡起涟漪，仿佛有一股看不见的浪潮在涌动。"

			end
			 if item.name == "Skeletal Claw" then
				item.name = "白骨之握"
				item.unided_name  = "连着骨爪的鞭子"
				item.desc  =  "这根鞭子看上去像是人类的脊骨做成，一端有一个柄，另一端是一个磨光的爪子。"

			end
			 if item.name == "Core of the Forge" then
				item.name = "熔炉之核"
				item.unided_name  = "灼热的灵晶"
				item.desc  =  "这块灼热发光的灵晶有节奏地律动着，每次攻击会放出一波热量。"

			end

			 if item.name == "Piercing Gaze" then
				item.name = "锐利目光"
				item.unided_name="刻有岩石眼的盾牌"
				item.desc  =  "这个巨大的盾牌上嵌有一个石质的眼睛"

			end
			 if item.name == "Shantiz the Stormblade" then
				item.name = "风暴之刃"
				item.unided_name="很薄的短刃"
				item.desc  =  "这柄超现实的匕首周围环绕有强大的风暴"

			end
			 if item.name == "The Calm" then
				item.name = "宁静"
				item.unided_name="华丽的绿色长袍"
				item.desc  =  "这件绿色长袍上刻有云朵和漩涡。它最初的主人，大法师普偌卡拉，因其善行和力量被人们敬畏"

			end
			 if item.name == "Borosk's Hate" then
				item.name = "博瑞思科的仇恨"
				item.unided_name="双刃剑"
				item.desc  =  "这柄剑令人印象深刻，因为它有两个平行刀锋。"

			end
			 if item.name == "Windborne Azurite" then
				item.name = "风之铜蓝"
				item.unided_name="微风环绕的宝石"
				item.desc  =  "空气在这块亮蓝色宝石周围旋转。"

			end
			 if item.name == "Primal Infusion" then
				item.name = "原初之纹身"
				item.unided_name="有活力的纹身"
				item.desc  =  "这个纹身已经进化了"

			end
			 if item.name == "Swordbreaker" then
				item.name = "破剑匕"
				item.unided_name="带锯齿的匕首"
				item.desc  =  "这柄普通的匕首是由精制坚硬的沃瑞坦制成的，配有锯齿钩边。看似平凡的外表背后潜藏着强大的力量——它破坏过诸多刀刃，收割走那些战士的生命和未来。"

			end
			 if item.name == "Shieldsmaiden" then
				item.name = "女武神之心"
				item.unided_name="冰冻的盾"
				item.desc  =  "传说中的女武神，来自马基埃亚尔世界的北方荒地。她的美貌和力量吸引了众多爱慕者前去，然而所有人都空手而归。因此，有这样一句谚语：女武神的心同她的盾一样冰冷而不可打破。"

			end
			 if item.name == "Tirakai's Maul" then
				item.name = "提瑞卡之锤"
				item.unided_name="锤子"
				item.desc  =  "这柄巨型锤子是用一种厚厚的古怪结晶体制成的，锤子里面能看到一个空槽，似乎很容易就能将宝石放进去。"

			end
			 if item.name == "Fist of the Destroyer" then
				item.name = "毁灭者之拳"
				item.unided_name="邪恶的手套"
				item.desc  =  "这对手套看上去十分恐怖，闪耀着不明能量。"
				item.set_desc.destroyer = "只有受虐狂才能解锁它的能量."
			end
			 if item.name == "Masochism" then
				item.name = "受虐狂"
				item.unided_name="破损的衣物"
				item.desc  =  "窃取血肉,\n窃取苦痛,\n舍弃本我,\n秽尸复苏。"
				item.set_desc.masochism = "如果有更好的掌控力，它将摧毁敌人。"
			end
			 if item.name == "Obliterator" then
				item.name = "抹杀者"
				item.unided_name="巨型锤子"
				item.desc  =  "这柄巨大的锤子挥击时拥有能粉碎骨头的巨力。"

			end
			 if item.name == "Champion's Will" then
				item.name = "冠军意志"
				item.unided_name  = "一把发出炫目光芒的剑"
				item.desc  =  "初看这把外形令人印象深刻的长剑，最先吸引你目光的是雕刻在剑柄之中的金色太阳。而蚀刻在剑刃之上的复杂的符文仿佛在告诉你，只有真正掌握自己肉体和精神力量之人才能发挥出这把武器的最大威力。"
				item.use_power.name = function(self, who) 
					return ("攻 击 长 度 为 %d 的 直 线 上 所 有 目 标 , 造 成 100%% 光 系 武 器 伤  害,  并 将 50%% 伤 害 转 化 为 治 疗。"):format(self.use_power.range) 
					end
			end
			 if item.name == "Tarrasca" then
				item.name = "泰拉斯奎巨铠"
				item.unided_name  = "一件荒诞般巨大的铠甲"
				item.desc  =  "这件结实硕大的板甲有着夸张的体积和难以想象的重量。相传这件板甲属于一位不知名的士兵，为了抵御洪水般的兽人军团入侵他的家乡，这名士兵守护在通向他村庄的大桥上。经过几天几夜惨烈的进攻，兽人没能击倒他，最终敌人撤退了。而这名传奇般的士兵，也因为精疲力竭当场倒毙，这件盔甲最终夺去了他的生命。"

			end
				 if item.name == "Aetherwalk" then
				item.name = "以太漫步者"
				item.unided_name  = "飘渺的靴子"
				item.desc  =  "一圈紫色光环围绕着这双半透明的黑色靴子。"

			end
			 if item.name == "Colaryem" then
				item.name = "克拉伊姆·飞翔之剑"
				item.unided_name  = "漂浮的剑"
				item.desc  =  "这把长得不可思议的剑几乎和人一样宽，与其巨大尺寸格格不入的是，它的重量极轻，而且似乎总想要从你的手中飞走一样。要么足够强壮，要么足够高大，你才能握紧这剑，防止其飞走。"

			end
			 if item.name == "Void Quiver" then
				item.name = "虚空箭壶"
				item.unided_name  = "飘渺的箭壶"
				item.desc  =  "这个深黑色的箭壶中可以源源不断的抽出箭矢，它的表面闪烁着点点微光。"

			end
			 if item.name == "Hornet Stingers" then
				item.name = "黄蜂尾钉"
				item.unided_name  = "镶着尖刺的箭矢"
				item.desc  =  "箭矢的尖端滴落着剧毒。"

			end
			 if item.name == "Umbraphage" then
				item.name = "安布瑞吉·暗影吞噬者"
				item.unided_name  = "深黑色的灯笼"
				item.desc  =  "这个灰白色水晶制成的灯笼周围笼罩着一片黑暗，但是它仍放射着光芒。光之所在，黑暗尽除。"
				item.special_desc = function(self) 
					return ("在 光 照 范 围 内 吸 收 所 有 黑 暗(强度 %d,基 于 意 志 和 灵 巧) 并 增 加 亮 度. (当 前 增 幅： %d).")
					:format(self.worn_by and self.use_power.litepower(self, self.worn_by) or 100, self.charge) 
				end
				item.use_power.name = function(self, who)
					local dam = who:damDesc(engine.DamageType.DARKNESS, self.use_power.damage(self, who))
					return ("在 %d 码 的 锥 形 范 围 内 释 放 吸 收 的 黑 暗 ， 有 %d%% 几 率 致 盲 （ 基 于 光 照 半 径 ） , 并 造 成 %0.2f 暗 影 伤 害 ( 基 于 精 神 强 度 和 吸 收 量)"):format(self.use_power.radius(self, who), self.use_power.blindchance(self, who), dam)
				end
			end
			 if item.name == "Spellblaze Shard" then
				item.name = "魔爆碎片"
				item.unided_name  = "水晶匕首"
				item.desc  =  "这块锯齿状的水晶放射出异常的亮光，它的一端绑着几圈布条当作握把。"

			end
			 if item.name == "Spectral Cage" then
				item.name = "幽灵牢笼"
				item.unided_name  = "天蓝色的灯笼"
				item.desc  =  "这个古老、褪色的灯笼放射出淡蓝色的光芒。它的金属表面摸上去像冰一样冷。"

			end
			 if item.name == "The Guardian's Totem" then
				item.name = "守卫者图腾"
				item.unided_name  = "损坏的石头图腾"
				item.desc  =  "这个古老的石制图腾的石缝里不断涌出粘液。尽管如此，你仍能感受到它的巨大能量。"

			end
			 if item.name == "Cloth of Dreams" then
				item.name = "梦幻披风 "
				item.unided_name  = "破烂的披风"
				item.desc  =  "当你触摸这件超脱尘俗的披风时你既觉得昏昏欲睡又十分清醒。"

			end
			 if item.name == "Void Shard" then
				item.name = "虚空碎片"
				item.unided_name  = "奇怪的锯齿状碎片"
				item.desc  =  "这个锯齿状的影像看上去像是时空中的黑洞，但它又是固态的，尽管重量非常的轻。"
				item.use_power.name = function(self, who)
					local dam = self.use_power.damage(self, who)/2
					return ("在 %d 码 范 围 内 释放 虚空 能 量 ，至 多 距 离 %d。造 成 %0.2f时空和 %0.2f 暗 影 伤 害。(基 于 魔 法)"):format(self.use_power.radius, self.use_power.range, who:damDesc(engine.DamageType.TEMPORAL, dam), who:damDesc(engine.DamageType.DARKNESS, dam))
				end
			end
			 if item.name == "Thalore-Wood Cuirass" then
				item.name = "精灵木胸甲"
				item.unided_name  = "厚木板甲"
				item.desc  =  "由树皮制成，做工相当精巧，重量很轻，却能提供很好的防护。"

			end
			 if item.name == "Coral Spray" then
				item.name = "云雾珊瑚"
				item.unided_name  = "厚重的珊瑚板甲"
				item.desc  =  "用大块的珊瑚制成，源自大海深处。"

			end
			 if item.name == "Shard of Insanity" then
				item.name = "狂乱碎片"
				item.unided_name  = "损坏的黑色项链"
				item.desc  =  "从这条损坏的黑色项链上放出暗红色的光亮，当你触摸它时，你能听到脑海里的窃窃私语。"

			end
			 if item.name == "Pouch of the Subconscious" then
				item.name = "欲望之核"
				item.unided_name  = "常见的弹药袋"
				item.desc  =  "你情不自禁的想使用这袋弹药。"
				item.combat.special_on_hit.desc="50%% 几 率 回 复 一 颗 子 弹。"
			end
			 if item.name == "Wind Worn Shot" then
				item.name = "风化弹"
				item.unided_name  = "极其光滑的弹药"
				item.desc  =  "这些白色的弹丸似乎饱经风霜。"

			end
			 if item.name == "Spellcrusher" then
				item.name = "奥术摧毁者"
				item.unided_name  = "藤蔓覆盖的锤子"
				item.desc  =  "这柄巨大的铁制巨锤，其手柄上覆盖着一层厚厚的藤蔓。"

			end
			 if item.name == "Telekinetic Core" then
				item.name = "念力之核"
				item.unided_name  = "沉重的项圈"
				item.desc  =  "这副沉重的项圈将周围的所有物体拉向它。"

			end
			 if item.name == "Spectral Blade" then
				item.name = "幽灵之刃"
				item.unided_name  = "虚幻的剑"
				item.desc  =  "这把剑飘渺无形。"

			end
			 if item.name == "Crystle's Astral Bindings" then
				item.name = "众星之握"
				item.unided_name  = "水晶手套"
				item.desc  =  "相传这副手套曾属于一位不知名的星月法师。无数的星辰从这副手套的表面反射出来，显得超凡脱俗。"

			end
			 if item.name == "Prothotipe's Prismatic Eye" then
				item.name = "普罗斯泰普的七彩之眼"
				item.unided_name  = "损坏的傀儡之眼"
				item.desc  =  "这枚损坏的宝石看起来似乎有一定的年月了。种种迹象表面它曾经是某个傀儡的眼珠。"

			end
			 if item.name == "Plate of the Blackened Mind" then
				item.name = "堕落灵魂之甲"
				item.unided_name  = "黑色胸甲"
				item.desc  =  "这件黑色的胸甲吸收了附近的所有光线。你能感受到其中沉睡着一股邪恶的力量。当你触摸它时，你感到黑暗的思想在不断的涌现在你的脑海。"

			end
			 if item.name == "Tree of Life" then
				item.name = "生命之树"
				item.unided_name  = "树状的图腾"
				item.desc  =  "你能在这根小巧的树状图腾上感受到强大的治愈能量。"

			end
			 if item.name == "Ring of Growth" then
				item.name = "生命之戒"
				item.unided_name  = "藤蔓缠绕的戒指"
				item.desc  =  "这枚小巧的戒指上缠绕着一根藤蔓，藤蔓似乎仍然在不断的吐出新叶。"

			end
			 if item.name == "Wrap of Stone" then
				item.name = "石化风衣"
				item.unided_name  = "石头斗篷"
				item.desc  =  "尽管这件石头斗篷又硬又厚，但是你仍能轻松的折叠它。"

			end
			 if item.name == "Death's Embrace" then
				item.name = "死亡拥抱"
				item.unided_name  = "黑色的皮甲"
				item.desc  =  "这件黑色的皮甲上覆盖着一层厚厚的丝绸，触感冰凉。"
				item.use_power.name = function(self, who) 
					return ("隐形10回合(强 度%d, 基 于 灵 巧 和 魔 法 ）"):format(self.use_power.invispower(self, who)) 
					end
			end
			 if item.name == "Breath of Eyal" then
				item.name = "埃亚尔的呼吸"
				item.unided_name  = "薄薄的绿色护甲"
				item.desc  =  "这件护甲由数以千计的豆芽缠绕编成，豆芽们仍在不停的生长缠绕。尽管在你手里很轻，但当穿上它时，你感觉到肩上那世界一般的重量。"

			end
			 if item.name == "Eternity's Counter" then
				item.name = "永恒沙漏"
				item.unided_name  = "水晶沙漏"
				item.desc  =  "这只漂亮的沙漏里装载着数以千计的宝石，用以代替沙子。当它们落下时，你能够感受到时间的变化。"
				item.use_power.name = function(self, who) 
					return ("反转沙漏 (沙 子 当 前 流 向 %s)"):format(self.direction > 0 and "稳定" or "熵") 
					end
			end
			 if item.name == "Malslek the Accursed's Hat" then
				item.name = "马斯拉克·诅咒之帽"
				item.unided_name  = "黑色的烧焦帽子"
				item.desc  =  "这顶黑色的帽子曾属于一名强大的法师马斯拉克，在黄昏纪时以交游位面之广而著称。值得一提的是，他还与许多恶魔进行了交易。直到某一天，一名恶魔厌烦了契约的约束而背叛了他并偷走了马斯拉克的力量。马斯拉克一气之下烧毁了自己的高塔，意图杀死这只恶魔。最终，废墟中只剩下了这顶帽子流传至今。"

			end
			 if item.name == "Fortune's Eye" then
				item.name = "幸运之眼"
				item.unided_name  = "金色望远镜"
				item.desc  =  "这副精致的望远镜曾属于一位著名的冒险家和探险家贾斯丁·海风。有此宝在手，海风遍历了整个马基埃亚尔大陆，在他死前据说他搜集了许多宝贵的财富。他相信这副望远镜能带给他好运，有此物在手，无论面对任何险境，都能死里逃生。相传，他死于一名恶魔的报复，报复他偷走了恶魔私藏的一把剑。海风留给世间的最后遗言是——想要我的财富吗？那就去找吧，我的一切都在那里，大幕才刚刚拉开。"

			end
			 if item.name == "Anchoring Ankh" then
				item.name = "稳固十字架"
				item.unided_name  = "发光的十字架"
				item.desc  =  "当你举起这个十字架时你觉得异常的稳定。你感到周围的世界也变的更加稳定了。"

			end
			 if item.name == "Ancient Tome titled 'Gems and their uses'" then
				item.name = "远古之书《宝石之秘》"
				item.unided_name  = "远古之书"
				item.desc  =  ""

			end
			 if item.name == "Scroll of Summoning (Limmir the Jeweler)" then
				item.name = "召唤卷轴（召唤珠宝匠利米尔）"
				item.unided_name  = ""
				item.desc  =  ""

			end
			 if item.name == "Pendant of the Sun and Moons" then
				item.name = "日月垂饰"
				item.unided_name  = "一个闪烁着金色灰色的垂饰"
				item.desc  =  "一个小小的垂饰，雕刻着红月吞日的图案。传说其主人是太阳之墙的建立者之一。"

			end
			 if item.name == "Unsetting Sun" then
				item.name = "永恒光辉"
				item.unided_name  = "闪耀着金色光芒的盾牌"
				item.desc  =  "当冲锋队队长艾米奥·帕纳森为他的遇难船员们寻求庇护所的时候，他的盾牌反射着落日的光辉。他们在光辉照耀的地方休息宿营，之后太阳之墙在那里成立。在随后那些暗无天日的日子里，这面盾牌被人们当做美好未来希望的象征。"
				item.	set_desc.dawn = "在黎明下闪耀光芒。"
			end
			 if item.name == "Scorched Boots" then
				item.name = "烧焦的长靴"
				item.unided_name  = "一双熏黑的靴子"
				item.desc  =  "血魔导师鲁·克汉是派尔纪第一个使用夏·图尔远程传送门进行试验的兽人。试验不是很成功，能量爆炸后，只剩下了一双烧焦的靴子。"

			end
			 if item.name == "Goedalath Rock" then
				item.name = "高达勒斯之石"
				item.unided_name  = "神秘的黑色石头"
				item.desc  =  "这块小石头看起来不是这个世界的，它不时产生着激烈的能量震动，让人感到扭曲、可怕、邪恶……而又强大的能量。"

			end
			 if item.name == "Threads of Fate" then
				item.name = "命运之弦"
				item.unided_name  = "一件闪着微光的白色斗篷"
				item.desc  =  "这件精致的白色斗篷由异界材料制成，随光线变化而闪烁，永恒如新。"

			end
			 if item.name == "Blood-Edge" then
				item.name = "饮血剑"
				item.unided_name  = "红色的水晶剑"
				item.desc  =  [[这把深红色的剑不断的向下滴血。它诞生于兽人堕落者胡里克的实验室。最初，胡里克寻找了一枚水晶来制造他的命匣，但他的计划很快被一群太阳骑士打断，尽管大部分骑士死于不死军团的阻拦，但骑士团团长瑞苏尔却单枪匹马杀入了胡里克的实验室。在那里，两位强者展开了对决，利剑与血魔法你来我往，直到他们都重伤倒地。兽人想拼尽最后一分力气，拿到他的命匣，希望能拯救自己，但是瑞苏尔识破了他的阴谋，将浸满鲜血的利剑掷向了命匣。命匣破碎的瞬间，胡里克的灵魂和利剑以及水晶融为了一体。
现在，残存的胡里克灵魂被困在了这件可怕的武器中，他的思维因数十年的监禁而扭曲。只有鲜血的味道能引起他的兴奋，他的灵魂在不断的侵蚀他人的血肉，希望有朝一日能够重组自我，摆脱这痛苦的存在形式。]]

			end
			 if item.name == "Dawn's Blade" then
				item.name = "黎明之刃"
				item.unided_name  = "闪光的长剑"
				item.desc  =  "传说是在太阳堡垒成立之初打造，这把长剑闪耀着黎明破晓之光，可以破除一切黑暗。"
				item.use_power.name = function(self, who) 
					return ("激 发 黎 明 的 光 芒，在 半 径 %d 内 造 成 %0.2f 光 系 伤 害（基于魔法），并 照 明 %d 码 。")
					:format(self.use_power.radius, engine.interface.ActorTalents.damDesc(who, engine.DamageType.LIGHT, self.use_power.damage(who)), self.use_power.radius*2) end
				item.set_desc.dawn = "如果太阳永不落山，黎明的光辉将永恒。"
			end
			 if item.name == "Zemekkys' Broken Hourglass" then
				item.name = "伊莫克斯的破沙漏"
				item.unided_name  = "坏掉的沙漏"
				item.desc  =  "这个坏掉的小沙漏系在一根金子做的细链上。沙漏的玻璃被打破了，里面的沙子早就掉光了。"

			end
			 if item.name == "Mandible of Ungolmor" then
				item.name = "恩格莫的上颚"
				item.unided_name  = "弯曲的锯齿状黑色匕首"
				item.desc  =  "这把黑曜石打造的利刃镶嵌有恩格莫的致命毒牙。光明在它周围消逝，无尽的黑暗缠绕着它。"

			end
			 if item.name == "Kinetic Spike" then
				item.name = "灵能钉刺"
				item.unided_name  = "短刃匕首"
				item.desc  =  "看似只是简单雕刻过的石柄，然而其前端显现着一道摇晃的刀锋。当你试图去抓住刀锋的时候，你感受到这是一股如热气般无形的力量。尽管外观粗糙，但它在意志足够坚强并且懂得使用它的人手里却可以削铁如泥。"
				item.use_power.name = function(self, who) 
					return ("发 射 灵 能 之 力 ，在 距 离 %d 范 围 内 造 成 150%% 武 器 伤 害 。")
					:format(self.use_power.range) end
			end
			 if item.name == "Yeek-fur Robe" then
				item.name = "夺心魔皮袍"
				item.unided_name  = "光滑的毛皮袍子"
				item.desc  =  "美丽、柔软、洁白，这显然是为半身人贵族设计的衣物，褶边上还缀着几颗明亮的蓝宝石。尽管它是如此迷人，当你披上它时却忍不住有些恶心。"

			end
			 if item.name == "Void Star" then
				item.name = "虚空之星"
				item.unided_name  = "小巧的黑色星星"
				item.desc  =  "它看起来像是一颗非常小巧的星星——深邃的黑暗——不时闪着光芒。"

			end
			 if item.name == "Bindings of Eternal Night" then
				item.name = "永夜绷带"
				item.unided_name  = "染黑的滑腻木乃伊绷带"
				item.desc  =  "这根由亡灵能量编织成的绷带，给任何它们接触到的东西带来死亡。任何穿上它们的人会发现他处于生死的边缘。"

			end
			 if item.name == "Crown of Eternal Night" then
				item.name = "永夜王冠"
				item.unided_name  = "染黑的王冠"
				item.desc  =  "这顶王冠看起来毫无用处，尽管如此你仍能感受到它是由亡灵能量编织而成的。可能会有些用处吧。"

			end
			 if item.name == "Rod of Spydric Poison" then
				item.name = "蜘蛛毒枝"
				item.unided_name  = "滴着毒液的枝条"
				item.desc  =  "这根枝条雕刻着巨大蜘蛛的毒牙，它往下不断的滴落毒液。"

			end
			 if item.name == "Cloak of Deception" then
				item.name = "欺诈斗篷"
				item.unided_name  = "黑色斗篷"
				item.desc  =  "一只黑色的斗篷，它在编织的过程中加入了幻觉特效。"

			end

			 if item.name == "Rune of the Rift" then
				item.name = "符文：时空裂缝"
				item.unided_name  = ""
				item.desc  =  ""

			end
			 if item.name == "Shifting Boots" then
				item.name = "闪现靴"
				item.unided_name  = "一双可以闪现的靴子"
				item.desc  =  "这双靴子可以使任何人像它以前的主人戴伯一样淘气。"

			end
			 if item.name == "Atamathon's Ruby Eye" then
				item.name = "阿塔玛森的红宝石眼睛"
				item.unided_name  = ""
				item.desc  =  "那只传奇傀儡——阿塔玛森的一只眼睛。据说它是半身人在派尔纪为了对抗兽人所造的武器。虽然它被破坏了，但是它也成功的使对方的首领吞噬者加库尔走向死亡。"

			end
			 if item.name == "Awakened Staff of Absorption" then
				item.name = "觉醒的吸能法杖"
				item.unided_name  = ""
				item.desc  =  [[杖身铭刻着符文，这根法杖似乎是很久以前制造的，虽然它毫无侵蚀的痕迹。它周围的光线会变的暗淡，当你触摸它时可以感受到惊人的魔力。
	恶魔法师们似乎唤醒了它的力量。
	#{italic}#"终于他们直面了阿马克泰尔，并且上千人牺牲在了他的王座前，其中有三名弑神者倒在了他的脚下。但是法利恩用他死前最后的力量将冰刃阿奇尔插入了真神的膝盖，看到这一机会，凯尔帝勒，弑神者的首领，立刻上前并用吸能法杖对阿马克泰尔造成了致命的一击。这样真神最终倒在了他自己的儿女手中，他的头颅也化作了尘埃。"#{normal}#"]]

			end
			 if item.name == "Pearl of Life and Death" then
				item.name = "生死珍珠"
				item.unided_name  = "闪光的珍珠"
				item.desc  =  "一颗比其他要大三倍的珍珠。它的表面不断的闪烁着光芒，似乎有奇妙的花纹在其表面一闪而逝。"

			end
			 if item.name == "Potion of Martial Prowess" then
				item.name = "尚武药剂"
				item.unided_name  = "金属质的药剂"
				item.desc  =  "这种强大的药剂可以给那些忽视基础的人提供最基本的武学技巧。"

			end
			 if item.name == "Antimagic Wyrm Bile Extract" then
				item.name = "龙胆药剂（反魔）"
				item.unided_name  = "粘糊糊的药剂"
				item.desc  =  "这种强大的药剂提取自一头龙的龙胆，可以给予你对抗魔法的力量。"

			end
			 if item.name == "folded up piece of paper" then
				item.name = "折叠着的纸张"
				item.unided_name  = "折叠着的纸张"
				item.desc  =  "一张折叠的纸张，上面写着一些文字。"

			end
			 if item.name == "Iron Acorn" then
				item.name = "铁质橡果"
				item.unided_name  = "铁质橡果"
				item.desc  =  "一只小巧的橡果，似乎是用粗糙的手法将铁球打磨而成。"

			end
			 if item.name == "Iron Acorn" then
				item.name = "铁质橡果"
				item.unided_name  = "铁质橡果"
				item.desc  =  "一只小巧的橡果，似乎是用粗糙的手法将铁球打磨而成。它曾经属于班德，但现在是你的。带着它可以坚定你的意志，使你在面对前方的挑战时能有充分的准备。"

			end
			 if item.name == "Cold Iron Acorn" then
				item.name = "冰冷的铁质橡果"
				item.unided_name  = "铁质橡果"
				item.desc  =  "一只小巧的橡果，似乎是用粗糙的手法将铁球打磨而成。这只橡果时刻提醒着你，你是何人，去往何处。"

			end
			 if item.name == "Kyless' Book" then
				item.name = "克里斯的书"
				item.unided_name  = "书"
				item.desc  =  "这就是那本带给克里斯力量和诅咒的书。书本用牛皮简单的装订着，封面上没有任何标记，翻开书本，入目尽是空白页。"

			end
			 if item.name == "Celia's Still Beating Heart" then
				item.name = "赛利亚的跳动心脏"
				item.unided_name  = "鲜红的心脏"
				item.desc  =  "亡灵法师赛利亚的跳动心脏，取自她的胸膛，上面充满了魔法的力量。"

			end
			 if item.name == "Epoch's Curve" then
				item.name = "亚伯契的弧线"
				item.unided_name  = "灰白的白蜡长弓"
				item.desc  =  "在亚伯契的弧线失踪前，它已经服务于守卫们数载，代代相传。根据历史记载，它是用魔法大爆炸后第一棵长出的白蜡树制成，拥有时空和恢复的力量。"

			end
--[[			 if item.name == "Sealed Scroll of Last Hope" then
				item.name = "最后希望的密封卷轴"
				item.unided_name  = ""
				item.desc  =  ""

			end
			 if item.name == "Resonating Diamond" then
				item.name = "共鸣宝石"
				item.unided_name  = ""
				item.desc  =  ""

			end
			 if item.name == "Blood-Runed Athame" then
				item.name = "血符祭剑"
				item.unided_name  = "祭祀短剑"
				item.desc  =  "一柄祭祀短剑，上面刻有血色的符文。它散发着能量波动。"

			end]]
			 if item.name == "Fake Skullcleaver" then
				item.name = "仿制碎颅战斧"
				item.unided_name  = "仿制的血红战斧"
				item.desc  =  "一把小巧而锋利的斧头，斧柄由打磨过的骨头制成。这把斧头打破了许多头骨，并被染成了鲜红色。"

			end
			 if item.name == "Bloodcaller" then
				item.name = "鲜血呼唤"
				item.unided_name  = "血色的戒指"
				item.desc  =  "你赢得了鲜血之环的试炼，那是对你的奖赏。"

			end
			 if item.name == "Heart of the Sandworm Queen" then
				item.name = "沙虫女皇之心"
				item.unided_name  = "跳动的心脏"
				item.desc  =  "从沙虫女皇尸体上割下的心脏。你可以……吃了它，尽管你觉得这是疯狂之举。"

			end
			 if item.name == "Corrupted heart of the Sandworm Queen" then
				item.name = "腐化沙虫女皇之心"
				item.unided_name  = "跳动的心脏"
				item.desc  =  "从沙虫女皇尸体上割下的心脏,已被魔法大爆炸的力量腐化。你可以……吃了它，尽管你觉得这是疯狂之举。"

			end
			 if item.name == "Wyrm Bile" then
				item.name = "巨龙胆汁"
				item.unided_name  = "腐败的药剂"
				item.desc  =  "一瓶粘稠的浑浊液体。天知道你喝了它之后会发生什么？"

			end
			 if item.name == "Atamathon's Lost Ruby Eye" then
				item.name = "阿塔玛森丢失的红宝石眼睛"
				item.unided_name  = ""
				item.desc  =  "那只传奇傀儡——阿塔玛森的另一只眼睛。据说它是半身人在派尔纪为了对抗兽人所造的武器。虽然它被破坏了，但是它也成功的使对方的首领吞噬者加库尔走向死亡。"

			end
			 if item.name == "Robes of Deflection" then
				item.name = "扭曲之袍"
				item.unided_name  = "七彩的长袍"
				item.desc  =  "这套长袍闪烁着金属般的光辉。"

			end

			 if item.name == "Telos's Staff (Bottom Half)" then
				item.name = "泰勒斯的法杖（下半部）"
				item.unided_name  = "折断的法杖"
				item.desc  =  "泰勒斯折断法杖的下半部。"

			end
			 if item.name == "Eldritch Pearl" then
				item.name = "埃尔德里奇珍珠"
				item.unided_name  = "闪亮的珍珠"
				item.desc  =  "在创造神庙千年的时间使它被注入了波涛的愤怒。它向外辐射着光芒。"

			end
			 if item.name == "Legacy of the Naloren" then
				item.name = "纳鲁精灵的馈赠"
				item.unided_name  = "华丽的奥利哈刚三叉戟"
				item.desc  =  "这柄拥有着强大力量的三叉戟通体由奥利哈刚金属打造而成。一颗闪亮的珍珠镶嵌在其顶端，向前延伸而出的，是三道锋利的三叉戟刃。它被灌输了娜迦即纳鲁一族最强大战士的力量。现在，萨拉苏尔将它赐予你，作为他对你的信任。同时，它也寄托了纳鲁一族的希望，只有你能受到他们如此的信任。"

			end
			 if item.name == "Rune of the Rift" then
				item.name = "龟裂符文"
				item.unided_name  = ""
				item.desc  =  ""

			end
			 if item.name == "Lecture on Humility by Archmage Linaniil" then
				item.name = "魔导师莱娜尼尔手记"
				item.unided_name  = ""
				item.desc  =  "魔导师莱娜尼尔所写的文献，讲述了很久以前，一段有关于魔法大爆炸的故事。"

			end
			 if item.name == "'What is Magic' by Archmage Teralion" then
				item.name = "魔导师泰尔兰的“魔法是什么”手记"
				item.unided_name  = ""
				item.desc  =  "魔导师泰尔兰所写的关于魔法本质的文献。"

			end
			 if item.name == "The Diaries of King Toknor the Brave " then
				item.name = "狮心王图库纳的日记"
				item.unided_name  = ""
				item.desc  =  "记载了最后希望以及狮心王图库纳的部分历史。"

			end
			 if item.name == "the Pale King part " then
				item.name = "亡灵国王的部分记载"
				item.unided_name  = ""
				item.desc  =  "一份对南晶岛不同寻常统治者的研究报告。"

			end
			 if item.name == "Shard of Crystalized Time" then
				item.name = "时空结晶碎片"
				item.unided_name  = "闪光的碎片"
				item.desc  =  "这是一块紫色的闪光碎片。闪光时缓时快，时而亮如星辰，时而黯淡无光。握着它时，你感到自己既年轻又苍老，时而觉得自己是一个年轻人，时而又觉得自己像是活了几千年。你的肉体在短暂的瞬间似乎跨越了千年，但是灵魂却永恒不变。"

			end
			 if item.name == "The Great Evil" then
				item.name = "罪恶之源"
				item.unided_name  = ""
				item.desc  =  "魔法的恐怖历史。"

			end
			 if item.name == "Boots of Physical Save (+10)" then
				item.name = "物理豁免之靴（+10）"
				item.unided_name  = "干瘪的老旧靴子"
				item.desc  =  "可以提高你10点物理豁免的好靴。"

			end
			 if item.name == "Amulet of Mindpower (+3)" then
				item.name = "精神强度之项链（+3）"
				item.unided_name  = "闪光的项链"
				item.desc  =  "可以提高你3点精神强度的项链。"

			end
			 if item.name == "Helmet of Accuracy (+6)" then
				item.name = "命中之头盔（+6）"
				item.unided_name  = "难看的头盔"
				item.desc  =  "一只可以提高你6点命中的精工头盔。"

			end
			 if item.name == "Ring of Mental Save (+6)" then
				item.name = "精神豁免之戒指（+6）"
				item.unided_name  = "光滑的戒指"
				item.desc  =  "一只镶有红宝石的戒指。"

			end
			 if item.name == "Tome of Wildfire" then
				item.name = "焱之书"
				item.unided_name  = "燃烧的书"
				item.desc  =  "这本巨大的书本被明亮的火焰所围绕。但它们不会伤害你。"

			end
			 if item.name == "Tome of Uttercold" then
				item.name = "冰之书"
				item.unided_name  = "结冰的书"
				item.desc  =  "这本巨大的书本被无尽的雪花所围绕。但它们不会伤害你。"

			end
			 if item.name == "Black Mesh" then
				item.name = "黑暗之网"
				item.unided_name  = "一堆卷须"
				item.desc  =  "盾牌由许多黑色的触须交织而成。当你触摸它时，你可以感受它非常明显的反应，它缠绕住你的手臂并将其包裹在一团黑色而温暖的物质中。"
				item.on_block.desc = "30%% 几率勒住攻击者"
			end
			 if item.name == "Neira's Memory" then
				item.name = "尼耶拉的记忆"
				item.unided_name  = "发出异常声音的腰带"
				item.desc  =  "许多年前这根腰带是年轻时的莱娜尼尔穿戴的，在魔法大爆炸的火焰之中它的力量保护了她，但却保护不了她的姐妹尼耶拉。"
				item.use_power.name = function(self, who) return ("制造一层魔法护盾，( 强度 %d, 基于魔法) ，持 续 10 回 合。"):format(self.use_power.shield(self, who)) end
			end
			 if item.name == "Quiver of Domination" then
				item.name = "统御箭袋"
				item.unided_name  = "灰色的箭袋"
				item.desc  =  "箭袋中的箭矢中散发出一股强大的意念力，尖端虽然看上去不锋利，但是当你触摸时却让你感到剧烈的疼痛。"

			end
			 if item.name == "Essence of Bearness" then
				item.name = "巨熊精华"
				item.unided_name  = "灰色的熊爪"
				item.desc  =  "巨熊的精华所在！"

			end
			 if item.name == "Crown of Burning Pain" then
				item.name = "痛苦之焱"
				item.unided_name  = "燃烧的王冠"
				item.desc  =  "这顶由纯粹火焰所打造的王冠上漂浮着许多小小的石块，每个都可以用意念扔出，化作一块真实的陨石砸向大地。"

			end
			 if item.name == "Skull of the Rat Lich" then
				item.name = "巫妖鼠骨盔"
				item.unided_name  = "燃烧的王冠"
				item.desc  =  "这顶古老的骨盔是巫妖鼠仅存于世的东西，上面残留了巫妖鼠的部分精华能量。"

			end
			 if item.name == "Morrigor" then
				item.name = "摄魂剑·莫瑞格"
				item.unided_name  = "锯齿状的剑"
				item.desc  =  "这把沉重的，有着锯齿状刀刃的长剑正在向外散发强大的魔法波动，当你握住剑时，一阵寒意从剑柄传来，直刺灵魂。你仿佛感觉到了葬身剑下的亡灵，他们渴望着更多同伴的到来。"

			end
			 if item.name == "Eye of the Forest" then
				item.name = "森林之眼"
				item.unided_name  = "长满苔藓的皮帽"
				item.desc  =  "这顶皮帽上长满了厚厚的苔藓，帽子正前方用木头刻上了一只眼睛——在眼睛中心，绿色的液体缓缓流动，仿佛眼泪一样。"

			end
			 if item.name == "Eyal's Will" then
				item.name = "埃亚尔之意志"
				item.unided_name  = "淡绿色的灵晶"
				item.desc  =  "光滑的绿色晶体，内部有闪亮的绿色液体在流动。偶尔一小滴液体渗了出来，滴在地上，地面马上就长满了青草。"

			end
			 if item.name == "Evermoss Robe" then
				item.name = "真菌之袍"
				item.unided_name  = "深绿的长袍"
				item.desc  =  "这件厚厚的长袍使用一大块深绿的苔藓织成的，十分牢固，摸上去很清凉。据说，它能让人恢复青春。"

			end
			 if item.name == "Nithan's Force" then
				item.name = "尼森之力"
				item.unided_name="巨型投石索"
				item.desc  =  "这个投石索曾属于大力士尼森，他投出的弹药能击倒砖墙，很可能得到了魔法的帮助。"

			end
			 if item.name == "The Titan's Quiver" then
				item.name = "泰坦之箭"
				item.unided_name="巨型陶制箭矢"
				item.desc  =  "巨大而尖锐的箭矢，不，与其说是箭，不如说是长钉。"

			end
			 if item.name == "Inertial Twine" then
				item.name = "惯性编织之戒"
				item.unided_name="缠绕着钢铁的戒指"
				item.desc  =  "双螺旋状的戒指，很难将它移动，戴上它后似乎可以将其力量延展到整个身体。"

			end
			 if item.name == "Everpyre Blade" then
				item.name = "永火木剑"
				item.unided_name="正在燃烧的木剑"
				item.desc  =  "从永不停止燃烧的树上截取下来的木头，精心雕刻后形成的华丽的剑。剑柄用宝石做外壳，暗示其奇特的状态。剑身的火焰似乎能按照剑主人的意愿扭曲。"

			end
			 if item.name == "Eclipse" then
				item.name = "日食"
				item.unided_name="幽暗而闪光的法杖"
				item.desc  =  "这根法杖前部镶嵌有黑色的倾斜球体，似乎正发出强光。"

			end
			 if item.name == "Eksatin's Ultimatum" then
				item.name = "阿克萨丁的最后通牒"
				item.unided_name="血迹斑斑的战斧"
				item.desc  =  "这把被血液浸满的战斧曾被一位不知名的虐待成性的国王使用，他用这把斧头亲自执行了不少死刑。国王有一个房间专门用来收藏他杀死的人的头骨，每一个都完好的保存者。当国王被推翻时，他自己的头颅也进入了这间房子，作为他暴行的证据而保存。"

			end
			 if item.name == "Radiance" then
				item.name = "光辉"
				item.unided_name="闪耀光辉的金色斗篷"
				item.desc  =  "这件古朴的金色斗篷随风漂浮着，内侧洁白无一物，外侧闪耀着强烈的光芒。"

			end
			 if item.name == "Unbreakable Greaves" then
				item.name = "牢不可破之护胫"
				item.unided_name="巨大的石靴"
				item.desc  =  "这对巨大的靴子似乎是用石头雕刻而成的，尽管已经风化破裂，但仍旧能抵抗一切伤害。"

			end
			 if item.name == "The Untouchable" then
				item.name = "不可触及"
				item.unided_name="硬皮甲"
				item.desc  =  "这件破旧的夹克流传在许多乡村传说中。有人说，它属于魔法大爆炸前的一位法师转职成的盗贼，在此之后就遗失了。行行色色的人都声称曾穿过这件衣服，并且在千钧一发时救过他的命，他们说，这就是其名为“不可触及”的原因。"

			end
			 if item.name == "Honeywood Chalice" then
				item.name = "蜂蜜木酒杯"
				item.unided_name="装满液体的杯子"
				item.desc  =  "这个酒杯里装满了粘稠的物质，尝一口能提神醒脑。"

			end
			 if item.name == "Eye of the Dreaming One" then
				item.name = "梦境之眼"
				item.unided_name="半透明的球体"
				item.desc  =  "这个眼睛永远是睁着的，似乎并不相信它见到的事物。"

			end
			 if item.name == "Wyrmbreath" then
				item.name = "龙之吐息"
				item.unided_name="嵌有龙爪的手套"
				item.desc  =  "这件龙鳞手套上嵌着一条恶龙的牙齿与爪子。手套摸上去十分温暖。"

			end
			 if item.name == "The River's Fury" then
				item.name = "河流之怒"
				item.unided_name="华丽的三叉戟"
				item.desc  =  "这柄华丽的三叉戟曾被纳什瓦使用过，当你握紧它时，你会听到奔腾河流的怒吼。"

			end

			 if item.name == "Rod of Sarrilon" then
				item.name = "萨瑞伦之杖"
				item.unided_name="礼仪用的法杖"
				item.desc  =  "看上去普普通通的法杖，但是它和时间的神秘联系连时空法师都不清楚。"

			end
			 if item.name == "Un'fezan's Cap" then
				item.name = "Un'fezan之帽"
				item.unided_name="时尚的红色毡帽"
				item.desc  =  "这顶土耳其毡帽曾经属于一位旅行家，他经常在奇怪的地方被人发现。#{italic}#帽子看上去很不错。#{normal}#"
				item.set_desc.tardis = "需要一件同样时尚而炫酷的装备来搭配，"
			end
			 if item.name == "Omniscience" then
				item.name = "全知"
				item.unided_name="朴素的皮帽"
				item.desc  =  "这顶白色的帽子朴素、笨拙，但是，当光线在它的表面反射时，你看到了世界的极远方。"

			end
			 if item.name == "Earthen Beads" then
				item.name = "大地串珠"
				item.unided_name="系在一起的陶珠"
				item.desc  =  "这是一串古朴而坚硬的陶制串珠，年代久远，已经破碎褪色。它制作于黄昏纪，用来增加和自然的联系。"

			end
			 if item.name == "Hand of the World-Shaper" then
				item.name = "世界塑形之手"
				item.unided_name="异世界的石质手套"
				item.desc  =  "当这双沉重的手套移动时，大地会随之扭曲。"

			end
			 if item.name == "Mercy" then
				item.name = "慈悲"
				item.unided_name="异常尖锐的匕首"
				item.desc  =  "这柄匕首曾被黄昏纪一名无名的医生使用。瘟疫袭击了城镇，而医者终究是凡人，他只能用这柄匕首结束那些绝望的病人的痛苦。尽管初衷是好的，这柄匕首现在已经被黑暗力量污染，用它伤害虚弱的敌人威力更大。"

			end
			 if item.name == "Guise of the Hated" then
				item.name = "仇恨"
				item.unided_name="黑暗围绕的斗篷"
				item.desc  =  "月色皎洁，星空璀璨\n阳光温暖，光辉耀闪\n我心暗淡，其光难入\n我心苦楚，莫可见述\n"

			end
			 if item.name == "Spelldrinker" then
				item.name = "饮法者"
				item.unided_name="怪异的黑色匕首"
				item.desc  =  "无数法师曾殒命这匕首之下，被那些渴望力量的同伴背叛。时光流逝，匆匆不还，这柄匕首也开始渴望杀戮。"

			end
			 if item.name == "Frost Lord's Chain" then
				item.name = "冰霜领主之链"
				item.unided_name="寒冰覆盖的铁链"
				item.desc  =  "这不可思议的金属链覆盖着极度寒霜，向外放射出诡异而强大的光环能量"

			end
			 if item.name == "Twilight's Edge" then
				item.name = "晨昏之刃"
				item.unided_name="发光的长剑"
				item.desc  =  "这柄长剑似乎是用沃瑞坦和蓝锆石混合制成，光与暗在不断旋转交融。"

			end
			 if item.name == "Mnemonic" then
				item.name = "记忆"
				item.unided_name="熟悉的戒指"
				item.desc  =  "只要你戴上这枚戒指，你永远不会忘却。"

			end
			 if item.name == "Acera" then
				item.name = "腐蚀之剑·阿塞拉"
				item.unided_name="被腐蚀的剑"
				item.desc  =  "这柄扭曲的黑刀从无数小孔中滴落酸液。"

			end
			 if item.name == "Butcher" then
				item.name = "屠夫"
				item.unided_name="血迹斑斑的短刃"
				item.desc  =  "或许是堕落，或许是疯狂，半身人屠夫凯莱布杀死他的亲戚代替牲口。他的疯狂还没有停止，他的人影却已经不见，只留下这把刀刃，留在了血泊之中。下面刻着一行字“真有趣，下次再试试”"
				item.special_desc = function(self)
					local maxp = self:min_power_to_trigger()
					return ("生命降至20%%下后进入暴走状态。\n%s"):format(self.power < maxp and (" (冷却时间： %d 回合)"):format(maxp - self.power) or "") 
				end
				item.combat.special_on_hit.desc="试图吞噬一个低生命的敌人。"
				item.combat.special_on_kill.desc="进入暴走(共享冷却)."
			end
			 if item.name == "Ethereal Embrace" then
				item.name = "以太之拥"
				item.unided_name="脆弱的紫色斗篷"
				item.desc  =  "这件斗篷漂浮弯曲，发出闪耀的光芒，折射出空间深处、以太核心。"

			end
			 if item.name == "Boots of the Hunter" then
				item.name = "猎人之靴"
				item.unided_name="用旧了的靴子"
				item.desc  =  "这对有裂缝的靴子涂着厚厚的一层泥浆。目前还不清楚它以前属于谁,但显然,它曾被很多人使用过。"

			end
			 if item.name == "Sludgegrip" then
				item.name = "泥泞之握"
				item.unided_name="粘液覆盖的手套"
				item.desc  =  "这双手套被粘稠的绿色液体覆盖。"

			end
			 if item.name == "Ring of the Archlich" then
				item.name = "大巫妖之戒"
				item.unided_name="布满尘土的戒指"
				item.desc  =  "这枚戒指含有强大的力量，但是没有显现出来。 它将生命拉入金属牢笼之中，而你自己不受伤害。似乎它感觉在不久的将来你会带来无尽的死亡。"
				item.set_desc.archlich = "它渴望被亡灵围绕。"
			end
			 if item.name == "Lightbringer's Wand" then
				item.name = "光明使者之棒"
				item.unided_name="明亮的魔棒"
				item.desc  =  "这个镶嵌着金子的魔棒散发出超自然的强光。"

			end
			 if item.name == "Destala's Scales" then
				item.name = "德斯塔拉之鳞片"
				item.unided_name="绿色的龙鳞斗篷"
				item.desc  =  "黄昏纪末年，一条不知名的毒龙威胁着乡村，冒险家贾斯丁·海风率领的小队杀死了这条恶龙，用它的鳞片制作了这件时尚的斗篷。"

			end
			 if item.name == "Temporal Rift" then
				item.name = "时空裂缝"
				item.unided_name="空间之洞"
				item.desc  =  "某些疯狂的时空法师在时空中开了一个洞。它似乎很有效，但是会以自己诡异的方式运转。"

			end
			 if item.name == "Arkul's Siege Arrows" then
				item.name = "阿库尔的攻城矢"
				item.unided_name="巨大的螺旋箭"
				item.desc  =  "巨大的双螺旋箭，似乎是为推倒高塔而非常规战斗设计。毫无疑问,它们会迅速干掉敌人。"

			end
			 if item.name == "Punae's Blade" then
				item.name = "普纳之刃"
				item.unided_name="很薄的剑"
				item.desc  =  "这柄超乎寻常的薄刃能轻松地在空气中挥舞，让你行动更为迅速。"

			end
			 if item.name == "Crimson Robe" then
				item.name = "深红之袍"
				item.unided_name="被血污染的长袍"
				item.desc  =  "这件长袍曾被卡利斯特拥有，他是一名强大的超能力者，拥有各种能力。在他的妻子被谋杀之后，卡利斯特执着于寻找凶手,用自己的仇恨作为燃料，创造了令人不安的技术。让杀手折磨自己致死后,他行走在地上,迫使任何他发现的人自杀——这是他从世界的恐怖中给予人解脱的方式。有一天,他消失了。这浸泡在血液中的长袍,是他留下的唯一物品。"

			end
			 if item.name == "Exiler" then
				item.name = "放逐"
				item.unided_name="荣誉之戒"
				item.desc  =  "时空法师索利斯在马基埃亚尔的世界中十分有名。他总是抓住了他的敌人落单之时。即使对手不是独自一人,他也能临场发挥。"
				item.use_power.name = function(self, who)
					local Talents = require "engine.interface.ActorTalents"
					local tal = Talents:getTalentFromId(Talents.T_TIME_SKIP)
					local oldlevel = who.talents[Talents.T_TIME_SKIP]
					who.talents[Talents.T_TIME_SKIP] = 2
					local dam = who:damDesc(engine.DamageType.TEMPORAL, who:callTalent(Talents.T_TIME_SKIP, "getDamage", who, tal))
					who.talents[Talents.T_TIME_SKIP] = oldlevel
					return ("对 召 唤 物 造 成 %0.2f 时 空 伤 害（基于 魔 法 和 紊 乱）如果仍存活则移出时间线, 半 径 %d，距 离%d。"):format(dam, self.use_power.radius, self.use_power.range)
				end
			end
			 if item.name == "The Face of Fear" then
				item.name = "恐惧之颜"
				item.unided_name  = "骨质面具"
				item.desc  =  "这件面具似乎用某种不明生物的头骨制成的，那是一种本不应该存在于世间的可怕生物，畸形并且扭曲。每当你盯着这个面具时，它那空洞的眼窝似乎也在注视着你，令你感到发自内心的颤栗。"

			end
			 if item.name == "Cinderfeet" then
				item.name = "余烬之足"
				item.unided_name  = "一双被火焰覆盖的草鞋"
				item.desc  =  "这是一个警示故事，讲的是有个叫凯姆的古代术士，为了勘查地狱般的恶魔荒原，也为了考验自己，自命不凡的认为可以在恶魔的老巢高达勒斯天天散步。他每次从恶魔位面归来都小心翼翼地不敢带回任何东西，生怕成为恶魔找到他的指引。不幸的是，来回很多次以后，他的草鞋浸满了恐惧之地的烟尘和灰烬。地狱之焰随他的脚步被带到了世间，同时也注定了他悲惨的命运。"

			end
			 if item.name == "Cuirass of the Dark Lord" then
				item.name = "黑暗领主胸甲"
				item.unided_name  = "一件黑色的尖刺铠甲"
				item.desc  =  "这件胸甲属于一个早已被人遗忘的暴君，成千上万无辜死者的鲜血强化了这件铠甲。黑暗领主最终在衰老与虚弱中孤独的死去，他的统治分崩离析，他的人民四散而去。只有这件胸甲被保留了下来，渴望着再次品尝鲜血的味道。"
				item.use_power.name = "吸 收 半 径 5 内 所 有 生 物 的 血 液 ,   令 其 在 4 回 合内 受 到 1 2 0 点 流  血 伤 害 。 每 吸 收 一 个 生 物 （至 多 1 0 ） ， 护 甲的 属 性 增 加 。 10 回 合 后 复 原。"
			end
			 if item.name == "Yaldan Baoth" then
				item.name = "雅尔丹 宝石"
				item.unided_name="昏暗的头盔"
				item.desc  =  "这顶金色的王冠属于传说之城雅尔丹之王——Veluca。【待翻译】他比他的任何亲戚活得都长，在生命的最后日子里，他行走在早期的世界上，教育人们反抗黑暗。临死前，这顶王冠交给了他的继任者，一同交付的还有他的遗言——勿惧邪恶"

			end
			 if item.name == "Blackfire Aegis" then
				item.name = "黑炎石盾"
				item.unided_name  = "黑色的石质盾牌"
				item.desc  =  "这个坚固的石盾闪烁着漆黑的火焰。"

			end
			 if item.name == "Will of Ul'Gruth" then
				item.name = "Ul'Gruth的意志"
				item.unided_name  = "巨型金属手套"
				item.desc  =  "这双巨大的手套曾经属于一个名叫Ul'Gruth的强大的恶魔。据说，这个怪物一挥手就能将一座城市夷为平地。"

			end
			 if item.name == "Fearfire Mantle" then
				item.name = "恐惧之焰"
				item.unided_name  = "火焰般的斗篷"
				item.desc  =  "黑色的火焰从漆黑的心脏中涌出。"

			end
			 if item.name == "Plague-Fire Sceptre" then
				item.name = "疫火权杖"
				item.unided_name  = "黑色的法杖"
				item.desc  =  "Mal'Rok的火焰比一般的火焰更加顽强。当它们无物可燃时，它们知道去哪里寻找。"

			end
			 if item.name == "Dethblyd" then
				item.name = "Dethblyd"
				item.unided_name  = "黑色的剑"
				item.desc  =  "毁灭者Grushgore以头脑简单四肢发达闻名。他从不擅长谋略，但他的力量无以伦比。"

			end
			 if item.name == "Quasit's Skull" then
				item.name = "夸塞魔之颅"
				item.unided_name  = "岩石头盔"
				item.desc  =  "一些有魄力的冒险者已经注意到了夸塞魔的皮肤其实比大多数金属都要坚硬，这个头盔就是一个夸塞魔的颅骨制成的。呣，气味浓郁。"

			end
			 if item.name == "Blackfire Aegis" then
				item.name = "黑炎石盾"
				item.unided_name  = "黑色的石质盾牌"
				item.desc  =  "这个坚固的石盾闪烁着漆黑的火焰。"

			end
			 if item.name == "Revenant" then
				item.name = "亡魂"
				item.unided_name  = "不断变形的胸甲"
				item.desc  =  "关节不祥的咯吱作响，骨架弯曲突起的呼吸。划痕与裂纹是金属的低语，有关苦楚、失去、坚持与复仇。"

			end
			 if item.name == "Imp Claw" then
				item.name = "小鬼之爪"
				item.unided_name  = "红色的爪子"
				item.desc  =  "这是一只火焰小鬼留下的满是伤痕的爪子。它还燃烧着不自然的火焰。"

			end
			 if item.name == "Wheel of Fate" then
				item.name = "命运之轮"
				item.unided_name  = "命运之轮"
				item.desc  =  "这不是我想要的结果！- Howar	Muransk,普通人类恶魔学家。\nThis band of gothic obsidian menaces with an embossed image of a grinning skull. It beckons you to tempt fate and put it on. Do you?"

			end
			 if item.name == "Helm of the Dominated" then
				item.name = "支配头盔"
				item.unided_name  = "长角的头盔"
				item.desc  =  "这个头盔是为了提高Doom Elf的能力，而作为实验产品被制造出来。"

			end
			 if item.name == "The Black Crown" then
				item.name = "黑之冠"
				item.unided_name  = "破碎的黑曜石头盔"
				item.desc  =  "魔中之魔，加冕为王"

			end
			 if item.name == "The Black Core" then
				item.name = "黑之核"
				item.unided_name  = "黑色的宝石"
				item.desc  =  "锁住灵魂，死亡莫及。"

			end
			 if item.name == "The Black Spike" then
				item.name = "黑之钉"
				item.unided_name  = "很薄的黑色短剑"
				item.desc  =  "世界之心，终将刺穿"

			end
			 if item.name == "The Black Ring" then
				item.name = "黑之戒"
				item.unided_name  = "黑曜石戒指"
				item.desc  =  "勿视其中，安然无恙"

			end
			 if item.name == "The Black Boots" then
				item.name = "黑之靴"
				item.unided_name  = "黑色的靴子"
				item.desc  =  "背叛之路，直通天际"

			end
			 if item.name == "The Black Plate" then
				item.name = "黑之铠"
				item.unided_name  = "黑曜石胸甲"
				item.desc  =  "己身若残，何物能存?"

			end
			 if item.name == "The Black Maul" then
				item.name = "黑之锤"
				item.unided_name  = "巨大的黑曜石战锤"
				item.desc  =  "冠军之锤，举重若轻"

			end
			 if item.name == "The Black Maul" then
				item.name = "黑之锤"
				item.unided_name  = "巨大的黑曜石战锤"
				item.desc  =  "冠军之锤，举重若轻"

			end
			 if item.name == "The Black Wall" then
				item.name = "黑之墙"
				item.unided_name  = "巨大的黑曜石盾牌"
				item.desc  =  "披坚持盾，众莫能伤"

			end
			 if item.name == "Planar Beacon" then
				item.name = "空间信标"
				item.unided_name  = "闪光的红色球体"
				item.desc  =  "从恶魔手里拿到的奇怪的球体，它正闪耀着超现实的红光。"

			end
			 if item.name == "Jaw of Rogroth" then
				item.name = "Rogroth的下颚"
				item.unided_name  = "布满尖齿的腰带"
				item.desc  =  "真有趣，灵魂吞噬者Rogroth的嘴巴正好和你的腰一样大。"

			end
			 if item.name == "Bikini" then
				item.name = "比基尼"
				item.unided_name  = "小小的一块布"
				item.desc  =  [[性感，粉色，有趣。
    #{bold}#如果你在全程不脱下它的情况下通关你将可以得到一个成就和吹牛的权利！#{normal}#]]

			end
			 if item.name == "Mankini" then
				item.name = "男性比基尼"
				item.unided_name  = "小小的一块布"
				item.desc  =  [[性感，绿色，有趣。
    #{bold}#如果你在全程不脱下它的情况下通关你将可以得到一个成就和吹牛的权利！#{normal}#]]

			end

	if item.name == "Staff of Absorption" then
	item.name = "吸能法杖"
	item.unided_name  = "黑暗符文法杖"
	item.desc  =  "杖身铭刻着符文，这根法杖似乎是很久以前制造的，虽然它毫无侵蚀的痕迹。它周围的光线会变的暗淡，当你触摸它时可以感受到惊人的魔力。"
	end
--[[	if item.name == "Orb of Many Ways" then
	item.name = "多元水晶球"
	item.unided_name  = "涡流水晶球"
	item.desc  =  "这个球体可以折射出远处的景象并快速的切换着，有些景象甚至不属于这个世界。如果你在传送点附近使用它，它可能会激活传送。"
	end]]
--[[	if item.name == "Orb of Many Ways Demon" then
	item.name = "多元水晶球"
	item.unided_name  = "涡流水晶球"
	item.desc  =  "这个球体可以折射出远处的景象并快速的切换着，有些景象甚至不属于这个世界。如果你在传送点附近使用它，它可能会激活传送。"
	end]]
	if item.name == "Orb of Undeath (Orb of Command)" then
	item.name = "指令水晶球（亡灵） "
	item.unided_name  = "指令水晶球"
	item.desc  =  "当你拿起这个水晶球时，无尽的黑暗铺面而来。这个球摸上去冰凉。"
	end
	if item.name == "Dragon Orb (Orb of Command)" then
	item.name = "指令水晶球（巨龙）"
	item.unided_name  = "指令水晶球"
	item.desc  =  "这个水晶球摸起来很暖和。"
	end
	if item.name == "Elemental Orb (Orb of Command)" then
	item.name = "指令水晶球（元素）"
	item.unided_name  = "指令水晶球"
	item.desc  =  "火焰在覆满了冰霜的水晶球上旋转。"
	end	
	if item.name == "Orb of Destruction (Orb of Command)" then
	item.name = "指令水晶球（毁灭）"
	item.unided_name  = "指令水晶球"
	item.desc  =  "当你拿起这个水晶球时，你眼前浮现出死亡和毁灭的景象。"
	end
	if item.name == "Scrying Orb" then
	item.name = "鉴定水晶球"
	item.unided_name  = "鉴定水晶球"
	item.desc  =  "这个球是半身人先知埃莉萨给你的，它会自动为你鉴定装备。"
	end
	if item.name == "Rod of Recall" then
	item.name = "回归之杖"
	item.unided_name  = "不稳定的魔杖"
	item.desc  =  "这个法杖通体用沃瑞钽打造，充满了可以撕裂空间的奥术能量。你以前曾听说过此类物品。它们对于冒险者的快速旅行非常有帮助。"
	end
	if item.name == "Transmogrification Chest" then
	item.name = "转化之盒"
	item.unided_name  = ""
	item.desc  =  [[这只宝箱是伊尔克古尔的延伸，任何扔在里面的物品会被自动传送到湖底要塞，由核心驱动，当能量耗尽时会被破坏。这件物品的副作用是，由于金币对要塞是没用的，它会自动返还给你。
当你有这只箱子时，所有你经过地面上的物品会被自动捡起，并且当你离开地下城时会自动交易成金币。
如果你想保留物品，只需要从宝箱里把它移到包裹中。在宝箱中的物品不会增加你的负重。]]
	end

	if item.name == "Elixir of the Fox" then
	item.name = "狡诈药剂"
	item.unided_name = "一瓶粉红色的液体"
	item.desc = "一瓶粉红色的透明液体。"
	end
	if item.name == "Elixir of Avoidance" then
	item.name = "闪避药剂"
	item.unided_name = "一瓶绿色的液体"
	item.desc = "一瓶浑浊的绿色液体。"
	end
	if item.name == "Elixir of Precision" then
	item.name = "精准药剂"
	item.unided_name = "一瓶红色的液体"
	item.desc = "一瓶粘稠的红色液体。"
	end
	if item.name == "Elixir of Mysticism" then
	item.name = "神秘药剂"
	item.unided_name = "一瓶青色的液体"
	item.desc = "一瓶炽热的青色液体。"
	end
	if item.name == "Elixir of the Savior" then
	item.name = "守护药剂"
	item.unided_name = "一瓶灰色的液体"
	item.desc = "一瓶翻滚着泡沫的灰色液体。"
	end
	if item.name == "Elixir of Mastery" then
	item.name = "掌握药剂"
	item.unided_name = "一瓶栗色的液体"
	item.desc = "一瓶浓郁的栗色液体。"
	end
	if item.name == "Elixir of Explosive Force" then
	item.name = "爆炸药剂"
	item.unided_name = "一瓶橙色的液体"
	item.desc = "一瓶浑浊的橙色液体。"
	end
	if item.name == "Elixir of Serendipity" then
	item.name = "幸运药剂"
	item.unided_name = "一瓶黄色的液体"
	item.desc = "一瓶流动的黄色液体。"
	end
	if item.name == "Elixir of Focus" then
	item.name = "专注药剂"
	item.unided_name = "一瓶透明的液体"
	item.desc = "一瓶透明的沸腾液体。"
	end
	if item.name == "Elixir of Brawn" then
	item.name = "蛮牛药剂"
	item.unided_name = "一瓶棕褐色的液体"
	item.desc = "一瓶粘稠的棕褐色液体。"
	end
	if item.name == "Elixir of Stoneskin" then
	item.name = "石肤药剂"
	item.unided_name = "一瓶有金属光泽的液体"
	item.desc = "一瓶带有特殊纹理、泛着金属光泽的液体。"
	end
	if item.name == "Elixir of Foundations" then
	item.name = "领悟药剂"
	item.unided_name = "一瓶白色的液体"
	item.desc = "一瓶朦胧的白色液体。"
	end
	if item.name == "Taint of Telepathy" then
	item.name = "堕落印记：感应"
	item.unided_name = ""
	item.desc = ""
	end
	if item.name == "Infusion of Wild Growth" then
	item.name = "纹身：根须缠绕"
	item.unided_name = ""
	item.desc = ""
	end
	if item.name == "Lifebinding Emerald" then
	item.name = "生命之心"
	item.unided_name = "半透明的厚重翡翠"
	item.desc = "一块不规则的厚重翡翠，表面有云纹浮动。"
	end
	if item.name == "Elixir of Invulnerability" then
	item.name = "无敌药剂"
	item.unided_name = "一瓶黑色的液体"
	item.desc = "一瓶粘稠的反射着金属光泽的液体。它有着难以置信的重量。"
	end
	if item.name == "Decayed Visage" then
		item.name = "堕落视觉"
		item.unided_name = "木乃伊皮面罩"
		item.desc = [[一小片人皮面具，是派尔纪一位死灵法师的遗物。他试图变成巫妖，但是没有成功。他的身体逐渐腐烂，但由于未成功的法术而不能死去，就这样过了数年。现在，他的灵魂仍藏身于这小块皮肤中，渴求着永恒的生命。]]
		end
	if 	item.name == "Dream Malleus" then
		item.name = "梦境之槌"
		item.unided_name = "发光木锤"
		item.desc = [[一个闪闪发光的大木槌,你的耳朵里似乎能听到它发出的声音.它既像思想一样有可塑性也像最强的钢铁那样坚硬.]]
	end
	if 	item.name == "Cloud Caller" then
		item.name = "唤云者"
		item.unided_name = "宽边帽"
		item.desc = [[这顶帽子宽阔的帽檐保护您免受恶劣的阳光和突如其来的暴风雨.]]
	end
	if 	item.name == "The Jolt" then
		item.name = "震撼"
		item.unided_name = "刺痛项圈"
		item.desc = [[这项圈摸起来让人觉得刺痛,但似乎增强了你的思考.]]
		item.special_desc = function(self) 
			return "每次当你 的 雷 电 伤 害 超 过 了 目 标 10%% 最 大 生 命 时 ， 将 附 加 锁 脑 状 态。" end
	end
	if 	item.name == "Stormfront" then
		item.name = "风暴前线"
		item.unided_name = "潮湿的钢铁战斧"
		item.desc = [[剑身泛着淡淡的蓝色,反射出了满天的乌云.]]
		item.combat.special_on_crit.desc = "造成湿润或震撼效果。"
	end
	if 	item.name == "Eye of Summer" then
		item.name = "夏日之眼"
		item.unided_name = "温暖的灵晶"
		item.desc = [[这个灵晶散发着温暖的微光,但似乎有点残缺.]]
		item.set_desc.eyesummer = "自然需要平衡的灵晶."
	end
	if 	item.name == "Eye of Winter" then
		item.name = "冬日之眼"
		item.unided_name = "寒冰的灵晶"
		item.desc = [[这个灵晶散发着寒冷的微光,但似乎有点残缺.]]
		item.set_desc.eyewinter = "自然需要平衡的灵晶."
	end
	if 	item.name == "Ruthless Grip" then
		item.name = "无情之握"
		item.unided_name = "邪恶的手套"
				item.desc = [[一个军阀为了永远掌握他的臣民而制造的.黑暗的思想被真正的灌注进去这些手套里.]]	
	end
	if 	item.name == "Icy Kill" then
		item.name = "冰冷杀戮"
		item.unided_name = "锋利的冰柱"
		item.desc = [[任何占卜师都知道，凶器乃是缉查凶手最重要的线索；他们往往顺着这条线索顺藤摸瓜，从人群中找出凶手的真身。
        然而，一个冷酷的杀手找到了一个办法：他用寒冰铸成了一把利刃，将其刺入受害者的胸口，让其随着受害者心脏的体温渐渐融化，消失于无形。
        最终，这名杀手仍然没有逍遥于法外。一名受害者幸运地夺下了利刃，反身刺入了杀手的心脏里。杀手冷酷的内心没有温度，而这把与其相融的利刃从此再也不会融化。]]
		item.combat.special_on_crit.desc="冻结目标"
		item.combat.special_on_kill.desc="令 一 个 冻 结 生 物 爆 炸 ( 伤 害 受 意 志 加 成)"
		end
	if item.name =="Thunderfall" then
			item.name = "落雷"
			item.unided_name = "巨型发声狼牙棒"
			item.desc = [[巨大的力量集中在这沉重的权杖里.只是掉落在地就可以摧毁附近的墙壁.]]
			item.use_power.name = function(self, who) 
				return ("对 范 围 %d 内 的 一 个 目 标 造 成 自 动 暴 击 的 雷 电 伤 害。"):format(self.use_power.range) 
				end
		end
	if 	item.name == "Kinetic Focus" then
		item.name = "动能之核"
		item.unided_name = "发出嗡嗡声的灵晶"
		item.desc = [[动能集中在这个灵晶的核心里.]]
		item.set_desc.trifocus = "在这个物品里你感受到了两种不相关的能量。"
		end
	if 	item.name == "Charged Focus" then
		item.name = "电能之核"
		item.unided_name = "发出火花的灵晶"
		item.desc = [[电能集中在这个灵晶的核心里.]]
				item.set_desc.trifocus = "在这个物品里你感受到了两种不相关的能量。"
		end
 	if 	item.name == "Thermal Focus" then
		item.name = "热能之核"
		item.unided_name = "炽热的的灵晶"
		item.desc = [[热能集中在这个灵晶的核心里.]]
				item.set_desc.trifocus = "在这个物品里你感受到了两种不相关的能量。"
		end
	if 	item.name == "Lightning Catcher" then
		item.name = "雷电接收器"
		item.unided_name = "螺旋形金属腰带"
		item.desc = [[一个坚固的铁链缠着细金属丝网。火花在上面跳舞.]]
		item.special_desc = function(self)
		 return [[每 次 接 受 雷 电 伤 害 或 造 成 暴 击 雷 电 伤 害 时 获 得两 点 充 能 ， 每 点 充 能 提 供 5%% 雷 电 伤 害 加 成 和 1 点 全属 性 。 每 回 合 损 失一 点 加 成。]] 
		end
	end
    if item.name == "Astelrid's Clubstaff" then
		item.name = "医师亚斯特莉的“狼牙棒”"
		item.unided_name = "一把巨锤"
		item.desc = [[如同它的前任主人一样，这曾经是无私治愈的工具，然而愤怒和恐惧将其扭曲成一把嗜血的武器。在插着锋利的手术设备的石膏涂层下，依稀可以感觉到流淌而出的治疗魔法的力量]]
		item.special_desc = function(self)
		 return [[增 加 纹 身 和 符 文 的 属 性 加 成 效 果 15%%]]         
        end
	end
end
end
end)