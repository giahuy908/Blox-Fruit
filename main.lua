----------------------------------------------------------------------------------------------------------------------------------------------
-- KHỞI TẠO THƯ VIỆN FLUENT LIBRARY & CONFIG
----------------------------------------------------------------------------------------------------------------------------------------------
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "huy Hub",
    SubTitle = "Blox Fruits Auto Farm Sea 1",
    TabWidth = 160,
    Size = UDim2.fromOffset(530, 350),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.End
})

local Tabs = {
    Main = Window:AddTab({ Title = "Chính", Icon = "home" }),
    Setting = Window:AddTab({ Title = "Cài Đặt", Icon = "settings" })
}

_G.AutoLevel = false
_G.Fast_Delay = 0.05 -- Tốc độ đánh tối ưu chống mất sát thương
SelectWeapon = "Melee" -- Mặc định: Melee, Sword, Blox Fruit

-- Cấu hình Auto Stats
_G.AutoStats = false
_G.StatsToUpgrade = {
    ["Melee"] = false,
    ["Defense"] = false,
    ["Demon Fruit"] = false
}

-- Danh sách Code bạn cung cấp
local CodeList = {
    "SUB2GAMERROBOT_EXP1",
    "SUB2GAMERROBOT_RESET1",
    "KITT_RESET",
    "ADMINFIGHT",
    "AXIORE",
    "BIGNEWS",
    "BLUXXY",
    "ENYU_IS_PRO",
    "FUDD10",
    "FUDD10_V2",
    "JCWK",
    "KITTGAMING",
    "MAGICBUS",
    "STARCODEHEO",
    "STRAWHATMAINE",
    "SUB2CAPTAINMAUI",
    "SUB2DAIGROCK",
    "SUB2FER999",
    "SUB2NOOBMASTER123",
    "TANTAIGAMING",
    "THEGREATACE"
}

----------------------------------------------------------------------------------------------------------------------------------------------
-- NÚT BẬT TẮT MENU (TOGGLE BUTTON) DÀNH CHO MOBILE
----------------------------------------------------------------------------------------------------------------------------------------------
local MobileButton = Instance.new("ScreenGui")
local ToggleBtn = Instance.new("TextButton")

MobileButton.Name = "MobileButtonGui"
MobileButton.Parent = game:GetService("CoreGui")
MobileButton.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Parent = MobileButton
ToggleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
ToggleBtn.BorderSizePixel = 2
ToggleBtn.BorderColor3 = Color3.fromRGB(0, 255, 150)
ToggleBtn.Position = UDim2.new(0, 15, 0, 15)
ToggleBtn.Size = UDim2.new(0, 70, 0, 35)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "huy Hub"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 14.000

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = ToggleBtn

ToggleBtn.MouseButton1Click:Connect(function()
    Window:Minimize()
end)

----------------------------------------------------------------------------------------------------------------------------------------------
-- CHỐNG TREO MÁY (ANTI-AFK) & NOCLIP CHI TIẾT
----------------------------------------------------------------------------------------------------------------------------------------------
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Vòng lặp Noclip và vô hiệu hóa vận tốc rơi tự do
spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if _G.AutoLevel and game.Players.LocalPlayer.Character then
            local char = game.Players.LocalPlayer.Character
            -- Noclip xuyên tường
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            -- Khóa cứng vận tốc rơi tự do khi đang auto farm (FIX RƠI / GIẬT)
            if char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end)

----------------------------------------------------------------------------------------------------------------------------------------------
-- HÀM FIX LỖI: TWEEN MƯỢT MÀ & CỐ ĐỊNH VỊ TRÍ
----------------------------------------------------------------------------------------------------------------------------------------------
local currentTween = nil
local function Tween(CFgo)
    local playerChar = game.Players.LocalPlayer.Character
    if not playerChar or not playerChar:FindFirstChild("HumanoidRootPart") then return end
    
    local currentPos = playerChar.HumanoidRootPart.Position
    local distance = (currentPos - CFgo.Position).Magnitude
    
    -- Tốc độ di chuyển mượt mà ổn định
    local speed = 325 
    local duration = distance / speed
    
    -- Nếu khoảng cách quá gần, dịch chuyển thẳng để chống giật nhấp nháy
    if distance < 3 then
        playerChar.HumanoidRootPart.CFrame = CFgo
        return
    end

    local tween_s = game:GetService("TweenService")
    local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    
    if currentTween then currentTween:Cancel() end -- Hủy Tween cũ để tránh xung đột vị trí
    
    currentTween = tween_s:Create(playerChar.HumanoidRootPart, info, {CFrame = CFgo})
    currentTween:Play()
    return currentTween
end

