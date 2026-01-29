local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local dataservice = require(ReplicatedStorage.Packages.dataservice).server

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

function dataservice:onPlayerInit(player: Player, data: DataTemplate) end

PlotServiceServer:init()
