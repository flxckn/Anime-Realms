local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crypt = require(ReplicatedStorage.Cryptware.Crypt)

local Template = Crypt.Register({ Name = "Template" })
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

function Template:Init()
	
end

return Template