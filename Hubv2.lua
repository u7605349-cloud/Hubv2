local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield", true))()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Window = Rayfield:CreateWindow({
    Name = "Raymond Hub",
    LoadingTitle = "Rayfield UI",
    LoadingSubtitle = "by raymond",
    ToggleUIKeybind = "K"
})

local MainTab = Window:CreateTab("🏠 Main")
local FlyTab = Window:CreateTab("🕊 Fly")

local infJump = false
local flying = false
local flySpeed = 60
local bv, bg

local function getChar()
    local char = player.Character or player.CharacterAdded:Wait()
    return char, char:WaitForChild("Humanoid"), char:WaitForChild("HumanoidRootPart")
end

MainTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16,300},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v)
        local _, hum = getChar()
        hum.WalkSpeed = v
    end
})

MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v)
        infJump = v
    end
})

UIS.JumpRequest:Connect(function()
    if infJump then
        local _, hum = getChar()
        hum:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

FlyTab:CreateToggle({
    Name = "Enable Fly",
    CurrentValue = false,
    Callback = function(v)
        local _, hum, hrp = getChar()
        flying = v
        if v then
            bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)

            bg = Instance.new("BodyGyro", hrp)
            bg.MaxTorque = Vector3.new(1e5,1e5,1e5)

            hum.PlatformStand = true
        else
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            hum.PlatformStand = false
        end
    end
})

FlyTab:CreateSlider({
    Name = "Fly Speed",
    Range = {20,200},
    Increment = 5,
    CurrentValue = 60,
    Callback = function(v)
        flySpeed = v
    end
})

RunService.RenderStepped:Connect(function()
    if flying then
        local _, hum, hrp = getChar()
        local move = hum.MoveDirection
        local y = 0
        if UIS:IsKeyDown(Enum.KeyCode.E) then y = 1 end
        if UIS:IsKeyDown(Enum.KeyCode.Q) then y = -1 end
        bv.Velocity = Vector3.new(move.X, y, move.Z) * flySpeed
        bg.CFrame = camera.CFrame
    end
end)
