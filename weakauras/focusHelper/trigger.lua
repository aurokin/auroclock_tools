function(s, e, ...)
    -- PLAYER_FOCUS_CHANGED, CHAT_MSG_ADDON, FRAME_UPDATE, CLEU:SPELL_CAST_SUCCESS, AURO_MPLUS_FOCUS_CHANGED, AURO_MPLUS_FOCUS_BUFFER, ACT_ORL_COOLDOWN_LIST_UPDATE, ACT_ORL_COOLDOWN_UPDATE
    -- #?# /snippets/triggerStart.lua
    
    if (e == "PLAYER_FOCUS_CHANGED") then
        aura_env.bufferFocusChange();
    elseif (e == "AURO_MPLUS_FOCUS_BUFFER") then
        local focusGUID = UnitGUID("focus") or "CLEAR";
        aura_env.updateFocus(aura_env.pName, focusGUID);
        aura_env.sendTimer();
    elseif (e == "AURO_MPLUS_FOCUS_CHANGED") then
        local focusGUID = UnitGUID("focus") or "CLEAR";
        aura_env.sendFocusMessage(focusGUID);
    elseif (e == "CHAT_MSG_ADDON") then
        local prefix, text, _, sender = select(1, ...);
        if (prefix == aura_env.prefix and sender ~= nil) then
            aura_env.updateFocus(sender, text);
        end
    elseif (e == "FRAME_UPDATE") then
        local now = GetTime();
        if (aura_env.lastTick == nil or aura_env.lastTick + 0.5 <= now) then
            aura_env.lastTick = now;
            
            for k, v in pairs(s) do
                s[k] = { show = false, changed = true }; 
            end
            
            local nameplates = C_NamePlate.GetNamePlates(false);
            for npNum, nameplate in ipairs(nameplates) do
                local unit = nameplate.namePlateUnitToken;
                local guid = UnitGUID(unit);            
                
                local kicks = aura_env.guids[guid];
                
                if (kicks ~= nil) then
                    for name, v in pairs(kicks) do
                        local initial = strsub(name, 1, 1);
                        local _, class = UnitClass(name);
                        local isKickUp = aura_env.isKickUp(name);
                        
                        -- print(name, guid, unit);
                        s[name] = {
                            show = true,
                            changed = true,
                            unit = unit,
                            guid = guid,
                            name = initial,
                            class = class,
                            isKickUp = isKickUp,
                        }
                    end
                end
            end
            
            return true;
        end
    elseif (e == "COMBAT_LOG_EVENT_UNFILTERED") then
        local sourceName = select(5, ...);
        local spellId = select(12, ...);
        if (sourceName ~= nil and spellId ~= nil) then
            local name = aura_env.removeRealmName(sourceName); 
            aura_env.addKick(name, spellId);
        end
    elseif (e == "ACT_ORL_COOLDOWN_LIST_UPDATE" or e == "ACT_ORL_COOLDOWN_UPDATE") then
        local unit = select(1, ...);
        local name = UnitName(unit);
        local spellId = aura_env.lastKick[name];

        if (name ~= nil and spellId ~= nil) then
            local now = GetTime();
            local isReady, _, timeLeft = AuroclockTools.Libs.ORL.GetCooldownStatusFromUnitSpellID(unit, spellId);
            local isKickUp = aura_env.isKickUp(name);

            if (isReady and not isKickUp) then
                aura_env.kicks[name] = now - 1;
                aura_env.lastTick = nil;
            elseif (not isReady and timeLeft ~= nil) then
                aura_env.kicks[name] = now + timeLeft;
            end
        end
    end
end

