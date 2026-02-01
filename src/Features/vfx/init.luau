local ReplicatedStorage = game:GetService("ReplicatedStorage")

local charm = require(ReplicatedStorage.Packages.charm)
local UISlice = require(ReplicatedStorage.Source.Features.App.UISlice)

local VFX = {}

function VFX.init()
	for _, module in script:GetChildren() do
		VFX[module.Name] = require(module)
	end

	-- Global effect listeners
	charm.subscribe(UISlice.shownMenu, function(shownMenu)
		if shownMenu ~= nil then
			VFX.ToggleZoom(true)
			VFX.ToggleBlur(true)
		else
			VFX.ToggleZoom(false)
			VFX.ToggleBlur(false)
		end
	end)
end

return VFX
