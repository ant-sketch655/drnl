-- DRNL HUB RP (estável + 3x nos principais)

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
    {nome = "//mat", cmd = "//MAT -[FAMÍLIA DORNELLE] -🇮🇹", vezes = 3},
    {nome = "//Furar pneu", cmd = "//Furar pneu", vezes = 3},
    {nome = "//tiro no rosto", cmd = "//TIRO NO ROSTO -[FAMÍLIA DORNELLE] -🇮🇹", vezes = 3},
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

-- Bolinha arrastável
local bolinha = Instance.new("TextButton")
bolinha.Size = UDim2.new(0, 48, 0, 48)
bolinha.Position = UDim2.new(1, -65, 0.5, -24)
bolinha.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
bolinha.Text = "☰"
bolinha.TextColor3 = Color3.fromRGB(255, 255, 255)
bolinha.Font = Enum.Font.GothamBold
bolinha.TextSize = 22
bolinha.Parent = gui
Instance.new("UICorner", bolinha).CornerRadius = UDim.new(1, 0)

local dragging = false
local dragStart, startPos, hasDragged

bolinha.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        hasDragged = false
        dragStart = input.Position
        startPos = bolinha.Position
    end
end)

bolinha.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
        if not hasDragged then
            main.Visible = not main.Visible
        end
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 5 or math.abs(delta.Y) > 5 then
            hasDragged = true
        end
        bolinha.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

print("✅ DRNL HUB RP carregado!")
