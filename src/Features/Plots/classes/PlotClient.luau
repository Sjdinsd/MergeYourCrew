local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local janitor = require(ReplicatedStorage.Packages.janitor)
local Networker = require(ReplicatedStorage.Source.Core.Framework.Networker)
local ComponentSets = require(ReplicatedStorage.Source.Features.App.Modules.ComponentSets)
local UIController = require(ReplicatedStorage.Source.Features.App.UIController)
local PlotSlice = require(ReplicatedStorage.Source.Features.Plots.PlotSlice)
local PlotTypes = require(ReplicatedStorage.Source.Features.Plots.PlotTypes)
local Vfx = require(ReplicatedStorage.Source.Features.Vfx)

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

local PlotClient = {}
PlotClient.__index = PlotClient

export type PlotClient = typeof(setmetatable(
	{} :: {
		plotModel: Model & PlotTypes.PlotModel,
		networker: Networker.Client,
		troops: { [string]: { model: Model, animator: Animator, troopID: string } },
		buttonJanitor: janitor.Janitor,
		janitor: janitor.Janitor,
	},
	PlotClient
))

function PlotClient.new(plotIndex: number, plotModel: Model)
	local self = setmetatable({
		plotModel = plotModel,
		troops = {},
		buttonJanitor = janitor.new(),
		janitor = janitor.new(),
	}, PlotClient) :: PlotClient
	self.networker = Networker.client.new("Plot" .. plotIndex, self)

	self:init()

	game.Close:Connect(function()
		self:destroy()
	end)

	PlotClient.PlotClient = self

	return self
end

function PlotClient.init(self: PlotClient)
	-- setup buttons
	local buttonsFolder = self.plotModel:WaitForChild("Buttons")
	if not buttonsFolder then
		return
	end
	local canPress = {}
	for _, buttonModel in buttonsFolder:GetChildren() do
		local serverFunc = buttonModel:GetAttribute("ServerFunction")
		local buttonHead: BasePart = buttonModel:WaitForChild("Button")

		canPress[buttonModel] = true
		local buttonConn = buttonHead.Touched:Connect(function(part)
			if not canPress[buttonModel] or not part:IsDescendantOf(character) then
				return
			end

			canPress[buttonModel] = false
			Vfx.PressButton(buttonHead, buttonHead.Position, 0.5)

			self.networker:fire(serverFunc)

			task.delay(0.5, function()
				canPress[buttonModel] = true
			end)
		end)

		self.buttonJanitor:Add(buttonConn, "Disconnect")
	end

	-- setup troop selection
	local mouse = player:GetMouse()
	local mouseMoveConn
	local mouseClickConn
	local selectedHighlight = ReplicatedStorage.Assets.VFX.SelectHighlight:Clone()
	local hoverHighlight = ReplicatedStorage.Assets.VFX.HoverHighlight:Clone()
	selectedHighlight.Parent = workspace.Debri
	hoverHighlight.Parent = workspace.Debri

	mouseMoveConn = mouse.Move:Connect(function()
		local target = mouse.Target
		if not target or not target.Parent:HasTag("Troop") then
			hoverHighlight.Adornee = nil
			return
		end
		hoverHighlight.Adornee = target.Parent
	end)

	mouseClickConn = mouse.Button1Down:Connect(function()
		local target = mouse.Target
		if not target or not target.Parent:HasTag("Troop") then
			return
		end
		target = target.Parent
		selectedHighlight.Adornee = target

		PlotSlice.SelectedTroop(self.troops[target.Name])

		UIController:clearComponents()
		UIController:bulkShowComponents(ComponentSets.TroopInfoComponents)
	end)

	self.janitor:Add(mouseMoveConn, "Disconnect")
	self.janitor:Add(mouseClickConn, "Disconnect")

	UIController:showComponent("StartFightingButton")
end

function PlotClient.StartFighting(self: PlotClient)
	local startedFight, msg = self.networker:fetch("StartFighting")
	if startedFight then
		PlotSlice.isFighting(true)
	else
		print(msg)
	end
end
function PlotClient.StopFighting(self: PlotClient)
	local stoppedFight, msg = self.networker:fetch("StopFighting")
	if stoppedFight then
		PlotSlice.isFighting(false)
	else
		print(msg)
	end
end

function PlotClient.animateTroop(self: PlotClient, guid, animId)
	local troop = self.troops[guid]
	local animation = troop.model.Animations:FindFirstChild(animId)
	local track = troop.animator:LoadAnimation(animation)
	track:Play()
end

function PlotClient.initializeTroop(self: PlotClient, guid)
	local troopModel = self.plotModel.Troops:FindFirstChild(guid)
	local troopAnimator = troopModel:FindFirstChildWhichIsA("Animator", true)
	local troopID = troopModel:GetAttribute("TroopID")

	self.troops[guid] = {
		model = troopModel,
		animator = troopAnimator,
		troopID = troopID,
	}

	PlotSlice.LoadedTroops(self.troops)
end

function PlotClient.destroy(self: PlotClient)
	self.networker:destroy()
	self.buttonJanitor:Destroy()
	self.janitor:Destroy()
end

return PlotClient
