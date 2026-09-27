-- AUTO WALLHOP - By dantexx (Corrigido para Delta Executor)
-- Grok Imagine ativado + SuperGrok Dedicado

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace  = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")

-- CORREÇÃO 1: Usar variável local em vez de getgenv() para evitar nil value
local Config = {
	wallCheckDistance = 2.5,
	jumpCooldown      = 0.3,
	flickAngle        = 60,
	flickDuration     = 0.25,
	autoWallHop       = true,
	requireVertical   = true,
	sampleBand        = 1.2,
	sampleCount       = 9,
	seamTolerance     = 0.6,
	directions        = 8,
}

local player = Players.LocalPlayer
local character, humanoid, hrp
local lastJumpTime = 0
local flick = { active = false, t = 0, baseYaw = 0 }

local rayParams = RaycastParams.new()
do
	local ok, ft = pcall(function() return Enum.RaycastFilterType.Exclude end)
	rayParams.FilterType = ok and ft or Enum.RaycastFilterType.Blacklist
	rayParams.IgnoreWater = true
end

-- CORREÇÃO 2: Inicialização segura das direções
local RAY_DIRS = {}
for i = 0, Config.directions - 1 do
	local a = (i / Config.directions) * math.pi * 2
	RAY_DIRS[i + 1] = Vector3.new(math.cos(a), 0, math.sin(a))
end

local function normalizeAngle(a) return (a + math.pi) % (2 * math.pi) - math.pi end
local function getYaw(cf) local l = cf.LookVector return math.atan2(-l.X, -l.Z) end
local function smoothstep(s) s = math.clamp(s, 0, 1) return s * s * (3 - 2 * s) end

local function setYawAbsolute(yaw)
	if not hrp then return end
	local cf, pos = hrp.CFrame, hrp.CFrame.Position
	local delta = normalizeAngle(yaw - getYaw(cf))
	if math.abs(delta) < 1e-4 then return end
	local lv, av = hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity
	hrp.CFrame = CFrame.new(pos) * CFrame.Angles(0, delta, 0) * (cf - pos)
	hrp.AssemblyLinearVelocity  = lv
	hrp.AssemblyAngularVelocity = av
end

local function getFeetY()
	if not hrp or not humanoid then return 0 end
	return hrp.Position.Y - hrp.Size.Y * 0.5 - (humanoid.HipHeight or 0)
end

local function isWallHit(result)
	if not result or not result.Instance or not result.Instance.CanCollide then return false end
	if Config.requireVertical and math.abs(result.Normal.Y) >= 0.35 then return false end
	return true
end

local function findSeam()
	-- CORREÇÃO 3: Garantir que hrp existe antes de usar
	if not hrp then return false end
	
	local origin = hrp.Position
	local feetY  = getFeetY()
	local halfBand = Config.sampleBand
	local n        = Config.sampleCount
	local step     = (halfBand * 2) / (n - 1)

	for _, dir in ipairs(RAY_DIRS) do
		local prevPart, prevY = nil, nil
		for k = 1, n do
			local y = feetY - halfBand + step * (k - 1)
			local o = Vector3.new(origin.X, y, origin.Z)
			local r = Workspace:Raycast(o, dir * Config.wallCheckDistance, rayParams)

			if isWallHit(r) then
				local part = r.Instance
				if prevPart and part ~= prevPart then
					local seamY = (prevY + y) * 0.5
					if math.abs(seamY - feetY) <= Config.seamTolerance then
						return true
					end
				end
				prevPart = part
				prevY    = y
			else
				prevPart, prevY = nil, nil
			end
		end
	end
	return false
end

local function startFlick()
	if flick.active or not hrp or not humanoid then return end
	flick.active  = true
	flick.t       = 0
	flick.baseYaw = getYaw(hrp.CFrame)
	humanoid.AutoRotate = false
end

local function updateFlick(dt)
	if not flick.active or not hrp or not humanoid then return end
	flick.t = flick.t + dt
	local a = math.clamp(flick.t / Config.flickDuration, 0, 1)
	local angle = math.rad(Config.flickAngle)

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
		if humanoid then humanoid.AutoRotate = true end
	end
end

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

-- ==================== TOGGLE BUTTON (F1) ====================
local toggleEnabled = Config.autoWallHop

local function toggleScript()
	toggleEnabled = not toggleEnabled
	Config.autoWallHop = toggleEnabled

	if toggleEnabled then
		print("✅ AUTO WALLHOP LIGADO")
	else
		print("❌ AUTO WALLHOP DESLIGADO")
	end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end -- Evita ativar quando estiver digitando no chat
	if input.KeyCode == Enum.KeyCode.F1 then
		toggleScript()
	end
end)

-- ==================== BOTÃO VISUAL FLICK ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "WallhopFlick"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = player:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 180, 0, 60)
MainFrame.Position = UDim2.new(0.5, -90, 1, -90)
MainFrame.BackgroundTransparency = 0.1
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(1, 0)
Corner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "FLICK"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

-- ==================== LOOP PRINCIPAL ====================
RunService.RenderStepped:Connect(function(dt)
	-- CORREÇÃO 4: Verificação rigorosa para não quebrar o script
	if not hrp or not humanoid or humanoid.Health <= 0 then 
		if MainFrame then MainFrame.Visible = false end
		return 
	end

	updateFlick(dt)

	if not toggleEnabled then 
		MainFrame.Visible = false
		return 
	end
	MainFrame.Visible = true

	if flick.active then return end
	if os.clock() - lastJumpTime < Config.jumpCooldown then return end

	if humanoid.FloorMaterial ~= Enum.Material.Air then return end

	local state = humanoid:GetState()
	if state == Enum.HumanoidStateType.Climbing or state == Enum.HumanoidStateType.Swimming then return end

	if not findSeam() then return end

	lastJumpTime = os.clock()
	startFlick()
	humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)

print("🎮 Wallhop carregado! F1 = ligar/desligar | Botão FLICK visual")
