NDCore = exports["ND_Core"]:GetCoreObject()
NDCore.Functions.VersionChecker("ND_Jailing", GetCurrentResourceName(), "https://github.com/Andyyy7666/ND_Framework", "https://raw.githubusercontent.com/Andyyy7666/ND_Framework/main/ND_Jailing/fxmanifest.lua")

local jailedPlayers = {}

-- Get player any identifier, available types: steam, license, xbl, ip, discord, live.
function GetPlayerIdentifierFromType(type, source)
    local identifierCount = GetNumPlayerIdentifiers(source)
    for count = 0, identifierCount do
        local identifier = GetPlayerIdentifier(source, count)
        if identifier and string.find(identifier, type) then
            return identifier
        end
    end
    return nil
end

-- send discord embed with webhook.
function sendToDiscord(name, message, color)
    local embed = {
        {
            title = name,
            description = message,
            footer = {
                icon_url = "https://i.imgur.com/notBtrZ.png",
                text = "Created by Andyyy#7666"
            },
            color = color
        }
    }
    PerformHttpRequest(server_config.discordWebhook, function(err, text, headers) end, 'POST', json.encode({username = "ND Jailing", embeds = embed}), {["Content-Type"] = "application/json"})
end

-- Jail player discord log, trigger the event on the player's client and send a message to everyone.
RegisterNetEvent("ND_Jailing:jailPlayer", function(id, time, fine, reason)
    local player = source
    local players = NDCore.Functions.GetPlayers()
    local dept = players[player].job
    local character = NDCore.Functions.GetPlayer(id) -- Get jailed person's character
    local jailingOfficer = character.firstName .. " " .. character.lastName .. " (" .. character.job .. ")" -- Get jailing officer's name
    local jailedPerson = character.firstName .. " " .. character.lastName -- Get jailed person's name

    for _, department in pairs(config.accessDepartments) do
        if department == dept then
            jailedPlayers[GetPlayerIdentifierFromType("license", id)] = time
            NDCore.Functions.DeductMoney(fine, id, "bank")
            TriggerClientEvent("ND_Jailing:jailPlayer", id, time)

            if GetResourceState('ModernHUD') == 'started' then
                TriggerClientEvent("ND_Jailing:TriggerModernHUDNotify", -1, jailingOfficer, jailedPerson, time, reason)
            else
                TriggerClientEvent('chat:addMessage', -1, {
                    color = { 255, 0, 0 },
                    multiline = true,
                    args = {"[Judge]", jailingOfficer .. " jailed " .. jailedPerson .. " for " .. time .. " seconds with the reason: " .. reason}
                })
            end

            sendToDiscord("Jail Logs", "**" .. jailingOfficer .. "** jailed **" .. jailedPerson .. "** for **" .. time .. " seconds** with the reason: **" .. reason .. "**.", 1595381)
            break
        end
    end
end)



RegisterNetEvent("ND_Jailing:updateJailing", function(time)
    local player = source
    if time == 0 then
        jailedPlayers[GetPlayerIdentifierFromType("license", player)] = nil
    else
        jailedPlayers[GetPlayerIdentifierFromType("license", player)] = time
    end
end)

-- Gets all players on the server and adds them to a table.
RegisterNetEvent("ND_Jailing:getPlayers", function()
    local players = {}
    for _, id in pairs(GetPlayers()) do
        players[id] = "(" .. id .. ") " .. GetPlayerName(id)
    end
    TriggerClientEvent("ND_Jailing:returnPlayers", source, players)
end)

RegisterNetEvent("ND_Jailing:getJailTime", function()
    local player = source
    local time = jailedPlayers[GetPlayerIdentifierFromType("license", player)]
    if time then
        TriggerClientEvent("ND_Jailing:jailPlayer", player, time)
    end
end)