local ReplicatedStorage = game:GetService("ReplicatedStorage")

local networker = require(ReplicatedStorage.Packages.networker)

local PlotClient = {}
PlotClient.__index = PlotClient

export type PlotClient = typeof(setmetatable(
	{} :: {
		plotModel: Model,
	},
	PlotClient
))

function PlotClient.new(plotIndex: number, plotModel: Model)
	local self = setmetatable({
		plotModel = plotModel,
	}, PlotClient) :: PlotClient
	self.networker = networker.client.new("Plot" .. plotIndex, self)
	return self
end

function PlotClient.StartFighting(self: PlotClient) end

return PlotClient
