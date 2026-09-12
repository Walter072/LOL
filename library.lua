--[[
  LOL Hub UI — Fusion polished
  Transparent bg · Open/Close fab · Animated show/hide · Settings-ready
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local LOL = { Version = "2.1" }
LOL.__index = LOL

local Themes = {
    lol = {
        bg = Color3.fromRGB(16, 18, 24),
        top = Color3.fromRGB(22, 24, 32),
        side = Color3.fromRGB(12, 13, 18),
        card = Color3.fromRGB(26, 28, 36),
        elev = Color3.fromRGB(34, 36, 46),
        stroke = Color3.fromRGB(60, 64, 78),
        accent = Color3.fromRGB(150, 30, 40),
        accent2 = Color3.fromRGB(230, 185, 55),
        text = Color3.fromRGB(245, 245, 250),
        dim = Color3.fromRGB(140, 145, 160),
        toggleOn = Color3.fromRGB(230, 185, 55),
        toggleOff = Color3.fromRGB(48, 50, 60),
        slider = Color3.fromRGB(150, 30, 40),
        tabOn = Color3.fromRGB(150, 30, 40),
        fab = Color3.fromRGB(150, 30, 40),
    },
    dollar = {
        bg = Color3.fromRGB(8, 8, 8),
        top = Color3.fromRGB(14, 14, 14),
        side = Color3.fromRGB(10, 10, 10),
        card = Color3.fromRGB(16, 16, 16),
        elev = Color3.fromRGB(22, 22, 22),
        stroke = Color3.fromRGB(40, 40, 40),
        accent = Color3.fromRGB(249, 22, 52),
        accent2 = Color3.fromRGB(255, 90, 140),
        text = Color3.fromRGB(255, 255, 255),
        dim = Color3.fromRGB(160, 160, 160),
        toggleOn = Color3.fromRGB(249, 22, 52),
        toggleOff = Color3.fromRGB(45, 45, 45),
        slider = Color3.fromRGB(249, 22, 52),
        tabOn = Color3.fromRGB(249, 22, 52),
        fab = Color3.fromRGB(249, 22, 52),
    },
    rayfield = {
        bg = Color3.fromRGB(22, 22, 26),
        top = Color3.fromRGB(30, 30, 36),
        side = Color3.fromRGB(26, 26, 30),
        card = Color3.fromRGB(32, 32, 38),
        elev = Color3.fromRGB(40, 40, 48),
        stroke = Color3.fromRGB(55, 55, 65),
        accent = Color3.fromRGB(50, 140, 220),
        accent2 = Color3.fromRGB(90, 180, 255),
        text = Color3.fromRGB(240, 240, 245),
        dim = Color3.fromRGB(150, 150, 160),
        toggleOn = Color3.fromRGB(0, 150, 220),
        toggleOff = Color3.fromRGB(70, 70, 80),
        slider = Color3.fromRGB(50, 140, 220),
        tabOn = Color3.fromRGB(50, 140, 220),
        fab = Color3.fromRGB(50, 140, 220),
    },
}

local function tween(obj, t, props, style)
    local info = TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, info, props)
    tw:Play()
    return tw
end
local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 10)
    c.Parent = p
