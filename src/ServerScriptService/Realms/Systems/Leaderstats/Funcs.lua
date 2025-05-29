local Funcs = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Abbreviate = require(ReplicatedStorage.Cryptware.Abbreviate)
local InfiniteMath = require(ReplicatedStorage.Cryptware.InfiniteMath)

function Funcs:Init(Leaderstats)
	function Leaderstats:Update(player, leaderstat, value)
		local ldsObj = player.leaderstats:WaitForChild(leaderstat, 5)
		
		if ldsObj then
			ldsObj.Value = InfiniteMath.new(value):GetSuffix()
		end
	end
	
	function Leaderstats:PlayerAdded(player)
		local profile = self.Profiles[player]
		
		local leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player
		
		for _, lds in self.DisplayStats do
			local ldsValue = Instance.new("StringValue")
			local ldsData = profile.Data.PlayerData[lds]

			ldsValue.Name = lds
			ldsValue.Value = InfiniteMath.new(ldsData):GetSuffix()
			ldsValue.Parent = leaderstats
		end
	end
end

return Funcs