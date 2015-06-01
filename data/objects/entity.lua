module(..., package.seeall)

function _M:bindHooks()
	local class = require "engine.class"
	class:bindHook("Entity:loadList", function (self,data)
		if data.file == "/data/zones/shertul-fortress/grids.lua" then
			local dcb = function(self)
				if not self._mo then return end
				local tex, nblines, wline = nil
				local DamageType = require "engine.DamageType"
				local shader = require("engine.Shader").default.textoutline and require("engine.Shader").default.textoutline.shad
				local FontPackage = require "engine.FontPackage"
				local font = FontPackage:get("mono")
				local UIBase = require "engine.ui.Base"
				local MyUI = require("engine.class").inherit(UIBase){}
				MyUI.ui = "metal"
				local frame = MyUI:makeFrame("ui/tooltip/", 50, 50)
				self._mo:displayCallback(function(x, y, w, h)
					if not game.zone.training_dummies or not game.zone.training_dummies.start_turn then return end
					local data = game.zone.training_dummies
					if not tex or data.changed or data.damtypes.changed or data.last_turn ~= game.turn then 
						data.last_turn = game.turn
						local turns = (game.turn - data.start_turn) / 10
						local text
						if self.monitor_mode == "global" then
							text = ("回合数: %d\n总伤害: %d\n平均每回合伤害: %d"):format(turns, data.total, data.total / turns)
							data.changed = false
						else
							text = {}
							for damtype, value in pairs(data.damtypes) do if damtype ~= "changed" then
								local dt = DamageType:get(damtype)
								if dt then
									text[#text+1] = ("%s%s#WHITE#: %d (%d%%)"):format(dt.text_color or "#WHITE#", dt.name, value, value / data.total * 100)
								end
							end end
							text = table.concat(text, "\n")
							data.damtypes.changed = false
						end
						tex, nblines, wline = font:draw(text, text:toTString():maxWidth(font), 255, 255, 255)
					end

					y = y - tex[1].h * nblines
					x = x - (wline - w) / 2
					frame.w = wline + 16 frame.h = tex[1].h * nblines + 16
					MyUI:drawFrame(frame, x - 4, y - 4, 0, 0, 0, 0.3)
					MyUI:drawFrame(frame, x - 8, y - 8, 1, 1, 1, 0.6)
					for i = 1, #tex do
						local item = tex[i]
						if shader then
							shader:use(true)
							shader:uniOutlineSize(2, 2)
							shader:uniTextSize(item._tex_w, item._tex_h)
						else
							item._tex:toScreenFull(x+2, y+2, item.w, item.h, item._tex_w, item._tex_h, 0, 0, 0, 0.7)
						end
						item._tex:toScreenFull(x, y, item.w, item.h, item._tex_w, item._tex_h)
						if shader then shader:use(false) end
						y = y + item.h
					end
					return true
				end)
			end
			for _, item in ipairs(data.res) do
				if item.define_as == "MONITOR_ORB1" then
					item.add_displays = {mod.class.Grid.new{
						image="terrain/shertul_control_orb_greenish.png", z=17,
						monitor_mode = "global",
						defineDisplayCallback = dcb,
					}}
				elseif item.define_as == "MONITOR_ORB2" then
					item.add_displays = {mod.class.Grid.new{
						image="terrain/shertul_control_orb_greenish.png", z=17,
						monitor_mode = "specific",
						defineDisplayCallback = dcb,
					}}
				end

			end
		end
	end)
end