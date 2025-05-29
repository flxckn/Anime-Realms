local Funcs = {}

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Assets = ReplicatedStorage.Assets
local SwordAssets = Assets.Swords
local Hitboxes = Assets.Hiboxes
local swingHitbox = Hitboxes.Swing

local anims = {
	Knockback = "13550142824"
}

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

function Funcs:Init(Swords)
	function Swords:PlayerAdded(player)
		local profile = self.Profiles[player]
		self.TempSwords[player] = {}

		local numSwords = 0
		for _, swordDef in profile.Data.Inventory.Swords do
			local sword = clone(swordDef)
			numSwords += 1
			sword.Id = numSwords
			self.TempSwords[player][sword.Id] = sword
		end

		self.UpdateSwords:Fire(player, self.TempSwords[player])
	end
	
	function Swords:Equip(player, swordId)
		local swordData = self.TempSwords[player][swordId]

		if not swordData then
			return
		end
		
		swordData.Equipped = true

		local swordAsset = SwordAssets[swordData.Name]:Clone()
		swordAsset.Name = swordData.Name
		swordAsset.Parent = player.Backpack

		return {
			Tool = swordAsset,
			Type = swordData.Type
		}
	end

	function Swords:Unequip(player, swordId)
		local swordData = self.TempSwords[player][swordId]

		if not swordData then
			return
		end
		
		swordData.Equipped = false

		local inBackpack = player.Backpack:FindFirstChild(swordData.Name)
		local inCharacter = player.Character:FindFirstChild(swordData.Name)

		if inBackpack then
			inBackpack:Destroy()
		elseif inCharacter then
			inCharacter:Destroy()
		end
	end
	
	function Swords:Swing(player)
		local plrChar = player.Character
		local plrRoot = plrChar.PrimaryPart
		local ObjectsInHitbox = workspace:GetPartBoundsInBox(plrChar.PrimaryPart.CFrame * CFrame.new(0, 0, -2), swingHitbox.Size)
		local hit = {}
		local dmg = {}
		
		for _, obj in ObjectsInHitbox do
			local theirChar = obj.Parent

			if not theirChar:FindFirstChild("Head") or hit[theirChar.Name] or theirChar.Name == plrChar.Name then
				continue
			end

			hit[theirChar.Name] = theirChar
			dmg[theirChar.Name] = 10
			break
		end
		
		for _, char in hit do
			local plr = Players:FindFirstChild(char.Name)
			
			if plr then
				self.PlayAnim:Fire(plr, anims.Knockback)
			else
				task.spawn(function()
					local root: BasePart = char.PrimaryPart
					local humanoid = char.Humanoid
					local knockbackDirection = plrRoot.CFrame.LookVector
					local knockbackForce = 300
					
					root:ApplyImpulse(knockbackDirection * knockbackForce)
				end)
				
				local anim = Instance.new("Animation")
				anim.AnimationId = `rbxassetid://{anims.Knockback}`

				local animator = char.Humanoid.Animator
				local track = animator:LoadAnimation(anim)
				track.Priority = Enum.AnimationPriority.Action4
				track:Play()
				track.Ended:Wait()
				track:Destroy()
			end
		end
		
		return dmg
	end
end

return Funcs