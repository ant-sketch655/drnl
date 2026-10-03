print("=== INICIANDO DRNL HUB RP ===")

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================================
-- MÓDULO ESP (Compatível com Mobile e PC)
-- ============================================================
local CONFIG = {
    Enabled = false,
    TeamCheck = false, -- DESATIVADO! Em RP, todos são do mesmo time.
    BoxColor = Color3.fromRGB(0, 255, 120),
    NameColor = Color3.fromRGB(255, 255, 0),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    HealthColor = Color3.fromRGB(0, 255, 0),
}

local espCache = {}

local function createESP(player)
    if player == LocalPlayer then return end

    local character = player.Character
    if not character then return end
    local head = character:FindFirstChild("Head")
    if not head then return end

    -- Se já existir, remove o antigo
    if espCache[player] then
        espCache[player]:Destroy()
        espCache[player] = nil
    end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "DRNL_ESP"
    billboard.Size = UDim2.new(4, 0, 5, 0) -- Tamanho da caixa
    billboard.StudsOffset = Vector3.new(0, 1.5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = head

    -- Caixa (Box)
    local box = Instance.new("Frame")
    box.Size = UDim2.new(1, 0, 1, 0)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 2
    box.BorderColor3 = CONFIG.BoxColor
    box.Parent = billboard

    -- Nome
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, -0.25, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = CONFIG.NameColor
    nameLabel.TextStrokeTransparency = 0
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.Parent = billboard

    -- Distância
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(1, 0, 0, 20)
    distLabel.Position = UDim2.new(0, 0, 1.1, 0)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "[ 0m ]"
    distLabel.TextColor3 = CONFIG.DistanceColor
    distLabel.TextStrokeTransparency = 0
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 12
    distLabel.Parent = billboard

    -- Barra de Vida (Fundo)
    local hpBg = Instance.new("Frame")
    hpBg.Size = UDim2.new(0, 4, 1, 0)
    hpBg.Position = UDim2.new(-0.1, 0, 0, 0)
    hpBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    hpBg.BorderSizePixel = 0
    hpBg.Parent = billboard

    -- Barra de Vida (Preenchimento)
    local hpBar = Instance.new("Frame")
    hpBar.Size = UDim2.new(1, 0, 1, 0)
    hpBar.Position = UDim2.new(0, 0, 0, 0)
    hpBar.BackgroundColor3 = CONFIG.HealthColor
    hpBar.BorderSizePixel = 0
    hpBar.Parent = hpBg

    espCache[player] = billboard
end

local function removeESP(player)
    if espCache[player] then
        espCache[player]:Destroy()
        espCache[player] = nil
    end
end

-- Loop de atualização do ESP (Distância e Vida)
RunService.RenderStepped:Connect(function()
    if not CONFIG.Enabled then
        for _, gui in pairs(espCache) do gui.Enabled = false end
        return
    end

    for player, gui in pairs(espCache) do
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("HumanoidRootPart") then
            local humanoid = character.Humanoid
            local root = character.HumanoidRootPart

            if humanoid.Health > 0 and not (CONFIG.TeamCheck and player.Team == LocalPlayer.Team) then
                gui.Enabled = true
                
                -- Atualizar Distância
                local dist = math.floor((Camera.CFrame.Position - root.Position).Magnitude)
                local distLabel = gui:FindFirstChild("TextLabel", true) -- Pega o primeiro TextLabel (Nome)
                -- Como temos dois TextLabels, vamos pegar o segundo (Distância)
                for _, child in ipairs(gui:GetChildren()) do
                    if child:IsA("TextLabel") and child.Text:find("m") then
                        child.Text = "[ " .. dist .. "m ]"
                    end
                end

                -- Atualizar Barra de Vida
                local hpBg = gui:FindFirstChild("Frame")
                if hpBg then
                    local hpBar = hpBg:FindFirstChild("Frame")
                    if hpBar then
                        local hpPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                        hpBar.Size = UDim2.new(1, 0, hpPercent, 0)
                        hpBar.Position = UDim2.new(0, 0, 1 - hpPercent, 0)
                        hpBar.BackgroundColor3 = Color3.fromRGB(255 * (1 - hpPercent), 255 * hpPercent, 0)
                    end
                end
            else
                gui.Enabled = false
            end
        else
            gui.Enabled = false
        end
    end
end)

-- Inicialização
for _, player in ipairs(Players:GetPlayers()) do createESP(player) end
Players.PlayerAdded:Connect(createESP)
Players.PlayerRemoving:Connect(removeESP)
Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function() task.wait(0.5) createESP(p) end) end)

