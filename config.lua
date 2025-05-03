local config = {}
    -- Player States
    x = memory.readbyte(0xDCB8)  -- X pos
    y = memory.readbyte(0xDCB7)  -- Y pos
    position = function() return memory.readword(0xDCB7) end
    getX = function() return memory.readbyte(0xDCB8) end -- X pos
    getY = function() return memory.readbyte(0xDCB7) end-- Y pos
    xInt = memory.readbyteunsigned(0xDCB8)  -- X pos
    yInt = memory.readbyteunsigned(0xDCB7)  -- Y pos
    map = memory.readbyte(0xDCB6) -- map ID // 276 trade map
    mapBank = memory.readbyte(0xDCB5)  -- map ID // 276 trade map
    getMap = function() return memory.readbyte(0xDCB6) end -- map ID // 276 trade map
    getMapBank = function() return memory.readbyte(0xDCB5) end -- map ID // 276 trade map
    mapID = function() return memory.readword(0xDCB5) end -- map com mapBANK
    havePokeball = function() return memory.readbyte(0xD8D7) ~= 0x00 end
    onPokeDead = function() return memory.readbyte(0xC63C) == 0x00 end

    collisionDown  = function() return memory.readbyte(0xC2FA) == 0x00 or memory.readbyte(0xC2FA) == 0x7A end
    collisionUp  = function() return memory.readbyte(0xC2FB) == 0x00 or memory.readbyte(0xC2FB) == 0x7A  end
    collisionLeft  = function() return memory.readbyte(0xC2FC) == 0x00 or memory.readbyte(0xC2FC) == 0x7A  end
    collisionRight  = function() return memory.readbyte(0xC2FD) == 0x00 or memory.readbyte(0xC2FD) == 0x7A  end

    -- Low Priority Moves OFFSETS
    local lowPriorityMoveId = {
        [0x2B] = true,
        [0x2D] = true,
        [0x51] = true,
        [0x68] = true,
        [0x6F] = true,
        [0x73] = true,
        [0xC1] = true,
        [0xC5] = true,
        [0xE3] = true
      }

    --screens
    ownThisPokemon = function() return memory.readbyte(0xC4B5) ~= 0x5D end
    onAttackMenu = function() return memory.readword(0xC5F8) == 0x7A7D end
    onBattleMenu = function() return memory.readdword(0xC5C2) == 0x87868885 and memory.readdword(0xC5CA) == 0x7F7C7C7F end
    enemyHpScreen = function() return memory.readdword(0xC4C8) == 0x61606D7F end
    cannotUseSkill = function() return memory.readword(0xC581) == 0xF67F or memory.readword(0xC56D) == 0xABA1 end -- Disable ou PP 0
    onNextPokeScreen = function() return memory.readdword(0xC5C6) == 0xE68D8E8C end
    whichPoke = function() return memory.readdword(0xC5E5) == 0xE2E17FA7 end
    onPocket = function() return memory.readdword(0xC4A0) == 0x2B2A2928 end
    onPocketTMHM = function() return memory.readdword(0xC540) == 0x13121110 end
    onPocketItems = function() return memory.readdword(0xC540) == 0x09080706 end
    onPocketBalls = function() return memory.readdword(0xC540) == 0x18171615 end
    onPocketKeyItems = function() return memory.readdword(0xC540) == 0x0E0D0C0B end
    onCapturedScreen = function() return memory.readdword(0xC568) == 0x61575636 or memory.readdword(0xC568) == 0x61585636 end
    onNicknameScreen = function() return memory.readdword(0xC5C7) == 0xAEB37FA4 end
    notOnCaughtChat = function() return memory.readdword(0xC5E5) ~= 0xA6B4A0A2 end
    playerDead = function() return memory.readdword(0xC5E1) == 0xE7B3B4AE end
    onNewMove = function() return memory.readdword(0xC550) == 0x7C928498 and memory.readdword(0xC5C6) == 0xACAEAEB1 end
    onNewMoveShould = function() return memory.readdword(0xC5C6) == 0xA3ABB4AE end

    --arrows
    onFightArrow = function() return memory.readbyte(0xC5C1) == 0xED end
    onPKMArrow = function() return memory.readbyte(0xC5C7) == 0xED end
    onRunArrow = function() return memory.readbyte(0xC5EF) == 0xED end
    onPackArrow = function() return memory.readbyte(0xC5E9) == 0xED end
    leftYesArrow = function() return memory.readword(0xC542) == 0x98ED end
    leftNoArrow = function() return memory.readbyte(0xC56A) == 0x8D7F end
    rightYesArrow = function() return memory.readdword(0xC54F) == 0x928498ED end
    rightNoArrow = function() return memory.readdword(0xC577) == 0x7F8E8DED end
    onSkillChangeArrow = function(skillNumber) return memory.readbyte(0xC4CF + skillNumber * 27) == 0xED end
    onSkill2ChangeArrow = function() return memory.readbyte(0xC51F) == 0xED end
    onSkill3ChangeArrow = function() return memory.readbyte(0xC546) == 0xED end
    onSkill4ChangeArrow = function() return memory.readbyte(0xC56F) == 0xED end

    function getState()
        state = memory.readbyte(0xD22D)
        if state == 0x00 then
            return "map"
        elseif state == 0x01 then
            return "wild"
        elseif state == 0x02 then
            return "trainer"
        else 
            return "unknown state"
        end
    end

    function skillHavePP(x)
        print(tostring (memory.readbyte(0xC633 + x)) )
        return memory.readbyte(0xC633 + x) ~= 0x00
    end

    function onBattleSkillOffset(x)
        print(string.format("0x%X", memory.readbyte(0xC62D + x)))
        return memory.readbyte(0xC662D + x)
    end

    function isLowPriorityMove(offset)
        return lowPriorityMoveId[offset] == true
    end

return config