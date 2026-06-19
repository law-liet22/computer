-- Mes fonctions utilitaires
local utils = require("/backend/utils/functions")

-- Trouvé si un modem est connecté et ouvrir rednet (si rednet ne s'ouvre pas, alors pas de modem)
peripheral.find("modem", rednet.open)
if not rednet.isOpen() then
    error("Aucun modem trouve !")
end

-- Variables/constantes
local PROTOCOLE = "api_rp"
local NOM_SERVEUR = "serveur_central"
local FICHIER_DB = "bdd_utilisateurs.txt"
local FICHIER_LOGS = "logs.txt"
local FICHIER_INTERFACE_CLIENT = "/backend/interface/interface.lua"
local FICHIER_FONCTIONS_CLIENT = "/backend/interface/fonctions.lua"
local bdd = {}
local logs = ""

-- Message lors du démarrage du serveur
local msgServeurDemarre = "Serveur [" .. NOM_SERVEUR .. "] demarre sur le protocole [" .. PROTOCOLE .. "]."

utils.envoyerLogDiscord("D\233marrage", msgServeurDemarre, tonumber(0xFF0000), "https://discord.com/api/webhooks/1517216741502091284/P85rO3fNTuFL9wlLSCdm_-K895vy_n7g-_BNWOULWoepqBRS8k5o2gwGtU3NOlBBNY2H")

-- Clear le terminal 
term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1, 1)
term.setCursorBlink(true)

-- Mettre le serveur en host
rednet.host(PROTOCOLE, NOM_SERVEUR)

-- Log le demarrage du serveur 
utils.ajouterLogEtPrint(msgServeurDemarre, FICHIER_LOGS)
print("En attente de requetes...\n")

-- Watcher pour tenir compte des changements dans la base de données de manière dynamique
local function watcherBdd()

    -- Charger les données initiales
    bdd = utils.chargerDonnees(FICHIER_DB, FICHIER_LOGS, bdd, logs)

    local derniereModif = 0

    -- Vérifier si le fichier existe
    if fs.exists(FICHIER_DB) then
        -- Prendre la date de la dernière modification
        derniereModif = fs.attributes(FICHIER_DB).modified
    else
        -- Si aucun fichier de base de données est trouvé, alors on return pour arrêter le serveur pour limiter la charge
        return
    end

    while true do
        sleep(2)
        
        if fs.exists(FICHIER_DB) then
            local modifActuelle = fs.attributes(FICHIER_DB).modified

            if modifActuelle > derniereModif then
                utils.ajouterLogEtPrint("[SYSTEME] BDD modifiee, rechargement.", FICHIER_LOGS)
                bdd = utils.chargerDonnees(FICHIER_DB, FICHIER_LOGS, bdd, logs)
                derniereModif = modifActuelle
                utils.ajouterLogEtPrint("[SYSTEME] BDD mise a jour en RAM.", FICHIER_LOGS)
            end
        else
            return
        end
    end
end

local function routeurReseau()
    while true do
        local expediteur, requete, protocoleRecu = rednet.receive(PROTOCOLE)

        if type(requete) == "table" and requete.action then
            local msgLog = "Requete recue de l'ID " .. expediteur .. " : " .. requete.action
            utils.ajouterLogEtPrint(msgLog, FICHIER_LOGS)

            local reponse = { statut = "error", message = "Action inconnue" }

            if requete.action == "connexion" then
                local nomUser = requete.user 
                local mdp = requete.mdp

                if bdd[nomUser] and bdd[nomUser].mdp == mdp then
                    reponse = { statut = "succes", message = "Connexion reussie", role = bdd[nomUser].role, departement = bdd[nomUser].departement }
                else
                    reponse = { statut = "error", message = "Identifiants incorrects. Si vous n'avez pas encore de compte sur le reseau, veuillez en demander au plus vite a l'ASIA." }
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
                if fs.exists(FICHIER_INTERFACE_CLIENT) and fs.exists(FICHIER_FONCTIONS_CLIENT) then
                    local fichierCode = fs.open(FICHIER_INTERFACE_CLIENT, "r")
                    local codeSource = fichierCode.readAll()
                    local fichierCodeFonctions = fs.open(FICHIER_FONCTIONS_CLIENT, "r")
                    local fonctionsClients = fichierCodeFonctions.readAll()
                    fichierCodeFonctions.close()
                    fichierCode.close()                    

                    reponse = { statut = "succes", code = codeSource, fonctions = fonctionsClients }
                else
                    reponse = { statut = "error", message = "Fichier source introuvable sur le serveur." }
                end
            end

            rednet.send(expediteur, reponse, PROTOCOLE)
        end
    end
end

parallel.waitForAny(watcherBdd, routeurReseau)

utils.ajouterLogEtPrint("[SYSTEME] Le serveur s'est arrete de maniere inatendue.", FICHIER_LOGS)