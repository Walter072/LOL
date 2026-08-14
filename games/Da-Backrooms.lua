local uiLoader = loadstring(game:HttpGet('https://raw.githubusercontent.com/topitbopit/dollarware/main/library.lua'))
local ui = uiLoader({
    rounding = false,
    theme = 'lime', -- idk themes you like only have themes lime,watermelon,orange etc
    smoothDragging = false
})
local size = Vector2.new(550, 376)
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
-- all services pls give me credits i dont know english pls dont bullyng me
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local ShootRemote = ReplicatedStorage:FindFirstChild("Shoot") or ReplicatedStorage:FindFirstChild("Rgnns")
local InventoryRemote = ReplicatedStorage:FindFirstChild("Inventory")
local SpinnerRF = ReplicatedStorage:FindFirstChild("SpinnerModule") and ReplicatedStorage.SpinnerModule:FindFirstChild("RemoteFunction")

local mainMenu = window:addMenu({ text = "Main" })
local combatMenu = window:addMenu({ text = "Combat" })
local espMenu = window:addMenu({ text = "ESP" })
local dupeMenu = window:addMenu({ text = "Dupe" })
local miscMenu = window:addMenu({ text = "Misc" })
local hubMenu = window:addMenu({ text = "TheHub" })

do
    local section = mainMenu:addSection({ text = "Player", side = "auto" })

    section:addSlider({
        text = "WalkSpeed",
        min = 16,
        max = 120,
        step = 1,
        val = 16
    }, function(val)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Looking") then
            char.Looking.WalkSpeed.Value = val
        end
    end)

    local staminaLoop
    section:addToggle({ text = "Infinite Stamina", state = false })
        :bindToEvent("onToggle", function(state)
            if state then
                staminaLoop = task.spawn(function()
                    while true do
                        pcall(function()
                            LocalPlayer.PlayerGui.MainGUI.Stamina.Value = 9999
                        end)
                        task.wait(0.2)
                    end
                end)
            else
                if staminaLoop then task.cancel(staminaLoop) staminaLoop = nil end
            end
        end)

    local sanityLoop
    section:addToggle({ text = "Infinite Sanity", state = false })
        :bindToEvent("onToggle", function(state)
            if state then
                sanityLoop = task.spawn(function()
                    while true do
                        pcall(function()
                            LocalPlayer.PlayerGui.MainGUI.Sanity.Value = 9999999
                        end)
                        task.wait(0.2)
                    end
                end)
            else
                if sanityLoop then task.cancel(sanityLoop) sanityLoop = nil end
            end
        end)
end

do
    local section = combatMenu:addSection({ text = "Shooting", side = "left" })

    section:addToggle({ text = "Auto Shoot", state = false })
        :bindToEvent("onToggle", function(state)
            getgenv().autoShoot = state
            if state then
                task.spawn(function()
                    local params = RaycastParams.new()
                    params.FilterType = Enum.RaycastFilterType.Exclude
                    params.FilterDescendantsInstances = {LocalPlayer.Character}
                    while getgenv().autoShoot do
                        local cf = Camera.CFrame
                        local result = Workspace:Raycast(cf.Position, cf.LookVector * 250, params)
                        if ShootRemote then
                            pcall(function()
                                if result then
                                    ShootRemote:FireServer(cf, result.Instance, result.Instance.Position - result.Position, 1)
                                else
                                    ShootRemote:FireServer(cf, "Failed", cf.LookVector * 250, 1)
                                end
                            end)
                        end
                        task.wait()
                    end
                end)
            end
        end)

    local abilityCD = 0.05
    section:addSlider({
        text = "Ability Cooldown",
        min = 0,
        max = 3,
        step = 0.05,
        val = 0.05
    }, function(val)
        abilityCD = val
    end)

    local abilityLoop
    section:addToggle({ text = "Ability Spam", state = false })
        :bindToEvent("onToggle", function(state)
            if state then
                abilityLoop = task.spawn(function()
                    while true do
                        if ShootRemote then
                            pcall(function()
                                ShootRemote:FireServer(Camera.CFrame, nil, nil, 2)
                            end)
                        end
                        task.wait(abilityCD)
                    end
                end)
            else
                if abilityLoop then task.cancel(abilityLoop) abilityLoop = nil end
            end
        end)

    local instaReloadLoop
    section:addToggle({ text = "Insta Reload", state = false })
        :bindToEvent("onToggle", function(state)
            if state then
                instaReloadLoop = task.spawn(function()
                    local ReloadRemote = ReplicatedStorage:FindFirstChild("Reload")
                    while true do
                        local char = LocalPlayer.Character
                        if char and ReloadRemote then
                            for _, tool in ipairs(char:GetChildren()) do
                                if tool:IsA("Tool") then
                                    pcall(function()
                                        ReloadRemote:FireServer(tool)
                                    end)
                                end
                            end
                        end
                        task.wait(0.1)
                    end
                end)
            else
                if instaReloadLoop then task.cancel(instaReloadLoop) instaReloadLoop = nil end
            end
        end)
