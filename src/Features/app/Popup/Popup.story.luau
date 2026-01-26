local ReplicatedStorage = game:GetService("ReplicatedStorage")

local RootUI = require(ReplicatedStorage.Source.Features.App.Popup.RootUI)
local React = require(ReplicatedStorage.Packages.React)
local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)

return function(parent)
	local root = ReactRoblox.createRoot(parent)
	local app = React.createElement(RootUI)
	root:render(app)

	return function()
		root:unmount()
	end
end
