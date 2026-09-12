--[[
  LOL Hub UI — Glass / Symmetric
  Inspired by modern glass UI · practical script hub layout
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local LOL = { Version = "2.2-glass" }
LOL.__index = LOL

-- Glass blue (concept) + LOL accent
local T = {
    bg = Color3.fromRGB(12, 16, 28),
    top = Color3.fromRGB(18, 24, 40),
    side = Color3.fromRGB(14, 20, 34),
    card = Color3.fromRGB(22, 30, 48),
    elev = Color3.fromRGB(28, 38, 58),
    stroke = Color3.fromRGB(60, 120, 200),
    accent = Color3.fromRGB(40, 140, 255),
    accent2 = Color3.fromRGB(100, 200, 255),
    gold = Color3.fromRGB(230, 185, 55),
    text = Color3.fromRGB(235, 245, 255),
    dim = Color3.fromRGB(140, 160, 190),
    toggleOn = Color3.fromRGB(40, 160, 255),
    toggleOff = Color3.fromRGB(40, 50, 70),
    danger = Color3.fromRGB(220, 70, 90),
    fab = Color3.fromRGB(30, 100, 220),
}

local function tween(o, t, p, style)
    local tw = TweenService:Create(o, TweenInfo.new(t or 0.25, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out), p)
    tw:Play()
    return tw
end
local function corner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 12)
    c.Parent = p
end
local function stroke(p, col, th, tr)
    local s = Instance.new("UIStroke")
    s.Color = col or T.stroke
    s.Thickness = th or 1
    s.Transparency = tr or 0.4
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
    if not self._gui then return end
    if not self._notifHost then
        local host = Instance.new("Frame")
        host.Size = UDim2.fromOffset(300, 480)
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
    f.Size = UDim2.fromOffset(280, 0)
    f.AutomaticSize = Enum.AutomaticSize.Y
    f.BackgroundColor3 = T.top
    f.BackgroundTransparency = 1
    f.Parent = self._notifHost
    corner(f, 14)
    local st = stroke(f, T.accent, 1.2, 1)
    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0, 3, 1, -16)
    bar.Position = UDim2.fromOffset(10, 8)
    bar.BackgroundColor3 = T.accent2
    bar.BackgroundTransparency = 1
    bar.BorderSizePixel = 0
    bar.Parent = f
    corner(bar, 2)
    local ttl = Instance.new("TextLabel")
    ttl.Size = UDim2.new(1, -28, 0, 18)
    ttl.Position = UDim2.fromOffset(20, 12)
    ttl.BackgroundTransparency = 1
    ttl.Font = Enum.Font.GothamBold
    ttl.TextSize = 13
    ttl.TextColor3 = T.accent2
    ttl.TextTransparency = 1
    ttl.TextXAlignment = Enum.TextXAlignment.Left
    ttl.Text = opts.Title or "LOL Hub"
    ttl.Parent = f
    local body = Instance.new("TextLabel")
    body.Size = UDim2.new(1, -28, 0, 0)
    body.AutomaticSize = Enum.AutomaticSize.Y
    body.Position = UDim2.fromOffset(20, 32)
    body.BackgroundTransparency = 1
    body.Font = Enum.Font.Gotham
    body.TextSize = 12
    body.TextColor3 = T.dim
    body.TextTransparency = 1
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextWrapped = true
    body.Text = opts.Content or ""
    body.Parent = f
    pad(f, 0, 14, 0, 0)
    tween(f, 0.35, { BackgroundTransparency = 0.12 })
    tween(st, 0.35, { Transparency = 0.3 })
    tween(bar, 0.35, { BackgroundTransparency = 0 })
    tween(ttl, 0.35, { TextTransparency = 0 })
    tween(body, 0.35, { TextTransparency = 0 })
    task.delay(opts.Duration or 3, function()
        if not f.Parent then return end
        tween(f, 0.25, { BackgroundTransparency = 1 })
        tween(ttl, 0.25, { TextTransparency = 1 })
        tween(body, 0.25, { TextTransparency = 1 })
        task.wait(0.28)
        f:Destroy()
    end)
