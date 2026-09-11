-- DRNL HUB RP (bolinha fixa igual ao de PC) - Versão Corrigida

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

-- ====================== PAINEL PRINCIPAL ======================
local main = Instance.new("Frame")
main.Name = "MainPanel"
main.Size = UDim2.new(0, 240, 0, 420) -- um pouco mais largo e altura controlada
main.Position = UDim2.new(1, -255, 0.5, -210)
main.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
main.BorderSizePixel = 0
main.Visible = false
main.ClipsDescendants = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(55, 55, 55)
mainStroke.Thickness = 1
mainStroke.Parent = main

-- Título
local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 42)
title.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
title.Text = "DRNL HUB RP"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = main

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

-- Cantos inferiores do título retos (só arredonda em cima)
local titleFix = Instance.new("Frame")
titleFix.Size = UDim2.new(1, 0, 0, 14)
titleFix.Position = UDim2.new(0, 0, 1, -14)
titleFix.BackgroundColor3 = Color3.fromRGB(32, 32, 32)
titleFix.BorderSizePixel = 0
titleFix.Parent = title

-- ====================== ÁREA COM ROLAGEM ======================
local scroll = Instance.new("ScrollingFrame")
scroll.Name = "CommandScroll"
scroll.Size = UDim2.new(1, -12, 1, -54)
scroll.Position = UDim2.new(0, 6, 0, 48)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 5
scroll.ScrollBarImageColor3 = Color3.fromRGB(120, 120, 120)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0) -- será atualizado automaticamente
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = main

local listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 6)
listLayout.Parent = scroll

local listPadding = Instance.new("UIPadding")
listPadding.PaddingTop = UDim.new(0, 4)
listPadding.PaddingBottom = UDim.new(0, 8)
listPadding.PaddingLeft = UDim.new(0, 2)
listPadding.PaddingRight = UDim.new(0, 2)
listPadding.Parent = scroll

-- ====================== COMANDOS (mantidos exatamente iguais) ======================
local comandos = {
{nome = [[
/rasteira
/chave de braço
]], cmd = "[JIU-JITSU 🇧🇷] RASTEIRA + CHAVE DE BRAÇO"},

{nome = [[
/guarda fechada
/raspagem
/montada
]], cmd = "[JIU-JITSU 🇧🇷] GUARDA FECHADA + PROJEÇÃO DE QUADRIL + MONTADA + FECHAR BRECHAS"},

{nome = [[
/guarda aberta
/raspagem com a perna
/controle lateral
]], cmd = "[JIU-JITSU 🇧🇷] GUARDA ABERTA + RASPAGEM + CONTROLE LATERAL"},

{nome = [[
/raspagem
/passagem de guarda
/montada
/chave de braço
]], cmd = "[JIU-JITSU 🇧🇷] RASPAGEM + PASSAGEM DE GUARDA + MONTADA + CHAVE DE BRAÇO"},

{nome = [[
/gancho com a perna
/raspagem
/triângulo
]], cmd = "[JIU-JITSU 🇧🇷] GANCHO + RASPAGEM + TRIÂNGULO"},

{nome = [[
	——— APERTAR ———
]], cmd = "/APERTAR"},
	
{nome = [[
	——— PESAR ———
]], cmd = "/PESAR"},
	
{nome = [[
/chute frontal
/chute lateral
]], cmd = "[TAEKWONDO 🇰🇷] CHUTE FRONTAL + CHUTE LATERAL"},

{nome = [[
/chute baixo
/chute alto
/chute giratório
]], cmd = "[TAEKWONDO 🇰🇷] CHUTE BAIXO + CHUTE ALTO + CHUTE GIRATÓRIO"},

{nome = [[
/chute frontal
/chute giratório
/chute giratório alto
]], cmd = "[TAEKWONDO 🇰🇷] CHUTE FRONTAL + CHUTE GIRATÓRIO + CHUTE GIRATÓRIO ALTO"},

{nome = [[
/chute lateral
/chute de gancho
/chute descendente
]], cmd = "[TAEKWONDO 🇰🇷] CHUTE LATERAL + CHUTE DE GANCHO + CHUTE DESCENDENTE"},

{nome = [[
/chute traseiro
/chute giratório
/chute 540 graus
]], cmd = "[TAEKWONDO 🇰🇷] CHUTE TRASEIRO + CHUTE GIRATÓRIO + CHUTE 540 GRAUS"},

{nome = [[
/desvio 
/segurar perna
]], cmd = "/DEVIAR + SEGURAR PERNA"},
}

-- Função de envio (mantida a lógica original)
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

-- Criação dos botões
for i, v in ipairs(comandos) do
	local btn = Instance.new("TextButton")
	btn.Name = "Cmd_" .. i
	btn.Size = UDim2.new(1, -4, 0, 42)
	btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	btn.Text = v.nome
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Font = Enum.Font.Gotham
	btn.TextSize = 12
	btn.TextWrapped = true
	btn.TextXAlignment = Enum.TextXAlignment.Left
	btn.AutoButtonColor = false
	btn.LayoutOrder = i
	btn.Parent = scroll

	local btnCorner = Instance.new("UICorner")
	btnCorner.CornerRadius = UDim.new(0, 8)
	btnCorner.Parent = btn

	local btnPadding = Instance.new("UIPadding")
	btnPadding.PaddingLeft = UDim.new(0, 10)
	btnPadding.PaddingRight = UDim.new(0, 8)
	btnPadding.Parent = btn

	-- Efeito visual (funciona bem em PC)
	btn.MouseEnter:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	end)
	btn.MouseLeave:Connect(function()
		btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end)

	-- Clique (funciona em PC e celular)
	btn.MouseButton1Click:Connect(function()
		enviar(v.cmd, v.vezes)
	end)
end

-- ====================== BOLINHA (abrir/fechar) ======================
local bolinha = Instance.new("TextButton")
bolinha.Name = "ToggleButton"
bolinha.Size = UDim2.new(0, 67, 0, 67)
bolinha.Position = UDim2.new(1, -65, 0, 8) -- mesma posição do PC
bolinha.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
bolinha.Text = "🥊"
bolinha.TextColor3 = Color3.fromRGB(255, 255, 255)
bolinha.Font = Enum.Font.GothamBold
bolinha.TextSize = 22
bolinha.AutoButtonColor = false
bolinha.Parent = gui

local bolinhaCorner = Instance.new("UICorner")
bolinhaCorner.CornerRadius = UDim.new(1, 0)
bolinhaCorner.Parent = bolinha

local bolinhaStroke = Instance.new("UIStroke")
bolinhaStroke.Color = Color3.fromRGB(70, 70, 70)
bolinhaStroke.Thickness = 1.5
bolinhaStroke.Parent = bolinha

bolinha.MouseButton1Click:Connect(function()
	main.Visible = not main.Visible
end)

-- Efeito visual da bolinha
bolinha.MouseEnter:Connect(function()
	bolinha.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
end)
bolinha.MouseLeave:Connect(function()
	bolinha.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
end)

print("✅ DRNL HUB RP carregado! Bolinha fixa no canto superior direito")
