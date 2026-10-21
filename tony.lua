-- ============================================================
-- STARK COMBAT HUB — WINDUI EDITION (MOBILE CLICK FIX 2)
-- ============================================================

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local CYAN = Color3.fromRGB(0, 200, 255)
local WHITE = Color3.fromRGB(235, 245, 255)
local BG = Color3.fromRGB(10, 16, 25)

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end

-- ============================================================
-- SISTEMA DE CHAT (DUPLO)
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
-- HUD DA ARMADURA (A.R.I.A. STYLE)
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

    -- Vinheta
    local vignette = Instance.new("Frame")
    vignette.Size = UDim2.new(1,0,1,0)
    vignette.BackgroundTransparency = 1
    vignette.Parent = armorGui
    for _, pos in ipairs({
        {UDim2.new(0,0,0,0), UDim2.new(0,400,0,400), 0},
        {UDim2.new(1,-400,0,0), UDim2.new(0,400,0,400), 90},
        {UDim2.new(0,0,1,-400), UDim2.new(0,400,0,400), 270},
        {UDim2.new(1,-400,1,-400), UDim2.new(0,400,0,400), 180},
    }) do
        local f = Instance.new("Frame")
        f.Size = pos[2]
        f.Position = pos[1]
        f.BackgroundColor3 = Color3.fromRGB(0,0,0)
        f.BackgroundTransparency = 0.3
        f.BorderSizePixel = 0
        f.ZIndex = 1
        f.Parent = vignette
        local grad = Instance.new("UIGradient")
        grad.Rotation = pos[3]
        grad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.2),
            NumberSequenceKeypoint.new(1, 1),
        })
        grad.Parent = f
    end

    -- Linhas de Scan
    local scanContainer = Instance.new("Frame")
    scanContainer.Size = UDim2.new(1,0,1,0)
    scanContainer.BackgroundTransparency = 1
    scanContainer.ZIndex = 2
    scanContainer.Parent = armorGui
    for i = 0, 40 do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1,0,0,1)
        line.Position = UDim2.new(0,0,i/40,0)
        line.BackgroundColor3 = CYAN
        line.BackgroundTransparency = 0.92
        line.BorderSizePixel = 0
        line.ZIndex = 2
        line.Parent = scanContainer
    end

    -- Brackets (Cantos)
    local bracketSize = 80
    local bracketThick = 3
    for _, corner in ipairs({
        {UDim2.new(0,20,0,20), 1, 1},
        {UDim2.new(1,-20-bracketSize,0,20), 1, -1},
        {UDim2.new(0,20,1,-20-bracketSize), -1, 1},
        {UDim2.new(1,-20-bracketSize,1,-20-bracketSize), -1, -1},
    }) do
        local container = Instance.new("Frame")
        container.Size = UDim2.new(0, bracketSize, 0, bracketSize)
        container.Position = corner[1]
        container.BackgroundTransparency = 1
        container.ZIndex = 3
        container.Parent = armorGui
        local h = Instance.new("Frame")
        h.Size = UDim2.new(corner[2], 0, 0, bracketThick)
        h.Position = UDim2.new(corner[2] == 1 and 0 or 1, 0, corner[3] == 1 and 0 or 1, 0)
        h.BackgroundColor3 = CYAN
        h.BorderSizePixel = 0
        h.ZIndex = 3
        h.Parent = container
        local v = Instance.new("Frame")
        v.Size = UDim2.new(0, bracketThick, corner[3], 0)
        v.Position = UDim2.new(corner[2] == 1 and 0 or 1, 0, corner[3] == 1 and 0 or 1, 0)
        v.BackgroundColor3 = CYAN
        v.BorderSizePixel = 0
        v.ZIndex = 3
        v.Parent = container
    end

    -- Retículo Central
    local reticle = Instance.new("Frame")
    reticle.Size = UDim2.new(0, 160, 0, 160)
    reticle.Position = UDim2.new(0.5, -80, 0.5, -80)
    reticle.BackgroundTransparency = 1
    reticle.ZIndex = 5
    reticle.Parent = armorGui
    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(1,0,1,0)
    circle.BackgroundTransparency = 1
    circle.ZIndex = 6
    circle.Parent = reticle
    local cStroke = Instance.new("UIStroke")
    cStroke.Color = CYAN
    cStroke.Thickness = 1
    cStroke.Transparency = 0.4
    cStroke.Parent = circle
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1,0)
    cCorner.Parent = circle
    for _, dim in ipairs({
        {UDim2.new(0,80,0,1), UDim2.new(0.5,-40,0.5,0)},
        {UDim2.new(0,1,0,80), UDim2.new(0.5,0,0.5,-40)},
    }) do
        local bar = Instance.new("Frame")
        bar.Size = dim[1]
        bar.Position = dim[2]
        bar.BackgroundColor3 = CYAN
        bar.BackgroundTransparency = 0.3
        bar.BorderSizePixel = 0
        bar.ZIndex = 6
        bar.Parent = reticle
    end

    -- Painel Esquerdo
    local leftPanel = Instance.new("Frame")
    leftPanel.Size = UDim2.new(0, 220, 0, 140)
    leftPanel.Position = UDim2.new(0, 40, 0.5, -70)
    leftPanel.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
    leftPanel.BackgroundTransparency = 0.6
    leftPanel.BorderSizePixel = 0
    leftPanel.ZIndex = 5
    leftPanel.Parent = armorGui
    local lpStroke = Instance.new("UIStroke")
    lpStroke.Color = CYAN
    lpStroke.Thickness = 1
    lpStroke.Transparency = 0.3
    lpStroke.Parent = leftPanel
    local leftTitle = Instance.new("TextLabel")
    leftTitle.Size = UDim2.new(1,-10,0,20)
    leftTitle.Position = UDim2.new(0,5,0,5)
    leftTitle.BackgroundTransparency = 1
    leftTitle.Text = "» SUIT STATUS"
    leftTitle.TextColor3 = CYAN
    leftTitle.TextXAlignment = Enum.TextXAlignment.Left
    leftTitle.Font = Enum.Font.Code
    leftTitle.TextSize = 12
    leftTitle.ZIndex = 6
    leftTitle.Parent = leftPanel
    local leftInfo = Instance.new("TextLabel")
    leftInfo.Name = "Info"
    leftInfo.Size = UDim2.new(1,-10,1,-30)
    leftInfo.Position = UDim2.new(0,5,0,25)
    leftInfo.BackgroundTransparency = 1
    leftInfo.TextColor3 = CYAN
    leftInfo.TextXAlignment = Enum.TextXAlignment.Left
    leftInfo.TextYAlignment = Enum.TextYAlignment.Top
    leftInfo.Font = Enum.Font.Code
    leftInfo.TextSize = 11
    leftInfo.ZIndex = 6
    leftInfo.Parent = leftPanel

    -- Painel Direito
    local rightPanel = Instance.new("Frame")
    rightPanel.Size = UDim2.new(0, 220, 0, 140)
    rightPanel.Position = UDim2.new(1, -260, 0.5, -70)
    rightPanel.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
    rightPanel.BackgroundTransparency = 0.6
    rightPanel.BorderSizePixel = 0
    rightPanel.ZIndex = 5
    rightPanel.Parent = armorGui
    local rpStroke = Instance.new("UIStroke")
    rpStroke.Color = CYAN
    rpStroke.Thickness = 1
    rpStroke.Transparency = 0.3
    rpStroke.Parent = rightPanel
    local rightTitle = Instance.new("TextLabel")
    rightTitle.Size = UDim2.new(1,-10,0,20)
    rightTitle.Position = UDim2.new(0,5,0,5)
    rightTitle.BackgroundTransparency = 1
    rightTitle.Text = "» TARGETING"
    rightTitle.TextColor3 = CYAN
    rightTitle.TextXAlignment = Enum.TextXAlignment.Left
    rightTitle.Font = Enum.Font.Code
    rightTitle.TextSize = 12
    rightTitle.ZIndex = 6
    rightTitle.Parent = rightPanel
    local rightInfo = Instance.new("TextLabel")
    rightInfo.Name = "Info"
    rightInfo.Size = UDim2.new(1,-10,1,-30)
    rightInfo.Position = UDim2.new(0,5,0,25)
    rightInfo.BackgroundTransparency = 1
    rightInfo.TextColor3 = CYAN
    rightInfo.TextXAlignment = Enum.TextXAlignment.Left
    rightInfo.TextYAlignment = Enum.TextYAlignment.Top
    rightInfo.Font = Enum.Font.Code
    rightInfo.TextSize = 11
    rightInfo.ZIndex = 6
    rightInfo.Parent = rightPanel

    -- Barras
    local topBar = Instance.new("TextLabel")
    topBar.Name = "TopBar"
    topBar.Size = UDim2.new(0, 500, 0, 26)
    topBar.Position = UDim2.new(0.5, -250, 0, 20)
    topBar.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
    topBar.BackgroundTransparency = 0.5
    topBar.BorderSizePixel = 0
    topBar.Text = "A.R.I.A. // MARK VII // ONLINE"
    topBar.TextColor3 = CYAN
    topBar.Font = Enum.Font.Code
    topBar.TextSize = 13
    topBar.ZIndex = 6
    topBar.Parent = armorGui

    local bottomBar = Instance.new("TextLabel")
    bottomBar.Name = "BottomBar"
    bottomBar.Size = UDim2.new(0, 500, 0, 26)
    bottomBar.Position = UDim2.new(0.5, -250, 1, -46)
    bottomBar.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
    bottomBar.BackgroundTransparency = 0.5
    bottomBar.BorderSizePixel = 0
    bottomBar.TextColor3 = CYAN
    bottomBar.Font = Enum.Font.Code
    bottomBar.TextSize = 12
    bottomBar.ZIndex = 6
    bottomBar.Parent = armorGui

    -- Atualização
    task.spawn(function()
        while armorGui and armorGui.Parent do
            task.wait(0.5)
            if armorGui and armorGui.Parent then
                local char = player.Character
                local h = char and char:FindFirstChildOfClass("Humanoid")
                if h and leftInfo and leftInfo.Parent then
                    leftInfo.Text = string.format(
                        "PWR: %d%%\nHP: %d%%\nWALK: %d u/s\nPWR-OUT: NOMINAL",
                        math.random(90, 100),
                        math.floor(h.Health / h.MaxHealth * 100),
                        math.floor(h.WalkSpeed)
                    )
                end
                if rightInfo and rightInfo.Parent then
                    rightInfo.Text = string.format(
                        "SCAN: %s\nTARGETS: %d\nRANGE: %dm",
                        scanAtivo and "ACTIVE" or "IDLE",
                        scanAtivo and (#Players:GetPlayers() - 1) or 0,
                        40
                    )
                end
                if bottomBar and bottomBar.Parent then
                    local t = os.date("*t")
                    bottomBar.Text = string.format("MARK VII | %02d:%02d:%02d | STARK INDUSTRIES", t.hour, t.min, t.sec)
                end
            end
        end
    end)

    -- Rotação
    task.spawn(function()
        local angle = 0
        while armorGui and armorGui.Parent and reticle and reticle.Parent do
            task.wait(0.05)
            angle = (angle + 1) % 360
            circle.Rotation = angle
        end
    end)
end

-- ============================================================
-- PAINEL DE COMBATE FLUTUANTE (FIX MOBILE CLIQUE)
-- ============================================================
local function abrirPainelCombate()
    -- Destrói o antigo se já existir para evitar sobreposição
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
    main.Active = false -- Importante: o fundo não engole o toque do botão
    main.Parent = gui
    corner(main, 10)

    -- Barra de Título
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 38)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleBar.Active = false -- Importante: não engole o toque
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

    -- Lógica manual de Drag (Arrastar) sem Active=true
    local dragging = false
    local dragInput, dragStart, startPos

    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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

    -- Botão de Fechar (ZIndex Máximo e Active=true para garantir o toque)
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
    
    -- Função de fechar robusta (suporta mouse e touch)
    local function fecharPainel()
        gui:Destroy()
    end

    closeBtn.MouseButton1Click:Connect(fecharPainel)
    closeBtn.Activated:Connect(fecharPainel)

    -- Botões de Comando
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
        {"Soco - Rosto", "//SOCO - ROSTO"},
        {"Chute - Tórax", "//CHUTE - TÓRAX"},
        {"Joelhada - Abdômen", "//JOELHADA - ABDÔMEN"},
        {"Cotovelada - Tórax", "//COTOVELADA - TÓRAX"},
        {"Esquiva", "//ESQUIVA"},
        {"Bloqueio", "//BLOQUEIO"},
        {"Contra-Ataque", "//CONTRA-ATAQUE"},
        {"Agarrão", "//AGARRÃO"},
        {"Imobilização", "//IMOBILIZAÇÃO"},
        {"Derrubada", "//DERRUBADA"},
        {"Tiro na Cara", "//TIRO - NA CARA"},
        {"Render", "/RENDER"},
        {"Suplex", "//SUPLEX - QUEDA DE WRESTLING"},
        {"Furar Pneus", "//FURAR PNEUS"},
        {"Jogar Granada", "//JOGAR GRANADA"},
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
            -- Feedback visual
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
    Desc = "Abre o painel estilo DRNL na lateral da tela.",
    Icon = "layout-panel-left",
    Callback = abrirPainelCombate
})

