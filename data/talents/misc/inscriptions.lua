


















newInscription = function(t)
	
	for i = 1, 6 do
		local tt = table.clone(t)
		tt.short_name = tt.name:upper():gsub("[ ]", "_").."_"..i
		tt.display_name = function(self, t)
			local data = self:getInscriptionData(t.short_name)
			if data.item_name then
				local n = tstring{t.name, " ["
				n:merge(data.item_name)
				n:add("]")
				return n
			else
				return t.name
			end
name)
			return data.cooldown
		end
name)
			if data.use_stat and data.use_stat_mod then
				ret = ret..("\n受 你 的 %s 影 响， 此 效 果 按 比 例 加 成。 "):format(s_stat_name[self.stats_def[data.use_stat].name] or self.stats_def[data.use_stat].name)
			end
name or t.name):lower():gsub("[^a-z0-9_]", "_")..".png"
		end
name = "Infusion: Regeneration"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 纹 身 治 疗 你 自 己 %d 生 命 值， 持 续 %d 回 合。 ]]):format(data.heal + data.inc_stat, data.dur)
	end
name)
		return ([[治 疗 %d 持 续 %d 回 合  ]]):format(data.heal + data.inc_stat, data.dur)
	end
name = "Infusion: Healing"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 纹 身 立 即 治 疗 你 %d 生 命 值, 同 时 去 除 一 个 流 血 或 毒 素 效 果 。]]):format(data.heal + data.inc_stat)
	end
name)
		return ([[治 疗 %d]]):format(data.heal + data.inc_stat)
	end
name = "Infusion: Wild"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local what = table.concatNice(table.keys(data.what), ", ", " or ")
		return ([[激 活 纹 身 解 除 你 %s 效 果 并 减 少 所 有 伤 害 %d%% 持 续 %d 回 合。 
同 时 会 除 去 对 应 状 态 的 CT 效 果 。]]):format(change_infusion_eff(what), data.power+data.inc_stat, data.dur)
	end
name)
		local what = table.concat(table.keys(data.what), ", ")
		return ([[减 伤 %d%%; 解 除 %s]]):format(data.power + data.inc_stat, what:gsub("physical"," 物 理 "):gsub("magical"," 魔 法 "):gsub("mental"," 精 神 ").." 效 果 ")
	end
name = "Infusion: Primal", image = "talents/infusion__wild.png"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local what = table.concat(table.keys(data.what), ", ")
		return ([[ 激 活 这 个 纹 身 ， 解 除 %s 效 果 并 将 你 受 到 的 %d%% 全 体 伤 害 转 化 为 治 疗 ， 持 续 %d 回 合 。
		同 时 会 除 去 对 应 状 态 的 CT 效 果 。]]):format(change_infusion_eff(what), data.power+data.inc_stat, data.dur)
	end
name)
		local what = table.concat(table.keys(data.what), ", ")
		return ([[伤 害 治 疗 %d%%; 解 除 %s]]):format(data.power + data.inc_stat,change_infusion_eff(what))
	end
name = "Infusion: Movement"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 纹 身 可 以 在 1 个 游 戏 回 合 内 提 升 移 动 速 度 %d%% 。 除 移 动 以 外 其 他 动 作 会 取 消 这 个 效 果。 
		 同 时 免 疫 眩 晕、 震 慑 和 定 身 效 果 %d 回 合。 
		 注 意： 由 于 你 的 速 度 非 常 快， 游 戏 回 合 会 相 对 很 慢。 ]]):format(data.speed + data.inc_stat, data.dur)
	end
name)
		return ([[%d%% 加 速 ; %d 回 合 ]]):format(data.speed + data.inc_stat, data.dur)
	end
name = "Infusion: Sun"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local apply = self:rescaleCombatStats((data.power + data.inc_stat))
		return ([[激 活 这 个 纹 身 照 亮 %d 区 域 和 潜 行 单 位， 可 能 使 潜 行 目 标 显 形（ 降 低 %d 潜 行 强 度）。 %s
		 同 时 区 域 内 目 标 也 有 几 率 被 致 盲（ %d 等 级）， 持 续 %d 回 合。 ]]):
		format(data.range, apply/2, apply >= 19 and "\n 这 光 线 是 如 此 强 烈， 以 至 于 能 驱 散 魔 法 造 成 的 黑 暗 " or "", data.power + data.inc_stat, data.turns)
	end
