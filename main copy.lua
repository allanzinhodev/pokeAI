dofile("funcoes.lua") -- importa as funções

-- Requer o arquivo com funções auxiliares se estiver separado
-- require("funcoes")  -- se tiver salvo suas funções em funcoes.lua, por exemplo

-- Configurações
local captura_tentativas = 0
local max_tentativas = 4

-- Lógica de cada estado
local estados = {
    [0] = function()  -- Modo mapa
        captura_tentativas = 0

        -- Verifica colisão
        local collision_down  = memory.readbyte(0xC2FA)
        local collision_up    = memory.readbyte(0xC2FB)
        local collision_left  = memory.readbyte(0xC2FC)
        local collision_right = memory.readbyte(0xC2FD)

        local direcoes = {}
        if collision_down ~= 0x07 and collision_down ~= 0xFF then table.insert(direcoes, "down") end
        if collision_up ~= 0x07 and collision_up ~= 0xFF then table.insert(direcoes, "up") end
        if collision_left ~= 0x07 and collision_left ~= 0xFF then table.insert(direcoes, "left") end
        if collision_right ~= 0x07 and collision_right ~= 0xFF then table.insert(direcoes, "right") end

        if #direcoes > 0 then
            local move = direcoes[math.random(1, #direcoes)]
            joypad.set(1, { [move] = true }); emu.frameadvance(); joypad.set(1, { [move] = false })
            emu.frameadvance()
        end

        -- Aperta A ou B aleatoriamente
        if math.random(1, 5) == 1 then
            joypad.set(1, { A = true }); emu.frameadvance(); joypad.set(1, { A = false })
            emu.frameadvance()
        end
        if math.random(1, 25) == 1 then
            joypad.set(1, { B = true }); emu.frameadvance(); joypad.set(1, { B = false })
            emu.frameadvance()
        end
    end,

    [1] = function()  -- Batalha selvagem
        local arquivo = io.open("opcao_menu.txt", "r")
        if arquivo then
            local opcao = arquivo:read("*l")
            arquivo:close()
    
            if opcao == "fight" then
                print("Detectado: FIGHT")
    
                -- Primeira pressão de A
                for i = 1, 5 do
                    joypad.set(1, { A = true })
                    emu.frameadvance()
                end
                joypad.set(1, { A = false })
                emu.frameadvance()
    
                -- Pressiona DOWN 5 vezes com intervalo
                for i = 1, 5 do
                    for j = 1, 5 do
                        joypad.set(1, { down = true })
                        emu.frameadvance()
                    end
                    joypad.set(1, { down = false })
                    emu.frameadvance()
                end
    
                -- Segunda pressão de A (para confirmar)
                for i = 1, 5 do
                    joypad.set(1, { A = true })
                    emu.frameadvance()
                end
                joypad.set(1, { A = false })
                emu.frameadvance()
    
    
                -- Aguarda 180 frames
                for i = 1, 180 do
                    emu.frameadvance()
                end
    
                -- Apaga o conteúdo do arquivo
                local apagar = io.open("opcao_menu.txt", "w")
                apagar:write("")
                apagar:close()
            end
        else
            print("Arquivo não encontrado!")
        end
    end;
    
    [2] = function()  -- Batalha contra treinador
        local keys = { "up", "down", "left", "A", "B" }
        local tecla = keys[math.random(1, #keys)]
        joypad.set(1, { [tecla] = true }); emu.frameadvance(); joypad.set(1, { [tecla] = false })
        for i = 1, 10 do emu.frameadvance() end
    end
}

-- Loop principal
while true do
    local estado = memory.readbyte(0xD22D)
    if estados[estado] then
        estados[estado]()
    else
        print("Estado desconhecido: " .. tostring(estado))
    end
    emu.frameadvance()
end
