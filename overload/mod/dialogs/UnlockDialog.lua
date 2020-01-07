
require "engine.class"
local Dialog = require "engine.ui.Dialog"
local Textzone = require "engine.ui.Textzone"

module(..., package.seeall, class.inherit(Dialog))

function _M:init(what)
	self.what = what
	local f, err
	if self.what and textCHN["unlock-" .. self.what] then
		f, err = loadfile("/data-chn123/texts/unlock-"..self.what..".lua")
	else
	 	f, err = loadfile("/data/texts/unlock-"..self.what..".lua")
	end
	if not f and err then error(err) end
	setfenv(f, {})
	self.name, self.str = f()

	game.logPlayer(game.player, "#VIOLET#游戏选项解锁: "..self.name)

	Dialog.init(self, "游戏选项解锁: "..self.name, 600, 400)

	self.c_desc = Textzone.new{width=math.floor(self.iw - 10), height=self.ih, no_color_bleed=true, auto_height=true, text=self.str}

	self:loadUI{
		{left=0, top=0, ui=self.c_desc},
	}
	self:setupUI(not rw, not rh)

	self.key:addBinds{
		ACCEPT = accept_key and "EXIT",
		EXIT = function()
			game:unregisterDialog(self)
			if on_exit then on_exit() end
		end,
	}
end
