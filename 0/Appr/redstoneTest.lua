local programInit = require("../fonctions/programInit")

programInit.progInit(colors.black, colors.white)

local CODE = "4567"

local function main()

    print("Entrez le code :")
    local answer = read()

    if answer == CODE then
        term.clear()
        term.setCursorPos(1, 1)
        print("Code correct, bienvenue !")
        redstone.setOutput("back", true)
        sleep(5)
        redstone.setOutput("back", false)
        term.clear()
        term.setCursorPos(1, 1)
    else
        term.clear()
        term.setCursorPos(1, 1)
        print("Code incorrect.")
        sleep(5)
        term.clear()
        term.setCursorPos(1, 1)
    end
end

while true do
    main()
end