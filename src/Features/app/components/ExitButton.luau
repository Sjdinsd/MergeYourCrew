local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local StuddedButton = require(ReplicatedStorage.Source.Features.App.Components.StuddedButton)
local UIController = require(ReplicatedStorage.Source.Features.App.UIController)
local e = React.createElement

return function(props: {
	TargetMenuOrCallback: string | () -> nil,
	Position: UDim2?,
	Size: UDim2?,
	AnchorPoint: Vector2?,
})
	return e(StuddedButton, {
		Color = Color3.new(1, 0, 0),
		Size = props.Size or UDim2.fromScale(0.15, 0.15),
		TileSize = UDim2.fromScale(2, 2),
		Position = props.Position or UDim2.fromScale(1, 0),
		AnchorPoint = props.AnchorPoint or Vector2.new(0.5, 0.5),
		ActivatedEvent = function()
			if type(props.TargetMenuOrCallback) == "string" then
				UIController:toggleMenu(props.TargetMenuOrCallback)
			else
				props.TargetMenuOrCallback()
			end
		end,
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint"),
		TextLabel = e("TextLabel", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = "X",
			TextScaled = true,
			Font = Enum.Font.BuilderSansExtraBold,
			TextColor3 = Color3.new(1, 1, 1),
		}, { UIStroke = e("UIStroke", { Thickness = 0.025, StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize }) }),
		UICorner = e("UICorner", { CornerRadius = UDim.new(0.1, 0) }),
		UIStroke = e("UIStroke", { Thickness = 0.025, StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize }),
	})
end
