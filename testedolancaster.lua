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

    TweenService:Create(Card, TweenInfo.new(
        0.55,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    ), {
        Size = UDim2.fromOffset(500, 265),
        BackgroundTransparency = 0.05
    }):Play()

    TweenService:Create(CardStroke, TweenInfo.new(
        0.45,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        Transparency = 0.15
    }):Play()

    task.wait(0.08)

    TweenService:Create(Logo, TweenInfo.new(
        0.65,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    }):Play()

    task.wait(0.08)

    TweenService:Create(Title, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    }):Play()

    task.wait(0.08)

    TweenService:Create(Message, TweenInfo.new(
        0.65,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    }):Play()

    TweenService:Create(Line, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.Out
    ), {
        Size = UDim2.fromOffset(320, 2)
    }):Play()

    task.spawn(function()

        while WelcomeGui.Parent do

            local PulseIn = TweenService:Create(
                Glow,
                TweenInfo.new(
                    0.9,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut
                ),
                {
                    Size = UDim2.fromOffset(380, 380),
                    BackgroundTransparency = 0.97
                }
            )

            local PulseOut = TweenService:Create(
                Glow,
                TweenInfo.new(
                    0.9,
                    Enum.EasingStyle.Sine,
                    Enum.EasingDirection.InOut
                ),
                {
                    Size = UDim2.fromOffset(260, 260),
                    BackgroundTransparency = 0.94
                }
            )

            PulseIn:Play()
            PulseIn.Completed:Wait()

            if not WelcomeGui.Parent then
                break
            end

            PulseOut:Play()
            PulseOut.Completed:Wait()
        end

    end)

    task.wait(5)

    TweenService:Create(Card, TweenInfo.new(
        0.35,
        Enum.EasingStyle.Quint,
        Enum.EasingDirection.In
    ), {
        Size = UDim2.fromOffset(530, 280),
        BackgroundTransparency = 1
    }):Play()

    TweenService:Create(CardStroke, TweenInfo.new(
        0.25,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        Transparency = 1
    }):Play()

    TweenService:Create(Logo, TweenInfo.new(
        0.25,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        TextTransparency = 1
    }):Play()

    TweenService:Create(Title, TweenInfo.new(
        0.25,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        TextTransparency = 1
    }):Play()

    TweenService:Create(Message, TweenInfo.new(
        0.2,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        TextTransparency = 1
    }):Play()

    TweenService:Create(Line, TweenInfo.new(
        0.2,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
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

        StarterGui:SetCore(
            "SendNotification",
            {
                Title = "👑 LANCASTER HUB",
                Text = "O dono do Lancaster Hub está no servidor!",
                Duration = 8,
            }
        )

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
-- 📢 WEBHOOK
-- ============================================================

local WEBHOOK = "https://discord.com/api/webhooks/1550549897588113619/yieQgHFG9DY6Be06Do7grclQI5h121HCh8VeLk84iK4h1HQWb_IChpmBOdU3QKjXtYqQ"

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

    if not player then
        return
    end

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
                    value =
                        "Display: " ..
                        tostring(player.DisplayName) ..
                        "\nUsername: " ..
                        tostring(player.Name),
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
                    value =
                        "👑 Versão: V2\n" ..
                        "💎 Edição: Professional\n" ..
                        "🌑 Tema: Dark Glass",
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

    if WEBHOOK ~= "COLOQUE_SEU_WEBHOOK_AQUI" then
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

        Enabled = true,

        Title = "Lancaster Hub - Key HWID",

        Key = {
            "quemnaoxitanaobrilha"
        },

        Note =
            "Key vinculada ao seu nome do Roblox\n" ..
            "Só você consegue usar • ninguém rouba",

        SaveKey = true,
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

                if size.X >= 550
                    and size.X <= 950
                    and size.Y >= 400
                    and size.Y <= 650 then

                    local hasLancaster = false

                    for _, child in ipairs(obj:GetDescendants()) do

                        if child:IsA("TextLabel")
                            and string.find(
                                child.Text,
                                "LANCASTER HUB",
                                1,
                                true
                            ) then

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

            HubWindow = FindHubWindow(
                game:GetService("CoreGui")
            )

        end)

    end

    if not HubWindow then
        return
    end

    local Scale = HubWindow:FindFirstChild(
        "LancasterHubAnimationScale"
    )

    if not Scale then

        Scale = Instance.new("UIScale")
        Scale.Name = "LancasterHubAnimationScale"
        Scale.Scale = 0.82
        Scale.Parent = HubWindow

    end

    local EnterTween = TweenService:Create(
        Scale,
        TweenInfo.new(
            0.65,
            Enum.EasingStyle.Quint,
            Enum.EasingDirection.Out
        ),
        {
            Scale = 1
        }
    )

    EnterTween:Play()

    EnterTween.Completed:Connect(function()

        if not Scale or not Scale.Parent then
            return
        end

        local BounceIn = TweenService:Create(
            Scale,
            TweenInfo.new(
                0.14,
                Enum.EasingStyle.Back,
                Enum.EasingDirection.Out
            ),
            {
                Scale = 1.025
            }
        )

        BounceIn:Play()

        BounceIn.Completed:Connect(function()

            if Scale and Scale.Parent then

                TweenService:Create(
                    Scale,
                    TweenInfo.new(
                        0.12,
                        Enum.EasingStyle.Quad,
                        Enum.EasingDirection.Out
                    ),
                    {
                        Scale = 1
                    }
                ):Play()

            end

        end)

    end)

end)

