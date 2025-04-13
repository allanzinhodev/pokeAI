function walkTo(destX, destY)
    local visitados = {}

    local function marcarVisitado(x, y)
        visitados[y .. "," .. x] = true
    end

    local function foiVisitado(x, y)
        return visitados[y .. "," .. x] == true
    end

    local prioridadeXY = true -- alterna a prioridade entre Y -> X e X -> Y quando bloqueado

    while true do
        local y = memory.readbyte(0xDCB7)
        local x = memory.readbyte(0xDCB8)

        print(string.format("Pos atual: (%d, %d) | Destino: (%d, %d)", x, y, destX, destY))

        if x == destX and y == destY then
            print("✅ Chegou no destino!")
            break
        end

        marcarVisitado(x, y)

        local dx = destX - x
        local dy = destY - y

        local collision_down  = memory.readbyte(0xC2FA)
        local collision_up    = memory.readbyte(0xC2FB)
        local collision_left  = memory.readbyte(0xC2FC)
        local collision_right = memory.readbyte(0xC2FD)

        local function podeAndar(collision, destino)
            return (collision ~= 0x07 and collision ~= 0x29 and (collision ~= 0xFF or destino) and (collision ~= 0x71 or destino))
        end

        local moveFeito = false

        local direcoes = {
            { cond = (dy > 0), dir = "down", collision = collision_down, dest = (y + 1 == destY), nx = x, ny = y + 1 },
            { cond = (dy < 0), dir = "up", collision = collision_up, dest = (y - 1 == destY), nx = x, ny = y - 1 },
            { cond = (dx > 0), dir = "right", collision = collision_right, dest = (x + 1 == destX), nx = x + 1, ny = y },
            { cond = (dx < 0), dir = "left", collision = collision_left, dest = (x - 1 == destX), nx = x - 1, ny = y },
        }

        if not prioridadeXY then
            -- troca a ordem: tenta eixo X antes do Y
            direcoes = { direcoes[3], direcoes[4], direcoes[1], direcoes[2] }
        end

        for _, d in ipairs(direcoes) do
            if d.cond then
                if podeAndar(d.collision, d.dest) then
                    if not foiVisitado(d.nx, d.ny) then
                        print("➡️ Movendo para", d.dir, "->", d.nx, d.ny)
                        joypad.set(1, { [d.dir] = true }); emu.frameadvance(); joypad.set(1, { [d.dir] = false })
                        moveFeito = true
                        break
                    else
                        print("⛔ Já visitado:", d.nx, d.ny, "(bloqueado)")
                    end
                else
                    print("❌ Colisão ao tentar ir", d.dir, "(valor:", string.format("0x%02X", d.collision), ")")
                end
            end
        end

        if not moveFeito then
            print("🔄 Tentando desviar...")
            local opcoes = {}

            if podeAndar(collision_up, false) and not foiVisitado(x, y - 1) then table.insert(opcoes, { dir = "up", nx = x, ny = y - 1 }) end
            if podeAndar(collision_down, false) and not foiVisitado(x, y + 1) then table.insert(opcoes, { dir = "down", nx = x, ny = y + 1 }) end
            if podeAndar(collision_left, false) and not foiVisitado(x - 1, y) then table.insert(opcoes, { dir = "left", nx = x - 1, ny = y }) end
            if podeAndar(collision_right, false) and not foiVisitado(x + 1, y) then table.insert(opcoes, { dir = "right", nx = x + 1, ny = y }) end

            if #opcoes > 0 then
                local desvio = opcoes[math.random(1, #opcoes)]
                print("🌀 Desviando para:", desvio.dir, "->", desvio.nx, desvio.ny)
                joypad.set(1, { [desvio.dir] = true }); emu.frameadvance(); joypad.set(1, { [desvio.dir] = false })
            else
                prioridadeXY = not prioridadeXY
                print("🚧 Preso! Trocando prioridade de movimentação (XY <-> YX)")
            end
        end

        emu.frameadvance()
    end
end




-- Move aleatoriamente em uma das 4 direções
function moveRandom()
    local direcoes = { "up", "down", "left", "right" }
    local escolha = direcoes[math.random(1, #direcoes)]

    joypad.set(1, { [escolha] = true })
    emu.frameadvance()
    joypad.set(1, { [escolha] = false })
    emu.frameadvance()
end
