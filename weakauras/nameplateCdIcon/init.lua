local requiredACT = 5;
C_Timer.After(AuroclockTools ~= nil and AuroclockTools.registerDelay() or 5, function() 
        local waName = "Nameplate CD Icon";
        local waId = "NameplateCDIcon";
        local waVersion = 1;  
        
        WeakAuras.ScanEvents("AUROCLOCK_TOOLS_REGISTER_WA", waId, waName, waVersion, requiredACT);
end);

-- #?# /snippets/initLoad.lua

aura_env.init = function()
    -- Set Initial Data
    aura_env.reset();
end

aura_env.npcs = {};
aura_env.spellIds = {};

aura_env.addSpell = function(npcId, spellId, initialCd, cd)
    -- Initial Cast Can Be Nil 
    if (aura_env.npcs[npcId] == nil) then
        aura_env.npcs[npcId] = {}; 
    end
    aura_env.npcs[npcId][spellId] = true;
    
    aura_env.spellIds[spellId] = {
        initialCd = initialCd,
        cd = cd,
    }
end

-- npcId, spellId, initialCd, cd
-- aura_env.addSpell(187318, 372862, 2, 10); --Test Spell

-- Atal'Dazar
aura_env.addSpell(122973, 253544, 9, 23); -- Mantle
aura_env.addSpell(122967, 255591, 9, 34); -- Molten Gold
aura_env.addSpell(122984, 254959, 5, 12); -- Soulburn
-- BRH
aura_env.addSpell(98275, 200343, 9.9, 20); -- Arrow Barrage
aura_env.addSpell(101839, 225962, 4.2, 14.6); -- Bloodthirsty Leap
aura_env.addSpell(98810, 201139, 10.7, 20.7); -- Brutal Assault
aura_env.addSpell(98691, 200291, 7, 18.2); -- Knife Dance
aura_env.addSpell(98368, 200105, 17, 26.8); -- Sacrifice Soul
-- DHT
aura_env.addSpell(200580, 95779, 5.6, 14.5); -- Maddening Roar, 2nd should start @ 14
aura_env.addSpell(99358, 198904, 5.9, 19.4); -- Poison Spear
aura_env.addSpell(95772, 200618, 4.7, 18.1); -- Frantic Leap
aura_env.addSpell(99365, 201517, 6.6, 8.5); -- Dark Hunt
aura_env.addSpell(99359, 220369, 9.7, 17); -- Vile Mushroom
aura_env.addSpell(101679, 200684, 9.6, 17); -- Nightmare Toxin
aura_env.addSpell(100531, 201226, 9.4, 23.1); -- Blood Assault
-- Throne
aura_env.addSpell(40577, 428542, 13.4, 9.3); -- Crushing Depths, 2nd should start @ 19.5
aura_env.addSpell(40925, 76634, 7.5, 20.6); -- Swell
aura_env.addSpell(40936, 428926, 9.7, 24.2); -- Clenching Tentacles
aura_env.addSpell(212673, 426684, 9.9, 20.6); -- Volatile Bolt
-- Everbloom
aura_env.addSpell(81984, 426500, 8.4, 18.2); -- Gnarled Roots
aura_env.addSpell(86372, 172576, 5.9, 17); -- Bounding Whirl
aura_env.addSpell(84957, 427223, 8.1, 18.3); -- Cinderbolt Salvo
aura_env.addSpell(84990, 426974, 4.9, 19.4); -- Spatial Disruption
aura_env.addSpell(84767, 169445, 10.9, 19.4); -- Noxious Eruption
-- DOTI
aura_env.addSpell(205158, 412215, 6.2, 19.5); -- Shrouding Sandstorm
aura_env.addSpell(206070, 419511, 8.9, 23); -- Temporal Link
aura_env.addSpell(205723, 412156, 11.1, 17); -- Bombing Run
aura_env.addSpell(205435, 412052, 3.6, 14.5); -- Timerip, 2nd should start @ 19.4
aura_env.addSpell(206140, 415770, 9.8, 14.6); -- Infinite Bolt Volley
aura_env.addSpell(201222, 413024, 13, 27.1); -- Titan Bulwark
aura_env.addSpell(206214, 413622, 3.6, 20.6); -- Infinite Fury
aura_env.addSpell(206230, 413622, 3.6, 20.6); -- Infinite Fury
aura_env.addSpell(207177, 413622, 3.6, 20.6); -- Infinite Fury
aura_env.addSpell(208440, 413622, 3.6, 20.6); -- Infinite Fury, 2nd should start @ 12.1 [Only 208440]
-- Waycrest
aura_env.addSpell(131586, 265407, 9.3, 17); -- Dinner Bell

aura_env.reset = function()
    aura_env.cds = {}; 
    aura_env.scans = {};
    aura_env.lastScan = nil;
    aura_env.lastPurge = nil;
    aura_env.lastUpdate = nil;
end
aura_env.reset();

aura_env.addCd = function(guid, spellId, spellCd)
    -- Key: GUID
    -- Save SpellId
    -- Save Spell Icon
    -- Save Duration: CD
    -- Save Expiration Time (Now + CD)
    if (aura_env.cds[guid] == nil) then
        aura_env.cds[guid] = {}; 
    end
    
    local _, _, icon = GetSpellInfo(spellId);
    
    if (icon ~= nil) then
        aura_env.cds[guid][spellId] = {
            ["spellIcon"] = icon,
            ["duration"] = spellCd,
            ["expirationTime"] = spellCd + GetTime();
        }
    end
end

aura_env.buildKey = function(guid, spellId)
    return format("%s-%s", guid, spellId);
end

-- #?# /snippets/initEnd.lua
