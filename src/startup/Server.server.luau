local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local DataService = require(ReplicatedStorage.Source.Core.Framework.DataService).server
local PlotServer = require(ServerScriptService.Features.Plots.Classes.PlotServer)
local PlotServiceServer = require(ServerScriptService.Features.Plots.PlotServiceServer)
local DataTemplate = require(ReplicatedStorage.Source.Game.Items.DataTemplate)

export type DataTemplate = typeof(DataTemplate)

PlotServiceServer:init()

DataService:init({
	template = DataTemplate,
	profileStoreIndex = "beta.2",
	useMock = false,
	resetData = false,
	dontSave = false,
})

function DataService:onPlayerInit(player: Player, data: DataTemplate)
	local plotServer: PlotServer.PlotServer = PlotServiceServer.getPlot(player)
	plotServer:loadTroops(data.Troops)

	task.wait(3)
	DataService:set(player, { "Upgrades", "Damage" }, 5)
end

Players.PlayerAdded:Connect(function(player: Player)
	local char = player.Character or player.CharacterAdded:Wait()
	for _, basePart in char:QueryDescendants("BasePart, Part, MeshPart") do
		basePart.CollisionGroup = "Characters"
	end
end)
