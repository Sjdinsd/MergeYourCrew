local ReplicatedStorage = game:GetService("ReplicatedStorage")

local charm = require(ReplicatedStorage.Packages.charm)
local atoms = {
	client = {
		isMerging = charm.atom(false),
	},
	server = {},
	shared = {},
}

export type UnloadedTroop = {
	TroopID: string,
	PositionIndex: number,
	isEquipped: boolean,
}

return {
	atoms = atoms,
}
