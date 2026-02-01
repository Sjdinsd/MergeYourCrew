local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local Menu = require(ReplicatedStorage.Source.Features.App.Menus.Menu)
local Sidebar = require(ReplicatedStorage.Source.Features.App.Sidebar.Sidebar)
local TroopSelection = require(ReplicatedStorage.Source.Features.App.TroopSelection.TroopSelection)
local StartFightingButton = require(ReplicatedStorage.Source.Features.Plots.UI.StartFightingButton)
local e = React.createElement

return function()
	return e(React.Fragment, nil, {
		StartFightingButton = StartFightingButton({}),
		Sidebar = Sidebar({}),
		Menu = Menu({}),
		TroopSelection = TroopSelection({}),
	})
end
