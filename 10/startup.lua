local PROTOCOLE = "api_rp"
local NOM_SERVEUR = "serveur_central"
local FICHIER_CIBLE = "interface.lua"


term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()
term.setCursorPos(1, 1)

peripheral.find("modem", rednet.open)
if not rednet.isOpen() then
    print("Erreur : modem introuvable.")
    sleep(2)

else
    print("Recherche de mise a jour")
    local idServeur = rednet.lookup(PROTOCOLE, NOM_SERVEUR)

    if idServeur then
        rednet.send(idServeur, { action = "telechargerMaj" }, PROTOCOLE)
        local id, reponse = rednet.receive(PROTOCOLE, 5) -- Timeout 5 sec

        if reponse and reponse.statut == "succes" then
            local fichier = fs.open(FICHIER_CIBLE, "w")
            fichier.write(reponse.code)
            fichier.close()
            print("Mise a jour appliquee.")
            sleep(4)
        else
            print("Echec de la recuperation de la maj.")
            print(reponse.statut .. " : " .. reponse.message)
            sleep(1)
        end
    else
        print("Serveur introuvable.")
        sleep(1)
    end
end

if fs.exists(FICHIER_CIBLE) then
    shell.run(FICHIER_CIBLE)
else
    print("Erreur : aucun system installe sur ce pc.")
end