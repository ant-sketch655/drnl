-- ============================================================
-- STARK COMBAT HUB — WINDUI + FLY + HUD AJUSTADO
-- ============================================================

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local CYAN = Color3.fromRGB(0, 200, 255)
local WHITE = Color3.fromRGB(235, 245, 255)
local COR_BOTAO = Color3.fromRGB(22, 22, 22)
local COR_PROPULSOR = CYAN

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

-- ============================================================
-- SISTEMA DE CHAT
-- ============================================================
local function enviar(cmd)
    task.spawn(function()
        local success = false
        pcall(function()
            local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
            if channel then
                channel:SendAsync(cmd)
                success = true
            end
        end)
        if not success then
            pcall(function()
                game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(cmd, "All")
            end)
        end
    end)
end

-- ============================================================
-- SISTEMA ESP
-- ============================================================
local scanAtivo = false
local espInstancias = {}

local function limparESP(j)
    if espInstancias[j] then
        if espInstancias[j].highlight then espInstancias[j].highlight:Destroy() end
        if espInstancias[j].billboard then espInstancias[j].billboard:Destroy() end
        espInstancias[j] = nil
    end
end

local function aplicarESP(j)
    if j == player then return end
    limparESP(j)
    local char = j.Character
    if not char then return end
    
    local hl = Instance.new("Highlight")
    hl.FillColor = CYAN
    hl.OutlineColor = Color3.new(1,1,1)
    hl.FillTransparency = 0.6
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = char
    
    local head = char:FindFirstChild("Head")
    local bb, lbl
    if head then
        bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0, 220, 0, 44)
        bb.StudsOffset = Vector3.new(0, 3, 0)
        bb.AlwaysOnTop = true
        bb.Parent = head
        lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1,0,1,0)
        lbl.BackgroundTransparency = 1
        lbl.TextColor3 = CYAN
        lbl.TextStrokeTransparency = 0
        lbl.Font = Enum.Font.Code
        lbl.TextScaled = true
        lbl.Text = j.Name .. " [--m]"
        lbl.Parent = bb
    end
    espInstancias[j] = { highlight = hl, billboard = bb, label = lbl }
end

local function toggleESP(state)
    scanAtivo = state
    if state then
        for _, p in ipairs(Players:GetPlayers()) do
            aplicarESP(p)
        end
    else
        for j, _ in pairs(espInstancias) do
            limparESP(j)
        end
    end
end

RunService.RenderStepped:Connect(function()
    if not scanAtivo then return end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for j, inst in pairs(espInstancias) do
        if inst.label and j.Character then
            local h2 = j.Character:FindFirstChild("HumanoidRootPart")
            if h2 then
                local d = math.floor((h2.Position - hrp.Position).Magnitude)
                inst.label.Text = j.Name .. " [" .. d .. "m]"
            end
        end
    end
end)

Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function(char)
        task.wait(1)
        if scanAtivo then aplicarESP(p) end
    end)
end)

-- ============================================================
-- HUD DA ARMADURA (AJUSTADA PARA CABER NA TELA E MAIS TRANSPARENTE)
-- ============================================================
local armorGui = nil