-- ============================================================
-- 🥇 TAGS
-- ============================================================

if Players.LocalPlayer
    and Players.LocalPlayer.UserId == OWNER_USER_ID then

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

        warn(
            "Lancaster Hub - Erro ao carregar script:",
            err
        )

        pcall(function()

            StarterGui:SetCore(
                "SendNotification",
                {
                    Title = "❌ Lancaster Hub",
                    Text = "Erro ao carregar o script.",
                    Duration = 5,
                }
            )

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

        local TikTokURL =
            "https://www.tiktok.com/@lancastervoltou"

        pcall(function()

            if setclipboard then

                setclipboard(TikTokURL)

                StarterGui:SetCore(
                    "SendNotification",
                    {
                        Title = "🎵 TikTok do Lancaster",
                        Text = "Link do TikTok copiado!",
                        Duration = 5,
                    }
                )

            else

                StarterGui:SetCore(
                    "SendNotification",
                    {
                        Title = "🎵 TikTok do Lancaster",
                        Text = "@lancastervoltou",
                        Duration = 5,
                    }
                )

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

        LoadScript(
            "https://pastebin.com/raw/c27sEpVh"
        )

    end

})

MainTab:Button({

    Title = "Atravessar do Lancaster🙈🙉🙊",

    Desc = "Atravessar do Lancaster • FPS pode cair.",

    Callback = function()

        LoadScript(
            "https://pastefy.app/UyL8ic0V/raw"
        )

    end

})

-- ============================================================
-- ⚽ FUTEBOL / BOLA
-- ============================================================

MainTab:Section({

    Title = "⚽ Futebol / Bola",
    Icon = "circle",

})

local FutebolScripts = {

    {"Bola Chiclete⚽️", "https://pastefy.app/ZMHWh8kW/raw"},
    {"Anti Atravessar Soccer Tool⚽", "https://pastebin.com/raw/LYWJ6sfF"},
    {"Football Master V5 Pro⚽", "https://pastefy.app/77ScQkbz/raw"},
    {"Chute Bomba💣", "https://pastefy.app/HeRcZpTg/raw"},

    -- NOVOS DO ZYCK
    {"Soccer Dribble Hub ⚡️", "https://pastebin.com/raw/gwZKjbVM"},
    {"Passe Forte🦵", "https://pastebin.com/raw/2Yw8Bv85"},
    {"Condução Theus⚽", "https://pastefy.app/7FAwfRUX/raw"},
    {"Anti Ball Pedra⚽", "https://pastefy.app/59dDHHfr/raw"},
    {"Football Master V7⚽", "https://pastefy.app/I9nocuO2/raw"},
    {"Hub Da Leandrinha⚽️", "https://pastebin.com/raw/q5CxCNyi"},

}

for _, data in ipairs(FutebolScripts) do

    MainTab:Button({

        Title = data[1],

        Callback = function()
            LoadScript(data[2])
        end

    })

end

-- ============================================================
-- 👻 ATRAVESSAR / NOCLIP
-- ============================================================

MainTab:Section({

    Title = "👻 Atravessar / Noclip",
    Icon = "ghost",

})

