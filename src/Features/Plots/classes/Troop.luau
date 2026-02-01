local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotTypes = require(ReplicatedStorage.Source.Features.Plots.PlotTypes)
local TroopData = require(ReplicatedStorage.Source.Game.Data.TroopData)

local Troop = {}
Troop.__index = Troop

type PlotModel = Model & {
	EquippedTroops: Model,
	UnequippedTroops: Model,
	Troops: Folder,
	Enemies: Folder,
}

export type Troop = typeof(setmetatable(
	{} :: {
		_guid: string,
		_troopID: string,
		_positionIdx: number,
		_isEquipped: boolean,

		cooldown: number,
		target: Model?,
		fire: (guid: string) -> nil,

		_troopData: TroopData.TROOP_DATA,
		_troopModel: Model,
		_plotModel: Model & PlotModel,
		_plotServer: any,
		_enemyFolder: Folder,
	},
	Troop
))

function Troop.new(unloadedTroopData: PlotTypes.UnloadedTroop, plotModel: Model, plotServer: any)
	local troopData = TroopData[unloadedTroopData.TroopID]
	local self = setmetatable({
		_guid = HttpService:GenerateGUID(false),
		_troopID = unloadedTroopData.TroopID,
		_positionIdx = unloadedTroopData.PositionIndex,
		_isEquipped = unloadedTroopData.isEquipped,

		cooldown = 60 / troopData.Firerate, -- data.Firerate is rpm, so 60/rate
		target = nil,

		_troopData = troopData,
		_troopModel = troopData.Model:Clone(),
		_plotModel = plotModel,
		_plotServer = plotServer,
		_enemyFolder = plotModel:FindFirstChild("Enemies"),
	}, Troop)

	self:init()

	return self
end

function Troop.init(self: Troop)
	local standParent = self._isEquipped and self._plotModel.EquippedTroops or self._plotModel.UnequippedTroops
	local stand = standParent:FindFirstChild(`{self._positionIdx}`).Attachment
	self._troopModel:PivotTo(stand.WorldCFrame * CFrame.new(self._troopModel:GetExtentsSize() * Vector3.yAxis / 2))
	self._troopModel.Parent = self._plotModel.Troops

	self._troopModel.Name = self._guid
end

function Troop.update(self: Troop, dt)
	if not self.target then
		assert(self._troopModel.PrimaryPart, `Troop model: {self._troopModel:GetFullName()} does not have a primary part`)
		local troopPos = self._troopModel.PrimaryPart.Position
		local closestEnemyModel = nil :: Model?
		local closestEnemyMagnitude = 9999
		for _, enemyModel in self._enemyFolder:GetChildren() do
			if not enemyModel.PrimaryPart then
				continue
			end
			local enemyPos = enemyModel.PrimaryPart.Position
			local enemyMag = (enemyPos - troopPos).Magnitude

			if enemyMag <= closestEnemyMagnitude then
				closestEnemyModel = enemyModel
				closestEnemyMagnitude = enemyMag
			end
		end
		self.target = closestEnemyModel
	end

	self.cooldown -= dt
	if self.cooldown < 0 and self.target then
		self.cooldown = 60 / self._troopData.Firerate

		local targetHealth = self.target:GetAttribute("Health")
		self.target:SetAttribute("Health", targetHealth - self._troopData.Damage)
		self._plotServer:shoot(self._guid)
	end
end

function Troop.destroy(self: Troop)
	self._troopModel:Destroy()
end

return Troop
