loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/refs/heads/main/main.lua"))()

local Window = WindUI:CreateWindow({
    Title = "PS99 Hub",
    Icon = "rbxassetid://10723407389",
    Author = "YourName",
    Folder = "PS99Hub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "Dark",
    User = { Enabled = true, Anonymous = true, Callback = function() end }
})

-- VARIABEL
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

-- REMOTE HANDLER
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

-- AUTO COLLECT
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

-- LOOP UTAMA
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

-- MOVEMENT
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

-- ESP
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

-- UI
local MainTab = Window:Tab({ Title = "Main", Icon = "home" })
local PlayerTab = Window:Tab({ Title = "Player", Icon = "user" })
local EspTab = Window:Tab({ Title = "ESP", Icon = "eye" })
local MiscTab = Window:Tab({ Title = "Misc", Icon = "settings" })

MainTab:Section({ Title = "Auto Farm" })
MainTab:Toggle({ Title = "Auto Collect", Default = false, Callback = function(v) _G.autoCollect = v end })
MainTab:Toggle({ Title = "Auto Hatch", Default = false, Callback = function(v) _G.autoHatch = v end })
MainTab:Toggle({ Title = "Auto Sell", Default = false, Callback = function(v) _G.autoSell = v end })
MainTab:Toggle({ Title = "Auto Buy Egg", Default = false, Callback = function(v) _G.autoBuy = v end })
MainTab:Toggle({ Title = "Auto Rebirth", Default = false, Callback = function(v) _G.autoRebirth = v end })
MainTab:Toggle({ Title = "Auto Upgrade", Default = false, Callback = function(v) _G.autoUpgrade = v end })
MainTab:Toggle({ Title = "Auto Rank Up", Default = false, Callback = function(v) _G.autoRankUp = v end })
MainTab:Toggle({ Title = "Auto Claim", Default = false, Callback = function(v) _G.autoClaim = v end })
MainTab:Toggle({ Title = "Auto Delete Pet", Default = false, Callback = function(v) _G.autoDelete = v end })
MainTab:Toggle({ Title = "Auto Equip Best", Default = false, Callback = function(v) _G.autoEquipBest = v end })

PlayerTab:Section({ Title = "Movement" })
PlayerTab:Slider({ Title = "WalkSpeed", Default = 16, Min = 1, Max = 200, Callback = function(v) _G.walkSpeed = v end })
PlayerTab:Slider({ Title = "JumpPower", Default = 50, Min = 1, Max = 500, Callback = function(v) _G.jumpPower = v end })
PlayerTab:Toggle({ Title = "Fly", Default = false, Callback = function(v) _G.fly = v end })
PlayerTab:Toggle({ Title = "Noclip", Default = false, Callback = function(v) _G.noclip = v end })
PlayerTab:Toggle({ Title = "Infinite Jump", Default = false, Callback = function(v) _G.infiniteJump = v end })
PlayerTab:Toggle({ Title = "Anti AFK", Default = true, Callback = function(v) _G.antiAfk = v end })

EspTab:Section({ Title = "ESP Settings" })
EspTab:Toggle({ Title = "ESP Coins", Default = false, Callback = function(v) _G.espCoins = v end })
EspTab:Toggle({ Title = "ESP Breakables", Default = false, Callback = function(v) _G.espBreakables = v end })

MiscTab:Section({ Title = "Server" })
MiscTab:Button({ Title = "Rejoin Server", Callback = function() game:GetService("TeleportService"):Teleport(game.PlaceId) end })
MiscTab:Button({ Title = "Server Hop", Callback = function()
    local TS = game:GetService("TeleportService")
    local Http = game:GetService("HttpService")
    local servers = Http:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
    for _, v in pairs(servers.data) do
        if v.playing < v.maxPlayers and v.id ~= game.JobId then
            TS:TeleportToPlaceInstance(game.PlaceId, v.id)
            break
        end
    end
end })
MiscTab:Button({ Title = "Destroy UI", Callback = function() Window:Destroy() end })

print("PS99 Hub Loaded!")
