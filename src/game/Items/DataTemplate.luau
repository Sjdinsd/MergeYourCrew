export type UnloadedTroop = {
	TroopID: string,
	PositionIndex: number,
	isEquipped: boolean,
}
return {
	Money = 100,
	Gems = 0,
	Troops = {} :: { UnloadedTroop },
	Round = 0,
	Base = {
		TroopStartingLevel = 1,
		BaseUpgradeLevel = 1,
	},
}
