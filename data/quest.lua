--转化任务名字 
questCHN = {}

function questCHN:getquestname(name)
			local qname = name
			if questCHN[name] then
				qname = questCHN[name].name
			elseif name:find("Escort") then
				qname = questCHN["Escort"].name(name)
			end
			return qname
end
questCHN["Hidden treasure"] = {
name = " 隐 藏 的 财 宝 ",
description = function(desc)
    desc = string.gsub(desc,"You have found all the clues leading to the hidden treasure. There should be a way on the third level of the Trollmire."," 你 已 经 找 到 了 所 有 有 关 秘 密 财 宝 的 线 索， 在 食 人 魔 沼 泽 第 三 层 应 该 能 找 到 一 条 通 往 那 里 的 路。 ")
	desc = string.gsub(desc,[[It looks extremely dangerous, however %- beware.]],[[ 注 意： 看 样 子 那 里 非 常 危 险。 ]])
	desc = string.gsub(desc,"You have slain Bill. His treasure is yours for the taking."," 你 已 经 干 掉 了 比 尔， 他 的 财 宝 现 在 归 你 了。 ")
	return desc
end}

questCHN["The fall of Zigur"] = {
name = " 伊 格 的 陷 落 ",
description = function(desc)
	desc = string.gsub(desc,"You decided to side with the Grand Corruptor and joined forces to assault the Ziguranth main base of power."," 你 决 定 与 “ 堕 落 者 大 师 ” 并 肩 战 斗， 加 入 对 伊 格 兰 斯 主 力 部 队 的 攻 击。 ")
	desc = string.gsub(desc,"The Grand Corruptor died during the attack before he had time to teach you his ways."," “ 堕 落 者 大 师 ” 在 战 斗 中 死 了， 不 过 战 斗 中 你 学 会 了 他 很 多 东 西。 ")
	desc = string.gsub(desc,"The defenders of Zigur were crushed, the Ziguranth scattered and weakened."," 伊 格 城 的 防 御 被 击 溃 了， 伊 格 兰 斯 的 势 力 受 到 了 分 化 和 削 弱。 ")
	desc = string.gsub(desc,"In the aftermath you turned against the Grand Corruptor and dispatched him."," 最 后， 你 背 叛 了 堕 落 大 师 并 杀 死 了 他。 ")
	return desc
end}

questCHN["The Curse of Magic"] = {
name = " 魔 法 的 诅 咒 ",
description = function(desc)
	desc = string.gsub(desc,"You have been invited to join a group called the Ziguranth, dedicated to opposing magic."," 你 被 邀 请 参 加 一 个 叫 做 伊 格 兰 斯 的 组 织， 致 力 于 对 抗 魔 法。 ")
	return desc
end}

questCHN["The Arena"] = {
name = " 竞 技 场 ",
description = function(desc)
	desc = string.gsub(desc,"Seeking wealth, glory, and a great fight, you challenge the Arena!"," 寻 找 财 富、 荣 耀 和 强 大 的 对 手， 去 挑 战 竞 技 场 吧！ ")
	desc = string.gsub(desc,"Can you defeat your foes and become Master of Arena%?"," 你 能 打 败 你 的 对 手， 甚 至 打 败 竞 技 场 主 宰 么？ ")
	desc = string.gsub(desc,"Well done! You have won the Arena: Challenge of the Master"," 干 的 好！ 你 已 经 赢 得 了： 竞 技 场 主 宰 的 荣 誉！ ")
	desc = string.gsub(desc,"You valiantly fought every creature the arena could throw at you and you emerged victorious!"," 你 勇 敢 地 战 胜 了 竞 技 场 里 的 所 有 生 物 并 赢 得 了 最 终 胜 利！ ")
	desc = string.gsub(desc,"Glory to you, you are now the new master and your future characters will challenge you."," 荣 耀 归 于 你， 现 在 你 是 新 的 竞 技 场 主 宰， 你 可 以 用 以 后 的 角 色 来 挑 战 你 自 己。 ")
	return desc
end}

questCHN["The agent of the arena"] = {
name = " 竞 技 场 代 理 人 ",
description = function(desc)
	desc = string.gsub(desc,"You were asked to prove your worth as a fighter by a rogue, in order to participate in the arena"," 你 被 要 求 用 一 个 盗 贼 的 角 色 进 入 竞 技 场 证 明 你 的 实 力。 ")
	desc = string.gsub(desc,"You succesfully defeated your adversaries and gained access to the arena!"," 你 成 功 战 胜 了 你 的 对 手， 你 现 在 可 以 进 入 竞 技 场 了！ ")
	return desc
end}

questCHN["The Brotherhood of Alchemists"] = {
name = " 炼 金 术 士 兄 弟 会 ",
description = function(desc)
	desc = string.gsub(desc,"Thanks to your timely aid, "," 谢 谢 你 的 及 时 帮 助， ")
	desc = string.gsub(desc," is the newest member of the Brotherhood of Alchemists."," 是 炼 金 术 士 兄 弟 会 的 新 成 员 了。 ")
	desc = string.gsub(desc,"You aided various denizens of Maj'Eyal in their attempts to join the Brotherhood of Alchemists, though you did not prove the deciding factor for any. This year's new member is "," 虽 然 你 没 有 证 明 那 些 决 定 性 因 素， 你 还 是 帮 助 了 不 同 的 马 基 埃 亚 尔 的 居 民 加 入 了 炼 金 术 士 兄 弟 会， 今 年 的 新 成 员 是 ")
	desc = string.gsub(desc,"Various alchemists around Maj'Eyal are competing to gain entry into the great Brotherhood of Alchemists, and one or more have enlisted your aid."," 很 多 马 基 埃 亚 尔 的 炼 金 术 士 想 竞 争 加 入 强 大 的 炼 金 术 士 兄 弟 会， 其 中 有 一 个 或 者 几 个 人 请 求 你 的 帮 助。 ")
	desc = string.gsub(desc,"You have aided "," 你 帮 助 了 ")
	desc = string.gsub(desc," in creating an "," 制 造 ")
	desc = string.gsub(desc," has completed an "," 已 经 制 造 了 ")
	desc = string.gsub(desc," without your aid.","， 并 没 有 获 得 你 的 帮 助。 ")
	desc = string.gsub(desc,"Having failed to gain admittance to the Brotherhood of the Alchemists, "," 没 有 获 得 炼 金 术 士 兄 弟 会 的 承 认， ")
	desc = string.gsub(desc," no longer needs your help making the "," 不 在 需 要 你 帮 忙 制 作 ")
	desc = string.gsub(desc," needs your help making an "," 需 要 你 的 帮 助 来 制 作 ")
	desc = string.gsub(desc,". He has given you some notes on the ingredients:","。 他 给 了 你 一 张 写 着 配 方 的 小 纸 条： ")
	desc = string.gsub(desc," 'Needed: one "," 需 要 材 料： ")
	desc = string.gsub(desc," You've found the needed "," 你 找 到 了 所 需 的 ")
	desc = string.gsub(desc,"elixir of the fox"," 狡 诈 药 剂 ")
	desc = string.gsub(desc,"elixir of avoidance"," 闪 避 药 剂 ")
	desc = string.gsub(desc,"elixir of precision"," 精 准 药 剂 ")
	desc = string.gsub(desc,"elixir of mysticism"," 神 秘 药 剂 ")
	desc = string.gsub(desc,"elixir of the savior"," 守 护 药 剂 ")
	desc = string.gsub(desc,"elixir of mastery"," 掌 握 药 剂 ")
	desc = string.gsub(desc,"elixir of explosive force"," 爆 炸 药 剂 ")
	desc = string.gsub(desc,"elixir of serendipity"," 幸 运 药 剂 ")
	desc = string.gsub(desc,"elixir of focus"," 专 注 药 剂 ")
	desc = string.gsub(desc,"elixir of brawn"," 蛮 牛 药 剂 ")
	desc = string.gsub(desc,"elixir of stoneskin"," 石 肤 药 剂 ")
	desc = string.gsub(desc,"elixir of foundations"," 领 悟 药 剂 ")
	desc = string.gsub(desc,"Stire of Derth"," 德 斯 镇 的 斯 泰 尔 ")
	desc = string.gsub(desc,"Marus of Elvala"," 埃 尔 瓦 拉 的 马 鲁 斯 ")
	desc = string.gsub(desc,"Agrimley the hermit"," 隐 居 者 亚 格 雷 姆 利 ")
	desc = string.gsub(desc,"Ungrol of Last Hope"," 最 后 的 希 望 的 温 格 洛 ")
	desc = changeElixir(desc)
	return desc
end}

questCHN["The Doom of the World!"] = {
name = " 世 界 末 日！ ",
description = function(desc)
	desc = string.gsub(desc,"You were sent to the Charred Scar at the heart of which lies a huge volcano. In the Age of Pyre it destroyed the old Sher'Tul ruins that stood there, absorbing much of their latent magic."," 你 被 送 到 了 灼 烧 之 痕， 其 中 部 是 一 个 巨 大 的 火 山， 在 派 尔 纪 元 这 里 曾 是 夏 · 图 尔 遗 址 的 所 在， 吸 收 了 大 量 潜 藏 的 魔 法。 ")
	desc = string.gsub(desc,"This place is still full of that power and the orcs intend to absorb this power using the Staff of Absorption!"," 这 里 仍 然 充 满 了 那 种 能 量， 兽 人 打 算 用 吸 能 法 杖 的 力 量 来 吸 收 这 里 的 能 量。 ")
	desc = string.gsub(desc,"Whatever their plan may be, they must be stopped at all cost."," 不 管 他 们 的 目 的 是 要 干 什 么， 必 须 不 惜 一 切 代 价 阻 止 他 们。 ")
	desc = string.gsub(desc,"The volcano is attacked by orcs. A few Sun Paladins made it there with you. They will hold the line at the cost of their lives to buy you some time."," 火 山 受 到 了 兽 人 的 攻 击， 一 些 太 阳 骑 士 正 顶 在 最 前 线 用 他 们 的 生 命 来 帮 助 你 争 取 一 些 时 间。 ")
	desc = string.gsub(desc,"Honor their sacrifice; do not let the orcs finish their work!"," 向 他 们 的 献 身 精 神 致 敬！ 不 要 让 兽 人 们 达 成 所 愿。 ")
	desc = string.gsub(desc,"You arrived too late. The place has been drained of its power and the sorcerers have left."," 你 来 的 太 晚 了， 这 里 的 能 量 已 经 被 吸 干， 而 那 些 法 师 已 经 离 开 了。 ")
	desc = string.gsub(desc,"Use the portal to go back to the Far East. You *MUST* stop them, no matter the cost."," 使 用 传 送 门 到 达 远 东 大 陆， 你 必 须 阻 止 他 们， 不 惜 一 切 代 价！ ")
	desc = string.gsub(desc,"You arrived in time and interrupted the ritual. The sorcerers have departed."," 你 终 于 及 时 赶 来 阻 止 了 仪 式， 法 师 们 被 驱 散 了。 ")
	return desc
end}

questCHN["From bellow, it devours"] = {
name = " 地 下 吞 噬 者 ",
description = function(desc)
	desc = string.gsub(desc,"Your escape from Reknor got your heart pounding and your desire for wealth and power increased tenfold."," 你 从 瑞 库 纳 逃 了 出 来， 你 觉 得 你 的 心 脏 狂 跳 不 止， 你 对 财 富 和 力 量 的 渴 望 增 加 了 十 倍 ～ ")
	desc = string.gsub(desc,"Maybe it is time for you to start an adventurer's career. Deep below the Iron Throne mountains lies the Deep Bellow."," 也 许 是 你 开 始 冒 险 生 涯 的 时 候 了， 在 钢 铁 王 座 山 脉 的 深 处 有 个 无 尽 深 渊 地 下 城。 ")
	desc = string.gsub(desc,"It has been long sealed away but still, from time to time adventurers go there looking for wealth."," 那 里 已 被 尘 封 已 久， 但 是 还 是 不 断 有 冒 险 者 前 去 寻 找 财 宝。 ")
	desc = string.gsub(desc,"None that you know of has come back yet, but you did survive Reknor. You are great."," 据 你 所 知 没 有 一 个 人 能 活 着 回 来， 不 过 你 从 瑞 库 纳 幸 存 了 下 来， 你 比 较 牛 X。 ")
	return desc
end}

