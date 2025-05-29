local Signals = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Assets = ReplicatedStorage.Assets

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

function Signals:Init(Essence)
	
end

return Signals