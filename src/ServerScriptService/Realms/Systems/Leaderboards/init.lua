local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crypt = require(ReplicatedStorage.Cryptware.Crypt)

local Leaderboards = Crypt.Register({ Name = "Leaderboards" }).Expose({
    RF = { "GetPlaces", "GetTypes" }
})

function Leaderboards:Init()
    self.TempPlaces = {}
    self.BoardStores = {}

    self.Types = {
        Essence = {
			Emoji = "🔮",
			Color = "#a026de"
		},

		Power = {
			Emoji = "🥊",
			Color = "#de3226"
		},
    }

    self.Boards = {
        ["Essence"] = workspace.Leaderboards:FindFirstChild("Essence"),
        ["Power"] = workspace.Leaderboards:FindFirstChild("Power")
    }

	require(script.Funcs):Init(self)
end

function Leaderboards:Start()
	self.Data = Crypt.Import("Data")
	self.Profiles = self.Data:GetProfiles()

    for boardName, _ in self.Boards do
        self.BoardStores[boardName] = DataStoreService:GetOrderedDataStore(boardName .. "_2")
        
        task.spawn(function()
            self:UpdateBoard(boardName)
            while task.wait(60) do
                self:UpdateBoard(boardName)
            end
        end)
    end
end

function Leaderboards:PlayerRemoving(player)
    self.TempPlaces[player] = nil
end

return Leaderboards