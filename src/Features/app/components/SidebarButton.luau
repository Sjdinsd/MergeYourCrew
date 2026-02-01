local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local react_ripple = require(ReplicatedStorage.Packages["react-ripple"])
local e = React.createElement

return function(props: {
	LayoutOrder: number,
	Size: UDim2,
	ImageID: string,
	Title: string,
	ButtonCallback: () -> nil,
})
	local sizeBinding, sizeSpring = react_ripple.useSpring(props.Size, react_ripple.config.figmaQuick)

	local hoverSize = React.useMemo(function()
		-- print(UDim2.fromScale(props.Size.X.Scale * 1.1, props.Size.Y.Scale * 1.1))
		return UDim2.fromScale(props.Size.X.Scale * 1.05, props.Size.Y.Scale * 1.05)
	end)

	return e("Frame", {
		Size = sizeBinding,
		LayoutOrder = props.LayoutOrder,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {}),
		ImageButton = e("ImageButton", {
			Size = UDim2.fromScale(1, 1),
			Image = props.ImageID,
			BackgroundTransparency = 1,

			[React.Event.MouseEnter] = function()
				sizeSpring:setGoal(hoverSize)
			end,
			[React.Event.MouseLeave] = function()
				sizeSpring:setGoal(props.Size)
			end,
			[React.Event.Activated] = function()
				props.ButtonCallback()
				sizeSpring:setGoal(props.Size)
			end,
		}),
		TitleLabel = e("TextLabel", {
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.fromScale(1, 0.3),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextScaled = true,
			BackgroundTransparency = 1,
			Font = Enum.Font.SourceSansBold,
			TextColor3 = Color3.new(1, 1, 1),
			Text = props.Title,
			ZIndex = 2,
		}, {
			UIStroke = e("UIStroke", {
				StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
				Thickness = 0.05,
			}),
		}),
	})
end
