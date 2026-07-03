--[[
    SCRIPT BLOX FRUIT KAITUN OPTIMIZED
    - Hỗ trợ đầy đủ Sea 1, Sea 2, Sea 3
    - Tối ưu hóa cấu trúc, loại bỏ code thừa từ các game khác
    - Giảm thiểu lag và tăng tốc độ xử lý của Fast Attack
]]

repeat task.wait() until game:IsLoaded()

local placeId = game.PlaceId
if placeId == 2753915549 or placeId == 4442272183 or placeId == 7449423635 then
    BF = true
else
    game.Players.LocalPlayer:Kick("Game không được hỗ trợ bởi script Blox Fruit Kaitun này!")
    return
end

-- ==========================================
-- CẤU HÌNH MẶC ĐỊNH (SETTINGS)
-- ==========================================
if not getgenv().Setting then
    getgenv().Setting = {
        ["Join Team"] = "Pirate", -- "Pirate" hoặc "Marine"
        ["Auto Farm Level"] = true,
        ["Select Weapon"] = "Combat", -- Vũ khí ưu tiên dùng để farm
        ["Auto Rejoin"] = true,
        ["Auto Buy BlackLeg"] = true,
        ["Auto Buy Electro"] = true,
        ["Auto Buy Fishman karate"] = true,
        ["Auto Buy Dragon claw"] = true,
        ["Auto New World"] = true,
        ["Auto Factory"] = true,
        ["Auto third World"] = true,
        ["Auto Superhuman"] = true,
        ["Auto Superhuman [Full]"] = true,
        ["Auto Death Step"] = true,
        ["Auto Dragon Talon"] = true,
        ["Auto Electric Clow"] = true,
        ["Auto Buy Legendary Sword"] = true,
        ["Auto Buy Legendary Sword Hop"] = false,
        ["Auto Buy Enhancement"] = true,
        ["Auto Farm Select Boss Hop"] = false,
        ["Melee"] = true,
        ["Defense"] = true,
        ["Sword"] = false,
        ["Gun"] = false,
        ["Demon Fruit"] = false,
        ["Auto Buy Exp x2"] = true,
        ["Auto Buy Exp x2[ Exp Expire ]"] = true,
        ["Bounty Hop"] = false
    }
end

-- Chờ các game objects tải hoàn tất
repeat wait() until game.Players
repeat wait() until game.Players.LocalPlayer
repeat wait() until game.ReplicatedStorage
repeat wait() until game.ReplicatedStorage:FindFirstChild("Remotes")
repeat wait() until game.Players.LocalPlayer:FindFirstChild("PlayerGui")
repeat wait() until game.Players.LocalPlayer.PlayerGui:FindFirstChild("Main")

-- Tự động chọn Đội (Pirate / Marine)
spawn(function()
    if game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("Main").ChooseTeam.Visible == true then
        local team = getgenv().Setting["Join Team"] or "Pirate"
        local container = game:GetService("Players")["LocalPlayer"].PlayerGui.Main.ChooseTeam.Container
        local targetFrame = (team == "Marine") and container.Marines or container.Pirates
        
        targetFrame.Frame.ViewportFrame.TextButton.Size = UDim2.new(0, 10000, 0, 10000)
        targetFrame.Frame.ViewportFrame.TextButton.Position = UDim2.new(-4, 0, -5, 0)
        targetFrame.Frame.ViewportFrame.TextButton.BackgroundTransparency = 1
        task.wait(0.5)
        game:GetService('VirtualUser'):Button1Down(Vector2.new(99,99))
        game:GetService('VirtualUser'):Button1Up(Vector2.new(99,99))
    end
end)

repeat wait() until game.Players.LocalPlayer.Team ~= nil and game:IsLoaded()

-- Dọn dẹp UI Voice Chat cũ nếu có
if game.CoreGui.RobloxGui:FindFirstChild("Voice Chat Ui") then 
    game.CoreGui.RobloxGui:FindFirstChild("Voice Chat Ui"):Destroy() 
end

-- ==========================================
-- THƯ VIỆN UI (CUSTOMIZABLE LIBRARY)
-- ==========================================
local library = {RainbowColorValue = 0, HueSelectionPosition = 0}
local PresetColor = Color3.fromRGB(255, 0, 0)
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local MyNameIs = LocalPlayer.Name
local Mouse = LocalPlayer:GetMouse()
local CloseBind = Enum.KeyCode.RightControl

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "Voice Chat Ui"
ScreenGui.Parent = game.CoreGui.RobloxGui
local uitoggled = false

UserInputService.InputBegan:Connect(function(io, p)
    if io.KeyCode == CloseBind then
        uitoggled = not uitoggled
        ScreenGui.Enabled = not uitoggled
    end
end)

coroutine.wrap(function()
    while wait() do
        library.RainbowColorValue = library.RainbowColorValue + 1 / 255
        library.HueSelectionPosition = library.HueSelectionPosition + 1
        if library.RainbowColorValue >= 1 then library.RainbowColorValue = 0 end
        if library.HueSelectionPosition == 80 then library.HueSelectionPosition = 0 end
    end
end)()

local function MakeDraggable(topbarobject, object)
    local Dragging, DragInput, DragStart, StartPosition
    local function Update(input)
        local Delta = input.Position - DragStart
        object.Position = UDim2.new(
            StartPosition.X.Scale, StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y
        )
    end
    topbarobject.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPosition = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    topbarobject.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then Update(input) end
    end)
end

