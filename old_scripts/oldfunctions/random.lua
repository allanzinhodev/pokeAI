local captura_tentativas = 0
local max_tentativas = 4

while true do
    local battle_state = memory.readbyte(0xD22D)

    if battle_state == 0 then
        -- Se estiver no mapa, reseta a contagem de tentativas
        captura_tentativas = 0

        -- Verifica colisão antes de andar
        local collision_down = memory.readbyte(0xC2FA)
        local collision_up = memory.readbyte(0xC2FB)
        local collision_left = memory.readbyte(0xC2FC)
        local collision_right = memory.readbyte(0xC2FD)

        -- Lista direções seguras
        local safe_directions = {}
        if collision_down ~= 0x07 then table.insert(safe_directions, "down") end
        if collision_up ~= 0x07 then table.insert(safe_directions, "up") end
        if collision_left ~= 0x07 then table.insert(safe_directions, "left") end
        if collision_right ~= 0x07 then table.insert(safe_directions, "right") end

        -- Se houver pelo menos uma direção livre, move-se
        if #safe_directions > 0 then
            local move = safe_directions[math.random(1, #safe_directions)]
            joypad.set(1, { [move] = true })
            emu.frameadvance()
            joypad.set(1, { [move] = false })
            emu.frameadvance()
        end

        -- Aperta "A" aleatoriamente às vezes
        if math.random(1, 5) == 1 then  
            joypad.set(1, { A = true })
            emu.frameadvance()
            joypad.set(1, { A = false })
            emu.frameadvance()
        end

        if math.random(1, 25) == 1 then  
            joypad.set(1, { B = true })
            emu.frameadvance()
            joypad.set(1, { B = false })
            emu.frameadvance()
        end
    elseif battle_state == 1 then
        -- Pokémon selvagem encontrado!
        local pokebolas = memory.readbyte(0xCDE4)

        if captura_tentativas < max_tentativas and pokebolas > 0 then
            print("Tentando capturar... Tentativa #" .. (captura_tentativas + 1))
            captura_tentativas = captura_tentativas + 1

            -- Sequência da captura
            joypad.set(1, { down = true }); emu.frameadvance(); joypad.set(1, { down = false })
            for i = 1, 20 do emu.frameadvance() end

            joypad.set(1, { A = true }); emu.frameadvance(); joypad.set(1, { A = false })
            for i = 1, 20 do emu.frameadvance() end

            joypad.set(1, { right = true }); emu.frameadvance(); joypad.set(1, { right = false })
            for i = 1, 20 do emu.frameadvance() end

            joypad.set(1, { A = true }); emu.frameadvance(); joypad.set(1, { A = false })
            for i = 1, 20 do emu.frameadvance() end

            joypad.set(1, { A = true }); emu.frameadvance(); joypad.set(1, { A = false })
            for i = 1, 60 do emu.frameadvance() end
        else
            local directions = {"up", "down", "left", "right"}
            local move = directions[math.random(1, #directions)] 
    
            joypad.set(1, { [move] = true }) -- Move o personagem
            emu.frameadvance()
            joypad.set(1, { [move] = false }) -- Solta o botão
            emu.frameadvance()
    
            -- Ocasionalmente pressiona "A"
            if math.random(1, 5) == 1 then  
                joypad.set(1, { A = true })
                emu.frameadvance()
                joypad.set(1, { A = false })
                emu.frameadvance()
            end
        end

    elseif battle_state == 2 then
        -- Contra treinador, apenas aperta teclas aleatórias
        local keys = { "up", "down", "left", "right", "A", "B" }
        local action = keys[math.random(1, #keys)]
        joypad.set(1, { [action] = true })
        emu.frameadvance()
        joypad.set(1, { [action] = false })
        for i = 1, 10 do emu.frameadvance() end
    end

    emu.frameadvance()
end
