local _M = loadPrevious(...)
_M.old_findInAllInventories = _M.findInAllInventories
function _M:findInAllInventories(name, getname)
	a, b, c = _M.old_findInAllInventories(self, name, getname)
	if (not (a and b)) and require("data-chn123.objects.artifact").artifactCHN[name] then
		a, b, c = _M.old_findInAllInventories(self, require("data-chn123.objects.artifact").artifactCHN[name].name, getname)
	end
	if (not (a and b)) and require("data-chn123.objects.artifact").artifactCHN[name] then
		a, b, c = _M.findInAllInventoriesBy(self, "originName", name)
	end
	return a, b, c
end
return _M