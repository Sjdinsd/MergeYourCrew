local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)

local templateContainer = Instance.new("ScreenGui")
templateContainer.IgnoreGuiInset = true
templateContainer.ResetOnSpawn = false
templateContainer.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
templateContainer.ClipToDeviceSafeArea = false

local features = ReplicatedStorage.Source.Features

return function()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")
	-- Make a root for each folder under Features/App
	for _, folder in features.App:GetChildren() do
		local rootUIModule = folder:WaitForChild("RootUI", 5)
		if not rootUIModule then
			continue
		end
		local RootUI = require(rootUIModule)
		local container = templateContainer:Clone()
		container.Name = folder.Name
		container.Parent = playerGui

		local root = ReactRoblox.createRoot(container)
		local app = React.createElement(RootUI)
		root:render(app)
	end
end
