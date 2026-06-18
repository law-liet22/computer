local MAX_NUMBER = 10
local numberToFind = math.random(MAX_NUMBER)
local x, y = term.getSize()

local number = 0

local function leaveBlankLine()
    local cursPosX, cursPosY = term.getCursorPos()
    term.setCursorPos(cursPosX, cursPosY + 1)
    term.write("")
     term.setCursorPos(cursPosX, cursPosY + 2)
end

local function clearIfIsOutOfScreen(lastAnswer, lastString)
    local cursPosX, cursPosY = term.getCursorPos()
    if cursPosY + 3 > y then
        term.clear()
        term.setCursorPos(1, 1)
        print(lastAnswer)
        print(lastString)
        leaveBlankLine()
    end
end

term.clear()
term.setCursorBlink(true)
term.setCursorPos(1, 1)
print("Le jeu commence.")
sleep(1)
term.clear()
term.setCursorPos(1, 1)

while number ~= numberToFind do
     
    print("Entrez un nombre entre 1 et " .. MAX_NUMBER .. ":")
    
    local answer = read()
    number = tonumber(answer)
    

    if number < numberToFind then
        print("Le nombre est plus grand.")
        leaveBlankLine()
        clearIfIsOutOfScreen(answer, "Le nombre est plus grand.")   
        
        

    elseif number > numberToFind then
        print("Le nombre est plus petit.")
        leaveBlankLine()
        clearIfIsOutOfScreen(answer, "Le nombre est plus petit.")   
        

    else
        print("Bravo ! Vous avez trouve le nombre !")
    end
end