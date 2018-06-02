local _M = loadPrevious(...)

function _M:Calendar_trans(datastring)

	if not datastring then return end

	if datastring:find("Maj'Eyal") then return "今天是 %s %s 第 %s 年 卓越纪，马基埃亚尔。\n现在时间是 %02d:%02d."  end

	return datastring 
end


function _M:init(definition, datestring, start_year, start_day, start_hour)
	local data = dofile(definition)
	self.calendar = {}
	local days = 0
	for _, e in ipairs(data) do
		if not e[3] then e[3] = 0 end
		table.insert(self.calendar, { days=days, name=e[2], length=e[1], offset=e[3] })
		days = days + e[1]
	end
	assert(days == 365, "Calendar incomplete, days ends at "..days.." instead of 365")

	self.datestring = self:Calendar_trans(datestring)
	self.start_year = start_year
	self.start_day = start_day or 1
	self.start_hour = start_hour or 8
end

return _M
