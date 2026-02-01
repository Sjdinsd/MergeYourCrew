local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local PlotServer = require(ServerScriptService.Features.Plots.Classes.PlotServer)
local Networker = require(ReplicatedStorage.Source.Core.Framework.Networker)

local plotDict = {}

local playerPlots = {}

local PLOT_FOLDER = workspace:FindFirstChild("Plots")

local PlotServiceServer = {}

function PlotServiceServer.init(self: PlotServiceServer)
	self.networker = Networker.server.new("PlotService", PlotServiceServer, {})

	for _, plotPoint: Attachment in PLOT_FOLDER.PlotPoints:QueryDescendants("Attachment") do
		local newPlotModel = ReplicatedStorage.Assets.Plot:Clone()
		newPlotModel.Name = plotPoint.Name
		newPlotModel.Parent = PLOT_FOLDER
		newPlotModel:PivotTo(plotPoint.WorldCFrame)

		plotDict[newPlotModel] = false
	end

	Players.PlayerAdded:Connect(function(player: Player)
		for plot, isTaken in plotDict do
			if isTaken then
				continue
			end
			plotDict[plot] = player

			local plotIndex = tonumber(plot.Name)
			self.networker:fire(player, "SetPlot", plotIndex)
			playerPlots[player] = PlotServer.new(player, plotIndex)

			local char = player.Character or player.CharacterAdded:Wait()
			char:PivotTo(plot.PlayerSpawn.WorldCFrame * CFrame.new(char:GetExtentsSize() / 2 * Vector3.yAxis))
			break
		end
	end)
	Players.PlayerRemoving:Connect(function(player: Player)
		local plot = playerPlots[player]
		-- save plot
		plot:destroy()
	end)
end

function PlotServiceServer.getPlot(player: Player)
	return playerPlots[player]
end

export type PlotServiceServer = typeof(PlotServiceServer) & {
	networker: Networker.Server,
}

return PlotServiceServer :: PlotServiceServer
