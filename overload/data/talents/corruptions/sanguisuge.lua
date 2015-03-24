-- ToME - Tales of Maj'Eyal
-- Copyright (C) 2009 - 2014 Nicolas Casalini
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

newTalent{
	name = "Drain",
	type = {"corruption/sanguisuge", 1},
	require = corrs_req1,
	points = 5,
	vim = 0,
	cooldown = 9,
	reflectable = true,
	proj_speed = 15,
	tactical = { ATTACK = {BLIGHT = 2}, VIM = 2 },
	requires_target = true,
	range = function(self, t) return math.floor(self:combatTalentScale(t, 5, 9)) end,
	action = function(self, t)
		local tg = {type="bolt", range=self:getTalentRange(t), talent=t, display={particle="bolt_slime"}}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:projectile(tg, x, y, DamageType.DRAIN_VIM, self:spellCrit(self:combatTalentSpellDamage(t, 25, 200)), {type="slime"})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[射 出 1 枚 枯 萎 之 球， 对 目 标 造 成 %0.2f 枯 萎 伤 害。 同 时 补 充 20%% 伤 害 值 作 为 活 力。 
		 活 力 回 复 量 受 目 标 分 级 影 响（ 高 级 怪 提 供 更 多 活 力）。 
		 受 法 术 强 度 影 响， 效 果 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 25, 200)))
	end,
}

--[[
newTalent{
	name = "Blood Sacrifice",
	type = {"corruption/sanguisuge", 2},
	require = corrs_req2,
	points = 5,
	vim = 0,
	cooldown = 30,
	range = 10,
	tactical = { VIM = 1 },
	action = function(self, t)
		local amount = self.life * 0.5
		if self.life <= amount + 1 then
			game.logPlayer(self, "Doing this would kill you.")
			return
		end

		local seen = false
		-- Check for visible monsters, only see LOS actors, so telepathy wont prevent resting
		core.fov.calc_circle(self.x, self.y, game.level.map.w, game.level.map.h, 20, function(_, x, y) return game.level.map:opaque(x, y) end, function(_, x, y)
			local actor = game.level.map(x, y, game.level.map.ACTOR)
			if actor and self:reactionToward(actor) < 0 and self:canSee(actor) and game.level.map.seens(x, y) then
				seen = {x=x,y=y,actor=actor}
			end
		end, nil)
		if not seen then
			game.logPlayer(self, "There are no foes in sight.")
			return
		end

		self:incVim(30 + self:combatTalentSpellDamage(t, 5, 150))
		self:takeHit(amount, self)
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([=[Sacrifices 50%% of your current life to restore %d vim.
		This only works if there is at least one foe in sight.
		The effect will increase with your Magic stat.]=]):
		format(30 + self:combatTalentSpellDamage(t, 5, 150))
	end,
}
]]
newTalent{
	name = "Bloodcasting",
	type = {"corruption/sanguisuge", 2},
	require = corrs_req2,
	points = 5,
	vim = 0,
	cooldown = 18,
	no_energy = true,
	range = 10,
	no_npc_use = true,
	getDuration = function(self, t) return math.floor(self:combatTalentLimit(t, 18, 3, 7)) end, --Limit duration < 18
	action = function(self, t)
		self:setEffect(self.EFF_BLOODCASTING, t.getDuration(self,t), {})
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[当 法 术 消 耗 大 于 你 当 前 的 活 力 值 时， 你 的 堕 落 系 法 术 会 用 生 命 代 替 活 力 被 消 耗， 持 续 %d 回 合。]]):
		format(t.getDuration(self,t))
	end,
}

newTalent{
	name = "Absorb Life",
	type = {"corruption/sanguisuge", 3},
	mode = "sustained",
	require = corrs_req3,
	points = 5,
	sustain_vim = 5,
	cooldown = 30,
	range = 10,
	tactical = { BUFF = 2 },
	VimOnDeath = function(self, t) return self:combatTalentScale(t, 6, 16) end,
	activate = function(self, t)
		game:playSoundNear(self, "talents/spell_generic2")
		local ret = {
			vim_regen = self:addTemporaryValue("vim_regen", -0.5),
			vim_on_death = self:addTemporaryValue("vim_on_death", t.VimOnDeath(self, t)),
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("vim_regen", p.vim_regen)
		self:removeTemporaryValue("vim_on_death", p.vim_on_death)
		return true
	end,
	info = function(self, t)
		return ([[当 你 杀 死 敌 人 时， 你 会 吸 收 目 标 生 命。 
		 当 此 技 能 激 活 时， 每 回 合 会 消 耗 0.5 点 活 力； 当 你 杀 死 一 个 非 不 死 族 单 位 时， 会 获 得 %0.1f 点 活 力（ 此 外 自 然 增 长 受 意 志 影 响）。]]):
		format(t.VimOnDeath(self, t))
	end,
}

newTalent{
	name = "Life Tap",
	type = {"corruption/sanguisuge", 4},
	require = corrs_req4,
	points = 5,
	vim = 40,
	cooldown = 20,
	range = 10,
	no_energy = true,
	tactical = { BUFF = 2 },
	getMult = function(self,t) return self:combatTalentScale(t, 8, 16) end,
	action = function(self, t)
		self:setEffect(self.EFF_LIFE_TAP, 7, {power=t.getMult(self,t)})
		game:playSoundNear(self, "talents/spell_generic2")
		return true
	end,
	info = function(self, t)
		return ([[解 除 生 命 的 限 制 获 得 强 大 的 力 量， 增 加 %0.1f%% 所 有 伤 害， 持 续 7 回 合。]]):
		format(t.getMult(self,t))
	end,
}
