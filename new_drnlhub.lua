print("=== INICIANDO DRNL HUB RP ===")

-- ============================================================
-- SERVIÇOS
-- ============================================================
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- ============================================================
-- MÓDULO ESP (Box, Skeleton, Name, Distance, Health)
-- ============================================================
local ESP = {}
local Drawing = Drawing

local CONFIG = {
    Enabled = false,
    BoxColor = Color3.fromRGB(0, 255, 120),
    BoxThickness = 1.5,
    SkeletonColor = Color3.fromRGB(255, 165, 0),
    SkeletonThickness = 1.5,
    NameColor = Color3.fromRGB(255, 255, 0),
    DistanceColor = Color3.fromRGB(255, 255, 255),
    HealthBarBgColor = Color3.fromRGB(0, 0, 0),
    HealthBarColor = Color3.fromRGB(0, 255, 0),
    HealthBarWidth = 3,
    HealthBarOffset = 5,
    TeamCheck = true, -- Mude para false se quiser ver aliados também
}

local cache = {}

local function createESP(player)
    if player == LocalPlayer then return end
    if not Drawing then return end

    local data = {}

    data.Box = Drawing.new("Square")
    data.Box.Color = CONFIG.BoxColor
    data.Box.Thickness = CONFIG.BoxThickness
    data.Box.Filled = false
    data.Box.Visible = false

    data.Name = Drawing.new("Text")
    data.Name.Size = 14
    data.Name.Center = true
    data.Name.Outline = true
    data.Name.Color = CONFIG.NameColor
    data.Name.Visible = false

    data.Distance = Drawing.new("Text")
    data.Distance.Size = 12
    data.Distance.Center = true
    data.Distance.Outline = true
    data.Distance.Color = CONFIG.DistanceColor
    data.Distance.Visible = false

    data.HealthBg = Drawing.new("Square")
    data.HealthBg.Color = CONFIG.HealthBarBgColor
    data.HealthBg.Thickness = 1
    data.HealthBg.Filled = true
    data.HealthBg.Visible = false

    data.HealthBar = Drawing.new("Square")
    data.HealthBar.Color = CONFIG.HealthBarColor
    data.HealthBar.Thickness = 1
    data.HealthBar.Filled = true
    data.HealthBar.Visible = false

    data.Skeleton = {}
    local connections = {
        {"Head", "Torso"}, {"Torso", "Left Arm"}, {"Torso", "Right Arm"},
        {"Torso", "Left Leg"}, {"Torso", "Right Leg"},
        {"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"},
        {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"},
        {"LeftLowerArm", "LeftHand"}, {"UpperTorso", "RightUpperArm"},
        {"RightUpperArm", "RightLowerArm"}, {"RightLowerArm", "RightHand"},
        {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"},
        {"LeftLowerLeg", "LeftFoot"}, {"LowerTorso", "RightUpperLeg"},
        {"RightUpperLeg", "RightLowerLeg"}, {"RightLowerLeg", "RightFoot"}
    }

    for _, conn in ipairs(connections) do
        local line = Drawing.new("Line")
        line.Color = CONFIG.SkeletonColor
        line.Thickness = CONFIG.SkeletonThickness
        line.Visible = false
        table.insert(data.Skeleton, {Line = line, From = conn[1], To = conn[2]})
    end

    cache[player] = data
end

local function removeESP(player)
    local data = cache[player]
    if not data then return end

    if data.Box then data.Box:Remove() end
    if data.Name then data.Name:Remove() end
    if data.Distance then data.Distance:Remove() end
    if data.HealthBg then data.HealthBg:Remove() end
    if data.HealthBar then data.HealthBar:Remove() end

    if data.Skeleton then
        for _, lineData in ipairs(data.Skeleton) do
            if lineData.Line then lineData.Line:Remove() end
        end
    end
    cache[player] = nil
end

local function hideAll(data)
    data.Box.Visible = false
    data.Name.Visible = false
    data.Distance.Visible = false
    data.HealthBg.Visible = false
    data.HealthBar.Visible = false
    for _, lineData in ipairs(data.Skeleton) do
        lineData.Line.Visible = false
    end
end

local function updateESP()
    if not CONFIG.Enabled then
        for _, data in pairs(cache) do hideAll(data) end
        return
    end

    for player, data in pairs(cache) do
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")

        if not character or not humanoid or not rootPart or humanoid.Health <= 0
            or (CONFIG.TeamCheck and player.Team == LocalPlayer.Team) then
            hideAll(data)
            continue
        end

        local headPart = character:FindFirstChild("Head")
        local leftLeg = character:FindFirstChild("Left Leg") or character:FindFirstChild("LeftLowerLeg")

        local headPos = headPart and headPart.Position or rootPart.Position + Vector3.new(0, 1.5, 0)
        local legPos = leftLeg and leftLeg.Position or rootPart.Position - Vector3.new(0, 2.5, 0)

        local headScreen, headOnScreen = Camera:WorldToViewportPoint(headPos)
        local legScreen, legOnScreen = Camera:WorldToViewportPoint(legPos)

        if not (headOnScreen and legOnScreen) then
            hideAll(data)
            continue
        end

        local boxHeight = math.abs(headScreen.Y - legScreen.Y)
        local boxWidth = boxHeight * 0.6
        local boxTopLeft = Vector2.new(headScreen.X - boxWidth / 2, headScreen.Y)

        data.Box.Size = Vector2.new(boxWidth, boxHeight)
        data.Box.Position = boxTopLeft
        data.Box.Visible = true

        data.Name.Text = player.Name
        data.Name.Position = Vector2.new(headScreen.X, headScreen.Y - 18)
        data.Name.Visible = true

        local distance = math.floor((Camera.CFrame.Position - rootPart.Position).Magnitude)
        data.Distance.Text = string.format("[ %dm ]", distance)
        data.Distance.Position = Vector2.new(headScreen.X, legScreen.Y + 6)
        data.Distance.Visible = true

        local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
        local healthBarHeight = boxHeight
        local healthBarPos = Vector2.new(boxTopLeft.X - CONFIG.HealthBarOffset - CONFIG.HealthBarWidth, boxTopLeft.Y)
        local healthBarSize = Vector2.new(CONFIG.HealthBarWidth, healthBarHeight)
        local healthFillSize = Vector2.new(CONFIG.HealthBarWidth, healthBarHeight * healthPercent)
        local healthFillPos = Vector2.new(healthBarPos.X, healthBarPos.Y + healthBarHeight - healthFillSize.Y)

        data.HealthBg.Size = healthBarSize
        data.HealthBg.Position = healthBarPos
        data.HealthBg.Visible = true

        data.HealthBar.Size = healthFillSize
        data.HealthBar.Position = healthFillPos
        data.HealthBar.Color = Color3.fromRGB(255 * (1 - healthPercent), 255 * healthPercent, 0)
        data.HealthBar.Visible = true

        for _, lineData in ipairs(data.Skeleton) do
            local fromPart = character:FindFirstChild(lineData.From)
            local toPart = character:FindFirstChild(lineData.To)
            if fromPart and toPart then
                local fromPos, fromOnScreen = Camera:WorldToViewportPoint(fromPart.Position)
                local toPos, toOnScreen = Camera:WorldToViewportPoint(toPart.Position)
                if fromOnScreen and toOnScreen then
                    lineData.Line.From = Vector2.new(fromPos.X, fromPos.Y)
                    lineData.Line.To = Vector2.new(toPos.X, toPos.Y)
                    lineData.Line.Visible = true
                else
                    lineData.Line.Visible = false
                end
            else
                lineData.Line.Visible = false
            end
        end
    end
end

-- Inicialização do ESP (só se o Drawing existir no executor)
if Drawing then
    for _, player in ipairs(Players:GetPlayers()) do createESP(player) end
    Players.PlayerAdded:Connect(createESP)
    Players.PlayerRemoving:Connect(removeESP)
    RunService.RenderStepped:Connect(updateESP)
else
    warn("[DRNL HUB] API Drawing não disponível. ESP desativado.")
end

function ESP.Toggle(state)
    CONFIG.Enabled = state
end
_G.ESP = ESP

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
if gethui then
    pcall(function()
        gui.Parent = gethui()
        parented = true
    end)
end
if not parented then
    pcall(function()
        gui.Parent = game:GetService("CoreGui")
        parented = true
    end)
end
if not parented then
    pcall(function()
        gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        parented = true
    end)
end

-- Painel de comandos
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

-- Comandos (erro de sintaxe corrigido)
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
            if channel then
                channel:SendAsync(cmd)
            end
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

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)

    btn.MouseButton1Click:Connect(function()
        enviar(v.cmd, v.vezes)
    end)
end

-- ============================================================
-- BOTÃO DO ESP (adicionado abaixo dos comandos)
-- ============================================================
local espY = 46 + (#comandos) * 42 + 6 -- posição calculada automaticamente

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

espBtn.MouseEnter:Connect(function()
    espBtn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
end)
espBtn.MouseLeave:Connect(function()
    if _G.ESP and _G.ESP.Enabled then
        espBtn.BackgroundColor3 = Color3.fromRGB(30, 90, 50)
    else
        espBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

local espState = false
espBtn.MouseButton1Click:Connect(function()
    if not Drawing then
        espBtn.Text = "ESP [SEM SUPORTE]"
        return
    end

    espState = not espState
    if espState then
        espBtn.Text = "ESP [ON]"
        espBtn.BackgroundColor3 = Color3.fromRGB(30, 90, 50)
        if _G.ESP then _G.ESP.Toggle(true) end
    else
        espBtn.Text = "ESP [OFF]"
        espBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        if _G.ESP then _G.ESP.Toggle(false) end
    end
end)

-- ============================================================
-- BOTÃO DA BOLINHA (abre/fecha o painel)
-- ============================================================
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

print("✅ DRNL HUB RP carregado! Bolinha fixa no canto superior direito")
print("✅ ESP integrado com sucesso!")
