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

newTalent{
	name = "Dark Ritual",
	type = {"corruption/blight", 1},
	mode = "sustained",
	require = corrs_req1,
	points = 5,
	tactical = { ATTACK = 2 },
	sustain_vim = 20,
	cooldown = 30,
	activate = function(self, t)
		game:playSoundNear(self, "talents/slime")
		local ret = {
			per = self:addTemporaryValue("combat_critical_power", self:combatTalentSpellDamage(t, 20, 60)),
		}
		return ret
	end,
	deactivate = function(self, t, p)
		self:removeTemporaryValue("combat_critical_power", p.per)
		return true
	end,
	info = function(self, t)
		return ([[增 加 %d%% 法 术 暴 击 倍 率。 
		 受 法 术 强 度 影 响， 倍 率 有 额 外 加 成。]]):
		format(self:combatTalentSpellDamage(t, 20, 60))
	end,
}

newTalent{
	name = "Corrupted Negation",
	type = {"corruption/blight", 2},
	require = corrs_req2,
	points = 5,
	cooldown = 10,
	vim = 30,
	range = 10,
	radius = 3,
	tactical = { ATTACKAREA = {BLIGHT = 1}, DISABLE = 2 },
	requires_target = true,
	target = function(self, t)
		return {type="ball", radius=self:getTalentRadius(t), range=self:getTalentRange(t), talent=t}
	end,
	getRemoveCount = function(self, t) return math.floor(self:combatTalentScale(t, 1, 5, "log")) end,
	action = function(self, t)
		local tg = self:getTalentTarget(t)
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		local dam = self:spellCrit(self:combatTalentSpellDamage(t, 28, 120))
		local nb = t.getRemoveCount(self,t)
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end

			DamageType:get(DamageType.BLIGHT).projector(self, px, py, DamageType.BLIGHT, dam)

			local effs = {}

			-- Go through all spell effects
			for eff_id, p in pairs(target.tmp) do
				local e = target.tempeffect_def[eff_id]
				if e.type == "magical" or e.type == "physical" then
					effs[#effs+1] = {"effect", eff_id}
				end
			end

			-- Go through all sustained spells
			for tid, act in pairs(target.sustain_talents) do
				if act then
					effs[#effs+1] = {"talent", tid}
				end
			end

			for i = 1, nb do
				if #effs == 0 then break end
				local eff = rng.tableRemove(effs)

				if self:checkHit(self:combatSpellpower(), target:combatSpellResist(), 0, 95, 5) then
					target:crossTierEffect(target.EFF_SPELLSHOCKED, self:combatSpellpower())
					if eff[1] == "effect" then
						target:removeEffect(eff[2])
					else
						target:forceUseTalent(eff[2], {ignore_energy=true})
					end
				end
			end
		end)
		local _ _, x, y = self:canProject(tg, x, y)
		game.level.map:particleEmitter(x, y, tg.radius, "circle", {zdepth=6, oversize=1, a=130, appear=8, limit_life=8, speed=5, img="green_demon_fire_circle", radius=tg.radius})
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[在 3 码 球 形 范 围 内 制 造 一 个 堕 落 能 量 球， 造 成 %0.2f 枯 萎 伤 害 并 移 除 范 围 内 任 意 怪 物 至 多 %d 种 魔 法 或 物 理 效 果。 
		 每 除 去 一 个 效 果 时， 基 于 法 术 豁 免， 目 标 都 有 一 定 概 率 抵 抗。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成。]]):format(damDesc(self, DamageType.BLIGHT, self:combatTalentSpellDamage(t, 28, 120)), t.getRemoveCount(self, t))
	end,
}

newTalent{
	name = "Corrosive Worm",
	type = {"corruption/blight", 3},
	require = corrs_req3,
	points = 5,
	cooldown = 10,
	vim = 12,
	range = 10,
	tactical = { ATTACK = {ACID = 2} },
	requires_target = true,
	action = function(self, t)
		local tg = {type="hit", range=self:getTalentRange(t), talent=t}
		local x, y = self:getTarget(tg)
		if not x or not y then return nil end
		self:project(tg, x, y, function(px, py)
			local target = game.level.map(px, py, Map.ACTOR)
			if not target then return end
			target:setEffect(target.EFF_CORROSIVE_WORM, 10, {src=self, dam=self:spellCrit(self:combatTalentSpellDamage(t, 10, 60)), explosion=self:spellCrit(self:combatTalentSpellDamage(t, 10, 230))})
		end)
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[用 腐 蚀 蠕 虫 感 染 目 标， 每 回 合 造 成 %0.2f 酸 性 伤 害， 持 续 10 回 合。 
		 如 果 蠕 虫 在 目 标 体 内 时， 目 标 死 亡， 则 会 产 生 酸 性 爆 炸， 在 4 码 半 径 范 围 内 造 成 %0.2f 酸 性 伤 害。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成， 并 且 该 技 能 可 暴 击。]]):
		format(damDesc(self, DamageType.ACID, self:combatTalentSpellDamage(t, 10, 60)), damDesc(self, DamageType.ACID, self:combatTalentSpellDamage(t, 10, 230)))
	end,
}

newTalent{
	name = "Poison Storm",
	type = {"corruption/blight", 4},
	require = corrs_req4,
	points = 5,
	vim = 36,
	cooldown = 30,
	range = 0,
	radius = 4,
	tactical = { ATTACKAREA = {NATURE = 2} },
	target = function(self, t)
		return {type="ball", range=self:getTalentRange(t), radius=self:getTalentRadius(t)}
	end,
	getDuration = function(self, t) return math.floor(self:combatTalentScale(t, 6, 10)) end,
	action = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		local dam = self:spellCrit(self:combatTalentSpellDamage(t, 12, 130))
		local actor = self
		-- Add a lasting map effect
		game.level.map:addEffect(self,
			self.x, self.y, duration,
			DamageType.POISON, {dam=dam, apply_power=actor:combatSpellpower()},
			radius,
			5, nil,
			MapEffect.new{color_br=20, color_bg=220, color_bb=70, effect_shader="shader_images/poison_effect.png"},
			function(e)
				e.x = e.src.x
				e.y = e.src.y
				return true
			end,
			false
		)
		game:playSoundNear(self, "talents/slime")
		return true
	end,
	info = function(self, t)
		return ([[一 股 强 烈 的 剧 毒 风 暴 围 绕 着 施 法 者， 半 径 %d 持 续 %d 回 合。风 暴 内 的 生 物 将 进 入 中 毒 状 态 ，受 到 共 计 %0.2f 的 自 然 伤 害。 
		 毒 性 是 可 以 叠 加 的， 它 们 在 剧 毒 风 暴 里 待 的 时 间 越 长， 它 们 受 到 的 毒 素 伤 害 越 高。 
		 受 法 术 强 度 影 响， 伤 害 有 额 外 加 成， 并 且  可 暴 击。]]):
		format(self:getTalentRadius(t), t.getDuration(self, t), damDesc(self, DamageType.NATURE, self:combatTalentSpellDamage(t, 12, 130)))
	end,
}

