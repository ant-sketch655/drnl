-- =====================================================================
-- CONDUÇÃO HUB - Simple GUI V2.6 Style
-- =====================================================================

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- =====================================================================
-- DADOS DOS SCRIPTS
-- =====================================================================
local scriptsData = {
    -- ==================== CONDUÇÃO ====================
    {category = "⚽️ ANT PULO E CONDUÇÃO ⚽️"},
    {name = "ANT PULO", url = "https://pastebin.com/raw/d2T3QxGt"},
    {name = "ANTI PULO ELIAS", url = "https://pastebin.com/raw/mgzrnsbr"},
    {name = "ZYCK ANTI PULO", url = "https://pastebin.com/raw/MCTcaHZq"},
    {name = "SOCCER DRIBBLE HUB ⚡️", url = "https://pastebin.com/raw/gwZKjbVM"},
    {name = "PASSE FORTE 🦵", url = "https://pastebin.com/raw/2Yw8Bv85"},
    {name = "CONDUÇÃO THEUS ⚽", url = "https://pastefy.app/7FAwfRUX/raw"},
    {name = "HENRIQUE DRIBLE ⚡", url = "https://pastebin.com/raw/wJKBdV8A"},

    -- ==================== Atravessar / Soccer Tool ====================
    {category = "🔥 Atravessar / Soccer Tool 🔥"},
    {name = "ANTI Atravessar Soccer Tool", url = "https://pastebin.com/raw/LYWJ6sfF"},
    {name = "ATRAVESSAR SIMPLES 🔥", url = "https://pastebin.com/raw/D15v30nW"},
    {name = "ATRAVESSAR THEUS 👻", url = "https://pastefy.app/7e1VxPgW/raw"},
    {name = "PJ Atravessa 🧧", url = "https://pastefy.app/CrhmqFtx/raw"},
    {name = "ATRAVESSAR V12 🟣", url = "https://pastebin.com/raw/GZn1L0PM"},
    {name = "Oliver Atravessador 🗡", url = "https://rawscripts.net/raw/Universal-Script-Script-de-atravessar-56285"},
    {name = "NOCLIP Injusto + Reach 900 studs 🔥", url = "https://pastebin.com/raw/hfrDcUm8"},
    {name = "ANTI BALL PEDRA + Atravessar ⚽", url = "https://pastebin.com/raw/Z7eZDEj8"},

    -- ==================== Defender / Goleiro ====================
    {category = "🧤 DEFENDER / GOLEIRO 🧤"},
    {name = "MURALHA HUB 🧱", url = "https://pastebin.com/raw/UxtmMHm1"},
    {name = "GOLEIRO HUB (Rayfield) 🧤", url = "https://pastefy.app/cogJvYif/raw"},
    {name = "Legendary Defender ⚔️", url = "https://pastebin.com/raw/s91y0AFs"},
    {name = "GK Hub (Goleiro Deitado) 🧤", url = "https://pastebin.com/raw/FaBkfBHr"},
    {name = "Yashin Ultra 🧤", url = "https://pastebin.com/raw/KmNHLYsb"},
    {name = "Puyol V3 ⚡️", url = "https://pastebin.com/raw/bMLRRKwG"},

    -- ==================== Reach / Bug / Glitch ====================
    {category = "🌑 REACH / BUG / GLITCH 🌑"},
    {name = "REACH THE VOID 🌑", url = "https://pastebin.com/raw/HyAUVhnP"},
    {name = "GHOST + Reach 👻", url = "https://pastebin.com/raw/1if0pn7x"},
    {name = "THEUS REACH V2 🦿", url = "https://pastebin.com/raw/pm4pyxm4"},
    {name = "REACH DO THEUS 🦿", url = "https://pastefy.app/tSYVNcwc/raw"},
    {name = "JVZ Bug ", url = "https://pastefy.app/hYyBJna/raw"},
    {name = "Bug do Reidorm 👑", url = "https://pastebin.com/raw/qtsDZHGu"},
    {name = "PEDRIZZ Bug ⚡️", url = "https://pastebin.com/raw/28LDYic2"},
    {name = "MTZIN Pro Max ⚡", url = "https://pastebin.com/raw/kCKEhh99"},
    {name = "LAG SWITCH 👣", url = "https://pastefy.app/zZo7yoUB/raw"},
    {name = "GLITCH INFINITY ♾️", url = "https://pastebin.com/raw/FpPh3UhN"},

    -- ==================== Otimização / GUI ====================
    {category = "🚀 OTIMIZAÇÃO / GUI 🚀"},
    {name = "OTIMIZAÇÃO 🚀", url = "https://raw.githubusercontent.com/Davzxxfixroblox/DavzxHubFixLag/refs/heads/main/FixLagHub"},
    {name = "PING OPTIMIZER 🧟‍♂️", url = "https://pastebin.com/raw/kbHL8MZ5"},
    {name = "ESTICAR TELA 🖥", url = "https://pastefy.app/4Sa0uIve/raw"},
    {name = "LIMPAR TELA 💻", url = "https://pastefy.app/FwY4L6qM/raw"},
    {name = "MEGA OTIMIZAÇÃO Brookhaven 🏠", url = "https://pastebin.com/raw/GzrqQWkx"},
    {name = "OTIMIZAÇÃO LINHA TRANSPARENTE 🔗", url = "https://pastebin.com/raw/RbC506TY"},

    -- ==================== Outros / Novos ====================
    {category = "⭐ OUTROS / NOVOS ⭐"},
    {name = "BOLA CHICLETE ⚽️", url = "https://pastefy.app/ZMHWh8kW/raw"},
    {name = "FOOTBALL MASTER V5 PRO", url = "https://pastefy.app/77ScQkbz/raw"},
    {name = "CHUTE BOMBA 💣", url = "https://pastefy.app/HeRcZpTg/raw"},
    {name = "FOOTBALL MASTER V7 ⚽", url = "https://pastefy.app/I9nocuO2/raw"},
    {name = "HUB DA LEANDRINHA ⚽", url = "https://pastebin.com/raw/q5CxCNyi"},
    {name = "ZYCK 4.5 🇺🇸", url = "https://pastefy.app/P2eNOBe2/raw"},
    {name = "GUI PRIME PRO ⚽", url = "https://pastebin.com/raw/xgkQc7Q9"},
    {name = "K4y The Promission ☠️", url = "https://pastefy.app/Of3pO501/raw"},
    {name = "LP Scripts ✔️", url = "https://gist.githubusercontent.com/yesn20456-crypto/af368f3184c1d34a8f4a9e33d4325d0d/raw/60e8309b99f9e002a55005b2d7905a82b90b70f1/gistfile1.txt"},
    {name = "Armando Jr Hub 🔥", url = "https://raw.githubusercontent.com/carlosedut11/ArmadinhoJrPorCantonaJr/refs/heads/main/ArmadinhoJrPorCantonaJr.lua"},
    {name = "Lucas Hub 😈", url = "https://pastebin.com/raw/xmbL5T3i"},
    {name = "Painel do Kayne 🔥", url = "https://pastebin.com/raw/Frxjj6my"},
    {name = "KAYNE Supremo 🔥", url = "https://pastebin.com/raw/xyS7KQdY"},
    {name = "Theus Hub 🍎", url = "https://pastefy.app/bib1MRS8/raw"},
    {name = "Matteo Hub ❄️", url = "https://pastefy.app/Pvf3lqmJ/raw"},
    {name = "Gotto Hub ⚽", url = "https://pastefy.app/EOizRmIz/raw"},
    {name = "Loved Hub 🍷", url = "https://pastefy.app/AccDN8CV/raw"},
    {name = "Painel Spider V2 🕷", url = "https://pastefy.app/LvYw31OO/raw"},
    {name = "Angel Hub 😇", url = "https://pastefy.app/679CyrEi/raw"},
    {name = "Samuzx Hub 🥶", url = "https://pastefy.app/yOVyrBNy/raw"},
    {name = "Script do Spider V1 🕷", url = "https://pastefy.app/hutJntDN/raw"},
    {name = "Script do Freezer 🧊", url = "https://pastefy.app/bWS31I8q/raw"},
    {name = "Papai Cris Menu ❤️", url = "https://pastefy.app/jI58Il0a/raw"},
    {name = "Hunk Hub ", url = "https://pastefy.app/ZGDUJNWr/raw"},
    {name = "Slow Hub 🐌", url = "https://pastefy.app/tSoOifGr/raw"},
    {name = "Drinho Hub 🎯", url = "https://pastefy.app/KEfkfhsr/raw"},

    -- Novos extras
    {name = "LUKINHAS HUB 💙", url = "https://pastebin.com/raw/dhxQnF4b"},
    {name = "PIRULITO HUB 🍭", url = "https://pastebin.com/raw/A0xCHTGM"},
    {name = "TONI KROOS 🍀", url = "https://pastebin.com/raw/bCL22UZw"},
    {name = "X10 PREMIUM HUB 💎", url = "https://pastebin.com/raw/MW2Zyv6z"},
    {name = "FIRE HUB 🔥", url = "https://pastebin.com/raw/iVp2tnCR"},
    {name = "SFORZA HUB 🔧", url = "https://pastebin.com/raw/pdyfSjzK"},
    {name = "ZYCK ☠️", url = "https://pastebin.com/raw/WYeG9ypc"},
    {name = "ABENÇOADO 777 👼", url = "https://raw.githubusercontent.com/admpietrovinicius-debug/Aben-oado-777/refs/heads/main/Aben%C3%A7oado777.lua"},
    {name = "WATER HUB 🌊", url = "https://pastefy.app/iQzbaBGE/raw"},
    {name = "SIX HUB 6️⃣", url = "https://pastebin.com/raw/MDhqkib4"},
    {name = "SCRIPT DA DEBINHA 🥀", url = "https://pastefy.app/9k4tL5Q7/raw"},
    {name = "HOTDOG V4 🌭", url = "https://pastefy.app/GzxmSIIn/raw"},
    {name = "TIRA ANALÓGICO 🕹", url = "https://pastefy.app/AJhzcN5G/raw"},
    {name = "TUBAINA HUB 🥶", url = "https://pastefy.app/xLM92mP5/raw"},
    {name = "SCRIPT DO KAY V2 🔥", url = "https://pastebin.com/raw/eXGuwWWE"},
    {name = "DD OSAMA V5 🇺🇸", url = "https://pastebin.com/raw/NxpP7iWb"},
    {name = "FUZZY BUGS ♟️", url = "https://pastefy.app/rsiBF3CL/raw"},
    {name = "ANTI ROUBO BOLA ⚽️ 🔑 KWLS", url = "https://pastebin.com/raw/4GXQEjAs"},
    {name = "SIXXINHO HUB 🔒 🔑 SWGK", url = "https://raw.githubusercontent.com/josegaviao888-alt/Six-Hub-Privdo/refs/heads/main/Six%20hUB"},
    {name = "X HUB ❌️", url = "https://pastefy.app/yXuzlTpQ/raw"},
    {name = "CAGA NA ROUPA HUB 💩", url = "https://pastefy.app/eKFExNPG/raw"},
}

