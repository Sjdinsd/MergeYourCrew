local ReplicatedStorage = game:GetService("ReplicatedStorage")
local tropps = ReplicatedStorage.Assets.Troops

export type TROOP_DATA = {
	TroopID: string,
	Name: string,
	Model: Instance,
	Animations: { Animation },

	Level: number,
	Firerate: number, --rounds per minute
	Damage: number,
}

local Troops: { [string]: TROOP_DATA } = {
	test_troop_1 = {
		TroopID = "test_troop_1",
		Name = "Test Troop 1",
		Model = ReplicatedStorage.Assets.Troops.TestTroop1,
		Animations = {
			Idle = tropps.TestTroop1.Animations.Idle,
			Shoot = tropps.TestTroop1.Animations.Shoot,
		},

		Level = 1,
		Firerate = 60,
		Damage = 1,
	},
	test_troop_2 = {
		TroopID = "test_troop_2",
		Name = "Test Troop 2",
		Model = ReplicatedStorage.Assets.Troops.TestTroop2,
		Animations = {
			Idle = tropps.TestTroop2.Animations.Idle,
			Shoot = tropps.TestTroop2.Animations.Shoot,
		},

		Level = 2,
		Firerate = 60,
		Damage = 1,
	},
}

return Troops
