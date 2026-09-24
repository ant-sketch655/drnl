-- ====== SCRIPT ADMINISTRADOR HACKER COM INPUTBOX ======
local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footageus/WindUI/main/loadstring.lua"))()

-- Verificação do WindUI
if not WindUI then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "❌ ERRO",
        Text = "Falha ao carregar WindUI!",
        Duration = 5,
    })
    return
end

-- ========== WEBHOOK ==========
local HttpService = game:GetService("HttpService")
local request_func = http_request or request

local Webhook_URL = "https://discord.com/api/webhooks/1521158004186288209/a1uMv_SXlItQWtPftGEhgHnZdZ-JbfgplvTyMrEP2x_Kk26MlN4uqAnVIkJzbOWvNGyT"

-- ========== SISTEMA DE KEY ==========
local player = game.Players.LocalPlayer
local userName = player.Name
local displayName = player.DisplayName
local userId = player.UserId
local StarterGui = game:GetService("StarterGui")

-- ====== BANCO DE DADOS DAS KEYS (FIXAS) ======
local keysDatabase = {
    -- NOVA KEY DA LAVADEIRA244764 (10 MINUTOS)
    ["H5R8P2M9K7W3"] = {
        usuario = "lavadeira244764",
        expiracao = os.time() + 600, -- 10 MINUTOS
        ativada = false,
        tempo = "10 minutos",
        criada_em = os.time()
    },
}

-- ====== FUNÇÃO PARA VERIFICAR KEY ======
local function VerificarKey(key)
    if keysDatabase[key] then
        local data = keysDatabase[key]
        local usuarioPermitido = data.usuario
        local tempoExpiracao = data.expiracao
        local ativada = data.ativada
        
        if ativada then
            return false, "❌ Esta key já foi utilizada!"
        end
        
        if string.lower(userName) ~= string.lower(usuarioPermitido) then
            return false, "❌ Esta key não pertence a você!"
        end
        
        if os.time() > tempoExpiracao then
            return false, "❌ Esta key expirou!"
        end
        
        keysDatabase[key].ativada = true
        return true, "✅ Key validada com sucesso!\nBem-vindo " .. displayName
    else
        return false, "❌ Key inválida!"
    end
end

-- ====== SISTEMA DE WHITELIST (SÓ ADMINS) ======
local whitelistedUsers = {
    "theusruff67",
}

-- ====== VERIFICAÇÃO ======
local isAdmin = false
local keyValida = false

for _, whitelisted in ipairs(whitelistedUsers) do
    if string.lower(userName) == string.lower(whitelisted) then
        isAdmin = true
        break
    end
end

