local function clearTerminal()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.clear()
    term.setCursorPos(1, 1)
end

local function clearTerminalAndShowInfos(role, departement)
    clearTerminal()
    print("Role : " .. role .."\nDepartement : " .. departement .. "\n\n")
end

local function menuAdmin()
    return "1. Creer compte utilisateur\n2. Supprimer compte utilisateur\n 3. Modifier compte utilisateur\n4. Vos informations\n5. Acceder aux fichiers"
end

local function menuUser()
    return "1. Vos informations\n2. Acceder aux fichiers"
end

local function menuSuperAdmin()
    return "1. Creer compte utilisateur\n2. Supprimer compte utilisateur\n 3. Modifier compte utilisateur\n4. Gerer comptes admin\n5. Vos informations\n6. Acceder aux fichiers"
end

local function afficherMenu(userRole)
    if userRole == "admin" then
        print(menuAdmin())
    elseif userRole == "user" then
        print(menuUser())
    elseif userRole == "superadmin" then
        print(menuSuperAdmin())
    end
    print("\n")
end

return { clearTerminal = clearTerminal,
        clearTerminalAndShowInfos = clearTerminalAndShowInfos,
        afficherMenu = afficherMenu
}