local config = {}
-- 🧭 Posição do jogador
config.player = {
    x = function() return memory.readbyte(0xDCB8) end,  -- X pos
    y = function() return memory.readbyte(0xDCB7) end,  -- Y pos
    map = function() return memory.readbyte(0xDCB6) end,  -- map ID // 276 trade map
    mapBank = function() return memory.readbyte(0xDCB5) end,  -- map ID // 276 trade map
    collision_down  = memory.readbyte(0xC2FA), -- 07 Block -- FF black square
    collision_up    = memory.readbyte(0xC2FB),
    collision_left  = memory.readbyte(0xC2FC),
    collision_right = memory.readbyte(0xC2FD),

}

have.battle = {
    fight = function() return memory.readbyte(0xC5C1) == 0xED end,
}

-- ⚔️ Batalha
config.battle = {
    havePokeball = function()
        return memory.readbyte(0xD8D7) ~= 0x00
    end,
    
    getState = function()
        return memory.readbyte(0xD22D)
    end,
    getItemMenu = function()
        return memory.readbyte(0x956D)
    end,
    skill1 = function() return memory.readbyte(0xC634) end,
    skill2 = function() return memory.readbyte(0xC635) end,
    skill3 = function() return memory.readbyte(0xC636) end,
    skill4 = function() return memory.readbyte(0xC637) end,
}

return config
