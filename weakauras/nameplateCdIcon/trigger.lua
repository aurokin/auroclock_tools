function(s, e, ...)
    -- PLAYER_ENTERING_WORLD, FRAME_UPDATE, CLEU:SPELL_CAST_START:UNIT_DIED
    if (e == "PLAYER_ENTERING_WORLD") then
        aura_env.reset();
        
        -- Reset State
        for k, v in pairs(s) do
            s[k] = {
                show = true,
                changed = true,
            };
        end
        
        return true;
    elseif (e == "FRAME_UPDATE") then
        local now = GetTime();
        local changed = false;
        
        if (aura_env.lastScan == nil or aura_env.lastScan + aura_env.config.scanRate <= now) then
            aura_env.lastScan = now;   
            
            local nameplates = C_NamePlate.GetNamePlates(false);
            for npNum, nameplate in ipairs(nameplates) do
                local unit = nameplate.namePlateUnitToken;
                local guid = UnitGUID(unit);            
                
                -- Get NPC ID
                local npcId = AuroclockTools.Utility.getNpcIdFromUnit(unit, guid);
                local npcInfo = aura_env.npcs[npcId];
                
                if (npcInfo ~= nil and UnitAffectingCombat(unit)) then
                    -- Unit Affecting Combat
                    aura_env.scans[guid] = now;
                    
                    if (aura_env.cds[guid] == nil) then
                        for spellId, spellEnabled in pairs(npcInfo) do
                            local spellInfo = aura_env.spellIds[spellId];
                            if (spellInfo ~= nil) then
                                local cd = spellInfo.initialCd or 0; 
                                aura_env.addCd(guid, spellId, cd);
                                aura_env.lastUpdate = nil;
                            end
                        end
                    end
                end
            end
        end
        
        if (aura_env.lastPurge == nil or aura_env.lastPurge + aura_env.config.purgeRate <= now) then
            aura_env.lastPurge = now;
            
            for guid, scannedAt in pairs(aura_env.scans) do
                if (scannedAt + aura_env.config.purgeRate <= now) then
                    aura_env.scans[guid] = nil;
                    aura_env.cds[guid] = nil;
                end
            end
        end
        
        if (aura_env.lastUpdate == nil or aura_env.lastUpdate + aura_env.config.updateRate <= now) then
            aura_env.lastUpdate = now;
            changed = true;
            
            for k, v in pairs(s) do
                s[k] = { show = false, changed = true }; 
            end
            
            local nameplates = C_NamePlate.GetNamePlates(false);
            for npNum, nameplate in ipairs(nameplates) do
                local unit = nameplate.namePlateUnitToken;
                local guid = UnitGUID(unit);            
                
                local cds = aura_env.cds[guid];
                
                if (cds ~= nil) then
                    for spellId, cd in pairs(cds) do
                        local isReady = now >= cd.expirationTime;
                        local key = aura_env.buildKey(guid, spellId);
                        
                        -- print(name, guid, unit);
                        s[key] = {
                            show = true,
                            changed = true,
                            unit = unit,
                            guid = guid,
                            icon = cd.spellIcon,
                            progressType = "timed",
                            duration = cd.duration,
                            expirationTime = cd.expirationTime,
                            isReady = isReady,
                        }
                    end
                end
            end 
        end
        
        return changed;
    elseif (e == "COMBAT_LOG_EVENT_UNFILTERED") then
        -- SPELL_CAST_SUCCESS:UNIT_DIED
        local subEvent = select(2, ...);
        
        if (subEvent == "UNIT_DIED") then
            local destGUID = select(8, ...);
            
            if (aura_env.scans[destGUID] ~= nil) then
                aura_env.scans[destGUID] = nil;
            end
            
            if (aura_env.cds[destGUID] ~= nil) then
                aura_env.cds[destGUID] = nil;
                aura_env.lastUpdate = nil;
            end
        elseif (subEvent == "SPELL_CAST_START") then
            local sourceGUID = select(4, ...);
            local spellId = select(12, ...);
            
            local spellInfo = aura_env.spellIds[spellId];
            
            if (spellInfo ~= nil) then
                aura_env.addCd(sourceGUID, spellId, spellInfo.cd);
                aura_env.lastUpdate = nil;
            end
        end
    end
end

