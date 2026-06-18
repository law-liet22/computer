local modem = peripheral.find("modem") or error("Aucun modem trouve", 0)
local mon = peripheral.find("monitor")
modem.open(43)

local event, side, channel, replyChannel, message, distance
while true do
    repeat
        event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == 43
    mon.clear()
    mon.write(message .. " | Distance : " .. distance)
    sleep(0.5)
    mon.setCursorPos(1, 1)
end