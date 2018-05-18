questCHN["The Worm That Devours"] = {

	name = "吞噬之虫",
	description = function(desc)
		
		desc = desc:gsub("A huge mindless and corrupted worm is heading toward Kroshkkur!","一只巨大的无心智的腐化蠕虫正向克诺什库尔前进！")
		desc = desc:gsub("It has to be stopped or the Sanctuary will fall, digested in the bowels of giant worm, its forbidden knowledge lost forever.","它必须被阻拦，否则避难所将终结在它胃中，禁忌知识将永远消失。")
		desc = desc:gsub("You have destroyed the Worm's neural spine, preventing the doom of the Sanctuary.","你成功地摧毁了虫子的脊髓，避难所免遭末日")
		desc = desc:gsub("You have failed to destroy the Worm in time, the Sanctuary has been destroyed.","你没能及时摧毁虫子，避难所被摧毁了")
		desc = desc:gsub("You have to destroy the Worm's neural spine.","你必须摧毁虫子的脊髓以阻止其行动")
	return desc
	end}
