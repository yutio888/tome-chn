questCHN["The Impossible Castle"] ={
	name = "不可能的城堡",
	description = function(desc)
		
		desc = desc:gsub("You have discovered the entrance to a strange castle inside a huge book. The place seems to eat at your sanity but you feel drawn to it somehow...","你在巨大的书本中发现了通向奇怪城堡的入口。入口似乎在吞噬你的理智，但你感觉自己被它吸引……")
		desc = desc:gsub("You have closed a book of binding, it seems the whole castle had stabilized a little, there may be more books to close.","你关上了一本链接之书，城堡似乎稳定了一些，这里一定还有更多书需要关闭。")
		desc = desc:gsub("You have closed two books of binding, the castle is now stable and you should probably be able to access the last chapter.","你关闭了两本书，城堡稳定下来了，你应该前往最后一章。")
		desc = desc:gsub("You have killed the Glass Golem and claimed the castle treasures for yourself!","你杀死了玻璃傀儡，获得了城堡的宝藏")
		return desc
	end
}