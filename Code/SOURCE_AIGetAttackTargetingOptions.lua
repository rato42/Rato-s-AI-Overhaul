function AIGetAttackTargetingOptions(unit, context, target, action, targeting)
    local body_parts
    targeting = targeting or context.archetype.BaseAttackTargeting

    if IsKindOf(target, "Unit") and targeting then
        action = action or context.default_attack
        ---
        local args = {target = target, aim = 3}
        ---
        local parts = target:GetBodyParts(context.weapon)
        local valid, fallback
        for _, part in ipairs(parts) do
            args.target_spot_group = part.id
            local results = action:GetActionResults(unit, args)
            body_parts = body_parts or {}
            results.chance_to_hit = results.chance_to_hit or 0
            -- table.insert(body_parts, {id = part.id, chance = results.chance_to_hit})
            if results.chance_to_hit > 0 then
                fallback = fallback or {id = part.id, chance = results.chance_to_hit}
                if targeting[part.id] then
                    valid = true
                    -----
                    table.insert(body_parts, {id = part.id, chance = results.chance_to_hit})
                    -----
                end
            end
        end
        if not valid then
            table.insert(body_parts, fallback)
        end
    end
    ----
    return body_parts
    ----
end
