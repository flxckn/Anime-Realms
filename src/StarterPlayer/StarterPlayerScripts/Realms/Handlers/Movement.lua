local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local ContextActionService = game:GetService("ContextActionService")
local RunService = game:GetService("RunService")

local Crypt = require(ReplicatedStorage.Cryptware.Crypt)

local Movement = Crypt.Register({ Name = "Movement" })
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid: Humanoid = Character:WaitForChild("Humanoid")
local keys = {"W", "A", "S", "D"}

function Movement:Init()
	self.Running = false
	self.ToggleDebounce = false
	self.JumpDebounce = false
end

function Movement:Start()
	self.CharacterState = Crypt.Import("CharacterState")
	self:HandleCharacter()
	self:HandleHumanoid()
end

function Movement:HandleHumanoid()
	Humanoid:SetAttribute("JumpPower", Humanoid.JumpPower)
	Humanoid:SetAttribute("MinJumpPower", Humanoid.JumpPower)
	
	Humanoid:GetAttributeChangedSignal("JumpPower"):Connect(function()
		Humanoid.JumpPower = Humanoid:GetAttribute("JumpPower")
	end)

	Humanoid.Jumping:Connect(function()
		if not self.JumpDebounce then
			self.JumpDebounce = true
			task.wait(.1)
			Humanoid:SetAttribute("JumpPower", 0)
			task.wait(1)
			Humanoid:SetAttribute("JumpPower", Humanoid:GetAttribute("MinJumpPower"))
			self.JumpDebounce = false
		end
	end)
end

function Movement:HandleCharacter()
	Character:SetAttribute("MinSpeed", Humanoid.WalkSpeed)
	Character:SetAttribute("MaxSpeed", Humanoid.WalkSpeed * 1.75)
	Character:SetAttribute("Weight", 0)
	Character:SetAttribute("Speed", Humanoid.WalkSpeed)

	Character:GetAttributeChangedSignal("Speed"):Connect(function()
		Humanoid.WalkSpeed = Character:GetAttribute("Speed")
	end)
	
	local function updateCharacterState()
		if self.Busy or self.CharacterState.Bound then
			return
		end

		local isIdle = Humanoid.MoveDirection == Vector3.zero
		local isJumping = Humanoid:GetState() == Enum.HumanoidStateType.Jumping or Humanoid.Jump
		local isFalling = Humanoid:GetState() == Enum.HumanoidStateType.Freefall

		local lastState = self.CharacterState.State
		local isRunning = self.Running
		local state

		if isIdle and not isJumping and not isFalling then
			state = "Idle"
		elseif not isJumping and not isIdle and not isFalling and not isRunning then
			state = "Walking"
		elseif not isJumping and not isIdle and not isFalling and isRunning then
			state = "Running"
		elseif isJumping and not isIdle then
			state = "Jumping"
		elseif isFalling and not isIdle then
			state = "Falling"
		elseif isFalling and isIdle then
			state = "Jumping"
		end

		for _, key in keys do
			if UserInputService:IsKeyDown(Enum.KeyCode[key]) and not isRunning then
				state = "Walking"
				break
			elseif UserInputService:IsKeyDown(Enum.KeyCode[key]) and isRunning then
				state = "Running"
				break
			end
		end

		state = UserInputService:IsKeyDown(Enum.KeyCode.Space) and Humanoid.FloorMaterial == Enum.Material.Air and "Jumping" or state

		if state == "Jumping" or state == "Falling" then
			workspace.Gravity = 320
		else
			workspace.Gravity = 196.2
		end

		if lastState == state then
			return
		end

		if lastState == "Falling" and state == "Jumping" then
			return
		end

		self.CharacterState:SetState(state)
	end
	
	local function HandleRunning()
		if self.ToggleDebounce then
			return
		end
		self.ToggleDebounce = true
		self.Running = not self.Running

		local current = self.Running and Character:GetAttribute("MaxSpeed")
			or Character:GetAttribute("MinSpeed")
		Character:SetAttribute("Speed", current - Character:GetAttribute("Weight"))
		
		task.wait(.25)
		self.ToggleDebounce = false
	end

	RunService.Stepped:Connect(function()
		updateCharacterState()
	end)
	
	UserInputService.InputBegan:Connect(function(input, GPE)
		if GPE then
			return
		end

		if input.KeyCode == Enum.KeyCode.LeftControl or input.KeyCode == Enum.KeyCode.ButtonA then
			HandleRunning()
		end
	end)

	UserInputService.InputChanged:Connect(function(input, GPE)
		if GPE then
			self.Busy =	true
			return
		else
			self.Busy =	false
		end
	end)
	
	if UserInputService.TouchEnabled then
		HandleRunning()
	end
	
	ContextActionService:BindAction("ToggleSprint", HandleRunning, true)
	ContextActionService:SetTitle("ToggleSprint", "Toggle Sprint")
	ContextActionService:SetPosition("ToggleSprint", UDim2.new(1, -70, 0, 10))
end

return Movement