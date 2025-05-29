local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Crypt = require(ReplicatedStorage.Cryptware.Crypt)
local CharacterState = Crypt.Register({ Name = "CharacterState" })

local Player = Players.LocalPlayer
local PlayerGui = Player.PlayerGui
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Animator = Humanoid.Animator
local keys = {"Space", "W", "A", "S", "D"}

function CharacterState:Init()
	self.DefaultAnims = require(script.DefaultAnims)
	self.Anims = self.DefaultAnims
	
	self.Debounce = false
	self.CurrentTracks = {}
	
	Character:WaitForChild("Animate"):Destroy()
	self:LoadAnims()
end

function CharacterState:SetState(state, noLoop)
	if self.State == state or not self.Anims[state] then
		return
	end
	
	if self.DefaultAnims[state] and self.Bound then
		return
	end
	
	if self.Debounce then
		return
	end
	
	self.Debounce = true
	self.State = state
	self:UnloadAnims()
	return self:PlayAnim(state, noLoop)
end

function CharacterState:LoadAnim(anim)
	local animId = self.Anims[anim]
	
	if self.CurrentTracks[anim] or not animId then
		return
	end
	
	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://" .. animId
	
	local animTrack = Animator:LoadAnimation(animation)
	animTrack.Name = anim
	self.CurrentTracks[anim] = animTrack
end

function CharacterState:StopAnim(anim)
	local animTrack: AnimationTrack = self.CurrentTracks[anim]
	
	if not animTrack then
		return
	end
	
	animTrack:Stop()
end

function CharacterState:PlayAnim(anim, noLoop)
	local animTrack: AnimationTrack = self.CurrentTracks[anim]
	
	local ret = {}

	function ret:andThen(callback)
		callback(animTrack)
	end

	if not animTrack then
		return ret
	end
	
	if not anim:match("Jumping")
		and not anim:match("Falling")
		and not anim:match("Equip")
		and not anim:match("Swing")
	then
		animTrack.Looped = true
	end
	
	if anim:match("Jumping") or anim:match("Falling") then
		animTrack:AdjustSpeed(.75)
		noLoop = true
	elseif anim:match("SwordWalking") then
		animTrack:AdjustSpeed(6)
	elseif anim:match("SwordRunning") then
		animTrack:AdjustSpeed(.1)
	elseif anim:match("SwordEquip") then
		animTrack:AdjustSpeed(0.35)
	end
	
	animTrack:Play()
	
	if not noLoop then
		task.spawn(function()
			animTrack:AdjustSpeed(0)
			animTrack:AdjustWeight(0)

			for i = 1, 5 do
				task.wait()
				animTrack:AdjustSpeed(i / 5)
				animTrack:AdjustWeight(i / 5)
			end

			animTrack:AdjustSpeed(1)
			animTrack:AdjustWeight(1)
		end)
	end
	
	task.wait(.1)
	self.Debounce = false
	return ret
end

function CharacterState:LoadAnims()
	for anim, animId in self.Anims do
		self:LoadAnim(anim, animId)
	end
end

function CharacterState:UnloadAnims(match)
	for anim, track in Animator:GetPlayingAnimationTracks() do
		track:Stop()
		track.Looped = false
		
		if not self.Anims[track.Name] then
			track:Destroy()
		end
		
		if match and track.Name:match(match) then
			track:Destroy()
			self.CurrentTracks[anim] = nil
		end
	end
end

function CharacterState:BindAnims(anims)
	self.Bound = true
	self.Anims = anims
	self:LoadAnims()
end

function CharacterState:UnbindAnims(match)
	self:UnloadAnims(match)
	self.Anims = self.DefaultAnims
	self.Bound = false
end

return CharacterState