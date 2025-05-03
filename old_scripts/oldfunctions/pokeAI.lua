local battle_address = 0xD22D  -- Endereço do estado de batalha

while true do
    local battle_state = memory.readbyte(battle_address)
    print(require("socket"))

    if battle_state == 0x01 then
        print("Pokémon selvagem encontrado!")
    elseif battle_state == 0x02 then
        print("Treinador encontrado!")
    end

    -- Salvar estado em um arquivo para o Python ler
    local file = io.open("battle_state.txt", "w")
    file:write("teste")
    file:close()

    emu.frameadvance()  -- Avançar para o próximo frame do jogo
end
