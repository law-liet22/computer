local dfpwm = require("cc.audio.dfpwm")
local speakers = { peripheral.find("speaker") }
local decoder = dfpwm.make_decoder()

for _, speaker in pairs(speakers) do
    for chunk in io.lines("roi_dans_le_bac_sable.dfpwm", 16 * 1024) do
    local buffer = decoder(chunk)

        while not speaker.playAudio(buffer, 50) do
            os.pullEvent("speaker_audio_empty")
        end
    end
end

