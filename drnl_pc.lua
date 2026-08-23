-- DRNL Keybinds RP (escolhe tecla + manda 3x)

local success, err = pcall(function()
    local UserInputService = game:GetService("UserInputService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    -- Comandos disponíveis
    local comandos = {
        {nome = "/mat", cmd = "/mat", key = nil},
        {nome = "/tiro na cabeca", cmd = "/tiro na cabeca", key = nil},
        {nome = "/tirar comunicacao", cmd = "/tirar comunicacao", key = nil},
        {nome = "/render", cmd = "/render", key = nil},
        {nome = "/furar pneu", cmd = "/furar pneu", key = nil},
        {nome = "/lockpick", cmd = "/lockpick", key = nil},
        {nome = "/algemar", cmd = "/algemar", key = nil},
    }

    local waitingForKey = nil

    -- Função que envia o comando 3 vezes
    local function enviar(cmd)
        for i = 1, 3 do
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

    if gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game:GetService("CoreGui")
    end

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 260, 0, 340)
    main.Position = UDim2.new(0.5, -130, 0.5, -170)
    main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    main.BorderSizePixel = 0
    main.Visible = true
    main.Parent = gui

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = main

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 36)
    title.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
    title.Text = "  Configurar Teclas"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = main

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = title

    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 20)
    info.Position = UDim2.new(0, 10, 0, 40)
    info.BackgroundTransparency = 1
    info.Text = "Clique no comando e pressione a tecla"
    info.TextColor3 = Color3.fromRGB(180, 180, 180)
    info.Font = Enum.Font.Gotham
    info.TextSize = 12
    info.Parent = main

    local buttons = {}

    local function atualizarTexto(i)
        local v = comandos[i]
        local keyName = v.key and v.key.Name or "Nenhuma"
        buttons[i].Text = v.nome .. "  →  [" .. keyName .. "]"
    end

    for i, v in ipairs(comandos) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 32)
        btn.Position = UDim2.new(0, 10, 0, 70 + (i-1) * 36)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.Text = v.nome .. "  →  [Nenhuma]"
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 13
        btn.Parent = main

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 6)
        btnCorner.Parent = btn

        buttons[i] = btn

        btn.MouseEnter:Connect(function()
            if waitingForKey \~= i then
                btn.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
            end
        end)
        btn.MouseLeave:Connect(function()
            if waitingForKey \~= i then
                btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end
        end)

        btn.MouseButton1Click:Connect(function()
            if waitingForKey then
                buttons[waitingForKey].BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                atualizarTexto(waitingForKey)
            end

            waitingForKey = i
            btn.BackgroundColor3 = Color3.fromRGB(0, 120, 80)
            btn.Text = v.nome .. "  →  [Pressione uma tecla...]"
        end)
    end

    -- Detecta tecla
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if waitingForKey and input.UserInputType == Enum.UserInputType.Keyboard then
            local i = waitingForKey
            comandos[i].key = input.KeyCode
            waitingForKey = nil
            buttons[i].BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            atualizarTexto(i)
            return
        end

        if gameProcessed then return end

        for _, v in ipairs(comandos) do
            if v.key and input.KeyCode == v.key then
                enviar(v.cmd) -- manda 3 vezes
                break
            end
        end
    end)

    -- Botão fechar
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -35, 0, 3)
    close.BackgroundColor3 = Color3.fromRGB(60, 30, 30)
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 14
    close.Parent = main

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = close

    close.MouseButton1Click:Connect(function()
        main.Visible = false
    end)

    print("✅ DRNL Keybinds carregado! (manda 3x)")
end)

if not success then
    warn("Erro: " .. tostring(err))
end
