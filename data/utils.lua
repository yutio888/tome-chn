module(..., package.seeall)

function _M.copytable(item, t)
    for k, v in pairs(t) do
        local sf = item
        while (type(k) == "string") and k:find("%.") do
            l, _ = k:find("%.")
            sf = sf[k:sub(1, l - 1)]
            k = k:sub(l + 1, k:len() )
        end
        if type(v) == "table" then
            _M.copytable(sf[k], v)
        else
            sf[k] = v
        end
    end
end

function _M.copytable_safe(item, t)
    assert(type(item) == "table")
    assert(type(t) == "table")
    for k, v in pairs(t) do
        local sf = item
        while (type(k) == "string") and k:find("%.") do
            l, _ = k:find("%.")
            sf = sf[k:sub(1, l - 1)]
            if sf == nil then
                goto fail
            end
            k = k:sub(l + 1, k:len() )
        end
        if sf[k] == nil then
            goto fail
        end
        if type(v) == "table" then
            _M.copytable_safe(sf[k], v)
        else
            sf[k] = v
        end
        ::fail::
    end
end


return _M