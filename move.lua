local move = {}
local config = require("config")
local waitFrames = 15  -- ajuste esse valor se quiser esperar mais/menos
pos = nil
lastPos = nil

function move.up(steps)
    steps = steps or 1
    for i = 1, steps*waitFrames do
        joypad.set(1, {up = true })
        emu.frameadvance()
    end
    joypad.set(1, {up = false })
    emu.frameadvance()
end

function move.down(steps)
    steps = steps or 1
    for i = 1, steps*waitFrames do
        joypad.set(1, {down = true })
        emu.frameadvance()
    end
    joypad.set(1, {down = false })
    emu.frameadvance()
end

function move.left(steps)
    steps = steps or 1
    for i = 1, steps*waitFrames do
        joypad.set(1, {left = true })
        emu.frameadvance()
    end
    joypad.set(1, {left = false })
    emu.frameadvance()
end

function move.right(steps)
    steps = steps or 1
    for i = 1, steps*waitFrames do
        joypad.set(1, {right = true })
        emu.frameadvance()
    end
    joypad.set(1, {right = false })
    emu.frameadvance()
end

function move.random(maxSteps)
    local steps = math.random(1, maxSteps or 1)  -- se maxSteps não for passado, usa 1
    local directions = { "up", "down", "left", "right" }
    local direction = directions[math.random(#directions)]
    if memory.readdword(0xC540) == 0x94937F7C or memory.readdword(0xC518) == 0x94907F7C or memory.readdword(0xC4B4) == 0x11051416 then
        pressB()
    end
    print("Movendo aleatoriamente para " .. direction .. " por " .. steps .. " passos")
    move[direction](steps)
end

function pressA()
    for i = 1, 15 do
        joypad.set(1, {A = true })
        emu.frameadvance()
    end
    joypad.set(1, {A = false })
    emu.frameadvance()
end

function pressB()
    for i = 1, 15 do
        joypad.set(1, {B = true })
        emu.frameadvance()
    end
    joypad.set(1, {B = false })
    emu.frameadvance()
end

function move.walkToX(gotoX)
    local atualMap = mapID()
    while memory.readbyteunsigned(0xDCB8) ~= gotoX and memory.readbyte(0xD22D) == 0 and atualMap == mapID() do
        posRecord()
        if memory.readbyteunsigned(0xDCB8) == gotoX then
            break
        elseif memory.readbyteunsigned(0xDCB8) < gotoX then
            if collisionRight() == false or position() == lastPos then
                move.random(4)
            else
                move.right()
            end
        else
            if collisionLeft() ==false or position() == lastPos then
                move.random(4)
            else
                move.left()
            end
        end
    end
end

function move.walkToY(gotoY)
    local atualMap = mapID()
    while memory.readbyteunsigned(0xDCB7) ~= gotoY and memory.readbyte(0xD22D) == 0 and atualMap == mapID() do
        posRecord()
        if memory.readbyteunsigned(0xDCB7) == gotoY then
            break
        elseif memory.readbyteunsigned(0xDCB7) < gotoY then
            if collisionDown() == false or position() == lastPos then
                move.random(4)
            else
                move.down()
            end
        else
            if collisionUp() == false or position() == lastPos then
                move.random(4)
            else
                move.up()
            end
        end
    end
end

function posRecord()
    if pos == nil then
        pos = position()
        print("Criada variavel de pos: " .. string.format("0x%04X", pos))
    else
        lastPos = pos
        pos = position()
        print("Ultimo pos atualizado: " .. string.format("0x%04X", lastPos))
    end
end

function justtalk()
   -- if memory.readbyteunsigned(0xC5E2) == 41636 and memory.readbyteunsigned(0xC5E4) == 43172 and memory.readbyteunsigned(0xC577) == 36333
   -- then
    --    pressA()
    --elseif memory.readbyteunsigned(0xC5E2) == 41636 and memory.readbyteunsigned(0xC5E4) == 43172 and memory.readbyteunsigned(0xC54F) == 39149
    --    then
   --     move.down()
    --end
    if memory.readbyte(0xC606) == 0xEE or memory.readbyte(0xC4B5) == 0x62 or memory.readdword(0xC4C0) == 0x82809393 then
        pressA()
    end

end

return move