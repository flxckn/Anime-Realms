local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Crypt = require(ReplicatedStorage.Cryptware.Crypt)
local PotionHandler = Crypt.Register({ Name = "PotionHandler" })

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local PotionsGui = PlayerGui:WaitForChild("Potions")

local TimeTemplate = ReplicatedStorage.Assets.UI.Potions.TimeTemplate
local PotionItems = require(ReplicatedStorage.Shared.Potions)

local function toSeconds(hms)
    local days, hours, minutes, seconds = 0, 0, 0, 0
    
    if #hms > 11 then
        days = hms:sub(1, 2) * 86400
        hours = hms:sub(5, 6) * 3600
        minutes = hms:sub(9, 10) * 60
        seconds = hms:sub(13, 14)
    else
        hours = hms:sub(1, 2) * 3600
        minutes = hms:sub(5, 6) * 60
        seconds = hms:sub(9, 10)
    end
    
    return days + hours + minutes + seconds
end

local function toHMS(s)
    return s >= 86400 and ("%02id %02ih %02im %02is"):format(math.floor(s/86400), math.floor(s/60^2%24), math.floor(s/60%60), math.floor(s%60)) or ("%02ih %02im %02is"):format(math.floor(s/60^2%24), math.floor(s/60%60), math.floor(s%60))
end

local function InitPotion(potion, potionData)
	local timelabel = TimeTemplate:Clone()
	timelabel.Visible = false
	timelabel.Parent = PotionsGui.Container

	while task.wait(1) do
		if potionData.Time <= 0 then
			potionData.Time = 0
			timelabel.Visible = false
		else
			potionData.Time -= 1
			timelabel.Text = `{potion}: {toHMS(potionData.Time)}`
			timelabel.Visible = true
		end
	end
end

function PotionHandler:Init()
	self.Potions = {}
end

function PotionHandler:Start()
	local PotionSystem = Crypt.Import("Potions")

	PotionSystem.UpdateTime:Connect(function(potion, potionData)
		if self.Potions[potion] and self.Potions[potion].Initialized then
			self.Potions[potion].Time = potionData.Time
		else
			self.Potions[potion] = potionData
			self.Potions[potion].Initialized = true
			InitPotion(potion, potionData)
		end
	end)

	for porion, potionData in self.Potions do
		if not potionData.Initialized then
			potionData.Initialized = true
			task.spawn(InitPotion, porion, potionData)
		end
	end
end

return PotionHandler