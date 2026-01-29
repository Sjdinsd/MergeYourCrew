export type ENEMY_DATA = {
	EnemeyID: string,
	Model: Model,
	Health: number,
	Damage: number,
	Difficulty: number,
	MoneyReward: number,
}

local Enemey: { [string]: ENEMY_DATA } = {}

return Enemey
