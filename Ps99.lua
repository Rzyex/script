-- ============================================
-- PET SIMULATOR 99 - VELVET UI EDITION
-- ============================================

-- 1. LOAD LIBRARY & ADDONS
local repo = "https://raw.githubusercontent.com/DexCodeSX/Velvet/main/"
local Velvet = loadstring(game:HttpGet(repo .. "Library.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local Icons = loadstring(game:HttpGet(repo .. "addons/Icons.lua"))()

-- 2. SETUP
Velvet:SetIcons(Icons)
SaveManager:Bind(Velvet, "PS99Hub")
ThemeManager:Bind(Velvet)

-- 3. BIKIN WINDOW
local Window = Velvet:CreateWindow({
    Title = "PS99 Hub",
    SubTitle = "Velvet Edition",
    ToggleKey = Enum.KeyCode.RightShift,
    ToggleIcon = "sparkles",
})

-- ============================================
-- VARIABEL
-- ============================================
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

-- ============================================
-- REMOTE HANDLER
-- ============================================
local function fireRemote(name, ...)
    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local remote = rs:FindFirstChild(name, true)
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(...)
        elseif remote and remote:IsA("RemoteFunction") then
            remote:InvokeServer(...)
        end
    end)
end

-- ============================================
-- AUTO COLLECT
-- ============================================
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

-- ============================================
-- LOOP UTAMA
-- ============================================
task.spawn(function()
    while task.wait(0.5) do
        if _G.autoCollect then autoCollect() end
        if _G.autoHatch then fireRemote("Hatch") fireRemote("HatchEgg") end
        if _G.autoSell then fireRemote("Sell") fireRemote("SellPet") end
        if _G.autoBuy then fireRemote("Buy") fireRemote("BuyEgg") end
        if _G.autoRebirth then fireRemote("Rebirth") end
        if _G.autoUpgrade then fireRemote("Upgrade") end
        if _G.autoRankUp then fireRemote("RankUp") end
        if _G.autoClaim then fireRemote("Claim") end
        if _G.autoDelete then fireRemote("Delete") end
        if _G.autoEquipBest then fireRemote("EquipBest") fireRemote("Equip") end
    end
end)

-- ============================================
-- MOVEMENT
-- ============================================
local runService = game:GetService("RunService")
local userInput = game:GetService("UserInputService")

runService.Heartbeat:Connect(function()
    local char = game.Players.LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = _G.walkSpeed
        char.Humanoid.JumpPower = _G.jumpPower
        if _G.noclip then
            for _, v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
        if _G.fly then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local speed = 50
                local move = Vector3.new()
                if userInput:IsKeyDown(Enum.KeyCode.W) then move = move + workspace.CurrentCamera.CFrame.LookVector end
                if userInput:IsKeyDown(Enum.KeyCode.S) then move = move - workspace.CurrentCamera.CFrame.LookVector end
                if userInput:IsKeyDown(Enum.KeyCode.A) then move = move - workspace.CurrentCamera.CFrame.RightVector end
                if userInput:IsKeyDown(Enum.KeyCode.D) then move = move + workspace.CurrentCamera.CFrame.RightVector end
                if userInput:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0, 1, 0) end
                if userInput:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0, 1, 0) end
                hrp.Velocity = move * speed
            end
        end
    end
end)

userInput.JumpRequest:Connect(function()
    if _G.infiniteJump then
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
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

-- ============================================
-- ESP
-- ============================================
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
    end
end)

-- ============================================
-- UI TABS
-- ============================================
local MainTab = Window:AddTab("Main", "home")
local PlayerTab = Window:AddTab("Player", "user")
local EspTab = Window:AddTab("ESP", "eye")
local MiscTab = Window:AddTab("Misc", "settings")

-- ============================================
-- MAIN TAB
-- ============================================
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

-- ============================================
-- PLAYER TAB
-- ============================================
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

-- ============================================
-- ESP TAB
-- ============================================
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

-- ============================================
-- MISC TAB
-- ============================================
local ServerSection = MiscTab:AddSection("Server")

ServerSection:AddButton({
    Text = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId)
    end
})
ServerSection:AddButton({
    Text = "Server Hop",
    Callback = function()
        local TS = game:GetService("TeleportService")
        local Http = game:GetService("HttpService")
        local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, v in pairs(servers.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then
                TS:TeleportToPlaceInstance(game.PlaceId, v.id)
                break
            end
        end
    end
})
ServerSection:AddButton({
    Text = "Destroy UI",
    Callback = function()
        Window:Destroy()
    end
})

-- ============================================
-- NOTIFIKASI
-- ============================================
Velvet:Notify({
    Title = "PS99 Hub Loaded",
    Content = "Velvet Edition siap digunakan!",
    Duration = 5,
    Type = "success"
})

print("PS99 Hub Velvet Edition Loaded!")
