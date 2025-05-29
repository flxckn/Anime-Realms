local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crypt = require(ReplicatedStorage.Cryptware.Crypt)

local MessagingHandler = Crypt.Register({ Name = "MessagingHandler" })
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local UI = ReplicatedStorage.Assets.UI
local MessageLabel = UI.ServerMessages.MessageLabel

function MessagingHandler:Init()
	self.Messaging = Crypt.Import("Messaging")
end

function MessagingHandler:Start()
    local ServerMessageUI = PlayerGui:WaitForChild("ServerMessages")

    local function hideCurrent()
        local foundMessage = ServerMessageUI:FindFirstChildWhichIsA("TextLabel")

        if foundMessage then
            foundMessage:TweenPosition(
                UDim2.fromScale(0.5, -0.3),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Sine,
                .25,
                false
            )
            task.wait(.25)
            foundMessage:Destroy()
        end
    end

    self.Messaging.SendMessage:Connect(function(status, messageData)
        hideCurrent()

        if status == "Show" then
            local newLabel: TextLabel = MessageLabel:Clone()
            newLabel.Text = messageData.Message
            newLabel.TextColor3 = messageData.Color
            newLabel.UIStroke.Color = messageData.Color2
            newLabel.Position = UDim2.fromScale(.5, -.2)
            newLabel.Parent = ServerMessageUI

            newLabel:TweenPosition(
                UDim2.fromScale(0.5, 0.15),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Sine,
                .25,
                false
            )
        end
    end)
end

return MessagingHandler