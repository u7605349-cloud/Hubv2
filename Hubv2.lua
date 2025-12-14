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
            cloneHrp.CFrame = hrp.CFrame * CFrame.new(5, 0, 0)
        end
        clone.Parent = workspace
        local humanoid = clone:FindFirstChildOfClass("Humanoid")
        if humanoid and not humanoid:FindFirstChildOfClass("Animator") then
            local animator = Instance.new("Animator")
            animator.Parent = humanoid
        end
        Rayfield:Notify({
            Title = "Clone Created",
            Content = "Your clone looks exactly like you",
            Duration = 4
        })
    end
})
local FlyTab = Window:CreateTab("🕊 Fly", nil)
FlyTab:CreateSection("Fly Controls")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local flying = false
local flySpeed = 60
local bv, bg, flyConn
local move = {w=0,a=0,s=0,d=0,q=0,e=0}
local function toggleFly(state)
    flying = state
    local char = player.Character
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
            local dir =
                (cam.CFrame.LookVector * (move.w - move.s)) +
                (cam.CFrame.RightVector * (move.d - move.a)) +
                (Vector3.new(0,1,0) * (move.e - move.q))
            if dir.Magnitude > 0 then
                bv.Velocity = dir.Unit * flySpeed
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
    Range = {10, 200},
    Increment = 5,
    CurrentValue = 60,
    Suffix = "Speed",
    Callback = function(Value)
        flySpeed = Value
    end
})
UIS.InputBegan:Connect(function(i,g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.W then move.w=1 end
    if i.KeyCode == Enum.KeyCode.A then move.a=1 end
    if i.KeyCode == Enum.KeyCode.S then move.s=1 end
    if i.KeyCode == Enum.KeyCode.D then move.d=1 end
    if i.KeyCode == Enum.KeyCode.E then move.e=1 end
    if i.KeyCode == Enum.KeyCode.Q then move.q=1 end
end)
UIS.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.W then move.w=0 end
    if i.KeyCode == Enum.KeyCode.A then move.a=0 end
    if i.KeyCode == Enum.KeyCode.S then move.s=0 end
    if i.KeyCode == Enum.KeyCode.D then move.d=0 end
    if i.KeyCode == Enum.KeyCode.E then move.e=0 end
    if i.KeyCode == Enum.KeyCode.Q then move.q=0 end
end)
