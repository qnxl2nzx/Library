-- Sonix UI Library - Premium Modern Design
-- Unique & Stylish Roblox UI Library

local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- ユーティリティ関数
local function MakeDraggable(frame, dragHandle)
    local dragging, dragInput, dragStart, startPos
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    dragHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

local function Tween(object, properties, duration, style)
    local tweenInfo = TweenInfo.new(
        duration or 0.3, 
        style or Enum.EasingStyle.Quint, 
        Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(object, tweenInfo, properties)
    tween:Play()
    return tween
end

-- タイプライター効果
local function TypewriterEffect(textLabel, fullText, speed)
    textLabel.Text = ""
    for i = 1, #fullText do
        textLabel.Text = string.sub(fullText, 1, i)
        task.wait(speed or 0.05)
    end
end

-- レインボーテキスト効果
local function RainbowText(textLabel)
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if not textLabel or not textLabel.Parent then
            connection:Disconnect()
            return
        end
        local hue = tick() % 5 / 5
        textLabel.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
    end)
    return connection
end

-- グローエフェクト
local function CreateGlow(parent, color)
    local glow = Instance.new("ImageLabel")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, 40, 1, 40)
    glow.Position = UDim2.new(0, -20, 0, -20)
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = color or Color3.fromRGB(100, 200, 255)
    glow.ImageTransparency = 0.7
    glow.ZIndex = 0
    glow.Parent = parent
    return glow
end

