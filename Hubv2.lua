local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "Raymond Hub",
    LoadingTitle = "Rayfield UI",
    LoadingSubtitle = "by raymond",
    Theme = "Default",
    ToggleUIKeybind = "K",
})

local MainTab = Window:CreateTab("🏠 Main", nil)
MainTab:CreateSection("Player")

MainTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 300},
    Increment = 1,
    CurrentValue = 16,
    Suffix = "Speed",
    Callback = function(Value)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = Value
        end
    end
})

local infJumpEnabled = false
MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        infJumpEnabled = Value
    end
})
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

MainTab:CreateButton({
    Name = "Clone Me (Original Look)",
    Callback = function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        if not char then return end
        local clone = char:Clone()
        clone.Name = player.Name .. "_Clone"
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local cloneHrp = clone:FindFirstChild("HumanoidRootPart")
        if hrp and cloneHrp then
            cloneHrp.CFrame = hrp.CFrame * CFrame.new(5,0,0)
        end
        clone.Parent = workspace
        local humanoid = clone:FindFirstChildOfClass("Humanoid")
        if humanoid and not humanoid:FindFirstChildOfClass("Animator") then
            Instance.new("Animator", humanoid)
        end
        Rayfield:Notify({Title="Clone Created", Content="Your clone looks exactly like you", Duration=4})
    end
})

local FlyTab = Window:CreateTab("🕊 Fly", nil)
FlyTab:CreateSection("Fly Controls")

local flying = false
local flySpeed = 50
local player = game.Players.LocalPlayer
local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
local bv, bg = nil, nil
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")

local function startFly()
    local char = player.Character
    if not char then return end
    hrp = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(1e5,1e5,1e5)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp
    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp
    humanoid.PlatformStand = true
    flying = true
end

local function stopFly()
    flying = false
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
    end
end

FlyTab:CreateToggle({
    Name = "Enable Fly",
    CurrentValue = false,
    Callback = function(val)
        if val then
            startFly()
        else
            stopFly()
        end
    end
})

FlyTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10,300},
    Increment = 5,
    CurrentValue = flySpeed,
    Suffix = "Speed",
    Callback = function(val)
        flySpeed = val
    end
})

RunService.RenderStepped:Connect(function()
    if flying and hrp and bv and bg and player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            local move = humanoid.MoveDirection
            local up = 0
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then up = 1
            elseif UserInputService:IsKeyDown(Enum.KeyCode.Q) then up = -1
            end
            bv.Velocity = Vector3.new(move.X, up, move.Z) * flySpeed
            bg.CFrame = Camera.CFrame
        end
    end
end)

player.CharacterAdded:Connect(function()
    wait(1)
    if flying then
        startFly()
    end
end)

local BloxTab = Window:CreateTab("🍌 Blox Fruits", nil)
BloxTab:CreateSection("Auto Farm & Utilities")

local killAuraEnabled = false
BloxTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Callback = function(val)
        killAuraEnabled = val
        spawn(function()
            while killAuraEnabled do
                local char = player.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    for i,v in pairs(game.Workspace.Enemies:GetChildren()) do
                        if v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude < 15 then
                            v.Humanoid.Health = 0
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})