local AtravessarScripts = {

    {"Atravessar Simples🔥", "https://pastebin.com/raw/D15v30nW"},
    {"Atravessar Theus 👻", "https://pastefy.app/7e1VxPgW/raw"},

    -- NOVOS DO ZYCK
    {"PJ Atravessa 🧧", "https://pastefy.app/CrhmqFtx/raw"},
    {"Atravessar V12🟣", "https://pastebin.com/raw/GZn1L0PM"},
    {"Oliver Atravessador 🗡", "https://rawscripts.net/raw/Universal-Script-Script-de-atravessar-56285"},
    {"Noclip Injusto + Reach 900 studs🔥", "https://pastebin.com/raw/hfrDcUm8"},
    {"Anti Ball Pedra + Atravessar⚽", "https://pastebin.com/raw/Z7eZDEj8"},

}

for _, data in ipairs(AtravessarScripts) do

    MainTab:Button({

        Title = data[1],

        Callback = function()
            LoadScript(data[2])
        end

    })

end

-- ============================================================
-- 🧤 GOLEIRO / DEFESA
-- ============================================================

MainTab:Section({

    Title = "🧤 Goleiro / Defesa",
    Icon = "shield",

})

local GoleiroScripts = {

    {"Muralha Hub🧱", "https://pastebin.com/raw/UxtmMHm1"},
    {"Goleiro Hub (Rayfield)🧤", "https://pastefy.app/cogJvYif/raw"},
    {"Legendary Defender ⚔️", "https://pastebin.com/raw/s91y0AFs"},

    -- NOVOS DO ZYCK
    {"GK Hub (Goleiro Deitado)🧤", "https://pastebin.com/raw/FaBkfBHr"},
    {"Yashin Ultra🧤", "https://pastebin.com/raw/KmNHLYsb"},
    {"Puyol V3 ⚡️", "https://pastebin.com/raw/bMLRRKwG"},

}

for _, data in ipairs(GoleiroScripts) do

    MainTab:Button({

        Title = data[1],

        Callback = function()
            LoadScript(data[2])
        end

    })

end

-- ============================================================
-- 🏃 MOVIMENTO / REACH / BUGS
-- ============================================================

MainTab:Section({

    Title = "🏃 Movimento / Reach / Bugs",
    Icon = "zap",

})

local MovimentoScripts = {

    {"Reach The Void🌑", "https://pastebin.com/raw/HyAUVhnP"},
    {"Ghost + Reach👻", "https://pastebin.com/raw/1if0pn7x"},
    {"Henrique Drible⚡", "https://pastebin.com/raw/wJKBdV8A"},
    {"Jvz Bug🥷", "https://pastefy.app/hYyBJna/raw"},
    {"Bug Do reidorm👑", "https://pastebin.com/raw/qtsDZHGu"},
    {"Pedrizz Bug⚡️", "https://pastebin.com/raw/28LDYic2"},
    {"Mtzin Pro Max⚡", "https://pastebin.com/raw/kCKEhh99"},
    {"Lag Switch👣", "https://pastefy.app/zZo7yoUB/raw"},
    {"Glitch Infinity♾️", "https://pastebin.com/raw/FpPh3UhN"},

    -- NOVOS DO ZYCK
    {"Theus Reach V2 🦿", "https://pastebin.com/raw/pm4pyxm4"},
    {"Reach Do Theus🦿", "https://pastefy.app/tSYVNcwc/raw"},

}

for _, data in ipairs(MovimentoScripts) do

    MainTab:Button({

        Title = data[1],

        Callback = function()
            LoadScript(data[2])
        end

    })

end

-- ============================================================
-- 🏡 BROOKHAVEN
-- ============================================================

MainTab:Section({

    Title = "🏡 Brookhaven",
    Icon = "home",

})

local BrookhavenScripts = {

    {"Brookhaven Ultimate🏡", "https://pastefy.app/Ul55j8hu/raw"},
    {"Brookhaven Painel V2🏠", "https://pastebin.com/raw/m70Y67h9"},
    {"Brookhaven Optimization🧩", "https://pastebin.com/raw/5DK3dz5Y"},
    {"Brookhaven Panel🏠", "https://pastefy.app/RGPRtmRg/raw"},
    {"Brazilian Panel🇧🇷", "https://pastebin.com/raw/x5XX9kiK"},
    {"Brazilian Panel V2 🇧🇷", "https://pastebin.com/raw/geau1Zy7"},

}

