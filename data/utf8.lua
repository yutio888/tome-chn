--[[
Name: utf8
Author(s): Cosin
Website: http://www.cwowaddon.com/
         http://wiki.cwowaddon.com/cosin0002/

Description:
	This is a code for utf8 string enhancement, especially for multi byte language, such as Chinese.

License:
	This code is free, you can redistribute it and/or
	modify it under the terms of the GNU Lesser General Public
	License as published by the Free Software Foundation; either
	version 2.1 of the License, or (at your option) any later version.

	This code is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
	Lesser General Public License for more details.

Note:
	This code is specifically designed to work with
	World of Warcraft's interpreted AddOn system.
]]

local function utf8_parse(obUTF8)
	local length = string.len(obUTF8.str)
	local code, test
	local iPosIndex = 1
	local i = 1
	while i <= length do
		code = string.byte(obUTF8.str, i)
		test = bit.rshift(bit.band(code, 255), 4)
		if 0 <= test and test <= 7 then
			obUTF8.pos[iPosIndex] = {i, 1}
		elseif 12 <= test and test <= 13 then
			if i + 1 <= length then
				obUTF8.pos[iPosIndex] = {i, 2}
				i = i + 1
			else
				obUTF8.pos[iPosIndex] = {i, 1}
				obUTF8.unknown = obUTF8.unknown + 1
			end
		elseif 14 == test then
			if i + 2 <= length then
				obUTF8.pos[iPosIndex] = {i, 3}
				i = i + 2
			else
				obUTF8.pos[iPosIndex] = {i, 1}
				obUTF8.unknown = obUTF8.unknown + 1
			end
		else
			obUTF8.pos[iPosIndex] = {i, 1}
			obUTF8.unknown = obUTF8.unknown + 1
		end
		i = i + 1
		iPosIndex = iPosIndex + 1
	end
end

utf8 = {}

function utf8:new(str)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	if type(str) ~= "string" then
		str = ""
	end
	o:set(str)
	return o
end

function utf8:set(str)
	self.str = str
	self.pos = {}
	self.unknown = 0
	utf8_parse(self)
end

function utf8:len()
	return #self.pos
end

function utf8:getChar(index)
	if 0 >= index or index > self:len() then
		return ""
	end
	return string.sub(self.str, self.pos[index][1], self.pos[index][1] + self.pos[index][2] - 1)
end

function utf8:sub(iStart, iEnd)
	local length = self:len()
	if type(iStart) ~= "number" or iStart < 1 then
		iStart = 1
	end
	if type(iEnd) ~= "number" or iEnd > length then
		iEnd = length
	end
	return string.sub(self.str, self.pos[iStart][1], self.pos[iEnd][1] + self.pos[iEnd][2] - 1)
end