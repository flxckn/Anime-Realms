local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crypt = require(ReplicatedStorage.Cryptware.Crypt)

local Level = Crypt.Register({ Name = "Level" }).Expose({
	RE = { "GetInfo" },
	RF = {}
})

function Level:Init()
	self.MaxLevel = 100

	require(script.Signals):Init(self)
	require(script.Funcs):Init(self)
end

function Level:Start()
	self.Data = Crypt.Import("Data")
	self.Leaderstats = Crypt.Import("Leaderstats")
	self.Profiles = self.Data:GetProfiles()
end

return Level