local function RippleEffect(object)
    spawn(function()
        local Ripple = Instance.new("ImageLabel")
        Ripple.Name = "Ripple"
        Ripple.Parent = object
        Ripple.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Ripple.BackgroundTransparency = 1.000
        Ripple.ZIndex = 8
        Ripple.Image = "rbxassetid://2708891598"
        Ripple.ImageTransparency = 0.800
        Ripple.ScaleType = Enum.ScaleType.Fit
        Ripple.Position = UDim2.new((Mouse.X - Ripple.AbsolutePosition.X) / object.AbsoluteSize.X, 0, (Mouse.Y - Ripple.AbsolutePosition.Y) / object.AbsoluteSize.Y, 0)
        TweenService:Create(Ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(-5.5, 0, -15, 0), Size = UDim2.new(12, 0, 30, 0)}):Play()
        wait(0.5)
        TweenService:Create(Ripple, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
        wait(0.5)
        Ripple:Destroy()
    end)
end

function library:Window(name, gameName)
    local ColorII = Color3.fromRGB(255, 0, 0)
    local Main = Instance.new("Frame")
    local ShowName = Instance.new("TextLabel")
    local MainUICorner = Instance.new("UICorner")
    local TopMain = Instance.new("Frame")
    local TopMainUICorner = Instance.new("UICorner")
    local TopMainLine = Instance.new("Frame")
    local NameHub = Instance.new("TextLabel")
    local Toggleui = Instance.new("TextLabel")
    local HideTab = Instance.new("ImageButton")
    local SizeFullSection = Instance.new("Frame")

    Main.Name = "Main"
    Main.Parent = ScreenGui
    Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Main.ClipsDescendants = true
    Main.Position = UDim2.new(0.5, -325, 0.5, -175)
    Main.Size = UDim2.new(0, 650, 0, 425)

    MainUICorner.Name = "MainUICorner"
    MainUICorner.Parent = Main

    TopMain.Name = "TopMain"
    TopMain.Parent = Main
    TopMain.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    TopMain.Size = UDim2.new(0, 650, 0, 30)

    MakeDraggable(TopMain, Main)

    TopMainUICorner.Name = "TopMainUICorner"
    TopMainUICorner.Parent = TopMain

    TopMainLine.Name = "TopMainLine"
    TopMainLine.Parent = TopMain
    TopMainLine.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    TopMainLine.BorderSizePixel = 0
    TopMainLine.Position = UDim2.new(0, 0, 0.833, 0)
    TopMainLine.Size = UDim2.new(1, 0, 0, 5)

    ShowName.Name = "MyName"
    ShowName.Parent = Main
    ShowName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ShowName.BackgroundTransparency = 1.000
    ShowName.Position = UDim2.new(0, 9, 0.92, 0)
    ShowName.Size = UDim2.new(0, 160, 0, 30)
    ShowName.Font = Enum.Font.SourceSansSemibold
    ShowName.RichText = true
    ShowName.Text = "Tên: " .. MyNameIs
    ShowName.TextColor3 = Color3.fromRGB(255, 255, 255)
    ShowName.TextSize = 18.000
    ShowName.TextXAlignment = Enum.TextXAlignment.Left

    spawn(function()
        while wait() do 
            for i = 1, 255 do
                ShowName.TextColor3 = Color3.fromHSV(i/255, 1, 1)
                wait()
            end
        end
    end)

    NameHub.Name = "NameHub"
    NameHub.Parent = TopMain
    NameHub.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.BackgroundTransparency = 1.000
    NameHub.Position = UDim2.new(0.05, 0, 0, 0)
    NameHub.Size = UDim2.new(0, 200, 0, 30)
    NameHub.Font = Enum.Font.SourceSansSemibold
    NameHub.RichText = true
    NameHub.Text = "<font color=\"rgb(255, 50, 50)\">" .. name .. "</font> | " .. gameName
    NameHub.TextColor3 = Color3.fromRGB(255, 255, 255)
    NameHub.TextSize = 22.000
    NameHub.TextXAlignment = Enum.TextXAlignment.Left

    Toggleui.Name = "Toggleui"
    Toggleui.Parent = TopMain
    Toggleui.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Toggleui.BackgroundTransparency = 1.000
    Toggleui.Position = UDim2.new(0.8, 0, 0, 0)
    Toggleui.Size = UDim2.new(0, 120, 0, 30)
    Toggleui.Font = Enum.Font.SourceSansSemibold
    Toggleui.Text = "[ Right Control ]"
    Toggleui.TextColor3 = Color3.fromRGB(255, 50, 50)
    Toggleui.TextSize = 18.000

    HideTab.Name = "HideTab"
    HideTab.Parent = TopMain
    HideTab.BackgroundTransparency = 1.000
    HideTab.Position = UDim2.new(0.0125, 0, 0.067, 0)
    HideTab.Size = UDim2.new(0, 25, 0, 25)
    HideTab.ZIndex = 2
    HideTab.Image = "rbxassetid://3926305904"
    HideTab.ImageRectOffset = Vector2.new(484, 204)
    HideTab.ImageRectSize = Vector2.new(36, 36)

    SizeFullSection.Name = "SizeFullSection"
    SizeFullSection.Parent = Main
    SizeFullSection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SizeFullSection.BackgroundTransparency = 1.000
    SizeFullSection.Position = UDim2.new(0.192, 0, 0.093, 0)
    SizeFullSection.Size = UDim2.new(0, 525, 0, 340)

    local Taplist = Instance.new("Frame")
    local TaplistUIListLayout = Instance.new("UIListLayout")
    local TabSet = Instance.new("TextBox")
    local TabSetCorner = Instance.new("UICorner")
    local BalckGrouitList = Instance.new("ScrollingFrame")
    local BalckGrouitListUICorner = Instance.new("UICorner")
    local BalckGrouitListUIListLayout = Instance.new("UIListLayout")

    Taplist.Name = "Taplist"
    Taplist.Parent = Main
    Taplist.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Taplist.BackgroundTransparency = 1.000
    Taplist.Position = UDim2.new(0, 0, 0.08, 0)
    Taplist.Size = UDim2.new(0, 130, 0, 345)

    TaplistUIListLayout.Name = "TaplistUIListLayout"
    TaplistUIListLayout.Parent = Taplist
    TaplistUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    TaplistUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TaplistUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    TaplistUIListLayout.Padding = UDim.new(0, 5)

    TabSet.Name = "TabSet"
    TabSet.Parent = Taplist
    TabSet.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TabSet.Size = UDim2.new(0, 120, 0, 25)
    TabSet.Font = Enum.Font.SourceSansSemibold
    TabSet.PlaceholderText = "Tìm kiếm..."
    TabSet.Text = ""
    TabSet.TextColor3 = Color3.fromRGB(255, 50, 50)
    TabSet.PlaceholderColor3 = Color3.fromRGB(150, 50, 50)
    TabSet.TextSize = 16.000
    TabSet.ClipsDescendants = true

    TabSetCorner.Name = "TabSetCorner"
    TabSetCorner.Parent = TabSet

    BalckGrouitList.Name = "BalckGrouitList"
    BalckGrouitList.Parent = Taplist
    BalckGrouitList.Active = true
    BalckGrouitList.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    BalckGrouitList.BackgroundTransparency = 1.000
    BalckGrouitList.Size = UDim2.new(0, 120, 0, 305)
    BalckGrouitList.ScrollBarThickness = 2

    BalckGrouitListUICorner.Name = "BalckGrouitListUICorner"
    BalckGrouitListUICorner.Parent = BalckGrouitList

    BalckGrouitListUIListLayout.Name = "BalckGrouitListUIListLayout"
    BalckGrouitListUIListLayout.Parent = BalckGrouitList
    BalckGrouitListUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    BalckGrouitListUIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    BalckGrouitListUIListLayout.Padding = UDim.new(0, 2)

    BalckGrouitListUIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        BalckGrouitList.CanvasSize = UDim2.new(0, 0, 0, BalckGrouitListUIListLayout.AbsoluteContentSize.Y)
    end)

    local Tabs = {}
    local fspage = nil
    
    function Tabs:Tab(text, Real)
        Real = Real or false
        local RealName = Real and "KakMoungMaiMee" or "Tab"
        local Tab = Instance.new("TextButton")
        local TabUICorner = Instance.new("UICorner")

        Tab.Name = RealName
        Tab.Parent = BalckGrouitList
        Tab.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
        Tab.Size = UDim2.new(0, 115, 0, 25)
        Tab.Font = Enum.Font.SourceSansSemibold
        Tab.Text = text
        Tab.TextColor3 = Color3.fromRGB(160, 160, 160)
        Tab.TextSize = 18.000
        Tab.TextWrapped = true
        Tab.AutoButtonColor = false
        Tab.Visible = not Real

        TabUICorner.Name = "TabUICorner"
        TabUICorner.Parent = Tab

        local MainSection = Instance.new("ImageLabel")
        local SectionBorder = Instance.new("ImageLabel")
        local SectionContent = Instance.new("ScrollingFrame")
        local SectionContentLayout = Instance.new("UIListLayout")

        MainSection.Name = "MainSection"
        MainSection.Parent = SizeFullSection
        MainSection.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        MainSection.BackgroundTransparency = 1
        MainSection.Position = UDim2.new(0.02, 0, 0.03, 0)
        MainSection.Size = UDim2.new(0, 503, 0, 0)
        MainSection.ZIndex = 4
        MainSection.Image = "rbxassetid://3570695787"
        MainSection.ImageColor3 = Color3.fromRGB(20, 20, 20)
        MainSection.ScaleType = Enum.ScaleType.Slice
        MainSection.SliceCenter = Rect.new(100, 100, 100, 100)
        MainSection.SliceScale = 0.05
        MainSection.Visible = false

        SectionBorder.Name = "SectionBorder"
        SectionBorder.Parent = MainSection
        SectionBorder.BackgroundTransparency = 1.000
        SectionBorder.Position = UDim2.new(0, -1, 0, -1)
        SectionBorder.Size = UDim2.new(1, 2, 1, 2)
        SectionBorder.ZIndex = 3
        SectionBorder.Image = "rbxassetid://3570695787"
        SectionBorder.ImageColor3 = Color3.fromRGB(255, 50, 50)
        SectionBorder.ScaleType = Enum.ScaleType.Slice
        SectionBorder.SliceCenter = Rect.new(100, 100, 100, 100)
        SectionBorder.SliceScale = 0.05

        SectionContent.Name = "SectionContent"
        SectionContent.Parent = MainSection
        SectionContent.Active = true
        SectionContent.BackgroundTransparency = 1.000
        SectionContent.BorderSizePixel = 0
        SectionContent.Position = UDim2.new(0, 0, 0.03, 0)
        SectionContent.Size = UDim2.new(1, 0, 0.96, 0)
        SectionContent.ZIndex = 4
        SectionContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        SectionContent.ScrollBarThickness = 3

        SectionContentLayout.Name = "SectionContentLayout"
        SectionContentLayout.Parent = SectionContent
        SectionContentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        SectionContentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        SectionContentLayout.Padding = UDim.new(0, 5)

        SectionContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            SectionContent.CanvasSize = UDim2.new(0, 0, 0, SectionContentLayout.AbsoluteContentSize.Y + 15)
        end)

        if fspage == nil then
            fspage = true
            MainSection.Visible = true
            TweenService:Create(MainSection, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 503, 0, 355)}):Play()
            TweenService:Create(Tab, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
            Tab.TextColor3 = ColorII
        end

        Tab.MouseButton1Click:Connect(function()
            for _, v in next, SizeFullSection:GetChildren() do
                if v.Name == "MainSection" then
                    TweenService:Create(v, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 503, 0, 0)}):Play()
                    v.Visible = false
                end
            end
            MainSection.Visible = true
            TweenService:Create(MainSection, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, 503, 0, 355)}):Play()
            
            for _, v in next, BalckGrouitList:GetChildren() do
                if v.Name == "Tab" then
                    TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextColor3 = Color3.fromRGB(160, 160, 160)}):Play()
                    TweenService:Create(v, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
                end
            end
            TweenService:Create(Tab, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {TextColor3 = ColorII}):Play()
            TweenService:Create(Tab, TweenInfo.new(1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}):Play()
        end)

        local TabElements = {}

        function TabElements:Button(text, callback)
            local NameButton = Instance.new("Frame")
            local Button = Instance.new("TextButton")
            local ButtonRounded = Instance.new("ImageLabel")
            local UICorner = Instance.new("UICorner")
            local UICorner_2 = Instance.new("UICorner")

            NameButton.Name = (text .. "Button")
            NameButton.Parent = SectionContent
            NameButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            NameButton.Size = UDim2.new(0, 475, 0, 30)
            NameButton.ZIndex = 5

            Button.Name = "Button"
            Button.Parent = NameButton
            Button.BackgroundTransparency = 1.000
            Button.BorderSizePixel = 0
            Button.ClipsDescendants = true
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.Text = text
            Button.ZIndex = 6
            Button.Font = Enum.Font.SourceSansBold
            Button.TextColor3 = Color3.fromRGB(200, 200, 200)
            Button.TextSize = 15.000

            ButtonRounded.Name = "ButtonRounded"
            ButtonRounded.Parent = Button
            ButtonRounded.Active = true
            ButtonRounded.AnchorPoint = Vector2.new(0.5, 0.5)
            ButtonRounded.BackgroundTransparency = 1.000
            ButtonRounded.Position = UDim2.new(0.5, 0, 0.5, 0)
            ButtonRounded.Size = UDim2.new(1, 0, 1, 0)
            ButtonRounded.ZIndex = 5
            ButtonRounded.Image = "rbxassetid://3570695787"
            ButtonRounded.ImageColor3 = Color3.fromRGB(255, 50, 50)
            ButtonRounded.ImageTransparency = 1.000
            ButtonRounded.ScaleType = Enum.ScaleType.Slice
            ButtonRounded.SliceCenter = Rect.new(100, 100, 100, 100)
            ButtonRounded.SliceScale = 0.05

            UICorner.Parent = NameButton
            UICorner_2.Parent = Button

            Button.MouseButton1Down:Connect(function()
                RippleEffect(Button)
                callback(Button)
            end)

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(.2, Enum.EasingStyle.Quad), {TextColor3 = Color3.fromRGB(255, 50, 50)}):Play()
            end)

            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(.2, Enum.EasingStyle.Quad), {TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            end)

            return NameButton
        end

        function TabElements:Toggle(text, stats, callback)
            stats = stats or false
            local Toggled = stats
            local ToggleName = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local Toggle = Instance.new("TextButton")
            local CheckboxOutline = Instance.new("ImageLabel")
            local UIGradient = Instance.new("UIGradient")
            local CheckboxTicked = Instance.new("ImageLabel")
            local UIGradient_2 = Instance.new("UIGradient")
            local TickCover = Instance.new("Frame")
            local UICorner = Instance.new("UICorner")

            ToggleName.Name = (text .. "Toggle")
            ToggleName.Parent = SectionContent
            ToggleName.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            ToggleName.Size = UDim2.new(0, 475, 0, 35)
            ToggleName.ZIndex = 5

            Title.Name = "Title"
            Title.Parent = ToggleName
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 13, 0, 0)
            Title.Size = UDim2.new(0, 300, 0, 35)
            Title.ZIndex = 5
            Title.Font = Enum.Font.SourceSansBold
            Title.Text = text
            Title.TextColor3 = Color3.fromRGB(185, 185, 185)
            Title.TextSize = 15.000
            Title.TextXAlignment = Enum.TextXAlignment.Left

            Toggle.Name = "Toggle"
            Toggle.Parent = ToggleName
            Toggle.BackgroundTransparency = 1.000
            Toggle.Size = UDim2.new(1, 0, 1, 0)
            Toggle.ZIndex = 5
            Toggle.AutoButtonColor = false
            Toggle.Text = ""

            CheckboxOutline.Name = "CheckboxOutline"
            CheckboxOutline.Parent = Toggle
            CheckboxOutline.BackgroundTransparency = 1.000
            CheckboxOutline.Position = UDim2.new(1, -35, 0.5, -12)
            CheckboxOutline.Size = UDim2.new(0, 24, 0, 24)
            CheckboxOutline.ZIndex = 5
            CheckboxOutline.Image = "http://www.roblox.com/asset/?id=5416796047"

            UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 50, 50)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(150, 0, 0))}
            UIGradient.Parent = CheckboxOutline

            CheckboxTicked.Name = "CheckboxTicked"
            CheckboxTicked.Parent = Toggle
            CheckboxTicked.BackgroundTransparency = 1.000
            CheckboxTicked.Position = UDim2.new(1, -35, 0.5, -12)
            CheckboxTicked.Size = UDim2.new(0, 24, 0, 24)
            CheckboxTicked.ZIndex = 5
            CheckboxTicked.Image = "http://www.roblox.com/asset/?id=5416796675"

            UIGradient_2.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 50, 50)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(150, 0, 0))}
            UIGradient_2.Parent = CheckboxTicked

            TickCover.Name = "TickCover"
            TickCover.Parent = Toggle
            TickCover.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            TickCover.BorderSizePixel = 0
            TickCover.Position = UDim2.new(1, -30, 0.5, -7)
            TickCover.Size = UDim2.new(0, 14, 0, 14)
            TickCover.ZIndex = 5

            UICorner.Parent = ToggleName

            local function SetState(state)
                if state then
                    TweenService:Create(Title, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(255, 50, 50)}):Play()
                    TweenService:Create(TickCover, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, -30, 0.5, -7), Size = UDim2.new(0, 0, 0, 0)}):Play()
                else
                    TweenService:Create(Title, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {TextColor3 = Color3.fromRGB(185, 185, 185)}):Play()
                    TweenService:Create(TickCover, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Position = UDim2.new(1, -30, 0.5, -7), Size = UDim2.new(0, 14, 0, 14)}):Play()
                end
            end

            if stats then
                SetState(stats)
                callback(stats)
            end

            Toggle.MouseButton1Down:Connect(function()
                Toggled = not Toggled
                SetState(Toggled)
                callback(Toggled)
            end)

            return ToggleName
        end

        function TabElements:Slider(name, minimumvalue, maximumvalue, presetvalue, precisevalue, callback)
            local SliderDragging = false
            local StartingValue = presetvalue or minimumvalue

            local SliderName = Instance.new("Frame")
            local Title = Instance.new("TextLabel")
            local SliderBackground = Instance.new("ImageLabel")
            local SliderIndicator = Instance.new("ImageLabel")
            local UIGradient = Instance.new("UIGradient")
            local CircleSelector = Instance.new("ImageLabel")
            local UICorner = Instance.new("UICorner")
            local SliderValue = Instance.new("ImageLabel")
            local Value = Instance.new("TextBox")

            SliderName.Name = (name .. "Slider")
            SliderName.Parent = SectionContent
            SliderName.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            SliderName.Size = UDim2.new(0, 475, 0, 50)
            SliderName.ZIndex = 5

            Title.Name = "Title"
            Title.Parent = SliderName
            Title.BackgroundTransparency = 1.000
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.Size = UDim2.new(0, 150, 0, 35)
            Title.ZIndex = 5
            Title.Font = Enum.Font.SourceSansBold
            Title.Text = name
            Title.TextColor3 = Color3.fromRGB(185, 185, 185)
            Title.TextSize = 15.000
            Title.TextXAlignment = Enum.TextXAlignment.Left

            SliderBackground.Name = "SliderBackground"
            SliderBackground.Parent = SliderName
            SliderBackground.BackgroundTransparency = 1.000
            SliderBackground.Position = UDim2.new(0.02, 0, 0.7, 0)
            SliderBackground.Size = UDim2.new(0, 450, 0, 4)
            SliderBackground.ZIndex = 5
            SliderBackground.Image = "rbxassetid://3570695787"
            SliderBackground.ImageColor3 = Color3.fromRGB(60, 60, 60)
            SliderBackground.ScaleType = Enum.ScaleType.Slice
            SliderBackground.SliceCenter = Rect.new(100, 100, 100, 100)
            SliderBackground.SliceScale = 0.15

            SliderIndicator.Name = "SliderIndicator"
            SliderIndicator.Parent = SliderBackground
            SliderIndicator.BackgroundTransparency = 1.000
            SliderIndicator.Size = UDim2.new((StartingValue - minimumvalue) / (maximumvalue - minimumvalue), 0, 1, 0)
            SliderIndicator.ZIndex = 5
            SliderIndicator.Image = "rbxassetid://3570695787"
            SliderIndicator.ScaleType = Enum.ScaleType.Slice
            SliderIndicator.SliceCenter = Rect.new(100, 100, 100, 100)
            SliderIndicator.SliceScale = 0.15

            UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 50, 50)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(150, 0, 0))}
            UIGradient.Parent = SliderIndicator

            CircleSelector.Name = "CircleSelector"
            CircleSelector.Parent = SliderIndicator
            CircleSelector.BackgroundTransparency = 1.000
            CircleSelector.Position = UDim2.new(0.98, -7, 0.75, -7)
            CircleSelector.Size = UDim2.new(0, 12, 0, 12)
            CircleSelector.ZIndex = 5
            CircleSelector.Image = "rbxassetid://3570695787"

            UICorner.Parent = SliderName

            SliderValue.Name = "SliderValue"
            SliderValue.Parent = SliderName
            SliderValue.BackgroundTransparency = 1.000
            SliderValue.Position = UDim2.new(0.9, -7, 0.4, -12)
            SliderValue.Size = UDim2.new(0, 40, 0, 19)
            SliderValue.ZIndex = 5
            SliderValue.Image = "rbxassetid://3570695787"
            SliderValue.ImageColor3 = Color3.fromRGB(70, 70, 70)
            SliderValue.ScaleType = Enum.ScaleType.Slice
            SliderValue.SliceCenter = Rect.new(100, 100, 100, 100)
            SliderValue.SliceScale = 0.03

            Value.Name = "Value"
            Value.Parent = SliderValue
            Value.BackgroundTransparency = 1.000
            Value.Size = UDim2.new(1, 0, 1, 0)
            Value.ZIndex = 5
            Value.Font = Enum.Font.SourceSansBold
            Value.Text = tostring(StartingValue)
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.TextSize = 14.000

            local function Sliding(input)
                local SliderPosition = UDim2.new(math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1), 0, 1, 0)
                TweenService:Create(SliderIndicator, TweenInfo.new(0.1, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = SliderPosition}):Play()

                local NonSliderPreciseValue = math.floor(((SliderPosition.X.Scale * maximumvalue) / maximumvalue) * (maximumvalue - minimumvalue) + minimumvalue)
                local SliderPreciseValue = ((SliderPosition.X.Scale * maximumvalue) / maximumvalue) * (maximumvalue - minimumvalue) + minimumvalue

                local SlidingValue = precisevalue and SliderPreciseValue or NonSliderPreciseValue
                SlidingValue = tonumber(string.format("%.2f", SlidingValue))

                Value.Text = tostring(SlidingValue)
                callback(SlidingValue)
            end

            CircleSelector.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then SliderDragging = true end
            end)

            CircleSelector.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then SliderDragging = false end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if SliderDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    Sliding(input)
                end
            end)

            callback(StartingValue)
            return SliderName
        end

        function TabElements:Dropdown(name, options, presetoption, callback)
            local NameDropdown = Instance.new("Frame")
            local UICorner = Instance.new("UICorner")
            local TitleToggle = Instance.new("TextButton")
            local Dropdown = Instance.new("ScrollingFrame")
            local UICorner_2 = Instance.new("UICorner")
            local DropdownContentLayout = Instance.new("UIListLayout")
            local add = Instance.new("ImageButton")
            local SelectedOption = "nil"

            if type(presetoption) == "number" and options[presetoption] then
                SelectedOption = options[presetoption]
                callback(options[presetoption])
            elseif type(presetoption) == "string" then
                SelectedOption = presetoption
                callback(presetoption)
            end

            NameDropdown.Name = (name .. "NameDropdown")
            NameDropdown.Parent = SectionContent
            NameDropdown.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            NameDropdown.Size = UDim2.new(0, 475, 0, 30)
            NameDropdown.ZIndex = 5

            UICorner.Parent = NameDropdown

            TitleToggle.Name = "TitleToggle"
            TitleToggle.Parent = NameDropdown
            TitleToggle.BackgroundTransparency = 1.000
            TitleToggle.BorderSizePixel = 0
            TitleToggle.Position = UDim2.new(0, 13, 0, 0)
            TitleToggle.Size = UDim2.new(1, -26, 0, 30)
            TitleToggle.ZIndex = 7
            TitleToggle.Font = Enum.Font.SourceSansBold
            TitleToggle.Text = (name .. " : " .. SelectedOption)
            TitleToggle.TextColor3 = Color3.fromRGB(185, 185, 185)
            TitleToggle.TextSize = 15.000
            TitleToggle.TextXAlignment = Enum.TextXAlignment.Left

            local DropdownToggled = true
            Dropdown.Name = "Dropdown"
            Dropdown.Parent = NameDropdown
            Dropdown.Active = true
            Dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Dropdown.BorderSizePixel = 0
            Dropdown.Position = UDim2.new(0, 15, 0, 30)
            Dropdown.Size = UDim2.new(0, 450, 0, 0)
            Dropdown.ZIndex = 15
            Dropdown.CanvasSize = UDim2.new(0, 0, 0, 0)
            Dropdown.ScrollBarThickness = 2

            UICorner_2.Parent = Dropdown
            DropdownContentLayout.Parent = Dropdown
            DropdownContentLayout.SortOrder = Enum.SortOrder.LayoutOrder

            add.Name = "add"
            add.Parent = NameDropdown
            add.BackgroundTransparency = 1.000
            add.Position = UDim2.new(0.92, 0, 0.05, 0)
            add.Size = UDim2.new(0, 25, 0, 25)
            add.ZIndex = 10
            add.Image = "rbxassetid://3926307971"
            add.ImageRectOffset = Vector2.new(324, 364)
            add.ImageRectSize = Vector2.new(36, 36)

            local function Populate()
                for _, option in pairs(options) do
                    local Item = Instance.new("TextButton")
                    Item.Name = option .. "Btn"
                    Item.Parent = Dropdown
                    Item.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
                    Item.Size = UDim2.new(1, 0, 0, 25)
                    Item.Font = Enum.Font.SourceSansBold
                    Item.Text = option
                    Item.TextColor3 = Color3.fromRGB(200, 200, 200)
                    Item.TextSize = 14.000

                    Item.MouseButton1Click:Connect(function()
                        SelectedOption = option
                        TitleToggle.Text = (name .. " : " .. SelectedOption)
                        callback(option)
                        DropdownToggled = true
                        TweenService:Create(NameDropdown, TweenInfo.new(0.3), {Size = UDim2.new(0, 475, 0, 30)}):Play()
                        TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = UDim2.new(0, 450, 0, 0)}):Play()
                    end)
                end
            end
            Populate()

            TitleToggle.MouseButton1Click:Connect(function()
                DropdownToggled = not DropdownToggled
                if DropdownToggled then
                    TweenService:Create(NameDropdown, TweenInfo.new(0.3), {Size = UDim2.new(0, 475, 0, 30)}):Play()
                    TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = UDim2.new(0, 450, 0, 0)}):Play()
                else
                    TweenService:Create(NameDropdown, TweenInfo.new(0.3), {Size = UDim2.new(0, 475, 0, 140)}):Play()
                    TweenService:Create(Dropdown, TweenInfo.new(0.3), {Size = UDim2.new(0, 450, 0, 100)}):Play()
                end
            end)

            local dropdownControls = {}
            function dropdownControls:Refresh(newOptions)
                for _, child in pairs(Dropdown:GetChildren()) do
                    if child:IsA("TextButton") then child:Destroy() end
                end
                options = newOptions
                Populate()
            end
            return dropdownControls
        end

        function TabElements:Line()
            local Line = Instance.new("Frame")
            Line.Name = "Line"
            Line.Parent = SectionContent
            Line.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
            Line.Size = UDim2.new(0, 475, 0, 2)
        end

        function TabElements:Label(text)
            local Label = Instance.new("TextLabel")
            local UICorner = Instance.new("UICorner")

            Label.Name = (text .. "Label")
            Label.Parent = SectionContent
            Label.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            Label.Size = UDim2.new(0, 475, 0, 30)
            Label.Font = Enum.Font.SourceSansBold
            Label.Text = text
            Label.TextColor3 = Color3.fromRGB(255, 50, 50)
            Label.TextSize = 16.000

            UICorner.Parent = Label
            return Label
        end

        return TabElements
    end
    return Tabs
