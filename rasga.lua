local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local model = nil
local keys = {}
local speed = 1.3
local rotSpeed = 3.5

local function part(parent, size, offset, color, transp)
	local p = Instance.new("Part")
	p.Size = size
	p.CFrame = CFrame.new(offset)
	p.Color = color
	p.Transparency = transp or 0.52
	p.Anchored = true
	p.CanCollide = false
	p.Material = Enum.Material.SmoothPlastic
	p.Parent = parent

	local h = Instance.new("Highlight")
	h.OutlineColor = Color3.fromRGB(0, 210, 255)
	h.FillTransparency = 1
	h.OutlineTransparency = 0.25
	h.Parent = p
	return p
end

local function criar()
	if model then model:Destroy() end

	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local origem = root.Position + root.CFrame.LookVector * 22 + Vector3.new(0, 3, 0)

	model = Instance.new("Model")
	model.Name = "CafeMolde"

	local primary = part(model, Vector3.new(1.5,1.5,1.5), origem, Color3.fromRGB(255,70,70), 0.4)
	primary.Name = "Primary"
	model.PrimaryPart = primary

	local function r(x,y,z)
		return origem + Vector3.new(x,y,z)
	end

	-- Piso principal
	part(model, Vector3.new(40, 1, 30), r(0, 0.5, 0), Color3.fromRGB(90, 65, 45))

	-- Paredes
	part(model, Vector3.new(40, 9, 0.6), r(0, 5, -15), Color3.fromRGB(80, 55, 35))          -- frente madeira
	part(model, Vector3.new(40, 9, 0.6), r(0, 5, 15), Color3.fromRGB(50, 95, 55))           -- fundo verde
	part(model, Vector3.new(0.6, 9, 30), r(-20, 5, 0), Color3.fromRGB(155, 150, 140))       -- lateral
	part(model, Vector3.new(0.6, 9, 30), r(20, 5, 0), Color3.fromRGB(155, 150, 140))

	-- Vidros grandes da fachada
	part(model, Vector3.new(16, 6.5, 0.4), r(-8, 4.5, -15.2), Color3.fromRGB(145, 205, 255), 0.7)
	part(model, Vector3.new(16, 6.5, 0.4), r(8, 4.5, -15.2), Color3.fromRGB(145, 205, 255), 0.7)

	-- Segundo andar / mezanino
	part(model, Vector3.new(28, 1, 18), r(0, 10, 3), Color3.fromRGB(90, 65, 45))
	part(model, Vector3.new(28, 5.5, 0.5), r(0, 13, -6), Color3.fromRGB(50, 95, 55))

	-- Teto
	part(model, Vector3.new(42, 1.2, 32), r(0, 16, 0), Color3.fromRGB(70, 50, 35), 0.45)

	-- Letreiro CAFE
	part(model, Vector3.new(13, 3, 0.7), r(0, 12, -15.5), Color3.fromRGB(25, 25, 25), 0.3)

	-- Pátio externo
	part(model, Vector3.new(40, 0.6, 13), r(0, 0.3, -21.5), Color3.fromRGB(100, 90, 80))

	-- Ombrelones
	for _, x in pairs({-12, 0, 12}) do
		part(model, Vector3.new(0.5, 4.8, 0.5), r(x, 2.8, -21.5), Color3.fromRGB(60, 40, 25), 0.4)
		part(model, Vector3.new(7.5, 0.35, 7.5), r(x, 5.5, -21.5), Color3.fromRGB(195, 70, 70), 0.45)
	end

	-- Balcão
	part(model, Vector3.new(14, 3.3, 2.8), r(0, 2.1, 6), Color3.fromRGB(80, 55, 35), 0.45)

	model.Parent = workspace
end

-- ================= GUI =================
local gui = Instance.new("ScreenGui")
gui.Name = "CafeGUI"
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local function btn(texto, pos, tamanho, cor)
	local b = Instance.new("TextButton")
	b.Size = tamanho
	b.Position = pos
	b.BackgroundColor3 = cor
	b.Text = texto
	b.TextColor3 = Color3.new(1,1,1)
	b.TextScaled = true
	b.Font = Enum.Font.GothamBold
	b.Parent = gui
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
	return b
