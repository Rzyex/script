-- ============================================
-- PS99 HUB - VELVET EDITION (REMAKE V3)
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
    Title = "PS99 Hub",
    SubTitle = "Remake V3",
    ToggleKey = Enum.KeyCode.RightShift,
})

-- ============================================
-- VARIABEL
-- ============================================
_G.autoUnlockArena = false
_G.autoTpBestArena = false
_G.autoClick = false
_G.petSpeed = false
_G.petSpeedValue = 2
_G.selectedEgg = "Auto"
_G.autoHatchEgg = false
_G.autoConsumablePotion = false
_G.autoConsumableEvent = false
_G.autoRedeemReward = false
_G.autoEquipBest = false

-- ============================================
-- FUNGSI UTIL
-- ============================================
local function fireRemote(name, ...)
    local args = {...}
    pcall(function()
        local rs = game:GetService("ReplicatedStorage")
        local remote = rs:FindFirstChild(name, true)
        if remote and remote:IsA("RemoteEvent") then
            remote:FireServer(unpack(args))
        elseif remote and remote:IsA("RemoteFunction") then
            remote:InvokeServer(unpack(args))
        end
    end)
end

-- Cari semua remote yang ada di game
local function getRemotes()
    local remotes = {}
    pcall(function()
        for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                remotes[v.Name] = v
            end
        end
    end)
    return remotes
end

-- ============================================
-- 1. AUTO UNLOCK ARENA
-- ============================================
local function autoUnlockArena()
    pcall(function()
        local remotes = getRemotes()
        -- Coba beberapa nama remote yang umum
        for _, name in pairs({"UnlockArena", "UnlockZone", "BuyArena", "ArenaUnlock", "UnlockWorld"}) do
            if remotes[name] then
                remotes[name]:FireServer()
            end
        end
    end)
end

-- ============================================
-- 2. AUTO TP BEST ARENA
-- ============================================
local function autoTpBestArena()
    pcall(function()
        local player = game.Players.LocalPlayer
        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        
        local hrp = char.HumanoidRootPart
        local bestArena = nil
        local bestValue = 0
        
        -- Cari semua arena/zone di workspace
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") or v:IsA("Model") then
                local name = v.Name:lower()
                if name:find("arena") or name:find("zone") or name:find("world") then
                    -- Cek apakah arena ini terbuka
                    local part = v:IsA("Model") and v.PrimaryPart or v
                    if part then
                        -- Ambil nilai tertinggi berdasarkan posisi Y atau nama
                        local val = tonumber(name:match("%d+")) or part.Position.Y
                        if val and val > bestValue then
                            bestValue = val
                            bestArena = part
                        end
                    end
                end
            end
        end
        
        if bestArena then
            hrp.CFrame = bestArena.CFrame + Vector3.new(0, 5, 0)
        end
    end)
end

-- ============================================
-- 3. AUTO CLICK + AUTO COLLECT (MAGNET)
-- ============================================
local function autoClick()
    pcall(function()
        local remotes = getRemotes()
        -- Auto click buat mecah breakables
        for _, name in pairs({"Click", "Hit", "Break", "Mine", "Attack"}) do
            if remotes[name] then
                remotes[name]:FireServer()
            end
        end
        
        -- Magnet collect: kumpulin semua coin/breakable di sekitar player
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local hrp = char.HumanoidRootPart
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and (v.Name:lower():find("coin") or v.Name:lower():find("breakable") or v.Name:lower():find("cash")) then
                    local dist = (hrp.Position - v.Position).Magnitude
                    if dist < 200 then
                        -- Tarik item ke player (magnet effect)
                        v.CFrame = hrp.CFrame
                    end
                end
            end
        end
    end)
end

-- ============================================
-- 4. PET SPEED HACK
-- ============================================
local function petSpeedHack()
    pcall(function()
        local remotes = getRemotes()
        -- Coba remote upgrade speed
        for _, name in pairs({"PetSpeed", "UpgradeSpeed", "SetSpeed", "BuySpeed", "SpeedUpgrade"}) do
            if remotes[name] then
                remotes[name]:FireServer(_G.petSpeedValue)
            end
        end
        
        -- Alternatif: ubah WalkSpeed karakter (biar keliatan cepet)
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = 16 + (_G.petSpeedValue * 5)
        end
    end)
end

