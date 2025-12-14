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

local FlyTab = Window:CreateTab("🕊 Fly", nil)
FlyTab:CreateSection("Fly Controls")
local flying = false
local flySpeed = 60
local bv, bg, flyConn
local move = {w=0,a=0,s=0,d=0,q=0,e=0}

local function toggleFly(state)
    flying = state
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if flying then
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e5,1e5,1e5)
        bg = Instance.new("BodyGyro", hrp)
        bg.MaxTorque = Vector3.new(1e5,1e5,1e5)
        bg.P = 1e4
        flyConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            local dir = (cam.CFrame.LookVector*(move.w-move.s) + cam.CFrame.RightVector*(move.d-move.a) + Vector3.new(0,1,0)*(move.e-move.q))
            if dir.Magnitude>0 then
                bv.Velocity = dir.Unit*flySpeed
            else
                bv.Velocity = Vector3.zero
            end
            bg.CFrame = cam.CFrame
        end)
    else
        if flyConn then flyConn:Disconnect() end
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end

FlyTab:CreateToggle({
    Name = "Enable Fly",
    CurrentValue = false,
    Callback = function(Value)
        toggleFly(Value)
    end
})

FlyTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10,200},
    Increment = 5,
    CurrentValue = 60,
    Suffix = "Speed",
    Callback = function(Value)
        flySpeed = Value
    end
})

UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode==Enum.KeyCode.W then move.w=1 end
    if i.KeyCode==Enum.KeyCode.A then move.a=1 end
    if i.KeyCode==Enum.KeyCode.S then move.s=1 end
    if i.KeyCode==Enum.KeyCode.D then move.d=1 end
    if i.KeyCode==Enum.KeyCode.E then move.e=1 end
    if i.KeyCode==Enum.KeyCode.Q then move.q=1 end
end)

UIS.InputEnded:Connect(function(i)
    if i.KeyCode==Enum.KeyCode.W then move.w=0 end
    if i.KeyCode==Enum.KeyCode.A then move.a=0 end
    if i.KeyCode==Enum.KeyCode.S then move.s=0 end
    if i.KeyCode==Enum.KeyCode.D then move.d=0 end
    if i.KeyCode==Enum.KeyCode.E then move.e=0 end
    if i.KeyCode==Enum.KeyCode.Q then move.q=0 end
end)

local BloxFruitsTab = Window:CreateTab("🍉 Blox Fruits", nil)
BloxFruitsTab:CreateSection("Blox Fruits Scripts")

-- example: Kill Aura toggle
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
