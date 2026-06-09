-- [[ HUYDEPZAIHUB SCRIPT - ULTRA METHOD EDITION (NO NOTIFICATION) ]] --

_G.FastAttack = true

if _G.FastAttack then
    local _ENV = (getgenv or getrenv or getfenv)()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer

    if not LocalPlayer then return end

    local Enemies = workspace:WaitForChild("Enemies")
    local Characters = workspace:WaitForChild("Characters")
    local NetModule = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net"))

    local FastAttack = { Distance = 100 }
    
    -- Hàm quét mảng siêu tốc không lặp sâu
    local function GetNearestTargets()
        local targets = {}
        local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not myRoot then return targets end

        for _, folder in ipairs({Enemies, Characters}) do
            for _, char in ipairs(folder:GetChildren()) do
                if char ~= LocalPlayer.Character then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local hum = char:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        if (hrp.Position - myRoot.Position).Magnitude <= FastAttack.Distance then
                            table.insert(targets, {char, hrp})
                        end
                    end
                end
            end
        end
        return targets
    end

    -- Vòng lặp cưỡng bức gói tin - Chạy song song đa luồng (Thread Spammer)
    for i = 1, 5 do 
        task.spawn(function()
            while true do
                local char = LocalPlayer.Character
                local tool = char and char:FindFirstChildOfClass("Tool")
                
                if tool and (tool:GetAttribute("WeaponType") == "Melee" or tool:GetAttribute("WeaponType") == "Sword") then
                    local list = GetNearestTargets()
                    if #list > 0 then
                        pcall(function()
                            NetModule["RE/RegisterAttack"]:FireServer(0)
                            local primaryHead = list[1][1]:FindFirstChild("Head")
                            if primaryHead then
                                NetModule["RE/RegisterHit"]:FireServer(primaryHead, list, {}, tostring(LocalPlayer.UserId):sub(2, 4) .. tostring(coroutine.running()):sub(11, 15))
                            end
                        end)
                    end
                end
                task.wait() 
            end
        end)
    end
end

-- Cơ chế quét mã hóa liên lạc của tệp gốc
local remote, idremote
for _, v in next, ({game.ReplicatedStorage.Util, game.ReplicatedStorage.Common, game.ReplicatedStorage.Remotes, game.ReplicatedStorage.Assets, game.ReplicatedStorage.FX}) do
    for _, n in next, v:GetChildren() do
        if n:IsA("RemoteEvent") and n:GetAttribute("Id") then
            remote, idremote = n, n:GetAttribute("Id")
        end
    end
    v.ChildAdded:Connect(function(n)
        if n:IsA("RemoteEvent") and n:GetAttribute("Id") then
            remote, idremote = n, n:GetAttribute("Id")
        end
    end)
end

-- Gửi kèm gói mã hóa theo nhịp RenderStepped
game:GetService("RunService").RenderStepped:Connect(function()
    local char = game.Players.LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local tool = char and char:FindFirstChildOfClass("Tool")
    
    if root and tool and (tool:GetAttribute("WeaponType") == "Melee" or tool:GetAttribute("WeaponType") == "Sword") then
        local parts = {}
        for _, x in ipairs({workspace.Enemies, workspace.Characters}) do
            for _, v in ipairs(x:GetChildren()) do
                local hrp = v:FindFirstChild("HumanoidRootPart")
                local hum = v:FindFirstChild("Humanoid")
                if v ~= char and hrp and hum and hum.Health > 0 and (hrp.Position - root.Position).Magnitude <= 75 then
                    for _, _v in ipairs(v:GetChildren()) do
                        if _v:IsA("BasePart") then
                            parts[#parts + 1] = {v, _v}
                        end
                    end
                end
            end
        end
        
        if #parts > 0 and remote and idremote then
            pcall(function()
                local head = parts[1][1]:FindFirstChild("Head")
                if head then
                    cloneref(remote):FireServer(string.gsub("RE/RegisterHit", ".", function(c)
                        return string.char(bit32.bxor(string.byte(c), math.floor(workspace:GetServerTimeNow() / 10 % 10) + 1))
                    end), bit32.bxor(idremote + 909090, require(game.ReplicatedStorage.Modules.Net).seed:InvokeServer() * 2), head, parts)
                end
            end)
        end
    end
end)

-- Hệ thống Hitbox Tàng Hình Siêu Tốc
game:GetService("RunService").RenderStepped:Connect(function()
    -- Xử lý nhanh cho Quái (Enemies)
    for _, enemy in ipairs(workspace.Enemies:GetChildren()) do
        pcall(function()
            local hrp = enemy:FindFirstChild("HumanoidRootPart")
            if hrp and enemy.Humanoid.Health > 0 then
                hrp.Size = Vector3.new(50, 50, 50)
                hrp.Transparency = 1 
                hrp.CanCollide = false
            end
        end)
    end
    
    -- Xử lý nhanh cho Người chơi (Characters)
    for _, p in ipairs(workspace.Characters:GetChildren()) do
        pcall(function()
            if p.Name ~= game.Players.LocalPlayer.Name then
                local hrp = p:FindFirstChild("HumanoidRootPart")
                if hrp and p.Humanoid.Health > 0 then
                    hrp.Size = Vector3.new(50, 50, 50)
                    hrp.Transparency = 1 
                    hrp.CanCollide = false
                end
            end
        end)
    end
end)
