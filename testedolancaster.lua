-- ============================================================
--                  LANCASTER HUB V2
--             PROFESSIONAL EDITION
-- ============================================================

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local BackgroundImage = "rbxassetid://85878831310179"

-- ============================================================
-- 🥇 TELA DE BOAS-VINDAS
-- ============================================================

local function ShowWelcomeScreen()
    local WelcomeGui = Instance.new("ScreenGui")
    WelcomeGui.Name = "LancasterWelcome"
    WelcomeGui.IgnoreGuiInset = true
    WelcomeGui.ResetOnSpawn = false
    WelcomeGui.DisplayOrder = 999999
    WelcomeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    WelcomeGui.Parent = PlayerGui

    local Background = Instance.new("Frame")
    Background.Size = UDim2.fromScale(1, 1)
    Background.BackgroundColor3 = Color3.fromRGB(5, 6, 10)
    Background.BorderSizePixel = 0
    Background.Parent = WelcomeGui

    local Glow = Instance.new("Frame")
    Glow.AnchorPoint = Vector2.new(0.5, 0.5)
    Glow.Position = UDim2.fromScale(0.5, 0.47)
    Glow.Size = UDim2.fromOffset(260, 260)
    Glow.BackgroundColor3 = Color3.fromRGB(255, 200, 45)
    Glow.BackgroundTransparency = 0.94
    Glow.BorderSizePixel = 0
    Glow.Parent = Background

    local GlowCorner = Instance.new("UICorner")
    GlowCorner.CornerRadius = UDim.new(1, 0)
    GlowCorner.Parent = Glow

    local Card = Instance.new("Frame")
    Card.AnchorPoint = Vector2.new(0.5, 0.5)
    Card.Position = UDim2.fromScale(0.5, 0.48)
    Card.Size = UDim2.fromOffset(420, 205)
    Card.BackgroundColor3 = Color3.fromRGB(13, 14, 20)
    Card.BackgroundTransparency = 1
    Card.BorderSizePixel = 0
    Card.Parent = Background

    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 20)
    CardCorner.Parent = Card

    local CardStroke = Instance.new("UIStroke")
    CardStroke.Thickness = 2
    CardStroke.Color = Color3.fromRGB(255, 200, 50)
    CardStroke.Transparency = 1
    CardStroke.Parent = Card

    local Logo = Instance.new("TextLabel")
    Logo.AnchorPoint = Vector2.new(0.5, 0)
    Logo.Position = UDim2.fromScale(0.5, 0.05)
    Logo.Size = UDim2.fromOffset(90, 75)
    Logo.BackgroundTransparency = 1
    Logo.Text = "🥇"
    Logo.TextScaled = true
    Logo.Font = Enum.Font.GothamBold
    Logo.TextTransparency = 1
    Logo.Parent = Card

    local Title = Instance.new("TextLabel")
    Title.AnchorPoint = Vector2.new(0.5, 0)
    Title.Position = UDim2.fromScale(0.5, 0.37)
    Title.Size = UDim2.fromOffset(440, 42)
    Title.BackgroundTransparency = 1
    Title.Text = "Bem-vindo ao Lancaster Hub!"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextScaled = true
    Title.Font = Enum.Font.GothamBold
    Title.TextTransparency = 1
    Title.Parent = Card

    local Message = Instance.new("TextLabel")
    Message.AnchorPoint = Vector2.new(0.5, 0)
    Message.Position = UDim2.fromScale(0.5, 0.58)
    Message.Size = UDim2.fromOffset(450, 105)
    Message.BackgroundTransparency = 1
    Message.Text =
        "Obrigado por usar o Lancaster Hub! ❤️\n" ..
        "Aproveite os scripts e fique ligado nas próximas atualizações! 🚀\n\n" ..
        "🆕 Nova atualização:\n" ..
        "Retirei os scripts ou corpos que não estavam funcionando e coloquei alguns scripts úteis."
    Message.TextColor3 = Color3.fromRGB(190, 193, 200)
    Message.TextSize = 14
    Message.TextWrapped = true
    Message.Font = Enum.Font.Gotham
    Message.TextTransparency = 1
    Message.Parent = Card

    local Line = Instance.new("Frame")
    Line.AnchorPoint = Vector2.new(0.5, 0)
    Line.Position = UDim2.fromScale(0.5, 0.94)
    Line.Size = UDim2.fromOffset(0, 2)
    Line.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
    Line.BorderSizePixel = 0
    Line.Parent = Card

    TweenService:Create(Card, TweenInfo.new(0.55, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(500, 265),
        BackgroundTransparency = 0.05
    }):Play()

    TweenService:Create(CardStroke, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 0.15
    }):Play()

    task.wait(0.08)
    TweenService:Create(Logo, TweenInfo.new(0.65, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()

    task.wait(0.08)
    TweenService:Create(Title, TweenInfo.new(0.5, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()

    task.wait(0.08)
    TweenService:Create(Message, TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        TextTransparency = 0
    }):Play()

    TweenService:Create(Line, TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(320, 2)
    }):Play()

    task.spawn(function()
        while WelcomeGui.Parent do
            local PulseIn = TweenService:Create(Glow, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.fromOffset(380, 380),
                BackgroundTransparency = 0.97
            })
            local PulseOut = TweenService:Create(Glow, TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.fromOffset(260, 260),
                BackgroundTransparency = 0.94
            })
            PulseIn:Play()
            PulseIn.Completed:Wait()
            if not WelcomeGui.Parent then break end
            PulseOut:Play()
            PulseOut.Completed:Wait()
        end
    end)

    task.wait(5)

    TweenService:Create(Card, TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
        Size = UDim2.fromOffset(530, 280),
        BackgroundTransparency = 1
    }):Play()
    TweenService:Create(CardStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1
    }):Play()
    TweenService:Create(Logo, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    }):Play()
    TweenService:Create(Title, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    }):Play()
    TweenService:Create(Message, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    }):Play()
    TweenService:Create(Line, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(0, 2)
    }):Play()

    task.wait(0.35)
    WelcomeGui:Destroy()
