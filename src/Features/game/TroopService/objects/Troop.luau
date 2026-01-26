local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EasyAnimator = require(ReplicatedStorage.Source.Core.EasyAnimator)
local TroopData = require(ReplicatedStorage.Source.Shared.Data.TroopData)

local Private = {}
local Troop = {}

function Troop.new(uniqueID, troopID, plotNumber, isEquipped, positionIndex)
	local troopSpecificData = TroopData[troopID]
	local model = troopSpecificData.Model:Clone()

	local self = {}
	self._uniqueID = uniqueID
	self._troopID = troopID
	self._plotReference = workspace.Plots:FindFirstChild(`{plotNumber}`)
	self._animator = EasyAnimator.new(model.Humanoid.Animator, troopSpecificData.Animations)

	self._isEquipped = isEquipped
	self._positionIndex = positionIndex

	self._model = ReplicatedStorage.Assets

	self._target = nil :: Model?
	self._level = troopSpecificData.Level
	self._damage = troopSpecificData.Damage
	self._firerate = Private.RoundsPerMinuteToCooldown(troopSpecificData.Firerate)
	self._lastShot = 0

	return setmetatable(self, Troop)
end

function Troop.init(self: Troop) end

function Troop.update(self: Troop)
	if not self._target then
		local enemies = self._plotReference.Enemies:GetChildren()
		local troopPos = self._model.PrimaryPart.Position
		local closestEnemy, closestEnemyMagnitude = nil, math.huge

		for _, enemyModel in enemies do
			local enemyPos = enemyModel.PrimaryPart.Position
			local enemyMag = (enemyPos - troopPos).Magnitude
			if enemyMag < closestEnemyMagnitude then
				closestEnemy = enemyModel
			end
		end

		self._target = closestEnemy

		if not self._target then
			return
		end
	end

	if self._lastShot + self._firerate < os.clock() and self._target then
		self._lastShot = os.clock()
	end
end

function Troop.destroy(self: Troop)
	self.Model:Destroy()
	self = nil
end

function Private.RoundsPerMinuteToCooldown(rpm)
	return 60 / rpm
end

export type Troop = typeof(Troop.new(nil :: any))

return Troop
