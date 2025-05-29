local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Crypt = require(ReplicatedStorage.Cryptware.Crypt)
local SwordHandler = Crypt.Register({ Name = "SwordHandler" })

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local PlayerGui = Player.PlayerGui

local Assets = ReplicatedStorage.Assets
local Shared = ReplicatedStorage.Shared

local Hitboxes = Assets.Hiboxes
local hitbox = Hitboxes.Swing

local SwordAnims = require(Shared.SwordAnims)

local keys = {"W", "A", "S", "D"}
local options = { "SwordSwing1", "SwordSwing2" }

function SwordHandler:Init()
	self.Toggled = false
	self.CurrentSwords = nil
	self.Debounce = false
	self.Swing = false
	self.Connections = {}
end

function SwordHandler:Start()
	self.Swords = Crypt.Import("Swords")
	self.CharacterState = Crypt.Import("CharacterState")
	self.Movement = Crypt.Import("Movement")
	
	self.Swords.UpdateSwords:Connect(function(swords)
		self.CurrentSwords = swords
	end)
	
	self.Swords.PlayAnim:Connect(function(animId)
		local anim = Instance.new("Animation")
		anim.AnimationId = `rbxassetid://{animId}`
		
		local animator = Humanoid.Animator
		local track = animator:LoadAnimation(anim)
		track.Priority = Enum.AnimationPriority.Action4
		track:Play()
		track.Ended:Wait()
		track:Destroy()
	end)
	
	UserInputService.InputBegan:Connect(function(input, GPE)
		if GPE then
			return
		end
		
		if input.KeyCode == Enum.KeyCode.E then
			self.Toggled = not self.Toggled
			self:Toggle()
		end
	end)
end

function SwordHandler:Toggle()
	if self.Toggled then
		self:HandleTool(self.Swords:Equip(1))
	else
		self.Swords:Unequip(1)
	end
end

function SwordHandler:HandleTool(toolData)
	if not toolData then
		return
	end
	
	local tool: Tool = toolData.Tool
	local toolType = toolData.Type
	
	self.Connections.Equipped = tool.Equipped:Connect(function()
		Character:SetAttribute("Weight", 4)
		Character:SetAttribute("Speed", Character:GetAttribute("Speed") - Character:GetAttribute("Weight"))
		
		self.CharacterState:BindAnims(SwordAnims[toolType])
		self.CharacterState:SetState("SwordEquip")
		task.wait(.7)
		
		self.Connections.UpdateState = RunService.Stepped:Connect(function()
			self:UpdateCharacterState()
		end)
		
		self.Connections.Activated = tool.Activated:Connect(function()
			if self.Debounce then
				return
			end

			local selected = not self.Swing and options[1] or options[2]
			local ret = self.CharacterState:SetState(selected, true)

			if ret then
				self.Prioritized = true
				ret:andThen(function(track: AnimationTrack)
					self.Swing = not self.Swing
					self.Debounce = true
					
					task.spawn(function()
						local returned = self.Swords:Swing()
					end)
					
					track.Looped = false
					track.Priority = Enum.AnimationPriority.Action4
					track:AdjustSpeed(0.65)

					task.wait(.1)
					track:AdjustSpeed(2)
					task.wait(.1)
					track:Stop()
					
					self.Debounce = false
					self.Prioritized = false
				end)
			end
		end)
	end)

	self.Connections.Unequipped = tool.Unequipped:Connect(function()
		repeat task.wait() until self.Connections.UpdateState
		Character:SetAttribute("Weight", 0)
		
		local current = self.Movement.Running and Character:GetAttribute("MaxSpeed")
			or Character:GetAttribute("MinSpeed")
		Character:SetAttribute("Speed", current)
		
		self.Connections.UpdateState:Disconnect()
		self.CharacterState:UnbindAnims("Sword")
	end)
	
	tool.Parent = Character
end

function SwordHandler:UpdateCharacterState()
	if self.Prioritized then
		return
	end
	
	local isIdle = Humanoid.MoveDirection == Vector3.zero
	local isJumping = Humanoid:GetState() == Enum.HumanoidStateType.Jumping or Humanoid.Jump
	local isFalling = Humanoid:GetState() == Enum.HumanoidStateType.Freefall

	local lastState = self.CharacterState.State
	local isRunning = self.Movement.Running
	local state

	if isIdle and not isJumping and not isFalling then
		state = "SwordIdle"
	elseif not isJumping and not isIdle and not isFalling and not isRunning then
		state = "SwordWalking"
	elseif not isJumping and not isIdle and not isFalling and isRunning then
		state = "SwordRunning"
	elseif isJumping and not isIdle then
		state = "SwordJumping"
	elseif isFalling and not isIdle then
		state = "SwordFalling"
	elseif isFalling and isIdle then
		state = "SwordJumping"
	end
	
	for _, key in keys do
		if UserInputService:IsKeyDown(Enum.KeyCode[key]) and not isRunning then
			state = "SwordWalking"
		elseif UserInputService:IsKeyDown(Enum.KeyCode[key]) and isRunning then
			state = "SwordRunning"
		end
	end

	state = UserInputService:IsKeyDown(Enum.KeyCode.Space) and Humanoid.JumpPower > 0 and "SwordJumping" or state

	if state == "SwordJumping" then
		workspace.Gravity = 320
	else
		workspace.Gravity = 196.2
	end
	
	if lastState == state then
		return
	end
	
	if state == "SwordWalking" and lastState == state and not isIdle then
		return
	end
	
	if lastState == "SwordFalling" and state == "SwordJumping" then
		return
	end

	self.CharacterState:SetState(state)
end

return SwordHandler