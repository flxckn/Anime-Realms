local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local ItemFrame = ReplicatedStorage.Assets.UI.AdminPanel.DropItem
local ItemFrame2 = ReplicatedStorage.Assets.UI.AdminPanel.ScrollItem

local Funcs = {}
local UIFuncs = {}
UIFuncs.Connections = {}

local Commands = require(script.Parent.Commands)

function UIFuncs:HandleCommands()
    local CommandsScroll = self.AdminPanel.Container.Commands.ScrollContainer.Scroll
    local layout = CommandsScroll.UIListLayout
    
    for _, cmdInfo in Commands.CommandInfo do
        local newItem = ItemFrame2:Clone()
        newItem.ItemContainer.CommandName.Text = cmdInfo.Name:lower()
        newItem.ItemContainer.CommandDesc.Text = cmdInfo.Desc
        newItem.ItemContainer.CommandUsage.Text = cmdInfo.Usage
        newItem.Parent = CommandsScroll

        newItem.ItemContainer.Button.MouseButton1Click:Connect(function()
            print("Clicked:", cmdInfo.Name)
        end)
    end

    CommandsScroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)

    self.AdminPanel.Container.Main.Commands.Button.MouseButton1Click:Connect(function()
        self.AdminPanel.Container.Commands.Visible = true
        self.AdminPanel.Container.TopBar.Back.Visible = true
        self.AdminPanel.Container.Main.Visible = false
    end)

    self.AdminPanel.Container.TopBar.Back.MouseButton1Click:Connect(function()
        self.AdminPanel.Container.Main.Visible = true
        self.AdminPanel.Container.TopBar.Back.Visible = false
        self.AdminPanel.Container.Commands.Visible = false
    end)
end

