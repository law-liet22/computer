term.setCursorBlink(true)
term.clear()

print("Entrez votre nom :")
local name = read()
term.clear()

print("Bonjour, " .. name .. ".")
term.setCursorBlink(false)
sleep(5)
term.clear()