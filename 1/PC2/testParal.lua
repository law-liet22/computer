--[[
local function tick()
    while true do
        os.sleep(1)
        print("Tick")
    end
end

local function waitForQ()
    repeat
        local _, key = os.pullEvent("key")
    until key == keys.q
    print("Q a ete recu.")
end

parallel.waitForAny(tick, waitForQ)
print("Fin du programme.")

]]

local funcs = {}
for i = 1, 5 do
    table.insert(funcs, function()
        sleep(math.random(5))
        print("Fini : ".. i)
    end)
end

parallel.waitForAll(table.unpack(funcs))
print("Fin du programme.")