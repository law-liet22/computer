local utils = require("/backend/utils/functions")

local PROTOCOLE = "api_rp"
local NOM_SERVEUR = "serveur_central"
local FICHIER_DB = "bdd_utilisateurs.txt"
local bdd = {}
local FICHIER_LOGS = "logs.txt"
local logs = ""
local FICHIER_INTERFACE_CLIENT = "/backend/interface/interface.lua"

local function maFonction()
    bdd = utils.chargerDonnees(FICHIER_DB, FICHIER_LOGS, bdd, logs)
    os.sleep(5)
    return bdd
end

bdd = parallel.waitForAny(maFonction)

print("test")
print("test")