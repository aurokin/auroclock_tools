function(s, e, ...)
    -- UNIT_SPELLCAST_CHANNEL_START:focus,UNIT_SPELLCAST_CHANNEL_STOP:focus,UNIT_SPELLCAST_CHANNEL_UPDATE:focus,UNIT_SPELLCAST_DELAYED:focus,UNIT_SPELLCAST_EMPOWER_START:focus,UNIT_SPELLCAST_EMPOWER_STOP:focus,UNIT_SPELLCAST_EMPOWER_UPDATE:focus,UNIT_SPELLCAST_FAILED:focus,UNIT_SPELLCAST_FAILED_QUIET:focus,UNIT_SPELLCAST_INTERRUPTED:focus,UNIT_SPELLCAST_INTERRUPTIBLE:focus,UNIT_SPELLCAST_NOT_INTERRUPTIBLE:focus,UNIT_SPELLCAST_RETICLE_CLEAR:focus,UNIT_SPELLCAST_RETICLE_TARGET:focus,UNIT_SPELLCAST_START:focus,UNIT_SPELLCAST_STOP:focus,UNIT_SPELLCAST_SUCCEEDED:focus,AURO_CAST_TARGET_CHECK,PLAYER_FOCUS_CHANGED
    -- #?# /snippets/triggerStart.lua

    local unit = select(1, ...);
    local cast = true;
    
    if (unit == aura_env.unit or e == "PLAYER_FOCUS_CHANGED") then
        local name, _, icon, startTimeMS, endTimeMS, _, castGUID, notInterruptible, spellId = UnitCastingInfo(aura_env.unit);
        if (name == nil) then
            name, _, icon, startTimeMS, endTimeMS, _, notInterruptible, spellId = UnitChannelInfo(aura_env.unit);
            cast = false;
        end
        
        if (name ~= nil) then
            local duration = (endTimeMS - startTimeMS) / 1000;
            local props = {
                ["interruptible"] = false,
                ["emphasizedInterrupt"] = false,
                ["stoppable"] = false,
                ["emphasizedStoppable"] = false,
            }
            
            if (AuroclockTools and AuroclockTools.Data.MPlusSpellDb) then
                local spellData = AuroclockTools.Data.MPlusSpellDb[spellId];
                if (spellData ~= nil) then
                    for k, v in pairs(props) do
                        if (spellData[k] ~= nil) then
                            props[k] = spellData[k]; 
                        end
                    end
                end
            end
            
            local targetUnit = format("%starget", aura_env.unit);
            local target = "";
            if (UnitExists(targetUnit)) then
                target = format(">> %s", WA_ClassColorName(targetUnit) or UnitName(targetUnit));
            end
            
            s.cast = {
                show = true,
                changed = true,
                progressType = "timed",
                cast = cast,
                name = name,
                icon = icon,
                spellId = spellId,
                duration = duration,
                expirationTime = endTimeMS / 1000,
                notInterruptible = notInterruptible, -- From WoW API
                autoHide = true,
                target = target,
            }
            
            for k, v in pairs(props) do
                s.cast[k] = v; 
            end
            
            aura_env.sendTargetCheck();
            
            return true;
        else 
            s.cast = {
                show = false,
                changed = true,
            }
            
            return true;
        end
    end
end

