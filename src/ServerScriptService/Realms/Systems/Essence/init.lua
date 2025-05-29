local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crypt = require(ReplicatedStorage.Cryptware.Crypt)

local Essence = Crypt.Register({ Name = "Essence" }).Expose({
	RE = {},
	RF = { "MakePurchase" }
})

function Essence:Init()
	require(script.Signals):Init(self)
	require(script.Funcs):Init(self)
end

function Essence:Start()
	self.Data = Crypt.Import("Data")
	self.Profiles = self.Data:GetProfiles()
end

return Essence