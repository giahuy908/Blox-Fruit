--[[
    RELZ HUB - BLOX FRUITS PREMIUM EDITION
    Giao diện: Fluent UI (Premium, mượt mà, tối ưu hóa Mobile/PC)
    Chức năng: Auto Farm Level, Auto Boss, Auto Sea, Auto Item, ESP, Stats, Teleport, Fruit...
    Ngôn ngữ hiển thị: Tiếng Việt
]]

-- Khởi tạo kiểm tra thế giới (World Detection)
local placeId = game.PlaceId
local World1, World2, World3 = false, false, false
if placeId == 2753915549 then
    World1 = true
elseif placeId == 4442272183 then
    World2 = true
elseif placeId == 7449423635 then
    World3 = true
end

-- Chờ game tải hoàn tất
if not game:IsLoaded() then game.Loaded:Wait() end

-- Tải Thư viện Fluent UI & Các Addon Quản lý cấu hình
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/main/Addons/InterfaceManager.lua"))()

-- Khởi tạo cấu hình mặc định (Settings)
_G.Settings = {
    Main = {
        ["Auto Farm Level"] = false,
        ["Select Weapon"] = "Melee",
        ["Selected Weapon"] = "Combat",
        ["Farm Mode"] = "Normal", -- Normal / Fast / Nearest
        ["Auto Farm Fruit Mastery"] = false,
        ["Auto Farm Gun Mastery"] = false,
        ["Auto Farm Sword Mastery"] = false,
        ["Selected Mastery Sword"] = "",
        ["Selected Mob"] = "",
        ["Auto Farm Mob"] = false,
        ["Selected Boss"] = "",
        ["Auto Farm Boss"] = false,
        ["Auto Farm All Boss"] = false,
        ["Mastery Health"] = 25
    },
    Farm = {
        ["Auto Elite Hunter"] = false,
        ["Auto Elite Hunter Hop"] = false,
        ["Selected Bone Farm Mode"] = "Quest",
        ["Auto Farm Bone"] = false,
        ["Auto Random Surprise"] = false,
        ["Auto Pirate Raid"] = false,
        ["Auto Farm Observation"] = false,
        ["Auto Observation V2"] = false,
        ["Auto Musketeer Hat"] = false,
        ["Auto Saber"] = false,
        ["Auto Farm Chest Tween"] = false,
        ["Auto Farm Chest Instant"] = false,
        ["Auto Chest Hop"] = false,
        ["Auto Stop Items"] = false,
        ["Auto Farm Katakuri"] = false,
        ["Auto Spawn Cake Prince"] = false,
        ["Auto Kill Cake Prince"] = false,
        ["Auto Kill Dough King"] = false
    },
    Setting = {
        ["Spin Position"] = false,
        ["Farm Distance"] = 35,
        ["Player Tween Speed"] = 350,
        ["Bring Mob"] = true,
        ["Bring Mob Mode"] = "Normal",
        ["Fast Attack"] = true,
        ["Fast Attack Mode"] = "Normal", -- Slow, Normal, Fast, Super Fast
        ["Attack Aura"] = true,
        ["Hide Notification"] = false,
        ["Hide Damage Text"] = true,
        ["Black Screen"] = false,
        ["White Screen"] = false,
        ["Hide Monster"] = false,
        ["Auto Set Spawn Point"] = true,
        ["Auto Observation"] = false,
        ["Auto Haki"] = true,
        ["Auto Rejoin"] = true,
        ["Bypass Anti Cheat"] = true
    },
    Hold = {
        ["Hold Mastery Skill Z"] = 0,
        ["Hold Mastery Skill X"] = 0,
        ["Hold Mastery Skill C"] = 0,
        ["Hold Mastery Skill V"] = 0,
        ["Hold Mastery Skill F"] = 0
    },
    Stats = {
        ["Auto Add Melee Stats"] = false,
        ["Auto Add Defense Stats"] = false,
        ["Auto Add Devil Fruit Stats"] = false,
        ["Auto Add Sword Stats"] = false,
        ["Auto Add Gun Stats"] = false,
        ["Point Stats"] = 1
    },
    Items = {
        ["Auto Second Sea"] = false,
        ["Auto Third Sea"] = false,
        ["Auto Farm Factory"] = false,
        ["Auto Super Human"] = false,
        ["Auto Death Step"] = false,
        ["Auto Fishman Karate"] = false,
        ["Auto Electric Claw"] = false,
        ["Auto Dragon Talon"] = false,
        ["Auto God Human"] = false,
        ["Auto Soul Guitar"] = false,
        ["Auto Cursed Dual Katana"] = false,
        ["Auto Yama"] = false,
        ["Auto Tushita"] = false,
        ["Auto Canvander"] = false,
        ["Auto Dragon Trident"] = false,
        ["Auto Pole"] = false,
        ["Auto Shark Saw"] = false,
        ["Auto Greybeard"] = false,
        ["Auto Swan Glasses"] = false,
        ["Auto Rainbow Haki"] = false,
        ["Auto Holy Torch"] = false,
        ["Auto Bartilo Quest"] = false
    },
    Esp = {
        ["ESP Player"] = false,
        ["ESP Chest"] = false,
        ["ESP DevilFruit"] = false,
        ["ESP RealFruit"] = false,
        ["ESP Flower"] = false,
        ["ESP Island"] = false,
        ["ESP Npc"] = false,
        ["ESP Sea Beast"] = false,
        ["ESP Monster"] = false
    },
    SeaEvent = {
        ["Selected Boat"] = "Guardian",
        ["Selected Zone"] = "Zone 5",
        ["Boat Tween Speed"] = 300,
        ["Sail Boat"] = false,
        ["Auto Farm Shark"] = true,
        ["Auto Farm Piranha"] = true,
        ["Auto Farm Terrorshark"] = true,
        ["Auto Farm Seabeasts"] = true,
        ["No Clip Rock"] = false
    },
    LocalPlayer = {
        ["Infinite Energy"] = false,
        ["Infinite Ability"] = true,
        ["Infinite Geppo"] = false,
        ["Active Race V4"] = true,
        ["Walk On Water"] = true,
        ["No Clip"] = false
    },
    Fruit = {
        ["Auto Buy Random Fruit"] = false,
        ["Store Rarity Fruit"] = "Common - Mythical",
        ["Auto Store Fruit"] = false,
        ["Fruit Notification"] = false,
        ["Teleport To Fruit"] = false,
        ["Tween To Fruit"] = false
    }
}

-- Hàm lưu cài đặt
local function SaveSettings()
    if writefile then
        writefile("RelzHub_BloxFruits_Config.json", game:GetService("HttpService"):JSONEncode(_G.Settings))
    end
end

-- Tải cài đặt cũ nếu có
if isfile and isfile("RelzHub_BloxFruits_Config.json") then
    local success, decoded = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile("RelzHub_BloxFruits_Config.json"))
    end)
    if success then
        _G.Settings = decoded
    end
end

