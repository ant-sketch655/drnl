local Players = game:GetService("Players")
local player = Players.LocalPlayer

local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 500, 0, 300)
frame.Position = UDim2.new(0.5, -250, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Parent = gui

local dados = {
	{"Jogadores", 80},
	{"Vendas", 55},
	{"XP", 95},
	{"Moedas", 40}
}

local maiorValor = 100

for i, dado in ipairs(dados) do
	local nome = dado[1]
	local valor = dado[2]

	local barra = Instance.new("Frame")
	barra.Size = UDim2.new(0, 70, 0, (valor / maiorValor) * 220)
	barra.Position = UDim2.new(0, 30 + ((i - 1) * 115), 1, -20)
	barra.AnchorPoint = Vector2.new(0, 1)
	barra.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
	barra.Parent = frame

	local texto = Instance.new("TextLabel")
	texto.Size = UDim2.new(1, 0, 0, 25)
	texto.Position = UDim2.new(0, 0, 1, 5)
	texto.BackgroundTransparency = 1
	texto.Text = nome
	texto.TextColor3 = Color3.new(1, 1, 1)
	texto.Parent = barra

	local numero = Instance.new("TextLabel")
	numero.Size = UDim2.new(1, 0, 0, 25)
	numero.Position = UDim2.new(0, 0, 0, -25)
	numero.BackgroundTransparency = 1
	numero.Text = tostring(valor)
	numero.TextColor3 = Color3.new(1, 1, 1)
	numero.Parent = barra
end