questCHN["The Island of Dread"] = {
name = " 恐 怖 之 岛 ",
description = function(desc)
	desc = string.gsub(desc,"You have heard that near the Charred Scar, to the south, lies a ruined tower known as the Dreadfell."," 你 听 说 在 灼 烧 之 痕 南 部 有 一 个 叫 做 恐 惧 王 座 的 荒 塔 废 墟。 ")
	desc = string.gsub(desc,"There are disturbing rumors of greater undead, and nobody who reached it ever returned."," 传 说 那 里 有 强 大 的 亡 灵 生 物， 凡 是 到 达 那 里 的 人 都 有 去 无 回。 ")
	desc = string.gsub(desc,"Perhaps you should explore it and find the truth, and the treasures, for yourself!"," 也 许 你 应 该 去 那 里 一 探 究 竟， 顺 便 可 以 找 到 埋 藏 在 那 里 的 财 宝。 ")
	return desc
end}

questCHN["Back and there again"] = {
name = " 穿 越 过 去 ",
description = function(desc)
	desc = string.gsub(desc,"You have created a portal back to Maj'Eyal. You should try to talk to someone in Last Hope about establishing a link back."," 你 创 造 了 一 个 回 到 马 基 埃 亚 尔 的 传 送 门， 你 应 该 试 试 找 最 后 的 希 望 的 某 个 人 谈 谈 关 于 这 件 事。 ")
	desc = string.gsub(desc,"You talked to the Elder in Last Hope who in turn told you to talk to Tannen, who lives in the north of the city."," 你 和 最 后 的 希 望 的 长 者 交 谈， 得 知 要 去 找 城 市 北 边 的 泰 恩 ")
	desc = string.gsub(desc,"You gave the Orb of Many Ways to Tannen to study while you look for the athame and diamond in Reknor."," 你 把 多 元 水 晶 球 交 给 了 泰 恩 进 一 步 研 究， 然 后 去 瑞 库 纳 继 续 寻 找 血 符 祭 剑 和 共 鸣 宝 石 。 ")
	desc = string.gsub(desc,"You kept the Orb of Many Ways despite Tannen's request to study it. You must now look for the athame and diamond in Reknor."," 虽 然 泰 恩 要 求 拿 来 研 究 但 是 你 还 是 把 多 元 水 晶 球 保 留 了 下 来， 下 一 步 你 必 须 去 瑞 库 纳 寻 找 血 符 祭 剑 和 共 鸣 宝 石 了。 ")
	desc = string.gsub(desc,"You brought back the diamond and athame to Tannen who asked you to check the tower of Telmur, looking for a text of portals, although he is not sure it is even there. He told you to come back in a few days."," 你 把 血 符 祭 剑 和 共 鸣 宝 石 带 回 给 泰 恩， 他 告 诉 你 去 泰 尔 玛 之 塔 看 看， 寻 找 那 里 的 传 送 密 文， 他 告 诉 几 天 之 后 再 回 去 找 他。 ")
	desc = string.gsub(desc,"You brought back the diamond and athame to Tannen who asked you to contact Zemekkys to ask some delicate questions."," 你 把 血 符 祭 剑 和 共 鸣 宝 石 带 回 给 Tannen， 他 告 诉 你 去 找 伊 莫 克 斯 问 一 些 细 节 问 题。 ")
	desc = string.gsub(desc,"You brought back the diamond and athame to Tannen who asked you to come back in a few days."," 你 把 血 符 祭 剑 和 共 鸣 宝 石 带 回 给 泰 恩 ， 他 告 诉 你 过 几 天 再 去 找 他。 ")
	desc = string.gsub(desc,"Tannen has tricked you! He swapped the orb for a false one that brought you to a demonic plane. Find the exit, and get revenge!"," 泰 恩 把 你 耍 了！ 他 换 了 个 错 的 水 晶 球 给 你， 把 你 传 送 到 了 恶 魔 的 空 间 ， 找 到 出 口 回 去 找 他 算 账！ ")
	desc = string.gsub(desc,"Tannen revealed himself as the vile scum he really is and trapped you in his tower."," 泰 恩 暴 露 出 了 他 的 确 是 个 卑 鄙 的 人 渣， 他 把 你 囚 禁 在 他 的 塔 牢 里。 ")
	desc = string.gsub(desc,"The portal to the Far East is now functional and can be used to go back."," 前 往 远 东 大 陆 的 传 送 门 现 在 可 以 使 用 了， 并 可 以 通 过 它 返 回。 ")
	return desc
end}

questCHN["And now for a grave"] = {
name = " 绝 望 的 坟 墓 ",
description = function(desc)
	desc = string.gsub(desc,"Ungrol of Last Hope asked you to look for his wife's friend Celia, who has been reported missing. She frequently visits her late husband's mausoleum, in the graveyard near Last Hope."," 最 后 的 希 望 的 温 格 洛 要 帮 忙 找 她 妻 子 失 踪 的 朋 友 希 利 娅， 她 经 常 去 他 亡 夫 的 陵 墓 那 里， 在 最 后 的 希 望 附 近 的 墓 地 里。 ")
	desc = string.gsub(desc,"You searched for Celia in the graveyard near Last Hope, and found a note. In it, Celia reveals that she has been conducting experiments in the dark arts, in an attempt to extend her life... also, she is pregnant."," 你 在 最 后 的 希 望 附 近 的 目 的 搜 寻 希 利 娅 的 踪 迹， 找 到 一 个 纸 条。 从 纸 条 中 写 的 内 容 你 得 知， 希 利 娅 正 在 进 行 一 些 黑 暗 魔 法 仪 式， 试 图 延 长 她 的 寿 命， 另 外。。。 她 还 有 孕 在 身！ ")
	desc = string.gsub(desc,"You have tracked Celia to her husband's mausoleum in the graveyard near Last Hope. It seems she has taken some liberties with the corpses there."," 你 跟 踪 希 利 娅 到 了 她 亡 夫 在 最 后 的 希 望 附 近 墓 地 的 陵 墓 里， 似 乎 她 在 那 里 复 活 了 一 些 尸 体。 ")
	desc = string.gsub(desc,"You have laid Celia to rest, putting an end to her gruesome experiments."," 你 埋 葬 了 希 利 娅， 终 结 了 她 阴 森 恐 怖 的 实 验。 ")
	desc = string.gsub(desc,"You have laid Celia to rest, putting an end to her failed experiments. You have taken her heart, for your own experiments. You do not plan to fail as she did."," 你 埋 葬 了 希 利 娅， 终 结 了 她 失 败 的 实 验， 你 拿 走 了 她 的 心 脏 为 自 己 的 实 验 做 准 备， 你 相 信 你 不 会 重 蹈 她 的 覆 辙。 ")
	return desc
end}

questCHN["Falling Toward Apotheosis"] = {
name = " 拜 倒 在 神 的 脚 下 ",
description = function(desc)
	desc = string.gsub(desc,"You have vanquished the masters of the Orc Pride. Now you must venture inside the most dangerous place of this world: the High Peak."," 你 征 服 了 兽 人 军 团 的 最 高 领 袖， 现 在 你 必 须 向 这 个 世 界 最 危 险 的 地 方 挺 进： 巅 峰。 ")
	desc = string.gsub(desc,"Seek the Sorcerers and stop them before they bend the world to their will."," 找 到 那 些 妄 图 扭 曲 这 个 世 界 的 法 师 并 阻 止 他 们。 ")
	desc = string.gsub(desc,"To enter, you will need the four orbs of command to remove the shield over the peak."," 想 要 进 去 的 话， 你 必 须 找 到 那 四 个 指 令 水 晶 来 移 除 塔 顶 的 防 护 罩。 ")
	desc = string.gsub(desc,"The entrance to the peak passes through a place called 'the slime tunnels', probably located inside or near Grushnak Pride."," 通 往 塔 顶 的 路 需 要 穿 过 一 个 地 方， 叫 做 “ 史 莱 姆 通 道 ”， 就 在 格 鲁 希 纳 克 部 落 里 面 或 者 附 近。 ")
	desc = string.gsub(desc,"You have reached the summit of the High Peak, entered the sanctum of the Sorcerers and destroyed them, freeing the world from the threat of evil."," 你 到 达 了 巅 峰 的 最 高 处， 进 入 法 师 们 的 圣 所 并 摧 毁 他 们， 把 这 个 世 界 从 恶 魔 的 威 胁 之 中 解 放 出 来 吧。 ")
	desc = string.gsub(desc,"You have won the game!"," 你 通 关 了！ ")
	desc = string.gsub(desc,"You encountered Sun Paladin Aeryn who blamed you for the loss of the Sunwall. You were forced to kill her."," 你 遭 遇 了 太 阳 骑 士 艾 伦， 他 把 太 阳 堡 垒 的 陷 落 责 任 全 部 推 卸 于 你 的 头 上， 你 不 得 不 杀 了 他。 ")
	desc = string.gsub(desc,"You encountered Sun Paladin Aeryn who blamed you for the loss of the Sunwall, but you spared her."," 你 遭 遇 了 太 阳 骑 士 艾 伦， 他 把 太 阳 堡 垒 的 陷 落 责 任 全 部 推 卸 于 你 的 头 上， 但 是 你 饶 恕 了 他。 ")
	desc = string.gsub(desc,"You defeated the Sorcerers before the Void portal could open."," 你 在 虚 空 传 送 门 打 开 之 前 击 败 了 那 些 法 师。 ")
	desc = string.gsub(desc,"You defeated the Sorcerers and Aeryn sacrificed herself to close the Void portal."," 你 击 败 了 那 些 法 师， 艾 伦 牺 牲 了 她 自 己 关 闭 了 虚 空 传 送 门。 ")
	desc = string.gsub(desc,"You defeated the Sorcerers and sacrificed yourself to close the Void portal."," 你 击 败 了 那 些 法 师， 并 牺 牲 了 自 己 关 闭 虚 空 传 送 门。 ")
	desc = string.gsub(desc,"Well done! You have won the Tales of Maj'Eyal: The Age of Ascendancy"," 干 的 好！ 你 赢 得 了 马 基 埃 亚 尔 的 传 说： 卓 越 时 代 ")
	desc = string.gsub(desc,"The Sorcerers are dead, and the Orc Pride lies in ruins, thanks to your efforts."," 那 些 法 师 死 了， 兽 人 部 落 被 埋 葬 在 废 墟 之 中， 感 谢 你 为 此 付 出 的 努 力。 ")
	desc = string.gsub(desc,"Your sacrifice worked. Your mental energies were imbued with farportal energies. The Way radiated from the High Peak toward the rest of Eyal like a mental tidal wave."," 你 的 牺 牲 起 作 用 了， 你 的 精 神 能 量 被 原 自 传 送 门 的 能 量 所 感 染， 从 巅 峰 通 往 埃 亚 尔 的 辐 射 状 维 网 形 成 了 一 股 精 神 冲 击 波。 ")
	desc = string.gsub(desc,"Every sentient being in Eyal is now part of the Way. Peace and happiness are enforced for all."," 所 有 埃 亚 尔 有 感 觉 的 生 物 都 成 为 了 维 网 的 一 部 分， 和 平 和 幸 福 被 传 输 给 大 家。 ")
	desc = string.gsub(desc,"Only the mages of Angolwen were able to withstand the mental shock and thus are the only unsafe people left. But what can they do against the might of the Way%?"," 只 有 安 格 利 文 的 法 师 能 够 抵 制 住 这 道 精 神 冲 击， 从 而 他 们 成 为 了 仅 存 的 危 险 人 类， 不 过 他 们 又 能 对 强 大 的 维 网 怎 么 样 呢？ ")
	desc = string.gsub(desc,"In the aftermath of the battle the Way tried to force you to act as a vessel to bring the Way to every sentient being."," 在 战 斗 结 束 后 ， 维 网 试 图 强 迫 你 用 你 的 身 躯 作 为 通 道 将 维 网 传 输 到 所 有 知 觉 生 物 的 身 体 中 。")
	desc = string.gsub(desc,"Through an incredible display of willpower you resisted long enough to ask Aeryn to kill you."," 然 而 ， 你 强 大 的 意 志 力 让 你 支 撑 下 来 ， 向 艾 伦 发 送 了 信 息 。 ")
	desc = string.gsub(desc,"She sadly agreed and ran her sword through you, enabling you to do the last sacrifice you could for the world."," 她 怀 着 悲 痛 的 心 情 用 长 剑 刺 穿 了 你 的 身 躯 ， 你 终 于 为 这 个 世 界 做 出 了 最 后 的 贡 献 。")
	desc = string.gsub(desc,"You have prevented the portal to the Void from opening and thus stopped the Creator from bringing about the end of the world."," 你 阻 止 了 虚 空 传 送 门 的 开 启， 并 终 止 了 世 界 末 日 的 到 来。 ")
	desc = string.gsub(desc,"In a selfless act, High Sun Paladin Aeryn sacrificed herself to close the portal to the Void and thus stopped the Creator from bringing about the end of the world."," 高 阶 太 阳 骑 士 艾 伦 非 常 无 私 的 牺 牲 了 她 自 己， 阻 止 了 虚 空 传 送 门 的 开 启， 解 救 了 这 个 世 界。 ")
	desc = string.gsub(desc,"In a selfless act, you sacrificed yourself to close the portal to the Void and thus stopped the Creator from bringing about the end of the world."," 你 非 常 无 私 的 牺 牲 了 你 自 己， 阻 止 了 虚 空 传 送 门 的 开 启， 解 救 了 这 个 世 界。 ")
	desc = string.gsub(desc,"The Gates of Morning have been destroyed and the Sunwall has fallen. The last remnants of the free people in the Far East will surely diminish, and soon only orcs will inhabit this land."," 晨 曦 之 门 被 摧 毁 了， 太 阳 堡 垒 陷 落 了。 远 东 大 陆 幸 存 的 人 口 比 以 前 明 显 减 少， 很 快 兽 人 会 占 据 整 个 大 陆。 ")
	desc = string.gsub(desc,"The orc presence in the Far East has greatly been diminished by the loss of their leaders and the destruction of the Sorcerers. The free people of the Sunwall will be able to prosper and thrive on this land."," 失 去 了 恶 魔 法 师 和 兽 人 首 领 的 兽 人 部 落 人 口 急 剧 减 少， 太 阳 堡 垒 的 人 们 得 以 这 片 大 陆 上 继 续 发 展、 繁 荣。 ")
	desc = string.gsub(desc,"Maj'Eyal will once more know peace. Most of its inhabitants will never know they even were on the verge of destruction, but then this is what being a true hero means: to do the right thing even though nobody will know about it."," 马 基 埃 亚 尔 再 一 次 回 复 了 和 平 和 宁 静， 大 多 数 居 民 也 许 并 不 知 道 他 们 到 了 差 点 毁 灭 的 边 缘， 不 过 这 正 是 称 之 为 一 个 真 正 的 英 雄： 就 算 不 会 被 人 所 知 也 要 去 维 护 正 义。 ")
	desc = string.gsub(desc,"You may continue playing and enjoy the rest of the world."," 你 可 以 继 续 在 这 个 世 界 上 探 险。 ")
	return desc
end}

