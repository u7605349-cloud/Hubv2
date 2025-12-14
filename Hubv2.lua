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

local FunTab = Window:CreateTab("🎉 Fun", nil)
FunTab:CreateSection("Fun Scripts")

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

FunTab:CreateToggle({
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
