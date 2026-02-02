local ReplicatedStorage = game:GetService("ReplicatedStorage")
export type ENEMY_DATA = {
	EnemeyID: string,
	Name: string,
	Model: Model,
	Health: number,
	Damage: number,
	Difficulty: number,
	MoneyReward: number,
}

local Enemey: { [string]: ENEMY_DATA } = {
	["test_enemy"] = {
		EnemeyID = "test_enemy",
		Name = "Test Enemy",
		Model = ReplicatedStorage.Assets.Enemies.TestEnemy,
		Health = 15,
		Damage = 5,
		Difficulty = 1,
		MoneyReward = 10,
	},
}

return Enemey