end

ShowWelcomeScreen()

-- ============================================================
-- WINDUI
-- ============================================================

local WindUI = loadstring(game:HttpGet(
    "https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"
))()

-- ============================================================
-- 👑 DONO
-- ============================================================

local OWNER_USER_ID = 7799564650

local function ShowOwnerNotification()
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "👑 LANCASTER HUB",
            Text = "O dono do Lancaster Hub está no servidor!",
            Duration = 8,
        })
    end)
end

local function CheckOwner(player)
    if player and player.UserId == OWNER_USER_ID then
        ShowOwnerNotification()
    end
end

for _, player in ipairs(Players:GetPlayers()) do
    CheckOwner(player)
end

Players.PlayerAdded:Connect(function(player)
    CheckOwner(player)
end)

-- ============================================================
-- 📢 WEBHOOK (NOVO)
-- ============================================================

local WEBHOOK = "https://discord.com/api/webhooks/1551012440693809162/ohuXcXUHhxRGPfKMBVXVfu-9glvmSMENifSksfbOc9AU3x1f7qxsPo_T6RSY6ae7T9y0"

local function SendDiscord(data)
    local requestFunction =
        (syn and syn.request)
        or (http and http.request)
        or request
        or http_request

    if not requestFunction then
        warn("Lancaster Hub: executor sem suporte a HTTP request.")
        return false
    end

    local sucesso, resposta = pcall(function()
        return requestFunction({
            Url = WEBHOOK,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(data)
        })
    end)

    if sucesso then
        return true
    end

    warn("Lancaster Hub: erro no webhook:", resposta)
    return false
end

