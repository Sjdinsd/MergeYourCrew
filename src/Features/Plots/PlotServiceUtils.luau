local function calculateStartingLevelUpgrade(currentLevel: number)
	return 2 ^ (currentLevel - 1) * 1000
end
local function calculateTroopCost(startingLevel)
	return 2 ^ (startingLevel - 1) * 100
end

local BUFF_MULT = {
	Damage = 4,
	Firerate = 4,
	Money = 16,
}

local function calculateBuff(buff, v)
	return v * BUFF_MULT[buff]
end

return {
	calculateStartingLevelUpgrade = calculateStartingLevelUpgrade,
	calculateTroopCost = calculateTroopCost,
	calculateBuff = calculateBuff,
}
