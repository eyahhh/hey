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
Title.Text = "Aimbot 1.1 - TavinX"
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
LegitButton.Text = "Legitz"
LegitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
LegitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
LegitButton.BorderSizePixel = 1
LegitButton.Font = Enum.Font.GothamSemibold
LegitButton.TextSize = 14
LegitButton.AutoButtonColor = true

-- Dropdown Container
local DropdownContainer = Instance.new("Frame", Container)
DropdownContainer.Size = UDim2.new(0, 80, 0, 20)
DropdownContainer.Position = UDim2.new(1, -90, 0, 5)
DropdownContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
DropdownContainer.BorderSizePixel = 1
DropdownContainer.BorderColor3 = Color3.fromRGB(0, 255, 255)
DropdownContainer.ClipsDescendants = true

-- Selected Option Label
local SelectedOption = Instance.new("TextLabel", DropdownContainer)
SelectedOption.Size = UDim2.new(1, -20, 1, 0)
SelectedOption.Position = UDim2.new(0, 5, 0, 0)
SelectedOption.BackgroundTransparency = 1
SelectedOption.TextColor3 = Color3.fromRGB(0, 255, 255)
SelectedOption.Font = Enum.Font.GothamSemibold
SelectedOption.TextSize = 14
SelectedOption.TextXAlignment = Enum.TextXAlignment.Left
SelectedOption.Text = AimPartName

-- Dropdown Arrow Button
local ArrowButton = Instance.new("TextButton", DropdownContainer)
ArrowButton.Size = UDim2.new(0, 20, 1, 0)
ArrowButton.Position = UDim2.new(1, -20, 0, 0)
ArrowButton.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
ArrowButton.Text = "▼"
ArrowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ArrowButton.Font = Enum.Font.GothamSemibold
ArrowButton.TextSize = 14
ArrowButton.AutoButtonColor = true

-- Options Frame (escondido por padrão)
local OptionsFrame = Instance.new("Frame", DropdownContainer)
OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
OptionsFrame.Position = UDim2.new(0, 0, 1, 0)
OptionsFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
OptionsFrame.BorderSizePixel = 1
OptionsFrame.BorderColor3 = Color3.fromRGB(0, 255, 255)
OptionsFrame.ClipsDescendants = true
OptionsFrame.Visible = false

local optionNames = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}

local expanded = false

-- Função toggle do dropdown (sem tween, pra garantir abrir/fechar na moral)
local function toggleDropdown()
    if expanded then
        OptionsFrame.Size = UDim2.new(1, 0, 0, 0)
        OptionsFrame.Visible = false
    else
        OptionsFrame.Size = UDim2.new(1, 0, 0, #optionNames * 25)
        OptionsFrame.Visible = true
    end
    expanded = not expanded
end

ArrowButton.MouseButton1Click:Connect(toggleDropdown)
SelectedOption.MouseButton1Click:Connect(toggleDropdown)

-- Criar as opções dentro do OptionsFrame
for i, name in ipairs(optionNames) do
    local option = Instance.new("TextButton", OptionsFrame)
    option.Size = UDim2.new(1, 0, 0, 25)
    option.Position = UDim2.new(0, 0, 0, (i -1) * 25)
    option.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    option.BorderSizePixel = 1
    option.BorderColor3 = Color3.fromRGB(0, 255, 255)
    option.TextColor3 = Color3.fromRGB(0, 255, 255)
    option.Font = Enum.Font.GothamSemibold
    option.TextSize = 14
    option.Text = name
    option.AutoButtonColor = true

    option.MouseButton1Click:Connect(function()
        AimPartName = name
        SelectedOption.Text = name
        toggleDropdown()
    end)
end

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

-- Verifica visibilidade com raycast
local function isVisible(targetPart)
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * (targetPart.Position - origin).Magnitude
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.IgnoreWater = true
    local result = workspace:Raycast(origin, direction, raycastParams)
    if result then
        return result.Instance:IsDescendantOf(targetPart.Parent)
    else
        return true
    end
end

-- Busca o melhor alvo
local function getClosestTarget()
    local closestTarget = nil
    local closestDistance = math.huge
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Team ~= LocalPlayer.Team and player.Character and player.Character:FindFirstChild(AimPartName) then
            local targetPart = player.Character[AimPartName]
            local screenPoint, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
            if onScreen and isVisible(targetPart) then
                local mousePos = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
                local targetPos = Vector2.new(screenPoint.X, screenPoint.Y)
                local distance = (targetPos - mousePos).Magnitude
                if distance < closestDistance and distance <= FOV_RADIUS then
                    closestDistance = distance
                    closestTarget = targetPart
                end
            end
        end
    end
    return closestTarget
end

-- Atualiza ESP (highlights)
local function updateESP()
    if not ESPEnabled then return end
    -- Limpar highlights que não estão mais no jogo
    for _, highlight in ipairs(HighlightFolder:GetChildren()) do
        if not highlight.Adornee or not highlight.Adornee.Parent then
            highlight:Destroy()
        end
    end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local char = player.Character
            local hrp = char.HumanoidRootPart
            local teamColor = player.Team and player.Team.TeamColor.Color or Color3.fromRGB(255, 255, 255)
            local isEnemy = player.Team ~= LocalPlayer.Team
            local highlight = HighlightFolder:FindFirstChild(player.Name)
            if ESPEnabled then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = player.Name
                    highlight.Adornee = char
                    highlight.Parent = HighlightFolder
                    highlight.FillTransparency = 0.6
                    highlight.OutlineTransparency = 0.3
                end
                highlight.FillColor = isEnemy and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
                highlight.OutlineColor = isEnemy and Color3.fromRGB(255, 0, 0) or Color3.fromRGB(0, 255, 0)
            elseif highlight then
                highlight:Destroy()
            end
        end
    end
end

-- Atualiza a mira da câmera se aimbot estiver ligado
RunService.RenderStepped:Connect(function()
    updateESP()
    if AimbotEnabled then
        local target = getClosestTarget()
        if target then
            local targetPos = target.Position
            local camPos = Camera.CFrame.Position
            local direction = (targetPos - camPos).Unit
            -- Tween suave pra mirar
            local newCFrame = CFrame.new(camPos, camPos + direction)
            Camera.CFrame = newCFrame
        end
    end
end)

updateModeButtons()
