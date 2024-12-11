-- full working setreadonly
local function setreadonly(obj, value)
    local mt = getmetatable(obj)
    
    if mt and type(mt) == "table" then
        if value == true then
            mt.__oldindex = mt.__newindex
            mt.__newindex = _cclosure(function() error("attempt to modify a readonly table", 0) end)
        else
            if mt.__oldindex then
                mt.__newindex = mt.__oldindex
                mt.__oldindex = nil
            elseif mt.__readonly then
                mt.__newindex = nil
                mt.__readonly = nil
            end
        end
    elseif not mt then
        setmetatable(obj, {
            __newindex = _cclosure(function() error("attempt to modify a readonly table", 0) end),
            __readonly = true
        })
    else
        error("unable to safely freeze table")
    end
end
-- full working getrawmetatable
local function getrawmetatable(obj)
    local meta = getmetatable(obj)
    if meta and meta.__index == meta then
        return meta
    end
    return nil
end
-- non-hookmetamethod
local function hookmetamethod(object, method, newFunction)
    local meta = getrawmetatable(object)
    if meta then
        local oldFunction = meta[method]
        setreadonly(meta, false)
        meta[method] = newFunction(oldFunction)
        setreadonly(meta, true)
    end
end
local function cryptencrypt(str,data,str2,key)
        local str3 = ""
        for i = 1,#str do
            str3 = str3..string.char(string.byte(str,i)+string.byte(data,i))
        end
        local str4 = ""
        for i = 1,#str3 do
            str4 = str4..string.char(string.byte(str3,i)+string.byte(str2,i))
        end
        local str5 = ""
        for i = 1,#str4 do
            str5 = str5..string.char(string.byte(str4,i)+key)
        end
        return str5
    end
local function base64encode(str, data)
    local base64chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local base64 = {}
    local padding = ""
    local bitstring = ""
    local charmap = {}
    local str_len = #str

    for i = 1, str_len do
        local byte = string.byte(str, i)
        bitstring = bitstring .. string.format("%08b", byte)  
    end

    
    local padding_needed = #bitstring % 24
    if padding_needed ~= 0 then
        padding_needed = 24 - padding_needed
        padding = string.rep("=", padding_needed / 8)
        bitstring = bitstring .. string.rep("0", padding_needed) 
    end

    
    for i = 1, #bitstring, 6 do
        local chunk = bitstring:sub(i, i + 5)
        local index = tonumber(chunk, 2)
        base64[#base64 + 1] = base64chars:sub(index + 1, index + 1)  
    end


    return table.concat(base64) .. padding
end
local function cryptrandom(number,size)
    local random = Random.new(number)
    local characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local result = ""
    for i = 1, size do
        local randomIndex = random:NextInteger(1, #characters)
        result = result .. characters:sub(randomIndex, randomIndex)
    end
    return result
end
-- non-getconnections
local function getconnections()
    local connections = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") or v:IsA("BindableEvent") or v:IsA("BindableFunction") then
            for _, connection in pairs(v:GetChildren()) do
                if connection:IsA("Connection") then
                    table.insert(connections, connection)
                end
            end
        end
    end
    return connections
end