local function toggleHUD(state)
    if not state then
        if armorGui then armorGui:Destroy() armorGui = nil end
        return
    end

    if armorGui then armorGui:Destroy() end
    armorGui = Instance.new("ScreenGui")
    armorGui.Name = "ARIA_ArmorHUD"
    armorGui.ResetOnSpawn = false
    armorGui.IgnoreGuiInset = true
    armorGui.DisplayOrder = 999
    armorGui.Parent = (gethui and gethui()) or CoreGui

    -- Imagem Principal
    local bgImage = Instance.new("ImageLabel")
    bgImage.Size = UDim2.new(1, 0, 1, 0) 
    bgImage.BackgroundTransparency = 1
    bgImage.Image = "rbxassetid://124658062891182"
    bgImage.ScaleType = Enum.ScaleType.Fit -- Mudado para Fit para não cortar as bordas no celular
    bgImage.ImageTransparency = 0.75 -- Mais transparente para enxergar o jogo
    bgImage.ZIndex = 2
    bgImage.Parent = armorGui

    -- Efeito de Scanline
    local scanline = Instance.new("Frame")
    scanline.Size = UDim2.new(1, 0, 0, 4)
    scanline.BackgroundColor3 = CYAN
    scanline.BackgroundTransparency = 0.7
    scanline.BorderSizePixel = 0
    scanline.ZIndex = 5
    scanline.Parent = armorGui
    
    task.spawn(function()
        while armorGui and armorGui.Parent do
            scanline.Position = UDim2.new(0, 0, 0, -4)
            local tween = game:GetService("TweenService"):Create(scanline, TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {Position = UDim2.new(0, 0, 1, 0)})
            tween:Play()
            task.wait(3)
        end
    end)
end

-- ============================================================
-- SISTEMA DE VOO (FLY) DO HOMEM DE FERRO
-- ============================================================
local tela = Instance.new("ScreenGui")
tela.Name = "StarkFlyUI"
tela.ResetOnSpawn = false
tela.Parent = playerGui

local flyAtivo = false
local boostAtivo = false
local flyBV, flyBG, conexaoRender
local flyParticles, flyLight, flyTrail

local INCLINACAO_NORMAL = math.rad(-15)
local INCLINACAO_BOOST = math.rad(-40)
local VELOCIDADE_INCLIN = 0.1
local FORCA_VERTICAL = 1.5
local VELOCIDADE = 50
local VELOCIDADE_BOOST = 120
local SUAVIDADE = 0.2

-- Botão FLY (Movido para a direita, acima do botão de pulo)
local btnFly = Instance.new("TextButton")
btnFly.Size = UDim2.new(0, 60, 0, 60)
btnFly.Position = UDim2.new(1, -80, 1, -180) 
btnFly.BackgroundColor3 = COR_BOTAO
btnFly.BorderSizePixel = 0
btnFly.Text = "FLY"
btnFly.TextColor3 = COR_PROPULSOR
btnFly.Font = Enum.Font.GothamBold
btnFly.TextSize = 14
btnFly.AutoButtonColor = false
btnFly.Parent = tela
corner(btnFly, 30)
local flyStroke = Instance.new("UIStroke")
flyStroke.Color = COR_PROPULSOR
flyStroke.Thickness = 2
flyStroke.Parent = btnFly

-- Botão BOOST (Movido para cima do Fly)
local btnBoost = Instance.new("TextButton")
btnBoost.Size = UDim2.new(0, 50, 0, 50)
btnBoost.Position = UDim2.new(1, -75, 1, -250)
btnBoost.BackgroundColor3 = COR_BOTAO
btnBoost.BorderSizePixel = 0
btnBoost.Text = "⚡"
btnBoost.TextColor3 = COR_PROPULSOR
btnBoost.Font = Enum.Font.GothamBold
btnBoost.TextSize = 22
btnBoost.AutoButtonColor = false
btnBoost.Visible = false
btnBoost.Parent = tela
corner(btnBoost, 25)
local boostStroke = Instance.new("UIStroke")
boostStroke.Color = COR_PROPULSOR
boostStroke.Thickness = 1.5
boostStroke.Parent = btnBoost

