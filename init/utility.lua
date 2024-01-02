-- Utility Functions
AuroclockTools.Utility = {};

AuroclockTools.Utility.getMsgType = function()
    if (UnitInRaid("player") ~= nil) then
        return "RAID";
    elseif (UnitInParty("player")) then
        return "PARTY";
    end

    return nil;
end

AuroclockTools.Utility.removeRealmName = function(name)
    return name:match("^([^-]+)");
end

AuroclockTools.Utility.getNpcIdFromUnit = function(unit, guid)
    if (unit ~= nil and guid == nil) then
        guid = UnitGUID(unit);
    end
    if (type(guid) == "string") then
        local guidTbl = {strsplit("-", guid)}
        if (guidTbl[6] ~= nil) then
            local npcId = tonumber(guidTbl[6]);
            if (npcId ~= nil) then
                return npcId;
            end
        end
    end

    return 0;
end