end

do
    local section = combatMenu:addSection({ text = "Remover", side = "right" })

    local portalConn, portalLoop
    local function removePortal(obj)
        if not obj then return end
        local name = string.lower(obj.Name or "")
        if name == "portal" or name:find("portal") then
            pcall(function() obj:Destroy() end)
        end
    end

    section:addToggle({ text = "Remove Portals", state = false })
        :bindToEvent("onToggle", function(state)
            if state then
                for _, obj in ipairs(Workspace:GetChildren()) do removePortal(obj) end
                portalConn = Workspace.ChildAdded:Connect(function(obj)
                    task.defer(function() removePortal(obj) end)
                end)
                portalLoop = task.spawn(function()
                    while true do
                        for _, obj in ipairs(Workspace:GetChildren()) do removePortal(obj) end
                        task.wait(0.7)
                    end
                end)
            else
                if portalConn then portalConn:Disconnect() portalConn = nil end
                if portalLoop then task.cancel(portalLoop) portalLoop = nil end
            end
        end)

    section:addButton({ text = "Remove Trident Particles", style = "small" }, function()
        local count = 0
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj.Name == "Trident" or obj.Name == "Trident Grip" then
                for _, v in ipairs(obj:GetDescendants()) do
                    if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                        pcall(function() v:Destroy() end)
                        count = count + 1
                    end
                end
            end
        end
        for _, player in ipairs(Players:GetPlayers()) do
            local containers = {player.Character, player:FindFirstChild("Backpack")}
            for _, container in ipairs(containers) do
                if container then
                    for _, obj in ipairs(container:GetDescendants()) do
                        if obj.Name == "Trident" or obj.Name == "Trident Grip" then
                            for _, v in ipairs(obj:GetDescendants()) do
                                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                                    pcall(function() v:Destroy() end)
                                    count = count + 1
                                end
                            end
                        end
                    end
                end
            end
        end
        ui.notify({ title = "Trident", message = "destroyed " .. count .. "idontknow", duration = 3 })
    end)

    local waveConn, waveLoop
    local function disableWave(obj)
        if not obj then return end
        if obj:IsA("Model") and (obj.Name == "Wave" or obj.Name:lower():find("wave")) then
            for _, part in ipairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.CanTouch = false
                    part.CanQuery = false
                end
            end
        end
        if obj:IsA("BasePart") and (obj.Name == "Wave" or obj.Name:lower():find("wave")) then
            obj.CanCollide = false
            obj.CanTouch = false
            obj.CanQuery = false
        end
    end

    section:addToggle({ text = "Disable Wave Damage", state = false })
        :bindToEvent("onToggle", function(state)
            if state then
                for _, obj in ipairs(Workspace:GetDescendants()) do disableWave(obj) end
                waveConn = Workspace.DescendantAdded:Connect(function(obj)
                    task.defer(function() disableWave(obj) end)
                end)
                waveLoop = task.spawn(function()
                    while true do
                        for _, obj in ipairs(Workspace:GetChildren()) do
                            if obj.Name == "Wave" or obj.Name:lower():find("wave") then
                                disableWave(obj)
                            end
                        end
                        task.wait(0.5)
                    end
                end)
            else
                if waveConn then waveConn:Disconnect() waveConn = nil end
                if waveLoop then task.cancel(waveLoop) waveLoop = nil end
            end
        end)

    local puddleConn, puddleLoop
    local function disablePuddle(obj)
        if not obj then return end
        local name = string.lower(obj.Name or "")
        if name:find("puddle") or name == "playerpuddle" then
            for _, part in ipairs(obj:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                    part.CanTouch = false
                    part.CanQuery = false
                end
            end
            if obj:IsA("BasePart") then
                obj.CanCollide = false
                obj.CanTouch = false
                obj.CanQuery = false
            end
        end
    end

    section:addToggle({ text = "Disable Puddles", state = false })
        :bindToEvent("onToggle", function(state)
            if state then
                for _, obj in ipairs(Workspace:GetDescendants()) do disablePuddle(obj) end
                puddleConn = Workspace.DescendantAdded:Connect(function(obj)
                    task.defer(function() disablePuddle(obj) end)
                end)
                puddleLoop = task.spawn(function()
                    while true do
                        for _, obj in ipairs(Workspace:GetChildren()) do disablePuddle(obj) end
                        task.wait(0.5)
                    end
                end)
            else
                if puddleConn then puddleConn:Disconnect() puddleConn = nil end
                if puddleLoop then task.cancel(puddleLoop) puddleLoop = nil end
            end
        end)
end

do
    local section = dupeMenu:addSection({ text = "Inventory Dupe & Dupe Others", side = "auto" })

    local function doInventoryDupe(character)
        local itemsFolder = Workspace:FindFirstChild("Items")
        if not itemsFolder or not character then return 0 end
        local count = 0
        for _, model in ipairs(character:GetChildren()) do
            if model:IsA("Model") then
                local itemVal = model:FindFirstChild("Item")
                if itemVal and itemVal:IsA("StringValue") then
                    for _, part in ipairs(model:GetDescendants()) do
                        if part:IsA("MeshPart") or part:IsA("BasePart") then
                            part.CanCollide = false
                            part.CanTouch = true
                            part.CanQuery = true
                        end
                    end
                    pcall(function()
                        model.Parent = itemsFolder
                    end)
                    count = count + 1
                end
            end
        end
        return count
    end

    local autoInvDupeLoop
    section:addToggle({ text = "Auto Inventory Dupe", state = false })
        :bindToEvent("onToggle", function(state)
            if state then
                autoInvDupeLoop = task.spawn(function()
                    while true do
                        local char = LocalPlayer.Character
                        if char then doInventoryDupe(char) end
                        task.wait(0.05)
                    end
                end)
            else
                if autoInvDupeLoop then task.cancel(autoInvDupeLoop) autoInvDupeLoop = nil end
            end
        end)

    local autoOthersDupeLoop
    section:addToggle({ text = "Auto Dupe Others", state = false })
        :bindToEvent("onToggle", function(state)
            if state then
                autoOthersDupeLoop = task.spawn(function()
                    while true do
                        for _, player in ipairs(Players:GetPlayers()) do
                            if player ~= LocalPlayer and player.Character then
                                doInventoryDupe(player.Character)
                            end
                        end
                        task.wait(0.05)
                    end
                end)
            else
                if autoOthersDupeLoop then task.cancel(autoOthersDupeLoop) autoOthersDupeLoop = nil end
            end
        end)
end

do
    local section = dupeMenu:addSection({ text = "Extras", side = "auto" })

    section:addButton({ text = "Force Weapon to Hand", style = "small" }, function()
        local char = LocalPlayer.Character
        if not char then return end
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if humanoid and backpack then
            for _, tool in ipairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    pcall(function() humanoid:EquipTool(tool) end)
                    ui.notify({ title = "Force to Hand", message = tool.Name, duration = 3 })
                    return
                end
            end
        end
    end)
end

--==================== jojojo all ia slop game tung tung tung sahur300maxmilawjhdgasd ====================
do
    local section = espMenu:addSection({ text = "ESP", side = "auto" })

    local function destroyHighlight(hl)
        pcall(function() hl:Destroy() end)
    end

    local itemHighlights = {}
    local itemsESPEnabled = false
    local itemsESPConnection, itemsESPLoop

    local function clearItemESP()
        for _, hl in pairs(itemHighlights) do destroyHighlight(hl) end
        itemHighlights = {}
    end

    local function addItemHighlight(obj)
        if itemHighlights[obj] then return end
        if not (obj:IsA("Model") or obj:IsA("BasePart")) then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "ItemESP"
        highlight.Adornee = obj
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 60, 60)
        highlight.FillTransparency = 0.45
        highlight.OutlineTransparency = 0.2
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = obj
        itemHighlights[obj] = highlight
    end

    local function updateItemsESP()
        local itemsFolder = Workspace:FindFirstChild("Items")
        if not itemsFolder then return end
        for _, obj in ipairs(itemsFolder:GetChildren()) do addItemHighlight(obj) end
        for obj, hl in pairs(itemHighlights) do
            if not obj or not obj.Parent or obj.Parent ~= itemsFolder then
                destroyHighlight(hl)
                itemHighlights[obj] = nil
            end
        end
    end

    section:addToggle({ text = "Items ESP", state = false })
        :bindToEvent("onToggle", function(state)
            itemsESPEnabled = state
            if state then
                clearItemESP()
                updateItemsESP()
                local itemsFolder = Workspace:FindFirstChild("Items")
                if itemsFolder then
                    itemsESPConnection = itemsFolder.ChildAdded:Connect(function(obj)
                        task.wait(0.1)
                        if itemsESPEnabled then addItemHighlight(obj) end
                    end)
                end
                itemsESPLoop = task.spawn(function()
                    while itemsESPEnabled do
                        updateItemsESP()
                        task.wait(1)
                    end
                end)
            else
                if itemsESPConnection then itemsESPConnection:Disconnect() itemsESPConnection = nil end
                if itemsESPLoop then task.cancel(itemsESPLoop) itemsESPLoop = nil end
                clearItemESP()
            end
        end)

    -- you are the next.
    local playerHighlights = {}
    local playerESPEnabled = false
    local playerESPConnections = {}

    local function clearPlayerESP()
        for _, hl in pairs(playerHighlights) do destroyHighlight(hl) end
        playerHighlights = {}
    end

    local function addPlayerHighlight(player)
        if player == LocalPlayer then return end
        if playerHighlights[player] then return end
        local char = player.Character
        if not char then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "PlayerESP"
        highlight.Adornee = char
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 80, 80)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0.15
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char
        playerHighlights[player] = highlight
    end

    section:addToggle({ text = "Players ESP", state = false })
        :bindToEvent("onToggle", function(state)
            playerESPEnabled = state
            if state then
                clearPlayerESP()
                for _, player in ipairs(Players:GetPlayers()) do
                    addPlayerHighlight(player)
                    playerESPConnections[player] = player.CharacterAdded:Connect(function()
                        task.wait(0.4)
                        if playerESPEnabled then addPlayerHighlight(player) end
                    end)
                end
                Players.PlayerAdded:Connect(function(player)
                    playerESPConnections[player] = player.CharacterAdded:Connect(function()
                        task.wait(0.4)
                        if playerESPEnabled then addPlayerHighlight(player) end
                    end)
                end)
                Players.PlayerRemoving:Connect(function(player)
                    if playerHighlights[player] then
                        destroyHighlight(playerHighlights[player])
                        playerHighlights[player] = nil
                    end
                end)
            else
                for _, conn in pairs(playerESPConnections) do
                    pcall(function() conn:Disconnect() end)
                end
                playerESPConnections = {}
                clearPlayerESP()
            end
        end)

    -- tung tung tung sahur
    local monsterHighlights = {}
    local monsterESPEnabled = false
    local monsterESPConnection, monsterESPLoop

    local function clearMonsterESP()
        for _, hl in pairs(monsterHighlights) do destroyHighlight(hl) end
        monsterHighlights = {}
    end

    local function addMonsterHighlight(model)
        if monsterHighlights[model] then return end
        if not model:IsA("Model") then return end
        local highlight = Instance.new("Highlight")
        highlight.Name = "MonsterESP"
        highlight.Adornee = model
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.OutlineColor = Color3.fromRGB(255, 40, 40)
        highlight.FillTransparency = 0.4
        highlight.OutlineTransparency = 0.1
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = model
        monsterHighlights[model] = highlight
    end

    local function updateMonsterESP()
        local folder = Workspace:FindFirstChild("Monsters") or Workspace:FindFirstChild("Entities")
        if not folder then return end
        for _, model in ipairs(folder:GetChildren()) do
            if model:IsA("Model") then addMonsterHighlight(model) end
        end
        for model, hl in pairs(monsterHighlights) do
            if not model or not model.Parent then
                destroyHighlight(hl)
                monsterHighlights[model] = nil
            end
        end
    end

    section:addToggle({ text = "Monsters ESP", state = false })
        :bindToEvent("onToggle", function(state)
            monsterESPEnabled = state
            if state then
                clearMonsterESP()
                updateMonsterESP()
                local folder = Workspace:FindFirstChild("Monsters") or Workspace:FindFirstChild("Entities")
                if folder then
                    monsterESPConnection = folder.ChildAdded:Connect(function(obj)
                        task.wait(0.15)
                        if monsterESPEnabled and obj:IsA("Model") then addMonsterHighlight(obj) end
                    end)
                end
                monsterESPLoop = task.spawn(function()
                    while monsterESPEnabled do
                        updateMonsterESP()
                        task.wait(1.2)
                    end
                end)
            else
                if monsterESPConnection then monsterESPConnection:Disconnect() monsterESPConnection = nil end
                if monsterESPLoop then task.cancel(monsterESPLoop) monsterESPLoop = nil end
                clearMonsterESP()
            end
        end)
