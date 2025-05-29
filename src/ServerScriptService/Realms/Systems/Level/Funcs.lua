local Funcs = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local InfiniteMath = require(ReplicatedStorage.Cryptware.InfiniteMath)
local Assets = ReplicatedStorage.Assets

local LevelUpVFX = Assets.Particles.LevelUp

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

function Funcs:Init(Level)
	function Level:GetLevelData(player)
		return self.Profiles[player].LevelData
	end

	function Level:LevelUp(player, levelData, level)
		levelData.Level = level or levelData.Level + 1
		levelData.CurrentExp = 0
		levelData.MaxExp = 10 + (levelData.Level * 10)

		task.spawn(function()
			local hrp = player.Character.HumanoidRootPart

			for _, attachment: Attachment in LevelUpVFX.HRP:GetChildren() do
				local attch = attachment:Clone()
				attch.Parent = hrp

				task.delay(2, function()
					for _, emitter: ParticleEmitter in attch:GetChildren() do
						emitter.Enabled = false
					end

					game.Debris:AddItem(attch, .5)
				end)
			end
		end)
	end

	function Level:SafeLevel(player, levelData)
		if levelData.Level >= self.MaxLevel then
			self:LevelUp(player, levelData, self.MaxLevel)
			return false
		end
		return true
	end

	function Level:ExpCap(levelData, amt)
		if levelData.CurrentExp + amt >= levelData.MaxExp then
			return true
		end
	end

	function Level:CheckExp(player, levelData, amt)
		local failed = false

		while task.wait() do
			if not self:SafeLevel(player, levelData) then
				failed = true
				break
			elseif self:ExpCap(levelData, amt) then
				amt = (levelData.CurrentExp + amt) - levelData.MaxExp
				self:LevelUp(player, levelData)
			else
				break
			end
		end

		if not failed or amt < levelData.MaxExp then
			levelData.CurrentExp += amt
		end
	end
	
	function Level:SetLevel(player, lvl)
		local profile = self.Profiles[player]
		local levelData = profile.Data.LevelData
		
		self:LevelUp(player, levelData, lvl)
		return levelData
	end
	
	function Level:AddExp(player, amt)
		local profile = self.Profiles[player]
		local levelData = profile.Data.LevelData
		local multis = profile.Data.Multipliers
		
		levelData.CurrentExp += amt * (multis.Exp > 0 and multis.Exp or 1)
		self:CheckExp(player, levelData, amt)

		return levelData
	end
	
	function Level:PlayerAdded(player)
		self.GetInfo:Fire(player)
	end
end

return Funcs