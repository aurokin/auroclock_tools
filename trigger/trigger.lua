function(e, ...)
    -- AUROCLOCK_TOOLS_REGISTER_WA
    if (e == "AUROCLOCK_TOOLS_REGISTER_WA") then
        local id, name, currentVersion, requiredVersion = select(1, ...);
        AuroclockTools.register(id, name, currentVersion, requiredVersion); 
    end
end