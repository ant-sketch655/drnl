local function createGui()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ConduçãoLancasterHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- ==================== TÍTULO PRINCIPAL ====================
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 70)
    TitleBar.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    TitleBar.BackgroundTransparency = 0.1
    TitleBar.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 1, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "⚽️ CONDUÇÃO DO LANCASTER ⚽️"
    Title.TextColor3 = Color3.fromRGB(0, 255, 100)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.Parent = TitleBar

    -- ==================== SIDEBAR ====================
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0.22, 0, 1, -70)
    Sidebar.Position = UDim2.new(0, 0, 0, 70)
    Sidebar.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
    Sidebar.Parent = ScreenGui

    local SidebarList = Instance.new("UIListLayout")
    SidebarList.SortOrder = Enum.SortOrder.LayoutOrder
    SidebarList.Padding = UDim.new(0, 8)
    SidebarList.Parent = Sidebar

    -- ==================== CARDS ====================
    local function CreateCard(title, desc, url)
        local Card = Instance.new("Frame")
        Card.Size = UDim2.new(1, -20, 0, 78)
        Card.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
        Card.BackgroundTransparency = 0.05
        Card.BorderSizePixel = 0
        Card.Parent = Sidebar

        local UICorner = Instance.new("UICorner")
        UICorner.CornerRadius = UDim.new(0, 12)
        UICorner.Parent = Card

        local TitleLabel = Instance.new("TextLabel")
        TitleLabel.Size = UDim2.new(1, -80, 0.65, 0)
        TitleLabel.Position = UDim2.new(0, 15, 0, 8)
        TitleLabel.BackgroundTransparency = 1
        TitleLabel.Text = title
        TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
        TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
        TitleLabel.TextYAlignment = Enum.TextYAlignment.Top
        TitleLabel.Font = Enum.Font.GothamBold
        TitleLabel.TextScaled = true
        TitleLabel.Parent = Card

        local DescLabel = Instance.new("TextLabel")
        DescLabel.Size = UDim2.new(1, -80, 0.35, 0)
        DescLabel.Position = UDim2.new(0, 15, 0.65, 0)
        DescLabel.BackgroundTransparency = 1
        DescLabel.Text = desc
        DescLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
        DescLabel.TextXAlignment = Enum.TextXAlignment.Left
        DescLabel.Font = Enum.Font.Gotham
        DescLabel.TextScaled = false
        DescLabel.Parent = Card

        local ExecuteBtn = Instance.new("TextButton")
        ExecuteBtn.Size = UDim2.new(0, 65, 0, 26)
        ExecuteBtn.Position = UDim2.new(1, -75, 0.5, -13)
        ExecuteBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        ExecuteBtn.Text = "EXECUTAR"
        ExecuteBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ExecuteBtn.Font = Enum.Font.GothamBold
        ExecuteBtn.TextScaled = true
        ExecuteBtn.Parent = Card

        local BtnCorner = Instance.new("UICorner")
        BtnCorner.CornerRadius = UDim.new(0, 8)
        BtnCorner.Parent = ExecuteBtn

        ExecuteBtn.MouseButton1Click:Connect(function()
            local success, err = pcall(function()
                loadstring(game:HttpGet(url))()
            end)
            if not success then
                warn("Erro ao carregar: " .. err)
            end
        end)
    end

    -- ==================== DADOS ATUALIZADOS (COM CATEGORIAS) ====================
    local cardsData = {
        -- ==================== CONDUÇÃO ====================
        {"⚽️ CONDUÇÃO ⚽️", ""},
        {"ANT PULO", ""},
        {"https://pastebin.com/raw/d2T3QxGt"},
        {"ANTI PULO ELIAS", ""},
        {"https://pastebin.com/raw/mgzrnsbr"},
        {"ZYCK ANTI PULO", ""},
        {"https://pastebin.com/raw/MCTcaHZq"},
        {"SOCCER DRIBBLE HUB ⚡️", ""},
        {"https://pastebin.com/raw/gwZKjbVM"},
        {"PASSE FORTE 🦵", ""},
        {"https://pastebin.com/raw/2Yw8Bv85"},
        {"CONDUÇÃO THEUS ⚽", ""},
        {"https://pastefy.app/7FAwfRUX/raw"},
        {"HENRIQUE DRIBLE ⚡", ""},
        {"https://pastebin.com/raw/wJKBdV8A"},

        -- ==================== Atravessar / Soccer Tool ====================
        {"🔥 Atravessar / Soccer Tool 🔥", ""},
        {"ANTI Atravessar Soccer Tool", ""},
        {"https://pastebin.com/raw/LYWJ6sfF"},
        {"ATRAVESSAR SIMPLES 🔥", ""},
        {"https://pastebin.com/raw/D15v30nW"},
        {"ATRAVESSAR THEUS 👻", ""},
        {"https://pastefy.app/7e1VxPgW/raw"},
        {"PJ Atravessa 🧧", ""},
        {"https://pastefy.app/CrhmqFtx/raw"},
        {"ATRAVESSAR V12 🟣", ""},
        {"https://pastebin.com/raw/GZn1L0PM"},
        {"Oliver Atravessador 🗡", ""},
        {"https://rawscripts.net/raw/Universal-Script-Script-de-atravessar-56285"},
        {"NOCLIP Injusto + Reach 900 studs 🔥", ""},
        {"https://pastebin.com/raw/hfrDcUm8"},
        {"ANTI BALL PEDRA + Atravessar ⚽", ""},
        {"https://pastebin.com/raw/Z7eZDEj8"},

        -- ==================== Defender / Goleiro ====================
        {"🧤 DEFENDER / GOLEIRO 🧤", ""},
        {"MURALHA HUB 🧱", ""},
        {"https://pastebin.com/raw/UxtmMHm1"},
        {"GOLEIRO HUB (Rayfield) 🧤", ""},
        {"https://pastefy.app/cogJvYif/raw"},
        {"Legendary Defender ⚔️", ""},
        {"https://pastebin.com/raw/s91y0AFs"},
        {"GK Hub (Goleiro Deitado) 🧤", ""},
        {"https://pastebin.com/raw/FaBkfBHr"},
        {"Yashin Ultra 🧤", ""},
        {"https://pastebin.com/raw/KmNHLYsb"},
        {"Puyol V3 ⚡️", ""},
        {"https://pastebin.com/raw/bMLRRKwG"},

        -- ==================== Reach / Bug / Glitch ====================
        {"🌑 REACH / BUG / GLITCH 🌑", ""},
        {"REACH THE VOID 🌑", ""},
        {"https://pastebin.com/raw/HyAUVhnP"},
        {"GHOST + Reach 👻", ""},
        {"https://pastebin.com/raw/1if0pn7x"},
        {"THEUS REACH V2 🦿", ""},
        {"https://pastebin.com/raw/pm4pyxm4"},
        {"REACH DO THEUS 🦿", ""},
        {"https://pastefy.app/tSYVNcwc/raw"},
        {"JVZ Bug 🥷", ""},
        {"https://pastefy.app/hYyBJna/raw"},
        {"Bug do Reidorm 👑", ""},
        {"https://pastebin.com/raw/qtsDZHGu"},
        {"PEDRIZZ Bug ⚡️", ""},
        {"https://pastebin.com/raw/28LDYic2"},
        {"MTZIN Pro Max ⚡", ""},
        {"https://pastebin.com/raw/kCKEhh99"},
        {"LAG SWITCH 👣", ""},
        {"https://pastefy.app/zZo7yoUB/raw"},
        {"GLITCH INFINITY ♾️", ""},
        {"https://pastebin.com/raw/FpPh3UhN"},

        -- ==================== Otimização / GUI ====================
        {"🚀 OTIMIZAÇÃO / GUI 🚀", ""},
        {"OTIMIZAÇÃO 🚀", ""},
        {"https://raw.githubusercontent.com/Davzxxfixroblox/DavzxHubFixLag/refs/heads/main/FixLagHub"},
        {"PING OPTIMIZER 🧟‍♂️", ""},
        {"https://pastebin.com/raw/kbHL8MZ5"},
        {"ESTICAR TELA 🖥", ""},
        {"https://pastefy.app/4Sa0uIve/raw"},
        {"LIMPAR TELA 💻", ""},
        {"https://pastefy.app/FwY4L6qM/raw"},
        {"MEGA OTIMIZAÇÃO Brookhaven 🏠", ""},
        {"https://pastebin.com/raw/GzrqQWkx"},
        {"OTIMIZAÇÃO LINHA TRANSPARENTE 🔗", ""},
        {"https://pastebin.com/raw/RbC506TY"},

        -- ==================== Outros / Novos ====================
        {"⭐ OUTROS / NOVOS ⭐", ""},
        {"BOLA CHICLETE ⚽️", ""},
        {"https://pastefy.app/ZMHWh8kW/raw"},
        {"FOOTBALL MASTER V5 PRO", ""},
        {"https://pastefy.app/77ScQkbz/raw"},
        {"CHUTE BOMBA 💣", ""},
        {"https://pastefy.app/HeRcZpTg/raw"},
        {"FOOTBALL MASTER V7 ⚽", ""},
        {"https://pastefy.app/I9nocuO2/raw"},
        {"HUB DA LEANDRINHA ⚽", ""},
        {"https://pastebin.com/raw/q5CxCNyi"},
        {"ZYCK 4.5 🇺🇸", ""},
        {"https://pastefy.app/P2eNOBe2/raw"},
        {"GUI PRIME PRO ⚽", ""},
        {"https://pastebin.com/raw/xgkQc7Q9"},
        {"K4y The Promission ☠️", ""},
        {"https://pastefy.app/Of3pO501/raw"},
        {"LP Scripts ✔️", ""},
        {"https://gist.githubusercontent.com/yesn20456-crypto/af368f3184c1d34a8f4a9e33d4325d0d/raw/60e8309b99f9e002a55005b2d7905a82b90b70f1/gistfile1.txt"},
        {"Armando Jr Hub 🔥", ""},
        {"https://raw.githubusercontent.com/carlosedut11/ArmadinhoJrPorCantonaJr/refs/heads/main/ArmadinhoJrPorCantonaJr.lua"},
        {"Lucas Hub 😈", ""},
        {"https://pastebin.com/raw/xmbL5T3i"},
        {"Painel do Kayne 🔥", ""},
        {"https://pastebin.com/raw/Frxjj6my"},
        {"KAYNE Supremo 🔥", ""},
        {"https://pastebin.com/raw/xyS7KQdY"},
        {"Theus Hub 🍎", ""},
        {"https://pastefy.app/bib1MRS8/raw"},
        {"Matteo Hub ❄️", ""},
        {"https://pastefy.app/Pvf3lqmJ/raw"},
        {"Gotto Hub ⚽", ""},
        {"https://pastefy.app/EOizRmIz/raw"},
        {"Loved Hub 🍷", ""},
        {"https://pastefy.app/AccDN8CV/raw"},
        {"Painel Spider V2 🕷", ""},
        {"https://pastefy.app/LvYw31OO/raw"},
        {"Angel Hub 😇", ""},
        {"https://pastefy.app/679CyrEi/raw"},
        {"Samuzx Hub 🥶", ""},
        {"https://pastefy.app/yOVyrBNy/raw"},
        {"Script do Spider V1 🕷", ""},
        {"https://pastefy.app/hutJntDN/raw"},
        {"Script do Freezer 🧊", ""},
        {"https://pastefy.app/bWS31I8q/raw"},
        {"Papai Cris Menu ❤️", ""},
        {"https://pastefy.app/jI58Il0a/raw"},
        {"Hunk Hub 🫂", ""},
        {"https://pastefy.app/ZGDUJNWr/raw"},
        {"Slow Hub 🐌", ""},
        {"https://pastefy.app/tSoOifGr/raw"},
        {"Drinho Hub 🎯", ""},
        {"https://pastefy.app/KEfkfhsr/raw"},

        -- Novos extras
        {"LUKINHAS HUB 💙", ""},
        {"https://pastebin.com/raw/dhxQnF4b"},
        {"PIRULITO HUB 🍭", ""},
        {"https://pastebin.com/raw/A0xCHTGM"},
        {"TONI KROOS 🍀", ""},
        {"https://pastebin.com/raw/bCL22UZw"},
        {"X10 PREMIUM HUB 💎", ""},
        {"https://pastebin.com/raw/MW2Zyv6z"},
        {"FIRE HUB 🔥", ""},
        {"https://pastebin.com/raw/iVp2tnCR"},
        {"SFORZA HUB 🔧", ""},
        {"https://pastebin.com/raw/pdyfSjzK"},
        {"ZYCK ☠️", ""},
        {"https://pastebin.com/raw/WYeG9ypc"},
        {"ABENÇOADO 777 👼", ""},
        {"https://raw.githubusercontent.com/admpietrovinicius-debug/Aben-oado-777/refs/heads/main/Aben%C3%A7oado777.lua"},
        {"WATER HUB 🌊", ""},
        {"https://pastefy.app/iQzbaBGE/raw"},
        {"SIX HUB 6️⃣", ""},
        {"https://pastebin.com/raw/MDhqkib4"},
        {"SCRIPT DA DEBINHA 🥀", ""},
        {"https://pastefy.app/9k4tL5Q7/raw"},
        {"HOTDOG V4 🌭", ""},
        {"https://pastefy.app/GzxmSIIn/raw"},
        {"TIRA ANALÓGICO 🕹", ""},
        {"https://pastefy.app/AJhzcN5G/raw"},
        {"TUBAINA HUB 🥶", ""},
        {"https://pastefy.app/xLM92mP5/raw"},
        {"SCRIPT DO KAY V2 🔥", ""},
        {"https://pastebin.com/raw/eXGuwWWE"},
        {"DD OSAMA V5 🇺🇸", ""},
        {"https://pastebin.com/raw/NxpP7iWb"},
        {"FUZZY BUGS ♟️", ""},
        {"https://pastefy.app/rsiBF3CL/raw"},
        {"ANTI ROUBO BOLA ⚽️ 🔑 KWLS", ""},
        {"https://pastebin.com/raw/4GXQEjAs"},
        {"SIXXINHO HUB 🔒 🔑 SWGK", ""},
        {"https://raw.githubusercontent.com/josegaviao888-alt/Six-Hub-Privdo/refs/heads/main/Six%20hUB"},
        {"X HUB ❌️", ""},
        {"https://pastefy.app/yXuzlTpQ/raw"},
        {"CAGA NA ROUPA HUB 💩", ""},
        {"https://pastefy.app/eKFExNPG/raw"},
    }

    for i = 1, #cardsData, 2 do
        local title = cardsData[i]
        local url = cardsData[i + 1]
        if url == "" then
            -- Categoria ou Subcategoria
            local Cat = Instance.new("TextLabel")
            Cat.Size = UDim2.new(1, -20, 0, 36)
            Cat.Position = UDim2.new(0, 10, 0, 0)
            Cat.BackgroundTransparency = 1
            Cat.Text = title
            Cat.TextColor3 = Color3.fromRGB(0, 255, 150)
            Cat.TextXAlignment = Enum.TextXAlignment.Left
            Cat.Font = Enum.Font.GothamBlack
            Cat.TextSize = 16
            Cat.Parent = Sidebar
            SidebarList:Add(Cat)
        else
            CreateCard(title, "", url)
        end
    end

    -- ==================== BOTÕES FLUTUANTES ====================
    local OpenDemo = Instance.new("TextButton")
    OpenDemo.Size = UDim2.new(0, 140, 0, 48)
    OpenDemo.Position = UDim2.new(0.5, -70, 1, -60)
    OpenDemo.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
    OpenDemo.Text = "OPEN GUI DEMO"
    OpenDemo.TextColor3 = Color3.new(1,1,1)
    OpenDemo.Font = Enum.Font.GothamBold
    OpenDemo.TextScaled = true
    OpenDemo.Parent = ScreenGui

    local TestBtn = Instance.new("TextButton")
    TestBtn.Size = UDim2.new(0, 140, 0, 48)
    TestBtn.Position = UDim2.new(0.5, 70, 1, -60)
    TestBtn.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
    TestBtn.Text = "TESTAR NO ROBLOX"
    TestBtn.TextColor3 = Color3.new(1,1,1)
    TestBtn.Font = Enum.Font.GothamBold
    TestBtn.TextScaled = true
    TestBtn.Parent = ScreenGui

    local OpenCorner = Instance.new("UICorner")
    OpenCorner.CornerRadius = UDim.new(0, 12)
    OpenCorner.Parent = OpenDemo
    OpenCorner.Parent = TestBtn

    SidebarList:ApplyLayout()
end

createGui()
