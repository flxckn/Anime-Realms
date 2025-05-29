local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crypt = require(ReplicatedStorage.Cryptware.Crypt)

local Leaderstats = Crypt.Register({ Name = "Leaderstats" })

function Leaderstats:Init()
	self.DisplayStats = {
		"Power",
		"Essence"
	}
	
	require(script.Funcs):Init(self)
end

function Leaderstats:Start()
	self.Data = Crypt.Import("Data")
	self.Profiles = self.Data:GetProfiles()
end

return Leaderstats