for _, data in ipairs(BrookhavenScripts) do

    MainTab:Button({

        Title = data[1],

        Callback = function()
            LoadScript(data[2])
        end

    })

end

-- ============================================================
-- 🚀 OTIMIZAÇÃO
-- ============================================================

MainTab:Section({

    Title = "🚀 Otimização",
    Icon = "rocket",

})

local OtimizacaoScripts = {

    {"Otimização🚀", "https://raw.githubusercontent.com/Davzxxfixroblox/DavzxHubFixLag/refs/heads/main/FixLagHub"},
    {"Ping Optimizer🧟‍♂️", "https://pastebin.com/raw/kbHL8MZ5"},
    {"Esticar Tela 🖥", "https://pastefy.app/4Sa0uIve/raw"},
    {"Limpar Tela 💻", "https://pastefy.app/FwY4L6qM/raw"},

    -- NOVOS DO ZYCK
    {"Mega Otimização Brookhaven 🏠", "https://pastebin.com/raw/GzrqQWkx"},
    {"Otimização Linha Transparente 🔗", "https://pastebin.com/raw/RbC506TY"},

}

for _, data in ipairs(OtimizacaoScripts) do

    MainTab:Button({

        Title = data[1],

        Callback = function()
            LoadScript(data[2])
        end

    })

end

-- ============================================================
-- 🎨 HUBS / PAINÉIS
-- ============================================================

MainTab:Section({

    Title = "🎨 Hubs / Painéis",
    Icon = "layout-dashboard",

})

local HubsScripts = {

    {"Nova Era Hub💎", "https://pastefy.app/zrszTIQx/raw"},
    {"Zyck 4.5 🇺🇸", "https://pastefy.app/P2eNOBe2/raw"},
    {"Gui Prime Pro⚽️", "https://pastebin.com/raw/xgkQc7Q9"},
    {"K4y The Promission☠️", "https://pastefy.app/Of3pO501/raw"},
    {"LP Scripts✔️", "https://gist.githubusercontent.com/yesn20456-crypto/af368f3184c1d34a8f4a9e33d4325d0d/raw/60e8309b99f9e002a55005b2d7905a82b90b70f1/gistfile1.txt"},
    {"Armando Jr Hub🔥", "https://raw.githubusercontent.com/carlosedut11/ArmadinhoJrPorCantonaJr/refs/heads/main/ArmadinhoJrPorCantonaJr.lua"},
    {"Lucas Hub😈", "https://pastebin.com/raw/xmbL5T3i"},
    {"Painel do Kayne🔥", "https://pastebin.com/raw/Frxjj6my"},
    {"Kayne Supremo🔥", "https://pastebin.com/raw/xyS7KQdY"},
    {"Theus Hub🍎", "https://pastefy.app/bib1MRS8/raw"},
    {"Matteo Hub ❄️", "https://pastefy.app/Pvf3lqmJ/raw"},
    {"Gotto Hub⚽", "https://pastefy.app/EOizRmIz/raw"},
    {"Loved Hub🍷", "https://pastefy.app/AccDN8CV/raw"},
    {"Painel Spider V2🕷", "https://pastefy.app/LvYw31OO/raw"},
    {"Angel Hub😇", "https://pastefy.app/679CyrEi/raw"},
    {"Samuzx Hub🥶", "https://pastefy.app/yOVyrBNy/raw"},
    {"Script do Spider V1🕷", "https://pastefy.app/hutJntDN/raw"},
    {"Script do Freezer🧊", "https://pastefy.app/bWS31I8q/raw"},
    {"Papai Cris Menu❤️", "https://pastefy.app/jI58Il0a/raw"},
    {"Hunk Hub🫂", "https://pastefy.app/ZGDUJNWr/raw"},
    {"Slow Hub 🐌", "https://pastefy.app/tSoOifGr/raw"},
    {"Drinho Hub 🎯", "https://pastefy.app/KEfkfhsr/raw"},

    -- NOVOS DO ZYCK
    {"Lukinhas Hub 💙", "https://pastebin.com/raw/dhxQnF4b"},
    {"Pirulito Hub 🍭", "https://pastebin.com/raw/A0xCHTGM"},
    {"Toni Kroos 🍀", "https://pastebin.com/raw/bCL22UZw"},
    {"X10 Premium Hub 💎", "https://pastebin.com/raw/MW2Zyv6z"},
    {"Fire Hub🔥", "https://pastebin.com/raw/iVp2tnCR"},
    {"Sforza Hub🔧", "https://pastebin.com/raw/pdyfSjzK"},
    {"Zyck ☠️", "https://pastebin.com/raw/WYeG9ypc"},
    {"Abençoado 777 👼", "https://raw.githubusercontent.com/admpietrovinicius-debug/Aben-oado-777/refs/heads/main/Aben%C3%A7oado777.lua"},
    {"Water Hub🌊", "https://pastefy.app/iQzbaBGE/raw"},
    {"Six Hub 6️⃣", "https://pastebin.com/raw/MDhqkib4"},

}

