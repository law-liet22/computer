local state = true
turtle.forward()

while true do
    local hasBlock, data = turtle.inspect()
    if hasBlock then
        if data.name == "minecraft:oak_log" then
            turtle.dig("right")
            turtle.forward()
            while state do
                local hasBlock, data = turtle.inspectUp()
                if hasBlock then
                    if data.name == "minecraft:oak_log" then
                        turtle.digUp("right")
                        turtle.up()
                    else
                        if turtle.detectDown() then
                            state = false
                            turtle.forward()
                        else
                            turtle.down()
                        end
                    end
                else
                    if turtle.detectDown() then
                        state = false
                        turtle.forward()
                    else
                        turtle.down()
                    end
                end
            end
        else
            break
        end
    end
    turtle.forward()
    break
end