CombatTab:Section({ Title = "Ataques Básicos" })
local basicos = {
    {"Soco - Rosto", "//SOCO - ROSTO"},
    {"Chute - Tórax", "//CHUTE - TÓRAX"},
    {"Joelhada - Abdômen", "//JOELHADA - ABDÔMEN"},
    {"Cotovelada - Tórax", "//COTOVELADA - TÓRAX"},
}
for _, cmd in ipairs(basicos) do
    CombatTab:Button({
        Title = cmd[1],
        Desc = cmd[2],
        Icon = "hand",
        Callback = function() enviar(cmd[2]) end
    })
end

CombatTab:Section({ Title = "Ações Táticas" })
local taticas = {
    {"Esquiva", "//ESQUIVA"},
    {"Bloqueio", "//BLOQUEIO"},
    {"Contra-Ataque", "//CONTRA-ATAQUE"},
    {"Agarrão", "//AGARRÃO"},
    {"Imobilização", "//IMOBILIZAÇÃO"},
    {"Derrubada", "//DERRUBADA"},
    {"Suplex (Wrestling)", "//SUPLEX - QUEDA DE WRESTLING"},
}
for _, cmd in ipairs(taticas) do
    CombatTab:Button({
        Title = cmd[1],
        Desc = cmd[2],
        Icon = "shield",
        Callback = function() enviar(cmd[2]) end
    })
