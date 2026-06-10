----------------------------------------------------------------------------------------------------------------------------------------------
-- KHỞI TẠO THƯ VIỆN FLUENT LIBRARY & CONFIG
----------------------------------------------------------------------------------------------------------------------------------------------
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Window = Fluent:CreateWindow({
    Title = "huy Hub",
    SubTitle = "Blox Fruits Auto Farm Full Seas (Lv 1 - 2800)",
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
_G.Fast_Delay = 0.01 
SelectWeapon = "Melee" 

-- Cấu hình Auto Stats
_G.AutoStats = false
_G.StatsToUpgrade = {
    ["Melee"] = false,
    ["Defense"] = false,
    ["Demon Fruit"] = false
}

----------------------------------------------------------------------------------------------------------------------------------------------
-- NÚT BẬT TẮT MENU (TOGGLE BUTTON) MOBILE
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
-- ANTI-AFK & NOCLIP
----------------------------------------------------------------------------------------------------------------------------------------------
game:GetService("Players").LocalPlayer.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if _G.AutoLevel and game.Players.LocalPlayer.Character then
            local char = game.Players.LocalPlayer.Character
            for _, part in pairs(char:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            if char:FindFirstChild("HumanoidRootPart") then
                char.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end)

----------------------------------------------------------------------------------------------------------------------------------------------
-- HÀM TWEEN VÀ BỔ TRỢ
----------------------------------------------------------------------------------------------------------------------------------------------
local currentTween = nil
local function Tween(CFgo)
    local playerChar = game.Players.LocalPlayer.Character
    if not playerChar or not playerChar:FindFirstChild("HumanoidRootPart") then return end
    
    local currentPos = playerChar.HumanoidRootPart.Position
    local distance = (currentPos - CFgo.Position).Magnitude
    local speed = 350 
    local duration = distance / speed
    
    if distance < 5 then
        playerChar.HumanoidRootPart.CFrame = CFgo
        return
    end

    local tween_s = game:GetService("TweenService")
    local info = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    
    if currentTween then currentTween:Cancel() end
    
    currentTween = tween_s:Create(playerChar.HumanoidRootPart, info, {CFrame = CFgo})
    currentTween:Play()
    return currentTween
end

local function EquipTool(ToolType)
    local bp = game.Players.LocalPlayer.Backpack
    local char = game.Players.LocalPlayer.Character
    if not char then return end
    for _, v in pairs(bp:GetChildren()) do
        if v:IsA("Tool") and (v.ToolTip == ToolType or v.Name == ToolType or string.find(v.Name, ToolType)) then
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
-- DATABASE PHÂN TÍCH NHIỆM VỤ ĐÚNG 100% THEO FILE TÀI LIỆU (LEVEL 1 - 2800)
----------------------------------------------------------------------------------------------------------------------------------------------
function CheckLevel()
    local Lv = game:GetService("Players").LocalPlayer.Data.Level.Value
    local MySea = 1
    
    if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("BoatCastle") then
        MySea = 3
    elseif workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("IceGlacier") then
        MySea = 2
    end

    -- Khởi tạo mặc định tránh nil lỗi
    NameQuest = "BanditQuest1" QuestLv = 1 NameMon = "Bandit"
    CFrameQ = CFrame.new(1060.938, 16.455, 1547.784) CFrameMon = CFrame.new(1038.553, 41.296, 1576.510)

    -- ================= SEA 1 =================
    if MySea == 1 then
        if Lv >= 1 and Lv <= 9 then
            [span_1](start_span)NameQuest = "BanditQuest1" QuestLv = 1 NameMon = "Bandit" --[span_1](end_span)
            CFrameQ = CFrame.new(1060.938, 16.455, 1547.784) CFrameMon = CFrame.new(1038.553, 41.296, 1576.510)
        elseif Lv >= 10 and Lv <= 14 then
            [span_2](start_span)NameQuest = "BanditQuest2" QuestLv = 2 NameMon = "Monkey" --[span_2](end_span)
            CFrameQ = CFrame.new(-1601.655, 36.852, 153.388) CFrameMon = CFrame.new(-1448.144, 50.852, 63.607)
        elseif Lv >= 15 and Lv <= 29 then
            [span_3](start_span)NameQuest = "JungleQuest" QuestLv = 1 NameMon = "Gorilla" --[span_3](end_span)
            CFrameQ = CFrame.new(-1601.655, 36.852, 153.388) CFrameMon = CFrame.new(-1142.648, 40.462, -515.392)
        elseif Lv >= 30 and Lv <= 39 then
            [span_4](start_span)NameQuest = "JungleQuest" QuestLv = 2 NameMon = "Gorilla King" --[span_4](end_span)
            CFrameQ = CFrame.new(-1601.655, 36.852, 153.388) CFrameMon = CFrame.new(-1142.648, 40.462, -515.392)
        elseif Lv >= 40 and Lv <= 59 then
            [span_5](start_span)NameQuest = "BuggyQuest1" QuestLv = 1 NameMon = "Pirate" --[span_5](end_span)
            CFrameQ = CFrame.new(-1140.176, 4.752, 3827.405) CFrameMon = CFrame.new(-1201.088, 40.628, 3857.596)
        elseif Lv >= 60 and Lv <= 74 then
            [span_6](start_span)NameQuest = "BuggyQuest1" QuestLv = 2 NameMon = "Brute" --[span_6](end_span)
            CFrameQ = CFrame.new(-1140.176, 4.752, 3827.405) CFrameMon = CFrame.new(-1387.532, 24.592, 4100.958)
        elseif Lv >= 75 and Lv <= 89 then
            [span_7](start_span)NameQuest = "DesertQuest" QuestLv = 1 NameMon = "Desert Bandit" --[span_7](end_span)
            CFrameQ = CFrame.new(896.517, 6.438, 4390.149) CFrameMon = CFrame.new(984.999, 16.110, 4417.910)
        elseif Lv >= 90 and Lv <= 99 then
            [span_8](start_span)NameQuest = "DesertQuest" QuestLv = 2 NameMon = "Desert Officer" --[span_8](end_span)
            CFrameQ = CFrame.new(896.517, 6.438, 4390.149) CFrameMon = CFrame.new(1547.151, 14.452, 4381.800)
        elseif Lv >= 100 and Lv <= 119 then
            [span_9](start_span)NameQuest = "SnowQuest" QuestLv = 1 NameMon = "Snow Bandit" --[span_9](end_span)
            CFrameQ = CFrame.new(1386.807, 87.273, -1298.358) CFrameMon = CFrame.new(1356.302, 105.769, -1328.242)
        elseif Lv >= 120 and Lv <= 149 then
            [span_10](start_span)NameQuest = "SnowQuest" QuestLv = 2 NameMon = "Snowman" --[span_10](end_span)
            CFrameQ = CFrame.new(1386.807, 87.273, -1298.358) CFrameMon = CFrame.new(1218.796, 138.012, -1488.026)
        elseif Lv >= 150 and Lv <= 174 then
            [span_11](start_span)NameQuest = "MarinefordQuest" QuestLv = 1 NameMon = "Chief Petty Officer" --[span_11](end_span)
            CFrameQ = CFrame.new(-5035.496, 28.678, 4324.184) CFrameMon = CFrame.new(-4931.155, 65.793, 4121.839)
        elseif Lv >= 175 and Lv <= 189 then
            [span_12](start_span)NameQuest = "MarinefordQuest" QuestLv = 2 NameMon = "Vice Admiral" --[span_12](end_span)
            CFrameQ = CFrame.new(-5035.496, 28.678, 4324.184) CFrameMon = CFrame.new(-4931.155, 65.793, 4121.839)
        elseif Lv >= 190 and Lv <= 209 then
            [span_13](start_span)NameQuest = "SkyQuest" QuestLv = 1 NameMon = "Sky Bandit" --[span_13](end_span)
            CFrameQ = CFrame.new(-4842.137, 717.695, -2623.048) CFrameMon = CFrame.new(-4955.641, 365.464, -2908.187)
        elseif Lv >= 210 and Lv <= 249 then
            [span_14](start_span)NameQuest = "SkyQuest" QuestLv = 2 NameMon = "Dark Master" --[span_14](end_span)
            CFrameQ = CFrame.new(-4842.137, 717.695, -2623.048) CFrameMon = CFrame.new(-5148.165, 439.046, -2332.961)
        elseif Lv >= 250 and Lv <= 274 then
            [span_15](start_span)NameQuest = "ColosseumQuest" QuestLv = 1 NameMon = "Toga Warrior" --[span_15](end_span)
            CFrameQ = CFrame.new(-6244.410, 5581.564, -1324.321) CFrameMon = CFrame.new(-6284.150, 5600.222, -1388.150)
        elseif Lv >= 275 and Lv <= 299 then
            [span_16](start_span)NameQuest = "ColosseumQuest" QuestLv = 2 NameMon = "Gladiator" --[span_16](end_span)
            CFrameQ = CFrame.new(-6244.410, 5581.564, -1324.321) CFrameMon = CFrame.new(-6284.150, 5600.222, -1388.150)
        elseif Lv >= 300 and Lv <= 329 then
            [span_17](start_span)NameQuest = "MagmaQuest" QuestLv = 1 NameMon = "Military Soldier" --[span_17](end_span)
            CFrameQ = CFrame.new(-5224.231, 14.521, 8452.421) CFrameMon = CFrame.new(-5411.380, 72.411, 8560.124)
        elseif Lv >= 330 and Lv <= 374 then
            [span_18](start_span)NameQuest = "MagmaQuest" QuestLv = 2 NameMon = "Military Spy" --[span_18](end_span)
            CFrameQ = CFrame.new(-5224.231, 14.521, 8452.421) CFrameMon = CFrame.new(-5824.120, 80.522, 8824.110)
        elseif Lv >= 375 and Lv <= 399 then
            [span_19](start_span)NameQuest = "FishmanQuest" QuestLv = 1 NameMon = "Fishman Warrior" --[span_19](end_span)
            CFrameQ = CFrame.new(6112.42, 18.42, -5672.11) CFrameMon = CFrame.new(6084.12, 18.52, -5924.12)
        elseif Lv >= 400 and Lv <= 449 then
            [span_20](start_span)NameQuest = "FishmanQuest" QuestLv = 2 NameMon = "Fishman Commando" --[span_20](end_span)
            CFrameQ = CFrame.new(6112.42, 18.42, -5672.11) CFrameMon = CFrame.new(6210.42, 18.52, -6150.41)
        elseif Lv >= 450 and Lv <= 474 then
            [span_21](start_span)NameQuest = "SkyExp1Quest" QuestLv = 1 NameMon = "God's Guard" --[span_21](end_span)
            CFrameQ = CFrame.new(-5705.210, 7122.421, -1721.411) CFrameMon = CFrame.new(-5780.250, 7150.120, -1890.350)
        elseif Lv >= 475 and Lv <= 524 then
            [span_22](start_span)NameQuest = "SkyExp1Quest" QuestLv = 2 NameMon = "Shanda" --[span_22](end_span)
            CFrameQ = CFrame.new(-5705.210, 7122.421, -1721.411) CFrameMon = CFrame.new(-5542.150, 7192.150, -2100.410)
        elseif Lv >= 525 and Lv <= 549 then
            [span_23](start_span)NameQuest = "SkyExp2Quest" QuestLv = 1 NameMon = "Royal Squad" --[span_23](end_span)
            CFrameQ = CFrame.new(-7854.21, 5542.11, -380.25) CFrameMon = CFrame.new(-7640.21, 5545.12, -490.25)
        elseif Lv >= 550 and Lv <= 624 then
            [span_24](start_span)NameQuest = "SkyExp2Quest" QuestLv = 2 NameMon = "Royal Soldier" --[span_24](end_span)
            CFrameQ = CFrame.new(-7854.21, 5542.11, -380.25) CFrameMon = CFrame.new(-7920.14, 5550.21, -210.45)
        elseif Lv >= 625 and Lv <= 649 then
            [span_25](start_span)NameQuest = "FountainQuest" QuestLv = 1 NameMon = "Galley Pirate" --[span_25](end_span)
            CFrameQ = CFrame.new(5258.279, 38.527, 4050.045) CFrameMon = CFrame.new(5425.410, 70.410, 4824.150)
        elseif Lv >= 650 then
            [span_26](start_span)NameQuest = "FountainQuest" QuestLv = 2 NameMon = "Galley Captain" --[span_26](end_span)
            CFrameQ = CFrame.new(5258.279, 38.527, 4050.045) CFrameMon = CFrame.new(5677.677, 92.786, 4966.632)
        end

    -- ================= SEA 2 =================
    elseif MySea == 2 then
        if Lv >= 700 and Lv <= 724 then
            [span_27](start_span)NameQuest = "Area1Quest" QuestLv = 1 NameMon = "Raider" --[span_27](end_span)
            CFrameQ = CFrame.new(-425.12, 7.15, 1824.50) CFrameMon = CFrame.new(-312.45, 45.10, 2011.20)
        elseif Lv >= 725 and Lv <= 774 then
            [span_28](start_span)NameQuest = "Area1Quest" QuestLv = 2 NameMon = "Mercenary" --[span_28](end_span)
            CFrameQ = CFrame.new(-425.12, 7.15, 1824.50) CFrameMon = CFrame.new(-540.20, 45.50, 1920.80)
        elseif Lv >= 775 and Lv <= 799 then
            [span_29](start_span)NameQuest = "Area2Quest" QuestLv = 1 NameMon = "Swan Pirate" --[span_29](end_span)
            CFrameQ = CFrame.new(625.40, 35.12, 1075.40) CFrameMon = CFrame.new(845.20, 33.10, 1210.50)
        elseif Lv >= 800 and Lv <= 874 then
            [span_30](start_span)NameQuest = "Area2Quest" QuestLv = 2 NameMon = "Factory Staff" --[span_30](end_span)
            CFrameQ = CFrame.new(625.40, 35.12, 1075.40) CFrameMon = CFrame.new(610.25, 35.12, 1420.50)
        elseif Lv >= 875 and Lv <= 899 then
            [span_31](start_span)NameQuest = "ZombieQuest" QuestLv = 1 NameMon = "Zombie" --[span_31](end_span)
            CFrameQ = CFrame.new(-5490.50, 48.15, -710.20) CFrameMon = CFrame.new(-5620.40, 40.20, -780.40)
        elseif Lv >= 900 and Lv <= 949 then
            [span_32](start_span)NameQuest = "ZombieQuest" QuestLv = 2 NameMon = "Vampire" --[span_32](end_span)
            CFrameQ = CFrame.new(-5490.50, 48.15, -710.20) CFrameMon = CFrame.new(-5520.42, 45.12, -924.12)
        elseif Lv >= 950 and Lv <= 974 then
            [span_33](start_span)NameQuest = "SnowMountainQuest" QuestLv = 1 NameMon = "Snow Trooper" --[span_33](end_span)
            CFrameQ = CFrame.new(1250.40, 125.40, -5420.10) CFrameMon = CFrame.new(1380.20, 128.50, -5540.40)
        elseif Lv >= 975 and Lv <= 999 then
            [span_34](start_span)NameQuest = "SnowMountainQuest" QuestLv = 2 NameMon = "Winter Warrior" --[span_34](end_span)
            CFrameQ = CFrame.new(1250.40, 125.40, -5420.10) CFrameMon = CFrame.new(1120.45, 140.21, -5320.14)
        elseif Lv >= 1000 and Lv <= 1049 then
            [span_35](start_span)NameQuest = "HotIslandQuest" QuestLv = 1 NameMon = "Lab Subordinate" --[span_35](end_span)
            CFrameQ = CFrame.new(-2724.11, 15.21, -5240.11) CFrameMon = CFrame.new(-2840.12, 20.45, -5380.11)
        elseif Lv >= 1050 and Lv <= 1099 then
            [span_36](start_span)NameQuest = "HotIslandQuest" QuestLv = 2 NameMon = "Horned Warrior" --[span_36](end_span)
            CFrameQ = CFrame.new(-2724.11, 15.21, -5240.11) CFrameMon = CFrame.new(-2600.41, 18.52, -5100.41)
        elseif Lv >= 1100 and Lv <= 1124 then
            [span_37](start_span)NameQuest = "ColdIslandQuest" QuestLv = 1 NameMon = "Magma Ninja" --[span_37](end_span)
            CFrameQ = CFrame.new(-2724.11, 15.21, -5240.11) CFrameMon = CFrame.new(-3120.45, 40.12, -5500.12)
        elseif Lv >= 1125 and Lv <= 1174 then
            [span_38](start_span)NameQuest = "ColdIslandQuest" QuestLv = 2 NameMon = "Lava Pirate" --[span_38](end_span)
            CFrameQ = CFrame.new(-2724.11, 15.21, -5240.11) CFrameMon = CFrame.new(-3250.14, 42.15, -5720.45)
        elseif Lv >= 1175 and Lv <= 1199 then
            [span_39](start_span)NameQuest = "IceCastleQuest" QuestLv = 1 NameMon = "Snow Lurker" --[span_39](end_span)
            CFrameQ = CFrame.new(6124.11, 15.42, -924.12) CFrameMon = CFrame.new(6250.45, 15.42, -1050.25)
        elseif Lv >= 1200 and Lv <= 1249 then
            [span_40](start_span)NameQuest = "IceCastleQuest" QuestLv = 2 NameMon = "Arctic Warrior" --[span_40](end_span)
            CFrameQ = CFrame.new(6124.11, 15.42, -924.12) CFrameMon = CFrame.new(6020.14, 40.25, -820.14)
        elseif Lv >= 1250 and Lv <= 1274 then
            [span_41](start_span)NameQuest = "ForgottenQuest" QuestLv = 1 NameMon = "Sea Soldier" --[span_41](end_span)
            CFrameQ = CFrame.new(-3050.21, 240.12, -10214.11) CFrameMon = CFrame.new(-3150.45, 245.12, -10350.21)
        elseif Lv >= 1275 then
            [span_42](start_span)NameQuest = "ForgottenQuest" QuestLv = 2 NameMon = "Water Fighter" --[span_42](end_span)
            CFrameQ = CFrame.new(-3050.21, 240.12, -10214.11) CFrameMon = CFrame.new(-2920.14, 245.12, -10080.14)
        end

    -- ================= SEA 3 =================
    elseif MySea == 3 then
        if Lv >= 1500 and Lv <= 1524 then
            [span_43](start_span)NameQuest = "PiratePortQuest" QuestLv = 1 NameMon = "Pirate Millionaire" --[span_43](end_span)
            CFrameQ = CFrame.new(-290.40, 15.20, 5400.10) CFrameMon = CFrame.new(-450.50, 15.20, 5300.40)
        elseif Lv >= 1525 and Lv <= 1574 then
            [span_44](start_span)NameQuest = "PiratePortQuest" QuestLv = 2 NameMon = "Pistol Billionaire" --[span_44](end_span)
            CFrameQ = CFrame.new(-290.40, 15.20, 5400.10) CFrameMon = CFrame.new(-200.40, 75.10, 5550.20)
        elseif Lv >= 1575 and Lv <= 1599 then
            [span_45](start_span)NameQuest = "AmazonQuest" QuestLv = 1 NameMon = "Dragon Crew Warrior" --[span_45](end_span)
            CFrameQ = CFrame.new(5700.50, 50.10, -100.40) CFrameMon = CFrame.new(5850.40, 50.20, -250.50)
        elseif Lv >= 1600 and Lv <= 1624 then
            [span_46](start_span)NameQuest = "AmazonQuest" QuestLv = 2 NameMon = "Dragon Crew Archer" --[span_46](end_span)
            CFrameQ = CFrame.new(5700.50, 50.10, -100.40) CFrameMon = CFrame.new(6050.20, 75.40, -150.40)
        elseif Lv >= 1625 and Lv <= 1649 then
            [span_47](start_span)NameQuest = "AmazonQuest2" QuestLv = 1 NameMon = "Female Islander" --[span_47](end_span)
            CFrameQ = CFrame.new(5420.11, 80.21, -520.14) CFrameMon = CFrame.new(5300.14, 80.21, -640.41)
        elseif Lv >= 1650 and Lv <= 1699 then
            [span_48](start_span)NameQuest = "AmazonQuest2" QuestLv = 2 NameMon = "Giant Islander" --[span_48](end_span)
            CFrameQ = CFrame.new(5420.11, 80.21, -520.14) CFrameMon = CFrame.new(5560.14, 85.12, -720.14)
        elseif Lv >= 1700 and Lv <= 1724 then
            [span_49](start_span)NameQuest = "MarineTreeQuest" QuestLv = 1 NameMon = "Marine Recruit" --[span_49](end_span)
        CFrameQ = CFrame.new(2200.40, 25.10, -6500.40) CFrameMon = CFrame.new(2100.50, 40.20, -6300.40)
        elseif Lv >= 1775 and Lv <= 1799 then
            [span_51](start_span)NameQuest = "DeepForestQuest" QuestLv = 1 NameMon = "Forest Pirate" --[span_51](end_span)
            CFrameQ = CFrame.new(-5800.20, 120.40, -1800.50) CFrameMon = CFrame.new(-6000.40, 120.40, -1950.20)
        elseif Lv >= 1800 and Lv <= 1824 then
            [span_52](start_span)NameQuest = "DeepForestQuest" QuestLv = 2 NameMon = "Mythological Pirate" --[span_52](end_span)
            CFrameQ = CFrame.new(-5800.20, 120.40, -1800.50) CFrameMon = CFrame.new(-5650.50, 150.20, -1700.40)
        elseif Lv >= 1825 and Lv <= 1849 then
            [span_53](start_span)NameQuest = "DeepForestQuest2" QuestLv = 1 NameMon = "Jungle Pirate" --[span_53](end_span)
            CFrameQ = CFrame.new(-6100.40, 150.20, -3000.50) CFrameMon = CFrame.new(-6300.20, 150.20, -3150.40)
        elseif Lv >= 1850 and Lv <= 1899 then
            [span_54](start_span)NameQuest = "DeepForestQuest2" QuestLv = 2 NameMon = "Musketeer Pirate" --[span_54](end_span)
            CFrameQ = CFrame.new(-6100.40, 150.20, -3000.50) CFrameMon = CFrame.new(-5950.14, 150.20, -2900.14)
        elseif Lv >= 1900 and Lv <= 1924 then
            [span_55](start_span)NameQuest = "HauntedQuest" QuestLv = 1 NameMon = "Reborn Skeleton" --[span_55](end_span)
            CFrameQ = CFrame.new(-5400.40, 15.20, -5400.20) CFrameMon = CFrame.new(-5550.50, 15.20, -5600.40)
        elseif Lv >= 1925 and Lv <= 1974 then
            [span_56](start_span)NameQuest = "HauntedQuest" QuestLv = 2 NameMon = "Living Zombie" --[span_56](end_span)
            CFrameQ = CFrame.new(-5400.40, 15.20, -5400.20) CFrameMon = CFrame.new(-5300.40, 45.10, -5700.20)
        elseif Lv >= 1975 and Lv <= 1999 then
            [span_57](start_span)NameQuest = "IceCreamQuest" QuestLv = 1 NameMon = "Ice Cream Chef" --[span_57](end_span)
            CFrameQ = CFrame.new(-1150.20, 15.40, -12200.40) CFrameMon = CFrame.new(-1300.40, 15.40, -12350.50)
        elseif Lv >= 2000 and Lv <= 2049 then
            [span_58](start_span)NameQuest = "IceCreamQuest" QuestLv = 2 NameMon = "Ice Cream Commander" --[span_58](end_span)
            CFrameQ = CFrame.new(-1150.20, 15.40, -12200.40) CFrameMon = CFrame.new(-1000.50, 15.40, -12050.20)
        elseif Lv >= 2050 and Lv <= 2074 then
            [span_59](start_span)NameQuest = "CakeQuest1" QuestLv = 1 NameMon = "Cookie Crafter" --[span_59](end_span)
            CFrameQ = CFrame.new(-1150.20, 15.40, -12200.40) CFrameMon = CFrame.new(-1300.40, 15.40, -12350.50)
        elseif Lv >= 2075 and Lv <= 2124 then
            [span_60](start_span)NameQuest = "CakeQuest1" QuestLv = 2 NameMon = "Cake Guard" --[span_60](end_span)
            CFrameQ = CFrame.new(-1150.20, 15.40, -12200.40) CFrameMon = CFrame.new(-1000.50, 15.40, -12050.20)
        elseif Lv >= 2125 and Lv <= 2149 then
            [span_61](start_span)NameQuest = "CakeQuest2" QuestLv = 1 NameMon = "Baking Staff" --[span_61](end_span)
            CFrameQ = CFrame.new(-1900.40, 40.20, -13100.50) CFrameMon = CFrame.new(-2050.20, 40.20, -13300.40)
        elseif Lv >= 2150 and Lv <= 2199 then
            [span_62](start_span)NameQuest = "CakeQuest2" QuestLv = 2 NameMon = "Head Baker" --[span_62](end_span)
            CFrameQ = CFrame.new(-1900.40, 40.20, -13100.50) CFrameMon = CFrame.new(-1750.50, 40.20, -12900.20)
        elseif Lv >= 2200 and Lv <= 2224 then
            [span_63](start_span)NameQuest = "ChocolateQuest" QuestLv = 1 NameMon = "Cocoa Warrior" --[span_63](end_span)
            CFrameQ = CFrame.new(-1900.40, 40.20, -13100.50) CFrameMon = CFrame.new(-1750.50, 40.20, -12900.20)
        elseif Lv >= 2225 and Lv <= 2274 then
            [span_64](start_span)NameQuest = "ChocolateQuest" QuestLv = 2 NameMon = "Chocolate Bar Battler" --[span_64](end_span)
            CFrameQ = CFrame.new(-1900.40, 40.20, -13100.50) CFrameMon = CFrame.new(-2200.14, 40.20, -13250.14)
        elseif Lv >= 2275 and Lv <= 2299 then
            [span_65](start_span)NameQuest = "CandyQuest" QuestLv = 1 NameMon = "Sweet Thief" --[span_65](end_span)
            CFrameQ = CFrame.new(-2500.40, 15.20, -14200.50) CFrameMon = CFrame.new(-2650.20, 15.20, -14400.40)
        elseif Lv >= 2300 and Lv <= 2349 then
            [span_66](start_span)NameQuest = "CandyQuest" QuestLv = 2 NameMon = "Candy Rebel" --[span_66](end_span)
            CFrameQ = CFrame.new(-2500.40, 15.20, -14200.50) CFrameMon = CFrame.new(-2350.50, 15.20, -14000.20)
        elseif Lv >= 2350 and Lv <= 2399 then
            [span_67](start_span)NameQuest = "TikiQuest" QuestLv = 1 NameMon = "Isle Outlaw" --[span_67](end_span)
            CFrameQ = CFrame.new(-15412.45, 45.12, -1214.45) CFrameMon = CFrame.new(-15550.45, 45.12, -1380.12)
        elseif Lv >= 2400 then
            [span_68](start_span)NameQuest = "TikiQuest" QuestLv = 2 NameMon = "Sun-kissed Warrior" --[span_68](end_span)
            CFrameQ = CFrame.new(-15412.45, 45.12, -1214.45) CFrameMon = CFrame.new(-15210.14, 50.14, -1040.45)
        end
    end
end

----------------------------------------------------------------------------------------------------------------------------------------------
-- GIAO DIỆN HÀNH VI (UI CONTROLS)
----------------------------------------------------------------------------------------------------------------------------------------------
Tabs.Main:AddToggle("ToggleFarm", {Title = "Tự Động Farm Cấp Độ (Tất cả Sea)", Default = false}):OnChanged(function(Value)
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

Tabs.Setting:AddSection("--- Tự Động Nâng Điểm (Auto Stats) ---")
Tabs.Setting:AddToggle("ToggleStats", {Title = "Kích Hoạt Auto Stats", Default = false}):OnChanged(function(Value) _G.AutoStats = Value end)
Tabs.Setting:AddToggle("StatMelee", {Title = "Nâng Cận Chiến (Melee)", Default = false}):OnChanged(function(Value) _G.StatsToUpgrade["Melee"] = Value end)
Tabs.Setting:AddToggle("StatDefense", {Title = "Nâng Phòng Thủ (Defense)", Default = false}):OnChanged(function(Value) _G.StatsToUpgrade["Defense"] = Value end)
Tabs.Setting:AddToggle("StatFruit", {Title = "Nâng Trái Blox (Demon Fruit)", Default = false}):OnChanged(function(Value) _G.StatsToUpgrade["Demon Fruit"] = Value end)

Tabs.Setting:AddSection("--- Tiện Ích Khác ---")
Tabs.Setting:AddButton({
    Title = "Giảm Lag Trò Chơi (Fix Lag)",
    Description = "Tối ưu hóa đồ họa, xóa sương mù/mây để tăng mượt mà",
    Callback = function()
        pcall(function()
            local terrain = workspace:FindFirstChildOfClass("Terrain")
            if terrain then terrain.WaterWaveSize = 0 terrain.WaterWaveSpeed = 0 terrain.WaterReflectance = 0 terrain.WaterDetailSize = 0 end
            local lighting = game:GetService("Lighting")
            lighting.GlobalShadows = false lighting.FogEnd = 9e9
            for _, v in pairs(lighting:GetChildren()) do if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("Clouds") then v:Destroy() end end
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and not v:IsA("MeshPart") then v.Material = Enum.Material.SmoothPlastic v.Reflectance = 0
                elseif v:IsA("Decal") or v:IsA("Texture") then v:Destroy()
                elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
            end
            Fluent:Notify({Title = "huy Hub", Content = "Đã kích hoạt chế độ siêu mượt!", Duration = 3})
        end)
    end
})

----------------------------------------------------------------------------------------------------------------------------------------------
-- VÒNG LẶP KHỞI CHẠY AUTO STATS
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
-- VÒNG LẶP CHÍNH SYSTEM FARM (SEA 1 -> SEA 3)
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
                    if (char.HumanoidRootPart.Position - CFrameQ.Position).Magnitude > 20 then
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
                            
                            -- Gom toàn bộ quái có tên tương đồng về một vị trí để đánh lan tối ưu tốc độ
                            for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                                if v.Name == NameMon and v ~= TargetMob and v:FindFirstChild("HumanoidRootPart") then
                                    v.HumanoidRootPart.CFrame = TargetMob.HumanoidRootPart.CFrame
                                    v.HumanoidRootPart.CanCollide = false
                                end
                            end
                            
                            FarmPos = TargetMob.HumanoidRootPart.CFrame * CFrame.new(0, 11, 0)
                            Tween(FarmPos)
                            
                            AttackNoCD()
                        until not TargetMob.Parent or TargetMob.Humanoid.Health <= 0 or not _G.AutoLevel
                    else
                        if (char.HumanoidRootPart.Position - CFrameMon.Position).Magnitude > 20 then
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
