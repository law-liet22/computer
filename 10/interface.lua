local utils = require("/fonctions")

peripheral.find("modem", rednet.open)
if not rednet.isOpen() then
    error("Aucun modem trouve !")
end

local PROTOCOLE = "api_rp"
local NOM_SERVEUR = "serveur_central"

print("Recherche du serveur...")

local idServeur = rednet.lookup(PROTOCOLE, NOM_SERVEUR)

if not idServeur then
    error("Impossible de connecter le serveur central.")
end

print("Serveur trouve (ID : " .. idServeur .. ")")

local function faireRequete(donnees)
    rednet.send(idServeur, donnees, PROTOCOLE)

    local id, reponse = rednet.receive(PROTOCOLE, 5)

    if reponse then
        return reponse
    else
        return { statut = "erreur", message = "Delai d'attente depasse (timeout)"}
    end
end

local isInMenu = true

while true do
    term.clear()
    term.setCursorPos(1, 1)
    print("=== CONNEXION ===")
    write("Utilisateur : ")
    local util = read()
    write("Mot de passe : ")
    local mdp = read("*")

    print("\nAuthentification en cours...")

    local requeteConnexion = {
        action = "connexion",
        user = util,
        mdp = mdp
    }

    local result = faireRequete(requeteConnexion)

    print("\n--- REPONSE DU SERVEUR ---")
    if result.statut == "succes" then
        print("Succes : " .. result.message)
        print("Votre role : " .. result.role)
        print("Votre departement : " .. result.departement)
        sleep(3)
        while isInMenu do
            utils.clearTerminalAndShowInfos(result.role, result.departement)
            utils.afficherMenu(result.role)
            print("Que souhaitez vous faire ?")
            local choix = read()
        end


    else
        print("Erreur : " .. result.message)
        sleep(3)
    end
end
