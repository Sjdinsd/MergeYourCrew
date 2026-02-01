local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local React = require(ReplicatedStorage.Packages.React)
local ImageIDs = require(ReplicatedStorage.Source.Game.Items.ImageIDs)
local e = React.createElement

return function(props: {
	Color: Color3,
	Size: UDim2,
	Transparency: number?,
	TileSize: UDim2,
	Position: UDim2?,
	AnchorPoint: Vector2?,
} & any)
	return e("ImageLabel", {
		Image = ImageIDs.StuddedBackground,
		ImageTransparency = props.Transparency,
		BackgroundTransparency = props.Transparency,
		BackgroundColor3 = props.Color,
		Size = props.Size,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = props.TileSize,
	}, props.children)
end
