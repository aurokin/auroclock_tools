function(modTable)
    --insert code here
    local propPriority = {
        [1] = "emphasizedInterrupt",
        [2] = "emphasizedStoppable",
        [3] = "interruptible",
        [4] = "stoppable",
    };
    
    modTable.propPriority = {};
    modTable.propColors = {};
    for k, prop in ipairs(propPriority) do
        local colorName = format("%sColor",  prop);
        if (modTable.config[prop] == true and modTable.config[colorName] ~= nil) then
            tinsert(modTable.propPriority, prop);
            modTable.propColors[prop] = CreateColor(Plater:ParseColors(modTable.config[colorName]));
        end
    end
    
    modTable.formatName = function(unitFrame)
        local maxLevel = 70;
        
        local unit = unitFrame.namePlateUnitToken;
        local name = unitFrame.namePlateUnitName;
        
        local level = maxLevel;
        
        if (UnitExists(unit)) then
            level = UnitLevel(unit); 
        end
        
        if (level == nil) then
            level = maxLevel; 
        end
        
        if (name and level) then
            local shortName = name:gsub('(%S+) ',function(t) return t:sub(1,1)..'.' end);
            local text = shortName;
            local numLevel = tonumber(level);
            if (numLevel ~= nil and numLevel < maxLevel) then
                text = string.format("%s (%d)", shortName, level);
            end
            
            if (AuroclockTools and AuroclockTools.Data.MPlusNpcDb) then
                local npcData = AuroclockTools.Data.MPlusNpcDb[unitFrame.namePlateNpcId];
                if (npcData ~= nil) then
                    for k, v in ipairs(modTable.propPriority) do
                        local color = modTable.propColors[v];
                        if (npcData[v] == true and color ~= nil) then
                            text = color:WrapTextInColorCode(text);
                            break;
                        end
                    end
                end
            end
            
            unitFrame.healthBar.unitName:SetText(text)
        end
    end
end