
--==================================================
-- KAYUI
-- Version 1.0.0
-- Mobile Friendly UI Library
--==================================================

local KayUI = {}

KayUI.Version = "1.0.0"
KayUI.Creator = "Kayron"

-- SERVICES
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

local Player = Players.LocalPlayer

-- THEMES
KayUI.Themes = {
    Blue = {
        Background = Color3.fromRGB(13, 16, 25),
        Sidebar = Color3.fromRGB(19, 23, 35),
        Card = Color3.fromRGB(27, 32, 47),
        Accent = Color3.fromRGB(75, 125, 255),
        Text = Color3.fromRGB(245, 247, 255),
        Muted = Color3.fromRGB(145, 153, 175),
        Stroke = Color3.fromRGB(43, 50, 69)
    },

    Purple = {
        Background = Color3.fromRGB(17, 14, 25),
        Sidebar = Color3.fromRGB(25, 20, 36),
        Card = Color3.fromRGB(37, 29, 50),
        Accent = Color3.fromRGB(160, 100, 255),
        Text = Color3.fromRGB(250, 245, 255),
        Muted = Color3.fromRGB(165, 150, 185),
        Stroke = Color3.fromRGB(65, 48, 80)
    },

    Red = {
        Background = Color3.fromRGB(22, 13, 16),
        Sidebar = Color3.fromRGB(34, 19, 23),
        Card = Color3.fromRGB(47, 27, 33),
        Accent = Color3.fromRGB(245, 75, 100),
        Text = Color3.fromRGB(255, 245, 247),
        Muted = Color3.fromRGB(180, 145, 155),
        Stroke = Color3.fromRGB(75, 43, 52)
    }
}

KayUI.Theme = KayUI.Themes.Blue

-- UTILITIES
local function Create(class, props, parent)
    local object = Instance.new(class)

    for property, value in pairs(props or {}) do
        object[property] = value
    end

    object.Parent = parent
    return object
end

local function Corner(object, radius)
    Create("UICorner", {
        CornerRadius = UDim.new(0, radius or 10)
    }, object)
end

local function Stroke(object, color)
    Create("UIStroke", {
        Color = color or KayUI.Theme.Stroke,
        Thickness = 1,
        Transparency = 0.15
    }, object)
end

local function Tween(object, properties, duration)
    local animation = TweenService:Create(
        object,
        TweenInfo.new(
            duration or 0.2,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        properties
    )

    animation:Play()
    return animation
end

local function MakeLabel(parent, text, size, position, color)
    return Create("TextLabel", {
        Size = size,
        Position = position,
        BackgroundTransparency = 1,
        Text = text or "",
        TextColor3 = color or KayUI.Theme.Text,
        TextSize = 12,
        Font = Enum.Font.GothamMedium,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true
    }, parent)
end

-- NOTIFICATIONS
function KayUI:Notify(title, message, duration)
    if not self.Gui then return end

    local toast = Create("Frame", {
        Size = UDim2.fromOffset(250, 75),
        Position = UDim2.new(1, 260, 1, -95),
        BackgroundColor3 = self.Theme.Sidebar,
        BorderSizePixel = 0
    }, self.Gui)

    Corner(toast, 10)
    Stroke(toast)

    Create("Frame", {
        Size = UDim2.new(0, 4, 1, -16),
        Position = UDim2.fromOffset(0, 8),
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0
    }, toast)

    MakeLabel(
        toast,
        title or "KAYUI",
        UDim2.new(1, -20, 0, 24),
        UDim2.fromOffset(13, 8),
        self.Theme.Text
    )

    MakeLabel(
        toast,
        message or "",
        UDim2.new(1, -20, 0, 30),
        UDim2.fromOffset(13, 35),
        self.Theme.Muted
    )

    Tween(toast, {
        Position = UDim2.new(1, -265, 1, -95)
    })

    task.delay(duration or 3, function()
        if toast.Parent then
            Tween(toast, {
                Position = UDim2.new(1, 260, 1, -95)
            })

            task.wait(0.25)
            toast:Destroy()
        end
    end)
end

-- CREATE WINDOW
function KayUI:CreateWindow(config)
    config = config or {}

    local theme = self.Themes[config.Theme or "Blue"]
        or self.Themes.Blue

    self.Theme = theme
    self.Tabs = {}

    local gui = Create("ScreenGui", {
        Name = "KayUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    }, Player:WaitForChild("PlayerGui"))

    self.Gui = gui

    local main = Create("Frame", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(
            config.Width or 540,
            config.Height or 370
        ),
        BackgroundColor3 = theme.Background,
        BorderSizePixel = 0
    }, gui)

    self.Main = main

    Corner(main, 14)
    Stroke(main)

    local scale = Create("UIScale", {
        Scale = 1
    }, main)

    local function UpdateScale()
        local camera = workspace.CurrentCamera
        if not camera then return end

        local viewport = camera.ViewportSize

        scale.Scale = math.clamp(
            math.min(viewport.X / 580, viewport.Y / 430),
            0.5,
            1
        )
    end

    UpdateScale()

    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal(
            "ViewportSize"
        ):Connect(UpdateScale)
    end

    -- HEADER
    local header = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 55),
        BackgroundColor3 = theme.Sidebar,
        BorderSizePixel = 0
    }, main)

    Corner(header, 14)

    MakeLabel(
        header,
        config.Name or "KAYUI",
        UDim2.new(0, 300, 0, 28),
        UDim2.fromOffset(15, 5),
        theme.Text
    ).TextSize = 18

    MakeLabel(
        header,
        "Version " .. self.Version,
        UDim2.new(0, 200, 0, 16),
        UDim2.fromOffset(17, 32),
        theme.Muted
    ).TextSize = 9

    