-- Biến toàn cục hệ thống farm
local MyName = game.Players.LocalPlayer.Name
local MyLevel = game.Players.LocalPlayer.Data.Level.Value
local Mon, LevelQuest, NameQuest, NameMon, CFrameQuest, CFrameMon
local Pos = CFrame.new(0, _G.Settings.Setting["Farm Distance"], 0)
local tween
local PosMon
local MonFarm = ""

-- KHỞI TẠO CÁC HÀM TIỆN ÍCH HỖ TRỢ FARM CHUYÊN SÂU (Bypass, Tween, Auto-Haki, Equip)

-- Hàm kiểm tra khoảng cách
local function GetDistance(target)
    if not target then return 999999 end
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        return math.floor((target.Position - hrp.Position).Magnitude)
    end
    return 999999
end

-- Hệ thống NoClip và BodyVelocity giữ độ cao cố định tránh rơi xuống hư vô khi Farm
local function EnsureBodyClip()
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        if not hrp:FindFirstChild("BodyClip") then
            local Noclip = Instance.new("BodyVelocity")
            Noclip.Name = "BodyClip"
            Noclip.Parent = hrp
            Noclip.MaxForce = Vector3.new(100000, 100000, 100000)
            Noclip.Velocity = Vector3.new(0, 0, 0)
        end
    end
end

local function RemoveBodyClip()
    local hrp = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if hrp and hrp:FindFirstChild("BodyClip") then
        hrp:FindFirstChild("BodyClip"):Destroy()
    end
end

