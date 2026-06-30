local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local MarketplaceService = game:GetService("MarketplaceService")
local UserInputService = game:GetService("UserInputService")

-- Fetch Map Data
local placeId = game.PlaceId
local success, productInfo = pcall(function()
    return MarketplaceService:GetProductInfo(placeId)
end)
local mapName = success and productInfo.Name or "Unknown"

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MapIdDetectorGui"
ScreenGui.ResetOnSpawn = false

-- Parent the GUI to CoreGui (if run in an exploit environment) or PlayerGui (for Studio)
local parentSuccess, _ = pcall(function()
    local CoreGui = game:GetService("CoreGui")
    ScreenGui.Parent = CoreGui
end)
if not parentSuccess then
    ScreenGui.Parent = PlayerGui
end

-- Main Window Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 320, 0, 180)
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -90)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 1.5
UIStroke.Parent = MainFrame

-- UI Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "TitleLabel"
TitleLabel.Size = UDim2.new(1, 0, 0, 35)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.Text = "MAP ID DETECTOR"
TitleLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
TitleLabel.TextSize = 14
TitleLabel.Parent = MainFrame

-- Close Button (X)
local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.Position = UDim2.new(1, -35, 0, 5)
CloseButton.BackgroundTransparency = 1
CloseButton.Font = Enum.Font.GothamBold
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 75, 75)
CloseButton.TextSize = 16
CloseButton.Parent = MainFrame

CloseButton.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Map Name Label
local MapNameLabel = Instance.new("TextLabel")
MapNameLabel.Name = "MapNameLabel"
MapNameLabel.Size = UDim2.new(1, -20, 0, 30)
MapNameLabel.Position = UDim2.new(0, 10, 0, 45)
MapNameLabel.BackgroundTransparency = 1
MapNameLabel.Font = Enum.Font.GothamSemibold
MapNameLabel.Text = "Name: " .. mapName
MapNameLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
MapNameLabel.TextSize = 12
MapNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
MapNameLabel.Parent = MainFrame

-- Map ID Label
local MapIdLabel = Instance.new("TextLabel")
MapIdLabel.Name = "MapIdLabel"
MapIdLabel.Size = UDim2.new(1, -20, 0, 30)
MapIdLabel.Position = UDim2.new(0, 10, 0, 80)
MapIdLabel.BackgroundTransparency = 1
MapIdLabel.Font = Enum.Font.GothamBold
MapIdLabel.Text = "ID: " .. tostring(placeId)
MapIdLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
MapIdLabel.TextSize = 16
MapIdLabel.Parent = MainFrame

-- Copy ID Button
local CopyButton = Instance.new("TextButton")
CopyButton.Name = "CopyButton"
CopyButton.Size = UDim2.new(0.8, 0, 0, 35)
CopyButton.Position = UDim2.new(0.1, 0, 0, 125)
CopyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
CopyButton.BorderSizePixel = 0
CopyButton.Font = Enum.Font.GothamBold
CopyButton.Text = "Copy Map ID"
CopyButton.TextColor3 = Color3.fromRGB(220, 220, 220)
CopyButton.TextSize = 12
CopyButton.Parent = MainFrame

local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 6)
ButtonCorner.Parent = CopyButton

local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Color = Color3.fromRGB(70, 70, 70)
ButtonStroke.Thickness = 1
ButtonStroke.Parent = CopyButton

-- Copy Button Hover Effects
CopyButton.MouseEnter:Connect(function()
    CopyButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    ButtonStroke.Color = Color3.fromRGB(0, 170, 255)
end)
CopyButton.MouseLeave:Connect(function()
    CopyButton.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    ButtonStroke.Color = Color3.fromRGB(70, 70, 70)
end)

CopyButton.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(tostring(placeId))
        CopyButton.Text = "Copied Successfully!"
        CopyButton.TextColor3 = Color3.fromRGB(0, 255, 150)
        task.wait(1.5)
        CopyButton.Text = "Copy Map ID"
        CopyButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    else
        -- Fallback if run inside Roblox Studio (where 'setclipboard' is unavailable)
        CopyButton.Text = "Failed (Check Console F9)"
        CopyButton.TextColor3 = Color3.fromRGB(255, 75, 75)
        warn("Your Map Place ID: " .. tostring(placeId))
        task.wait(1.5)
        CopyButton.Text = "Copy Map ID"
        CopyButton.TextColor3 = Color3.fromRGB(220, 220, 220)
    end
end)

-- Custom Dragging System (Enables smooth panel movement via mouse or touch)
local dragging, dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)
