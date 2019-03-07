local vararglen
do
	local maxidx
	do
		local max = math.max
		local pairs = pairs
		local type = type
		function maxidx(t)
			local maxi=0
			for k,v in pairs(t) do
				if type(k)=="number" then
					if not maxi then
						maxi = k
					else
						maxi = max(maxi, k)
					end
				end
			end
			return maxi
		end
	end
	local detectors = {
		pcall,
		tostring,
		tonumber,
		type,
	}

	local detector
	for i=1,#detectors do
		local v = detectors[i]
		if v and not pcall(v) and pcall(v, nil) then
			detector = v
			break
		end
	end
	if not detector then
		error("unable to detect vararg len")
	end

	local select = select
	local pcall = pcall
	function vararglen(...)
		--local i = #{...} -- start at the last known item (or 0)
		local i = maxidx({...})
		local ok
		while true do
			i = i+1
			if not pcall(detector, select(i,...)) then
				return i-1
			end
		end
	end
end
return vararglen
