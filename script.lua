local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local AimbotEnabled = false
local ESPEnabled = true
local FOV_RADIUS = 90
local AimPartName = "Head"

local HighlightFolder = Instance.new("Folder", game.CoreGui)
HighlightFolder.Name = "AimbotHighlights"

-- GUI
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.ResetOnSpawn = false
ScreenGui.Name = "AimbotUI"

-- Container Frame pra organização
local Container = Instance.new("Frame", ScreenGui)
Container.Size = UDim2.new(0, 260, 0, 90)
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

-- Aim Part Button
local AimPartButton = Instance.new("TextButton", Container)
AimPartButton.Size = UDim2.new(0, 60, 0, 20)
AimPartButton.Position = UDim2.new(0, 110, 0, 65)
AimPartButton.Text = AimPartName
AimPartButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
AimPartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimPartButton.BorderSizePixel = 1
AimPartButton.Font = Enum.Font.GothamSemibold
AimPartButton.TextSize = 14
AimPartButton.AutoButtonColor = true

-- Lista das partes do corpo para a mira
local aimParts = {
	"Head",
	"Torso",
	"Left Leg",
	"Right Leg",
	"Right Arm",
	"Left Arm"
}

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

-- Função que retorna a parte do corpo para mirar, baseado na escolha do usuário
local function getAimTargetPart(player)
	local char = player.Character
	if not char then return nil end

	if AimPartName == "Head" then
		return char:FindFirstChild("Head")
	elseif AimPartName == "Torso" then
		return char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
	elseif AimPartName == "Left Leg" then
		return char:FindFirstChild("Left Leg") or char:FindFirstChild("LeftLowerLeg")
	elseif AimPartName == "Right Leg" then
		return char:FindFirstChild("Right Leg") or char:FindFirstChild("RightLowerLeg")
	elseif AimPartName == "Right Arm" then
		return char:FindFirstChild("Right Arm") or char:FindFirstChild("RightUpperArm")
	elseif AimPartName == "Left Arm" then
		return char:FindFirstChild("Left Arm") or char:FindFirstChild("LeftUpperArm")
	end
	return nil
end

-- Botão para ciclar a parte do corpo onde o aimbot mira
AimPartButton.MouseButton1Click:Connect(function()
	-- Pega o índice atual da parte selecionada
	local currentIndex = nil
	for i, partName in ipairs(aimParts) do
		if partName == AimPartName then
			currentIndex = i
			break
		end
	end

	-- Incrementa e volta pro começo se passar do fim
	currentIndex = (currentIndex % #aimParts) + 1
	AimPartName = aimParts[currentIndex]
	AimPartButton.Text = AimPartName
end)

-- Verifica visibilidade da parte
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
		if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
			local char = player.Character
			local hum = char and char:FindFirstChild("Humanoid")
			local head = char and char:FindFirstChild("Head")

			if char and hum and head and hum.Health > 0 then
				local hl = HighlightFolder:FindFirstChild(player.Name)
				if not hl then
					hl = Instance.new("Highlight", HighlightFolder)
					hl.Name = player.Name
					hl.Adornee = char
					hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					hl.FillTransparency = 0.5
					hl.OutlineTransparency = 1
				end

				hl.FillColor = isVisible(head) and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(255, 0, 0)
			else
				local old = HighlightFolder:FindFirstChild(player.Name)
				if old then old:Destroy() end
			end
		else
			local old = HighlightFolder:FindFirstChild(player.Name)
			if old then old:Destroy() end
		end
	end
end

-- Inimigo mais próximo dentro do FOV
local function getClosestVisibleEnemy()
	local closest = nil
	local shortest = math.huge

	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team then
			local char = player.Character
			local hum = char and char:FindFirstChild("Humanoid")
			local targetPart = getAimTargetPart(player)
			if char and hum and targetPart and hum.Health > 0 and isVisible(targetPart) then
				local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
				if onScreen then
					local dist = (Vector2.new(screenPos.X, screenPos.Y) - Camera.ViewportSize / 2).Magnitude
					if dist < FOV_RADIUS and dist < shortest then
						shortest = dist
						closest = player
					end
				end
			end
		end
	end

	return closest
end

-- Loop Principal
RunService.RenderStepped:Connect(function()
	updateESP()

	if AimbotEnabled then
		local target = getClosestVisibleEnemy()
		if target and target.Character then
			local aimPart = getAimTargetPart(target)
			if aimPart then
				Camera.CFrame = CFrame.new(Camera.CFrame.Position, aimPart.Position)
			end
		end
	end
end)

updateModeButtons()
