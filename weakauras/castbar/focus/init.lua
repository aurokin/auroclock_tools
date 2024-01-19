local requiredACT = 5;
C_Timer.After(AuroclockTools ~= nil and AuroclockTools.registerDelay() or 5, function() 
        local waName = "Focus Castbar";
        local waId = "FocusCastbar";
        local waVersion = 1;  
        
        WeakAuras.ScanEvents("AUROCLOCK_TOOLS_REGISTER_WA", waId, waName, waVersion, requiredACT);
end);

-- #?# /snippets/initLoad.lua

aura_env.init = function()
end

aura_env.unit = "focus";

aura_env.sendTargetCheck = function()
    if (aura_env.timer ~= nil and not aura_env.timer:IsCancelled()) then
        aura_env.timer:Cancel();
        aura_env.timer = nil;
    end
    
    aura_env.timer = C_Timer.NewTimer(0.1, function()
            WeakAuras.ScanEvents("AURO_CAST_TARGET_CHECK", "focus");
    end);
end

-- #?# /snippets/initEnd.lua