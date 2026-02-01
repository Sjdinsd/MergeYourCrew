local ReplicatedStorage = game:GetService("ReplicatedStorage")

local PlotTypes = require(ReplicatedStorage.Source.Features.Plots.PlotTypes)

return {
	Money = 1000,
	Gems = 0,
	Troops = {} :: { PlotTypes.UnloadedTroop },
	Round = 0,
	Base = {
		TroopStartingLevel = 1,
		BaseUpgradeLevel = 1,
	},
	Upgrades = {
		Damage = 0,
		Money = 0,
		Firerate = 0,
	},
}