end
local function stroke(p, col, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = col
    s.Thickness = th or 1
    s.Transparency = tr or 0
    s.Parent = p
    return s
end
local function pad(p, t, b, l, r)
    local x = Instance.new("UIPadding")
    x.PaddingTop = UDim.new(0, t or 0)
    x.PaddingBottom = UDim.new(0, b or 0)
    x.PaddingLeft = UDim.new(0, l or 0)
    x.PaddingRight = UDim.new(0, r or 0)
    x.Parent = p
end

function LOL:Notify(opts)
    opts = opts or {}
    local T = self._T
    if not T or not self._gui then return end
    local title = opts.Title or "LOL Hub"
    local content = opts.Content or ""
    local dur = opts.Duration or 3

    if not self._notifHost then
        local host = Instance.new("Frame")
        host.Size = UDim2.fromOffset(290, 500)
        host.Position = UDim2.new(1, -14, 1, -14)
        host.AnchorPoint = Vector2.new(1, 1)
        host.BackgroundTransparency = 1
        host.Parent = self._gui
        local lay = Instance.new("UIListLayout")
        lay.VerticalAlignment = Enum.VerticalAlignment.Bottom
        lay.Padding = UDim.new(0, 10)
        lay.Parent = host
        self._notifHost = host
    end

    local f = Instance.new("Frame")
    f.Size = UDim2.fromOffset(280, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = T.top
    f.BackgroundTransparency = 1
    f.Parent = self._notifHost
    corner(f, 12)
    local st = stroke(f, T.accent, 1.2, 1)

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 3, 1, -16)
    accentBar.Position = UDim2.fromOffset(10, 8)
    accentBar.BackgroundColor3 = T.accent2
    accentBar.BackgroundTransparency = 1
    accentBar.BorderSizePixel = 0
    accentBar.Parent = f
    corner(accentBar, 2)

    local ttl = Instance.new("TextLabel")
    ttl.Size = UDim2.new(1, -30, 0, 18)
    ttl.Position = UDim2.fromOffset(20, 12)
    ttl.BackgroundTransparency = 1
    ttl.Font = Enum.Font.GothamBold
    ttl.TextSize = 13
    ttl.TextColor3 = T.accent2
    ttl.TextTransparency = 1
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ttl.Text = title
    ttl.Parent = f

    local body = Instance.new("TextLabel")
    body.Size = UDim2.new(1, -30, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.Position = UDim2.fromOffset(20, 32)
    body.BackgroundTransparency = 1
    body.Font = Enum.Font.Gotham
    body.TextSize = 12
    body.TextColor3 = T.dim
    body.TextTransparency = 1
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextWrapped = true
    body.Text = content
    body.Parent = f
    pad(f, 0, 14, 0, 0)

    tween(f, 0.4, { BackgroundTransparency = 0.12 })
    tween(st, 0.4, { Transparency = 0.25 })
    tween(accentBar, 0.4, { BackgroundTransparency = 0 })
    tween(ttl, 0.4, { TextTransparency = 0 })
    tween(body, 0.4, { TextTransparency = 0 })

    task.delay(dur, function()
        if not f.Parent then return end
        tween(f, 0.28, { BackgroundTransparency = 1 })
        tween(st, 0.28, { Transparency = 1 })
        tween(ttl, 0.28, { TextTransparency = 1 })
        tween(body, 0.28, { TextTransparency = 1 })
        task.wait(0.3)
        f:Destroy()
    end)
end

function LOL:CreateWindow(opts)
    opts = opts or {}
    local themeName = opts.Theme or "lol"
    local T = Themes[themeName] or Themes.lol
    self._T = T

    local bgAlpha = opts.Transparency or 0.18 -- higher = more transparent window fill

    local old = PlayerGui:FindFirstChild("LOLHubLib")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "LOLHubLib"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 130
    gui.Parent = PlayerGui
    self._gui = gui

    local W, H = opts.Width or 560, opts.Height or 390

    -- ===== Floating open/close button (typical LOL) =====
    local fab = Instance.new("TextButton")
    fab.Name = "OpenBtn"
    fab.Size = UDim2.fromOffset(52, 52)
    fab.Position = UDim2.new(0, 18, 1, -70)
    fab.BackgroundColor3 = T.fab
    fab.BackgroundTransparency = 0.1
    fab.Font = Enum.Font.GothamBlack
    fab.TextSize = 13
    fab.TextColor3 = Color3.new(1, 1, 1)
    fab.Text = "LOL"
    fab.AutoButtonColor = false
    fab.Parent = gui
    corner(fab, 16)
    local fabStroke = stroke(fab, T.accent2, 1.5, 0.2)

    -- drag fab
    do
        local dragging, start, startPos
        fab.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                start = input.Position
                startPos = fab.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - start
                fab.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    fab.MouseEnter:Connect(function()
        tween(fab, 0.2, { Size = UDim2.fromOffset(56, 56), BackgroundTransparency = 0 })
    end)
    fab.MouseLeave:Connect(function()
        tween(fab, 0.2, { Size = UDim2.fromOffset(52, 52), BackgroundTransparency = 0.1 })
    end)

    -- ===== Window =====
    local win = Instance.new("Frame")
    win.Name = "Window"
    win.Size = UDim2.fromOffset(W, 0)
    win.Position = UDim2.fromScale(0.5, 0.5)
    win.AnchorPoint = Vector2.new(0.5, 0.5)
    win.BackgroundColor3 = T.bg
    win.BackgroundTransparency = 1
    win.ClipsDescendants = true
    win.Visible = false
    win.Parent = gui
    corner(win, 14)
    local winStroke = stroke(win, T.accent, 1.2, 1)

    local hubOpen = false
    local animating = false

    local function setOpen(open)
        if animating then return end
        animating = true
        hubOpen = open
        if open then
            win.Visible = true
            win.Size = UDim2.fromOffset(W, 0)
            win.BackgroundTransparency = 1
            winStroke.Transparency = 1
            tween(win, 0.35, {
                Size = UDim2.fromOffset(W, H),
                BackgroundTransparency = bgAlpha,
            }, Enum.EasingStyle.Quint)
            tween(winStroke, 0.35, { Transparency = 0.35 })
            tween(fab, 0.25, { BackgroundColor3 = T.accent2 })
            fab.Text = "—"
            task.delay(0.36, function() animating = false end)
        else
            tween(win, 0.28, {
                Size = UDim2.fromOffset(W, 0),
                BackgroundTransparency = 1,
            }, Enum.EasingStyle.Quint)
            tween(winStroke, 0.28, { Transparency = 1 })
            tween(fab, 0.25, { BackgroundColor3 = T.fab })
            fab.Text = "LOL"
            task.delay(0.3, function()
                win.Visible = false
                animating = false
            end)
        end
    end

    fab.MouseButton1Click:Connect(function()
        setOpen(not hubOpen)
    end)

    getgenv().__LOL_ToggleHub = function()
        setOpen(not hubOpen)
    end

    -- Title bar
    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 44)
    top.BackgroundColor3 = T.top
    top.BackgroundTransparency = 0.15
    top.Parent = win
    corner(top, 14)
    local topFix = Instance.new("Frame")
    topFix.Size = UDim2.new(1, 0, 0, 16)
    topFix.Position = UDim2.new(0, 0, 1, -16)
    topFix.BackgroundColor3 = T.top
    topFix.BackgroundTransparency = 0.15
    topFix.BorderSizePixel = 0
    topFix.Parent = top

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -80, 1, 0)
    title.Position = UDim2.fromOffset(16, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextColor3 = T.accent2
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = opts.Name or "LOL Hub"
    title.Parent = top

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.fromOffset(30, 30)
    closeBtn.Position = UDim2.new(1, -38, 0.5, -15)
    closeBtn.BackgroundColor3 = T.accent
    closeBtn.BackgroundTransparency = 0.15
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.TextColor3 = T.text
    closeBtn.Text = "X"
    closeBtn.Parent = top
    corner(closeBtn, 9)
    closeBtn.MouseButton1Click:Connect(function()
        setOpen(false)
    end)

    -- drag window
    do
        local dragging, start, startPos
        top.InputBegan:Connect(function(input)
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
            if not dragging or input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            local d = input.Position - start
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end)
    end

    -- Sidebar
    local side = Instance.new("Frame")
    side.Size = UDim2.new(0, 112, 1, -56)
    side.Position = UDim2.fromOffset(10, 50)
    side.BackgroundColor3 = T.side
    side.BackgroundTransparency = 0.2
    side.Parent = win
    corner(side, 12)
    stroke(side, T.stroke, 1, 0.45)

    local sideScroll = Instance.new("ScrollingFrame")
    sideScroll.Size = UDim2.new(1, -8, 1, -8)
    sideScroll.Position = UDim2.fromOffset(4, 4)
    sideScroll.BackgroundTransparency = 1
    sideScroll.BorderSizePixel = 0
    sideScroll.ScrollBarThickness = 2
    sideScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sideScroll.CanvasSize = UDim2.new()
    sideScroll.Parent = side
    local sideLay = Instance.new("UIListLayout")
    sideLay.Padding = UDim.new(0, 5)
    sideLay.Parent = sideScroll

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -136, 1, -60)
    content.Position = UDim2.fromOffset(128, 52)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = T.accent2
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.CanvasSize = UDim2.new()
    content.Parent = win
    local contentLay = Instance.new("UIListLayout")
    contentLay.Padding = UDim.new(0, 10)
    contentLay.SortOrder = Enum.SortOrder.LayoutOrder
    contentLay.Parent = content
    pad(content, 4, 10, 6, 8)

    local Window = { _tabs = {}, _builders = {}, _first = nil, _order = 0 }

    local function clear()
        Window._order = 0
        for _, ch in ipairs(content:GetChildren()) do
            if not ch:IsA("UIListLayout") and not ch:IsA("UIPadding") then ch:Destroy() end
        end
    end

    function Window:SelectTab(name)
        for n, btn in pairs(self._tabs) do
            local on = n == name
            tween(btn, 0.2, {
                BackgroundTransparency = on and 0.2 or 1,
                BackgroundColor3 = on and T.tabOn or T.side,
            })
            btn.TextColor3 = on and T.text or T.dim
        end
        clear()
        if self._builders[name] then self._builders[name]() end
    end

    function Window:CreateTab(o)
        o = o or {}
        local name = o.Name or "Tab"
        local sections = {}

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 0, 32)
        btn.BackgroundColor3 = T.tabOn
        btn.BackgroundTransparency = 1
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 12
        btn.TextColor3 = T.dim
        btn.Text = "  " .. name
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.Parent = sideScroll
        corner(btn, 9)
        self._tabs[name] = btn
        btn.MouseButton1Click:Connect(function() self:SelectTab(name) end)

        self._builders[name] = function()
            for _, b in ipairs(sections) do b() end
        end

        local Tab = {}
        function Tab:CreateSection(so)
            so = so or {}
            local secName = so.Name or "Section"
            local controls = {}

            table.insert(sections, function()
                Window._order += 1
                local lab = Instance.new("TextLabel")
                lab.LayoutOrder = Window._order
                lab.Size = UDim2.new(1, 0, 0, 16)
                lab.BackgroundTransparency = 1
                lab.Font = Enum.Font.GothamBold
                lab.TextSize = 11
                lab.TextColor3 = T.accent2
                lab.TextXAlignment = Enum.TextXAlignment.Left
                lab.Text = string.upper(secName)
                lab.Parent = content

                Window._order += 1
                local card = Instance.new("Frame")
                card.LayoutOrder = Window._order
                card.Size = UDim2.new(1, 0, 0, 0)
                card.AutomaticSize = Enum.AutomaticSize.Y
                card.BackgroundColor3 = T.card
                card.BackgroundTransparency = 0.2
                card.Parent = content
                corner(card, 12)
                stroke(card, T.stroke, 1, 0.4)
                local lay = Instance.new("UIListLayout")
                lay.Padding = UDim.new(0, 8)
                lay.Parent = card
                pad(card, 12, 12, 12, 12)

                for _, add in ipairs(controls) do add(card) end
            end)

            local Sec = {}

            function Sec:CreateToggle(c)
                c = c or {}
                table.insert(controls, function(parent)
                    local row = Instance.new("Frame")
                    row.Size = UDim2.new(1, 0, 0, 30)
                    row.BackgroundTransparency = 1
                    row.Parent = parent
                    local state = c.CurrentValue or false
                    local lab = Instance.new("TextLabel")
                    lab.Size = UDim2.new(1, -54, 1, 0)
                    lab.BackgroundTransparency = 1
                    lab.Font = Enum.Font.Gotham
                    lab.TextSize = 13
                    lab.TextColor3 = T.text
                    lab.TextXAlignment = Enum.TextXAlignment.Left
                    lab.Text = c.Name or "Toggle"
                    lab.Parent = row
                    local track = Instance.new("TextButton")
                    track.Size = UDim2.fromOffset(46, 26)
                    track.Position = UDim2.new(1, -46, 0.5, -13)
                    track.BackgroundColor3 = state and T.toggleOn or T.toggleOff
                    track.Text = ""
                    track.AutoButtonColor = false
                    track.Parent = row
                    corner(track, 13)
                    local knob = Instance.new("Frame")
                    knob.Size = UDim2.fromOffset(20, 20)
                    knob.Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
                    knob.BackgroundColor3 = Color3.new(1, 1, 1)
                    knob.Parent = track
                    corner(knob, 10)
                    track.MouseButton1Click:Connect(function()
                        state = not state
                        tween(track, 0.2, { BackgroundColor3 = state and T.toggleOn or T.toggleOff })
                        tween(knob, 0.2, {
                            Position = state and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10),
                        })
                        if c.Callback then c.Callback(state) end
                    end)
                end)
                return Sec
            end

            function Sec:CreateSlider(c)
                c = c or {}
                table.insert(controls, function(parent)
                    local min = c.Range and c.Range[1] or 0
                    local max = c.Range and c.Range[2] or 100
                    local value = c.CurrentValue or min
                    local wrap = Instance.new("Frame")
                    wrap.Size = UDim2.new(1, 0, 0, 46)
                    wrap.BackgroundTransparency = 1
                    wrap.Parent = parent
                    local titleL = Instance.new("TextLabel")
                    titleL.Size = UDim2.new(1, 0, 0, 16)
                    titleL.BackgroundTransparency = 1
                    titleL.Font = Enum.Font.Gotham
                    titleL.TextSize = 12
                    titleL.TextColor3 = T.text
                    titleL.TextXAlignment = Enum.TextXAlignment.Left
                    titleL.Text = (c.Name or "Slider") .. "  ·  " .. tostring(value)
                    titleL.Parent = wrap
                    local bg = Instance.new("Frame")
                    bg.Size = UDim2.new(1, 0, 0, 10)
                    bg.Position = UDim2.fromOffset(0, 26)
                    bg.BackgroundColor3 = T.elev
                    bg.BackgroundTransparency = 0.2
                    bg.Parent = wrap
                    corner(bg, 5)
                    local fill = Instance.new("Frame")
                    fill.Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0)
                    fill.BackgroundColor3 = T.slider
                    fill.Parent = bg
                    corner(fill, 5)
                    local dragging = false
                    local function apply(v)
                        value = math.clamp(math.floor(v + 0.5), min, max)
                        fill.Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0)
                        titleL.Text = (c.Name or "Slider") .. "  ·  " .. tostring(value)
                        if c.Callback then c.Callback(value) end
                    end
                    bg.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            dragging = true
                            local rel = math.clamp((input.Position.X - bg.AbsolutePosition.X) / math.max(bg.AbsoluteSize.X, 1), 0, 1)
                            apply(min + (max - min) * rel)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
                    end)
                    UserInputService.InputChanged:Connect(function(input)
                        if not dragging or input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
                        local rel = math.clamp((input.Position.X - bg.AbsolutePosition.X) / math.max(bg.AbsoluteSize.X, 1), 0, 1)
                        apply(min + (max - min) * rel)
                    end)
                end)
                return Sec
            end

            function Sec:CreateButton(c)
                c = c or {}
                table.insert(controls, function(parent)
                    local b = Instance.new("TextButton")
                    b.Size = UDim2.new(1, 0, 0, 34)
                    b.BackgroundColor3 = T.elev
                    b.BackgroundTransparency = 0.15
                    b.Font = Enum.Font.GothamBold
                    b.TextSize = 12
                    b.TextColor3 = T.text
                    b.Text = c.Name or "Button"
                    b.AutoButtonColor = false
                    b.Parent = parent
                    corner(b, 10)
                    stroke(b, T.stroke, 1, 0.35)
                    b.MouseEnter:Connect(function()
                        tween(b, 0.15, { BackgroundColor3 = T.accent, BackgroundTransparency = 0.05 })
                    end)
                    b.MouseLeave:Connect(function()
                        tween(b, 0.15, { BackgroundColor3 = T.elev, BackgroundTransparency = 0.15 })
                    end)
                    b.MouseButton1Click:Connect(function()
                        if c.Callback then c.Callback() end
                    end)
                end)
                return Sec
            end

            function Sec:CreateTextbox(c)
                c = c or {}
                table.insert(controls, function(parent)
                    local box = Instance.new("TextBox")
                    box.Size = UDim2.new(1, 0, 0, 34)
                    box.BackgroundColor3 = T.elev
                    box.BackgroundTransparency = 0.15
                    box.PlaceholderText = c.PlaceholderText or c.Name or "..."
                    box.PlaceholderColor3 = T.dim
                    box.Text = c.CurrentValue or ""
                    box.Font = Enum.Font.Gotham
                    box.TextSize = 12
                    box.TextColor3 = T.text
                    box.ClearTextOnFocus = false
                    box.TextXAlignment = Enum.TextXAlignment.Left
                    box.Parent = parent
                    corner(box, 10)
                    stroke(box, T.stroke, 1, 0.35)
                    pad(box, 0, 0, 12, 12)
                    box.FocusLost:Connect(function()
                        if c.Callback then c.Callback(box.Text) end
                    end)
                end)
                return Sec
            end

            function Sec:CreateLabel(c)
                c = c or {}
                table.insert(controls, function(parent)
                    local lab = Instance.new("TextLabel")
                    lab.Size = UDim2.new(1, 0, 0, 18)
                    lab.BackgroundTransparency = 1
                    lab.Font = Enum.Font.Gotham
                    lab.TextSize = 12
                    lab.TextColor3 = T.dim
                    lab.TextXAlignment = Enum.TextXAlignment.Left
                    lab.Text = c.Name or ""
                    lab.Parent = parent
                end)
                return Sec
            end

            return Sec
        end

        if not self._first then
            self._first = name
            task.defer(function() self:SelectTab(name) end)
        end
        return Tab
    end

    function Window:Destroy()
        gui:Destroy()
    end

    -- loading flash
    task.spawn(function()
        task.wait(0.15)
        setOpen(true)
        self:Notify({
            Title = "LOL Hub",
            Content = "Ready · drag LOL button · X closes",
            Duration = 3,
        })
    end)

    return Window
end

return setmetatable({}, LOL)
