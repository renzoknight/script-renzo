-- [[ GURITA HUB V1 - FINAL BUG FIX ]] --

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CG = game:GetService("CoreGui")

-- 1. SAVE SYSTEM (Load Otomatis)
local filename = "GURITA_HUB_V1_STABLE.json"
_G.GH_Settings = {
    ESP_Player_GH = false,
    Xray_GH = false,
    AutoCollect_GH = false,
    ESP_Egg_GH = false
}

local function SaveData()
    if writefile then pcall(function() writefile(filename, HttpService:JSONEncode(_G.GH_Settings)) end) end
end

if isfile and isfile(filename) then
    pcall(function() _G.GH_Settings = HttpService:JSONDecode(readfile(filename)) end)
end

-- 2. X-RAY FIX (Tanpa ngerusak tekstur dunia)
local function UpdateXray()
    task.spawn(function()
        for i, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                -- Cek apakah objek adalah bagian dari bangunan (tembok/lantai)
                local n = v.Name:lower()
                if n:find("wall") or n:find("pillar") or n:find("roof") or n:find("glass") then
                    if _G.GH_Settings.Xray_GH then
                        v.LocalTransparencyModifier = 0.6 -- Pakai modifier biar tekstur asli gak hilang
                    else
                        v.LocalTransparencyModifier = 0
                    end
                end
            end
            if i % 500 == 0 then task.wait() end -- Jeda biar gak lag parah
        end
    end)
end

-- 3. ESP PLAYER (BIG TEXT)
local function CreateESP(plr)
    task.spawn(function()
        while plr and plr.Parent do
            if _G.GH_Settings.ESP_Player_GH then
                pcall(function()
                    if plr.Character and plr.Character:FindFirstChild("Head") then
                        local head = plr.Character.Head
                        if not head:FindFirstChild("ESPTag") then
                            local bg = Instance.new("BillboardGui", head)
                            bg.Name = "ESPTag"; bg.AlwaysOnTop = true; bg.Size = UDim2.new(0, 200, 0, 50); bg.ExtentsOffset = Vector3.new(0, 3, 0)
                            local lbl = Instance.new("TextLabel", bg)
                            lbl.Size = UDim2.new(1, 0, 1, 0); lbl.BackgroundTransparency = 1; lbl.TextColor3 = Color3.new(1, 1, 1)
                            lbl.Text = plr.Name; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 18; lbl.TextStrokeTransparency = 0
                        end
                    end
                end)
            else
                if plr.Character and plr.Character:FindFirstChild("Head") and plr.Character.Head:FindFirstChild("ESPTag") then
                    plr.Character.Head.ESPTag:Destroy()
                end
            end
            task.wait(3)
        end
    end)
end

-- 4. UI CONSTRUCTION
local SG = Instance.new("ScreenGui", CG); SG.Name = "GuritaHubV1_Final"

-- POSISI JUDUL PALING ATAS (0.01)
local GHTxtBtn = Instance.new("TextButton", SG)
GHTxtBtn.Size = UDim2.new(0, 180, 0, 35); GHTxtBtn.Position = UDim2.new(0.5, -90, 0.01, 0) 
GHTxtBtn.BackgroundTransparency = 1; GHTxtBtn.Text = "GURITA HUB V1"; GHTxtBtn.Font = Enum.Font.GothamBold; GHTxtBtn.TextSize = 22; GHTxtBtn.TextStrokeTransparency = 0.6

local Colors = {Color3.fromRGB(0, 170, 255), Color3.fromRGB(255, 120, 0), Color3.fromRGB(255, 255, 0), Color3.fromRGB(170, 0, 255)}
task.spawn(function()
    local i = 1
    while true do
        TweenService:Create(GHTxtBtn, TweenInfo.new(1.5), {TextColor3 = Colors[i]}):Play()
        task.wait(1.5); i = i % #Colors + 1
    end
end)

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 420, 0, 300); Main.Position = UDim2.new(0.5, -210, 0.5, -150); Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18); Main.Visible = false
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(0, 150, 255); MainStroke.Thickness = 2
Instance.new("UICorner", Main)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 35, 0, 35); CloseBtn.Position = UDim2.new(0, 5, 0, 5); CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.Text = "X"; CloseBtn.TextColor3 = Color3.new(1, 1, 1); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 16; Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)
GHTxtBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 120, 1, -50); Sidebar.Position = UDim2.new(0, 10, 0, 45); Sidebar.BackgroundTransparency = 1
local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -150, 1, -100); Pages.Position = UDim2.new(0, 140, 0, 45); Pages.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Pages); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 2
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    return p
end

local PagePaska = CreatePage("PASKA"); local PageESP = CreatePage("ESP")
PagePaska.Visible = true

local function CreateSideBtn(txt, page)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(25, 25, 40); b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1); b.Font = Enum.Font.GothamBold; b.TextSize = 10; Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _, v in pairs(Pages:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; page.Visible = true end)
end
CreateSideBtn("PASKA EVENT", PagePaska); CreateSideBtn("ESP", PageESP)

local function CreateToggle(parent, txt, var, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(22, 22, 35)
    local function UpdateBtn()
        local status = _G.GH_Settings[var]; b.Text = txt..(status and ": ON" or ": OFF")
        b.TextColor3 = status and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    end
    UpdateBtn()
    b.MouseButton1Click:Connect(function() 
        _G.GH_Settings[var] = not _G.GH_Settings[var]
        UpdateBtn()
        SaveData()
        callback() 
    end)
    Instance.new("UICorner", b)
end

-- [[ EXECUTION ]] --
CreateToggle(PagePaska, "Auto Collect Koin Paska GH", "AutoCollect_GH", function() end)
CreateToggle(PagePaska, "ESP EGG HUNT GH", "ESP_Egg_GH", function() end)
CreateToggle(PageESP, "ESC Player GH", "ESP_Player_GH", function() 
    for _, p in pairs(Players:GetPlayers()) do if p ~= lp then CreateESP(p) end end 
end)
CreateToggle(PageESP, "X-Rey GH", "Xray_GH", UpdateXray)

-- Auto Run Last Settings
if _G.GH_Settings.ESP_Player_GH then for _, p in pairs(Players:GetPlayers()) do if p ~= lp then CreateESP(p) end end end
if _G.GH_Settings.Xray_GH then UpdateXray() end

Players.PlayerAdded:Connect(CreateESP)
