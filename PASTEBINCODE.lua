local dfpwm = require("cc.audio.dfpwm")
local speakers = { peripheral.find("speaker") }
if #speakers == 0 then error("No speakers attached") end

-- Terminal setup
local mon = peripheral.find("monitor")
if mon and not pocket then
    term.redirect(mon)
    if mon.setTextScale then mon.setTextScale(1) end
    mon.clear()
end

term.setBackgroundColor(colors.black)
term.setTextColor(colors.white)
term.clear()

-- ===== Songs setup =====
local songIndexUrl = "https://raw.githubusercontent.com/XEXModz/CC-Tweaked_Music_Player/refs/heads/main/index.txt"
local songNames = textutils.unserialize(http.get(songIndexUrl).readAll())
local songs = {}
for i, name in ipairs(songNames) do
    table.insert(songs, {
        name = name,
        url = "https://raw.githubusercontent.com/XEXModz/CC-Tweaked_Music_Player/refs/heads/main/" .. name:gsub(" ", "%%20") .. ".dfpwm"
    })
end

-- ===== Playback state =====
local currentSong = nil
local playing = false
local stopFlag = false
local shuffle = false
local loopMode = 0
local volume = 1.5
local decoder = dfpwm.make_decoder()
local currentPage = 1
local width, height = term.getSize()
local topRows = 2
local bottomRows = 5
local songsPerPage = height - topRows - bottomRows

local buttons = {}

-- ===== UI =====
local function totalPages()
    return math.max(1, math.ceil(#songs / songsPerPage))
end

local function drawUI()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.clear()
    term.setCursorPos(2,1)
    term.write("Now Playing: " .. (currentSong and currentSong.name or "(none)"))

    local startIdx = (currentPage-1)*songsPerPage + 1
    local y = 3
    for i=startIdx, math.min(startIdx+songsPerPage-1, #songs) do
        term.setCursorPos(2,y)
        term.setTextColor((currentSong==songs[i]) and colors.yellow or colors.white)
        term.write(songs[i].name)
        y = y + 1
    end

    buttons = {}
    local btnLines = {
        {"Shuffle: "..(shuffle and "On" or "Off"), "Loop: "..({[0]="Off",[1]="All",[2]="One"})[loopMode]},
        {"Page "..currentPage.."/"..totalPages(), "Prev","Next"},
        {(playing and "Playing" or "Stopped"), "Skip"},
        {"-","Volume: "..math.floor(volume/3*100).."%","+",""}
    }

    local startY = height - bottomRows + 1
    for lineIdx, line in ipairs(btnLines) do
        local x = 2
        local lineY = startY + lineIdx - 1
        for _, btn in ipairs(line) do
            if #btn>0 then
                term.setCursorPos(x, lineY)
                term.setBackgroundColor(colors.gray)
                term.setTextColor(colors.white)
                term.write(" "..btn.." ")
                table.insert(buttons,{line=lineIdx, text=btn, x1=x, x2=x+#btn+1})
                x = x + #btn + 3
            end
        end
    end
end

-- ===== Playback loop =====
-- Per docs: speaker buffers ONE playAudio call at a time. Track which speakers
-- have accepted the current buffer so we don't re-call playAudio on them.
local function playerLoop()
    while true do
        if currentSong and playing then
            -- Fetch song data BEFORE entering the audio loop so HTTP latency
            -- doesn't block playback timing.
            local response = http.get(currentSong.url)
            if not response then
                playing = false
                drawUI()
            else
                local songData = response.readAll()
                response.close()
                local dataLen = #songData

                for i = 1, dataLen, 16*1024 do
                    if stopFlag then break end
                    local chunk = songData:sub(i, math.min(i+16*1024-1, dataLen))
                    local buffer = decoder(chunk)

                    -- Track acceptance per-speaker so we don't waste calls
                    local accepted = {}
                    local pending = #speakers

                    while pending > 0 and not stopFlag do
                        for idx, spk in ipairs(speakers) do
                            if not accepted[idx] then
                                if spk.playAudio(buffer, volume) then
                                    accepted[idx] = true
                                    pending = pending - 1
                                end
                            end
                        end
                        if pending > 0 then
                            os.pullEvent("speaker_audio_empty")
                        end
                    end
                end

                if stopFlag then
                    for _, spk in ipairs(speakers) do spk.stop() end
                    stopFlag = false
                else
                    if loopMode == 2 then
                        -- loop current
                    elseif shuffle then
                        currentSong = songs[math.random(#songs)]
                    elseif loopMode == 1 then
                        local idx = 1
                        for i,s in ipairs(songs) do if s==currentSong then idx=i end end
                        currentSong = songs[idx % #songs + 1]
                    else
                        local idx = 1
                        for i,s in ipairs(songs) do if s==currentSong then idx=i end end
                        if idx<#songs then currentSong = songs[idx+1] else currentSong = nil playing=false end
                    end
                end
                drawUI()
            end
        else
            os.sleep(0.05)
        end
    end
end

-- ===== Input loop =====
local function inputLoop()
    drawUI()
    while true do
        local e, p2, x, y = os.pullEvent()
        if e == "mouse_click" or e == "monitor_touch" then
            local startIdx = (currentPage-1)*songsPerPage + 1
            for i=startIdx, math.min(startIdx+songsPerPage-1, #songs) do
                local row = 3 + (i-startIdx)
                if y==row then
                    currentSong = songs[i]
                    stopFlag = true
                    playing = true
                    drawUI()
                end
            end

            for _, btn in ipairs(buttons) do
                local btnY = (height - bottomRows + btn.line)
                if y == btnY and x >= btn.x1 and x <= btn.x2 then
                    if btn.text:find("Shuffle") then shuffle = not shuffle
                    elseif btn.text:find("Loop") then loopMode = (loopMode+1)%3
                    elseif btn.text:find("Prev") and currentPage>1 then currentPage=currentPage-1
                    elseif btn.text:find("Next") and currentPage<totalPages() then currentPage=currentPage+1
                    elseif btn.text:find("Stopped") or btn.text:find("Playing") then
                        if playing then
                            stopFlag = true
                            playing = false
                        else
                            if currentSong then playing = true end
                        end
                    elseif btn.text:find("Skip") then
                        if currentSong then
                            local idx = 1
                            for i,s in ipairs(songs) do if s==currentSong then idx=i end end
                            if shuffle then
                                currentSong = songs[math.random(#songs)]
                            else
                                if idx < #songs then
                                    currentSong = songs[idx+1]
                                else
                                    currentSong = songs[1]
                                end
                            end
                            stopFlag = true
                            playing = true
                        end
                    elseif btn.text=="-" then volume = math.max(0,volume-0.3)
                    elseif btn.text=="+" then volume = math.min(3,volume+0.3)
                    end
                    drawUI()
                end
            end
        end
    end
end

parallel.waitForAny(playerLoop, inputLoop)
