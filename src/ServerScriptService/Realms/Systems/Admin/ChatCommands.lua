local ChatCommands = {}

function ChatCommands.Panel(player)
    local panel = player.PlayerGui:WaitForChild("Admin", 10)
    
    if panel then
        panel.Enabled = not panel.Enabled
    end
end

return ChatCommands