local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crypt = require(ReplicatedStorage.Cryptware.Crypt)

local Potions = Crypt.Register({ Name = "Potions" }).Expose({
    RE = { "MakePurchase", "UpdateTime", "UpdatePotions", "UsePotion" }
})

function Potions:Init()
    require(script.Funcs):Init(self)
end

function Potions:Start()
	self.Data = Crypt.Import("Data")
	self.Profiles = self.Data:GetProfiles()
end

return Potions