questCHN["The Infinite Dungeon"] = {
name = " 无 尽 地 下 城 ",
description = function(desc)
	desc = string.gsub(desc,"You have entered the Infinite Dungeon. There is no going back now."," 你 进 入 了 无 限 地 下 城。 你 已 不 能 再 走 回 头 路 了。 ")
	desc = string.gsub(desc,"Go deep, fight, win or die in a blaze of glory!"," 深 入 地 下 城 去 战 斗 吧， 胜 利 或 者 为 荣 耀 而 死！ ")
	return desc
end}

questCHN["The Sect of Kryl-Feijan"] = {
name = " 卡 洛 · 斐 济 教 派 ",
description = function(desc)
	desc = string.gsub(desc,"You discovered a sect worshipping a demon named Kryl%-Feijan in a crypt."," 你 在 一 个 地 城 内 发 现 了 一 个 膜 拜 恶 魔 的 教 派， 卡 洛 · 斐 济 教 派 ")
	desc = string.gsub(desc,"They were trying to bring it back into the world using a human sacrifice."," 他 们 试 图 用 献 祭 活 人 来 召 唤 恶 魔 到 这 个 世 界 上。 ")
	desc = string.gsub(desc,"You defeated the acolytes and saved the woman. She told you she is the daughter of a rich merchant of Last Hope."," 你 打 败 了 那 些 寺 僧 并 救 了 这 个 女 人 的 命。 她 告 诉 你 她 是 最 后 的 希 望 一 个 富 商 的 女 儿。 ")
	desc = string.gsub(desc,"You failed to protect her when escorting her out of the crypt."," 你 没 有 能 成 功 地 将 她 护 送 出 这 个 地 城。 ")
	desc = string.gsub(desc,"You failed to defeat the acolytes in time %- the woman got torn apart by the demon growing inside her."," 你 没 能 及 时 杀 死 那 些 寺 僧， 那 个 女 人 被 从 她 体 内 召 唤 出 的 恶 魔 撕 成 了 碎 片。 ")
	return desc
end}

questCHN["Keepsake"] = {
name = " 往 昔 信 物 ",
description = function(desc)
	desc = string.gsub(desc,"You have begun to look for a way to overcome the curse that afflicts you."," 你 开 始 寻 求 方 法 以 驱 除 一 直 困 扰 着 你 的 诅 咒。 ")
	desc = string.gsub(desc,"You have found a small iron acorn which you keep as a reminder of your past"," 你 找 到 了 一 个 小 小 的 铁 质 橡 果， 似 乎 可 以 让 你 回 想 起 以 前 的 往 事。 ")
	desc = string.gsub(desc,"You have destroyed the merchant caravan that you once considered family."," 你 摧 毁 了 那 个 你 曾 经 视 作 家 人 的 商 队。 ")
	desc = string.gsub(desc,"Kyless, the one who brought the curse, is dead by your hand."," 克 里 斯， 那 个 曾 经 为 你 带 来 诅 咒 的 人， 死 在 了 你 的 手 上。 ")
	desc = string.gsub(desc,"Berethh is dead, may he rest in peace."," 贝 里 斯 已 死， 但 愿 他 能 安 息。 ")
	desc = string.gsub(desc,"Your curse has changed the iron acorn which now serves as a cruel reminder of your past and present."," 你 的 诅 咒 使 铁 橡 果 成 为 了 使 你 回 忆 起 残 酷 过 去 和 现 实 的 信 物。 ")
	desc = string.gsub(desc,"Your curse has defiled the iron acorn which now serves as a reminder of your vile nature."," 你 的 诅 咒 污 浊 了 铁 橡 果， 它 成 为 了 使 你 回 想 起 你 卑 劣 本 性 的 信 物。 ")
	desc = string.gsub(desc,"You need to find Berethh, the last person who may be able to help you."," 你 得 找 到 贝 里 斯， 也 许 他 是 最 后 一 个 可 以 帮 助 你 的 人。 ")
	desc = string.gsub(desc,"Seek out Kyless' cave in the northern part of the meadow and end him. Perhaps the curse will end with him."," 找 出 位 于 草 原 北 部 的 克 里 斯 的 洞 穴， 然 后 杀 掉 他， 他 的 死 也 许 会 解 除 这 个 诅 咒。 ")
	desc = string.gsub(desc,"Discover the meaning of the acorn and the dream."," 搞 清 楚 铁 橡 果 与 这 个 梦 境 的 含 义。 ")
	desc = string.gsub(desc,"You may have to revist your past to unlock some secret buried there."," 你 可 以 回 忆 一 下 过 去 来 解 开 埋 藏 在 这 里 的 秘 密。 ")
	return desc
end}

questCHN["From Death, Life"] = {
name = " 起 死 回 生 ",
description = function(desc)
	desc = string.gsub(desc,"The affairs of this mortal world are trifling compared to your true goal: To conquer death."," 凡 人 世 界 的 那 些 琐 事 对 于 你 的 终 极 目 标： 超 越 死 亡 来 说 是 微 不 足 道 的。 ")
	desc = string.gsub(desc,"Your studies have uncovered much surrounding this subject, but now you must prepare for your glorious rebirth."," 你 关 于 这 个 主 题 的 研 究 已 经 令 你 发 现 了 很 多 东 西， 现 在， 你 必 须 准 备 你 辉 煌 的 重 生 仪 式。 ")
	desc = string.gsub(desc,"You will need:"," 你 需 要： ")
	desc = string.gsub(desc,"You are experienced enough."," 你 有 足 够 的 经 验。 ")
	desc = string.gsub(desc,"The ceremony will require that you are worthy, experienced, and possessed of a certain amount of power"," 仪 式 需 要 你 有 足 够 的 财 富、 经 验 并 拥 有 足 够 的 力 量。 ")
	desc = string.gsub(desc,"You have 'extracted' the heart of one of your fellow necromancers."," 你 已 经 取 得 了 你 死 灵 法 师 同 类 的 心 脏。 ")
	desc = string.gsub(desc,"The beating heart of a powerful necromancer."," 一 个 死 灵 法 师 跳 动 的 心 脏。 ")
	desc = string.gsub(desc,"Yiilkgur the Sher'tul Fortress is a suitable location."," 夏 · 图 尔 堡 垒 伊 克 格 是 个 合 适 的 地 方。 ")
	desc = string.gsub(desc,"Yiilkgur has enough energy."," 伊 克 格 有 足 够 的 能 量。 ")
	desc = string.gsub(desc,"You are now on the path of lichdom."," 你 已 经 做 好 了 成 为 巫 妖 的 准 备。 ")
	desc = string.gsub(desc,"Use the control orb of Yiilkgur to begin the ceremony."," 使 用 伊 克 格 的 控 制 水 晶 来 开 启 仪 式。 ")
	desc = string.gsub(desc,"Your lair must amass enough energy to use in your rebirth (40 energy)."," 你 的 堡 垒 中 必 须 积 累 足 够 的 能 量 才 能 开 启 重 生 仪 式。（ 40 能 量） ")
	desc = string.gsub(desc,"The ceremony will require a suitable location, secluded and given to the channelling of energy"," 仪 式 必 须 在 一 个 合 适 的 地 方 进 行， 要 足 够 隐 蔽 但 是 又 能 传 输 能 量。 ")
	return desc
end}

questCHN["Storming the city"] = {
name = " 雷 鸣 之 城 ",
description = function(desc)
	desc = string.gsub(desc,"As you approached Derth you saw a huge dark cloud over the small town."," 当 你 接 近 德 斯 村 时 你 看 到 一 个 巨 大 的 黑 色 乌 云 笼 罩 在 小 镇 上 方。 ")
	desc = string.gsub(desc,"When you entered you were greeted by an army of air elementals slaughtering the population."," 当 你 进 入 村 庄 时， 你 看 到 的 景 象： 一 群 空 气 元 素 正 在 屠 杀 村 民。 ")
	desc = string.gsub(desc,"You have dispatched the elementals but the cloud lingers still. You must find a powerful ally to remove it. There are rumours of a secret town in the mountains, to the southwest. You could also check out the Ziguranth group that is supposed to fight magic."," 你 已 经 驱 散 了 元 素 生 物， 但 是 天 上 乌 云 并 未 就 此 散 去。 \n 西 南 方 的 山 脉 之 中 有 一 个 传 说 中 的 小 镇， 你 也 能 顺 便 调 查 一 下 伊 格 兰 斯 这 个 反 魔 法 军 团。 ")
	desc = string.gsub(desc,"You have learned the real threat comes from a rogue Archmage, a Tempest named Urkis. The mages of Angolwen are ready to teleport you there."," 你 得 知 真 正 的 威 胁 来 自 于 一 个 堕 落 元 素 法 师， 名 字 叫 乌 尔 切 斯， 精 通 风 暴 法 术， 安 格 利 文 的 法 师 已 经 准 备 好 把 你 传 送 到 那 里 去 了。 ")
	desc = string.gsub(desc,"You have learned the real threat comes from a rogue Archmage, a Tempest. You have been shown a secret entrance to his stronghold."," 你 得 知 真 正 的 威 胁 来 自 于 一 个 堕 落 元 素 法 师， 你 已 经 找 到 前 往 他 要 塞 的 秘 密 通 道。 ")
	return desc
end}

questCHN["Trapped!"] = {
name = " 陷 阱！ ",
description = function(desc)
	desc = string.gsub(desc,"You heard a plea for help and decided to investigate..."," 你 听 到 了 求 救 声， 决 定 去 调 查 一 下 … … ")
	desc = string.gsub(desc,"Only to find yourself trapped inside an unknown tunnel complex."," 结 果 落 到 了 一 个 未 知 的 复 杂 通 道 的 陷 阱 里。 ")
	return desc
end}

questCHN["Melinda, lucky girl"] = {
name = " 幸 运 女 孩 梅 琳 达 ",
description = function(desc)
	desc = string.gsub(desc,"After rescuing Melinda from Kryl%-Feijan and the cultists you met her again in Last Hope."," 在 你 从 卡 洛 · 斐 济 邪 教 手 中 解 救 了 梅 琳 达 之 后， 你 在 最 后 的 希 望 又 碰 到 了 她。 ")
	desc = string.gsub(desc,"Melinda was saved from the brink of death at the beach, by a strange wave of blight."," 在 海 滩 上 ， 梅 琳 达 被 一 股 奇 怪 的 枯 萎 能 量 拯 救 。 ")
	desc = string.gsub(desc,"The Fortress Shadow said she could be cured."," 堡 垒 之 影 说 她 会 得 到 治 疗。 ")
	desc = string.gsub(desc,"Melinda decided to come live with you in your Fortress."," 梅 琳 达 决 定 和 你 一 起 在 堡 垒 里 生 活。 ")
	desc = string.gsub(desc,"The Fortress Shadow has established a portal for her so she can come and go freely."," 堡 垒 之 影 为 她 建 造 了 一 个 传 送 门 ， 他 让 她 能 够 自 由 来 去 。 ")
	return desc
end}