name)
		local apply = self:rescaleCombatStats((data.power + data.inc_stat))
		return ([[范围 %d; 强度 %d; 回合 %d%s]]):format(data.range, apply, data.turns, apply >= 19 and "; dispells darkness" or "")
	end
name = "Infusion: Heroism"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 纹 身 可 以 增 加 你 3 项 基 础 属 性 %d ， 持 续 %d 回 合。
		同 时， 当 英 雄 纹 身 激 活 时， 你 的 生 命 值 只 有 在 降 低 到 -%d 生 命 时 才 会 死 亡。 然 而， 当 生 命 值 低 于 0 时， 你 无 法 看 到 你 还 剩 下 多 少 生 命。
		属 性 提 高 以 你 最 高 的 三 个 属 性 为 准。
		效 果 结 束 时， 如 果 你 的 生 命 值 在 0 以 下 ， 会 变 为 1 点。 ]]):format(data.power + data.inc_stat, data.dur, data.die_at + data.inc_stat * 30)
	end
name)
		return ([[+%d 持 续 %d 回 合， 死 亡 限 值 -%d]]):format(data.power + data.inc_stat, data.dur, data.die_at + data.inc_stat * 30)
	end
name = "Infusion: Insidious Poison"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 纹 身 会 发 射 一 个 毒 气 弹 造 成 每 回 合 %0.2f 自 然 伤 害 持 续 7 回 合， 并 降 低 目 标 治 疗 效 果 %d%% 。
		 突 然 涌 动 的 自 然 力 量 会 除 去 你 受 到 的 一 个 负 面 魔 法 效 果 。 ]]):format(damDesc(self, DamageType.NATURE, data.power + data.inc_stat) / 7, data.heal_factor)
	end
name)
		return ([[%d 自 然 伤 害， %d%% 治 疗 下 降 ]]):format(damDesc(self, DamageType.NATURE, data.power + data.inc_stat) / 7, data.heal_factor)
	end
name = "Infusion: Wild Growth"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local damage = t.getDamage(self, t)
		return ([[从 土 地 中 召 唤 坚 硬 的 藤 蔓， 缠 绕 %d 码 范 围 内 所 有 生 物， 持 续 %d 回 合。 将 其 定 身 并 造 成 每 回 合 %0.2f 物 理 和 %0.2f 自 然 伤 害。 
		 藤 蔓 也 会 生 长 在 你 的 身 边 ， 增 加 %d 护 甲 和 %d%% 护 甲 硬 度 。]]):
		format(self:getTalentRadius(t), data.dur, damDesc(self, DamageType.PHYSICAL, damage)/3, damDesc(self, DamageType.NATURE, 2*damage)/3, data.armor or 50, data.hard or 30)
	end
name)
		return ([[范 围 %d 持 续 %d 回 合 ]]):format(self:getTalentRadius(t), data.dur)
	end
name = "Rune: Phase Door"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = (data.power or data.range) + data.inc_stat * 3
		return ([[激 活 这 个 符 文 会 使 你 在 %d 码 范 围 内 随 机 传 送。 
		 之 后 ， 你 会 出 入 现 实 空 间 % d 回 合 ， 所 有 新 的 负 面 状 态 持 续 时 间 减 少 %d%% ， 闪 避 增 加 %d ， 全 体 伤 害 抗 性 增 加 %d%% 。 ]]):
		format(data.range + data.inc_stat, data.dur or 3, power, power, power)
	end
name)
		local power = (data.power or data.range) + data.inc_stat * 3
		return ([[范 围 %d; 强 度 %d; 持 续 %d]]):format(data.range + data.inc_stat, power, data.dur or 3)
	end
name = "Rune: Controlled Phase Door"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文， 传 送 至 %d 码 内 的 指 定 位 置。 ]]):format(data.range + data.inc_stat)
	end
name)
		return ([[范 围 %d]]):format(data.range + data.inc_stat)
	end
name = "Rune: Teleportation"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 随 机 传 送 %d 码 范 围 内 位 置， 至 少 传 送 15 码 以 外。 ]]):format(data.range + data.inc_stat)
	end
name)
		return ([[范 围 %d]]):format(data.range + data.inc_stat)
	end
name = "Rune: Shielding"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 产 生 一 个 防 护 护 盾， 吸 收 最 多 %d 伤 害 持 续 %d 回 合。 ]]):format(data.power + data.inc_stat, data.dur)
	end
