module(..., package.seeall, class.make)

_M.name = {}
_M.desc = {}

function _M:getAchName(name)
	local ls = 0
	while name:find(" %(", ls) do
		_, ls = name:find(" %(", ls)
		print(ls)
	end
	return name:sub(1, ls - 2)
end

function _M:getName(name)
	local name = name
	if self.name[name] then name = self.name[name]
	elseif name:find(" %(") then 
		local achname = self:getAchName(name)
		local chnname = achname
		if self.name[achname] then chnname = self.name[achname] end
		name = name:gsub(achname,chnname):gsub("Nightmare","噩梦难度"):gsub("Insane","疯狂难度"):gsub("Madness","绝望难度")
						 :gsub("Adventure","冒险模式"):gsub("Roguelike","永久死亡模式"):gsub("Exploration","探索模式")
						 :gsub("mode",""):gsub("difficulty","")
	end
	return name
end

function _M:getDesc(name, desc)
	local desc = desc
	if self.desc[name] then desc = self.desc[name]
	elseif name:find(" %(") then 
		local achname = self:getAchName(name)
		if self.desc[achname] then chnname = self.desc[achname] end
	end
	return desc
end

function _M:registerAchievementTranslation(t)
	self.name[t.name] = t.chnName
	self.desc[t.name] = t.desc
end

function _M:loadDefinition(file, env)
	local f, err = loadfile(file)
	if not f and err then error(err) end
	setfenv(f, setmetatable(env or {
		registerAchievementTranslation = function(t) self:registerAchievementTranslation(t) end,
		load = function(f) self:loadDefinition(f, getfenv(2)) end
	}, {__index=_G}))
	f()
end

_M.category = {}
_M.category["Maj'Eyal"] = "马基埃亚尔"
_M.category["Ashes of Urh'Rok"] = "乌鲁洛克之烬"

function _M:getCategory(name)
	return self.category[name] or name
end