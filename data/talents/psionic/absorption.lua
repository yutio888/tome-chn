local Talents = require "engine.interface.ActorTalents"
local damDesc = Talents.main_env.damDesc
local DamageType = require "engine.DamageType"


local function getShieldStrength(self, t)
	--return math.max(0, self:combatMindpower())
	return self:combatTalentMindDamage(t, 20, 100)
end

local function getEfficiency(self, t)
	return self:combatTalentLimit(t, 100, 20, 55)/100 -- Limit to <100%
end

local function maxPsiAbsorb(self, t) -- Max psi/turn to prevent runaway psi gains (solipsist randbosses)
	return 2 + self:combatTalentScale(t, 0.3, 1)
end

local function shieldMastery(self, t)
	return 100-self:combatTalentMindDamage(t, 40, 50)
end

local function kineticElement(self, t, damtype)
	if damtype == DamageType.PHYSICAL or damtype == DamageType.ACID or damtype == DamageType.NATURE or damtype == DamageType.TEMPORAL then return true end
	return false
end

local function thermalElement(self, t, damtype)
	if damtype == DamageType.FIRE or damtype == DamageType.COLD or damtype == DamageType.LIGHT or damtype == DamageType.ARCANE then return true end
	return false
end

local function chargedElement(self, t, damtype)
	if damtype == DamageType.LIGHTNING or damtype == DamageType.BLIGHT or damtype == DamageType.DARKNESS or damtype == DamageType.MIND then return true end
	return false
end

local function shieldAbsorb(self, t, p, absorbed)
	local cturn = math.floor(game.turn / 10)
	if cturn ~= p.last_absorbs.last_turn then
		local diff = cturn - p.last_absorbs.last_turn
		for i = 2, 0, -1 do
			local ni = i + diff
			if ni <= 2 then
				p.last_absorbs.values[ni] = p.last_absorbs.values[i]
			end
			p.last_absorbs.values[i] = nil
		end
	end
	p.last_absorbs.values[0] = (p.last_absorbs.values[0] or 0) + absorbed
	p.last_absorbs.last_turn = cturn
end

local function shieldSpike(self, t, p)
	local val = 0
	for i = 0, 2 do val = val + (p.last_absorbs.values[i] or 0) end
	if val > 0 then self:setEffect(self.EFF_PSI_DAMAGE_SHIELD, 5, {power=val*2}) end
end

local function shieldOverlay(self, t, p)
	local val = 0
	for i = 0, 2 do val = val + (p.last_absorbs.values[i] or 0) end
	if val <= 0 then return "" end
	local fnt = "buff_font_small"
	if val >= 1000 then fnt = "buff_font_smaller" end
	return tostring(math.ceil(val)), fnt
end

local function shieldOnDamage(self, t, elementTest, transcendId, dam)
	if not elementTest then return dam end
	local shield = self:isTalentActive(t.id)
	if shield.game_turn + 10 <= game.turn then
		shield.psi_gain = 0
		shield.game_turn = game.turn
	end
	local mast = shieldMastery(self, t)
	local total_dam = dam
	local absorbable_dam = getEfficiency(self, t) * total_dam
	local strength = getShieldStrength(self, t)
	if self:hasEffect(transcendId) then
		absorbable = total_dam
		strength = strength * 2
	end
	local guaranteed_dam = total_dam - absorbable_dam
	dam = absorbable_dam

	local psigain = 0
	if dam <= strength then
		psigain = 1 + dam/mast
		shieldAbsorb(self, t, shield, dam)
		dam = 0
	else
		psigain = 1 + strength/mast
		dam = dam - strength
		shieldAbsorb(self, t, shield, strength)
	end
	psigain = math.min(maxPsiAbsorb(self, t) - shield.psi_gain, psigain)
	shield.psi_gain = shield.psi_gain + psigain
	self:incPsi(psigain)

	return dam + guaranteed_dam
end

