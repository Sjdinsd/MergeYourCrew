local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local RebirthMenu = require(ReplicatedStorage.Source.Features.App.Menus.RebirthMenu)
local ShopMenu = require(ReplicatedStorage.Source.Features.App.Menus.ShopMenu)
local UpgradesMenu = require(ReplicatedStorage.Source.Features.App.Menus.UpgradesMenu)
local e = React.createElement

return function(props: {})
	return e(React.Fragment, nil, {
		ShopMenu = ShopMenu({}),
		UpgradesMenu = UpgradesMenu({}),
		RebirthMenu = RebirthMenu({}),
	})
end
