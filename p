-- [[ RENZO GURITA - XRAY GURITA V5.1 AUTO-LOAD ]] --

local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- 1. FUNGSI VISUAL (FLAT COLOR & XRAY OTOMATIS)
local function ApplyVisual(v)
    pcall(function()
        if v:IsA("BasePart") or v:IsA("MeshPart") then
            -- JANGAN sentuh karakter player agar tidak abu-abu
            if v:IsDescendantOf(lp.Character) or v.Parent:FindFirstChild("Humanoid") then 
                return 
            end

            local name = v.Name:lower()

            -- FLAT COLOR LOGIC
            v.Material = Enum.Material.Plastic
            if v:IsA("MeshPart") then v.TextureID = "" end -- Hapus tekstur biar enteng
            v.CastShadow = false

            -- XRAY LOGIC (Tembok & Bangunan)
            local isBuilding = name:find("wall") or name:find("base") or name:find("dinding") or name:find("roof") or name:find("door")
            
            if isBuilding then
                v.Transparency = 0.5
                v.Color = Color3.fromRGB(180, 180, 180) -- Abu-abu solid
            else
                -- LANTAI & BASE (Visual Hijau Neon seperti di foto)
                if name:find("floor") or name:find("lantai") or name:find("ground") then
                    v.Color = Color3.fromRGB(0, 255, 120)
                    v.Transparency = 0
                end
            end

            -- PEMBERSIH (Hapus Rumput/Daun agar pandangan luas)
            if name:find("grass") or name:find("leaf") or name:find("tree") then
                v.Transparency = 1
                v.CanCollide = true
            end
        end
    end)
end

-- 2. TRACER BIRU (LANGSUNG ON)
local function AddTracer(plr)
    local Line = Drawing.new("Line")
    Line.Visible = true
    Line.Color = Color3.fromRGB(0, 160, 255)
    Line.Thickness = 1.5
    
    local function UpdateTracer()
        local c = RunService.RenderStepped:Connect(function()
            if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                local root = plr.Character.HumanoidRootPart
                local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    Line.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                    Line.To = Vector2.new(pos.X, pos.Y)
                    Line.Visible = true
                else Line.Visible = false end
            else Line.Visible = false end
        end)
        plr.CharacterRemoving:Connect(function() c:Disconnect() Line.Visible = false end)
    end
    task.spawn(UpdateTracer)
end

-- 3. EKSEKUSI SEMUA FUNGSI (AUTO)
for _, v in pairs(workspace:GetDescendants()) do
    ApplyVisual(v)
end

workspace.DescendantAdded:Connect(function(v)
    task.wait()
    ApplyVisual(v)
end)

for _, p in pairs(Players:GetPlayers()) do
    if p ~= lp then AddTracer(p) end
end
Players.PlayerAdded:Connect(AddTracer)

-- NOTIFIKASI LOADED
print("Gurita V5.1: Visual Auto-Applied!")
