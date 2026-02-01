local ReplicatedStorage = game:GetService("ReplicatedStorage")
local charm = require(ReplicatedStorage.Packages.charm)

return {
	isFighting = charm.atom(false),
	LoadedTroops = charm.atom({}),
	SelectedTroop = charm.atom(nil :: {}?),
}
