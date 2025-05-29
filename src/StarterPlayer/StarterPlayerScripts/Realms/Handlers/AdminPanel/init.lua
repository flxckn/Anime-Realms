local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Crypt = require(ReplicatedStorage.Cryptware.Crypt)

local AdminPanel = Crypt.Register({ Name = "AdminPanel" })
local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui

local UI = ReplicatedStorage.Assets.UI
local Notification = UI.Notifications.Notification

local function dragify(Frame)
    local dragToggle, dragStart, dragInput, startPos, Delta, Position
    
    local function updateInput(input)
        Delta = input.Position - dragStart
        Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
        game:GetService("TweenService"):Create(Frame, TweenInfo.new(.25), {Position = Position}):Play()
    end
    
    Frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragToggle = true
            dragStart = input.Position
            startPos = Frame.Position
            input.Changed:Connect(function()
                if (input.UserInputState == Enum.UserInputState.End) then
                    dragToggle = false
                end
            end)
        end
    end)
    
    Frame.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)
    
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if (input == dragInput and dragToggle) then
            updateInput(input)
        end
    end)
end

function AdminPanel:Init()
    self.Administrators = {
        ["168170701"] = { Rank = "Lead Programmer" },
        ["1276064805"] = { Rank = "Developer" },
        ["2733923205"] = { Rank = "Owner" },
        ["428007781"] = { Rank = "Owner" },
        ["109051248"] = { Rank = "Owner" },
        ["3439007392"] = { Rank = "Owner" },
        ["115247828"] = { Rank = "Owner" },
    }
end

function AdminPanel:Start()
    self.Admin = Crypt.Import("Admin")

    local succ = self.Admin:CheckAdmin()

    if self.Administrators[tostring(Player.UserId)] and succ then
        local panel = PlayerGui:WaitForChild("Admin", 10)
        self.Panel = panel

        require(script.Funcs):Init(self)

        self:HandleNotifications()
        self:Begin(self.Administrators[tostring(Player.UserId)])
    else
        for _, scrpt in script:GetChildren() do
            scrpt:Destroy()
        end
        self.Administrators = nil
        self.Begin = nil
        self.HandleNotifications = nil
        PlayerGui:WaitForChild("Notifications"):Destroy()
        UI.Notifications:Destroy()
    end
end

function AdminPanel:HandleNotifications()
    local Notifications = PlayerGui:WaitForChild("Notifications")
    local notifQueue = {}

    self.Admin.Notify:Connect(function(message, color)
        table.insert(notifQueue, {
            Message = message,
            Color = color
        })
    end)

    task.spawn(function()
        while task.wait() do
            local nextItem = notifQueue[1]

            if nextItem then
                local newNotif: Frame = Notification:Clone()
                newNotif.Status.Text = nextItem.Message
                newNotif.Status.TextColor3 = nextItem.Color
                newNotif.Parent = Notifications
        
                newNotif:TweenPosition(
                    UDim2.fromScale(0.841, 0.947),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Sine,
                    .2
                )
        
                task.wait(2.5)
        
                newNotif:TweenPosition(
                    UDim2.fromScale(0.841, 1.2),
                    Enum.EasingDirection.Out,
                    Enum.EasingStyle.Sine,
                    .2
                )

                task.wait(.2)
                newNotif:Destroy()
                table.remove(notifQueue, 1)
            end
        end
    end)
end

function AdminPanel:Begin(adminData)
    local adminRank = adminData.Rank
    local content, isReady = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
    
    local AdminContainer = self.Panel.Container
    local TopBar = AdminContainer.TopBar

    dragify(AdminContainer)
    TopBar.Avatar.Image = (isReady and content) or "rbxassetid://0"
    TopBar.Info.Text = `{Player.DisplayName} | {adminRank}`

    self.UI:HandleCommands()
    self.UI:HandleQuickCommand()
end

return AdminPanel