local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- local ReactRoblox = require(ReplicatedStorage.Packages.ReactRoblox)
local React = require(ReplicatedStorage.Packages.React)
local e = React.createElement

local STUD_IMAGE_ID = "rbxassetid://108514275627954"

return function(props: {
	Color: Color3,
	Size: UDim2,
	TileSize: UDim2,
	Position: UDim2?,
	AnchorPoint: Vector2?,
} & any)
	return e("ImageLabel", {
		Image = STUD_IMAGE_ID,
		ImageTransparency = 0.5,
		BackgroundColor3 = props.Color,
		Size = props.Size,
		Position = props.Position,
		AnchorPoint = props.AnchorPoint,
		ScaleType = Enum.ScaleType.Tile,
		TileSize = props.TileSize,
	}, props.children)
end
