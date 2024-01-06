local requiredACT = 3;
C_Timer.After(AuroclockTools ~= nil and AuroclockTools.registerDelay() or 5, function() 
        local waName = "Keystone Reporter";
        local waId = "KeystoneReporter";
        local waVersion = 3;  
        
        WeakAuras.ScanEvents("AUROCLOCK_TOOLS_REGISTER_WA", waId, waName, waVersion, requiredACT);
end);

aura_env.checkItems = aura_env.checkItems or false;

-- #?# /snippets/initLoad.lua

aura_env.init = function()
    -- Set Initial Data
    if (aura_env.keystoneInfo == nil) then
        aura_env.keystoneInfo = aura_env.getKeystoneInfo();
    end 
end

aura_env.getKeystoneInfo = function()
    local id, level, name = AuroclockTools.MPlus.getKeystone();
    if (id ~= nil and level ~= nil and name ~= nil) then
        return { ["id"] = id, ["level"] = level, ["name"] = name };
    end
    
    return nil;
end

aura_env.hasKeystoneChanged = function(newKeystoneInfo)
    if ((aura_env.keystoneInfo == nil and newKeystoneInfo ~= nil) or (aura_env.keystoneInfo ~= nil and newKeystoneInfo == nil)) then
        return true;
    end 
    
    return aura_env.keystoneInfo.id ~= newKeystoneInfo.id or aura_env.keystoneInfo.level ~= newKeystoneInfo.level;
end

aura_env.sendKeyInfo = function()
    local msgType = AuroclockTools.Utility.getMsgType(); 
    local msg = "";
    if (msgType ~= nil) then
        local keystoneLink = AuroclockTools.MPlus.createKeyLink();
        if (keystoneLink ~= nil) then
            msg = keystoneLink;
        else
            msg = format("No Key =(");
        end
        
        SendChatMessage(msg, msgType);
    end
end

aura_env.isKeystonePanda = function()
    return AuroclockTools.Utility.getNpcIdFromUnit("target") == 197711; 
end


-- #?# /snippets/initEnd.lua

