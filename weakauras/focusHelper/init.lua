local requiredACT = 3;
C_Timer.After(AuroclockTools ~= nil and AuroclockTools.registerDelay() or 5, function() 
        local waName = "Focus Helper";
        local waId = "FocusHelper";
        local waVersion = 3;  
        
        WeakAuras.ScanEvents("AUROCLOCK_TOOLS_REGISTER_WA", waId, waName, waVersion, requiredACT);
end);

-- #?# /snippets/initLoad.lua

local prefix = "AURO_MPLUS_FOCUS"
aura_env.prefix = prefix;

aura_env.init = function()
    if (not C_ChatInfo.IsAddonMessagePrefixRegistered(prefix)) then
        C_ChatInfo.RegisterAddonMessagePrefix(prefix);
    end
end

aura_env.db = {
    [183752] = 15, -- Disrupt
    [2139] = 24, -- Counterspell
    [351338] = 18, -- Quell
    [96231] = 15, -- Rebuke
    [47528] = 15, -- Mind Freeze
    [106839] = 15, -- Skull Bash
    [78675] = 60, -- Solar Beam
    [147362] = 24, -- Counter Shot
    [187707] = 15, -- Muzzle
    [116705] = 15, -- Spear Hand Strike
    [15487] = 45, -- Silence
    [1766] = 15, -- Kick
    [57994] = 12, -- Wind Shear
    [119898] = 24, -- Command Demon
    [6552] = 15, -- Pummel
};

aura_env.pName = UnitName("player");

aura_env.players = {};
aura_env.guids = {};
aura_env.kicks = {};
aura_env.lastKick = {};
aura_env.lastTick = nil;

aura_env.sendFocusMessage = function(guid)
    local now = GetTime();
    local msgType = AuroclockTools.Utility.getMsgType();
    
    if (msgType ~= nil) then
        aura_env.lastAddonMsg = now;
        C_ChatInfo.SendAddonMessage(prefix, guid, msgType);        
    end
end

aura_env.fillGUIDs = function()
    aura_env.guids = {};
    
    for name, guid in pairs(aura_env.players) do
        if (aura_env.guids[guid] == nil) then
            aura_env.guids[guid] = {}; 
        end 
        
        aura_env.guids[guid][name] = true;
    end
end

aura_env.removeRealmName = function(name)
    return name:match("^([^-]+)");
end

aura_env.isKickUp = function(name)
    local now = GetTime();
    
    local kickExp = aura_env.kicks[name];
    return kickExp == nil or now >= kickExp;
end

aura_env.addKick = function(name, spellId)
    local cd = aura_env.db[spellId];
    if (cd ~= nil) then
        local now = GetTime();
        aura_env.kicks[name] = now + cd;
        aura_env.lastKick[name] = spellId;
    end
end

aura_env.sendTimer = function()
    if (aura_env.timer ~= nil) then
        aura_env.timer:Cancel();
        aura_env.timer = nil;
    end
    
    local now = GetTime();
    local tick = 0.5;
    
    if (aura_env.lastAddonMsg == nil or aura_env.lastAddonMsg + tick <= now) then
        WeakAuras.ScanEvents("AURO_MPLUS_FOCUS_CHANGED", true);
    else
        aura_env.timer = C_Timer.NewTimer(tick, function()
                WeakAuras.ScanEvents("AURO_MPLUS_FOCUS_CHANGED", true);
        end);
    end
end

aura_env.bufferFocusChange = function()
    if (aura_env.fc ~= nil) then
        aura_env.fc:Cancel();
        aura_env.fc = nil;
    end
    
    local now = GetTime();
    local tick = 0.1;
    
    aura_env.fc = C_Timer.NewTimer(tick, function()
            WeakAuras.ScanEvents("AURO_MPLUS_FOCUS_BUFFER", true);
    end);
end

aura_env.updateFocus = function(sender, guid)
    local name = aura_env.removeRealmName(sender);
    -- print(name, guid);
    
    if (guid == "CLEAR") then
        -- Clear GUID
        aura_env.players[name] = nil;
    else
        aura_env.players[name] = guid;
    end
    aura_env.fillGUIDs();
    aura_env.lastTick = nil; 
end

