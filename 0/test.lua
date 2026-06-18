local mon = peripheral.find("monitor")
if not mon then
    print("Erreur : aucun moniteur trouve")
    return
end

mon.setTextScale(1)

term.redirect(mon)

local comptes = {
    ["testBright"] = "ez",
    ["test2"] = "yyy"
}

local function dessinCadre()
    local x, y = term.getSize()
    term.setBackgroundColor(colors.black)
    term.clear()

    term.setBackgroundColor(colors.red)
    term.setCursorPos(1, 1)
    term.write(string.rep(" ", x))
    term.setCursorPos(2, 1)
    term.setTextColor(colors.white)
    term.write("Test Terminaux")

    term.setBackgroundColor(colors.black)
end

local function drawLoginScreen()
    dessinCadre()
    local x, y = term.getSize()

    term.setTextColor(colors.lightGray)
    term.setCursorPos(3, 4)
    term.write("ASIA")

    term.setCursorPos(3, 6)
    term.setTextColor(colors.gray)
    term.write("Acces non autorise n'est pas tolere")

    term.setTextColor(colors.white)
    term.setCursorPos(5, 10)
    term.write("IDENTIFIANT : ")

    term.setCursorPos(5, 12)
    term.write("MDP : ")
end

local function afficherSucces(user)
    term.setBackgroundColor(colors.green)
    term.clear()
    term.setTextColor(colors.white)

    local x, y = term.getSize()
    local msg = "Bienvenue " .. string.upper(user)
    term.setCursorPos(math.floor((x - #msg)/2), math.floor(y/2))
    term.write(msg)

    redstone.setOutput("bottom", true)
    sleep(3)
    redstone.setOutput("bottom", false)
end

local function afficherEchec()
    term.setBackgroundColor(colors.red)
    term.clear()
    term.setTextColor(colors.white)

    local x, y = term.getSize()
    local msg1 = "ID INCORRECT"
    local msg2 = "TENTATIVE ENREGISTREE"

    term.setCursorPos(math.floor((x - #msg1)/2), math.floor(y/2) - 1)
    term.write(msg1)
    term.setCursorPos(math.floor((x - #msg2)/2), math.floor(y/2) + 1)
    term.write(msg2)

    sleep(4)
end

while true do
    drawLoginScreen()

    term.setCursorPos(19, 10)
    term.setCursorBlink(true)
    term.setTextColor(colors.yellow)
    local inputUser = read()

    term.setCursorPos(20, 12)
    term.setTextColor(colors.yellow)
    local inputPassword = read("*")

    inputUser = string.lower(inputUser:match("^%s*(.-)%s*$"))

    if comptes[inputUser] and comptes[inputUser] == inputPassword then
        afficherSucces(inputUser)
    else
        afficherEchec()
    end
end