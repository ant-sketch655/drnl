-- AUTO WALLHOP, By - dantexx

-- Services
local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace  = game:GetService("Workspace")

-- Allows Use with other scripts, and advanced features like `Randomise flick angle(min-max)`
-- Global config so u can change this later on without Re-Executing, copy paste if necesary
getgenv().Wallhop_Config = {
	wallCheckDistance = 2.5,   -- ray length (studs)
	jumpCooldown      = 0.3,  -- seconds between hops, usualy should be larger than flick duration
	flickAngle        = 60,    -- degerees
	flickDuration     = 0.25,  -- duration of hop sequence or smth
	autoWallHop       = true,
	requireVertical   = true,  -- self explanatory

	-- seam detection
	sampleBand        = 1.2,   -- up/down step sample rate
	sampleCount       = 9,     -- vertical samples per direction
	seamTolerance     = 0.6,   -- max distance of intercestion from legs (studs)
	directions        = 8,     -- horizontal ray directions
}

local player = Players.LocalPlayer

-- States
local character, humanoid, hrp
local lastJumpTime = 0
local flick = { active = false, t = 0, baseYaw = 0 }

-- Raycasts
local rayParams = RaycastParams.new()
do
	local ok, ft = pcall(function() return Enum.RaycastFilterType.Exclude end)
	rayParams.FilterType = ok and ft or Enum.RaycastFilterType.Blacklist
	rayParams.IgnoreWater = true
end

-- Precompute horizontal ray directions (full circle)
local RAY_DIRS = {}
for i = 0, getgenv().Wallhop_Config.directions - 1 do
	local a = (i / getgenv().Wallhop_Config.directions) * math.pi * 2
	RAY_DIRS[i + 1] = Vector3.new(math.cos(a), 0, math.sin(a))
end

-- Math funcs
local function normalizeAngle(a) return (a + math.pi) % (2 * math.pi) - math.pi end
local function getYaw(cf) local l = cf.LookVector return math.atan2(-l.X, -l.Z) end
local function smoothstep(s) s = math.clamp(s, 0, 1) return s * s * (3 - 2 * s) end

local function setYawAbsolute(yaw)
	local cf, pos = hrp.CFrame, hrp.CFrame.Position
	local delta = normalizeAngle(yaw - getYaw(cf))
	if math.abs(delta) < 1e-4 then return end
	local lv, av = hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity
	hrp.CFrame = CFrame.new(pos) * CFrame.Angles(0, delta, 0) * (cf - pos)
	hrp.AssemblyLinearVelocity  = lv
	hrp.AssemblyAngularVelocity = av
end

-- Y lev of char's feet
local function getFeetY()
	return hrp.Position.Y - hrp.Size.Y * 0.5 - (humanoid.HipHeight or 0)
end

--[[
SEAM DETECTION:

For each horizontal direction, sample the wall at several
Y heights around the legs. A seam is detected when two
ADJACENT samples (with no gap between them) hit DIFFERENT
parts, and the seam is within seamTolerance of the feet.

]]
local function isWallHit(result)
	if not result or not result.Instance or not result.Instance.CanCollide then
		return false
	end
	if getgenv().Wallhop_Config.requireVertical and math.abs(result.Normal.Y) >= 0.35 then
		return false
	end
	return true
end

local function findSeam()
	local origin = hrp.Position
	local feetY  = getFeetY()

	local halfBand = getgenv().Wallhop_Config.sampleBand
	local n        = getgenv().Wallhop_Config.sampleCount
	local step     = (halfBand * 2) / (n - 1)

	for _, dir in ipairs(RAY_DIRS) do
		local prevPart, prevY = nil, nil

		for k = 1, n do
			local y = feetY - halfBand + step * (k - 1)
			local o = Vector3.new(origin.X, y, origin.Z)
			local r = Workspace:Raycast(o, dir * getgenv().Wallhop_Config.wallCheckDistance, rayParams)

			if isWallHit(r) then
				local part = r.Instance

				if prevPart and part ~= prevPart then
					-- seam detec
					local seamY = (prevY + y) * 0.5
					if math.abs(seamY - feetY) <= getgenv().Wallhop_Config.seamTolerance then
						return true
					end
				end

				prevPart = part
				prevY    = y
			else
				-- unless intersection we hop, we didnt get intersection
				prevPart, prevY = nil, nil
			end
		end
	end

	return false
end

-- Frames
local function startFlick()
	if flick.active then return end
	flick.active  = true
	flick.t       = 0
	flick.baseYaw = getYaw(hrp.CFrame)
	humanoid.AutoRotate = false
end

local function updateFlick(dt)
	if not flick.active then return end

	flick.t = flick.t + dt
	local a = math.clamp(flick.t / getgenv().Wallhop_Config.flickDuration, 0, 1)
	local angle = math.rad(getgenv().Wallhop_Config.flickAngle)

	local offset
	if a < 1/3 then
		offset = -angle * smoothstep(a * 3)
	elseif a < 2/3 then
		offset = -angle + (2 * angle) * smoothstep((a - 1/3) * 3)
	else
		offset = angle - angle * smoothstep((a - 2/3) * 3)
	end

	setYawAbsolute(flick.baseYaw + offset)

	if a >= 1 then
		flick.active = false
		setYawAbsolute(flick.baseYaw)
		humanoid.AutoRotate = true
	end
end

-- Char binder
local function onCharacter(char)
	character = char
	humanoid  = char:WaitForChild("Humanoid")
	hrp       = char:WaitForChild("HumanoidRootPart")

	rayParams.FilterDescendantsInstances = { char }

	flick.active = false
	lastJumpTime = 0
end

player.CharacterAdded:Connect(onCharacter)
if player.Character then onCharacter(player.Character) end


-- Main Loop
RunService.RenderStepped:Connect(function(dt)
	if not hrp or not humanoid or humanoid.Health <= 0 then return end

	updateFlick(dt)

	if not getgenv().Wallhop_Config.autoWallHop then return end
	if flick.active then return end
	if os.clock() - lastJumpTime < getgenv().Wallhop_Config.jumpCooldown then return end

	-- dont want to hop when yr on the ground do you?
	if humanoid.FloorMaterial ~= Enum.Material.Air then return end

	-- Anti-laddr + swim
	local state = humanoid:GetState()
	if state == Enum.HumanoidStateType.Climbing
		or state == Enum.HumanoidStateType.Swimming then
		return
	end

	--hop on intersections
	if not findSeam() then return end

	lastJumpTime = os.clock()
	startFlick()
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)
