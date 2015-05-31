module(..., package.seeall)

local q = game.player:hasQuest("brotherhood-of-alchemists")

local old_competition = q.competition
local ename = {
	["elixir of the fox"] = "狡诈药剂",
	["elixir of avoidance"] = "闪避药剂",
	["elixir of precision"] = "精准药剂",
	["elixir of mysticism"] = "神秘药剂",
	["elixir of the savior"] = "守护药剂",
	["elixir of mastery"] = "掌握药剂",
	["elixir of explosive force"] = "爆炸药剂",
	["elixir of serendipity"] = "幸运药剂",
	["elixir of focus"] = "专注药剂",
	["elixir of brawn"] = "蛮牛药剂",
	["elixir of	 stoneskin"] = "石肤药剂",
	["elixir of foundations"] = "领悟药剂",
}
local aname = {
	["Stire of Derth"] = "德斯镇的斯泰尔",
	["Marus of Elvala"] = "埃尔瓦拉的马鲁斯",
	["Agrimley the hermit"] = "隐居者亚格雷姆利",
	["Ungrol of Last Hope"] = "最后的希望的温格洛",
}
function _M.competition(self, player, other_alchemist_nums)
	local other_alch, other_elixir, player_loses, alch_picked, e_picked = old_competition(self, player, other_alchemist_nums)
	other_alch = aname[other_alch] or other_alch
	other_elixir = ename[other_elixir] or other_elixir
	return other_alch, other_elixir, player_loses, alch_picked, e_picked
end
