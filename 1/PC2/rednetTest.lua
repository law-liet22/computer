modem = peripheral.find("modem")
modemName = peripheral.getName(modem)
rednet.open(modemName)

while true do
    term.clear()
    term.setCursorPos(1, 1)
    if rednet.isOpen() then
        print("Entrez votre message a envoyer : ")
        local msg = read()
        rednet.send(7, msg, "ez")
    end
end