local function EquipTool(ToolType)
    local bp = game.Players.LocalPlayer.Backpack
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    
    for _, v in pairs(bp:GetChildren()) do
        if v:IsA("Tool") and (v.ToolTip == ToolType or v.Name == ToolType) then
            char.Humanoid:EquipTool(v)
        end
    end
end

local function AutoHaki()
    if not game.Players.LocalPlayer.Character:FindFirstChild("HasBuso") then
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
    end
end

local function AttackNoCD()
    local vu = game:GetService("VirtualUser")
    vu:CaptureController()
    vu:Button1Down(Vector2.new(1280, 672))
end

----------------------------------------------------------------------------------------------------------------------------------------------
-- DATABASE PHÂN TÍCH NHIỆM VỤ FULL SEA 1 (LEVEL 1 - 700)
----------------------------------------------------------------------------------------------------------------------------------------------
function CheckLevel()
    local Lv = game:GetService("Players").LocalPlayer.Data.Level.Value
    
    Ms = "Bandit" NameQuest = "BanditQuest1" QuestLv = 1 NameMon = "Bandit"
    CFrameQ = CFrame.new(1060.938, 16.455, 1547.784) CFrameMon = CFrame.new(1038.553, 41.296, 1576.510)

    if Lv >= 10 and Lv <= 14 then
        Ms = "Monkey" NameQuest = "JungleQuest" QuestLv = 1 NameMon = "Monkey"
        CFrameQ = CFrame.new(-1601.655, 36.852, 153.388) CFrameMon = CFrame.new(-1448.144, 50.852, 63.607)
    elseif Lv >= 15 and Lv <= 29 then
        Ms = "Gorilla" NameQuest = "JungleQuest" QuestLv = 2 NameMon = "Gorilla"
        CFrameQ = CFrame.new(-1601.655, 36.852, 153.388) CFrameMon = CFrame.new(-1142.648, 40.462, -515.392)
    elseif Lv >= 30 and Lv <= 39 then
        Ms = "Pirate" NameQuest = "BuggyQuest1" QuestLv = 1 NameMon = "Pirate"
        CFrameQ = CFrame.new(-1140.176, 4.752, 3827.405) CFrameMon = CFrame.new(-1201.088, 40.628, 3857.596)
    elseif Lv >= 40 and Lv <= 59 then
        Ms = "Brute" NameQuest = "BuggyQuest1" QuestLv = 2 NameMon = "Brute"
        CFrameQ = CFrame.new(-1140.176, 4.752, 3827.405) CFrameMon = CFrame.new(-1387.532, 24.592, 4100.958)
    elseif Lv >= 60 and Lv <= 74 then
        Ms = "Desert Bandit" NameQuest = "DesertQuest" QuestLv = 1 NameMon = "Desert Bandit"
        CFrameQ = CFrame.new(896.517, 6.438, 4390.149) CFrameMon = CFrame.new(984.999, 16.110, 4417.910)
    elseif Lv >= 75 and Lv <= 89 then
        Ms = "Desert Officer" NameQuest = "DesertQuest" QuestLv = 2 NameMon = "Desert Officer"
        CFrameQ = CFrame.new(896.517, 6.438, 4390.149) CFrameMon = CFrame.new(1547.151, 14.452, 4381.800)
    elseif Lv >= 90 and Lv <= 99 then
        Ms = "Snow Bandit" NameQuest = "SnowQuest" QuestLv = 1 NameMon = "Snow Bandit"
        CFrameQ = CFrame.new(1386.807, 87.273, -1298.358) CFrameMon = CFrame.new(1356.302, 105.769, -1328.242)
    elseif Lv >= 100 and Lv <= 119 then
        Ms = "Snowman" NameQuest = "SnowQuest" QuestLv = 2 NameMon = "Snowman"
        CFrameQ = CFrame.new(1386.807, 87.273, -1298.358) CFrameMon = CFrame.new(1218.796, 138.012, -1488.026)
    elseif Lv >= 120 and Lv <= 149 then
        Ms = "Chief Petty Officer" NameQuest = "MarineQuest2" QuestLv = 1 NameMon = "Chief Petty Officer"
        CFrameQ = CFrame.new(-5035.496, 28.678, 4324.184) CFrameMon = CFrame.new(-4931.155, 65.793, 4121.839)
    elseif Lv >= 150 and Lv <= 174 then
        Ms = "Sky Bandit" NameQuest = "SkyQuest" QuestLv = 1 NameMon = "Sky Bandit"
        CFrameQ = CFrame.new(-4842.137, 717.695, -2623.048) CFrameMon = CFrame.new(-4955.641, 365.464, -2908.187)
    elseif Lv >= 175 and Lv <= 224 then
        Ms = "Dark Master" NameQuest = "SkyQuest" QuestLv = 2 NameMon = "Dark Master"
        CFrameQ = CFrame.new(-4842.137, 717.695, -2623.048) CFrameMon = CFrame.new(-5148.165, 439.046, -2332.961)
    elseif Lv >= 225 and Lv <= 249 then
        Ms = "Toga Warrior" NameQuest = "SkyQuest2" QuestLv = 1 NameMon = "Toga Warrior"
        CFrameQ = CFrame.new(-6244.410, 5581.564, -1324.321) CFrameMon = CFrame.new(-6284.150, 5600.222, -1388.150)
    elseif Lv >= 250 and Lv <= 299 then
        Ms = "Prisoner" NameQuest = "PrisonerQuest" QuestLv = 1 NameMon = "Prisoner"
        CFrameQ = CFrame.new(5306.452, 1.455, 474.321) CFrameMon = CFrame.new(5422.388, 30.122, 510.662)
    elseif Lv >= 300 and Lv <= 349 then
        Ms = "Dangerous Prisoner" NameQuest = "PrisonerQuest" QuestLv = 2 NameMon = "Dangerous Prisoner"
        CFrameQ = CFrame.new(5306.452, 1.455, 474.321) CFrameMon = CFrame.new(5566.250, 31.425, 788.150)
    elseif Lv >= 350 and Lv <= 399 then
        Ms = "Military Soldier" NameQuest = "MagmaQuest" QuestLv = 1 NameMon = "Military Soldier"
        CFrameQ = CFrame.new(-5224.231, 14.521, 8452.421) CFrameMon = CFrame.new(-5411.380, 72.411, 8560.124)
    elseif Lv >= 400 and Lv <= 449 then
        Ms = "Military Spy" NameQuest = "MagmaQuest" QuestLv = 2 NameMon = "Military Spy"
        CFrameQ = CFrame.new(-5224.231, 14.521, 8452.421) CFrameMon = CFrame.new(-5824.120, 80.522, 8824.110)
    elseif Lv >= 450 and Lv <= 474 then
        Ms = "God's Guard" NameQuest = "SkyExp1Quest" QuestLv = 1 NameMon = "God's Guard"
        CFrameQ = CFrame.new(-5705.210, 7122.421, -1721.411) CFrameMon = CFrame.new(-5780.250, 7150.120, -1890.350)
    elseif Lv >= 475 and Lv <= 524 then
        Ms = "Shanda" NameQuest = "SkyExp1Quest" QuestLv = 2 NameMon = "Shanda"
        CFrameQ = CFrame.new(-5705.210, 7122.421, -1721.411) CFrameMon = CFrame.new(-5542.150, 7192.150, -2100.410)
    elseif Lv >= 525 and Lv <= 624 then
        Ms = "Galley Pirate" NameQuest = "FountainQuest" QuestLv = 1 NameMon = "Galley Pirate"
        CFrameQ = CFrame.new(5258.279, 38.527, 4050.045) CFrameMon = CFrame.new(5425.410, 70.410, 4824.150)
    elseif Lv >= 625 and Lv <= 700 then
        Ms = "Galley Captain" NameQuest = "FountainQuest" QuestLv = 2 NameMon = "Galley Captain"
        CFrameQ = CFrame.new(5258.279, 38.527, 4050.045) CFrameMon = CFrame.new(5677.677, 92.786, 4966.632)
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------
-- GIAO DIỆN (UI CONTROLS)
----------------------------------------------------------------------------------------------------------------------------------------------
Tabs.Main:AddToggle("ToggleFarm", {Title = "Tự Động Farm Cấp Độ (Sea 1)", Default = false}):OnChanged(function(Value)
    _G.AutoLevel = Value
end)