name)
		return ([[吸 收 %d 持 续 %d 回 合 ]]):format(data.power + data.inc_stat, data.dur)
	end
name = "Rune: Reflection Shield"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local power = 100+5*self:getMag()
		if data.power and data.inc_stat then power = data.power + data.inc_stat end
name)
		local power = 100+5*self:getMag()
		return ([[吸 收 并 反 弹 %d 持 续 %d 回 合 ]]):format(power, data.dur or 5)
	end
name = "Rune: Invisibility"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 使 你 变 得 隐 形（ %d 隐 形 等 级） 持 续 %d 回 合。 
		 由 于 你 的 隐 形 使 你 从 现 实 相 位 中 脱 离， 你 的 所 有 伤 害 降 低 40%% 。 
		]]):format(data.power + data.inc_stat, data.dur)
	end
name)
		return ([[强 度 %d 持 续 %d 回 合 ]]):format(data.power + data.inc_stat, data.dur)
	end
name = "Rune: Speed"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 提 高 整 体 速 度 %d%% 持 续 %d 回 合。 ]]):format(data.power + data.inc_stat, data.dur)
	end
name)
		return ([[ 提 速 %d%% 持 续 %d 回 合 ]]):format(data.power + data.inc_stat, data.dur)
	end
name = "Rune: Vision"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local kind=data.esp or " 人 形 怪 "
                kind=kind:gsub("demon"," 恶 魔 "):gsub("animal"," 动 物 "):gsub("undead"," 不 死 族 "):gsub("dragon"," 龙 "):gsub("horror"," 恐 魔 "):gsub("humanoid","人 形 怪")
		return ([[激 活 这 个 符 文 可 以 使 你 查 看 周 围 环 境（ %d 有 效 范 围） 使 你 你 查 看 隐 形 生 物（ %d 侦 测 隐 形 等 级） 持 续 %d 回 合。 
		 你 的 精 神 更 加 敏 锐 ， 能 感 知 到 周 围 的 %s  ， 持 续 %d 回 合。 ]]):
		format(data.range, data.power + data.inc_stat, data.dur, kind, data.dur)

	end
name)
		local kind=data.esp or " 人 形 "
                kind=kind:gsub("demon"," 恶 魔 "):gsub("animal"," 动 物 "):gsub("undead"," 不 死 "):gsub("dragon"," 龙 "):gsub("horror"," 恐 魔 "):gsub("humanoid","人 形 怪")
		return ([[范 围 %d; 持 续 %d; 感知 %s]]):format(data.range, data.dur, kind)
	end
name = "Rune: Heat Beam"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 发 射 一 束 射 线， 造 成 %0.2f 火 焰 伤 害 持 续 5 回 合。 
		 高 温 同 时 会 解 除 你 受 到 的 一 个 负 面 物 理 状 态。 ]]):format(damDesc(self, DamageType.FIRE, data.power + data.inc_stat))
	end
name)
		return ([[%d 火 焰 伤 害 ]]):format(damDesc(self, DamageType.FIRE, data.power + data.inc_stat))
	end
name = "Rune: Biting Gale"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local apply = self:rescaleCombatStats((data.apply + data.inc_stat))
		return ([[激 活 这 个 符 文 ， 形 成 一 股 锥 形 寒 风 ， 造 成 %0.2f 寒 冷 伤 害。
			寒 风 会 减 半 敌 人 的 震 慑 抗 性 ， 并 试 图 冻 结 他 们 3 回合 ，强 度 %d 。
			寒 冷 同 时 净 化 了 你 的 精 神， 解 除 一 项 随 机 负 面 精 神 效 果。 ]]):
			format(damDesc(self, DamageType.COLD, data.power + data.inc_stat), apply)
	end
name)
		local apply = self:rescaleCombatStats((data.apply + data.inc_stat))
		return ([[%d 寒冷伤害; %d 强度]]):format(damDesc(self, DamageType.COLD, data.power + data.inc_stat), apply)
	end
name = "Rune: Acid Wave"
	info= function(self, t)
		  local data = self:getInscriptionData(t.short_name)
		  local pow = data.apply + data.inc_stat
		  local apply = self:rescaleCombatStats((data.apply + data.inc_stat))
		  
		  return ([[发 射 锥 形 酸 性 冲 击 波 造 成 %d 码 %0.2f 酸 性 伤 害。
		 酸 性 冲 击 波 会 腐 蚀 目 标， 缴 械 %d 回 合 ，强 度 %d 。
		 酸 性 能 量 同 时 会 除 去 你 的 一 项 负 面 魔 法 效 果。]]):
			 format(self:getTalentRadius(t), damDesc(self, DamageType.ACID, data.power + data.inc_stat), data.dur or 3, apply)
	   end