-- ============================================
-- 5. AUTO HATCH EGG (DETECT NEAREST + BUY MAX)
-- ============================================
local function findNearestEgg()
    pcall(function()
        local char = game.Players.LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
        local hrp = char.HumanoidRootPart
        
        local nearest = nil
        local nearestDist = math.huge
        
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name:lower():find("egg") then
                local dist = (hrp.Position - v.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = v
                end
            end
        end
        return nearest
    end)
end

local function autoHatch()
    pcall(function()
        local remotes = getRemotes()
        local egg = findNearestEgg()
        
        -- Kalo pilih egg spesifik
        if _G.selectedEgg ~= "Auto" and egg then
            -- Cari egg dengan nama yang cocok
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and v.Name:lower():find(_G.selectedEgg:lower()) then
                    egg = v
                    break
                end
            end
        end
        
        if egg then
            -- Teleport ke egg
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.CFrame = egg.CFrame + Vector3.new(0, 5, 0)
            end
            
            -- Beli egg maksimal (spam remote sampe inventory penuh)
            for i = 1, 50 do
                for _, name in pairs({"BuyEgg", "Hatch", "HatchEgg", "Buy", "PurchaseEgg"}) do
                    if remotes[name] then
                        remotes[name]:FireServer(egg)
                    end
                end
                task.wait(0.1)
            end
        end
    end)
end

-- ============================================
-- 6. AUTO CONSUMABLE POTION
-- ============================================
local function autoConsumablePotion()
    pcall(function()
        local remotes = getRemotes()
        for _, name in pairs({"UsePotion", "ConsumePotion", "DrinkPotion", "UseConsumable"}) do
            if remotes[name] then
                remotes[name]:FireServer("Potion")
            end
        end
    end)
end

-- ============================================
-- 7. AUTO CONSUMABLE EVENT
-- ============================================
local function autoConsumableEvent()
    pcall(function()
        local remotes = getRemotes()
        for _, name in pairs({"UseEvent", "ConsumeEvent", "UseEventItem", "ActivateEvent"}) do
            if remotes[name] then
                remotes[name]:FireServer("Event")
            end
        end
    end)
end

-- ============================================
-- 8. AUTO REDEEM REWARD
-- ============================================
local function autoRedeemReward()
    pcall(function()
        local remotes = getRemotes()
        for _, name in pairs({"Redeem", "ClaimReward", "RedeemCode", "Claim", "RedeemReward"}) do
            if remotes[name] then
                remotes[name]:FireServer()
            end
        end
    end)
end

-- ============================================
-- 9. AUTO EQUIP BEST
-- ============================================
local function autoEquipBest()
    pcall(function()
        local remotes = getRemotes()
        for _, name in pairs({"EquipBest", "Equip", "AutoEquip"}) do
            if remotes[name] then
                remotes[name]:FireServer()
            end
        end
    end)
end

-- ============================================
-- LOOP UTAMA
-- ============================================
task.spawn(function()
    while task.wait(0.3) do
        if _G.autoUnlockArena then autoUnlockArena() end
        if _G.autoTpBestArena then autoTpBestArena() end
        if _G.autoClick then autoClick() end
        if _G.petSpeed then petSpeedHack() end
        if _G.autoHatchEgg then autoHatch() end
        if _G.autoConsumablePotion then autoConsumablePotion() end
        if _G.autoConsumableEvent then autoConsumableEvent() end
        if _G.autoRedeemReward then autoRedeemReward() end
        if _G.autoEquipBest then autoEquipBest() end
    end
end)

-- ============================================
-- UI TABS
-- ============================================
local FarmTab = Window:AddTab("Auto Farm", "pickaxe")
local HatchTab = Window:AddTab("Auto Hatch", "egg")
local ConsumTab = Window:AddTab("Consumable", "flask-conical")
local MiscTab = Window:AddTab("Misc", "settings")

-- ============================================
-- TAB AUTO FARM
-- ============================================
local ArenaSection = FarmTab:AddSection("Arena")

ArenaSection:AddToggle("AutoUnlockArena", {
    Text = "Auto Unlock Arena",
    Default = false,
    Callback = function(v) _G.autoUnlockArena = v end
})

ArenaSection:AddToggle("AutoTpBestArena", {
    Text = "Auto TP Best Arena",
    Default = false,
    Callback = function(v) _G.autoTpBestArena = v end
})

local FarmSection = FarmTab:AddSection("Farming")

FarmSection:AddToggle("AutoClick", {
    Text = "Auto Click (Include Auto Collect)",
    Default = false,
    Callback = function(v) _G.autoClick = v end
})

FarmSection:AddToggle("PetSpeed", {
    Text = "Pet Speed",
    Default = false,
    Callback = function(v) _G.petSpeed = v end
})

FarmSection:AddSlider("PetSpeedValue", {
    Text = "Pet Speed Value",
    Min = 1,
    Max = 50,
    Default = 2,
    Increment = 1,
    Callback = function(v) _G.petSpeedValue = v end
})

-- ============================================
-- TAB AUTO HATCH
-- ============================================
local EggSection = HatchTab:AddSection("Egg Settings")

EggSection:AddDropdown("SelectedEgg", {
    Text = "Select Egg",
    Values = {"Auto", "Basic", "Common", "Rare", "Epic", "Legendary", "Mythical"},
    Default = "Auto",
    Callback = function(v) _G.selectedEgg = v end
})

EggSection:AddToggle("AutoHatchEgg", {
    Text = "Auto Detect & Buy Nearest Egg",
    Default = false,
    Callback = function(v) _G.autoHatchEgg = v end
})

-- ============================================
-- TAB CONSUMABLE
-- ============================================
local ConsumSection = ConsumTab:AddSection("Consumable")

ConsumSection:AddToggle("AutoConsumablePotion", {
    Text = "Auto Consumable Potion",
    Default = false,
    Callback = function(v) _G.autoConsumablePotion = v end
})

ConsumSection:AddToggle("AutoConsumableEvent", {
    Text = "Auto Consumable Event",
    Default = false,
    Callback = function(v) _G.autoConsumableEvent = v end
})

ConsumSection:AddToggle("AutoRedeemReward", {
    Text = "Auto Redeem Reward",
    Default = false,
    Callback = function(v) _G.autoRedeemReward = v end
})

-- ============================================
-- TAB MISC
-- ============================================
local MiscSection = MiscTab:AddSection("Pet")

MiscSection:AddToggle("AutoEquipBest", {
    Text = "Auto Equip Best",
    Default = false,
    Callback = function(v) _G.autoEquipBest = v end
})

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

-- ============================================
-- NOTIF
-- ============================================
pcall(function()
    Velvet:Notify({
        Title = "PS99 Hub Loaded",
        Content = "Remake V3 siap!",
        Duration = 5,
    })
end)

print("PS99 Hub Remake V3 Loaded!")
