-- ============================================
-- PS99 HUB - VELVET EDITION (FIXED V2)
-- ============================================

-- 1. LOAD VELVET
local Velvet
pcall(function()
    Velvet = loadstring(game:HttpGet("https://raw.githubusercontent.com/DexCodeSX/Velvet/main/Library.lua"))()
end)

if not Velvet then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "ERROR",
        Text = "Gagal load Velvet UI!",
        Duration = 5
    })
    return
end

-- 2. BIKIN WINDOW
local Window = Velvet:CreateWindow({
    Title = "PS99 Hub",
    SubTitle = "Velvet Edition",
    ToggleKey = Enum.KeyCode.RightShift,
})

-- 3. VARIABEL
_G.autoCollect = false
_G.autoHatch = false
_G.autoSell = false
_G.autoBuy = false
_G.autoRebirth = false
_G.autoUpgrade = false
_G.autoRankUp = false
_G.autoClaim = false
_G.autoDelete = false
_G.autoEquipBest = false
_G.walkSpeed = 16
_G.jumpPower = 50
_G.fly = false
_G.noclip = false
_G.infiniteJump = false
_G.antiAfk = true
_G.espCoins = false
_G.espBreakables = false

-- 4. FUNGSI REMOTE
local function fireRemote(name)
    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local remote = rs:FindFirstChild(name, true)
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer()
        elseif remote and remote:IsA("RemoteFunction") then
            remote:InvokeServer()
        end
    end)
end

-- 5. AUTO COLLECT
local function autoCollect()
    pcall(function()
        local char = game.Players.LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local hrp = char.HumanoidRootPart
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:lower():find("coin") or v.Name:lower():find("breakable")) then
                if (hrp.Position - v.Position).Magnitude < 500 then
                    hrp.CFrame = v.CFrame
                    task.wait(0.05)
                end
            end
        end
    end)
end

-- 6. LOOP UTAMA
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            if _G.autoCollect then autoCollect() end
            if _G.autoHatch then fireRemote("Hatch") end
            if _G.autoSell then fireRemote("Sell") end
            if _G.autoBuy then fireRemote("Buy") end
            if _G.autoRebirth then fireRemote("Rebirth") end
            if _G.autoUpgrade then fireRemote("Upgrade") end
            if _G.autoRankUp then fireRemote("RankUp") end
            if _G.autoClaim then fireRemote("Claim") end
            if _G.autoDelete then fireRemote("Delete") end
            if _G.autoEquipBest then fireRemote("EquipBest") end
        end)
    end
end)

-- 7. MOVEMENT
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

runService.Heartbeat:Connect(function()
    pcall(function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = _G.walkSpeed
            char.Humanoid.JumpPower = _G.jumpPower
            if _G.noclip then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end
    end)
end)

userInput.JumpRequest:Connect(function()
    if _G.infiniteJump then
        pcall(function()
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(60) do
        if _G.antiAfk then
            pcall(function()
                game:GetService("VirtualUser"):CaptureController()
                game:GetService("VirtualUser"):ClickButton1(Vector2.new())
            end)
        end
    end
end)

-- 8. ESP
local function createESP(obj, color)
    if not obj or not obj:IsA("BasePart") then return end
    if obj:FindFirstChild("PS99_ESP") then return end
    local box = Instance.new("BoxHandleAdornment")
    box.Name = "PS99_ESP"
    box.Size = Vector3.new(4, 4, 4)
    box.Adornee = obj
    box.ZIndex = 0
    box.Color3 = color
    box.Transparency = 0.5
    box.AlwaysOnTop = true
    box.Parent = obj
end

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if _G.espCoins then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name:lower():find("coin") then
                        createESP(v, Color3.new(1, 1, 0))
                    end
                end
            end
            if _G.espBreakables then
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and (v.Name:lower():find("breakable") or v.Name:lower():find("chest")) then
                        createESP(v, Color3.new(1, 0, 0))
                    end
                end
            end
        end)
    end
end)

