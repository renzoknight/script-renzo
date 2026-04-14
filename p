-- [[ GURITA HUB V1 - TRUE TOP & AUTO SAVE ONLY ]] --

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CG = game:GetService("CoreGui")

-- 1. SISTEM AUTO SAVE (TANPA TOMBOL MANUAL)
local filename = "GURITA_CONFIG_NEW.json"
_G.GH_Settings = {
    ESP_Player_GH = false,
    Xray_GH = false,
    AutoCollect_GH = false,
    ESP_Egg_GH = false
}

local function AutoSave()
    pcall(function()
        if writefile then
            writefile(filename, HttpService:JSONEncode(_G.GH_Settings))
        end
    end)
end

-- Load Otomatis saat Start
pcall(function()
    if isfile and isfile(filename) then
        local data = HttpService:JSONDecode(readfile(filename))
        for k, v in pairs(data) do _G.GH_Settings[k] = v end
    end
end)

-- 2. X-RAY FIX (MODIFIER ONLY - ANTI BUG VISUAL)
local function UpdateXray()
    task.spawn(function()
        for i, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
                local n = v.Name:lower()
                if n:find("wall") or n:find("pillar") or n:find("roof") or n:find("floor") then
                    v.LocalTransparencyModifier = _G.GH_Settings.Xray_GH and 0.6 or 0
                end
            end
            if i % 500 == 0 then task.wait() end 
        end
    end)
end

-- 3. UI - POSISI PALING ATAS (TITIK 0)
if CG:FindFirstChild("GuritaHub_V1") then CG.GuritaHub_V1:Destroy() end

local SG = Instance.new("ScreenGui", CG); SG.Name = "GuritaHub_V1"

local GHTxtBtn = Instance.new("TextButton", SG)
GHTxtBtn.Size = UDim2.new(0, 200, 0, 30)
GHTxtBtn.Position = UDim2.new(0.5, -100, 0, 0) -- POSISI 0 (MENTOK ATAS)
GHTxtBtn.BackgroundTransparency = 1; GHTxtBtn.Text = "GURITA HUB V1"; GHTxtBtn.Font = Enum.Font.GothamBold; GHTxtBtn.TextSize = 20; GHTxtBtn.TextStrokeTransparency = 0.5

local Colors = {Color3.fromRGB(0, 170, 255), Color3.fromRGB(255, 120, 0), Color3.fromRGB(255, 255, 0)}
task.spawn(function()
    local i = 1
    while true do
        TweenService:Create(GHTxtBtn, TweenInfo.new(1), {TextColor3 = Colors[i]}):Play()
        task.wait(1.2); i = i % #Colors + 1
    end
end)

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 400, 0, 280); Main.Position = UDim2.new(0.5, -200, 0.5, -140); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Main.Visible = false
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(0, 150, 255); MainStroke.Thickness = 2
Instance.new("UICorner", Main)

local CloseBtn = Instance.new("TextButton", Main)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -35, 0, 5); CloseBtn.Text = "X"; CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50); Instance.new("UICorner", CloseBtn)
CloseBtn.MouseButton1Click:Connect(function() Main.Visible = false end)
GHTxtBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 100, 1, -20); Sidebar.Position = UDim2.new(0, 10, 0, 10); Sidebar.BackgroundTransparency = 1
local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -130, 1, -40); Pages.Position = UDim2.new(0, 120, 0, 10); Pages.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Pages); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    return p
end

local PageM = CreatePage("M"); local PageE = CreatePage("E")
PageM.Visible = true

local function CreateSideBtn(txt, page)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(1, 0, 0, 35); b.BackgroundColor3 = Color3.fromRGB(30, 30, 45); b.Text = txt; b.TextColor3 = Color3.new(1, 1, 1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _, v in pairs(Pages:GetChildren()) do if v:IsA("ScrollingFrame") then v.Visible = false end end; page.Visible = true end)
end
CreateSideBtn("EVENT", PageM); CreateSideBtn("ESP", PageE)

local function CreateToggle(parent, txt, var, callback)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(0.95, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    local function UpdateBtn()
        local status = _G.GH_Settings[var]
        b.Text = txt..(status and ": ON" or ": OFF")
        b.TextColor3 = status and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    end
    UpdateBtn()
    b.MouseButton1Click:Connect(function() 
        _G.GH_Settings[var] = not _G.GH_Settings[var]
        UpdateBtn()
        AutoSave() -- OTOMATIS SAVE
        callback() 
    end)
    Instance.new("UICorner", b)
end

-- [[ EXECUTION ]] --
CreateToggle(PageM, "Auto Collect", "AutoCollect_GH", function() end)
CreateToggle(PageM, "ESP Egg", "ESP_Egg_GH", function() end)
CreateToggle(PageE, "ESP Player", "ESP_Player_GH", function() end)
CreateToggle(PageE, "X-Ray", "Xray_GH", UpdateXray)

-- Aktifkan Settingan Terakhir
if _G.GH_Settings.Xray_GH then UpdateXray() end
