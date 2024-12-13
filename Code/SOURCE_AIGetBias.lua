--[[function AIGetBias(id, unit, context, ai_action)
    ---
    local weight_mod, disable, priority = 100, false, false -- AIGetCustomBiasWeight(id, unit, context, ai_action)
    ---
    if id and id ~= "" then
        local mods = g_AIBiases[id] or empty_table
        if mods[unit] then
            weight_mod = weight_mod + mods[unit].total
            disable = disable or mods[unit].disable
            priority = priority or mods[unit].priority
        end
        if mods[unit.team] then
            weight_mod = weight_mod + mods[unit.team].total
            disable = disable or mods[unit.team].disable
            priority = priority or mods[unit.team].priority
        end
    end

    disable = disable or (weight_mod <= 0)

    return weight_mod, disable, priority
end]] 
