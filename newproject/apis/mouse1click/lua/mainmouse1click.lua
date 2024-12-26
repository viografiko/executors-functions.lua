local HttpService = game:GetService("HttpService")
local plr = game.Players.LocalPlayer

local function mouse1click()
    local url = "http://127.0.0.1:5000/mouse1click"
    HttpService:PostAsync(url, "")
end

--[[
mouse1click()
]]