end

function LOL:CreateWindow(opts)
    opts = opts or {}
    local bgAlpha = opts.Transparency or 0.15
    local W, H = opts.Width or 580, opts.Height or 400

    local old = PlayerGui:FindFirstChild("LOLHubLib")
    if old then old:Destroy() end

    local gui = Instance.new("ScreenGui")
    gui.Name = "LOLHubLib"
    gui.ResetOnSpawn = false
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.DisplayOrder = 140
    gui.Parent = PlayerGui
    self._gui = gui

    -- FAB open/close
    local fab = Instance.new("TextButton")
    fab.Size = UDim2.fromOffset(54, 54)
    fab.Position = UDim2.new(0, 20, 1, -76)
    fab.BackgroundColor3 = T.fab
    fab.BackgroundTransparency = 0.08
    fab.Font = Enum.Font.GothamBlack
    fab.TextSize = 12
    fab.TextColor3 = T.text
    fab.Text = "LOL"
    fab.AutoButtonColor = false
    fab.Parent = gui
    corner(fab, 18)
    stroke(fab, T.accent2, 1.5, 0.25)

    do
        local dragging, start, startPos
        fab.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - start
                fab.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    -- Main window (symmetric)
    local win = Instance.new("Frame")
    win.Size = UDim2.fromOffset(W, 0)
    win.Position = UDim2.fromScale(0.5, 0.5)
    win.AnchorPoint = Vector2.new(0.5, 0.5)
    win.BackgroundColor3 = T.bg
    win.BackgroundTransparency = 1
    win.ClipsDescendants = true
    win.Visible = false
    win.Parent = gui
    corner(win, 18)
    local winStroke = stroke(win, T.accent, 1.5, 1)

    local hubOpen, animating = false, false
    local function setOpen(open)
        if animating then return end
        animating = true
        hubOpen = open
        if open then
            win.Visible = true
            win.Size = UDim2.fromOffset(W * 0.92, 0)
            tween(win, 0.38, {
                Size = UDim2.fromOffset(W, H),
                BackgroundTransparency = bgAlpha,
            })
            tween(winStroke, 0.38, { Transparency = 0.35 })
            fab.Text = "—"
            tween(fab, 0.2, { BackgroundColor3 = T.accent2 })
            task.delay(0.4, function() animating = false end)
        else
            tween(win, 0.28, {
                Size = UDim2.fromOffset(W * 0.92, 0),
                BackgroundTransparency = 1,
            })
            tween(winStroke, 0.28, { Transparency = 1 })
            fab.Text = "LOL"
            tween(fab, 0.2, { BackgroundColor3 = T.fab })
            task.delay(0.3, function()
                win.Visible = false
                animating = false
            end)
        end
    end
    fab.MouseButton1Click:Connect(function() setOpen(not hubOpen) end)
    getgenv().__LOL_ToggleHub = function() setOpen(not hubOpen) end

    -- Top bar (balanced: title left, actions right)
   -- ===== Title bar (sin franja negra) =====
local TOP_H = 44

local top = Instance.new("Frame")
top.Name = "TopBar"
top.Size = UDim2.new(1, 0, 0, TOP_H)
top.BackgroundColor3 = T.top
top.BackgroundTransparency = 0.12
top.BorderSizePixel = 0
top.Parent = win
corner(top, 18)

-- recorta solo las esquinas de abajo del top para que no “coma” el body
local topClip = Instance.new("Frame")
topClip.Size = UDim2.new(1, 0, 1, 12)
topClip.BackgroundColor3 = T.top
topClip.BackgroundTransparency = 0.12
topClip.BorderSizePixel = 0
topClip.Parent = top
-- NO uses un fill negro aparte debajo del top

-- línea fina de separación (glass, no negro sólido)
local sep = Instance.new("Frame")
sep.Size = UDim2.new(1, -24, 0, 1)
sep.Position = UDim2.new(0, 12, 1, -1)
sep.BackgroundColor3 = T.accent
sep.BackgroundTransparency = 0.75
sep.BorderSizePixel = 0
sep.ZIndex = 2
sep.Parent = top

