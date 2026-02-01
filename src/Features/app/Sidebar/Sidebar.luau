local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local react_charm = require(ReplicatedStorage.Packages["react-charm"])
local react_ripple = require(ReplicatedStorage.Packages["react-ripple"])
local SidebarButton = require(ReplicatedStorage.Source.Features.App.Components.SidebarButton)
local UIController = require(ReplicatedStorage.Source.Features.App.UIController)
local UISlice = require(ReplicatedStorage.Source.Features.App.UISlice)
local ImageIDs = require(ReplicatedStorage.Source.Game.Items.ImageIDs)
local e = React.createElement

local l = 0
local function nextLayout()
	l += 1
	return l
end

local SHOWN_POS = UDim2.fromScale(0.015, 0.5)
local HIDDEN_POS = UDim2.fromScale(-0.5, 0.5)

return function(props: {})
	local posBinding, posSpring = react_ripple.useSpring(HIDDEN_POS, react_ripple.config.figmaQuick)
	local isShown = react_charm.useAtom(UISlice.shownComponents)

	React.useEffect(function()
		if table.find(isShown, "Sidebar") then
			posSpring:setGoal(SHOWN_POS)
		else
			posSpring:setGoal(HIDDEN_POS)
		end
	end, { isShown })

	return e("Frame", {
		Size = UDim2.fromScale(0.15, 0.15),
		Position = posBinding,
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
	}, {
		UIAspectRatioConstraint = e("UIAspectRatioConstraint"),
		UIListLayout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		ShopButton = SidebarButton({
			LayoutOrder = nextLayout(),
			Size = UDim2.fromScale(1, 1),
			ImageID = ImageIDs.ShopButton,
			Title = "Shop",
			ButtonCallback = function()
				UIController:toggleMenu("ShopMenu")
			end,
		}),
		UpgradesButton = SidebarButton({
			LayoutOrder = nextLayout(),
			Size = UDim2.fromScale(1, 1),
			ImageID = ImageIDs.UpgradesButton,
			Title = "Upgrades",
			ButtonCallback = function()
				UIController:toggleMenu("UpgradesMenu")
			end,
		}),
		RebirthButton = SidebarButton({
			LayoutOrder = nextLayout(),
			Size = UDim2.fromScale(1, 1),
			ImageID = ImageIDs.RebirthButton,
			Title = "Rebirth",
			ButtonCallback = function()
				UIController:toggleMenu("RebirthMenu")
			end,
		}),
	})
end
