local Gamepasses = {}

local gamepasses = {
    ["184400985"] = "2x Essence",
    ["184400460"] = "2x Power",
    ["184400622"] = "2x Exp",
    ["184401963"] = "+1 Fighting Style Slot",
    ["184401499"] = "More Luck",
}

local fixes = {
    ["2xEssence"] = "2x Essence",
    ["2xPower"] = "2x Power",
    ["2xExp"] = "2x Exp",
    ["+1FightingStyleSlot"] = "+1 Fighting Style Slot",
    ["MoreLuck"] = "More Luck"
}

function Gamepasses:GetIdByName(passName)
    for id, gp in gamepasses do
        if gp:lower() == passName:lower() or gp:lower():match(passName:lower()) then
            return id
        elseif gp:lower():sub(1, #passName:lower()) == passName:lower() then
            return id
        elseif gp == passName or gp:match(passName) then
            return id
        end
    end
end

function Gamepasses:GetNameById(passId)
    return gamepasses[passId]
end

function Gamepasses:GetPasses()
    return gamepasses
end

function Gamepasses:IsPass(name, isId)
    if isId and self:GetNameById(name) then
        return true
    elseif not isId and self:GetIdByName(name) then
        return true
    end
    return false
end

function Gamepasses:FixPassName(passName)
    for fix, actual in fixes do
        if fix:lower():sub(1, #passName:lower()) == passName:lower() then
            return actual
        end
    end
end

function Gamepasses:GetPassNames()
    local namesTbl = {}

    for _, gpName in gamepasses do
        local name = gpName:gsub(" ", "")
        table.insert(namesTbl, name)
    end

    return namesTbl
end

return Gamepasses