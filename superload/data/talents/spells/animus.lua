local _M = loadPrevious(...)

registerTalentTranslation{
	id = "T_CONSUME_SOUL",
	name = "消耗灵魂",
	info = function(self, t)
		local heal = t.getHeal(self, t)
		return ([[ 粉 碎 你 捕 获 的 一 个 灵 魂 ， 利 用 其 能 量 回 复 自 己 %d 点 生 命 ， %d 点 法 力 。
		 受 法 术 强 度 影 响 ，治 疗 量 有 额 外 加 成。 ]]):
		format(heal, heal / 3)
	end,
}

registerTalentTranslation{
	id = "T_ANIMUS_HOARDER",
	name = "灵魂储存",
	info = function(self, t)
		local max, chance = t.getMax(self, t), t.getChance(self, t)
		return ([[ 你 对 灵 魂 的 渴 望 与 日 俱 增 。 当 你 杀 死 一 个 生 物 时 ， 你 利 用 强 大 的 力 量 抹 去 它 的 仇 恨， 有 %d%% 概 率 获 得 额 外 一 个 灵 魂 ， 同 时 你 能 获 得 的 最 大 灵 魂 数 增 加  %d 。]]):
		format(chance, max)
	end,
}

registerTalentTranslation{
	id = "T_ANIMUS_PURGE",
	name = "仇恨净化",
	info = function(self, t)
		local damage = t.getDamage(self, t)
		return ([[ 试 图 粉 碎 你 敌 人 的 灵 魂， 造 成 %0.2f 点 暗 影 伤 害 （ 但 不 会 杀 死 它 ） 。 
		 如 果 剩 余 生 命 少 于 %d%% , 你 将 试 图 控 制 其 身 体 。
		 如 果 成 功 ， 对 方 将 成 为 你 永 久 的 傀 儡， 不 受 你 的 死 灵 光 环 影 响 ， 并 得 到 两 个 灵 魂 。 
		 傀 儡 能 力 与 生 前 相 同 , 受 黑 暗 共 享 的 影 响， 在 制 造 时 生 命 恢 复 满 值 ， 之 后 不 能 以 任 何 方 式 被 治 疗 。
		 任 何 时 候， 这 种 方 式 只 能 控 制 一 个 生 物 ， 在 已 经 存 在 傀 儡 时 使 用 该 技 能 会 让 原 来 的 傀 儡 消 失。
		 boss、 不 死 族 和 召 唤 物 不 会 变 成 傀 儡 。 
		 受 法 术 强 度 影 响， 伤 害 和 概 率 有 额 外 加 成。]]):
		format(damDesc(self, DamageType.DARKNESS, damage), t.getMaxLife(self, t))
	end,
}

registerTalentTranslation{
	id = "T_ESSENCE_OF_THE_DEAD",
	name = "亡者精华",
	info = function(self, t)
		local nb = t.getnb(self, t)
		return ([[  粉 碎 两 个 灵 魂， 接 下 来 的 %d 个 法 术 获 得 额 外 效 果 ： 
                  受 影 响 的 法 术 有：
		  亡 灵 分 流： 获 得 治 疗 量 一 半 的 护 盾 
                  亡 灵 召 唤： 额 外 召 唤 两 个 不 死 族
                  亡 灵 组 合： 额 外 召 唤 一 个 骨 巨 人
                  黑 夜 降 临： 攻 击 变 成 锥 形
                  暗 影 通 道： 被 传 送 的 不 死 族 同 时 受 到 相 当 于 30%% 最 大 生 命 值 的 治 疗
                  骨 灵 冷 火： 冰 冻 概 率 增 加 至 100%%
                  寒 冰 箭： 每 个 寒 冰 箭 都 变 成 射 线
                  消 耗 灵 魂： 效 果 增 加 50%%]]):
		format(nb)
	end,
}

registerTalentTranslation{
	id = "T_HUSK_DESTRUCT",
	name = "自爆",
	info = function(self, t)
		local rad = self:getTalentRadius(t)
		return ([[毁 灭 自 己 ， 在 半 径 %d 的 范 围 造 成 %0.2f 点 暗 影 伤 害。
		只 有 当 主 人 死 去 时 才 能 使 用。]]):format(rad, damDesc(self, DamageType.DARKNESS, 50 + 10 * self.level))
	end,
}


return _M
