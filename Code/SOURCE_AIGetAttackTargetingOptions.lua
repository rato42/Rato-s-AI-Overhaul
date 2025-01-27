function AIGetAttackTargetingOptions(unit, context, target, action, targeting)
    local body_parts
    targeting = targeting or context.archetype.BaseAttackTargeting
    ----
    local valid, fallback = false, {}
    ---
    if IsKindOf(target, "Unit") and targeting then
        action = action or context.default_attack
        ---
        local args = {target = target, aim = 3}
        ---
        local parts = target:GetBodyParts(context.weapon)
        for _, part in ipairs(parts) do
            args.target_spot_group = part.id
            local results = action:GetActionResults(unit, args)
            body_parts = body_parts or {}
            results.chance_to_hit = results.chance_to_hit or 0
            -- table.insert(body_parts, {id = part.id, chance = results.chance_to_hit})
            if results.chance_to_hit > 0 then
                table.insert(fallback, {id = part.id, chance = results.chance_to_hit})
                if targeting[part.id] then
                    valid = true
                    -----
                    table.insert(body_parts, {id = part.id, chance = results.chance_to_hit})
                    -----
                end
            end
        end
    end
    ----
    return valid and body_parts or fallback
    ----
end

