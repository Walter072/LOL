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
local sectionright = mainMenu:addSection({
    text = 'Farm',
    side = 'right',
    showMinButton = true 
})
local infmoneyloop

section:addToggle({
    text = "Auto inf money",
    state = false
}):bindToEvent("onToggle", function(newState)
    if newState then
        infmoneyloop = task.spawn(function()
            local Event = game:GetService("ReplicatedStorage").events.buyGear

            while true do
                pcall(function()
                  Event:FireServer("Hot Sauce", -9e9)
                end)

                task.wait(0.2) -- 3. Velocidad del spam
            end
        end)
    else
        if infmoneyloop then
            task.cancel(infmoneyloop)
            infmoneyloop = nil
        end
    end
end)