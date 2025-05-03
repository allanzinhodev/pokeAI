dofile("funcoes.lua") -- importa as funções

-- Requer o arquivo com funções auxiliares se estiver separado
-- require("funcoes")  -- se tiver salvo suas funções em funcoes.lua, por exemplo

-- Lógica de cada estado
local estados = {
    [0] = function()  -- Modo mapa
        local mapa = memory.readword(0xDCB5)
            joypad.set(1, { A = true }); emu.frameadvance(); joypad.set(1, { A = false })
            emu.frameadvance()
        if mapa == 276 then
            print("Mapa 0x1401 detectado: forçando movimento para baixo e esquerda")
            moveRandom()
            moveRandom()
            joypad.set(1, { A = true }); emu.frameadvance(); joypad.set(1, { A = false })
            emu.frameadvance()
            joypad.set(1, { down = true }); emu.frameadvance(); joypad.set(1, { down = false })
            joypad.set(1, { down = true }); emu.frameadvance(); joypad.set(1, { down = false })
            emu.frameadvance()
            joypad.set(1, { left = true }); emu.frameadvance(); joypad.set(1, { left = false })
            joypad.set(1, { left = true }); emu.frameadvance(); joypad.set(1, { left = false })
            emu.frameadvance()
            moveRandom()
            return
        end

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
        if not arquivo then
            print("Arquivo 'opcao_menu.txt' não encontrado!")
            return
        end
    
        local opcao = arquivo:read("*l")
        arquivo:close()
    
        local function pressionar(tecla, vezes)
            for i = 1, vezes do
                joypad.set(1, { [tecla] = true })
                emu.frameadvance()
            end
            joypad.set(1, { [tecla] = false })
            emu.frameadvance()
        end
    
        local acoes = {
            fight = function()
                print("Detectado: FIGHT")
                pressionar("A", 5)
    
                for i = 1, 5 do
                    pressionar("down", 5)
                end
    
                pressionar("A", 5)
    
                for i = 1, 90 do  -- Espera 90 frames (ajustável)
                    emu.frameadvance()
                end
            end,
    
            run = function()
                print("Detectado: RUN")
                pressionar("left", 5)
                pressionar("up", 5)
            end,
    
            pack = function()
                print("Detectado: PACK")
                pressionar("up", 5)
            end,
    
            poke = function()
                print("Detectado: POKE")
                pressionar("left", 5)
            end,

            skill1 = function()
                valor_mp = memory.readbyte(0xC634)
                
                if valor_mp > 0 then
                    print("MP suficiente, apertando A")
                    pressionar("A", 5)
                else
                    print("Sem MP, descendo")
                    pressionar("down", 5)
                end  -- <- este estava faltando
            end,

            skill2 = function()
                valor_mp = memory.readbyte(0xC635)
                
                if valor_mp > 0 then
                    print("MP suficiente, apertando A")
                    pressionar("A", 5)
                else
                    print("Sem MP, descendo")
                    pressionar("down", 5)
                end
            end,

            skill3 = function()
                valor_mp = memory.readbyte(0xC636)
                
                if valor_mp > 0 then
                    print("MP suficiente, apertando A")
                    pressionar("A", 5)
                else
                    print("Sem MP, descendo")
                    pressionar("down", 5)
                end
            end,

            skill4 = function()
                valor_mp = memory.readbyte(0xC637)
                
                if valor_mp > 0 then
                    print("MP suficiente, apertando A")
                    pressionar("A", 5)
                else
                    print("Sem MP, descendo")
                    pressionar("down", 5)
                end
            end,


            A = function()
                pressionar("down", 5)
                pressionar("A", 5)
            end,
    
            nenhum = function()
                print("Detectado: NENHUM")
                pressionar("A", 5)
            end
        }
    


        -- Executa a ação correspondente, se existir
        if acoes[opcao] then
            acoes[opcao]()
        else
            print("Opção não reconhecida: " .. tostring(opcao))
            print("Pressionando A")
            pressionar("A", 5)
        end
    
        -- Limpa o conteúdo do arquivo
        local apagar = io.open("opcao_menu.txt", "w")
        apagar:write("")
        apagar:close()
    end;
    
    
    
    [2] = function()  -- Batalha contra treinador
        local arquivo = io.open("opcao_menu.txt", "r")
        if not arquivo then
            print("Arquivo 'opcao_menu.txt' não encontrado!")
            return
        end
    
        local opcao = arquivo:read("*l")
        arquivo:close()
    
        local function pressionar(tecla, vezes)
            for i = 1, vezes do
                joypad.set(1, { [tecla] = true })
                emu.frameadvance()
            end
            joypad.set(1, { [tecla] = false })
            emu.frameadvance()
        end
    
        local acoes = {
            fight = function()
                print("Detectado: FIGHT")
                pressionar("A", 5)
    
                for i = 1, 5 do
                    pressionar("down", 5)
                end
    
                pressionar("A", 5)
    
                for i = 1, 90 do  -- Espera 90 frames (ajustável)
                    emu.frameadvance()
                end
            end,
    
            run = function()
                print("Detectado: RUN")
                pressionar("left", 5)
                pressionar("up", 5)
            end,
    
            pack = function()
                print("Detectado: PACK")
                pressionar("up", 5)
            end,
    
            poke = function()
                print("Detectado: POKE")
                pressionar("left", 5)
            end,

            skill1 = function()
                valor_mp = memory.readbyte(0xC634)
                
                if valor_mp > 0 then
                    print("MP suficiente, apertando A")
                    pressionar("A", 5)
                else
                    print("Sem MP, descendo")
                    pressionar("down", 5)
                end  -- <- este estava faltando
            end,

            skill2 = function()
                valor_mp = memory.readbyte(0xC635)
                
                if valor_mp > 0 then
                    print("MP suficiente, apertando A")
                    pressionar("A", 5)
                else
                    print("Sem MP, descendo")
                    pressionar("down", 5)
                end
            end,

            skill3 = function()
                valor_mp = memory.readbyte(0xC636)
                
                if valor_mp > 0 then
                    print("MP suficiente, apertando A")
                    pressionar("A", 5)
                else
                    print("Sem MP, descendo")
                    pressionar("down", 5)
                end
            end,

            skill4 = function()
                valor_mp = memory.readbyte(0xC637)
                
                if valor_mp > 0 then
                    print("MP suficiente, apertando A")
                    pressionar("A", 5)
                else
                    print("Sem MP, descendo")
                    pressionar("down", 5)
                end
            end,


            A = function()
                pressionar("down", 5)
                pressionar("A", 5)
            end,
    
            nenhum = function()
                print("Detectado: NENHUM")
                pressionar("A", 5)
            end
        }
    


        -- Executa a ação correspondente, se existir
        if acoes[opcao] then
            acoes[opcao]()
        else
            print("Opção não reconhecida: " .. tostring(opcao))
            print("Pressionando A")
            pressionar("A", 5)
        end
    
        -- Limpa o conteúdo do arquivo
        local apagar = io.open("opcao_menu.txt", "w")
        apagar:write("")
        apagar:close()
    end;

    [122] = function()  -- NPC TALK
        print("NPC Detectado: Apertar A")
        joypad.set(1, { A = true })
        emu.frameadvance()
        joypad.set(1, { A = false })
        emu.frameadvance()
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
