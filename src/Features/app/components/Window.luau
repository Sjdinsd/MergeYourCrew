local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local sift = require(ReplicatedStorage.Packages.sift)
local StuddedFrame = require(ReplicatedStorage.Source.Features.App.Components.StuddedFrame)
local e = React.createElement

local DEFAULT_ASPECT_RATIO = 1.5

return function(props: {
	Title: string,
	Size: UDim2?,
	Position: UDim2,
	AspectRatio: number?,
	[any]: any,
})
	return e(
		StuddedFrame,
		{
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = props.Position,
			Size = props.Size or UDim2.fromScale(0.6, 0.6),
			Transparency = 0.6,
			TileSize = UDim2.fromScale(
				1 / 2 / (props.AspectRatio or DEFAULT_ASPECT_RATIO),
				1 / 1.5 / (props.AspectRatio or DEFAULT_ASPECT_RATIO)
			),
			Color = Color3.new(0.05, 0.05, 0.05),
		},
		sift.Dictionary.join({
			UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
				AspectRatio = props.AspectRatio or DEFAULT_ASPECT_RATIO,
			}),
			UICorner = e("UICorner", {
				CornerRadius = UDim.new(0.05, 0),
			}),
			UIStroke = e("UIStroke", {
				StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
				Thickness = 0.01,
				Transparency = 0.4,
			}),
		}),
		props.children
	)
end