-- Logo
local logo = Instance.new("Frame")
logo.Size = UDim2.fromOffset(28, 28)
logo.Position = UDim2.fromOffset(12, 8)
logo.BackgroundColor3 = T.elev
logo.BorderSizePixel = 0
logo.Parent = top
corner(logo, 14)
stroke(logo, T.accent2, 1.2, 0.25)

local logoT = Instance.new("TextLabel")
logoT.Size = UDim2.fromScale(1, 1)
logoT.BackgroundTransparency = 1
logoT.Font = Enum.Font.GothamBlack
logoT.TextSize = 9
logoT.TextColor3 = T.accent2
logoT.Text = "LOL"
logoT.Parent = logo

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -120, 1, 0)
title.Position = UDim2.fromOffset(48, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextColor3 = T.text
title.TextXAlignment = Enum.TextXAlignment.Left
title.Text = opts.Name or "LOL Hub"
title.Parent = top

-- Contenedor horizontal de botones (derecha)
local actions = Instance.new("Frame")
actions.Size = UDim2.fromOffset(72, 26)
actions.Position = UDim2.new(1, -84, 0.5, -13)
actions.BackgroundTransparency = 1
actions.Parent = top

local actionsLay = Instance.new("UIListLayout")
actionsLay.FillDirection = Enum.FillDirection.Horizontal
actionsLay.HorizontalAlignment = Enum.HorizontalAlignment.Right
actionsLay.VerticalAlignment = Enum.VerticalAlignment.Center
actionsLay.Padding = UDim.new(0, 6)
actionsLay.Parent = actions

-- Minimizar (achica la GUI)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.fromOffset(26, 26)
minBtn.BackgroundColor3 = T.elev
minBtn.BackgroundTransparency = 0.05
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 12
minBtn.TextColor3 = T.dim
minBtn.Text = "─"
minBtn.AutoButtonColor = false
minBtn.Parent = actions
corner(minBtn, 8)
stroke(minBtn, T.stroke, 1, 0.45)

-- Cerrar (chiquito, limpio)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.fromOffset(26, 26)
closeBtn.BackgroundColor3 = T.elev
closeBtn.BackgroundTransparency = 0.05
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 12
closeBtn.TextColor3 = T.dim
closeBtn.Text = "✕"
closeBtn.AutoButtonColor = false
closeBtn.Parent = actions
corner(closeBtn, 8)
stroke(closeBtn, T.stroke, 1, 0.45)

minBtn.MouseEnter:Connect(function()
    tween(minBtn, 0.12, { BackgroundColor3 = T.accent, TextColor3 = T.text })
end)
minBtn.MouseLeave:Connect(function()
    tween(minBtn, 0.12, { BackgroundColor3 = T.elev, TextColor3 = T.dim })
end)
closeBtn.MouseEnter:Connect(function()
    tween(closeBtn, 0.12, { BackgroundColor3 = Color3.fromRGB(220, 70, 90), TextColor3 = Color3.new(1, 1, 1) })
end)
closeBtn.MouseLeave:Connect(function()
    tween(closeBtn, 0.12, { BackgroundColor3 = T.elev, TextColor3 = T.dim })
end)
    -- drag
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

    -- Sidebar (aligned width, even padding)
    local SIDE_W = 120
    local side = Instance.new("Frame")
    side.Size = UDim2.new(0, SIDE_W, 1, -64)
    side.Position = UDim2.fromOffset(12, 56)
    side.BackgroundColor3 = T.side
    side.BackgroundTransparency = 0.25
    side.Parent = win
    corner(side, 14)
    stroke(side, T.stroke, 1, 0.55)

    local sideScroll = Instance.new("ScrollingFrame")
    sideScroll.Size = UDim2.new(1, -12, 1, -12)
    sideScroll.Position = UDim2.fromOffset(6, 6)
    sideScroll.BackgroundTransparency = 1
    sideScroll.BorderSizePixel = 0
    sideScroll.ScrollBarThickness = 2
    sideScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sideScroll.CanvasSize = UDim2.new()
    sideScroll.Parent = side
    local sideLay = Instance.new("UIListLayout")
    sideLay.Padding = UDim.new(0, 6)
    sideLay.Parent = sideScroll

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -(SIDE_W + 28), 1, -68)
    content.Position = UDim2.fromOffset(SIDE_W + 20, 56)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 3
    content.ScrollBarImageColor3 = T.accent2
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.CanvasSize = UDim2.new()
    content.Parent = win
    local contentLay = Instance.new("UIListLayout")
    contentLay.Padding = UDim.new(0, 12)
    contentLay.SortOrder = Enum.SortOrder.LayoutOrder
    contentLay.Parent = content
    pad(content, 4, 12, 4, 8)

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
                BackgroundTransparency = on and 0.15 or 1,
                BackgroundColor3 = on and T.accent or T.side,
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
        btn.Size = UDim2.new(1, 0, 0, 34)
        btn.BackgroundColor3 = T.accent
        btn.BackgroundTransparency = 1
        btn.Font = Enum.Font.GothamMedium
        btn.TextSize = 12
        btn.TextColor3 = T.dim
        btn.Text = "  " .. name
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.Parent = sideScroll
        corner(btn, 10)
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
                card.BackgroundTransparency = 0.22
                card.Parent = content
                corner(card, 14)
                stroke(card, T.stroke, 1, 0.5)
                local lay = Instance.new("UIListLayout")
                lay.Padding = UDim.new(0, 10)
                lay.Parent = card
                pad(card, 14, 14, 14, 14)

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
                    lab.Size = UDim2.new(1, -56, 1, 0)
                    lab.BackgroundTransparency = 1
                    lab.Font = Enum.Font.Gotham
                    lab.TextSize = 13
                    lab.TextColor3 = T.text
                    lab.TextXAlignment = Enum.TextXAlignment.Left
                    lab.Text = c.Name or "Toggle"
                    lab.Parent = row
                    local track = Instance.new("TextButton")
                    track.Size = UDim2.fromOffset(48, 26)
                    track.Position = UDim2.new(1, -48, 0.5, -13)
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
                    fill.BackgroundColor3 = T.accent
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
                    b.Size = UDim2.new(1, 0, 0, 36)
                    b.BackgroundColor3 = T.elev
                    b.BackgroundTransparency = 0.12
                    b.Font = Enum.Font.GothamBold
                    b.TextSize = 12
                    b.TextColor3 = T.text
                    b.Text = c.Name or "Button"
                    b.AutoButtonColor = false
                    b.Parent = parent
                    corner(b, 12)
                    stroke(b, T.stroke, 1, 0.45)
                    b.MouseEnter:Connect(function()
                        tween(b, 0.15, { BackgroundColor3 = T.accent, BackgroundTransparency = 0 })
                    end)
                    b.MouseLeave:Connect(function()
                        tween(b, 0.15, { BackgroundColor3 = T.elev, BackgroundTransparency = 0.12 })
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
                    box.Size = UDim2.new(1, 0, 0, 36)
                    box.BackgroundColor3 = T.elev
                    box.BackgroundTransparency = 0.12
                    box.PlaceholderText = c.PlaceholderText or c.Name or "..."
                    box.PlaceholderColor3 = T.dim
                    box.Text = c.CurrentValue or ""
                    box.Font = Enum.Font.Gotham
                    box.TextSize = 12
                    box.TextColor3 = T.text
                    box.ClearTextOnFocus = false
                    box.TextXAlignment = Enum.TextXAlignment.Left
                    box.Parent = parent
                    corner(box, 12)
                    stroke(box, T.stroke, 1, 0.45)
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

    task.spawn(function()
        task.wait(0.12)
        setOpen(true)
        self:Notify({ Title = "LOL Hub", Content = "Glass UI · drag LOL · ✕ closes", Duration = 3 })
    end)

    return Window
end

return setmetatable({}, LOL)
