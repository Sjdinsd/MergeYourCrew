local ReplicatedStorage = game:GetService("ReplicatedStorage")

local networker = require(ReplicatedStorage.Packages.networker)
local charm_sync = require(ReplicatedStorage.Packages["charm-sync"])
local PlotServiceUtils = require(ReplicatedStorage.Source.Features.Game.PlotService.PlotServiceUtils)

local client: networker.Client
local syncer

local Private = {}
local PlotServiceClient = {}

function PlotServiceClient.init()
	client = networker.client.new("PlotService", PlotServiceClient)
	syncer = charm_sync.client({
		atoms = PlotServiceUtils.atoms.shared,
	})
end

function PlotServiceClient.updateAtoms(...)
	syncer:sync(...)
end

return PlotServiceClient
