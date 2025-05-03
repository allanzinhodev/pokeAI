local battle = {}
local config = require("config")
local move = require("move")

function attack()
    while onAttackMenu() do
        print("Attack")
        if cannotUseSkill() then -- não tem pp?
            move.random(2)
            move.random(2)
            print("Cannot use Skill")
        elseif onAttackMenu() then
            pressA()
            print("Funcao Attack pressA")
            break
        else 
        end
        emu.frameadvance()
    end
end

function simpleBattle()
    while memory.readbyte(0xD22D) ~= 0x00 do -- Enquanto fora da tela do mapa
        justtalk()
        if getState() == "wild" then
            print("SPCapturar")
            capturar()
            print("SPBattleAction Attack")
            battleAction("attack")
            print("SP Atack")
            attack()
            print("SP Next Pokemon")
            nextPokemon()
            print("SP Change Pokemon")
            changePoke()
            print("getNewMove")
            updateNewMove()
            ifDie()
        elseif getState() == "trainer" then
            print("SPBattleAction Attack")
            battleAction("attack")
            print("SP Atack")
            attack()
            print("SP Next Pokemon")
            nextPokemon()
            print("SP Change Pokemon")
            changePoke()
            print("getNewMove")
            updateNewMove()
            justtalk()
            pressA()
            ifDie()
        end
        emu.frameadvance()
    end
end

function updateNewMove()
    local changeSkillNumber = nil
    if onNewMove() then
        if rightYesArrow() then
            pressA()
        elseif rightNoArrow() then
            move.up()
        end
    elseif onNewMoveShould() then
        move.random(3)
        move.random(3)
        pressA()
        --for i = 1, 4, 1 do
        --    print("SKILL OFFSET")
        --    print(string.format("0x%X", onBattleSkillOffset(i)))
        --    if isLowPriorityMove(onBattleSkillOffset(i)) then
        --        print("encontrada")
        --        changeSkillNumber = i
        --    end
        --end
       -- if changeSkillNumber ~= nil then
       --     if onSkillChangeArrow(changeSkillNumber) then
       --         print("Skill Low Priority encontrada")
       --         pressA()
       --     else 
       --         print("Buscar Outra")
       --     end
       -- end
    end
end

function ifDie()
    print("ifDie")
    if playerDead() and onPokeDead() then
        pressA()
    end
end

function nextPokemon()
    while onNextPokeScreen() do
        if leftYesArrow() then
            pressA()
            break
        elseif leftNoArrow() then
            move.up()
        end
        emu.frameadvance()
    end
end

function changePoke()
    while whichPoke() do
        move.down()
        pressA()
    end
    ifDie()
end

function battleAction(action)
    while onBattleMenu() do
        if action == "attack" then
            if onPackArrow() then
                move.up()
            elseif onRunArrow() then
                move.left()
            elseif onPKMArrow() then
                move.left()
            elseif onFightArrow() then
                pressA()
                print ("battleMenu -> skillMenu")
            end
        elseif action == "pack" then
            if onPackArrow() then
                pressA()
                print ("battleMenu -> packMenu")
            elseif onRunArrow() then
                move.left()
            elseif onPKMArrow() then
                move.left()
            elseif onFightArrow() then
                move.down()
            end
        elseif action == "PKM" then
            if onPackArrow() then
                move.up()
            elseif onRunArrow() then
                move.up()
            elseif onPKMArrow() then
                pressA()
                print ("battleMenu -> PKMMenu")
            elseif onFightArrow() then
                move.right()
            end
        elseif action == "run" then
            if onPackArrow() then
                move.right()
            elseif onRunArrow() then
                pressA()
                print ("battleMenu -> RUN")
            elseif onPKMArrow() then
                move.down()
            elseif onFightArrow() then
                move.down()
            end
        else 
            break
        end
    emu.frameadvance()
    end
end

function capturar()
    if havePokeball() and ownThisPokemon() and notOnCaughtChat() then
        print("Try capture")
        battleAction("pack")
    end
    if onPocket() then
        print("OnPocket")
        if onPocketBalls() then
            print("OnPocketBalls")
            pressA()
        else
            move.right()
        end
    end

    if onCapturedScreen() then
        print("onCaptureScreen")
        pressA()
    elseif onNicknameScreen() then
        print("onNicknameScreen")
        if rightYesArrow() then
            print("rightYesArrow")
            move.down()
        elseif rightNoArrow() then
            print("rightNoArrow")
            pressA()
        end
    end

end

return battle