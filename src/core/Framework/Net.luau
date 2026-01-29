local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local isServer = RunService:IsServer()

local eventFolder = ReplicatedStorage:FindFirstChild("NET/EVENT")
local functionFolder = ReplicatedStorage:FindFirstChild("NET/FUNC")

if isServer then
	eventFolder = eventFolder or Instance.new("Folder")
	functionFolder = functionFolder or Instance.new("Folder")
	eventFolder.Name = "NET/EVENT"
	eventFolder.Parent = ReplicatedStorage
	functionFolder.Name = "NET/FUNC"
	functionFolder.Parent = ReplicatedStorage
else
	eventFolder = ReplicatedStorage:WaitForChild("NET/EVENT", 10)
	functionFolder = ReplicatedStorage:WaitForChild("NET/FUNC", 10)
	if not eventFolder or not functionFolder then
		error("Network folders not created by server")
	end
end

local eventCache = {}
local functionCache = {}

local SERVER_TIMEOUT = 2

local Net = {}
Net.__index = Net

function Net:RemoteEvent(name): RemoteEvent
	if isServer then
		if eventCache[name] then
			return eventCache[name]
		end
		local newEvent = Instance.new("RemoteEvent")
		newEvent.Name = name
		newEvent.Parent = eventFolder
		eventCache[name] = newEvent
		return newEvent
	else
		if eventCache[name] then
			return eventCache[name]
		end
		local foundEvent = eventFolder:FindFirstChild(name)

		if not foundEvent then
			local running = coroutine.running()

			local connection
			connection = eventFolder.ChildAdded:Connect(function(newEvent)
				if newEvent.Name ~= name then
					return
				end
				foundEvent = newEvent
				connection:Disconnect()
				coroutine.resume(running)
			end)

			task.delay(SERVER_TIMEOUT, function()
				connection:Disconnect()
				coroutine.resume(running)
			end)

			coroutine.yield()

			if foundEvent then
				eventCache[name] = foundEvent
				return foundEvent
			else
				error(`RemoteEvent '{name}' not created on server within timeout`)
			end
		else
			eventCache[name] = foundEvent
			return foundEvent
		end
	end
end

function Net:RemoteFunction(name): RemoteFunction
	if isServer then
		if functionCache[name] then
			return functionCache[name]
		end
		local newFunction = Instance.new("RemoteFunction")
		newFunction.Name = name
		newFunction.Parent = functionFolder
		functionCache[name] = newFunction
		return newFunction
	else
		if functionCache[name] then
			return functionCache[name]
		end
		local foundFunction = functionFolder:FindFirstChild(name)

		if not foundFunction then
			local running = coroutine.running()

			local connection
			connection = functionFolder.ChildAdded:Connect(function(newFunction)
				if newFunction.Name ~= name then
					return
				end
				foundFunction = newFunction
				connection:Disconnect()
				coroutine.resume(running)
			end)

			task.delay(SERVER_TIMEOUT, function()
				connection:Disconnect()
				coroutine.resume(running)
			end)

			coroutine.yield()

			if foundFunction then
				functionCache[name] = foundFunction
				return foundFunction
			else
				error(`RemoteFunction '{name}' not created on server within timeout`)
			end
		else
			functionCache[name] = foundFunction
			return foundFunction
		end
	end
end

return setmetatable({}, Net)
