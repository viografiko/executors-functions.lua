--[[
 PLEASE CHECK, I MADED THIS AT ROBLOX STUDIO, SO MAKE SURE TO REMOVE POSTASYNC
AND USE A HTTPLIB.
]]
local HttpService = game:GetService("HttpService")

local function mousemoverel(x, y)
	local url = "http://127.0.0.1:5000/mousemoverel" 
	local data = {
		x = x,
		y = y
	}

	local success, response = pcall(function()
		return HttpService:PostAsync(url, HttpService:JSONEncode(data), Enum.HttpContentType.ApplicationJson)
	end)

	if success then
		print("sucess 200:", response)
	else
		warn("error 404:", response)
	end
end
--[[
while wait(1) do
	mousemoverel(100, 50) 
end
]]
