-- Função para criar a matriz 9x9 do entorno do personagem (5,5 é o centro = posição atual)
function criarMapaBloqueio()
    local mapa = {}
    for i = 1, 9 do
        mapa[i] = {}
        for j = 1, 9 do
            mapa[i][j] = 0
        end
    end
    return mapa
end

-- Marca uma célula como bloqueada no mapa com base no deslocamento relativo
function marcarBloqueio(mapa, dx, dy)
    local cx, cy = 5, 5
    local nx, ny = cx + dx, cy + dy
    if nx >= 1 and nx <= 9 and ny >= 1 and ny <= 9 then
        mapa[ny][nx] = 1
    end
end

-- Verifica se um valor está em uma tabela
function tableContains(tbl, val)
    for i = 1, #tbl do
        if tbl[i] == val then
            return true
        end
    end
    return false
end

-- Função principal: andar até x e y, evitando caminhos bloqueados
function walkTo(dest_x, dest_y)
    local mapa = criarMapaBloqueio()
    local current_x = memory.readbyte(0xDCB8)
    local current_y = memory.readbyte(0xDCB7)

    local max_tentativas = 100
    local tentativas = 0

    while current_x ~= dest_x or current_y ~= dest_y do
        if tentativas > max_tentativas then
            print("Não conseguiu chegar ao destino.")
            break
        end

        local dx = 0
        local dy = 0

        if current_x < dest_x then dx = 1 elseif current_x > dest_x then dx = -1 end
        if current_y < dest_y then dy = 1 elseif current_y > dest_y then dy = -1 end

        local directions = {
            { key = "right", dx = 1, dy = 0, collision = memory.readbyte(0xC2FD) },
            { key = "left",  dx = -1, dy = 0, collision = memory.readbyte(0xC2FC) },
            { key = "down",  dx = 0, dy = 1, collision = memory.readbyte(0xC2FA) },
            { key = "up",    dx = 0, dy = -1, collision = memory.readbyte(0xC2FB) },
        }

        local moved = false

        for _, dir in ipairs(directions) do
            local next_x = current_x + dir.dx
            local next_y = current_y + dir.dy

            if (next_x == dest_x or dx == dir.dx) and
               (next_y == dest_y or dy == dir.dy) and
               dir.collision ~= 0x07 and dir.collision ~= 0xFF and
               mapa[5 + dir.dy][5 + dir.dx] ~= 1 then

                joypad.set(1, { [dir.key] = true })
                emu.frameadvance()
                joypad.set(1, { [dir.key] = false })
                emu.frameadvance()

                moved = true
                break
            end
        end

        if not moved then
            -- Marca como bloqueado no mapa
            for _, dir in ipairs(directions) do
                if dir.collision == 0x07 or dir.collision == 0xFF then
                    marcarBloqueio(mapa, dir.dx, dir.dy)
                end
            end
        end

        current_x = memory.readbyte(0xDCB8)
        current_y = memory.readbyte(0xDCB7)
        tentativas = tentativas + 1
    end

    if current_x == dest_x and current_y == dest_y then
        print("Chegou ao destino: ", dest_x, dest_y)
    end
end

-- Exemplo de uso da função:
-- Andar até a posição X=10, Y=12
walkTo(10, 12)
