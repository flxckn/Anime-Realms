local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crypt = require(ReplicatedStorage.Cryptware.Crypt)

local Messaging = Crypt.Register({ Name = "Messaging" }).Expose({
	RE = { "SendMessage" },
})

function Messaging:Init()
	require(script.Signals):Init(self)
	require(script.Funcs):Init(self)
end

function Messaging:Start()
	self.Data = Crypt.Import("Data")
	self.Leaderstats = Crypt.Import("Leaderstats")
	self.Profiles = self.Data:GetProfiles()
end

return Messaging