local ReplicatedStorage = game:GetService("ReplicatedStorage")

local janitor = require(ReplicatedStorage.Packages.janitor)
local sift = require(ReplicatedStorage.Packages.sift)
local DataService = require(ReplicatedStorage.Source.Core.Framework.DataService).server
local Networker = require(ReplicatedStorage.Source.Core.Framework.Networker)
local Troop = require(ReplicatedStorage.Source.Features.Plots.Classes.Troop)
local TroopData = require(ReplicatedStorage.Source.Features.Plots.Modules.TroopData)
local PlotServiceUtils = require(ReplicatedStorage.Source.Features.Plots.PlotServiceUtils)
local PlotTypes = require(ReplicatedStorage.Source.Features.Plots.PlotTypes)
local RoundCheckpoints = require(ReplicatedStorage.Source.Game.Items.RoundCheckpoints)

local ROUND_CD = 1
local FIGHTING_CD = 0.2

local EQUIPPED_MAX_IDX = 5
local UNEQUIPPED_MAX_IDX = 9

local PlotServer = {}
PlotServer.__index = PlotServer

export type PlotServer = typeof(setmetatable(
	{} :: {
		player: Player,
		networker: Networker.Server,
		plot: Model,

		Troops: { Equipped: {}, Unequipped: {} },

		isFighting: boolean,
		lastUpdatedFighting: number,
		fightingThread: thread?,

		_janitor: janitor.Janitor,
	},
	PlotServer
))

function PlotServer.new(player: Player, plotIndex: number)
	local self = setmetatable({
		player = player,
		plot = workspace:FindFirstChild("Plots")[`{plotIndex}`],

		Troops = { Equipped = {}, Unequipped = {} },

		isFighting = false,
		lastUpdatedFighting = 0,
		fightingThread = nil,

		_janitor = janitor.new(),

		-- StartFighting = PlotServer.StartFighting,
		-- StopFighting = PlotServer.StopFighting,
		-- PurchaseTroop = PlotServer.PurchaseTroop,
		-- UpgradeBaseLevel = PlotServer.UpgradeBaseLevel,
		-- UpgradeStartingLevel = PlotServer.UpgradeStartingLevel,
	}, PlotServer)
	self.networker = Networker.server.new(
		"Plot" .. plotIndex,
		self,
		{
			PlotServer.PurchaseTroop,
			PlotServer.UpgradeBaseLevel,
			PlotServer.UpgradeStartingLevel,
			PlotServer.StartFighting,
			PlotServer.StopFighting,
		}
	)

	local disconnect = DataService:addPlayerRemovingCallback(function(player: Player, data: any)
		self:save()
	end)
	self._janitor:Add(disconnect)
	return self
end

function PlotServer.save(self: PlotServer)
	local unloadedTroops = {}
	local function unloadTroop(troop: Troop.Troop)
		local unloadedTroop = {} :: PlotTypes.UnloadedTroop
		unloadedTroop.TroopID = troop._troopID
		unloadedTroop.isEquipped = troop._isEquipped
		unloadedTroop.PositionIndex = troop._positionIdx

		troop:destroy()
		return unloadedTroop
	end
	for _, troop in sift.Array.join(self.Troops.Equipped, self.Troops.Unequipped) do
		local unloadedTroop = unloadTroop(troop)
		table.insert(unloadedTroops, unloadedTroop)
	end

	DataService:set(self.player, "Troops", unloadedTroops)
end

function PlotServer.shoot(self: PlotServer, guid)
	self.networker:fire(self.player, "animateTroop", guid, "Shoot")
end

function PlotServer.addTroop(self: PlotServer, troopID, isEquipped: boolean?, positionIdx: number?)
	local troopTable = isEquipped and self.Troops.Equipped or self.Troops.Unequipped
	local maxIdx = isEquipped and EQUIPPED_MAX_IDX or UNEQUIPPED_MAX_IDX
	local posIdx = nil
	for i = 1, maxIdx do
		if not troopTable[i] then
			posIdx = i
			break
		end
	end
	if not posIdx then
		return false
	end
	local troop = Troop.new({
		TroopID = troopID,
		PositionIndex = posIdx,
		isEquipped = isEquipped ~= nil and isEquipped or false,
	}, self.plot, self)

	troopTable[posIdx] = troop

	self.networker:fire(self.player, "initializeTroop", troop._guid)
	self.networker:fire(self.player, "animateTroop", troop._guid, "Idle")

	return true
end

function PlotServer.loadTroops(self: PlotServer, troops: { PlotTypes.UnloadedTroop })
	for _, unloadedTroop in troops do
		self:addTroop(unloadedTroop.TroopID, unloadedTroop.isEquipped, unloadedTroop.PositionIndex)
	end
end

function PlotServer.StartFighting(self: PlotServer)
	if self.lastUpdatedFighting + FIGHTING_CD > os.clock() then
		return false, "Too Quick!"
	end
	self.isFighting = true
	self.lastUpdatedFighting = os.clock()

	self.fightingThread = coroutine.create(function()
		local startingRound = DataService:get(self.player, "Round")
		local round = startingRound or 0
		local nextCheckpoint = RoundCheckpoints[round].NextCheckpoint
		self.networker:fire(self.player, "StartFighting", startingRound)
		while self.isFighting do
			if round == nextCheckpoint then
				-- spawn boss
				nextCheckpoint = RoundCheckpoints[round]
			else
				-- spawn enemies
			end
			-- wait till all dead or base is killed
			round += 1
			task.wait(ROUND_CD)
			self.networker:fire(self.player, "UpdateRound", round, nextCheckpoint)
		end
	end)

	return true, ""
end
function PlotServer.StopFighting(self: PlotServer)
	if self.lastUpdatedFighting + FIGHTING_CD > os.clock() then
		return false, "Too Quick!"
	end
	self.isFighting = false
	self.lastUpdatedFighting = os.clock()

	if self.fightingThread then
		coroutine.close(self.fightingThread)
		self.fightingThread = nil
	end

	return true, ""
end

function PlotServer.PurchaseTroop(self: PlotServer)
	local money = DataService:get(self.player, "Money")
	local startingLevel = DataService:get(self.player, { "Base", "TroopStartingLevel" })

	local requiredMoney = PlotServiceUtils.calculateTroopCost(startingLevel)

	if money < requiredMoney then
		return
	end
	for troopID, troopData in TroopData do
		if troopData.Level ~= startingLevel then
			continue
		end
		local addedTroop = self:addTroop(troopID)
		if addedTroop then
			DataService:update(self.player, { "Money" }, function(current)
				return current - requiredMoney
			end)
		end
		break
	end
end
function PlotServer.UpgradeBaseLevel(self: PlotServer) end
function PlotServer.UpgradeStartingLevel(self: PlotServer) end

function PlotServer.destroy(self: PlotServer)
	self.networker:destroy()
	-- also destroy troops
end

return PlotServer
