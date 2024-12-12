function AISelectAction(context, actions, base_weight, dbg_available_actions)
    local available = {}
    local weight = base_weight or 0
    --------- base_weight is from the default attack
    ---- Stored here
    ---context.choose_actions = {{action = false, weight = weight, priority = false}}

    context.action_states = context.action_states or {}

    for _, action in ipairs(actions) do
        context.action_states[action] = {}
        local weight_mod, disable, priority =
            AIGetBias(action.BiasId, context.unit, context, action)
        disable = disable or context.disable_actions[action.BiasId or false]
        if not disable then
            action:PrecalcAction(context, context.action_states[action])
            if action:IsAvailable(context, context.action_states[action]) then
                local action_weight = MulDivRound(action.Weight, weight_mod, 100)
                priority = priority or action.Priority
                if dbg_available_actions then
                    table.insert(dbg_available_actions,
                                 {action = action, weight = action_weight, priority = priority})
                end
                if priority then
                    return action
                end
                available[#available + 1] = action
                available[available] = action_weight
                weight = weight + action_weight
            elseif dbg_available_actions then
                table.insert(dbg_available_actions, {action = action, weight = false})
            end
        end
    end

    if weight > 0 then
        local roll = InteractionRand(weight, "AISignatureAction", context.unit)
        for _, action in ipairs(available) do
            local w = available[action]
            if roll <= weight then
                return action
            end
            roll = roll - weight
        end
    end

    return available[#available]
end
