local move = require("move")
local battle = require("battle")
local config = require("config")
local map = require("map")
local lastState = -1
state = getState()
  -- Se ED é porque está no comando FIGH

function handleBattleState()
    state = getState()
    if state == "map" and memory.readbyte(0xC4DD) ~= 0x74 or playerDead() then
        print("map")
       --mapRecord()
       -- mapActions()
        justtalk()
        move.random(5)
        pressA()
    elseif state == "wild" then
        ifDie()
        print("wild")
       -- capturar()
        justtalk()
        simpleBattle()
    elseif state == "trainer" then
        ifDie()
        print("trainer")
        simpleBattle()
        justtalk()
    else
    end
    emu.frameadvance()
end

while true do
    handleBattleState()
    justtalk()
    emu.frameadvance()
end
