local ReplicatedStorage = game:GetService("ReplicatedStorage")

local charm = require(ReplicatedStorage.Packages.charm)
return {
	shownComponents = charm.atom({}),
	shownMenu = charm.atom(nil :: string?),
}
