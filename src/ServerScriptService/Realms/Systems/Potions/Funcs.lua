local Funcs = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PotionItems = require(ReplicatedStorage.Shared.Potions)

local function toHMS(s)
    return s >= 86400 and ("%02id %02ih %02im %02is"):format(math.floor(s/86400), math.floor(s/60^2%24), math.floor(s/60%60), math.floor(s%60)) or ("%02ih %02im %02is"):format(math.floor(s/60^2%24), math.floor(s/60%60), math.floor(s%60))
end

local function clone(tbl)
	local newTbl = {}
	for index, value in tbl do
		if type(value) == "table" then
			newTbl[index] = clone(value)
		else
			newTbl[index] = value
		end
	end
	return newTbl
end

function Funcs:Init(Potions)
    function Potions:HandleUse(player, useData, force, useType)
        local item = useData.Item
        local amt = useData.Quantity

        if type(item) ~= "string" or type(amt) ~= "string" then
            return
        end

        if not PotionItems[item] or (not force and not table.find(PotionItems[item].Quantities, tonumber(amt))) then
            return
        end

        local profile = self.Profiles[player]
        local potionData = profile.Data.Inventory.Potions[item]

        if not force and potionData.Owned[amt] < 1 then
            potionData.Owned[amt] = 0
            return
        elseif not force then
            potionData.Owned[amt] -= 1
        end

        if useType == "Set" then
            potionData.Time = (amt * 60)
        else
            potionData.Time += (amt * 60)
        end

        self.UpdateTime:Fire(player, item, potionData)
        self.UpdatePotions:Fire(player, item, potionData.Owned[amt])
    end

    function Potions:HandlePurchase(player, purchaseData)
        local item = purchaseData.Item
        local amt = purchaseData.Quantity

        if type(item) ~= "string" or type(amt) ~= "string" then
            return
        end

        if not PotionItems[item] or not table.find(PotionItems[item].Quantities, tonumber(amt)) then
            return
        end

        local profile = self.Profiles[player]
        local owned = profile.Data.Inventory.Potions[item].Owned

        if profile.Data.PlayerData.Essence < PotionItems[item].Price then
            return
        else
            self.Data:Sub(player, "Essence", PotionItems[item].Price, "PlayerData")
        end

        owned[amt] += 1
        self.UpdatePotions:Fire(player, item, owned[amt])
    end

    Potions.UsePotion:Connect(function(player, useData)
        Potions:HandleUse(player, useData)
    end)
    
    Potions.MakePurchase:Connect(function(player, purchaseData)
        Potions:HandlePurchase(player, purchaseData)
    end)

	function Potions:PlayerAdded(player)
		local profile = self.Profiles[player]
        
        for potion, potionData in profile.Data.Inventory.Potions do
			self.UpdateTime:Fire(player, potion, potionData)
            self.UpdatePotions:Fire(player, potion, potionData.Owned)

            task.spawn(self.InitPotion, self, player, profile, potion, potionData)
		end
	end

    function Potions:PlayerRemoving(player)
        local profile = self.Profiles[player]

        if not profile or profile.Data.Ban.Active then
            return
        end

        for potion, potionData in profile.Data.Inventory.Potions do
			if potionData.Time > 0 then
                profile.Data.Multipliers[potion] -= 2
            end
		end
    end

    function Potions:InitPotion(player, profile, potion, potionData)
        task.spawn(function()
            while task.wait(1) do
                if not player then
                    break
                end
    
                if potionData.Time > 0 then
                    profile.Data.Multipliers[potion] += 2
                    repeat task.wait() until not player or potionData.Time <= 0
                    profile.Data.Multipliers[potion] -= 2
                end
            end
        end)

        while task.wait(1) do
            if not player then
                break
            end

            if potionData.Time > 0 then
                potionData.Time -= 1
            end
        end
    end
end

return Funcs