-- Status Label (Movido para a direita)
local statusFlyLbl = Instance.new("TextLabel")
statusFlyLbl.Size = UDim2.new(0, 120, 0, 26)
statusFlyLbl.Position = UDim2.new(1, -140, 1, -120)
statusFlyLbl.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
statusFlyLbl.BackgroundTransparency = 0.3
statusFlyLbl.BorderSizePixel = 0
statusFlyLbl.Text = "⚡ OFFLINE"
statusFlyLbl.TextColor3 = COR_PROPULSOR
statusFlyLbl.Font = Enum.Font.Code
statusFlyLbl.TextSize = 12
statusFlyLbl.Parent = tela
corner(statusFlyLbl, 6)
local statusFlyStroke = Instance.new("UIStroke")
statusFlyStroke.Color = COR_PROPULSOR
statusFlyStroke.Thickness = 1
statusFlyStroke.Transparency = 0.5
statusFlyStroke.Parent = statusFlyLbl

local function criarEfeitosFly(hrp)
    local attachment = Instance.new("Attachment")
    attachment.Name = "IronMan_Thruster"
    attachment.Position = Vector3.new(0, -2.8, 0)
    attachment.Parent = hrp

    flyParticles = Instance.new("ParticleEmitter")
    flyParticles.Texture = "rbxasset://textures/particles/fire_main.dds"
    flyParticles.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COR_PROPULSOR),
        ColorSequenceKeypoint.new(0.4, Color3.fromRGB(150, 230, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 80, 180)),
    })
    flyParticles.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 2.5),
        NumberSequenceKeypoint.new(0.5, 1.5),
        NumberSequenceKeypoint.new(1, 0),
    })
    flyParticles.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 1),
    })
    flyParticles.Lifetime = NumberRange.new(0.25, 0.5)
    flyParticles.Rate = 120
    flyParticles.Speed = NumberRange.new(20, 35)
    flyParticles.SpreadAngle = Vector2.new(12, 12)
    flyParticles.Rotation = NumberRange.new(0, 360)
    flyParticles.LightEmission = 1
    flyParticles.LightInfluence = 0
    flyParticles.Parent = attachment

    flyLight = Instance.new("PointLight")
    flyLight.Color = COR_PROPULSOR
    flyLight.Range = 12
    flyLight.Brightness = 2
    flyLight.Parent = attachment

    flyTrail = Instance.new("Trail")
    flyTrail.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COR_PROPULSOR),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 40, 100)),
    })
    flyTrail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1),
    })
    flyTrail.Lifetime = 0.6
    flyTrail.LightEmission = 1
    flyTrail.Attachment0 = attachment
    flyTrail.Attachment1 = attachment
    flyTrail.Parent = hrp
end

local function limparEfeitosFly(hrp)
    if not hrp then return end
    local att = hrp:FindFirstChild("IronMan_Thruster")
    if att then att:Destroy() end
    if flyParticles then flyParticles:Destroy(); flyParticles = nil end
    if flyLight then flyLight:Destroy(); flyLight = nil end
    if flyTrail then flyTrail:Destroy(); flyTrail = nil end
end

