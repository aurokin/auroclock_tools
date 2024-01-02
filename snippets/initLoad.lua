aura_env.load = function()
    if (aura_env.loaded == true) then return true; end
    
    aura_env.loaded = AuroclockTools ~= nil and AuroclockTools.versionCheck(requiredACT);
    if (not aura_env.loaded) then return false; end
    
    aura_env.init();
    
    return aura_env.loaded;
end