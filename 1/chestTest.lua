local chest = peripheral.find("minecraft:chest") -- or inventory

for slot, item in pairs(chest.list()) do
    print(("%d x %s dans le slot %d"):format(item.count, item.name, slot))
end