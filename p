-- [[ GURITA HUB V1 - CARPET SPEED MENU V2 ]] --

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local CG = game:GetService("CoreGui")

-- Hapus UI lama kalau ada biar gak tumpuk
if CG:FindFirstChild("CarpetSpeedFix") then
    CG.CarpetSpeedFix:Destroy()
end

-- Variabel Global
_G.CarpetSpeedValue = 5

-- 1. UI SETUP (Dibuat lebih besar & mencolok)
local SG = Instance.new("ScreenGui", CG); SG.Name = "CarpetSpeedFix"

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 250, 0, 180)
Main.Position = UDim2.new(0.5, -125, 0.5, -90) -- PAS DI TENGAH LAYAR
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true -- Bisa Abang geser kalau ganggu
Instance.new("UICorner", Main)

local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(255, 120, 0); MainStroke.Thickness = 3

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = "CARPET SPEED SETTING"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.BackgroundTransparency = 1

-- 2. DISPLAY ANGKA
local SpeedShow = Instance.new("TextLabel", Main)
SpeedShow.Size = UDim2.new(1, 0, 0, 50)
SpeedShow.Position = UDim2.new(0, 0, 0, 40)
SpeedShow.Text = "SPEED: " .. tostring(_G.CarpetSpeedValue)
SpeedShow.TextColor3 = Color3.fromRGB(0, 255, 150)
SpeedShow.Font = Enum.Font.GothamBold
SpeedShow.TextSize = 30
SpeedShow.BackgroundTransparency = 1

-- 3. TOMBOL TAMBAH (+)
local AddBtn = Instance.new("TextButton", Main)
AddBtn.Size = UDim2.new(0, 60, 0, 50)
AddBtn.Position = UDim2.new(0.65, 0, 0.6, 0)
AddBtn.Text = "+"
AddBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
AddBtn.TextColor3 = Color3.new(1, 1, 1)
AddBtn.Font = Enum.Font.GothamBold
AddBtn.TextSize = 30
Instance.new("UICorner", AddBtn)

-- 4. TOMBOL KURANG (-)
local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 60, 0, 50)
MinBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
MinBtn.Text = "-"
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 30
Instance.new("UICorner", MinBtn)

-- Logika Tombol
AddBtn.MouseButton1Click:Connect(function()
    _G.CarpetSpeedValue = _G.CarpetSpeedValue + 1
    SpeedShow.Text = "SPEED: " .. tostring(_G.CarpetSpeedValue)
end)

MinBtn.MouseButton1Click:Connect(function()
    if _G.CarpetSpeedValue > 1 then
        _G.CarpetSpeedValue = _G.CarpetSpeedValue - 1
        SpeedShow.Text = "SPEED: " .. tostring(_G.CarpetSpeedValue)
    end
end)

-- 5. LOGIKA TERBANG (ANTI LAG)
task.spawn(function()
    while true do
        pcall(function()
            if lp.Character then
                for _, v in pairs(lp.Character:GetDescendants()) do
                    if v:IsA("BodyVelocity") or v:IsA("LinearVelocity") then
                        v.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                        v.Velocity = v.Velocity.Unit * (16 * _G.CarpetSpeedValue) 
                    end
                end
            end
        end)
        task.wait(0.3) -- Respon lebih cepat tapi gak bikin lag
    end
end)

print("Menu Carpet Speed Muncul di Tengah Layar, Bang!")
