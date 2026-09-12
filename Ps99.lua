-- ============================================
-- PS99 ULTIMATE HUB - VELVET EDITION
-- Gabungan dari berbagai open-source
-- ============================================

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

local Window = Velvet:CreateWindow({
    Title = "PS99 Ultimate Hub",
    SubTitle = "Velvet Edition",
    ToggleKey = Enum.KeyCode.RightShift,
})

-- ============================================
-- VARIABEL
-- ============================================
_G = _G or {}
_G.autoBreak = false
_G.autoCollect = false
_G.autoHatch = false
_G.autoRank = false
_G.autoRebirth = false
_G.autoMiniGames = false
_G.autoDaycare = false
_G.autoVending = false
_G.autoConsumable = false
_G.autoRedeem = false
_G.autoEquipBest = false
_G.fly = false
_G.noclip = false
_G.infiniteJump = false
_G.antiAfk = true
_G.walkSpeed = 16
_G.jumpPower = 50
_G.selectedEgg = "Auto"
_G.espCoins = false
_G.espEggs = false
_G.espBreakables = false

-- ============================================
-- CORE SERVICES
-- ============================================
local RS = game:GetService("ReplicatedStorage")
local Network = RS:WaitForChild("Network")
local Workspace = game:GetService("Workspace")
local Things = Workspace:WaitForChild("__THINGS")
local Lootbags = Things:WaitForChild("Lootbags")
local Orbs = Things:WaitForChild("Orbs")
local Breakables = Things:WaitForChild("Breakables")
local Coins = Things:FindFirstChild("Coins") or Things:FindFirstChild("CoinDrops")

-- ============================================
-- FUNGSI REMOTE AMAN
-- ============================================
local function fireRemote(name, ...)
    local args = {...}
    pcall(function()
        local remote = Network:FindFirstChild(name, true)
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(unpack(args))
        elseif remote and remote:IsA("RemoteFunction") then
            remote:InvokeServer(unpack(args))
        end
    end)
end

local function invokeRemote(name, ...)
    local args = {...}
    local result = nil
    pcall(function()
        local remote = Network:FindFirstChild(name, true)
        if remote and remote:IsA("RemoteFunction") then
            result = remote:InvokeServer(unpack(args))
        end
    end)
    return result
end

-- ============================================
-- AUTO FARM
-- ============================================
local function autoBreak()
    pcall(function()
        for _, v in pairs(Breakables:GetChildren()) do
            if v:IsA("BasePart") or v:IsA("Model") then
                local part = v:IsA("Model") and v.PrimaryPart or v
                if part then
                    local args = { [1] = { [1] = v, [2] = part.Position } }
                    fireRemote("Breakables_RequestHit", unpack(args))
                end
            end
        end
    end)
end

local function autoCollect()
    pcall(function()
        -- Klaim Lootbags
        for _, v in pairs(Lootbags:GetChildren()) do
            if v then
                fireRemote("Lootbags_Claim", { [1] = { [1] = v.Name } })
            end
        end
        -- Klaim Orbs
        for _, v in pairs(Orbs:GetChildren()) do
            if v then
                fireRemote("Orbs: Collect", { [1] = { [1] = tonumber(v.Name) } })
            end
        end
        -- Klaim Coins
        if Coins then
            for _, v in pairs(Coins:GetChildren()) do
                if v then
                    fireRemote("Coins_Collect", v)
                end
            end
        end
    end)
end

-- ============================================
-- AUTO HATCH
-- ============================================
local function findNearestEgg()
    local char = game.Players.LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local hrp = char.HumanoidRootPart
    local nearest, nearestDist = nil, math.huge
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Name:lower():find("egg") then
            local dist = (hrp.Position - v.Position).Magnitude
            if dist < nearestDist then
                nearestDist = dist
                nearest = v
            end
        end
    end
    return nearest
end

local function autoHatch()
    pcall(function()
        local egg = findNearestEgg()
        if _G.selectedEgg ~= "Auto" and egg then
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find(_G.selectedEgg:lower()) then
                    egg = v
                    break
                end
            end
        end
        if egg then
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = egg.CFrame + Vector3.new(0, 5, 0)
            end
            for i = 1, 50 do
                fireRemote("Eggs_RequestHatch", egg)
                task.wait(0.1)
            end
        end
    end)
