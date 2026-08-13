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
local sectionleft = mainMenu:addSection({
    text = 'Farm',
    side = 'left',
    showMinButton = true 
})
local buyLoop

sectionleft:addToggle({
    text = "Infinite money",
    state = false
}):bindToEvent("onToggle", function(newState)
    if newState then
        buyLoop = task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").events.buyGear

            while true do
                pcall(function()
                    Event:FireServer("Hot Sauce", 127e7493)
                end)
                task.wait(0.1)
            end
        end)
    else
        if buyLoop then
            task.cancel(buyLoop)
            buyLoop = nil
        end
    end
end)