local Utils = {}

local Players = game:GetService("Players")

function Utils.FindPlayer(shortName)
    for _, plr in Players:GetPlayers() do
        if plr.Name:lower():sub(1, #shortName) == shortName:lower() then
            return plr
        elseif plr.DisplayName:sub(1, #shortName) == shortName:lower() then
            return plr, true
        end
    end
end

return Utils