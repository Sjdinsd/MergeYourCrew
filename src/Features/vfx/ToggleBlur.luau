local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ripple = require(ReplicatedStorage.Packages.ripple)
local sift = require(ReplicatedStorage.Packages.sift)

local BLUR_SIZE = 20

local blurSpring = ripple.createSpring(0, sift.Dictionary.join(ripple.config.figmaQuick, { start = true }))
blurSpring:onChange(function(v)
	Lighting.Blur.Size = v
end)
return function(enabled, size: number?)
	if enabled then
		blurSpring:setGoal(size or BLUR_SIZE)
	else
		blurSpring:setGoal(0)
	end
end
