modem = peripheral.find("modem")
modemName = peripheral.getName(modem)
rednet.open(modemName)

if rednet.isOpen() then
    local resNumber, message, protocol = rednet.receive()
    print(resNumber, message, protocol)
end