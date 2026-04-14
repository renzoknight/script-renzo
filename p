-- [[ GURITA HUB V1 - CARPET SPEED MENU ONLY ]] --

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local CG = game:GetService("CoreGui")

-- Variabel Awal
_G.CarpetSpeedValue = 5 -- Default kecepatan awal

-- 1. UI SETUP (Mini Menu)
local SG = Instance.new("ScreenGui", CG); SG.Name = "CarpetSpeedMenu"

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 200, 0, 150)
Main.Position = UDim2.new(0.5, -100, 0.4, -75) -- Letak di tengah agak atas
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BorderSizePixel = 0
Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(255, 120, 0); MainStroke.Thickness = 2

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "CARPET SETTING"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.BackgroundTransparency = 1

-- 2. DISPLAY ANGKA KECEPATAN
local SpeedShow = Instance.new("TextLabel", Main)
SpeedShow.Size = UDim2.new(1, 0, 0, 40)
SpeedShow.Position = UDim2.new(0, 0, 0, 35)
SpeedShow.Text = tostring(_G.CarpetSpeedValue)
SpeedShow.TextColor3 = Color3.fromRGB(0, 255, 150)
SpeedShow.Font = Enum.Font.GothamBold
SpeedShow.TextSize = 25
SpeedShow.BackgroundTransparency = 1

-- 3. TOMBOL TAMBAH (+)
local AddBtn = Instance.new("TextButton", Main)
AddBtn.Size = UDim2.new(0, 40, 0, 40)
AddBtn.Position = UDim2.new(0.7, 0, 0.6, 0)
AddBtn.Text = "+"
AddBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
AddBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", AddBtn)

-- 4. TOMBOL KURANG (-)
local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 40, 0, 40)
MinBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", MinBtn)

-- Logika Tombol
AddBtn.MouseButton1Click:Connect(function()
    _G.CarpetSpeedValue = _G.CarpetSpeedValue + 1
    SpeedShow.Text = tostring(_G.CarpetSpeedValue)
end)

MinBtn.MouseButton1Click:Connect(function()
    if _G.CarpetSpeedValue > 1 then
        _G.CarpetSpeedValue = _G.CarpetSpeedValue - 1
        SpeedShow.Text = tostring(_G.CarpetSpeedValue)
    end
end)

-- 5. CARPET LOGIC (ANTI LAG)
task.spawn(function()
    while true do
        pcall(function()
            if lp.Character then
                for _, v in pairs(lp.Character:GetDescendants()) do
                    if v:IsA("BodyVelocity") or v:IsA("LinearVelocity") then
                        v.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                        -- Gunakan nilai dari menu
                        v.Velocity = v.Velocity.Unit * (16 * _G.CarpetSpeedValue) 
                    end
                end
            end
        end)
        task.wait(0.5) -- Jeda biar enteng
    end
end)

print("Menu Carpet Speed Berhasil Dimuat, Bang!")