-- Hàm No-Clip an toàn thông qua RunService Stepped
local NoClipConnection
local function StartNoClip()
    if not NoClipConnection then
        NoClipConnection = game:GetService("RunService").Stepped:Connect(function()
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end

local function StopNoClip()
    if NoClipConnection then
        NoClipConnection:Disconnect()
        NoClipConnection = nil
    end
end

-- Hàm di chuyển bypass (Tween Speed Control + NoClip Security)
local function topos(targetCFrame)
    if not targetCFrame then return end
    local char = game.Players.LocalPlayer.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    
    if not hrp or not hum or hum.Health <= 0 then return end
    
    -- Kích hoạt chống kẹt địa hình
    StartNoClip()
    EnsureBodyClip()
    
    local distance = (targetCFrame.Position - hrp.Position).Magnitude
    if distance < 15 then
        hrp.CFrame = targetCFrame
        if tween then tween:Cancel() end
        return
    end
    
    local speed = _G.Settings.Setting["Player Tween Speed"]
    local info = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    
    if tween then tween:Cancel() end
    tween = game:GetService("TweenService"):Create(hrp, info, {CFrame = targetCFrame})
    tween:Play()
end

-- Hàm dừng Tween khi tắt chức năng
local function StopTween(toggleValue)
    if not toggleValue then
        if tween then tween:Cancel() end
        StopNoClip()
        RemoveBodyClip()
    end
end

-- Tự động bật Buso Haki (Vũ trang)
local function AutoHaki()
    if _G.Settings.Setting["Auto Haki"] then
        local char = game.Players.LocalPlayer.Character
        if char and not char:FindFirstChild("HasBuso") then
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso")
        end
    end
end

-- Hàm trang bị vũ khí tự động thông qua Backpack / Character
local function EquipWeapon(weaponName)
    local bp = game.Players.LocalPlayer:FindFirstChild("Backpack")
    local char = game.Players.LocalPlayer.Character
    if char and bp then
        local tool = bp:FindFirstChild(weaponName)
        if tool then
            char.Humanoid:EquipTool(tool)
        end
    end
end

-- Hàm hủy trang bị vũ khí
local function UnEquipWeapon(weaponName)
    local char = game.Players.LocalPlayer.Character
    local bp = game.Players.LocalPlayer:FindFirstChild("Backpack")
    if char and bp then
        local tool = char:FindFirstChild(weaponName)
        if tool then
            tool.Parent = bp
        end
    end
end

-- HỆ THỐNG KIỂM TRA NHIỆM VỤ DỰA TRÊN THẾ GIỚI (WORLD 1, 2, 3) VÀ CẤP ĐỘ
function CheckQuest()
    MyLevel = game.Players.LocalPlayer.Data.Level.Value
    if World1 then
        if MyLevel >= 1 and MyLevel <= 9 then
            Mon = "Bandit"
            LevelQuest = 1
            NameQuest = "BanditQuest1"
            NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37195, 15.4495068, 1550.4231)
            CFrameMon = CFrame.new(1045.9626, 27.0025, 1560.8203)
        elseif MyLevel >= 10 and MyLevel <= 14 then
            Mon = "Monkey"
            LevelQuest = 1
            NameQuest = "JungleQuest"
            NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838)
            CFrameMon = CFrame.new(-1448.518, 67.853, 11.465)
        elseif MyLevel >= 15 and MyLevel <= 29 then
            Mon = "Gorilla"
            LevelQuest = 2
            NameQuest = "JungleQuest"
            NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598.08911, 35.5501175, 153.377838)
            CFrameMon = CFrame.new(-1129.883, 40.4635, -525.4237)
        elseif MyLevel >= 30 and MyLevel <= 39 then
            Mon = "Pirate"
            LevelQuest = 1
            NameQuest = "BuggyQuest1"
            NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498)
            CFrameMon = CFrame.new(-1103.513, 13.752, 3896.091)
        elseif MyLevel >= 40 and MyLevel <= 59 then
            Mon = "Brute"
            LevelQuest = 2
            NameQuest = "BuggyQuest1"
            NameMon = "Brute"
            CFrameQuest = CFrame.new(-1141.07483, 4.10001802, 3831.5498)
            CFrameMon = CFrame.new(-1140.083, 14.809, 4322.921)
        elseif MyLevel >= 60 and MyLevel <= 74 then
            Mon = "Desert Bandit"
            LevelQuest = 1
            NameQuest = "DesertQuest"
            NameMon = "Desert Bandit"
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359)
            CFrameMon = CFrame.new(924.7998, 6.4486, 4481.5859)
        elseif MyLevel >= 75 and MyLevel <= 89 then
            Mon = "Desert Officer"
            LevelQuest = 2
            NameQuest = "DesertQuest"
            NameMon = "Desert Officer"
            CFrameQuest = CFrame.new(894.488647, 5.14000702, 4392.43359)
            CFrameMon = CFrame.new(1608.282, 8.614, 4371.007)
        elseif MyLevel >= 90 and MyLevel <= 99 then
            Mon = "Snow Bandit"
            LevelQuest = 1
            NameQuest = "SnowQuest"
            NameMon = "Snow Bandit"
            CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796)
            CFrameMon = CFrame.new(1354.347, 87.272, -1393.946)
        elseif MyLevel >= 100 and MyLevel <= 119 then
            Mon = "Snowman"
            LevelQuest = 2
            NameQuest = "SnowQuest"
            NameMon = "Snowman"
            CFrameQuest = CFrame.new(1389.74451, 88.1519318, -1298.90796)
            CFrameMon = CFrame.new(1201.641, 144.579, -1550.067)
        elseif MyLevel >= 120 and MyLevel <= 149 then
            Mon = "Chief Petty Officer"
            LevelQuest = 1
            NameQuest = "MarineQuest2"
            NameMon = "Chief Petty Officer"
            CFrameQuest = CFrame.new(-5039.58643, 27.3500385, 4324.68018)
            CFrameMon = CFrame.new(-4881.23, 22.652, 4273.752)
        elseif MyLevel >= 150 and MyLevel <= 174 then
            Mon = "Sky Bandit"
            LevelQuest = 1
            NameQuest = "SkyQuest"
            NameMon = "Sky Bandit"
            CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165)
            CFrameMon = CFrame.new(-4953.207, 295.744, -2899.229)
        elseif MyLevel >= 175 and MyLevel <= 189 then
            Mon = "Dark Master"
            LevelQuest = 2
            NameQuest = "SkyQuest"
            NameMon = "Dark Master"
            CFrameQuest = CFrame.new(-4839.53027, 716.368591, -2619.44165)
            CFrameMon = CFrame.new(-5259.844, 391.397, -2229.035)
        elseif MyLevel >= 190 and MyLevel <= 209 then
            Mon = "Prisoner"
            LevelQuest = 1
            NameQuest = "PrisonerQuest"
            NameMon = "Prisoner"
            CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514)
            CFrameMon = CFrame.new(5098.973, -0.32, 474.237)
        elseif MyLevel >= 210 and MyLevel <= 249 then
            Mon = "Dangerous Prisoner"
            LevelQuest = 2
            NameQuest = "PrisonerQuest"
            NameMon = "Dangerous Prisoner"
            CFrameQuest = CFrame.new(5308.93115, 1.65517521, 475.120514)
            CFrameMon = CFrame.new(5654.563, 15.633, 866.299)
        elseif MyLevel >= 250 and MyLevel <= 274 then
            Mon = "Toga Warrior"
            LevelQuest = 1
            NameQuest = "ColosseumQuest"
            NameMon = "Toga Warrior"
            CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534)
            CFrameMon = CFrame.new(-1820.214, 51.683, -2740.665)
        elseif MyLevel >= 275 and MyLevel <= 299 then
            Mon = "Gladiator"
            LevelQuest = 2
            NameQuest = "ColosseumQuest"
            NameMon = "Gladiator"
            CFrameQuest = CFrame.new(-1580.04663, 6.35000277, -2986.47534)
            CFrameMon = CFrame.new(-1292.838, 56.38, -3339.031)
        elseif MyLevel >= 300 and MyLevel <= 324 then
            Mon = "Military Soldier"
            LevelQuest = 1
            NameQuest = "MagmaQuest"
            NameMon = "Military Soldier"
            CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395)
            CFrameMon = CFrame.new(-5411.164, 11.08, 8454.292)
        elseif MyLevel >= 325 and MyLevel <= 374 then
            Mon = "Military Spy"
            LevelQuest = 2
            NameQuest = "MagmaQuest"
            NameMon = "Military Spy"
            CFrameQuest = CFrame.new(-5313.37012, 10.9500084, 8515.29395)
            CFrameMon = CFrame.new(-5802.868, 86.262, 8828.859)
        elseif MyLevel >= 375 and MyLevel <= 399 then
            Mon = "Fishman Warrior"
            LevelQuest = 1
            NameQuest = "FishmanQuest"
            NameMon = "Fishman Warrior"
            CFrameQuest = CFrame.new(61122.6523, 18.4974, 1569.399)
            CFrameMon = CFrame.new(60878.300, 18.48, 1543.757)
        elseif MyLevel >= 400 and MyLevel <= 449 then
            Mon = "Fishman Commando"
            LevelQuest = 2
            NameQuest = "FishmanQuest"
            NameMon = "Fishman Commando"
            CFrameQuest = CFrame.new(61122.6523, 18.4974, 1569.399)
            CFrameMon = CFrame.new(61922.632, 18.48, 1493.934)
        elseif MyLevel >= 450 and MyLevel <= 474 then
            Mon = "God's Guard"
            LevelQuest = 1
            NameQuest = "SkyExp1Quest"
            NameMon = "God's Guard"
            CFrameQuest = CFrame.new(-4721.88867, 843.874695, -1949.96643)
            CFrameMon = CFrame.new(-4710.042, 845.27, -1927.307)
        elseif MyLevel >= 475 and MyLevel <= 524 then
            Mon = "Shanda"
            LevelQuest = 2
            NameQuest = "SkyExp1Quest"
            NameMon = "Shanda"
            CFrameQuest = CFrame.new(-7859.09814, 5544.19043, -381.476196)
            CFrameMon = CFrame.new(-7678.489, 5566.4, -497.215)
        elseif MyLevel >= 525 and MyLevel <= 549 then
            Mon = "Royal Squad"
            LevelQuest = 1
            NameQuest = "SkyExp2Quest"
            NameMon = "Royal Squad"
            CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194)
            CFrameMon = CFrame.new(-7624.252, 5658.13, -1467.354)
        elseif MyLevel >= 550 and MyLevel <= 624 then
            Mon = "Royal Soldier"
            LevelQuest = 2
            NameQuest = "SkyExp2Quest"
            NameMon = "Royal Soldier"
            CFrameQuest = CFrame.new(-7906.81592, 5634.6626, -1411.99194)
            CFrameMon = CFrame.new(-7836.753, 5645.66, -1790.62)
        elseif MyLevel >= 625 and MyLevel <= 649 then
            Mon = "Galley Pirate"
            LevelQuest = 1
            NameQuest = "FountainQuest"
            NameMon = "Galley Pirate"
            CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293)
            CFrameMon = CFrame.new(5551.021, 78.9, 3930.41)
        elseif MyLevel >= 650 then
            Mon = "Galley Captain"
            LevelQuest = 2
            NameQuest = "FountainQuest"
            NameMon = "Galley Captain"
            CFrameQuest = CFrame.new(5259.81982, 37.3500175, 4050.0293)
            CFrameMon = CFrame.new(5441.951, 42.5, 4950.093)
        end
    elseif World2 then
        if MyLevel >= 700 and MyLevel <= 724 then
            Mon = "Raider"
            LevelQuest = 1
            NameQuest = "Area1Quest"
            NameMon = "Raider"
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188)
            CFrameMon = CFrame.new(-728.3267, 52.779, 2345.77)
        elseif MyLevel >= 725 and MyLevel <= 774 then
            Mon = "Mercenary"
            LevelQuest = 2
            NameQuest = "Area1Quest"
            NameMon = "Mercenary"
            CFrameQuest = CFrame.new(-429.543518, 71.7699966, 1836.18188)
            CFrameMon = CFrame.new(-1004.324, 80.158, 1424.619)
        elseif MyLevel >= 775 and MyLevel <= 799 then
            Mon = "Swan Pirate"
            LevelQuest = 1
            NameQuest = "Area2Quest"
            NameMon = "Swan Pirate"
            CFrameQuest = CFrame.new(638.43811, 71.769989, 918.282898)
            CFrameMon = CFrame.new(1068.664, 137.614, 1322.106)
        elseif MyLevel >= 800 and MyLevel <= 874 then
            Mon = "Factory Staff"
            LevelQuest = 2
            NameQuest = "Area2Quest"
            NameMon = "Factory Staff"
            CFrameQuest = CFrame.new(632.698608, 73.1055908, 918.666321)
            CFrameMon = CFrame.new(73.078, 81.86, -27.47)
        elseif MyLevel >= 875 and MyLevel <= 899 then
            Mon = "Marine Lieutenant"
            LevelQuest = 1
            NameQuest = "MarineQuest3"
            NameMon = "Marine Lieutenant"
            CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812)
            CFrameMon = CFrame.new(-2821.372, 75.89, -3070.08)
        elseif MyLevel >= 900 and MyLevel <= 949 then
            Mon = "Marine Captain"
            LevelQuest = 2
            NameQuest = "MarineQuest3"
            NameMon = "Marine Captain"
            CFrameQuest = CFrame.new(-2440.79639, 71.7140732, -3216.06812)
            CFrameMon = CFrame.new(-1861.23, 80.17, -3254.697)
        elseif MyLevel >= 950 and MyLevel <= 974 then
            Mon = "Zombie"
            LevelQuest = 1
            NameQuest = "ZombieQuest"
            NameMon = "Zombie"
            CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061)
            CFrameMon = CFrame.new(-5657.776, 78.96, -928.687)
        elseif MyLevel >= 975 and MyLevel <= 999 then
            Mon = "Vampire"
            LevelQuest = 2
            NameQuest = "ZombieQuest"
            NameMon = "Vampire"
            CFrameQuest = CFrame.new(-5497.06152, 47.5923004, -795.237061)
            CFrameMon = CFrame.new(-6037.667, 32.18, -1340.659)
        elseif MyLevel >= 1000 and MyLevel <= 1049 then
            Mon = "Snow Trooper"
            LevelQuest = 1
            NameQuest = "SnowMountainQuest"
            NameMon = "Snow Trooper"
            CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928)
            CFrameMon = CFrame.new(549.147, 427.38, -5563.698)
        elseif MyLevel >= 1050 and MyLevel <= 1099 then
            Mon = "Winter Warrior"
            LevelQuest = 2
            NameQuest = "SnowMountainQuest"
            NameMon = "Winter Warrior"
            CFrameQuest = CFrame.new(609.858826, 400.119904, -5372.25928)
            CFrameMon = CFrame.new(1142.745, 475.6, -5199.416)
        elseif MyLevel >= 1100 and MyLevel <= 1124 then
            Mon = "Lab Subordinate"
            LevelQuest = 1
            NameQuest = "IceSideQuest"
            NameMon = "Lab Subordinate"
            CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852)
            CFrameMon = CFrame.new(-5707.47, 15.95, -4513.39)
        elseif MyLevel >= 1125 and MyLevel <= 1174 then
            Mon = "Horned Warrior"
            LevelQuest = 2
            NameQuest = "IceSideQuest"
            NameMon = "Horned Warrior"
            CFrameQuest = CFrame.new(-6064.06885, 15.2422857, -4902.97852)
            CFrameMon = CFrame.new(-6341.36, 15.95, -5723.16)
        elseif MyLevel >= 1175 and MyLevel <= 1199 then
            Mon = "Magma Ninja"
            LevelQuest = 1
            NameQuest = "FireSideQuest"
            NameMon = "Magma Ninja"
            CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457)
            CFrameMon = CFrame.new(-5449.67, 76.6, -5808.2)
        elseif MyLevel >= 1200 and MyLevel <= 1249 then
            Mon = "Lava Pirate"
            LevelQuest = 2
            NameQuest = "FireSideQuest"
            NameMon = "Lava Pirate"
            CFrameQuest = CFrame.new(-5428.03174, 15.0622921, -5299.43457)
            CFrameMon = CFrame.new(-5213.33, 49.7, -4701.45)
        elseif MyLevel >= 1250 and MyLevel <= 1274 then
            Mon = "Ship Deckhand"
            LevelQuest = 1
            NameQuest = "ShipQuest1"
            NameMon = "Ship Deckhand"
            CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)
            CFrameMon = CFrame.new(1212.011, 150.792, 33059.246)
        elseif MyLevel >= 1275 and MyLevel <= 1299 then
            Mon = "Ship Engineer"
            LevelQuest = 2
            NameQuest = "ShipQuest1"
            NameMon = "Ship Engineer"
            CFrameQuest = CFrame.new(1037.80127, 125.092171, 32911.6016)
            CFrameMon = CFrame.new(919.47, 43.5, 32779.96)
        elseif MyLevel >= 1300 and MyLevel <= 1324 then
            Mon = "Ship Steward"
            LevelQuest = 1
            NameQuest = "ShipQuest2"
            NameMon = "Ship Steward"
            CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)
            CFrameMon = CFrame.new(919.43, 129.5, 33436.03)
        elseif MyLevel >= 1325 and MyLevel <= 1349 then
            Mon = "Ship Officer"
            LevelQuest = 2
            NameQuest = "ShipQuest2"
            NameMon = "Ship Officer"
            CFrameQuest = CFrame.new(968.80957, 125.092171, 33244.125)
            CFrameMon = CFrame.new(1036.01, 181.4, 33315.72)
        elseif MyLevel >= 1350 and MyLevel <= 1374 then
            Mon = "Arctic Warrior"
            LevelQuest = 1
            NameQuest = "FrostQuest"
            NameMon = "Arctic Warrior"
            CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984)
            CFrameMon = CFrame.new(5966.24, 62.97, -6179.38)
        elseif MyLevel >= 1375 and MyLevel <= 1424 then
            Mon = "Snow Lurker"
            LevelQuest = 2
            NameQuest = "FrostQuest"
            NameMon = "Snow Lurker"
            CFrameQuest = CFrame.new(5667.6582, 26.7997818, -6486.08984)
            CFrameMon = CFrame.new(5407.07, 69.19, -6880.88)
        elseif MyLevel >= 1425 and MyLevel <= 1449 then
            Mon = "Sea Soldier"
            LevelQuest = 1
            NameQuest = "ForgottenQuest"
            NameMon = "Sea Soldier"
            CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193)
            CFrameMon = CFrame.new(-3028.22, 64.67, -9775.42)
        elseif MyLevel >= 1450 then
            Mon = "Water Fighter"
            LevelQuest = 2
            NameQuest = "ForgottenQuest"
            NameMon = "Water Fighter"
            CFrameQuest = CFrame.new(-3054.44458, 235.544281, -10142.8193)
            CFrameMon = CFrame.new(-3352.9, 285.01, -10534.84)
        end
    elseif World3 then
        if MyLevel >= 1500 and MyLevel <= 1524 then
            Mon = "Pirate Millionaire"
            LevelQuest = 1
            NameQuest = "PiratePortQuest"
            NameMon = "Pirate Millionaire"
            CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984)
            CFrameMon = CFrame.new(-245.99, 47.3, 5584.1)
        elseif MyLevel >= 1525 and MyLevel <= 1574 then
            Mon = "Pistol Billionaire"
            LevelQuest = 2
            NameQuest = "PiratePortQuest"
            NameMon = "Pistol Billionaire"
            CFrameQuest = CFrame.new(-290.074677, 42.9034653, 5581.58984)
            CFrameMon = CFrame.new(-187.33, 86.2, 6013.51)
        elseif MyLevel >= 1575 and MyLevel <= 1599 then
            Mon = "Dragon Crew Warrior"
            LevelQuest = 1
            NameQuest = "AmazonQuest"
            NameMon = "Dragon Crew Warrior"
            CFrameQuest = CFrame.new(5832.83594, 51.6806107, -1101.51563)
            CFrameMon = CFrame.new(6141.14, 51.3, -1340.7)
        elseif MyLevel >= 1600 and MyLevel <= 1624 then
            Mon = "Dragon Crew Archer"
            LevelQuest = 2
            NameQuest = "AmazonQuest"
            NameMon = "Dragon Crew Archer"
            CFrameQuest = CFrame.new(5833.114, 51.6, -1103.069)
            CFrameMon = CFrame.new(6616.417, 441.76, 446.046)
        elseif MyLevel >= 1625 and MyLevel <= 1649 then
            Mon = "Female Islander"
            LevelQuest = 1
            NameQuest = "AmazonQuest2"
            NameMon = "Female Islander"
            CFrameQuest = CFrame.new(5446.879, 601.6, 749.456)
            CFrameMon = CFrame.new(4685.258, 735.8, 815.342)
        elseif MyLevel >= 1650 and MyLevel <= 1699 then
            Mon = "Giant Islander"
            LevelQuest = 2
            NameQuest = "AmazonQuest2"
            NameMon = "Giant Islander"
            CFrameQuest = CFrame.new(5446.879, 601.6, 749.456)
            CFrameMon = CFrame.new(4729.09, 590.43, -36.9)
        elseif MyLevel >= 1700 and MyLevel <= 1724 then
            Mon = "Marine Commodore"
            LevelQuest = 1
            NameQuest = "MarineTreeIsland"
            NameMon = "Marine Commodore"
            CFrameQuest = CFrame.new(2180.54126, 27.8156815, -6741.5498)
            CFrameMon = CFrame.new(2286.00, 73.1, -7159.8)
        elseif MyLevel >= 1725 and MyLevel <= 1774 then
            Mon = "Marine Rear Admiral"
            LevelQuest = 2
            NameQuest = "MarineTreeIsland"
            NameMon = "Marine Rear Admiral"
            CFrameQuest = CFrame.new(2179.98, 28.7, -6740.0)
            CFrameMon = CFrame.new(3656.77, 160.5, -7001.59)
        elseif MyLevel >= 1775 and MyLevel <= 1799 then
            Mon = "Fishman Raider"
            LevelQuest = 1
            NameQuest = "DeepForestIsland3"
            NameMon = "Fishman Raider"
            CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652)
            CFrameMon = CFrame.new(-10407.52, 331.7, -8368.51)
        elseif MyLevel >= 1800 and MyLevel <= 1824 then
            Mon = "Fishman Captain"
            LevelQuest = 2
            NameQuest = "DeepForestIsland3"
            NameMon = "Fishman Captain"
            CFrameQuest = CFrame.new(-10581.6563, 330.872955, -8761.18652)
            CFrameMon = CFrame.new(-10994.7, 352.3, -9002.11)
        elseif MyLevel >= 1825 and MyLevel <= 1849 then
            Mon = "Forest Pirate"
            LevelQuest = 1
            NameQuest = "DeepForestIsland"
            NameMon = "Forest Pirate"
            CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137)
            CFrameMon = CFrame.new(-13274.47, 332.3, -7769.5)
        elseif MyLevel >= 1850 and MyLevel <= 1899 then
            Mon = "Mythological Pirate"
            LevelQuest = 2
            NameQuest = "DeepForestIsland"
            NameMon = "Mythological Pirate"
            CFrameQuest = CFrame.new(-13234.04, 331.488495, -7625.40137)
            CFrameMon = CFrame.new(-13680.6, 501.0, -6991.1)
        elseif MyLevel >= 1900 and MyLevel <= 1924 then
            Mon = "Jungle Pirate"
            LevelQuest = 1
            NameQuest = "DeepForestIsland2"
            NameMon = "Jungle Pirate"
            CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953)
            CFrameMon = CFrame.new(-12256.1, 331.7, -10485.8)
        elseif MyLevel >= 1925 and MyLevel <= 1974 then
            Mon = "Musketeer Pirate"
            LevelQuest = 2
            NameQuest = "DeepForestIsland2"
            NameMon = "Musketeer Pirate"
            CFrameQuest = CFrame.new(-12680.3818, 389.971039, -9902.01953)
            CFrameMon = CFrame.new(-13457.9, 391.5, -9859.1)
        elseif MyLevel >= 1975 and MyLevel <= 1999 then
            Mon = "Reborn Skeleton"
            LevelQuest = 1
            NameQuest = "HauntedQuest1"
            NameMon = "Reborn Skeleton"
            CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277)
            CFrameMon = CFrame.new(-8763.7, 165.7, 6159.8)
        elseif MyLevel >= 2000 and MyLevel <= 2024 then
            Mon = "Living Zombie"
            LevelQuest = 2
            NameQuest = "HauntedQuest1"
            NameMon = "Living Zombie"
            CFrameQuest = CFrame.new(-9479.2168, 141.215088, 5566.09277)
            CFrameMon = CFrame.new(-10144.1, 138.6, 5838.08)
        elseif MyLevel >= 2025 and MyLevel <= 2049 then
            Mon = "Demonic Soul"
            LevelQuest = 1
            NameQuest = "HauntedQuest2"
            NameMon = "Demonic Soul"
            CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533)
            CFrameMon = CFrame.new(-9505.8, 172.1, 6158.9)
        elseif MyLevel >= 2050 and MyLevel <= 2074 then
            Mon = "Posessed Mummy"
            LevelQuest = 2
            NameQuest = "HauntedQuest2"
            NameMon = "Posessed Mummy"
            CFrameQuest = CFrame.new(-9516.99316, 172.017181, 6078.46533)
            CFrameMon = CFrame.new(-9582.02, 6.2, 6205.47)
        elseif MyLevel >= 2075 and MyLevel <= 2099 then
            Mon = "Peanut Scout"
            LevelQuest = 1
            NameQuest = "NutsIslandQuest"
            NameMon = "Peanut Scout"
            CFrameQuest = CFrame.new(-2104.39, 38.1, -10194.2)
            CFrameMon = CFrame.new(-2143.2, 47.7, -10029.9)
        elseif MyLevel >= 2100 and MyLevel <= 2124 then
            Mon = "Peanut President"
            LevelQuest = 2
            NameQuest = "NutsIslandQuest"
            NameMon = "Peanut President"
            CFrameQuest = CFrame.new(-2104.39, 38.1, -10194.2)
            CFrameMon = CFrame.new(-1859.3, 38.1, -10422.4)
        elseif MyLevel >= 2125 and MyLevel <= 2149 then
            Mon = "Ice Cream Chef"
            LevelQuest = 1
            NameQuest = "IceCreamIslandQuest"
            NameMon = "Ice Cream Chef"
            CFrameQuest = CFrame.new(-820.6, 65.8, -10965.7)
            CFrameMon = CFrame.new(-872.2, 65.8, -10919.9)
        elseif MyLevel >= 2150 and MyLevel <= 2199 then
            Mon = "Ice Cream Commander"
            LevelQuest = 2
            NameQuest = "IceCreamIslandQuest"
            NameMon = "Ice Cream Commander"
            CFrameQuest = CFrame.new(-820.6, 65.8, -10965.7)
            CFrameMon = CFrame.new(-558.0, 112.0, -11290.7)
        elseif MyLevel >= 2200 and MyLevel <= 2224 then
            Mon = "Cookie Crafter"
            LevelQuest = 1
            NameQuest = "CakeQuest1"
            NameMon = "Cookie Crafter"
            CFrameQuest = CFrame.new(-2021.3, 37.7, -12028.7)
            CFrameMon = CFrame.new(-2374.1, 37.7, -12125.3)
        elseif MyLevel >= 2225 and MyLevel <= 2249 then
            Mon = "Cake Guard"
            LevelQuest = 2
            NameQuest = "CakeQuest1"
            NameMon = "Cake Guard"
            CFrameQuest = CFrame.new(-2021.3, 37.7, -12028.7)
            CFrameMon = CFrame.new(-1598.3, 43.7, -12244.5)
        elseif MyLevel >= 2250 and MyLevel <= 2274 then
            Mon = "Baking Staff"
            LevelQuest = 1
            NameQuest = "CakeQuest2"
            NameMon = "Baking Staff"
            CFrameQuest = CFrame.new(-1927.9, 37.7, -12842.5)
            CFrameMon = CFrame.new(-1887.8, 77.6, -12998.3)
        elseif MyLevel >= 2275 and MyLevel <= 2299 then
            Mon = "Head Baker"
            LevelQuest = 2
            NameQuest = "CakeQuest2"
            NameMon = "Head Baker"
            CFrameQuest = CFrame.new(-1927.9, 37.7, -12842.5)
            CFrameMon = CFrame.new(-2216.1, 82.8, -12869.2)
        elseif MyLevel >= 2300 and MyLevel <= 2324 then
            Mon = "Cocoa Warrior"
            LevelQuest = 1
            NameQuest = "ChocQuest1"
            NameMon = "Cocoa Warrior"
            CFrameQuest = CFrame.new(233.22, 29.8, -12201.2)
            CFrameMon = CFrame.new(-21.5, 80.5, -12352.3)
        elseif MyLevel >= 2325 and MyLevel <= 2349 then
            Mon = "Chocolate Bar Battler"
            LevelQuest = 2
            NameQuest = "ChocQuest1"
            NameMon = "Chocolate Bar Battler"
            CFrameQuest = CFrame.new(233.22, 29.8, -12201.2)
            CFrameMon = CFrame.new(582.5, 77.1, -12463.1)
        elseif MyLevel >= 2350 and MyLevel <= 2374 then
            Mon = "Sweet Thief"
            LevelQuest = 1
            NameQuest = "ChocQuest2"
            NameMon = "Sweet Thief"
            CFrameQuest = CFrame.new(150.5, 30.6, -12774.5)
            CFrameMon = CFrame.new(165.1, 76.0, -12600.8)
        elseif MyLevel >= 2375 and MyLevel <= 2399 then
            Mon = "Candy Rebel"
            LevelQuest = 2
            NameQuest = "ChocQuest2"
            NameMon = "Candy Rebel"
            CFrameQuest = CFrame.new(150.5, 30.6, -12774.5)
            CFrameMon = CFrame.new(134.8, 77.2, -12876.5)
        elseif MyLevel >= 2400 and MyLevel <= 2424 then
            Mon = "Candy Pirate"
            LevelQuest = 1
            NameQuest = "CandyQuest1"
            NameMon = "Candy Pirate"
            CFrameQuest = CFrame.new(-1150.0, 20.3, -14446.3)
            CFrameMon = CFrame.new(-1310.5, 26.0, -14562.4)
        elseif MyLevel >= 2425 and MyLevel <= 2449 then
            Mon = "Snow Demon"
            LevelQuest = 2
            NameQuest = "CandyQuest1"
            NameMon = "Snow Demon"
            CFrameQuest = CFrame.new(-1150.0, 20.3, -14446.3)
            CFrameMon = CFrame.new(-880.2, 71.2, -14538.6)
        elseif MyLevel >= 2450 and MyLevel <= 2474 then
            Mon = "Isle Outlaw"
            LevelQuest = 1
            NameQuest = "TikiQuest1"
            NameMon = "Isle Outlaw"
            CFrameQuest = CFrame.new(-16547.7, 61.1, -173.4)
            CFrameMon = CFrame.new(-16442.8, 116.1, -264.4)
        elseif MyLevel >= 2475 and MyLevel <= 2524 then
            Mon = "Island Boy"
            LevelQuest = 2
            NameQuest = "TikiQuest1"
            NameMon = "Island Boy"
            CFrameQuest = CFrame.new(-16547.7, 61.1, -173.4)
            CFrameMon = CFrame.new(-16901.2, 84.0, -192.8)
        elseif MyLevel >= 2525 and MyLevel <= 2549 then
            Mon = "Isle Champion"
            LevelQuest = 2
            NameQuest = "TikiQuest2"
            NameMon = "Isle Champion"
            CFrameQuest = CFrame.new(-16539.07, 55.6, 1051.5)
            CFrameMon = CFrame.new(-16641.6, 235.7, 1031.2)
        elseif MyLevel >= 2550 and MyLevel <= 2574 then
            Mon = "Serpent Hunter"
            LevelQuest = 1
            NameQuest = "TikiQuest3"
            NameMon = "Serpent Hunter"
            CFrameQuest = CFrame.new(-16661.89, 105.2, 1576.6)
            CFrameMon = CFrame.new(-16587.8, 154.2, 1533.4)
        elseif MyLevel >= 2575 then
            Mon = "Skull Slayer"
            LevelQuest = 2
            NameQuest = "TikiQuest3"
            NameMon = "Skull Slayer"
            CFrameQuest = CFrame.new(-16661.89, 105.2, 1576.6)
            CFrameMon = CFrame.new(-16885.2, 114.1, 1627.9)
        end
    end
