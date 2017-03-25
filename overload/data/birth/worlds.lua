-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2017 Nicolas Casalini
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

local default_eyal_descriptors = function(add)
	local base = {

	race =
	{
		__ALL__ = "disallow",
		Human = "allow",
		Elf = "allow",
		Dwarf = "allow",
		Halfling = "allow",
		Yeek = "allow",
		Giant = "allow",
		Undead = "allow",
		Construct = "allow",
	},

	class =
	{
		__ALL__ = "disallow",
		Psionic = "allow",
		Warrior = "allow",
		Rogue = "allow",
		Mage = "allow",
		Celestial = "allow",
		Wilder = "allow",
		Defiler = "allow",
		Afflicted = "allow",
		Chronomancer = "allow",
		Psionic = "allow",
		Adventurer = "allow",
	},
	subclass =
	{
		-- Nobody should be a sun paladin & anorithil but humans & elves
		['Sun Paladin'] = "nolore",
		Anorithil = "nolore",
		-- Nobody should be an archmage but human, elves, halflings and undeads
		Archmage = "nolore",
	},
}
	if add then table.merge(base, add) end
	return base
end
Birther.default_eyal_descriptors = default_eyal_descriptors

-- Player worlds/campaigns
newBirthDescriptor{
	type = "world",
	name = "Maj'Eyal",
	display_name = " 马 基 埃 亚 尔 : 卓 越 时 代 ",
	selection_default = config.settings.tome.default_birth and config.settings.tome.default_birth.campaign == "Maj'Eyal",
	desc =
	{
		"    马 基 埃 亚 尔 的 人： 人 类、 半 身 人 、 精 灵 和 矮 人 再 次 繁 荣 起 来， 世 界 已 经 保 持 了 超 过 一 百 年 的 和 平。 ",
		"    你 是 一 位 冒 险 者， 出 发 去 寻 找 失 落 的 宝 藏 和 荣 耀。 在 世 界 的 阴 影 之 下 究 竟 潜 伏 着 什 么 呢？ ",
	},
	descriptor_choices = default_eyal_descriptors{},
	game_state = {
		campaign_name = "maj-eyal",
		__allow_rod_recall = true,
		__allow_transmo_chest = true,
		grab_online_event_zone = function() return "wilderness-1" end,
		grab_online_event_spot = function(zone, level)
			local find = {type="world-encounter", subtype="maj-eyal"}
			local where = game.level:pickSpotRemove(find)
			while where and (game.level.map:checkAllEntities(where.x, where.y, "block_move") or not game.level.map:checkAllEntities(where.x, where.y, "can_encounter")) do where = game.level:pickSpotRemove(find) end
			local x, y = mod.class.Encounter:findSpot(where)
			return x, y
		end,
	},
}

