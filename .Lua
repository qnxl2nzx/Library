-- Rayfield風 UI Library with Typewriter & Rainbow Text
-- 完全版

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- ドラッグ
local function MakeDraggable(frame, dragHandle)
    local dragging, dragStart, startPos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- Tween
local function Tween(object, properties, duration)
    local tweenInfo = TweenInfo.new(duration or 0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- タイプライター
local function TypewriterEffect(textLabel, fullText, speed)
    textLabel.Text = ""
    for i = 1, #fullText do
        textLabel.Text = fullText:sub(1, i)
        task.wait(speed or 0.05)
    end
end

-- ⭐ レインボーテキスト
function Library:RainbowText(label)
    task.spawn(function()
        local hue = 0
        while label and label.Parent do
            hue = (hue + 1) % 360
            label.TextColor3 = Color3.fromHSV(hue / 360, 1, 1)
            task.wait(0.02)
        end
    end)
end

------------------------------------------------------
--                Window 作成
------------------------------------------------------
function Library:CreateWindow(config)
    config = config or {}

    local windowName = config.Name or "Rayfield UI"
    local typewriterSpeed = config.TypewriterSpeed or 0.05

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "RayfieldUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui

    -- MainFrame
    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 550, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -225)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local MainCorner = Instance.new("UICorner", MainFrame)
    MainCorner.CornerRadius = UDim.new(0, 12)

    -- Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageTransparency = 0.5
    Shadow.BackgroundTransparency = 1
    Shadow.ZIndex = 0
    Shadow.Parent = MainFrame

    -- Header
    local Header = Instance.new("Frame")
    Header.Size = UDim2.new(1, 0, 0, 45)
    Header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    Header.Parent = MainFrame

    local HeaderCorner = Instance.new("UICorner", Header)
    HeaderCorner.CornerRadius = UDim.new(0, 12)

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 18
    Title.TextColor3 = Color3.new(1, 1, 1)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header

    -- タイプライター → レインボー
    task.spawn(function()
        TypewriterEffect(Title, windowName, typewriterSpeed)
        Library:RainbowText(Title)
    end)

    ------------------------------------------------------
    --         ⭐ 最小化（ヘッダー以外を折りたたむ）
    ------------------------------------------------------
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
    MinimizeButton.Position = UDim2.new(1, -80, 0, 5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    MinimizeButton.Text = "-"
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.TextColor3 = Color3.new(1, 1, 1)
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Parent = Header

    Instance.new("UICorner", MinimizeButton).CornerRadius = UDim.new(0, 8)

    ------------------------------------------------------
    -- コンテンツコンテナ
    ------------------------------------------------------
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(1, -20, 1, -60)
    ContentContainer.Position = UDim2.new(0, 10, 0, 50)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame

    local originalContentSize = ContentContainer.Size
    local isMinimized = false

    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Tween(ContentContainer, {Size = UDim2.new(1, -20, 0, 0)}, 0.3)
            MinimizeButton.Text = "+"
        else
            Tween(ContentContainer, {Size = originalContentSize}, 0.3)
            MinimizeButton.Text = "-"
        end
    end)

    ------------------------------------------------------
    -- CloseButton
    ------------------------------------------------------
    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.Position = UDim2.new(1, -40, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.new(1, 1, 1)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = Header

    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 8)

    CloseButton.MouseButton1Click:Connect(function()
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        ScreenGui:Destroy()
    end)

    ------------------------------------------------------
    -- TabContainer
    ------------------------------------------------------
    local TabContainer = Instance.new("Frame")
    TabContainer.Size = UDim2.new(0, 140, 1, -65)
    TabContainer.Position = UDim2.new(0, 10, 0, 55)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = ContentContainer

    local TabList = Instance.new("UIListLayout")
    TabList.Padding = UDim.new(0, 8)
    TabList.Parent = TabContainer

    -- タブとコンテンツ管理
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil

    ------------------------------------------------------
    -- タブ作成関数
    ------------------------------------------------------
    function Window:CreateTab(tabName)
        local Tab = {}

        -- タブボタン
        local TabButton = Instance.new("TextButton")
        TabButton.Size = UDim2.new(1, 0, 0, 38)
        TabButton.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        TabButton.Text = tabName
        TabButton.TextColor3 = Color3.fromRGB(180, 180, 180)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Parent = TabContainer

        Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0, 8)

        -- タブのコンテンツ
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Size = UDim2.new(1, -160, 1, -10)
        TabContent.Position = UDim2.new(0, 150, 0, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.ScrollBarThickness = 4
        TabContent.Visible = false
        TabContent.Parent = ContentContainer

        local ContentList = Instance.new("UIListLayout")
        ContentList.Padding = UDim.new(0, 10)
        ContentList.Parent = TabContent

        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)

        ------------------------------------------------------
        -- タブ切り替え
        ------------------------------------------------------
        TabButton.MouseButton1Click:Connect(function()
            for _, t in ipairs(Window.Tabs) do
                t.Button.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
                t.Button.TextColor3 = Color3.fromRGB(180, 180, 180)
                t.Content.Visible = false
            end

            TabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
            TabButton.TextColor3 = Color3.new(1, 1, 1)
            TabContent.Visible = true

            Window.CurrentTab = Tab
        end)

        -- 初回タブ自動選択
        if #Window.Tabs == 0 then
            TabButton.BackgroundColor3 = Color3.fromRGB(80, 80, 255)
            TabButton.TextColor3 = Color3.new(1, 1, 1)
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end

        ------------------------------------------------------
        -- UI要素（Button / Toggle / Slider / Input）
        ------------------------------------------------------

        -- Button
        function Tab:CreateButton(config)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, -10, 0, 40)
            Button.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            Button.TextColor3 = Color3.new(1, 1, 1)
            Button.Font = Enum.Font.Gotham
            Button.Text = config.Name or "Button"
            Button.Parent = TabContent

            Instance.new("UICorner", Button).CornerRadius = UDim.new(0, 8)

            Button.MouseButton1Click:Connect(config.Callback or function() end)

            return Button
        end
        
        self.Tabs[#self.Tabs+1] = Tab
        Tab.Button = TabButton
        Tab.Content = TabContent

        return Tab
    end

    MakeDraggable(MainFrame, Header)
    return Window
end

return Library
