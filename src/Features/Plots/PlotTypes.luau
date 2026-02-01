export type UnloadedTroop = {
	TroopID: string,
	PositionIndex: number,
	isEquipped: boolean,
}

export type PlotModel = Model & {
	EquippedTroops: Model,
	UnequippedTroops: Model,
	Troops: Folder,
	Enemies: Folder,
}

return {}
