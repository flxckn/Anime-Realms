local Funcs = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Abbreviate = require(ReplicatedStorage.Cryptware.Abbreviate)
local InfiniteMath = require(game:GetService("ReplicatedStorage").Cryptware.InfiniteMath)

local info = ReplicatedStorage.Assets.UI.Leaderboard.Info

function Funcs:Init(Leaderboards)
    function Leaderboards:PlayerAdded(player)
        self.TempPlaces[player] = {}

        for boardName, store in self.BoardStores do
            local smallestFirst = false
            local numberToShow = 100
            local minValue = 1
            local maxValue = 10e307
            local pages = store:GetSortedAsync(smallestFirst, numberToShow, minValue, maxValue)
            
            local top = pages:GetCurrentPage()
            local dataTbl = {}
    
            for _, data in top do
                local userId = data.key
    
                local username = "[Failed To Load]"
                local succ, err = pcall(function()
                    username = Players:GetNameFromUserIdAsync(userId)
                end)
    
                if not succ then
                    warn(err)
                end
    
                table.insert(dataTbl,{
                    Name = username
                })
            end

            local function find()
                for place, plrData in dataTbl do
                    if plrData.Name == player.Name then
                        self.TempPlaces[player][boardName] = place
                        return true
                    end
                end
            end

            local found = find()

            if found then
                continue
            end
        end
    end

    function Leaderboards:GetTypes()
        return self.Types
    end

    function Leaderboards:GetPlaces(player)
        return self.TempPlaces[player]
    end

    function Leaderboards:UpdateBoard(boardName)
        local board = self.Boards[boardName]
        local store = self.BoardStores[boardName]

        local list: ScrollingFrame = board.Main.Display.Container.List
        local layout: UIListLayout = list.UIListLayout

        for _, obj in list:GetChildren() do
            if obj:IsA("TextLabel") then
                obj:Destroy()
            end
        end

        local smallestFirst = false
        local numberToShow = 100
        local minValue = 1
        local maxValue = 10e307
        local pages = store:GetSortedAsync(smallestFirst, numberToShow, minValue, maxValue)
        
        local top = pages:GetCurrentPage()
        local dataTbl = {}

        for _, data in top do
            local userId = data.key
            local val = InfiniteMath:ConvertFromLeaderboards(data.value)
            --local val = Abbreviate:Abbreviate((10^(data.value/(2^63)*308.254))-1)

            local username = "[Failed To Load]"
            local succ, err = pcall(function()
                username = Players:GetNameFromUserIdAsync(userId)
            end)

            if not succ then
                warn(err)
            end

            local av = Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)

            table.insert(dataTbl,{
                Name = username,
                Value = val,
                Avatar = av
            })
        end

        for _, player in Players:GetPlayers() do
            self.TempPlaces[player][boardName] = 0
        end

        for place, plrData in dataTbl do
            local player = Players:FindFirstChild(plrData.Name)
            if player then
                self.TempPlaces[player][boardName] = place
            end

            local newInfo = info:Clone()
            newInfo.Text = `#{place} - {plrData.Name} - {plrData.Value}`
            newInfo.Parent = list
        end

        list.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y)
    end
end

return Funcs