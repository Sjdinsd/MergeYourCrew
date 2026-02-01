local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local dataservice = require(ReplicatedStorage.Packages.dataservice).server

local PlotServer = require(ServerScriptService.Features.Plots.Classes.PlotServer)
local PlotServiceServer = require(ServerScriptService.Features.Plots.PlotServiceServer)
local DataTemplate = require(ReplicatedStorage.Source.Game.Items.DataTemplate)

export type DataTemplate = typeof(DataTemplate)

dataservice:init({
	template = DataTemplate,
	profileStoreIndex = "beta.1",
	useMock = false,
	resetData = false,
	dontSave = false,
})

function dataservice:onPlayerInit(player: Player, data: DataTemplate)
	local plotServer: PlotServer.PlotServer = PlotServiceServer.getPlot(player)
	plotServer:loadTroops(data.Troops)
end

PlotServiceServer:init()

Players.PlayerAdded:Connect(function(player: Player)
	local char = player.Character or player.CharacterAdded:Wait()
	for _, basePart in char:QueryDescendants("BasePart, Part, MeshPart") do
		basePart.CollisionGroup = "Characters"
	end
end)
