local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local react_charm = require(ReplicatedStorage.Packages["react-charm"])
local react_ripple = require(ReplicatedStorage.Packages["react-ripple"])
local ExitButton = require(ReplicatedStorage.Source.Features.App.Components.ExitButton)
local Window = require(ReplicatedStorage.Source.Features.App.Components.Window)
local UISlice = require(ReplicatedStorage.Source.Features.App.UISlice)
local e = React.createElement

local SHOWN_POS = UDim2.fromScale(0.5, 0.55)
local HIDDEN_POS = UDim2.fromScale(0.5, 1.5)

local COMPONENT_NAME = "ShopMenu"

return function(props: {})
	local posBinding, posSpring = react_ripple.useSpring(HIDDEN_POS, react_ripple.config.figmaQuick)
	local activeMenu = react_charm.useAtom(UISlice.shownMenu)

	React.useEffect(function()
		if activeMenu == COMPONENT_NAME then
			posSpring:setGoal(SHOWN_POS)
		else
			posSpring:setGoal(HIDDEN_POS)
		end
	end, { activeMenu })

	return e(Window, {
		Title = "Rebirth",
		Position = posBinding,
	}, {
		ExitButton = ExitButton({ TargetMenuOrCallback = COMPONENT_NAME }),
	})
end
