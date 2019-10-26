module(..., package.seeall)
_M.escortType = {}
_M.escortReward = {}
local copytable_safe = require("data-chn123.utils").copytable_safe
function registerEscortType(t)
    assert(t.name)
    _M.escortType[t.name] = t
end
function registerEscortReward(t)
    table.insert(_M.escortReward, t)
end

registerEscortType{
    name = "lost warrior",
    chnName = "迷路的战士",
    text = "帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过我打了太多仗，恐怕靠我自己是到不了那里了，你能帮我一下吗？",
    ["actor.desc"] = "他看起来又累又饿，且身受重伤。"
}

registerEscortType{
    name = "injured seer",
    chnName = "受伤的先知",
    text = "帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过我打了太多仗，恐怕靠我自己是到不了那里了，你能帮我一下吗？",
    ["actor.desc"] = "她看起来又累又饿，且身受重伤。"
}

registerEscortType{
    name = "repented thief",
    chnName = "忏悔的盗贼",
    text = "帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过我打了太多仗，恐怕靠我自己是到不了那里了，你能帮我一下吗？",
    ["actor.desc"] = "他看起来又累又饿，且身受重伤。"
}

registerEscortType{
    name = "lone alchemist",
    chnName = "落单的炼金术师",
    text = "帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过我打了太多仗，恐怕靠我自己是到不了那里了，你能帮我一下吗？",
    ["actor.desc"] = "他看起来又累又饿，且身受重伤。"
}

registerEscortType{
    name = "lost sun paladin",
    chnName = "迷路的太阳骑士",
    text = "帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过我打了太多仗，恐怕靠我自己是到不了那里了，你能帮我一下吗？",
    ["actor.desc"] = "她看起来又累又饿，且身受重伤。"
}

registerEscortType{
    name = "lost defiler",
    chnName = "迷路的堕落者",
    text = "帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过我打了太多仗，恐怕靠我自己是到不了那里了，你能帮我一下吗？",
    ["actor.desc"] = "她看起来又累又饿，且身受重伤。"
}

registerEscortType{
    name = "temporal explorer",
    chnName = "时空探索者",
    text = [[呃……你是……另一个我吗？
好吧，我是对的，这已经不是我本来的时间线了！
帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过我打了太多仗恐怕靠我自己是到不了那里了，你能帮我……呃……你自己一下吗？]],
    ["actor.desc"] = "她看起来又累又饿，且身受重伤。她跟你是如此的相像，但完全不一样。好奇怪。"
}

registerEscortType{
    name = "worried loremaster",
    chnName = "担忧的贤者",
    text = "帮帮我！我在这地方迷路了，我有个朋友给我留下了一个传送门，不过我打了太多仗，恐怕靠我自己是到不了那里了，你能帮我一下吗？",
    ["actor.desc"] = "她看起来又累又饿，且身受重伤。"
}

registerEscortType{
    name = "lost tinker",
    altName = "experimenting tinker",
    chnName = "实验的工匠",
    text = "帮帮我！我在测试某种蒸汽科技，结果在这地方迷路了。我有个朋友给我留下了一个传送门，不过我打了太多仗，恐怕靠我自己是到不了那里了，你能帮我一下吗？",
    ["actor.desc"] = "她看起来又累又饿，且身受重伤。"
}
registerEscortReward{
--    ["reward_types.steamtech.special.desc"] = "[问她哪里可以学到她的技术]",
--    ["reward_types.steamtech.special.tooltip"] = "揭示她老师的位置。",
    ["reward_types.steamtech.special"] ={
        {
            ["desc"] = "[问她哪里可以学到她的技术]",
            ["tooltip"] = "揭示她老师的位置。"
        }
    }
}
function _M.replaceEscortName(data)
    local data = data
    for _, t in pairs(_M.escortType) do
        data = data:gsub(t.name, t.chnName)
        if t.altName then
            data = data:gsub(t.altName, t.chnName)
        end
    end
    return data
end
function hookEscortAssign(self, data)
    for _, v in ipairs(data.possible_types) do
        if _M.escortType[v.name] then
            local t = _M.escortType[v.name]
            copytable_safe(v, t)
            v.actor.name = v.actor.name:gsub("the " .. t.name, t.chnName)
            v.actor.name = v.actor.name:gsub(t.name, t.chnName)
            if t.altName then
                v.actor.name = v.actor.name:gsub("the " .. t.altName, t.chnName)
            end
        end
    end
end
function hookEscortReward(self, data)
    for _, v in ipairs(_M.escortReward) do
        copytable_safe(data, v)
    end
end
function _M:bindHooks()
    local class = require "engine.class"
    class:bindHook("Quest:escort:assign", hookEscortAssign)
    class:bindHook("Quest:escort:reward", hookEscortReward)
end

return _M