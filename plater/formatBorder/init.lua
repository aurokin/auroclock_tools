function (modTable)
    --insert code here
    modTable.updateBorder = function(unitFrame)
        if (unitFrame.namePlateUnitGUID == UnitGUID("focus")) then
            -- 8cd5f5
            Plater.SetBorderColor(unitFrame, 0.55, 0.84, 0.96, 1);
        elseif (unitFrame.namePlateUnitGUID == UnitGUID("mouseover")) then
            -- f58cba
            Plater.SetBorderColor(unitFrame, 0.96, 0.55, 0.73, 1);
        elseif (unitFrame.namePlateUnitGUID == UnitGUID("target")) then
            -- Change to White
            Plater.SetBorderColor(unitFrame, 1, 1, 1, 1);
        else
            -- Change to Black
            Plater.SetBorderColor(unitFrame);
        end
    end
end