end

-- KHỞI TẠO CẤU TRÚC GIAO DIỆN CHÍNH (FLUENT UI)
local Window = Fluent:CreateWindow({
    Title = "Relz Hub",
    SubTitle = "bởi Tuấn Anh IOS",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tạo các Tab điều khiển
local HomeTab = Window:AddTab({ Title = "Trang Chủ", Icon = "home" })
local FarmTab = Window:AddTab({ Title = "Tự Động Farm", Icon = "sword" })
local ItemsTab = Window:AddTab({ Title = "Vật Phẩm", Icon = "crown" })
local StatsTab = Window:AddTab({ Title = "Chỉ Số", Icon = "user" })
local TeleportTab = Window:AddTab({ Title = "Dịch Chuyển", Icon = "map-pin" })
local ShopTab = Window:AddTab({ Title = "Cửa Hàng", Icon = "shopping-cart" })
local SettingsTab = Window:AddTab({ Title = "Cài Đặt", Icon = "settings" })

-- TAB TRANG CHỦ
HomeTab:AddParagraph({
    Title = "Chào mừng quay trở lại!",
    Content = "Tài khoản: " .. MyName .. "\nCấp độ hiện tại: " .. tostring(MyLevel)
})

local TimeLabel = HomeTab:AddParagraph({
    Title = "Thời Gian Máy Chủ",
    Content = "Đang tải dữ liệu..."
})

task.spawn(function()
    while task.wait(1) do
        local GameTime = math.floor(workspace.DistributedGameTime + 0.5)
        local Hour = math.floor(GameTime / 60 ^ 2) % 24
        local Minute = math.floor(GameTime / 60 ^ 1) % 60
        local Second = math.floor(GameTime / 60 ^ 0) % 60
        TimeLabel:SetDesc("Thời gian chạy máy chủ: " .. Hour .. " giờ " .. Minute .. " phút " .. Second .. " giây")
    end
end)

-- TAB TỰ ĐỘNG FARM
FarmTab:AddSection("Cày Cấp Độ Chính")

local WeaponList = { "Melee", "Sword", "Fruit" }
local WeaponDropdown = FarmTab:AddDropdown("SelectWeaponType", {
    Title = "Chọn Loại Vũ Khí",
    Values = WeaponList,
    CurrentValue = _G.Settings.Main["Select Weapon"],
    Callback = function(value)
        _G.Settings.Main["Select Weapon"] = value
        SaveSettings()
    end
})

local FarmModeList = { "Normal", "Auto Quest", "Nearest" }
local FarmModeDropdown = FarmTab:AddDropdown("SelectFarmMode", {
    Title = "Chế Độ Farm",
    Values = FarmModeList,
    CurrentValue = _G.Settings.Main["Farm Mode"],
    Callback = function(value)
        _G.Settings.Main["Farm Mode"] = value
        SaveSettings()
    end
})

local AutoFarmToggle = FarmTab:AddToggle("AutoFarmLvl", {
    Title = "Bật Tự Động Farm Cấp",
    Default = _G.Settings.Main["Auto Farm"],
    Callback = function(value)
        _G.Settings.Main["Auto Farm"] = value
        StopTween(_G.Settings.Main["Auto Farm"])
        SaveSettings()
    end
})

-- Tải động vũ khí thuộc dòng vũ khí đã chọn
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local selectedType = _G.Settings.Main["Select Weapon"]
            local backpack = game.Players.LocalPlayer:FindFirstChild("Backpack")
            local char = game.Players.LocalPlayer.Character
            
            if selectedType == "Melee" then
                for _, item in pairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and item.ToolTip == "Melee" then
                        _G.Settings.Main["Selected Weapon"] = item.Name
                    end
                end
            elseif selectedType == "Sword" then
                for _, item in pairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and item.ToolTip == "Sword" then
                        _G.Settings.Main["Selected Weapon"] = item.Name
                    end
                end
            elseif selectedType == "Fruit" then
                for _, item in pairs(backpack:GetChildren()) do
                    if item:IsA("Tool") and item.ToolTip == "Blox Fruit" then
                        _G.Settings.Main["Selected Weapon"] = item.Name
                    end
                end
            end
        end)
    end
end)

