-- [[ GURITA HUB V1 - CARPET SPEED ONLY TEST ]] --

local Players = game:GetService("Players")
local lp = Players.LocalPlayer

-- SETTING KECEPATAN DI SINI (Ganti angkanya sesuka Abang)
local SpeedValue = 5 -- Semakin besar angkanya, semakin kencang terbangnya

task.spawn(function()
    print("Carpet Speed Script Active!")
    while true do
        pcall(function()
            if lp.Character then
                -- Mencari semua objek penggerak di dalam karakter (biasanya dipakai karpet)
                for _, v in pairs(lp.Character:GetDescendants()) do
                    if v:IsA("BodyVelocity") or v:IsA("LinearVelocity") then
                        -- Memberikan kekuatan maksimal agar tidak berat
                        v.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                        
                        -- Mengalikan kecepatan asli dengan SpeedValue Abang
                        -- 16 adalah kecepatan standar Roblox
                        v.Velocity = v.Velocity.Unit * (16 * SpeedValue) 
                    end
                end
            end
        end)
        task.wait(0.5) -- Jeda biar tetap enteng dan nggak lag
    end
end)
