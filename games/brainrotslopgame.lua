local uiLoader = loadstring(game:HttpGet('https://raw.githubusercontent.com/topitbopit/dollarware/main/library.lua'))
local ui = uiLoader({
    rounding = false,
    theme = 'lime',
    smoothDragging = false
})
ui.autoDisableToggles = true

local size = Vector2.new(460, 360)
local viewport = workspace.CurrentCamera.ViewportSize

local window = ui.newWindow({
    text = 'Farm Brainrot',
    resize = true,
    size = size,
    position = Vector2.new(
        (viewport.X - size.X) / 2,
        (viewport.Y - size.Y) / 2
    )
})

local menu = window:addMenu({ text = 'Farm' })
local section = menu:addSection({ text = 'Lucky Block', side = 'auto' })

local Players = game:GetService('Players')
local ReplicatedStorage = game:GetService('ReplicatedStorage')
local LocalPlayer = Players.LocalPlayer

local config = {
    ItemName = 'Meowl',
    Rarity = 'OG',
    Mutation = 'Disco',
    BlockName = 'Uncommon Lucky Block',
    Power = 10.642112568062,
    LandingPosition = Vector3.new(4, -99, 4514)
}

local farmLoop

local function doThrow()
    local char = LocalPlayer.Character
    if not char then return end

    local Remotes = ReplicatedStorage:FindFirstChild('ThrowLuckyBlockRemotes')
    if not Remotes then
        warn('[Farm] ThrowLuckyBlockRemotes not found')
        return
    end

    char:MoveTo(Vector3.new(9, 19, -493))
    task.wait(0.5)

    pcall(function()
        Remotes.ThrowZoneBatVisual:FireServer(true)
    end)
    task.wait()

    pcall(function()
        Remotes.ThrowStarted:FireServer()
    end)
    task.wait()

    pcall(function()
        Remotes.ThrowBatHit:FireServer(nil, false)
    end)
    task.wait()

    pcall(function()
        Remotes.ThrowBatTimingVfxCleanup:FireServer()
    end)
    task.wait()

    pcall(function()
        Remotes.LuckyBlockLanded:FireServer({
            LandingPosition = config.LandingPosition,
            ItemName = config.ItemName,
            Rarity = config.Rarity,
            BlockName = config.BlockName,
            LandingRarity = config.Rarity,
            Mutation = config.Mutation,
            Power = config.Power
        })
    end)

    task.wait(0.5)
    char:MoveTo(Vector3.new(8, 21, -558))
    task.wait(0.5)
end

section:addLabel({ text = 'Edit and save values' })

section:addTextbox({ text = 'ItemName (Brainrot)' })
    :bindToEvent('onFocusLost', function(text)
        if text and text ~= '' then
            config.ItemName = text
            ui.notify({ title = 'Config', message = 'ItemName = ' .. text, duration = 2 })
        end
    end)

section:addTextbox({ text = 'Rarity' })
    :bindToEvent('onFocusLost', function(text)
        if text and text ~= '' then
            config.Rarity = text
            ui.notify({ title = 'Config', message = 'Rarity = ' .. text, duration = 2 })
        end
    end)

section:addTextbox({ text = 'Mutation' })
    :bindToEvent('onFocusLost', function(text)
        if text and text ~= '' then
            config.Mutation = text
            ui.notify({ title = 'Config', message = 'Mutation = ' .. text, duration = 2 })
        end
    end)

section:addTextbox({ text = 'BlockName (optional)' })
    :bindToEvent('onFocusLost', function(text)
        if text and text ~= '' then
            config.BlockName = text
        end
    end)

section:addLabel({ text = 'Actual: Meowl | OG | Disco' })

section:addToggle({
    text = 'Auto Dupe/Spawn Brainrot',
    state = false
}):bindToEvent('onToggle', function(state)
    if state then
        farmLoop = task.spawn(function()
            while true do
                doThrow()
            end
        end)
        ui.notify({
            title = 'Farm',
            message = 'Auto ON: ' .. config.ItemName .. ' | ' .. config.Rarity .. ' | ' .. config.Mutation,
            duration = 3
        })
    else
        if farmLoop then
            task.cancel(farmLoop)
            farmLoop = nil
        end
        ui.notify({ title = 'Farm', message = 'Auto OFF', duration = 2 })
    end
end)

section:addButton({
    text = 'dupe manual',
    style = 'large'
}, function()
    task.spawn(function()
        doThrow()
        ui.notify({
            title = 'dupe manual',
            message = config.ItemName .. ' | ' .. config.Rarity .. ' | ' .. config.Mutation,
            duration = 3
        })
    end)
end)