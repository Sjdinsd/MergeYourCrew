local ReplicatedStorage = game:GetService("ReplicatedStorage")

local networker = require(ReplicatedStorage.Packages.networker)

local Troop = require(ReplicatedStorage.Source.Features.Game.TroopService.Objects.Troop)

local client: networker.Client?

local unequippedTroops = {}
local equippedTroops = {}

local Private = {}
local TroopServiceClient = {}

function TroopServiceClient.init()
	client = networker.client.new("TroopServiceClient", TroopServiceClient)
end

function TroopServiceClient.LoadTroop(uniqueID, troopID, isEquipped, positionIndex)
	Troop.new(uniqueID, troopID, isEquipped, positionIndex)
end

return TroopServiceClient