-- Vòng lặp core xử lý Auto Farm Level
task.spawn(function()
    while task.wait(0.2) do
        if _G.Settings.Main["Auto Farm"] then
            pcall(function()
                CheckQuest()
                local char = game.Players.LocalPlayer.Character
                if not char or not char:FindFirstChild("HumanoidRootPart") or char.Humanoid.Health <= 0 then return end
                
                local questGui = game.Players.LocalPlayer.PlayerGui.Main.Quest
                local QuestTitle = questGui.Container.QuestTitle.Title.Text
                
                -- Từ bỏ nhiệm vụ nếu sai loại quái
                if questGui.Visible == true and not string.find(QuestTitle, NameMon) then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AbandonQuest")
                end
                
                -- Nhận nhiệm vụ
                if questGui.Visible == false then
                    topos(CFrameQuest)
                    if GetDistance(CFrameQuest) <= 15 then
                        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
                    end
                -- Bắt đầu đi farm
                elseif questGui.Visible == true then
                    local targetMob = game.Workspace.Enemies:FindFirstChild(Mon)
                    if targetMob and targetMob:FindFirstChild("HumanoidRootPart") and targetMob.Humanoid.Health > 0 then
                        -- Gom quái (Bring Mobs)
                        if _G.Settings.Setting["Bring Mob"] then
                            for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                                if enemy.Name == Mon and enemy:FindFirstChild("HumanoidRootPart") and (enemy.HumanoidRootPart.Position - char.HumanoidRootPart.Position).Magnitude <= 300 then
                                    enemy.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame
                                    enemy.HumanoidRootPart.CanCollide = false
                                    enemy.Humanoid.WalkSpeed = 0
                                    if enemy.Humanoid:FindFirstChild("Animator") then
                                        enemy.Humanoid.Animator:Destroy()
                                    end
                                end
                            end
                        end
                        
                        -- Tấn công
                        repeat
                            task.wait()
                            EquipWeapon(_G.Settings.Main["Selected Weapon"])
                            AutoHaki()
                            PosMon = targetMob.HumanoidRootPart.CFrame
                            topos(targetMob.HumanoidRootPart.CFrame * Pos)
                            Click()
                        until not _G.Settings.Main["Auto Farm"] or targetMob.Humanoid.Health <= 0 or not targetMob.Parent or questGui.Visible == false
                    else
                        -- Đợi quái hồi sinh, di chuyển đến điểm spawn
                        topos(CFrameMon)
                        UnEquipWeapon(_G.Settings.Main["Selected Weapon"])
                    end
                end
            end)
        end
    end
end)

