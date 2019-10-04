local _M = loadPrevious(...)

--- Returns a tooltip for the trap
-- requires the trap be known to player, full info only if identified
function _M:tooltip()
	if self:knownBy(game.player) then
		local res = tstring{{"uid", self.uid}, self:getName(), true}
		local id = self:isIdentified()
		if self.temporary then res:add(("#LIGHT_GREEN#%d 回合 #WHITE#"):format(self.temporary)) end
		if self.is_store then
			res:add(true, {"font","italic"}, "<Store>", {"font","normal"})
			if self.store_faction then
				local factcolor, factstate, factlevel = "#ANTIQUE_WHITE#", "中立", Faction:factionReaction(self.store_faction, game.player.faction)
				if factlevel < 0 then factcolor, factstate = "#LIGHT_RED#", "敌对"
				elseif factlevel > 0 then factcolor, factstate = "#LIGHT_GREEN#", "友好"
				end
				if Faction.factions[self.store_faction] then res:add(true, "阵营: ") res:merge(factcolor:toTString()) res:add(("%s (%s, %d)"):format(Faction.factions[self.store_faction].name, factstate, factlevel), {"color", "WHITE"}, true) end
			end
		else
			if id then
				if self.faction then
					if self.beneficial_trap then 
						if self:reactionToward(game.player) >= 0 then
							res:add({"color", "LIGHT_GREEN"}, "(有益)", {"color", "WHITE"})
						else
							res:add({"color", "ORANGE"}, "(对敌有益)", {"color", "WHITE"})
						end
					elseif self:reactionToward(game.player) >= 0 then
						res:add({"color", "LIGHT_GREEN"}, "(安全)", {"color", "WHITE"})
					end
				end
				if self.pressure_trap then
					res:add(true, {"color", "GREEN"}, "压力感应", {"color", "WHITE"})
				end
				local desc = self.desc
				if self.name then
					if self.name == "glyph of twilight" then 
						desc = function(self)
							return ([[产 生 爆 炸 ， 击 退 敌 人 1 格 并 造 成 %d 光 系 和 %d 暗 影 伤 害。]]):format(engine.interface.ActorTalents.damDesc(self, engine.DamageType.LIGHT, self.dam/2), engine.interface.ActorTalents.damDesc(self, engine.DamageType.DARKNESS, self.dam/2))
						end
					elseif self.name == "glyph of sunlight" then 
						desc = function(self)
							return ([[造 成 %d 光 系 伤 害，并 治 疗 使 用 者 %d 生 命]]):format(engine.interface.ActorTalents.damDesc(self, engine.DamageType.LIGHT, self.dam), self.heal)
						end
					elseif self.name == "glyph of moonlight" then
						desc =  function(self)
							return ([[造 成 %d 暗 影 伤 害 并 吸 取 敌 方 能 量， 降 低 其 造 成 的 伤 害 %d%%， 效 果 持 续 %d 回 合。]]):format(engine.interface.ActorTalents.damDesc(self, engine.DamageType.DARKNESS, self.dam), self.numb, self.numbDur)
						end
					end
				end
				if desc then desc = util.getval(desc, self) end
				if desc then res:add(true, desc) end
			end
			res:add(true, ("#YELLOW# 侦测: %d#WHITE#"):format(self.detect_power))
			if id or config.settings.cheat then
				res:add(("#YELLOW# 解除: %d#WHITE#"):format(self.disarm_power))
			end
		end
		if config.settings.cheat then res:add(true, "UID: "..self.uid, true) end
		return res
	end
end

function _M:canTrigger(x, y, who, no_random)
	if self.faction and who.reactionToward and who:reactionToward(self) >= 0 then return self.beneficial_trap end

	local avoid
	if who:attr("avoid_traps") then
		avoid = "无视了"
	elseif self.pressure_trap and (who:attr("levitation") or who:attr("avoid_pressure_traps")) then
		avoid = "轻松无视了"
	elseif not no_random and who.trap_avoidance and rng.percent(who.trap_avoidance) then
		avoid = "小心避开了"
	elseif not self.beneficial_trap and rng.percent(self.trigger_fail) then
		avoid = "不知怎么就避开了"
	elseif who:attr("walk_sun_path") and game.level then
		for i, e in ipairs(game.level.map.effects) do if e.damtype == DamageType.SUN_PATH and e.grids[x] and e.grids[x][y] then	avoid = "闪避了" break end
		end
	end
	
	if avoid then
		if self.x == who.x and self.y == who.y and game.level.map.seens(x, y) then
			local known_player = self:knownBy(game.player)
			if who.player then
				if known_player then game.log("#CADET_BLUE#你 %s 一个陷阱 (%s).", avoid, logCHN:getName(self:getName())) end
			else
				game.logSeen(who, "#CADET_BLUE#%s %ss %s.", logCHN:getName(who.name), avoid, known_player and ("一个陷阱 (%s)"):format(logCHN:getName(self:getName())) or "地板上的某物")
			end
		end
		return false
	end

	return true
end

return _M