local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local AimbotEnabled = false
local ESPEnabled = true
local FOV_RADIUS = 90
local AimPartName = "Head" -- parte alvo padrão do aimbot

local HighlightFolder = Instance.new("Folder", game.CoreGui)
HighlightFolder.Name = "AimbotHighlights"

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "AimbotUI"

-- Container Frame pra organização
local Container = Instance.new("Frame", ScreenGui)
Container.Size = UDim2.new(0, 220, 0, 90)
Container.Position = UDim2.new(0, 10, 0.5, -45)
Container.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Container.BorderSizePixel = 0
Container.BackgroundTransparency = 0.15
Container.ClipsDescendants = true
Container.AnchorPoint = Vector2.new(0, 0)

-- Título
local Title = Instance.new("TextLabel", Container)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Text = "Aimbot 1.1 - Tavin"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(0, 255, 255)
Title.TextStrokeTransparency = 0.7

-- Dropdown Container (pai do dropdown)
local DropdownContainer = Instance.new("Frame", Container)
DropdownContainer.Size = UDim2.new(0, 80, 0, 25)
DropdownContainer.Position = UDim2.new(1, -85, 0, 5) -- canto superior direito do Container
DropdownContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
DropdownContainer.BorderSizePixel = 1
DropdownContainer.BorderColor3 = Color3.fromRGB(0, 255, 255)
DropdownContainer.ClipsDescendants = true

-- Botão do dropdown
local DropdownButton = Instance.new("TextButton", DropdownContainer)
DropdownButton.Size = UDim2.new(1, 0, 1, 0)
DropdownButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
DropdownButton.TextColor3 = Color3.fromRGB(0, 255, 255)
DropdownButton.Font = Enum.Font.GothamSemibold
DropdownButton.TextSize = 14
DropdownButton.Text = AimPartName .. " ▼" -- mostra o alvo atual

-- Frame para opções (inicialmente escondido)
local OptionsFrame = Instance.new("Frame", DropdownContainer)
OptionsFrame.Position = UDim2.new(0, 0, 1, 2)
OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
OptionsFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OptionsFrame.BorderSizePixel = 1
OptionsFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
OptionsFrame.ClipsDescendants = true

local optionNames = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

local expanded = false

