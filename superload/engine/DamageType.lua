require "data-chn123.damage_type"

local _M = loadPrevious(...)

function _M:newDamageType(t)
	assert(t.name, "no ability type name")
	assert(t.type, "no ability type type")
	t.type = t.type:upper()
	t.name = getDamageTypeCHN(t.name)
	t.projector = t.projector or self.defaultProjector

	self.dam_def[t.type] = t
	self[t.type] = t.type
	--table.insert(self.dam_def, t)
	--self[t.type] = #self.dam_def
end

return _M
