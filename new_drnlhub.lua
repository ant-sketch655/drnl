-- DRNL HUB RP (bolinha fixa igual ao de PC)

print("=== INICIANDO DRNL HUB RP ===")

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

local comandos = {
    {nome = "//armar c4", cmd = "//Armar C4", vezes = 1},
    {nome = "//ativar c4", cmd = "//Ativar C4", vezes = 1},
    {nome = "//mat", cmd = "/TIRO NA CABEÇA", vezes = 3},
    {nome = "//Furar pneu", cmd = "//Furar pneu", vezes = 3},
    {nome = "//tiro no rosto", cmd = "//TIRO NO ROSTO -[FAMÍLIA DORNELLE]-🇮🇹", vezes = 3},
    {nome = "//Derrubar no chão", cmd = "//Derrubar no chão", vezes = 1},
    {nome = "//Render", cmd = "//Render", vezes = 3},
    {nome = "//mata leão", cmd = "//Mata leão", vezes = 1},
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

-- Bolinha FIXA no mesmo lugar do script de PC (canto superior direito)
local bolinha = Instance.new("TextButton")
bolinha.Size = UDim2.new(0, 42, 0, 42)
bolinha.Position = UDim2.new(1, -70, 0, 8) -- Mesma posição do PC
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
