local Luna = loadstring(game:HttpGet("https://raw.githubusercontent.com/RobloxAvatar/Luna/main/Luna.lua"))()

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local Window = Luna:CreateWindow({
    Name = "Raymond Hub (Luna)",
    Theme = "Dark",
    Keybind = Enum.KeyCode.K
})

local MainTab = Window:CreateTab("Main")
local FlyTab = Window:CreateTab("Fly")
local TPTab = Window:CreateTab("Teleport")

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
    Min = 16,
    Max = 300,
    Default = 16,
    Callback = function(v)
        local _, hum = getChar()
        hum.WalkSpeed = v
    end
})

MainTab:CreateToggle({
    Name = "Infinite Jump",
    Default = false,
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
    Default = false,
    Callback = function(v)
        local _, hum, hrp = getChar()
        flying = v
        if v then
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e5,1e5,1e5)
            bv.Parent = hrp

            bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
            bg.Parent = hrp

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
    Min = 20,
    Max = 200,
    Default = 60,
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

TPTab:CreateTextbox({
    Name = "Teleport to Player",
    Placeholder = "Player Name",
    Callback = function(name)
        local target = Players:FindFirstChild(name)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local _, _, hrp = getChar()
            hrp.CFrame = target.Character.HumanoidRootPart.CFrame + Vector3.new(0,5,0)
        end
    end
})
