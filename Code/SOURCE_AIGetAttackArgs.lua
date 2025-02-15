function AIGetAttackArgs(context, action, target_spot_group, aim_type, override_target)
    local upos = GetPackedPosAndStance(context.unit)
    local target = override_target or context.dest_target[upos]
    local args = {target = target, target_spot_group = target_spot_group or "Torso"}

    local dest_ap
    ----
    local dest_pos
    ---
    if context.ai_destination then
        local u_x, u_y, u_z = stance_pos_unpack(upos)
        local dest_x, dest_y, dest_z = stance_pos_unpack(context.ai_destination)

        if point(u_x, u_y, u_z) ~= point(dest_x, dest_y, dest_z) then
            dest_ap = context.dest_ap[context.ai_destination]
        end
        ---
        dest_pos = point(dest_x, dest_y, dest_z)
        ---
    end

    local unit_ap = dest_ap or context.unit:GetUIActionPoints()
    ----
    local unit_pos = dest_pos or context.unit:GetPos()

    ------------------
    if unit_pos and target then
        local dist = unit_pos:Dist(target)
        if dist <= const.Weapons.PointBlankRange * const.SlabSizeX then
            aim_type = aim_type ~= "None" and "Remaining AP" or aim_type
        end
    end
    local min_aim, max_aim = context.unit:GetBaseAimLevelRange(action, false)

    ------------------

    if action.id == "Overwatch" then
        local attacks, aim = context.unit:GetOverwatchAttacksAndAim(action, args, unit_ap)
        args.num_attacks = attacks
        args.aim_ap = aim
        ----
    elseif action.id == "PinDown" then
        args.aim = max_aim
        -----
    elseif aim_type ~= "None" then
        -- args.aim = context.weapon.MaxAimActions
        ---------
        --------TODO: Check if Shooting Stance is correctly being considered

        args.aim = max_aim
        --------
        -- if aim_type == "Remaining AP" then
        -- while args.aim > 0 and not context.unit:HasAP(action:GetAPCost(context.unit, args)) do
        -----
        if aim_type == "Remaining AP" then
            ----
            while args.aim > min_aim and
                ---
                not context.unit:HasAP(action:GetAPCost(context.unit, args)) do
                args.aim = args.aim - 1
            end
        end
    end

    local cost = action:GetAPCost(context.unit, args)
    local has_ap = cost >= 0 and (unit_ap >= cost)

    return args, has_ap, target
end
