function ShouldMaxAim(context, target_dist) ----- used in AICalcAttacksAndAim

    if not target_dist or not IsKindOf(context.weapon, "Firearm") then
        return false
    end

    local er = context.EffectiveRange
    local pb = const.Weapons.PointBlankRange
    local to_check_range = pb

    if target_dist and (target_dist > to_check_range * const.SlabSizeX) then
        return true
    end
    return false
end

function GetIdealAimLevels(context, target_dist, max_aim, min_aim) ----- used in AICalcAttacksAndAim

    if not target_dist and context.AIisPlayingAttacks then ---- from AIPlayAttacks
        local dest = context.ai_destination or GetPackedPosAndStance(context.unit)
        local target = dest and (context.dest_target or empty_table)[dest]
        target_dist = target and context.dest_target_dist[dest][target]
    end

    if not target_dist or not IsKindOf(context.weapon, "Firearm") then
        return min_aim
    end

    local effective_range = context.EffectiveRange
    local point_blank = const.Weapons.PointBlankRange

    if IsKindOfClasses(context.weapon, "SubmachineGun", "Pistol", "Revolver") then
        effective_range = MulDivRound(context.EffectiveRange, 50, 100)
        point_blank = MulDivRound(const.Weapons.PointBlankRange, 80, 100)
    else
        effective_range = MulDivRound(context.EffectiveRange, 40, 100)
    end

    if (target_dist <= point_blank * const.SlabSizeX) then
        return min_aim
    elseif (target_dist <= effective_range * const.SlabSizeX) then
        return Max(1, min_aim)
    end
    return max_aim
end

