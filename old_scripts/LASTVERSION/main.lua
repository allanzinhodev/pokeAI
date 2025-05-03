local move = require("move")
local battle = require("battle")
local config = require("config")
local map = require("map")
local lastState = -1

  -- Se ED é porque está no comando FIGH

function handleBattleState(state)
    if state == 0 and memory.readbyte(0xC4DD) ~= 0x74 then
     --   print("📍 Jogador está no mapa.")
        mapRecord()
        mapActions()
        move.random(6)
        pressA()
    elseif state == 1 then
        if on.battle.fight then
            print("⚔️ Batalha contra Pokémon selvagem!")
        end
       -- capturar()
        --simpleBattle()
        
    elseif state == 2 then
        print("🏆 Batalha contra treinador!")
        simpleBattle()
    else
        print("🔎 Estado desconhecido: " .. tostring(state))
    end
end

while true do
    local currentState = config.battle.getState()
    handleBattleState(currentState)
    justtalk()
    emu.frameadvance()
end
