function AISelectAction(context, actions, base_weight, dbg_available_actions)
    local available = {}
    local weight = base_weight or 0
    --------- base_weight is from the default attack
    ---- Stored here
    ---context.choose_actions = {{action = false, weight = weight, priority = false}}

    context.action_states = context.action_states or {}

    for _, action in ipairs(actions) do

        context.action_states[action] = {}
        local weight_mod, disable, priority = AIGetBias(action.BiasId, context.unit)

        --------------------------------------------

        local c_action_weight, custom_disable, action_priority = action:CustomScoring(context)

        -- disable = disable or context.disable_actions[action.BiasId or false] 
        disable = disable or context.disable_actions[action.BiasId or false] or custom_disable
        --------------------------------------------
        ic(action.BiasId, disable)
        if not disable then

            -- if action and action.action_id == "RunAndGun" then
            --     bp()
            -- end
            if action and action.BiasId == "AssaultGrenadeThrow" then
                -- bp()
            end
            action:PrecalcAction(context, context.action_states[action])

            if action:IsAvailable(context, context.action_states[action]) then
                ic(action.action_id)
                --------------------------------------------
                -- local action_weight = MulDivRound(action.Weight, weight_mod, 100)
                local action_weight = MulDivRound(c_action_weight, weight_mod, 100)

                -- priority = priority or action.Priority
                priority = priority or action_priority
                --------------------------------------------

                if dbg_available_actions then
                    table.insert(dbg_available_actions,
                                 {action = action, weight = action_weight, priority = priority})
                end
                if priority then
                    return action
                end
                available[#available + 1] = action
                ----
                available[action] = action_weight
                ---
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
            -- ic(action.action_id, w)
            -- if roll <= weight then
            if roll <= w then

                return action
            end
            -- roll = roll - weight
            roll = roll - w
        end
    end

    return -- available[#available]
end
