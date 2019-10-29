questCHN["Research. Tinker. Annihilate."] = {
    name = "研究。制造。歼灭。",
    description = function(desc)
        desc = desc:gsub("Inside some of your foes you have found some intact pieces that give you new ideas.", "在你的一些敌人身上，你发现了一些完整的碎片，这给你带来了新的想法。")
        desc = desc:gsub("Keep on killing mechanical contraptions or steam%-related foes", "请继续杀死机械装置，或和蒸汽有关的敌人")
        desc = desc:gsub("You destroyed a mecharachnid equiped with a flamethrower. Both those things could prove very useful.", "你摧毁了一个装备火焰喷射器的机械蜘蛛。这两样东西将来都会很有用。")
        desc = desc:gsub("You have studied the 'remains' of an greater or ultimate hethugoroth, providing new ideas for ways to annihilate with heat.","你研究了一个大型或终极赫斯格鲁斯的“遗骸”。这为你如何用热歼灭敌人提供了新的思路。")
        desc = desc:gsub("The impressive Automated Defense System remains will prove very useful to create automated and self-deploying constructs.", "这种令人印象深刻的自动防御系统的残骸，对制造可以自动部署的自动化机械十分有用。")
        return desc
    end
}