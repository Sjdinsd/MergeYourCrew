local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local react_charm = require(ReplicatedStorage.Packages["react-charm"])
local react_ripple = require(ReplicatedStorage.Packages["react-ripple"])
local UISlice = require(ReplicatedStorage.Source.Features.App.UISlice)
local PlotSlice = require(ReplicatedStorage.Source.Features.Plots.PlotSlice)
local TroopData = require(ReplicatedStorage.Source.Game.Data.TroopData)
local e = React.createElement

local function rpmToRps(rpm)
	return 60 / rpm
end

local HIDDEN_POS = UDim2.fromScale(0.5, -0.9)
local SHOWN_POS = UDim2.fromScale(0.5, 0.02)

local DEBUG_VALUES = {
	Name = "",
	Level = 0,
	Damage = 0,
	Firerate = 1,
}

local function AnimatedLabel(props: {
	Text: string,
	Color: Color3,
	InitSize: UDim2,
	LayoutOrder: number,
	ResetKey: any,
})
	local binding, spring = react_ripple.useSpring(props.InitSize, react_ripple.config.figmaSlow)

	React.useEffect(function()
		spring:setPosition(UDim2.fromScale(0.05, 0.05))
		spring:setGoal(props.InitSize)
	end, { props.ResetKey })

	return e("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Font = Enum.Font.SourceSansBold,
		Text = props.Text,
		TextScaled = true,
		TextColor3 = props.Color,
		Size = binding,
		LayoutOrder = props.LayoutOrder,
	}, {
		UIStroke = e("UIStroke", { Thickness = 0.03, StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize }),
	})
end

return function(props: {})
	local posBinding, posSpring = react_ripple.useSpring(HIDDEN_POS)
	local isShown = react_charm.useAtom(UISlice.shownComponents)
	local selectedTroop = react_charm.useAtom(PlotSlice.SelectedTroop)

	React.useEffect(function()
		if table.find(isShown, "TroopInfo") then
			posSpring:setGoal(SHOWN_POS)
		else
			posSpring:setGoal(HIDDEN_POS)
		end
	end, { isShown })

	local troopData = React.useMemo(function()
		if selectedTroop == nil then
			return DEBUG_VALUES
		end
		return TroopData[selectedTroop.troopID]
	end, { selectedTroop })
	return e("Frame", {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = posBinding,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromScale(1, 1),
	}, {
		UIListLayout = e("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			VerticalAlignment = Enum.VerticalAlignment.Top,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
		TroopName = e(AnimatedLabel, {
			Text = troopData.Name,
			Color = Color3.new(1, 1, 1),
			InitSize = UDim2.new(0.5, 0, 0.12, 0),
			LayoutOrder = 1,
			ResetKey = selectedTroop,
		}),
		TroopLevel = e(AnimatedLabel, {
			Text = `Level: {troopData.Level}`,
			Color = Color3.new(0, 1, 0),
			InitSize = UDim2.new(0.5, 0, 0.08, 0),
			LayoutOrder = 2,
			ResetKey = selectedTroop,
		}),
		TroopDamage = e(AnimatedLabel, {
			Text = `Damage: {troopData.Damage}`,
			Color = Color3.new(1, 0, 0),
			InitSize = UDim2.new(0.5, 0, 0.08, 0),
			LayoutOrder = 3,
			ResetKey = selectedTroop,
		}),
		TroopFirerate = e(AnimatedLabel, {
			Text = `Firerate: {rpmToRps(troopData.Firerate)}/s`,
			Color = Color3.new(1, 1, 0),
			InitSize = UDim2.new(0.5, 0, 0.08, 0),
			LayoutOrder = 4,
			ResetKey = selectedTroop,
		}),
	})
end