-- TAB VẬT PHẨM & NHIỆM VỤ PHỤ
ItemsTab:AddSection("Nhiệm Vụ Khác")

local AutoBonesToggle = ItemsTab:AddToggle("AutoBoneLvl", {
    Title = "Auto Farm Xương (Bone - Sea 3)",
    Default = _G.Settings.Farm["Auto Farm Bone"],
    Callback = function(value)
        _G.Settings.Farm["Auto Farm Bone"] = value
        StopTween(_G.Settings.Farm["Auto Farm Bone"])
        SaveSettings()
    end
})

local AutoSurpriseToggle = ItemsTab:AddToggle("AutoSurpriseRandom", {
    Title = "Tự Động Random Surprise (Bone)",
    Default = _G.Settings.Farm["Auto Random Surprise"],
    Callback = function(value)
        _G.Settings.Farm["Auto Random Surprise"] = value
        SaveSettings()
    end
})

-- Xử lý vòng lặp Farm Xương (Bone Farm)
task.spawn(function()
    while task.wait(0.2) do
        if _G.Settings.Farm["Auto Farm Bone"] and World3 then
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if not char or char.Humanoid.Health <= 0 then return end
                
                local boneArea = CFrame.new(-9506.2, 172.1, 6117.0)
                local hasMob = false
                for _, enemy in pairs(game.Workspace.Enemies:GetChildren()) do
                    if enemy.Name == "Reborn Skeleton" or enemy.Name == "Living Zombie" or enemy.Name == "Demonic Soul" or enemy.Name == "Posessed Mummy" then
                        if enemy:FindFirstChild("HumanoidRootPart") and enemy.Humanoid.Health > 0 then
                            hasMob = true
                            repeat
                                task.wait()
                                AutoHaki()
                                EquipWeapon(_G.Settings.Main["Selected Weapon"])
                                PosMon = enemy.HumanoidRootPart.CFrame
                                topos(enemy.HumanoidRootPart.CFrame * Pos)
                                Click()
                            until not _G.Settings.Farm["Auto Farm Bone"] or not enemy.Parent or enemy.Humanoid.Health <= 0
                        end
                    end
                end
                if not hasMob then
                    topos(boneArea)
                end
            end)
        end
    end