local function NotifyDiscord()
    local player = Players.LocalPlayer
    if not player then return end

    SendDiscord({
        username = "👑 Lancaster Hub",
        embeds = {{
            title = "╭━━「 👑 LANCASTER HUB 」━━╮",
            description =
                "✨ Lancaster Hub foi executado com sucesso!\n" ..
                "━━━━━━━━━━━━━━━━━━━━\n" ..
                "🎮 Um jogador acaba de utilizar o hub.",
            color = 0x00FFF0,
            fields = {
                {
                    name = "👤・Jogador",
                    value = "Display: " .. tostring(player.DisplayName) .. "\nUsername: " .. tostring(player.Name),
                    inline = true
                },
                {
                    name = "🆔・Identificação",
                    value = "UserId: " .. tostring(player.UserId),
                    inline = true
                },
                {
                    name = "🎮・Jogo",
                    value = "Brookhaven 🏡RP",
                    inline = true
                },
                {
                    name = "🟢・Status",
                    value = "✅ EXECUTADO COM SUCESSO",
                    inline = false
                },
                {
                    name = "🚀・Lancaster Hub",
                    value = "👑 Versão: V2\n💎 Edição: Professional\n🌑 Tema: Dark Glass",
                    inline = false
                }
            },
            footer = {
                text = "🥇 Lancaster Hub • Professional Edition"
            },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    })
end

task.spawn(function()
    if WEBHOOK \~= "COLOQUE_SEU_WEBHOOK_AQUI" then
        NotifyDiscord()
    end
end)

-- ============================================================
-- 🪟 JANELA PRINCIPAL
-- ============================================================

local MainWindow = WindUI:CreateWindow({
    Title = "LANCASTER HUB 🥇",
    Icon = "trophy",
    Author = "Por Lancaster",
    Folder = "LancasterHub",

    Size = UDim2.fromOffset(620, 480),
    MinSize = Vector2.new(580, 380),
    MaxSize = Vector2.new(900, 600),

    Transparent = true,
    Theme = "Dark",
    Resizable = true,
    SideBarWidth = 215,

    Background = BackgroundImage,
    BackgroundImageTransparency = 0.65,
    BackgroundTransparency = 0.02,

    HideSearchBar = true,
    ScrollBarEnabled = false,

    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("Perfil do Lancaster Hub")
        end,
    },

    KeySystem = {
        Title = "Lancaster Hub - Key HWID",

        Note =
            "Key vinculada ao seu nome do Roblox\n" ..
            "Só o dono da key consegue usar",

        SaveKey = true,

        KeyValidator = function(key)
            local playerName = game.Players.LocalPlayer.Name
            local expectedStart = playerName .. "-"

            local isValid = false

            if string.sub(key, 1, #expectedStart) == expectedStart then
                local codigo = string.sub(key, #expectedStart + 1)
                if #codigo >= 6 then
                    isValid = true
                end
            end

            -- Se a key estiver ERRADA, manda webhook
            if not isValid then
                task.spawn(function()
                    SendDiscord({
                        username = "🔐 Lancaster Hub - Key Errada",
                        embeds = {{
                            title = "╭━━「 ❌ KEY INVÁLIDA 」━━╮",
                            description = "Alguém tentou usar uma key que não funcionou.",
                            color = 0xFF0000,
                            fields = {
                                {
                                    name = "👤・Jogador",
                                    value = "Display: " .. tostring(Player.DisplayName) .. "\nUsername: " .. tostring(playerName),
                                    inline = true
                                },
                                {
                                    name = "🆔・UserId",
                                    value = tostring(Player.UserId),
                                    inline = true
                                },
                                {
                                    name = "🔑・Key digitada",
                                    value = "```" .. tostring(key) .. "```",
                                    inline = false
                                }
                            },
                            footer = {
                                text = "Lancaster Hub • Tentativa de Key"
                            },
                            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                        }}
                    })
                end)
            end

            return isValid
        end
    }
})

-- ============================================================
-- ✨ ANIMAÇÃO DO HUB
-- ============================================================

task.spawn(function()
    task.wait(0.20)

    local HubWindow = nil

    local function FindHubWindow(parent)
        for _, obj in ipairs(parent:GetDescendants()) do
            if obj:IsA("GuiObject") then
                local size = obj.AbsoluteSize
                if size.X >= 550 and size.X <= 950 and size.Y >= 400 and size.Y <= 650 then
                    local hasLancaster = false
                    for _, child in ipairs(obj:GetDescendants()) do
                        if child:IsA("TextLabel") and string.find(child.Text, "LANCASTER HUB", 1, true) then
                            hasLancaster = true
                            break
                        end
                    end
                    if hasLancaster then
                        return obj
                    end
                end
            end
        end
        return nil
    end

    HubWindow = FindHubWindow(PlayerGui)

    if not HubWindow then
        pcall(function()
            HubWindow = FindHubWindow(game:GetService("CoreGui"))
        end)
    end

    if not HubWindow then return end

    local Scale = HubWindow:FindFirstChild("LancasterHubAnimationScale")
    if not Scale then
        Scale = Instance.new("UIScale")
        Scale.Name = "LancasterHubAnimationScale"
        Scale.Scale = 0.82
        Scale.Parent = HubWindow
    end

    local EnterTween = TweenService:Create(Scale, TweenInfo.new(0.65, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Scale = 1
    })
    EnterTween:Play()

    EnterTween.Completed:Connect(function()
        if not Scale or not Scale.Parent then return end

        local BounceIn = TweenService:Create(Scale, TweenInfo.new(0.14, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1.025
        })
        BounceIn:Play()

        BounceIn.Completed:Connect(function()
            if Scale and Scale.Parent then
                TweenService:Create(Scale, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Scale = 1
                }):Play()
            end
        end)
    end)
end)

-- ============================================================
-- 🥇 TAGS
-- ============================================================

if Players.LocalPlayer and Players.LocalPlayer.UserId == OWNER_USER_ID then
    MainWindow:Tag({
        Title = "DONO 👑",
        Icon = "crown",
        Color = Color3.fromHex("#FFD700"),
        Radius = 13,
    })
end

MainWindow:Tag({
    Title = "V2",
    Icon = "crown",
    Color = Color3.fromHex("#00FFF0"),
    Radius = 13,
})

MainWindow:Tag({
    Title = "PRO",
    Icon = "sparkles",
    Color = Color3.fromHex("#8B5CF6"),
    Radius = 13,
})

-- ============================================================
-- 🔘 BOTÃO FLUTUANTE
-- ============================================================

MainWindow:EditOpenButton({
    Title = "Lancaster Hub 🥇",
    Icon = "trophy",
    CornerRadius = UDim.new(0, 14),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("#00FFF0"),
        Color3.fromHex("#0066FF")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

-- ============================================================
-- 📜 FUNÇÃO PARA CARREGAR SCRIPTS
-- ============================================================

local function LoadScript(url)
    local success, err = pcall(function()
        local source = game:HttpGet(url)
        local func = loadstring(source)
        if not func then
            error("Não foi possível compilar o script.")
        end
        func()
    end)

    if not success then
        warn("Lancaster Hub - Erro ao carregar script:", err)
        pcall(function()
            StarterGui:SetCore("SendNotification", {
                Title = "❌ Lancaster Hub",
                Text = "Erro ao carregar o script.",
                Duration = 5,
            })
        end)
    end
end

-- ============================================================
-- 📜 ABA 1 — SCRIPTS
-- ============================================================

local MainTab = MainWindow:Tab({
    Title = "Scripts",
    Icon = "layers",
    Locked = false,
})

MainTab:Paragraph({
    Title = "🥇 LANCASTER HUB",
    Desc = "Central de scripts • Interface Professional",
    Image = "trophy",
    ImageSize = 22,
})

MainTab:Section({
    Title = "🎵 TikTok do Lancaster",
    Icon = "music",
})

MainTab:Paragraph({
    Title = "📢 Siga o meu TikTok!",
    Desc = "Siga o meu Tik Tok para mais atualizações e tirar suas dúvidas!",
    Image = "music",
    ImageSize = 22,
})

MainTab:Button({
    Title = "🎵 Seguir no TikTok — @lancastervoltou",
    Callback = function()
        local TikTokURL = "https://www.tiktok.com/@lancastervoltou"
        pcall(function()
            if setclipboard then
                setclipboard(TikTokURL)
                StarterGui:SetCore("SendNotification", {
                    Title = "🎵 TikTok do Lancaster",
                    Text = "Link do TikTok copiado!",
                    Duration = 5,
                })
            else
                StarterGui:SetCore("SendNotification", {
                    Title = "🎵 TikTok do Lancaster",
                    Text = "@lancastervoltou",
                    Duration = 5,
                })
            end
        end)
    end
})

-- ============================================================
-- 🥇 DESTAQUE
-- ============================================================

MainTab:Section({
    Title = "🥇 Destaque",
    Icon = "trophy",
})

MainTab:Button({
    Title = "Condução do Lancaster⚽️",
    Callback = function()
        LoadScript("https://pastebin.com/raw/c27sEpVh")
    end
})

MainTab:Button({
    Title = "Atravessar do Lancaster🙈🙉🙊",
    Desc = "Atravessar do Lancaster • FPS pode cair.",
    Callback = function()
        LoadScript("https://pastefy.app/UyL8ic0V/raw")
    end
})

-- ============================================================
-- ⚽ F
