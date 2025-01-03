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
-- non-hookmetamethod (upgraded)
local function hookmetamethod(object, method, newFunction)
    if typeof(object) ~= "Instance" and typeof(object) ~= "table" then
        error("Expected object to be an Instance or table.")
    end

    if typeof(method) ~= "string" then
        error("Expected method to be a string.")
    end

    if typeof(newFunction) ~= "function" then
        error("Expected newFunction to be a function.")
    end
    local meta = getrawmetatable(object)
    if not meta then
        error("Failed to retrieve metatable.")
    end
    local oldMeta = meta[method]
    if not oldMeta then
        error("Specified method not found in metatable.")
    end

    setreadonly(meta, false)
    meta[method] = function(...)
        return newFunction(oldMeta, ...)
    end
    setreadonly(meta, true)
end

-- non-getconnections (upgraded)
local function getconnections()
    if typeof(signal) ~= "Instance" or not signal:IsA("BindableEvent") and not signal:IsA("BindableFunction") and not signal:IsA("RemoteEvent") and not signal:IsA("RemoteFunction") then
        error("Expected a signal instance (e.g., BindableEvent, RemoteEvent, etc.)")
    end


    local connections = {}
    local internalGetConnections = getrawmetatable(game).__index


    for _, connection in pairs(internalGetConnections(signal)) do
        table.insert(connections, connection)
    end

    return connections
end
-- full getnamecallmethod
local function getnamecallmethod()
    return debug.getinfo(2, "n").name
end
-- full gethui
local function gethui()
    local uis = {} 

    local CoreGui = game:GetService("CoreGui")
    local Players = game:GetService("Players")
    local Player = Players.LocalPlayer
    local PlayerGui = Player and Player:FindFirstChild("PlayerGui")

    local function collectUIElements(parent)
        for _, child in ipairs(parent:GetDescendants()) do
            if child:IsA("ScreenGui") or child:IsA("Frame") or child:IsA("TextLabel") or child:IsA("TextButton") or child:IsA("ImageLabel") then
                table.insert(uis, child)
            end
        end
    end

    collectUIElements(CoreGui)

    if PlayerGui then
        collectUIElements(PlayerGui)
    end

    return uis
end
-- getthreadcontext full with upgraded checks
local function getthreadcontext()
    local contextInfo = {
        level = 1,        
        type = "Unknown", 
        details = {}      
    }
    local function getService(serviceName)
        local success, service = pcall(function() 
            return game:GetService(serviceName) 
        end)
        return success and service or nil
    end
    local function determineContext()
        local currentScript = script

        local coreGui = getService("CoreGui")
        if coreGui and coreGui:FindFirstChild("CoreScripts") then
            contextInfo.level = 8
            contextInfo.type = "CoreScript"
            return
        end
        if not currentScript then 
            contextInfo.type = "NoScriptContext"
            return 
        end
        if currentScript.ClassName == "LocalScript" then
            if currentScript.Parent and currentScript.Parent:IsA("Player") then
                contextInfo.level = 4
                contextInfo.type = "PlayerLocalScript"
                contextInfo.details.player = currentScript.Parent
            else
                contextInfo.level = 3
                contextInfo.type = "LocalScript"
            end
            return
        end
        if currentScript.ClassName == "Script" then
            local parent = currentScript.Parent
            if parent then
                if parent:IsA("Workspace") then
                    contextInfo.level = 5
                    contextInfo.type = "WorkspaceScript"
                elseif parent:IsA("ServerScriptService") then
                    contextInfo.level = 6
                    contextInfo.type = "ServerScript"
                end
            end
            return
        end
        if currentScript:IsA("ModuleScript") then
            contextInfo.level = 2
            contextInfo.type = "ModuleScript"
            

            local success, moduleParent = pcall(function() 
                return currentScript.Parent 
            end)
            if success and moduleParent then
                contextInfo.details.parentType = moduleParent.ClassName
            end
            return
        end
        local studioService = getService("StudioService")
        if studioService and studioService:GetUserId() > 0 then
            contextInfo.level = 3
            contextInfo.type = "PluginContext"
            return
        end
    end
    determineContext()
    contextInfo.details.scriptClassName = script and script.ClassName or "None"
    contextInfo.details.environment = game:GetService("RunService"):IsServer() and "Server" or "Client"

    return contextInfo
