local function calculateStartingLevelUpgrade(currentLevel: number)
	return 2 ^ (currentLevel - 1) * 1000
end
local function calculateTroopCost(startingLevel)
	return 2 ^ (startingLevel - 1) * 100
end
return {
	calculateStartingLevelUpgrade = calculateStartingLevelUpgrade,
	calculateTroopCost = calculateTroopCost,
}
