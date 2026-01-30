
-- ChilliHub_AllInOne.lua
-- Fully merged, clean, runnable single-file version
-- Rebuilt from obfuscated source into maintainable code

--// ===== SERVICES =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

--// ===== GUARD =====
if _G.ChilliHubLoaded then
    warn("ChilliHub already loaded")
    return
end
_G.ChilliHubLoaded = true

--// ===== UI ROOT =====
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ChilliHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = CoreGui

--// ===== FLOATING TOGGLE =====
local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.fromOffset(100, 36)
ToggleButton.Position = UDim2.fromScale(0.02, 0.2)
ToggleButton.Text = "Chilli"
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 16
ToggleButton.TextColor3 = Color3.fromRGB(240,240,240)
ToggleButton.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
ToggleButton.Parent = ScreenGui

Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(0,12)

--// ===== MAIN WINDOW =====
local Window = Instance.new("Frame")
Window.Size = UDim2.fromOffset(450,320)
Window.Position = UDim2.fromScale(0.3,0.3)
Window.BackgroundColor3 = Color3.fromRGB(18,18,28)
Window.Visible = false
Window.Parent = ScreenGui

Instance.new("UICorner", Window).CornerRadius = UDim.new(0,14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.fromScale(1,0.15)
Title.BackgroundTransparency = 1
Title.Text = "Chilli Hub – Steal a Brainrot"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.Parent = Window

--// ===== BASIC CONTENT =====
local Content = Instance.new("TextLabel")
Content.Position = UDim2.fromScale(0,0.18)
Content.Size = UDim2.fromScale(1,0.82)
Content.BackgroundTransparency = 1
Content.TextWrapped = true
Content.TextYAlignment = Enum.TextYAlignment.Top
Content.TextXAlignment = Enum.TextXAlignment.Left
Content.Font = Enum.Font.Gotham
Content.TextSize = 14
Content.TextColor3 = Color3.fromRGB(220,220,220)
Content.Text = "• Plot Scanner\n• Steal Prompt Finder\n• Anti-AFK\n\nCheck console for outputs."
Content.Parent = Window

--// ===== TOGGLE LOGIC =====
ToggleButton.MouseButton1Click:Connect(function()
    Window.Visible = not Window.Visible
end)

--// ===== PLOT SCANNER =====
local function scanPlots()
    local output = {}
    local plots = workspace:FindFirstChild("Plots")
    if not plots then
        warn("Plots folder not found")
        return
    end

    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        if sign then
            local gui = sign:FindFirstChild("SurfaceGui")
            if gui then
                local label = gui:FindFirstChildWhichIsA("TextLabel", true)
                if label and type(label.Text) == "string" then
                    table.insert(output, label.Text)
                    print("[ChilliHub] Plot:", label.Text)
                end
            end
        end
    end

    if #output == 0 then
        warn("[ChilliHub] No plot names found")
    end
end

--// ===== PROXIMITY PROMPT FINDER =====
local function findStealPrompt(model)
    for _, v in ipairs(model:GetDescendants()) do
        if v:IsA("ProximityPrompt") and v.ActionText == "Steal" then
            return v
        end
    end
end

--// ===== SIMPLE AUTO-STEAL (SAFE, MANUAL CALL) =====
local function trySteal(target)
    local prompt = findStealPrompt(target)
    if prompt then
        fireproximityprompt(prompt)
        print("[ChilliHub] Fired Steal prompt")
    end
end

--// ===== ANTI-AFK =====
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

--// ===== CHARACTER HANDLING =====
local function onCharacter(char)
    char:WaitForChild("Humanoid")
    char:WaitForChild("HumanoidRootPart")
end

if LocalPlayer.Character then
    onCharacter(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(onCharacter)

--// ===== INIT =====
scanPlots()
print("[ChilliHub] Loaded successfully")
