function(e, ...)
    -- CHALLENGE_MODE_COMPLETED, ITEM_CHANGED, GOSSIP_CLOSED, PLAYER_ENTERING_WORLD, CHAT_MSG_PARTY, CHAT_MSG_PARTY_LEADER
    -- #?# /snippets/triggerStart.lua
    
    if (e == "PLAYER_ENTERING_WORLD") then
        aura_env.checkItems = false;
    elseif (e == "CHALLENGE_MODE_COMPLETED") then
        aura_env.checkItems = true;
    elseif ((e == "ITEM_CHANGED" and aura_env.checkItems) or (e == "GOSSIP_CLOSED" and aura_env.isKeystonePanda())) then
        local keystoneInfo = aura_env.getKeystoneInfo();
        if (aura_env.hasKeystoneChanged(keystoneInfo)) then
            aura_env.keystoneInfo = keystoneInfo;
            aura_env.sendKeyInfo();
        end
    elseif (e == "CHAT_MSG_PARTY" or e == "CHAT_MSG_PARTY_LEADER") then
        local text = select(1, ...);
        if (text == "!keys") then
            aura_env.sendKeyInfo(); 
        end
    end
end

