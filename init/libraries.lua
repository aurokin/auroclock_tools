local ORL = LibStub:GetLibrary("LibOpenRaid-1.0")

if (ORL ~= nil) then
    AuroclockTools.Libs.ORL = ORL;
    -- https://www.curseforge.com/wow/addons/openraid
    -- https://legacy.curseforge.com/wow/addons/openraid/pages/api

    local cbCooldownListUpdate = function(unitId, unitCooldowns, allUnitCooldowns)
        WeakAuras.ScanEvents("ACT_ORL_COOLDOWN_LIST_UPDATE", unitId, unitCooldowns, allUnitCooldowns);
    end

    local cbCooldownUpdate = function(unitId, spellId, cooldownInfo, unitCooldowns, allUnitCooldowns)
        WeakAuras.ScanEvents("ACT_ORL_COOLDOWN_UPDATE", unitId, spellId, cooldownInfo, unitCooldowns, allUnitCooldowns);
    end

    local cbCooldownListWipe = function(allUnitsCooldowns)
        -- Should be nil
        -- WeakAuras.ScanEvents("ACT_ORL_COOLDOWN_LIST_WIPE", allUnitsCooldowns);
    end

    local cbUnitInfoUpdate = function(unitId, unitInfo, allUnitsInfo)
        -- WeakAuras.ScanEvents("ACT_ORL_UNIT_INFO_UPDATE", unitId, unitInfo, allUnitsInfo);
    end

    local cbUnitInfoWipe = function()
        -- No Args
        -- WeakAuras.ScanEvents("ACT_ORL_UNIT_INFO_WIPE", true);
    end

    local cbTalentUpdate = function(unitId, talents, unitInfo, allUnitsInfo)
        -- WeakAuras.ScanEvents("ACT_ORL_UNIT_INFO_WIPE", unitId, talents, unitInfo, allUnitsInfo);
    end

    local orlCbs = {
        ["CooldownListUpdate"] = cbCooldownListUpdate,
        ["CooldownUpdate"] = cbCooldownUpdate,
        ["CooldownListWipe"] = cbCooldownListWipe,
        ["UnitInfoUpdate"] = cbUnitInfoUpdate,
        ["UnitInfoWipe"] = cbUnitInfoWipe,
        ["TalentUpdate"] = cbTalentUpdate,
    };

    for event, fn in pairs(orlCbs) do
        ORL.RegisterCallback(orlCbs, event, event);
    end
end