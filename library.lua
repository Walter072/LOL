--[[
  LOL Hub UI Library — Dollarware-inspired
  API: CreateWindow / CreateTab / CreateSection / Toggle, Slider, Button, Textbox, Label, Notify
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local LOL = {}
LOL.__index = LOL
LOL.Version = "1.1.0-dw"

-- Dollarware-like cherry palette
local T = {
    primary = Color3.fromRGB(249, 22, 52),
    secondary = Color3.fromRGB(247, 22, 149),
    win1 = Color3.fromRGB(11, 11, 11),
    win2 = Color3.fromRGB(5, 5, 5),
    win3 = Color3.fromRGB(8, 8, 8),
    btn1 = Color3.fromRGB(12, 12, 12),
    btn2 = Color3.fromRGB(15, 15, 15),
    btn3 = Color3.fromRGB(21, 21, 21),
    stroke = Color3.fromRGB(30, 30, 30),
    strokeHover = Color3.fromRGB(83, 23, 31),
    text = Color3.fromRGB(255, 255, 255),
    dim = Color3.fromRGB(164, 164, 164),
    toggleOn = Color3.fromRGB(249, 22, 52),
    toggleOff = Color3.fromRGB(40, 40, 40),
    barBg = Color3.fromRGB(20, 20, 20),
}

local function tween(o, props, t)
    local tw = TweenService:Create(o, TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end

local function stroke(p, col, th)
    local s = Instance.new("UIStroke")
    s.Color = col or T.stroke
    s.Thickness = th or 1
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = p
    return s
end

local function pad(p, l, t, r, b)
    local x = Instance.new("UIPadding")
    x.PaddingLeft = UDim.new(0, l or 0)
    x.PaddingTop = UDim.new(0, t or 0)
    x.PaddingRight = UDim.new(0, r or 0)
    x.PaddingBottom = UDim.new(0, b or 0)
    x.Parent = p
end

function LOL:Notify(opts)
    opts = opts or {}
    local title = opts.Title or opts.title or "LOL Hub"
    local msg = opts.Content or opts.message or ""
    local dur = opts.Duration or opts.duration or 3

    if not self._notifHost then
        local host = Instance.new("Frame")
        host.Size = UDim2.fromOffset(220, 400)
        host.Position = UDim2.new(1, -230, 1, -20)
        host.AnchorPoint = Vector2.new(0, 1)
        host.BackgroundTransparency = 1
        host.Parent = self._gui
        local lay = Instance.new("UIListLayout")
        lay.VerticalAlignment = Enum.VerticalAlignment.Bottom
        lay.Padding = UDim.new(0, 8)
        lay.Parent = host
        self._notifHost = host
    end

    local f = Instance.new("Frame")
    f.Size = UDim2.fromOffset(210, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = T.win2
    f.BorderSizePixel = 0
    f.Parent = self._notifHost
    stroke(f, T.primary, 1)

    local trim = Instance.new("Frame")
    trim.Size = UDim2.new(1, 0, 0, 1)
    trim.BackgroundColor3 = T.primary
    trim.BorderSizePixel = 0
    trim.Parent = f

    local ttl = Instance.new("TextLabel")
    ttl.Size = UDim2.new(1, -10, 0, 18)
    ttl.Position = UDim2.fromOffset(6, 6)
    ttl.BackgroundTransparency = 1
    ttl.Font = Enum.Font.SourceSans
    ttl.TextSize = 14
    ttl.TextColor3 = T.text
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ttl.Text = title
    ttl.Parent = f

    local body = Instance.new("TextLabel")
    body.Size = UDim2.new(1, -10, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.Position = UDim2.fromOffset(6, 24)
    body.BackgroundTransparency = 1
    body.Font = Enum.Font.SourceSans
    body.TextSize = 13
    body.TextColor3 = T.dim
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextWrapped = true
    body.Text = msg
    body.Parent = f
    pad(f, 0, 0, 0, 8)

    task.delay(dur, function()
        if f.Parent then f:Destroy() end
    end)
end

function LOL:CreateWindow(opts)
    opts = opts or {}
    local name = opts.Name or opts.name or "LOL Hub"

    local old = PlayerGui:FindFirstChild("LOLHubLib")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "LOLHubLib"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 100
    gui.Parent = PlayerGui
    self._gui = gui

    local winW = opts.Width or 550
    local winH = opts.Height or 376

    local win = Instance.new("Frame")
    win.Name = "Window"
    win.Size = UDim2.fromOffset(winW, winH)
    win.Position = UDim2.fromScale(0.5, 0.5)
    win.AnchorPoint = Vector2.new(0.5, 0.5)
    win.BackgroundColor3 = T.win2
    win.BorderSizePixel = 0
    win.Parent = gui
    stroke(win, T.primary, 1)

    -- top accent line (Dollarware style)
    local topLine = Instance.new("Frame")
    topLine.Size = UDim2.new(1, 0, 0, 1)
    topLine.BackgroundColor3 = T.primary
    topLine.BorderSizePixel = 0
    topLine.ZIndex = 5
    topLine.Parent = win

    -- title bar
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 26)
    titleBar.BackgroundColor3 = T.win1
    titleBar.BorderSizePixel = 0
    titleBar.Parent = win
    stroke(titleBar, T.stroke, 1)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.fromOffset(8, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.SourceSans
    title.TextSize = 14
    title.TextColor3 = T.text
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = name
    title.Parent = titleBar

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(22, 18)
    closeBtn.Position = UDim2.new(1, -26, 0.5, -9)
    closeBtn.BackgroundColor3 = T.btn1
    closeBtn.BorderSizePixel = 0
    closeBtn.Font = Enum.Font.SourceSans
    closeBtn.TextSize = 14
    closeBtn.TextColor3 = T.text
    closeBtn.Text = "X"
    closeBtn.Parent = titleBar
    stroke(closeBtn, T.stroke, 1)
    closeBtn.MouseButton1Click:Connect(function()
        gui:Destroy()
    end)

    -- drag
    do
        local dragging, start, startPos
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                start = input.Position
                startPos = win.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement then
                local d = input.Position - start
                win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    -- sidebar (menus)
    local side = Instance.new("Frame")
    side.Size = UDim2.new(0, 100, 1, -26)
    side.Position = UDim2.fromOffset(0, 26)
    side.BackgroundColor3 = T.win3
    side.BorderSizePixel = 0
    side.Parent = win
    stroke(side, T.stroke, 1)

    local sideScroll = Instance.new("ScrollingFrame")
    sideScroll.Size = UDim2.new(1, -4, 1, -8)
    sideScroll.Position = UDim2.fromOffset(2, 4)
    sideScroll.BackgroundTransparency = 1
    sideScroll.BorderSizePixel = 0
    sideScroll.ScrollBarThickness = 2
    sideScroll.ScrollBarImageColor3 = T.primary
    sideScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sideScroll.CanvasSize = UDim2.new()
    sideScroll.Parent = side
    local sideLay = Instance.new("UIListLayout")
    sideLay.Padding = UDim.new(0, 2)
    sideLay.Parent = sideScroll

    -- content area (two columns feel)
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -104, 1, -30)
    content.Position = UDim2.fromOffset(102, 28)
    content.BackgroundColor3 = T.win2
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = T.primary
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.CanvasSize = UDim2.new()
    content.Parent = win
    local contentLay = Instance.new("UIListLayout")
    contentLay.FillDirection = Enum.FillDirection.Horizontal
    contentLay.SortOrder = Enum.SortOrder.LayoutOrder
    contentLay.Padding = UDim.new(0, 6)
    contentLay.Parent = content
    pad(content, 6, 4, 6, 6)

    local Window = {
        _lol = self,
        _win = win,
        _content = content,
        _sideScroll = sideScroll,
        _tabs = {},
        _builders = {},
        _first = nil,
    }

    local function clearContent()
        for _, ch in ipairs(content:GetChildren()) do
            if not ch:IsA("UIListLayout") and not ch:IsA("UIPadding") then
                ch:Destroy()
            end
        end
    end

    function Window:SelectTab(tabName)
        for n, btn in pairs(self._tabs) do
            local on = n == tabName
            btn.TextColor3 = on and T.primary or T.dim
            btn.BackgroundColor3 = on and T.btn2 or T.win3
        end
        clearContent()
        if self._builders[tabName] then
            self._builders[tabName]()
        end
    end

    function Window:CreateTab(tOpts)
        tOpts = tOpts or {}
        local tabName = tOpts.Name or tOpts.name or "Tab"
        local sections = {}

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -2, 0, 22)
        btn.BackgroundColor3 = T.win3
        btn.BorderSizePixel = 0
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 14
        btn.TextColor3 = T.dim
        btn.Text = tabName
        btn.Parent = sideScroll
        stroke(btn, T.stroke, 1)
        self._tabs[tabName] = btn

        self._builders[tabName] = function()
            for _, build in ipairs(sections) do
                build()
            end
        end

        btn.MouseButton1Click:Connect(function()
            self:SelectTab(tabName)
        end)

        local Tab = {}

        function Tab:CreateSection(sOpts)
            sOpts = sOpts or {}
            local secName = sOpts.Name or sOpts.name or "section"
            local sidePref = sOpts.Side or sOpts.side -- "left" | "right" | nil
            local controls = {}

            table.insert(sections, function()
                local col = Instance.new("Frame")
                col.Size = UDim2.new(0.5, -4, 0, 0)
                col.AutomaticSize = Enum.AutomaticSize.Y
                col.BackgroundColor3 = T.win2
                col.BorderSizePixel = 0
                col.LayoutOrder = (sidePref == "right") and 2 or 1
                col.Parent = content
                stroke(col, T.stroke, 1)

                local header = Instance.new("Frame")
                header.Size = UDim2.new(1, 0, 0, 18)
                header.BackgroundColor3 = T.win3
                header.BorderSizePixel = 0
                header.Parent = col
                stroke(header, T.stroke, 1)

                local hLab = Instance.new("TextLabel")
                hLab.Size = UDim2.fromScale(1, 1)
                hLab.BackgroundTransparency = 1
                hLab.Font = Enum.Font.SourceSans
                hLab.TextSize = 13
                hLab.TextColor3 = T.dim
                hLab.TextXAlignment = Enum.TextXAlignment.Left
                hLab.Text = secName
                hLab.Parent = header
                pad(hLab, 6, 0, 0, 0)

                local body = Instance.new("Frame")
                body.Size = UDim2.new(1, 0, 0, 0)
                body.AutomaticSize = Enum.AutomaticSize.Y
                body.Position = UDim2.fromOffset(0, 18)
                body.BackgroundTransparency = 1
                body.Parent = col
                local bodyLay = Instance.new("UIListLayout")
                bodyLay.Padding = UDim.new(0, 2)
                bodyLay.Parent = body
                pad(body, 4, 4, 4, 6)

                for _, add in ipairs(controls) do
                    add(body)
                end
            end)

            local Section = {}

            function Section:CreateToggle(c)
                c = c or {}
                table.insert(controls, function(parent)
                    local row = Instance.new("Frame")
                    row.Size = UDim2.new(1, 0, 0, 20)
                    row.BackgroundTransparency = 1
                    row.Parent = parent
                    local state = c.CurrentValue or c.state or false

                    local lab = Instance.new("TextLabel")
                    lab.Size = UDim2.new(1, -28, 1, 0)
                    lab.BackgroundTransparency = 1
                    lab.Font = Enum.Font.SourceSans
                    lab.TextSize = 14
                    lab.TextColor3 = T.text
                    lab.TextXAlignment = Enum.TextXAlignment.Left
                    lab.Text = c.Name or c.text or "toggle"
                    lab.Parent = row

                    local box = Instance.new("TextButton")
                    box.Size = UDim2.fromOffset(16, 16)
                    box.Position = UDim2.new(1, -18, 0.5, -8)
                    box.BackgroundColor3 = T.btn1
                    box.BorderSizePixel = 0
                    box.Font = Enum.Font.SourceSansBold
                    box.TextSize = 12
                    box.TextColor3 = T.primary
                    box.Text = state and "X" or ""
                    box.Parent = row
                    stroke(box, T.stroke, 1)

                    box.MouseButton1Click:Connect(function()
                        state = not state
                        box.Text = state and "X" or ""
                        stroke(box, state and T.primary or T.stroke, 1)
                        if c.Callback then c.Callback(state) end
                    end)
                end)
                return Section
            end

            function Section:CreateSlider(c)
                c = c or {}
                table.insert(controls, function(parent)
                    local min = c.Range and c.Range[1] or c.min or 0
                    local max = c.Range and c.Range[2] or c.max or 100
                    local value = c.CurrentValue or c.val or min

                    local row = Instance.new("Frame")
                    row.Size = UDim2.new(1, 0, 0, 20)
                    row.BackgroundTransparency = 1
                    row.Parent = parent

                    local lab = Instance.new("TextLabel")
                    lab.Size = UDim2.new(0.45, 0, 1, 0)
                    lab.BackgroundTransparency = 1
                    lab.Font = Enum.Font.SourceSans
                    lab.TextSize = 14
                    lab.TextColor3 = T.text
                    lab.TextXAlignment = Enum.TextXAlignment.Left
                    lab.Text = c.Name or "slider"
                    lab.Parent = row

                    local valLab = Instance.new("TextLabel")
                    valLab.Size = UDim2.new(0.2, 0, 1, 0)
                    valLab.Position = UDim2.fromScale(0.8, 0)
                    valLab.BackgroundTransparency = 1
                    valLab.Font = Enum.Font.SourceSans
                    valLab.TextSize = 13
                    valLab.TextColor3 = T.dim
                    valLab.TextXAlignment = Enum.TextXAlignment.Right
                    valLab.Text = string.format("%.0f", value)
                    valLab.Parent = row

                    local barBg = Instance.new("Frame")
                    barBg.Size = UDim2.new(0.32, 0, 0, 6)
                    barBg.Position = UDim2.new(0.45, 0, 0.5, -3)
                    barBg.BackgroundColor3 = T.barBg
                    barBg.BorderSizePixel = 0
                    barBg.Parent = row
                    stroke(barBg, T.stroke, 1)

                    local fill = Instance.new("Frame")
                    fill.Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0)
                    fill.BackgroundColor3 = T.primary
                    fill.BorderSizePixel = 0
                    fill.Parent = barBg

                    local drag = false
                    local function apply(v)
                        value = math.clamp(math.floor(v + 0.5), min, max)
                        fill.Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0)
                        valLab.Text = tostring(value)
                        if c.Callback then c.Callback(value) end
                    end
                    barBg.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            drag = true
                            local rel = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / math.max(barBg.AbsoluteSize.X, 1), 0, 1)
                            apply(min + (max - min) * rel)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
                    end)
                    UserInputService.InputChanged:Connect(function(input)
                        if not drag then return end
                        if input.UserInputType == Enum.UserInputType.MouseMovement then
                            local rel = math.clamp((input.Position.X - barBg.AbsolutePosition.X) / math.max(barBg.AbsoluteSize.X, 1), 0, 1)
                            apply(min + (max - min) * rel)
                        end
                    end)
                end)
                return Section
            end

            function Section:CreateButton(c)
                c = c or {}
                table.insert(controls, function(parent)
                    local style = c.Style or c.style or "small"
                    if style == "large" then
                        local b = Instance.new("TextButton")
                        b.Size = UDim2.new(1, 0, 0, 22)
                        b.BackgroundColor3 = T.btn1
                        b.BorderSizePixel = 0
                        b.Font = Enum.Font.SourceSans
                        b.TextSize = 14
                        b.TextColor3 = T.text
                        b.Text = c.Name or c.text or "button"
                        b.Parent = parent
                        stroke(b, T.stroke, 1)
                        b.MouseEnter:Connect(function()
                            b.BackgroundColor3 = T.btn3
                            stroke(b, T.strokeHover, 1)
                        end)
                        b.MouseLeave:Connect(function()
                            b.BackgroundColor3 = T.btn1
                            stroke(b, T.stroke, 1)
                        end)
                        b.MouseButton1Click:Connect(function()
                            if c.Callback then c.Callback() end
                        end)
                    else
                        local row = Instance.new("Frame")
                        row.Size = UDim2.new(1, 0, 0, 20)
                        row.BackgroundTransparency = 1
                        row.Parent = parent
                        local lab = Instance.new("TextLabel")
                        lab.Size = UDim2.new(1, -24, 1, 0)
                        lab.BackgroundTransparency = 1
                        lab.Font = Enum.Font.SourceSans
                        lab.TextSize = 14
                        lab.TextColor3 = T.text
                        lab.TextXAlignment = Enum.TextXAlignment.Left
                        lab.Text = c.Name or c.text or "button"
                        lab.Parent = row
                        local dot = Instance.new("TextButton")
                        dot.Size = UDim2.fromOffset(14, 14)
                        dot.Position = UDim2.new(1, -16, 0.5, -7)
                        dot.BackgroundColor3 = T.btn1
                        dot.BorderSizePixel = 0
                        dot.Text = ""
                        dot.Parent = row
                        stroke(dot, T.stroke, 1)
                        local inner = Instance.new("Frame")
                        inner.Size = UDim2.fromOffset(6, 6)
                        inner.Position = UDim2.fromScale(0.5, 0.5)
                        inner.AnchorPoint = Vector2.new(0.5, 0.5)
                        inner.BackgroundColor3 = T.dim
                        inner.BorderSizePixel = 0
                        inner.Parent = dot
                        dot.MouseButton1Click:Connect(function()
                            if c.Callback then c.Callback() end
                        end)
                    end
                end)
                return Section
            end

            function Section:CreateTextbox(c)
                c = c or {}
                table.insert(controls, function(parent)
                    local row = Instance.new("Frame")
                    row.Size = UDim2.new(1, 0, 0, 20)
                    row.BackgroundTransparency = 1
                    row.Parent = parent
                    local lab = Instance.new("TextLabel")
                    lab.Size = UDim2.new(0.4, 0, 1, 0)
                    lab.BackgroundTransparency = 1
                    lab.Font = Enum.Font.SourceSans
                    lab.TextSize = 14
                    lab.TextColor3 = T.text
                    lab.TextXAlignment = Enum.TextXAlignment.Left
                    lab.Text = c.Name or c.text or "textbox"
                    lab.Parent = row
                    local box = Instance.new("TextBox")
                    box.Size = UDim2.new(0.58, 0, 0, 16)
                    box.Position = UDim2.new(0.42, 0, 0.5, -8)
                    box.BackgroundColor3 = T.btn1
                    box.BorderSizePixel = 0
                    box.Font = Enum.Font.SourceSans
                    box.TextSize = 13
                    box.TextColor3 = T.text
                    box.PlaceholderColor3 = T.dim
                    box.PlaceholderText = c.PlaceholderText or ""
                    box.Text = c.CurrentValue or ""
                    box.ClearTextOnFocus = false
                    box.Parent = row
                    stroke(box, T.stroke, 1)
                    box.FocusLost:Connect(function()
                        if c.Callback then c.Callback(box.Text) end
                    end)
                end)
                return Section
            end

            function Section:CreateLabel(c)
                c = c or {}
                table.insert(controls, function(parent)
                    local lab = Instance.new("TextLabel")
                    lab.Size = UDim2.new(1, 0, 0, 18)
                    lab.BackgroundTransparency = 1
                    lab.Font = Enum.Font.SourceSans
                    lab.TextSize = 14
                    lab.TextColor3 = T.dim
                    lab.TextXAlignment = Enum.TextXAlignment.Left
                    lab.Text = c.Name or c.text or ""
                    lab.Parent = parent
                end)
                return Section
            end

            return Section
        end

        if not self._first then
            self._first = tabName
            task.defer(function()
                self:SelectTab(tabName)
            end)
        end

        return Tab
    end

    function Window:Destroy()
        gui:Destroy()
    end

    return Window
end

return setmetatable({}, LOL)