Tabs.Setting:AddDropdown("DropdownWeapon", {
    Title = "Chọn Loại Vũ Khí Đang Dùng",
    Values = {"Melee", "Sword", "Blox Fruit"},
    Multi = false,
    Default = "Melee",
}):OnChanged(function(Value)
    SelectWeapon = Value
end)

-- TỰ ĐỘNG NÂNG ĐIỂM (AUTO STATS)
Tabs.Setting:AddSection("--- Tự Động Nâng Điểm (Auto Stats) ---")

Tabs.Setting:AddToggle("ToggleStats", {Title = "Kích Hoạt Auto Stats", Default = false}):OnChanged(function(Value)
    _G.AutoStats = Value
end)

Tabs.Setting:AddToggle("StatMelee", {Title = "Nâng Cận Chiến (Melee)", Default = false}):OnChanged(function(Value)
    _G.StatsToUpgrade["Melee"] = Value
end)

Tabs.Setting:AddToggle("StatDefense", {Title = "Nâng Phòng Thủ (Defense)", Default = false}):OnChanged(function(Value)
    _G.StatsToUpgrade["Defense"] = Value
end)

Tabs.Setting:AddToggle("StatFruit", {Title = "Nâng Trái Blox (Demon Fruit)", Default = false}):OnChanged(function(Value)
    _G.StatsToUpgrade["Demon Fruit"] = Value
end)

