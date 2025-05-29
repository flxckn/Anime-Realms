local Funcs = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MessagingService = game:GetService("MessagingService")

local Utils = require(script.Parent.Utils)
local Gamepasses = require(ReplicatedStorage.Shared.Gamepasses)
local InfiniteMath = require(ReplicatedStorage.Cryptware.InfiniteMath)

local Commands = {}
Commands.Chat = require(script.Parent.ChatCommands)

local AdminSystem

function Commands.SetLevel(_, ...)
    local target, amt = ...
    Commands.AddLevel(_, target, amt, "Set")
end

function Commands.AddLevel(_, ...)
    local target, amt, setType = ...

    if setType then
        Commands.Level:SetLevel(target, amt)
    else
        local profile = Commands.Data.Profiles[target]
        local lvl = profile.Data.LevelData.Level

        Commands.Level:SetLevel(target, amt + lvl)
    end
end

function Commands.AddExp(_, ...)
    local target, amt = ...

    Commands.Level:AddExp(target, amt)
end

function Commands.SetLuck(_, ...)
    local target, amt = ...
    Commands.AddLuck(_, target, amt, "Set")
end

function Commands.AddLuck(_, ...)
    local target, amt, setType = ...

    if setType then
        Commands.Data[setType](Commands.Data, target, "Luck", InfiniteMath.new(amt .. ", 0"), "PlayerData")
    else
        Commands.Data:Add(target, "Luck", InfiniteMath.new(amt .. ", 0"), "PlayerData")
    end
end

function Commands.SetPower(_, ...)
    local target, amt = ...
    Commands.AddPower(_, target, amt, "Set")
end

function Commands.AddPower(_, ...)
    local target, amt, setType = ...

    if setType then
        Commands.Data[setType](Commands.Data, target, "Power", InfiniteMath.new(amt .. ", 0"), "PlayerData")
    else
        Commands.Data:Add(target, "Power", InfiniteMath.new(amt .. ", 0"), "PlayerData")
    end
end

function Commands.SetEssence(_, ...)
    local target, amt = ...
    Commands.AddEssence(_, target, amt, "Set")
end

function Commands.AddEssence(_, ...)
    local target, amt, setType = ...

    if setType then
        Commands.Data[setType](Commands.Data, target, "Essence", InfiniteMath.new(amt .. ", 0"), "PlayerData")
    else
        Commands.Data:Add(target, "Essence", InfiniteMath.new(amt .. ", 0"), "PlayerData")
    end
end

function Commands.SetPotion(_, ...)
    local target, item, amt = ...
    Commands.GivePotion(_, target, item, amt, "Set")
end

function Commands.GivePotion(_, ...)
    local target, item, amt, setType = ...
    item = item:sub(1, 1):upper() .. item:sub(2, #item):lower()

    Commands.Potions:HandleUse(target, {
        Item = item,
        Quantity = amt
    }, true, setType)
end

function Commands.Unban(_, id)
    local profile = Commands.Data.ProfileStore:LoadProfileAsync(`Player_{id}`, "ForceLoad")
    
    if profile ~= nil then
        if not profile.Data.Ban.Active then
            return
        else
            profile.Data.Ban.Active = false
        end
    end
end

function Commands.Ban(_, id)
    local profile
    local plr = Players:GetPlayerByUserId(id)

    if plr then
        profile = Commands.Data.Profiles[plr]
    else
        profile = Commands.Data.ProfileStore:LoadProfileAsync(`Player_{id}`, "ForceLoad")
    end
    
    if profile ~= nil then
        if profile.Data.Ban.Active then
            return
        else
            profile.Data.Ban.Active = true
        end

        profile:Release()
    end
end

function Commands.Kick(_, ...)
    local target, reason = ...

    target:Kick(reason or nil)
end

function Commands.GlobalShutdown()
    MessagingService:PublishAsync("GlobalShutdown")
end

function Commands.Shutdown()
    Commands.Data.KickMessage = "The server has shutdown, please rejoin."
    for _, profile in Commands.Data.Profiles do
        profile:Release()
    end
end

function Commands.GlobalMessage(_, message)
    MessagingService:PublishAsync("GlobalMessage", message)
end

function Commands.ServerMessage(_, message)
    Commands.Messaging:AddMessage({
        Message = message,
        Duration = 15,
        Color = Color3.new(0.968627, 0.250980, 0.250980),
        Color2 = Color3.new(0.658823, 0.149019, 0.149019)
    })
end

function Commands.GiveGamepass(_, target, useDisplay, gamepass)
    local id = Gamepasses:GetIdByName(gamepass)
    local targetName = if useDisplay then target.DisplayName else target.name

    if id then
        local gpName = Gamepasses:GetNameById(id)
        local profile = Commands.Data.Profiles[target]
       
        if not profile.Data.Gamepasses[id] then
            profile.Data.Gamepasses[id] = true
            AdminSystem.Notify:Fire(_, `GAVE {targetName:upper()}: {gpName}`, Color3.new(0.439215, 0.933333, 0.588235))
        else
            AdminSystem.Notify:Fire(_, `{targetName:upper()} ALREADY OWNS GAMEPASS`, Color3.new(0.913725, 0.560784, 0.035294))
        end
    else
        AdminSystem.Notify:Fire(_, "UNKNOWN GAMEPASS", Color3.new(0.733333, 0.066666, 0.066666))
    end
end

function Funcs:Init(Admin)
    AdminSystem = Admin
    Commands.Potions = Admin.Potions
    Commands.Data = Admin.Data
    Commands.Level = Admin.Level
    Commands.Messaging = Admin.Messaging

    Admin.Commands = Commands
end

return Funcs