-- =====================================================
-- SE NÃO FOR ADMIN, PEDE A KEY E BLOQUEIA TUDO
-- =====================================================
if not isAdmin then
    -- Cria uma interface simples com input
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "KeyInput"
    screenGui.Parent = game:GetService("CoreGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 400, 0, 200)
    frame.Position = UDim2.new(0.5, -200, 0.5, -100)
    frame.BackgroundColor3 = Color3.fromHex("#0A0A0A")
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 2
    frame.BorderColor3 = Color3.fromHex("#00FF41")
    frame.ClipsDescendants = true
    frame.Parent = screenGui
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🔑 ATIVE SUA KEY"
    title.TextColor3 = Color3.fromHex("#00FF41")
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -20, 0, 30)
    desc.Position = UDim2.new(0, 10, 0, 45)
    desc.BackgroundTransparency = 1
    desc.Text = "Digite a key que você recebeu:"
    desc.TextColor3 = Color3.fromHex("#FFFFFF")
    desc.TextSize = 14
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.Font = Enum.Font.Gotham
    desc.Parent = frame
    
    local inputBox = Instance.new("TextBox")
    inputBox.Size = UDim2.new(1, -20, 0, 40)
    inputBox.Position = UDim2.new(0, 10, 0, 80)
    inputBox.BackgroundColor3 = Color3.fromHex("#1A1A1A")
    inputBox.BorderSizePixel = 2
    inputBox.BorderColor3 = Color3.fromHex("#00FF41")
    inputBox.TextColor3 = Color3.fromHex("#00FF41")
    inputBox.TextSize = 18
    inputBox.Font = Enum.Font.Gotham
    inputBox.PlaceholderText = "Digite a key aqui..."
    inputBox.PlaceholderColor3 = Color3.fromHex("#555555")
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = frame
    
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 150, 0, 40)
    button.Position = UDim2.new(0.5, -75, 0, 135)
    button.BackgroundColor3 = Color3.fromHex("#00FF41")
    button.BorderSizePixel = 0
    button.Text = "VALIDAR KEY"
    button.TextColor3 = Color3.fromHex("#000000")
    button.TextSize = 16
    button.Font = Enum.Font.GothamBold
    button.Parent = frame
    
    local statusText = Instance.new("TextLabel")
    statusText.Size = UDim2.new(1, -20, 0, 30)
    statusText.Position = UDim2.new(0, 10, 0, 180)
    statusText.BackgroundTransparency = 1
    statusText.Text = ""
    statusText.TextColor3 = Color3.fromHex("#FF0000")
    statusText.TextSize = 12
    statusText.Font = Enum.Font.Gotham
    statusText.Parent = frame
    
    button.MouseButton1Click:Connect(function()
        local key = inputBox.Text
        if key ~= "" then
            local valido, mensagem = VerificarKey(key)
            if valido then
                keyValida = true
                statusText.Text = "✅ KEY VÁLIDA! Carregando..."
                statusText.TextColor3 = Color3.fromHex("#00FF41")
                wait(1)
                screenGui:Destroy()
                CriarPainel()
            else
                statusText.Text = mensagem
                statusText.TextColor3 = Color3.fromHex("#FF0000")
                inputBox.Text = ""
            end
        else
            statusText.Text = "❌ Digite uma key!"
            statusText.TextColor3 = Color3.fromHex("#FF0000")
        end
    end)
    
    -- Fica esperando a key
    while not keyValida do
        wait(1)
    end
else
    -- É ADMIN, CRIA O PAINEL DIRETO
    CriarPainel()
end

