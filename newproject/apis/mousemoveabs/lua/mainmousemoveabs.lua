local HttpService = game:GetService("HttpService")

local function mousemoveabs(x, y)
	local url = "http://127.0.0.1:5000/mousemoveabs"  
	local data = {
		x = x,
		y = y
	}

	local success, response = pcall(function()
		return HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
	end)

	if success then
		--print("200 sucess:", response)
	else
		warn("404 error:", response)
	end
end

--[[
while wait(1) do
	mousemoveabs(500, 300)
end
]]
