local move = {}
local config = require("config")
local waitFrames = 15  -- ajuste esse valor se quiser esperar mais/menos

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

function move.walkTo(x, y)
    -- lógica de andar até x, y
end

function justtalk()
    if memory.readbyte(0xC606) == 0xEE or memory.readbyte(0xC4B5) == 0x62 then
        for i = 1, 15 do
            joypad.set(1, {A = true })
            emu.frameadvance()
        end
        joypad.set(1, {A = false })
        emu.frameadvance()
    end
end

function capturar()
    
    if config.battle.havePokeball() and memory.readbyte(0xC4B5) ~= 0x5D then
        
        local offsets = {
            C5C1 = 0xC5C1,
            C5E9 = 0xC5E9,
            C5C7 = 0xC5C7,
            C5EF = 0xC5EF
        }
        
        while true do
            justtalk()
            for nome, addr in pairs(offsets) do
                if memory.readbyte(addr) == 0xED then
                    if nome == "C5E9" then
                        pressA()
                    elseif nome == "C5EF" then
                        move.left()
                        pressA()
                    elseif nome == "C5C7" then
                        move.left()
                        move.down()
                        pressA()
                    elseif nome == "C5C1" then
                        move.down()
                        pressA()
                    end
                    emu.frameadvance()
                end
            end

            if memory.readbyte(offsets.C5E9) == 0xED then
                print("Menu de items encontrado.")
                break
            end

            emu.frameadvance()

            while true do
        
                if config.battle.getItemMenu() == 0x01 then
                    pressA()
                    
                else
                    move.right()
                end
            
                emu.frameadvance()
                break
            end
        end
    end
end

function attack()
   -- while memory.readbyte(0x96F2) ~= 03 do
        print("Funcao attack.")
        if memory.readword(0xC581) == 0xF67F or memory.readword(0xC56D) == 0xABA1 then -- não tem pp?
            move.down()
            print("Funcao atack down")
        else
            pressA()
            print("Funcao atack else")
        end
        
  --  end
end

function simpleBattle()


        local emBatalha = true

        while emBatalha == true do
            print("Funcao batalha loop")
            justtalk()
           
                    if  memory.readbyte(0xC5E9) == 0xED then
                        move.up()
                        pressA()
                        print("batalha pack")
                    elseif  memory.readbyte(0xC5EF) == 0xED then
                        move.left()
                        move.up()
                        pressA()
                        print("batalha run")
                    elseif  memory.readbyte(0xC5C7) == 0xED then
                        move.left()
                        pressA()
                        print("batalha pkm")
                    elseif  memory.readbyte(0xC5C1) == 0xED then
                        pressA()
                        print("batalha fight")
                    elseif memory.readword(0xC6C3) == 0x0000 and memory.readbyte(0x96F2) == 0x00 and memory.readdword(0xC5C4) ~= 0xB1A0B17F and memory.readdword(0xC5E0) ~= 0xB4B0B27C then
                        justtalk()
                        print("batalha Trocar pokemon sim ou nao")
                    elseif memory.readbyte(0x96F2) == 0x03 then
                        move.down()
                        pressA()
                        print("batalha pokemenu")
                    else 
                        print("Batalha else")
                        attack()
                        if config.battle.getState() == 0x00 and memory.readbyte(0xC4DD) ~= 0x74 then
                            print("Batalha finalizada.")
                            emBatalha = false
                        end
                        
                    end
                    emu.frameadvance()
                end

            emu.frameadvance()


            if config.battle.getState() == 0x00 and memory.readbyte(0xC4DD) ~= 0x74 then
                print("Batalha finalizada.")
                emBatalha = false
            end
        end


return move