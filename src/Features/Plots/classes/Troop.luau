local Troop = {}
Troop.__index = Troop

export type Troop = typeof(setmetatable({} :: {}, Troop))

function Troop.new(troopID)
	local self = setmetatable({}, Troop)
	return self
end

return Troop
