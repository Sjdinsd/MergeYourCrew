local ReplicatedStorage = game:GetService("ReplicatedStorage")

local networker = require(ReplicatedStorage.Packages.networker)

local server: networker.Server

local Private = {}
local TroopServiceServer = {}

function TroopServiceServer.init()
	server = networker.server.new("TroopServiceClient", TroopServiceServer)
end

return TroopServiceServer
