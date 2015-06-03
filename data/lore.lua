module(..., package.seeall, class.make)

_M.loreCHN = {}

function _M:registerLoreTranslation(t)
	assert(t.id, "no lore translation id")
	self.loreCHN[t.id] = {}
	self.loreCHN[t.id].id = t.id
	self.loreCHN[t.id].name = t.name
	self.loreCHN[t.id].lore = t.lore
end

function _M:loadDefinition(file, env)
	local f, err = loadfile(file)
	if not f and err then error(err) end
	setfenv(f, setmetatable(env or {
		registerLoreTranslation = function(t) self:registerLoreTranslation(t) end,
		load = function(f) self:loadDefinition(f, getfenv(2)) end
	}, {__index=_G}))
	f()
end
