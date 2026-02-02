local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local React = require(ReplicatedStorage.Packages.React)
local RootUI = require(ReplicatedStorage.Source.Features.App.RootUI)
local e = React.createElement
print("Story is required")
local function story(target)
	print("Story is attempting render")
	local root = ReactRoblox.createLegacyRoot(target)
	root:render(e(RootUI, {}, {}))

	return function()
		root:unmount()
	end
end

return story
