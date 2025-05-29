local Commands = {}
local CommandUtils = require(script.Parent.CommandUtils)
local Players = game:GetService("Players")
local Gamepasses = require(game:GetService("ReplicatedStorage").Shared.Gamepasses)

local CurrentPlayers
task.spawn(function()
    CurrentPlayers = Players:GetPlayers()

    Players.PlayerAdded:Connect(function(player)
        table.insert(CurrentPlayers, player)
    end)

    Players.PlayerRemoving:Connect(function(player)
        local index = table.find(CurrentPlayers, player)
        table.remove(CurrentPlayers, index)
    end)
end)

Commands.CommandInfo = {
    { Name = "SetLevel", Desc = "Sets a specified player's level.", Usage = "<player_name> <number>" },
    { Name = "AddLevel", Desc = "Adds to a specified player's level.", Usage = "<player_name> <number>" },

    { Name = "AddExp", Desc = "Adds to a specified player's exp.", Usage = "<player_name> <number>" },
    
    { Name = "SetLuck", Desc = "Sets a specified player's luck.", Usage = "<player_name> <number>" },
    { Name = "AddLuck", Desc = "Adds to a specified player's luck.", Usage = "<player_name> <number>" },

    { Name = "SetPower", Desc = "Sets a specified player's power.", Usage = "<player_name> <number>" },
    { Name = "AddPower", Desc = "Adds to a specified player's power.", Usage = "<player_name> <number>" },

    { Name = "SetEssence", Desc = "Sets a specified player's essence.", Usage = "<player_name> <number>" },
    { Name = "AddEssence", Desc = "Adds to a specified player's essence.", Usage = "<player_name> <number>" },

    { Name = "SetPotion ", Desc = "Sets a specified player's potion duration for the given potion type.", Usage = "<player_name> <potion_type> <number>" },
    { Name = "GivePotion", Desc = "Adds to a specified player's potion duration for the given potion type.", Usage = "<player_name> <potion_type> <number>" },

    { Name = "Ban", Desc = "Permanently bans a specified user ID.", Usage = "<number>" },
    { Name = "Unban", Desc = "Unbans a specified user ID.", Usage = "<number>" },
    { Name = "Kick", Desc = "Kicks a specified player with optional reason.", Usage = "<player_name> [reason]" },

    { Name = "GiveGamepass", Desc = "Attempts to give a specified user a gamepass.", Usage = "<player_name> <pass_name>" },

    { Name = "GlobalShutdown", Desc = "Shuts all running servers down.", Usage = "N/A" },
    { Name = "Shutdown", Desc = "Shuts the current server down.", Usage = "N/A" },
    { Name = "GlobalMessage", Desc = "Notifies all running servers with the specified message.", Usage = "<message>" },
    { Name = "ServerMessage", Desc = "Notifies the current server with the specified message.", Usage = "<message>" },
}

Commands.CommandArgs = {
    SetLevel = {
        CurrentPlayers
    },

    AddLevel = {
        CurrentPlayers
    },

    AddExp = {
        CurrentPlayers
    },

    SetLuck = {
        CurrentPlayers
    },

    AddLuck = {
        CurrentPlayers
    },

    SetPower = {
        CurrentPlayers
    },

    AddPower = {
        CurrentPlayers
    },

    SetEssence = {
        CurrentPlayers
    },

    AddEssence = {
        CurrentPlayers
    },

    SetPotion = {
        CurrentPlayers,
        { "Essence", "Power", "Exp", "Luck" }
    },

    GivePotion = {
        CurrentPlayers,
        { "Essence", "Power", "Exp", "Luck" }
    },

    Unban = {
        CurrentPlayers
    },

    Ban = {
        CurrentPlayers
    },

    Kick = {
        CurrentPlayers
    },

    GiveGamepass = {
        CurrentPlayers,
        Gamepasses:GetPassNames()
    },
}

function Commands.SetLevel(args)
    if not Commands.Settings.Target then
        return
    end

    if not args[3] or not tonumber(args[3]) then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, Commands.Settings.Target, args[3])
end

function Commands.AddLevel(args)
    if not Commands.Settings.Target then
        return
    end

    if not args[3] or not tonumber(args[3]) then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, Commands.Settings.Target, args[3])
end

function Commands.AddExp(args)
    if not Commands.Settings.Target then
        return
    end
    
    if not args[3] or not tonumber(args[3]) then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, Commands.Settings.Target, args[3])
end

function Commands.SetLuck(args)
    if not Commands.Settings.Target then
        return
    end
    
    if not args[3] or not tonumber(args[3]) then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, Commands.Settings.Target, args[3])
end

function Commands.AddLuck(args)
    if not Commands.Settings.Target then
        return
    end
    
    if not args[3] or not tonumber(args[3]) then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, Commands.Settings.Target, args[3])
end

function Commands.SetPower(args)
    if not Commands.Settings.Target then
        return
    end
    
    if not args[3] or not tonumber(args[3]) then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, Commands.Settings.Target, args[3])
end

function Commands.AddPower(args)
    if not Commands.Settings.Target then
        return
    end
    
    if not args[3] or not tonumber(args[3]) then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, Commands.Settings.Target, args[3])
end

function Commands.SetEssence(args)
    if not Commands.Settings.Target then
        return
    end
    
    if not args[3] or not tonumber(args[3]) then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, Commands.Settings.Target, args[3])
end

function Commands.AddEssence(args)
    if not Commands.Settings.Target then
        return
    end
    
    if not args[3] or not tonumber(args[3]) then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, Commands.Settings.Target, args[3])
end

function Commands.SetPotion(args)
    if not Commands.Settings.Target then
        return
    end
    
    if not args[3] or not args[4] or not tonumber(args[4]) then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, Commands.Settings.Target, args[3], args[4])
end

function Commands.GivePotion(args)
    if not Commands.Settings.Target then
        return
    end
    
    if not args[3] or not args[4] or not tonumber(args[4]) then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, Commands.Settings.Target, args[3], args[4])
end

function Commands.Unban(args)
    local id = args[2]

    if not id or not tonumber(id) then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, id)
end

function Commands.Ban(args)
    local id = args[2]

    if not id or not tonumber(id) then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, id)
end

function Commands.Kick(args)
    local reason
    for i = 3, #args do
        if args[i] then
            if not reason then
                reason = ""
            end
            reason = `{reason} {args[i]}`
        end
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, Commands.Settings.Target, reason)
end

function Commands.GlobalShutdown()
    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName)
end

function Commands.Shutdown()
    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName)
end

function Commands.GlobalMessage(args)
    local message
    for i = 2, #args do
        if args[i] then
            if not message then
                message = ""
            end
            message = `{message} {args[i]}`
        end
    end

    if not message or #message == 0 then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, message)
end

function Commands.ServerMessage(args)
    local message
    for i = 2, #args do
        if args[i] then
            if not message then
                message = ""
            end
            message = `{message} {args[i]}`
        end
    end

    if not message or #message == 0 then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, message)
end

function Commands.GiveGamepass(args)
    local gamepass = Gamepasses:FixPassName(args[3])

    if not Commands.Settings.Target or not gamepass or #gamepass == 0 then
        return
    end

    Commands.Admin.SendCommand:Fire(Commands.Settings.CommandName, Commands.Settings.Target, Commands.Settings.UseDisplay, gamepass)
end

CommandUtils:Init(Commands)
return Commands