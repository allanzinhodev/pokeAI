-- Configuração do arquivo
local screen_file = "screen_data.txt"
local command_file = "command.txt"

while true do
    -- Captura uma região da tela (exemplo: pixel no canto inferior direito)
    local x, y = 220, 140  -- Coordenadas da seta (ajuste conforme necessário)
    local color = gui.getpixel(x, y)

    -- Salva a cor do pixel em um arquivo
    local file = io.open(screen_file, "w")
    file:write(tostring(color))  -- Escreve a cor no arquivo
    file:close()

    -- Verifica se Python enviou um comando
    local cmd_file = io.open(command_file, "r")
    if cmd_file then
        local command = cmd_file:read("*all")
        cmd_file:close()

        -- Se o comando for "Z", pressiona o botão Z
        if command == "Z" then
            joypad.set(1, {["Z"]=true})
        end
    end

    emu.frameadvance() -- Avança para o próximo frame
end