questCHN["The beast within"] = {
name = " 林 中 的 野 兽 ",
description = function(desc)
	desc = string.gsub(desc,"You met a half%-mad lumberjack fleeing a small village, rambling about an untold horror lurking there, slaughtering people."," 你 遇 到 了 一 个 吓 得 魂 飞 魄 散 的 伐 木 工 人 从 一 个 小 村 庄 里 跑 出 来， 大 声 喊 着 有 个 没 见 过 的 吓 人 的 东 西 在 里 面 杀 人。 ")
	desc = string.gsub(desc," lumberjacks have died."," 个 伐 木 工 人 死 了。 ")
	return desc
end}

questCHN["An apprentice task"] = {
name = " 学 徒 的 任 务 ",
description = function(desc)
	desc = string.gsub(desc,"You met a novice mage who was tasked to collect an arcane powered artifact."," 你 碰 到 了 一 个 法 师 学 徒， 他 被 指 派 去 搜 集 一 件 充 满 奥 术 力 量 的 神 器。 ")
	desc = string.gsub(desc,"He asked for your help, should you collect some that you do not need."," 他 请 求 你 的 帮 助， 你 能 帮 他 搜 集 一 点 么。 ")
	desc = string.gsub(desc,"Collect an artifact arcane powered item."," 搜 集 一 件 充 满 奥 术 力 量 的 神 器。 ")
	return desc
end}

questCHN["Lost Knowledge"] = {
name = " 遗 失 的 知 识 ",
description = function(desc)
	desc = string.gsub(desc,"You found an ancient tome about gems."," 你 发 现 一 本 关 于 珠 宝 的 旧 书。 ")
	desc = string.gsub(desc,"You should bring it to the jeweler in the Gates of Morning."," 你 应 该 把 这 本 书 带 给 晨 曦 之 门 的 珠 宝 匠 看 看。 ")
	desc = string.gsub(desc,"Limmir told you to look for the Valley of the Moon in the southern mountains.","利 米 尔 告 诉 你 去 到 南 部 的 山 脉 中 寻 找 新 月 峡 谷 ")
	return desc
end}

questCHN["The Orbs of Command"] = {
name = " 指 令 水 晶 ",
description = function(desc)
	desc = string.gsub(desc,"You have found an orb of command that seems to be used to open the shield protecting the High Peak."," 你 找 到 了 一 个 指 令 水 晶 球， 似 乎 是 用 来 开 启 巅 峰 护 盾 的 钥 匙。 ")
	desc = string.gsub(desc,"There seems to be a total of four of them. The more you have the weaker the shield will be."," 似 乎 一 共 有 四 个 水 晶 球， 你 得 到 的 越 多， 护 盾 的 防 御 力 越 弱。 ")
	return desc
end}

questCHN["Let's hunt some Orc"] = {
name = " 狩 猎 兽 人 ",
description = function(desc)
	desc = string.gsub(desc,"The elder in Last Hope sent you to the old Dwarven kingdom of Reknor, deep under the Iron Throne, to investigate the orc presence."," 最 后 的 希 望 的 长 者 将 你 传 送 到 瑞 库 纳 的 古 代 矮 人 国 王 那 里， 在 钢 铁 王 座 的 深 处， 去 调 查 兽 人 的 行 踪。 ")
	desc = string.gsub(desc,"Find out if they are in any way linked to the lost staff."," 查 清 楚 他 们 是 不 是 和 遗 失 的 法 杖 有 关。 ")
	desc = string.gsub(desc,"But be careful %-%- even the Dwarves have not ventured in these old halls for many years."," 小 心， 矮 人 们 已 经 很 多 年 没 有 进 过 那 些 古 老 的 大 厅 了。 ")
	return desc
end}

questCHN["The many Prides of the Orcs"] = {
name = " 兽 人 部 落 ",
description = function(desc)
	 desc = string.gsub(desc,"Investigate the bastions of the Pride."," 调 查 兽 人 部 落 的 基 地。 ")
	desc = string.gsub(desc,"You have destroyed Rak'shor."," 你 已 经 摧 毁 了 拉 克 · 肖 部 落。 ")
	desc = string.gsub(desc,"Rak'shor Pride, in the west of the southern desert."," 拉 克 · 肖 部 落 在 南 部 的 沙 漠 里。 ")
	desc = string.gsub(desc,"You have killed the master of Eastport."," 你 已 经 杀 死 了 东 部 港 口 的 首 领。 ")
	desc = string.gsub(desc,"A group of corrupted Humans live in Eastport on the southern coastline. They have contact with the Pride."," 一 队 堕 落 人 族 驻 扎 在 南 部 海 岸 线 的 东 部 港 口， 他 们 和 部 落 有 关 联。 ")
	desc = string.gsub(desc,"You have destroyed Vor."," 你 击 败 了 沃 尔 部 落。 ")
	desc = string.gsub(desc,"Vor Pride, in the north east."," 沃 尔 部 落 在 东 北 部。 ")
	desc = string.gsub(desc,"You have destroyed Grushnak."," 你 击 败 了 格 鲁 希 纳 克 部 落。 ")
	desc = string.gsub(desc,"Grushnak Pride, near a small mountain range in the north west."," 格 鲁 希 纳 克 部 落 在 西 北 部 一 个 小 山 脉 附 近。 ")
	desc = string.gsub(desc,"You have destroyed Gorbat."," 你 击 败 了 加 伯 特 部 落。 ")
	desc = string.gsub(desc,"Gorbat Pride, in a mountain range in the southern desert."," 加 伯 特 部 落， 在 南 部 沙 漠 的 一 个 山 脉 中。 ")
	desc = string.gsub(desc,"All the bastions of the Pride lie in ruins, their masters destroyed. High Sun Paladin Aeryn would surely be glad of the news!"," 所 有 的 部 落 基 地 被 摧 毁， 他 们 的 首 领 被 杀 死 了， 高 阶 太 阳 骑 士 艾 伦 应 该 对 这 个 消 息 感 到 很 高 兴！ ")
	return desc
end}

questCHN["The Way We Weren't"] = {
name = " 穿 越 时 空 ",
description = function(desc)
	desc = string.gsub(desc,"You have met what seems to be a future version of yourself."," 你 看 到 了 一 个 未 来 的 自 己。 ")
	desc = string.gsub(desc,"You tried to kill yourself to prevent you from doing something, or going somewhere... you were not very clear."," 你 尝 试 杀 掉 自 己， 以 免 他 做 什 么 你 不 知 道 的 事 或 者 到 某 个 你 也 不 清 楚 的 地 方。 ")
	desc = string.gsub(desc,"You were killed by your future self, and thus this event never occured."," 你 被 未 来 的 自 己 杀 掉 了， 从 此 这 种 事 就 再 没 有 发 生 过。 ")
	desc = string.gsub(desc,"You killed your future self. In the future, you might wish to avoid time%-traveling back to this moment..."," 你 杀 死 了 未 来 的 自 己， 在 未 来， 你 可 不 希 望 再 穿 越 时 空 到 这 个 时 间 点 ...")
	return desc
end}

questCHN["Important news"] = {
name = " 重 要 的 消 息 ",
description = function(desc)
	desc = string.gsub(desc,"Orcs were spotted with the staff you seek in an arid waste in the southern desert."," 在 南 部 沙 漠 的 一 个 干 旱 的 荒 地 里， 你 发 现 了 兽 人 和 法 杖 的 踪 迹。 ")
	desc = string.gsub(desc,"You should go investigate what is happening there."," 你 得 去 调 查 一 下 那 里 发 生 了 什 么 事。 ")
	return desc
end}

questCHN["Light at the end of the tunnel"] = {
name = " 隧 道 尽 头 的 亮 光 ",
description = function(desc)
	desc = string.gsub(desc,"You must find a way to Maj'Eyal through the tunnel to the north of the island."," 你 必 须 在 小 岛 北 部 找 到 一 条 穿 过 这 个 通 道 到 达 马 基 埃 亚 尔 的 路。 ")
	return desc
end}

questCHN["Till the Blood Runs Clear"] = {
name = " 鲜 血 之 环 ",
description = function(desc)
	desc = string.gsub(desc,"You have found a slavers' compound and entered it."," 你 发 现 了 一 个 奴 隶 收 容 所 并 走 了 进 去。 ")
	desc = string.gsub(desc,"You decided to join the slavers and take part in their game. You won the ring of blood!"," 你 决 定 加 入 那 些 奴 隶 间 的 游 戏， 你 赢 得 了 鲜 血 之 环 的 胜 利！ ")
	desc = string.gsub(desc,"You decided you cannot let slavers continue their dirty work and destroyed them!"," 你 觉 得 不 能 让 那 些 奴 隶 继 续 做 他 们 肮 脏 工 作 并 把 他 们 都 做 掉 了！ ")
	return desc
end}

questCHN["Sher'Tul Fortress"] = {
name = " 夏 · 图 尔 堡 垒 ",
description = function(desc)
	desc = string.gsub(desc,"You found notes from an explorer inside the Old Forest. He spoke about Sher'Tul ruins sunken below the surface of the lake of Nur, at the forest's center."," 在 古 老 森 林 里 找 到 了 一 个 探 险 者 的 笔 记， 里 面 提 到 在 森 林 中 心 的 纳 尔 湖 底 下 有 一 个 沉 没 的 夏 · 图 尔 遗 迹。 ")
	desc = string.gsub(desc,"With one of the notes there was a small gem that looks like a key."," 和 笔 记 在 一 起 被 发 现 的 还 有 个 小 小 的 宝 石， 样 子 看 上 去 像 一 把 钥 匙。 ")
	desc = string.gsub(desc,"You used the key inside the ruins of Nur and found a way into the fortress of old."," 你 使 用 这 把 钥 匙 进 入 了 古 老 森 林 中 的 纳 尔 废 墟。 ")
	desc = string.gsub(desc,"The Weirdling Beast is dead, freeing the way into the fortress itself."," 怪 兽 被 杀 掉 了， 进 入 森 林 的 障 碍 被 扫 除。 ")
	desc = string.gsub(desc,"You have activated what seems to be a ... butler%? with your rod of recall."," 你 用 你 的 召 回 之 杖 激 活 了 一 个 男。。。 管 家？ ")
	desc = string.gsub(desc,"You have upgraded your rod of recall to transport you to the fortress."," 你 升 级 了 你 的 召 回 之 杖， 可 以 使 你 传 送 到 这 片 森 林。 ")
	desc = string.gsub(desc,"You have unlocked the training room."," 你 解 锁 了 训 练 室 。")
	desc = string.gsub(desc,"The fortress shadow has asked that you come back as soon as possible."," 现 在 你 可 以 随 时 随 地 回 到 这 里 了。 ")
	desc = string.gsub(desc,"You have forced a recall while into an exploratory farportal zone, the farportal was rendered unusable in the process."," 你 在 远 古 传 送 门 的 空 间 中 使 用 了 召 回 之 杖 ， 传 送 门 被 损 坏 了 。 ")
	desc = string.gsub(desc,"You have entered the exploratory farportal room and defeated the horror lurking there. You can now use the farportal."," 你 进 入 了 传 送 区 域 并 清 除 了 那 里 的 怪 物， 你 现 在 可 以 使 用 传 送 门 了。 ")
	desc = string.gsub(desc,"You have re%-enabled the fortress flight systems. You can now fly around in your fortress!"," 你 激 活 了 森 林 的 飞 行 系 统， 你 现 在 可 以 在 森 林 里 到 处 飞 行 了！ ")
	desc = string.gsub(desc,"The fortress shadow has asked that you find an Ancient Storm Saphir, along with at least 250 energy, to re%-enable the fortress flight systems."," 你 要 找 到 古 代 风 暴 蓝 宝 石， 还 有 至 少 250 点 能 量 来 激 活 森 林 飞 行 系 统。 ")
	desc = string.gsub(desc,"The fortress's current energy level is:"," 堡 垒 目 前 的 能 量 是： ")
	desc = string.gsub(desc,"You have bound the transmogrification chest to the Fortress power system."," 你 将 转 化 之 盒 绑 定 至 堡 垒 的 能 量 系 统。 ")
	desc = string.gsub(desc,"You have upgraded the transmogrification chest to automatically transmute metallic items into gems before transmogrifying them."," 你 升 级 了 转 化 之 盒， 它 会 在 你 转 化 金 属 物 品 之 前 自 动 将 其 变 成 宝 石。 ")
	return desc
end}

