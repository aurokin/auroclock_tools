-- Version Checking
AuroclockTools.Data.RegisteredWAs = {};

AuroclockTools.getVersion = function()
    return AuroclockTools.Constants.Version;
end

AuroclockTools.register = function(id, name, currentVersion, requiredVersion)
    if (AuroclockTools.versionCheck(requiredVersion)) then
        AuroclockTools.Data.RegisteredWAs[id] = {
            ["name"] = name,
            ["currentVersion"] = currentVersion
        };
    end
end

AuroclockTools.registerDelay = function()
    return 0.1;
end

AuroclockTools.versionCheck = function(requiredVersion)
    if (requiredVersion == nil) then
        return false
    end
    local valid = AuroclockTools.getVersion() >= requiredVersion;

    if (not valid) then
        print("One of your WeakAuras does not meet the AuroclockTools version requirement, please update AuroclockTools");
    end

    return valid;
end

AuroclockTools.printRegisteredWAs = function()
    local printed = false;
    for k, v in pairs(AuroclockTools.Data.RegisteredWAs) do
        if (not printed) then
            AuroclockTools.print("Registered WAs");
            printed = true;
        end

        AuroclockTools.print(format("%s: %d", v.name, v.currentVersion));
    end

    if (not printed) then
        AuroclockTools.print("No WAs Registered");
    end
end
