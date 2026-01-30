
-- ChilliHub_Mobile_AllInOne.lua
-- Mobile-compatible UI version
-- All original features preserved, UI replaced ONLY for mobile

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local VirtualUser = game:GetService("VirtualUser")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

if _G.ChilliMobileLoaded then return end
_G.ChilliMobileLoaded = true

local CONFIG_FOLDER = "Chilli Hub Brainot"
local CONFIG_FILE = CONFIG_FOLDER .. "/" .. LocalPlayer.Name .. ".json"
local Config = { Speed = 16, Jump = 50, Gravity = Workspace.Gravity, ESP = true }

if makefolder and not isfolder(CONFIG_FOLDER) then
    makefolder(CONFIG_FOLDER)
end

local function saveConfig()
    if writefile then
        writefile(CONFIG_FILE, HttpService:JSONEncode(Config))
    end
end

local function loadConfig()
    if readfile and isfile and isfile(CONFIG_FILE) then
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_FILE))
        end)
        if ok and type(data) == "table" then
            Config = data
        end
    end
end

loadConfig()

LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

local Humanoid
LocalPlayer.CharacterAdded:Connect(function(c)
    Humanoid = c:WaitForChild("Humanoid")
end)
if LocalPlayer.Character then
    Humanoid = LocalPlayer.Character:WaitForChild("Humanoid")
end

RunService.Heartbeat:Connect(function()
    if Humanoid then
        Humanoid.WalkSpeed = Config.Speed
        Humanoid.JumpPower = Config.Jump
    end
    Workspace.Gravity = Config.Gravity
end)

local function addESP(player)
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function(char)
        local head = char:WaitForChild("Head",5)
        if not head then return end
        local gui = Instance.new("BillboardGui", head)
        gui.Size = UDim2.new(0,200,0,50)
        gui.AlwaysOnTop = true
        local lbl = Instance.new("TextLabel", gui)
        lbl.Size = UDim2.fromScale(1,1)
        lbl.BackgroundTransparency = 1
        lbl.Text = player.DisplayName
        lbl.TextColor3 = Color3.new(1,1,1)
    end)
end

for _,p in ipairs(Players:GetPlayers()) do addESP(p) end
Players.PlayerAdded:Connect(addESP)

local gui = Instance.new("ScreenGui", CoreGui)
gui.Name = "ChilliMobileUI"
gui.ResetOnSpawn = false

local open = Instance.new("TextButton", gui)
open.Size = UDim2.new(0,100,0,40)
open.Position = UDim2.new(0.05,0,0.4,0)
open.Text = "Chilli"
open.BackgroundColor3 = Color3.fromRGB(30,30,45)
open.TextColor3 = Color3.new(1,1,1)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,260,0,320)
frame.Position = UDim2.new(0.5,-130,0.5,-160)
frame.BackgroundColor3 = Color3.fromRGB(15,15,25)
frame.Visible = false

open.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
end)

local function makeButton(text, y, callback)
    local b = Instance.new("TextButton", frame)
    b.Size = UDim2.new(1,-20,0,40)
    b.Position = UDim2.new(0,10,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(40,40,60)
    b.TextColor3 = Color3.new(1,1,1)
    b.MouseButton1Click:Connect(callback)
end

makeButton("Speed +10", 20, function()
    Config.Speed += 10
    saveConfig()
end)

makeButton("Jump +20", 70, function()
    Config.Jump += 20
    saveConfig()
end)

makeButton("Gravity -10", 120, function()
    Config.Gravity -= 10
    saveConfig()
end)

makeButton("Toggle ESP", 170, function()
    Config.ESP = not Config.ESP
    saveConfig()
end)

print("[ChilliHub] Mobile version loaded")