questCHN["Eight legs of wonder"] = {
name = " 八 脚 怪 物 ",
description = function(desc)
	desc = string.gsub(desc,"Enter the caverns of Ardhungol and look for Sun Paladin Rashim."," 进 入 阿 尔 德 胡 格 山 洞 寻 找 太 阳 骑 士 拉 希 姆。 ")
	desc = string.gsub(desc,"But be careful; those are not small spiders..."," 当 心， 那 里 的 蜘 蛛 个 头 可 不 小。。。 ")
	desc = string.gsub(desc,"You have killed Ungolë in Ardhungol and saved the Sun Paladin."," 你 杀 死 了 阿 尔 德 胡 格 里 的 温 格 勒 并 救 了 太 阳 骑 士。 ")
	return desc
end}

questCHN["A mysterious staff"] = {
name = " 奇 怪 的 法 杖 ",
description = function(desc)
	desc = string.gsub(desc,"Deep in the Dreadfell you fought and destroyed the Master, a powerful vampire."," 在 恐 惧 王 座 深 处 你 和 一 个 强 大 的 吸 血 鬼 大 法 师 战 斗 并 杀 死 了 他。 ")
	desc = string.gsub(desc,"On your way out of the Dreadfell you were ambushed by a band of orcs."," 当 你 走 出 恐 惧 王 座 的 时 候 你 受 到 了 一 队 兽 人 小 队 的 偷 袭。 ")
	desc = string.gsub(desc,"They asked about the staff."," 他 们 想 抢 走 法 杖。 ")
	desc = string.gsub(desc,"On your way out of the Dreadfell you were ambushed by a band of orcs and left for dead."," 当 你 走 出 恐 惧 王 座 的 时 候 你 受 到 了 一 队 兽 人 小 队 的 偷 袭， 他 们 把 你 干 掉 了。 ")
	desc = string.gsub(desc,"They asked about the staff and stole it from you."," 他 们 从 你 那 里 把 法 杖 抢 走 了。 ")
	desc = string.gsub(desc,"Go at once to Last Hope to report those events!"," 立 刻 到 最 后 的 希 望 去 报 告 发 生 的 情 况！ ")
	desc = string.gsub(desc,"On your way out of Last Hope you were ambushed by a band of orcs."," 当 你 走 出 最 后 的 希 望 的 时 候 你 中 了 一 群 兽 人 的 埋 伏。 ")
	desc = string.gsub(desc,"They asked about the staff and stole it from you."," 他 们 想 从 你 那 里 抢 走 了 法 杖。 ")
	desc = string.gsub(desc,"You told them nothing and vanquished them."," 你 没 告 诉 他 们 任 何 事 并 把 它 们 都 消 灭 了。 ")
	desc = string.gsub(desc,"Go at once to Last Hope to report those events!"," 立 刻 到 最 后 的 希 望 汇 报 所 发 生 的 情 况。 ")
	desc = string.gsub(desc,"In its remains, you found a strange staff. It radiates power and danger and you dare not use it yourself."," 在 他 的 尸 体 上， 你 发 现 了 一 根 奇 怪 的 法 杖， 它 辐 射 出 的 力 量 和 危 险 使 你 不 敢 使 用 它。 ")
	desc = string.gsub(desc,"You should bring it to the elders of Last Hope in the southeast."," 你 应 该 把 它 带 到 最 后 的 希 望 西 南 部 的 长 者 那 里 给 他 看 看。 ")
	return desc
end}

questCHN["Of trolls and damp caves"] = {
name = " 食 人 魔 巢 穴 ",
description = function(desc)
	desc = string.gsub(desc,"Explore the caves below the ruins of Kor'Pul and the Trollmire in search of treasure and glory!"," 到 卡 · 普 尔 和 食 人 魔 沼 泽 的 地 下 城 去 发 现 宝 藏 和 荣 耀！ ")
	desc = string.gsub(desc,"You have explored the Trollmire and vanquished Prox the Troll."," 你 已 经 探 索 了 食 人 魔 巢 穴 并 击 败 了 食 人 魔 普 洛 克 斯。 ")
	desc = string.gsub(desc,"You have explored the Trollmire and vanquished Shax the Troll."," 你 已 经 探 索 了 食 人 魔 巢 穴 并 击 败 了 食 人 魔 夏 克 斯。 ")
	desc = string.gsub(desc,"You must explore the Trollmire and find out what lurks there and what treasures are to be gained!"," 你 必 须 进 入 食 人 魔 沼 泽 去 调 查 那 里 潜 伏 着 什 么 怪 物 并 找 到 那 里 的 宝 藏！ ")
	desc = string.gsub(desc,"You have explored the ruins of Kor'Pul and vanquished the Shade."," 你 探 索 了 卡 · 普 尔 废 墟 并 击 败 了 暗 影 骷 髅。 ")
	desc = string.gsub(desc,"You have explored the ruins of Kor'Pul and vanquished the Possessed."," 你 探 索 了 卡 · 普 尔 废 墟 并 击 败 了 强 盗 头 目。 ")
	desc = string.gsub(desc,"You must explore the ruins of Kor'Pul and find out what lurks there and what treasures are to be gained!"," 你 必 须 进 入 卡 · 普 尔 去 调 查 那 里 潜 伏 着 什 么 怪 物 并 找 到 那 里 的 宝 藏！ ")
	return desc
end}

questCHN["Spellblaze Fallouts"] = {
name = " 魔 法 大 爆 炸 的 余 波 ",
description = function(desc)
	desc = string.gsub(desc,"The Abashed Expanse is a part of Eyal torn apart by the Spellblaze and thrown into the void between the stars."," 次 元 浮 岛 是 埃 亚 尔 大 陆 的 一 部 分， 在 魔 法 大 爆 炸 中 被 撕 裂 并 轰 击 到 星 辰 之 间 的 虚 无 之 中 .")
	desc = string.gsub(desc,"It has recently begun to destabilize, threatening to crash onto Eyal, destroying everything in its path."," 现 在 变 的 越 来 越 不 稳 定， 有 与 Eyal 大 陆 发 生 碰 撞 的 危 险， 摧 毁 一 切 它 所 碰 到 的 东 西。 ")
	desc = string.gsub(desc,"You have entered it and must now stabilize three wormholes by firing any spell at them."," 你 现 在 必 须 进 入 那 里， 对 三 个 虫 洞 进 行 施 法 以 稳 定 它 们。 ")
	desc = string.gsub(desc,"Remember, the floating islands are not stable and might teleport randomly. However, the disturbances also help you: your Phase Door spell is fully controllable even if not of high level yet."," 记 住， 浮 岛 上 很 不 稳 定， 有 可 能 将 你 随 机 传 送， 不 过 也 有 一 个 好 处， 你 的 传 送 之 门 技 能 会 受 到 完 全 控 制， 就 算 你 的 技 能 等 级 不 够 高 也 没 关 系。 ")
	desc = string.gsub(desc,"You have explored the expanse and closed all three wormholes."," 你 已 经 探 索 了 整 个 浮 岛 并 关 闭 了 所 有 三 个 虫 洞。 ")
	desc = string.gsub(desc,"You have closed"," 你 关 闭 了 ")
	return desc
end}

questCHN["Reknor is lost!"] = {
name = " 在 瑞 克 纳 迷 路 了！ ",
description = function(desc)
	desc = string.gsub(desc,"You were part of a group of dwarves sent to investigate the situation of the kingdom of Reknor."," 你 是 被 指 派 到 瑞 库 纳 国 王 大 厅 去 调 查 情 况 的 一 个 矮 人 小 分 队 的 一 员。 ")
	desc = string.gsub(desc,"When you arrived there you found nothing but orcs, well organized and very powerful."," 当 你 到 达 那 里 时， 你 受 到 了 大 量 有 组 织 的 强 力 兽 人 的 阻 击。 ")
	desc = string.gsub(desc,"Most of your team was killed there and now you and Norgan %(the sole survivor besides you%) must hurry back to the Iron Council to bring the news."," 你 队 伍 中 大 多 数 人 被 杀 死， 现 在 你 和 诺 尔 甘 ( 除 你 以 外 的 唯 一 幸 存 者 ) 必 须 赶 紧 突 围 回 到 钢 铁 议 会 去 汇 报 这 里 的 情 况。 ")
	desc = string.gsub(desc,"Let nothing stop you."," 不 惜 一 切 代 价 冲 出 去。 ")
	desc = string.gsub(desc,"Both Norgan and you made it home."," 你 和 诺 尔 甘 都 回 到 了 家。 ")
	return desc
end}

questCHN["Into the darkness"] = {
name = " 进 入 黑 暗 ",
description = function(desc)
	desc = string.gsub(desc,"It is time to explore some new places %-%- dark, forgotten and dangerous ones."," 是 时 候 去 一 些 新 的 地 方 探 索 一 下 了 — — 那 些 黑 暗、 被 遗 忘 和 危 险 的 地 方。 ")
	desc = string.gsub(desc,"The Old Forest is just south%-east of the town of Derth."," 在 德 斯 镇 东 南 方 向 是 古 老 森 林。 ")
	desc = string.gsub(desc,"The Maze is west of Derth."," 在 德 斯 镇 西 面 是 迷 宫。 ")
	desc = string.gsub(desc,"The Sandworm Lair is to the far west of Derth, near the sea."," 在 德 斯 镇 远 一 点 的 西 面， 靠 近 海 岸 的 地 方 是 沙 虫 巢 穴。 ")
	desc = string.gsub(desc,"The Daikara is on the eastern borders of the Thaloren forest."," 在 自 然 精 灵 树 林 的 东 部 边 境 那 里 是 岱 卡 拉。 ")
	desc = string.gsub(desc,"You have explored the Old Forest and vanquished Wrathroot."," 你 已 经 探 索 了 古 老 森 林 并 杀 死 了 狂 怒 树 精 。 ")
	desc = string.gsub(desc,"You have explored the Old Forest and vanquished Shardskin."," 你 已 经 探 索 了 古 老 森 林 并 杀 死 了 水 晶 树 精 。 ")
	desc = string.gsub(desc,"You must explore the Old Forest and find out what lurks there and what treasures are to be gained!"," 你 已 经 探 索 了 古 老 森 林 并 查 清 了 那 里 潜 伏 的 危 险， 还 获 得 了 那 里 的 宝 藏。 ")
	desc = string.gsub(desc,"You have explored the Maze and vanquished the Minotaur."," 你 已 经 探 索 了 迷 宫 并 杀 死 了 米 诺 陶。 ")
        desc = string.gsub(desc,"You have explored the Maze and vanquished the Horned Horror"," 你 已 经 探 索 了 迷 宫 并 杀 死 了 长 角 恐 魔。 ")
	desc = string.gsub(desc,"You must explore the Maze and find out what lurks there and what treasures are to be gained!"," 你 已 经 探 索 了 迷 宫 并 查 清 了 那 里 潜 伏 的 危 险， 还 获 得 了 那 里 的 宝 藏。 ")
	desc = string.gsub(desc,"You have explored the Sandworm Lair and vanquished their Queen."," 你 已 经 探 索 了 沙 虫 巢 穴 并 杀 死 了 沙 虫 皇 后。 ")
	desc = string.gsub(desc,"You must explore the Sandworm Lair and find out what lurks there and what treasures are to be gained!"," 你 已 经 探 索 了 沙 虫 巢 穴 并 查 清 了 那 里 潜 伏 的 危 险， 还 获 得 了 那 里 的 宝 藏。 ")
	desc = string.gsub(desc,"You have explored the Daikara and vanquished the huge ice dragon that dwelled there."," 你 已 经 探 索 了 岱 卡 拉 并 杀 死 了 冰 龙。 ")
	desc = string.gsub(desc,"You have explored the Daikara and vanquished the huge fire dragon that dwelled there."," 你 已 经 探 索 了 岱 卡 拉 并 杀 死 了 火 龙。 ")
	desc = string.gsub(desc,"You must explore the Daikara and find out what lurks there and what treasures are to be gained!"," 你 已 经 探 索 了 岱 卡 拉 并 查 清 了 那 里 潜 伏 的 危 险， 还 获 得 了 那 里 的 宝 藏。 ")
	return desc
end}

