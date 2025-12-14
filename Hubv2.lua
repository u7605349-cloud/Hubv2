local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
local Window = Rayfield:CreateWindow({
    Name = "Raymond Hub",
    LoadingTitle = "Rayfield UI",
    LoadingSubtitle = "by raymond",
    Theme = "Default",
    ToggleUIKeybind = "K",
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- MAIN TAB
local MainTab = Window:CreateTab("🏠 Main", nil)
MainTab:CreateSection("Player")

MainTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 300},
    Increment = 1,
    CurrentValue = 16,
    Suffix = "Speed",
    Callback = function(Value)
        local char = LocalPlayer.Character
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
UIS.JumpRequest:Connect(function()
    if infJumpEnabled then
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

MainTab:CreateButton({
    Name = "Clone Me (Original Look)",
    Callback = function()
        local char = LocalPlayer.Character
        if not char then return end
        local clone = char:Clone()
        clone.Name = LocalPlayer.Name.."_Clone"
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

-- FLY TAB
local FlyTab = Window:CreateTab("🕊 Fly", nil)
FlyTab:CreateSection("Fly Controls")

local savedSpeed = 50
local flying = false
local flySpeed = savedSpeed
local bodyVelocity
local bodyGyro
local move = {w=0, a=0, s=0, d=0, q=0, e=0}

local function setupFly()
    local char = LocalPlayer.Character
    if not char then return end
    local HRP = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")
    local Camera = workspace.CurrentCamera

    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5,1e5,1e5)

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5,1e5,1e5)

    RunService:BindToRenderStep("FlyMovement", Enum.RenderPriority.Camera.Value, function()
        if not flying then return end
        local dir = Vector3.zero
        local camCF = Camera.CFrame
        if move.w ~= 0 then dir += camCF.LookVector * move.w end
        if move.s ~= 0 then dir -= camCF.LookVector * move.s end
        if move.a ~= 0 then dir -= camCF.RightVector * move.a end
        if move.d ~= 0 then dir += camCF.RightVector * move.d end
        if move.e ~= 0 then dir += Vector3.yAxis * move.e end
        if move.q ~= 0 then dir -= Vector3.yAxis * move.q end
        if dir.Magnitude > 0 then dir = dir.Unit end
        bodyVelocity.Velocity = dir * flySpeed
        bodyGyro.CFrame = camCF
    end)
end

local function startFlying()
    local char = LocalPlayer.Character
    if not char then return end
    local HRP = char:WaitForChild("HumanoidRootPart")
    local humanoid = char:WaitForChild("Humanoid")
    bodyVelocity.Parent = HRP
    bodyGyro.Parent = HRP
    humanoid.PlatformStand = true
    flying = true
end

local function stopFlying()
    flying = false
    if bodyVelocity then bodyVelocity.Parent = nil end
    if bodyGyro then bodyGyro.Parent = nil end
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.PlatformStand = false
    end
end

FlyTab:CreateToggle({
    Name = "Enable Fly",
    CurrentValue = false,
    Callback = function(Value)
        flying = Value
        if Value then
            setupFly()
            startFlying()
        else
            stopFlying()
        end
    end
})

FlyTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 5,
    CurrentValue = savedSpeed,
    Suffix = "Speed",
    Callback = function(Value)
        flySpeed = Value
        savedSpeed = Value
    end
})

UIS.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.W then move.w = 1 end
    if input.KeyCode == Enum.KeyCode.S then move.s = 1 end
    if input.KeyCode == Enum.KeyCode.A then move.a = 1 end
    if input.KeyCode == Enum.KeyCode.D then move.d = 1 end
    if input.KeyCode == Enum.KeyCode.E then move.e = 1 end
    if input.KeyCode == Enum.KeyCode.Q then move.q = 1 end
end)

UIS.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then move.w = 0 end
    if input.KeyCode == Enum.KeyCode.S then move.s = 0 end
    if input.KeyCode == Enum.KeyCode.A then move.a = 0 end
    if input.KeyCode == Enum.KeyCode.D then move.d = 0 end
    if input.KeyCode == Enum.KeyCode.E then move.e = 0 end
    if input.KeyCode == Enum.KeyCode.Q then move.q = 0 end
end)

LocalPlayer.CharacterAdded:Connect(function()
    flying = false
    setupFly()
end)

-- BLOX FRUITS TAB
local BloxFruitsTab = Window:CreateTab("🍉 Blox Fruits", nil)
BloxFruitsTab:CreateSection("Blox Fruits Scripts")

local killAuraEnabled = false
BloxFruitsTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Callback = function(Value)
        killAuraEnabled = Value
        spawn(function()
            while killAuraEnabled do
                for _, npc in pairs(workspace.Enemies:GetChildren()) do
                    if npc:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0,3,0)
                        if npc:FindFirstChildOfClass("Humanoid") then
                            npc:FindFirstChildOfClass("Humanoid").Health = 0
                        end
                    end
                end
                task.wait(0.1)
            end
        end)
    end
})

local hideOtherPlayersEnabled = false
local function hideCharacterForOthers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("MeshPart") then
                    part.Transparency = 1
                    local decal = part:FindFirstChildOfClass("Decal")
                    if decal then decal.Transparency = 1 end
                elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
                    part.Enabled = false
                end
            end
        end
    end
end

local function showCharacterForOthers()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") or part:IsA("MeshPart") then
                    part.Transparency = 0
                    local decal = part:FindFirstChildOfClass("Decal")
                    if decal then decal.Transparency = 0 end
                elseif part:IsA("BillboardGui") or part:IsA("SurfaceGui") then
                    part.Enabled = true
                end
            end
        end
    end
end

BloxFruitsTab:CreateToggle({
    Name = "Hide Other Players",
    CurrentValue = false,
    Callback = function(Value)
        hideOtherPlayersEnabled = Value
        if Value then
            hideCharacterForOthers()
        else
            showCharacterForOthers()
        end
    end
})

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function()
        if hideOtherPlayersEnabled then
            hideCharacterForOthers()
        end
    end)
end)
