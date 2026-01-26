local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- local ComponentLoader = require(ReplicatedStorage.Source.Shared.Modules.Framework.ComponentLoader)
local ModuleLoader = require(ReplicatedStorage.Source.Shared.Modules.Framework.ModuleLoader)
local MountUI = require(ReplicatedStorage.Source.StartUp.MountUI)

-- local FEATURE_SERVICE_TAG = "FeatureServiceClient"

local client = ReplicatedStorage.Source.Features

local services = {
	client:FindFirstChild("Game"),
	client:FindFirstChild("Core"),
}
-- local components = {
-- 	client.Components,
-- }
-- print(services)
for _, folder in services do
	ModuleLoader(folder)
end

-- for _, folder in components do
-- 	ComponentLoader(folder)
-- end

-- for _, module in CollectionService:GetTagged(FEATURE_SERVICE_TAG) do
-- 	ModuleLoader(module)
-- end

MountUI()
