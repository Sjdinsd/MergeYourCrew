local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local sift = require(ReplicatedStorage.Packages.sift)
local react_charm = require(ReplicatedStorage.Packages["react-charm"])
local react_ripple = require(ReplicatedStorage.Packages["react-ripple"])
local UISlice = require(ReplicatedStorage.Source.Features.App.UISlice)
local PlotServiceUtils = require(ReplicatedStorage.Source.Features.Plots.PlotServiceUtils)
local DataService = require(ReplicatedStorage.Source.Core.Framework.DataService).client
local e = React.createElement

local IDX_TO_BUFF = {
	[1] = "Damage",
	[2] = "Money",
	[3] = "Firerate",
}

local IDX_TO_COLOR = {
	[1] = Color3.new(1, 0, 0),
	[2] = Color3.new(0, 1, 0),
	[3] = Color3.new(1, 1, 0),
}

local SHOWN_POS = UDim2.new(0, 10, 0.5, 0)
local HIDDEN_POS = UDim2.new(-0.25, 10, 0.5, 0)

return function(props: {})
	local posBinding, posSpring = react_ripple.useSpring(HIDDEN_POS)
	local isShown = react_charm.useAtom(UISlice.shownComponents)

	React.useEffect(function()
		if table.find(isShown, "Buffs") then
			posSpring:setGoal(SHOWN_POS)
		else
			posSpring:setGoal(HIDDEN_POS)
		end
	end, { isShown })

	local buffData, setBuffData = React.useState({})
	React.useEffect(function()
		DataService:getChangedSignal({ "Upgrades" }):Connect(function(upgradeData)
			setBuffData(upgradeData)
		end)
	end, {})

	local buffElements = {}
	for i = 1, 3 do
		local buff = IDX_TO_BUFF[i]
		local buffValue = React.useMemo(function()
			return PlotServiceUtils.calculateBuff(buff, buffData[buff] or 0)
		end, { buffData })
		local buffElement = e("Frame", {
			Size = UDim2.fromScale(1, 1.5),
			LayoutOrder = i,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		}, {
			UIListLayout = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
			}),
			BuffImage = e("ImageLabel", {
				Size = UDim2.fromScale(0.5, 1),
				Image = `{buff}Icon`,
				LayoutOrder = 1,
				BackgroundTransparency = 0.2,
				BorderSizePixel = 0,
			}, {
				UIAspectRatioConstraint = e("UIAspectRatioConstraint"),
			}),
			BuffText = e("TextLabel", {
				Size = UDim2.fromScale(0.3, 1.4),
				Text = `+{buffValue}%`,
				TextScaled = true,
				TextColor3 = IDX_TO_COLOR[i],
				LayoutOrder = 2,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
			}),
		})

		buffElements[i] = buffElement
	end

	return e(
		"Frame",
		{
			Size = UDim2.fromScale(0.1, 0.05),
			AnchorPoint = Vector2.new(0, 0.5),
			Position = posBinding,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
		},
		sift.Dictionary.join({
			UIListLayout = e("UIListLayout", {
				FillDirection = Enum.FillDirection.Vertical,
				VerticalAlignment = Enum.VerticalAlignment.Top,
				SortOrder = Enum.SortOrder.LayoutOrder,
			}),
			BuffTitle = e("TextLabel", {
				Text = "~ Buffs ~",
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				TextScaled = true,
				LayoutOrder = 0,
			}),
		}, buffElements)
	)
end
