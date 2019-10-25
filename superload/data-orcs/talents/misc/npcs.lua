local _M = loadPrevious(...)
registerTalentTranslation{
	id = "T_PETRIFYING_GAZE",
	name = "石化凝视",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		return ([[凝视你的敌人并把他石化 %d 回合。
		被石化的生物不能行动，回血，并且非常脆弱。
		如果被石化的生物一次性受到了超过总生命值 30%% 的伤害，那么他会破碎并死去。
		被石化的生物对火焰和闪电有着很高的抗性，并对物理攻击有着一定的抗性。]]):
		format(duration)
	end,}

registerTalentTranslation{
	id = "T_GNASHING_MAW",
	name = "撕咬",
	info = function(self, t)
		return ([[用你的武器攻击目标，造成 %d%% 伤害。如果攻击命中了，目标的命中会被降低 %d，持续 %d 回合。
		命中降低会随着你的物理强度增长。]])
		:format(
			100 * self:combatTalentWeaponDamage(t, 1, 1.5), 3 * self:getTalentLevel(t), t.getDuration(self, t))
	end,}

local sandtrap = nil
registerTalentTranslation{
	id = "T_SANDRUSH",
	name = "潜沙突袭",
	info = function(self, t)
		return ([[潜入沙中向距离你 %d 码的目标发起突袭攻击。
		在你的跃出点会出现最多 9 个持续 %d 回合（基于你的力量）的沙坑。
		你必须突袭至少 2 码。]]):format(t.range(self, t), t.duration(self, t))
	end,}

registerTalentTranslation{
	id = "T_RITCH_LARVA_INFECT",
	name = "里奇幼虫寄生",
	info = function(self, t)
		local dam = t.getDamage(self, t)
		local nb = t.getNb(self, t)
		local Pdam, Fdam = self:damDesc(DamageType.PHYSICAL, dam/2), self:damDesc(DamageType.FIRE, dam/2)
		return ([[用你的产卵器蜇目标一下，将 %d 个幼虫注入目标体内以完成他们的孵化流程。
		在一个 5 回合的发育周期内，幼虫们会以受害者的血肉为食，每回合造成 %0.2f 到 %0.2f 的物理伤害（随着他们的成长增多）。
		在发育期结束后，幼虫会从寄主体内钻出，每个幼虫造成 %0.2f 物理和 %0.2f 火焰伤害。
		]]):format(nb, nb*Pdam*2*.05, nb*Pdam*2*.25, Pdam, Fdam)
	end,}

registerTalentTranslation{
	id = "T_AMAKTHEL_SLUMBER",
	name = "沉睡中...",
	info = function(self, t)
		return ([[死神正在沉睡。起码现在是。]])
	end,}

registerTalentTranslation{
	id = "T_AMAKTHEL_TENTACLE_SPAWN",
	name = "衍生触手", 
	info = function(self, t)
		return ([[死神想要逗逗你……]])
	end,}

registerTalentTranslation{
	id = "T_CURSE_OF_AMAKTHEL",
	name = "阿马克泰尔的诅咒",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[创造一片诅咒之地（半径 %d 码） %d 回合。任何陷入其中的敌人都会被诅咒，任何他们新得到的负面状态的持续时间都会翻倍。
		]]):
		format(radius, duration)
	end,}

registerTalentTranslation{
	id = "T_TEMPORAL_RIPPLES",
	name = "时空涟漪",
	info = function(self, t)
		local duration = t.getDuration(self, t)
		local radius = self:getTalentRadius(t)
		return ([[创造一片半径 %d 码的时间错乱之地 %d 回合。任何站在其中的敌人受到的伤害都会治疗攻击者 200%% 伤害数额的生命。
		]]):
		format(radius, duration)
	end,}

registerTalentTranslation{
	id = "T_SAW_STORM",
	name = "锯刃风暴",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[召唤由旋转的锯刃组成的风暴来撕裂你的敌人，对每个接近者造成 %d 物理伤害并使其流血，持续 %d 回合。
]]):format(damDesc(self, DamageType.PHYSICAL, damage), duration)
	end,}

registerTalentTranslation{
	id = "T_RAZOR_SAW",
	name = "剃刀飞锯",
	info = function(self, t)
		return ([[发射一个动能十足的锯刃，对一条线内的所有目标造成 %0.2f 物理伤害。
		伤害会随着你的精神强度增长。]]):format(damDesc(self, DamageType.PHYSICAL, self:combatTalentMindDamage(t, 60, 300)))
	end,}

registerTalentTranslation{
	id = "T_ROCKET_DASH",
	name = "火箭突进",
	info = function(self, t)
		return ([[使用火箭向前突进。
		如果目标地点已被占据，那么你对那里的目标进行一次近战攻击。
		攻击会造成 130% 武器伤害。
		你必须至少突进 2 码。]])
	end,}

-- Solely used to track the achievement
registerTalentTranslation{
	id = "T_ACHIEVEMENT_MIND_CONTROLLED_YETI",
	name = "精神控制的雪人",
	info = function(self, t)
		return "雪人重击！"
	end,}


return _M