name)
		local pow = data.power
		local apply = self:rescaleCombatStats((data.apply + data.inc_stat))

		return ([[%d 酸 性 伤 害; 持 续 %d; 强 度 %d]]):format(damDesc(self, DamageType.ACID, data.power + data.inc_stat), data.dur or 3, apply)
	end
name = "Rune: Lightning"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		local dam = damDesc(self, DamageType.LIGHTNING, data.power + data.inc_stat)
		return ([[激 活 这 个 符 文 发 射 一 束 闪 电 打 击 目 标， 造 成 %0.2f 至 %0.2f 闪 电 伤 害。 
		 同 时 会 让 你 进 入 闪 电 形 态 %d 回 合： 受 到 伤 害 时 你 会 瞬 移 到 附 近 的 一 格 并 防 止 此 伤 害 ， 一 回 合 只 能 触 发 一 次。 ]]):
		format(dam / 3, dam, 2)
	end
name)
		return ([[%d 闪 电 伤 害 ]]):format(damDesc(self, DamageType.LIGHTNING, data.power + data.inc_stat))
	end
name = "Rune: Manasurge"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 对 你 自 己 释 放 法 力 回 复， 增 加 %d%% 回 复 量 持 续 %d 回 合， 并 立 即 回 复 %d 法 力 值。 
			同 时 ， 在 你 休 息 时 增 加 每 回 合 0.5 的 魔 力 回 复。 ]]):format(data.mana + data.inc_stat, data.dur, (data.mana + data.inc_stat) / 20)
	end
name)
		return ([[%d%% 回 复 持 续 %d 回 合 ; %d 法 力 瞬 回 ]]):format(data.mana + data.inc_stat, data.dur, (data.mana + data.inc_stat) / 20)
	end
name = "Rune: Frozen Spear"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[激 活 这 个 符 文 发 射 一 束 冰 枪， 造 成 %0.2f 冰 冻 伤 害 并 有 一 定 几 率 冻 结 你 的 目 标。 
               	 寒 冰 同 时 会 解 除 你 受 到 的 一 个 负 面 精 神 状 态。 ]]):format(damDesc(self, DamageType.COLD, data.power + data.inc_stat))
	end
name)
		return ([[%d 寒 冰 伤 害 ]]):format(damDesc(self, DamageType.COLD, data.power + data.inc_stat))
	end
name = "Rune of the Rift"
	info= function(self, t)
		local damage = t.getDamage(self, t)
		local duration = t.getDuration(self, t)
		return ([[造 成 %0.2f 时 空 伤 害。 如 果 你 的 目 标 存 活， 则 它 会 被 传 送 %d 回 合 至 未 来。 
		 它 也 能 降 低 你 25 紊 乱 值 ( 如 果 你 拥 有 该 能 量 )。 
		 注 意， 若 与 其 他 时 空 效 果 相 混 合 则 可 能 产 生 无 法 预 料 的 后 果。 ]]):format(damDesc(self, DamageType.TEMPORAL, damage), duration)
	end
name = "Taint: Devourer"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[对 目 标 激 活 此 印 记， 移 除 其 %d 个 效 果 并 将 其 转 化 为 治 疗 你 每 个 效 果 %d 生 命 值。 ]]):format(data.effects, data.heal + data.inc_stat)
	end
name)
		return ([[%d 效 果 / %d 治 疗 ]]):format(data.effects, data.heal + data.inc_stat)
	end
name = "Taint: Telepathy"
	info= function(self, t)
		local data = self:getInscriptionData(t.short_name)
		return ([[解 除 你 的 精 神 束 缚 %d 回 合， 感 应 %d 码 范 围 内 的 所 有 生 物 ， 减 少 %d 精 神 豁 免 持 续 10 回 合 并 增 加 %d 点 精 神 强 度。 ]]):format(data.dur, self:getTalentRange(t), 10, 35)
	end
name)
		return ([[范 围 %d 码 心 灵 感 应 持 续 %d 回 合 ]]):format(self:getTalentRange(t), data.dur)
	end


