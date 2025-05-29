local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crypt = require(ReplicatedStorage.Cryptware.Crypt)

local Admin = Crypt.Register({ Name = "Admin" }).Expose({
    RE = { "SendCommand", "SendMessage", "Notify" },
    RF = { "CheckAdmin" }
})

function Admin:Init()
    self.Prefix = "/"
    self.TempAdministrators = {}

    self.Administrators = {
        ["168170701"] = "encrxpt3d",
        ["1276064805"] = "PaidosDev",
        ["2733923205"] = "idk91",
        ["428007781"] = "math731",
        ["109051248"] = "Lelep",
        ["3439007392"] = "LeozimGamers",
        ["115247828"] = "PaidosGame",
    }

	require(script.Funcs):Init(self)
end

function Admin:Start()
	self.Data = Crypt.Import("Data")
    self.Potions = Crypt.Import("Potions")
    self.Level = Crypt.Import("Level")
    self.Messaging = Crypt.Import("Messaging")
    
	self.Profiles = self.Data:GetProfiles()
    require(script.Commands):Init(self)
end

function Admin:PlayerRemoving(player)
    if self.TempAdministrators[tostring(player.UserId)] then
        self.TempAdministrators[tostring(player.UserId)] = nil
    end
end

return Admin