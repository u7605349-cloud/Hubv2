local Rayfield = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()

local Window = Rayfield:CreateWindow({
    Name = "Raymond hub",
    Icon = 0,
    LoadingTitle = "Rayfield Interface Suite",
    LoadingSubtitle = "by raymond",
    ShowText = "Rayfield",
    Theme = "Default",
    ToggleUIKeybind = "K",

    ConfigurationSaving = {
        Enabled = true,
        FolderName = nil,
        FileName = "Big Hub"
    },

    KeySystem = true,
    KeySettings = {
        Title = "key system",
        Subtitle = "KeyCode",
        Note = "No method of obtaining the key is provided",
        FileName = "raymond1",
        SaveKey = true,
        GrabKeyFromSite = true,
        Key = {"https://pastebin.com/raw/e22b7rVf"}
    }
})

local MainTab = Window:CreateTab("🏠", nil)
MainTab:CreateSection("main")

Rayfield:Notify({
    Title = "u activated script",
    Content = "best ui",
    Duration = 6.5
})

MainTab:CreateButton({
    Name = "Infinite Jump",
    Callback = function()
        local u = game:GetService("UserInputService")
        local p = game.Players.LocalPlayer
        u.JumpRequest:Connect(function()
            if p.Character and p.Character:FindFirstChildOfClass("Humanoid") then
                p.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
})

MainTab:CreateSlider({
    Name = "walk speed",
    Range = {0,300},
    Increment = 1,
    Suffix = "speed",
    CurrentValue = 16,
    Callback = function(Value)
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end
})

local FlyTab = Window:CreateTab("fly", nil)
FlyTab:CreateSection("fly script")

FlyTab:CreateButton({
    Name = "fly (press F)",
    Callback = function()
        local p = game.Players.LocalPlayer
        local u = game:GetService("UserInputService")
        local r = game:GetService("RunService")

        local flying = false
        local bv, bg, conn
        local speed = 50
        local dir = {w=0,a=0,s=0,d=0,q=0,e=0}

        local function toggle()
            local c = p.Character
            if not c then return end
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if not hrp then return end

            flying = not flying

            if flying then
                bv = Instance.new("BodyVelocity", hrp)
                bv.MaxForce = Vector3.new(1,1,1) * 1e5
                bg = Instance.new("BodyGyro", hrp)
                bg.MaxTorque = Vector3.new(1,1,1) * 1e5
                bg.P = 1e4

                conn = r.RenderStepped:Connect(function()
                    local cam = workspace.CurrentCamera
                    local move =
                        cam.CFrame.LookVector * (dir.w - dir.s) +
                        cam.CFrame.RightVector * (dir.d - dir.a) +
                        Vector3.new(0,1,0) * (dir.e - dir.q)

                    if move.Magnitude > 0 then
                        bv.Velocity = move.Unit * speed
                    else
                        bv.Velocity = Vector3.zero
                    end

                    bg.CFrame = cam.CFrame
                end)
            else
                if conn then conn:Disconnect() end
                if bv then bv:Destroy() end
                if bg then bg:Destroy() end
            end
        end

        u.InputBegan:Connect(function(i,g)
            if g then return end
            if i.KeyCode == Enum.KeyCode.F then toggle() end
            if i.KeyCode == Enum.KeyCode.W then dir.w=1 end
            if i.KeyCode == Enum.KeyCode.A then dir.a=1 end
            if i.KeyCode == Enum.KeyCode.S then dir.s=1 end
            if i.KeyCode == Enum.KeyCode.D then dir.d=1 end
            if i.KeyCode == Enum.KeyCode.E then dir.e=1 end
            if i.KeyCode == Enum.KeyCode.Q then dir.q=1 end
        end)

        u.InputEnded:Connect(function(i)
            if i.KeyCode == Enum.KeyCode.W then dir.w=0 end
            if i.KeyCode == Enum.KeyCode.A then dir.a=0 end
            if i.KeyCode == Enum.KeyCode.S then dir.s=0 end
            if i.KeyCode == Enum.KeyCode.D then dir.d=0 end
            if i.KeyCode == Enum.KeyCode.E then dir.e=0 end
            if i.KeyCode == Enum.KeyCode.Q then dir.q=0 end
        end)
    end
})