local function ativarFly()
    if flyAtivo then return end
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    flyAtivo = true
    inclinacaoAtual = INCLINACAO_NORMAL
    hum.PlatformStand = true

    flyBV = Instance.new("BodyVelocity")
    flyBV.Name = "IronMan_FlyBV"
    flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBV.Velocity = Vector3.new(0, 0, 0)
    flyBV.Parent = hrp

    flyBG = Instance.new("BodyGyro")
    flyBG.Name = "IronMan_FlyBG"
    flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    flyBG.P = 15000
    flyBG.D = 900
    flyBG.CFrame = Workspace.CurrentCamera.CFrame
    flyBG.Parent = hrp

    criarEfeitosFly(hrp)

    btnBoost.Visible = true
    btnFly.Text = "STOP"
    btnFly.TextColor3 = Color3.fromRGB(255, 100, 100)
    flyStroke.Color = Color3.fromRGB(255, 100, 100)
    statusFlyLbl.Text = "⚡ FLY ON"
    statusFlyLbl.TextColor3 = Color3.fromRGB(100, 255, 150)
    statusFlyStroke.Color = Color3.fromRGB(100, 255, 150)

    conexaoRender = RunService.RenderStepped:Connect(function()
        local char2 = player.Character
        local hrp2 = char2 and char2:FindFirstChild("HumanoidRootPart")
        if not hrp2 or not flyBV or not flyBG then return end

        local cam = Workspace.CurrentCamera
        local alvoInclinacao = boostAtivo and INCLINACAO_BOOST or INCLINACAO_NORMAL
        inclinacaoAtual = inclinacaoAtual + (alvoInclinacao - inclinacaoAtual) * VELOCIDADE_INCLIN
        flyBG.CFrame = cam.CFrame * CFrame.Angles(inclinacaoAtual, 0, 0)

        local moveDir = Vector3.new(0, 0, 0)
        local hum2 = char2:FindFirstChildOfClass("Humanoid")
        if hum2 then
            local md = hum2.MoveDirection
            if md.Magnitude > 0.05 then
                local horiz = Vector3.new(md.X, 0, md.Z)
                if horiz.Magnitude > 0.01 then horiz = horiz.Unit end
                local pitch = cam.CFrame.LookVector.Y
                moveDir = Vector3.new(horiz.X, pitch * FORCA_VERTICAL, horiz.Z)
                if moveDir.Magnitude > 0.01 then moveDir = moveDir.Unit end
            end
        end

        local speed = boostAtivo and VELOCIDADE_BOOST or VELOCIDADE
        if moveDir.Magnitude > 0 then
            flyBV.Velocity = flyBV.Velocity:Lerp(moveDir * speed, SUAVIDADE)
        else
            flyBV.Velocity = flyBV.Velocity:Lerp(Vector3.new(0,0,0), 0.3)
        end
    end)
end

local function desativarFly()
    if not flyAtivo then return end
    flyAtivo = false
    boostAtivo = false

    if conexaoRender then conexaoRender:Disconnect(); conexaoRender = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end
    limparEfeitosFly(hrp)

    btnBoost.Visible = false
    btnBoost.BackgroundColor3 = COR_BOTAO
    btnFly.Text = "FLY"
    btnFly.TextColor3 = COR_PROPULSOR
    flyStroke.Color = COR_PROPULSOR
    statusFlyLbl.Text = "⚡ OFFLINE"
    statusFlyLbl.TextColor3 = COR_PROPULSOR
    statusFlyStroke.Color = COR_PROPULSOR
end

btnFly.MouseButton1Click:Connect(function()
    if flyAtivo then desativarFly() else ativarFly() end
end)

btnBoost.MouseButton1Click:Connect(function()
    boostAtivo = not boostAtivo
    if boostAtivo then
        btnBoost.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
        btnBoost.TextColor3 = Color3.fromRGB(0, 0, 0)
        boostStroke.Color = Color3.fromRGB(255, 200, 50)
        statusFlyLbl.Text = "⚡ BOOST ON"
    else
        btnBoost.BackgroundColor3 = COR_BOTAO
        btnBoost.TextColor3 = COR_PROPULSOR
        boostStroke.Color = COR_PROPULSOR
        statusFlyLbl.Text = "⚡ FLY ON"
    end
end)