-- SECTION TIỆN ÍCH MỚI THÊM (FIX LAG & REDEEM CODE)
Tabs.Setting:AddSection("--- Tiện Ích Khác ---")

Tabs.Setting:AddButton({
    Title = "Giảm Lag Trò Chơi (Fix Lag)",
    Description = "Tối ưu hóa đồ họa, xóa sương mù/mây để tăng mượt mà",
    Callback = function()
        pcall(function()
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterDetailSize = 0
            end
            
            local lighting = game:GetService("Lighting")
            lighting.GlobalShadows = false
            lighting.FogEnd = 9e9
            
            for _, v in pairs(lighting:GetChildren()) do
                if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") then
                    v:Destroy()
                end
            end
            
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsA("MeshPart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    v:Destroy()
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                    v.Enabled = false
                end
            end
            
            Fluent:Notify({
                Title = "huy Hub",
                Content = "Đã kích hoạt chế độ siêu mượt (Fix Lag)!",
                Duration = 3
            })
        end)
    end
})

Tabs.Setting:AddButton({
    Title = "Nhập Tất Cả Code EXP/Reset",
    Description = "Tự động kích hoạt toàn bộ mã Code còn hạn",
    Callback = function()
        Fluent:Notify({
            Title = "huy Hub",
            Content = "Đang tiến hành nhập toàn bộ Code...",
            Duration = 3
        })
        
        spawn(function()
            for _, code in pairs(CodeList) do
                pcall(function()
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("RedeemCode", code)
                    task.wait(0.2) -- Tránh spam hệ thống quá nhanh gây lỗi
                end)
            end
            
            Fluent:Notify({
                Title = "huy Hub",
                Content = "Đã chạy xong danh sách Code!",
                Duration = 4
            })
        end)
    end
})

----------------------------------------------------------------------------------------------------------------------------------------------
-- VÒNG LẶP AUTO STATS
----------------------------------------------------------------------------------------------------------------------------------------------
spawn(function()
    while task.wait(0.5) do
        if _G.AutoStats then
            pcall(function()
                local points = game:GetService("Players").LocalPlayer.Data.Points.Value
                if points > 0 then
                    for statName, shouldUpgrade in pairs(_G.StatsToUpgrade) do
                        if shouldUpgrade then
                            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", statName, points)
                        end
                    end
                end
            end)
        end
    end
end)

----------------------------------------------------------------------------------------------------------------------------------------------
-- VÒNG LẶP CHÍNH THỰC THI NHIỆM VỤ (MAIN SYSTEM)
----------------------------------------------------------------------------------------------------------------------------------------------
spawn(function()
    while task.wait() do
        if _G.AutoLevel then
            pcall(function()
                CheckLevel()
                
                local char = game.Players.LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") then return end

                local hasQuest = game:GetService("Players").LocalPlayer.PlayerGui.Main:FindFirstChild("Quest") and game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest.Visible
                
                if not hasQuest then
                    if (char.HumanoidRootPart.Position - CFrameQ.Position).Magnitude > 15 then
                        Tween(CFrameQ)
                    else
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, QuestLv)
                    end
                else
                    local TargetMob = nil
                    for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                        if v.Name == NameMon and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then
                            TargetMob = v
                            break
                        end
                    end
                    
                    if TargetMob and TargetMob:FindFirstChild("HumanoidRootPart") then
                        local FarmPos = TargetMob.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0)
                        
                        repeat task.wait(_G.Fast_Delay)
                            if not _G.AutoLevel then break end
                            
                            AutoHaki()
                            EquipTool(SelectWeapon)
                            
                            TargetMob.HumanoidRootPart.CanCollide = false
                            TargetMob.HumanoidRootPart.Size = Vector3.new(50, 50, 50)
                            TargetMob.Humanoid.WalkSpeed = 0
                            
                            FarmPos = TargetMob.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0)
                            Tween(FarmPos)
                            
                            AttackNoCD()
                        until not TargetMob.Parent or TargetMob.Humanoid.Health <= 0 or not _G.AutoLevel
                    else
                        if (char.HumanoidRootPart.Position - CFrameMon.Position).Magnitude > 15 then
                            Tween(CFrameMon * CFrame.new(0, 11, 0))
                        else
                            char.HumanoidRootPart.CFrame = CFrameMon * CFrame.new(0, 11, 0)
                        end
                    end
                end
            end)
        end
    end
end)

Fluent:Notify({
    Title = "huy Hub",
    Content = "Đã cập nhật tính năng Fix Lag và Auto Code thành công!",
    Duration = 5
})
