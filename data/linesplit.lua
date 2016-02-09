-- 字符串断行函数

function cutChrCHN(txt,w)
	local w = w or 35
	local chr = utf8:new(txt)
	local x = ""
	local y = ""
	local z = ""
	local num_count = 0
	local line_count = 0
	local check_chr = ""
	local sharp = false
	for i = 1 , chr:len() do
		check_chr = chr:sub(i,i)
		if sharp and check_chr ~= "#" then
			x = x..check_chr
		elseif check_chr == "#" and sharp ~= true then
			sharp = true
			x = x..check_chr
		elseif check_chr == "#" and sharp == true then
			sharp = false
			x = x..check_chr
		elseif string.find(check_chr,"[%w%p]") then
			if line_count > w-0.5 then
				x = x.."\n"..z..check_chr
				z = ""
				line_count = num_count
			else
				z = z..check_chr
				num_count = num_count + 0.5
			end
		elseif check_chr == "\n" then 
			if z == "" then
				x = x.."\n"
				line_count = 0
				num_count = 0
			else
				x = x..z.."\n"
				num_count = 0
				line_count  = 0
				z = ""
			end
		else
			if z == "" then
				if line_count > w-0.5 then 
					if check_chr == "，" or check_chr == "。" or check_chr == "？" or check_chr == "；" or check_chr == "！" or check_chr == "：" then
						x = x..check_chr.."\n"
						line_count = 0
					else
						x = x.."\n"..check_chr
						line_count = 1
					end
				else
					x = x..check_chr
					line_count = line_count + 1
				end
			else
				if line_count+num_count > w-0.5 then
					if check_chr == "，" or check_chr == "。" or check_chr == "？" or check_chr == "；" or check_chr == "！" or check_chr == "："  then
						x = x..z..check_chr.."\n"
						line_count = 0
						z = ""
						num_count = 0
					else
						x = x..z.."\n"..check_chr
						line_count = 1
						z = ""
						num_count = 0
					end
				else
					x = x..z..check_chr
					line_count = line_count + num_count +1
					z = ""
					num_count = 0
				end
			end
		end
	end
	x = x..z
	return x
end

-- 删除字符串中的空格和制表符
function delSpaceTxt(txt)
	local chr = utf8:new(txt)
	local chr_new = ""
	local len_chr = chr:len()
	for i = 1 , len_chr do
		if chr:sub(i,i) ~= " " and  chr:sub(i,i) ~= "\t" then
			chr_new = chr_new..chr:sub(i,i)
		elseif i~=1 and chr:sub(i-1,i-1) == '%w' then 
			chr_new = chr_new..chr:sub(i,i)
		end
	end
	return chr_new

end

--tString类型字符断行函数，w为行宽
function descLine(ts,w)
	local w = w or 20
	local count = 0
	local enchar
	if type(ts) == "table" then
		for i = 1,#ts do
			if ts[i] == true then
				count = 0
			elseif type(ts[i]) == "string" then
				ts[i] = ts[i]:gsub(" ","")
				if ts[i] == "" then
					if ts[i+1] == "" then
						ts[i] = 0
						ts[i+1] = 0
						i = i + 2
					elseif count > w and ts[i+1] ~= "，" and ts[i+1] ~= "。" and ts[i+1] ~= "？" and ts[i+1] ~= "；" and ts[i+1] ~= "！" and ts[i+1] ~= "：" and ts[i+1] ~= "、" and ts[i+1] ~= "）" then
						ts[i] = true
						count = 0
					else ts[i] = 0
					end
				elseif ts[i]:toString():find("[%w%p]") then
					enchar = utf8:new(ts[i])
					count = count + enchar:len() / 2
				else
					count = count + 1
				end
			end
		end
	end
	return ts
end

function string:uncapitalize(str)
	if not str then return end

	local ch = str:sub(1,1)
	local len = string.len(str)  

	ch = string.lower(ch)  
	if len == 1 then  
             return ch  
        else  
             return ch .. string.sub(str, 2, len)  
        end 
end

function translateSub(str)
	if not str then return end
	str = str:gsub("%%","%%%%")
	str = str:gsub("%+","%%+")
	str = str:gsub("%-","%%-")
	str = str:gsub("%*","%%*")
	str = str:gsub("%(","%%(")
	str = str:gsub("%)","%%)")
	str = str:gsub("%?","%%?")
	str = str:gsub("%.","%%.")
	
	return str
end

