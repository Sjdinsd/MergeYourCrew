local ReplicatedStorage = game:GetService("ReplicatedStorage")

local React = require(ReplicatedStorage.Packages.React)
local react_charm = require(ReplicatedStorage.Packages["react-charm"])
local react_ripple = require(ReplicatedStorage.Packages["react-ripple"])
local StuddedButton = require(ReplicatedStorage.Source.Features.App.Components.StuddedButton)
local UISlice = require(ReplicatedStorage.Source.Features.App.UISlice)
local PlotServiceClient = require(ReplicatedStorage.Source.Features.Plots.PlotServiceClient)
local PlotSlice = require(ReplicatedStorage.Source.Features.Plots.PlotSlice)
local e = React.createElement

local FIGHTING_COLOR = Color3.new(0.9, 0.1, 0.1)
local NOT_FIGHTING_COLOR = Color3.new(0.08, 0.7, 0.08)

local SHOWN_POS = UDim2.fromScale(0.5, 0.025)
local HIDDEN_POS = UDim2.fromScale(0.5, -0.5)

return function(props: { AspectRatio: number? })
	local isFighting = react_charm.useAtom(PlotSlice.isFighting)
	local isShown = react_charm.useAtom(UISlice.shownComponents)
	local menuShown = react_charm.useAtom(UISlice.shownMenu)

	local fightingColor = isFighting and FIGHTING_COLOR or NOT_FIGHTING_COLOR

	local springBinding, spring = react_ripple.useSpring(HIDDEN_POS, react_ripple.config.figmaQuick)

	React.useEffect(function()
		if table.find(isShown, "StartFightingButton") and menuShown == nil then
			spring:setGoal(SHOWN_POS)
		else
			spring:setGoal(HIDDEN_POS)
		end
	end, { isShown, menuShown })

	return e(StuddedButton, {
		Color = fightingColor,
		Size = UDim2.fromScale(0.15, 0.15),
		TileSize = UDim2.fromScale(0.8, 2),
		Position = springBinding,
		AnchorPoint = Vector2.new(0.5, 0),
		ActivatedEvent = function()
			if isFighting then
				PlotServiceClient.plotClient:StopFighting()
			else
				PlotServiceClient.plotClient:StartFighting()
			end
		end,
	}, {
		TextLabel = e("TextLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(0.9, 0.6),
			Text = isFighting and "Stop Fighting!" or "Fight!",
			Font = Enum.Font.SourceSansBold,
			TextColor3 = Color3.new(1, 1, 1),
			BackgroundTransparency = 1,
			TextScaled = true,
		}, {
			UIStroke = e("UIStroke", {
				StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
				Thickness = 0.06,
			}),
		}),
		UIGradient = e("UIGradient", {
			Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, fightingColor:Lerp(Color3.new(1, 1, 1), 0.7)),
				ColorSequenceKeypoint.new(1, fightingColor:Lerp(Color3.new(1, 1, 1), 1)),
			}),
			Rotation = -90,
		}),
		UIStroke = e("UIStroke", {
			StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize,
			Thickness = 0.05,
			Color = fightingColor:lerp(Color3.new(), 0.3),
		}),
		UICorner = e("UICorner", {
			CornerRadius = UDim.new(0.1, 0),
		}),
		UIAspectRatioConstraint = e("UIAspectRatioConstraint", {
			AspectRatio = props.AspectRatio or 2.4,
		}),
	})
end
