local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Networker = require(ReplicatedStorage.Source.Core.Framework.Networker)
local PlotClient = require(ReplicatedStorage.Source.Features.Plots.Classes.PlotClient)

local PLOT_FOLDER = workspace:FindFirstChild("Plots")

local PlotServiceClient = {}

function PlotServiceClient.init(self: PlotServiceClient)
	self.networker = Networker.client.new("PlotService", PlotServiceClient)
end

function PlotServiceClient.SetPlot(self: PlotServiceClient, plotIndex: number)
	self.plotIndex = plotIndex
	self.plotModel = PLOT_FOLDER:FindFirstChild(`{plotIndex}`)
	self.plotClient = PlotClient.new(self.plotIndex, self.plotModel)
end

export type PlotServiceClient = typeof(PlotServiceClient) & {
	networker: Networker.Client,
	plotClient: PlotClient.PlotClient,
	plotIndex: number,
	plotModel: Model,
}

return PlotServiceClient :: PlotServiceClient
-- Brb