end

CombatTab:Section({ Title = "Armas e Utilidades" })
local armas = {
    {"Tiro na Cara", "//TIRO - NA CARA"},
    {"Render", "/RENDER"},
    {"Furar Pneus", "//FURAR PNEUS"},
    {"Jogar Granada", "//JOGAR GRANADA"},
}
for _, cmd in ipairs(armas) do
    CombatTab:Button({
        Title = cmd[1],
        Desc = cmd[2],
        Icon = "crosshair",
        Callback = function() enviar(cmd[2]) end
    })
end

-- ==================== ABA: ARMADURA ====================
local ArmorTab = Window:Tab({ Title = "Armadura", Icon = "shield-check" })

ArmorTab:Section({ Title = "Sistemas de Visão" })
ArmorTab:Toggle({
    Title = "Ativar HUD da Armadura (A.R.I.A.)",
    Desc = "Liga a interface tática imersiva na tela.",
    Value = false,
    Callback = function(state)
        toggleHUD(state)
    end
})

ArmorTab:Section({ Title = "Armamento Integrado" })
local armorCmds = {
    {"Micro Armas (Mini Uzi)", "//MICRO ARMAS - TIRO NO ROSTO (Mini Uzi)"},
    {"Mini Lança Míssel", "//MINI LANÇA MÍSSEL - EXPLODE (Míssel pequeno implantado no ombro)"},
    {"Tiro de 762", "//TIRO DE 762 - TÓRAX (Um tiro de calibre 762 vindo do braço esquerdo)"},
}
for _, cmd in ipairs(armorCmds) do
    ArmorTab:Button({
        Title = cmd[1],
        Desc = cmd[2],
        Icon = "rocket",
        Callback = function() enviar(cmd[2]) end
    })
end

-- ==================== ABA: SISTEMAS ====================
local SystemTab = Window:Tab({ Title = "Sistemas", Icon = "cpu" })

SystemTab:Section({ Title = "Visão Tática" })
SystemTab:Toggle({
    Title = "Ativar ESP (Inimigos)",
    Desc = "Destaca jogadores e mostra a distância.",
    Value = false,
    Callback = function(state)
        toggleESP(state)
    end
})

SystemTab:Section({ Title = "Informações" })
SystemTab:Paragraph({
    Title = "Stark Combat Hub",
    Desc = "Interface de RP desenvolvida para máxima imersão.\nVersão: 4.3 (Mobile Overlap Fix)\nDesign baseado no Homem de Ferro."
})

-- Boas vindas
WindUI:Notify({
    Title = "STARK HUB ONLINE",
    Content = "Bem-vindo, Sr. Stark.",
    Duration = 6,
    Icon = "check-circle"
})