questCHN["Future Echoes"] = {
name = " 未 来 的 回 音 ",
description = function(desc)
	desc = string.gsub(desc,"The unhallowed morass is the name of the 'zone' surrounding Point Zero."," 混 沌 之 沼 是 零 点 圣 域 周 围 区 域 的 名 字。 ")
	desc = string.gsub(desc,"The temporal spiders that inhabit it are growing restless and started attacking at random. You need to investigate what is going on."," 栖 息 在 那 里 的 时 空 蜘 蛛 开 始 变 得 有 攻 击 性， 你 得 去 调 查 一 下 到 底 发 生 了 什 么 事。 ")
	desc = string.gsub(desc,"You have explored the morass and destroyed the weaver queen, finding strange traces on it."," 你 探 索 了 混 沌 之 沼 并 杀 死 了 织 网 蛛 后， 发 现 了 奇 怪 的 痕 迹。 ")
	desc = string.gsub(desc,"You must explore the morass."," 你 必 须 探 索 混 沌 之 沼。 ")
	desc = string.gsub(desc,"You have helped defend Point Zero."," 你 成 功 守 卫 了 零 点 圣 域。 ")
	return desc
end}

questCHN["Echoes of the Spellblaze"] = {
name = " 魔 法 大 爆 炸 的 回 音 ",
description = function(desc)
	desc = string.gsub(desc,"You have heard that within the scintillating caves lie strange crystals imbued with Spellblaze energies."," 你 听 说 在 闪 光 洞 穴 中 有 一 些 被 魔 法 大 爆 炸 能 量 影 响 的 奇 怪 水 晶。 ")
	desc = string.gsub(desc,"There are also rumours of a regenade Shaloren camp to the west."," 有 传 闻 说 西 面 有 堕 落 的 永 恒 精 灵 的 营 地。 ")
	desc = string.gsub(desc,"You have explored the scintillating caves and destroyed the Spellblaze Crystal."," 你 已 经 探 索 了 闪 光 洞 穴， 并 摧 毁 了 魔 法 烈 焰 水 晶 体。 ")
	desc = string.gsub(desc,"You must explore the scintillating caves."," 你 必 须 探 索 闪 光 洞 穴。 ")
	desc = string.gsub(desc,"You have explored the Rhaloren camp and killed the Inquisitor."," 你 已 经 探 索 了 罗 兰 精 灵 营 地 并 杀 死 了 检 察 官。 ")
	desc = string.gsub(desc,"You must explore the renegade Shaloren camp."," 你 已 经 探 索 了 堕 落 的 永 恒 精 灵 的 营 地。 ")
	return desc
end}

questCHN["Serpentine Invaders"] = {
name = " 蛇 形 的 侵 略 者 ",
description = function(desc)
	desc = string.gsub(desc,"Nagas are invading the slazish fens. The Sunwall cannot fight on two fronts; you need to stop the invaders before it is too late.\n Locate and destroy the invaders' portal."," 纳 迦 正 在 攻 击 斯 拉 伊 什 沼 泽， 太 阳 堡 垒 不 能 同 时 两 线 作 战， 你 必 须 抓 紧 时 间 阻 止 那 些 侵 略 者 以 免 来 不 及。 \n 找 到 并 摧 毁 侵 略 者 的 传 送 门。 ")
	desc = string.gsub(desc,"You have destroyed the naga portal. The invasion is stopped."," 你 摧 毁 了 纳 迦 的 传 送 门， 侵 略 者 被 阻 止 了。 ")
	desc = string.gsub(desc,"You are back in Var'Eyal, the Far East as the people from the west call it."," 你 回 到 了 瓦 · 埃 亚 尔 — — 来 自 西 方 的 人 称 呼 远 东 大 陆 的 名 字。 ")
	desc = string.gsub(desc,"However, you were teleported to a distant land. You must find a way back to the Gates of Morning."," 然 而， 你 被 传 送 到 了 一 个 遥 远 的 区 域， 你 必 须 找 到 返 回 晨 曦 之 门 的 方 法。 ")
	desc = string.gsub(desc,"You must stop the nagas."," 你 必 须 阻 止 那 些 纳 迦。 ")
	return desc
end}

questCHN["Madness of the Ages"] = {
name = " 疯 狂 的 岁 月 ",
description = function(desc)
	desc = string.gsub(desc,"The Thaloren forest is disrupted. Corruption is spreading. Norgos the guardian bear is said to have gone mad."," 自 然 精 灵 森 林 陷 入 了 混 乱， 到 处 肆 虐 着 堕 落。 听 说 诺 尔 格 斯， 守 护 巨 熊， 陷 入 了 疯 狂。 ")
	desc = string.gsub(desc,"On the western border of the forest a gloomy aura has been set up. Things inside are... twisted."," 在 森 林 的 西 部 边 境 被 设 置 了 一 个 黑 暗 光 环， 里 面 的 东 西 已 陷 入 了 扭 曲。 ")
	desc = string.gsub(desc,"You have explored Norgos' Lair and put it to rest."," 你 已 经 探 索 了 诺 尔 格 斯 的 巢 穴 并 埋 葬 了 他 们。 ")
	desc = string.gsub(desc,"You have explored Norgos' Lair and stopped the shivgoroth invasion."," 你 已 经 探 索 了 诺 尔 格 斯 的 巢 穴 并 阻止了寒 冰 元 素 的 侵 略。 ")
	desc = string.gsub(desc,"You must explore Norgos' Lair."," 你 必 须 调 查 诺 尔 格 斯 的 巢 穴。 ")
	desc = string.gsub(desc,"You have explored the Heart of the Gloom and slain the Withering Thing."," 你 已 经 探 索 了 黑 暗 中 心 并 杀 死 了 凋 零。 ")
	desc = string.gsub(desc,"You have explored the Heart of the Gloom and slain the Dreaming One."," 你 已 经 探 索 了 黑 暗 中 心 并 杀 死 了 梦 境 之 眼。 ")
	desc = string.gsub(desc,"You must explore the Heart of the Gloom."," 你 必 须 调 查 一 下 黑 暗 之 心。 ")
	return desc
end}

questCHN["The rotting stench of the dead"] = {
name = " 腐 臭 的 尸 体 ",
description = function(desc)
	desc = string.gsub(desc,"You have been resurrected as an undead by some dark powers."," 你 被 黑 暗 力 量 复 活 了。 ")
	desc = string.gsub(desc,"However, the ritual failed in some way and you retain your own mind. You need to get out of this dark place and try to carve a place for yourself in the world."," 不 过， 复 活 仪 式 似 乎 出 了 点 问 题， 你 保 留 了 自 己 的 意 识， 你 必 须 离 开 这 个 黑 暗 地 方 并 找 到 属 于 自 己 的 栖 息 地。 ")
	desc = string.gsub(desc,"You have found a very special cloak that will help you walk among the living without trouble."," 你 发 现 了 一 个 非 常 神 奇 的 斗 篷， 可 以 使 你 在 活 人 之 中 自 由 生 活 而 不 会 陷 入 麻 烦。 ")
	return desc
end}

questCHN["Following The Way"] = {
name = " 保 卫 维 网 ",
description = function(desc)
	desc = string.gsub(desc,"You have been tasked to remove two threats to the yeeks."," 你 被 派 去 清 除 对 夺 心 魔 的 两 大 威 胁。 ")
	desc = string.gsub(desc,"Protect the Way, and vanquish your foes."," 守 护 维 网， 征 服 你 的 敌 人。 ")
	desc = string.gsub(desc,"You have explored the underwater zone and vanquished Murgol."," 你 已 经 探 索 了 水 下 区 域 并 击 败 了 穆 格 尔。 ")
	desc = string.gsub(desc,"You must explore the underwater lair of Murgol."," 你 必 须 调 查 一 下 穆 格 尔 位 于 水 下 的 巢 穴。 ")
	desc = string.gsub(desc,"You have explored the ritch tunnels and vanquished their queen."," 你 调 查 了 里 奇 通 道 并 击 败 了 他 们 的 皇 后。 ")
	desc = string.gsub(desc,"You must explore the ritch tunnels."," 你 必 须 调 查 一 下 里 奇 通 道。 ")
	return desc
end}

questCHN["Strange new world"] = {
name = " 奇 怪 的 世 界 ",
description = function(desc)
	desc = string.gsub(desc,"You arrived through the farportal in a cave, probably in the Far East."," 你 穿 过 了 山 洞 的 远 古 传 送 门， 可 能 会 到 达 远 东 大 陆。 ")
	desc = string.gsub(desc,"Upon arrival you met an Elf and an orc fighting."," 你 碰 到 了 一 个 精 灵 在 和 一 个 兽 人 战 斗。 ")
	desc = string.gsub(desc,"You decided to side with the Elven lady."," 你 决 定 帮 帮 那 个 精 灵。 ")
	desc = string.gsub(desc,"You decided to side with the orc."," 你 决 定 帮 帮 那 个 兽 人。 ")
	desc = string.gsub(desc,"Fillarel told you to go to the southeast and meet with High Sun Paladin Aeryn."," 菲 拉 瑞 尔 告 诉 你 去 东 南 方 会 见 高 阶 太 阳 骑 士 艾 伦。 ")
	desc = string.gsub(desc,"Krogar told you to go to the west and look for the Kruk Pride."," 克 洛 加 尔 告 诉 你 去 西 面 寻 找 克 鲁 克 部 落。 ")
	return desc
end}

questCHN["The Temple of Creation"] = {
name = " 造 物 者 神 庙 ",
description = function(desc)
	desc = string.gsub(desc,"Ukllmswwik asked you to take his portal to the Temple of Creation and kill Slasul who has turned mad."," 乌 克 勒 姆 斯 维 奇 请 求 你 穿 过 他 的 传 送 门 到 造 物 者 神 庙 去 杀 死 发 疯 了 的 斯 拉 苏 尔。 ")
	desc = string.gsub(desc,"Slasul told you his side of the story. Now you must decide: which of them is corrupt%?"," 斯 拉 苏 尔 告 诉 了 你 关 于 他 的 故 事， 你 现 在 必 须 决 定： 到 底 谁 才 是 真 正 的 堕 落 者。 ")
	desc = string.gsub(desc,"You have killed both Ukllmswwik and Slasul, betraying them both."," 你 把 乌 克 勒 姆 斯 维 奇 和 斯 拉 苏 尔 都 杀 掉 了， 同 时 背 叛 了 他 们 两 个。 ")
	desc = string.gsub(desc,"You have sided with Ukllmswwik and killed Slasul."," 你 选 择 相 信 乌 克 勒 姆 斯 维 奇 并 杀 死 了 斯 拉 苏 尔。 ")
	desc = string.gsub(desc,"You have sided with Slasul and killed Ukllmswwik."," 你 选 择 相 信 斯 拉 苏 尔 并 杀 死 了 乌 克 勒 姆 斯 维 奇。 ")
	desc = string.gsub(desc,"Slasul bound his lifeforce to yours and gave your a powerful trident in return."," 斯 拉 苏 尔 赋 予 你 他 的 生 命 之 力， 并 交 给 你 一 把 强 力 的 三 叉 戟。 ")
	return desc
end}

questCHN["Back and Back and Back to the Future"] = {
name = " 回 到 未 来 ",
description = function(desc)
	desc = string.gsub(desc,"After passing through some kind of time anomaly you met a temporal warden who told you to destroy the abominations of this alternate timeline."," 穿 过 了 异 常 时 空 你 碰 到 了 一 个 时 空 看 守， 他 告 诉 你 去 摧 毁 这 个 变 换 时 间 线 里 的 怪 物。 ")
	return desc
end}

questCHN["Tutorial"] = {
name = " 教 程 ",
description = function(desc)
	desc = string.gsub(desc,"You must venture in the heart of the forest and kill the Lone Wolf, who randomly attacks villagers."," 你 必 须 进 入 森 林 的 中 心 地 带 并 杀 死 孤 狼 — — 那 个 肆 意 屠 杀 村 民 的 凶 手。 ")
	return desc
end}

questCHN["Tutorial: combat stats"] = {
name = " 教 程： 战 斗 属 性 ",
description = function(desc)
	desc = string.gsub(desc,"Explore the Dungeon of Adventurer Enlightenment to learn about ToME's combat mechanics."," 探 索 地 下 城 冒 险 启 蒙 版 学 习 一 下 ToME 里 的 战 斗 机 制。 ")
	desc = string.gsub(desc,"You have navigated the Dungeon of Adventurer Enlightenment!"," 你 通 过 了 地 下 城 冒 险 启 蒙 版！ ")
	return desc
end}

