local requiredACT = 2;
C_Timer.After(AuroclockTools ~= nil and AuroclockTools.registerDelay() or 5, function() 
        local waName = "WA_Name_Here";
        local waId = "WA_ID_Here";
        local waVersion = 1;  
        
        WeakAuras.ScanEvents("AUROCLOCK_TOOLS_REGISTER_WA", waId, waName, waVersion, requiredACT);
end);