for _, data in ipairs(HubsScripts) do

    MainTab:Button({

        Title = data[1],

        Callback = function()
            LoadScript(data[2])
        end

    })

end

-- ============================================================
-- 🧩 OUTROS
-- ============================================================

MainTab:Section({

    Title = "🧩 Outros",
    Icon = "box",

})

local OutrosScripts = {

    {"Script Da Debinha🥀", "https://pastefy.app/9k4tL5Q7/raw"},
    {"Hotdog V4 🌭", "https://pastefy.app/GzxmSIIn/raw"},
    {"Tira Analógico 🕹", "https://pastefy.app/AJhzcN5G/raw"},
    {"Tubaina Hub 🥶", "https://pastefy.app/xLM92mP5/raw"},
    {"Script do Kay V2🔥", "https://pastebin.com/raw/eXGuwWWE"},
    {"DD Osama V5 🇺🇸", "https://pastebin.com/raw/NxpP7iWb"},
    {"Fuzzy Bugs ♟️", "https://pastefy.app/rsiBF3CL/raw"},
    {"Anti Roubo Bola ⚽️\n🔑 Key: KWLS", "https://pastebin.com/raw/4GXQEjAs"},
    {"Sixxinho Hub 🔒\n🔑 Key: SWGK", "https://raw.githubusercontent.com/josegaviao888-alt/Six-Hub-Privdo/refs/heads/main/Six%20hUB"},
    {"X Hub ❌️", "https://pastefy.app/yXuzlTpQ/raw"},

    -- NOVOS DO ZYCK
    {"Caga Na Roupa Hub 💩", "https://pastefy.app/eKFExNPG/raw"},
    {"Anti Pulo Foldenxz 🚫", "https://pastebin.com/raw/d2T3QxGt"},
    {"Anti Pulo Elias 🚫", "https://pastebin.com/raw/mgzrnsbr"},
    {"Zyck Anti Pulo 🚫", "https://pastebin.com/raw/MCTcaHZq"},

}

for _, data in ipairs(OutrosScripts) do

    MainTab:Button({

        Title = data[1],

        Callback = function()
            LoadScript(data[2])
        end

    })

end

-- ============================================================
-- ⭐ ABA 2 — SCRIPTS QUE EU USO
-- ============================================================

local MeusScriptsTab = MainWindow:Tab({

    Title = "Scripts que eu uso",
    Icon = "star",
    Locked = false,

})

MeusScriptsTab:Paragraph({

    Title = "⭐ SCRIPTS QUE EU USO",
    Desc = "Scripts que eu mais utilizo no Lancaster Hub.",
    Image = "star",
    ImageSize = 22,

})

MeusScriptsTab:Section({

    Title = "🔥 Meus favoritos",
    Icon = "heart",

})

MeusScriptsTab:Button({

    Title = "Condução do Lancaster⚽️",
    Desc = "Script de condução da bola.",

    Callback = function()

        LoadScript(
            "https://pastebin.com/raw/c27sEpVh"
        )

    end

})

MeusScriptsTab:Button({

    Title = "Atravessar do Lancaster🙈🙉🙊",
    Desc = "Atravessar do Lancaster • FPS pode cair.",

    Callback = function()

        LoadScript(
            "https://pastefy.app/UyL8ic0V/raw"
        )

    end

})

MeusScriptsTab:Button({

    Title = "Lag Switch👣",
    Desc = "Lag Switch utilizado na aba de scripts.",

    Callback = function()

        LoadScript(
            "https://pastefy.app/zZo7yoUB/raw"
        )

    end

})

