local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crypt = require(ReplicatedStorage.Cryptware.Crypt)

local Data = Crypt.Register({ Name = "Data" }).Expose({
	RF = { "GetMyProfile" }
})

function Data:Init()
	local key = self.Util.KeyHandler:GetKey()
	local ProfileService = self.Util.ProfileService
	local DefaultData = self.Util.DefaultData

	self.ProfileStore = ProfileService.GetProfileStore(key, DefaultData)
	self.Profiles = {}
	--self.UseMock = true

	require(script.Funcs):Init(self)
end

function Data:Start()
	self.Leaderstats = Crypt.Import("Leaderstats")
end

return Data