newBirthDescriptor{
	type = "world",
	name = "Infinite",
	display_name = " 无 尽 地 下 城 ",
	locked = function() return profile.mod.allow_build.campaign_infinite_dungeon end,
	locked_desc = "    无 尽 深 度， 没 有 终 点， 没 有 重 复， 不 断 深 入， 在 古 老 的 废 墟 里， 穿 过 关 闭 的 大 门， 解 开 谜 题， 寻 找 你 的 宿 命。 ",
	selection_default = config.settings.tome.default_birth and config.settings.tome.default_birth.campaign == "Infinite",
	desc =
	{
		"    选 择 你 最 喜 欢 的 种 族 和 职 业， 进 入 无 尽 地 城 冒 险。 ",
		"    能 够 前 进 多 远 取 决 于 你 的 个 人 技 术！ ",
		"    在 无 尽 地 城 中 你 不 受 限 制， 你 可 以 突 破 50 级 的 等 级 上 限 并 继 续 获 得 属 性 和 天 赋 点 数（ 以 一 个 较 低 的 比 例 获 得）。 ",
		"    50 级 之 后 属 性 最 大 值 每 级 增 加 1 点。 ",
		"    50 级 之 后 每 10 级 每 个 天 赋 的 最 大 等 级 增 加 1 点。 ",
	},
	descriptor_choices = default_eyal_descriptors{ difficulty = { Tutorial = "never"} },
	copy = {
		-- Can levelup forever
		resolvers.generic(function(e) e.max_level = nil end),
		no_points_on_levelup = function(self)
			if self.level <= 50 then
				self.unused_stats = self.unused_stats + (self.stats_per_level or 3) + self:getRankStatAdjust()
				self.unused_talents = self.unused_talents + 1
				self.unused_generics = self.unused_generics + 1
				if self.level % 5 == 0 then self.unused_talents = self.unused_talents + 1 end
				if self.level % 5 == 0 then self.unused_generics = self.unused_generics - 1 end

				if self.extra_talent_point_every and self.level % self.extra_talent_point_every == 0 then self.unused_talents = self.unused_talents + 1 end
				if self.extra_generic_point_every and self.level % self.extra_generic_point_every == 0 then self.unused_generics = self.unused_generics + 1 end

				if self.level == 10 or self.level == 20 or self.level == 36 or self.level == 46 then
					self.unused_talents_types = self.unused_talents_types + 1
				end
				if self.level == 30 or self.level == 42 then
					self.unused_prodigies = self.unused_prodigies + 1
				end
				if self.level == 50 then
					self.unused_stats = self.unused_stats + 10
					self.unused_talents = self.unused_talents + 3
					self.unused_generics = self.unused_generics + 3
				end
			else
				self.unused_stats = self.unused_stats + 1
				if self.level % 2 == 0 then
					self.unused_talents = self.unused_talents + 1
				elseif self.level % 3 == 0 then
					self.unused_generics = self.unused_generics + 1
				end
			end
		end,

		resolvers.equip{ id=true, {name="iron pickaxe", ego_chance=-1000}},
		-- Override normal stuff
		before_starting_zone = function(self)
			self.starting_level = 1
			self.starting_level_force_down = nil
			self.starting_zone = "infinite-dungeon"
			self.starting_quest = "infinite-dungeon"
			self.starting_intro = "infinite-dungeon"
		end,
	},
	game_state = {
		campaign_name = "infinite-dungeon",
		__allow_transmo_chest = true,
		is_infinite_dungeon = true,
		ignore_prodigies_special_reqs = true,
		grab_online_event_zone = function() return "infinite-dungeon-"..(game.level.level+rng.range(1,4)) end,
		grab_online_event_spot = function(zone, level)
			if not level then return end
			local x, y = game.state:findEventGrid(level)
			return x, y
		end,
	},
}

newBirthDescriptor{
	type = "world",
	name = "Arena",
	display_name = " 竞 技 场： 竞 技 之 王 的 挑 战 ",
	locked = function() return profile.mod.allow_build.campaign_arena end,
	locked_desc = "    血 溅 沙 场， 勇 者 生 存， 需 证 明 你 有 进 入 的 资 格。 ",
	selection_default = config.settings.tome.default_birth and config.settings.tome.default_birth.campaign == "Arena",
	desc =
	{
		"    孤 身 一 人 直 面 竞 技 场 的 挑 战！ ",
		"    你 可 以 使 用 任 何 职 业 和 种 族。 ",
		"    看 看 你 能 前 进 多 远！ 你 能 成 为 新 的 竞 技 场 冠 军 么？ ",
		"    如 果 这 样， 下 一 场 战 斗 你 的 对 手 就 是 你 自 己 的 冠 军 角 色！ ",
	},
	descriptor_choices = default_eyal_descriptors{ difficulty = { Tutorial = "never" }, permadeath = { Exploration = "never", Adventure = "never" } },
	copy = {
		death_dialog = "ArenaFinish",
		-- Override normal stuff
		before_starting_zone = function(self)
			self.starting_level = 1
			self.starting_level_force_down = nil
			self.starting_zone = "arena"
			self.starting_quest = "arena"
			self.starting_intro = "arena"
		end,
	},
	game_state = {
		campaign_name = "arena",
		is_arena = true,
		ignore_prodigies_special_reqs = true,
	},
}

