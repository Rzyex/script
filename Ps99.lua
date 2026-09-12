
local Velvet = loadstring(game:HttpGet("https://raw.githubusercontent.com/DexCodeSX/Velvet/main/Library.lua"))()

local Window = Velvet:CreateWindow({
    Title = "Test",
    SubTitle = "Minimal",
    ToggleKey = Enum.KeyCode.RightShift,
})

local Tab = Window:AddTab("Main", "home")
local Section = Tab:AddSection("Test")

Section:AddButton({
    Text = "Klik Aku",
    Callback = function()
        print("Tombol diklik!")
    end
})

print("TEST MINIMAL LOADED")
