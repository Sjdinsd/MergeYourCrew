export type ROUND_CHECKPOINT = {
	Boss: string,
	RewardStrength: number,
	DifficultyMultiplier: number,
	NextCheckpoint: number,
}

local RoundCheckpoints: { [number]: ROUND_CHECKPOINT } = {
	[0] = { Boss = nil, RewardStrength = 0, DifficultyMultiplier = 1, NextCheckpoint = 10 },
	[10] = { Boss = nil, RewardStrength = 1, DifficultyMultiplier = 2, NextCheckpoint = 25 },
	[25] = { Boss = nil, RewardStrength = 1, DifficultyMultiplier = 3, NextCheckpoint = 50 },
	[50] = { Boss = nil, RewardStrength = 1, DifficultyMultiplier = 4, NextCheckpoint = 100 },
	[100] = { Boss = nil, RewardStrength = 2, DifficultyMultiplier = 5, NextCheckpoint = 150 },
	[150] = { Boss = nil, RewardStrength = 2, DifficultyMultiplier = 6, NextCheckpoint = 250 },
	[250] = { Boss = nil, RewardStrength = 2, DifficultyMultiplier = 7, NextCheckpoint = 500 },
	[500] = { Boss = nil, RewardStrength = 3, DifficultyMultiplier = 8, NextCheckpoint = 1000 },
}

return RoundCheckpoints
