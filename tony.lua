-- ============================================================
-- A.R.I.A. v2 + VOO HOMEM DE FERRO (MOBILE INTEGRADO)
-- ============================================================

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

-- ============================================================
-- CONFIG
-- ============================================================
local BASE_URL = ""
local OLLAMA_URL = ""
local TTS_URL = ""

local COR_ARIA   = Color3.fromRGB(0, 200, 255)
local COR_ALERTA = Color3.fromRGB(255, 60, 60)
local RAIO_ALERTA = 40
local VOZ_ATIVA = true

local VELOCIDADE         = 80
local VELOCIDADE_BOOST   = 170
local SUAVIDADE          = 0.18
local FORCA_VERTICAL     = 1.3
local COR_PROPULSOR      = Color3.fromRGB(0, 180, 255)
local COR_BOTAO          = Color3.fromRGB(0, 40, 70)
local INCLINACAO_NORMAL  = math.rad(-20)
local INCLINACAO_BOOST   = math.rad(-80)
local VELOCIDADE_INCLIN  = 0.10

local SYSTEM_PROMPT = [[Você é A.R.I.A. — Advanced Robotic Intelligence Assistant.
IA pessoal de Tony Stark. Sarcástica, afiada, leal — estilo FRIDAY/JARVIS.
Chama o usuário de "Chefe" ou "Sr. Stark". Respostas curtas (máx 2 frases).
Usa termos: protocolos, varredura, sensores, banco de dados.
Nunca quebra o personagem. Sempre responde em português.]]

-- ============================================================
-- VARIÁVEIS DOS BOTÕES DE FLY (declaradas ANTES de serem usadas!)
-- ============================================================
local btnFly, btnBoost, flyStroke, boostStroke, statusFlyLbl, statusFlyStroke

-- ============================================================
-- ESTADO
-- ============================================================
local historico = {}
local scanAtivo = false
local alertaAtivo = false
local espInstancias = {}
local jogadoresNaArea = {}
local modoArmadura = false
local armorGui

local flyAtivo = false
local boostAtivo = false
local inclinacaoAtual = 0
local flyBV, flyBG, flyParticles, flyLight, flyTrail
local conexaoRender

-- ============================================================
-- REQUEST
-- ============================================================
local function getRequest()
    return (syn and syn.request) or (http and http.request)
        or (fluxus and fluxus.request) or request or http_request
end
local requestFunc = getRequest()

local function atualizarURLs()
    if BASE_URL ~= "" then
        OLLAMA_URL = BASE_URL .. "/v1/chat/completions"
        TTS_URL = BASE_URL .. "/speak"
    end
end

-- ============================================================
-- VOZ
-- ============================================================
local function falar(texto)
    if not VOZ_ATIVA or not requestFunc or not texto or texto == "" or TTS_URL == "" then return end
    task.spawn(function()
        pcall(function()
            requestFunc({
                Url = TTS_URL, Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({ text = texto })
            })
        end)
    end)
end

-- ============================================================
-- IA
-- ============================================================
local function perguntarARIA(msg)
    if not requestFunc then return "Erro: executor sem HTTP, Chefe." end
    if OLLAMA_URL == "" then return "Configure a URL primeiro, Chefe." end

    local mensagens = { { role = "system", content = SYSTEM_PROMPT } }
    for _, m in ipairs(historico) do
        table.insert(mensagens, {
            role = (m.role == "Chefe") and "user" or "assistant",
            content = m.content
        })
    end
    table.insert(mensagens, { role = "user", content = msg })

    local body = HttpService:JSONEncode({
        messages = mensagens, temperature = 0.85, max_tokens = 100
    })

    local ok, resp = pcall(function()
        return requestFunc({
            Url = OLLAMA_URL, Method = "POST",
            Headers = { ["Content-Type"] = "application/json" },
            Body = body
        })
    end)

    if ok and resp and resp.StatusCode == 200 then
        local d = HttpService:JSONDecode(resp.Body)
        local t = d.choices and d.choices[1] and d.choices[1].message.content or "..."
        return t:gsub("\n", " "):gsub("%s+", " "):sub(1, 220)
    end
    return "Comunicação offline, Chefe."
end

-- ============================================================
-- SCAN ESP
-- ============================================================
local function limparESP(j)
    if espInstancias[j] then
        if espInstancias[j].highlight then espInstancias[j].highlight:Destroy() end
        if espInstancias[j].billboard then espInstancias[j].billboard:Destroy() end
        espInstancias[j] = nil
    end
end