end

do
    local section = miscMenu:addSection({ text = "Utility", side = "auto" })

    section:addToggle({ text = "Item Aura", state = false })
        :bindToEvent("onToggle", function(state)
            getgenv().ItemAura = state
            if state then
                task.spawn(function()
                    while getgenv().ItemAura do
                        local items = Workspace:FindFirstChild("Items")
                        local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if items and hrp and InventoryRemote then
                            for _, item in ipairs(items:GetChildren()) do
                                local pos = item.PrimaryPart and item.PrimaryPart.Position
                                if pos and (pos - hrp.Position).Magnitude < 90 then
                                    pcall(function()
                                        InventoryRemote:FireServer("PickUp", item)
                                    end)
                                end
                            end
                        end
                        task.wait(0.25)
                    end
                end)
            end
        end)

    local autoConsumeLoop
    local Consumables = {
        "Bread", "Cupcake", "LargeAlmondWater", "Pizza", "Burger",
        "Energy Drink", "Spaghetti", "AlmondWater", "Dino Nuggies" -- ignore this pls
    }

    local function isConsumable(name)
        if not name then return false end
        local lower = string.lower(name)
        for _, item in ipairs(Consumables) do
            if lower:find(string.lower(item)) then return true end
        end
        return false
    end

    section:addToggle({ text = "Auto Consume", state = false })
        :bindToEvent("onToggle", function(state)
            if state then
                autoConsumeLoop = task.spawn(function()
                    while true do
                        local backpack = LocalPlayer:FindFirstChild("Backpack")
                        local character = LocalPlayer.Character
                        local UseItem = ReplicatedStorage:FindFirstChild("UseItem")
                        if UseItem then
                            if backpack then
                                for _, item in ipairs(backpack:GetChildren()) do
                                    if item:IsA("Tool") and isConsumable(item.Name) then
                                        pcall(function() UseItem:FireServer(item) end)
                                        task.wait(1.5)
                                    end
                                end
                            end
                            if character then
                                for _, item in ipairs(character:GetChildren()) do
                                    if item:IsA("Tool") and isConsumable(item.Name) then
                                        pcall(function() UseItem:FireServer(item) end)
                                        task.wait(0.9)
                                    end
                                end
                            end
                        end
                        task.wait(0.9)
                    end
                end)
            else
                if autoConsumeLoop then task.cancel(autoConsumeLoop) autoConsumeLoop = nil end
            end
        end)