local function adjustShieldGFX(self, t, v, p, r, g, b)
	if not p then p = self:isTalentActive(t.id) end
	if not p then return end
	self:removeParticles(p.particle)
	if v then
		if core.shader.active(4) then p.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.4, img="shield5"},
			{type="runicshield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=7, bubbleColor={r, g, b, 0.6}, auraColor={r, g, b, 1}}))
		else p.particle = self:addParticles(Particles.new("generic_shield", 1, {r=r, g=g, b=b, a=1}))
		end
	else
		if core.shader.active(4) then p.particle = self:addParticles(Particles.new("shader_shield", 1, {size_factor=1.1, img="shield5"},
			{type="shield", ellipsoidalFactor=1, time_factor=-10000, llpow=1, aadjust=3, color={r, g, b}}))
		else p.particle = self:addParticles(Particles.new("generic_shield", 1, {r=r, g=g, b=b, a=0.5}))
		end
	end
end
Talents.talents_def.T_KINETIC_SHIELD.name= "动能护盾"
Talents.talents_def.T_KINETIC_SHIELD.info= function(self, t)
		local s_str = getShieldStrength(self, t)
		local absorb = 100*getEfficiency(self,t)
		return ([[用 护 盾 环 绕 自 己 ，吸 收  %d%%  物 理 、酸 性 、自 然 、时 空 伤 害 ，每 次 最 多 吸 收 %d 伤 害 。
		每 次 你 的 护 盾 吸 收 伤 害 时，将 部 分 伤 害 转 化 为 能 量 ，获 得 两 点 超 能 力 值 ，每 吸 收 %0.1f 点 伤 害 额 外 增 加 一 点 超 能 力 值 ，每 回 合 最 多 增 加 %0.1f 点 超 能 力 值 。
		等 级 3 时 ，  当 你 关 掉 护 盾 ，前 3 回 合 内 吸 收 的 全 部 伤 害 值 的 两 倍 将 被 释 放 成 为 一 个 完 整 的 超 能 力 护 盾 （吸 收 完 整 伤 害 ）
		护 盾 的 吸 收 值 和 获 得 超 能 力 值 的 效 率 随 精 神 强 度 增 强 。]]):
		format(absorb, s_str, shieldMastery(self, t), maxPsiAbsorb(self,t))
	end
Talents.talents_def.T_THERMAL_SHIELD.name= "热能护盾"
Talents.talents_def.T_THERMAL_SHIELD.info= function(self, t)
		local s_str = getShieldStrength(self, t)
		local absorb = 100*getEfficiency(self,t)
		return ([[用 护 盾 环 绕 自 己 ，吸 收  %d%%  火 焰 、寒 冷 、光 系 、奥 术 伤 害 ，每 次 最 多 吸 收 %d 伤 害 。
		每 次 你 的 护 盾 吸 收 伤 害 时，将 部 分 伤 害 转 化 为 能 量 ，获 得 两 点 超 能 力 值 ，每 吸 收 %0.1f 点 伤 害 额 外 增 加 一 点 超 能 力 值 ，每 回 合 最 多 增 加 %0.1f 点 超 能 力 值 。
		等 级 3 时 ，  当 你 关 掉 护 盾 ，前 3 回 合 内 吸 收 的 全 部 伤 害 值 的 两 倍 将 被 释 放 成 为 一 个 完 整 的 超 能 力 护 盾 （吸 收 完 整 伤 害 ）
		护 盾 的 吸 收 值 和 获 得 超 能 力 值 的 效 率 随 精 神 强 度 增 强 。]]):
		format(absorb, s_str, shieldMastery(self, t), maxPsiAbsorb(self,t))
	end
Talents.talents_def.T_CHARGED_SHIELD.name= "电能护盾"
Talents.talents_def.T_CHARGED_SHIELD.info= function(self, t)
		local s_str = getShieldStrength(self, t)
		local absorb = 100*getEfficiency(self,t)
		return ([[用 护 盾 环 绕 自 己 ，吸 收  %d%%  闪 电 、枯 萎 、暗 影 、精 神 伤 害  , 每 次 最 多 吸 收 %d 伤 害 。
每 次 你 的 护 盾 吸 收 伤 害 ，将 其 部 分 转 化 为 能 量 ，获 得 两 点 能 量 ，每 吸 收 %0.1f 点 伤 害 额 外 增 加 一 点 能 量 ，每 回 合 最 多 增 加 %0.1f 点 能 量 。
等 级 3 时 ，  当 你 关 掉 护 盾 ，前 3 回 合 内 吸 收 的 全 部 伤 害 两 倍 将 被 释 放 成 为 一 个 完 整 的 超 能 力 护 盾 （吸 收 完 整 伤 害 ）
护 盾 的 吸 收 值 和 获 得 能 量 的 效 率 随 精 神 强 度 增 强 .]]):
		format(absorb, s_str, shieldMastery(self, t), maxPsiAbsorb(self,t))
	end
Talents.talents_def.T_FORCEFIELD.name= "超能力场"
Talents.talents_def.T_FORCEFIELD.info= function(self, t)
		return ([[用 力 场 环 绕 自 己 ，减 少 受 到 的 所 有 伤 害 %d%%
		维 持 这 样 的 护 盾 代 价 非 常 昂 贵 ，开 启 时 每 回 合 叠 加 消 耗 5%% 你 的 最 大 超 能 值 ，第 二 回 合 将 消 耗 10%% ，依 次 递 增 。]]):
		format(t.getResist(self,t))
	end

