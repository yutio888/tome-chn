achievementCHN = {}

function achievementCHN:getName(name)
	if name:find(" %(") then 
		local f=name:find(" %(")
		local achname = name:sub(1,f-1)
		local chnname = achname
		if achievementCHN[achname] then chnname = achievementCHN[achname] end
		name = name:gsub(achname,chnname):gsub("Nightmare","噩梦难度"):gsub("Insane","疯狂难度"):gsub("Madness","绝望难度")
						 :gsub("Adventure","冒险模式"):gsub("Roguelike","永久死亡模式"):gsub("Exploration","探索模式")
						 :gsub("mode",""):gsub("difficulty","")
	elseif achievementCHN[name] then name = achievementCHN[name]
	end
	return name
end

--竞技场
achievementCHN["The Arena"] = "竞技场"
achievementCHN["Arena Battler 20"] = "竞技场20波"
achievementCHN["Arena Battler 50"] = "竞技场50波"
achievementCHN["Almost Master of Arena"] = "接近竞技之王"
achievementCHN["Master of Arena"] = "竞技之王"
achievementCHN["XXX the Destroyer"] = "毁灭者XXX"
achievementCHN["Grand Master"] = "竞技大师"
achievementCHN["Ten at one blow"] = "横扫千军"

--事件（events）
achievementCHN["The sky is falling!"] = "天塌了！"
achievementCHN["Demonic Invasion"] = "恶魔入侵"
achievementCHN["Invasion from the Depths"] = "海底入侵"
achievementCHN["The Restless Dead"] = "永不安息"
achievementCHN["The Rat Lich"] = "巫妖鼠"
achievementCHN["Shasshhiy'Kaish"] = "莎西·凯希"
achievementCHN["Bringer of Doom"] = "厄运行者"
achievementCHN["A living one!"] = "一只活着的夏图尔人！"
achievementCHN["Slimefest"] = "淤泥巢穴"
achievementCHN["Slime killer party"] = "史莱姆杀手聚会"
achievementCHN["Don't mind the slimy smell"] = "别在意这股史莱姆味～"
achievementCHN["In the company of slimes"] = "史莱姆大军"

--无尽地下城
achievementCHN["Infinite x10"] = "无尽10层"
achievementCHN["Infinite x20"] = "无尽20层"
achievementCHN["Infinite x30"] = "无尽30层"
achievementCHN["Infinite x40"] = "无尽40层"
achievementCHN["Infinite x50"] = "无尽50层"
achievementCHN["Infinite x60"] = "无尽60层"
achievementCHN["Infinite x70"] = "无尽70层"
achievementCHN["Infinite x80"] = "无尽80层"
achievementCHN["Infinite x90"] = "无尽90层"
achievementCHN["Infinite x100"] = "无尽100层"
achievementCHN["Infinite x150"] = "无尽150层"
achievementCHN["Infinite x200"] = "无尽200层"
achievementCHN["Infinite x300"] = "无尽300层"
achievementCHN["Infinite x400"] = "无尽400层"
achievementCHN["Infinite x500"] = "无尽500层"

--物品（items）
achievementCHN["Deus Ex Machina"] = "上帝之佑"
achievementCHN["Treasure Hunter"] = "宝藏猎人"
achievementCHN["Treasure Hoarder"] = "藏金库"
achievementCHN["Dragon's Greed"] = "龙之贪婪"

--杀怪记录（kills）
achievementCHN["That was close"] = "千钧一发"
achievementCHN["Size matters"] = "伤害很重要"
achievementCHN["Size is everything"] = "伤害就是一切"
achievementCHN["The bigger the better!"] = "越大越好！"
achievementCHN["Overpowered!"] = "暴走！"
achievementCHN["Exterminator"] = "屠夫"
achievementCHN["Pest Control"] = "害虫防治"
achievementCHN["Reaver"] = "收割者"
achievementCHN["Backstabbing Traitor"] = "背后伤人"
achievementCHN["Bad Driver"] = "路痴"
achievementCHN["Guiding Hand"] = "最佳护卫"
achievementCHN["Earth Master"] = "大地领主"
achievementCHN["Kill Bill!"] = "杀死比尔！"
achievementCHN["Atamathoned!"] = "阿塔麦森！"
achievementCHN["Huge Appetite"] = "大胃王"
achievementCHN["Headbanger"] = "铁头功大师"
achievementCHN["Are you out of your mind?!"] = "你犯2了吗？！"
achievementCHN["I cleared the room of death and all I got was this lousy achievement!"] = "我清完“死亡之屋”后发现我只得到了这个无聊的成就！"
achievementCHN["I'm a cool hero"] = "我是超级英雄！"
achievementCHN["Kickin' it old-school"] = "挥挥衣袖，挥死一片闪电"
achievementCHN["Leave the big boys alone"] = "千里杀一人"
achievementCHN["You know who's to blame"] = "你知道谁才是罪人！"
achievementCHN["You know who's to blame (reprise)"] = "你知道谁才是罪人（重复）！"
achievementCHN["Now, this is impressive!"] = "令人惊讶！"
achievementCHN["Fear of Fours"] = "恐惧四人组"
achievementCHN["Well trained"] = "训练有素"

