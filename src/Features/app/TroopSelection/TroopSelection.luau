local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local sift = require(ReplicatedStorage.Packages.sift)
local react_charm = require(ReplicatedStorage.Packages["react-charm"])
local react_ripple = require(ReplicatedStorage.Packages["react-ripple"])
local ExitButton = require(ReplicatedStorage.Source.Features.App.Components.ExitButton)
local ComponentSets = require(ReplicatedStorage.Source.Features.App.Modules.ComponentSets)
local Buffs = require(ReplicatedStorage.Source.Features.App.TroopSelection.Buffs)
local TroopInfo = require(ReplicatedStorage.Source.Features.App.TroopSelection.TroopInfo)
local TroopOptions = require(ReplicatedStorage.Source.Features.App.TroopSelection.TroopOptions)
local UIController = require(ReplicatedStorage.Source.Features.App.UIController)
local UISlice = require(ReplicatedStorage.Source.Features.App.UISlice)
local PlotSlice = require(ReplicatedStorage.Source.Features.Plots.PlotSlice)
local e = React.createElement

local EXIT_SHOWN = UDim2.new(1, -10, 0, 10)
local EXIT_HIDDEN = UDim2.new(1.4, 0, 0, -10)

return function(props: {})
	local exitPosBinding, exitPosSpring = react_ripple.useSpring(EXIT_HIDDEN)
	local isShown = react_charm.useAtom(UISlice.shownComponents)

	React.useEffect(function()
		if sift.Array.equals(ComponentSets.TroopInfoComponents, isShown) then
			exitPosSpring:setGoal(EXIT_SHOWN)
		else
			exitPosSpring:setGoal(EXIT_HIDDEN)
		end
	end, { isShown })

	return e(React.Fragment, nil, {
		TroopInfo = TroopInfo({}),
		ExitTroopSelection = ExitButton({
			TargetMenuOrCallback = function()
				UIController:clearComponents()
				UIController:bulkShowComponents(ComponentSets.IniitalComponents)
				PlotSlice.SelectedTroop(nil)
			end,
			Position = exitPosBinding,
			Size = UDim2.fromScale(0.15, 0.15),
			AnchorPoint = Vector2.new(1, 0),
		}),
		Buffs = Buffs({}),
		TroopOptions = TroopOptions({}),
	})
end
