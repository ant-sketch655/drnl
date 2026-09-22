-- DRNL Keybinds para Controle (não PC) - Grok 4 Heavy | Versão HUB MAIOR
-- Menu aumentado para melhor experiência no celular

print("=== INICIANDO SCRIPT PARA CONTROLE - HUB MAIOR ===")

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local comandos = {
    {nome = "/mat", cmd = "/mat", key = nil, vezes = 3},
    {nome = "/tiro na cabeca - 3", cmd = "/tiro na cabeca", key = nil, vezes = 3},
    {nome = "/tiro na cabeça - 1", cmd = "/tiro na cabeça", key = nil, vezes = 1},
    {nome = "/tirar comunicacao", cmd = "/tirar comunicacao", key = nil, vezes = 1},
    {nome = "/render - 3", cmd = "/render", key = nil, vezes = 3},
    {nome = "/render - 1", cmd = "/render", key = nil, vezes = 1},
    {nome = "/furar pneu", cmd = "/furar pneu", key = nil, vezes = 3},
    {nome = "/lockpick", cmd = "/lockpick", key = nil, vezes = 1},
    {nome = "/algemar", cmd = "/algemar", key = nil, vezes = 1},
}

local waitingForKey = nil
local selectedButtonIndex = nil

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
if gethui then pcall(function() gui.Parent = gethui() parented = true end) end
if not parented then pcall(function() gui.Parent = game:GetService("CoreGui") parented = true end) end
if not parented then pcall(function() gui.Parent = LocalPlayer:WaitForChild("PlayerGui") parented = true end) end

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 440)  -- HUB AUMENTADO
main.Position = UDim2.new(0.5, -160, 0.5, -220)
main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
main.BorderSizePixel = 0
main.Visible = false
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 14)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 44)
title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
title.Text = "  Configurar Teclas (DRNL) - Controle"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = main
Instance.new("UICorner", title).CornerRadius = UDim.new(0, 14)

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 20)
info.Position = UDim2.new(0, 10, 0, 54)
info.BackgroundTransparency = 1
info.Text = "Toque no comando e pressione qualquer tecla do controle"
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
    btn.Size = UDim2.new(1, -20, 0, 42)
    btn.Position = UDim2.new(0, 10, 0, 82 + (i-1) * 48)  -- espaçamento aumentado
    btn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    btn.Text = "  " .. v.nome .. "  →  [Nenhuma]"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    buttons[i] = btn

    btn.MouseButton1Click:Connect(function()
        if waitingForKey then
            buttons[waitingForKey].BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        end
        waitingForKey = true
        selectedButtonIndex = i
        btn.BackgroundColor3 = Color3.fromRGB(0, 140, 70)
        btn.Text = "  " .. v.nome .. "  →  [Pressione a tecla...]"
    end)
end

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 36, 0, 36)
close.Position = UDim2.new(1, -46, 0, 4)
close.BackgroundColor3 = Color3.fromRGB(80, 30, 30)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 18
close.Parent = main
Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)

close.MouseButton1Click:Connect(function()
    main.Visible = false
end)

-- Bolinha no canto superior direito
local bolinha = Instance.new("TextButton")
bolinha.Size = UDim2.new(0, 46, 0, 46)
bolinha.Position = UDim2.new(1, -78, 0, 9)
bolinha.BackgroundColor3 = Color3.fromRGB(0, 120, 70)
bolinha.Text = "🎮"
bolinha.TextColor3 = Color3.fromRGB(255, 255, 255)
bolinha.Font = Enum.Font.GothamBold
bolinha.TextSize = 24
bolinha.Parent = gui
Instance.new("UICorner", bolinha).CornerRadius = UDim.new(1, 0)

bolinha.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- ====================== DETECÇÃO COMPLETA ======================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- Tecla do controle
    local isControlKey = 
        input.KeyCode == Enum.KeyCode.ButtonA or 
        input.KeyCode == Enum.KeyCode.ButtonB or 
        input.KeyCode == Enum.KeyCode.ButtonX or 
        input.KeyCode == Enum.KeyCode.ButtonY or 
        input.KeyCode == Enum.KeyCode.ButtonL1 or 
        input.KeyCode == Enum.KeyCode.ButtonR1 or 
        input.KeyCode == Enum.KeyCode.ButtonL2 or 
        input.KeyCode == Enum.KeyCode.ButtonR2 or 
        input.KeyCode == Enum.KeyCode.ButtonStart or 
        input.KeyCode == Enum.KeyCode.ButtonSelect or 
        input.KeyCode == Enum.KeyCode.DPadUp or 
        input.KeyCode == Enum.KeyCode.DPadDown or 
        input.KeyCode == Enum.KeyCode.DPadLeft or 
        input.KeyCode == Enum.KeyCode.DPadRight or 
        input.KeyCode == Enum.KeyCode.Thumbstick1 or 
        input.KeyCode == Enum.KeyCode.Thumbstick2

    if isControlKey and waitingForKey and selectedButtonIndex then
        local i = selectedButtonIndex
        comandos[i].key = input.KeyCode
        waitingForKey = nil
        selectedButtonIndex = nil
        buttons[i].BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        atualizarTexto(i)
        return
    end

    -- Tecla do teclado (backup)
    if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
        local i = selectedButtonIndex
        comandos[i].key = input.KeyCode
        waitingForKey = nil
        selectedButtonIndex = nil
        buttons[i].BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        atualizarTexto(i)
        return
    end

    if gameProcessed then return end

    -- Executa comando
    for _, v in ipairs(comandos) do
        if v.key and input.KeyCode == v.key then
            enviar(v.cmd, v.vezes)
            break
        end
    end
end)

print("=== SCRIPT CARREGADO - HUB MAIOR ATIVADO ===")
print("Bolinha no canto superior direito - Testa aí!")