end

do
    local section = hubMenu:addSection({ text = "Experimental", side = "auto" })

    section:addButton({ text = "Inventory Fixer", style = "small" }, function()
        pcall(function()
            LocalPlayer.PlayerGui.Inventory.Inventory.Visible = true
        end)
    end)

    local autoSpinLoop
    section:addToggle({ text = "Auto Spin", state = false })
        :bindToEvent("onToggle", function(state)
            if state then
                autoSpinLoop = task.spawn(function()
                    while true do
                        local spinner = ReplicatedStorage:FindFirstChild("SpinnerModule")
                        if spinner then
                            local remote = spinner:FindFirstChild("RemoteFunction") or spinner:FindFirstChildWhichIsA("RemoteFunction")
                            if remote then
                                pcall(function() remote:InvokeServer() end)
                            end
                        end
                        task.wait(0.15)
                    end
                end)
            else
                if autoSpinLoop then task.cancel(autoSpinLoop) autoSpinLoop = nil end
            end
        end)

    section:addButton({ text = "Spinner", style = "small" }, function()
        local spinner = ReplicatedStorage:FindFirstChild("SpinnerModule")
        if spinner then
            local remote = spinner:FindFirstChild("RemoteFunction") or spinner:FindFirstChildWhichIsA("RemoteFunction")
            if remote then
                pcall(function() remote:InvokeServer() end)
            end
        end
    end)
end

ui.notify({
    title = "LOL HUB",
    message = "LOL HUB is now open source",
    duration = 4
})
-- ya yayayay