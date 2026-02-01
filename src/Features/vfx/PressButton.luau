local TweenService = game:GetService("TweenService")

local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In, 0, true)

return function(buttonHead: BasePart, originalPos: Vector3, depth: number)
	TweenService:Create(buttonHead, info, {
		Position = originalPos - (Vector3.yAxis * depth),
	}):Play()
end