end)

-- Vòng lặp tự động mua quà bằng Xương
task.spawn(function()
    while task.wait(2) do
        if _G.Settings.Farm["Auto Random Surprise"] and World3 then
            pcall(function()
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Bones", "Buy", 1, 1)
            end)
        end
    end
end)

-- TAB CHỈ SỐ (STATS)
StatsTab:AddSection("Tự Động Nâng Điểm")

local MeleeToggle = StatsTab:AddToggle("StatMelee", {
    Title = "Nâng Cận Chiến (Melee)",
    Default = _G.Settings.Stats["Auto Add Melee Stats"],
    Callback = function(value)
        _G.Settings.Stats["Auto Add Melee Stats"] = value
        SaveSettings()
    end
})

local DefenseToggle = StatsTab:AddToggle("StatDefense", {
    Title = "Nâng Phòng Thủ (Defense)",
    Default = _G.Settings.Stats["Auto Add Defense Stats"],
    Callback = function(value)
        _G.Settings.Stats["Auto Add Defense Stats"] = value
        SaveSettings()
    end
})

local SwordToggle = StatsTab:AddToggle("StatSword", {
    Title = "Nâng Kiếm (Sword)",
    Default = _G.Settings.Stats["Auto Add Sword Stats"],
    Callback = function(value)
        _G.Settings.Stats["Auto Add Sword Stats"] = value
        SaveSettings()
    end
})