-- 9. UI TABS
local MainTab = Window:AddTab("Main", "home")
local PlayerTab = Window:AddTab("Player", "user")
local EspTab = Window:AddTab("ESP", "eye")
local MiscTab = Window:AddTab("Misc", "settings")

-- 10. MAIN TAB
local AutoSection = MainTab:AddSection("Auto Farm")

AutoSection:AddToggle("AutoCollect", {
    Text = "Auto Collect",
    Default = false,
    Callback = function(v) _G.autoCollect = v end
})
AutoSection:AddToggle("AutoHatch", {
    Text = "Auto Hatch",
    Default = false,
    Callback = function(v) _G.autoHatch = v end
})
AutoSection:AddToggle("AutoSell", {
    Text = "Auto Sell",
    Default = false,
    Callback = function(v) _G.autoSell = v end
})
AutoSection:AddToggle("AutoBuy", {
    Text = "Auto Buy Egg",
    Default = false,
    Callback = function(v) _G.autoBuy = v end
})
AutoSection:AddToggle("AutoRebirth", {
    Text = "Auto Rebirth",
    Default = false,
    Callback = function(v) _G.autoRebirth = v end
})
AutoSection:AddToggle("AutoUpgrade", {
    Text = "Auto Upgrade",
    Default = false,
    Callback = function(v) _G.autoUpgrade = v end
})
AutoSection:AddToggle("AutoRankUp", {
    Text = "Auto Rank Up",
    Default = false,
    Callback = function(v) _G.autoRankUp = v end
})
AutoSection:AddToggle("AutoClaim", {
    Text = "Auto Claim",
    Default = false,
    Callback = function(v) _G.autoClaim = v end
})
AutoSection:AddToggle("AutoDelete", {
    Text = "Auto Delete Pet",
    Default = false,
    Callback = function(v) _G.autoDelete = v end
})
AutoSection:AddToggle("AutoEquip", {
    Text = "Auto Equip Best",
    Default = false,
    Callback = function(v) _G.autoEquipBest = v end
})

-- 11. PLAYER TAB
local MoveSection = PlayerTab:AddSection("Movement")

MoveSection:AddSlider("WalkSpeed", {
    Text = "WalkSpeed",
    Min = 1,
    Max = 200,
    Default = 16,
    Increment = 1,
    Callback = function(v) _G.walkSpeed = v end
})
MoveSection:AddSlider("JumpPower", {
    Text = "JumpPower",
    Min = 1,
    Max = 500,
    Default = 50,
    Increment = 1,
    Callback = function(v) _G.jumpPower = v end
})
MoveSection:AddToggle("Fly", {
    Text = "Fly",
    Default = false,
    Callback = function(v) _G.fly = v end
})
MoveSection:AddToggle("Noclip", {
    Text = "Noclip",
    Default = false,
    Callback = function(v) _G.noclip = v end
})
MoveSection:AddToggle("InfJump", {
    Text = "Infinite Jump",
    Default = false,
    Callback = function(v) _G.infiniteJump = v end
})
MoveSection:AddToggle("AntiAfk", {
    Text = "Anti AFK",
    Default = true,
    Callback = function(v) _G.antiAfk = v end
})

-- 12. ESP TAB
local EspSection = EspTab:AddSection("ESP Settings")

EspSection:AddToggle("EspCoin", {
    Text = "ESP Coins",
    Default = false,
    Callback = function(v) _G.espCoins = v end
})
EspSection:AddToggle("EspBreak", {
    Text = "ESP Breakables",
    Default = false,
    Callback = function(v) _G.espBreakables = v end
})

-- 13. MISC TAB
local ServerSection = MiscTab:AddSection("Server")

ServerSection:AddButton({
    Text = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
})
ServerSection:AddButton({
    Text = "Destroy UI",
    Callback = function()
        Window:Destroy()
    end
})

-- 14. NOTIF
pcall(function()
    Velvet:Notify({
        Title = "PS99 Hub Loaded",
        Content = "Velvet Edition siap!",
        Duration = 5,
    })
end)

print("PS99 Hub Loaded!")
