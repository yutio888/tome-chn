local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_SAWWHEELS",
	name = "链锯轮滑",
	info = function(self, t)
		return ([[把 链 锯 深 深 插 入 地 面 ， 作 为 履 带 ， 增 强 自 己 的 行 动 能 力 （ 移 动 速 度 增 加 %d%% ） 。
		在 你 移 动 路 线 两 侧 的 敌 人 被 链 锯 割 断 ，  被 击 退 3 码 。
		攻 击 或 者 使 用 其 他 技 能 的 动 作 都 会 中 断 效 果 , 同 时 冲 击 力 对 周 围 的 敌 人 造 成 %d%% 武 器 伤 害 。 你 需 要 至 少 移 动 五 次 来 达 到 最 高 伤 害 ， 否 则 伤 害 会 降 低 。 若 不 移 动 则 没 有 伤 害 。 
		#{italic}#冲锋 ！ 死亡之轮！！#{normal}#]]):
		format(t.getSpeed(self, t), self:combatTalentWeaponDamage(t, 1, 2) * 100)
	end,}

registerTalentTranslation{
	id = "T_GRINDING_SHIELD",
	name = "利齿护盾",
	getSawwheelDamage = function(self, t) return math.floor(self:combatTalentScale(t, 10, 80)) end,
	info = function(self, t)
		local ev, spread = t.getEvasion(self, t)
		local flat = t.getFlatMax(self, t)
		return ([[围 绕 自 身 快 速 旋 转 链 锯 ， 形 成 一 堵 链 锯 齿 形 成 的 墙 壁。
		所 有 近 战 伤 害 降 低 %d%%， 有 %d%% 的 概 率 回 避 投 射 物 ， 并 且 受 到 的 一 击 伤 害 不 会 超 过 最 大 生 命 值 的 %d%%。
		#{italic}#用 死 亡 链 锯 拆 了 他 们 的 骨 头！！#{normal}#]])
		:format(ev, ev, flat)
	end,}

-- Core highest damage potential strike
registerTalentTranslation{
	id = "T_PUNISHMENT",
	name = "惩戒",
	info = function(self, t)
		return ([[用 链 锯 猛 力 拍 击 目 标 ， 造 成 100%% + 每 个 物 理 、 魔 法 或 者 精 神 状 态 %d%% 加 成 的 伤 害（ 最 多 7 个） 。
		持 续 技 能 不 视 作 状 态 。
		#{italic}# 钢铁惩戒 ！！#{normal}#]]):
		format(t.getBonus(self, t))
	end,}

-- Needs new bonus for Saw Wheels
registerTalentTranslation{
	id = "T_BATTLEFIELD_VETERAN",
	name = "战场老兵",
	info = function(self, t)
		return ([[你 是 一 名 坚 毅 的 老 兵 ， 经 历 了 大 量 战 争 仍 然 能 够 幸 存 ， 有 着 丰 富 的 战 斗 经 验 。
		链 锯 轮 滑 的 伤 害 增 加 %d%% 。
		利 齿 护 盾 让 你 超 越 生 存 下 限 ， 在 -%d 的 生 命 下 仍 然 生 存。
		惩 戒 有 %d%% 的 概 率 触 发 ：对 象 每 具 备 一 个 效 果 ， 就 降 低 惩 戒 1 回 合 CD。
		#{italic}#一切尽在掌控 ！！#{normal}#]]):
		format(t.getSawwheelDamage(self, t), t.getLife(self, t), t.getChance(self, t))
	end,}
return _M