-- ============================================================
-- PAINEL DE COMBATE FLUTUANTE
-- ============================================================
local function abrirPainelCombate()
    local antigo = playerGui:FindFirstChild("PainelCombate")
    if antigo then antigo:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "PainelCombate"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 1000
    gui.Parent = playerGui 

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 220, 0, 400)
    main.Position = UDim2.new(1, -240, 0.5, -200)
    main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    main.BorderSizePixel = 0
    main.Active = false
    main.Parent = gui
    corner(main, 10)

    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 38)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleBar.Active = false
    titleBar.Parent = main
    corner(titleBar, 10)

    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -50, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "PAINEL COMBATE"
    titleText.TextColor3 = WHITE
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 15
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar

    -- Arrastar
    local dragging, dragInput, dragStart, startPos
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Botão Fechar
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 34, 0, 34)
    closeBtn.Position = UDim2.new(1, -38, 0, 2)
    closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeBtn.Text = "X"
    closeBtn.TextColor3 = WHITE
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 18
    closeBtn.ZIndex = 999
    closeBtn.Active = true
    closeBtn.Parent = titleBar
    corner(closeBtn, 8)
    
    local function fecharPainel() gui:Destroy() end
    closeBtn.MouseButton1Click:Connect(fecharPainel)
    closeBtn.Activated:Connect(fecharPainel)

    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -10, 1, -48)
    scroll.Position = UDim2.new(0, 5, 0, 43)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 3
    scroll.ScrollBarImageColor3 = CYAN
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.Parent = main

    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 4)
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Parent = scroll

    local padding = Instance.new("UIPadding")
    padding.PaddingTop = UDim.new(0, 4)
    padding.PaddingLeft = UDim.new(0, 4)
    padding.PaddingRight = UDim.new(0, 4)
    padding.PaddingBottom = UDim.new(0, 4)
    padding.Parent = scroll

    local comandos = {
        {"Soco - Rosto", "//SOCO - ROSTO"}, {"Chute - Tórax", "//CHUTE - TÓRAX"},
        {"Joelhada - Abdômen", "//JOELHADA - ABDÔMEN"}, {"Cotovelada - Tórax", "//COTOVELADA - TÓRAX"},
        {"Esquiva", "//ESQUIVA"}, {"Bloqueio", "//BLOQUEIO"}, {"Contra-Ataque", "//CONTRA-ATAQUE"},
        {"Agarrão", "//AGARRÃO"}, {"Imobilização", "//IMOBILIZAÇÃO"}, {"Derrubada", "//DERRUBADA"},
        {"Tiro na Cara", "//TIRO - NA CARA"}, {"Render", "/RENDER"}, {"Suplex", "//SUPLEX - QUEDA DE WRESTLING"},
        {"Furar Pneus", "//FURAR PNEUS"}, {"Jogar Granada", "//JOGAR GRANADA"},
        {"Micro Armas (Mini Uzi)", "//MICRO ARMAS - TIRO NO ROSTO (Mini Uzi)"},
        {"Mini Lança Míssel", "//MINI LANÇA MÍSSEL - EXPLODE (Míssel pequeno implantado no ombro)"},
        {"Tiro de 762", "//TIRO DE 762 - TÓRAX (Um tiro de calibre 762 vindo do braço esquerdo)"},
    }

    for i, cmd in ipairs(comandos) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 35)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.Text = cmd[1]
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 12
        btn.LayoutOrder = i
        btn.ZIndex = 2
        btn.Active = true
        btn.Parent = scroll
        corner(btn, 6)
        btn.MouseButton1Click:Connect(function()
            enviar(cmd[2])
            WindUI:Notify({Title = "Comando", Content = cmd[1], Duration = 2, Icon = "check"})
        end)
    end
end

-- ============================================================
-- CONFIGURAÇÃO DO WINDUI
-- ============================================================
local Window = WindUI:CreateWindow({
    Title = "STARK COMBAT HUB",
    Author = "Stark Industries RP",
    Icon = "rbxassetid://4483362458",
    Folder = "StarkHub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    HideSearchBar = false,
})

-- ==================== ABA: COMBATE ====================
local CombatTab = Window:Tab({ Title = "Combate", Icon = "swords" })
CombatTab:Section({ Title = "Interface Rápida" })
CombatTab:Button({
    Title = "Abrir Painel Flutuante",
    Desc = "Abre o painel de comandos na lateral.",
    Icon = "layout-panel-left",
    Callback = abrirPainelCombate
})

