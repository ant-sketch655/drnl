-- DRNL HUB RP (corrigido + rolagem + arrastável)

local success, err = pcall(function()
	local UIS = game:GetService("UserInputService")
	local Players = game:GetService("Players")
	local LP = Players.LocalPlayer

	local gui = Instance.new("ScreenGui")
	gui.Name = "DRNLHUBRP"
	gui.ResetOnSpawn = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.IgnoreGuiInset = true
	gui.DisplayOrder = 999999
	gui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

	-- ===================== PAINEL PRINCIPAL =====================
	local main = Instance.new("Frame")
	main.Name = "Main"
	main.Size = UDim2.new(0, 200, 0, 420) -- altura menor para não cobrir a tela
	main.Position = UDim2.new(1, -220, 0.5, -210)
	main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
	main.BorderSizePixel = 0
	main.Visible = false
	main.Parent = gui
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)

	-- Título (área de arraste do painel)
	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, 0, 0, 40)
	title.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
	title.Text = "DRNL HUB RP"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBold
	title.TextSize = 15
	title.Parent = main
	Instance.new("UICorner", title).CornerRadius = UDim.new(0, 12)

	-- ScrollingFrame (rolagem)
	local scroll = Instance.new("ScrollingFrame")
	scroll.Size = UDim2.new(1, -10, 1, -50)
	scroll.Position = UDim2.new(0, 5, 0, 45)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 4
	scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
	scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scroll.Parent = main

	local list = Instance.new("UIListLayout")
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, 6)
	list.Parent = scroll

	local padding = Instance.new("UIPadding")
	padding.PaddingTop = UDim.new(0, 4)
	padding.PaddingBottom = UDim.new(0, 8)
	padding.Parent = scroll

	-- ===================== COMANDOS (todos preservados) =====================
	local comandos = {
	{nome = "[HAPKIDO 🇰🇷] BLOQUEIO + PROJEÇÃO", cmd = "/bloqueio + projeção"},
	{nome = "[KYOKUSHIN 🇯🇵] CHUTE BAIXO + SOCO DIRETO", cmd = "/chute baixo + soco direto"},
	{nome = "[SANDA 🇨🇳] CRUZADO + CHUTE + RASTEIRA", cmd = "/cruzado + chute + rasteira"},
	{nome = "[SUMÔ 🇯🇵] EMPURRÃO + DESEQUILÍBRIO", cmd = "/empurrão + desequilíbrio"},
	{nome = "[PANKRATION 🇬🇷] SOCO + QUEDA", cmd = "/soco + queda"},
	{nome = "[SILAT 🇮🇩] ESQUIVA + CONTRA-ATAQUE", cmd = "/esquiva + contra-ataque"},
	{nome = "[LETHWEI 🇲🇲] COTOVELADA + JOELHADA", cmd = "/cotovelada + joelhada"},
	{nome = "[WRESTLING 🇷🇺] SUPLEX", cmd = "/suplex"},
	{nome = "[KALARIPAYATTU 🇮🇳] CHUTE + ATAQUE GIRATÓRIO", cmd = "/chute + ataque giratório"},
	{nome = "[SHOOT BOXING 🇯🇵] SOCO + JOELHADA + QUEDA", cmd = "/soco + joelhada + queda"},
	{nome = "[LA CANNE 🇫🇷] ATAQUE COM BASTÃO ⚠️", cmd = "/ataque com bastão"},
	{nome = "[BAJÍQUÁN 🇨🇳] GOLPE DE OMBRO + EMPURRÃO", cmd = "/golpe de ombro + empurrão"},
	{nome = "[JIU JITSU 🇧🇷] ARMLOCK", cmd = "/armlock"},
	{nome = "[WING CHUN 🇨🇳] DESVIAR + BLOQUEAR", cmd = "/desviar + bloquear"},
	{nome = "[TAI CHI 🇨🇳] DEFENDER + REDIRECIONAR", cmd = "/defender + redirecionar"},
	{nome = "[KARATÊ SHOTOKAN 🇯🇵] SOCO AVANÇANDO + SOCO DIRETO", cmd = "/soco avançando + soco direto"},
	{nome = "[KARATÊ SHOTOKAN 🇯🇵] SOCO RÁPIDO + SOCO DIRETO", cmd = "/soco rápido + soco direto"},
	{nome = "[KARATÊ SHOTOKAN 🇯🇵] CHUTE FRONTAL + SOCO DIRETO", cmd = "/chute frontal + soco direto"},
	{nome = "[KARATÊ SHOTOKAN 🇯🇵] CHUTE LATERAL", cmd = "/chute lateral"},
	{nome = "[KARATÊ SHOTOKAN 🇯🇵] CHUTE CIRCULAR + SOCO DIRETO", cmd = "/chute circular + soco direto"},
	{nome = "[KARATÊ SHOTOKAN 🇯🇵] DOIS SOCOS RÁPIDOS", cmd = "/dois socos rápidos"},
	{nome = "[KARATÊ SHOTOKAN 🇯🇵] SOCO + CHUTE FRONTAL", cmd = "/soco + chute frontal"},
	{nome = "[KARATÊ SHOTOKAN 🇯🇵] CHUTE FRONTAL + CHUTE CIRCULAR", cmd = "/chute frontal + chute circular"},
	{nome = "[KARATÊ SHOTOKAN 🇯🇵] SOCO AVANÇANDO + CHUTE", cmd = "/soco avançando + chute"},
	{nome = "[KARATÊ SHOTOKAN 🇯🇵] FINTA + SOCO DIRETO", cmd = "/finta + soco direto"},
	{nome = "[KARATÊ SHOTOKAN 🇯🇵] ESQUIVA + SOCO DIRETO", cmd = "/esquiva + soco direto"},
	{nome = "[KARATÊ SHOTOKAN 🇯🇵] CHUTE LATERAL + SOCO", cmd = "/chute lateral + soco"},
	{nome = "[KARATÊ SHOTOKAN 🇯🇵] COMBINAÇÃO RÁPIDA DE SOCOS", cmd = "/combinação rápida de socos"},
	{nome = "[KARATÊ SHOTOKAN 🇯🇵] BLOQUEAR ATAQUE", cmd = "/bloquear ataque"},
	{nome = "[KARATÊ SHOTOKAN 🇯🇵] DESVIAR + CONTRA-ATACAR", cmd = "/desviar + contra-atacar"},
	}

	-- ===================== FUNÇÕES =====================
	local function tocarAnimacao(animId)
		local char = LP.Character
		if not char then return end
		local hum = char:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then return end

		local animator = hum:FindFirstChildOfClass("Animator")
		if not animator then
			animator = Instance.new("Animator")
			animator.Parent = hum
		end

		for _, track in pairs(animator:GetPlayingAnimationTracks()) do
			track:Stop(0.1)
		end

		local anim = Instance.new("Animation")
		anim.AnimationId = "rbxassetid://" .. tostring(animId)

		local ok, track = pcall(function()
			return animator:LoadAnimation(anim)
		end)

		if ok and track then
			track.Priority = Enum.AnimationPriority.Action4
			track.Looped = false
			track:Play(0.1)
			track:AdjustSpeed(1.2)
			task.delay(1.2, function()
				if track.IsPlaying then
					track:Stop(0.2)
				end
			end)
		end
	end

	local function enviar(cmd, animId)
		-- Sistema antigo de chat
		pcall(function()
			game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(cmd, "All")
		end)

		-- Sistema novo de chat (TextChatService)
		pcall(function()
			local tcs = game:GetService("TextChatService")
			local channel = tcs.TextChannels:FindFirstChild("RBXGeneral")
			if channel then
				channel:SendAsync(cmd)
			end
		end)

		if animId then
			tocarAnimacao(animId)
		end
	end

	-- Criação dos botões
	for i, v in ipairs(comandos) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1, -4, 0, 36)
		btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		btn.Text = v.nome
		btn.TextColor3 = Color3.fromRGB(255, 255, 255)
		btn.Font = Enum.Font.Gotham
		btn.TextSize = 14
		btn.AutoButtonColor = false
		btn.Parent = scroll
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

		btn.MouseEnter:Connect(function()
			btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
		end)
		btn.MouseLeave:Connect(function()
			btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		end)

		btn.MouseButton1Click:Connect(function()
			enviar(v.cmd, v.animId)
		end)
	end

	-- ===================== ARRASTAR O PAINEL (pelo título) =====================
	local draggingPanel = false
	local dragStart, startPos

	title.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingPanel = true
			dragStart = input.Position
			startPos = main.Position
		end
	end)

	title.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingPanel = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if draggingPanel and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

	-- ===================== BOLINHA (abrir/fechar + arrastável) =====================
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

	local draggingBall = false
	local ballStart, ballPos
	local hasDragged = false

	bolinha.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingBall = true
			hasDragged = false
			ballStart = input.Position
			ballPos = bolinha.Position
		end
	end)

	bolinha.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingBall = false
			if not hasDragged then
				main.Visible = not main.Visible
			end
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if draggingBall and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - ballStart
			if math.abs(delta.X) > 6 or math.abs(delta.Y) > 6 then
				hasDragged = true
			end
			bolinha.Position = UDim2.new(
				ballPos.X.Scale,
				ballPos.X.Offset + delta.X,
				ballPos.Y.Scale,
				ballPos.Y.Offset + delta.Y
			)
		end
	end)

	print("✅ DRNL HUB RP carregado com sucesso!")
end)

if not success then
	warn("Erro no DRNL HUB RP: " .. tostring(err))
end
