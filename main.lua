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
    
            A = function()
                print("Detectado: A")
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
        end
    
        -- Limpa o conteúdo do arquivo
        local apagar = io.open("opcao_menu.txt", "w")
        apagar:write("")
        apagar:close()
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
