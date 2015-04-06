-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2015 Nicolas Casalini
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

newBirthDescriptor{
	type = "class",
	name = "Adventurer",
	display_name = " 冒险家 ",
	locked = function() return profile.mod.allow_build.adventurer and true or "hide"  end,
	desc = {
		"    冒 险 家 可 以 学 习 很 多 技 能， 他 们 可 以 学 习 任 何 碰 巧 发 现 的 技 能。 ",
		"#{bold}# 这 是 通 关 后 获 得 的 奖 励 职 业， 显 然 它 绝 对 是 不 平 衡 的。 #{normal}#",
	},
	descriptor_choices =
	{
		subclass =
		{
			__ALL__ = "disallow",
			Adventurer = "allow",
		},
	},
	copy = {
		mana_regen = 0.25,
		max_life = 100,
	},
}

newBirthDescriptor{
	type = "subclass",
	name = "Adventurer",
	display_name = " 冒 险 家 ",
	locked = function() return profile.mod.allow_build.adventurer and true or "hide"  end,
	desc = {
		" 冒 险 家 可 以 学 习 很 多 技 能， 他 们 可 以 学 习 任 何 碰 巧 发 现 的 技 能。 ",
		"#{bold}# 这 是 通 关 后 获 得 的 奖 励 职 业， 显 然 它 是 绝 不 平 衡 的。 #{normal}#",
		" 他 们 的 职 业 倾 向 决 定 了 他 们 的 主 属 性。 ",
		"#GOLD# 属 性 修 正： ",
		"#LIGHT_BLUE# * +2 力 量 , +2 敏 捷 , +2 体 质 ",
		"#LIGHT_BLUE# * +2 魔 法 , +2 意 志 , +2 灵 巧 ",
		"#GOLD# 每 等 级 生 命 加 值： #LIGHT_BLUE# +0",
	},
	not_on_random_boss = true,
	stats = { str=2, con=2, dex=2, mag=2, wil=2, cun=2 },
	talents_types = function(birth)
		local tts = {}
		for _, class in ipairs(birth.all_classes) do
			for _, sclass in ipairs(class.nodes) do if sclass.id ~= "Adventurer" and sclass.def and not sclass.def.not_on_random_boss then
				if birth.birth_descriptor_def.subclass[sclass.id].talents_types then
					local tt = birth.birth_descriptor_def.subclass[sclass.id].talents_types
					if type(tt) == "function" then tt = tt(birth) end

					for t, _ in pairs(tt) do
						tts[t] = {false, 0}
					end
				end

				if birth.birth_descriptor_def.subclass[sclass.id].unlockable_talents_types then
					local tt = birth.birth_descriptor_def.subclass[sclass.id].unlockable_talents_types
					if type(tt) == "function" then tt = tt(birth) end

					for t, v in pairs(tt) do
						if profile.mod.allow_build[v[3]] then
							tts[t] = {false, 0}
						end
					end
				end
			end end
		end
		return tts
	end,
	copy_add = {
		unused_generics = 2,
		unused_talents = 3,
		unused_talents_types = 7,
	},
	copy = {
		resolvers.inventorybirth{ id=true, transmo=true,
			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="dagger", name="iron dagger", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="longsword", name="iron longsword", ego_chance=-1000, ego_chance=-1000},
			{type="weapon", subtype="longsword", name="iron longsword", ego_chance=-1000, ego_chance=-1000},
			{type="weapon", subtype="staff", name="elm staff", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="mindstar", name="mossy mindstar", autoreq=true, ego_chance=-1000},
			{type="armor", subtype="hands", name="iron gauntlets", autoreq=true, ego_chance=-1000, ego_chance=-1000},
			{type="armor", subtype="hands", name="rough leather gloves", ego_chance=-1000, ego_chance=-1000},
			{type="armor", subtype="light", name="rough leather armour", ego_chance=-1000, ego_chance=-1000},
			{type="armor", subtype="cloth", name="linen robe", autoreq=true, ego_chance=-1000},
			{type="scroll", subtype="rune", name="manasurge rune", ego_chance=-1000, ego_chance=-1000},
			{type="weapon", subtype="longbow", name="elm longbow", autoreq=true, ego_chance=-1000},
			{type="ammo", subtype="arrow", name="quiver of elm arrows", autoreq=true, ego_chance=-1000},
			{type="weapon", subtype="sling", name="rough leather sling", autoreq=true, ego_chance=-1000},
			{type="ammo", subtype="shot", name="pouch of iron shots", autoreq=true, ego_chance=-1000},
		},
		chooseCursedAuraTree = true,
	},
}
