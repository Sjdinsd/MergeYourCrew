local ReplicatedStorage = game:GetService("ReplicatedStorage")

local networker = require(ReplicatedStorage.Packages.networker)

local PlotServer = {}
PlotServer.__index = PlotServer

export type PlotServer = typeof(setmetatable(
	{} :: {
		player: Player,
		networker: networker.Server,
	},
	PlotServer
))

function PlotServer.new(player: Player, plotIndex: number)
	local self = setmetatable({
		player = player,

		PurchaseTroop = PlotServer.PurchaseTroop,
		UpgradeBaseLevel = PlotServer.UpgradeBaseLevel,
		UpgradeStartingLevel = PlotServer.UpgradeStartingLevel,
	}, PlotServer)
	local networker = networker.server.new("Plot" .. plotIndex, self, { self.PurchaseTroop })
	self.networker = networker

	return self
end

function PlotServer.PurchaseTroop(self: PlotServer) end
function PlotServer.UpgradeBaseLevel(self: PlotServer) end
function PlotServer.UpgradeStartingLevel(self: PlotServer) end

return PlotServer