end

-- Botões principais
local spawnBtn = btn("SPAWN", UDim2.new(0.03,0,0.68,0), UDim2.new(0.18,0,0.07,0), Color3.fromRGB(0,170,70))
local removeBtn = btn("REMOVER", UDim2.new(0.03,0,0.77,0), UDim2.new(0.18,0,0.07,0), Color3.fromRGB(200,40,40))

-- Movimento
local up = btn("↑", UDim2.new(0.79,0,0.55,0), UDim2.new(0.09,0,0.08,0), Color3.fromRGB(45,45,45))
local down = btn("↓", UDim2.new(0.79,0,0.73,0), UDim2.new(0.09,0,0.08,0), Color3.fromRGB(45,45,45))
local left = btn("←", UDim2.new(0.69,0,0.64,0), UDim2.new(0.09,0,0.08,0), Color3.fromRGB(45,45,45))
local right = btn("→", UDim2.new(0.89,0,0.64,0), UDim2.new(0.09,0,0.08,0), Color3.fromRGB(45,45,45))

-- Girar e altura
local rotL = btn("↺", UDim2.new(0.69,0,0.83,0), UDim2.new(0.09,0,0.07,0), Color3.fromRGB(100,50,160))
local rotR = btn("↻", UDim2.new(0.89,0,0.83,0), UDim2.new(0.09,0,0.07,0), Color3.fromRGB(100,50,160))
local hUp = btn("⬆", UDim2.new(0.79,0,0.45,0), UDim2.new(0.09,0,0.07,0), Color3.fromRGB(30,100,180))
local hDown = btn("⬇", UDim2.new(0.79,0,0.83,0), UDim2.new(0.09,0,0.07,0), Color3.fromRGB(30,100,180))

spawnBtn.MouseButton1Click:Connect(criar)
removeBtn.MouseButton1Click:Connect(function()
	if model then model:Destroy() model = nil end
end)

local function set(k, v) keys[k] = v end

up.MouseButton1Down:Connect(function() set("W", true) end)
up.MouseButton1Up:Connect(function() set("W", false) end)
down.MouseButton1Down:Connect(function() set("S", true) end)
down.MouseButton1Up:Connect(function() set("S", false) end)
left.MouseButton1Down:Connect(function() set("A", true) end)
left.MouseButton1Up:Connect(function() set("A", false) end)
right.MouseButton1Down:Connect(function() set("D", true) end)
right.MouseButton1Up:Connect(function() set("D", false) end)
rotL.MouseButton1Down:Connect(function() set("Q", true) end)
rotL.MouseButton1Up:Connect(function() set("Q", false) end)
rotR.MouseButton1Down:Connect(function() set("E", true) end)
rotR.MouseButton1Up:Connect(function() set("E", false) end)
hUp.MouseButton1Down:Connect(function() set("R", true) end)
hUp.MouseButton1Up:Connect(function() set("R", false) end)
hDown.MouseButton1Down:Connect(function() set("F", true) end)
hDown.MouseButton1Up:Connect(function() set("F", false) end)

-- Movimento contínuo
RunService.RenderStepped:Connect(function()
	if not model or not model.PrimaryPart then return end
	local move = Vector3.zero
	local rot = 0

	if keys["W"] then move = move + Vector3.new(0, 0, -speed) end
	if keys["S"] then move = move + Vector3.new(0, 0, speed) end
	if keys["A"] then move = move + Vector3.new(-speed, 0, 0) end
	if keys["D"] then move = move + Vector3.new(speed, 0, 0) end
	if keys["R"] then move = move + Vector3.new(0, speed, 0) end
	if keys["F"] then move = move + Vector3.new(0, -speed, 0) end
	if keys["Q"] then rot = rot + rotSpeed end
	if keys["E"] then rot = rot - rotSpeed end

	if move.Magnitude > 0 or rot \~= 0 then
		model:SetPrimaryPartCFrame(model.PrimaryPart.CFrame * CFrame.new(move) * CFrame.Angles(0, math.rad(rot), 0))
	end
end)

criar() -- já spawna
