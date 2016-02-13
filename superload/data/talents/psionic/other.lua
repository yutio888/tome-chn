local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_TELEKINETIC_GRASP",
	name = "念力之握",
	info = function(self, t)
		return ([[用 精 神 超 能 力 值 灌 注 一 件 武 器 或 宝 石， 使 它 能 够 承 受 你 的 精 神 力 量。]])
	end,
}

registerTalentTranslation{
	id = "T_BEYOND_THE_FLESH",
	name = "超越肉体",
	info = function(self, t)
		local base = [[允 许 你 用 念 力 来 装 备 一 件 武 器， 用 你 的 意 念 来 操 纵 它， 使 它 能 在 每 回 合 随 机 攻 击 一 个 近 战 范 围 的 目 标。
		 也 可 以 装 备 灵 晶 或 者 宝 石 ， 并 获 得 特 殊 效 果。
		 宝 石 ： 每 一 级 材 质 等 级 ， 使 全 部 属 性 加 3 ， 同 时 部 分 技 能 的 攻 击 范 围 增 加 1 。
		 灵 晶 ： 每 一 级 材 质 等 级 ， 有 5% 几 率 将 额 外 1 半 径 内 一 个 随 机 敌 人 抓 取 到 身 边。
		 开 启 后，使 用 60% 意 志 和 灵 巧 来 分 别 代 替 力 量 和 敏 捷 以 决 定 武 器 的 攻 击。 ]]

		local o = self:getInven("PSIONIC_FOCUS") and self:getInven("PSIONIC_FOCUS")[1]
		if type(o) == "boolean" then o = nil end
		if not o then return base end

		local atk = 0
		local dam = 0
		local apr = 0
		local crit = 0
		local speed = 1
		local range = 0
		local ammo = self:getInven("QUIVER") and self:getInven("QUIVER")[1]
		if ammo and ammo.archery_ammo ~= o.archery then ammo = nil end
		if o.type == "gem" then
			local ml = o.material_level or 1
			base = base..([[念 动 宝 石 增 加 你 %d 属 性 。]]):format(ml * 4)
		elseif o.subtype == "mindstar" then
			local ml = o.material_level or 1			
			base = base..([[念 动 灵 晶 有 %d%% 几 率 抓 取 %d 半 径 内 的 敌 人。]]):format((ml + 1) * 5, ml + 2)
			elseif o.archery and ammo then
			self:attr("use_psi_combat", 1)
			range = math.max(math.min(o.combat.range or 6), self:attr("archery_range_override") or 1)
			atk = self:combatAttackRanged(o.combat, ammo.combat)
			dam = self:combatDamage(o.combat, nil, ammo.combat)
			apr = self:combatAPR(ammo.combat) + (o.combat and o.combat.apr or 0)
			crit = self:combatCrit(o.combat)
			speed = self:combatSpeed(o.combat)
			self:attr("use_psi_combat", -1)
			base = base..([[念 动 武 器 使 用 意 志 和 灵 巧 来 分 别 代 替 力 量 和 敏 捷 以 决 定 武 器 的 攻 击。 
			战 斗 属 性： 
			范 围： %d
			命 中： %d
			伤 害： %d
			护 甲 穿 透： %d
			暴 击 率： %0.2f
			速 度： %0.2f]]):
			format(range, atk, dam, apr, crit, speed*100)
		else
			self:attr("use_psi_combat", 1)
			atk = self:combatAttack(o.combat)
			dam = self:combatDamage(o.combat)
			apr = self:combatAPR(o.combat)
			crit = self:combatCrit(o.combat)
			speed = self:combatSpeed(o.combat)
			self:attr("use_psi_combat", -1)
			base = base..([[念 动 武 器 使 用 意 志 和 灵 巧 来 分 别 代 替 力 量 和 敏 捷 以 决 定 武 器 的 攻 击。 
			战 斗 属 性： 
			命 中： %d
			伤 害： %d
			护 甲 穿 透： %d
			暴 击 率： %0.2f
			速 度： %0.2f]]):
			format(atk, dam, apr, crit, speed)
		end
		return base
	end,
}


return _M