questCHN["In the void, no one can hear you scream"] = {
name = " 虚 空 之 中 无 人 会 听 到 你 的 叫 喊 ",
description = function(desc)
	desc = string.gsub(desc,"You have destroyed the sorcerers. Sadly, the portal to the Void remains open; the Creator is coming."," 你 杀 死 了 那 些 法 师， 但 是 悲 剧 的 是， 虚 空 传 送 门 还 是 被 打 开 了， 造 物 之 主 就 要 降 临 人 间。 ")
	desc = string.gsub(desc,"This cannot be allowed to happen. After thousands of years trapped in the Void between the stars, Gerlyk is mad with rage."," 这 些 事 本 不 能 发 生 的， 被 困 在 虚 空 星 界 之 间 几 千 年 后， 加 莱 克 被 愤 怒 逼 疯 了。 ")
	desc = string.gsub(desc,"You must now finish what the Sher'tuls started. Take the Staff of Absorption and become a Godslayer yourself."," 你 现 在 必 须 像 夏 · 图 尔 开 始 时 候 那 样， 拿 起 吸 能 法 杖， 成 为 一 个 弑 神 者。 ")
	return desc
end}

questCHN["There and back again"] = {
name = " 穿 越 回 来 ",
description = function(desc)
	desc = string.gsub(desc,"Zemekkys in the Gates of Morning can build a portal back to Maj'Eyal for you."," 晨 曦 之 门 的 伊 莫 克 斯 可 以 为 你 制 造 一 个 传 送 门 使 你 回 到 马 基 埃 亚 尔。 ")
	desc = string.gsub(desc,"You have found a Blood%-Runed Athame."," 你 找 到 了 血 符 祭 祀 之 刃。 ")
	desc = string.gsub(desc,"Find a Blood%-Runed Athame."," 寻 找 血 符 祭 祀 之 刃。 ")
	desc = string.gsub(desc,"You have found the Resonating Diamond."," 你 找 到 了 共 鸣 宝 石。 ")
	desc = string.gsub(desc,"Find a Resonating Diamond."," 寻 找 共 鸣 宝 石。 ")
	desc = string.gsub(desc,"The portal to Maj'Eyal is now functional and can be used to go back, although, like all portals, it is one%-way only."," 到 马 基 埃 亚 尔 的 传 送 门 被 激 活 了， 你 可 以 用 它 返 回， 不 过 和 其 他 传 送 门 一 样， 传 送 过 去 之 后 不 能 传 回 来。 ")
	return desc
end}

questCHN["The wild wild east"] = {
name = " 遥 远 的 东 方 ",
description = function(desc)
	desc = string.gsub(desc,"There must be a way to go into the far east from the lair of Golbug. Find it and explore the unknown far east, looking for clues."," 在 高 尔 布 格 巢 穴 内 肯 定 有 一 条 通 往 远 东 大 陆 的 路， 去 寻 找 线 索 并 找 到 它， 然 后 探 索 那 未 知 而 遥 远 的 东 方。 ")
	return desc
end}

questCHN["Ashes in the Wind"] = {
name = "风中灰烬",
description = function(desc)
	desc = string.gsub(desc,"You do not remember much of your life before you were on this burning continent, floating in the void between worlds.  You have been helping demons, happily participating in their experiments to shatter some sort of shield preventing them from taking their righteous revenge on Eyal.","你 已 经 不 太 记 得 来 到 这 片 漂 浮 在 虚 空 中 的 燃 烧 大 陆 之 前 的 记 忆 了 。 你 曾 经 帮 助 过 恶 魔 ， 欢 欣 着 参 与 他 们 的 实 验 ， 以 打 破 某 种 阻 止 恶 魔 降 临 大 举 复 仇 的 无 形 屏 障 。")
	desc = string.gsub(desc,"You are being taken by your handler to the torture%-pits to help them figure out how to cause the most pain to those on Eyal, when you hear a roaring above you; you look up and see a burning meteor, flying closer, and the demons' spells failing to divert its course!  It lands near you, knocking you off your feet with its shockwave and killing your handler instantly.","你 被 你 的 ' 主 人 ' 带 到 这 里 以 帮 助 研 究 如 何 对 埃 亚 尔 大 陆  造 成 更 严 重 的 伤 害 ， 突 然 一 阵 轰 鸣 从 天 上 传 来 ，你 抬 头 ， 看 见 一 颗 燃 烧 着 的 陨 石 正 在 坠 落 。 恶 魔 试 图 用 法 术 将 其 粉 碎 ， 但 没 有 成 功 ！ 它 落 在 你 身 边 ， 砸 死 了 你 的 ' 主 人 ' ， 同 时 你 也 被 砸 晕 在 地 。")
	desc = string.gsub(desc,"As you recover, and your platform of searing earth splits from the main continent, your old memories flood your mind and you come to your senses %- the demons are out to destroy your home!  You must escape... but not without destroying the crystal they've used to keep track of you.","当 你 醒 来 后 ， 你 发 现 你 身 处 一 个 和 主 大 陆 分 离 的 平 台 ， 而 你 旧 时 的 记 忆 渐 渐 涌 来 。 你 立 刻 惊 醒 —— 恶 魔 们 要 毁 灭 你 的 故 乡 ！ 你 必 须 逃 离 。。。同 时 别 忘 了 摧 毁 他 们 用 以 追 踪 你 的 水 晶 体。")
	desc = string.gsub(desc,"You have destroyed the controlling crystal. The demons can no track you down anymore.","你 摧 毁 了 控 制 水 晶 ， 恶 魔 们 不 能 再 追 踪 你 了。")
	desc = string.gsub(desc,"You have destroyed the Planar Controller. Flee now!","你摧 毁 了 空 间 控 制 者 。 趁 现 在 逃 跑 吧！")
	desc = string.gsub(desc,"You have to destroy the Planar Controller to escape.","想 要 逃 跑 ， 你 必 须 摧 毁 空 间 控 制 者。")
	desc = string.gsub(desc,"You have to destroy the controlling crystal before leaving or the demons will be able to track you down.","你 必 须 在 逃 跑 前 摧 毁 控 制 水 晶")
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
	n = n:gsub("Escort: "," 护 送： "):gsub("lost warrior"," 迷 路 的 战 士 "):gsub("injured seer"," 受 伤 的 先 知 "):gsub("repented thief"," 忏 悔 的 盗 贼 "):gsub("lone alchemist"," 迷 途 的 炼 金 术 士 "):gsub("lost sun paladin"," 迷 路 的 太 阳 骑 士 "):gsub("lost anorithil"," 迷 路 的 星 月 术 士 "):gsub("worried loremaster"," 忧 郁 的 博 学 者 "):gsub("temporal explorer","时 空 探 索 者")
	
	local m = n:gsub(".+%(level %d+ of ",""):gsub("%)","")
	local l = n:match("level (%d+) of ")
	if zoneName[m] then m = zoneName[m] end
	n = string.gsub(n,"%(level %d+ of .+","").."("..m.." 第 "..l.." 层 )"
	return n 
	end,
description = function(desc)
	local match_chr = ""

	desc = string.gsub(desc,"You successfully escorted the "," 你 成 功 的 护 送 了 ")
	desc = string.gsub(desc,"You failed to protect the "," 你 没 能 成 功 护 送 ")
	if desc:find(" from death by ") then
		match_chr = desc:match(" from death by (.+)%.")
		desc = string.gsub(desc," from death by ","， 杀 死 他（ 她） 的 是： ")
		desc = desc:gsub(match_chr,npcCHN:getName(match_chr))
	end
	desc = string.gsub(desc,"Escort the "," 护 送 ")
	if desc:find(" to the recall portal on level ") then
		match_chr = desc:match(" to the recall portal on level %d+ of (.+)%.\n")
		desc = string.gsub(desc," to the recall portal on level "," 到 达 传 送 门， 位 于 第 ")
		if zoneName[match_chr] then desc = desc:gsub("of " .. match_chr, " 层， " .. zoneName[match_chr]) end
	end
	desc = string.gsub(desc,"You abandoned "," 你 扔 下 了 ")
	desc = string.gsub(desc," to death."," 任 其 自 生 自 灭。 ")
	desc = string.gsub(desc,"lost warrior"," 迷 路 的 战 士 ")
	desc = string.gsub(desc,"injured seer"," 受 伤 的 先 知 ")
	desc = string.gsub(desc,"repented thief"," 忏 悔 的 盗 贼 ")
	desc = string.gsub(desc,"lone alchemist"," 迷 途 的 炼 金 术 士 ")
	desc = string.gsub(desc,"lost sun paladin"," 迷 路 的 太 阳 骑 士 ")
	desc = string.gsub(desc,"lost anorithil"," 迷 路 的 星 月 术 士 ")
	desc = string.gsub(desc,"worried loremaster"," 忧 郁 的 博 学 者 ")
	desc = desc:gsub("temporal explorer","时 空 探 索 者")
	desc = string.gsub(desc,"As a reward you"," 作 为 报 答 你 得 到 奖 励： ")

	if desc:find("improved .+ save by") then
		match_chr = desc:match("improved (.+) save by")
		desc = desc:gsub("improved .+ save by"," 提 升 " .. (s_stat_name[match_chr] or match_chr) .."豁免")
	elseif desc:find("improved .+ by") then
		match_chr = desc:match("improved (.+) by")
		desc = desc:gsub("improved .+ by"," 提 升 " .. (s_stat_name[match_chr] or match_chr))
	elseif desc:find(" talent .+level") then
		desc = desc:gsub("improved"," 提 升 ")
		desc = desc:gsub("learnt"," 习 得 ")
		desc = desc:gsub("talent"," 技 能 　 ")
		desc = desc:gsub("level%(s%)"," 等 级 ")
	elseif desc:find("gained talent category .+at mastery") then
		match_chr = desc:match("gained talent category (.+) / ")
		desc = desc:gsub("gained talent category"," 获 得 技 能 树 点 数 ")
		desc = desc:gsub("at mastery"," 技 能 树 等 级 ")
		if t_talent_cat[string.lower(match_chr)] then desc = desc:gsub(match_chr,t_talent_cat[string.lower(match_chr)]) end
	end

	return desc
end}


--	quest.name =  string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(txt,"Escort: "),),),),),),),)
		

-- 替 换 任 务 状 态 
function getQuestStat(txt)
	if txt == "active" then return " 进 行 中 "
	elseif txt == "done" then return " 完 成 "
	elseif txt == "failed" then return " 失 败 "
	else return txt
	end
end