function UIFuncs:HandleQuickCommand()
    local cmdBox: TextBox = self.AdminPanel.Container.Main.QuickCommand.Input
    local foundLabel: TextLabel = self.AdminPanel.Container.Main.QuickCommand.Found
    local drop: Frame = self.AdminPanel.Container.Drop

    local foundCmd = nil
    local filledCmd = false
    local currentArgs = {}

    local setting = false
    local argLevel = 1
    local lastArgLevel = argLevel

    local function set()
        setting = true
        task.wait(.15)
        cmdBox.Text = foundLabel.Text
        cmdBox.CursorPosition = #cmdBox.Text + 1
        setting = false
    end

    local function loadDrop(items)
        cmdBox.TextEditable = false
        setting = true
        if items and items[1] then
            for _, item in items do
                local newItem = ItemFrame:Clone()
    
                if typeof(item) == "Instance" and item:IsA("Player") then
                    newItem.ItemLabel.Text = item.Name .. " | " .. item.DisplayName
                else
                    newItem.ItemLabel.Text = item
                end
                
                newItem.Parent = drop.Scroll
                task.wait(.125)
            end

            drop:TweenSizeAndPosition(
                UDim2.fromScale(.975, .761),
                UDim2.fromScale(.5, 1.45),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Sine,
                .25,
                true
            )
        end
        cmdBox.TextEditable = true
        setting = false
    end

    local function unloadDrop()
        cmdBox.TextEditable = false
        setting = true
        if #drop.Scroll:GetChildren() > 1 then
            for _, item in drop.Scroll:GetChildren() do
                if item:IsA("Frame") then
                    item:Destroy()
                end
            end
    
            drop:TweenSizeAndPosition(
                UDim2.fromScale(.975, 0),
                UDim2.fromScale(.5, 1.079),
                Enum.EasingDirection.Out,
                Enum.EasingStyle.Sine,
                .25,
                true
            )
        end
        cmdBox.TextEditable = true
        setting = false
    end

    local function showItem(itemToShow)
        cmdBox.TextEditable = false
        setting = true
        itemToShow = if typeof(itemToShow) == "Instance"
            then if Commands.Settings.UseDisplay
                then itemToShow.DisplayName
                else itemToShow.Name
            else itemToShow

        for _, item in drop.Scroll:GetChildren() do
            if item:IsA("Frame") then
                item.Visible = true
            end

            if item:IsA("Frame")
            and not item.ItemLabel.Text:lower():match(itemToShow:lower()) then
                item.Visible = false
            end
        end
        cmdBox.TextEditable = true
        setting = false
    end
    
    local function showAllItems()
        cmdBox.TextEditable = false
        setting = true
        for _, item in drop.Scroll:GetChildren() do
            if item:IsA("Frame") then
                item.Visible = true
            end
        end
        cmdBox.TextEditable = true
        setting = false
    end

    self.Connections.Tab = UserInputService.InputBegan:Connect(function(input, GPE)
        if not GPE then
            return
        end

        if input.KeyCode == Enum.KeyCode.Tab then
            if foundCmd and not filledCmd then
                filledCmd = true
                set()
            end
        end
    end)
    
    cmdBox:GetPropertyChangedSignal("Text"):Connect(function()
        local succ, _ = pcall(function()
            if #cmdBox.Text > 0 then
                cmdBox.TextXAlignment = Enum.TextXAlignment.Left
            else
                foundLabel.Text = ""
    
                foundCmd = nil
                filledCmd = false
                currentArgs = {}
                argLevel = 1
                lastArgLevel = argLevel
    
                cmdBox.TextXAlignment = Enum.TextXAlignment.Center
                return
            end
    
            if setting then
                return
            end
    
            local str = cmdBox.Text
            local args = str:split(" ")
            
            if not args[1] then
                return
            end

            for index, arg in args do
                if arg:match("%s") or #arg < 1 then
                    table.remove(args, index)
                end
            end

            argLevel = #args

            if argLevel ~= lastArgLevel and Commands.CommandArgs[foundCmd.Name][argLevel - 1] and not str:sub(-1, -1):match("%s") then
                --print("Loading new args...\n\n")
                unloadDrop()
                loadDrop(Commands.CommandArgs[foundCmd.Name][argLevel - 1])
            elseif str:sub(-1, -1):match("%s") then
                --print("Loading next args...\n\n")
                unloadDrop()
                loadDrop(Commands.CommandArgs[foundCmd.Name][argLevel])
            end

            lastArgLevel = argLevel
    
            if args[2] and args[2]:match("%s") or args[2] and not Commands.Util:IsCommand(args[1]) then
                foundCmd = nil
                Commands.Util:FindCommand(" ")
                foundLabel.Text = ""
                return
            end

            if not Commands.Util:IsCommand(args[1]) then
                filledCmd = false
            end
    
            local cmd = Commands.Util:FindCommand(args[1])
    
            if cmd then
                if not Commands.Util:IsCommand(args[1]) then
                    foundCmd = cmd
                    foundLabel.Text = `{cmd.Name:lower()} `
                end
            elseif foundCmd then
                foundCmd = nil
                Commands.Util:FindCommand(" ")
                foundLabel.Text = ""
            end

            if foundCmd and args[2] and not args[2]:match("%s") and Commands.CommandArgs[foundCmd.Name][argLevel - 1] then
                local argument

                if currentArgs[argLevel]
                and not table.find(Commands.CommandArgs[foundCmd.Name][argLevel - 1], currentArgs[argLevel]) then
                    currentArgs[argLevel] = nil
                    return
                end

                for _, arg in Commands.CommandArgs[foundCmd.Name][argLevel - 1] do
                    if typeof(arg) == "Instance" and arg:IsA("Player") then
                        if arg.Name:lower():sub(1, #args[argLevel]) == args[argLevel]:lower() then
                            argument = arg.Name
                            Commands.Settings.Target = arg
                            Commands.Settings.UseDisplay = false
                            break
                        elseif arg.DisplayName:lower():sub(1, #args[argLevel]) == args[argLevel]:lower() then
                            argument = arg.DisplayName
                            Commands.Settings.Target = arg
                            Commands.Settings.UseDisplay = true
                            break
                        end
                    else
                        if arg:lower():sub(1, #args[argLevel]) == args[argLevel]:lower() then
                            argument = arg
                            break
                        end
                    end
                end

                if argument then
                    showItem(args[argLevel])
                    --showItem(argument)
                    currentArgs[argLevel] = argument
                else
                    showAllItems()
                    currentArgs[argLevel] = nil
                    return
                end
            end
    
            if foundCmd and #currentArgs >= #Commands.CommandArgs[foundCmd.Name] then
                unloadDrop()
                foundLabel.Text = ""
            end
        end)

        if not succ then
            --warn(err)
        end
    end)

    cmdBox.FocusLost:Connect(function(enterPressed)
        if not enterPressed then
            return
        end
        
        unloadDrop()
        local str = cmdBox.Text
        local args = str:split(" ")
        Commands.Util:RunCommand(args)

        foundCmd = nil
        filledCmd = false
        currentArgs = {}
        argLevel = 1
        lastArgLevel = argLevel

        cmdBox.Text = ""
        foundLabel.Text = ""
    end)
end

function Funcs:Init(AdminPanel)
    AdminPanel.UI = UIFuncs
    AdminPanel.UI.AdminPanel = AdminPanel.Panel
    
    Commands.Admin = AdminPanel.Admin
end

return Funcs