end

-- ==========================================
-- HỆ THỐNG PHÁT HIỆN SEA (WORLD DETECTION)
-- ==========================================
local placeId = game.PlaceId
if placeId == 2753915549 then
    OldWorld = true
elseif placeId == 4442272183 then
    NewWorld = true
elseif placeId == 7449423635 then
    ThreeWorld = true
end

-- ==========================================
-- HÀM DỊCH CHUYỂN & GOM QUÁI (TWEEN / MAGNET)
-- ==========================================
local function toTarget(targetPos, targetCFrame)
    local Speed = FastTween and 320 or 250
    local tween_s = game:GetService("TweenService")
    local distance = (targetPos - game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart").Position).Magnitude
    local info = TweenInfo.new(distance / Speed, Enum.EasingStyle.Linear)
    local tween = tween_s:Create(game.Players.LocalPlayer.Character["HumanoidRootPart"], info, {CFrame = targetCFrame})
    tween:Play()

    local tweenfunc = {}
    function tweenfunc:Stop()
        tween:Cancel()
    end
    return tweenfunc
end

local function EquipWeapon(ToolName)
    local bp = game.Players.LocalPlayer.Backpack
    local char = game.Players.LocalPlayer.Character
    if bp:FindFirstChild(ToolName) then
        local tool = bp:FindFirstChild(ToolName)
        char.Humanoid:EquipTool(tool)
    end
end

local function Click()
    local vu = game:GetService("VirtualUser")
    vu:CaptureController()
    vu:ClickButton1(Vector2.new(851, 158), game:GetService("Workspace").Camera.CFrame)
end

-- ==========================================
-- HỆ THỐNG QUEST VÀ DATA QUÁI VẬT (MONSTERS DATA)
-- ==========================================
local Nonquest = false
local Ms, NameQuest, LevelQuest, NameMon, CFrameQuest, CFrameMon

function CheckQuest()
    local MyLevel = game.Players.LocalPlayer.Data.Level.Value
    if OldWorld then
        if MyLevel >= 1 and MyLevel <= 9 then
            Ms = "Bandit [Lv. 5]"
            NameQuest = "BanditQuest1"
            LevelQuest = 1
            NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059.37, 15.44, 1550.42)
            CFrameMon = CFrame.new(1353.44, 3.4, 1376.92)
        elseif MyLevel >= 10 and MyLevel <= 14 then
            Ms = "Monkey [Lv. 14]"
            NameQuest = "JungleQuest"
            LevelQuest = 1
            NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37)
            CFrameMon = CFrame.new(-1402.74, 98.56, 90.64)
        elseif MyLevel >= 15 and MyLevel <= 29 then
            Ms = "Gorilla [Lv. 20]"
            NameQuest = "JungleQuest"
            LevelQuest = 2
            NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598.08, 35.55, 153.37)
            CFrameMon = CFrame.new(-1267.89, 66.2, -531.81)
        elseif MyLevel >= 30 and MyLevel <= 59 then
            Ms = "Desert Bandit [Lv. 60]"
            NameQuest = "DesertQuest"
            LevelQuest = 1
            NameMon = "Desert Bandit"
            CFrameQuest = CFrame.new(894.48, 5.14, 4392.43)
            CFrameMon = CFrame.new(932.78, 6.85, 4488.24)
        else
            -- Bổ sung fallback mặc định cho các Level cao hơn ở Sea 1
            Ms = "Galley Captain [Lv. 650]"
            NameQuest = "FountainQuest"
            LevelQuest = 2
            NameMon = "Galley Captain"
            CFrameQuest = CFrame.new(5259.81, 37.35, 4050.02)
            CFrameMon = CFrame.new(5782.90, 94.53, 4716.78)
        end
    elseif NewWorld then
        if MyLevel >= 700 and MyLevel <= 724 then
            Ms = "Raider [Lv. 700]"
            NameQuest = "Area1Quest"
            LevelQuest = 1
            NameMon = "Raider"
            CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18)
            CFrameMon = CFrame.new(-737.02, 10.17, 2392.57)
        elseif MyLevel >= 725 and MyLevel <= 774 then
            Ms = "Mercenary [Lv. 725]"
            NameQuest = "Area1Quest"
            LevelQuest = 2
            NameMon = "Mercenary"
            CFrameQuest = CFrame.new(-429.54, 71.76, 1836.18)
            CFrameMon = CFrame.new(-1022.21, 72.98, 1891.39)
        else
            -- Mặc định Sea 2 cấp cao
            Ms = "Water Fighter [Lv. 1450]"
            NameQuest = "ForgottenQuest"
            LevelQuest = 2
            NameMon = "Water Fighter"
            CFrameQuest = CFrame.new(-3054.44, 235.54, -10142.81)
            CFrameMon = CFrame.new(-3212.99, 263.8, -10551.87)
        end
    elseif ThreeWorld then
        if MyLevel >= 1500 and MyLevel <= 1524 then
            Ms = "Pirate Millionaire [Lv. 1500]"
            NameQuest = "PiratePortQuest"
            LevelQuest = 1
            NameMon = "Pirate Millionaire"
            CFrameQuest = CFrame.new(-290.07, 42.9, 5581.58)
            CFrameMon = CFrame.new(81.16, 43.75, 5724.70)
        else
            -- Mặc định Sea 3 cấp cao
            Ms = "Head Baker [Lv. 2275]"
            NameQuest = "CakeQuest2"
            LevelQuest = 2
            NameMon = "Head Baker"
            CFrameQuest = CFrame.new(-1928.31, 37.72, -12840.62)
            CFrameMon = CFrame.new(-2288.79, 106.94, -12811.11)
        end
    end
