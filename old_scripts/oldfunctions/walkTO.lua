function walkTo(dest_x, dest_y)
    local attempts = 0
    while attempts < 1000 do
        local y = memory.readbyte(0xDCB7)
        local x = memory.readbyte(0xDCB8)

        -- DEBUG: loga posição atual
        print(string.format("POS: x=%02X y=%02X -> DEST: x=%02X y=%02X", x, y, dest_x, dest_y))

        -- Chegou no destino
        if x == dest_x and y == dest_y then
            print("Chegou no destino!")
            break
        end

        -- Lê colisões
        local collision_down = memory.readbyte(0xC2FA)
        local collision_up = memory.readbyte(0xC2FB)
        local collision_left = memory.readbyte(0xC2FC)
        local collision_right = memory.readbyte(0xC2FD)

        -- Direções seguras
        local safe_moves = {}
        if collision_down ~= 0x07 and collision_down ~= 0xFF then table.insert(safe_moves, "down") end
        if collision_up ~= 0x07 and collision_up ~= 0xFF then table.insert(safe_moves, "up") end
        if collision_left ~= 0x07 and collision_left ~= 0xFF then table.insert(safe_moves, "left") end
        if collision_right ~= 0x07 and collision_right ~= 0xFF then table.insert(safe_moves, "right") end

        -- Define ordem de prioridade (direção preferida primeiro)
        local directions = {}

        if y < dest_y then table.insert(directions, "down")
        elseif y > dest_y then table.insert(directions, "up") end

        if x < dest_x then table.insert(directions, "right")
        elseif x > dest_x then table.insert(directions, "left") end

        -- Preenche com outras seguras caso precise
        for _, dir in ipairs(safe_moves) do
            if not tableContains(directions, dir) then
                table.insert(directions, dir)
            end
        end

        -- Tenta andar na melhor direção possível
        local moved = false
        for _, dir in ipairs(directions) do
            if tableContains(safe_moves, dir) then
                joypad.set(1, { [dir] = true })
                emu.frameadvance()
                joypad.set(1, { [dir] = false })
                moved = true
                break
            end
        end

        if not moved then
            print("Sem caminhos disponíveis!")
        end

        emu.frameadvance()
        attempts = attempts + 1
    end
end

-- Função auxiliar para verificar se um valor está em uma tabela
function tableContains(tbl, val)
    for _, v in ipairs(tbl) do
        if v == val then return true end
    end
    return false
end

walkTo(0x0F, 0x08) -- Vai até X=27, Y=10