local function toggleDropdown()
    if expanded then
        -- fechar
        OptionsFrame:TweenSize(UDim2.new(1, 0, 0, 0), "Out", "Quad", 0.2, true)
    else
        -- abrir
        OptionsFrame:TweenSize(UDim2.new(1, 0, 0, #optionNames * 25), "Out", "Quad", 0.2, true)
    end
    expanded = not expanded
end

DropdownButton.MouseButton1Click:Connect(toggleDropdown)

-- Criar os botões das opções
for i, name in ipairs(optionNames) do
    local btn = Instance.new("TextButton", OptionsFrame)
    btn.Size = UDim2.new(1, 0, 0, 25)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 25)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(0, 255, 255)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 14
    btn.Text = name
    btn.AutoButtonColor = true

    btn.MouseButton1Click:Connect(function()
        AimPartName = name
        DropdownButton.Text = AimPartName .. " ▼"
        toggleDropdown()
    end)
end

-- Toggle Button
local ToggleButton = Instance.new("TextButton", Container)
ToggleButton.Size = UDim2.new(0, 100, 0, 30)
ToggleButton.Position = UDim2.new(0, 10, 0, 30)
ToggleButton.Text = "Aimbot: OFF"
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ToggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
ToggleButton.BorderSizePixel = 1
ToggleButton.BorderColor3 = Color3.fromRGB(0, 255, 255)
ToggleButton.Font = Enum.Font.GothamSemibold
ToggleButton.TextSize = 14
ToggleButton.AutoButtonColor = true
ToggleButton.ZIndex = 2
ToggleButton.AnchorPoint = Vector2.new(0, 0)

-- ESP Toggle Button
local ESPButton = Instance.new("TextButton", Container)
ESPButton.Size = UDim2.new(0, 40, 0, 30)
ESPButton.Position = UDim2.new(0, 120, 0, 30)
ESPButton.Text = "ESP: ON"
ESPButton.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ESPButton.TextColor3 = Color3.fromRGB(0, 255, 0)
ESPButton.BorderSizePixel = 1
ESPButton.BorderColor3 = Color3.fromRGB(0, 255, 0)
ESPButton.Font = Enum.Font.GothamSemibold
ESPButton.TextSize = 14
ESPButton.AutoButtonColor = true
ESPButton.ZIndex = 2

-- Full Button
local FullButton = Instance.new("TextButton", Container)
FullButton.Size = UDim2.new(0, 40, 0, 20)
FullButton.Position = UDim2.new(0, 10, 0, 65)
FullButton.Text = "Full"
FullButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
FullButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FullButton.BorderSizePixel = 1
FullButton.Font = Enum.Font.GothamSemibold
FullButton.TextSize = 14
FullButton.AutoButtonColor = true

-- Legit Button
local LegitButton = Instance.new("TextButton", Container)
LegitButton.Size = UDim2.new(0, 40, 0, 20)
LegitButton.Position = UDim2.new(0, 60, 0, 65)
LegitButton.Text = "Legit"
LegitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
LegitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LegitButton.BorderSizePixel = 1
LegitButton.Font = Enum.Font.GothamSemibold
LegitButton.TextSize = 14
LegitButton.AutoButtonColor = true

-- Atualizar visual dos botões de modo
local function updateModeButtons()
	if FOV_RADIUS == 360 then
		FullButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		LegitButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	else
		FullButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		LegitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	end
end

FullButton.MouseButton1Click:Connect(function()
	FOV_RADIUS = 360
	updateModeButtons()
end)

LegitButton.MouseButton1Click:Connect(function()
	FOV_RADIUS = 90
	updateModeButtons()
end)

-- Toggle ESP
ESPButton.MouseButton1Click:Connect(function()
	ESPEnabled = not ESPEnabled
	ESPButton.Text = ESPEnabled and "ESP: ON" or "ESP: OFF"
	ESPButton.TextColor3 = ESPEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
	ESPButton.BorderColor3 = ESPButton.TextColor3
	if not ESPEnabled then
		-- Remove todos os highlights ao desligar o ESP
		for _, child in ipairs(HighlightFolder:GetChildren()) do
			child:Destroy()
		end
	end
end)

-- Toggle Aimbot
ToggleButton.MouseButton1Click:Connect(function()
	AimbotEnabled = not AimbotEnabled
	ToggleButton.Text = AimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
	ToggleButton.TextColor3 = AimbotEnabled and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(200, 200, 200)
	ToggleButton.BorderColor3 = AimbotEnabled and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(150, 150, 150)
end)

-- Verifica visibilidade
local function isVisible(targetPart)
	local origin = Camera.CFrame.Position
	local direction = targetPart.Position - origin
	local params = RaycastParams.new()
	params.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
	params.FilterType = Enum.RaycastFilterType.Blacklist

	local result = workspace:Raycast(origin, direction, params)
	return not result or result.Instance:IsDescendantOf(targetPart.Parent)
end

-- Atualizar ESP
local function updateESP()
	if not ESPEnabled then return end

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
			local char = player.Character
			local highlight = HighlightFolder:FindFirstChild(player.Name)
			if not highlight then
				highlight = Instance.new("Highlight", HighlightFolder)
				highlight.Name = player.Name
				highlight.Adornee = char
				highlight.FillColor = Color3.fromRGB(255, 0, 0)
				highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
				highlight.Enabled = ESPEnabled
			end
		end
	end

	-- Remove highlights de jogadores que saíram
	for _, highlight in ipairs(HighlightFolder:GetChildren()) do
		if not Players:FindFirstChild(highlight.Name) then
			highlight:Destroy()
		end
	end
end

-- Encontra inimigo mais próximo dentro do FOV
local function getClosestEnemy()
	local closest = nil
	local closestDistance = math.huge
	local mousePos = Camera.ViewportSize / 2

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild(AimPartName) then
			local part = player.Character:FindFirstChild(AimPartName)
			if part and isVisible(part) then
				local pos, onScreen = Camera:WorldToViewportPoint(part.Position)
				if onScreen then
					local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
					if dist < FOV_RADIUS and dist < closestDistance then
						closest = player
						closestDistance = dist
					end
				end
			end
		end
	end

	return closest
end

-- Main loop do aimbot
RunService.RenderStepped:Connect(function()
	if AimbotEnabled then
		local targetPlayer = getClosestEnemy()
		if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild(AimPartName) then
			local part = targetPlayer.Character[AimPartName]
			Camera.CFrame = CFrame.new(Camera.CFrame.Position, part.Position)
		end
	end

	updateESP()
end)