CombatTab:Section({ Title = "Ataques Básicos" })
for _, cmd in ipairs({
    {"Soco - Rosto", "//SOCO - ROSTO"}, {"Chute - Tórax", "//CHUTE - TÓRAX"},
    {"Joelhada - Abdômen", "//JOELHADA - ABDÔMEN"}, {"Cotovelada - Tórax", "//COTOVELADA - TÓRAX"},
}) do
    CombatTab:Button({ Title = cmd[1], Desc = cmd[2], Icon = "hand", Callback = function() enviar(cmd[2]) end })
end

CombatTab:Section({ Title = "Ações Táticas" })
for _, cmd in ipairs({
    {"Esquiva", "//ESQUIVA"}, {"Bloqueio", "//BLOQUEIO"}, {"Contra-Ataque", "//CONTRA-ATAQUE"},
    {"Agarrão", "//AGARRÃO"}, {"Imobilização", "//IMOBILIZAÇÃO"}, {"Derrubada", "//DERRUBADA"},
    {"Suplex (Wrestling)", "//SUPLEX - QUEDA DE WRESTLING"},
}) do
    CombatTab:Button({ Title = cmd[1], Desc = cmd[2], Icon = "shield", Callback = function() enviar(cmd[2]) end })
end

CombatTab:Section({ Title = "Armas e Utilidades" })
for _, cmd in ipairs({
    {"Tiro na Cara", "//TIRO - NA CARA"}, {"Render", "/RENDER"},
    {"Furar Pneus", "//FURAR PNEUS"}, {"Jogar Granada", "//JOGAR GRANADA"},
}) do
    CombatTab:Button({ Title = cmd[1], Desc = cmd[2], Icon = "crosshair", Callback = function() enviar(cmd[2]) end })
end

-- ==================== ABA: ARMADURA ====================
local ArmorTab = Window:Tab({ Title = "Armadura", Icon = "shield-check" })
ArmorTab:Section({ Title = "Sistemas de Visão" })
ArmorTab:Toggle({
    Title = "Ativar HUD da Armadura",
    Desc = "Liga a interface holográfica na tela.",
    Value = false,
    Callback = function(state) toggleHUD(state) end
})

ArmorTab:Section({ Title = "Armamento Integrado" })
for _, cmd in ipairs({
    {"Micro Armas (Mini Uzi)", "//MICRO ARMAS - TIRO NO ROSTO (Mini Uzi)"},
    {"Mini Lança Míssel", "//MINI LANÇA MÍSSEL - EXPLODE (Míssel pequeno implantado no ombro)"},
    {"Tiro de 762", "//TIRO DE 762 - TÓRAX (Um tiro de calibre 762 vindo do braço esquerdo)"},
}) do
    ArmorTab:Button({ Title = cmd[1], Desc = cmd[2], Icon = "rocket", Callback = function() enviar(cmd[2]) end })
end

-- ==================== ABA: SISTEMAS ====================
local SystemTab = Window:Tab({ Title = "Sistemas", Icon = "cpu" })
SystemTab:Section({ Title = "Visão Tática" })
SystemTab:Toggle({
    Title = "Ativar ESP (Inimigos)",
    Desc = "Destaca jogadores e mostra a distância.",
    Value = false,
    Callback = function(state) toggleESP(state) end
})

SystemTab:Section({ Title = "Voo (Iron Man)" })
SystemTab:Button({
    Title = "Ativar/Desativar Voo",
    Desc = "Alterna o modo de voo (O botão também está na tela).",
    Icon = "plane",
    Callback = function()
        if flyAtivo then desativarFly() else ativarFly() end
    end
})

SystemTab:Section({ Title = "Informações" })
SystemTab:Paragraph({
    Title = "Stark Combat Hub",
    Desc = "Interface de RP completa com voo, HUD e ESP.\nVersão: 5.2 (HUD Ajustado)\nDesign baseado no Homem de Ferro."
})

WindUI:Notify({
    Title = "STARK ONLINE",
    Content = "HUD ajustado e botões reposicionados.",
    Duration = 6,
    Icon = "check-circle"
})
