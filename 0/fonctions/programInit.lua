local function progInit(backgroundColor, textColor)
    term.setBackgroundColor(backgroundColor)
    term.setTextColor(textColor)
    term.clear()
    term.setCursorPos(1, 1)
end

return { progInit = progInit }