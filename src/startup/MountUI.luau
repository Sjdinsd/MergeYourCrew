local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)

local container = Instance.new("ScreenGui")
container.IgnoreGuiInset = true
container.ResetOnSpawn = false
container.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
container.ClipToDeviceSafeArea = false

local features = ReplicatedStorage.Source.Features

return function()
	local player = Players.LocalPlayer
	local playerGui = player:WaitForChild("PlayerGui")

	local RootUI = require(features.App.RootUI)
	container.Parent = playerGui

	local root = ReactRoblox.createRoot(container)
	local app = React.createElement(RootUI)
	root:render(app)
end