-- CLOSE / REOPEN SYSTEM

local close = Create("TextButton", {
    Size = UDim2.fromOffset(35, 32),
    Position = UDim2.new(1, -43, 0, 11),
    BackgroundColor3 = theme.Card,
    Text = "×",
    TextColor3 = theme.Text,
    TextSize = 20,
    Font = Enum.Font.GothamBold
}, header)

Corner(close, 8)

local reopen = Create("TextButton", {
    Name = "KUI_Reopen",
    Size = UDim2.fromOffset(55, 55),
    Position = UDim2.new(0, 18, 0.5, 0),
    AnchorPoint = Vector2.new(0, 0.5),
    BackgroundColor3 = theme.Accent,
    Text = "KUI",
    TextColor3 = Color3.new(1, 1, 1),
    TextSize = 16,
    Font = Enum.Font.GothamBlack,
    Visible = false,
    AutoButtonColor = false
}, gui)

Corner(reopen, 18)
Stroke(reopen, theme.Accent)

close.Activated:Connect(function()
    Tween(main, {
        Size = UDim2.fromOffset(0, 0)
    }, 0.15)

    task.wait(0.15)

    main.Visible = false
    main.Size = UDim2.fromOffset(
        config.Width or 540,
        config.Height or 370
    )

    reopen.Visible = true
end)

reopen.Activated:Connect(function()
    reopen.Visible = false
    main.Visible = true

    main.Size = UDim2.fromOffset(0, 0)

    Tween(main, {
        Size = UDim2.fromOffset(
            config.Width or 540,
            config.Height or 370
        )
    }, 0.2)
end)


    -- SIDEBAR
    local sidebar = Create("Frame", {
        Position = UDim2.fromOffset(10, 65),
        Size = UDim2.new(0, 140, 1, -75),
        BackgroundColor3 = theme.Sidebar,
        BorderSizePixel = 0
    }, main)

    Corner(sidebar, 10)

    local sideLayout = Create("UIListLayout", {
        Padding = UDim.new(0, 7),
        SortOrder = Enum.SortOrder.LayoutOrder
    }, sidebar)

    Create("UIPadding", {
        PaddingTop = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 6),
        PaddingRight = UDim.new(0, 6)
    }, sidebar)

    -- CONTENT
    local content = Create("Frame", {
        Position = UDim2.fromOffset(160, 65),
        Size = UDim2.new(1, -170, 1, -75),
        BackgroundTransparency = 1
    }, main)

    self.Content = content
    self.Sidebar = sidebar

    -- DRAG
    local dragging = false
    local dragStart
    local startPosition

    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPosition = main.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if dragging and (
            input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseMovement
        ) then
            local delta = input.Position - dragStart

            main.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

