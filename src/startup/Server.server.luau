local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

-- local ComponentLoader = require(ReplicatedStorage.Source.Shared.Modules.Framework.ComponentLoader)
local ModuleLoader = require(ReplicatedStorage.Source.Shared.Modules.Framework.ModuleLoader)

-- local FEATURE_SERVICE_TAG = "FeatureServiceServer"

local server = ServerScriptService.Features

local services = {
	server:FindFirstChild("Game"),
	server:FindFirstChild("Core"),
}
-- local components = {
-- 	server.Components,
-- }
for _, folder in services do
	ModuleLoader(folder)
end

-- for _, folder in components do
-- 	ComponentLoader(folder)
-- end

-- for _, module in CollectionService:GetTagged(FEATURE_SERVICE_TAG) do
-- 	ModuleLoader(module)
-- end
