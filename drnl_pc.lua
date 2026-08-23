-- DRNL Keybinds - Bolinha no canto superior direito

print("=== INICIANDO SCRIPT ===")

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local comandos = {
    {nome = "/mat", cmd = "/mat", key = nil, vezes = 3},
    {nome = "/tiro na cabeca", cmd = "/tiro na cabeca", key = nil, vezes = 3},
    {nome = "/tirar comunicacao", cmd = "/tirar comunicacao", key = nil, vezes = 1},
    {nome = "/render", cmd = "/render", key = nil, vezes = 3},
    {nome = "/furar pneu", cmd = "/furar pneu", key = nil, vezes = 3},
    {nome = "/lockpick", cmd = "/lockpick", key = nil, vezes = 1},
    {nome = "/algemar", cmd = "/algemar", key = nil, vezes = 1},
}

local waitingForKey = nil

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

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "DRNLKeybinds"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.Enabled = true

local parented = false
if gethui then
    pcall(function() gui.Parent = gethui() parented = true end)
end
if not parented then
    pcall(function() gui.Parent = game:GetService("CoreGui") parented = true end)
end
if not parented then
    pcall(function() gui.Parent = LocalPlayer:WaitForChild("PlayerGui") parented = true end)
end

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 280, 0, 380)
main.Position = UDim2.new(0.5, -140, 0.5, -190)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "  Configurar Teclas (DRNL)"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 20)
info.Position = UDim2.new(0, 10, 0, 48)
info.BackgroundTransparency = 1
info.Text = "Clique no comando e aperte a tecla"
info.TextColor3 = Color3.fromRGB(170, 170, 170)
info.Font = Enum.Font.Gotham
info.TextSize = 12
info.Parent = main

local buttons = {}

local function atualizarTexto(i)
    local v = comandos[i]
    local keyName = v.key and v.key.Name or "Nenhuma"
    buttons[i].Text = "  " .. v.nome .. "  →  [" .. keyName .. "]"
end

for i, v in ipairs(comandos) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 36)
    btn.Position = UDim2.new(0, 10, 0, 78 + (i-1) * 40)
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = "  " .. v.nome .. "  →  [Nenhuma]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

    buttons[i] = btn

    btn.MouseButton1Click:Connect(function()
        if waitingForKey then
            buttons[waitingForKey].BackgroundColor3 = Color3.fromRGB(45, 45, 45)
            atualizarTexto(waitingForKey)
        end
        waitingForKey = i
        btn.BackgroundColor3 = Color3.fromRGB(0, 140, 70)
        btn.Text = "  " .. v.nome .. "  →  [Pressione a tecla...]"
    end)
end

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 34, 0, 34)
close.Position = UDim2.new(1, -40, 0, 3)
close.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 16
close.Parent = main
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 6)

close.MouseButton1Click:Connect(function()
    main.Visible = false
end)

-- Bolinha no lugar marcado (canto superior direito)
local bolinha = Instance.new("TextButton")
bolinha.Size = UDim2.new(0, 42, 0, 42)
bolinha.Position = UDim2.new(1, -70, 0, 8) -- Posição marcada na imagem
bolinha.BackgroundColor3 = Color3.fromRGB(0, 120, 70)
bolinha.Text = "⌨"
bolinha.TextColor3 = Color3.fromRGB(255, 255, 255)
bolinha.Font = Enum.Font.GothamBold
bolinha.TextSize = 20
bolinha.Parent = gui
Instance.new("UICorner", bolinha).CornerRadius = UDim.new(1, 0)

bolinha.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
        local i = waitingForKey
        comandos[i].key = input.KeyCode
        waitingForKey = nil
        buttons[i].BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        atualizarTexto(i)
        return
    end

    if gameProcessed then return end

    for _, v in ipairs(comandos) do
        if v.key and input.KeyCode == v.key then
            enviar(v.cmd, v.vezes)
            break
        end
    end
end)

print("=== SCRIPT CARREGADO ===")
print("Bolinha no canto superior direito")
