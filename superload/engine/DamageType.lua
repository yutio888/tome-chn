require "data-chn123.damage_type"

local _M = loadPrevious(...)

function _M:newDamageType(t)
	assert(t.name, "no ability type name")
	assert(t.type, "no ability type type")
	t.type = t.type:upper()
	t.name = getDamageTypeCHN(t.name)
	t.projector = t.projector or self.defaultProjector
    
    if not t.color and type(t.text_color) == "string" then
		local ts = t.text_color:toTString()
		if type(ts[2]) == "table" and ts[2][1] == "color" then
			if type(ts[2][2]) == "string" then
				t.color = colors[ts[2][2]]
			elseif type(ts[2][2]) == "string" then
				t.color = {r=ts[2][2], g=ts[2][3], b=ts[2][4]}
			end
		end
	end
    
	self.dam_def[t.type] = t
	self[t.type] = t.type
	--table.insert(self.dam_def, t)
	--self[t.type] = #self.dam_def
end

return _M
