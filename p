-- [[ GURITA HUB V1 - TOP RIGHT POSITION & FULL FEATURES ]] --

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local CG = game:GetService("CoreGui")

-- 1. SISTEM AUTO SAVE (OTOMATIS)
local filename = "GURITA_HUB_CONFIG.json"
_G.GH_Settings = {
    ESP_Player_GH = false,
    Xray_GH = false,
    AutoCollect_GH = false,
    ESP_Egg_GH = false
}

local function AutoSave()
    pcall(function()
        if writefile then writefile(filename, HttpService:JSONEncode(_G.GH_Settings)) end
    end)
end

pcall(function()
    if isfile and isfile(filename) then
        local data = HttpService:JSONDecode(readfile(filename))
        for k, v in pairs(data) do _G.GH_Settings[k] = v end
    end
end)

-- 2. FITUR AUTO COLLECT & EGG ESP
task.spawn(function()
    while true do
        if _G.GH_Settings.AutoCollect_GH then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("TouchTransmitter") and (v.Parent.Name:lower():find("coin") or v.Parent.Name:lower():find("koin")) then
                        firetouchinterest(lp.Character.HumanoidRootPart, v.Parent, 0)
                        firetouchinterest(lp.Character.HumanoidRootPart, v.Parent, 1)
                    end
                end
            end)
        end
        if _G.GH_Settings.ESP_Egg_GH then
            pcall(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and v.Name:lower():find("egg") and not v:FindFirstChild("EggTag") then
                        local bg = Instance.new("BillboardGui", v)
                        bg.Name = "EggTag"; bg.AlwaysOnTop = true; bg.Size = UDim2.new(0, 80, 0, 20); bg.ExtentsOffset = Vector3.new(0, 2, 0)
                        local lbl = Instance.new("TextLabel", bg)
                        lbl.Size = UDim2.new(1, 0, 1, 0); lbl.Text = "🥚 EGG"; lbl.TextColor3 = Color3.new(1, 1, 0); lbl.BackgroundTransparency = 1; lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
                    end
                end
            end)
        end
        task.wait(0.5)
    end
end)

-- 3. UI - POSISI POJOK KANAN ATAS (BIAR GAK TABRAK DELTA)
if CG:FindFirstChild("GuritaHub_V1") then CG.GuritaHub_V1:Destroy() end
local SG = Instance.new("ScreenGui", CG); SG.Name = "GuritaHub_V1"

local GHTxtBtn = Instance.new("TextButton", SG)
GHTxtBtn.Size = UDim2.new(0, 150, 0, 30)
GHTxtBtn.Position = UDim2.new(1, -160, 0, 0) -- MENAMPEL DI POJOK KANAN PALING ATAS
GHTxtBtn.BackgroundTransparency = 1; GHTxtBtn.Text = "GURITA HUB V1"; GHTxtBtn.Font = Enum.Font.GothamBold; GHTxtBtn.TextSize = 18; GHTxtBtn.TextColor3 = Color3.new(1, 1, 1); GHTxtBtn.TextStrokeTransparency = 0.5

-- Animasi Warna Pelangi
task.spawn(function()
    local colors = {Color3.new(1, 0, 0), Color3.new(0, 1, 0), Color3.new(0, 0.6, 1)}
    local i = 1
    while true do
        TweenService:Create(GHTxtBtn, TweenInfo.new(1.2), {TextColor3 = colors[i]}):Play()
        task.wait(1.5); i = i % #colors + 1
    end
end)

local Main = Instance.new("Frame", SG)
Main.Size = UDim2.new(0, 380, 0, 250); Main.Position = UDim2.new(0.5, -190, 0.5, -125); Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Main.Visible = false; Instance.new("UICorner", Main)
GHTxtBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

-- Sidebar & Pages
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 90, 1, -20); Sidebar.Position = UDim2.new(0, 10, 0, 10); Sidebar.BackgroundTransparency = 1
local Pages = Instance.new("Frame", Main)
Pages.Size = UDim2.new(1, -120, 1, -40); Pages.Position = UDim2.new(0, 110, 0, 10); Pages.BackgroundTransparency = 1
Instance.new("UIListLayout", Sidebar).Padding = UDim.new(0, 5)

local function CreatePage(name)
    local p = Instance.new("ScrollingFrame", Pages); p.Name = name; p.Size = UDim2.new(1, 0, 1, 0); p.BackgroundTransparency = 1; p.Visible = false; p.ScrollBarThickness = 0
    Instance.new("UIListLayout", p).Padding = UDim.new(0, 8)
    return p
end

local P1 = CreatePage("Event"); local P2 = CreatePage("Visual")
P1.Visible = true

local function CreateToggle(parent, txt, var, callback)
    local b = Instance.new("TextButton", parent); b.Size = UDim2.new(0.95, 0, 0, 40); b.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    local function Upd()
        b.Text = txt..(_G.GH_Settings[var] and ": ON" or ": OFF")
        b.TextColor3 = _G.GH_Settings[var] and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    end
    Upd()
    b.MouseButton1Click:Connect(function() 
        _G.GH_Settings[var] = not _G.GH_Settings[var]; Upd(); AutoSave(); callback() 
    end)
    Instance.new("UICorner", b)
end

-- ISI MENU
CreateToggle(P1, "Auto Collect", "AutoCollect_GH", function() end)
CreateToggle(P1, "ESP Egg Hunt", "ESP_Egg_GH", function() end)
CreateToggle(P2, "X-Ray Vision", "Xray_GH", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and (v.Name:lower():find("wall") or v.Name:lower():find("floor")) then
            v.LocalTransparencyModifier = _G.GH_Settings.Xray_GH and 0.6 or 0
        end
    end
end)

local function Side(t, p)
    local b = Instance.new("TextButton", Sidebar); b.Size = UDim2.new(1, 0, 0, 35); b.Text = t; b.BackgroundColor3 = Color3.fromRGB(30,30,45); b.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", b)
    b.MouseButton1Click:Connect(function() for _, v in pairs(Pages:GetChildren()) do v.Visible = false end; p.Visible = true end)
end
Side("EVENT", P1); Side("VISUAL", P2)
