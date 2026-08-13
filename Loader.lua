if not game:IsLoaded() then
    game.Loaded:Wait()
end

if identifyexecutor then
    local execName = tostring(identifyexecutor()):lower()
    if execName:find("solara") or execName:find("xeno") then
        game:GetService("Players").LocalPlayer:Kick(
            "EXECUTOR NOT SUPPORTED\n[PLEASE DON'T GET MAD THIS IS SOLARA/XENO'S FAULT]"
        )
        return
    end
end

local BASE = "https://raw.githubusercontent.com/Walter072/LOL/main/games/"

local games = {
    [5088137] = "Da-Backrooms.lua",
    [490911723] = "+1-pickaxe.lua",
}

local file = games[game.CreatorId] or places[game.PlaceId]

if file then
    local url = BASE .. file
    print("Game detected. Loading:", file)

    local ok, result = pcall(function()
        return game:HttpGet(url)
    end)

    if ok and result and #result > 0 then
        local loadOk, loadErr = pcall(function()
            loadstring(result)()
        end)

        if loadOk then
            print("Successfully loaded script")
        else
            warn("Error running the script:", loadErr)
        end
    else
        warn("Script not loaded:", url)
    end
else
    warn("This game is not supported")
    warn("[Loader] CreatorId:", game.CreatorId, "| PlaceId:", game.PlaceId)

    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Loader",
            Text = "Game not supported\nCreatorId: " .. tostring(game.CreatorId),
            Duration = 5
        })
    end)
end