-- 替 换 炼 金 配 料 
function changeElixir(desc)
	desc = string.gsub(desc,"Kindly empty it before returning."," 在 把 它 带 回 来 之 前 请 把 它 清 理 干 净。 ")
	desc = string.gsub(desc,"length of troll intestine"," 较 长 的 巨 魔 肠 子 ")
	
	desc = string.gsub(desc,"If the eyes are still glowing, please bash it around a bit until they fade. I'll not have another one of those coming alive and wreaking havoc in my lab."," 如 果 它 的 眼 睛 仍 然 亮 着， 请 猛 击 它 直 到 不 再 发 光 为 止。 我 不 想 再 要 一 个 会 突 然 活 过 来 并 把 我 的 实 验 室 搞 的 一 塌 糊 涂 的 头 骨 了。 ")
	desc = string.gsub(desc,"skeleton mage skull"," 骷 髅 法 师 头 骨 ")
	
	desc = string.gsub(desc,"Keep as much venom in it as possible."," 请 尽 可 能 多 的 保 持 螫 针 的 毒 液。 ")
	desc = string.gsub(desc,"ritch stinger"," 里 奇 螫 针 ")
	
	desc = string.gsub(desc,"If you can fetch me a still%-beating orc heart, that would be even better. But you don't look like a master necromancer to me."," 如 果 你 能 给 我 一 个 新 鲜 的、 跳 动 着 的 兽 人 心 脏， 那 就 太 好 了。 但 是 在 我 看 来， 你 不 像 是 一 个 死 灵 魔 导 师。 ")
	desc = string.gsub(desc,"orc heart"," 兽 人 心 脏 ")
	
	desc = string.gsub(desc,"Best results occur with tongues never tainted by profanity, so if you happen to know any saintly nagas..."," 最 好 的 结 果 便 是 从 未 被 污 言 秽 语 亵 渎 过 的 舌 头， 所 以 如 果 你 正 好 碰 到 那 些 圣 者 娜 迦 … … ")
	desc = string.gsub(desc,"naga tongue"," 娜 迦 舌 头 ")
	
	desc = string.gsub(desc,"Don't drink it, even if it tells you to."," 不 要 去 喝 它， 即 使 它 诱 惑 着 你 … … ")
	desc = string.gsub(desc,"vial of greater demon bile"," 大 恶 魔 的 胆 汁 ")
	
	desc = string.gsub(desc,"Never, ever to be confused with garlic powder. Trust me."," 绝 对 绝 对 不 要 和 大 蒜 粉 搞 混 ， 相 信 我 … … ")
	desc = string.gsub(desc,"pouch of bone giant dust"," 一 袋 骨 巨 人 的 骨 灰 ")
	
	desc = string.gsub(desc,"If you've the means to eliminate the little venom problem, these make miraculous instant drink%-chilling straws."," 如 果 你 有 方 法 消 除 小 小 的 毒 液 问 题， 这 些 螫 针 可 以 成 为 不 可 思 议 的 冷 冻 吸 管。 ")
	desc = string.gsub(desc,"ice ant stinger"," 冰 蚁 的 螫 针 ")
	
	desc = string.gsub(desc,"You'll need to find one with a ring, preferably an expensive one."," 你 要 寻 找 1 个 带 有 圆 环 的， 最 好 是 比 较 贵 的 那 个。 ")
	desc = string.gsub(desc,"minotaur nose"," 米 诺 陶 的 鼻 子 ")
	
	desc = string.gsub(desc,"Once you've gotten it, cross some moving water on your way back."," 取 得 它 之 后， 你 最 好 在 回 去 的 路 上 用 活 水 写 些 十 字。 ")
	desc = string.gsub(desc,"vial of elder vampire blood"," 一 瓶 高 级 吸 血 鬼 的 血 液 ")
	
	desc = string.gsub(desc,"If you think collecting one of these is hard, try liquefying one."," 如 果 你 认 为 收 集 一 片 龙 鳞 很 困 难， 那 么 去 尝 试 溶 解 它 吧。 ")
	desc = string.gsub(desc,"multi%-hued wyrm scale"," 多 彩 的 龙 鳞 ")
	
	desc = string.gsub(desc,"The spiders in your barn won't do. You'll know a giant spider when you see one, though they're rare in Maj'Eyal."," 你 家 仓 库 里 的 蜘 蛛 是 不 行 的。 当 你 看 到 一 只 时， 你 就 会 明 白 什 么 是 巨 型 蜘 蛛， 尽 管 在 马 基 埃 亚 尔 这 种 蜘 蛛 很 稀 少。 ")
	desc = string.gsub(desc,"giant spider spinneret"," 巨 蛛 的 丝 腺 ")
	
	desc = string.gsub(desc,"Keep a firm grip on it. These things will dig themselves right back into the ground if you drop them."," 牢 牢 的 抓 住 它， 如 果 你 不 小 心 把 它 掉 在 地 上， 它 会 立 刻 挖 地 逃 走。 ")
	desc = string.gsub(desc,"honey tree root"," 蜜 蜂 树 的 根 ")
	
	desc = string.gsub(desc,"Don't worry if it dissolves. Just don't get any on you."," 不 要 担 心 它 的 腐 烂， 只 要 不 碰 到 你 身 上 就 没 事。 ")
	desc = string.gsub(desc,"bloated horror heart"," 浮 肿 的 恐 魔 心 脏 ")
	
	desc = string.gsub(desc,"I know, I know. Where does the eel stop and the tail start%? It doesn't much matter. The last ten inches or so should do nicely."," 我 知 道， 我 知 道。 你 想 问 电 鳗 的 尾 巴 是 哪 一 段？ 没 有 确 切 的 答 案。 最 后 10 英 寸 或 许 是 最 合 适 的。 ")
	desc = string.gsub(desc,"electric eel tail"," 电 鳗 尾 巴 ")
	
	desc = string.gsub(desc,"However annoying this will be for you to gather, I promise that the reek it produces in my lab will prove even more annoying."," 不 管 你 怎 样 讨 厌 它， 都 需 要 你 去 采 集， 我 向 你 保 证 我 在 实 验 室 用 它 做 出 的 东 西 会 更 加 令 人 讨 厌。 ")
	desc = string.gsub(desc,"vial of squid ink"," 一 瓶 乌 贼 墨 汁 ")
	
	desc = string.gsub(desc,"You'd think I could get one of these from a local hunter, but they've had no luck. Don't get eaten."," 你 认 为 我 可 以 从 本 地 的 猎 户 手 上 取 得 它 吗？ 甭 想 了， 他 们 没 那 个 运 气。 不 要 被 吃 掉 了。 ")
	desc = string.gsub(desc,"bear paw"," 熊 爪 ")
	
	desc = string.gsub(desc,"Ice Wyrms lose teeth fairly often, so you might get lucky and not have to do battle with one. But dress warm just in case."," 冰 龙 每 隔 一 段 时 间 会 换 齿， 所 以 你 幸 运 的 话， 可 以 捡 到 几 颗 而 不 需 要 和 它 战 斗。 保 险 起 见 穿 的 暖 和 点 … … ")
	desc = string.gsub(desc,"ice wyrm tooth"," 冰 霜 巨 龙 的 牙 齿 ")
	
	desc = string.gsub(desc,"I hear these can be found in a cave near Elvala. I also hear that they can cause you to spontaneously combust, so no need to explain if you come back hideously scarred."," 我 听 说 这 些 小 家 伙 可 以 在 埃 尔 瓦 拉 附 近 的 洞 穴 里 找 到。 我 还 听 说 它 们 会 使 你 自 燃， 所 以 当 你 高 度 烧 伤 回 来 的 话， 不 要 向 我 诉 苦。 ")
	desc = string.gsub(desc,"red crystal shard"," 红 色 水 晶 碎 片 ")
	
	desc = string.gsub(desc,"Keep this stuff well away from your campfire unless you want me to have to find a new, more alive adventurer."," 把 这 个 瓶 子 离 你 的 篝 火 远 一 些， 我 可 不 想 明 天 重 新 找 一 个 活 的 冒 险 家。 ")
	desc = string.gsub(desc,"vial of fire wyrm saliva"," 一 瓶 火 龙 涎 ")
	
	desc = string.gsub(desc,"Unfortunately for you, the chunks that regularly fall off ghouls won't do. I need one freshly carved off."," 告 诉 你 一 个 不 幸 的 消 息， 平 时 从 食 尸 鬼 身 上 掉 下 来 的 肉 是 不 行 的。 我 需 要 新 鲜 的， 刚 切 下 来 的 肉。 ")
	desc = string.gsub(desc,"chunk of ghoul flesh"," 腐 烂 的 食 尸 鬼 肉 块 ")
	
	desc = string.gsub(desc,"That is, a bone from a corpse that's undergone mummification. Actually, any bit of the body would do, but the bones are the only parts you're certain to find when you kick a mummy apart. I recommend finding one that doesn't apply curses."," 那 就 是， 经 过 木 乃 伊 化 的 尸 体 身 上 的 骨 头。 实 际 上， 身 体 的 任 何 部 位 都 可 以， 只 是 从 它 们 身 上 只 能 找 到 骨 头 了 。 我 推 荐 你 去 找 一 根 没 有 被 诅 咒 的 骨 头。 ")
	desc = string.gsub(desc,"mummified bone"," 木 乃 伊 骨 头 ")
	
	desc = string.gsub(desc,"Yes, sandworms have teeth. They're just very small and well back from where you're ever likely to see them and live."," 是 的， 沙 虫 也 有 牙 齿。 它 们 只 是 很 小 ， 藏 得 很 好 ，如 果 你 把 头 伸 进 去 找 它 你 就 没 法 活 着 回 来 了 。")
	desc = string.gsub(desc,"sandworm tooth"," 沙 虫 之 牙 ")
	
	desc = string.gsub(desc,"If you get bitten, I can save your life if you still manage to bring back the head... and if it happens within about a minute from my door. Good luck."," 如 果 你 被 它 咬 到 了， 只 要 你 坚 持 到 把 它 带 回 来 我 就 可 以 拯 救 你 … … 但 是 如 果 你 不 能 及 时 带 回 来， 那 么， 祝 你 好 运。 ")
	desc = string.gsub(desc,"black mamba head"," 黑 曼 巴 头 ")
	
	desc = string.gsub(desc,"I suggest not killing the snow giant by impaling it through the kidneys. You'll just have to find another."," 我 建 议 你 不 要 从 雪 巨 人 的 肾 脏 部 位 刺 死 它， 否 则 你 不 得 不 寻 找 另 外 一 个。 ")
	desc = string.gsub(desc,"snow giant kidney"," 雪 巨 人 的 肾 脏 ")
	
	desc = string.gsub(desc,"I recommend severing one of dewclaws. They're smaller and easier to remove, but they've never been blunted by use, so be careful you don't poke yourself. Oh yes, and don't get eaten."," 我 建 议 你 割 断 其 中 一 只 爪 子， 它 们 更 小 而 且 容 易 被 割 下。 但 是 它 们 从 来 不 会 因 使 用 而 钝 化， 所 以 当 心 点 别 划 伤 你 自 己。 哦， 对 了， 还 有 别 被 吃 掉。 ")
	desc = string.gsub(desc,"storm wyrm claw"," 风 暴 之 龙 的 爪 子 ")
	
	desc = string.gsub(desc,"Try to get any knots out before returning. Wear gloves."," 在 回 来 之 前 把 打 结 在 上 面 的 其 他 蠕 虫 统 统 清 理 掉。 戴 上 手 套。 ")
	desc = string.gsub(desc,"green worm"," 翡 翠 蠕 虫 ")
	
	desc = string.gsub(desc,"If you ingest any of this, never mind coming back here. Please."," 如 果 你 不 小 心 喝 掉 一 点， 请 不 要 介 意 回 到 我 这。 ")
	desc = string.gsub(desc,"vial of wight ectoplasm"," 一 瓶 尸 妖 的 血 浆 ")
	
	desc = string.gsub(desc,"Avoid fragments that contained the xorn's eyes. You've no idea how unpleasant it is being watched by your ingredients."," 不 要 带 回 包 含 着 索 尔 石 怪 眼 睛 的 碎 片。 你 不 知 道 被 你 的 原 材 料 盯 着 是 多 么 难 受 的 一 件 事。 ")
	desc = string.gsub(desc,"xorn fragment"," 索 尔 石 碎 片 ")
	
	desc = string.gsub(desc,"My usual ingredient gatherers draw the line at hunting wargs. Feel free to mock them on your way back."," 我 对 原 料 的 需 求 使 我 想 到 了 猎 杀 座 狼。 在 你 回 来 的 时 候 请 弄 一 只 爪 子 回 来。 ")
	desc = string.gsub(desc,"warg claw"," 座 狼 爪 ")
	
	desc = string.gsub(desc,"They're creatures of pure flame, and likely of extraplanar origin, but the ash of objects consumed by their fire has remarkable properties."," 它 们 是 由 纯 粹 的 火 焰 组 成 的 生 物， 似 乎 来 自 另 一 个 世 界。 然 而 ， 由 它 们 的 火 焰 燃 烧 成 的 灰 烬 有 着 非 凡 的 功 效。 ")
	desc = string.gsub(desc,"pouch of faeros ash"," 法 罗 的 灰 烬 ")
	
	desc = string.gsub(desc,"Evil little things, wretchlings. Feel free to kill as many as you can, though I just need the one intact eyeball."," 邪 恶 的 小 恶 魔， 酸 液 树 魔。 你 可 以 尽 情 的 杀 戮 它 们， 尽 管 我 只 需 要 一 只 完 整 的 眼 球。 ")
	desc = string.gsub(desc,"wretchling eyeball"," 酸 液 树 魔 之 眼 ")
	
	desc = string.gsub(desc,"I've lost a number of adventurers to this one, but I'm sure you'll be fine."," 我 已 经 在 这 个 工 作 中 失 去 了 许 多 冒 险 者， 但 我 确 信 你 会 安 全 归 来。 ")
	desc = string.gsub(desc,"faerlhing fang"," 费 尔 荷 毒 牙 ")
	
	desc = string.gsub(desc,"You should definitely consider not pricking yourself with it."," 你 必 须 确 保 自 己 不 会 被 它 划 伤。 ")
	desc = string.gsub(desc,"vampire lord fang"," 吸 血 鬼 族 长 的 毒 牙 ")
	
	desc = string.gsub(desc,"If you've not encountered hummerhorns before, they're like wasps, only gigantic and lethal."," 如 果 你 以 前 没 看 过 杀 人 蜂， 你 可 以 想 象 下 … … 它 们 像 大 黄 蜂 一 样， 只 不 过 变 的 巨 大 而 致 命。 ")
	desc = string.gsub(desc,"hummerhorn wing"," 半 透 明 的 昆 虫 翅 膀 ")
	
	desc = string.gsub(desc,"Not to be confused with radiant horrors. If you encounter the latter, then I suppose there are always more adventurers."," 不 要 被 恐 魔 发 出 的 强 光 所 吓 倒， 如 果 你 被 吓 倒， 我 会 考 虑 更 多 的 冒 险 者 来 接 替 你 的 使 命。 ")
	desc = string.gsub(desc,"pouch of luminous horror dust"," 一 袋 金 色 恐 魔 的 粉 尘 ")
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