local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crypt = require(ReplicatedStorage.Cryptware.Crypt)

local Swords = Crypt.Register({ Name = "Swords" }).Expose({
	RE = { "UpdateSwords", "PlayAnim" },
	RF = { "Equip", "Unequip", "Swing" }
})

function Swords:Init()
	self.TempSwords = {}
	
	require(script.Funcs):Init(self)
end

function Swords:Start()
	self.Data = Crypt.Import("Data")
	self.Profiles = self.Data:GetProfiles()
end

function Swords:PlayerRemoving(player)
	self.TempSwords[player] = nil
end

return Swords