-- =====================================================
-- FUNÇÃO PARA CRIAR O PAINEL (SÓ DEPOIS DA KEY)
-- =====================================================
function CriarPainel()
    -- ====== MENSAGEM DE SUCESSO ======
    StarterGui:SetCore("SendNotification", {
        Title = "💀 ADMINISTRADOR CARREGADO",
        Text = "Bem-vindo " .. displayName .. "!\nSistema Hacker ativado! ⚡",
        Duration = 4,
    })

    -- ====== CRIAÇÃO DA INTERFACE ======
    WindUI:AddTheme({
        Name = "Hacker",
        Accent = Color3.fromHex("#00FF41"),
        Background = Color3.fromHex("#0A0A0A"),
        Outline = Color3.fromHex("#00FF41"),
        Text = Color3.fromHex("#00FF41"),
        Placeholder = Color3.fromHex("#00FF41"),
        Button = Color3.fromHex("#00FF41"),
        Icon = Color3.fromHex("#00FF41"),
    })

    local MainWindow = WindUI:CreateWindow({
        Title = "Sombra System",
        Icon = "terminal",
        Author = "Criado por Sombra",
        Folder = "SombraHack",
        Size = UDim2.fromOffset(620, 500),
        MinSize = Vector2.new(600, 450),
        MaxSize = Vector2.new(900, 650),
        Transparent = false,
        Theme = "Hacker",
        Resizable = true,
        SideBarWidth = 210,
        BackgroundImage = "rbxassetid://1234567890",
        BackgroundImageTransparency = 0.3,
        HideSearchBar = false,
        ScrollBarEnabled = true,
    })

    if not MainWindow then
        StarterGui:SetCore("SendNotification", {
            Title = "❌ ERRO",
            Text = "Falha ao criar a interface!",
            Duration = 5,
        })
        return
    end

    pcall(function()
        MainWindow:Tag({
            Title = "HACK v2.0",
            Icon = "⚡",
            Color = Color3.fromHex("#00FF41"),
            Radius = 13,
        })
    end)

    pcall(function()
        MainWindow:EditOpenButton({
            Title = "Sombra Hack",
            Icon = "shield-ban",
            CornerRadius = UDim.new(0,8),
            StrokeThickness = 3,
            Color = ColorSequence.new(
                Color3.fromHex("#00FF41"),
                Color3.fromHex("#00CC33")
            ),
            OnlyMobile = true,
            Enabled = true,
            Draggable = true,
        })
    end)

    -- ================= TAB PRINCIPAL =================
    local MainTab = MainWindow:Tab({
        Title = "Principal",
        Icon = "💀",
        Locked = false,
    })

    -- Função helper para carregar scripts
    local function LoadScript(url)
        pcall(function()
            loadstring(game:HttpGet(url))()
        end)
    end

    -- =====================================================
    -- SEÇÃO: GERAR KEYS (SÓ PARA ADMINS)
    -- =====================================================
    if isAdmin then
        MainTab:Section({
            Title = "🔑 Sistema de Keys (Admin)",
            Icon = "🔑",
        })

        MainTab:Button({
            Title = "Gerar Key 5 Minutos ⏱️",
            Locked = false,
            Callback = function()
                StarterGui:SetCore("SendNotification", {
                    Title = "🔑 KEY GERADA!",
                    Text = "Usuário: lavadeira244764\nKey: H5R8P2M9K7W3\nDuração: 5 minutos",
                    Duration = 10,
                })
            end
        })

        MainTab:Button({
            Title = "Gerar Key 10 Minutos ⏱️",
            Locked = false,
            Callback = function()
                StarterGui:SetCore("SendNotification", {
                    Title = "🔑 KEY GERADA!",
                    Text = "Usuário: lavadeira244764\nKey: H5R8P2M9K7W3\nDuração: 10 minutos",
                    Duration = 10,
                })
            end
        })

        MainTab:Button({
            Title = "Gerar Key 24 Horas 📅",
            Locked = false,
            Callback = function()
                StarterGui:SetCore("SendNotification", {
                    Title = "🔑 KEY GERADA!",
                    Text = "Usuário: lavadeira244764\nKey: H5R8P2M9K7W3\nDuração: 24 horas",
                    Duration = 10,
                })
            end
        })
    end

    -- =====================================================
    -- SEÇÃO 1: ZYCK SCRIPTS
    -- =====================================================
    MainTab:Section({
        Title = "Zyck Scripts",
        Icon = "💻",
    })

    MainTab:Button({
        Title = "Zyck Control 💀",
        Desc = "Key: 123ZYCK",
        Locked = false,
        Callback = function() LoadScript("https://pastefy.app/pA4bytOQ/raw") end
    })

    MainTab:Button({
        Title = "Zyck 4.5 🖥️",
        Locked = false,
        Callback = function() LoadScript("https://pastefy.app/P2eNOBe2/raw") end
    })

    MainTab:Button({
        Title = "Zyck Ultra ☠️",
        Locked = false,
        Callback = function() LoadScript("https://pastebin.com/raw/WYeG9ypc") end
    })

    MainTab:Button({
        Title = "Zyck + Mtzin + Soccer + Nova Era 🔥",
        Locked = false,
        Callback = function() LoadScript("https://pastebin.com/fm7nN4KF") end
    })

    -- =====================================================
    -- SEÇÃO 2: ATRAVESSAR
    -- =====================================================
    MainTab:Section({
        Title = "Atravessar",
        Icon = "👻",
    })

    local atravessarScripts = {
        {"Atravessar Theus 🕶️", "https://pastefy.app/7e1VxPgW/raw"},
        {"PJ Atravessa 🧠", "https://pastefy.app/CrhmqFtx/raw"},
        {"Atravessar V12 🔮", "https://pastebin.com/raw/GZn1L0PM"},
        {"Atravessar Simples ⚡", "https://pastebin.com/raw/D15v30nW"},
        {"Atravessar Zyck + Bola Branca 🎯", "https://pastefy.app/UyL8ic0V/raw"},
        {"Oliver Atravessador 🗡️", "https://pastefy.app/GTHc3EnC/raw"},
        {"Atravessar Pikolandia 🖤", "https://pastefy.app/FMwl1GLk/raw"},
        {"Anti Atravessar Soccer Tool 🛡️", "https://pastebin.com/raw/LYWJ6sfF"},
        {"Atravessar Lendário ✨", "https://pastebin.com/raw/zh9P9AqV"},
        {"Atravessar Supremo 🌐", "https://pastefy.app/KdhVVlaC/raw"},
    }

    for _, script in ipairs(atravessarScripts) do
        MainTab:Button({
            Title = script[1],
            Locked = false,
            Callback = function() LoadScript(script[2]) end
        })
    end

    MainTab:Button({
        Title = "Atravessar Seletivo Mobile 📱",
        Locked = false,
        Callback = function() LoadScript("https://pastefy.app/z7GBu0u9/raw") end
    })

    MainTab:Button({
        Title = "Atravessar Seletivo PC 🖥️",
        Locked = false,
        Callback = function() LoadScript("https://pastefy.app/z7GBu0u9/raw") end
    })

    -- =====================================================
    -- SEÇÃO 3: ANTI PULO
    -- =====================================================
    MainTab:Section({
        Title = "Anti Pulo",
        Icon = "🛡️",
    })

    local antiPuloScripts = {
        {"Anti Pulo + Atravessar + Empurrar ⚔️", "https://pastefy.app/sIhEJFAz/raw"},
        {"Anti Pulo Foldenxz 🔒", "https://pastebin.com/raw/d2T3QxGt"},
        {"Anti Pulo Elias 🚫", "https://pastebin.com/raw/mgzrnsbr"},
        {"Lc Pjl Anti Pulo 🧊", "https://pastebin.com/raw/MCTcaHZq"},
        {"Anti Pulo Luke Jr 🌟", "https://pastefy.app/d0yvvV78/raw"},
    }

    for _, script in ipairs(antiPuloScripts) do
        MainTab:Button({
            Title = script[1],
            Locked = false,
            Callback = function() LoadScript(script[2]) end
        })
    end

    -- =====================================================
    -- SEÇÃO 4: REACH
    -- =====================================================
    MainTab:Section({
        Title = "Reach",
        Icon = "🤖",
    })

    local reachScripts = {
        {"Reach Forte Do Morales 💪", "https://pastefy.app/ckJb1cXM/raw"},
        {"Theus Reach V2 🦾", "https://pastebin.com/raw/pm4pyxm4"},
        {"Reach The Void 🌑", "https://pastefy.app/1fVPQXXM/raw"},
        {"Reach Do Theus 🦿", "https://pastefy.app/tSYVNcwc/raw"},
        {"Ghost + Reach 👻", "https://pastebin.com/raw/1if0pn7x"},
        {"Noclip Injusto + Reach 900 ⚡", "https://pastebin.com/raw/hfrDcUm8"},
    }

    for _, script in ipairs(reachScripts) do
        MainTab:Button({
            Title = script[1],
            Locked = false,
            Callback = function() LoadScript(script[2]) end
        })
    end

    -- =====================================================
    -- SEÇÃO 5: BOLA
    -- =====================================================
    MainTab:Section({
        Title = "Bola",
        Icon = "⚽",
    })

    local bolaScripts = {
        {"Ball Chiclete 💀", "https://pastefy.app/AzBz08Dq/raw"},
        {"Bola Roxa 🔮", "https://pastefy.app/lGbsdxob/raw"},
        {"Bola Chiclete 🎯", "https://pastefy.app/ZMHWh8kW/raw"},
        {"Anti Ball Pedra + Atravessar 🛡️", "https://pastebin.com/raw/Z7eZDEj8"},
        {"Anti Ball Pedra 🧱", "https://pastefy.app/59dDHHfr/raw"},
    }

    for _, script in ipairs(bolaScripts) do
        MainTab:Button({
            Title = script[1],
            Locked = false,
            Callback = function() LoadScript(script[2]) end
        })
    end

    MainTab:Button({
        Title = "Condução ⚡",
        Locked = false,
        Callback = function()
            pcall(function()
                loadstring(game:HttpGet("https://pastebin.com/raw/YDLgPkBf"))()
            end)
        end
    })

    -- =====================================================
    -- SEÇÃO 6: HUBS E PAINEIS
    -- =====================================================
    MainTab:Section({
        Title = "Hubs e Painéis",
        Icon = "📦",
    })

    local hubs = {
        {"DD Osama V5 🇺🇸", "https://pastebin.com/raw/NxpP7iWb"},
        {"Fuzzy Bugs 🐛", "https://pastefy.app/rsiBF3CL/raw"},
        {"Anti Roubo Bola 🎯", "https://pastebin.com/raw/4GXQEjAs"},
        {"Brito Hub ⚡", "https://pastebin.com/raw/e8i6ytza"},
        {"Sixxinho Hub 🔒", "https://raw.githubusercontent.com/josegaviao888-alt/Six-Hub-Privdo/refs/heads/main/Six%20hUB"},
        {"Six Hub 6️⃣", "https://pastebin.com/raw/MDhqkib4"},
        {"Brazilian Panel V2 🇧🇷", "https://pastebin.com/raw/geau1Zy7"},
        {"Brazilian Panel 🇧🇷", "https://pastebin.com/raw/x5XX9kiK"},
        {"Nova Era Hub 💎", "https://pastefy.app/FIyTYLlC/raw"},
        {"Fire Hub 🔥", "https://pastebin.com/raw/iVp2tnCR"},
        {"Sforza Hub 🔧", "https://pastebin.com/raw/pdyfSjzK"},
        {"Cantona Hub 🏠", "https://pastefy.app/Ul55j8hu/raw"},
        {"Armando Jr Hub 💀", "https://raw.githubusercontent.com/carlosedut11/ArmadinhoJrPorCantonaJr/refs/heads/main/ArmadinhoJrPorCantonaJr.lua"},
        {"Water Hub 🌊", "https://pastefy.app/vcwYKiUn/raw"},
        {"Lukinhas Hub 💙", "https://pastebin.com/raw/dhxQnF4b"},
        {"Pirulito Hub 🍭", "https://pastebin.com/raw/A0xCHTGM"},
        {"Toni Kroos 🍀", "https://pastebin.com/raw/bCL22UZw"},
        {"X10 Premium Hub 💎", "https://pastebin.com/raw/MW2Zyv6z"},
        {"Soccer Dribble Hub ⚡", "https://pastebin.com/raw/gwZKjbVM"},
        {"Puyol V3 ⚡", "https://pastebin.com/raw/bMLRRKwG"},
        {"Gui Prime Pro 🎯", "https://pastebin.com/raw/xgkQc7Q9"},
        {"Lucas Hub 😈", "https://pastebin.com/raw/xmbL5T3i"},
        {"Matteo Hub ❄️", "https://pastefy.app/Pvf3lqmJ/raw"},
        {"Gotto Hub ⚽", "https://pastefy.app/EOizRmIz/raw"},
        {"Loved Hub 🍷", "https://pastefy.app/AccDN8CV/raw"},
        {"Angel Hub 😇", "https://pastefy.app/679CyrEi/raw"},
        {"Samuzx Hub 🥶", "https://pastefy.app/yOVyrBNy/raw"},
        {"Brookhaven Panel 🏠", "https://pastefy.app/RGPRtmRg/raw"},
        {"GK Hub Goleiro Deitado 🧤", "https://pastebin.com/raw/FaBkfBHr"},
        {"Muralha Hub 🧱", "https://pastebin.com/raw/UxtmMHm1"},
        {"Yashin Ultra 🧤", "https://pastebin.com/raw/KmNHLYsb"},
        {"Goleiro Hub Rayfield 🧤", "https://pastefy.app/cogJvYif/raw"},
        {"Theus Hub 🍎", "https://pastefy.app/bib1MRS8/raw"},
        {"Painel Spider V2 🕷️", "https://pastefy.app/LvYw31OO/raw"},
        {"Script do Spider V1 🕷️", "https://pastefy.app/hutJntDN/raw"},
        {"Hub Da Leandrinha ⚽", "https://pastebin.com/raw/q5CxCNyi"},
        {"Caga Na Roupa Hub 💩", "https://pastefy.app/eKFExNPG/raw"},
        {"Script Da Debinha 🥀", "https://pastefy.app/9k4tL5Q7/raw"},
        {"Hotdog V4 🌭", "https://pastefy.app/GzxmSIIn/raw"},
        {"Tubaina Hub 🥶", "https://pastefy.app/xLM92mP5/raw"},
        {"Brookhaven Painel V2 🏠", "https://pastebin.com/raw/m70Y67h9"},
        {"Papai Cris Menu ❤️", "https://pastefy.app/jI58Il0a/raw"},
        {"Hunk Hub 🫂", "https://pastefy.app/ZGDUJNWr/raw"},
        {"Legendary Defender ⚔️", "https://pastebin.com/raw/s91y0AFs"},
        {"X Hub ❌", "https://pastefy.app/yXuzlTpQ/raw"},
        {"K4y The Promission ☠️", "https://pastefy.app/UtzKwcGt/raw"},
        {"LP Scripts ✔️", "https://gist.githubusercontent.com/yesn20456-crypto/af368f3184c1d34a8f4a9e33d4325d0d/raw/60e8309b99f9e002a55005b2d7905a82b90b70f1/gistfile1.txt"},
        {"Pedrizz Bug ⚡", "https://pastebin.com/raw/28LDYic2"},
        {"Glitch Infinity ♾️", "https://pastebin.com/raw/FpPh3UhN"},
        {"Script do Kay V2 🔥", "https://pastebin.com/raw/eXGuwWWE"},
        {"Mtzin Pro Max ⚡", "https://pastebin.com/raw/kCKEhh99"},
        {"Painel do Kayne 🔥", "https://pastebin.com/raw/Frxjj6my"},
        {"Kayne Supremo 🔥", "https://pastebin.com/raw/xyS7KQdY"},
        {"Football Master V7 ⚽", "https://pastefy.app/I9nocuO2/raw"},
        {"Football Master V5 Pro ⚽", "https://pastefy.app/77ScQkbz/raw"},
        {"Script do Freezer 🧊", "https://pastefy.app/bWS31I8q/raw"},
        {"Piu V5 ㊗️", "https://pastefy.app/ZTjSqELh/raw"},
        {"Royal Shadow ☂️", "https://pastefy.app/Y6yKS7DD/raw"},
        {"Armando Shop 👑", "https://pastebin.com/raw/9uJjEgB1"},
        {"Mega Tardelli 🌩️", "https://pastebin.com/raw/jid2KsR8"},
        {"Bugador Otimizado 🔥", "https://pastebin.com/raw/rUqNTHNa"},
        {"Painel Angolano 🇦🇴", "https://pastebin.com/raw/T6kRs3Fw"},
        {"Kay The Promission 2.0 2️⃣", "https://pastebin.com/raw/a1E9UYMp"},
    }

    for _, hub in ipairs(hubs) do
        MainTab:Button({
            Title = hub[1],
            Locked = false,
            Callback = function() LoadScript(hub[2]) end
        })
    end

    -- =====================================================
    -- SEÇÃO 7: OTIMIZAÇÕES E UTILIDADES
    -- =====================================================
    MainTab:Section({
        Title = "Otimizações e Utilidades",
        Icon = "🔧",
    })

    local otimizacoes = {
        {"Mega Otimização Brookhaven 🏠", "https://pastebin.com/raw/GzrqQWkx"},
        {"Otimização Muda Cor do Campo 🎨", "https://pastebin.com/raw/Zfjqvyzn"},
        {"Otimização Slow 🐢", "https://pastebin.com/raw/gX2QzCQ4"},
        {"Otimização Linha Transparente 🔗", "https://pastebin.com/raw/RbC506TY"},
        {"Otimização Ultra 🚀", "https://raw.githubusercontent.com/Davzxxfixroblox/DavzxHubFixLag/refs/heads/main/FixLagHub"},
        {"Ping Optimizer 🧟", "https://pastebin.com/raw/kbHL8MZ5"},
        {"Brookhaven Optimization 🧩", "https://pastebin.com/raw/5DK3dz5Y"},
        {"Slow Otimizer 💍", "https://pastefy.app/tSoOifGr/raw"},
        {"Esticar Tela 🖥️", "https://pastefy.app/4Sa0uIve/raw"},
        {"Tira Analógico 🕹️", "https://pastefy.app/AJhzcN5G/raw"},
    }

    for _, otim in ipairs(otimizacoes) do
        MainTab:Button({
            Title = otim[1],
            Locked = false,
            Callback = function() LoadScript(otim[2]) end
        })
    end

    MainTab:Button({
        Title = "Exit Lag Mobile ⛔",
        Locked = false,
        Callback = function()
            pcall(function()
                loadstring(game:HttpGet("https://pastefy.app/KEfkfhsr/raw"))()
            end)
        end
    })

    -- =====================================================
    -- SEÇÃO 8: DIVERSOS
    -- =====================================================
    MainTab:Section({
        Title = "Diversos",
        Icon = "🎯",
    })

    local diversos = {
        {"Limpar Tela 🧹", "https://pastefy.app/FwY4L6qM/raw"},
        {"Teste De Campo 🏑", "https://pastefy.app/dNWJ5ot7/raw"},
        {"Passe Forte 🦵", "https://pastebin.com/raw/2Yw8Bv85"},
        {"Lag Switch 👣", "https://pastefy.app/zZo7yoUB/raw"},
        {"Bug Do Reidorm 👑", "https://pastebin.com/raw/qtsDZHGu"},
        {"Henrique Drible ⚡", "https://pastebin.com/raw/wJKBdV8A"},
        {"Jvz Bug 🥷", "https://pastefy.app/hYyBJna9/raw"},
        {"Condução Theus ⚽", "https://pastefy.app/7FAwfRUX/raw"},
        {"Chute Bomba 💣", "https://pastefy.app/HeRcZpTg/raw"},
        {"Script De Magnetismo 🧲", "https://pastefy.app/SNttOINq/raw"},
    }

    for _, div in ipairs(diversos) do
        MainTab:Button({
            Title = div[1],
            Locked = false,
            Callback = function() LoadScript(div[2]) end
        })
    end

    -- ================= TAB SCRIPTS ALTERNATIVOS =================
    local SATab = MainWindow:Tab({
        Title = "Scripts Alternativos",
        Icon = "🔮",
        Locked = false,
    })

    local alternativos = {
        {"Fly 🍃", "https://pastefy.app/IHIgGN9b/raw"},
        {"Coquette Hub 🎀", "https://rawscripts.net/raw/Brookhaven-RP-Coquette-Hub-41921"},
        {"Hexagon Client 🔘", "https://raw.githubusercontent.com/nxvap/hexagon/refs/heads/main/brookhaven"},
        {"Script De Emotes 🕺", "https://pastefy.app/lAdApmz4/raw"},
        {"Crosshair 🎯", "https://rawscripts.net/raw/Universal-Script-Custom-Crosshair-Gui-237611"},
    }

    for _, alt in ipairs(alternativos) do
        SATab:Button({
            Title = alt[1],
            Locked = false,
            Callback = function() LoadScript(alt[2]) end
        })
    end

    -- ================= TAB CONFIGURAÇÕES =================
    local ConfigTab = MainWindow:Tab({
        Title = "Configurações",
        Icon = "⚙️",
        Locked = false,
    })

    local Camera = workspace.CurrentCamera

    ConfigTab:Slider({
        Title = "FOV",
        Step = 1,
        Value = {
            Min = 20,
            Max = 120,
            Default = 70,
        },
        Callback = function(value)
            pcall(function()
                if Camera then
                    Camera.FieldOfView = value
                end
            end)
        end
    })

    ConfigTab:Slider({
        Title = "Velocidade Speed",
        Step = 1,
        Value = {
            Min = 16,
            Max = 200,
            Default = 16,
        },
        Callback = function(value)
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                local hum = char and char:FindFirstChild("Humanoid")
                if hum then 
                    hum.WalkSpeed = value 
                end
            end)
        end
    })

    ConfigTab:Slider({
        Title = "Força de Pulo Jump",
        Step = 1,
        Value = {
            Min = 50,
            Max = 300,
            Default = 50,
        },
        Callback = function(value)
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                local hum = char and char:FindFirstChild("Humanoid")
                if hum then 
                    hum.JumpPower = value 
                end
            end)
        end
    })

    -- Botão Destruir Interface
    ConfigTab:Button({
        Title = "Destruir Interface 🔨",
        Locked = false,
        Callback = function()
            pcall(function()
                if MainWindow then
                    MainWindow:Destroy()
                end
            end)
        end
    })

    print("💀 Sombra System Carregado com sucesso!")
end
