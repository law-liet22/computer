local modem = peripheral.find("modem") or error("Aucun modem trouve", 0)
modem.open(42)


local function refuelIfLowFuel()
    local actualLevel = turtle.getFuelLevel()
    if actualLevel < 20 then
        turtle.refuel()
    else
        modem.transmit(43, 42, "Aucun refuel necessaire.")
    end
end
while true do
    modem.transmit(43, 42, "Fuel : " .. turtle.getFuelLevel())
    refuelIfLowFuel()
    turtle.turnLeft()
    turtle.turnLeft()
    local avant1, avant2 = turtle.forward(1)
    --print(avant1, avant2)
end