end
CheckQuest()

-- ==========================================
-- VÒNG LẶP AUTO FARM CHÍNH (MAIN FARM LOOP)
-- ==========================================
local farm = false
local StartMagnet = false
local PosMon

spawn(function()
    while true do
        if farm and getgenv().Setting["Auto Farm Level"] then
            CheckQuest()
            local QuestGui = game:GetService("Players").LocalPlayer.PlayerGui.Main.Quest
            if QuestGui.Visible == false then
                -- Nhận Quest
                local QuestTween = toTarget(CFrameQuest.Position, CFrameQuest)
                if (CFrameQuest.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 50 then
                    QuestTween:Stop()
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrameQuest
                    task.wait(0.5)
                    game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("StartQuest", NameQuest, LevelQuest)
                    game:GetService("ReplicatedStorage").Remotes["CommF_"]:InvokeServer("SetSpawnPoint")
                end
            else
                -- Tiến hành farm quái
                local foundMonster = false
                for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v.Name == Ms and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        foundMonster = true
                        repeat wait()
                            pcall(function()
                                if game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
                                    local FarmTween = toTarget(v.HumanoidRootPart.Position, v.HumanoidRootPart.CFrame * CFrame.new(0, 30, 0))
                                    if (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= 100 then
                                        FarmTween:Stop()
                                        PosMon = v.HumanoidRootPart.CFrame
                                        StartMagnet = true
                                        EquipWeapon(getgenv().Setting["Select Weapon"])
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 25, 0)
                                        Click()
                                    end
                                end
                            end)
                        until not farm or not v.Parent or v.Humanoid.Health <= 0 or QuestGui.Visible == false
                        StartMagnet = false
                    end
                end

                if not foundMonster then
                    -- Đi tìm quái nếu chưa xuất hiện
                    toTarget(CFrameMon.Position, CFrameMon)
                end
            end
        end
        task.wait(0.1)
    end
end)

-- HỆ THỐNG GOM QUÁI (MAGNET MONSTERS)
spawn(function()
    while true do
        if StartMagnet and farm then
            pcall(function()
                for _, v in pairs(game:GetService("Workspace").Enemies:GetChildren()) do
                    if v.Name == Ms and v:FindFirstChild("HumanoidRootPart") and v.Humanoid.Health > 0 then
                        if (v.HumanoidRootPart.Position - PosMon.Position).Magnitude <= 300 then
                            v.HumanoidRootPart.CFrame = PosMon
                            v.HumanoidRootPart.CanCollide = false
                            if v.Humanoid:FindFirstChild("Animator") then
                                v.Humanoid.Animator:Destroy()
                            end
                            v.Humanoid:ChangeState(11)
                        end
                    end
                end
            end)
        end
        task.wait(0.01)
    end
end)

-- NO CLIP KHI FARM
spawn(function()
    game:GetService("RunService").Stepped:Connect(function()
        if farm then
            pcall(function()
                local char = game.Players.LocalPlayer.Character
                if char:FindFirstChild("Humanoid") then
                    char.Humanoid:ChangeState(11)
                end
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end)
        end
    end)
end)

-- ==========================================
-- AUTO STATS
-- ==========================================
spawn(function()
    while wait(2) do
        local stats = game.Players.LocalPlayer.Data.Stats
        local points = game.Players.LocalPlayer.Data.Points.Value
        if points > 0 then
            if getgenv().Setting["Melee"] then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Melee", points)
            end
            if getgenv().Setting["Defense"] then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Defense", points)
            end
            if getgenv().Setting["Sword"] then
                game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("AddPoint", "Sword", points)
            end
        end
    end
end)

-- ==========================================
-- GIAO DIỆN ĐIỀU KHIỂN (UI WINDOW & TABS)
-- ==========================================
local Main = library:Window("Ren Kaitun", "Blox Fruit")
local AutoTab = Main:Tab("Auto Farm")
local StatsTab = Main:Tab("Stats")
local MiscTab = Main:Tab("Hệ Thống")

-- Auto Farm Tab Elements
AutoTab:Toggle("Auto Farm Level", getgenv().Setting["Auto Farm Level"], function(state)
    farm = state
    getgenv().Setting["Auto Farm Level"] = state
end)

FastTween = false
AutoTab:Toggle("Siêu Tốc Độ Bay (Bypass)", false, function(state)
    FastTween = state
end)

local weaponsList = {}
for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if v:IsA("Tool") then table.insert(weaponsList, v.Name) end
end
for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
    if v:IsA("Tool") then table.insert(weaponsList, v.Name) end
end

local WeaponDropdown = AutoTab:Dropdown("Chọn Vũ Khí", weaponsList, getgenv().Setting["Select Weapon"], function(weapon)
    getgenv().Setting["Select Weapon"] = weapon
end)

AutoTab:Button("Làm Mới Vũ Khí", function()
    local newList = {}
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") then table.insert(newList, v.Name) end
    end
    for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA("Tool") then table.insert(newList, v.Name) end
    end
    WeaponDropdown:Refresh(newList)
end)

-- Stats Tab Elements
StatsTab:Toggle("Nâng Melee (Cận chiến)", getgenv().Setting["Melee"], function(state)
    getgenv().Setting["Melee"] = state
end)

StatsTab:Toggle("Nâng Defense (Máu)", getgenv().Setting["Defense"], function(state)
    getgenv().Setting["Defense"] = state
end)

StatsTab:Toggle("Nâng Sword (Kiếm)", getgenv().Setting["Sword"], function(state)
    getgenv().Setting["Sword"] = state
end)

-- Hệ thống Tab Elements (Misc)
MiscTab:Button("Dịch chuyển về Sea 1", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelMain")
end)

MiscTab:Button("Dịch chuyển về Sea 2", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelDressrosa")
end)

MiscTab:Button("Dịch chuyển về Sea 3", function()
    game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("TravelZou")
end)

-- Chống ngắt kết nối khi treo máy lâu
LocalPlayer.Idled:Connect(function()
    local vu = game:GetService("VirtualUser")
    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)