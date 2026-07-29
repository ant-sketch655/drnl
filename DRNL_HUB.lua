-- DRNL HUB RP (bolinha arrastável)

local success, err = pcall(function()
    local UserInputService = game:GetService("UserInputService")

    local gui = Instance.new("ScreenGui")
    gui.Name = "DRNLHUBRP"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.IgnoreGuiInset = true
    gui.DisplayOrder = 999999

    if gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game:GetService("CoreGui")
    end

    -- Painel principal (começa fechado)
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 170, 0, 380)
    main.Position = UDim2.new(1, -185, 0.5, -190)
    main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    main.BorderSizePixel = 0
    main.Visible = false
    main.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = main

    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 38)
    title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    title.Text = "DRNL HUB RP"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.Parent = main

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title

    -- Comandos
    local comandos = {
        {nome = "//Revistar", cmd = "//Revistar"},
        {nome = "//Fuzilar", cmd = "//Fuzilar"},
        {nome = "//Matar", cmd = "//Mat"},
        {nome = "//Furar pneu", cmd = "//Furar pneu"},
        {nome = "//Pegar", cmd = "//Pegar"},
        {nome = "//LockPick", cmd = "//LockPick"},
        {nome = "//Render", cmd = "//Render"},
        {nome = "//Algema r", cmd = "//Algema r"},
    }

    local function enviar(cmd)
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

    for i, v in ipairs(comandos) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -14, 0, 35)
        btn.Position = UDim2.new(0, 7, 0, 45 + (i-1) * 39)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.Text = v.nome
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 14
        btn.Parent = main

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        btn.MouseEnter:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(65, 65, 65)
        end)
        btn.MouseLeave:Connect(function()
            btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        end)

        btn.MouseButton1Click:Connect(function()
            enviar(v.cmd)
        end)
    end

    -- Bolinha preta (arrastável)
    local bolinha = Instance.new("TextButton")
    bolinha.Size = UDim2.new(0, 45, 0, 45)
    bolinha.Position = UDim2.new(1, -60, 0.5, -22)
    bolinha.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    bolinha.Text = ""
    bolinha.Parent = gui

    local bolinhaCorner = Instance.new("UICorner")
    bolinhaCorner.CornerRadius = UDim.new(1, 0)
    bolinhaCorner.Parent = bolinha

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(1, 0, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = "☰"
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 22
    icon.Parent = bolinha

    -- Sistema de arrastar a bolinha
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local hasDragged = false

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

            -- Se não arrastou quase nada, considera como clique (abre/fecha)
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
end)

if not success then
    warn("Erro: " .. tostring(err))
end