--文献（lores）
achievementCHN["Tales of the Spellblaze"] = "魔法大爆炸的秘密"
achievementCHN["The Legend of Garkul"] = "加库尔传奇"
achievementCHN["A different point of view"] = "另一种立场"

--玩家（player）
achievementCHN["Level 10"] = "10级"
achievementCHN["Level 20"] = "20级"
achievementCHN["Level 30"] = "30级"
achievementCHN["Level 40"] = "40级"
achievementCHN["Level 50"] = "50级"
achievementCHN["Unstoppable"] = "无人可挡"
achievementCHN["Utterly Destroyed"] = "完全毁灭"
achievementCHN["Fool of a Took!"] = "蠢货！"
achievementCHN["Emancipation"] = "自由了！"
achievementCHN["Take you with me"] = "同归于尽"
achievementCHN["Look at me, I'm playing a roguelike!"] = "看！我正在玩Roguelike！"
achievementCHN["Fear me not!"] = "恐惧无法挡我！"

--任务（quests）
achievementCHN["Baby steps"] = "启程！"
achievementCHN["Vampire crusher"] = "吸血鬼毁灭者"
achievementCHN["A dangerous secret"] = "危险的秘密"
achievementCHN["The secret city"] = "秘密城市"
achievementCHN["Burnt to the ground"] = "烟花灿烂"
achievementCHN["Against all odds"] = "挑战不平等"
achievementCHN["Sliders"] = "激活触点"
achievementCHN["Destroyer's bane"] = "毁灭者的末日"
achievementCHN["Brave new world"] = "奔向新世界"
achievementCHN["Race through fire"] = "穿越火海"
achievementCHN["Orcrist"] = "兽人末日"
--wins
achievementCHN["Evil denied"] = "铲除邪恶"
achievementCHN["The High Lady's destiny"] = "至高女士的命运"
achievementCHN["The Sun Still Shines"] = "阳光依旧灿烂"
achievementCHN["Selfless"] = "无私奉献"
achievementCHN["Triumph of the Way"] = "维网的凯歌"
achievementCHN["No Way!"] = "我拒绝！"
achievementCHN["Tactical master"] = "战术大师"
achievementCHN["Portal destroyer"] = "传送门毁灭者"
achievementCHN["Portal reaver"] = "传送门收割者"
achievementCHN["Portal ender"] = "传送门终结者"
achievementCHN["Portal master"] = "传送门主宰者"
achievementCHN["Never Look Back And There Again"] = "从未回头"
--Other quests
achievementCHN["Rescuer of the lost"] = "救助迷失者"
achievementCHN["Poisonous"] = "卑鄙小人"
achievementCHN["Destroyer of the creation"] = "创造神终结者"
achievementCHN["Treacherous Bastard"] = "阴险的背叛者"
achievementCHN["Flooder"] = "倒戈"
achievementCHN["Gem of the Moon"] = "月亮宝石"
achievementCHN["Curse Lifter"] = "诅咒超度者"
achievementCHN["Fast Curse Dispel"] = "快速除咒"
achievementCHN["Eye of the storm"] = "风暴之眼"
achievementCHN["Antimagic!"] = "反魔法训练"
achievementCHN["Anti-Antimagic!"] = "摧毁反魔法！"
achievementCHN["There and back again"] = "我回来了！"
achievementCHN["Back and there again"] = "我会回来的！"
achievementCHN["Arachnophobia"] = "蜘蛛杀手"
achievementCHN["Clone War"] = "克隆战争"
achievementCHN["Home sweet home"] = "家，甜蜜的家"
achievementCHN["Squadmate"] = "一路有你"
achievementCHN["Genocide"] = "种族灾难"
achievementCHN["Savior of the damsels in distress"] = "迷路少女拯救者"
achievementCHN["Impossible Death"] = "不可能的死亡"
achievementCHN["Self-killer"] = "自杀者"
achievementCHN["Paradoxology"] = "时空悖论"
achievementCHN["Explorer"] = "探索者"
achievementCHN["Orbituary"] = "轨道学者"
achievementCHN["Wibbly Wobbly Timey Wimey Stuff"] = "摇晃的不稳定法杖"
achievementCHN["Matrix style!"] = "黑客帝国！"
achievementCHN["The Right thing to do"] = "正确的选择"
achievementCHN["Lost in translation"] = "迷失"
achievementCHN["Thralless"] = "奴隶救星！"
achievementCHN["Dreaming my dreams"] = "我的梦就是你的梦"
achievementCHN["Oozemancer"] = "软泥使"
achievementCHN["Lucky Girl"] = "幸运女孩"
--技能解锁
achievementCHN["Pyromancer"] = "烈焰术士"
achievementCHN["Cryomancer"] = "冰霜术士"
achievementCHN["Lichform"] = "巫妖化"

--DLC
achievementCHN["A Fist Full of Demons"] = "恶魔杀戮者"
achievementCHN["Glory to the Fearscape"] = "恐惧长廊之荣耀"
achievementCHN["Well Seeded"] = "种子培育专家"
achievementCHN["Demonic Party!"] = "恶魔狂欢！"
achievementCHN["Hell has no fury like a demon scorned!"] = "地狱逃脱"
achievementCHN["Once bitten, twice shy"] = "再一次的胜利"
achievementCHN["The Old Ones"] = "古老神话"
