-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009, 2010, 2011, 2012, 2013 Nicolas Casalini
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.
--
-- Nicolas Casalini "DarkGod"
-- darkgod@te4.org

local delivered_staff = game.player:resolveSource():isQuestStatus("staff-absorption", engine.Quest.COMPLETED, "survived-ukruk")

if delivered_staff then
return [[@playername@， 这 份 报 告 极 其 重 要。 

 你 留 在 最 后 的 希 望 的 法 杖 不 见 了， 一 群 兽 人 发 动 了 突 然 袭 击， 守 卫 被 他 们 传 送 到 了 一 个 密 室 内 干 掉。 
 我 们 的 部 队 设 法 追 上 了 其 中 的 一 个 兽 人， 并 强 迫 他 开 了 口。 
 他 知 道 的 不 多， 但 他 提 到 了 远 东 大 陆 的 “ 主 人 ”。 
 他 提 到 了 高 尔 布 格， 貌 似 是 瑞 库 纳 的 一 个 战 士 头 领， 带 队 将 一 个 神 秘 的 包 裹 穿 过 了 传 送 门。 

 事 情 非 常 紧 急， 请 你 调 查 一 下 这 个 高 尔 布 格 或 者 传 送 门。 

               #GOLD#-- 托 拉 克， 联 合 王 国 国 王。 ]]

else

return [[@playername@， 这 份 报 告 极 其 重 要。 

 我 们 的 长 老 从 古 老 文 献 中 查 找 你 提 到 的 那 个 法 杖 的 线 索。 
 它 的 确 是 一 件 非 常 强 大 的 神 器， 它 可 以 从 周 边 物 体 和 生 物 身 上 吸 收 能 量。 
 所 以 它 绝 对 不 能 落 入 坏 人 的 手 中， 很 显 然 包 括 兽 人。 
 你 不 在 的 时 候， 我 们 的 一 个 巡 逻 队 遭 遇 了 乌 克 鲁 克 带 领 的 一 个 小 分 队， 
 我 们 没 法 阻 止 他 们， 不 过 我 们 抓 了 他 们 中 的 一 个。 

 他 知 道 的 不 多， 但 他 提 到 了 远 东 大 陆 的 “ 主 人 ”。 
 他 提 到 了 高 尔 布 格， 貌 似 是 瑞 库 纳 的 一 个 战 士 头 领， 带 队 将 一 个 神 秘 的 包 
 裹 穿 过 了 传 送 门。 

               #GOLD#-- 托 拉 克， 联 合 王 国 国 王。 ]]
end