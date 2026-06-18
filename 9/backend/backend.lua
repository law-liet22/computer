local utils = require("/backend/utils/functions")

peripheral.find("modem", rednet.open)
if not rednet.isOpen() then
    error("Aucun modem trouve !")
end

local PROTOCOLE = "api_rp"
local NOM_SERVEUR = "serveur_central"
local FICHIER_DB = "bdd_utilisateurs.txt"
local bdd = {}
local FICHIER_LOGS = "logs.txt"
local logs = ""
local FICHIER_INTERFACE_CLIENT = "/backend/interface/interface.lua"

local msgServeurDemarre = "Serveur [" .. NOM_SERVEUR .. "] demarre sur le protocole [" .. PROTOCOLE .. "]."

--[[local function chargerDonnees()
    if fs.exists(FICHIER_DB) then
        local fichier = fs.open(FICHIER_DB, "r")
        local contenu = fichier.readAll()
        fichier.close()

        bdd = textutils.unserialise(contenu) or {}
        print("Base de donnees chargee.") -- (" .. #bdd .. " entrees)")
    else
        print("Nouvelle base de donnees creee.")
        bdd = {
            admin = { mdp = "secret", role = "administrateur" }
        }
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
    sauvegarderDonnees()
end]]

--[[function sauvegarderDonnees()
    local fichier = fs.open(FICHIER_DB, "w")

    fichier.write(textutils.serialise(bdd))
    fichier.close()
end
]]

function ajouterLogEtPrint(msg)

    if msg == nil then
        return
    end

    local fichier = fs.open(FICHIER_LOGS, "a")
    local apiStatus, date, heure = utils.getCurrentTimeParis()

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
bdd = utils.chargerDonnees(FICHIER_DB, FICHIER_LOGS, bdd, logs)

term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1, 1)
term.setCursorBlink(true)
rednet.host(PROTOCOLE, NOM_SERVEUR)

ajouterLogEtPrint(msgServeurDemarre)
print("En attente de requetes...\n")

while true do
    local expediteur, requete, protocoleRecu = rednet.receive(PROTOCOLE)

    if type(requete) == "table" and requete.action then
        local msgLog = "Requete recue de l'ID " .. expediteur .. " : " .. requete.action
        ajouterLogEtPrint(msgLog)

        local reponse = { statut = "error", message = "Action inconnue" }

        if requete.action == "connexion" then
            local nomUser = requete.user 
            local mdp = requete.mdp

            if bdd[nomUser] and bdd[nomUser].mdp == mdp then
                reponse = { statut = "succes", message = "Connexion reussie", role = bdd[nomUser].role }
            else
                reponse = { statut = "error", message = "Identifiants incorrects" }
            end

        elseif requete.action == "createAccount" then
            local nomUser = requete.user
            local mdp = requete.mdp

            if bdd[nomUser] then
                reponse = { statut = "error", message = "Cet utilisateur existe deja" }
            else
                bdd[nomUser] = { mdp = mdp, role = "utilisateur" }
                utils.sauvegarderDonnees(FICHIER_DB, bdd)
                reponse = { statut = "succes", message = "Compte cree avec succes !" }
            end

        elseif requete.action == "telechargerMaj" then
            if fs.exists(FICHIER_INTERFACE_CLIENT) then
                local fichierCode = fs.open(FICHIER_INTERFACE_CLIENT, "r")
                local codeSource = fichierCode.readAll()
                fichierCode.close()

                reponse = { statut = "succes", code = codeSource }
            else
                reponse = { statut = "error", message = "Fichier source introuvable sur le serveur." }
            end
        end

        rednet.send(expediteur, reponse, PROTOCOLE)
    end
end