-- =====================================================================
-- CRIAÇÃO DA INTERFACE (Simple GUI V2.6 Style)
-- =====================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ConducaoLancasterHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = playerGui

-- Frame principal (fundo escuro)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Barra de título
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -80, 1, 0)
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "⚽ CONDUÇÃO HUB"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextSize = 16
TitleLabel.Parent = TitleBar

-- Botão de fechar
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Campo de pesquisa
local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, -20, 0, 30)
SearchFrame.Position = UDim2.new(0, 10, 0, 50)
SearchFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
SearchFrame.BorderSizePixel = 0
SearchFrame.Parent = MainFrame

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -10, 1, 0)
SearchBox.Position = UDim2.new(0, 5, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.PlaceholderText = "🔍 Pesquisar script..."
SearchBox.Text = ""
SearchBox.TextColor3 = Color3.fromRGB(255, 255, 255)
SearchBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 14
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.Parent = SearchFrame

-- Container com scroll para os scripts
local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, -20, 1, -100)
ScrollFrame.Position = UDim2.new(0, 10, 0, 90)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.BorderSizePixel = 0
ScrollFrame.ScrollBarThickness = 6
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 120)
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollFrame.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)
UIListLayout.Parent = ScrollFrame

-- =====================================================================
-- FUNÇÃO PARA CRIAR BOTÕES DE SCRIPT
-- =====================================================================
local function CreateScriptButton(name, url, order)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -5, 0, 40)
    Button.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
    Button.Text = ""
    Button.Parent = ScrollFrame
    Button.LayoutOrder = order

    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 8)
    BtnCorner.Parent = Button

    local NameLabel = Instance.new("TextLabel")
    NameLabel.Size = UDim2.new(1, -80, 1, 0)
    NameLabel.Position = UDim2.new(0, 12, 0, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = name
    NameLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
    NameLabel.TextXAlignment = Enum.TextXAlignment.Left
    NameLabel.Font = Enum.Font.Gotham
    NameLabel.TextSize = 13
    NameLabel.Parent = Button

    local ExecBtn = Instance.new("TextButton")
    ExecBtn.Size = UDim2.new(0, 55, 0, 26)
    ExecBtn.Position = UDim2.new(1, -65, 0.5, -13)
    ExecBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    ExecBtn.Text = "▶"
    ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExecBtn.Font = Enum.Font.GothamBold
    ExecBtn.TextSize = 14
    ExecBtn.Parent = Button

    local ExecCorner = Instance.new("UICorner")
    ExecCorner.CornerRadius = UDim.new(0, 6)
    ExecCorner.Parent = ExecBtn

    ExecBtn.MouseButton1Click:Connect(function()
        local success, err = pcall(function()
            loadstring(game:HttpGet(url))()
        end)
        if not success then
            warn("Erro ao carregar: " .. err)
        end
    end)
end

-- =====================================================================
-- FUNÇÃO PARA CRIAR CABEÇALHOS DE CATEGORIA
-- =====================================================================
local function CreateCategoryHeader(name, order)
    local Header = Instance.new("TextLabel")
    Header.Size = UDim2.new(1, -5, 0, 28)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Header.Text = name
    Header.TextColor3 = Color3.fromRGB(0, 255, 150)
    Header.TextXAlignment = Enum.TextXAlignment.Left
    Header.Font = Enum.Font.GothamBold
    Header.TextSize = 13
    Header.Parent = ScrollFrame
    Header.LayoutOrder = order

    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 6)
    HeaderCorner.Parent = Header

    local Padding = Instance.new("UIPadding")
    Padding.PaddingLeft = UDim.new(0, 10)
    Padding.Parent = Header
