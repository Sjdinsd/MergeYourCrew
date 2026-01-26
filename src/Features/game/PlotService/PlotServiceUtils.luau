local ReplicatedStorage = game:GetService("ReplicatedStorage")

local charm = require(ReplicatedStorage.Packages.charm)
local atoms = {
	client = {},
	server = {},
	shared = { isFighting = charm.atom(false) },
}

return {
	atoms = atoms,
}
