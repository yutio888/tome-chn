local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_MOLTEN_IRON_BLOOD",
	name = "铁水血液",
	info = function(self, t)
		return ([[使 用 灵 能 改 变 你 的 血 液 ， 使 之 成 为 融 化 的 铁 水 。
 		 任 何 近 战 攻 击 你 的 生 物 将 受 到 %0.2f 火 焰 伤 害 。
		 你 全 体 伤 害 抗 性 增 加 %d%% ， 同 时 所 有 新 负 面 状 态 持 续 时 间 下 降 %d%% 。 
		]]):format(damDesc(self, DamageType.FIRE, t.getSplash(self, t)), t.getResists(self, t), t.getReduction(self, t))
	end,}

registerTalentTranslation{
	id = "T_MIND_DRONES",
	name = "精神雄蜂",
	info = function(self, t)
		return ([[将 灵 能 和 蒸 汽 科 技 结 合 ， 你 在 身 边 制 造 5 只 精 神 雄 蜂 飞 向 目 标 。
		雄 蜂 接 触 到 生 物 时 ， 将 进 入 其 大 脑 6 回 合 ， 干 扰 思 考 能 力 。 
 		受 影 响 的 生 物 有 %d%% 几 率 使 用 技 能 失 败 ，同 时 恐 惧 和 睡 眠 免 疫 减 少 %d%% 。]]):
		format(t.getFail(self, t), t.getReduction(self, t))
	end,}

registerTalentTranslation{
	id = "T_PSIONIC_MIRROR",
	name = "灵能之镜",
	info = function(self, t)
		return ([[解 除 %d 项 负 面 精 神 状 态  ， 并 将 每 个 状 态 随 机 转 移 至 半 径 5 以 内 的 敌 人 上 。 ]])
		:format(t.getNum(self, t))
	end,}

registerTalentTranslation{
	id = "T_MIND_INJECTION",
	name = "精神注射",
	info = function(self, t)
		local faked = false
		if not self.inscriptions_data.MIND_INJECTION then self.inscriptions_data.MIND_INJECTION = {power=t.getPower(self, t), cooldown_mod=t.getCooldownMod(self, t), cooldown=1} faked = true end
		local data = self:getInscriptionData(t.short_name)
		if faked then self.inscriptions_data.MIND_INJECTION = nil end
		return ([[与 身 体 建 立 直 接 的 灵 能 链 接 ， 让 你 使 用 药 剂 更 有 效 率 , 获 得 %d%% 效 果 和 %d%% 冷 却 系 数 修 正 。 ]])
		:format(data.power + data.inc_stat, data.cooldown_mod)
	end,}
return _M