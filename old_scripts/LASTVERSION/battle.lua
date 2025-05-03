local battle = {}
local config = require("config")
local move = require("move")

inBattle = memory.readbyte(0xD22D) -- 01 Wild battle 02 Trainer Battle
Pokeballs = memory.readbyte(0xD8D7) -- Quantidade de pokebolas diferentes
function onFightArrow()
    return memory.readbyte(0xC5C1) == ED 
end  -- Se ED é porque está no comando FIGH
onPKMArrow = memory.readbyte(0xC5C7) -- Se ED é porque está no comando FIGH
onPackArrow = memory.readbyte(0xC5E9)
onRunArrow = memory.readbyte(0xC5EF)
nextPokeYes = memory.readbyte(0xC58D)
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

            while memory.readbyte(0xD22D) == 0x01 do
        
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
    while inBattle == 0x01 or 0x02 do
        justtalk()
         if onPackArrow == 0xED then
            move.up()
            pressA()
            print("batalha pack")
        elseif onRunArrow == 0xED then
            move.left()
            move.up()
            pressA()
            print("batalha run")
        elseif onPKMArrow == 0xED then
            move.left()
            pressA()
            print("batalha pkm")
        elseif onFightArrow() then
            pressA()
            print("batattttttttttttlha fightDBG")
        elseif memory.readword(0xC6C3) == 0x0000 and memory.readbyte(0x96F2) == 0x00 and memory.readdword(0xC5C4) ~= 0xB1A0B17F and memory.readdword(0xC5E0) ~= 0xB4B0B27C then
            justtalk()
            print("batalha Trocar pokemon sim ou nao")
        else 
            print("Batalha else")
            attack()
        end
    end
end

return battle