local function aplicarESP(j)
    if j == LocalPlayer then return end
    limparESP(j)
    local char = j.Character
    if not char then return end
    local hl = Instance.new("Highlight")
    hl.FillColor = COR_ARIA
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
        lbl.TextColor3 = COR_ARIA
        lbl.TextStrokeTransparency = 0
        lbl.Font = Enum.Font.Code
        lbl.TextScaled = true
        lbl.Text = j.Name .. " [--m]"
        lbl.Parent = bb
    end
    espInstancias[j] = { highlight = hl, billboard = bb, label = lbl }
end

local function ligarScan()
    scanAtivo = true
    for _, p in ipairs(Players:GetPlayers()) do aplicarESP(p) end
end

local function desligarScan()
    scanAtivo = false
    for j,_ in pairs(espInstancias) do limparESP(j) end
end

RunService.RenderStepped:Connect(function()
    if not scanAtivo then return end
    local ch = LocalPlayer.Character
    local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
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

-- ============================================================
-- AVISOS
-- ============================================================
local function mostrarAviso(texto, cor)
    local sg = Instance.new("ScreenGui")
    sg.ResetOnSpawn = false
    sg.Parent = (gethui and gethui()) or CoreGui
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 380, 0, 60)
    f.Position = UDim2.new(0.5, -190, 0, -70)
    f.BackgroundColor3 = Color3.fromRGB(15,15,20)
    f.BorderSizePixel = 0
    f.Parent = sg
    local s = Instance.new("UIStroke")
    s.Color = cor or COR_ALERTA
    s.Thickness = 2
    s.Parent = f
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1,-20,1,0)
    l.Position = UDim2.new(0,10,0,0)
    l.BackgroundTransparency = 1
    l.TextColor3 = cor or COR_ALERTA
    l.Font = Enum.Font.Code
    l.TextSize = 15
    l.TextWrapped = true
    l.Text = texto
    l.Parent = f
    f:TweenPosition(UDim2.new(0.5,-190,0,20), "Out", "Quad", 0.4)
    task.delay(4, function()
        f:TweenPosition(UDim2.new(0.5,-190,0,-70), "In", "Quad", 0.4)
        task.wait(0.5); sg:Destroy()
    end)
end

