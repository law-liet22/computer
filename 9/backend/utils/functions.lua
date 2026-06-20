local function getCurrentTimeParis()
    local url = "https://timeapi.io/api/v1/time/current/zone?timezone=Europe%2FParis"
    local req = { url = url}
    local res = http.get(req)

    if res then
        local rawJson = res.readAll()
        res.close()

        local data = textutils.unserialiseJSON(rawJson)

        if data and data.date_time then
            local date = string.sub(data.date_time, 1, 10)
            local heure = string.sub(data.date_time, 12, 19)
            return 200, date, heure
        else
            return 404, nil, nil
        end
    else
        return 500, nil, nil
    end
end

local function sauvegarderDonnees(FICHIER_DB, bdd)
    local fichier = fs.open(FICHIER_DB, "w")

    fichier.write(textutils.serialise(bdd))
    fichier.close()
end

local function chargerDonnees(FICHIER_DB, FICHIER_LOGS, bdd, logs)
    if fs.exists(FICHIER_DB) then
        local fichier = fs.open(FICHIER_DB, "r")
        local contenu = fichier.readAll()
        fichier.close()

        bdd = textutils.unserialise(contenu) or {}
        print("Base de donnees chargee.") -- (" .. #bdd .. " entrees)")
        return bdd
    else
        print("Nouvelle base de donnees creee.")
        bdd = {
            admin = { mdp = "secret", role = "administrateur" }
        }

        return bdd
    end
    
    if fs.exists(FICHIER_LOGS) then
        local fichier = fs.open(FICHIER_LOGS, "r")
        local contenu = fichier.readAll()
        fichier.close()

        logs = contenu
        print("Logs charges.")
    else
        print("Nouveau fichier log cree.")
        logs = "Nouveau fichier"
    end
    sauvegarderDonnees(FICHIER_DB, bdd)
end



local function ajouterLogEtPrint(msg, FICHIER_LOGS)

    if msg == nil then
        return
    end

    local fichier = fs.open(FICHIER_LOGS, "a")
    local apiStatus, date, heure = getCurrentTimeParis()

    if apiStatus == 200 then
        fichier.write("[" .. date .. "T" .. heure .. "] " .. msg .. "\n")
        print("[" .. date .. "T" .. heure .. "] " .. msg .. "\n")
    elseif apiStatus == 404 then
        fichier.write("[N/A : 404] " .. msg .. "\n")
        print("[N/A : 404] " .. msg .. "\n")
    elseif apiStatus == 500 then
        fichier.write("[N/A : 500] " .. msg .. "\n")
        print("[N/A : 500] " .. msg .. "\n")
    end

    fichier.close()
end

local function envoyerLogDiscord(title, msg, color, webhookUrl)
    local embed = {
        title = title,
        description = msg,
        color = color
    }

    local payload = {
        content = "",
        embeds = {
            [1] = embed
        }
    }

    local jsonPayload = textutils.serialiseJSON(payload)

    local headers = {
        ["Content-Type"] = "application/json"
    }

    local response, err, errResponse = http.post(webhookUrl, jsonPayload, headers)
    
    if response then
        print("Webhook envoye.")
        response.close()
    else
        print("Erreur d'envoi (" .. tostring(err) .. ")")
        if errResponse then
            print("Reponse de Discord : " .. errResponse.readAll())
            sleep(3)
            errResponse.close()
        end
    end
end

return { getCurrentTimeParis = getCurrentTimeParis, 
        chargerDonnees = chargerDonnees, 
        sauvegarderDonnees = sauvegarderDonnees,
        ajouterLogEtPrint = ajouterLogEtPrint,
        envoyerLogDiscord = envoyerLogDiscord
    }