end

-- =====================================================================
-- CONSTRÓI A LISTA INICIAL
-- =====================================================================
local orderCounter = 0
local allItems = {} -- Armazena referências para o filtro

local function BuildList(filterText)
    -- Limpa a lista atual
    for _, child in ipairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextLabel") or child:IsA("TextButton") then
            if child ~= UIListLayout then
                child:Destroy()
            end
        end
    end
    allItems = {}
    orderCounter = 0

    filterText = string.lower(filterText or "")

    for _, item in ipairs(scriptsData) do
        if item.category then
            -- É um cabeçalho de categoria
            local catName = string.lower(item.category)
            if filterText == "" or string.find(catName, filterText, 1, true) then
                orderCounter = orderCounter + 1
                CreateCategoryHeader(item.category, orderCounter)
            end
        elseif item.name and item.url then
            -- É um script
            local scriptName = string.lower(item.name)
            if filterText == "" or string.find(scriptName, filterText, 1, true) then
                orderCounter = orderCounter + 1
                CreateScriptButton(item.name, item.url, orderCounter)
                table.insert(allItems, {name = item.name, url = item.url})
            end
        end
    end

    -- Atualiza o tamanho do canvas
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 10)
end

-- Inicializa a lista
BuildList("")

-- =====================================================================
-- FILTRO DE PESQUISA
-- =====================================================================
SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    BuildList(SearchBox.Text)
end)

-- =====================================================================
-- TORNAR A JANELA ARRASTÁVEL
-- =====================================================================
local dragging = false
local dragStart = nil
local startPos = nil

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

TitleBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