-- メインライブラリ作成
function Library:CreateWindow(config)
    config = config or {}
    local windowName = config.Name or "Sonix UI"
    local accentColor = config.AccentColor or Color3.fromRGB(100, 200, 255)
    local typewriterSpeed = config.TypewriterSpeed or 0.05
    local useTypewriter = config.Typewriter ~= false
    local useRainbow = config.Rainbow or false
    
    -- ScreenGui作成
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SonixUI"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = CoreGui
    
    -- メインフレーム（ガラスモーフィズム風）
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 480)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -240)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 16)
    MainCorner.Parent = MainFrame
    
    -- アウターグロー
    local OuterGlow = Instance.new("ImageLabel")
    OuterGlow.Name = "OuterGlow"
    OuterGlow.Size = UDim2.new(1, 60, 1, 60)
    OuterGlow.Position = UDim2.new(0, -30, 0, -30)
    OuterGlow.BackgroundTransparency = 1
    OuterGlow.Image = "rbxassetid://5028857084"
    OuterGlow.ImageColor3 = accentColor
    OuterGlow.ImageTransparency = 0.6
    OuterGlow.ZIndex = 0
    OuterGlow.Parent = MainFrame
    
    -- グラデーションボーダー
    local Border = Instance.new("Frame")
    Border.Name = "Border"
    Border.Size = UDim2.new(1, 4, 1, 4)
    Border.Position = UDim2.new(0, -2, 0, -2)
    Border.BackgroundColor3 = accentColor
    Border.BorderSizePixel = 0
    Border.ZIndex = -1
    Border.Parent = MainFrame
    
    local BorderCorner = Instance.new("UICorner")
    BorderCorner.CornerRadius = UDim.new(0, 18)
    BorderCorner.Parent = Border
    
    local BorderGradient = Instance.new("UIGradient")
    BorderGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, accentColor),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, accentColor)
    }
    BorderGradient.Rotation = 45
    BorderGradient.Parent = Border
    
    -- アニメーションボーダー
    task.spawn(function()
        while Border and Border.Parent do
            Tween(BorderGradient, {Rotation = BorderGradient.Rotation + 360}, 3, Enum.EasingStyle.Linear)
            task.wait(3)
        end
    end)
    
    -- ヘッダー
    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 60)
    Header.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    Header.BackgroundTransparency = 0.3
    Header.BorderSizePixel = 0
    Header.Parent = MainFrame
    
    local HeaderCorner = Instance.new("UICorner")
    HeaderCorner.CornerRadius = UDim.new(0, 16)
    HeaderCorner.Parent = Header
    
    local HeaderBottom = Instance.new("Frame")
    HeaderBottom.Size = UDim2.new(1, 0, 0, 16)
    HeaderBottom.Position = UDim2.new(0, 0, 1, -16)
    HeaderBottom.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    HeaderBottom.BackgroundTransparency = 0.3
    HeaderBottom.BorderSizePixel = 0
    HeaderBottom.Parent = Header
    
    -- アクセントライン
    local AccentLine = Instance.new("Frame")
    AccentLine.Name = "AccentLine"
    AccentLine.Size = UDim2.new(1, 0, 0, 2)
    AccentLine.Position = UDim2.new(0, 0, 1, 0)
    AccentLine.BackgroundColor3 = accentColor
    AccentLine.BorderSizePixel = 0
    AccentLine.Parent = Header
    
    local LineGradient = Instance.new("UIGradient")
    LineGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
        ColorSequenceKeypoint.new(0.5, accentColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
    }
    LineGradient.Parent = AccentLine
    
    -- ロゴアイコン
    local LogoIcon = Instance.new("Frame")
    LogoIcon.Name = "Logo"
    LogoIcon.Size = UDim2.new(0, 35, 0, 35)
    LogoIcon.Position = UDim2.new(0, 15, 0.5, -17.5)
    LogoIcon.BackgroundColor3 = accentColor
    LogoIcon.BorderSizePixel = 0
    LogoIcon.Parent = Header
    
    local LogoCorner = Instance.new("UICorner")
    LogoCorner.CornerRadius = UDim.new(0, 8)
    LogoCorner.Parent = LogoIcon
    
    local LogoGradient = Instance.new("UIGradient")
    LogoGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, accentColor),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 255, 255))
    }
    LogoGradient.Rotation = 45
    LogoGradient.Parent = LogoIcon
    
    local LogoText = Instance.new("TextLabel")
    LogoText.Size = UDim2.new(1, 0, 1, 0)
    LogoText.BackgroundTransparency = 1
    LogoText.Text = "S"
    LogoText.TextColor3 = Color3.fromRGB(255, 255, 255)
    LogoText.TextSize = 20
    LogoText.Font = Enum.Font.GothamBold
    LogoText.Parent = LogoIcon
    
    -- タイトル
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -180, 1, 0)
    Title.Position = UDim2.new(0, 60, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = useTypewriter and "" or windowName
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Header
    
    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, accentColor)
    }
    TitleGradient.Parent = Title
    
    -- タイプライターエフェクト
    if useTypewriter then
        task.spawn(function()
            TypewriterEffect(Title, windowName, typewriterSpeed)
        end)
    end
    
    -- レインボーエフェクト
    if useRainbow then
        RainbowText(Title)
    end
    
    -- コントロールボタンコンテナ
    local ControlsContainer = Instance.new("Frame")
    ControlsContainer.Name = "Controls"
    ControlsContainer.Size = UDim2.new(0, 100, 0, 35)
    ControlsContainer.Position = UDim2.new(1, -110, 0.5, -17.5)
    ControlsContainer.BackgroundTransparency = 1
    ControlsContainer.Parent = Header
    
    local ControlsList = Instance.new("UIListLayout")
    ControlsList.FillDirection = Enum.FillDirection.Horizontal
    ControlsList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ControlsList.Padding = UDim.new(0, 8)
    ControlsList.Parent = ControlsContainer
    
    -- 最小化ボタン
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.Size = UDim2.new(0, 35, 0, 35)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    MinimizeButton.Text = "─"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 16
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.BorderSizePixel = 0
    MinimizeButton.Parent = ControlsContainer
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 8)
    MinimizeCorner.Parent = MinimizeButton
    
    local isMinimized = false
    local originalSize = MainFrame.Size
    
    MinimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 60)}, 0.4)
            MinimizeButton.Text = "□"
        else
            Tween(MainFrame, {Size = originalSize}, 0.4)
            MinimizeButton.Text = "─"
        end
    end)
    
    MinimizeButton.MouseEnter:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = accentColor}, 0.2)
    end)
    
    MinimizeButton.MouseLeave:Connect(function()
        Tween(MinimizeButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, 0.2)
    end)
    
    -- 閉じるボタン
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.Size = UDim2.new(0, 35, 0, 35)
    CloseButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    CloseButton.Text = "✕"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 16
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.BorderSizePixel = 0
    CloseButton.Parent = ControlsContainer
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    local isHidden = false
    
    CloseButton.MouseButton1Click:Connect(function()
        isHidden = true
        Tween(MainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
        task.wait(0.3)
        MainFrame.Visible = false
    end)
    
    CloseButton.MouseEnter:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}, 0.2)
    end)
    
    CloseButton.MouseLeave:Connect(function()
        Tween(CloseButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}, 0.2)
    end)
    
    -- Qキーで再表示
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.Q and isHidden then
            isHidden = false
            MainFrame.Visible = true
            MainFrame.Size = UDim2.new(0, 0, 0, 0)
            Tween(MainFrame, {Size = originalSize}, 0.5, Enum.EasingStyle.Back)
        end
    end)
    
    -- タブコンテナ（横並び）
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -20, 0, 45)
    TabContainer.Position = UDim2.new(0, 10, 0, 70)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame
    
    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Size = UDim2.new(1, 0, 1, 0)
    TabScroll.BackgroundTransparency = 1
    TabScroll.BorderSizePixel = 0
    TabScroll.ScrollBarThickness = 0
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
    TabScroll.ScrollingDirection = Enum.ScrollingDirection.X
    TabScroll.Parent = TabContainer
    
    local TabList = Instance.new("UIListLayout")
    TabList.FillDirection = Enum.FillDirection.Horizontal
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 10)
    TabList.Parent = TabScroll
    
    -- コンテンツコンテナ
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -20, 1, -135)
    ContentContainer.Position = UDim2.new(0, 10, 0, 125)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = MainFrame
    
    -- ドラッグ可能にする
    MakeDraggable(MainFrame, Header)
    
    -- オープンアニメーション
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Rotation = -5
    Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 480)}, 0.6, Enum.EasingStyle.Back)
    Tween(MainFrame, {Rotation = 0}, 0.6, Enum.EasingStyle.Back)
    
    local Window = {}
    Window.Tabs = {}
    Window.CurrentTab = nil
    Window.AccentColor = accentColor
    
    function Window:CreateTab(tabName, icon)
        local Tab = {}
        
        -- タブボタン
        local TabButton = Instance.new("TextButton")
        TabButton.Name = tabName
        TabButton.Size = UDim2.new(0, 140, 1, 0)
        TabButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
        TabButton.Text = ""
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        TabButton.Parent = TabScroll
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 10)
        TabCorner.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Size = UDim2.new(1, -10, 1, 0)
        TabLabel.Position = UDim2.new(0, 5, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = (icon or "⚡") .. " " .. tabName
        TabLabel.TextColor3 = Color3.fromRGB(150, 150, 160)
        TabLabel.TextSize = 14
        TabLabel.Font = Enum.Font.GothamBold
        TabLabel.Parent = TabButton
        
        -- タブコンテンツ
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = tabName .. "Content"
        TabContent.Size = UDim2.new(1, 0, 1, 0)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 6
        TabContent.ScrollBarImageColor3 = accentColor
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 12)
        ContentList.Parent = TabContent
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 12)
        end)
        
        -- タブ切り替え
        TabButton.MouseButton1Click:Connect(function()
            for _, tab in pairs(Window.Tabs) do
                Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}, 0.2)
                tab.Label.TextColor3 = Color3.fromRGB(150, 150, 160)
                tab.Content.Visible = false
            end
            
            Tween(TabButton, {BackgroundColor3 = accentColor}, 0.2)
            TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end)
        
        TabButton.MouseEnter:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if Window.CurrentTab ~= Tab then
                Tween(TabButton, {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}, 0.2)
            end
        end)
        
        Tab.Button = TabButton
        Tab.Label = TabLabel
        Tab.Content = TabContent
        table.insert(Window.Tabs, Tab)
        
        -- 最初のタブを選択
        if #Window.Tabs == 1 then
            TabButton.BackgroundColor3 = accentColor
            TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            TabContent.Visible = true
            Window.CurrentTab = Tab
        end
        
        -- 要素作成関数
        function Tab:CreateButton(config)
            local buttonText = config.Name or "Button"
            local callback = config.Callback or function() end
            
            local ButtonFrame = Instance.new("Frame")
            ButtonFrame.Size = UDim2.new(1, -10, 0, 45)
            ButtonFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 10)
            ButtonCorner.Parent = ButtonFrame
            
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 1, 0)
            Button.BackgroundTransparency = 1
            Button.Text = buttonText
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 15
            Button.Font = Enum.Font.GothamSemibold
            Button.Parent = ButtonFrame
            
            Button.MouseButton1Click:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = accentColor}, 0.1)
                task.wait(0.1)
                Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}, 0.2)
                callback()
            end)
            
            Button.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 45)}, 0.2)
            end)
            
            Button.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}, 0.2)
            end)
            
            return ButtonFrame
        end
        
        function Tab:CreateToggle(config)
            local toggleText = config.Name or "Toggle"
            local default = config.Default or false
            local callback = config.Callback or function() end
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Size = UDim2.new(1, -10, 0, 45)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 10)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -70, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 15, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = toggleText
            ToggleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            ToggleLabel.TextSize = 15
            ToggleLabel.Font = Enum.Font.GothamSemibold
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 50, 0, 26)
            ToggleButton.Position = UDim2.new(1, -60, 0.5, -13)
            ToggleButton.BackgroundColor3 = default and accentColor or Color3.fromRGB(40, 40, 50)
            ToggleButton.Text = ""
            ToggleButton.BorderSizePixel = 0
            ToggleButton.Parent = ToggleFrame
            
            local ToggleCorner2 = Instance.new("UICorner")
            ToggleCorner2.CornerRadius = UDim.new(1, 0)
            ToggleCorner2.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 20, 0, 20)
            ToggleCircle.Position = default and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local toggled = default
            
            ToggleButton.MouseButton1Click:Connect(function()
                toggled = not toggled
                
                if toggled then
                    Tween(ToggleButton, {BackgroundColor3 = accentColor}, 0.3)
                    Tween(ToggleCircle, {Position = UDim2.new(1, -23, 0.5, -10)}, 0.3, Enum.EasingStyle.Back)
                else
                    Tween(ToggleButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 50)}, 0.3)
                    Tween(ToggleCircle, {Position = UDim2.new(0, 3, 0.5, -10)}, 0.3, Enum.EasingStyle.Back)
                end
                
                callback(toggled)
            end)
            
            return ToggleFrame
        end
        
        function Tab:CreateSlider(config)
            local sliderText = config.Name or "Slider"
            local min = config.Min or 0
            local max = config.Max or 100
            local default = config.Default or 50
            local callback = config.Callback or function() end
            
            local SliderFrame = Instance.new("Frame")
            SliderFrame.Size = UDim2.new(1, -10, 0, 60)
            SliderFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            SliderFrame.BorderSizePixel = 0
            SliderFrame.Parent = TabContent
            
            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 10)
            SliderCorner.Parent = SliderFrame
            
            local SliderLabel = Instance.new("TextLabel")
            SliderLabel.Size = UDim2.new(1, -20, 0, 20)
            SliderLabel.Position = UDim2.new(0, 15, 0, 8)
            SliderLabel.BackgroundTransparency = 1
            SliderLabel.Text = sliderText .. ": " .. default
            SliderLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            SliderLabel.TextSize = 14
            SliderLabel.Font = Enum.Font.GothamSemibold
            SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
            SliderLabel.Parent = SliderFrame
            
            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -30, 0, 8)
            SliderBar.Position = UDim2.new(0, 15, 1, -18)
            SliderBar.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
            SliderBar.BorderSizePixel = 0
            SliderBar.Parent = SliderFrame
            
            local SliderBarCorner = Instance.new("UICorner")
            SliderBarCorner.CornerRadius = UDim.new(1, 0)
            SliderBarCorner.Parent = SliderBar
            
            local SliderFill = Instance.new("Frame")
            SliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            SliderFill.BackgroundColor3 = accentColor
            SliderFill.BorderSizePixel = 0
            SliderFill.Parent = SliderBar
            
            local SliderFillCorner = Instance.new("UICorner")
            SliderFillCorner.CornerRadius = UDim.new(1, 0)
            SliderFillCorner.Parent = SliderFill
            
            local dragging = false
            
            SliderBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            
            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local mouse = UserInputService:GetMouseLocation()
                    local barPos = SliderBar.AbsolutePosition.X
                    local barSize = SliderBar.AbsoluteSize.X
                    local value = math.clamp((mouse.X - barPos) / barSize, 0, 1)
                    local finalValue = math.floor(min + (max - min) * value)
                    
                    Tween(SliderFill, {Size = UDim2.new(value, 0, 1, 0)}, 0.1)
                    SliderLabel.Text = sliderText .. ": " .. finalValue
                    callback(finalValue)
                end
            end)
            
            return SliderFrame
        end
        
        function Tab:CreateInput(config)
            local inputText = config.Name or "Input"
            local placeholder = config.Placeholder or "入力..."
            local callback = config.Callback or function() end
            
            local InputFrame = Instance.new("Frame")
            InputFrame.Size = UDim2.new(1, -10, 0, 75)
            InputFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            InputFrame.BorderSizePixel = 0
            InputFrame.Parent = TabContent
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 10)
            InputCorner.Parent = InputFrame
            
            local InputLabel = Instance.new("TextLabel")
            InputLabel.Size = UDim2.new(1, -20, 0, 20)
            InputLabel.Position = UDim2.new(0, 15, 0, 8)
            InputLabel.BackgroundTransparency = 1
            InputLabel.Text = inputText
            InputLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputLabel.TextSize = 14
            InputLabel.Font = Enum.Font.GothamSemibold
            InputLabel.TextXAlignment = Enum.TextXAlignment.Left
            InputLabel.Parent = InputFrame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(1, -30, 0, 38)
            InputBox.Position = UDim2.new(0, 15, 0, 32)
            InputBox.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
            InputBox.Text = ""
            InputBox.PlaceholderText = placeholder
            InputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            InputBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 110)
            InputBox.TextSize = 14
            InputBox.Font = Enum.Font.Gotham
            InputBox.BorderSizePixel = 0
            InputBox.Parent = InputFrame
            
            local InputBoxCorner = Instance.new("UICorner")
            InputBoxCorner.CornerRadius = UDim.new(0, 8)
            InputBoxCorner.Parent = InputBox
            
            InputBox.Focused:Connect(function()
                Tween(InputBox, {BackgroundColor3 = Color3.fromRGB(28, 28, 38)}, 0.2)
            end)
            
            InputBox.FocusLost:Connect(function(enterPressed)
                Tween(InputBox, {BackgroundColor3 = Color3.fromRGB(18, 18, 25)}, 0.2)
                if enterPressed then
                    callback(InputBox.Text)
                end
            end)
            
            return InputFrame
        end
        
        return Tab
    end
    
    return Window
end

return Library
