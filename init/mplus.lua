-- MPLUS
AuroclockTools.MPlus = {};
local DUNGEON_TABLE = {}; -- Thank you Astral Keys

DUNGEON_TABLE[169] = "Iron Docks"
DUNGEON_TABLE[166] = "Grimrail Depot"
DUNGEON_TABLE[227] = "Lower Karazhan"
DUNGEON_TABLE[234] = "Upper Karazhan"
DUNGEON_TABLE[370] = "Mechagon Workshop"
DUNGEON_TABLE[369] = "Mechagon Junkyard"
DUNGEON_TABLE[391] = "Streets of Wonder"
DUNGEON_TABLE[392] = "So'leah's Gambit"

DUNGEON_TABLE["227F"] = "Return to Karazhan: Lower"
DUNGEON_TABLE["234F"] = "Return to Karazhan: Upper"
DUNGEON_TABLE["370F"] = "Operation: Mechagon - Workshop"
DUNGEON_TABLE["369F"] = "Operation: Mechagon - Junkyard"
DUNGEON_TABLE["391F"] = "Tazavesh: Streets of Wonder"
DUNGEON_TABLE["392F"] = "Tazavesh: So'leah's Gambit"

-- Dragonflight Dungeons

DUNGEON_TABLE[399] = "Ruby Life Pools"
DUNGEON_TABLE[400] = "The Nokhud Offensive"
DUNGEON_TABLE[401] = "The Azure Vault"
DUNGEON_TABLE[402] = "Algeth'ar Academy"
DUNGEON_TABLE[210] = "Court of Stars"
DUNGEON_TABLE[200] = "Halls of Valor"
DUNGEON_TABLE[165] = "Shadowmoon Burial Grounds"
DUNGEON_TABLE[2] = "Temple of the Jade Serpent"

DUNGEON_TABLE["400F"] = "The Nokhud Offensive"
DUNGEON_TABLE["401F"] = "The Azure Vault"
DUNGEON_TABLE["165F"] = "Shadowmoon Burial Grounds"
DUNGEON_TABLE["2F"] = "Temple of the Jade Serpent"

DUNGEON_TABLE[403] = "Uldaman: Legacy of Tyr"
DUNGEON_TABLE[404] = "Neltharus"
DUNGEON_TABLE[405] = "Brackenhide Hollow"
DUNGEON_TABLE[406] = "Halls of Infusion"
DUNGEON_TABLE[438] = "The Vortex Pinnacle"
DUNGEON_TABLE[206] = "Neltharion's Lair"
DUNGEON_TABLE[245] = "Freehold"
DUNGEON_TABLE[251] = "The Underrot"

DUNGEON_TABLE["463F"] = "Dawn of the Infinite: Galakrond's Fall"
DUNGEON_TABLE[463] = "DotI: Galakrond's Fall"
DUNGEON_TABLE["464F"] = "Dawn of the Infinite: Murozond's Rise"
DUNGEON_TABLE[464] = "DotI: Murozond's Rise"
DUNGEON_TABLE[244] = "Atal'Dazar"
DUNGEON_TABLE[248] = "Waycrest Manor"
DUNGEON_TABLE[198] = "Darkheart Thicket"
DUNGEON_TABLE[199] = "Black Rook Hold"
DUNGEON_TABLE[168] = "The Everbloom"
DUNGEON_TABLE[456] = "Throne of the Tides"

AuroclockTools.Data.Dungeons = DUNGEON_TABLE;

AuroclockTools.MPlus.getMapName = function(mapId, full)
    -- Astral Keys
    if not mapId then
        return nil
    end
    return (full and DUNGEON_TABLE[format("%dF", mapId)]) or DUNGEON_TABLE[mapId];
end

AuroclockTools.MPlus.getKeystone = function()
    local mapId = C_MythicPlus.GetOwnedKeystoneChallengeMapID();
    local keystoneLevel = C_MythicPlus.GetOwnedKeystoneLevel();
    if (mapId ~= nil and keystoneLevel ~= nil) then
        local name = AuroclockTools.MPlus.getMapName(mapId, true);
        return mapId, keystoneLevel, name;
    end
    return nil, nil, nil;
end

AuroclockTools.MPlus.createKeyLink = function()
    -- Astral Keys
    local mapId, keystoneLevel, name = AuroclockTools.MPlus.getKeystone();
    if (mapId == nil or keystoneLevel == nil) then
        return nil;
    end
    local mythicKeystoneId = 180653;
    local affix1, affix2, affix3, affix4 = AuroclockTools.MPlus.getAffixes();
    local link = format('|cffa335ee|Hkeystone:%d:%d:%d:%d:%d:%d:%d|h[%s %s (%d)]|h|r', mythicKeystoneId, mapId,
        keystoneLevel, affix1, affix2, affix3, affix4, 'Keystone:', name, keystoneLevel):gsub("|", "\124");

    return link;
end

AuroclockTools.MPlus.getAffixes = function()
    local affixes = C_MythicPlus.GetCurrentAffixes()
    if not affixes or not C_ChallengeMode.GetAffixInfo(1) then -- affixes have not loaded, re-request the info
        C_MythicPlus.RequestMapInfo();
        C_MythicPlus.RequestCurrentAffixes();
        return 0, 0, 0, 0;
    end

    local affix1 = (affixes[1] ~= nil and affixes[1].id) or 0;
    local affix2 = (affixes[2] ~= nil and affixes[2].id) or 0;
    local affix3 = (affixes[3] ~= nil and affixes[3].id) or 0;
    local affix4 = (affixes[4] ~= nil and affixes[4].id) or 0;

    return affix1, affix2, affix3, affix4;
end