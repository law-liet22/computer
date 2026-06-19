local function clearTerminal()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.clear()
    term.setCursorPos(1, 1)
end

local function clearTerminalAndShowInfos(role, departement)
    clearTerminal()
    print("Role : " .. role .."\n Departement : " .. departement .. "\n\n")
end

local function afficherMenu(userRole)
    print("1. Vos informations")
    print("2. Consulter les fichiers")
end

return { clearTerminal = clearTerminal,
        clearTerminalAndShowInfos = clearTerminalAndShowInfos,
        afficherMenu = afficherMenu
}