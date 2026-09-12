--[[
  LOL Hub UI Library — Fusion (LOL + Dollarware + Rayfield)
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local LOL = { Version = "2.0-fusion" }
LOL.__index = LOL

local Themes = {
    lol = { -- LOL classic
        bg = Color3.fromRGB(18, 20, 26),
        top = Color3.fromRGB(22, 24, 32),
        side = Color3.fromRGB(14, 15, 20),
        card = Color3.fromRGB(28, 30, 38),
        elev = Color3.fromRGB(35, 38, 48),
        stroke = Color3.fromRGB(55, 58, 70),
        accent = Color3.fromRGB(140, 25, 35),
        accent2 = Color3.fromRGB(220, 170, 50),
        text = Color3.fromRGB(240, 240, 245),
        dim = Color3.fromRGB(130, 135, 150),
        toggleOn = Color3.fromRGB(220, 170, 50),
        toggleOff = Color3.fromRGB(50, 52, 62),
        slider = Color3.fromRGB(140, 25, 35),
        tabOn = Color3.fromRGB(140, 25, 35),
    },
    dollar = { -- Dollarware cherry-ish
        bg = Color3.fromRGB(5, 5, 5),
        top = Color3.fromRGB(11, 11, 11),
        side = Color3.fromRGB(8, 8, 8),
        card = Color3.fromRGB(12, 12, 12),
        elev = Color3.fromRGB(18, 18, 18),
        stroke = Color3.fromRGB(30, 30, 30),
        accent = Color3.fromRGB(249, 22, 52),
        accent2 = Color3.fromRGB(247, 22, 149),
        text = Color3.fromRGB(255, 255, 255),
        dim = Color3.fromRGB(164, 164, 164),
        toggleOn = Color3.fromRGB(249, 22, 52),
        toggleOff = Color3.fromRGB(40, 40, 40),
        slider = Color3.fromRGB(249, 22, 52),
        tabOn = Color3.fromRGB(249, 22, 52),
    },
    rayfield = { -- Rayfield Default-ish
        bg = Color3.fromRGB(25, 25, 25),
        top = Color3.fromRGB(34, 34, 34),
        side = Color3.fromRGB(28, 28, 28),
        card = Color3.fromRGB(35, 35, 35),
        elev = Color3.fromRGB(40, 40, 40),
        stroke = Color3.fromRGB(50, 50, 50),
        accent = Color3.fromRGB(50, 138, 220),
        accent2 = Color3.fromRGB(58, 163, 255),
        text = Color3.fromRGB(240, 240, 240),
        dim = Color3.fromRGB(160, 160, 160),
        toggleOn = Color3.fromRGB(0, 146, 214),
        toggleOff = Color3.fromRGB(100, 100, 100),
        slider = Color3.fromRGB(50, 138, 220),
        tabOn = Color3.fromRGB(210, 210, 210),
    },
}

local function tween(o, t, props)
    local tw = TweenService:Create(o, TweenInfo.new(t or 0.2, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out), props)
    tw:Play()
    return tw
end
local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
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
    local title = opts.Title or opts.title or "LOL Hub"
    local content = opts.Content or opts.message or ""
    local dur = opts.Duration or opts.duration or 3.5

    if not self._notifHost then
        local host = Instance.new("Frame")
        host.Size = UDim2.fromOffset(280, 420)
        host.Position = UDim2.new(1, -16, 1, -16)
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
    f.Size = UDim2.fromOffset(270, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = T.top
    f.BackgroundTransparency = 1
    f.Parent = self._notifHost
    corner(f, 10)
    local st = stroke(f, T.accent, 1, 1)

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 1, -12)
    bar.Position = UDim2.fromOffset(8, 6)
    bar.BackgroundColor3 = T.accent
    bar.BackgroundTransparency = 1
    bar.BorderSizePixel = 0
    bar.Parent = f
    corner(bar, 2)

    local ttl = Instance.new("TextLabel")
    ttl.Size = UDim2.new(1, -28, 0, 18)
    ttl.Position = UDim2.fromOffset(18, 10)
    ttl.BackgroundTransparency = 1
    ttl.Font = Enum.Font.GothamBold
    ttl.TextSize = 13
    ttl.TextColor3 = T.accent2
    ttl.TextTransparency = 1
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ttl.Text = title
    ttl.Parent = f

    local body = Instance.new("TextLabel")
    body.Size = UDim2.new(1, -28, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.Position = UDim2.fromOffset(18, 30)
    body.BackgroundTransparency = 1
    body.Font = Enum.Font.Gotham
    body.TextSize = 12
    body.TextColor3 = T.dim
    body.TextTransparency = 1
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextWrapped = true
    body.Text = content
    body.Parent = f
    pad(f, 0, 12, 0, 0)

    tween(f, 0.35, { BackgroundTransparency = 0.05 })
    tween(st, 0.35, { Transparency = 0.3 })
    tween(bar, 0.35, { BackgroundTransparency = 0 })
    tween(ttl, 0.35, { TextTransparency = 0 })
    tween(body, 0.35, { TextTransparency = 0 })

    task.delay(dur, function()
        if not f.Parent then return end
        tween(f, 0.25, { BackgroundTransparency = 1 })
        tween(st, 0.25, { Transparency = 1 })
        tween(ttl, 0.25, { TextTransparency = 1 })
        tween(body, 0.25, { TextTransparency = 1 })
        task.wait(0.28)
        f:Destroy()
    end)
end

function LOL:CreateWindow(opts)
    opts = opts or {}
    local themeName = opts.Theme or opts.theme or "lol"
    local T = Themes[themeName] or Themes.lol
    self._T = T

    local old = PlayerGui:FindFirstChild("LOLHubLib")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "LOLHubLib"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 120
    gui.Parent = PlayerGui
    self._gui = gui

    local W, H = opts.Width or 560, opts.Height or 380

    -- Loading (Rayfield-like)
    local loadF = Instance.new("Frame")
    loadF.Size = UDim2.fromOffset(280, 120)
    loadF.Position = UDim2.fromScale(0.5, 0.5)
    loadF.AnchorPoint = Vector2.new(0.5, 0.5)
    loadF.BackgroundColor3 = T.bg
    loadF.Parent = gui
    corner(loadF, 12)
    stroke(loadF, T.accent, 1, 0.4)
    local loadT = Instance.new("TextLabel")
    loadT.Size = UDim2.new(1, 0, 0, 28)
    loadT.Position = UDim2.fromOffset(0, 28)
    loadT.BackgroundTransparency = 1
    loadT.Font = Enum.Font.GothamBold
    loadT.TextSize = 18
    loadT.TextColor3 = T.accent2
    loadT.Text = opts.Name or "LOL Hub"
    loadT.Parent = loadF
    local loadS = Instance.new("TextLabel")
    loadS.Size = UDim2.new(1, 0, 0, 18)
    loadS.Position = UDim2.fromOffset(0, 56)
    loadS.BackgroundTransparency = 1
    loadS.Font = Enum.Font.Gotham
    loadS.TextSize = 12
    loadS.TextColor3 = T.dim
    loadS.Text = "LOL · Dollarware · Rayfield"
    loadS.Parent = loadF
    local barBg = Instance.new("Frame")
    barBg.Size = UDim2.new(1, -40, 0, 6)
    barBg.Position = UDim2.fromOffset(20, 90)
    barBg.BackgroundColor3 = T.elev
    barBg.Parent = loadF
    corner(barBg, 3)
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 0, 1, 0)
    bar.BackgroundColor3 = T.accent
    bar.Parent = barBg
    corner(bar, 3)

    local win = Instance.new("Frame")
    win.Size = UDim2.fromOffset(W, H)
    win.Position = UDim2.fromScale(0.5, 0.5)
    win.AnchorPoint = Vector2.new(0.5, 0.5)
    win.BackgroundColor3 = T.bg
    win.Visible = false
    win.Parent = gui
    corner(win, 12)
    stroke(win, T.stroke, 1, 0.25)

    -- Title (Rayfield topbar + LOL gold)
    local top = Instance.new("Frame")
    top.Size = UDim2.new(1, 0, 0, 42)
    top.BackgroundColor3 = T.top
    top.Parent = win
    corner(top, 12)
    local topFix = Instance.new("Frame")
    topFix.Size = UDim2.new(1, 0, 0, 14)
    topFix.Position = UDim2.new(0, 0, 1, -14)
    topFix.BackgroundColor3 = T.top
    topFix.BorderSizePixel = 0
    topFix.Parent = top

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(0.7, 0, 1, 0)
    title.Position = UDim2.fromOffset(14, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.TextSize = 15
    title.TextColor3 = T.accent2
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Text = opts.Name or "LOL Hub"
    title.Parent = top

    local close = Instance.new("TextButton")
    close.Size = UDim2.fromOffset(28, 28)
    close.Position = UDim2.new(1, -36, 0.5, -14)
    close.BackgroundColor3 = T.accent
    close.Text = "X"
    close.TextColor3 = T.text
    close.Font = Enum.Font.GothamBold
    close.TextSize = 12
    close.Parent = top
    corner(close, 8)
    close.MouseButton1Click:Connect(function() gui:Destroy() end)

    -- drag
    do
        local drag, start, startPos
        top.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = true
                start = input.Position
                startPos = win.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then drag = false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if not drag or input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            local d = input.Position - start
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end)
    end

    -- Sidebar (Dollarware menus)
    local side = Instance.new("Frame")
    side.Size = UDim2.new(0, 110, 1, -50)
    side.Position = UDim2.fromOffset(8, 46)
    side.BackgroundColor3 = T.side
    side.Parent = win
    corner(side, 10)
    stroke(side, T.stroke, 1, 0.4)

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
    sideLay.Padding = UDim.new(0, 4)
    sideLay.Parent = sideScroll

    -- Content (Rayfield elements list / DW columns)
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -130, 1, -54)
    content.Position = UDim2.fromOffset(124, 48)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = T.accent
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.CanvasSize = UDim2.new()
    content.Parent = win
    local contentLay = Instance.new("UIListLayout")
    contentLay.Padding = UDim.new(0, 8)
    contentLay.SortOrder = Enum.SortOrder.LayoutOrder
    contentLay.Parent = content
    pad(content, 4, 8, 8, 8)

    local Window = {
        _tabs = {},
        _builders = {},
        _first = nil,
        _order = 0,
    }

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
                BackgroundColor3 = on and T.tabOn or T.side,
                BackgroundTransparency = on and 0.15 or 1,
            })
            btn.TextColor3 = on and (themeName == "rayfield" and Color3.fromRGB(40, 40, 40) or T.text) or T.dim
        end
        clear()
        if self._builders[name] then self._builders[name]() end
    end

    function Window:CreateTab(o)
        o = o or {}
        local name = o.Name or o.name or "Tab"
        local sections = {}

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -4, 0, 30)
        btn.BackgroundColor3 = T.tabOn
        btn.BackgroundTransparency = 1
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 12
        btn.TextColor3 = T.dim
        btn.Text = "  " .. name
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Parent = sideScroll
        corner(btn, 8)
        self._tabs[name] = btn
        btn.MouseButton1Click:Connect(function() self:SelectTab(name) end)

        self._builders[name] = function()
            for _, b in ipairs(sections) do b() end
        end

        local Tab = {}
        function Tab:CreateSection(so)
            so = so or {}
            local secName = so.Name or so.name or "Section"
            local controls = {}

            table.insert(sections, function()
                Window._order += 1
                local lab = Instance.new("TextLabel")
                lab.LayoutOrder = Window._order
                lab.Size = UDim2.new(1, 0, 0, 18)
                lab.BackgroundTransparency = 1
                lab.Font = Enum.Font.GothamBold
                lab.TextSize = 12
                lab.TextColor3 = T.accent
                lab.TextXAlignment = Enum.TextXAlignment.Left
                lab.Text = string.upper(secName)
                lab.Parent = content

                Window._order += 1
                local card = Instance.new("Frame")
                card.LayoutOrder = Window._order
                card.Size = UDim2.new(1, 0, 0, 0)
                card.AutomaticSize = Enum.AutomaticSize.Y
                card.BackgroundColor3 = T.card
                card.Parent = content
                corner(card, 10)
                stroke(card, T.stroke, 1, 0.35)
                local lay = Instance.new("UIListLayout")
                lay.Padding = UDim.new(0, 6)
                lay.Parent = card
                pad(card, 10, 10, 10, 10)

                for _, add in ipairs(controls) do add(card) end
            end)

            local Sec = {}

            function Sec:CreateToggle(c)
                c = c or {}
                table.insert(controls, function(parent)
                    local row = Instance.new("Frame")
                    row.Size = UDim2.new(1, 0, 0, 32)
                    row.BackgroundTransparency = 1
                    row.Parent = parent
                    local state = c.CurrentValue or false
                    local lab = Instance.new("TextLabel")
                    lab.Size = UDim2.new(1, -52, 1, 0)
                    lab.BackgroundTransparency = 1
                    lab.Font = Enum.Font.Gotham
                    lab.TextSize = 13
                    lab.TextColor3 = T.text
                    lab.TextXAlignment = Enum.TextXAlignment.Left
                    lab.Text = c.Name or "Toggle"
                    lab.Parent = row
                    -- Rayfield-style pill
                    local track = Instance.new("TextButton")
                    track.Size = UDim2.fromOffset(44, 24)
                    track.Position = UDim2.new(1, -44, 0.5, -12)
                    track.BackgroundColor3 = state and T.toggleOn or T.toggleOff
                    track.Text = ""
                    track.Parent = row
                    corner(track, 12)
                    local knob = Instance.new("Frame")
                    knob.Size = UDim2.fromOffset(18, 18)
                    knob.Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
                    knob.BackgroundColor3 = Color3.new(1, 1, 1)
                    knob.Parent = track
                    corner(knob, 9)
                    track.MouseButton1Click:Connect(function()
                        state = not state
                        tween(track, 0.18, { BackgroundColor3 = state and T.toggleOn or T.toggleOff })
                        tween(knob, 0.18, {
                            Position = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
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
                    wrap.Size = UDim2.new(1, 0, 0, 48)
                    wrap.BackgroundTransparency = 1
                    wrap.Parent = parent
                    local title = Instance.new("TextLabel")
                    title.Size = UDim2.new(1, 0, 0, 16)
                    title.BackgroundTransparency = 1
                    title.Font = Enum.Font.Gotham
                    title.TextSize = 12
                    title.TextColor3 = T.text
                    title.TextXAlignment = Enum.TextXAlignment.Left
                    title.Text = (c.Name or "Slider") .. "  " .. tostring(value)
                    title.Parent = wrap
                    local bg = Instance.new("Frame")
                    bg.Size = UDim2.new(1, 0, 0, 8)
                    bg.Position = UDim2.fromOffset(0, 28)
                    bg.BackgroundColor3 = T.elev
                    bg.Parent = wrap
                    corner(bg, 4)
                    local fill = Instance.new("Frame")
                    fill.Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0)
                    fill.BackgroundColor3 = T.slider
                    fill.Parent = bg
                    corner(fill, 4)
                    local drag = false
                    local function apply(v)
                        value = math.clamp(math.floor(v + 0.5), min, max)
                        fill.Size = UDim2.new((value - min) / math.max(max - min, 1), 0, 1, 0)
                        title.Text = (c.Name or "Slider") .. "  " .. tostring(value)
                        if c.Callback then c.Callback(value) end
                    end
                    bg.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then
                            drag = true
                            local rel = math.clamp((input.Position.X - bg.AbsolutePosition.X) / math.max(bg.AbsoluteSize.X, 1), 0, 1)
                            apply(min + (max - min) * rel)
                        end
                    end)
                    UserInputService.InputEnded:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
                    end)
                    UserInputService.InputChanged:Connect(function(input)
                        if not drag or input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
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
                    b.Font = Enum.Font.GothamBold
                    b.TextSize = 12
                    b.TextColor3 = T.text
                    b.Text = c.Name or "Button"
                    b.Parent = parent
                    corner(b, 8)
                    stroke(b, T.stroke, 1, 0.3)
                    b.MouseEnter:Connect(function() tween(b, 0.15, { BackgroundColor3 = T.accent }) end)
                    b.MouseLeave:Connect(function() tween(b, 0.15, { BackgroundColor3 = T.elev }) end)
                    b.MouseButton1Click:Connect(function() if c.Callback then c.Callback() end end)
                end)
                return Sec
            end

            function Sec:CreateTextbox(c)
                c = c or {}
                table.insert(controls, function(parent)
                    local box = Instance.new("TextBox")
                    box.Size = UDim2.new(1, 0, 0, 34)
                    box.BackgroundColor3 = T.elev
                    box.PlaceholderText = c.PlaceholderText or c.Name or "..."
                    box.PlaceholderColor3 = T.dim
                    box.Text = c.CurrentValue or ""
                    box.Font = Enum.Font.Gotham
                    box.TextSize = 12
                    box.TextColor3 = T.text
                    box.ClearTextOnFocus = false
                    box.TextXAlignment = Enum.TextXAlignment.Left
                    box.Parent = parent
                    corner(box, 8)
                    stroke(box, T.stroke, 1, 0.3)
                    pad(box, 0, 0, 10, 10)
                    box.FocusLost:Connect(function() if c.Callback then c.Callback(box.Text) end end)
                end)
                return Sec
            end

            function Sec:CreateLabel(c)
                c = c or {}
                table.insert(controls, function(parent)
                    local lab = Instance.new("TextLabel")
                    lab.Size = UDim2.new(1, 0, 0, 20)
                    lab.BackgroundTransparency = 1
                    lab.Font = Enum.Font.Gotham
                    lab.TextSize = 12
                    lab.TextColor3 = T.dim
                    lab.TextXAlignment = Enum.TextXAlignment.Left
                    lab.Text = c.Name or c.text or ""
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

    task.spawn(function()
        for i = 1, 10 do
            bar.Size = UDim2.new(i / 10, 0, 1, 0)
            task.wait(0.04)
        end
        loadF.Visible = false
        win.Visible = true
        self:Notify({ Title = "LOL Hub", Content = "Fusion UI ready (" .. themeName .. ")", Duration = 3 })
    end)

    return Window
end

return setmetatable({}, LOL)
