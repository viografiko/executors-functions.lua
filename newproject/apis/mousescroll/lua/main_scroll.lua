--[[
 PLEASE CHECK, I MADED THIS AT ROBLOX STUDIO, SO MAKE SURE TO REMOVE POSTASYNC
AND USE A HTTPLIB.
]]
local HttpService = game:GetService("HttpService")
local plr = game.Players.LocalPlayer

local function mousescroll(number)
	local url = "http://127.0.0.1:5000/mousescroll"
	local data = HttpService:JSONEncode({scroll = number})
	HttpService:PostAsync(url, data)
end

--[[
mousescroll(120) 
mousescroll(-120) 
]]