end

-- ============================================
-- AUTO RANK & REBIRTH
-- ============================================
local function autoRank()
    pcall(function()
        fireRemote("Rank_RequestRankUp")
        fireRemote("RankUp")
    end)
end

local function autoRebirth()
    pcall(function()
        fireRemote("Rebirth_RequestRebirth")
        fireRemote("Rebirth")
    end)
end

-- ============================================
-- AUTO MINI GAMES
-- ============================================
local function autoMiniGames()
    pcall(function()
        -- Auto fish
        fireRemote("Fishing_RequestCast")
        task.wait(0.5)
        fireRemote("Fishing_RequestReel")
        -- Auto dig
        fireRemote("Digging_RequestDig")
        -- Auto chest
        fireRemote("Chests_RequestClaim")
        -- Auto treasure
        fireRemote("Treasure_RequestOpen")
    end)
end

-- ============================================
-- AUTO DAYCARE
-- ============================================
local function autoDaycare()
    pcall(function()
        fireRemote("Daycare_RequestClaim")
        fireRemote("Daycare_RequestDeposit")
    end)
end

-- ============================================
-- AUTO VENDING MACHINE
-- ============================================
local function autoVending()
    pcall(function()
        fireRemote("VendingMachine_RequestPurchase")
    end)
end

-- ============================================
-- AUTO CONSUMABLE
-- ============================================
local function autoConsumable()
    pcall(function()
        fireRemote("Consumables_RequestUse", "Potion")
        fireRemote("Consumables_RequestUse", "Event")
    end)
end

-- ============================================
-- AUTO REDEEM
-- ============================================
local function autoRedeem()
    pcall(function()
        fireRemote("Rewards_RequestClaim")
        fireRemote("Codes_RequestRedeem")
    end)
end

-- ============================================
-- AUTO EQUIP BEST
-- ============================================
local function autoEquipBest()
    pcall(function()
        fireRemote("Pets_RequestEquipBest")
    end)
end

-- ============================================
-- MOVEMENT
-- ============================================
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

-- Anti AFK
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    if _G.antiAfk then
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
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
        pcall(function()
            if _G.espCoins and Coins then
                for _, v in pairs(Coins:GetChildren()) do
                    if v:IsA("BasePart") then createESP(v, Color3.new(1, 1, 0)) end
                end
            end
            if _G.espBreakables then
                for _, v in pairs(Breakables:GetChildren()) do
                    local part = v:IsA("Model") and v.PrimaryPart or v
                    if part then createESP(part, Color3.new(1, 0, 0)) end
                end
            end
            if _G.espEggs then
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name:lower():find("egg") then
                        createESP(v, Color3.new(0, 1, 0))
                    end
                end
            end
        end)
    end
end)

-- ============================================
-- LOOP UTAMA
-- ============================================
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            if _G.autoBreak then autoBreak() end
            if _G.autoCollect then autoCollect() end
            if _G.autoHatch then autoHatch() end
            if _G.autoRank then autoRank() end
            if _G.autoRebirth then autoRebirth() end
            if _G.autoMiniGames then autoMiniGames() end
            if _G.autoDaycare then autoDaycare() end
            if _G.autoVending then autoVending() end
            if _G.autoConsumable then autoConsumable() end
            if _G.autoRedeem then autoRedeem() end
            if _G.autoEquipBest then autoEquipBest() end
        end)
    end
end)

-- ============================================
-- UI TABS
-- ============================================
local FarmTab = Window:AddTab("Auto Farm", "pickaxe")
local HatchTab = Window:AddTab("Auto Hatch", "egg")
local GamesTab = Window:AddTab("Mini Games", "gamepad-2")
local MiscTab = Window:AddTab("Misc", "settings")
local EspTab = Window:AddTab("ESP", "eye")

