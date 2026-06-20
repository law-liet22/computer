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

local MENUS = {
  user = {
    { key = "logout", label = "Se deconnecter" },
    { key = "my_infos", label = "Vos informations" },
    { key = "files", label = "Acceder aux fichiers" },
  },
  admin = {
    { key = "logout", label = "Se deconnecter" },
    { key = "create_user", label = "Creer compte utilisateur" },
    { key = "delete_user", label = "Supprimer compte utilisateur" },
    { key = "update_user", label = "Modifier compte utilisateur" },
    { key = "my_infos", label = "Vos informations" },
    { key = "files", label = "Acceder aux fichiers" },
  },
  superadmin = {
    { key = "logout", label = "Se deconnecter" },
    { key = "create_user", label = "Creer compte utilisateur" },
    { key = "delete_user", label = "Supprimer compte utilisateur" },
    { key = "update_user", label = "Modifier compte utilisateur" },
    { key = "manage_admins", label = "Gerer comptes admin" },
    { key = "my_infos", label = "Vos informations" },
    { key = "files", label = "Acceder aux fichiers" },
  }
}

local function getMenuForRole(userRole)
    return MENUS[userRole]
end

local function afficherMenu(userRole)
    local menu = getMenuForRole(userRole)

    if not menu then
        print("Role inconnu : " .. tostring(userRole))
        print("\n")
        return
    end

    for index, item in ipairs(menu) do
        print((index - 1) .. ". " .. item.label)
    end

    print("\n")
end

local function getActionFromChoice(userRole, choix)
    local menu = getMenuForRole(userRole)
    local choixNumerique = tonumber(choix)

    if not menu or not choixNumerique then
        return nil
    end

    local entree = menu[choixNumerique + 1]
    if not entree then
        return nil
    end

    return entree.key
end

return { clearTerminal = clearTerminal,
        clearTerminalAndShowInfos = clearTerminalAndShowInfos,
        afficherMenu = afficherMenu,
        getActionFromChoice = getActionFromChoice
}