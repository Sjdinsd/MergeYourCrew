local ReplicatedStorage = game:GetService("ReplicatedStorage")

local sift = require(ReplicatedStorage.Packages.sift)
local EasyAnimator = {}

export type AnimationOptions = number

function EasyAnimator.new(animator: Animator, animations: { [string]: Animation })
	local self = {}
	self._animator = animator :: Animator
	self._animations = animations
	self._activeTracks = { Ext = {} } :: { [string]: AnimationTrack, Ext: { AnimationTrack } }

	return setmetatable(self, EasyAnimator)
end

export type EasyAnimator = typeof(EasyAnimator.new(nil :: any, nil :: any))

function EasyAnimator.animate(self: EasyAnimator, animationName: string, ...: AnimationOptions)
	local animation = self._animations[animationName]
	local track = self._animator:LoadAnimation(animation)
	if self._activeTracks[animationName] then
		self._activeTracks[animationName]:Stop()
	end
	self._activeTracks[animationName] = track
	track:Play(...)

	if track.Looped then
		return self
	end

	task.delay(track.Length, function()
		if not self._activeTracks[animationName] then
			return
		end
		self._activeTracks[animationName] = nil
	end)

	return self
end

function EasyAnimator.animateExternal(self: EasyAnimator, animation: Animation, ...: AnimationOptions)
	local track = self._animator:LoadAnimation(animation)
	local idx = #self._activeTracks + 1
	self._activeTracks.Ext[idx] = track
	track:Play(...)

	if not track.Looped then
		task.delay(track.Length, function()
			if not self._activeTracks.Ext[idx] then
				return
			end
			self._activeTracks.Ext[idx] = nil
		end)
	end

	return track
end

function EasyAnimator.stopAnimation(self: EasyAnimator, animationName: string)
	if not self._activeTracks[animationName] then
		return self
	end
	self._activeTracks[animationName]:Stop()
	self._activeTracks[animationName] = nil

	return self
end

function EasyAnimator.stopAllAnimations(self: EasyAnimator)
	for idx, track in self._activeTracks do
		if idx == "Ext" then
			for _, extTrack in self._activeTracks[idx] do
				extTrack:Stop()
			end
		else
			track:Stop()
		end
	end

	return self
end

function EasyAnimator.addAnimations(self: EasyAnimator, animations)
	sift.Dictionary.merge(self._animations, animations)

	return self
end

function EasyAnimator.destroy(self: EasyAnimator)
	EasyAnimator:stopAllAnimations()
	self = nil
end

return EasyAnimator