-- AUTO FARM
local FarmSection = FarmTab:AddSection("Farming")
FarmSection:AddToggle("AutoBreak", { Text = "Auto Break Breakables", Default = false, Callback = function(v) _G.autoBreak = v end })
FarmSection:AddToggle("AutoCollect", { Text = "Auto Collect (Lootbags/Orbs/Coins)", Default = false, Callback = function(v) _G.autoCollect = v end })
FarmSection:AddToggle("AutoRank", { Text = "Auto Rank Up", Default = false, Callback = function(v) _G.autoRank = v end })
FarmSection:AddToggle("AutoRebirth", { Text = "Auto Rebirth", Default = false, Callback = function(v) _G.autoRebirth = v end })

-- AUTO HATCH
local EggSection = HatchTab:AddSection("Egg Settings")
EggSection:AddDropdown("SelectedEgg", { Text = "Select Egg", Values = {"Auto", "Basic", "Common", "Rare", "Epic", "Legendary", "Mythical"}, Default = "Auto", Callback = function(v) _G.selectedEgg = v end })
EggSection:AddToggle("AutoHatch", { Text = "Auto Hatch Egg (Nearest)", Default = false, Callback = function(v) _G.autoHatch = v end })

-- MINI GAMES
local GamesSection = GamesTab:AddSection("Auto Minigames")
GamesSection:AddToggle("AutoMiniGames", { Text = "Auto Mini Games (Fish/Dig/Chest)", Default = false, Callback = function(v) _G.autoMiniGames = v end })
GamesSection:AddToggle("AutoDaycare", { Text = "Auto Daycare", Default = false, Callback = function(v) _G.autoDaycare = v end })
GamesSection:AddToggle("AutoVending", { Text = "Auto Vending Machine", Default = false, Callback = function(v) _G.autoVending = v end })
GamesSection:AddToggle("AutoConsumable", { Text = "Auto Consumable (Potion/Event)", Default = false, Callback = function(v) _G.autoConsumable = v end })
GamesSection:AddToggle("AutoRedeem", { Text = "Auto Redeem Reward", Default = false, Callback = function(v) _G.autoRedeem = v end })
GamesSection:AddToggle("AutoEquipBest", { Text = "Auto Equip Best", Default = false, Callback = function(v) _G.autoEquipBest = v end })

-- MISC
local MoveSection = MiscTab:AddSection("Movement")
MoveSection:AddSlider("WalkSpeed", { Text = "WalkSpeed", Min = 1, Max = 200, Default = 16, Increment = 1, Callback = function(v) _G.walkSpeed = v end })
MoveSection:AddSlider("JumpPower", { Text = "JumpPower", Min = 1, Max = 500, Default = 50, Increment = 1, Callback = function(v) _G.jumpPower = v end })
MoveSection:AddToggle("Fly", { Text = "Fly", Default = false, Callback = function(v) _G.fly = v end })
MoveSection:AddToggle("Noclip", { Text = "Noclip", Default = false, Callback = function(v) _G.noclip = v end })
MoveSection:AddToggle("InfJump", { Text = "Infinite Jump", Default = false, Callback = function(v) _G.infiniteJump = v end })
MoveSection:AddToggle("AntiAfk", { Text = "Anti AFK", Default = true, Callback = function(v) _G.antiAfk = v end })

local ServerSection = MiscTab:AddSection("Server")
ServerSection:AddButton({ Text = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId) end })
ServerSection:AddButton({ Text = "Destroy UI", Callback = function() Window:Destroy() end })

-- ESP
local EspSection = EspTab:AddSection("ESP Settings")
EspSection:AddToggle("EspCoins", { Text = "ESP Coins", Default = false, Callback = function(v) _G.espCoins = v end })
EspSection:AddToggle("EspBreakables", { Text = "ESP Breakables", Default = false, Callback = function(v) _G.espBreakables = v end })
EspSection:AddToggle("EspEggs", { Text = "ESP Eggs", Default = false, Callback = function(v) _G.espEggs = v end })

-- ============================================
-- NOTIFIKASI
-- ============================================
pcall(function()
    Velvet:Notify({ Title = "PS99 Ultimate Hub", Content = "Loaded!", Duration = 5 })
end)

print("PS99 Ultimate Hub Loaded!")