local PointSlider = StatsTab:AddSlider("StatPointsSlider", {
    Title = "Số Điểm Nâng Mỗi Lần",
    Min = 1,
    Max = 100,
    Default = _G.Settings.Stats["Point Stats"],
    Callback = function(value)
        _G.Settings.Stats["Point Stats"] = value
        SaveSettings()
    end
})

-- Xử lý vòng lặp tự động nâng chỉ số
task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local points = game.Players.LocalPlayer.Data.Points.Value
            local amount = _G.Settings.Stats["Point Stats"]
            if points >= amount then
                if _G.Settings.Stats["Auto Add Melee Stats"] then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", amount)
                end
                if _G.Settings.Stats["Auto Add Defense Stats"] then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Defense", amount)
                end
                if _G.Settings.Stats["Auto Add Sword Stats"] then
                    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Sword", amount)
                end
            end
        end)
    end
end)

-- TAB DỊCH CHUYỂN (TELEPORT)
TeleportTab:AddSection("Dịch Chuyển Thế Giới")

TeleportTab:AddButton({
    Title = "Dịch Chuyển Đến Thế Giới 1",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
    end
})

TeleportTab:AddButton({
    Title = "Dịch Chuyển Đến Thế Giới 2",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
    end
})

TeleportTab:AddButton({
    Title = "Dịch Chuyển Đến Thế Giới 3",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
    end
})

-- TAB SHOP
ShopTab:AddSection("Mua Phong Cách Chiến Đấu (Fighting Style)")

ShopTab:AddButton({
    Title = "Mua Superhuman ($3,000,000)",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySuperhuman")
    end
})

ShopTab:AddButton({
    Title = "Mua Death Step ($5,000,000)",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyDeathStep")
    end
})

ShopTab:AddButton({
    Title = "Mua Sharkman Karate ($2,500,000)",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuySharkmanKarate")
    end
})

ShopTab:AddButton({
    Title = "Mua God Human ($5,000,000)",
    Callback = function()
        game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("BuyGodhuman")
    end
})

-- TAB CÀI ĐẶT
SettingsTab:AddSection("Cấu Hình Hệ Thống")

SettingsTab:AddToggle("SettingBringMob", {
    Title = "Gom Quái (Bring Mob)",
    Default = _G.Settings.Setting["Bring Mob"],
    Callback = function(value)
        _G.Settings.Setting["Bring Mob"] = value
        SaveSettings()
    end
})

SettingsTab:AddToggle("SettingFastAttack", {
    Title = "Tấn Công Nhanh (Fast Attack)",
    Default = _G.Settings.Setting["Fast Attack"],
    Callback = function(value)
        _G.Settings.Setting["Fast Attack"] = value
        SaveSettings()
    end
})

SettingsTab:AddSlider("TweenSpeedSlider", {
    Title = "Tốc Độ Bay (Tween Speed)",
    Min = 100,
    Max = 350,
    Default = _G.Settings.Setting["Player Tween Speed"],
    Callback = function(value)
        _G.Settings.Setting["Player Tween Speed"] = value
        SaveSettings()
    end
})

SettingsTab:AddToggle("SettingBypassAntiCheat", {
    Title = "Vượt Hệ Thống Quét (Anti-Cheat Bypass)",
    Default = _G.Settings.Setting["Bypass Anti Cheat"],
    Callback = function(value)
        _G.Settings.Setting["Bypass Anti Cheat"] = value
        SaveSettings()
    end
})

-- Vòng lặp dọn dẹp bộ nhớ và tự động Bypass Anti-Cheat cục bộ
task.spawn(function()
    while task.wait(1) do
        pcall(function()
            if _G.Settings.Setting["Bypass Anti Cheat"] then
                local char = game.Players.LocalPlayer.Character
                if char then
                    for _, script in pairs(char:GetDescendants()) do
                        if script:IsA("LocalScript") and (script.Name == "General" or script.Name == "FallDamage" or script.Name == "JumpCD") then
                            script:Destroy()
                        end
                    end
                end
            end
        end)
    end
end)

-- Tạo trình quản lý lưu Fluent
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("RelzHubConfig")
SaveManager:SetFolder("RelzHubConfig/BloxFruits")
SaveManager:BuildConfigSection(SettingsTab)
InterfaceManager:BuildInterfaceSection(SettingsTab)

-- Tải giao diện mặc định
Window:SelectTab(1)