end
-- full isreadonly
local function isreadonly(table)
    if type(table) ~= "table" then
        return false
    end

    local meta = getrawmetatable(table)
    if not meta then
        return false
    end

    local isReadonly = pcall(function()
        setreadonly(meta, false)
        table.newIndex = true
        setreadonly(meta, true)
    end)

    return not isReadonly
end
-- non-require upgraded
local function require(object)
    if object == nil then
        error("Cannot require a nil object", 2)
    end

    if typeof(object) == "Instance" then
        local success, result

        if object:IsA("ModuleScript") then
            success, result = pcall(function()
                return _G.originalRequire(object)
            end)
            if success then
                return result
            else
                error(string.format("Failed to require ModuleScript '%s': %s", object.Name, result), 2)
            end
        elseif object:IsA("Script") or object:IsA("LocalScript") then
            success, result = pcall(function()
                local loadedFunc = loadstring(object.Source)
                if not loadedFunc then
                    error("Failed to load script source")
                end
                local env = setmetatable({}, { __index = _G })
                setfenv(loadedFunc, env)
                return loadedFunc()
            end)
            if success then
                return result
            else
                error(string.format("Failed to process script '%s': %s", object.Name, result), 2)
            end
        else
            error(string.format("Cannot require Instance of type '%s'", object.ClassName), 2)
        end
    elseif typeof(object) == "table" or typeof(object) == "function" then
        return object
    elseif typeof(object) == "string" then
        local success, module = pcall(function()
            local current = game
            for part in object:gmatch("[^.]+") do
                current = current:FindFirstChild(part)
                if not current then
                    error("Could not find object at path: " .. object, 2)
                end
            end
            return require(current)
        end)
        if success then
            return module
        else
            error(string.format("Failed to require module at path '%s': %s", object, module), 2)
        end
    else
        error(string.format("Unsupported type for require: %s", typeof(object)), 2)
    end
end
-- _cclosure non
local function _cclosure(func)
    if type(func) ~= "function" then
        error("Expected a function, got " .. type(func), 2)
    end

    local upvalues = {}
    local upvalue_count = debug.getinfo(func, "u").nups

    for i = 1, upvalue_count do
        local name, value = debug.getupvalue(func, i)
        upvalues[i] = { name = name, value = value }
    end


    local function wrapped_func(...)
        return func(...)
    end

    for i, upvalue in ipairs(upvalues) do
        debug.setupvalue(wrapped_func, i, upvalue.value)
    end

    return wrapped_func
end

return _cclosure
-- newcclosure full
local function newcclosure(f)
    if type(f) ~= "function" then
        error("Expected a function, got " .. type(f), 2)
    end

    local function cclosure(...)
        return f(...)
    end

    local mt = {
        __call = function(_, ...)
            return f(...)
        end,
        __mode = "v" 
    }
    setmetatable(cclosure, mt)

    local function strip_upvalues(func)
        local upvalue_count = debug.getinfo(func, "u").nups
        for i = 1, upvalue_count do
            debug.setupvalue(func, i, nil)
        end
    end

    local success, err = pcall(function()
        strip_upvalues(cclosure)
    end)
    if not success then
        warn("Failed to strip upvalues: " .. tostring(err))
    end

    return cclosure
end

return newcclosure
-- newproxy full
local function newproxy(addMetatable)
    local proxy = newproxy(true)
    local mt = getmetatable(proxy)

    if type(addMetatable) == "table" then
        for k, v in pairs(addMetatable) do
            mt[k] = v
        end
    elseif addMetatable == nil or addMetatable == false then
    elseif addMetatable ~= true then
        error("Expected a table, true, false, or nil for addMetatable, got " .. type(addMetatable), 2)
    end

    return proxy
end

return newproxy
