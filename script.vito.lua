-- DRNL HUB RP - Muay Thai (estilo detalhado)

print("=== INICIANDO DRNL HUB RP (Muay Thai) ===")

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

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

-- Painel
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 420)
main.Position = UDim2.new(1, -340, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 38)
title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
title.Text = "  DRNL HUB - Muay Thai"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 10)

-- Comandos no estilo da imagem
local comandos = {
    {nome = "//derrubar + arm lock", cmd = "//derrubar no chão + travar no arm lock", vezes = 1},
    {nome = "//antecipa projeção", cmd = "//antecipa a tentativa de projeção e esquiva da linha frontal", vezes = 1},
    {nome = "//gira para as costas", cmd = "//gira rapidamente para as costas aproveitando o desequilíbrio do rival", vezes = 1},
    {nome = "//recua a perna", cmd = "//recua a perna mantendo a linha de visão e evitando o contato direto do judô", vezes = 1},
    {nome = "//palmada no ouvido", cmd = "//aplica uma palmada rápida no ouvido desestabilizando a noção de espaço dele", vezes = 1},
    {nome = "//joelhada no clinch", cmd = "//entra no clinch e aplica joelhada curta no tronco quebrando a postura", vezes = 1},
    {nome = "//chute baixo", cmd = "//desfere chute baixo na coxa interna forçando a abertura da guarda", vezes = 1},
    {nome = "//teep no peito", cmd = "//aplica teep seco no peito empurrando o rival para trás", vezes = 1},
    {nome = "//cotovelada", cmd = "//fecha a distância e desfere cotovelada curta na linha da sobrancelha", vezes = 1},
    {nome = "//mata-leão", cmd = "//passa para as costas e trava o mata-leão com pressão controlada", vezes = 1},
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
    btn.Size = UDim2.new(1, -14, 0, 32)
    btn.Position = UDim2.new(0, 7, 0, 46 + (i-1) * 36)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = "  " .. v.nome
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end)

    btn.MouseButton1Click:Connect(function()
        enviar(v.cmd, v.vezes)
    end)
end

-- Bolinha fixa (mesmo lugar do PC)
local bolinha = Instance.new("TextButton")
bolinha.Size = UDim2.new(0, 42, 0, 42)
bolinha.Position = UDim2.new(1, -70, 0, 8)
bolinha.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
bolinha.Text = "🥊"
bolinha.TextColor3 = Color3.fromRGB(255, 255, 255)
bolinha.Font = Enum.Font.GothamBold
bolinha.TextSize = 20
bolinha.Parent = gui
Instance.new("UICorner", bolinha).CornerRadius = UDim.new(1, 0)

bolinha.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

print("✅ DRNL HUB Muay Thai carregado!")