MeusScriptsTab:Button({

    Title = "Ping Optimizer🧟‍♂️",
    Desc = "Otimizador de ping.",

    Callback = function()

        LoadScript(
            "https://pastebin.com/raw/kbHL8MZ5"
        )

    end

})

MeusScriptsTab:Button({

    Title = "Loved Hub🍷",
    Desc = "Loved Hub.",

    Callback = function()

        LoadScript(
            "https://pastefy.app/AccDN8CV/raw"
        )

    end

})

MeusScriptsTab:Section({

    Title = "📌 Acesso rápido",
    Icon = "zap",

})

MeusScriptsTab:Paragraph({

    Title = "🥇 Lancaster Hub",

    Desc =
        "Aqui ficam os scripts que eu mais uso, " ..
        "organizados para acesso rápido.",

    Image = "trophy",
    ImageSize = 22,

})

-- ============================================================
-- 👤 ABA 3 — CORPOS
-- ============================================================

local CorposTab = MainWindow:Tab({

    Title = "Corpos",
    Icon = "user",
    Locked = false,

})

CorposTab:Paragraph({

    Title = "👤 CORPOS",

    Desc = "Corpos organizados por categoria. Toque no botão para copiar o código.",

    Image = "user",
    ImageSize = 22,

})

local function CopiarCorpo(nome, codigo)

    if setclipboard then

        local sucesso = pcall(function()
            setclipboard(codigo)
        end)

        if sucesso then

            pcall(function()

                StarterGui:SetCore(
                    "SendNotification",
                    {
                        Title = "📋 Corpo copiado!",
                        Text = nome,
                        Duration = 4,
                    }
                )

            end)

            return
        end
    end

    pcall(function()

        StarterGui:SetCore(
            "SendNotification",
            {
                Title = "❌ Não foi possível copiar",
                Text = "Seu executor não possui suporte a clipboard.",
                Duration = 5,
            }
        )

    end)

end

-- ============================================================
-- 🛡️ GK / ZAG
-- ============================================================

CorposTab:Section({

    Title = "🛡️ GK / ZAG",
    Icon = "shield",

})

local CorposGKZAG = {

    {
        "Ansu (ZAG)",
        "BH-AE-0a0faa266e97436e87a18ed0fa2ad5bc"
    },

    {
        "ZAG",
        "BH-AE-6360ccf2403f4fe6b784a90602f1850a"
    },

    {
        "ZAG com Reach",
        "BH-AE-6360ccf2403f4fe6b784a90602f1850a"
    },

    {
        "GK",
        "BH-AE-67c064e4deff4a1e908d041a46a537c3"
    },

}

for _, data in ipairs(CorposGKZAG) do

    CorposTab:Button({

        Title = "📋 " .. data[1],
        Desc = data[2],

        Callback = function()

            CopiarCorpo(
                data[1],
                data[2]
            )

        end

    })

end

-- ============================================================
-- ⚡ ATK
-- ============================================================

CorposTab:Section({

    Title = "⚡ ATK",
    Icon = "zap",

})

local CorposATK = {

    {
        "Kayne Atual",
        "BH-AE-ba2db28f95844fd7bc2f704006513845"
    },

    {
        "DDeus Antigo",
        "BH-AE-4f8f0b5764b546f886c787115766aa9d"
    },

    {
        "Veloso",
        "BH-AE-6d8f515ae2af4d39a7285398a1ce19b9"
    },

    {
        "Gerard",
        "BH-AE-e929a39d778742ce961140b27331e058"
    },

    {
        "Gusta",
        "BH-AE-c7f95dd67921416db5b33d9470d63741"
    },

    {
        "Gavi S4",
        "BH-AE-598426a8e0c74a37bc3c7fe61059e4e3"
    },

    {
        "Berry Atualizado (Vasco)",
        "BH-AE-3a6c2a069d0b4d26b2df75bd652524e5"
    },

    {
        "Pirulito (Atlético PR)",
        "BH-AE-e4fd3e7f628e415a8225689214181fd4"
    },

}

for _, data in ipairs(CorposATK) do

    CorposTab:Button({

        Title = "📋 " .. data[1],
        Desc = data[2],

        Callback = function()

            CopiarCorpo(
                data[1],
                data[2]
            )

        end

    })