-- DROPDOWN

function tab:AddDropdown(config)
    config = config or {}

    local options = config.Options or {}
    local selected = config.Default or options[1]
    local opened = false
    local optionButtons = {}

    local frame = Create("Frame", {
        Size = UDim2.new(1, -5, 0, 43),
        BackgroundColor3 = theme.Card,
        ClipsDescendants = true
    }, page)

    Corner(frame, 9)
    Stroke(frame)

    local mainButton = Create("TextButton", {
        Size = UDim2.new(1, 0, 0, 43),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor = false
    }, frame)

    local title = MakeLabel(
        mainButton,
        config.Name or "Dropdown",
        UDim2.new(0.55, 0, 1, 0),
        UDim2.fromOffset(12, 0),
        theme.Text
    )

    local valueLabel = MakeLabel(
        mainButton,
        tostring(selected or "Selecionar"),
        UDim2.new(0.35, 0, 1, 0),
        UDim2.new(0.58, 0, 0, 0),
        theme.Accent
    )

    valueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local arrow = MakeLabel(
        mainButton,
        "⌄",
        UDim2.fromOffset(20, 40),
        UDim2.new(1, -25, 0, 0),
        theme.Muted
    )

    arrow.TextXAlignment = Enum.TextXAlignment.Center

    local function UpdateSize()
        local height = 43

        if opened then
            height = 43 + (#options * 34)
        end

        Tween(frame, {
            Size = UDim2.new(1, -5, 0, height)
        })
    end

    local function Select(option)
        selected = option
        valueLabel.Text = tostring(option)

        if config.Callback then
            task.spawn(config.Callback, option)
        end

        opened = false
        arrow.Text = "⌄"
        UpdateSize()
    end

    for index, option in ipairs(options) do
        local optionButton = Create("TextButton", {
            Size = UDim2.new(1, -12, 0, 30),
            Position = UDim2.fromOffset(6, 43 + ((index - 1) * 34)),
            BackgroundColor3 = theme.Sidebar,
            Text = tostring(option),
            TextColor3 = theme.Text,
            TextSize = 11,
            Font = Enum.Font.GothamMedium,
            AutoButtonColor = false
        }, frame)

        Corner(optionButton, 7)

        optionButton.Activated:Connect(function()
            Select(option)
        end)

        table.insert(optionButtons, optionButton)
    end

    mainButton.Activated:Connect(function()
        opened = not opened
        arrow.Text = opened and "⌃" or "⌄"
        UpdateSize()
    end)

    return {
        Get = function()
            return selected
        end,

        Set = function(value)
            for _, option in ipairs(options) do
                if option == value then
                    Select(value)
                    return
                end
            end
        end
    }
end

-- KEYBIND

function tab:AddKeybind(config)
    config = config or {}

    local currentKey = config.Default or Enum.KeyCode.Unknown
    local listening = false

    local frame = Create("Frame", {
        Size = UDim2.new(1, -5, 0, 46),
        BackgroundColor3 = theme.Card
    }, page)

    Corner(frame, 9)
    Stroke(frame)

    MakeLabel(
        frame,
        config.Name or "Keybind",
        UDim2.new(0.55, 0, 1, 0),
        UDim2.fromOffset(12, 0),
        theme.Text
    )

    local bindButton = Create("TextButton", {
        Size = UDim2.fromOffset(105, 30),
        Position = UDim2.new(1, -115, 0.5, -15),
        BackgroundColor3 = theme.Sidebar,
        Text = currentKey.Name,
        TextColor3 = theme.Accent,
        TextSize = 11,
        Font = Enum.Font.GothamBold,
        AutoButtonColor = false
    }, frame)

    Corner(bindButton, 7)

    bindButton.Activated:Connect(function()
        listening = true
        bindButton.Text = "..."
    end)

    local connection

    connection = UIS.InputBegan:Connect(function(input, processed)
        if not listening then
            if not processed
            and input.UserInputType == Enum.UserInputType.Keyboard
            and input.KeyCode == currentKey then

                if config.Callback then
                    task.spawn(config.Callback)
                end
            end

            return
        end

        if input.UserInputType == Enum.UserInputType.Keyboard then
            currentKey = input.KeyCode
            bindButton.Text = currentKey.Name
            listening = false
        end
    end)

    return {
        Get = function()
            return currentKey
        end,

        Set = function(key)
            if typeof(key) == "EnumItem"
            and key.EnumType == Enum.KeyCode then
                currentKey = key
                bindButton.Text = key.Name
            end
        end,

        Destroy = function()
            if connection then
                connection:Disconnect()
            end

            frame:Destroy()
        end
    }
    end
    
    
    -- WINDOW OBJECT
    local window = self

    function window:CreateTab(name)
        local tab = {}

        local page = Create("ScrollingFrame", {
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            CanvasSize = UDim2.new(),
            Visible = false
        }, content)

        local layout = Create("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder
        }, page)

        Create("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 5)
        }, page)

        layout:GetPropertyChangedSignal(
            "AbsoluteContentSize"
        ):Connect(function()
            page.CanvasSize = UDim2.fromOffset(
                0,
                layout.AbsoluteContentSize.Y + 15
            )
        end)

        local tabButton = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundColor3 = theme.Card,
            BackgroundTransparency = 1,
            Text = name or "Tab",
            TextColor3 = theme.Muted,
            TextSize = 12,
            Font = Enum.Font.GothamMedium
        }, sidebar)

        Corner(tabButton, 8)

        local entry = {
            Page = page,
            Button = tabButton
        }

        table.insert(window.Tabs, entry)

        local function SelectTab()
            for _, item in ipairs(window.Tabs) do
                item.Page.Visible = false
                item.Button.BackgroundTransparency = 1
                item.Button.TextColor3 = theme.Muted
            end

            page.Visible = true
            Tween(tabButton, {
                BackgroundTransparency = 0,
                BackgroundColor3 = theme.Accent,
                TextColor3 = Color3.new(1, 1, 1)
            })
        end

        tabButton.Activated:Connect(SelectTab)

        if #window.Tabs == 1 then
            SelectTab()
        end

        -- SECTION
        function tab:AddSection(text)
            local label = MakeLabel(
                page,
                string.upper(text or "SECTION"),
                UDim2.new(1, -10, 0, 25),
                UDim2.new(),
                theme.Accent
            )

            label.Font = Enum.Font.GothamBold
            return label
        end

        -- LABEL
        function tab:AddLabel(text)
            return MakeLabel(
                page,
                text or "",
                UDim2.new(1, -10, 0, 35),
                UDim2.new(),
                theme.Muted
            )
        end

        -- BUTTON
        function tab:AddButton(config)
            config = config or {}

            local button = Create("TextButton", {
                Size = UDim2.new(1, -5, 0, 43),
                BackgroundColor3 = theme.Card,
                Text = config.Name or "Button",
                TextColor3 = theme.Text,
                TextSize = 12,
                Font = Enum.Font.GothamMedium,
                AutoButtonColor = false
            }, page)

            Corner(button, 9)
            Stroke(button)

            button.Activated:Connect(function()
                Tween(button, {
                    BackgroundColor3 = theme.Accent
                })

                if config.Callback then
                    task.spawn(config.Callback)
                end

                task.delay(0.2, function()
                    if button.Parent then
                        Tween(button, {
                            BackgroundColor3 = theme.Card
                        })
                    end
                end)
            end)

            return button
        end

        -- TOGGLE
        function tab:AddToggle(config)
            config = config or {}

            local value = config.Default == true

            local frame = Create("Frame", {
                Size = UDim2.new(1, -5, 0, 46),
                BackgroundColor3 = theme.Card
            }, page)

            Corner(frame, 9)
            Stroke(frame)

            MakeLabel(
                frame,
                config.Name or "Toggle",
                UDim2.new(1, -70, 1, 0),
                UDim2.fromOffset(12, 0),
                theme.Text
            )

            local switch = Create("TextButton", {
                Size = UDim2.fromOffset(42, 22),
                Position = UDim2.new(1, -53, 0.5, -11),
                BackgroundColor3 = value and theme.Accent or theme.Stroke,
                Text = "",
                AutoButtonColor = false
            }, frame)

            Corner(switch, 20)

            local dot = Create("Frame", {
                Size = UDim2.fromOffset(16, 16),
                Position = UDim2.new(0, value and 23 or 3, 0.5, -8),
                BackgroundColor3 = Color3.new(1, 1, 1)
            }, switch)

            Corner(dot, 20)

            local function Set(newValue)
                value = newValue == true

                Tween(switch, {
                    BackgroundColor3 = value and theme.Accent or theme.Stroke
                })

                Tween(dot, {
                    Position = UDim2.new(
                        0,
                        value and 23 or 3,
                        0.5,
                        -8
                    )
                })

                if config.Callback then
                    config.Callback(value)
                end
            end

            switch.Activated:Connect(function()
                Set(not value)
            end)

            return {
                Set = Set,
                Get = function()
                    return value
                end
            }
        end

        -- SLIDER
        function tab:AddSlider(config)
            config = config or {}

            local minimum = config.Min or 0
            local maximum = config.Max or 100
            local value = math.clamp(
                config.Default or minimum,
                minimum,
                maximum
            )

            local frame = Create("Frame", {
                Size = UDim2.new(1, -5, 0, 65),
                BackgroundColor3 = theme.Card
            }, page)

            Corner(frame, 9)
            Stroke(frame)

            local title = MakeLabel(
                frame,
                "",
                UDim2.new(1, -20, 0, 22),
                UDim2.fromOffset(12, 4),
                theme.Text
            )

            local bar = Create("Frame", {
                Position = UDim2.fromOffset(12, 43),
                Size = UDim2.new(1, -24, 0, 6),
                BackgroundColor3 = theme.Stroke
            }, frame)

            Corner(bar, 10)

            local fill = Create("Frame", {
                Size = UDim2.new(0, 0, 1, 0),
                BackgroundColor3 = theme.Accent
            }, bar)

            Corner(fill, 10)

            local hitbox = Create("TextButton", {
                Position = UDim2.fromOffset(0, 28),
                Size = UDim2.new(1, 0, 0, 35),
                BackgroundTransparency = 1,
                Text = ""
            }, frame)

            local function Set(newValue)
                value = math.clamp(newValue, minimum, maximum)

                local percent = (value - minimum) /
                    math.max(maximum - minimum, 1)

                fill.Size = UDim2.new(percent, 0, 1, 0)

                title.Text = (config.Name or "Slider")
                    .. "   " .. tostring(value)

                if config.Callback then
                    config.Callback(value)
                end
            end

            local function Update(x)
                local percent = math.clamp(
                    (x - bar.AbsolutePosition.X) /
                    math.max(bar.AbsoluteSize.X, 1),
                    0,
                    1
                )

                Set(math.floor(
                    minimum + (maximum - minimum) * percent
                ))
            end

            local active = false

            hitbox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch
                or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    active = true
                    Update(input.Position.X)
                end
            end)

            UIS.InputChanged:Connect(function(input)
                if active and (
                    input.UserInputType == Enum.UserInputType.Touch
                    or input.UserInputType == Enum.UserInputType.MouseMovement
                ) then
                    Update(input.Position.X)
                end
            end)

            UIS.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch
                or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    active = false
                end
            end)

            Set(value)

            return {
                Set = Set,
                Get = function()
                    return value
                end
            }
        end

        return tab
    end

    self:Notify("KAYUI", "Biblioteca carregada!", 3)

    return self
end

return KayUI
