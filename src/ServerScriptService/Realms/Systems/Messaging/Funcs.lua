local MessagingService = game:GetService("MessagingService")
local Funcs = {}
local Queue = {}

function Funcs:Init(Messaging)
    MessagingService:SubscribeAsync("GlobalMessage", function(message)
        table.insert(Queue, {
            Message = message.Data,
            Duration = 15,
            Color = Color3.new(0.968627, 0.250980, 0.250980),
            Color2 = Color3.new(0.658823, 0.149019, 0.149019)
        })
    end)

    MessagingService:SubscribeAsync("GlobalShutdown", function()
        Messaging.Data.KickMessage = "The server has shutdown, please rejoin."
        for _, profile in Messaging.Data.Profiles do
            profile:Release()
        end
    end)

    function Messaging:AddMessage(messageData)
        table.insert(Queue, messageData)
    end

    task.spawn(function()
        while task.wait() do
            local nextItem = Queue[1]
    
            if nextItem then
                Messaging.SendMessage:FireAll("Show", nextItem)
                task.wait(nextItem.Duration)
                Messaging.SendMessage:FireAll()
                table.remove(Queue, 1)
            end
        end
    end)
end

return Funcs