end

-- ============================================================
-- 🎯 MC
-- ============================================================

CorposTab:Section({

    Title = "🎯 MC",
    Icon = "crosshair",

})

local CorposMC = {

    {
        "Tony Filho — Real Madrid",
        "BH-AE-23ccc01c44a34a44b939d18f5c85e08c"
    },

    {
        "JZ7",
        "BH-AE-f9b842acae964316975b983e003f43ec"
    },

    {
        "Drinho (OFC)",
        "BH-AE-13f56612330c42ceafa09baeaf6489de"
    },

}

for _, data in ipairs(CorposMC) do

    CorposTab:Button({

        Title = "📋 " .. data[1],
        Desc = data[2],

        Callback = function()

            CopiarCorpo(
                data[1],
                data[2]
            )

        end

    })

end

-- ============================================================
-- 🛡️ ABA 4 — SCRIPTS ALTERNATIVOS
-- ============================================================

local SATab = MainWindow:Tab({

    Title = "Scripts Alternativos",
    Icon = "shield",
    Locked = false,

})

SATab:Paragraph({

    Title = "🛡 SCRIPTS ALTERNATIVOS",
    Desc = "Ferramentas adicionais do Lancaster Hub",
    Image = "shield",
    ImageSize = 22,

})

local AlternativeScripts = {

    {"Fly🍃", "https://pastefy.app/IHIgGN9b/raw"},
    {"Coquette Hub🎀", "https://rawscripts.net/raw/Brookhaven-RP-Coquette-Hub-41921"},
    {"Hexagon Client🔘", "https://raw.githubusercontent.com/nxvap/hexagon/refs/heads/main/brookhaven"},
    {"Script De Emotes🕺", "https://pastefy.app/lAdApmz4/raw"},

}

for _, data in ipairs(AlternativeScripts) do

    SATab:Button({

        Title = data[1],

        Callback = function()
            LoadScript(data[2])
        end

    })

end

-- ============================================================
-- ⚙️ ABA 5 — CONFIGURAÇÕES
-- ============================================================

local ConfigTab = MainWindow:Tab({

    Title = "Configurações",
    Icon = "settings",
    Locked = false,

})

ConfigTab:Paragraph({

    Title = "⚙️ CONFIGURAÇÕES",
    Desc = "Personalize sua experiência no Lancaster Hub",
    Image = "settings",
    ImageSize = 22,

})

local Camera = workspace.CurrentCamera

ConfigTab:Section({

    Title = "Câmera",
    Icon = "camera",

})

ConfigTab:Slider({

    Title = "FOV",
    Step = 1,

    Value = {
        Min = 20,
        Max = 120,
        Default = 70,
    },

    Callback = function(value)

        if Camera then
            Camera.FieldOfView = value
        end

    end

})

ConfigTab:Section({

    Title = "Jogador",
    Icon = "user",

})

ConfigTab:Slider({

    Title = "Velocidade (Speed)",
    Step = 1,

    Value = {
        Min = 16,
        Max = 200,
        Default = 16,
    },

    Callback = function(value)

        local char = Players.LocalPlayer.Character

        local hum =
            char and char:FindFirstChild("Humanoid")

        if hum then
            hum.WalkSpeed = value
        end

    end

})

ConfigTab:Slider({

    Title = "Força de Pulo (Jump)",
    Step = 1,

    Value = {
        Min = 50,
        Max = 300,
        Default = 50,
    },

    Callback = function(value)

        local char = Players.LocalPlayer.Character

        local hum =
            char and char:FindFirstChild("Humanoid")

        if hum then
            hum.JumpPower = value
        end

    end

})

ConfigTab:Section({

    Title = "Interface",
    Icon = "palette",

})

ConfigTab:Slider({

    Title = "Transparência do Fundo",
    Step = 0.05,

    Value = {
        Min = 0,
        Max = 1,
        Default = 0.65,
    },

    Callback = function(value)

        pcall(function()
            MainWindow:SetBackgroundImageTransparency(value)
        end)

    end

})

ConfigTab:Button({

    Title = "Destruir Interface 🔨",

    Callback = function()

        pcall(function()
            MainWindow:Destroy()
        end)

    end

})

-- ============================================================
-- 💡 ABA 6 — SUGESTÕES
-- ============================================================

