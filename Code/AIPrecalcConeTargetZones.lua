function AIPrecalcConeTargetZones(context, action_id, additional_target_pt, stance)
    if context.target_locked then
        return {}
    end

    local unit = context.unit
    local weapon = context.weapon
    local params = weapon:GetAreaAttackParams(action_id, unit)

    local min_range = params.min_range * const.SlabSizeX
    local max_range = params.max_range * const.SlabSizeX

    local target_pts = AICalcAOETargetPoints(context, min_range, max_range)
    if additional_target_pt then
        target_pts[#target_pts + 1] = additional_target_pt
    end

    -- calc cone areas for each remaining target point
    local zones = {}
    local cone_angle = params.cone_angle
    local targets = {}
    local attack_pos = unit:GetPos() -- make sure we're using the current position in case the unit has moved
    local units = table.copy(context.enemies)
    table.iappend(units, GetAllAlliedUnits(unit))
    local unit_sight = unit:GetSightRadius()

    for zi, pt in ipairs(target_pts) do
        local dir = pt - attack_pos
        if dir:Len() > 0 then
            local target_pos = (attack_pos + SetLen(dir, max_range)):SetTerrainZ()
            local zone = {target_pos = target_pos, units = {}}
            zones[#zones + 1] = zone

            local angle = CalcOrientation(attack_pos, pt)
            local los_any, los_targets = CheckLOS(units, unit, unit:GetDist(target_pos), nil,
                                                  cone_angle, angle)
            if los_any then
                for i, target_unit in ipairs(units) do
                    if los_targets[i] and IsValidTarget(target_unit) then
                        zone.units[#zone.units + 1] = target_unit
                        table.insert_unique(targets, target_unit)
                    end
                end
            end
        end
    end

    local check_ally
    if action_id == "Overwatch" then
        local atk_action = context.default_attack
        local aim_type = atk_action.AimType
        local is_aoe = aim_type == "cone" or aim_type == "aoe" or aim_type == "parabola aoe" or
                           aim_type == "line aoe"
        check_ally = not is_aoe
    end

    -- filter LOS targets
    local max_distance = Min(unit_sight, weapon:GetMaxRange())
    local los_any, los_targets = CheckLOS(targets, unit, max_distance)
    if not los_any then
        for _, zone in ipairs(zones) do
            table.iclear(zone.units)
        end
        return zones
    end
    for i = #targets, 1, -1 do
        if not los_any or not los_targets[i] then
            for _, zone in ipairs(zones) do
                table.remove_value(zone.units, targets[i])
            end
            table.remove(targets, i)
        end
    end
    -- check chance to hit
    local targets_attack_data = GetLoFData(unit, targets, {
        obj = unit,
        action_id = context.default_attack.id,
        weapon = weapon,
        stance = unit.stance,
        range = max_distance,
        target_spot_group = "Torso",
        prediction = true
    })
    local action = CombatActions[action_id]
    local args = {target_spot_group = false}

    ----
    if action_id == "Overwatch" or action_id == "MGSetup" then
        args.aim = 1
    end
    ----

    for i, attack_data in ipairs(targets_attack_data) do
        local target = targets[i]
        local chance_to_hit = 0
        if attack_data and not attack_data.stuck then
            for j, hit_info in ipairs(attack_data.lof) do
                if not check_ally or hit_info.ally_hits_count == 0 then
                    args.target_spot_group = hit_info.target_spot_group
                    -- chance_to_hit = unit:CalcChanceToHit(target, action, args, "chance_only")
                    chance_to_hit = unit:CalcChanceToHit(target, action, args)
                    if chance_to_hit > 0 then
                        break
                    end
                end
            end
        end
        if chance_to_hit == 0 then
            for _, zone in ipairs(zones) do
                table.remove_value(zone.units, target)
            end
        end
    end
    return zones
end

function AICalcAOETargetPoints(context, min_range, max_range, max_radius)
    local target_pts = {}
    local unit = context.unit
    local enemies = context.enemies

    -- add enemy positions
    for i, enemy in ipairs(enemies) do
        if VisibilityCheckAll(unit, enemy, nil, const.uvVisible) then
            target_pts[#target_pts + 1] = context.enemy_pos[enemy]
        end
    end

    local num_targets = #target_pts
    -- add midpoints of enemy pairs
    for i = 1, num_targets - 1 do
        for j = i + 1, num_targets do
            local pt = (target_pts[i] + target_pts[j]) / 2
            if not max_radius or pt:Dist(target_pts[i]) <= max_radius then
                target_pts[#target_pts + 1] = pt
            end
        end
    end

    -- add midpoints of enemy triples
    for i = 1, num_targets - 2 do
        for j = i + 1, num_targets - 1 do
            for k = j + 1, num_targets do
                local pt = (target_pts[i] + target_pts[j] + target_pts[k]) / 3
                if not max_radius or pt:Dist(target_pts[i]) <= max_radius then
                    target_pts[#target_pts + 1] = pt
                end
            end
        end
    end

    -- filter out target points not in range
    AIFilterTargetPoints(unit, target_pts, min_range, max_range)

    return target_pts
end
