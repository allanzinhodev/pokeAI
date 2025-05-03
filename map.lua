local config = require("config")
local move = require("move")

local mapa = nil
local lastMap = nil
local penultimateMap = nil
local playerx = memory.readbyteunsigned(0xDCB8)
local playery = memory.readbyteunsigned(0xDCB7)

function mapRecord()
    if mapa == nil then
        -- Atualiza mapa atual
        mapa = mapID()
        print("Criada variavel de mapa: " .. string.format("0x%04X", mapa))
    elseif mapa ~= mapID() then
        -- Atualiza o mapa anterior para o mapa atual e o mapa atual para o offset
        lastMap = mapa
        mapa = mapID()
        print("Ultimo map atualizado: " .. string.format("0x%04X", lastMap))
    end
end

function mapActions()
    -- Multiplayer Map
    if getMapBank() == 0x14 and getMap() == 0x1 
    then 
        move.up()
        move.down(2)
    end
    -- Cherrygroove
    if getMapBank() == 0x1A and getMap() == 0x03 then
        if lastMap == 0x03 or memory.readbyte(0xD88D) == 0x00
        then
            if getX() == 0x17 and getY() == 0x0A or getY() == 0x0B and getX() == 0x17 
            then
                move.left(3)
                move.up(8)
                move.left(4)
                move.up(12)
                move.right(7)
                move.up(17)
            end
        end
    else
    end
    -- Rota 30
    if getMapBank() == 0x1A and getMap() == 0x01 then
        
        if memory.readbyte(0xD88D) == 0x00
        then
            if getY() == 0x1B and getX() == 0x0F or getY() == 0x1B and getX() == 0x0E
            then
                move.left(1)
                move.up(5)
                move.left(4)
                move.up(5)
                move.right(3)
                move.up(7)
                move.right(6)
                move.up(6)
            end
        end
    else
    end
    -- New bark town ou Rota 29 OK
    if getMapBank() == 0x18 then
        
        -- Quarto OK
        if  mapID() == 0x0718 then
            move.walkToX(7)
            move.walkToY(0)
        end
        -- Mae OK
        if  mapID() == 0x0618 then
            move.walkToX(7)
            move.walkToY(8)
        end
        -- Newbarkcity OK
        if  mapID() == 0x0418 and getX() > 0x0D or getY() > 0x0A then
            move.walkToX(6)
            move.walkToY(7)
        end
        
        -- Rota 29 (3)
        
        if getMap() == 0x03
        then
            if memory.readbyteunsigned(0xDCB8) >= 14 and memory.readbyteunsigned(0xDCB8) <= 17 and memory.readbyteunsigned(0xDCB7) == 14
            then
                move.right(15)
            end
            --last map cherrygove 
            if lastMapBank == 0x1A or memory.readbyte(0xD8BD) == 0x45 then -- Se tiver mistery egg
                if memory.readbyteunsigned(0xDCB8) == 3 and memory.readbyteunsigned(0xDCB7) == 6 or memory.readbyteunsigned(0xDCB7) == 7 and memory.readbyteunsigned(0xDCB8) == 3
                then
                    move.right(4)
                    move.down(4)
                    move.right(8)
                    move.down(3)
                end
                if getX() == 0x1F and memory.readbyteunsigned(0xDCB7) >= 14
                then
                    move.up(6)
                    move.right(8)
                    move.down(2)
                    move.right(4)
                    move.up(4)
                    move.right(23)
                end
            end
            -- last map New Bark City
            if getX() == 0x1F and memory.readbyteunsigned(0xDCB7) > 14 and lastMap == 0x04
            then
                move.up(6)
                move.right(6)
                move.up(5)
                move.left(18)
                move.up(3)
                move.left(10)
                move.down(6)
                move.left(5)
            elseif getX() == 0x1F and getY() == 0x07 or getY() == 0x06 and lastMap == 0x04
            then
                move.up(1)
                move.left(11)
                move.up(4)
                move.left(5)
                move.down(5)
                move.left(3)
                move.down()
                move.left(5)
                move.up(2)
                move.left(6)
                justtalk()
            end
        end
    end
end

return map