local SugestoesTab = MainWindow:Tab({

    Title = "Sugestões",
    Icon = "lightbulb",
    Locked = false,

})

SugestoesTab:Paragraph({

    Title = "💡 CAIXA DE SUGESTÕES",

    Desc =
        "Ajude a melhorar o Lancaster Hub enviando sua sugestão.",

    Image = "lightbulb",
    ImageSize = 22,

})

SugestoesTab:Section({

    Title = "📝 Sua sugestão",
    Icon = "message-square",

})

local SugestaoTexto = ""

SugestoesTab:Input({

    Title = "Escreva sua sugestão",

    Desc =
        "Digite aqui o que podemos melhorar ou adicionar.",

    Placeholder =
        "Ex: Adicionar novos scripts...",

    Callback = function(value)

        SugestaoTexto =
            tostring(value or "")

    end

})

SugestoesTab:Button({

    Title = "📤 Enviar Sugestão",

    Callback = function()

        local player = Players.LocalPlayer

        if not player then
            return
        end

        if SugestaoTexto == ""
            or #SugestaoTexto < 3 then

            pcall(function()

                StarterGui:SetCore(
                    "SendNotification",
                    {
                        Title = "💡 Lancaster Hub",
                        Text = "Digite uma sugestão antes de enviar.",
                        Duration = 5,
                    }
                )

            end)

            return
        end

        local mensagem = {

            username = "💡 Lancaster Hub",

            embeds = {{

                title =
                    "╭━━「 💡 NOVA SUGESTÃO 」━━╮",

                description =
                    "📝 Uma nova sugestão foi enviada para o Lancaster Hub.\n\n" ..
                    "💬 **Sugestão:**\n" ..
                    SugestaoTexto,

                color = 0x8B5CF6,

                fields = {

                    {
                        name = "👤・Jogador",

                        value =
                            "Display: " ..
                            tostring(player.DisplayName) ..
                            "\nUsername: " ..
                            tostring(player.Name),

                        inline = true
                    },

                    {
                        name = "🆔・UserId",

                        value =
                            tostring(player.UserId),

                        inline = true
                    }

                },

                footer = {
                    text =
                        "🥇 Lancaster Hub • Caixa de Sugestões"
                },

                timestamp =
                    os.date("!%Y-%m-%dT%H:%M:%SZ")

            }}

        }

        local sucesso =
            SendDiscord(mensagem)

        if sucesso then

            SugestaoTexto = ""

            pcall(function()

                StarterGui:SetCore(
                    "SendNotification",
                    {
                        Title = "✅ Sugestão enviada!",
                        Text = "Obrigado por ajudar a melhorar o Lancaster Hub!",
                        Duration = 6,
                    }
                )

            end)

        else

            pcall(function()

                StarterGui:SetCore(
                    "SendNotification",
                    {
                        Title = "❌ Erro",
                        Text = "Não foi possível enviar a sugestão.",
                        Duration = 6,
                    }
                )

            end)

        end

    end

})

SugestoesTab:Paragraph({

    Title = "🥇 Lancaster Hub",

    Desc =
        "Sua opinião ajuda a trazer novas funções, melhorias e atualizações.",

    Image = "trophy",
    ImageSize = 22,

})

-- ============================================================
-- 🥇 FINAL
-- ============================================================

print("╔══════════════════════════════════════╗")
print("║ LANCASTER HUB V2 CARREGADO           ║")
print("║ PROFESSIONAL EDITION                 ║")
print("║ DARK GLASS EDITION                   ║")
print("║ DONO SYSTEM ON 👑                    ║")
print("║ KEY HWID ON 🔐                       ║")
print("║ TIKTOK: @lancastervoltou 🎵          ║")
print("║ SCRIPTS QUE EU USO → ATIVADA ⭐      ║")
print("║ SUGESTÕES → DISCORD 💡               ║")
print("║ CORPOS → GK/ZAG • ATK • MC 👤        ║")
print("║ WELCOME SCREEN → ATIVADA 🥇          ║")
print("║ HUB ANIMATION → ATIVADA ✨           ║")
print("║ ATUALIZAÇÃO → TELA DE ABERTURA 🆕   ║")
print("║ NOVOS SCRIPTS DO ZYCK → ADICIONADOS ║")
print("╚══════════════════════════════════════╝")
