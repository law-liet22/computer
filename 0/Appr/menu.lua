local sizeX, sizeY = term.getSize()

local function dessinerMenu()
    term.setBackgroundColor(colors.white)
    term.clear()
    term.setCursorPos(1, 1)
    term.setBackgroundColor(colors.red)
    term.write(string.rep(" ", sizeX))
    
    for i = 2, sizeY, 1 do
        term.setCursorPos(1, i)
        term.write(" ")
    end

    for i = 1, sizeY, 1 do
        term.setCursorPos(sizeX, i)
        term.write(" ")
    end

    term.setCursorPos(1, sizeY-1)
    term.write(string.rep(" ", sizeX))

    term.setBackgroundColor(colors.white)
    --term.setBackgroundColor(colors.black)
    --term.scroll(-1)

    term.setTextColor(colors.black)
    term.setCursorPos(3, 3)
    term.write("1 - Dire bonjour")
    term.setCursorPos(3, 4)
    term.write("2 - Dire au revoir")
    term.setCursorPos(3, 5)
    term.write("3 - Quitter")
    term.setCursorPos(1, sizeY)
    
end

dessinerMenu()
term.setTextColor(colors.white)
term.setBackgroundColor(colors.black)
local choix = read()

if choix == "1" then
    print("Bonjour")

elseif choix == "2" then
    print("Au revoir")

else
    term.clear()
    term.setCursorPos(1, 1)
end