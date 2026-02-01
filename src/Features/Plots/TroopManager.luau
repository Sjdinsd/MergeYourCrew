local TroopManager = {}
TroopManager.__index = TroopManager

export type TroopManager = typeof(setmetatable({} :: {}, TroopManager))

function TroopManager.new()
	local self = setmetatable({}, TroopManager)
	return self
end

return TroopManager
