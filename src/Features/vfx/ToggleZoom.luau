local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ripple = require(ReplicatedStorage.Packages.ripple)
local sift = require(ReplicatedStorage.Packages.sift)

local camera = workspace.CurrentCamera

local UNTOGGLED_FOV = 70
local TOGGLED_FOV = 50

local zoomSpring = ripple.createSpring(UNTOGGLED_FOV, sift.Dictionary.join(ripple.config.figmaQuick, { start = true }))
zoomSpring:onChange(function(v)
	camera.FieldOfView = v
end)
return function(enabled, fov: number?)
	if enabled then
		zoomSpring:setGoal(fov or TOGGLED_FOV)
	else
		zoomSpring:setGoal(UNTOGGLED_FOV)
	end
end