_G.ESP = {
    Toggle = function(state)
        CONFIG.Enabled = state
        if not state then
            for _, gui in pairs(espCache) do gui.Enabled = false end
        end
    end
}

-- ============================================================
-- GUI DO HUB
-- ============================================================
local gui = Instance.new("ScreenGui")
gui.Name = "DRNLHUBRP"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.Enabled = true

local parented = false
if gethui then pcall(function() gui.Parent = gethui() parented = true end) end
if not parented then pcall(function() gui.Parent = game:GetService("CoreGui") parented = true end) end
if not parented then pcall(function() gui.Parent = LocalPlayer:WaitForChild("PlayerGui") parented = true end) end

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 175, 0, 400)
main.Position = UDim2.new(1, -190, 0.5, -200)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 38)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Text = "DRNL HUB RP"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

local comandos = {
    {nome = "//mat 3x", cmd = "/TIRO NA CABEÇA", vezes = 3},
    {nome = "//mat", cmd = "/TIRO NA CABEÇA", vezes = 1},
    {nome = "//Furar pneu", cmd = "//Furar pneu", vezes = 1},
    {nome = "//Furar pneu 3x", cmd = "//Furar pneu", vezes = 3},
    {nome = "//Render", cmd = "//Render", vezes = 1},
    {nome = "//Render 3x", cmd = "//Render", vezes = 3},
}

local function enviar(cmd, vezes)
    for i = 1, (vezes or 1) do
        pcall(function()
            game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(cmd, "All")
        end)
        pcall(function()
            local tcs = game:GetService("TextChatService")
            local channel = tcs.TextChannels:FindFirstChild("RBXGeneral")
            if channel then channel:SendAsync(cmd) end
        end)
    end
end

for i, v in ipairs(comandos) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -14, 0, 36)
    btn.Position = UDim2.new(0, 7, 0, 46 + (i-1) * 42)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = v.nome
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.Parent = main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(65, 65, 65) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40) end)
    btn.MouseButton1Click:Connect(function() enviar(v.cmd, v.vezes) end)
end

-- Botão do ESP
local espY = 46 + (#comandos) * 42 + 6
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(1, -14, 0, 36)
espBtn.Position = UDim2.new(0, 7, 0, espY)
espBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
espBtn.Text = "ESP [OFF]"
espBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 13
espBtn.Parent = main
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0, 6)

local espState = false
espBtn.MouseButton1Click:Connect(function()
    espState = not espState
    if espState then
        espBtn.Text = "ESP [ON]"
        espBtn.BackgroundColor3 = Color3.fromRGB(30, 90, 50)
        _G.ESP.Toggle(true)
    else
        espBtn.Text = "ESP [OFF]"
        espBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        _G.ESP.Toggle(false)
    end
end)

-- Botão da Bolinha
local bolinha = Instance.new("TextButton")
bolinha.Size = UDim2.new(0, 42, 0, 42)
bolinha.Position = UDim2.new(1, -70, 0, 8)
bolinha.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
bolinha.Text = "☰"
bolinha.TextColor3 = Color3.fromRGB(255, 255, 255)
bolinha.Font = Enum.Font.GothamBold
bolinha.TextSize = 20
bolinha.Parent = gui
Instance.new("UICorner", bolinha).CornerRadius = UDim.new(1, 0)

bolinha.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

print("✅ DRNL HUB RP carregado! ESP Mobile Ativado.")