task.spawn(function()
    while true do
        task.wait(1)
        if alertaAtivo then
            local ch = LocalPlayer.Character
            local hrp = ch and ch:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, j in ipairs(Players:GetPlayers()) do
                    if j ~= LocalPlayer and j.Character then
                        local h2 = j.Character:FindFirstChild("HumanoidRootPart")
                        if h2 then
                            local d = (h2.Position - hrp.Position).Magnitude
                            if d <= RAIO_ALERTA and not jogadoresNaArea[j] then
                                jogadoresNaArea[j] = true
                                mostrarAviso("⚠ A.R.I.A: " .. j.Name .. " entrou no perímetro (" .. math.floor(d) .. "m)")
                                falar("Atenção Chefe. " .. j.Name .. " entrou no perímetro.")
                            elseif d > RAIO_ALERTA + 15 then
                                jogadoresNaArea[j] = nil
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- ============================================================
-- MODO ARMADURA
-- ============================================================
local function criarHUDarmadura()
    if armorGui then armorGui:Destroy() end
    armorGui = Instance.new("ScreenGui")
    armorGui.Name = "ARIA_ArmorHUD"
    armorGui.ResetOnSpawn = false
    armorGui.IgnoreGuiInset = true
    armorGui.DisplayOrder = 999
    armorGui.Parent = (gethui and gethui()) or CoreGui

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

    local scanContainer = Instance.new("Frame")
    scanContainer.Size = UDim2.new(1,0,1,0)
    scanContainer.BackgroundTransparency = 1
    scanContainer.ZIndex = 2
    scanContainer.Parent = armorGui
    for i = 0, 40 do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(1,0,0,1)
        line.Position = UDim2.new(0,0,i/40,0)
        line.BackgroundColor3 = COR_ARIA
        line.BackgroundTransparency = 0.92
        line.BorderSizePixel = 0
        line.ZIndex = 2
        line.Parent = scanContainer
    end

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
        container.ZIndex = 5
        container.Parent = armorGui
        local h = Instance.new("Frame")
        h.Size = UDim2.new(0, bracketSize, 0, bracketThick)
        h.Position = corner[2] == 1 and UDim2.new(0,0,0,0) or UDim2.new(0,0,1,-bracketThick)
        h.BackgroundColor3 = COR_ARIA
        h.BorderSizePixel = 0
        h.ZIndex = 5
        h.Parent = container
        local v = Instance.new("Frame")
        v.Size = UDim2.new(0, bracketThick, 0, bracketSize)
        v.Position = corner[3] == 1 and UDim2.new(0,0,0,0) or UDim2.new(1,-bracketThick,0,0)
        v.BackgroundColor3 = COR_ARIA
        v.BorderSizePixel = 0
        v.ZIndex = 5
        v.Parent = container
    end

    local reticle = Instance.new("Frame")
    reticle.Size = UDim2.new(0, 200, 0, 200)
    reticle.Position = UDim2.new(0.5, -100, 0.5, -100)
    reticle.BackgroundTransparency = 1
    reticle.ZIndex = 6
    reticle.Parent = armorGui

    local circle = Instance.new("Frame")
    circle.Size = UDim2.new(1,0,1,0)
    circle.BackgroundTransparency = 1
    circle.ZIndex = 6
    circle.Parent = reticle
    local cStroke = Instance.new("UIStroke")
    cStroke.Color = COR_ARIA
    cStroke.Thickness = 1
    cStroke.Transparency = 0.4
    cStroke.Parent = circle
    local cCorner = Instance.new("UICorner")
    cCorner.CornerRadius = UDim.new(1,0)
    cCorner.Parent = circle

    for _, dim in ipairs({{UDim2.new(0,80,0,1), UDim2.new(0.5,-40,0.5,0)}, {UDim2.new(0,1,0,80), UDim2.new(0.5,0,0.5,-40)}}) do
        local bar = Instance.new("Frame")
        bar.Size = dim[1]
        bar.Position = dim[2]
        bar.BackgroundColor3 = COR_ARIA
        bar.BackgroundTransparency = 0.3
        bar.BorderSizePixel = 0
        bar.ZIndex = 6
        bar.Parent = reticle
    end

    local leftPanel = Instance.new("Frame")
    leftPanel.Size = UDim2.new(0, 220, 0, 140)
    leftPanel.Position = UDim2.new(0, 40, 0.5, -70)
    leftPanel.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
    leftPanel.BackgroundTransparency = 0.6
    leftPanel.BorderSizePixel = 0
    leftPanel.ZIndex = 5
    leftPanel.Parent = armorGui
    local lpStroke = Instance.new("UIStroke")
    lpStroke.Color = COR_ARIA
    lpStroke.Thickness = 1
    lpStroke.Transparency = 0.3
    lpStroke.Parent = leftPanel
    local leftTitle = Instance.new("TextLabel")
    leftTitle.Size = UDim2.new(1,-10,0,20)
    leftTitle.Position = UDim2.new(0,5,0,5)
    leftTitle.BackgroundTransparency = 1
    leftTitle.Text = "» SUIT STATUS"
    leftTitle.TextColor3 = COR_ARIA
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
    leftInfo.Text = "PWR: 98%\nHP: 100%\nTHR: 87%\nPWR-OUT: NOMINAL"
    leftInfo.TextColor3 = COR_ARIA
    leftInfo.TextXAlignment = Enum.TextXAlignment.Left
    leftInfo.TextYAlignment = Enum.TextYAlignment.Top
    leftInfo.Font = Enum.Font.Code
    leftInfo.TextSize = 11
    leftInfo.ZIndex = 6
    leftInfo.Parent = leftPanel

    local rightPanel = Instance.new("Frame")
    rightPanel.Size = UDim2.new(0, 220, 0, 140)
    rightPanel.Position = UDim2.new(1, -260, 0.5, -70)
    rightPanel.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
    rightPanel.BackgroundTransparency = 0.6
    rightPanel.BorderSizePixel = 0
    rightPanel.ZIndex = 5
    rightPanel.Parent = armorGui
    local rpStroke = Instance.new("UIStroke")
    rpStroke.Color = COR_ARIA
    rpStroke.Thickness = 1
    rpStroke.Transparency = 0.3
    rpStroke.Parent = rightPanel
    local rightTitle = Instance.new("TextLabel")
    rightTitle.Size = UDim2.new(1,-10,0,20)
    rightTitle.Position = UDim2.new(0,5,0,5)
    rightTitle.BackgroundTransparency = 1
    rightTitle.Text = "» TARGETING"
    rightTitle.TextColor3 = COR_ARIA
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
    rightInfo.Text = "SCAN: IDLE\nTARGETS: 0\nRANGE: 100m"
    rightInfo.TextColor3 = COR_ARIA
    rightInfo.TextXAlignment = Enum.TextXAlignment.Left
    rightInfo.TextYAlignment = Enum.TextYAlignment.Top
    rightInfo.Font = Enum.Font.Code
    rightInfo.TextSize = 11
    rightInfo.ZIndex = 6
    rightInfo.Parent = rightPanel

    local topBar = Instance.new("TextLabel")
    topBar.Size = UDim2.new(0, 500, 0, 26)
    topBar.Position = UDim2.new(0.5, -250, 0, 20)
    topBar.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
    topBar.BackgroundTransparency = 0.5
    topBar.BorderSizePixel = 0
    topBar.Text = "◤ A.R.I.A. — MARK VII ONLINE ◢"
    topBar.TextColor3 = COR_ARIA
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
    bottomBar.Text = ""
    bottomBar.TextColor3 = COR_ARIA
    bottomBar.Font = Enum.Font.Code
    bottomBar.TextSize = 12
    bottomBar.ZIndex = 6
    bottomBar.Parent = armorGui

    task.spawn(function()
        while armorGui and armorGui.Parent do
            task.wait(0.5)
            if armorGui and armorGui.Parent then
                local ch = LocalPlayer.Character
                local h = ch and ch:FindFirstChildOfClass("Humanoid")
                if h and leftInfo and leftInfo.Parent then
                    leftInfo.Text = string.format(
                        "PWR: %d%%\nHP: %d%%\nWALK: %d u/s\nPWR-OUT: NOMINAL",
                        math.random(90, 100), math.floor(h.Health/h.MaxHealth*100), math.floor(h.WalkSpeed)
                    )
                end
                if rightInfo and rightInfo.Parent then
                    rightInfo.Text = string.format(
                        "SCAN: %s\nTARGETS: %d\nRANGE: %dm",
                        scanAtivo and "ACTIVE" or "IDLE",
                        scanAtivo and (#Players:GetPlayers()-1) or 0,
                        RAIO_ALERTA
                    )
                end
                if bottomBar and bottomBar.Parent then
                    local t = os.date("*t")
                    bottomBar.Text = string.format("MARK VII  |  %02d:%02d:%02d  |  STARK INDUSTRIES",
                        t.hour, t.min, t.sec)
                end
            end
        end
    end)

    task.spawn(function()
        local angle = 0
        while armorGui and armorGui.Parent and reticle and reticle.Parent do
            task.wait(0.05)
            angle = (angle + 1) % 360
            circle.Rotation = angle
        end
    end)
end

local function ligarArmadura()
    modoArmadura = true
    criarHUDarmadura()
end

local function desligarArmadura()
    modoArmadura = false
    if armorGui then armorGui:Destroy(); armorGui = nil end
end

-- ============================================================
-- GUI PRINCIPAL
-- ============================================================
local guiParent = (gethui and gethui()) or CoreGui
local tela = Instance.new("ScreenGui")
tela.Name = "ARIA_UI"
tela.ResetOnSpawn = false
tela.Parent = guiParent

local painel = Instance.new("Frame")
painel.Size = UDim2.new(0, 460, 0, 420)
painel.Position = UDim2.new(0, 20, 0.5, -210)
painel.BackgroundColor3 = Color3.fromRGB(10, 12, 18)
painel.BackgroundTransparency = 0.08
painel.BorderSizePixel = 0
painel.Active = true
painel.Draggable = true
painel.Parent = tela

local sp = Instance.new("UIStroke")
sp.Color = COR_ARIA
sp.Thickness = 1.5
sp.Transparency = 0.3
sp.Parent = painel

local title = Instance.new("Frame")
title.Size = UDim2.new(1,0,0,34)
title.BackgroundColor3 = Color3.fromRGB(0, 30, 50)
title.BackgroundTransparency = 0.4
title.BorderSizePixel = 0
title.Parent = painel

local tl = Instance.new("TextLabel")
tl.Size = UDim2.new(1,-80,1,0)
tl.Position = UDim2.new(0,12,0,0)
tl.BackgroundTransparency = 1
tl.Text = "◤ A.R.I.A. — Advanced Robotic Intelligence Assistant"
tl.TextColor3 = COR_ARIA
tl.TextXAlignment = Enum.TextXAlignment.Left
tl.Font = Enum.Font.Code
tl.TextSize = 13
tl.Parent = title

local btnMin = Instance.new("TextButton")
btnMin.Size = UDim2.new(0,30,0,24)
btnMin.Position = UDim2.new(1,-66,0,5)
btnMin.BackgroundColor3 = Color3.fromRGB(0,100,140)
btnMin.BorderSizePixel = 0
btnMin.Text = "—"
btnMin.TextColor3 = Color3.new(1,1,1)
btnMin.Font = Enum.Font.Code
btnMin.TextSize = 18
btnMin.Parent = title

local btnFechar = Instance.new("TextButton")
btnFechar.Size = UDim2.new(0,30,0,24)
btnFechar.Position = UDim2.new(1,-34,0,5)
btnFechar.BackgroundColor3 = Color3.fromRGB(140,30,30)
btnFechar.BorderSizePixel = 0
btnFechar.Text = "×"
btnFechar.TextColor3 = Color3.new(1,1,1)
btnFechar.Font = Enum.Font.Code
btnFechar.TextSize = 18
btnFechar.Parent = title

local urlFrame = Instance.new("Frame")
urlFrame.Size = UDim2.new(1,-20,0,32)
urlFrame.Position = UDim2.new(0,10,0,40)
urlFrame.BackgroundColor3 = Color3.fromRGB(5,8,12)
urlFrame.BackgroundTransparency = 0.2
urlFrame.BorderSizePixel = 0
urlFrame.Parent = painel

local uStroke = Instance.new("UIStroke")
uStroke.Color = COR_ARIA
uStroke.Thickness = 1
uStroke.Transparency = 0.5
uStroke.Parent = urlFrame

local urlInput = Instance.new("TextBox")
urlInput.Size = UDim2.new(1,-120,1,0)
urlInput.Position = UDim2.new(0,8,0,0)
urlInput.BackgroundTransparency = 1
urlInput.Text = ""
urlInput.PlaceholderText = "Cole a URL do túnel (ex: https://xxx.lhr.life)"
urlInput.PlaceholderColor3 = Color3.fromRGB(100,130,150)
urlInput.TextColor3 = COR_ARIA
urlInput.Font = Enum.Font.Code
urlInput.TextSize = 12
urlInput.TextXAlignment = Enum.TextXAlignment.Left
urlInput.ClearTextOnFocus = false
urlInput.Parent = urlFrame

local btnConectar = Instance.new("TextButton")
btnConectar.Size = UDim2.new(0,100,1,-6)
btnConectar.Position = UDim2.new(1,-105,0,3)
btnConectar.BackgroundColor3 = Color3.fromRGB(0,120,80)
btnConectar.BorderSizePixel = 0
btnConectar.Text = "CONECTAR"
btnConectar.TextColor3 = Color3.new(1,1,1)
btnConectar.Font = Enum.Font.Code
btnConectar.TextSize = 12
btnConectar.Parent = urlFrame

local statusConexao = Instance.new("TextLabel")
statusConexao.Size = UDim2.new(1,-20,0,16)
statusConexao.Position = UDim2.new(0,10,0,74)
statusConexao.BackgroundTransparency = 1
statusConexao.Text = "● DESCONECTADO — cole a URL e clique CONECTAR"
statusConexao.TextColor3 = Color3.fromRGB(200,100,100)
statusConexao.TextXAlignment = Enum.TextXAlignment.Left
statusConexao.Font = Enum.Font.Code
statusConexao.TextSize = 11
statusConexao.Parent = painel

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-20,1,-200)
scroll.Position = UDim2.new(0,10,0,94)
scroll.BackgroundColor3 = Color3.fromRGB(5,8,12)
scroll.BackgroundTransparency = 0.3
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = COR_ARIA
scroll.Parent = painel

local lay = Instance.new("UIListLayout")
lay.Padding = UDim.new(0,6)
lay.SortOrder = Enum.SortOrder.LayoutOrder
lay.Parent = scroll

local pd = Instance.new("UIPadding")
pd.PaddingTop = UDim.new(0,6)
pd.PaddingLeft = UDim.new(0,6)
pd.PaddingRight = UDim.new(0,6)
pd.Parent = scroll

local function addMsg(autor, texto, cor)
    local m = Instance.new("TextLabel")
    m.Size = UDim2.new(1,-12,0,0)
    m.AutomaticSize = Enum.AutomaticSize.Y
    m.BackgroundTransparency = 1
    m.TextWrapped = true
    m.TextXAlignment = Enum.TextXAlignment.Left
    m.Font = Enum.Font.Code
    m.TextSize = 13
    m.TextColor3 = cor or Color3.new(1,1,1)
    m.Text = "[" .. autor .. "]: " .. texto
    m.LayoutOrder = #scroll:GetChildren()
    m.Parent = scroll
    task.wait()
    scroll.CanvasSize = UDim2.new(0,0,0, lay.AbsoluteContentSize.Y + 12)
    scroll.CanvasPosition = Vector2.new(0, scroll.CanvasSize.Y.Offset)
end

local input = Instance.new("TextBox")
input.Size = UDim2.new(1,-110,0,34)
input.Position = UDim2.new(0,10,1,-80)
input.BackgroundColor3 = Color3.fromRGB(5,8,12)
input.BackgroundTransparency = 0.2
input.BorderSizePixel = 0
input.Text = ""
input.PlaceholderText = "Digite um comando..."
input.PlaceholderColor3 = Color3.fromRGB(100,130,150)
input.TextColor3 = COR_ARIA
input.Font = Enum.Font.Code
input.TextSize = 13
input.TextXAlignment = Enum.TextXAlignment.Left
input.ClearTextOnFocus = false
input.Parent = painel

local sI = Instance.new("UIStroke")
sI.Color = COR_ARIA
sI.Thickness = 1
sI.Transparency = 0.5
sI.Parent = input

local pI = Instance.new("UIPadding")
pI.PaddingLeft = UDim.new(0,8)
pI.Parent = input

local btnEnv = Instance.new("TextButton")
btnEnv.Size = UDim2.new(0,90,0,34)
btnEnv.Position = UDim2.new(1,-100,1,-80)
btnEnv.BackgroundColor3 = Color3.fromRGB(0,100,140)
btnEnv.BorderSizePixel = 0
btnEnv.Text = "ENVIAR"
btnEnv.TextColor3 = Color3.new(1,1,1)
btnEnv.Font = Enum.Font.Code
btnEnv.TextSize = 13
btnEnv.Parent = painel

local statusBar = Instance.new("TextLabel")
statusBar.Size = UDim2.new(1,-20,0,22)
statusBar.Position = UDim2.new(0,10,1,-40)
statusBar.BackgroundColor3 = Color3.fromRGB(0,30,50)
statusBar.BackgroundTransparency = 0.5
statusBar.BorderSizePixel = 0
statusBar.Text = "● OFFLINE"
statusBar.TextColor3 = COR_ARIA
statusBar.TextXAlignment = Enum.TextXAlignment.Left
statusBar.Font = Enum.Font.Code
statusBar.TextSize = 11
statusBar.Parent = painel

local pS = Instance.new("UIPadding")
pS.PaddingLeft = UDim.new(0,8)
pS.Parent = statusBar

local bolinha = Instance.new("TextButton")
bolinha.Size = UDim2.new(0,56,0,56)
bolinha.Position = UDim2.new(0,30,0.5,-28)
bolinha.BackgroundColor3 = Color3.fromRGB(0,40,70)
bolinha.BorderSizePixel = 0
bolinha.Text = "◉"
bolinha.TextColor3 = COR_ARIA
bolinha.Font = Enum.Font.Code
bolinha.TextSize = 30
bolinha.Visible = false
bolinha.Active = true
bolinha.Draggable = true
bolinha.Parent = tela

local sB = Instance.new("UIStroke")
sB.Color = COR_ARIA
sB.Thickness = 2
sB.Parent = bolinha

local crn = Instance.new("UICorner")
crn.CornerRadius = UDim.new(1,0)
crn.Parent = bolinha

task.spawn(function()
    while bolinha.Parent do
        task.wait(0.05)
        if bolinha.Visible then
            local t = tick() % 2
            sB.Transparency = 0.4 + 0.4 * math.sin(t * math.pi)
        end
    end
end)


-- ============================================================
-- BOTÕES DE FLY (atribuição das variáveis declaradas no topo)
-- ============================================================
btnFly = Instance.new("TextButton")
btnFly.Size = UDim2.new(0, 70, 0, 70)
btnFly.Position = UDim2.new(1, -90, 1, -180)
btnFly.BackgroundColor3 = COR_BOTAO
btnFly.BorderSizePixel = 0
btnFly.Text = "FLY"
btnFly.TextColor3 = COR_PROPULSOR
btnFly.Font = Enum.Font.Code
btnFly.TextSize = 16
btnFly.AutoButtonColor = false
btnFly.Parent = tela

flyStroke = Instance.new("UIStroke")
flyStroke.Color = COR_PROPULSOR
flyStroke.Thickness = 2
flyStroke.Parent = btnFly

local flyCorner = Instance.new("UICorner")
flyCorner.CornerRadius = UDim.new(1, 0)
flyCorner.Parent = btnFly

btnBoost = Instance.new("TextButton")
btnBoost.Size = UDim2.new(0, 60, 0, 60)
btnBoost.Position = UDim2.new(1, -80, 1, -260)
btnBoost.BackgroundColor3 = COR_BOTAO
btnBoost.BorderSizePixel = 0
btnBoost.Text = "⚡"
btnBoost.TextColor3 = COR_PROPULSOR
btnBoost.Font = Enum.Font.Code
btnBoost.TextSize = 22
btnBoost.AutoButtonColor = false
btnBoost.Visible = false
btnBoost.Parent = tela

boostStroke = Instance.new("UIStroke")
boostStroke.Color = COR_PROPULSOR
boostStroke.Thickness = 1.5
boostStroke.Parent = btnBoost

local boostCorner = Instance.new("UICorner")
boostCorner.CornerRadius = UDim.new(1, 0)
boostCorner.Parent = btnBoost

statusFlyLbl = Instance.new("TextLabel")
statusFlyLbl.Size = UDim2.new(0, 160, 0, 26)
statusFlyLbl.Position = UDim2.new(1, -170, 1, -110)
statusFlyLbl.BackgroundColor3 = Color3.fromRGB(0, 20, 40)
statusFlyLbl.BackgroundTransparency = 0.3
statusFlyLbl.BorderSizePixel = 0
statusFlyLbl.Text = "⚡ OFFLINE"
statusFlyLbl.TextColor3 = COR_PROPULSOR
statusFlyLbl.Font = Enum.Font.Code
statusFlyLbl.TextSize = 13
statusFlyLbl.Parent = tela

statusFlyStroke = Instance.new("UIStroke")
statusFlyStroke.Color = COR_PROPULSOR
statusFlyStroke.Thickness = 1
statusFlyStroke.Transparency = 0.5
statusFlyStroke.Parent = statusFlyLbl

-- ============================================================
-- FUNÇÕES DO FLY (agora as variáveis existem!)
-- ============================================================
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
    local char = LocalPlayer.Character
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

    if btnBoost then btnBoost.Visible = true end
    if btnFly then
        btnFly.Text = "STOP"
        btnFly.TextColor3 = Color3.fromRGB(255, 100, 100)
    end
    if flyStroke then flyStroke.Color = Color3.fromRGB(255, 100, 100) end
    if statusFlyLbl then
        statusFlyLbl.Text = "⚡ FLY ON"
        statusFlyLbl.TextColor3 = Color3.fromRGB(100, 255, 150)
    end
    if statusFlyStroke then statusFlyStroke.Color = Color3.fromRGB(100, 255, 150) end

    conexaoRender = RunService.RenderStepped:Connect(function()
        local char2 = LocalPlayer.Character
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

    if conexaoRender then conexaoRender:Disconnect(); conexaoRender = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end

    local char = LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = false end
    limparEfeitosFly(hrp)

    if btnBoost then btnBoost.Visible = false end
    if btnFly then
        btnFly.Text = "FLY"
        btnFly.TextColor3 = COR_PROPULSOR
    end
    if flyStroke then flyStroke.Color = COR_PROPULSOR end
    if statusFlyLbl then
        statusFlyLbl.Text = "⚡ OFFLINE"
        statusFlyLbl.TextColor3 = COR_PROPULSOR
    end
    if statusFlyStroke then statusFlyStroke.Color = COR_PROPULSOR end

    boostAtivo = false
end


-- ============================================================
-- EVENTOS DOS BOTÕES
-- ============================================================
local function minimizar() painel.Visible = false; bolinha.Visible = true end
local function restaurar() painel.Visible = true; bolinha.Visible = false end

btnMin.MouseButton1Click:Connect(minimizar)
bolinha.MouseButton1Click:Connect(restaurar)
btnFechar.MouseButton1Click:Connect(function()
    tela:Destroy(); desligarScan(); desligarArmadura(); desativarFly()
end)

btnConectar.MouseButton1Click:Connect(function()
    local url = urlInput.Text:match("^%s*(.-)%s*$")
    if url == "" then
        statusConexao.Text = "⚠ Cole uma URL primeiro"
        statusConexao.TextColor3 = Color3.fromRGB(255,200,100)
        return
    end
    if not url:match("^https?://") then url = "https://" .. url end
    url = url:gsub("/$", "")
    BASE_URL = url
    atualizarURLs()

    statusConexao.Text = "⏳ Testando..."
    statusConexao.TextColor3 = Color3.fromRGB(200,200,100)

    task.spawn(function()
        local ok, resp = pcall(function()
            return requestFunc({
                Url = OLLAMA_URL, Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({
                    messages = {{role="user",content="ping"}},
                    max_tokens = 5
                })
            })
        end)
        if ok and resp then
            statusConexao.Text = "● CONECTADO"
            statusConexao.TextColor3 = Color3.fromRGB(100,255,150)
            addMsg("A.R.I.A", "Conexão estabelecida. Sistemas online, Chefe.", COR_ARIA)
            falar("Conexão estabelecida. Sistemas online.")
        else
            statusConexao.Text = "❌ Falha ao conectar. Verifique o túnel."
            statusConexao.TextColor3 = Color3.fromRGB(255,100,100)
        end
    end)
end)

btnFly.MouseButton1Click:Connect(function()
    if flyAtivo then desativarFly() else ativarFly() end
end)

btnBoost.MouseButton1Click:Connect(function()
    boostAtivo = not boostAtivo
    if boostAtivo then
        boostStroke.Color = Color3.fromRGB(255, 220, 100)
        btnBoost.TextColor3 = Color3.fromRGB(255, 220, 100)
        statusFlyLbl.Text = "⚡ BOOST"
        statusFlyLbl.TextColor3 = Color3.fromRGB(255, 220, 100)
    else
        boostStroke.Color = COR_PROPULSOR
        btnBoost.TextColor3 = COR_PROPULSOR
        statusFlyLbl.Text = "⚡ FLY ON"
        statusFlyLbl.TextColor3 = Color3.fromRGB(100, 255, 150)
    end
end)

-- ============================================================
-- STATUS BAR
-- ============================================================
local function atualizarBar()
    statusBar.Text = "● " .. (OLLAMA_URL ~= "" and "ONLINE" or "OFFLINE")
        .. " | Alvos: " .. (#Players:GetPlayers()-1)
        .. " | Scan: " .. (scanAtivo and "ON" or "OFF")
        .. " | Arm: " .. (modoArmadura and "ON" or "OFF")
        .. " | Fly: " .. (flyAtivo and "ON" or "OFF")
end
task.spawn(function()
    while statusBar.Parent do task.wait(1); pcall(atualizarBar) end
end)

-- ============================================================
-- COMANDOS
-- ============================================================
local function processarComando(t)
    local l = t:lower()
    if l == "scan aria" or l == "scan" then
        ligarScan()
        addMsg("A.R.I.A", "Varredura iniciada.", COR_ARIA)
        falar("Varredura iniciada.")
        return true
    elseif l == "desativar scan" or l == "scan off" then
        desligarScan()
        addMsg("A.R.I.A", "Varredura encerrada.", COR_ARIA)
        return true
    elseif l == "modo armadura" or l == "armadura" then
        if modoArmadura then desligarArmadura(); addMsg("A.R.I.A", "Armadura desativada.", COR_ARIA)
        else ligarArmadura(); addMsg("A.R.I.A", "Protocolo MARK VII ativado.", COR_ARIA); falar("Protocolo Mark Seven ativado.") end
        return true
    elseif l == "fly" or l == "voar" then
        if flyAtivo then desativarFly() else ativarFly() end
        return true
    elseif l == "status" then
        local ch = LocalPlayer.Character
        local h = ch and ch:FindFirstChildOfClass("Humanoid")
        if h then
            addMsg("A.R.I.A", string.format("▸ Vel: %d | HP: %d/%d\n▸ Scan: %s | Fly: %s",
                math.floor(h.WalkSpeed), math.floor(h.Health), math.floor(h.MaxHealth),
                scanAtivo and "ON" or "off", flyAtivo and "ON" or "off"), COR_ARIA)
        end
        return true
    elseif l == "alerta" then
        alertaAtivo = true
        addMsg("A.R.I.A", "Alerta ATIVO.", COR_ALERTA)
        return true
    elseif l == "desativar alerta" then
        alertaAtivo = false; jogadoresNaArea = {}
        addMsg("A.R.I.A", "Alerta desativado.", COR_ARIA)
        return true
    elseif l == "voz on" then
        VOZ_ATIVA = true; addMsg("A.R.I.A", "Voz ativada.", COR_ARIA); falar("Voz ativada.")
        return true
    elseif l == "voz off" then
        VOZ_ATIVA = false; addMsg("A.R.I.A", "Voz desligada.", COR_ARIA)
        return true
    elseif l == "help" or l == "ajuda" then
        addMsg("A.R.I.A", "scan aria | desativar scan | modo armadura | fly | status | alerta | voz on/off | limpar", COR_ARIA)
        return true
    elseif l == "limpar" then
        for _, c in ipairs(scroll:GetChildren()) do
            if c:IsA("TextLabel") then c:Destroy() end
        end
        scroll.CanvasSize = UDim2.new(0,0,0,0)
        return true
    end
    return false
end

local function enviar()
    local t = input.Text:match("^%s*(.-)%s*$")
    if t == "" then return end
    input.Text = ""
    addMsg("Chefe", t, Color3.fromRGB(220,220,220))
    if processarComando(t) then return end

    task.spawn(function()
        addMsg("A.R.I.A", "...", Color3.fromRGB(120,150,170))
        local r = perguntarARIA(t)
        local ultimo = scroll:GetChildren()[#scroll:GetChildren()]
        if ultimo and ultimo:IsA("TextLabel") and ultimo.Text == "[A.R.I.A]: ..." then
            ultimo:Destroy()
        end
        addMsg("A.R.I.A", r, COR_ARIA)
        falar(r)
        table.insert(historico, { role = "Chefe", content = t })
        table.insert(historico, { role = "A.R.I.A", content = r })
        if #historico > 10 then table.remove(historico, 1) end
    end)
end

btnEnv.MouseButton1Click:Connect(enviar)
input.FocusLost:Connect(function(e) if e then enviar() end end)

-- ============================================================
-- RESPAWN
-- ============================================================
LocalPlayer.CharacterAdded:Connect(function()
    if flyAtivo then
        flyAtivo = false
        task.wait(1)
        ativarFly()
    end
end)

-- ============================================================
-- INICIALIZAÇÃO
-- ============================================================
addMsg("A.R.I.A", "Sistemas em standby. Cole a URL do túnel e clique em CONECTAR.", COR_ARIA)
addMsg("A.R.I.A", "Digite 'help' para ver os comandos.", Color3.fromRGB(120,150,170))
atualizarBar()
print("✅ A.R.I.A. v2 + Fly integrado. Botão FLY no canto inferior direito.")
