local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local React = require(ReplicatedStorage.Packages.React)
local react_ripple = require(ReplicatedStorage.Packages["react-ripple"])
local ImageIDs = require(ReplicatedStorage.Source.Game.Items.ImageIDs)
local e = React.createElement

return function(props: {
	Color: Color3,
	Size: UDim2,
	TileSize: UDim2,
	Position: UDim2?,
	AnchorPoint: Vector2?,
	ActivatedEvent: () -> any,
} & any)
	local sizeBinding, sizeSpring = react_ripple.useSpring(props.Size, react_ripple.config.figmaQuick)
	local hoveredSize = React.useMemo(function()
		return UDim2.fromScale(props.Size.X.Scale * 1.05, props.Size.Y.Scale * 1.05)
	end, { props.Size })
	local activatedSize = React.useMemo(function()
		return UDim2.fromScale(props.Size.X.Scale * 1.1, props.Size.Y.Scale * 1.1)
	end, { props.Size })

	return e("ImageButton", {
		Image = ImageIDs.StuddedBackground,
		ImageTransparency = 0.5,
		BackgroundColor3 = props.Color,
		BorderSizePixel = 0,
		Size = sizeBinding,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = props.TileSize,
		[React.Event.MouseButton1Up] = function()
			sizeSpring:setGoal(props.Size)
		end,
		[React.Event.MouseButton1Down] = function()
			props.ActivatedEvent()
			sizeSpring:setGoal(activatedSize)
		end,
		[React.Event.MouseEnter] = function()
			sizeSpring:setGoal(hoveredSize)
		end,
		[React.Event.MouseLeave] = function()
			sizeSpring:setGoal(props.Size)
		end,
	}, props.children)
end
