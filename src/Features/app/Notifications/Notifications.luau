local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local NotificationPopup = require(ReplicatedStorage.Source.Features.App.Notifications.NotificationPopup)
local e = React.createElement

return function(props: {})
	return e("Frame", {
		Size = UDim2.fromScale(1, 1),
	}, {
		UIListLayout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
		}),
		NotificationPopup({}),
	})
end
