local _M = loadPrevious(...)

------------------------------------------------------------------
-- Yetis' powers
------------------------------------------------------------------

registerTalentTranslation{
	id = "T_ALGID_RAGE",
	name = "寒冰之怒",
	info = function(self, t)
		return ([[你的雪人早已适应寒冷的环境。
		在 5 回合中你造成的所有伤害都有 %d%% 几率把目标冻在冰块中 3 回合。
		在霜寒暴怒生效中你可以轻松的穿透冰块，减少 50%% 他们所吸收的伤害。
		数值会随着你的意志提升。]]):
		format(t.getPower(self, t))
	end,}

registerTalentTranslation{
	id = "T_THICK_FUR",
	name = "厚实毛皮",
	info = function(self, t)
		return ([[你厚实的雪人毛皮能像盾牌一样保护你，为你提供 %d%% 寒冷抗性， %d%% 物理抗性和 %d 魔法豁免。.]]):
		format(t.getCResist(self, t), t.getPResist(self, t), t.getSave(self, t))
	end,}

registerTalentTranslation{
	id = "T_RESILIENT_BODY",
	name = "坚韧身躯",
	info = function(self, t)
		return ([[你的雪人身躯面对负面状态十分坚韧。
		每当你被一个负面的物理，魔法或精神状态击中时，你的身体会反射性地触发恢复之力。
		这个效果会治疗你 %d 生命值，且每回合最多触发 3 次。
		治疗值会随着你的体质增加。]]):
		format(t.heal(self, t))
	end,}

registerTalentTranslation{
	id = "T_MINDWAVE",
	name = "脑波冲击",
	info = function(self, t)
		return ([[你自主地将你的雪人大脑的一小部分烧熟，以此来在半径 %d 码的锥形里释放一发强大的精神冲击。		
		任何陷入精神冲击的敌人都会受到 %0.2f 精神伤害并被混乱（35%% 强度） %d 回合。
		伤害会随着你的体质增加，应用强度则为你物理，法术，精神强度中的最高者。]]):
		format(t.radius, t.getDamage(self, t), t.getDur(self, t))
	end,}

------------------------------------------------------------------
-- Whitehooves' powers
------------------------------------------------------------------
registerTalentTranslation{
	id = "T_WHITEHOOVES",
	name = "白蹄",
	info = function(self, t)
		return ([[强化你的死灵身躯，增加 %d 的力量和魔力。
		每次你移动时都会获得 1 层（最多 %d 层）死亡波纹，提升 20%% 你的移动速度。
		如果回合内你没有移动，那么你会失去一层死亡波纹。]])
		:format(t.statBonus(self, t), self:getTalentLevelRaw(t) + (self.DM_Bonus or 0))
	end,}

registerTalentTranslation{
	id = "T_DEAD_HIDE",
	name = "亡者之皮",
	info = function(self, t)
		return ([[你的死灵皮肤在重压之下会变得更加坚硬。每层死亡波纹都会提供 %d 的伤害减免。	]]):
		format(t.getFlatResist(self, t))
	end,}

registerTalentTranslation{
	id = "T_LIFELESS_RUSH",
	name = "无生突袭",
	info = function(self, t)
		return ([[你唤起你的死灵之力，瞬间获得最大层数的死亡波纹。
		死亡波纹只会在 %d 回合后开始衰减。
		除此之外，每层死亡波纹还会提供 +%d%% 的全部伤害。]]):
		format(t.getDur(self, t), t.getDam(self, t))
	end,}

registerTalentTranslation{
	id = "T_ESSENCE_DRAIN",
	name = "吸取精华",
	info = function(self, t)
		return ([[你对你的敌人释放出一波黑暗能量，造成 %0.2f 暗影伤害。
		黑暗会吸取他的一部分生命精华（只对活着的目标有效）来延长死亡波纹在消耗下一层前的持续时间 %d 回合。
		只能在你有死亡波纹的时候使用。
		伤害会随着你的魔力增长。]]):
		format(t.getDamage(self, t), t.getDur(self, t))
	end,}

return _M