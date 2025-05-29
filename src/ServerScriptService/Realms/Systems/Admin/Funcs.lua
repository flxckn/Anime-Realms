local Funcs = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PotionItems = require(ReplicatedStorage.Shared.Potions)

local Assets = ReplicatedStorage.Assets
local UI = Assets.UI

function Funcs:Init(Admin)
    Admin.SendCommand:Connect(function(player, cmd, ...)
        local id = tostring(player.UserId)
        local profile = Admin.Profiles[player]
    
        if profile.Data.Administrator or Admin.Administrators[id] and Admin.Commands[cmd] then
            Admin.Commands[cmd](player, ...)
        end
    end)

    function Admin:PlayerAdded(player)
        local id = tostring(player.UserId)
        local profile = self.Profiles[player]
    
        if profile.Data.Administrator or self.Administrators[id] then
            if not self.Administrators[id] then
                self.TempAdministrators[id] = player.Name
            end

            player.Chatted:Connect(function(msg)
                self:Chatted(player, msg)
            end)
        end
    end
    
    function Admin:Chatted(player, message)
        if message:sub(1, 1) ~= self.Prefix then
            return
        end

        local args = message:lower():gsub(self.Prefix, ""):split(" ")
        local cmd = args[1]:lower()

        for cmdName, cmdFunc in self.Commands.Chat do
            if cmdName:lower() == cmd then
                task.spawn(cmdFunc, player, args)
                break
            end
        end
    end

    function Admin:CheckAdmin(player)
        local id = tostring(player.UserId)
        local profile = self.Profiles[player]
    
        if profile.Data.Administrator or self.Administrators[id] then
            local panel = player.PlayerGui:FindFirstChild("Admin")

            if not panel then
                panel = UI.AdminPanel.Admin:Clone()
                panel.Enabled = false
                panel.Parent = player.PlayerGui
            end

            panel.Container.TopBar.Close.MouseButton1Click:Connect(function()
                panel.Enabled = false
            end)
            
            return true
        end

        return false
    end
end

return Funcs