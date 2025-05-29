local InfiniteMath = require(game:GetService("ReplicatedStorage").Cryptware.InfiniteMath)

return {
	PlayerData = {
		Essence = InfiniteMath.new(0),
		Power = InfiniteMath.new(1),
		Luck = InfiniteMath.new(1),
	},
	
	LevelData = {
		Level = 0,
		CurrentExp = 0,
		MaxExp = 10,
	},

	Multipliers = {
		Essence = 0,
		Power = 0,
		Luck = 0,
		Exp = 0,
	},
	
	PlayerStats = {
		Totals = {
			Power = InfiniteMath.new(1),
			Essence = InfiniteMath.new(0),
			MobsKilled = 0,
			IslandsUnlocked = 1,
		},
		
		Current = {
			Power = InfiniteMath.new(1),
			Essence = InfiniteMath.new(0),
			MobsKilled = 0,
			IslandsUnlocked = 1,
		}
	},
	
	Inventory = {
		Swords = {},
		Items = {},
		FightingStyles = {},

		Accessories = {
			Armor = {},
		},

		Potions = {
			Essence = {
				Owned = { ["15"] = 0, ["40"] = 0, ["125"] = 0, ["265"] = 0 },
				Time = 0,
			},

			Power = {
				Owned = { ["15"] = 0, ["40"] = 0, ["125"] = 0, ["265"] = 0 },
				Time = 0,
			},

			Exp = {
				Owned = { ["15"] = 0, ["40"] = 0, ["125"] = 0, ["265"] = 0 },
				Time = 0,
			},

			Luck = {
				Owned = { ["15"] = 0, ["40"] = 0, ["125"] = 0, ["265"] = 0 },
				Time = 0,
			},
		},
	},
	
	Quests = {
		Normal = {},
		Traverser = {},
		FightingStyle = {},
	},
	
	SkillTrees = {
		Character = {},
		Sword = {},
		FightingStyle = {},
	},
	
	Story = {},
	IslandsUnlocked = {},
	BoatsUnlocked = {},

	Gamepasses = {},
	Settings = {},

	Ban = {
		Active = false,
		Duration = nil,
	}
}