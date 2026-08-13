local uiLoader = loadstring(game:HttpGet('https://raw.githubusercontent.com/topitbopit/dollarware/main/library.lua'))
local ui = uiLoader({
    rounding = false,
    theme = 'lime',
    smoothDragging = false
})
ui.autoDisableToggles = true

local size = Vector2.new(420, 280)
local viewport = workspace.CurrentCamera.ViewportSize

local window = ui.newWindow({
    text = 'LOL HUB',
    resize = true,
    size = size,
    position = Vector2.new(
        (viewport.X - size.X) / 2,
        (viewport.Y - size.Y) / 2
    )
})
local mainMenu = window:addMenu({
    text = 'Main'
})

local miscMenu = window:addMenu({
    text = 'Misc'
})

local section2 = miscMenu:addSection({
    text = 'Misc',
    side = 'left',
    showMinButton = true
})
local section1 = mainMenu:addSection({
    text = 'Farm',
    side = 'left',
    showMinButton = true 
})
local buyLoop

local function getBuyGearRemote()
    local rs = game:GetService("ReplicatedStorage")
    local folder = rs:FindFirstChild("events") or rs:FindFirstChild("Events")
    if not folder then return nil end
    return folder:FindFirstChild("buyGear") or folder:FindFirstChild("BuyGear")
end

section2:addToggle({
    text = "Infinite Money",
    state = false
}):bindToEvent("onToggle", function(newState)
    if newState then
        buyLoop = task.spawn(function()
            while true do
                local Event = getBuyGearRemote()
                if Event then

                    pcall(function()
                        Event:FireServer("Hot Sauce", -3216e12632)
                    end)
  
                    pcall(function()
                        Event:FireServer({ "Hot Sauce", -3216e12632 })
                    end)

                    pcall(function()
                        local args = { [1] = "Hot Sauce", [2] = -3216e12632 }
                        Event:FireServer(unpack(args))
                    end)
                else
                    warn("BuyGear remote not found")
                end
                task.wait(0.5)
            end
        end)
    else
        if buyLoop then
            task.cancel(buyLoop)
            buyLoop = nil
        end
    end
end)
local rebirthloop

section1:addToggle({
    text = "Auto rebirth",
    state = false
}):bindToEvent("onToggle", function(newState)
    if newState then
        rebirthloop = task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").events.rebirth

            while true do
                pcall(function()
                    Event:FireServer(
                        1750
                    )
                end)

                task.wait(0.2)
            end
        end)
    else
        if rebirthloop then
            task.cancel(rebirthloop)
            rebirthloop = nil
        end
    end
end)