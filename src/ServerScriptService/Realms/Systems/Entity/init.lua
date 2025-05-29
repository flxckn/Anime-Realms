local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crypt = require(ReplicatedStorage.Cryptware.Crypt)

local Entity = Crypt.Register({ Name = "Entity" }).Expose({
	RE = {},
	RF = {}
})

function Entity:Init()
    self.Active = {}
    
	require(script.Funcs):Init(self)
end

function Entity:Start()
	self.Data = Crypt.Import("Data")
	self.Profiles = self.Data:GetProfiles()
end

return Entity